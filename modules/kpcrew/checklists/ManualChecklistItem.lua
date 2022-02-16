local ManualChecklistItem = {
}

require "kpcrew.genutils"
local ChecklistItem = require "kpcrew.checklists.ChecklistItem"

function ManualChecklistItem:new(challengeText, responseText, actor, waittime)

    ManualChecklistItem.__index = ManualChecklistItem
    setmetatable(ManualChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, ManualChecklistItem)

    obj.challengeText = challengeText
    obj.responseText = responseText
	obj.actor = actor
	obj.waittime = waittime

    return obj
end

function ManualChecklistItem:validate()
    return true
end

function ManualChecklistItem:isManualItem()
    return true
end

function ManualChecklistItem:isAutomaticItem()
    return false
end

function ManualChecklistItem:hasResponse()
    return false
end

return ManualChecklistItem