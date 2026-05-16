local awful = require("awful")
local string = string

local _filesystem = {}

function _filesystem.save_image_async_curl(url, filepath, callback)
    awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath),
    {
      exit=callback
    })
end

return _filesystem
