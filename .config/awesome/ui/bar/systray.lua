local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = require("helper").dpi

local expanded = true

local expand_button = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.icon .. " bold 8",
    markup = "",
    valign = "center",
    halign = "center",
    forced_width = dpi(17),
}

local systray = wibox.widget {
    widget = wibox.widget.systray,
}

local function toggle_expand()
    expanded = not expanded

    systray.visible = expanded

    if expanded then
        expand_button.markup = ""
    else
        expand_button.markup = ""
    end
end

expand_button:buttons {
    awful.button({ }, 1, toggle_expand)
}


return {
    layout = wibox.layout.fixed.horizontal,
    spacing = 0,
    expand_button, systray,
}
