-- "Indirect" Checklist Item to be added to procedures
-- An indirect item cannot be verified directly but waits for some actions to happen (in future by background proc)
-- only when the action has happened will it turn to green
--
-- @classmod IndirectChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcIndirectChecklistItem = {
	colorFailed 		= color_orange
}

-- Instantiate a new IndirectProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  responseFunc will overwrite the responseText with simulator values
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcIndirectChecklistItem:new(challengeText,responseText,actor,waittime,validFunc,responseFunc,actionFunc,skipFunc)
    kcIndirectChecklistItem.__index = kcIndirectChecklistItem
    setmetatable(kcIndirectChecklistItem, {
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcIndirectChecklistItem)

	obj.challengeText = challengeText
	obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime -- second
	obj.valid = true
	obj.color = color_orange
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.responseFunc = responseFunc
	obj.skipFunc = skipFunc

	obj.conditionMet = false  -- if condition was met set to true

    return obj
end

function kcIndirectChecklistItem:getStateColor()
	local statecolors = { kcFlowItem.colorInitial, kcFlowItem.colorActive, kcFlowItem.colorSuccess, color_orange, kcFlowItem.colorSkipped }
	return statecolors[self.state + 1]
end

function kcIndirectChecklistItem:reset()
    self:setState(kcFlowItem.stateInitial)
	self.valid = true
	self.color = color_orange
end

function kcIndirectChecklistItem:isValid()
	if type(self.validFunc) == 'function' then
		if self.conditionMet == false then
			if self.validFunc(self) then
				self.conditionMet = true
			end
		end
	end
    return self.conditionMet
end

return kcIndirectChecklistItem