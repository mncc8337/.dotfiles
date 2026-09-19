local awful = require("awful")
local gears = require("gears")
-- widget and layout library
local wibox = require("wibox")
local beautiful = require("beautiful")

screen.connect_signal("request::wallpaper", function(s)
    local wallpaper_width = s.geometry.width - beautiful.wibar_width - beautiful.wallpaper_gap
    local wallpaper_height = s.geometry.height - 2 * beautiful.wallpaper_gap

    awful.wallpaper {
        screen = s,
        widget = {
            widget = wibox.container.background,
            bg = beautiful.bg[1],
            {
                widget = wibox.container.margin,
                margins = {
                    left = beautiful.wibar_width,
                    right = beautiful.wallpaper_gap,
                    top = beautiful.wallpaper_gap,
                    bottom = beautiful.wallpaper_gap,
                },
                {
                    widget = wibox.widget.imagebox,
                    image = gears.surface.crop_surface {
                        surface = gears.surface.load_uncached(beautiful.wallpaper),
                        ratio = wallpaper_width / wallpaper_height,
                        left = beautiful.wallpaper_crop.left,
                        right = beautiful.wallpaper_crop.right,
                        top = beautiful.wallpaper_crop.top,
                        bottom = beautiful.wallpaper_crop.bottom,
                    },
                    upscale = false,
                    downscale = true,
                    clip_shape = function(cr, width, height)
                        gears.shape.rounded_rect(cr, width, height, beautiful.wallpaper_corner_radius)
                    end,
                }
            }
        }
    }
end)
