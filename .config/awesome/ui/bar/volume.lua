local wibox = require("wibox")
local beautiful = require("beautiful")

-- use pulseaudio to exceed the 100% limit
-- you can use either pulseaudio or alsa though
-- but dont use both of them at the same time
require("signal.pulseaudio"):start()

local volume_widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.normal .. " 10",
    markup = "N/A"
}
local volume_icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " 12",
    markup = '󰕾'
}

local volume = 25

local function update_icon(vol)
    if vol == nil then
        volume_icon.markup = '󰝟'
        return
    end

    if vol <= 25 then
        volume_icon.markup = '󰕿'
    elseif vol <= 75 then
        volume_icon.markup = '󰖀'
    else
        volume_icon.markup = '󰕾'
    end
end

awesome.connect_signal("audio::avg", function(avg)
    volume_widget.markup = avg .. '%'
    volume = avg
    update_icon(avg)
end)

awesome.connect_signal("audio::mute", function(muted)
    if muted then
        update_icon(nil)
    else
        update_icon(volume)
    end
end)

return {
    widget = wibox.container.margin,
    margins = beautiful.common_padding,
    {
        layout = wibox.layout.fixed.horizontal,
        spacing = beautiful.common_padding,
        volume_icon, volume_widget
    }
}
