-- switch with mode on/off and toggle function via custom script

-- @classmod TwoStateCustomSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khTwoStateCustomSwitch = {
	defaultDelay = 3 
}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, script for on, off and toggle
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @tparam string funcOn function to turn on
-- @tparam string funcOff function to turn off
-- @tparam string funcToggle function to toggle
-- @tparam string funcStatus function to return status value
-- @treturn Switch the created base element
function khTwoStateCustomSwitch:new(name, statusDref, statusDrefIdx, funcOn, funcOff, funcToggle, funcStatus)

    khTwoStateCustomSwitch.__index = khTwoStateCustomSwitch
    setmetatable(khTwoStateCustomSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name, statusDref, statusDrefIdx)
    setmetatable(obj, khTwoStateCustomSwitch)

	obj.funcOn = funcOn
	obj.funcOff = funcOff
	obj.funcToggle = funcToggle
	obj.funcStatus = funcStatus
	obj.delay = self.defaultDelay
	
    return obj
end

-- return value of status dataref
-- @treturn <type> status value
function khTwoStateCustomSwitch:getStatus()
	if type(self.funcStatus) == 'function' then
		return self.funcStatus()
	else
		return self:getStatus()
	end
end

-- actuate the switch with given mode
-- @tparam int action 0=off 1=on 2=tgl
function khTwoStateCustomSwitch:actuate(action)
	if action == modeOn then
		if type(self.funcOn) == 'function' then
			self.funcOn()
		end
	end
	if action == modeOff then
		if type(self.funcOff) == 'function' then
			self.funcOff()
		end
	end
	if action == modeToggle then
		if type(self.funcToggle) == 'function' then
			self.funcToggle()
		else
			if self:getStatus() ~= modeOff then
				self.funcOff()
			else
				self.funcOn()
			end
		end
	end
end

-- perform a single step up or down
-- @tparam int 0=down, 1=up, 10=delayed down, 11=delayed up
function khTwoStateCustomSwitch:step(action)
	if action == slowUp then
		if self.delay > 0 then
			self.delay = self.delay - 1
		else
			if type(self.funcOn) == 'function' then
				self.funcOn()
			end
			self.delay = self.defaultDelay
		end
	end
	if action == cmdUp then
		self:actuate(modeOn)
	end
	if action == slowDown then
		if self.delay > 0 then
			self.delay = self.delay - 1
		else
			if type(self.funcOff) == 'function' then
				self.funcOff()
			end
			self.delay = self.defaultDelay
		end
	end
	if action == cmdDown then
		self:actuate(modeOff)
	end
end

-- adjust the delay for repeated calls
-- @tparam int cycles to delay next step
function khTwoStateCustomSwitch:setDefaultDelay(delay)
	self.defaultDelay = delay
end

return khTwoStateCustomSwitch