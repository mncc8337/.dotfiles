local wibox = require("wibox")
local beautiful = require("beautiful")

return {
    id     = "background_role",
    widget = wibox.container.background,
    {
        widget  = wibox.container.margin,
        margins = beautiful.common_padding,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.common_padding,
            {
                id     = "icon_role",
                widget = wibox.widget.imagebox,
            },
            {
                id     = "text_role",
                widget = wibox.widget.textbox
            }
        }
    }
}
