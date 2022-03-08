-- interface for an CustomAnnunciator
local CustomAnnunciator = {
}

local Annunciator = require "kpcrew.systems.Annunciator"

-- new switch object
function CustomAnnunciator:new(name, funcStatus)

    CustomAnnunciator.__index = CustomAnnunciator
    setmetatable(CustomAnnunciator, {
        __index = Annunciator
    })

    local obj = Annunciator:new(name)
    setmetatable(obj, CustomAnnunciator)

	obj.funcStatus = funcStatus

    return obj
end

-- get name of switch object
function CustomAnnunciator:getName()
    return self.name
end

function CustomAnnunciator:getStatus()
	return self.funcStatus()
end

return CustomAnnunciator