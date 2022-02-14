local ChecklistItem = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateSuccess = 2,
    stateFailed = 3,
    stateDoneManually = 4
}

require "kpcrew.genutils"

function ChecklistItem:new(name,challengeText,responseText)
    ChecklistItem.__index = ChecklistItem

    local obj = {}
    setmetatable(obj, ChecklistItem)

    obj.name = name
	obj.state = ChecklistItem.stateNotStarted
	obj.challengeText = challengeText
	obj.responseText = responseText

    return obj
end

function ChecklistItem:getName()
    return self.name
end

function ChecklistItem:getChallengeText()
    return self.challengeText
end

function ChecklistItem:setChallengeText(text)
	self.challengeText = text
end

function ChecklistItem:getActor()
	return ""
end

function ChecklistItem:getResponseText()
	return self.responseText
end

function ChecklistItem:setResponseText(text)
	self.responseText = text
end

function ChecklistItem:getWaitTime()
	return 0
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

function ChecklistItem:validate()
    return true
end

function ChecklistItem:isManualItem()
    return false
end

function ChecklistItem:isAutomaticItem()
    return false
end

function ChecklistItem:hasResponse()
    return false
end

function ChecklistItem:speakChallenge()
	speakNoText(0,self:getChallengeText())
end
	
function ChecklistItem:speakResponse()
	speakNoText(0,self:getResponseText())
end
	
return ChecklistItem