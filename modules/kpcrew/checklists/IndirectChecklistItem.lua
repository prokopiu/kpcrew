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

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new IndirectChecklistItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcIndirectChecklistItem:new(challengeText,responseText,actor,waittime,procvar,validFunc,actionFunc,skipFunc)
    kcIndirectChecklistItem.__index = kcIndirectChecklistItem
    setmetatable(kcIndirectChecklistItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    setmetatable(obj, kcIndirectChecklistItem)

	obj.valid = true
	obj.color = color_orange
	obj.procvar = procvar

	obj.className = "IndirectChecklistItem"

	obj.conditionMet = false  -- if condition was met set to true

	kc_global_procvars:add(kcPreference:new(procvar,false,kcPreference.typeToggle,procvar .. "|TRUE|FALSE"))

    return obj
end

-- get checklist specific state color
function kcIndirectChecklistItem:getStateColor()
	local statecolors = { 
		FlowItem.colorInitial,	-- INIT 
		FlowItem.colorActive,   -- RUN
		FlowItem.colorPause,    -- PAUSE
		FlowItem.colorFailed,   -- FAIL
		FlowItem.colorSuccess,  -- DONE
		FlowItem.colorManual,   -- SKIP
		FlowItem.colorActive	-- RESUME 
	}

	return statecolors[self.state + 1]
end

-- reset an indirect checklist item
function kcIndirectChecklistItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = true
	self.color = color_orange

	self.conditionMet = false
	local procvar = getBckVars():find("procvars:" .. self.procvar)
	if procvar ~= nil then
		procvar:setValue(false)
	end
end

-- check validity and set procvar accordingly
function kcIndirectChecklistItem:isValid()
	local procvar = getBckVars():find("procvars:" .. self.procvar)
	if procvar ~= nil then
		if type(self.validFunc) == 'function' then
			if procvar:getValue() == false then
				procvar:setValue(self.validFunc(self))
			end
		end
	else
		return false
	end
	return procvar:getValue()	
end

-- set wait time depending on sound output
function kcIndirectChecklistItem:getWaitTime()
	if getActivePrefs():get("general:assistance") < 2 then
		return 0
	else
		return self.waittime
	end
end

-- speak the challenge text
function kcIndirectChecklistItem:speakChallengeText()
	if getActivePrefs():get("general:assistance") > 1 then
		if not self:isUserRole() or self:getActor()	== FlowItem.actorBOTH then
			if self:isValid() then
				kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. "    " .. self:getResponseText()))
			else
				kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. ". Please check! Should be ".. self:getResponseText()))
			end
		else
			kc_speakNoText(0,kc_parse_string(self:getChallengeText()))
		end
	end	
end

-- speak the challenge text
function kcIndirectChecklistItem:speakResponseText()
-- do nothing
end

return kcIndirectChecklistItem