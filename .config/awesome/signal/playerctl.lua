-- signals
--[[
    SET
    playerctl::next(player)
    playerctl::prev(player)
    playerctl::play(player)
    playerctl::pause(player)
    playerctl::toggle(player)
    playerctl::set_position(position player)
    playerctl::set_volume(volume, player)
    playerctl::set_loop_status(status, player)
    playerctl::set_shuffle(shuffer, player)
    playerctl::increase_volume(diff, player)

    for getting signals use the playerctl object directly
]]--

-- dependency: playerctl, curl

-- using the lib version will cause awesome to stop if run mpDris2 with Notify option set to true
-- maybe related to https://github.com/BlingCorp/bling/issues/215
-- since i dont use the built-in notification of mpdris2, this can be ignored
local playerctl = require("module.bling.signal.playerctl").lib()

local function get_player(playername)
    if playername == nil then
        return playerctl:get_active_player()
    else
        return playerctl:get_player_of_name(playername)
    end
end

-- add some signals to be used globally

awesome.connect_signal("playerctl::next", function(playername) playerctl:next(get_player(playername)) end)
awesome.connect_signal("playerctl::prev", function(playername) playerctl:previous(get_player(playername)) end)
awesome.connect_signal("playerctl::play", function(playername) playerctl:play(get_player(playername)) end)
awesome.connect_signal("playerctl::pause", function(playername) playerctl:pause(get_player(playername)) end)
awesome.connect_signal("playerctl::toggle", function(playername) playerctl:play_pause(get_player(playername)) end)

awesome.connect_signal("playerctl::set_position", function(position, playername)
    playerctl:set_position(position, get_player(playername))
end)
awesome.connect_signal("playerctl::set_volume", function(volume, playername)
    playerctl:set_volume(volume, get_player(playername))
end)
awesome.connect_signal("playerctl::set_loop_status", function(loop_status, playername)
    playerctl:set_loop_status(loop_status, get_player(playername))
end)
awesome.connect_signal("playerctl::set_shuffle", function(shuffle, playername)
    playerctl:set_shuffle(shuffle, get_player(playername))
end)
awesome.connect_signal("playerctl::increase_volume", function(diff, playername)
    local player = get_player(playername)
    playerctl:set_volume(player.volume + diff, get_player(playername))
end)
