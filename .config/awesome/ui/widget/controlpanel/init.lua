--[[
    SET
    controlpanel::show
    controlpanel::hide
    controlpanel::toggle
--]]--

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helper = require("helper")

local musicwidget = require("ui.widget.controlpanel.music")
local batterywidget = require("ui.widget.controlpanel.battery")

local function group(widgets)
    return wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg[2],
        gears.table.join (
            {
                widget = wibox.container.margin,
                margins = beautiful.common_padding,
            },
            widgets
        )
    }
end

local function vertical_group(widgets)
    return gears.table.join(
        {
            layout = wibox.layout.fixed.vertical,
            spacing = beautiful.common_margin,
        },
        widgets
    )
end

-- local function horizontal_group(ratios, widgets)
--     local w = wibox.widget {
--         layout = wibox.layout.ratio.horizontal,
--         spacing = beautiful.common_margin,
--     }
--     for i, rat in ipairs(ratios) do
--         w:insert(i, widgets[i])
--         w:set_ratio(i, rat)
--     end
--     return w
-- end

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
            vertical_group {
                group(musicwidget),
                group {
                    layout = wibox.layout.align.vertical,
                    spacing = beautiful.common_padding,
                    require("ui.widget.popup").sink_volume,
                    require("ui.widget.popup").source_volume,
                },
                group(require("ui.widget.popup").backlight),
                group(batterywidget),
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
