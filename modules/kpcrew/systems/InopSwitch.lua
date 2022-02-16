local InopSwitch = {}

utils = require "kpcrew.genutils"
Switch = require "kpcrew.systems.Switch"

function InopSwitch:new(name)

    InopSwitch.__index = InopSwitch
    setmetatable(InopSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, InopSwitch)

    return obj
end

-- return value of status dataref
function InopSwitch:getStatus()
	return 0
end

-- actuate the switch with given mode
function InopSwitch:actuate(action)
end

-- set the value
function InopSwitch:setValue(value)
end

function InopSwitch:adjustValue(value,min,max)
end

return InopSwitch