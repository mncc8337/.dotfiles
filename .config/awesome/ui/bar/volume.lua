local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local helper = require("helper")

local volume_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 10",
    markup = "N/A"
}
local volume_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = '󰕾'
}

local volume = 25
local mute = false

awesome.connect_signal("audio::sink_avg", function(avg)
    volume_widget.markup = avg .. '%'
    volume = avg
    volume_icon.markup = helper.get_volume_icon(avg, mute)
end)

awesome.connect_signal("audio::sink_mute", function(muted)
    mute = muted
    volume_icon.markup = helper.get_volume_icon(volume, mute)
end)

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    buttons = { awful.button({ }, 1, function() awesome.emit_signal("controlpanel::toggle") end) },
    {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.common_padding,
        volume_icon, volume_widget
    }
}
