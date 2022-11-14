-- Standard Procedure Item to be added to procedures
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcProcedureItem = {
}

local FlowItem 			= require "kpcrew.FlowItem"

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
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    setmetatable(obj, kcProcedureItem)

	obj.state = FlowItem.INIT

	obj.className = "ProcedureItem"

    return obj
end

-- more refined wait time only when assistance mode and voice output is needed
function kcProcedureItem:getWaitTime()
	return self.waittime
end

-- speak the challenge text which is a combination of both
function kcProcedureItem:speakChallengeText()
	-- if getActivePrefs():get("general:assistance") > 1 then
		-- if getActivePrefs():get("general:speakProcedure") == true then
			-- kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. ": " .. self:getResponseText()))
		-- end
	-- end
end

-- no challenge response
function kcProcedureItem:speakResponseText()
	-- do nothing
end

-- execute the automation function if available
function kcProcedureItem:execute()
	if getActivePrefs():get("general:assistance") > 2 then
		if (getActivePrefs():get("general:assistance") == 3 and self:isUserRole() == false) 
			or getActivePrefs():get("general:assistance") > 3 then
			if type(self.actionFunc) == 'function' then
				self.actionFunc()
			end
		end
	end
end

return kcProcedureItem