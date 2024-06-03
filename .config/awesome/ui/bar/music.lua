local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
-- using the lib version will cause awesome to stop if run mpdris2-rs without the --no-notification option
-- maybe related to https://github.com/BlingCorp/bling/issues/215
-- since i dont use the built-in notification of mpdris2-rs, this can be ignored
local playerctl = require("module.bling.signal.playerctl").lib()

local music_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 9"
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

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
    -- empty title and artist is considered empty
    if #title == 0 and #artist == 0 then
        turn_off()
        return
    end

    local content = title
    -- artist often omit in some website
    if #artist ~= 0 then
        content = artist .. " - " .. title
    end

    music_icon.markup = "󰝚"
    music_widget.markup = content

    if not new then return end
    local _album = ""
    if #album ~= 0 then
        _album = "\n" .. album
    end

    local image_file = nil
    -- check if file size is larger than 0
    -- if size is 0 then it is garbage
    local potential_img = io.open(album_path)
    if potential_img:seek("end") > 0 then
        image_file = album_path
    end
    potential_img:close()

    naughty.notify {
        title = player_name,
        message = content .. _album,
        icon = image_file
    }
end)
playerctl:connect_signal("no_players", turn_off)

turn_off()

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.common_padding,
        music_icon,
        {
            widget = wibox.container.scroll.horizontal,
            max_size = 200,
            extra_space = 0,
            fps = 15,
            step_function = wibox.container.scroll.step_functions
                            .nonlinear_back_and_forth,
            speed = 30,
            music_widget,
        }
    }
}
