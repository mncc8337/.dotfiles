local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function cell_background(widget)
    return wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg[2],
        widget
    }
end

client.connect_signal("request::titlebars", function(c)
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    local titlebar = awful.titlebar(c, { size = beautiful.titlebar_height })

    titlebar:setup {
        widget = wibox.container.margin,
        bottom = beautiful.common_padding,
        {
            layout = wibox.layout.align.horizontal,
            -- left
            {
                widget = awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
            },
            -- middle
            {
                layout  = wibox.layout.flex.horizontal,
                {
                    widget = wibox.container.margin,
                    left = beautiful.border_width,
                    right = beautiful.border_width,
                    buttons = buttons,
                    -- title
                    cell_background({
                        widget = wibox.container.margin,
                        left = beautiful.common_padding,
                        right = beautiful.common_padding,
                        {
                            halign = "left",
                            widget = awful.titlebar.widget.titlewidget(c)
                        }
                    })
                }
            },
            -- right
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 2,
                cell_background(awful.titlebar.widget.floatingbutton(c)),
                cell_background(awful.titlebar.widget.maximizedbutton(c)),
                cell_background(awful.titlebar.widget.stickybutton(c)),
                cell_background(awful.titlebar.widget.ontopbutton(c)),
                cell_background(awful.titlebar.widget.closebutton(c))
            }
        }
    }

end)

client.connect_signal("property::maximized", function(c)
    if c.maximized then
        awful.titlebar.hide(c)
        -- the height of the client will not change automaticaly after we hide the titlebar
        -- so we need to increase height to fill the gap
        c.height = c.height + beautiful.titlebar_height
    else
        awful.titlebar.show(c)
        c.height = c.height - beautiful.titlebar_height
    end
end)
