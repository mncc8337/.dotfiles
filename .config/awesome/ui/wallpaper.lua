local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            widget = wibox.container.tile,
            tiled  = false,
            valign = "center",
            halign = "center",
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            }
        }
    }
end)
-- }}}
