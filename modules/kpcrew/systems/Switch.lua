-- interface for a switch object used in systems
local Switch = {
	modeOn = 1,
	modeOff = 0,
	modeToggle = 2
}

local utils = require "kpcrew.genutils"

-- new switch object
function Switch:new(name)
    Switch.__index = Switch

    local obj = {}
    setmetatable(obj, Switch)

    obj.name = name

    return obj
end

-- get name of switch object
function Switch:getName()
    return self.name
end

-- execute a switch action
function Switch:actuate(action)
end

function Switch:getStatus()
	return 0
end

return Switch