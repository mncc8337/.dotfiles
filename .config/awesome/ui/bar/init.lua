local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local make_layoutbox = require(... .. ".layoutbox")
local make_taglist   = require(... .. ".taglist")
local make_tasklist  = require(... .. ".tasklist")

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
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    s.wibar = awful.wibar {
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
                    make_taglist(s),
                },
                -- Middle widget
                {
                    layout = wibox.layout.align.horizontal,
                    spacing_widget,
                    make_tasklist(s),
                    spacing_widget
                },
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.common_margin,
                    widget_container(require("ui.bar.music")),
                    widget_container(require("ui.bar.systray")),
                    widget_container(require("ui.bar.volume")),
                    widget_container(require("ui.bar.clock")),
                    make_layoutbox(s),
                }
            }
        }
    }
end)

