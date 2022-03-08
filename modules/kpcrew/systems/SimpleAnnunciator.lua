-- interface for an Annunciator
local SimpleAnnunciator = {
}

local Annunciator = require "kpcrew.systems.Annunciator"

-- new switch object
function SimpleAnnunciator:new(name, statusDref, statusDrefIdx)

    SimpleAnnunciator.__index = SimpleAnnunciator
    setmetatable(SimpleAnnunciator, {
        __index = Annunciator
    })

    local obj = Annunciator:new(name)
    setmetatable(obj, SimpleAnnunciator)

	obj.statusDref = statusDref
	obj.statusDrefIdx = statusDrefIdx

    return obj
end

-- get name of switch object
function SimpleAnnunciator:getName()
    return self.name
end

function SimpleAnnunciator:getStatus()
	return get(self.statusDref,self.statusDrefIdx)
end

return SimpleAnnunciator