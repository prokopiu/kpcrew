-- switch with mode on/off and toggle function via command
local TwoStateCustomSwitch = {}

utils = require "kpcrew.genutils"
Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
function TwoStateCustomSwitch:new(name, statusDref, statusDrefIdx, funcOn, funcOff, funcToggle)

    TwoStateCustomSwitch.__index = TwoStateCustomSwitch
    setmetatable(TwoStateCustomSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, TwoStateCustomSwitch)

	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx
	obj.funcOn = funcOn
	obj.funcOff = funcOff
	obj.funcToggle = funcToggle
	
    return obj
end

-- return value of status dataref
function TwoStateCustomSwitch:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

-- actuate the switch with given mode
function TwoStateCustomSwitch:actuate(action)
	if action == Switch.modeOn then
		self.funcOn()
	end
	
	if action == Switch.modeOff then
		self.funcOff()
	end
	
	if action == Switch.modeToggle then
		if self.funcToggle ~= nil then
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

return TwoStateCustomSwitch

