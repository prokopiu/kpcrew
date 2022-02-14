local Checklist = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateCompleted = 2
}

function Checklist:new(name)
    Checklist.__index = Checklist

    local obj = {}
    setmetatable(obj, Checklist)

    obj.name = name
    obj.state = Checklist.stateNotStarted
    obj.items = {}
    obj.activeItemNumber = 1


    return obj
end

function Checklist:getName()
    return self.name
end

function Checklist:setState(state)
    self.state = state
end

function Checklist:getState()
    return self.state
end

function Checklist:addItem(checklistItem)
    table.insert(self.items, checklistItem)
end

function Checklist:getAllItems()
    return self.items
end

function Checklist:getActiveItem()
    return self.items[self.activeItemNumber]
end

function Checklist:setActiveItemNumber(itemNumber)
    if itemNumber >= 1 and itemNumber <= #self.items then
		self.activeItemNumber = itemNumber
	else
		return -1
    end
    
end

function Checklist:hasNextItem()
    return self.activeItemNumber < #self.items
end

function Checklist:setNextItemActive()
    if self:hasNextItem() then
		self.activeItemNumber = self.activeItemNumber + 1 
	else
		return -1
    end
end

function Checklist:reset()
    self:setState(Checklist.stateNotStarted)
    self:setActiveItemNumber(1)

    for _, checklistItem in ipairs(self.items) do
        checklistItem:reset()
    end
end

return Checklist
