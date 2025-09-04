local helper = {}
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

helper.battery_icon = {
    na = "󱉞",
    discharging = { "󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹" },
    charging = { "󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅" },
}

helper.get_battery_icon = function(cap, charging)
    local idx = math.floor((cap + 5) / 10) + 1
    if charging then return helper.battery_icon.charging[idx] else return helper.battery_icon.discharging[idx] end
end

helper.light_icon = {
    na = "󱧤",
    intensity = { "󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨" },
}

helper.get_light_icon = function(intensity)
    local idx = math.floor((intensity + 5) / 10) + 1
    return helper.light_icon.intensity[idx]
end

return helper
