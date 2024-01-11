local wezterm = require('wezterm')
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
    '--config',
    nushell_config_home .. '/config.nu',
    '--env-config',
    nushell_config_home .. '/env.nu',
}
config.default_cwd = home

config.color_scheme = 'Gruvbox Dark (Gogh)'

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

local window_opacity = 0.85

config.window_background_opacity = window_opacity
config.enable_scroll_bar = true

wezterm.on('toggle-opacity', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local opacity = overrides.window_background_opacity
        or config.window_background_opacity

    if opacity == 1.0 then
        opacity = window_opacity
    else
        opacity = 1.0
    end

    window:set_config_overrides({ window_background_opacity = opacity })
end)

local emit = wezterm.action.EmitEvent
config.keys = {
    { key = 'b', mods = 'CTRL', action = emit('toggle-opacity') },
}

return config
