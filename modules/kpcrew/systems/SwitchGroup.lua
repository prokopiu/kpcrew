-- interface for a group of switches
local SwitchGroup = {
}

local utils = require "kpcrew.genutils"

-- new switch object
function SwitchGroup:new(name)
    SwitchGroup.__index = SwitchGroup

    local obj = {}
    setmetatable(obj, SwitchGroup)

    obj.name = name
	obj.switches = {}

    return obj
end

-- get name of switch object
function SwitchGroup:getName()
    return self.name
end

function SwitchGroup:addSwitch(newSwitch)
    table.insert(self.switches, newSwitch)
end

-- execute a switch group
function SwitchGroup:actuate(action)
    for _, switch in ipairs(self.switches) do
        switch:actuate(action)
    end	
end

function SwitchGroup:setValue(value)
    for _, switch in ipairs(self.switches) do
        switch:setValue(value)
    end	
end

function SwitchGroup:adjustValue(value,min,max)
    for _, switch in ipairs(self.switches) do
        switch:adjustValue(value,min,max)
    end	
end

return SwitchGroup