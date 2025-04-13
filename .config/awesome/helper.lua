local timer = require("gears").timer

local function get_volume_icon(vol, mute)
    if vol == nil or mute then
        return '󰝟'
    end

    if vol <= 25 then
        return '󰕿'
    elseif vol <= 75 then
        return '󰖀'
    else
        return '󰕾'
    end
end

local function rate_limited_call(interval, callback)
    local tm = timer {
        timeout = interval,
        callback = callback,
        single_shot = true,
    }

    local function call()
        if not tm.start then
            tm:start()
        else
            tm:again()
        end
    end

    return {
        call = call,
    }
end

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return {r, g, b}
end

local function rgb_to_hex(rgb)
    return string.format("#%02X%02X%02X", rgb[1], rgb[2], rgb[3])
end

local function color_tint(base_color, tin_color, weight)
    weight = math.min(1.0, weight)
    weight = math.max(0.0, weight)

    local rgb_base = hex_to_rgb(base_color)
    local rgb_tin = hex_to_rgb(tin_color)

    for i = 1, 3 do
        rgb_base[i] = math.floor(rgb_base[i] * rgb_tin[i] / 255 * weight + rgb_base[i] * (1 - weight))
    end

    return rgb_to_hex(rgb_base)
end

return {
    dpi = require("beautiful.xresources").apply_dpi,
    get_volume_icon = get_volume_icon,
    rate_limited_call = rate_limited_call,
    hex_to_rgb = hex_to_rgb,
    rgb_to_hex = rgb_to_hex,
    color_tint = color_tint,
}
