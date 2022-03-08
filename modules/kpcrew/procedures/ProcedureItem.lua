-- Standard Procedure Item to be added to procedures
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcProcedureItem = {
	colorInitial = color_green
}

-- Instantiate a new ProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcProcedureItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    kcProcedureItem.__index = kcProcedureItem
	setmetatable(kcProcedureItem, {
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcProcedureItem)

	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.actor = actor
	obj.waittime = waittime
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.skipFunc = skipFunc
	obj.state = kcFlowItem.stateInitial

    return obj
end

function kcProcedureItem:getStateColor()
	local statecolors = { self.colorInitial, self.colorActive, self.colorSuccess, self.colorFailed, self.colorManual, self.colorWhite }
	return statecolors[self.state + 1]
end


return kcProcedureItem