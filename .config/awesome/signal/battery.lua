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
    battery::health(health), battery health in percentage
    battery::alarm, emitted when energy level is low
    battery::power(power), current power consumption, might not available
    battery::cycle_count, charge cycle, might not available
]]--

local awful = require("awful")
local gears = require("gears")
local helper = require("helper")

local battery_dir = " /sys/class/power_supply/BAT0/"
local interval = 5

local features = {
    present = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    capacity = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    status = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    energy_now = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    energy_full = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    energy_full_design = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    alarm = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    power_now = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
    cycle_count = {
        available = false,
        checked = false,
        prop_idx = nil,
        value = nil,
    },
}

local runtime_features = {
    -- always available
    "capacity",
    "status",
    "energy_now",
    -- not always available
    "power_now",
}

local available_features = {}
local available_runtime_features = {}

local timer = gears.timer {
    timeout = interval,
    single_shot = false, autostart = false,
    callback = function()
        awesome.emit_signal("battery::update")
    end
}

awesome.connect_signal("battery::update", function()
    local cmd = "cat"

    local prop_idx = 1
    for _, feature in ipairs(available_runtime_features) do
        cmd = cmd .. battery_dir .. feature
        features[feature].prop_idx = prop_idx
        prop_idx = prop_idx + 1
    end

    awful.spawn.easy_async(cmd, function(out)
        local lst = gears.string.split(out, "\n")
        for _, feature in ipairs(available_runtime_features) do
            features[feature].value = lst[features[feature].prop_idx]
        end

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

            if status == "Discharging" then
                local time_remaining = energy / power
                awesome.emit_signal("battery::time_before_fully_discharged", time_remaining)
            elseif status == "Charging" then
                local time_remaining = (energy_full - energy) / power
                awesome.emit_signal("battery::time_before_fully_charged", time_remaining)
            end
        end
    end)
end)

awesome.connect_signal("battery::get_health", function()
    local health = tonumber(features.energy_full.value) / tonumber(features.energy_full_design.value) * 100
    awesome.emit_signal("battery::health", health)
end)

awesome.connect_signal("battery::get_cycle_count", function()
    if features.cycle_count.available then
        awesome.emit_signal("battery::cycle_count", features.cycle_count.value)
    else
        awesome.emit_signal("battery::cycle_count", "na")
    end
end)

-- check features availability
for feature, data in pairs(features) do
    local cmd = "if [ -e" .. battery_dir .. feature .. " ]; then echo 1; else echo 0; fi"
    awful.spawn.easy_async_with_shell(cmd, function(out)
        out = out:sub(1, -2)
        data.available = out == "1"
        data.checked = true
    end)
end

gears.timer {
    timeout = 0.5,
    single_shot = true, autostart = true,
    callback = function()
        local all_checked = true
        for _, data in pairs(features) do
            all_checked = all_checked and data.checked
        end
        if not all_checked then
            return true
        else
            local cmd = "cat"

            -- add available feature into table
            local prop_idx = 1
            for feature, data in pairs(features) do
                if data.available then
                    table.insert(available_features, feature)
                    if helper.table_contains(runtime_features, feature) then
                        table.insert(available_runtime_features, feature)
                    end
                    cmd = cmd .. battery_dir .. feature
                    data.prop_idx = prop_idx
                    prop_idx = prop_idx + 1
                end
            end

            awful.spawn.easy_async(cmd, function(out)
                local lst = gears.string.split(out, "\n")

                -- get basic info before calling udpate signal
                for _, feature in ipairs(available_features) do
                    features[feature].value = lst[features[feature].prop_idx]
                    -- require("naughty").notify{message=feature .. " " .. features[feature].value}
                end

                awesome.emit_signal("battery::update")
                timer:start()
            end)

            return false
        end
    end,
}

return timer
