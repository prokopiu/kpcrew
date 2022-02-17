-- SimpleChecklistItem: a line in the checklist that stays always white and has no activities, info text
-- SimleChecklistItem:new(challengeText)
--   challengeText only text to display full length
require "kpcrew.genutils"

local ChecklistItem = require "kpcrew.checklists.ChecklistItem"

local SimpleChecklistItem = {
}

function SimpleChecklistItem:new(challengeText)

    SimpleChecklistItem.__index = SimpleChecklistItem
    setmetatable(SimpleChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, SimpleChecklistItem)

    obj.challengeText = challengeText
    obj.responseText = ""
	obj.actor = ""
	obj.waittime = 0
	obj.color = color_white
	obj.valid = true
	obj.state = ChecklistItem.stateInitial
	
    return obj
end

-- nothing spoken with these entries
function SimpleChecklistItem:speakChallenge()
	-- do nothing
end

-- nothing spoken with these items
function SimpleChecklistItem:speakResponse()
	-- do nothing
end

-- color is always white
function SimpleChecklistItem:getColor()
	return color_white
end

-- item is always valid
function SimpleChecklistItem:isValid()
	return true
end

return SimpleChecklistItem