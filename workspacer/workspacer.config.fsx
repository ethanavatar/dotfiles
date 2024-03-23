#r @"C:\Program Files\workspacer\workspacer.Shared.dll"
#r @"C:\Program Files\workspacer\plugins\workspacer.Gap\workspacer.Gap.dll"
#r @"C:\Program Files\workspacer\plugins\workspacer.Bar\workspacer.Bar.dll"
#r @"C:\Program Files\workspacer\plugins\workspacer.TitleBar\workspacer.TitleBar.dll"
#r @"C:\Program Files\workspacer\plugins\workspacer.ActionMenu\workspacer.ActionMenu.dll"
#r @"C:\Program Files\workspacer\plugins\workspacer.FocusBorder\workspacer.FocusBorder.dll"

open workspacer;
open workspacer.Bar;
open workspacer.Gap;
open workspacer.TitleBar;
open workspacer.ActionMenu;
open workspacer.FocusBorder;

open System.Diagnostics

let launch (command: string) =
    let psi =
        new ProcessStartInfo("cmd", "/c " + command) in
    psi.CreateNoWindow <- true;
    psi.UseShellExecute <- false;
    psi.RedirectStandardOutput <- true;
    let _ = System.Diagnostics.Process.Start(psi) in
    ()
let colorFromHex (hex: string) =
    let map f (a, b, c) = f a, f b, f c in
    let split = hex.[1..2], hex.[3..4], hex.[5..6] in
    let toInt s = System.Convert.ToInt32(s, 16) in
    let r, g, b = map toInt split in
    Color (r, g, b)

let addGapPlugin (context: IConfigContext) =
    let size = 8 in
    let config =
        new GapPluginConfig (size, size, delta = size) in
    let _ = context.AddGap(config) in
    ()

let addBarPlugin (context: IConfigContext) =
    let config
        = new BarPluginConfig (FontName = "JetBrains Mono") in
    let _ = context.AddBar(config) in
    ()

let addFocusBorderPlugin (context: IConfigContext) =
    let color = colorFromHex "#90c182" in
    let config =
        new FocusBorderPluginConfig (BorderColor = color, BorderSize = 6) in
    let _ = context.AddFocusBorder(config) in
    ()

let addTitleBarPlugin (context: IConfigContext) =
    let style =
        new TitleBarStyle (showTitleBar = false, showSizingBorder = false) in
    let config =
        new TitleBarPluginConfig (defaultStyle = style) in
    let _ = context.AddTitleBar(config) in
    ()

let setupContext (context: IConfigContext) =
    let leader = KeyModifiers.LWin in
    let leaderShift =   KeyModifiers.LWin ||| KeyModifiers.Shift in
    let leaderCtrl =    KeyModifiers.LWin ||| KeyModifiers.Control in

    let keys = context.Keybinds in
    let workspaces = context.Workspaces in
    let focused = context.Workspaces.FocusedWorkspace in


    context.Branch <- Branch.Unstable;
    context.ConsoleLogLevel <- LogLevel.Debug;

    context.CanMinimizeWindows <- true;

    addGapPlugin(context);
    addBarPlugin(context);
    addFocusBorderPlugin(context);
    addTitleBarPlugin(context);

    // --- Keybindings ---
    // Based on the layout of https://github.com/shiltemann/cheatsheets/blob/master/awesome-wm.md

    context.Keybinds.UnsubscribeAll();

    // --- Window Manager ---
    keys.Subscribe(leaderCtrl, Keys.R, context.Restart);
    keys.Subscribe(leaderShift, Keys.Q, context.Quit);
    // Mod4 + r - Already the run prompt in Windows
    // Mod4 + x - No lua prompt in windows. Maybe C# REPL would be cool?
    keys.Subscribe(leader, Keys.Enter, fun _ -> launch("wezterm.exe"));
    // Mod4 + w - Open main menu

    // --- Navigation ---
    keys.Subscribe(leader, Keys.J, focused.FocusNextWindow);
    keys.Subscribe(leader, Keys.K, focused.FocusPreviousWindow);
    // Mod4 + u - Focus urgent client
    keys.Subscribe(leader, Keys.Right, workspaces.SwitchToNextWorkspace);
    keys.Subscribe(leader, Keys.Left, workspaces.SwitchToPreviousWorkspace);

    // --- Clients ---
    keys.Subscribe(leaderShift, Keys.C, focused.CloseFocusedWindow);

    // --- Layout ---
    keys.Subscribe(leaderShift, Keys.J, focused.SwapFocusAndNextWindow);
    keys.Subscribe(leaderShift, Keys.K, focused.SwapFocusAndPreviousWindow);


    context.WindowRouter.AddFilter(fun w -> not w.IsFullscreen);
    context.WorkspaceContainer.CreateWorkspaces("1", "2", "3", "4", "5");

    ()
