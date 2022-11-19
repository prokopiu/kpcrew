-- Procedure of setting a state
--
-- @classmod State
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcState = {
}

local Flow				= require "kpcrew.Flow"

-- Instantiate a new State
-- @tparam string name Name of the set (also used as title)
function kcState:new(name, speakname, finalstatement)
    kcState.__index = kcState
   setmetatable(kcState, {
        __index = Flow
    })
    local obj = Flow:new(name, speakname, finalStatement)
    setmetatable(obj, kcState)

	obj.className = "State"
	obj.finalStatement = finalstatement
	obj.spokenName = speakname

    return obj
end

return kcState