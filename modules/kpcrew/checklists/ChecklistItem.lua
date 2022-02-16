-- ChecklistItem: base class for a "line" item in a checklist which is part of a SOP
-- Instantiate assert
-- ChecklistItem:new(challengeText, responseText, actor)
--   challengeText is the left hand text which asks for a check
--   responseText is the expected answer
--   actor is the actor for the item; see list below
require "kpcrew.genutils"

local ChecklistItem = {
    stateInitial = 0,
    stateActive = 1,
    stateSuccess = 2,
    stateFailed = 3,
    stateSkipped = 4,
	actorPF 	= "PF",
	actorPNF 	= "PNF",
	actorBOTH 	= "BOTH",
	actorFO 	= "F/O",
	actorCPT 	= "CPT",
	actorLHS 	= "LHS",
	actorRHS 	= "RHS",
	actorNONE 	= "",
	colorInitial= color_grey,
	colorActive = color_white,
	colorSuccess= color_green,
	colorFailed = color_red,
	colorSkipped= color_dark_green
}

function ChecklistItem:new(challengeText,responseText,actor)
    ChecklistItem.__index = ChecklistItem

    local obj = {}
    setmetatable(obj, ChecklistItem)

	obj.state = ChecklistItem.stateInitial
	obj.challengeText = challengeText
	obj.origChallengeText = challengeText
	obj.speakChallengeText = challengeText
	obj.responseText = responseText
	obj.origResponseText = responseText
	obj.speakResponseText = responseText
	obj.actor = actor
	obj.waittime = 1 -- second
	obj.valid = true
	obj.color = ChecklistItem.colorInitial

    return obj
end

-- get the actor string for this checklist item
function ChecklistItem:getActor()
    return self.actor
end

-- get the left hand challenge text for the item
function ChecklistItem:getChallengeText()
    return self.challengeText
end

-- set the challenge text for the item (may not be needed)
function ChecklistItem:setChallengeText(text)
	self.challengeText = text
end

-- get the spoken version of the challenge text (default same)
-- Speech engine may need the text differently
function ChecklistItem:getSpeakChallengeText()
	return self.speakChallengeText
end

-- set the spoken response text
function ChecklistItem:setSpeakChallengeText(text)
	self.speakChallengeText = text
end

-- get the right hand response text to display
function ChecklistItem:getResponseText()
	return self.responseText
end

-- set the response text (used often for variable items)
function ChecklistItem:setResponseText(text)
	self.responseText = text
end

-- get the spoken version of the response text (default same)
-- Speech engine may need the text differently
function ChecklistItem:getSpeakResponseText()
	return self.speakResponseText
end

-- set the spoken response text
function ChecklistItem:setSpeakResponseText(text)
	self.speakResponseText = text
end

-- get the time in seconds this item is to be waited on
-- must be adjusted as the speech engine takes time
function ChecklistItem:getWaitTime()
	return self.waittime
end

-- set the wait time in seconds
function ChecklistItem:setWaitTime(seconds)
	self.waittime = seconds
end

-- get the current state of this checklist item
function ChecklistItem:getState()
    return self.state
end

-- change the state of the checklist item
-- also sets the color of the checklist item
function ChecklistItem:setState(state)
    self.state = state
	if state == ChecklistItem.stateInitial then
		self.color = ChecklistItem.colorInitial
	end
	if state == ChecklistItem.stateActive then
		self.color = ChecklistItem.colorActive
	end 
	if state == ChecklistItem.stateSuccess then
		self.color = ChecklistItem.colorSkipped
	end 
	if state == ChecklistItem.stateFailed then
		self.color = ChecklistItem.colorFailed
	end 
	if state == ChecklistItem.stateSkipped then
		self.color = ChecklistItem.colorSkipped
	end
end

-- get current color of the checklist item
function ChecklistItem:getColor()
	return self.color
end

-- set the color of the checklist item
function ChecklistItem:setColor(color)
	self.color = color
end

-- reset the item to its initial state
function ChecklistItem:reset()
    self:setState(ChecklistItem.stateInitial)
	self.challengeText = self.origChallengeText
	self.responseText = self.origResponseText
	self.speakText = self.responseText
	self.valid = true
	self.color = ChecklistItem.colorInitial
end

-- are the conditions for this item met?
function ChecklistItem:isValid()
    return self.valid
end

-- speak the challenge text with the XP11 speech engine
function ChecklistItem:speakChallenge()
	if self.speakChallengeText ~= "" then
		speakNoText(0,self.speakChallengeText)
	end
end
	
-- speak the response text (not with all items and sop modes)
function ChecklistItem:speakResponse()
	if speakResponseText ~= "" then
		speakNoText(0,self.speakResponseText)
	end
end

-- return the visual line to put in the checklist displays
function ChecklistItem:getLine(lineLength)
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
	line[#line + 1] = self.responseText
	if self.actor ~= "" then
		line[#line + 1] = " ("
		line[#line + 1] = self.actor
		line[#line + 1] = ")"
	end
	
	return table.concat(line)
end

return ChecklistItem