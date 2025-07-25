local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

MODKEY = "Mod4"
ALTKEY = "Mod1"

-- general Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ MODKEY,           }, "s", hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({ MODKEY, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ MODKEY, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ MODKEY,           }, "Return", function() awful.spawn(TERMINAL) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ MODKEY,           }, "w", function() awful.spawn(APPLAUNCHER) end,
              {description = "show app launcher", group = "launcher"}),
    awful.key({ MODKEY,           }, "r", function() awful.spawn(PROMPTRUNNER) end,
              {description = "run prompt", group = "launcher"}),
})

-- tags related keybindings
-- awful.keyboard.append_global_keybindings({
--     awful.key({ MODKEY }, ",",   awful.tag.viewprev,
--               {description = "view previous", group = "tag"}),
--     awful.key({ MODKEY }, ".",  awful.tag.viewnext,
--               {description = "view next", group = "tag"}),
--     awful.key({ MODKEY }, "Escape", awful.tag.history.restore,
--               {description = "go back", group = "tag"}),
-- })

-- focus helated keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ MODKEY,           }, ".",
        function()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ MODKEY,           }, ",",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ MODKEY,           }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- awful.key({ MODKEY, "Control" }, "j", function() awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ MODKEY, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
})

-- layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ MODKEY, "Control" }, ".", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ MODKEY, "Control" }, ",", function() awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ MODKEY }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ MODKEY, "Shift" }, ".", function() awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ MODKEY, "Shift" }, ",", function() awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({ MODKEY }, "k", function() awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ MODKEY }, "j", function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ MODKEY }, "l", function() awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ MODKEY }, "h", function() awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ MODKEY,           }, "space", function() awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ MODKEY, "Shift"   }, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),
    awful.key({ MODKEY, "Control" }, "n",
        function()
          local c = awful.client.restore()
          -- Focus restored client
          if c then
            c:activate { raise = true, context = "key.unminimize" }
          end
        end,
        {description = "restore minimized", group = "client"}),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { MODKEY },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { MODKEY, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { MODKEY, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { MODKEY, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    -- awful.key {
    --     modifiers   = { MODKEY },
    --     keygroup    = "numpad",
    --     description = "select layout directly",
    --     group       = "layout",
    --     on_press    = function(index)
    --         local t = awful.screen.focused().selected_tag
    --         if t then
    --             t.layout = t.layouts[index] or t.layout
    --         end
    --     end,
    -- }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ MODKEY }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ MODKEY }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ MODKEY }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ MODKEY,           }, "x",      function(c) c:kill() end,
                  {description = "close", group = "client"}),
        awful.key({ MODKEY, "Control" }, "space",  awful.client.floating.toggle,
                  {description = "toggle floating", group = "client"}),
        awful.key({ MODKEY, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),
        -- awful.key({ MODKEY,           }, "o",      function(c) c:move_to_screen() end,
        --           {description = "move to screen", group = "client"}),
        awful.key({ MODKEY,           }, "t",      function(c) c.ontop = not c.ontop end,
                  {description = "toggle keep on top", group = "client"}),
        awful.key({ MODKEY,           }, "y",      function(c) c.sticky = not c.sticky end,
                  {description = "toggle sticky", group = "client"}),
        awful.key({ MODKEY,           }, "n",      function(c) c.minimized = true end,
                  {description = "minimize", group = "client"}),
        awful.key({ MODKEY,           }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        -- awful.key({ MODKEY, "Control" }, "m",
        --     function(c)
        --         c.maximized_vertical = not c.maximized_vertical
        --         c:raise()
        --     end ,
        --     {description = "(un)maximize vertically", group = "client"}),
        -- awful.key({ MODKEY, "Shift"   }, "m",
        --     function(c)
        --         c.maximized_horizontal = not c.maximized_horizontal
        --         c:raise()
        --     end ,
        --     {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- media control
awful.keyboard.append_global_keybindings({
    awful.key({ }, "XF86AudioNext", function() awesome.emit_signal("playerctl::next")     end,
              {description = "next song", group = "media"}),
    awful.key({ }, "XF86AudioPrev", function() awesome.emit_signal("playerctl::prev") end,
              {description = "previous song", group = "media"}),
    awful.key({ }, "XF86AudioPlay", function() awesome.emit_signal("playerctl::toggle") end,
              {description = "pause/play song", group = "media"}),
    awful.key({ }, "XF86AudioStop", function() awesome.emit_signal("playerctl::pause") end,
              {description = "pause song", group = "media"}),
})

-- alt media control
awful.keyboard.append_global_keybindings({
    awful.key({ ALTKEY }, "0", function() awesome.emit_signal("playerctl::next")     end,
              {description = "next song", group = "media"}),
    awful.key({ ALTKEY }, "9", function() awesome.emit_signal("playerctl::prev") end,
              {description = "previous song", group = "media"}),
    awful.key({ ALTKEY }, "8", function() awesome.emit_signal("playerctl::toggle") end,
              {description = "pause/play song", group = "media"}),
    -- awful.key({ ALTKEY }, "7", function() awesome.emit_signal("playerctl::pause") end,
    --           {description = "pause song", group = "media"}),
})

-- audio control
awful.keyboard.append_global_keybindings({
    awful.key({ }, "XF86AudioRaiseVolume", function() awesome.emit_signal("audio::increase_volume",  2) end,
              {description = "increase volume", group = "media"}),
    awful.key({ }, "XF86AudioLowerVolume", function() awesome.emit_signal("audio::increase_volume", -2) end,
              {description = "decrease volume", group = "media"}),
    awful.key({ }, "XF86AudioMute",        function() awesome.emit_signal("audio::toggle_mute") end,
              {description = "toggle volume mute", group = "media"}),

    awful.key({ "Shift" }, "XF86AudioRaiseVolume", function() awesome.emit_signal("playerctl::increase_volume",  0.02) end,
              {description = "increase playerctl volume", group = "media"}),
    awful.key({ "Shift" }, "XF86AudioLowerVolume", function() awesome.emit_signal("playerctl::increase_volume", -0.02) end,
              {description = "decrease playerctl volume", group = "media"}),
})

-- alt audio control
awful.keyboard.append_global_keybindings({
    awful.key({ ALTKEY }, "=", function() awesome.emit_signal("audio::increase_volume",  2) end,
              {description = "increase volume", group = "media"}),
    awful.key({ ALTKEY }, "-", function() awesome.emit_signal("audio::increase_volume", -2) end,
              {description = "decrease volume", group = "media"}),
    awful.key({ ALTKEY }, "7",        function() awesome.emit_signal("audio::toggle_mute") end,
              {description = "toggle volume mute", group = "media"}),

    awful.key({ ALTKEY, "Shift" }, "=", function() awesome.emit_signal("playerctl::increase_volume",  0.02) end,
              {description = "increase playerctl volume", group = "media"}),
    awful.key({ ALTKEY, "Shift" }, "-", function() awesome.emit_signal("playerctl::increase_volume", -0.02) end,
              {description = "decrease playerctl volume", group = "media"}),
})

-- screenshot
awful.keyboard.append_global_keybindings({
    awful.key({                 }, "Print", function() awesome.emit_signal("screenshot::full", false) end,
              {description = "print full screen",               group = "media"}),
    awful.key({ MODKEY          }, "Print", function() awesome.emit_signal("screenshot::full", true)  end,
              {description = "print full screen and save",      group = "media"}),
    awful.key({         "Shift" }, "Print", function() awesome.emit_signal("screenshot::area", false) end,
              {description = "print a part of screen",          group = "media"}),
    awful.key({ MODKEY, "Shift" }, "Print", function() awesome.emit_signal("screenshot::area", true)  end,
              {description = "print a part of screen and save", group = "media"}),
})

-- app launching
awful.keyboard.append_global_keybindings({
    awful.key({ MODKEY }, "e", function() awful.spawn(FILEMAN) end,
              {description = "open file manager", group = "launcher"}),
})
