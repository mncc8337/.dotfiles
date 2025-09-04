-- automatically show a volume panel when volume properties changed

local wibox = require("wibox")
local awful = require("awful")
local timer = require("gears").timer
local beautiful = require("beautiful")
local helper = require("helper")

local brightness_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = helper.light_icon.na,
    forced_width = helper.dpi(15),
}

local brightness_slider = wibox.widget {
    widget = wibox.widget.slider,
    maximum = 100,
    minimum = 0,
    value = 75,
    forced_height = helper.dpi(5),
}

local brightness = 25

local panel = awful.popup {
    ontop = true,
    visible = false,
    screen = awful.screen.focused(),
    border_width = beautiful.border_width / 2,
    border_color = beautiful.border_color_marked,
    placement = function(d)
        awful.placement.bottom(d, {
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
                brightness_icon, brightness_slider,
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

awesome.connect_signal("backlight::brightness", function(percent)
    if brightness == percent then return end

    brightness = percent
    brightness_icon.markup = helper.get_light_icon(percent)

    brightness_slider.value = percent
end)

awesome.connect_signal("backlight::increase_brightness", function(_)
    if mouse_entered then return end
    panel.visible = true
    close_timer.timeout = 1.5
    close_timer:again()
end)

panel.widget:connect_signal("mouse::enter", function()
    mouse_entered = true
    close_timer:stop()
end)

panel.widget:connect_signal("mouse::leave", function()
    mouse_entered = false
    close_timer.timeout = 2.5
    close_timer:again()
end)

local update_brightness = helper.rate_limited_call(0.1, function()
    awesome.emit_signal("backlight::set_brightness", brightness_slider.value)
end)

brightness_slider:connect_signal("property::value", function()
    if not mouse_entered then return end
    update_brightness.call()
end)

-- brightness_icon:buttons {
--     awful.button({ }, 1, function()
--         awesome.emit_signal("audio::toggle_mute")
--     end)
-- }

return panel.widget
