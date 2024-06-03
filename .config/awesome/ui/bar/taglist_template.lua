local wibox = require("wibox")
local beautiful = require("beautiful")

return {
    widget = wibox.container.background,
    id     = "background_role",
    {
        widget  = wibox.container.margin,
        margins = beautiful.common_margin,
        {
            id     = "text_role",
            widget = wibox.widget.textbox,
        }
    }
}
