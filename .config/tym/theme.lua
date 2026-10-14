package.path = package.path .. ';' .. os.getenv('HOME') .. '/.config/tym/?.lua'
local json = require("json")

local fallback_theme = {
    bg = {
        "#1c1c1c",
        "#282828",
        "#383838",
        "#505050",
        "#666666",
    },
    fg = {
        "#bdbdbd",
        "#d5d5d5",
        "#ebebeb",
        "#fbfbfb",
    },
    accent = "#ffffff",
    urgent = "#cc6666",
    term = {
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
        bg = "#1c1c1c",
        fg = "#c5c8c6",
        cursor_bg = "#d5d5d5",
        cursor_fg = "#1c1c1c",
        cursor_border = "#d5d5d5",
        selection_bg = "#383838",
        selection_fg = "#ffffff",
    }
}

local function load_awesome_theme()
    local file = io.open("/tmp/awesome_theme.json", "r")
    if file then
        local contents = file:read("*a")
        file:close()

        local success, decoded = pcall(json.decode, contents)
        if success then
            return decoded
        else
            print("Failed to parse theme JSON: " .. tostring(decoded))
        end
    end

    return fallback_theme
end

local colorscheme = load_awesome_theme().term

return {
    color_background = colorscheme.bg,
    color_foreground = colorscheme.fg,
    color_bold = colorscheme.fg,
    color_cursor = colorscheme.cursor_bg,
    color_cursor_foreground = colorscheme.cursor_fg,
    color_highlight = colorscheme.selection_bg,
    color_highlight_foreground = colorscheme.selection_fg,
    color_0  = colorscheme.color[1],
    color_1  = colorscheme.color[2],
    color_2  = colorscheme.color[3],
    color_3  = colorscheme.color[4],
    color_4  = colorscheme.color[5],
    color_5  = colorscheme.color[6],
    color_6  = colorscheme.color[7],
    color_7  = colorscheme.color[8],
    color_8  = colorscheme.color[9],
    color_9  = colorscheme.color[10],
    color_10 = colorscheme.color[11],
    color_11 = colorscheme.color[12],
    color_12 = colorscheme.color[13],
    color_13 = colorscheme.color[14],
    color_14 = colorscheme.color[15],
    color_15 = colorscheme.color[16],
}
