local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local spacing_widget = {
    widget = wibox.container.constraint,
    strategy = "exact",
    width = beautiful.common_margin,
    height = beautiful.common_marign,
    nil
}

local function widget_container(w)
    return {
        widget = wibox.container.background,
        bg = beautiful.bg_2,
        w
    }
end

local myclientlist = awful.menu.client_list { theme = { width = 250 } }

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        widget_template = require("ui.bar.taglist_template")
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        layout = {
            layout = wibox.layout.flex.horizontal,
            spacing = beautiful.common_margin
        },
        widget_template = require("ui.bar.tasklist_template")
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height   = 30,
        widget   = {
            widget = wibox.container.margin,
            margins = beautiful.common_margin,
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist,
                },
                -- Middle widget
                {
                    layout = wibox.layout.align.horizontal,
                    spacing_widget,
                    s.mytasklist,
                    spacing_widget
                },
                { -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.common_margin,
                    widget_container(require("ui.bar.music")),
                    wibox.widget.systray(),
                    widget_container(require("ui.bar.volume")),
                    widget_container(require("ui.bar.clock")),
                    s.mylayoutbox,
                }
            }
        }
    }
end)

