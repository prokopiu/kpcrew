-- simple annunciator on/off

-- @classmod SimpleAnnunciator
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khSimpleAnnunciator = {
}

local Annunciator = require "kpcrew.systems.Annunciator"

-- Constructor for on off annunciator
-- @tparam string name of element
-- @tparam string dataref for elements status
-- @tparam int index of element dataref (set -1 if only accessible via dateref_array to reach [0])
-- @treturn Annunciator the created base element
function khSimpleAnnunciator:new(name, statusDref, statusDrefIdx)

    khSimpleAnnunciator.__index = khSimpleAnnunciator
    setmetatable(khSimpleAnnunciator, {
        __index = Annunciator
    })

    local obj = Annunciator:new(name, statusDref, statusDrefIdx)
    setmetatable(obj, khSimpleAnnunciator)

    return obj
end

return khSimpleAnnunciator