-- switch with mode on/off and toggle function via command
local TwoStateToggleSwitch = {}

utils = require "kpcrew.genutils"
Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
function TwoStateToggleSwitch:new(name, statusDref, statusDrefIdx, tglcmd)

    TwoStateToggleSwitch.__index = TwoStateToggleSwitch
    setmetatable(TwoStateToggleSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, TwoStateToggleSwitch)

	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx
	obj.tglcmd = tglcmd
	
    return obj
end

-- return value of status dataref
function TwoStateToggleSwitch:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

-- actuate the switch with given mode
function TwoStateToggleSwitch:actuate(action)
	if action == Switch.modeOn then
		if self:getStatus() ~= modeOn then
			command_once(self.tglcmd)
		end
	end
	if action == Switch.modeOff then
		if self:getStatus() ~= modeOff then
			command_once(self.tglcmd)
		end
	end
	if action == Switch.modeToggle then
		command_once(self.tglcmd)
	end
end

-- set the value
function TwoStateToggleSwitch:setValue(value)
	set_array(self.statusDref,self.statusDrefIdx)
end

return TwoStateToggleSwitch

