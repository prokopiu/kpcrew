-- Simple Procedure Item to be added to procedures
-- This item only displays text and does not execute or change
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcSimpleProcedureItem = {
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new SimpleProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcSimpleProcedureItem:new(challengeText, skipFunc)
    kcSimpleProcedureItem.__index = kcSimpleProcedureItem
    setmetatable(kcSimpleProcedureItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText, "", "", 0, nil, nil, skipFunc)
    setmetatable(obj, kcSimpleProcedureItem)

	obj.color = color_white
	obj.className = "SimpleProcedureItem"
	
    return obj
end

-- color is always white
function kcSimpleProcedureItem:getStateColor()
	return self.color
end

-- set always white
function kcSimpleProcedureItem:setColor(color)
	self.color = color_white
end

-- item is always valid
function kcSimpleProcedureItem:isValid()
	return true
end

-- return 0 wait time
function kcSimpleProcedureItem:getWaitTime()
	return 0
end

-- state always initial unless skipped
function kcSimpleProcedureItem:getState()
 	if type(self.skipFunc) == 'function' then
		if self.skipFunc() == true then
			return FlowItem.SKIP
		end
	end
   return FlowItem.DONE
end

-- reset the item by hardcoding the values
function kcSimpleProcedureItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = true
	self.color = color_grey
end

-- speak the challenge text
function kcSimpleProcedureItem:speakChallengeText()
	-- do nothing
end

-- no challenge response
function kcSimpleProcedureItem:speakResponseText()
	-- do nothing
end

return kcSimpleProcedureItem