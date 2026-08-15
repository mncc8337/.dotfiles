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
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)

-- set up theme
-- local colorscheme = require("theme.colorscheme.dynamic")
-- colorscheme.tint("#dd716f", 0.4)
-- colorscheme.tint("#cac7ff", 0.9)
local colorscheme = require("theme.colorscheme.nord-light")

local theme = require("theme")
theme.set_colorscheme(colorscheme)
theme.build()
theme.save_json_config()

-- run this after changing theme
-- theme.build_gtk_theme()

theme.wallpaper = theme.wallpaper_path .. "Paul_Signac_-_The_Port_of_Rotterdam_-_Google_Art_Project.jpg"
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

-- screen locker command
LOCKER = ([[
    i3lock
        -B 1.2
        -k -e
        --indicator
        --greeter-text="scren locked heh"
        --greeter-pos="100:100"
        --greeter-align 1
        --verif-text="hmm"
        --wrong-text="nein"
        --noinput-text="empty"
        --verif-color %s
        --wrong-color %s
        --time-color %s
        --date-color %s
        --keyhl-color %s
        --bshl-color %s
        --inside-color %s
        --ring-color %s
        --insidever-color %s
        --ringver-color %s
        --insidewrong-color %s
        --ringwrong-color %s
]]):format(
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.bg[1]:sub(2, -1),
    beautiful.accent:sub(2, -1),
    beautiful.term.color[2]:sub(2, -1),
    beautiful.fg[4]:sub(2, -1) .. "78",
    beautiful.accent:sub(2, -1),
    beautiful.term.color[5]:sub(2, -1) .. "78",
    beautiful.term.color[5]:sub(2, -1),
    beautiful.term.color[2]:sub(2, -1) .. "78",
    beautiful.term.color[2]:sub(2, -1)
):gsub("\n%s*", " ")

awful.spawn.with_shell(([[
    killall xidlehook;
    export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')";
    xidlehook
      --not-when-fullscreen
      --not-when-audio
      --timer 300
        'xrandr --output "$PRIMARY_DISPLAY" --brightness .1'
        'xrandr --output "$PRIMARY_DISPLAY" --brightness 1'
      --timer 300
        'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; %s'
        ''
]]):format(LOCKER):gsub("\n%s*", " "))

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
require("signal.pulseaudio")

-- some ideapad specific features
require("signal.ideapad")
awesome.connect_signal("ideapad::current_profile", function(prof)
    naughty.notify {
        message = "current power profile is <b>" .. prof .. "</b>"
    }
end)

awesome.connect_signal("battery::alarm", function()
    naughty.notify {
        title = "system",
        message = "battery level is below healthy limit, please recharge",
        urgency = "critical",
        timeout = 0,
    }
end)

require("config")
require("ui")

require("ui.widget.popup")
require("ui.widget.controlpanel")

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)

-- store/restore geometry of floating clients
client.connect_signal("property::floating", function(c)
    -- this signal is fired before the actual geometry change
    if not c.floating then
        -- save last floating geometry
        c.stored_floating_geometry = {
            x = c.x,
            y = c.y,
            width = c.width,
            height = c.height,
        }
    elseif c.stored_floating_geometry and not c.maximized and not c.fullscreen then
        c.x = c.stored_floating_geometry.x
        c.y = c.stored_floating_geometry.y
        c.width = c.stored_floating_geometry.width
        c.height = c.stored_floating_geometry.height
    end
end)

-- maximized/fullscreen clients fixes
-- idk if the default config has these issue
-- because doing manual positioning is pita

local function geometry_fix_func(c, type)
    local wibar = awful.screen.focused().wibar

    -- c.fullscreen and c.maximized should be mutual exclusive
    if c.fullscreen and c.maximized then
        if wibar.visible then
            -- if wibar is visible then fullscreen will have higher priority than maximize
            -- and the client should revert to maximize state after un-fullscreening
            c.maximized = false

            if type == "fullscreen" then
                -- geometry fixes for fullscreening from maximized state
                c.y = 0
                c.height = c.height + beautiful.wibar_height

                -- save state
                c.previously_maximized = true
            end
        else
            -- if wibar is not visible then fullscreen is the same as maximize
            -- so if only one is activated previously
            -- then activating either of them after that should deactivate both
            c.fullscreen = false
            c.maximized = false
        end
        return
    end

    -- now we are just dealing with either fullscreened or maximized, not both

    if (c.maximized or c.fullscreen) and not c.titlebar_fixed_applied then
        -- hide picom's round corner (also read picom config for full implementation)
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 0", false)

        -- hide titlebar
        -- some fullscreen clients would also have wrong geometry if titlebar is not hidden
        awful.titlebar.hide(c)

        -- the height of the client will not change automaticaly after we hide the titlebar
        -- so we need to increase height to fill the gap
        -- this is not a problem for fullscreening a maximized client (idk why)
        c.height = c.height + beautiful.titlebar_height
        c.titlebar_fixed_applied = true

        -- some applications do not do this so we need to enforce it manually
        c.border_width = 0

        if c.fullscreen then
            c.y = 0
        end
    elseif not c.maximized and not c.fullscreen then
        if c.previously_maximized then
            -- restore previous state
            c.maximized = true
            c.previously_maximized = false
        elseif c.titlebar_fixed_applied then
            -- undo all the thing above
            awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 1", false)
            awful.titlebar.show(c)
            c.height = c.height - beautiful.titlebar_height
            c.titlebar_fixed_applied = false
            c.border_width = beautiful.border_width
        end
    end
end
client.connect_signal("property::maximized", function(c) geometry_fix_func(c, "maximize") end)
client.connect_signal("property::fullscreen", function(c) geometry_fix_func(c, "fullscreen") end)

client.connect_signal("request::manage", function(c)
    -- fix weird position of already maximized/fullscreened clients when spawn
    -- just found out that my weird global placement rules causes this (see config/rules.lua)
    if c.maximized then
        c.maximized = false
        c.maximized = true
    end
    if c.fullscreen then
        c.fullscreen = false
        -- remind that its border exists
        c.border_width = beautiful.border_width
        c.fullscreen = true
    end

    -- save geometry of existed floating clients
    if c.floating then
        local previous_maximized = c.maximized
        local previous_fullscreen = c.fullscreen

        -- turn off maximize/fullscreen to get the real geometry
        if c.maximized then c.maximized = false end
        if c.fullscreen then c.fullscreen = false end

        -- toggle floating to trigger the property::floating signal
        c.floating = false
        c.floating = true

        c.maximized = previous_maximized
        c.fullscreen = previous_fullscreen
    end
end)
