-- Element which toggles between on and off via a single command

-- @classmod TwoStateToggleSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khTwoStateToggleSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- Constructor for toggle switch
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @tparam string tglcmd command string for toggle command in XP
-- @treturn Switch the created base element
function khTwoStateToggleSwitch:new(name, statusDref, statusDrefIdx, tglcmd)

    khTwoStateToggleSwitch.__index = khTwoStateToggleSwitch
    setmetatable(khTwoStateToggleSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name,statusDref,statusDrefIdx)
    setmetatable(obj, khTwoStateToggleSwitch)

	obj.tglcmd = tglcmd
	
    return obj
end

-- execute a switch action on, off or togle between the states on and off
-- @tparam int action code (modeOn, modeOff, modeToggle [0,1,2])
function khTwoStateToggleSwitch:actuate(action)
	if action == modeOn then
		if self:getStatus() ~= modeOn then
			command_once(self.tglcmd)
		end
	end
	if action == modeOff then
		if self:getStatus() ~= modeOff then
			command_once(self.tglcmd)
		end
	end
	if action == modeToggle then
		command_once(self.tglcmd)
	end
end

return khTwoStateToggleSwitch

