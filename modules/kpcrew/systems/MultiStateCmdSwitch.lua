-- switch with mode on/off and toggle function via command
local MultiStateCmdSwitch = {}

utils = require "kpcrew.genutils"
Switch = require "kpcrew.systems.Switch"

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
	
    return obj
end

-- return value of status dataref
function MultiStateCmdSwitch:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

-- actuate the switch with given mode
function MultiStateCmdSwitch:actuate(action)
	if action == Switch.increase then
		command_once(self.incrcmd)
	end
	if action == Switch.decrease then
		command_once(self.decrcmd)
	end
end

return MultiStateCmdSwitch

