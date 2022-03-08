-- interface for an Annunciator
local Annunciator = {
}

-- new switch object
function Annunciator:new(name)
    Annunciator.__index = Annunciator

    local obj = {}
    setmetatable(obj, Annunciator)

    obj.name = name

    return obj
end

-- get name of switch object
function Annunciator:getName()
    return self.name
end

function Annunciator:getStatus()
	return 0
end

return Annunciator