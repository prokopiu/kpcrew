-- Simple Checklist Item to be added to checklist
-- This item only displays text and does not execute or change
--
-- @classmod SimpleChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcSimpleChecklistItem = {
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new SimpleProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcSimpleChecklistItem:new(challengeText, skipFunc)
    kcSimpleChecklistItem.__index = kcSimpleChecklistItem
    setmetatable(kcSimpleChecklistItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,"","",0,nil,nil,skipFunc)
    setmetatable(obj, kcSimpleChecklistItem)

	obj.color = color_white
	obj.valid = true
	obj.skipFunc = skipFunc

	obj.className = "SimpleChecklistItem"
	
    return obj
end

-- item is always valid
function kcSimpleChecklistItem:isValid()
	return true
end

-- wait time is always 0
function kcSimpleChecklistItem:getWaitTime()
	return 0
end

-- adapted states
function kcSimpleChecklistItem:getState()
 	if type(self.skipFunc) == 'function' then
		if self.skipFunc() == true then
			return FlowItem.SKIP
		end
	end
   return FlowItem.INIT
end

-- always return white
function kcSimpleChecklistItem:getStateColor()
	return color_white
end

-- adapted reset
function kcSimpleChecklistItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = true
	self.color = color_white
end

-- speak the challenge text
function kcSimpleChecklistItem:speakChallengeText()
	-- do nothing
end

-- no challenge response
function kcSimpleChecklistItem:speakResponseText()
	-- do nothing
end

return kcSimpleChecklistItem