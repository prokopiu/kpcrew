-- Standard checklist Item to be added to procedures
--
-- @classmod ChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcChecklistItem = {
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
function kcChecklistItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    kcChecklistItem.__index = kcChecklistItem
	setmetatable(kcChecklistItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    setmetatable(obj, kcChecklistItem)

	obj.className = "ChecklistItem"

    return obj
end

function kcChecklistItem:getStateColor()
	local statecolors = { 
		color_grey, 			-- INIT
		FlowItem.colorActive, 	-- RUN
		FlowItem.colorPause, 	-- PAUSE
		FlowItem.colorFailed,  	-- FAIL
		FlowItem.colorSuccess,	-- DONE
		FlowItem.colorManual, 	-- SKIP
		FlowItem.colorActive 	-- RESUME
	}

	return statecolors[self.state + 1]
end

-- set wait time depending on sound output
function kcChecklistItem:getWaitTime()
	if getActivePrefs():get("general:assistance") < 2 then
		return 0
	else
		return self.waittime
	end
end

-- speak the challenge text
function kcChecklistItem:speakChallengeText()
	if getActivePrefs():get("general:assistance") > 1 then
		if not self:isUserRole() or self:getActor()	== FlowItem.actorBOTH then
			if self:isValid() then
				kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. ".    " .. self:getResponseText()))
			else
				kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. ". Please check! Should be ".. self:getResponseText()))
			end
		else
			kc_speakNoText(0,kc_parse_string(self:getChallengeText()))
		end
	end	
end

return kcChecklistItem