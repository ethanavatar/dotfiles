local function is_windows()
    return package.config:sub(1, 1) == '\\'
end

local function get_home_path()
    return is_windows() and os.getenv('HOMEPATH') or os.getenv('HOME')
end

---- Functions ----

local function find_font(file_name)
    local results = {}
    if is_windows() then
        -- TODO: Find a way to get the font path on Windows
    else
        local search_paths = {
            '/usr/share/fonts',
            '/usr/local/share/fonts',
            os.getenv('HOME') .. '/.local/share/fonts',
        }
        -- TODO: Find a way to list a directory's contents
    end

    return results
end

local function merge_tables(...)
    local result = {}
    for _, t in ipairs({ ... }) do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return result
end

---- Config ----

local wezterm = require('wezterm')
local generated_config = {}

if wezterm.config_builder then
    generated_config = wezterm.config_builder()
end

local home = get_home_path()
local xdg_config_home = home .. '/.config'
local nushell_config_home = xdg_config_home .. '/nushell'

local font = wezterm.font('JetBrains Mono')
if is_windows() then
    font = wezterm.font({ -- https://tosche.net/fonts/comic-code
        family = 'Comic Code Ligatures',
        weight = 'DemiBold',
        italic = true,
    })
end

local default_window_opacity = 0.85
local renderer = 'OpenGL'

local config = {
    default_cwd = home,
    default_prog = {
        'nu',
        '--login',
        '--config',
        nushell_config_home .. '/config.nu',
        '--env-config',
        nushell_config_home .. '/env.nu',
    },
    -- (OpenGL|Software|WebGpu) Right now, WebGpu seems to be the fastest
    -- But it's only available on Windows and macOS by default
    front_end = renderer,
    -- Default: 10
    animation_fps = 10,
    audible_bell = 'Disabled',
    adjust_window_size_when_changing_font_size = false,
    window_background_opacity = default_window_opacity,
    enable_scroll_bar = true,

    -- Disable the tab bar on Linux because
    -- I need to force myself to learn a tiling WM
    enable_tab_bar = is_windows(),
    hide_tab_bar_if_only_one_tab = true,

    color_scheme = 'Gruvbox Dark (Gogh)',
    font = font,
    font_rules = {
        { intensity = 'Bold', font = font },
        { intensity = 'Half', font = font },
        { intensity = 'Normal', font = font },
    },
}

---- Keybindings ----

wezterm.on('toggle-opacity', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local opacity = overrides.window_background_opacity
        or config.window_background_opacity

    if opacity == 1.0 then
        opacity = default_window_opacity
    else
        opacity = 1.0
    end

    window:set_config_overrides({ window_background_opacity = opacity })
end)

local emit = wezterm.action.EmitEvent
config.keys = {
    { key = 'b', mods = 'CTRL', action = emit('toggle-opacity') },
}

---- End Config ----

return merge_tables(config, generated_config)
