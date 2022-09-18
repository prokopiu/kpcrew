-- Checklist with checklist items
-- A checklist registers a number of cheklist challenge/response items
--
-- @classmod Checklist
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcChecklist = {
}

local Flow				= require "kpcrew.Flow"

-- Instantiate a new Checklist
-- @tparam string name Name of the set (also used as title)
function kcChecklist:new(name, speakname, finalstatement)
    kcChecklist.__index = kcChecklist
    setmetatable(kcChecklist, {
        __index = Flow
    })
    local obj = Flow:new(name, speakname, finalStatement)
    setmetatable(obj, kcChecklist)

	obj.className = "Checklist"

    return obj
end

return kcChecklist
