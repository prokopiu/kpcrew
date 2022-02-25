require "kpcrew.genutils"

local IndirectChecklistItem = {
	colorFailed 		= color_orange
}

local ChecklistItem = require "kpcrew.checklists.ChecklistItem"

function IndirectChecklistItem:new(challengeText,responseText,actor,waittime,validFunc,responseFunc)

    IndirectChecklistItem.__index = IndirectChecklistItem
    setmetatable(IndirectChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, IndirectChecklistItem)

	obj.state = ChecklistItem.stateInitial
	obj.challengeText = challengeText
	obj.origChallengeText = challengeText
	obj.speakChallengeText = challengeText
	obj.responseText = responseText
	obj.origResponseText = responseText
	obj.speakResponseText = responseText
	obj.actor = actor
	obj.waittime = waittime -- second
	obj.valid = true
	obj.color = color_orange
	obj.validFunc = validFunc
	obj.responseFunc = responseFunc
	obj.conditionMet = false

    return obj
end

function IndirectChecklistItem:getStateColor()
	local statecolors = { ChecklistItem.colorInitial, ChecklistItem.colorActive, ChecklistItem.colorSuccess, color_orange, ChecklistItem.colorSkipped }
	return statecolors[self.state + 1]
end

function IndirectChecklistItem:reset()
    self:setState(ChecklistItem.stateInitial)
	self.challengeText = self.origChallengeText
	self.responseText = self.origResponseText
	self.speakText = self.responseText
	self.valid = true
	self.color = color_orange
end

function IndirectChecklistItem:isValid()
	if type(self.validFunc) == 'function' then
		if self.conditionMet == false then
			if self.validFunc(self) then
				self.conditionMet = true
			end
		end
	end
    return self.conditionMet
end

function IndirectChecklistItem:isAutomaticItem()
    return false
end

return IndirectChecklistItem