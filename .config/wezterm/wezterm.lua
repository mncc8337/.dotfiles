local wezterm = require("wezterm")

-- load colorscheme from awesomewm generated file
-- see .config/awesome/theme/init.lua:theme.save_lua_config()
package.path = package.path .. ";/tmp/awesome_theme.lua"
local colorscheme = require("awesome_theme")

local normal_colors = {}
local bright_colors = {}
for i = 1, 8 do
    normal_colors[i] = colorscheme.term.color[i]
end
for i = 1, 8 do
    bright_colors[i] = colorscheme.term.color[i + 8]
end

local config = wezterm.config_builder()

config.default_prog = { "/usr/bin/zsh" }

config.initial_cols = 80
config.initial_rows = 25
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}
-- config.window_background_opacity = 0.8

config.font = wezterm.font {
    family = "CaskaydiaCove Nerd Font Mono",
    weight = "Regular",
    -- style = "Italic",
}
config.font_size = 13

config.enable_tab_bar = false

config.colors = {
    background = colorscheme.term.bg,
    foreground = colorscheme.term.fg,

    cursor_bg = colorscheme.term.cursor_bg,
    cursor_fg = colorscheme.term.cursor_fg,
    cursor_border = colorscheme.term.cursor_border,

    selection_bg = colorscheme.term.selection_bg,
    selection_fg = colorscheme.term.selection_fg,

    ansi = normal_colors,
    brights = bright_colors,
}

return config
