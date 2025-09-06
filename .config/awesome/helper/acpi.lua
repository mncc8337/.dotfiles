local awful = require("awful")
local gears = require("gears")
local helper = require("helper.common")

local acpi = {}
acpi.__index = acpi

function acpi:new(fields)
    local instance = setmetatable({}, acpi)

    instance.acpi_dir = " " .. fields.acpi_dir
    instance.features = {}
    instance.dynamic_features = fields.dynamic_features or {}
    instance.available_features = {}
    instance.available_dynamic_features = {}

    for _, feature in ipairs(fields.all_features) do
        instance.features[feature] = {
            available = false,
            checked = false,
            prop_idx = nil,
            value = nil,
        }
    end

    return instance
end

setmetatable(acpi, {
    __call = function(cls, fields)
        return cls:new(fields or {})
    end
})

-- check what features are available to use (async)
function acpi:check_features()
    for feature, data in pairs(self.features) do
        local cmd = "if [ -e" .. self.acpi_dir .. feature .. " ]; then echo 1; else echo 0; fi"
        awful.spawn.easy_async_with_shell(cmd, function(out)
            out = out:sub(1, -2)
            data.available = out == "1"
            data.checked = true
        end)
    end
end

-- get data of all features, also wait for all features to be checked
function acpi:get_all_features_data(callback)
    gears.timer {
        timeout = 0.5,
        single_shot = true, autostart = true,
        callback = function()
            local all_checked = true
            for _, data in pairs(self.features) do
                all_checked = all_checked and data.checked
            end
            if not all_checked then
                return true
            else
                local cmd = "cat"

                -- add available feature into table
                local prop_idx = 1
                for feature, data in pairs(self.features) do
                    if data.available then
                        table.insert(self.available_features, feature)
                        if helper.table_contains(self.dynamic_features, feature) then
                            table.insert(self.available_dynamic_features, feature)
                        end
                        cmd = cmd .. self.acpi_dir .. feature
                        data.prop_idx = prop_idx
                        prop_idx = prop_idx + 1
                    end
                end

                awful.spawn.easy_async(cmd, function(out)
                    local lst = gears.string.split(out, "\n")

                    -- get basic info before calling udpate signal
                    for _, feature in ipairs(self.available_features) do
                        self.features[feature].value = lst[self.features[feature].prop_idx]
                    end

                    callback(self.features)
                end)

                return false
            end
        end,
    }
end

-- get data of only dynamic features, make sure to call get_all_features_data() to ensure that all features are checked
function acpi:get_dynamic_features_data(callback)
    local cmd = "cat"

    local prop_idx = 1
    for _, feature in ipairs(self.available_dynamic_features) do
        cmd = cmd .. self.acpi_dir .. feature
        self.features[feature].prop_idx = prop_idx
        prop_idx = prop_idx + 1
    end

    awful.spawn.easy_async(cmd, function(out)
        local lst = gears.string.split(out, "\n")
        for _, feature in ipairs(self.available_dynamic_features) do
            self.features[feature].value = lst[self.features[feature].prop_idx]
        end

        callback(self.features)
    end)
end

function acpi:get_feature_data(feature, callback)
    if not helper.table_contains(self.available_features, feature) then
        return
    end

    local cmd = "cat" .. self.acpi_dir .. feature

    awful.spawn.easy_async(cmd, function(out)
        out = out:sub(1, -2)
        self.features[feature].value = out
        callback(out)
    end)
end

return acpi
