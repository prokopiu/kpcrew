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

    return obj
end

function SimpleChecklistItem:speakChallenge()
	-- do nothing
end
	
function SimpleChecklistItem:speakResponse()
	-- do nothing
end

function SimpleChecklistItem:getColor()
	return color_white
end

return SimpleChecklistItem