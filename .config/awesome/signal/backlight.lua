-- signals
--[[
    CALL
    backlight::force_turn_off

    GET
    backlight::max_brightness(max)
    backlight::brightness(value)

    SET
    backlight::set_brightness(percentage), set brightness
    backlight::increase_brightness(diff), increase/decrease brightness
]]--

-- need to copy udev rule (./misc/udev/90-backlight.rules) to set brightness as user other than root

local awful = require("awful")
local helper = require("helper")

local backlight_dir = "/sys/class/backlight/intel_backlight/"
local max_brightness = nil
local min_brightness = nil
local brightness_percentage = nil

local function set_brightness(percent)
    if percent ~= brightness_percentage then
        brightness_percentage = percent
        local raw_b = math.floor(10 ^ ((percent / 100) * math.log(max_brightness - min_brightness, 10)) + min_brightness)
        awful.spawn.with_shell("echo " .. raw_b .. " > " .. backlight_dir .. "brightness")
        awesome.emit_signal("backlight::brightness", percent)
    end
end

local backlight_acpi = helper.acpi {
    acpi_dir = backlight_dir,
    all_features = {
        "brightness",
        "max_brightness",
        -- "actual_brightness",
    },
    dynamic_features = {},
}

awesome.connect_signal("backlight::force_turn_off", function()
    awful.spawn("xset dpms force off")
end)

awesome.connect_signal("backlight::set_brightness", set_brightness)

awesome.connect_signal("backlight::increase_brightness", function(dif)
    local new = brightness_percentage + dif
    if new > 100 then
        new = 100
    elseif new < 0 then
        new = 0
    end

    set_brightness(new)
end)

backlight_acpi:check_features()
backlight_acpi:get_all_features_data(function(features)
    max_brightness = tonumber(features.max_brightness.value)
    min_brightness = max_brightness / 300
    local raw_b = tonumber(features.brightness.value)
    if raw_b == 0 then
        brightness_percentage = 0
    else
        brightness_percentage = math.floor(math.log(raw_b - min_brightness, 10) / math.log(max_brightness - min_brightness, 10) * 100)
    end
    awesome.emit_signal("backlight::brightness", brightness_percentage)
end)
