local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local helper = require("helper")

local function time_format(hours)
    local h = math.floor(hours)
    local m = math.floor((hours - h) * 60 + 0.5)

    local formatted = ""

    if h > 0 then
        formatted = formatted .. h .. " hours "
    end
    if m > 0 then
        formatted = formatted .. m .. " minutes "
    end

    return formatted
end

local est_text = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " italic 10",
    markup = "time text",
}

local status_text = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 12",
    markup = "status text",
}

local health_detail = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 10",
    markup = "health text",
}
local cycle_count = 0
local bat_health = 0

awesome.connect_signal("battery::time_before_fully_discharged", function(hours)
    est_text.markup = time_format(hours) .. "remain before fully discharged"
end)
awesome.connect_signal("battery::time_before_fully_charged", function(hours)
    est_text.markup = time_format(hours) .. "remain before fully charged"
end)
awesome.connect_signal("battery::idle", function()
    est_text.markup = "using power directly from the power supply"
end)

awesome.connect_signal("battery::status", function(stat)
    status_text.markup = "Battery " .. stat
end)

awesome.connect_signal("battery::cycle_count", function(cyc)
    cycle_count = cyc
    health_detail.markup = cycle_count .. " cycle, battery health: " .. bat_health .. "%"
end)

awesome.connect_signal("battery::health", function(h)
    bat_health = h
    health_detail.markup = cycle_count .. " cycle, battery health: " .. bat_health .. "%"
end)

require("gears").timer {
    timeout = 1,
    autostart = true, single_shot = true,
    callback = function()
        awesome.emit_signal("battery::get_health")
        awesome.emit_signal("battery::get_cycle_count")
    end
}

return wibox.widget {
    layout = wibox.layout.align.vertical,
    status_text,
    est_text,
    health_detail,
}

