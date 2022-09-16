-- interface for an Annunciator
--
-- @classmod Annunciator
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khAnnunciator = {
}

-- Base constructor for any annunciator
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref (set -1 if only accessible via dateref_array to reach [0])
-- @treturn Annunciator the created base element
function khAnnunciator:new(name, statusDref, statusDrefIdx)
    khAnnunciator.__index = khAnnunciator

    local obj = {}
    setmetatable(obj, khAnnunciator)

    obj.name = name
	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx

    return obj
end

-- Get name of switch object
-- @treturn string name of element
function khAnnunciator:getName()
    return self.name
end

-- return the current element dataref value
-- @treturn <type> dataref value
function khAnnunciator:getStatus()
	-- if index = 0 then it is a single dataref, pull with get
	if self.statusDrefIdx == 0 then
		return get(self.statusDref)
	end
	-- if the index is -1 then pull as array element index [0]
	-- otherwise pull as array element with given index
	if self.statusDrefIdx < 0 then
		return get(self.statusDref,0)
	else
		return get(self.statusDref,self.statusDrefIdx)
	end
end

return khAnnunciator