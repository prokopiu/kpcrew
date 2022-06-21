-- Standard checklist Item to be added to procedures
--
-- @classmod ChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcChecklistItem = {
}

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
        __index = kcFlowItem
    })
    local obj = kcFlowItem:new()
    setmetatable(obj, kcChecklistItem)

	obj.challengeText = challengeText
	obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime -- second
	obj.validFunc = validFunc
	obj.responseFunc = responseFunc
	obj.actionFunc = actionFunc
	obj.skipFunc = skipFunc
	obj.className = "ChecklistItem"

    return obj
end

function kcChecklistItem:getStateColor()
	local statecolors = { 
		color_grey, 				-- INIT
		kcFlowItem.colorActive, 	-- RUN
		kcFlowItem.colorPause, 		-- PAUSE
		kcFlowItem.colorFailed,  	-- FAIL
		kcFlowItem.colorSuccess,	-- DONE
		kcFlowItem.colorManual, 	-- SKIP
		kcFlowItem.colorActive 		-- RESUME
	}

	return statecolors[self.state + 1]
end

-- set wait time depending on sound output
function kcChecklistItem:getWaitTime()
	if getActivePrefs():get("general:assistance") < 2 then
		return 0
	else
		if getActivePrefs():get("general:speakChecklist") == true then
			return self.waittime
		else
			return 0
		end
	end
end

-- speak the challenge text
function kcChecklistItem:speakResponseText()
	if getActivePrefs():get("general:assistance") > 1 then
		if getActivePrefs():get("general:speakChecklist") == true then
			kc_speakNoText(0,kc_parse_string(self:getResponseText()))
		end
	end	
end

return kcChecklistItem