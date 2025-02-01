local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

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

local colorscheme = require("theme.colorscheme.dynamic")
colorscheme.tint("#dfadff", 0.4)

local theme = require("theme")
theme.set_colorscheme(colorscheme)
beautiful.init(theme.build())

-- TODO: move these to other place
terminal = "alacritty"
fileman = "nemo"
applauncher = "rofi -show drun"
promptrunner = "rofi -show run"
modkey = "Mod4"

require("config")
require("ui")

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
