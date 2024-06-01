local wibox = require("wibox")

return {
    id     = "background_role",
    widget = wibox.container.background,
    {
        widget  = wibox.container.margin,
        margins = 3,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 3,
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
