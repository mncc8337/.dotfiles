local wibox     = require("wibox")
local beautiful = require("beautiful")

local clock = {
    widget = wibox.widget.textclock,
    format = "%a, %b %d | <b>%R</b>",
    font = beautiful.font_type.normal .. " 10"
}

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    clock
}
