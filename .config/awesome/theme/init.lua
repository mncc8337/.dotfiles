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

theme.accent = "#ffffff"
theme.urgent = "#cc6666"

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

local function get_icons(_theme)
    local normal = "normal"
    local focus = "focus"
    if not _theme.darktheme then
        normal = "focus"
        focus = "normal"
    end

    _theme.titlebar_close_button_normal = _theme.themes_path.."default/titlebar/close_" .. normal .. ".png"
    _theme.titlebar_close_button_focus  = _theme.themes_path.."default/titlebar/close_" .. focus .. ".png"

    _theme.titlebar_minimize_button_normal = _theme.themes_path.."default/titlebar/minimize_" .. normal .. ".png"
    _theme.titlebar_minimize_button_focus  = _theme.themes_path.."default/titlebar/minimize_" .. focus .. ".png"

    _theme.titlebar_ontop_button_normal_inactive = _theme.themes_path.."default/titlebar/ontop_" .. normal .. "_inactive.png"
    _theme.titlebar_ontop_button_focus_inactive  = _theme.themes_path.."default/titlebar/ontop_" .. focus .. "_inactive.png"
    _theme.titlebar_ontop_button_normal_active = _theme.themes_path.."default/titlebar/ontop_" .. normal .. "_active.png"
    _theme.titlebar_ontop_button_focus_active  = _theme.themes_path.."default/titlebar/ontop_" .. focus .. "_active.png"

    _theme.titlebar_sticky_button_normal_inactive = _theme.themes_path.."default/titlebar/sticky_" .. normal .. "_inactive.png"
    _theme.titlebar_sticky_button_focus_inactive  = _theme.themes_path.."default/titlebar/sticky_" .. focus .. "_inactive.png"
    _theme.titlebar_sticky_button_normal_active = _theme.themes_path.."default/titlebar/sticky_" .. normal .. "_active.png"
    _theme.titlebar_sticky_button_focus_active  = _theme.themes_path.."default/titlebar/sticky_" .. focus .. "_active.png"

    _theme.titlebar_floating_button_normal_inactive = _theme.themes_path.."default/titlebar/floating_" .. normal .. "_inactive.png"
    _theme.titlebar_floating_button_focus_inactive  = _theme.themes_path.."default/titlebar/floating_" .. focus .. "_inactive.png"
    _theme.titlebar_floating_button_normal_active = _theme.themes_path.."default/titlebar/floating_" .. normal .. "_active.png"
    _theme.titlebar_floating_button_focus_active  = _theme.themes_path.."default/titlebar/floating_" .. focus .. "_active.png"

    _theme.titlebar_maximized_button_normal_inactive = _theme.themes_path.."default/titlebar/maximized_" .. normal .. "_inactive.png"
    _theme.titlebar_maximized_button_focus_inactive  = _theme.themes_path.."default/titlebar/maximized_" .. focus .. "_inactive.png"
    _theme.titlebar_maximized_button_normal_active = _theme.themes_path.."default/titlebar/maximized_" .. normal .. "_active.png"
    _theme.titlebar_maximized_button_focus_active  = _theme.themes_path.."default/titlebar/maximized_" .. focus .. "_active.png"

    local prefix = "w.png"
    if not theme.darktheme then prefix = ".png" end

    _theme.layout_fairh = _theme.themes_path.."default/layouts/fairh" .. prefix
    _theme.layout_fairv = _theme.themes_path.."default/layouts/fairv" .. prefix
    _theme.layout_floating  = _theme.themes_path.."default/layouts/floating" .. prefix
    _theme.layout_magnifier = _theme.themes_path.."default/layouts/magnifier" .. prefix
    _theme.layout_max = _theme.themes_path.."default/layouts/max" .. prefix
    _theme.layout_fullscreen = _theme.themes_path.."default/layouts/fullscreen" .. prefix
    _theme.layout_tilebottom = _theme.themes_path.."default/layouts/tilebottom" .. prefix
    _theme.layout_tileleft   = _theme.themes_path.."default/layouts/tileleft" .. prefix
    _theme.layout_tile = _theme.themes_path.."default/layouts/tile" .. prefix
    _theme.layout_tiletop = _theme.themes_path.."default/layouts/tiletop" .. prefix
    _theme.layout_spiral  = _theme.themes_path.."default/layouts/spiral" .. prefix
    _theme.layout_dwindle = _theme.themes_path.."default/layouts/dwindle" .. prefix
    _theme.layout_cornernw = _theme.themes_path.."default/layouts/cornernw" .. prefix
    _theme.layout_cornerne = _theme.themes_path.."default/layouts/cornerne" .. prefix
    _theme.layout_cornersw = _theme.themes_path.."default/layouts/cornersw" .. prefix
    _theme.layout_cornerse = _theme.themes_path.."default/layouts/cornerse" .. prefix
end

theme.icon_theme = "dynamic"

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
    get_icons(theme)

    theme.font = theme.font_type.normal .. " 8"

    theme.common_margin  = dpi(5)
    theme.common_padding = dpi(3)

    theme.wibar_height = dpi(30)

    theme.bg_normal  = theme.bg[1]
    theme.bg_focus   = theme.accent
    theme.bg_urgent  = theme.urgent
    theme.bg_systray = theme.bg[2]

    theme.fg_normal   = theme.fg[4]
    theme.fg_focus    = theme.bg[2]
    theme.fg_urgent   = theme.bg[1]
    theme.fg_minimize = theme.fg[2]

    -- either 0 or 6, or i will kill ya
    theme.useless_gap = dpi(6)
    -- theme.useless_gap = dpi(0)

    theme.border_width        = dpi(4)
    theme.border_color_normal = theme.bg_normal
    theme.border_color_active = theme.accent
    theme.border_color_marked = theme.bg[5]
    theme.border_color_urgent = theme.accent

    theme.tasklist_bg_normal   = theme.bg[3]
    theme.tasklist_bg_focus    = theme.bg_focus
    theme.tasklist_bg_minimize = theme.bg[2]

    theme.taglist_bg_empty    = theme.bg[2]
    theme.taglist_bg_occupied = theme.bg[3]
    theme.taglist_font        = theme.font_type.mono .. " 8"

    theme.slider_handle_width = 0
    theme.slider_bar_height = dpi(10)
    theme.slider_bar_color = theme.bg[3]
    theme.slider_bar_active_color = theme.accent

    theme.progressbar_fg = theme.accent
    theme.progressbar_bg = theme.bg[3]

    -- Variables set for theming notifications:
    -- notification_font
    -- notification_[bg|fg]
    -- notification_[width|height|margin]
    -- notification_[border_color|border_width|shape|opacity]
    theme.notification_font = theme.font_type.normal .. " 10"
    theme.notification_margin = theme.common_margin
    theme.notification_spacing = theme.useless_gap
    theme.notification_maximum_icon_width = dpi(100)
    theme.notification_maximum_icon_height = dpi(80)
    theme.notification_minimum_action_width = dpi(100)
    theme.notification_border_width = theme.border_width / 2
    theme.notification_border_color = theme.border_color_marked

    -- Variables set for theming the menu:
    -- menu_[bg|fg]_[normal|focus]
    -- menu_[border_color|border_width]
    theme.menu_submenu_icon = theme.themes_path.."default/submenu.png"
    theme.menu_height = dpi(15)
    theme.menu_width  = dpi(100)

    theme.titlebar_height = dpi(20)
    theme.titlebar_bg_focus = theme.border_color_active
    theme.titlebar_fg_focus = theme.fg_normal
end

theme.build_gtk_theme = function()
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

    local build_theme_cmd = ([[
        oomox-cli -o dynamic <(echo -e "
            BG=%s
            FG=%s
            HDR_BG=%s
            HDR_FG=%s
            SEL_BG=%s
            SEL_FG=%s
            ACCENT_BG=%s
            TXT_BG=%s
            TXT_FG=%s
            BTN_BG=%s
            BTN_FG=%s
            HDR_BTN_BG=%s
            HDR_BTN_FG=%s
            WM_BORDER_FOCUS=%s
            WM_BORDER_UNFOCUS=%s
            ROUNDNESS=4
            GRADIENT=0.0
            SPACING=3
        ")
    ]]):format(
        theme.bg[1]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.accent:sub(2, -1),
        theme.bg[1]:sub(2, -1), -- tuyf
        theme.accent:sub(2, -1),
        theme.bg[3]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.bg[2]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        theme.accent:sub(2, -1),
        theme.bg[1]:sub(2, -1)
    ):gsub("\n%s*", " ")

    local build_icon_theme_cmd = ([[
        mkdir -p ~/.local/share/icons/dynamic &&
        ICONS_SYMBOLIC_PANEL="%s" ICONS_SYMBOLIC_ACTION="%s" %s/gen-icon-theme.sh -o dynamic -c %s -d ~/.local/share/icons/dynamic &&
        gtk-update-icon-cache -f -t ~/.local/share/icons/dynamic
    ]]):format(
        theme.fg[4]:sub(2, -1),
        theme.fg[4]:sub(2, -1),
        os.getenv("DOTFILES") .. "/home/.bin",
        theme.accent:sub(2, -1)
    ):gsub("\n%s*", " ")

    -- local ibus_icon_cmd = (
    --     "gsettings set org.freedesktop.ibus.panel xkb-icon-rgba '%s'"
    -- ):format(theme.accent)

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

theme.save_json_config = function()
    local file = io.open("/tmp/awesome_theme.json", "w+")
    if not file then
        naughty.notification {
            title = "theme setter",
            message = "failed to save theme as json file. cannot open /tmp/awesome_theme.json",
            timeout = 0,
            urgency = "critical",
        }
        return
    end

    local json_template = [[{
        "bg": [
            "%s",
            "%s",
            "%s",
            "%s",
            "%s"
        ],
        "fg": [
            "%s",
            "%s",
            "%s",
            "%s"
        ],
        "accent": "%s",
        "urgent": "%s",
        "term": {
            "color": [
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s",
                "%s"
            ],
            "bg": "%s",
            "fg": "%s",
            "cursor_bg": "%s",
            "cursor_fg": "%s",
            "cursor_border": "%s",
            "selection_bg": "%s",
            "selection_fg": "%s"
        }
    }]]

    file:write(json_template:format(
        theme.bg[1],
        theme.bg[2],
        theme.bg[3],
        theme.bg[4],
        theme.bg[5],

        theme.fg[1],
        theme.fg[2],
        theme.fg[3],
        theme.fg[4],

        theme.accent,
        theme.urgent,

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
