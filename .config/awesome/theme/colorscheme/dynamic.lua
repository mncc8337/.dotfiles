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

    accent = {
        "#ffffff",
        "#dddddd",
    },

    termcolor = {
        "#373b41",
        "#cc6666",
        "#b5bd68",
        "#f0c674",
        "#81a2be",
        "#b294bb",
        "#8abeb7",
        "#c5c8c6",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
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
    accent = {
        "",
        "",
    },

    termcolor = {
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

}

color.tint = function(accent, weight)
    for i = 1, 5 do
        color.bg[i] = tint(base.bg[i], accent, weight)
    end

    for i = 1, 4 do
        color.fg[i] = tint(base.fg[i], accent, weight)
    end

    color.accent[1] = accent
    color.accent[2] = tint(base.accent[2], accent, 0.5)

    for i = 1, 8 do
        color.termcolor[i] = tint(base.termcolor[i], accent, 0.2)
        -- color.termcolor[i] = brightness(base.termcolor[i], 1.1)
    end
    for i = 9, 16 do
        color.termcolor[i] = brightness(base.termcolor[i - 8], 1.1)
    end
end

color.set_base = function(base_color)
    base.bg = base_color.bg
    base.fg = base_color.fg
    base.accent = base_color.accent
    base.termcolor = base_color.termcolor
end

return color
