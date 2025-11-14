-- signals
--[[
    CALL
    audio::update, force update and get info

    GET
    audio::sink_avg(val), average sink volume in both speaker in %
    audio::sink_mute(muted), muted or not

    SET
    audio::set_sink_volume(val)
    audio::increase_sink_volume(diff), increase/decrease sink volume by `diff`, depend on sign of `diff`
    audio::toggle_sink_mute, toggle mute
]]--

-- dependency: libpulse

local awful = require("awful")
local gears = require("gears")

local sink = "@DEFAULT_SINK@"
local source = "@DEFAULT_SOURCE"
local interval = 2

local last_sink_avg = nil
local last_sink_mute = false

local function get_volume(stdout)
    stdout = stdout:sub(1, -2)
    local line = gears.string.split(stdout, "\n")[1]

    local left  = line:match("front%-left:%s%d+%s/%s+(%d+)%%")
    local right = line:match("front%-right:%s%d+%s/%s+(%d+)%%")

    local avg = math.floor((left + right) / 2)

    if avg ~= last_sink_avg then
        awesome.emit_signal("audio::sink_avg", avg)
        last_sink_avg = avg
    end
end

local function get_mute(stdout)
    stdout = stdout:sub(1, -2)

    local muted = (stdout == "Mute: yes")

    if muted ~= last_sink_mute then
        awesome.emit_signal("audio::sink_mute", muted)
        last_sink_mute = muted
    end
end

awesome.connect_signal("audio::update", function()
    awful.spawn.easy_async_with_shell("pactl get-sink-volume " .. sink, get_volume)
    awful.spawn.easy_async_with_shell("pactl get-sink-mute " .. sink, get_mute)
end)

awesome.connect_signal("audio::set_sink_volume", function(val)
    awful.spawn("pactl set-sink-volume " .. sink .. " " .. val .. "%")
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::increase_sink_volume", function(diff)
    local sign = '+'
    if diff < 0 then sign = '-' end

    awful.spawn("pactl set-sink-volume " .. sink .. " " .. sign .. math.abs(diff) .. "%")
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::toggle_sink_mute", function()
    awful.spawn("pactl set-sink-mute " .. sink .. " toggle")
    awesome.emit_signal("audio::update")
end)

awesome.emit_signal("audio::update")
gears.timer.start_new(interval, function()
    awesome.emit_signal("audio::update")
    return true
end)
