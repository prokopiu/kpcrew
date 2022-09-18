-- Procedure of activities during a specific phase of flight
-- A procedure registers a number of activities/tasks to be executed and checked
--
-- @classmod Procedure
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcProcedure = {
}

local Flow				= require "kpcrew.Flow"

-- Instantiate a new Procedure
-- @tparam string name Name of the set (also used as title)
function kcProcedure:new(name, speakname, finalstatement)
    kcProcedure.__index = kcProcedure
   setmetatable(kcProcedure, {
        __index = Flow
    })
    local obj = Flow:new(name, speakname, finalStatement)
    setmetatable(obj, kcProcedure)

	obj.className = "Procedure"

    return obj
end

return kcProcedure