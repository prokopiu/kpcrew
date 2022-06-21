-- "Manual" Checklist Item to be added to procedures
-- This covers anything which can not be checked / set by the sim but requires master button action
--
-- @classmod ManualChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcManualChecklistItem = {
}

function kcManualChecklistItem:new(challengeText,responseText,actor,waittime,procvar,validFunc,actionFunc,skipFunc)

    kcManualChecklistItem.__index = kcManualChecklistItem
    setmetatable(kcManualChecklistItem, {
        __index = kcFlowItem
    })

    local obj = kcFlowItem:new()
    setmetatable(obj, kcManualChecklistItem)

	obj.challengeText = challengeText
	obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime -- second
	obj.valid = true
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.responseFunc = responseFunc
	obj.skipFunc = skipFunc
	obj.procvar = procvar

	obj.className = "ManualChecklistItem"

	obj.conditionMet = false  -- if condition was met set to true

	kc_global_procvars:add(kcPreference:new(procvar,false,kcPreference.typeToggle,procvar .. "|TRUE|FALSE"))

    return obj
end

function kcManualChecklistItem:getStateColor()
	local statecolors = { 
		kcFlowItem.colorInitial,	-- INIT 
		kcFlowItem.colorActive,     -- RUN
		kcFlowItem.colorPause,      -- PAUSE
		color_orange,		    	-- FAIL
		kcFlowItem.colorSuccess,    -- DONE
		kcFlowItem.colorManual,     -- SKIP
		kcFlowItem.colorActive	    -- RESUME 
	}

	return statecolors[self.state + 1]
end

function kcManualChecklistItem:isValid()
	if activePrefSet:get("general:assistance") < 2 then 
		return true
	else
		local proc_var = getBckVars():find("procvars:" .. self.procvar)
		if proc_var ~= nil then
			return proc_var:getValue()
		else
			return true
		end
	end
end

function kcManualChecklistItem:execute()
	local proc_var = getBckVars():find("procvars:" .. self.procvar)
	proc_var:setValue(true)
end

function kcManualChecklistItem:reset()
    self:setState(kcFlowItem.INIT)
	self.valid = true

	self.conditionMet = false
	local procvar = getBckVars():find("procvars:" .. self.procvar)
	if procvar ~= nil then
		procvar:setValue(false)
	end
end	

-- set wait time depending on sound output
function kcManualChecklistItem:getWaitTime()
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
function kcManualChecklistItem:speakResponseText()
	if getActivePrefs():get("general:assistance") > 1 then
		if getActivePrefs():get("general:speakChecklist") == true then
			kc_speakNoText(0,kc_parse_string(self:getResponseText()))
		end
	end	
end

return kcManualChecklistItem