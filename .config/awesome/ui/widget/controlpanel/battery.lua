local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local function time_format(hours)
    local h = math.floor(hours)
    local m = math.floor((hours - h) * 60 + 0.5)

    local formatted = ""

    if h > 0 then
        formatted = formatted .. h .. " hours "
    end
    if m > 0 then
        formatted = formatted .. m .. " minutes "
    end

    return formatted
end

local charge_type_to_button_map = {}

local est_text = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " italic 10",
    markup = "no estimated charge/discharge time",
}

local status_text = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 12",
    markup = "Unknown battery state",
}

local button_container = wibox.widget {
    layout = wibox.layout.flex.horizontal,
    spacing = beautiful.common_margin,
}

awesome.connect_signal("battery::time_before_fully_discharged", function(hours)
    est_text.markup = time_format(hours) .. "remain before fully discharged"
end)
awesome.connect_signal("battery::time_before_fully_charged", function(hours)
    est_text.markup = time_format(hours) .. "remain before fully charged"
end)
awesome.connect_signal("battery::idle", function()
    est_text.markup = "using power directly from the power supply"
end)

awesome.connect_signal("battery::status", function(stat, power)
    if power == nil then
        status_text.markup = "Battery is " .. stat
    else
        status_text.markup = "Battery is " .. stat .. " (" .. (power / 1000000) .. "W)"
    end
end)

awesome.connect_signal("battery::charge_types", function(all_charge_types, current_charge_type)
    for _, charge_type in ipairs(all_charge_types) do
        local bg = charge_type == current_charge_type and beautiful.fg[4] or beautiful.bg[5]
        if not charge_type_to_button_map[charge_type] then
            local button = wibox.widget {
                widget = wibox.container.background,
                bg = bg,
                fg = beautiful.bg[1],
                wibox.widget {
                    widget = wibox.container.margin,
                    margins = {
                        top = 0, bottom = 0,
                        left = beautiful.common_padding,
                        right = beautiful.common_padding,
                    },
                    wibox.widget {
                        widget = wibox.widget.textbox,
                        font = beautiful.font_type.normal .. " 10",
                        markup = charge_type,
                        halign = "center",
                    }
                },
            }
            charge_type_to_button_map[charge_type] = button
            button:add_button(awful.button( { }, 1, function()
                awesome.emit_signal("battery::set_current_charge_type", charge_type)
            end
            ))
            button_container:add(button)
        else
            charge_type_to_button_map[charge_type].bg = bg
        end
    end
end)

return wibox.widget {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    wibox.widget {
        layout = wibox.layout.align.vertical,
        status_text,
        est_text,
        wibox.widget {
            layout = wibox.layout.fixed.vertical,
            wibox.widget {
                widget = wibox.container.margin,
                margins = {
                    bottom = beautiful.common_padding,
                },
                wibox.widget {
                    widget = wibox.widget.textbox,
                    font = beautiful.font_type.normal .. " 8",
                    markup = "charge type",
                },
            },
            button_container,
        },
    },
}
