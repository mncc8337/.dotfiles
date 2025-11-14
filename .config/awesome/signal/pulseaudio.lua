-- signals
--[[
    CALL
    audio::update, force update and get info

    GET
    audio::sink_avg(val), average sink volume of both speaker in %
    audio::source_avg(val), average source volume of both mic in %
    audio::sink_mute(muted), muted or not
    audio::source_mute(muted), muted or not

    SET
    audio::set_sink_volume(val)
    audio::set_source_volume(val)
    audio::increase_sink_volume(diff), increase/decrease sink volume by `diff`, depend on sign of `diff`
    audio::increase_source_volume(diff), increase/decrease source volume by `diff`, depend on sign of `diff`
    audio::toggle_sink_mute, toggle mute
    audio::toggle_source_mute, toggle mute
]]--

-- dependency: libpulse

local awful = require("awful")
local gears = require("gears")

local sink = "@DEFAULT_SINK@"
local source = "@DEFAULT_SOURCE@"
local interval = 2

local last_sink_avg = nil
local last_source_avg = nil
local last_sink_mute = false
local last_source_mute = false

local function get_volume(stdout)
    stdout = stdout:sub(1, -2)
    local sink_line = gears.string.split(stdout, "\n")[1]
    local source_line = gears.string.split(stdout, "\n")[3]

    local sink_left  = sink_line:match("front%-left:%s%d+%s/%s+(%d+)%%")
    local sink_right = sink_line:match("front%-right:%s%d+%s/%s+(%d+)%%")

    local source_left  = source_line:match("front%-left:%s%d+%s/%s+(%d+)%%")
    local source_right = source_line:match("front%-right:%s%d+%s/%s+(%d+)%%")

    local sink_avg = math.floor((sink_left + sink_right) / 2)
    local source_avg = math.floor((source_left + source_right) / 2)

    if sink_avg ~= last_sink_avg then
        awesome.emit_signal("audio::sink_avg", sink_avg)
        last_sink_avg = sink_avg
    end

    if source_avg ~= last_source_avg then
        awesome.emit_signal("audio::source_avg", source_avg)
        last_source_avg = source_avg
    end
end

local function get_mute(stdout)
    stdout = stdout:sub(1, -2)
    local line = gears.string.split(stdout, "\n")

    local sink_muted = (line[1] == "Mute: yes")
    local source_muted = (line[2] == "Mute: yes")

    if sink_muted ~= last_sink_mute then
        awesome.emit_signal("audio::sink_mute", sink_muted)
        last_sink_mute = sink_muted
    end

    if source_muted ~= last_source_mute then
        awesome.emit_signal("audio::source_mute", source_muted)
        last_source_mute = source_muted
    end
end

awesome.connect_signal("audio::update", function()
    awful.spawn.easy_async_with_shell(
        "pactl get-sink-volume " .. sink .. " && pactl get-source-volume " .. source,
        get_volume
    )
    awful.spawn.easy_async_with_shell(
        "pactl get-sink-mute " .. sink .. " && pactl get-source-mute " .. source,
        get_mute
    )
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

awesome.connect_signal("audio::set_source_volume", function(val)
    awful.spawn("pactl set-source-volume " .. source .. " " .. val .. "%")
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::increase_source_volume", function(diff)
    local sign = '+'
    if diff < 0 then sign = '-' end

    awful.spawn("pactl set-source-volume " .. source .. " " .. sign .. math.abs(diff) .. "%")
    awesome.emit_signal("audio::update")
end)

awesome.connect_signal("audio::toggle_source_mute", function()
    awful.spawn("pactl set-source-mute " .. source .. " toggle")
    awesome.emit_signal("audio::update")
end)

awesome.emit_signal("audio::update")
gears.timer.start_new(interval, function()
    awesome.emit_signal("audio::update")
    return true
end)
