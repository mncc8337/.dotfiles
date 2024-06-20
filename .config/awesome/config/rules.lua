local awful = require("awful")
local ruled = require("ruled")

local ruled_count = 0.0
local client_in_a_row = 10
local client_offset = 20
local function offset_centered(c)
    -- this function always run 2 times for each client, not sure why. so i only add 0.5
    ruled_count = ruled_count + 0.5
    -- google maths
    local offset = client_offset * ((math.floor(ruled_count) % client_in_a_row) - client_in_a_row/2)

    return awful.placement.centered(c, {
        offset = {
            x = offset,
            y = offset
        }
    })
end

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = offset_centered
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Nsxiv",
                "Nemo",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "file-roller",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)
-- }}}
