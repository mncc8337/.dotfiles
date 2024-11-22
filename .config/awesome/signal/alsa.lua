-- signals
--[[
    audio::update get info
    audio::avg average volume in both speaker in %
    audio::mute muted or not

    audio::change_volume (diff), increase/decrease volume by `diff`, depend on sign of `diff`
    audio::toggle_mute, toggle mute
]]--

-- dependency: alsa-utils

local awful  = require("awful")
local gears  = require("gears")

local alsa_channel = "Master"
local interval = 2

local last_avg = nil
local last_mute = nil

local function get_info(stdout)
    stdout = stdout:sub(1, -2)
    local lines = gears.string.split(stdout, "\n")

    local left_v = 0
    local left_m = false
    local right_v = 0
    local right_m = false

    for _, line in ipairs(lines) do
        local v, m = line:match("([%d]+)%%.*%[([%l]*)") -- [vol%] [on/off]
        if line:match("([%d]+)%%.*%[([%l]*)") then
            v = tonumber(v)
            m = (m ~= "on")

            if line:match("Left") then
                left_v = v
                left_m = m
            elseif line:match("Right") then
                right_v = v
                right_m = m
            end
        end
    end

    local muted = (right_m == left_m) and left_m
    local avg = math.floor((left_v + right_v) / 2)

    if muted ~= last_mute then
        awesome.emit_signal("audio::mute", muted)
        last_mute = muted
    end
    if avg ~= last_avg then
        awesome.emit_signal("audio::avg", avg)
        last_avg = avg
    end
end

awesome.connect_signal("audio::update", function()
    awful.spawn.easy_async_with_shell("amixer get " .. alsa_channel, get_info)
end)

awesome.connect_signal("audio::change_volume", function(diff)
    local sign = '+'
    if diff < 0 then sign = '-' end

    awful.spawn("amixer sset " .. alsa_channel .. ' ' .. math.abs(diff) .. '%' .. sign)
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::toggle_mute", function()
    awful.spawn("amixer sset " .. alsa_channel .. " toggle")
    awesome.emit_signal("audio::update")
end)

awesome.emit_signal("audio::update")
local timer = gears.timer {
    timeout = interval,
    single_shot = false, autostart = false,
    callback = function()
        awesome.emit_signal("audio::update")
    end
}

return timer
