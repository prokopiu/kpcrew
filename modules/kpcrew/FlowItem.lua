-- Standard Flow Item to be added to procedures or checklists
--
-- @classmod FlowItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcFlowItem = {
    INIT		 		= 0,
	RUN					= 1,
    PAUSE			 	= 2,
    FAIL		 		= 3,
    DONE		 		= 4,
	SKIP				= 5,
	RESUME				= 6,
	
	states = { "INIT", "RUN", "PAUSE", "FAIL", "DONE", "SKIP", "RESUME" }, 

	actorPF 			= "PF",		-- pilot flying (you)
	actorPNF 			= "PNF",	-- pilot not flying (virtual)
	actorPM 			= "PM",		-- pilot monitoring (virtual)
	actorBOTH 			= "BOTH",	-- both have responses
	actorFO 			= "F/O",	-- first officer (virtual)
	actorCPT 			= "CPT",	-- captain (you)
	actorLHS 			= "LHS",	-- left hand seat (you)
	actorRHS 			= "RHS",	-- right hand seat (virtual)
	actorFE				= "FE",		-- flight engineer on some aircraft (virtual)
	actorALL 			= "ALL",
	actorNONE 			= "",

	colorInitial		= color_grey,
	colorActive 		= color_white,
	colorPause			= color_orange,
	colorFailed 		= color_red,
	colorSuccess		= color_green,
	colorSkipped		= color_white,
	colorManual			= color_dark_green
}

-- Instantiate a new FlowItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
-- @treturn local object
function kcFlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    kcFlowItem.__index = kcFlowItem
    local obj = {}
    setmetatable(obj, kcFlowItem)

	obj.state = self.INIT
	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.origResponseText = responseText
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true
	obj.color = self.colorInitial
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.skipFunc = skipFunc

	obj.className = "FlowItem"

    return obj
end

-- return the type of flow for distinction later
-- @treturn string "Flow" or "Procedure" or "Checklist"
function kcFlowItem:getClassName()
	return self.className
end

-- return true if the actor for the item is the sim pilot
-- @treturn boolean true = is the user's role as CPT,PF,LHS
function kcFlowItem:isUserRole()
	local userroles = {	self.actorPF, self.actorCPT, self.actorLHS, self.actorBOTH }
	return kc_hasValue(userroles, self.actor)
end	
	
-- get the actor string for this checklist item
-- @treturn string role name
function kcFlowItem:getActor()
	return self.actor
end

-- get the left hand action text for the item
-- @treturn string challenge text
function kcFlowItem:getChallengeText()
	if self.challengeText == nil then
		return ""
	else
		return self.challengeText
	end
end

-- set left hand action text
-- @tparam string text challenge text
function kcFlowItem:setChallengeText(text)
	self.challengeText = text
end

-- speak the challenge text
function kcFlowItem:speakChallengeText()
    kc_speakNoText(0,kc_parse_string(self.challengeText))
end

-- get the right hand result text for the item
function kcFlowItem:getResponseText()
	if string.find(self.responseText,"%%") == nil then
		return self.responseText
	else
		if string.find(self.responseText,"|") == nil then
			return self.responseText
		else
			local resArr = kc_split(self.responseText,"|")
			kcLoadString = "return string.format(\"" .. resArr[1] .. "\""
			if table.getn(resArr) > 1 then kcLoadString = kcLoadString .. "," .. resArr[2] end
			if table.getn(resArr) > 2 then kcLoadString = kcLoadString .. "," .. resArr[3] end
			if table.getn(resArr) > 3 then kcLoadString = kcLoadString .. "," .. resArr[4] end
			kcLoadString = kcLoadString .. ")"
			local resStr = loadstring(kcLoadString)
			return resStr()
		end
	end
end

-- speak the response text
function kcFlowItem:speakResponseText()
	kc_speakNoText(0,kc_parse_string(self:getResponseText()))
end

-- set the right hand result text for the item
-- @tparam string text response text
function kcFlowItem:setResponseText(text)
	self.responseText = text
end

-- get the time in seconds this item is to be waited on
-- @treturn int seconds
function kcFlowItem:getWaitTime()
	return self.waittime
end

-- set the wait time in seconds
-- @tparam int number of seconds
function kcFlowItem:setWaitTime(seconds)
	self.waittime = seconds
end

-- change the state of the checklist item
-- @tparam int state id
function kcFlowItem:setState(state)
    self.state = state
end

-- get the current state of this checklist item
-- @treturn int get state id
function kcFlowItem:getState()
	if type(self.skipFunc) == 'function' then
		if self.skipFunc() then
			return self.SKIP
		end
	end
    return self.state
end

-- get current color of the procedure item
-- @treturn int color code
function kcFlowItem:getColor()
	return self.color
end

-- set the color of the checklist item
-- @tparam int color code
function kcFlowItem:setColor(color)
	self.color = color
end

-- return the color code linked to the state
-- @treturn int matching color code for item
function kcFlowItem:getStateColor()
	local statecolors = { 
		self.colorInitial,	-- INIT 
		self.colorActive,   -- RUN
		self.colorPause,    -- PAUSE
		self.colorFailed,   -- FAIL
		self.colorSuccess,  -- DONE
		self.colorManual,   -- SKIP
		self.colorActive	-- RESUME 
	}
	return statecolors[self.state + 1]
end

-- reset the item to its initial state
function kcFlowItem:reset()
    self:setState(self.INIT)
	self.valid = true
	self:setColor(self.colorInitial)
end

-- are the conditions for this item met?
-- @treturn boolean true = valid
function kcFlowItem:isValid()
	if type(self.validFunc) == 'function' then
		self.valid = self.validFunc(self)
	end
    return self.valid
end

-- execute the automation function if available
function kcFlowItem:execute()
	if activePrefSet:get("general:assistance") > 2 then
		if (activePrefSet:get("general:assistance") == 3 and self:isUserRole() == false) or activePrefSet:get("general:assistance") == 4 then
			if type(self.actionFunc) == 'function' then
				self.actionFunc()
			end
		end
	end
end
	
-- return the visual line to put in the checklist displays
function kcFlowItem:getLine(lineLength)
	local line = {}
	local unparsedChallengeText = kc_unparse_string(self.challengeText)
	local unparsedResponseText = kc_unparse_string(self:getResponseText())
	local dots = lineLength - string.len(unparsedChallengeText) - string.len(unparsedResponseText) - 7
	line[#line + 1] = unparsedChallengeText
	local dotchar = "."
	if unparsedResponseText == "" then
		dotchar = " "
	end
	for i=0,dots-1,1 do
		line[#line + 1] = dotchar
	end
	line[#line + 1] = unparsedResponseText
	if self.actor ~= "" then
		line[#line + 1] = " ("
		line[#line + 1] = self.actor
		line[#line + 1] = ")"
	end
	
	return table.concat(line)
end

return kcFlowItem