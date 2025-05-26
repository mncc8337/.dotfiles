local timer = require("gears").timer

local helper = {}

helper.dpi = require("beautiful.xresources").apply_dpi

helper.get_volume_icon = function(vol, mute)
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

helper.rate_limited_call = function(interval, callback)
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

helper.hex_to_rgb = function(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return {r, g, b}
end

helper.rgb_to_hex = function(rgb)
    return string.format("#%02X%02X%02X", rgb[1], rgb[2], rgb[3])
end

helper.color_tint = function(base_color, tin_color, weight)
    weight = math.min(1.0, weight)
    weight = math.max(0.0, weight)

    local rgb_base = helper.hex_to_rgb(base_color)
    local rgb_tin = helper.hex_to_rgb(tin_color)

    for i = 1, 3 do
        rgb_base[i] = math.floor(rgb_base[i] * rgb_tin[i] / 255 * weight + rgb_base[i] * (1 - weight))
    end

    return helper.rgb_to_hex(rgb_base)
end

helper.color_brightness = function(base_color, weight)
    weight = math.abs(weight)
    local rgb_base = helper.hex_to_rgb(base_color)
    for i = 1, 3 do
        rgb_base[i] = rgb_base[i] * weight
        rgb_base[i] = math.min(255.0, rgb_base[i])
        rgb_base[i] = math.max(0.0, rgb_base[i])
        rgb_base[i] = math.floor(rgb_base[i])
    end

    return helper.rgb_to_hex(rgb_base)
end

return helper
