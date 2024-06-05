local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

return function(s)
    return awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        layout = {
            layout = wibox.layout.flex.horizontal,
            spacing = beautiful.common_margin
        },
        widget_template = {
            id     = "background_role",
            widget = wibox.container.background,
            {
                widget  = wibox.container.margin,
                margins = beautiful.common_padding,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.common_padding,
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox
                    }
                }
            }
        }
    }
end
