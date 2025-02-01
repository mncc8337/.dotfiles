-- signals
--[[
    SET
    playerctl::next(player)
    playerctl::prev(player)
    playerctl::play(player)
    playerctl::pause(player)
    playerctl::toggle(player)
    playerctl::set_position(position player)
    playerctl::set_volume(position, player)
    playerctl::set_loop_status(status, player)
    playerctl::set_shuffle(shuffer, player)
    playerctl::increase_volume(diff, player)

    for getting signals use the playerctl object directly
]]--

-- dependency: playerctl

-- using the lib version will cause awesome to stop if run mpDris2 with Notify option set to true
-- maybe related to https://github.com/BlingCorp/bling/issues/215
-- since i dont use the built-in notification of mpdris2, this can be ignored
local playerctl = require("module.bling.signal.playerctl").lib()

-- add some signals to be used globally

awesome.connect_signal("playerctl::next", function(playername) playerctl:next(playername) end)
awesome.connect_signal("playerctl::prev", function(playername) playerctl:previous(playername) end)
awesome.connect_signal("playerctl::play", function(playername) playerctl:play(playername) end)
awesome.connect_signal("playerctl::pause", function(playername) playerctl:pause(playername) end)
awesome.connect_signal("playerctl::toggle", function(playername) playerctl:play_pause(playername) end)

awesome.connect_signal("playerctl::set_position", function(position, playername)
    playerctl:set_position(position, playername)
end)
awesome.connect_signal("playerctl::set_volume", function(volume, playername)
    playerctl:set_volume(volume, playername)
end)
awesome.connect_signal("playerctl::set_loop_status", function(loop_status, playername)
    playerctl:set_loop_status(loop_status, playername)
end)
awesome.connect_signal("playerctl::set_shuffle", function(shuffle, playername)
    playerctl:set_shuffle(shuffle, playername)
end)
awesome.connect_signal("playerctl::increase_volume", function(diff, playername)
    local player = nil
    if playername == nil then
        player = playerctl:get_active_player()
    else
        player = playerctl:get_player_of_name(playername)
    end

    awesome.emit_signal("playerctl::set_volume", player.volume + diff, player)
end)
