local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- quick debugging global func
function notify(msg)
    require("naughty").notify {
        message = msg
    }
end

beautiful.init(require("theme"))

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
fileman = "nemo"

modkey = "Mod4"

-- use pulseaudio to exceed the 100% limit
-- you can use either pulseaudio or alsa though
-- but dont use both of them at the same time
require("signals.pulseaudio"):start()

require("config")
require("ui")

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)

-- disable roundcorner and border on maximized clients
local function reconfig_border(c)
    if c.maximized then
        c.border_width = 0
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 0")
    else
        c.border_width = beautiful.border_width
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 1")
    end
end
client.connect_signal("manage", reconfig_border)
client.connect_signal("property::maximized", reconfig_border)
