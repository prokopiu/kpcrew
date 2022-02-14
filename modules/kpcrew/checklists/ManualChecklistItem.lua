local ManualChecklistItem = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateSuccess = 2,
    stateFailed = 3,
    stateDoneManually = 4
}

require "kpcrew.genutils"

function ManualChecklistItem:new(challengeText, responseText)

    ManualChecklistItem.__index = ManualChecklistItem
    setmetatable(ManualChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, ManualChecklistItem)

    obj.challengeText = challengeText
    obj.responseText = responseText

    return obj
end

function ManualChecklistItem:getChallengeText()
    return nil
end

function ManualChecklistItem:getActor()
	return nil
end

function ManualChecklistItem:getResponseText()
	return nil
end

function ManualChecklistItem:getWaitTime()
	return 0
end

function ManualChecklistItem:setState(state)
    self.state = state
end

function ManualChecklistItem:getState()
    return self.state
end

function ManualChecklistItem:reset()
    self:setState(ChecklistItem.stateNotStarted)
end

function ManualChecklistItem:validate()
    return true
end

function ManualChecklistItem:isManualItem()
    return false
end

function ManualChecklistItem:isAutomaticItem()
    return false
end

function ManualChecklistItem:hasResponse()
    return false
end

function ManualChecklistItem:speakChallenge()
	speakNoText(0,self:getChallengeText())
end
	
function ManualChecklistItem:speakResponse()
	speakNoText(0,self:getResponseText())
end
	
return ManualChecklistItem