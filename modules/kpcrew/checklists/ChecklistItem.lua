local ChecklistItem = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateSuccess = 2,
    stateFailed = 3,
    stateDoneManually = 4,
	actorPF 	= "PF",
	actorPNF 	= "PNF",
	actorBOTH 	= "BOTH",
	actorFO 	= "F/O",
	actorCPT 	= "CPT",
	actorLHS 	= "LHS",
	actorRHS 	= "RHS",
	actorNONE 	= "",
}

require "kpcrew.genutils"

function ChecklistItem:new(challengeText,responseText,actor,waittime)
    ChecklistItem.__index = ChecklistItem

    local obj = {}
    setmetatable(obj, ChecklistItem)

	obj.state = ChecklistItem.stateNotStarted
	obj.challengeText = challengeText
	obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true

    return obj
end

function ChecklistItem:getActor()
    return self.actor
end

function ChecklistItem:getChallengeText()
    return self.challengeText
end

function ChecklistItem:setChallengeText(text)
	self.challengeText = text
end

function ChecklistItem:getResponseText()
	return self.responseText
end

function ChecklistItem:setResponseText(text)
	self.responseText = text
end

function ChecklistItem:getWaitTime()
	return self.waittime
end

function ChecklistItem:setWaitTime(waittime)
	self.waittime = waittime
end

function ChecklistItem:setState(state)
    self.state = state
end

function ChecklistItem:getState()
    return self.state
end

function ChecklistItem:reset()
    self:setState(ChecklistItem.stateNotStarted)
end

function ChecklistItem:validated()
    return self.valid
end

function ChecklistItem:isManualItem()
    return false
end

function ChecklistItem:isAutomaticItem()
    return false
end

function ChecklistItem:hasResponse()
    return true
end

function ChecklistItem:speakChallenge()
	speakNoText(0,self:getChallengeText())
end
	
function ChecklistItem:speakResponse()
	speakNoText(0,self:getResponseText())
end

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
	
	--- test 
	local addstr = " F"
	if self:validated() then
		addstr = " T"
	end
	line[#line + 1] = addstr
	
	return table.concat(line)
end

return ChecklistItem