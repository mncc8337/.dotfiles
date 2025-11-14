local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local helper = require("helper")

local playerctl = require("module.bling.signal.playerctl").lib()
local music_status = {
    paused = false,
    shuffle = false,
    loop_playlist = false,
    loop_track = false,
    no_loop = false,
}
local volume_slider_hovering = false
local current_player = ""
local prev_notif

local music_title = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " bold 16",
    markup = "N/A",
}

local music_detail = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 10",
    markup = "",
}

local music_art = wibox.widget {
    widget = wibox.widget.imagebox,
    image = FALLBACK_ART_IMG,
    forced_height = helper.dpi(100),
}

local music_progressbar = wibox.widget {
    widget = wibox.widget.progressbar,
    forced_width = helper.dpi(100),
    forced_height = helper.dpi(14),
    margins = {
        top = 5,
        bottom = 5,
    },
    max_value = 100,
    value = 75,
}

local music_time_elapsed = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " bold 8",
    markup = "N/A",
    valign = "top",
}

local music_time_total = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " bold 8",
    markup = "N/A",
    valign = "top",
}

local music_volume_slider = wibox.widget {
    widget = wibox.widget.slider,
    bar_height = helper.dpi(4),
    forced_width = helper.dpi(1),
    forced_height = helper.dpi(14),
    handle_width = 0,
    maximum = 100,
    minimum = 0,
    value = 75,
}

local music_playbutton = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " normal 14",
    markup = "",
    halign = "center",
    valign = "center",
    forced_width = helper.dpi(15),
}

local music_nextbutton = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " normal 14",
    markup = "󰒭",
    halign = "center",
    valign = "center",
}

local music_prevbutton = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " normal 14",
    markup = "󰒮",
    halign = "center",
    valign = "center",
}


local music_buttons = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = helper.dpi(10),
    music_prevbutton,
    music_playbutton,
    music_nextbutton,
}

local function turn_off()
    music_title.markup = "N/A"
    music_detail.markup = ""
    music_art.image = FALLBACK_ART_IMG
    music_progressbar.value = 0
    music_time_elapsed.markup = "N/A"
    music_time_total.markup = "N/A"
    music_volume_slider.value = 0
    music_playbutton.markup = ""
end

playerctl:connect_signal("metadata", function(_, title, artist, art_path, album, new, player_name)
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

    current_player = player_name

    if player_name == "chromium" or player_name == "firefox" then
        artist = artist:gsub("%s%-%sTopic", "")
    end

    music_title.markup = title
    music_detail.markup = artist

    if #album ~= 0 then
        music_detail.markup = music_detail.markup .. ", <i>" .. album .. "</i>"
    end

    music_playbutton.markup = ""
    local image_file = FALLBACK_ART_IMG or nil
    if #art_path ~= 0 then
        -- check if file size is larger than 0
        -- if the size is 0 then it is garbage
        local potential_img = io.open(art_path)
        if potential_img then
            if potential_img:seek("end") > 0 then
                image_file = art_path
            end
            potential_img:close()
        end
    end

    music_art.image = image_file

    if new then
        local _album = ""
        if #album ~= 0 then
            _album = "\n" .. album
        end

        if prev_notif ~= nil then
            prev_notif:destroy()
        end
        prev_notif = naughty.notification {
            title = player_name,
            message = artist .. " - " .. title .. _album,
            icon = image_file
        }
    end
end)

playerctl:connect_signal("position", function(_, interval, length, player_name)
    if current_player ~= player_name then return end
    if music_status.paused then return end

    local function timeformat(t)
        local decor = ''
        local second = math.floor(t % 60)
        if second < 10 then decor = '0' end
        local minute = math.floor((t - second) / 60)
        return minute .. ':' .. decor .. second
    end

    music_time_total.markup = timeformat(length)
    music_time_elapsed.markup = timeformat(interval)

    music_progressbar.max_value = length
    music_progressbar.value = interval
end)

playerctl:connect_signal("playback_status", function(_, playing)
    music_status.paused = not playing

    if playing then
        music_playbutton.markup = ""
    else
        music_playbutton.markup = ""
    end
end)

playerctl:connect_signal("volume", function(_, volume)
    if volume_slider_hovering then return end
    music_volume_slider.value = volume * 100
end)

playerctl:connect_signal("loop_status", function(_, loop_status)
    if loop_status == "playlist" then
        music_status.loop_playlist = true
        music_status.loop_track = false
        music_status.no_loop = false
    elseif loop_status == "track" then
        music_status.loop_playlist = false
        music_status.loop_track = true
        music_status.no_loop = false
    else
        music_status.loop_playlist = false
        music_status.loop_track = false
        music_status.no_loop = true
    end
end)

playerctl:connect_signal("shuffle", function(_, shuffle)
    music_status.shuffle = shuffle
end)

playerctl:connect_signal("no_players", turn_off)
turn_off()

local update_volume = helper.rate_limited_call(0.1, function()
    awesome.emit_signal("playerctl::set_volume", music_volume_slider.value / 100.0, current_player, "setter")
    return true
end)

music_volume_slider:connect_signal("mouse::enter", function()
    volume_slider_hovering = true
end)

music_volume_slider:connect_signal("mouse::leave", function()
    volume_slider_hovering = false
end)

music_volume_slider:connect_signal("property::value", function()
    if not volume_slider_hovering then return end
    update_volume.call()
end)

music_playbutton:buttons(awful.button({ }, 1, function()
    if music_playbutton.markup == "" then
        music_playbutton.markup = ""
    else
        music_playbutton.markup = ""
    end

    awesome.emit_signal("playerctl::toggle")
end))

music_nextbutton:buttons(awful.button({ }, 1, function()
    awesome.emit_signal("playerctl::next")
end))

music_prevbutton:buttons(awful.button({ }, 1, function()
    awesome.emit_signal("playerctl::prev")
end))

return wibox.widget {
    layout = wibox.layout.align.horizontal,
    {
        widget = wibox.container.margin,
        margins = {
            right = beautiful.common_margin,
        },
        music_art,
    },
    {
        widget = wibox.container.margin,
        right = 5, top = 15,
        {
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.container.scroll.horizontal,
                step_function = wibox.container.scroll.step_functions.linear_increase,
                max_size = 300,
                extra_space = 150,
                speed = 30,
                music_title,
            },
            music_detail,
            music_progressbar,
            {
                layout = wibox.layout.align.horizontal,
                music_time_elapsed,
                wibox.widget {
                    layout = wibox.layout.align.horizontal,
                    expand = "outside",
                    nil, music_buttons, nil,
                },
                music_time_total,
            },
        },
    },
    {
        widget = wibox.container.rotate,
        direction = "east",
        {
            widget = wibox.container.margin,
            right = 10, left = 10,
            music_volume_slider,
        },
    },
}
