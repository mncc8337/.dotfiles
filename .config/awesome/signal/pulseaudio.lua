-- signals
--[[
    GET
    audio::update get info
    audio::avg average volume in both speaker in %
    audio::mute muted or not

    SET
    audio::change_volume(diff), increase/decrease volume by `diff`, depend on sign of `diff`
    audio::toggle_mute, toggle mute
]]--

-- dependency: libpulse

local awful  = require("awful")
local gears  = require("gears")

local sink = "@DEFAULT_SINK@"
local interval = 2

local last_avg = nil
local last_mute = nil

local function get_volume(stdout)
    stdout = stdout:sub(1, -2)
    local line = gears.string.split(stdout, "\n")[1]

    local left  = line:match("front%-left:%s%d+%s/%s+(%d+)%%")
    local right = line:match("front%-right:%s%d+%s/%s+(%d+)%%")

    local avg = math.floor((left + right) / 2)

    if avg ~= last_avg then
        awesome.emit_signal("audio::avg", avg)
        last_avg = avg
    end
end

local function get_mute(stdout)
    stdout = stdout:sub(1, -2)

    local muted = (stdout == "Mute: yes")

    if muted ~= last_mute then
        awesome.emit_signal("audio::mute", muted)
        last_mute = muted
    end
end

awesome.connect_signal("audio::update", function()
    awful.spawn.easy_async_with_shell("pactl get-sink-volume " .. sink, get_volume)
    awful.spawn.easy_async_with_shell("pactl get-sink-mute " .. sink, get_mute)
end)

awesome.connect_signal("audio::change_volume", function(diff)
    local sign = '+'
    if diff < 0 then sign = '-' end

    awful.spawn("pactl set-sink-volume " .. sink .. " " .. sign .. math.abs(diff) .. "%")
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::toggle_mute", function()
    awful.spawn("pactl set-sink-mute " .. sink .. " toggle")
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
