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
    context.Branch <- Branch.Unstable;
    context.ConsoleLogLevel <- LogLevel.Debug;

    addGapPlugin(context);
    addBarPlugin(context);
    addFocusBorderPlugin(context);
    addTitleBarPlugin(context);

    let actionMenu = context.AddActionMenu();
    let leader = KeyModifiers.LWin;

    let startTerminal = fun _ -> launch("wezterm.exe");
    context.Keybinds.Subscribe(leader, Keys.Enter, startTerminal);

    context.WorkspaceContainer.CreateWorkspaces("1", "2", "3", "4", "5");
    context.CanMinimizeWindows <- true;

    ()
