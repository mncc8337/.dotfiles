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
        callback = callback
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

return {
    dpi = require("beautiful.xresources").apply_dpi,
    get_volume_icon = get_volume_icon,
    rate_limited_call = rate_limited_call,
}
