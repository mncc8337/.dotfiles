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
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }

    -- Set different colors for urgent notifications.
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

naughty.connect_signal("request::display", function(n)
    local msg_box = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_2,
        {
            widget = wibox.container.margin,
            margins = beautiful.common_padding,
            {
                layout = wibox.layout.fixed.vertical,
                naughty.widget.title,
                naughty.widget.message,
            }
        }
    }

    local img_box = nil
    if n.icon then
        -- find strategy to display icon
        local surf = gears.surface(n.icon)
        local width, height = gears.surface.get_size(surf)

        local ideal_height = nil
        local ideal_width = nil

        -- the current width is current height is beautiful.notification_icon_size
        local current_width = width / height * beautiful.notification_icon_size
        local max_width     = beautiful.notification_width * 3.5/5

        -- if width is too large then set fixed width
        if current_width > max_width then
            ideal_width = max_width
            ideal_height = nil
        else
            -- set fixed height
            ideal_width = nil
            ideal_height = beautiful.notification_icon_size
        end
        -- this strategy will ensure that
        -- the result widget is filled horizontally
        -- while the overall layout is not overflow

        -- using the normal imagebox because naughty.widget.icon only support square image
        img_box = {
            widget = wibox.widget.imagebox,
            image = n.icon,
            forced_width = ideal_width,
            forced_height = ideal_height,
            align = "center",
            valign = "center"
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
                bg = beautiful.bg_2,
                {
                    widget = wibox.container.margin,
                    marigns = beautiful.common_padding,
                    {
                        widget = wibox.widget.textbox,
                        id = "text_role",
                        align = "center"
                    }
                }
            }
        }
    }

    local notif = naughty.layout.box {
        notification = n,
        maximum_width = beautiful.notification_width,
        maximum_height = beautiful.notification_height,
        widget_template = {
            widget = naughty.container.background,
            id     = "background_role",
            {
                widget  = wibox.container.margin,
                margins = beautiful.notification_margin,
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = beautiful.notification_margin,
                        img_box,
                        msg_box
                    },
                    action_list
                }
            }
        }
    }

    -- why replace the built-in events?
    -- awful.title buttons will function if they detect mouse release event on them
    -- notifications are closed when receive mouse press event on them
    -- if you press mouse on a notification which is on top of those buttons
    -- you will unintentionally release mouse on top of the buttons, then the buttons will function,
    -- causing bugs like client close after click of notification, etc...
    -- by destroying notification AFTER releasing mouse, titlebar buttons will not receive the mouse release event,
    -- so they will not work unintentionally
    notif.buttons = {
        awful.button({}, "1", nil, function() n:destroy() end),
        awful.button({}, "3", nil, function() n:destroy() end)
    }
end)
