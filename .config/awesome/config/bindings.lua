local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
              {description = "show help", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function() awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "w", function() awful.spawn(applauncher) end,
              {description = "show app launcher", group = "launcher"}),
    awful.key({ modkey,           }, "r", function() awful.spawn(promptrunner) end,
              {description = "run prompt", group = "launcher"}),
})

-- Tags related keybindings
-- awful.keyboard.append_global_keybindings({
--     awful.key({ modkey }, "Left",   awful.tag.viewprev,
--               {description = "view previous", group = "tag"}),
--     awful.key({ modkey }, "Right",  awful.tag.viewnext,
--               {description = "view next", group = "tag"}),
--     awful.key({ modkey }, "Escape", awful.tag.history.restore,
--               {description = "go back", group = "tag"}),
-- })

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Right",
        function()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Left",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    -- awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control" }, "Right", function() awful.client.swap.byidx(1) end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "Left", function() awful.client.swap.byidx(-1) end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey, "Shift" }, "Right", function() awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "Left", function() awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey }, "k", function() awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey }, "j", function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey }, "l", function() awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey }, "h", function() awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({ modkey,           }, "space", function() awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey, "Control" }, "n",
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
        modifiers   = { modkey },
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
        modifiers   = { modkey, "Control" },
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
        modifiers = { modkey, "Shift" },
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
        modifiers   = { modkey, "Control", "Shift" },
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
    --     modifiers   = { modkey },
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
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey,           }, "x",      function(c) c:kill() end,
                  {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
                  {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),
        -- awful.key({ modkey,           }, "o",      function(c) c:move_to_screen() end,
        --           {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function(c) c.ontop = not c.ontop end,
                  {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "y",      function(c) c.sticky = not c.sticky end,
                  {description = "toggle sticky", group = "client"}),
        awful.key({ modkey,           }, "n",      function(c) c.minimized = true end,
                  {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        -- awful.key({ modkey, "Control" }, "m",
        --     function(c)
        --         c.maximized_vertical = not c.maximized_vertical
        --         c:raise()
        --     end ,
        --     {description = "(un)maximize vertically", group = "client"}),
        -- awful.key({ modkey, "Shift"   }, "m",
        --     function(c)
        --         c.maximized_horizontal = not c.maximized_horizontal
        --         c:raise()
        --     end ,
        --     {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- Media control
awful.keyboard.append_global_keybindings({
    awful.key({ }, "XF86AudioNext", function() awesome.emit_signal("playerctl::next")     end,
              {description = "next song", group = "media"}),
    awful.key({ }, "XF86AudioPrev", function() awesome.emit_signal("playerctl::prev") end,
              {description = "previous song", group = "media"}),
    awful.key({ }, "XF86AudioPlay", function() awesome.emit_signal("playerctl::toggle") end,
              {description = "pause/play song", group = "media"}),
    awful.key({ }, "XF86AudioStop", function() awesome.emit_signal("playerctl::pause") end,
              {description = "pause song", group = "media"}),

    awful.key({ "Shift" }, "XF86AudioRaiseVolume", function() awesome.emit_signal("playerctl::increase_volume",  0.02) end,
              {description = "increase playerctl volume", group = "media"}),
    awful.key({ "Shift" }, "XF86AudioLowerVolume", function() awesome.emit_signal("playerctl::increase_volume", -0.02) end,
              {description = "decrease playerctl volume", group = "media"}),
})

-- Audio control
awful.keyboard.append_global_keybindings({
    awful.key({ }, "XF86AudioRaiseVolume", function() awesome.emit_signal("audio::change_volume",  2) end,
              {description = "increase volume", group = "media"}),
    awful.key({ }, "XF86AudioLowerVolume", function() awesome.emit_signal("audio::change_volume", -2) end,
              {description = "decrease volume", group = "media"}),
    awful.key({ }, "XF86AudioMute",        function() awesome.emit_signal("audio::toggle_mute") end,
              {description = "toggle volume mute", group = "media"}),
})

-- Screenshot
awful.keyboard.append_global_keybindings({
    awful.key({               }, "Print", function() awesome.emit_signal("screenshot::full", false) end,
              {description = "print full screen",               group = "media"}),
    awful.key({modkey         }, "Print", function() awesome.emit_signal("screenshot::full", true)  end,
              {description = "print full screen and save",      group = "media"}),
    awful.key({        "Shift"}, "Print", function() awesome.emit_signal("screenshot::area", false) end,
              {description = "print a part of screen",          group = "media"}),
    awful.key({modkey, "Shift"}, "Print", function() awesome.emit_signal("screenshot::area", true)  end,
              {description = "print a part of screen and save", group = "media"}),
})

-- App launching
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "e", function() awful.spawn(fileman) end,
              {description = "open file manager", group = "launcher"}),
})
