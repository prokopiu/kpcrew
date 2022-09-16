-- switch with mode on/off and toggle function via command

-- @classmod TwoStateCmdSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khTwoStateCmdSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, commands for on, off and toggle. use "nocommand" if no tgl cmd
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @tparam string oncmd command to turn element on
-- @tparam string offcmd command to turn element of
-- @tparam string tglcmd command to toggle element status on/off
-- @treturn Switch the created base element
function khTwoStateCmdSwitch:new(name, statusDref, statusDrefIdx, oncmd, offcmd, tglcmd)

    khTwoStateCmdSwitch.__index = khTwoStateCmdSwitch
    setmetatable(khTwoStateCmdSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name, statusDref, statusDrefIdx)
    setmetatable(obj, khTwoStateCmdSwitch)

	obj.oncmd = oncmd
	obj.offcmd = offcmd
	obj.tglcmd = tglcmd
	
    return obj
end

-- actuate the switch with given mode
-- @tparam int action code (modeOn, modeOff, modeToggle [0,1,2])
function khTwoStateCmdSwitch:actuate(action)
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

return khTwoStateCmdSwitch

