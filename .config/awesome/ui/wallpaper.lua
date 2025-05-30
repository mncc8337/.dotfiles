local awful = require("awful")
local gears = require("gears")
-- widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")

screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            widget = wibox.widget.imagebox,
            image  = gears.surface.crop_surface {
                surface = gears.surface.load_uncached(beautiful.wallpaper),
                ratio = s.geometry.width/s.geometry.height,
                left = beautiful.wallpaper_crop.left,
                right = beautiful.wallpaper_crop.right,
                top = beautiful.wallpaper_crop.top,
                bottom = beautiful.wallpaper_crop.bottom,
            },
            upscale = false,
            downscale = true,
        }
    }
end)
