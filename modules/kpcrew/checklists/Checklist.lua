-- Checklist with checklist items
-- A checklist registers a number of cheklist challenge/response items
--
-- @classmod Checklist
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcChecklist = {
}

-- Instantiate a new Checklist
-- @tparam string name Name of the set (also used as title)
function kcChecklist:new(name, speakname, finalstatement)
    kcChecklist.__index = kcChecklist
    setmetatable(kcChecklist, {
        __index = kcFlow
    })
    local obj = kcFlow:new()
    setmetatable(obj, kcChecklist)

    obj.name = name
	obj.spokenName = speakname
	obj.finalStatement = finalstatement
	obj.className = "Checklist"

    return obj
end

return kcChecklist
