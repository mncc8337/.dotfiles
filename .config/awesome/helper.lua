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

return {
    dpi = require("beautiful.xresources").apply_dpi,
    get_volume_icon = get_volume_icon,
}
