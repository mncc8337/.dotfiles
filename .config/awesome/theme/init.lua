local naughty = require("naughty")
local gears = require("gears")

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")

local theme = {}

theme.themes_path    = gfs.get_themes_dir()
theme.wallpaper_path = os.getenv("DOTFILES") .. "/wallpaper/"

theme.bg = {
    "#282828",
    "#383838",
    "#505050",
    "#666666",
    "#909090",
}

theme.fg = {
    "#bdbdbd",
    "#d5d5d5",
    "#ebebeb",
    "#fbfbfb",
}

theme.accent = {
    "#ffffff",
    "#dddddd",
}

theme.term = {
    color = {
        "#373b41",
        "#cc6666",
        "#b5bd68",
        "#f0c674",
        "#81a2be",
        "#b294bb",
        "#8abeb7",
        "#c5c8c6",
        "#373b41",
        "#cc6666",
        "#b5bd68",
        "#f0c674",
        "#81a2be",
        "#b294bb",
        "#8abeb7",
        "#c5c8c6",
    },
    bg = "#282828",
    fg = "#bdbdbd",
    cursor_bg = "#d5d5d5",
    cursor_fg = "#282828",
    cursor_border = "#fbfbfb",
    selection_bg = "#d5d5d5",
    selection_fg = "#383838",
}

theme.set_colorscheme = function(colorscheme)
    gears.table.crush(theme, colorscheme)
end

theme.font_type = {
    normal = "IBM Plex Sans",
    mono   = "CaskaydiaCove Nerd Font Mono",
    icon   = "CaskaydiaCove Nerd Font Propo"
}

theme.common_margin  = dpi(5)
theme.common_padding = dpi(3)

theme.wibar_height = dpi(30)

theme.titlebar_height = dpi(20)

theme.titlebar_close_button_normal = theme.themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = theme.themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme.themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.themes_path.."default/titlebar/maximized_focus_active.png"

theme.layout_fairh = theme.themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = theme.themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = theme.themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = theme.themes_path.."default/layouts/magnifierw.png"
theme.layout_max = theme.themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = theme.themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = theme.themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = theme.themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = theme.themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = theme.themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = theme.themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = theme.themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = theme.themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = theme.themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = theme.themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = theme.themes_path.."default/layouts/cornersew.png"

theme.icon_theme = "oomox-gruvbox"

-- bling stuff
theme.playerctl_player = { "mpd", "vlc", "%any", "firefox", "chromium" }
theme.playerctl_update_on_activity = true

theme.wallpaper = theme.wallpaper_path .. "birbs.png"
theme.wallpaper_crop = {
    top = 0,
    left = 0,
    bottom = 0,
    right = 0,
}

-- call this when colorscheme changed
theme.build = function()
    theme.font = theme.font_type.normal .. " 8"

    theme.bg_normal     = theme.bg[1]
    theme.bg_focus      = theme.accent[2]
    theme.bg_urgent     = theme.accent[1]
    theme.bg_systray    = theme.bg[2]

    theme.fg_normal     = theme.fg[4]
    theme.fg_focus      = theme.bg[2]
    theme.fg_urgent     = theme.bg[1]
    theme.fg_minimize   = theme.fg[2]

    theme.useless_gap            = dpi(6)
    theme.border_width           = dpi(4)
    theme.border_color_normal    = theme.bg_normal
    theme.border_color_active    = theme.accent[2]
    theme.border_color_marked    = theme.bg[5]
    theme.border_color_urgent    = theme.accent[1]

    theme.tasklist_bg_normal   = theme.bg[3]
    theme.tasklist_bg_focus    = theme.bg_focus
    theme.tasklist_bg_minimize = theme.bg[2]

    theme.taglist_bg_empty    = theme.bg[2]
    theme.taglist_bg_occupied = theme.bg[3]
    theme.taglist_font        = theme.font_type.mono .. " 8"

    theme.slider_handle_width = 0
    theme.slider_bar_height = dpi(10)
    theme.slider_bar_color = theme.bg[3]
    theme.slider_bar_active_color = theme.accent[1]

    theme.progressbar_fg = theme.accent[1]
    theme.progressbar_bg = theme.bg[3]

    -- Variables set for theming notifications:
    -- notification_font
    -- notification_[bg|fg]
    -- notification_[width|height|margin]
    -- notification_[border_color|border_width|shape|opacity]
    theme.notification_font = theme.font_type.normal .. " 10"
    theme.notification_margin = theme.common_margin
    theme.notification_spacing = theme.useless_gap
    theme.notification_width = dpi(500)
    theme.notification_height = dpi(80)
    theme.notification_icon_size = theme.notification_height - theme.notification_margin * 2
    theme.notification_border_width = theme.border_width / 2
    theme.notification_border_color = theme.border_color_marked

    -- Variables set for theming the menu:
    -- menu_[bg|fg]_[normal|focus]
    -- menu_[border_color|border_width]
    theme.menu_submenu_icon = theme.themes_path.."default/submenu.png"
    theme.menu_height = dpi(15)
    theme.menu_width  = dpi(100)

    theme.titlebar_bg_focus = theme.border_color_active
    theme.titlebar_fg_focus = theme.fg_normal
end

theme.build_gtk_theme = function()
    -- pls specify this
    local OOMOX_PAPIRUS_PLUGINS_DIR = "/opt/oomox/plugins/icons_papirus"

    local easy_async_with_shell = require("awful").spawn.easy_async_with_shell

    local theme_notify = naughty.notification {
        title = "theme setter",
        message = "building gtk theme ...",
        timeout = 0,
    }
    local icon_theme_notify = naughty.notification {
        title = "theme setter",
        message = "building gtk icon theme ...",
        timeout = 0,
    }
    -- local ibus_icon_notify = naughty.notification {
    --     title = "theme setter",
    --     message = "setting ibus icon color ...",
    --     timeout = 0,
    -- }

    local build_theme_cmd = ("oomox-cli -o dynamic <(echo -e \"\
            BG=%s\n\
            FG=%s\n\
            HDR_BG=%s\n\
            HDR_FG=%s\n\
            SEL_BG=%s\n\
            SEL_FG=%s\n\
            ACCENT_BG=%s\n\
            TXT_BG=%s\n\
            TXT_FG=%s\n\
            BTN_BG=%s\n\
            BTN_FG=%s\n\
            HDR_BTN_BG=%s\n\
            HDR_BTN_FG=%s\n\
            WM_BORDER_FOCUS=%s\n\
            WM_BORDER_UNFOCUS=%s\n\
            ROUNDNESS=4\n\
            GRADIENT=0.0\n\
            SPACING=3\n\
        \")"):format(
        theme.bg[1]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.accent[1]:sub(2, -1),
        theme.bg[1]:sub(2, -1), -- tuyf
        theme.accent[1]:sub(2, -1),
        theme.bg[3]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.accent[1]:sub(2, -1),
        theme.bg[1]:sub(2, -1)
    )

    local build_icon_theme_cmd = ("mkdir -p ~/.local/share/icons/dynamic && \
        %s/change_color.sh -o dynamic -c %s -d ~/.local/share/icons/dynamic \
    "):format(
        OOMOX_PAPIRUS_PLUGINS_DIR,
        theme.accent[1]:sub(2, -1)
    )

    -- local ibus_icon_cmd = (
    --     "gsettings set org.freedesktop.ibus.panel xkb-icon-rgba '%s'"
    -- ):format(theme.accent[1])

    easy_async_with_shell(build_theme_cmd, function()
        theme_notify:destroy()
        naughty.notification {
            title = "theme setter",
            message = "gtk theme updated, change to theme \"dynamic\" and reload gtk apps to see changes",
            timeout = 0,
        }
    end)

    easy_async_with_shell(build_icon_theme_cmd, function()
        icon_theme_notify:destroy()
        naughty.notification {
            title = "theme setter",
            message = "gtk icon theme updated, change to icon theme \"dynamic\" to see changes",
            timeout = 0,
        }
    end)

    -- easy_async_with_shell(ibus_icon_cmd, function()
    --     ibus_icon_notify:destroy()
    --     naughty.notification {
    --         title = "theme setter",
    --         message = "ibus icon color set",
    --         timeout = 0,
    --     }
    -- end)
end

theme.save_lua_config = function()
    local file = io.open("/tmp/awesome_theme.lua", "w+")
    if not file then
        naughty.notification {
            title = "theme setter",
            message = "failed save theme as lua file. cannot open /tmp/awesome_theme.lua",
            timeout = 0,
            urgency = "critical",
        }
        return
    end

    file:write(("return {\
        bg = {\
            \"%s\",\
            \"%s\",\
            \"%s\",\
            \"%s\",\
            \"%s\",\
        },\
        fg = {\
            \"%s\",\
            \"%s\",\
            \"%s\",\
            \"%s\",\
        },\
        accent = {\
            \"%s\",\
            \"%s\",\
        },\
        term = {\
            color = {\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
                \"%s\",\
            },\
            bg = \"%s\",\
            fg = \"%s\",\
            cursor_bg = \"%s\",\
            cursor_fg = \"%s\",\
            cursor_border = \"%s\",\
            selection_bg = \"%s\",\
            selection_fg = \"%s\",\
        },\
    }"):format(
        theme.bg[1],
        theme.bg[2],
        theme.bg[3],
        theme.bg[4],
        theme.bg[5],

        theme.fg[1],
        theme.fg[2],
        theme.fg[3],
        theme.fg[4],

        theme.accent[1],
        theme.accent[2],

        theme.term.color[1],
        theme.term.color[2],
        theme.term.color[3],
        theme.term.color[4],
        theme.term.color[5],
        theme.term.color[6],
        theme.term.color[7],
        theme.term.color[8],
        theme.term.color[9],
        theme.term.color[10],
        theme.term.color[11],
        theme.term.color[12],
        theme.term.color[13],
        theme.term.color[14],
        theme.term.color[15],
        theme.term.color[16],
        theme.term.bg,
        theme.term.fg,
        theme.term.cursor_bg,
        theme.term.cursor_fg,
        theme.term.cursor_border,
        theme.term.selection_bg,
        theme.term.selection_fg
    ))
    file:close()
end

return theme
