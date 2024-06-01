local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 3,
        }
    }

    -- Set different colors for urgent notifications.
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

naughty.connect_signal("request::display", function(n)
    local notif = naughty.layout.box {
        notification = n,
        widget_template = {
            widget = naughty.container.background,
            id     = "background_role",
            {
                widget  = wibox.container.margin,
                margins = beautiful.notification_margin,
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        layout     = wibox.layout.fixed.horizontal,
                        spacing    = 4,
                        naughty.widget.icon,
                        {
                            widget = wibox.container.background,
                            bg = beautiful.bg_2,
                            {
                                widget = wibox.container.margin,
                                margins = 3,
                                {
                                    layout = wibox.layout.fixed.vertical,
                                    naughty.widget.title,
                                    naughty.widget.message,
                                }
                            }
                        }
                    },
                    {
                        widget = naughty.list.actions,
                        base_layout = wibox.widget {
                            layout = wibox.layout.flex.horizontal,
                            spacing = 3
                        },
                        widget_template = {
                            widget = wibox.container.margin,
                            top = 3,
                            {
                                widget = wibox.container.background,
                                bg = beautiful.bg_2,
                                {
                                    widget = wibox.container.margin,
                                    marigns = 3,
                                    {
                                        widget = wibox.widget.textbox,
                                        id = "text_role",
                                        align = "center"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end)
