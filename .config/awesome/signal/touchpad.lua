-- signals
--[[
    CALL
    touchpad::toggle
--]]

-- dependency: xorg-xinput

local awful = require("awful")
local naughty = require("naughty")

-- touchpad device name, search using `xinput list`
local device_name = "FTCS0038:00 2808:0106 Touchpad"

local touchpad_active = true

awesome.connect_signal("touchpad::toggle", function()
    if touchpad_active then
        awful.spawn.easy_async("xinput disable \"" .. device_name .. '"', function()
            naughty.notify {
                message = "touchpad is <b>disabled</b>"
            }
        end)
        touchpad_active = false
    else
        awful.spawn.easy_async("xinput enable \"" .. device_name .. '"', function()
            naughty.notify {
                message = "touchpad is <b>enabled</b>"
            }
        end)
        touchpad_active = true
    end
end)
