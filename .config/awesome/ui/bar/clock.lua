local wibox     = require("wibox")
local beautiful = require("beautiful")

local clock = {
    widget = wibox.widget.textclock,
    format = "<b>%H\n%M</b>",
    font = beautiful.font_type.normal .. " 10",
    halign = "center",
}

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    clock
}
