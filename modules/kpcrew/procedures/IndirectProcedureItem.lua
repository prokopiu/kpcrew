-- "Indirect" Procedure Item to be added to procedures
-- An indirect item cannot be verified directly but waits for some actions to happen (in future by background proc)
-- only when the action has happened will it turn to green
--
-- @classmod IndirectProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcIndirectProcedureItem = {
	colorFailed = color_orange
}

-- Instantiate a new IndirectProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcIndirectProcedureItem:new(challengeText,responseText,actor,waittime,procvar,validFunc,actionFunc,skipFunc)
    kcIndirectProcedureItem.__index = kcIndirectProcedureItem
    setmetatable(kcIndirectProcedureItem, {
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcIndirectProcedureItem)

	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true
	obj.color = color_orange
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.responseFunc = responseFunc
	obj.skipFunc = skipFunc
	obj.procvar = procvar

	obj.conditionMet = false  -- if condition was met set to true
	obj.className = "IndirectProcedureItem"

    return obj
end

function kcIndirectProcedureItem:getClassName()
	return self.className
end

-- return the color code linked to the state (varied from standard)
function kcIndirectProcedureItem:getStateColor()
	local statecolors = { kcFlowItem.colorInitial, kcFlowItem.colorActive, kcFlowItem.colorSuccess, color_orange, kcFlowItem.colorManual }
	return statecolors[self.state + 1]
end

-- reset the item to its initial state
function kcIndirectProcedureItem:reset()
    self:setState(kcFlowItem.stateInitial)
	self.valid = true
	self.color = color_orange

	self.conditionMet = false
end

-- are the conditions for this item met?
function kcIndirectProcedureItem:isValid()
	local procvar = getBckVars():find("procvars:" .. self.procvar)
	if procvar ~= nil then
		if type(self.validFunc) == 'function' then
			if procvar:getValue() == false then
				if self.validFunc(self) then
					procvar:setValue(true)
				end
			end
		end
	else
		return false
	end
	return procvar:getValue()
end

return kcIndirectProcedureItem