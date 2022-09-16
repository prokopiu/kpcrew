-- Begin pressing the button (via command) end end when stop has been given

-- @classmod khKeepPressedSwitchCmd
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khKeepPressedSwitchCmd = {}

local Switch = require "kpcrew.systems.Switch"

-- Constructor for toggle switch
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @tparam string cmd command string to execute
-- @treturn Switch the created base element
function khKeepPressedSwitchCmd:new(name, statusDref, statusDrefIdx, cmd)

    khKeepPressedSwitchCmd.__index = khKeepPressedSwitchCmd
    setmetatable(khKeepPressedSwitchCmd, {
        __index = Switch
    })

    local obj = Switch:new(name,statusDref,statusDrefIdx)
    setmetatable(obj, khKeepPressedSwitchCmd)

	obj.cmd = cmd
	
    return obj
end

-- actuate and hold knob until stopped with repeatOff
function khKeepPressedSwitchCmd:repeatOn()
	command_begin(self.cmd)
end

-- stop the repeat action
function khKeepPressedSwitchCmd:repeatOff()
	command_end(self.cmd)
end

return khKeepPressedSwitchCmd

