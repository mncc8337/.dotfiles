-- signals
--[[
    playerctl::metadata
    playerctl::position
    playerctl::playing
    playerctl::volume
    playerctl::loop_status
    playerctl::shuffle
    playerctl::exit
    playerctl::no_players

    playerctl::next
    playerctl::prev
    playerctl::play
    playerctl::pause
    playerctl::toggle

    playerctl::set_position
    playerctl::set_volume
    playerctl::set_loop_status
    playerctl::set_shuffle

    playerctl::increase_volume
]]--

-- dependency: playerctl, curl

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

return playerctl
