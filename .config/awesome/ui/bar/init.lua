local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local make_layoutbox = require("ui.bar.layoutbox")
local make_taglist = require("ui.bar..taglist")
local make_tasklist = require("ui.bar..tasklist")

local spacing_widget = {
    widget = wibox.container.constraint,
    strategy = "exact",
    width = beautiful.common_margin,
    height = beautiful.common_marign,
    nil,
}

local function widget_container(widget)
    return {
        widget = wibox.container.background,
        bg = beautiful.bg[2],
        widget
    }
end

screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    s.wibar = awful.wibar {
        position = "left",
        screen = s,
        -- height = beautiful.wibar_height,
        width = beautiful.wibar_width,
        widget = {
            widget = wibox.container.margin,
            margins = {
                top = beautiful.wibar_padding,
                bottom = beautiful.wibar_padding,
                left = beautiful.wibar_padding,
                right = beautiful.wibar_padding,
            },
            {
                layout = wibox.layout.align.vertical,
                -- left widgets
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = beautiful.common_margin,
                    make_layoutbox(s),
                    make_taglist(s),
                    widget_container(require("ui.bar.systray")),
                },
                -- middle widget
                {
                    widget = wibox.container.rotate,
                    direction = "west",
                    {
                        layout = wibox.layout.align.horizontal,
                        spacing_widget,
                        make_tasklist(s),
                        spacing_widget,
                    }
                },
                -- right widgets
                {
                    layout = wibox.layout.fixed.vertical,
                    spacing = beautiful.common_margin,
                    widget_container(require("ui.bar.music")),
                    widget_container(require("ui.bar.volume")),
                    widget_container(require("ui.bar.battery")),
                    widget_container(require("ui.bar.clock")),
                }
            }
        }
    }
end)

