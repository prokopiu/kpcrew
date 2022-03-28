-- Simple Procedure Item to be added to procedures
-- This item only displays text and does not execute or change
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcSimpleProcedureItem = {
}

-- Instantiate a new SimpleProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcSimpleProcedureItem:new(challengeText, skipFunc)
    kcSimpleProcedureItem.__index = kcSimpleProcedureItem
    setmetatable(kcSimpleProcedureItem, {
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcSimpleProcedureItem)

    obj.challengeText = challengeText
    obj.responseText = ""
	obj.actor = ""
	obj.waittime = 0
	obj.color = color_white
	obj.valid = true
	obj.skipFunc = skipFunc
	obj.className = "SimpleProcedureItem"
	
    return obj
end

function kcSimpleProcedureItem:getClassName()
	return self.className
end

-- color is always white
function kcFlowItem:getStateColor()
	return self.color
end

-- item is always valid
function kcSimpleProcedureItem:isValid()
	return true
end

-- rteurn 0 wait time
function kcSimpleProcedureItem:getWaitTime()
	return 0
end

-- state always initial unless skipped
function kcSimpleProcedureItem:getState()
 	if type(self.skipFunc) == 'function' then
		if self.skipFunc() == true then
			return kcFlowItem.stateSkipped
		end
	end
   return kcFlowItem.stateInitial
end

-- reset the item by hardcoding the values
function kcSimpleProcedureItem:reset()
    self:setState(kcFlowItem.stateInitial)
	self.valid = true
	self.color = color_grey
end

return kcSimpleProcedureItem