local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local layoutbox = require(... .. ".layoutbox")
local taglist   = require(... .. ".taglist")
local tasklist  = require(... .. ".tasklist")

local spacing_widget = {
    widget = wibox.container.constraint,
    strategy = "exact",
    width = beautiful.common_margin,
    height = beautiful.common_marign,
    nil
}

local function widget_container(widget)
    return {
        widget = wibox.container.background,
        bg = beautiful.bg[2],
        widget
    }
end

screen.connect_signal("request::desktop_decoration", function(s)
    s.mylayoutbox = layoutbox(s)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    s.mytaglist = taglist(s)
    s.mytasklist = tasklist(s)

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height   = 30,
        widget   = {
            widget = wibox.container.margin,
            margins = beautiful.common_margin,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist,
                },
                -- Middle widget
                {
                    layout = wibox.layout.align.horizontal,
                    spacing_widget,
                    s.mytasklist,
                    spacing_widget
                },
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.common_margin,
                    widget_container(require("ui.bar.music")),
                    wibox.widget.systray(),
                    widget_container(require("ui.bar.volume")),
                    widget_container(require("ui.bar.clock")),
                    s.mylayoutbox,
                }
            }
        }
    }
end)

