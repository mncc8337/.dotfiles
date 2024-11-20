local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path    = gfs.get_themes_dir()
local wallpaper_path = gfs.get_configuration_dir() .. "theme/wallpaper/"
local icon_path      = gfs.get_configuration_dir() .. "theme/icon/"

local theme = {}

theme.font_type = {
    normal = "Roboto",
    mono   = "Cascadia Code",
    icon   = "Symbols Nerd Font"
}

theme.font = theme.font_type.normal .. " 8"

theme.common_margin  = dpi(5)
theme.common_padding = dpi(3)

theme.bgs = {
    "#282828",
    "#3c3836",
    "#504945",
    "#665c54",
    "#bdae93",
    "#fe8019",
}

theme.fgs = {
    "#bdae93",
    "#d5c4a1",
    "#ebdbb2",
    "#fbf1c7",
}

theme.bg_normal     = theme.bgs[1]
theme.bg_focus      = theme.bgs[4]
theme.bg_urgent     = theme.bgs[6]
theme.bg_systray    = theme.bgs[2]

theme.fg_normal     = theme.fgs[3]
theme.fg_focus      = theme.fgs[4]
theme.fg_urgent     = theme.fgs[4]
theme.fg_minimize   = theme.fgs[1]

theme.useless_gap            = dpi(10)
theme.border_width           = dpi(4)
theme.border_color_normal    = theme.bg_normal
theme.border_color_active    = theme.bg_focus
theme.border_color_marked    = theme.bgs[5]
theme.border_color_urgent    = theme.bgs[6]
theme.border_width_maximized = 0

theme.tasklist_bg_normal   = theme.bgs[3]
theme.tasklist_bg_focus    = theme.bg_focus
theme.tasklist_bg_minimize = theme.bgs[2]

theme.taglist_bg_empty    = theme.bgs[2]
theme.taglist_bg_occupied = theme.bgs[3]
theme.taglist_font        = theme.font_type.mono .. " 8"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = theme.font_type.normal .. " 10"
theme.notification_margin = theme.common_margin
theme.notification_width = dpi(500)
theme.notification_height = dpi(80)
theme.notification_icon_size = theme.notification_height - theme.notification_margin * 2
theme.notification_border_width = dpi(2)
theme.notification_border_color = theme.bg_focus
theme.notification_music_fallback_icon = icon_path .. "music_fallback.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = wallpaper_path.."birbs.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "oomox-gruvbox"

-- bling stuff
theme.playerctl_player = { "mpd", "vlc", "%any", "firefox", "chromium" }
theme.playerctl_update_on_activity = true

return theme

