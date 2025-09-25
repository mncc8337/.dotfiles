-- signals
--[[
    CALL
    battery::update, force update and get info
    battery::get_health, emit battery::health signal
    battery::get_cycle_count, emit battery::cycle_count signal

    GET
    battery::capacity(capacity, is_charging), battery percentage
    battery::status(status), battery status, can be Charging, Discharging, Full, Not charging or Unknown
    battery::energy(energy), battery current available energy
    battery::time_before_fully_discharged(hours)
    battery::time_before_fully_charged(hours)
    battery::idle, emits when battery is fully charged and laptop is using power directly to the power supply
    battery::health(health), battery health in percentage
    battery::alarm, emitted when energy level is low
    battery::power(power), current power consumption, might not available
    battery::cycle_count, charge cycle, might not available
]]--

local gears = require("gears")
local helper = require("helper")

local interval = 5

local battery_acpi = helper.acpi {
    acpi_dir = "/sys/class/power_supply/BAT0/",
    all_features = {
        "present",
        "capacity",
        "status",
        "energy_now",
        "energy_full",
        "energy_full_design",
        "alarm",
        "power_now",
        "cycle_count",
    },
    dynamic_features = {
        "capacity",
        "status",
        "energy_now",
        "power_now",
    },
}

awesome.connect_signal("battery::update", function()
    battery_acpi:get_dynamic_features_data(function(features)
        local capacity
        if features.present.value == "1" then
            capacity = tonumber(features.capacity.value)
        else
            capacity = -1
        end
        local status = features.status.value
        local energy = tonumber(features.energy_now.value)
        local energy_full = tonumber(features.energy_full.value)

        local is_charging
        if status == "Charging" then is_charging = true else is_charging = false end

        awesome.emit_signal("battery::capacity", capacity, is_charging)
        awesome.emit_signal("battery::status", status)
        awesome.emit_signal("battery::energy", energy)

        if features.alarm.available then
            if energy <= tonumber(features.alarm.value) then
                awesome.emit_signal("battery::alarm")
            end
        else
            if capacity <= 10 then
                awesome.emit_signal("battery::alarm")
            end
        end

        if features.power_now.available then
            local power = tonumber(features.power_now.value)
            awesome.emit_signal("battery::power", power)

            if power > 0 then
                if status == "Discharging" then
                    local time_remaining = energy / power
                    awesome.emit_signal("battery::time_before_fully_discharged", time_remaining)
                elseif status == "Charging" then
                    local time_remaining = (energy_full - energy) / power
                    awesome.emit_signal("battery::time_before_fully_charged", time_remaining)
                end
            else
                awesome.emit_signal("battery::idle")
            end
        end

        if battery_acpi.features.cycle_count.available then
            awesome.emit_signal("battery::cycle_count", features.cycle_count.value)
        else
            awesome.emit_signal("battery::cycle_count", "na")
        end

    end)
end)

awesome.connect_signal("battery::get_health", function()
    local health = tonumber(battery_acpi.features.energy_full.value) / tonumber(battery_acpi.features.energy_full_design.value) * 100
    awesome.emit_signal("battery::health", math.floor(health))
end)

awesome.connect_signal("battery::get_cycle_count", function()
    battery_acpi:get_feature_data("cycle_count", function(cyc)
        awesome.emit_signal("battery::cycle_count", cyc)
    end)
end)

battery_acpi:check_features()
battery_acpi:get_all_features_data(function(_)
    awesome.emit_signal("battery::update")
    gears.timer.start_new(interval, function()
        awesome.emit_signal("battery::update")
        return true
    end)
end)
