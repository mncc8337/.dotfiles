local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

-- error handling
-- check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- set up theme 
-- local colorscheme =  require("theme.colorscheme.gruvbox")
local colorscheme = require("theme.colorscheme.dynamic")
-- colorscheme.tint("#dd716f", 0.4)
colorscheme.tint("#cac7ff", 0.9)

local theme = require("theme")
theme.set_colorscheme(colorscheme)
theme.build()
theme.save_lua_config()

-- run this after changing accent of dynamic theme
-- theme.build_gtk_theme()

theme.wallpaper = theme.wallpaper_path .. "manifold_garden.png"
theme.wallpaper_crop = {
    top = 0,
    left = 0,
    bottom = 0,
    right = 0,
}

beautiful.init(theme)

-- global vars
MODKEY = "Mod4"
ALTKEY = "Mod1"
TERMINAL = "wezterm"
FILEMAN = "nemo"
APPLAUNCHER = "rofi -show drun"
PROMPTRUNNER = "rofi -show run"
SETUPDISPLAY = "arandr"
LOCKER = ("i3lock \
    -B 1.2 \
    -k -e \
    --indicator \
    --greeter-text=\"scren locked heh\" \
    --greeter-pos=\"100:100\" \
    --greeter-align 1 \
    --verif-text=\"hmm\" \
    --wrong-text=\"nein\" \
    --noinput-text=\"empty\" \
    --verif-color %s \
    --wrong-color %s \
    --time-color %s \
    --date-color %s \
    --keyhl-color %s \
    --bshl-color %s \
    --inside-color %s \
    --ring-color %s \
    --insidever-color %s \
    --ringver-color %s \
    --insidewrong-color %s \
    --ringwrong-color %s \
"):format(
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.accent[1]:sub(2, -1),
    beautiful.termcolor[2]:sub(2, -1),
    beautiful.fg[4]:sub(2, -1) .. "78",
    beautiful.accent[2]:sub(2, -1),
    beautiful.termcolor[5]:sub(2, -1) .. "78",
    beautiful.termcolor[5]:sub(2, -1),
    beautiful.termcolor[2]:sub(2, -1) .. "78",
    beautiful.termcolor[2]:sub(2, -1)
)

-- xss-lock
awful.spawn("xss-lock -- " .. LOCKER)

-- generate fallback art
local fallback_art_widget = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.fg_normal,
    fg = beautiful.bg_systray,
    wibox.widget {
        widget = wibox.container.margin,
        margins = 50,
        wibox.widget {
            widget = wibox.widget.textbox,
            font = beautiful.font_type.icon .. " normal 128",
            markup = "󰲸",
            halign = "center",
            valign = "center",
        }
    }
}
FALLBACK_ART_IMG = wibox.widget.draw_to_image_surface(fallback_art_widget, 350, 350, nil, nil)

-- declare signal services
require("signal.touchpad")
require("signal.battery")
require("signal.backlight")
require("signal.playerctl")
require("signal.screenshot")
-- use pulseaudio to exceed the 100% volume limit
-- you can use either pulseaudio or alsa though
-- but dont use both of them at the same time
require("signal.pulseaudio")
-- require("signal.alsa")

-- some ideapad specific features
require("signal.ideapad")
awesome.connect_signal("ideapad::current_profile", function(prof)
    naughty.notify {
        message = "current power profile is <b>" .. prof .. "</b>"
    }
end)

require("config")
require("ui")

require("ui.widget.volume")
require("ui.widget.backlight")
require("ui.widget.controlpanel")

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)

-- disable round corner on maximized clients
local function reconfig_border(c)
    if c.maximized then
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 0")
    else
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 1")
    end
end
client.connect_signal("property::maximized", reconfig_border)

-- fix weird position of already maximized clients when spawn
client.connect_signal("request::manage", function(c)
    if c.maximized then
        c.maximized = false
        c.maximized = true
    end
end)
