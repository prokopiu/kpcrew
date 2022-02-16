local ProcedureItem = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateSuccess = 2,
    stateFailed = 3,
    stateDoneManually = 4
}

require "kpcrew.genutils"

function ProcedureItem:new(name,challengeText,responseText)
    ProcedureItem.__index = ProcedureItem

    local obj = {}
    setmetatable(obj, ProcedureItem)

    obj.name = name
	obj.state = ProcedureItem.stateNotStarted
	obj.challengeText = challengeText
	obj.responseText = responseText	

    return obj
end

function ProcedureItem:getName()
    return self.name
end

function ProcedureItem:getChallengeText()
    return self.challengeText
end

function ProcedureItem:setChallengeText(text)
	self.challengeText = text
end

function ProcedureItem:getActor()
	return ""
end

function ProcedureItem:getResponseText()
	return self.responseText
end

function ProcedureItem:setResponseText(text)
	self.responseText = text
end

function ProcedureItem:getWaitTime()
	return 0
end

function ProcedureItem:setState(state)
    self.state = state
end

function ProcedureItem:getState()
    return self.state
end

function ProcedureItem:reset()
    self:setState(ProcedureItem.stateNotStarted)
end

function ProcedureItem:validate()
    return true
end

function ProcedureItem:isManualItem()
    return false
end

function ProcedureItem:isAutomaticItem()
    return false
end

function ProcedureItem:hasResponse()
    return false
end

function ProcedureItem:speakChallenge()
	speakNoText(0,self:getChallengeText())
end
	
function ProcedureItem:speakResponse()
	speakNoText(0,self:getResponseText())
end
	
function ProcedureItem:getLine(lineLength)
	local line = {}
	-- if self.responseText ~= "" then
		local dots = lineLength - string.len(self.challengeText) - string.len(self.responseText) - 5
		line[#line + 1] = self.challengeText
		for i=0,dots-1,1 do
			line[#line + 1] = "."
		end
		line[#line + 1] = self.responseText
		line[#line + 1] = " "
		line[#line + 1] = self.actor
	
		return table.concat(line)
	-- else
		-- line[#line + 1] = self.challengeText
	-- end
end

return ProcedureItem