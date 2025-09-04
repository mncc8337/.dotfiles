local table_join = require("gears.table").join

local common = require("helper.common")
local icon = require("helper.icon")

local acpi = require("helper.acpi")

local helper = table_join(common, icon)
helper.acpi = acpi

return helper
