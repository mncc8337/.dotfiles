local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")

client.connect_signal("request::titlebars", function(c)
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c, { size = 20 }).widget = {
        layout = wibox.layout.align.horizontal,
        { -- Left
            layout  = wibox.layout.fixed.horizontal,
            buttons = buttons,
            wibox.widget {
                widget = wibox.container.margin,
                margins = beautiful.common_padding,
                awful.titlebar.widget.iconwidget(c),
            }
        },
        { -- Middle
            layout  = wibox.layout.flex.horizontal,
            buttons = buttons,
            { -- Title
                halign = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            }
        },
        { -- Right
            layout = wibox.layout.fixed.horizontal(),
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c)
        }
    }
end)
