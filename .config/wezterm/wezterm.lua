local wezterm = require("wezterm")
local mux = wezterm.mux

-- load colorscheme from awesomewm generated file
-- see .config/awesome/theme/init.lua:theme.save_lua_config()
package.path = package.path .. ";/tmp/awesome_theme.lua"
local colorscheme = require("awesome_theme")
local normal_colors = {}
local bright_colors = {}
for i = 1, 8 do
    normal_colors[i] = colorscheme.termcolor[i]
end
for i = 1, 8 do
    bright_colors[i] = colorscheme.termcolor[i + 8]
end

local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
    -- allow wezterm start -- something to affect what we spawn
    -- in our initial window
    local args = {}
    if cmd then
    args = cmd.args
    end
end)

config.default_prog = { "/usr/bin/zsh" }

config.initial_cols = 80
config.initial_rows = 25
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}
config.window_background_opacity = 0.9

config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font_size = 12

config.enable_tab_bar = false

config.colors = {
    foreground = colorscheme.fg[1],
    background = colorscheme.bg[1],

    cursor_bg = colorscheme.fg[2],
    cursor_fg = colorscheme.bg[1],
    cursor_border = colorscheme.fg[4],

    selection_fg = colorscheme.bg[2],
    selection_bg = colorscheme.fg[2],

    ansi = normal_colors,
    brights = bright_colors,
}

return config
