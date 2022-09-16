-- interface for a switch object used in systems
--
-- @classmod Switch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khSwitch = {
}

-- Base constructor for any switch
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref (set -1 if only accessible via dateref_array to reach [0])
-- @treturn Switch the created base element
function khSwitch:new(name, statusDref, statusDrefIdx)
    khSwitch.__index = khSwitch

    local obj = {}
    setmetatable(obj, khSwitch)

    obj.name = name
	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx

    return obj
end

-- Get name of switch object
-- @treturn string name of element
function khSwitch:getName()
    return self.name
end

-- execute a switch action
-- @tparam int action code (modeOn, modeOff...)
function khSwitch:actuate(action)
end

-- return the current element dataref value
-- @treturn <type> dataref value
function khSwitch:getStatus()
	-- if index = 0 then it is a single dataref, pull with get
	if self.statusDrefIdx == 0 then
		return get(self.statusDref)
	end
	-- if the index is -1 then pull as array element index [0]
	-- otherwise pull as array element with given index
	if self.statusDrefIdx < 0 then
		return get(self.statusDref,0)
	else
		return get(self.statusDref,self.statusDrefIdx)
	end
end

-- set the elements dataref status
-- @tparam <type> new value of dataref
function khSwitch:setValue(value)
	-- if index = 0 then it is a single dataref, set with simple set
	if self.statusDrefIdx == 0 then
		set(self.statusDref, value)
	end
	-- if the index is -1 then pull as array element index [0]
	-- otherwise pull as array element with given index
	if self.statusDrefIdx == -1 then
		set_array(self.statusDref,0,value)
	end
	if self.statusDrefIdx > 0 then
		set_array(self.statusDref,self.statusDrefIdx,value)
	end
end

return khSwitch