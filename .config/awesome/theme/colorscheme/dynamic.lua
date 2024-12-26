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

local function to_rgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return {r, g, b}
end

local function to_hex(rgb)
    return string.format("#%02X%02X%02X", rgb[1], rgb[2], rgb[3])
end

local function tint(base_color, tin_color, weight)
    weight = math.min(1.0, weight)
    weight = math.max(0.0, weight)

    local rgb_base = to_rgb(base_color)
    local rgb_tin = to_rgb(tin_color)

    for i = 1, 3 do
        rgb_base[i] = math.floor(rgb_base[i] * rgb_tin[i] / 255 * weight + rgb_base[i] * (1 - weight))
    end

    return to_hex(rgb_base)
end

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
    color.accent[2] = tint("#ffffff", accent, 0.5)

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
