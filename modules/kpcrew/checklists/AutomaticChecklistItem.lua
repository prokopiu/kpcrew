local AutomaticChecklistItem = {}

require "kpcrew.genutils"
local ChecklistItem = require "kpcrew.checklists.ChecklistItem"

function AutomaticChecklistItem:new(challengeText, responseText, actor, waittime)
    AutomaticChecklistItem.__index = AutomaticChecklistItem
    setmetatable(AutomaticChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, AutomaticChecklistItem)

    obj.challengeText = challengeText
    obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime

    return obj
end

return AutomaticChecklistItem
