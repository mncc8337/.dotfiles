local wezterm = require("wezterm")

local fallback_theme = {
    bg = {
        "#1c1c1c",
        "#282828",
        "#383838",
        "#505050",
        "#666666",
    },
    fg = {
        "#bdbdbd",
        "#d5d5d5",
        "#ebebeb",
        "#fbfbfb",
    },
    accent = "#ffffff",
    urgent = "#cc6666",
    term = {
        color = {
            "#373b41",
            "#cc6666",
            "#b5bd68",
            "#f0c674",
            "#81a2be",
            "#b294bb",
            "#8abeb7",
            "#c5c8c6",
            "#373b41",
            "#cc6666",
            "#b5bd68",
            "#f0c674",
            "#81a2be",
            "#b294bb",
            "#8abeb7",
            "#c5c8c6",
        },
        bg = "#1c1c1c",
        fg = "#c5c8c6",
        cursor_bg = "#d5d5d5",
        cursor_fg = "#1c1c1c",
        cursor_border = "#d5d5d5",
        selection_bg = "#383838",
        selection_fg = "#ffffff",
    }
}

local function load_awesome_theme()
    local file = io.open("/tmp/awesome_theme.json", "r")
    if file then
        local contents = file:read("*a")
        file:close()

        local success, decoded = pcall(wezterm.json_parse, contents)
        if success then
            return decoded
        else
            wezterm.log_error("Failed to parse theme JSON: " .. tostring(decoded))
        end
    end

    return fallback_theme
end

local colorscheme = load_awesome_theme()

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
