local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local helper = require("helper")

local battery_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 10",
    markup = "N/A"
}
local battery_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = helper.battery_icon.na,
}

awesome.connect_signal("battery::capacity", function(cap, is_charging)
    battery_icon.markup = helper.get_battery_icon(cap, is_charging)
    if cap > -1 then
    battery_widget.markup = cap .. "%"
    else
        battery_widget.markup = "N/A"
        battery_icon.markup = helper.battery_icon.na
    end
end)

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    buttons = { awful.button({ }, 1, function() awesome.emit_signal("controlpanel::toggle") end) },
    {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.common_padding,
        battery_icon, battery_widget
    }
}

