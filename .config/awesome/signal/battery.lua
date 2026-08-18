-- signals
--[[
    CALL
    battery::update, force update and get info
    battery::get_health, emit battery::health signal
    battery::get_cycle_count, emit battery::cycle_count signal
    battery::get_charge_types, emit battery::charge_types

    SET
    battery::set_current_charge_type(charge_type), set current charge type, will emit battery::charge_types when finished

    GET
    battery::capacity(capacity, is_charging), battery percentage
    battery::status(status, power), battery status, can be Charging, Discharging, Full, Not charging or Unknown
    battery::energy(energy), battery current available energy
    battery::time_before_fully_discharged(hours)
    battery::time_before_fully_charged(hours)
    battery::idle, emits when battery is fully charged and laptop is using power directly to the power supply
    battery::health(health), battery health in percentage
    battery::alarm, emitted when energy level is low
    battery::power(power), current power consumption, might not available
    battery::cycle_count(count), charge cycle, might not available
    battery::available_charge_types(types), list of all charging options
    battery::charge_types(all_types, current_type), all supported charge types and current type, might not be available
]]--

-- setting `charge_types` requires ./misc/udev/90-battery-charge-types.rules in /etc/udev/rules.d/

local gears = require("gears")
local helper = require("helper")

local interval = 5
local battery_alarmed = false

local all_charge_types = nil

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
        "charge_types",
    },
    dynamic_features = {
        "capacity",
        "status",
        "energy_now",
        "power_now",
    },
}

local function parse_charge_types(raw)
    local charge_types = gears.string.split(raw, " ")
    local current_type = nil
    for idx, charge_type in ipairs(charge_types) do
        if charge_type:sub(1, 1) == "[" then
            charge_types[idx] = charge_types[idx]:sub(2, -2)
            current_type = charge_types[idx]
        end
    end

    return {
        current = current_type,
        all = charge_types,
    }
end

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
        awesome.emit_signal("battery::energy", energy)

        local alarming_condition = capacity <= 10
        if features.alarm.available then
            alarming_condition = energy <= tonumber(features.alarm.value)
        end

        if alarming_condition then
            if not battery_alarmed then
                awesome.emit_signal("battery::alarm")
                battery_alarmed = true
            end
        else
            battery_alarmed = false
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

            awesome.emit_signal("battery::status", status, power)
        else
            awesome.emit_signal("battery::status", status, nil)
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

awesome.connect_signal("battery::get_charge_types", function()
    battery_acpi:get_feature_data("charge_types", function(types)
        local val = parse_charge_types(types)
        awesome.emit_signal("battery::charge_types", val.all, val.current)
    end)
end)

awesome.connect_signal("battery::set_current_charge_type", function(charge_type)
    if not gears.table.hasitem(all_charge_types, charge_type) then return end
    battery_acpi:set_feature_data("charge_types", charge_type, function(_)
        awesome.emit_signal("battery::get_charge_types")
    end)
end)

battery_acpi:check_features()
battery_acpi:get_all_features_data(function(features)
    awesome.emit_signal("battery::update")
    gears.timer.start_new(interval, function()
        awesome.emit_signal("battery::update")
        return true
    end)

    if features.charge_types.available then
        local val = parse_charge_types(features.charge_types.value)
        all_charge_types = val.all
        awesome.emit_signal("battery::charge_types", val.all, val.current)
    end
end)
