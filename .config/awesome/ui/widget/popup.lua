-- indicator popups manager

local wibox = require("wibox")
local awful = require("awful")
local timer = require("gears").timer
local beautiful = require("beautiful")
local helper = require("helper")

local popup_width = helper.dpi(200)

local popups = {}
local popup_stack = 0
local function set_position(panel, idx)
    panel.screen = awful.screen.focused()
    panel.x = (panel.screen.geometry.width - popup_width) / 2
    panel.y = idx * helper.dpi(30) + beautiful.useless_gap * 3 + beautiful.wibar_height
    panel.idx = idx
end
local function find_new_position(panel)
    set_position(panel, popup_stack)
    popup_stack = popup_stack + 1
end

local function popup_maker(
    default_icon,
    value_update_signal,
    value_update_function,
    value_increase_signal,
    value_set_signal,
    icon_change_signal,
    icon_change_function,
    icon_signal
)
    local popup_icon = wibox.widget {
        widget = wibox.widget.textbox,
        font = beautiful.font_type.icon .. " 12",
        markup = default_icon,
        forced_width = helper.dpi(15),
    }

    local popup_slider = wibox.widget {
        widget = wibox.widget.slider,
        maximum = 100,
        minimum = 0,
        value = 75,
        forced_height = helper.dpi(5),
    }

    local panel = awful.popup {
        ontop = true,
        visible = false,
        screen = awful.screen.focused(),
        border_width = beautiful.border_width / 2,
        border_color = beautiful.border_color_marked,
        widget = {
            widget = wibox.container.margin,
            margins = beautiful.common_padding,
            {
                widget = wibox.container.constraint,
                width = popup_width,
                strategy = "exact",
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.common_padding,
                    popup_icon, popup_slider,
                },
            },
        },
    }
    panel.idx = 0

    local mouse_entered = false
    local current_value = nil

    local function panel_open()
        if panel.visible then
            return
        end
        find_new_position(panel)
        panel.visible = true
    end

    local close_timer = timer {
        single_shot = true,
        callback = function()
            panel.visible = false
            popup_stack = popup_stack - 1
            if popup_stack < 0 then
                popup_stack = 0
            end
            -- update position of other popups
            for _, p in ipairs(popups) do
                if p.visible and p.idx >= panel.idx then
                    set_position(p, p.idx - 1)
                end
            end
        end
    }

    awesome.connect_signal(value_update_signal, function(val)
        if val == current_value then return end
        current_value = val

        value_update_function(popup_icon, popup_slider, val)
    end)

    awesome.connect_signal(icon_change_signal, function(val)
        icon_change_function(popup_icon, val)

        if mouse_entered then return end
        panel_open()
        close_timer.timeout = 2.0
        close_timer:again()
    end)

    awesome.connect_signal(value_increase_signal, function(_)
        if mouse_entered then return end
        panel_open()
        close_timer.timeout = 2.5
        close_timer:again()
    end)

    panel.widget:connect_signal("mouse::enter", function()
        mouse_entered = true
        close_timer:stop()
    end)

    panel.widget:connect_signal("mouse::leave", function()
        mouse_entered = false
        close_timer.timeout = 3.5
        close_timer:again()
    end)

    local update_value = helper.rate_limited_call(0.1, function()
        awesome.emit_signal(value_set_signal, popup_slider.value)
    end)

    popup_slider:connect_signal("property::value", function()
        if not mouse_entered then return end
        update_value.call()
    end)

    popup_icon:buttons {
        awful.button({ }, 1, function()
            awesome.emit_signal(icon_signal)
        end)
    }

    table.insert(popups, panel)
    return panel
end

local backlight_popup = popup_maker(
    helper.light_icon.na,
    "backlight::brightness",
    function(p_icon, p_slider, percent)
        p_icon.markup = helper.get_light_icon(percent)
        p_slider.value = percent
    end,
    "backlight::increase_brightness",
    "backlight::set_brightness",
    "",
    function() end,
    ""
)

local sink_mute = nil
local sink_volume = nil
local sink_volume_popup = popup_maker(
    '󰕾',
    "audio::sink_avg",
    function(p_icon, p_slider, volume)
        sink_volume = volume
        p_icon.markup = helper.get_volume_icon(volume, sink_mute)
        p_slider.value = volume
    end,
    "audio::increase_sink_volume",
    "audio::set_sink_volume",
    "audio::sink_mute",
    function(p_icon, muted)
        sink_mute = muted
        p_icon.markup = helper.get_volume_icon(sink_volume, muted)
    end,
    "audio::toggle_sink_mute"
)

local source_volume_popup = popup_maker(
    "󰍬",
    "audio::source_avg",
    function(_, p_slider, volume)
        p_slider.value = volume
    end,
    "audio::increase_source_volume",
    "audio::set_source_volume",
    "audio::source_mute",
    function(p_icon, muted)
        if muted then
            p_icon.markup = "󰍭"
        else
            p_icon.markup = "󰍬"
        end
    end,
    "audio::toggle_source_mute"
)

return {
    backlight = backlight_popup.widget,
    sink_volume = sink_volume_popup.widget,
    source_volume = source_volume_popup.widget,
}
