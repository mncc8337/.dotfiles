-- signals
--[[
    SET
    screenshot::full
    screenshot::area
--]]

-- dependency: maim, xclip

local awful = require("awful")
local naughty = require("naughty")

local save_dir    = "$HOME/Pictures/"
local save_format = "%Y-%m-%d_%H-%M-%S.png"

local full_cmd = "maim %s --hidecursor"
local area_cmd = "maim -g `slop` %s --hidecursor"

local function take_screenshot(cmd, callback_func)
    local tmpf = os.tmpname()
    awful.spawn.easy_async_with_shell(string.format(cmd, tmpf), function(_, _, _, exitcode)
        if exitcode == 1 then return end

        awful.spawn.with_shell('xclip -selection clip -t image/png -i ' .. tmpf)

        local notif = naughty.notification {
            title = "screenshot",
            message = "Image copied to clipboard",
            icon = tmpf
        }

        callback_func(tmpf, notif)
    end)
end

local function copy(tmpf, notif)
    local filename = os.date(save_format)
    local savepath = save_dir .. filename

    awful.spawn.with_shell("cp " .. tmpf .. ' ' .. savepath)

    naughty.replace_text(notif, notif.title, notif.message .. " and saved to " .. savepath)
end

local function dummy(_, _) end

awesome.connect_signal("screenshot::full", function(save)
    local callback = dummy
    if save then callback = copy end
    take_screenshot(full_cmd, callback)
end)
awesome.connect_signal("screenshot::area", function(save)
    local callback = dummy
    if save then callback = copy end
    take_screenshot(area_cmd, callback)
end)
