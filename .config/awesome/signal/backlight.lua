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
local rubato = require("module.rubato")

local backlight_dir = "/sys/class/backlight/intel_backlight/"
local max_brightness = 0
local min_brightness = 0
local brightness_percentage = 0

-- smooth brightness change is satisfying
local apply_brightness = helper.rate_limited_call(0.01, function()
    local raw_b = math.floor(10 ^ ((brightness_percentage / 100) * math.log(max_brightness - min_brightness, 10)) + min_brightness)
    awful.spawn.with_shell("echo " .. raw_b .. " > " .. backlight_dir .. "brightness")
    awesome.emit_signal("backlight::brightness", brightness_percentage)
end)

local smooth_value = rubato.timed {
    duration = 0.2,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(percent)
        brightness_percentage = percent
        apply_brightness.call()
    end
}

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
    smooth_value.target = percent
end)

awesome.connect_signal("backlight::increase_brightness", function(dif)
    local new = brightness_percentage + dif
    if new > 100 then
        new = 100
    elseif new < 0 then
        new = 0
    end

    smooth_value.target = new
end)

backlight_acpi:check_features()
backlight_acpi:get_all_features_data(function(features)
    max_brightness = tonumber(features.max_brightness.value)
    min_brightness = max_brightness / 500
    local raw_b = tonumber(features.brightness.value)
    if raw_b == 0 then
        brightness_percentage = 0
    else
        brightness_percentage = math.floor(math.log(raw_b - min_brightness, 10) / math.log(max_brightness - min_brightness, 10) * 100)
    end
    smooth_value.pos = brightness_percentage
    awesome.emit_signal("backlight::brightness", brightness_percentage)
end)
