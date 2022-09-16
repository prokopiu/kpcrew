-- interface for an Custom Annunciator with scripting

-- @classmod CustomAnnunciator
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khCustomAnnunciator = {
}

local Annunciator = require "kpcrew.systems.Annunciator"

-- new switch object
-- Constructor for custom scroipt annunciator
-- @tparam string name of element
-- @tparam function logic for setting annunciator 1 or 0
-- @treturn Annunciator the created base element
function khCustomAnnunciator:new(name, funcStatus)

    khCustomAnnunciator.__index = khCustomAnnunciator
    setmetatable(khCustomAnnunciator, {
        __index = Annunciator
    })

    local obj = Annunciator:new(name, "", 0)
    setmetatable(obj, khCustomAnnunciator)

	obj.funcStatus = funcStatus

    return obj
end

-- return custom status
-- @treturn <type> status value
function khCustomAnnunciator:getStatus()
	return self.funcStatus()
end

return khCustomAnnunciator