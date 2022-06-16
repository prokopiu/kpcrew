-- Obsolete
local SoundChecklistItem = {
}

require "kpcrew.genutils"
local ChecklistItem = require "kpcrew.checklists.ChecklistItem"

function SoundChecklistItem:new(challengeText, responseText, actor, waittime)
    soundChecklistItem.__index = SoundChecklistItem
    setmetatable(SoundChecklistItem, {
        __index = ChecklistItem
    })

    local obj = ChecklistItem:new()
    setmetatable(obj, SoundChecklistItem)

    obj.challengeText = challengeText

    return obj
end

return SoundChecklistItem