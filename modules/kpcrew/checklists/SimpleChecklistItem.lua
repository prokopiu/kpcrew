-- Simple Checklist Item to be added to checklist
-- This item only displays text and does not execute or change
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcSimpleChecklistItem = {
}

-- Instantiate a new SimpleProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcSimpleChecklistItem:new(challengeText, skipFunc)
    kcSimpleChecklistItem.__index = kcSimpleChecklistItem
    setmetatable(kcSimpleChecklistItem, {
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcSimpleChecklistItem)

    obj.challengeText = challengeText
    obj.responseText = ""
	obj.actor = ""
	obj.waittime = 0
	obj.color = color_white
	obj.valid = true
	obj.skipFunc = skipFunc
	obj.className = "SimpleChecklistItem"
	
    return obj
end

-- function kcSimpleChecklistItem:getClassName()
	-- return self.className
-- end

-- item is always valid
function kcSimpleChecklistItem:isValid()
	return true
end

function kcSimpleChecklistItem:getWaitTime()
	return 0
end

function kcSimpleChecklistItem:getState()
 	if type(self.skipFunc) == 'function' then
		if self.skipFunc() == true then
			return kcFlowItem.SKIP
		end
	end
   return kcFlowItem.INIT
end

function kcSimpleChecklistItem:getStateColor()
	return color_white
end

function kcSimpleChecklistItem:reset()
    self:setState(kcFlowItem.INIT)
	self.valid = true
	self.color = color_white
end

return kcSimpleChecklistItem