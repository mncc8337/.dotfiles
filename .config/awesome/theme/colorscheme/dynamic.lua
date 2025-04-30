local tint = require("helper").color_tint

local base = {
    bg = {
        "#282828",
        "#383838",
        "#505050",
        "#666666",
        "#909090",
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
}

color.tint = function(accent, weight)
    color.accent[1] = accent
    color.accent[2] = tint(base.accent[2], accent, 0.5)

    for i = 1, 5 do
        color.bg[i] = tint(base.bg[i], accent, weight)
    end

    for i = 1, 4 do
        color.fg[i] = tint(base.fg[i], accent, weight)
    end
end

color.set_base = function(base_color)
    base.bg = base_color.bg
    base.fg = base_color.fg
    base.accent = base_color.accent
end

return color
