-- switch with mode on/off and toggle function via command
local TwoStateCmdSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
function TwoStateCmdSwitch:new(name, statusDref, statusDrefIdx, oncmd, offcmd, tglcmd)

    TwoStateCmdSwitch.__index = TwoStateCmdSwitch
    setmetatable(TwoStateCmdSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, TwoStateCmdSwitch)

	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx
	obj.oncmd = oncmd
	obj.offcmd = offcmd
	obj.tglcmd = tglcmd
	
    return obj
end

-- return value of status dataref
function TwoStateCmdSwitch:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

-- actuate the switch with given mode
function TwoStateCmdSwitch:actuate(action)
	if action == modeOn then
		command_once(self.oncmd)
	end
	if action == modeOff then
		command_once(self.offcmd)
	end
	if action == modeToggle then
		if self.tglcmd ~= "nocommand" then
			command_once(self.tglcmd)
		else
			if self:getStatus() ~= modeOff then
				command_once(self.offcmd)
			else
				command_once(self.oncmd)
			end
		end
	end
end

return TwoStateCmdSwitch

