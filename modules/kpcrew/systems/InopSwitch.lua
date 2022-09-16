-- Switch placeholder with no function
-- use when aircraft does not support standard elements

-- @classmod InopSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khInopSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- Constructor for InopSwitch
-- @tparam string name of element
-- @treturn Switch the created element
function khInopSwitch:new(name)

    khInopSwitch.__index = khInopSwitch
    setmetatable(khInopSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name,"",0)
    setmetatable(obj, khInopSwitch)

    return obj
end

-- return the current element dataref value
-- @treturn 0
function khInopSwitch:getStatus()
	return 0
end

return khInopSwitch