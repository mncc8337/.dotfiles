local wibox = require("wibox")

return {
    widget = wibox.container.background,
    id     = "background_role",
    {
        widget  = wibox.container.margin,
        margins = 5,
        {
            id     = "text_role",
            widget = wibox.widget.textbox,
        }
    }
}
