-- interface for a group of switches

-- @classmod SwitchGroup
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khSwitchGroup = {
}

-- Base constructor for SwitchGroup
-- @tparam string name of element
-- @treturn SwitchGroup the created base element
function khSwitchGroup:new(name)
    khSwitchGroup.__index = khSwitchGroup

    local obj = {}
    setmetatable(obj, khSwitchGroup)

    obj.name = name
	obj.switches = {}

    return obj
end

-- get name of switch object
-- @treturn string name
function khSwitchGroup:getName()
    return self.name
end

-- add switch to group
-- @tparam newSwitch Switch based element
function khSwitchGroup:addSwitch(newSwitch)
    table.insert(self.switches, newSwitch)
end

-- actuate all switches in the switch group
-- @tparam int action code (modeOn, modeOff...)
function khSwitchGroup:actuate(action)
    for _, switch in ipairs(self.switches) do
        switch:actuate(action)
    end	
end

-- set the value of a status dref in a switch
-- @tparam <type> new value of dataref
function khSwitchGroup:setValue(value)
    for _, switch in ipairs(self.switches) do
        switch:setValue(value)
    end	
end

-- return the summed up status values
-- @treturn <type> dataref value
function khSwitchGroup:getStatus()
	local stat = 0
    for _, switch in ipairs(self.switches) do
        stat = stat + switch:getStatus()
    end	
	return stat
end

return khSwitchGroup