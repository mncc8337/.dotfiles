local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

return function(s)
    local button_size = beautiful.wibar_width - beautiful.wibar_padding * 2
    return awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ MODKEY }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ MODKEY }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        layout   = {
            -- spacing_widget = {
            --     color = "#dddddd",
            --     shape = gears.shape.powerline,
            --     widget = wibox.widget.separator,
            -- },
            layout  = wibox.layout.fixed.vertical,
        },
        widget_template = {
            widget = wibox.container.background,
            id = "background_role",
            forced_width = button_size,
            forced_height = button_size,
            {
                widget = wibox.container.margin,
                margins = beautiful.common_margin,
                {
                    id = "text_role",
                    widget = wibox.widget.textbox,
                    halign = "center",
                }
            }
        }
    }
end
