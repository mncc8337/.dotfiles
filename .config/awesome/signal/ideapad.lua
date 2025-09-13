-- signals
--[[
    CALL

    GET
    ideapad::profiles(profs), all available power profiles
    ideapad::current_profile(prof)
    ideapad::conservation_mode(active)

    SET
    ideapad::set_profile(prof)
    ideapad::set_conservation_mode(active)
]]--

-- some useful signals for lenovo ideapad
-- requires `./misc/sudoers.d/ideapad` in `/etc/sudoers.d/`

local awful = require("awful")
local helper = require("helper")
local gears = require("gears")

local available = nil
local platform_profiles = nil
local current_profile = nil

local ideapad_acpi = helper.acpi {
    acpi_dir = "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/",
    all_features = {
        "conservation_mode",
        -- "camera_power",
        "fn_lock",
        "usb_charging",
    }
}

awesome.connect_signal("ideapad::set_profile", function(prof)
    if not helper.table_contains(platform_profiles, prof) then
        return
    end

    awful.spawn.with_shell("echo " .. prof .. " | sudo tee /sys/firmware/acpi/platform_profile")
    current_profile = prof
end)

awesome.connect_signal("ideapad::set_conservation_mode", function(active)
    local str = nil
    if active then
        str = "1"
    else
        str = "0"
    end

    ideapad_acpi:set_feature_data("conservation_mode", str, function(out, err, _, code)
        require("naughty").notify{message=out .. " " .. err .. " " .. code}
    end)
end)

-- check if the module is available
awful.spawn.easy_async_with_shell("if lsmod | grep -wq ideapad_laptop; then echo 1; else 0; fi", function(out)
    out = out:sub(1, -2)
    available = out == "1"

    if available then
        -- get all platform profiles
        awful.spawn.easy_async("cat /sys/firmware/acpi/platform_profile_choices", function(out2)
            out2 = out2:sub(1, -2)
            platform_profiles = gears.string.split(out2, " ")
            awesome.emit_signal("ideapad::profiles", platform_profiles)
        end)

        -- get current profile
        gears.timer {
            timeout = 1,
            single_shot = false, autostart = true, call_now = true,
            callback = function()
                awful.spawn.easy_async("cat /sys/firmware/acpi/platform_profile", function(out2)
                    out2 = out2:sub(1, -2)
                    if out2 ~= current_profile then
                        current_profile = out2
                        awesome.emit_signal("ideapad::current_profile", current_profile)
                    end
                end)
            end
        }
    end
end)

ideapad_acpi:check_features()
ideapad_acpi:get_all_features_data()
