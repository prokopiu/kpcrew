-- ProcedureItem: base class for a step in a procedure as part of a SOP
-- ProcedureItem:new(challengeText, responseText, actor, time, validFunc, responseFunc)
--   challengeText is the left hand text 
--   responseText is specific state of the item
--   actor is the actor for the item; see list below
--   validFunc shall return true or false to verify if condition is met
--   responseFunc will overwrite the responseText with simulator values
require "kpcrew.genutils"

local ProcedureItem = {
    stateInitial 		= 0,
    stateInProgress 	= 1,
    stateSuccess 		= 2,
    stateFailed 		= 3,
    stateDoneManually 	= 4,
	actorPF 			= "PF",		-- pilot flying (you)
	actorPNF 			= "PNF",	-- pilot not flying (virtual)
	actorPM 			= "PM",		-- pilot monitoring (virtual)
	actorBOTH 			= "BOTH",	-- both have responses
	actorFO 			= "F/O",	-- first officer (virtual)
	actorCPT 			= "CPT",	-- captain (you)
	actorLHS 			= "LHS",	-- left hand seat (you)
	actorRHS 			= "RHS",	-- right hand seat (virtual)
	actorFE				= "FE",		-- flight engineer on some aircraft (virtual)
	actorNONE 			= "",
	colorInitial		= color_grey,
	colorActive 		= color_white,
	colorSuccess		= color_green,
	colorFailed 		= color_red,
	colorManual			= color_dark_green
}


function ProcedureItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,responseFunc)
    ProcedureItem.__index = ProcedureItem

    local obj = {}
    setmetatable(obj, ProcedureItem)

	obj.state = ProcedureItem.stateInitial
	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.origResponseText = responseText
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true
	obj.color = ProcedureItem.colorInitial
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.responseFunc = responseFunc

    return obj
end

-- get the actor string for this checklist item
function ProcedureItem:getActor()
	return self.actor
end

-- get the left hand action text for the item
function ProcedureItem:getChallengeText()
    return self.challengeText
end

-- set left hand action text
function ProcedureItem:setChallengeText(text)
	self.challengeText = text
end

-- get the right hand result text for the item
function ProcedureItem:getResponseText()
	return self.responseText
end

-- set the right hand result text for the item
function ProcedureItem:setResponseText(text)
	self.responseText = text
end

-- get the time in seconds this item is to be waited on
function ProcedureItem:getWaitTime()
	return self.waittime
end

-- set the wait time in seconds
function ChecklistItem:setWaitTime(seconds)
	self.waittime = seconds
end

-- change the state of the checklist item
function ProcedureItem:setState(state)
    self.state = state
end

-- get the current state of this checklist item
function ProcedureItem:getState()
    return self.state
end

-- get current color of the procedure item
function ProcedureItem:getColor()
	return self.color
end

-- set the color of the checklist item
function ProcedureItem:setColor(color)
	self.color = color
end

function ProcedureItem:getStateColor()
	local statecolors = { ChecklistItem.colorInitial, ChecklistItem.colorActive, ChecklistItem.colorSuccess, ChecklistItem.colorFailed, ChecklistItem.colorManual }
	return statecolors[self.state + 1]
end
-- reset the item to its initial state
function ProcedureItem:reset()
    self:setState(ProcedureItem.stateInitial)
	self.challengeText = self.origChallengeText
	self.responseText = self.origResponseText
	self.valid = true
	self.color = ChecklistItem.colorInitial
end

-- are the conditions for this item met?
function ProcedureItem:isValid()
	if type(self.validFunc) == 'function' then
		self.valid = self.validFunc(self)
	end
    return self.valid
end

-- return the visual line to put in the checklist displays
function ProcedureItem:getLine(lineLength)
	local line = {}
	local dots = lineLength - string.len(self.challengeText) - string.len(self.responseText) - 7
	line[#line + 1] = self.challengeText
	local dotchar = "."
	if self.responseText == "" then
		dotchar = " "
	end
	for i=0,dots-1,1 do
		line[#line + 1] = dotchar
	end
	line[#line + 1] = self:getResponseText()
	if self.actor ~= "" then
		line[#line + 1] = " ("
		line[#line + 1] = self.actor
		line[#line + 1] = ")"
	end
	
	return table.concat(line)
end

return ProcedureItem