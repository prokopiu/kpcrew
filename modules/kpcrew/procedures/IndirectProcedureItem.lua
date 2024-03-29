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

local FlowItem 			= require "kpcrew.FlowItem"

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
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    setmetatable(obj, kcIndirectProcedureItem)

	obj.valid = true
	obj.color = color_orange
	obj.procvar = procvar

	obj.conditionMet = false  -- if condition was met set to true
	obj.className = "IndirectProcedureItem"
	
	kc_global_procvars:add(kcPreference:new(procvar,false,kcPreference.typeToggle,procvar .. "|TRUE|FALSE"))

    return obj
end

-- reset the item to its initial state
function kcIndirectProcedureItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = true
	self.color = color_orange

	self.conditionMet = false
	local procvar = getBckVars():find("procvars:" .. self.procvar)
	if procvar ~= nil then
		procvar:setValue(false)
	end
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

-- speak the challenge text
function kcIndirectProcedureItem:speakChallengeText()
	-- if getActivePrefs():get("general:assistance") > 1 then
		-- if getActivePrefs():get("general:speakProcedure") == true then
			-- kc_speakNoText(0,kc_parse_string(self:getChallengeText() .. ": " .. self:getResponseText()))
		-- end
	-- end
end

-- no challenge response
function kcIndirectProcedureItem:speakResponseText()
	-- do nothing
end

return kcIndirectProcedureItem