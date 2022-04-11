-- switch with mode on/off and toggle function via command

local MultiStateCmdSwitch = { 
	defaultDelay = 3 
}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
function MultiStateCmdSwitch:new(name, statusDref, statusDrefIdx, decrcmd, incrcmd)

    MultiStateCmdSwitch.__index = MultiStateCmdSwitch
    setmetatable(MultiStateCmdSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, MultiStateCmdSwitch)

	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx
	obj.decrcmd = decrcmd
	obj.incrcmd = incrcmd
	obj.delay = self.defaultDelay
	
    return obj
end

-- return value of status dataref
function MultiStateCmdSwitch:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

-- actuate the switch with given mode
function MultiStateCmdSwitch:actuate(action)
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

-- set the value directly where possible (dref can be written)
function MultiStateCmdSwitch:setValue(value)
	if self.statusDrefIdx > 0 then
		set_array(self.statusDref,self.statusDrefIdx,value)
	else
		set(self.statusDref,value)
	end
end

-- set the value directly where possible 
function MultiStateCmdSwitch:adjustValue(value,min,max)
	if value <= max and value >= min then
		while value < math.floor(get(self.statusDref,self.statusDrefIdx)) and math.floor(get(self.statusDref,self.statusDrefIdx)) > min do
			command_once(self.decrcmd)
		end
		while value > math.floor(get(self.statusDref,self.statusDrefIdx)) and math.floor(get(self.statusDref,self.statusDrefIdx)) < max do
			command_once(self.incrcmd)
		end
	end
end

-- adjust the delay for repeated calls
function MultiStateCmdSwitch:setDefaultDelay(delay)
	self.defaultDelay = delay
end

return MultiStateCmdSwitch

