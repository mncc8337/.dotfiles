local wibox     = require("wibox")
local beautiful = require("beautiful")

local date = {
    widget = wibox.widget.textclock,
    format = "%a, %b %d | ",
    font = beautiful.font_type.normal .. " 10",
    halign = "center",
}

local clock = {
    widget = wibox.widget.textclock,
    format = "<b>%H\n%M</b>",
    font = beautiful.font_type.normal .. " 10",
    halign = "center",
}

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    {
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.container.rotate,
            direction = "west",
            date,
        },
        clock
    }
}
