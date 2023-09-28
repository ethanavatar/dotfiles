local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

local home = 'C:/Users/ethan'
local xdg_config_home = home .. '/.config'

local nushell_config_home = xdg_config_home .. '/nushell'
config.default_prog = {
    'nu',
    '--login',
    '--config', nushell_config_home .. '/config.nu',
    '--env-config', nushell_config_home .. '/env.nu',
}
config.default_cwd = home

config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font(
    { -- https://tosche.net/fonts/comic-code
        family = 'Comic Code Ligatures',
        weight = 'DemiBold',
        italic = true,
    }
)

config.window_background_opacity = 0.85
config.enable_scroll_bar = true

return config
