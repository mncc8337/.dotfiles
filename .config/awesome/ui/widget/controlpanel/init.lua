--[[
    SET
    controlpanel::show
    controlpanel::hide
    controlpanel::toggle
--]]--

local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helper = require("helper")

local musicwidget = require("ui.widget.controlpanel.music")

local panel = awful.popup {
    ontop = true,
    visible = false,
    screen = awful.screen.focused(),
    border_width = beautiful.border_width / 2,
    border_color = beautiful.border_color_marked,
    placement = function(d)
        awful.placement.top_right(d, {
            honor_workarea = true,
            margins = beautiful.useless_gap,
        })
    end,
    widget = {
        widget = wibox.container.constraint,
        width = helper.dpi(400),
        strategy = "exact",
        {
            widget = wibox.container.margin,
            margins = beautiful.common_margin,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = beautiful.common_padding,
                musicwidget,
                require("ui.widget.volume"),
                require("ui.widget.backlight"),
            },
        },
    },
}

awesome.connect_signal("controlpanel::show", function()
    panel.visible = true
end)

awesome.connect_signal("controlpanel::hide", function()
    panel.visible = false
end)

awesome.connect_signal("controlpanel::toggle", function()
    panel.visible = not panel.visible
end)

return panel.widget
