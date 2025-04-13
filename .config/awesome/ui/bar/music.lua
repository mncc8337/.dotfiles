local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local playerctl = require("module.bling.signal.playerctl").lib()

local music_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 8",
    ellipsize = "end",
}
local music_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = "󰝚"
}

local function turn_off()
    -- empty text cause spacing issue
    music_widget.markup = "ò<span font=\"sans 6\">w</span>Ó"
    music_icon.markup = "󰝛"
end

playerctl:connect_signal("metadata", function(_, title, artist, _, _, _, player_name)
    -- empty title and artist is considered empty
    if #title == 0 and #artist == 0 then
        turn_off()
        return
    end

    if #title == 0 then
        title = "unknown title"
    end

    if #artist == 0 then
        artist = "unknown artist"
    end

    if player_name == "chromium" or player_name == "firefox" then
        artist = artist:gsub("%s%-%sTopic", "")
    end

    music_icon.markup = "󰝚"
    music_widget.markup = artist .. " - " .. title
end)

playerctl:connect_signal("no_players", turn_off)
turn_off()


return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.common_padding,
        buttons = { awful.button({ }, 1, function() awesome.emit_signal("controlpanel::toggle") end) },
        music_icon,
        {
            widget = wibox.container.constraint,
            width = 200,
            strategy = "max",
            music_widget,
        },
    },
}
