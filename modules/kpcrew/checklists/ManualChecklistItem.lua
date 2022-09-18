-- "Manual" Checklist Item to be added to procedures
-- This covers anything which can not be checked / set by the sim but requires master button action
--
-- @classmod ManualChecklistItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcManualChecklistItem = {
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new ManualChecklistItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcManualChecklistItem:new(challengeText,responseText,actor,waittime,procvar,validFunc,actionFunc,skipFunc)
    kcManualChecklistItem.__index = kcManualChecklistItem
    setmetatable(kcManualChecklistItem, {
        __index = FlowItem
    })

    local obj = FlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    setmetatable(obj, kcManualChecklistItem)

	obj.valid = true
	obj.procvar = procvar

	obj.className = "ManualChecklistItem"

	obj.conditionMet = false  -- if condition was met set to true

	kc_global_procvars:add(kcPreference:new(procvar,false,kcPreference.typeToggle,procvar .. "|TRUE|FALSE"))

    return obj
end

-- override state colors
function kcManualChecklistItem:getStateColor()
	local statecolors = { 
		FlowItem.colorInitial,	-- INIT 
		FlowItem.colorActive,   -- RUN
		FlowItem.colorPause,    -- PAUSE
		color_orange,		    -- FAIL
		FlowItem.colorSuccess,  -- DONE
		FlowItem.colorManual,   -- SKIP
		FlowItem.colorActive	-- RESUME 
	}

	return statecolors[self.state + 1]
end

-- override valid detection
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

-- Override execute
function kcManualChecklistItem:execute()
	local proc_var = getBckVars():find("procvars:" .. self.procvar)
	proc_var:setValue(true)
end

-- Override reset
function kcManualChecklistItem:reset()
    self:setState(FlowItem.INIT)
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