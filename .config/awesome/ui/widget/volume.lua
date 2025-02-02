-- automatically show a volume panel when volume properties changed

local wibox = require("wibox")
local awful = require("awful")
local timer = require("gears").timer
local beautiful = require("beautiful")
local helper = require("helper")

local volume_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = '󰕾',
    forced_width = helper.dpi(14),
}

local volume_slider = wibox.widget {
    widget = wibox.widget.slider,
    maximum = 100,
    minimum = 0,
    value = 75,
    forced_height = helper.dpi(5),
}

local volume = 25
local mute = false

local panel = awful.popup {
    ontop = true,
    visible = false,
    screen = awful.screen.focused(),
    border_width = beautiful.border_width / 2,
    border_color = beautiful.border_color_marked,
    placement = function(d)
        awful.placement.top(d, {
            honor_workarea = true,
            margins = beautiful.useless_gap * 3,
        })
    end,
    widget = {
        widget = wibox.container.margin,
        margins = beautiful.common_padding,
        {
            widget = wibox.container.constraint,
            width = helper.dpi(200),
            strategy = "exact",
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.common_padding,
                volume_icon, volume_slider,
            },
        },
    },
}

local close_timer = timer {
    single_shot = true,
    callback = function()
        panel.visible = false
    end
}

local mouse_entered = false

awesome.connect_signal("audio::avg", function(avg)
    if volume == avg then return end

    volume = avg
    volume_icon.markup = helper.get_volume_icon(avg, mute)

    if avg == nil then avg = 0 end

    volume_slider.value = avg
end)

awesome.connect_signal("audio::mute", function(muted)
    mute = muted
    volume_icon.markup = helper.get_volume_icon(volume, muted)

    if mouse_entered then return end
    panel.visible = true
    close_timer.timeout = 1.5
    close_timer:again()
end)

awesome.connect_signal("audio::increase_volume", function(_)
    if mouse_entered then return end
    panel.visible = true
    close_timer.timeout = 1.5
    close_timer:again()
end)

volume_slider:connect_signal("mouse::enter", function()
    mouse_entered = true
    close_timer:stop()
end)

volume_slider:connect_signal("mouse::leave", function()
    mouse_entered = false
    close_timer.timeout = 2.5
    close_timer:again()
end)

local update_volume = helper.rate_limited_call(0.1, function()
    awesome.emit_signal("audio::set_volume", volume_slider.value)
end)

volume_slider:connect_signal("property::value", function()
    if not mouse_entered then return end
    update_volume.call()
end)

return panel.widget
