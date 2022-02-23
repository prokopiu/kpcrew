-- IndirectProcedureItem: a line in the procedure refers to something happening in the background (can be several actions)
-- ProcedureItem:new(challengeText)
--   challengeText only text to display full length
require "kpcrew.genutils"

local ProcedureItem = require "kpcrew.procedures.ProcedureItem"

local IndirectProcedureItem = {
	colorFailed 		= color_orange
}

function IndirectProcedureItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,responseFunc)

    IndirectProcedureItem.__index = IndirectProcedureItem
    setmetatable(IndirectProcedureItem, {
        __index = ProcedureItem
    })

    local obj = ProcedureItem:new()
    setmetatable(obj, IndirectProcedureItem)

	obj.state = ProcedureItem.stateInitial
	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.origResponseText = responseText
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true
	obj.color = color_orange
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.responseFunc = responseFunc
	obj.conditionMet = false
	
    return obj
end

function IndirectProcedureItem:getStateColor()
	local statecolors = { ProcedureItem.colorInitial, ProcedureItem.colorActive, ProcedureItem.colorSuccess, color_orange, ProcedureItem.colorManual }
	return statecolors[self.state + 1]
end

function ProcedureItem:reset()
    self:setState(ProcedureItem.stateInitial)
	self.challengeText = self.origChallengeText
	self.responseText = self.origResponseText
	self.valid = true
	self.color = color_orange
end

function IndirectProcedureItem:isValid()
	if type(self.validFunc) == 'function' then
		if self.conditionMet == false then
			if self.validFunc(self) then
				self.conditionMet = true
			end
		end
	end
    return self.conditionMet
end

return IndirectProcedureItem