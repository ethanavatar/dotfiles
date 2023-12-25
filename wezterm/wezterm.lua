local wezterm = require('wezterm')
local config = {}

local function is_windows()
    return package.config:sub(1, 1) == '\\'
end

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.hide_tab_bar_if_only_one_tab = true

local home = ''
if is_windows() then
    home = os.getenv('HOMEPATH')
else
    home = os.getenv('HOME')
    config.enable_tab_bar = false
end
local xdg_config_home = home .. '/.config'

local nushell_config_home = xdg_config_home .. '/nushell'
config.default_prog = {
    'nu',
    '--login',
    '--config',
    nushell_config_home .. '/config.nu',
    '--env-config',
    nushell_config_home .. '/env.nu',
}
config.default_cwd = home

config.color_scheme = 'Gruvbox Dark (Gogh)'

local handle = io.popen('fc-list | grep "Comic Code Ligatures"')
local result = handle:read('*a')
handle:close()

if #result > 0 then
    local font = wezterm.font({ -- https://tosche.net/fonts/comic-code
        family = 'Comic Code Ligatures',
        weight = 'DemiBold',
        italic = true,
    })
    config.font = font
    config.font_rules = {
        { intensity = 'Bold', font = font },
        { intensity = 'Half', font = font },
        { intensity = 'Normal', font = font },
    }
else
    config.font = wezterm.font('JetBrains Mono')
end

config.window_background_opacity = 0.85
config.enable_scroll_bar = true

return config
