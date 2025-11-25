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
local min_brightness = 0.0 -- [0, 100]
local steep_factor = 10 -- (0, +inf)

local max_raw = 0
local brightness_percentage = 0

local apply_brightness = helper.rate_limited_call(0.01, function()
    if brightness_percentage < min_brightness then
        brightness_percentage = min_brightness
    end

    local raw_b = math.floor(((steep_factor + 1.0) ^ (brightness_percentage / 100.0) - 1.0) / steep_factor * max_raw)
    awful.spawn.with_shell("echo " .. raw_b .. " > " .. backlight_dir .. "brightness")
    awesome.emit_signal("backlight::brightness", brightness_percentage)
end)

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

awesome.connect_signal("backlight::set_brightness", function(percent)
    brightness_percentage = percent
    apply_brightness.call()
end)

awesome.connect_signal("backlight::increase_brightness", function(dif)
    local new = brightness_percentage + dif
    if new > 100 then
        new = 100
    elseif new < min_brightness then
        new = min_brightness
    end

    brightness_percentage = new
    apply_brightness.call()
end)

backlight_acpi:check_features()
backlight_acpi:get_all_features_data(function(features)
    max_raw = tonumber(features.max_brightness.value) * 1.0

    local raw_b = tonumber(features.brightness.value)
    if raw_b == 0 then
        brightness_percentage = 80
    else
        brightness_percentage = math.log(raw_b / max_raw * steep_factor + 1.0) / math.log(steep_factor + 1.0) * 100.0
    end
    apply_brightness.call()
end)
