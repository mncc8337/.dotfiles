local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local gears = require("gears")

naughty.config.defaults.border_width = beautiful.notification_border_width

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }

    -- Set different colors for urgent notifications.
    ruled.notification.append_rule {
        rule = { urgency = 'critical' },
        properties = { bg = beautiful.term.color[2], fg = beautiful.fg_normal }
    }
end)

naughty.connect_signal("request::display", function(n)
    local msg_box = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg[2],
        {
            widget = wibox.container.margin,
            margins = beautiful.common_padding,
            {
                layout = wibox.layout.fixed.vertical,
                {
                    widget = naughty.widget.title,
                    halign = "center",
                },
                {
                    widget = naughty.widget.message,
                    halign = "center",
                    valign = "center",
                }
            }
        }
    }

    local img_box = nil
    if n.icon then
        -- find strategy to display icon
        local surf = gears.surface(n.icon)
        local width, height = gears.surface.get_size(surf)

        local scaled_width = beautiful.notification_maximum_icon_width
        local scaled_height = height / width * scaled_width

        local ideal_height = nil
        local ideal_width = nil

        if scaled_height > beautiful.notification_maximum_icon_height then
            ideal_height = beautiful.notification_maximum_icon_height
            ideal_width = width / height * ideal_height
        else
            ideal_width = scaled_width
            ideal_height = scaled_height
        end

        -- using the normal imagebox because naughty.widget.icon only support square image
        img_box = {
            widget = wibox.container.constraint,
            strategy = "max",
            width = ideal_width,
            height = ideal_height,
            {
                widget = wibox.widget.imagebox,
                image = n.icon,
                resize = true,
                halign = "center",
                valign = "center"
            }
        }
    end

    local action_list = {
        widget = naughty.list.actions,
        base_layout = wibox.widget {
            layout = wibox.layout.flex.horizontal,
            spacing = beautiful.common_padding
        },
        widget_template = {
            widget = wibox.container.margin,
            top = beautiful.common_padding,
            {
                widget = wibox.container.background,
                bg = beautiful.bg[2],
                {
                    widget = wibox.container.margin,
                    margins = beautiful.common_padding,
                    {
                        widget = wibox.container.constraint,
                        strategy = "min",
                        width = beautiful.notification_minimum_action_width,
                        {
                            widget = wibox.widget.textbox,
                            id = "text_role",
                            halign = "center",
                            ellipsize = "none",
                            wrap = "word",
                            justify = true
                        }
                    }
                }
            }
        }
    }

    local notif = naughty.layout.box {
        notification = n,
        widget_template = {
            widget = naughty.container.background,
            id = "background_role",
            {
                widget  = wibox.container.margin,
                margins = beautiful.notification_margin,
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        layout = wibox.layout.align.horizontal,
                        img_box,
                        msg_box,
                        nil,
                    },
                    action_list
                }
            }
        }
    }

    if #n.actions > 0 then
        n.timeout = 0
    end

    local function destroy_notif()
        if #n.actions > 0 then return end
        n:destroy()
    end

    -- why replace the built-in events?
    -- awful.title buttons will toggle if they detect mouse release event on them
    -- notifications are closed when receive mouse press event on them
    -- if you press mouse on a notification which is on top of those buttons
    -- you will unintentionally release mouse on top of the buttons, then the buttons will toggle,
    -- causing bugs like client close after click of notification, etc...
    -- by destroying notification AFTER releasing mouse, titlebar buttons will not receive the mouse release event,
    -- so they will not toggle unexpected
    notif.buttons = {
        awful.button({}, "1", nil, destroy_notif),
        awful.button({}, "3", nil, destroy_notif)
    }
end)
