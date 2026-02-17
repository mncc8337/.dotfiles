local helper = require("helper")
local tint = helper.color_tint
local brightness = helper.color_brightness

local base = {
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
        },
    },
}

local color = {
    bg = {
        "",
        "",
        "",
        "",
        "",
    },
    fg = {
        "",
        "",
        "",
        "",
    },

    accent = "",
    urgent = "",

    term = {
        color = {
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
        },
        bg = "",
        fg = "",
        cursor_bg = "",
        cursor_fg = "",
        cursor_border = "",
        selection_bg = "",
        selection_fg = "",
    },

}

color.tint = function(accent, weight)
    color.accent = accent

    for i = 1, 5 do
        color.bg[i] = tint(base.bg[i], accent, weight)
    end

    for i = 1, 4 do
        color.fg[i] = tint(base.fg[i], accent, weight)
    end

    for i = 1, 8 do
        color.term.color[i] = tint(base.term.color[i], accent, 0.2)
        -- color.term.color[i] = brightness(base.term.color[i], 1.1)
    end
    for i = 9, 16 do
        color.term.color[i] = brightness(base.term.color[i - 8], 1.1)
    end

    color.urgent = base.term.color[2]

    color.term.fg = color.fg[1]
    color.term.bg = color.bg[1]

    color.term.cursor_bg = color.fg[2]
    color.term.cursor_fg = color.bg[1]
    color.term.cursor_border = color.fg[4]

    color.term.selection_fg = color.bg[2]
    color.term.selection_bg = color.fg[2]
end

color.tint("#ffffff", 0.0)

return color
