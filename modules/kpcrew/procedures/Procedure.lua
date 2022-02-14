local Procedure = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateCompleted = 2
}

function Procedure:new(name)
    Procedure.__index = Procedure

    local obj = {}
    setmetatable(obj, Procedure)

    obj.name = name
    obj.state = Procedure.stateNotStarted
    obj.items = {}
    obj.activeItemNumber = 1

    return obj
end

function Procedure:getName()
    return self.name
end

function Procedure:setState(state)
    self.state = state
end

function Procedure:getState()
    return self.state
end

function Procedure:addItem(procedureItem)
    table.insert(self.items, procedureItem)
end

function Procedure:getAllItems()
    return self.items
end

function Procedure:getActiveItem()
    return self.items[self.activeItemNumber]
end

function Procedure:setActiveItemNumber(itemNumber)
    if itemNumber >= 1 and itemNumber <= #self.items then
		self.activeItemNumber = itemNumber
	else
		return -1
    end
end

function Procedure:hasNextItem()
    return self.activeItemNumber < #self.items
end

function Procedure:setNextItemActive()
    if self:hasNextItem() then
		self.activeItemNumber = self.activeItemNumber + 1
	else
		return -1
    end
end

function Procedure:reset()
    self:setState(Procedure.stateNotStarted)
    self:setActiveItemNumber(1)

    for _, procedureItem in ipairs(self.items) do
        procedureItem:reset()
    end
end

return Procedure
