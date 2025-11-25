local wibox = require("wibox")
local beautiful = require("beautiful")

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
    status_text.markup = "Battery is " .. stat
end)

return wibox.widget {
    layout = wibox.layout.align.vertical,
    status_text,
    est_text,
}

