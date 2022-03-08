-- switch with mode on/off and toggle function via command
local TwoStateToggleSwitch = {}

local Switch = require "kpcrew.systems.Switch"

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
	if self.statusDrefIdx == 0 then
		get(self.statusDref)
	end
	if self.statusDrefIdx < 0 then
		return get(self.statusDref,0)
	else
		return get(self.statusDref,self.statusDrefIdx)
	end
end

-- actuate the switch with given mode
function TwoStateToggleSwitch:actuate(action)
	if action == modeOn then
		if self:getStatus() ~= modeOn then
		logMsg("k")
			command_once(self.tglcmd)
		end
	end
	if action == modeOff then
		if self:getStatus() ~= modeOff then
		logMsg("l")
			command_once(self.tglcmd)
		end
	end
	if action == modeToggle then
			logMsg("m")
		command_once(self.tglcmd)
	end
end

-- set the value
function TwoStateToggleSwitch:setValue(value)
	set_array(self.statusDref,self.statusDrefIdx)
end

return TwoStateToggleSwitch

