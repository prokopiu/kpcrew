-- SimpleProcedureItem: a line in the procedurethat stays always white and has no activities, info text
-- SimpleProcedureItem:new(challengeText)
--   challengeText only text to display full length
require "kpcrew.genutils"

local ProcedureItem = require "kpcrew.procedures.ProcedureItem"

local SimpleProcedureItem = {
}

function SimpleProcedureItem:new(challengeText,skipFunc)

    SimpleProcedureItem.__index = SimpleProcedureItem
    setmetatable(SimpleProcedureItem, {
        __index = ProcedureItem
    })

    local obj = ProcedureItem:new()
    setmetatable(obj, SimpleProcedureItem)

    obj.challengeText = challengeText
    obj.responseText = ""
	obj.actor = ""
	obj.waittime = 0
	obj.color = color_grey
	obj.valid = true
	obj.state = ProcedureItem.stateInitial
	obj.skipFunc = skipFunc
	
    return obj
end

-- nothing spoken with these entries
function SimpleProcedureItem:speakChallenge()
	-- do nothing
end

-- nothing spoken with these items
function SimpleProcedureItem:speakResponse()
	-- do nothing
end

-- color is always white
function SimpleProcedureItem:getColor()
	return self.color
end

-- item is always valid
function SimpleProcedureItem:isValid()
	return true
end

function SimpleProcedureItem:getWaitTime()
	return 0
end

function SimpleProcedureItem:getState()
 	if type(self.skipFunc) == 'function' then
		if self.skipFunc() == true then
			return ProcedureItem.stateSkipped
		end
	end
   return ProcedureItem.stateInitial
end


function SimpleProcedureItem:getStateColor()
	return self.color
end

function SimpleProcedureItem:reset()
    self:setState(ProcedureItem.stateInitial)
	self.valid = true
	self.color = color_grey
end


return SimpleProcedureItem