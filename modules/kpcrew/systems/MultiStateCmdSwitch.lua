-- Rotaries and multi-state switches

-- @classmod MultiStateCmdSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khMultiStateCmdSwitch = { 
	defaultDelay = 3 
}

local Switch = require "kpcrew.systems.Switch"

-- Provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @tparam string decrcmd command string to reduce the int value
-- @tparam string incrcmd command string to increase the int value
-- @tparam int minvalue minimal value for the switch
-- @tparam int maxvalue maximal value for the switch
-- @tparam boolean readonly = true cannot use setValue()
-- @treturn Switch the created base element
function khMultiStateCmdSwitch:new(name, statusDref, statusDrefIdx, decrcmd, incrcmd, minvalue, maxvalue, readonly)

    khMultiStateCmdSwitch.__index = khMultiStateCmdSwitch
    setmetatable(khMultiStateCmdSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name, statusDref, statusDrefIdx)
    setmetatable(obj, khMultiStateCmdSwitch)

	obj.decrcmd = decrcmd
	obj.incrcmd = incrcmd
	obj.minvalue = minvalue
	obj.maxvalue = maxvalue
	obj.readonly = readonly
	obj.delay = self.defaultDelay
	
    return obj

end

-- actuate the switch with given mode
-- @tparam int action code (goal to reach)
function khMultiStateCmdSwitch:actuate(value)
	if self.readonly == true then
		if value <= self.maxvalue and value >= self.minvalue then
			local cnt = self.maxvalue - self.minvalue + 1
			if value < self:getStatus() then
				while cnt > 0 and self:getStatus() > self.minvalue and self:getStatus() ~= value do
					cnt = cnt -1
					command_once(self.decrcmd)
				end
			else
				while cnt > 0 and self:getStatus() < self.maxvalue and self:getStatus() ~= value do
					cnt = cnt -1
					command_once(self.incrcmd)
				end
			end
		end
	else
		self:setValue(value)
	end
end

-- perform a single step up or down
-- @tparam int 0=down, 1=up, 10=delayed down, 11=delayed up
function khMultiStateCmdSwitch:step(action)
	if action == cmdUp then
		command_once(self.incrcmd)
	end
	if action == slowUp then
		if self.delay > 0 then
			self.delay = self.delay - 1
		else
			command_once(self.incrcmd)
			self.delay = self.defaultDelay
		end
	end
	if action == cmdDown then
		command_once(self.decrcmd)
	end
	if action == slowDown then
		if self.delay > 0 then
			self.delay = self.delay - 1
		else
			command_once(self.decrcmd)
			self.delay = self.defaultDelay
		end
	end
end

-- adjust the delay for repeated calls
-- @tparam int cycles to delay next step
function khMultiStateCmdSwitch:setDefaultDelay(delay)
	self.defaultDelay = delay
end

return khMultiStateCmdSwitch

