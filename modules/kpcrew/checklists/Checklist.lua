-- Checklist: Checklist as a collection of checklist items
-- Checklist:new(name)
require "kpcrew.genutils"

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
	obj.wnd = nil
	obj.lineLength = 55
	obj.classtype = "Checklist"

    return obj
end

function Checklist:getType()
	return self.classtype
end

-- get name of checklist
function Checklist:getName()
    return self.name
end

-- set state of checklist
function Checklist:setState(state)
    self.state = state
end

-- get state of checklist
function Checklist:getState()
    return self.state
end

-- add a checklist item
function Checklist:addItem(checklistItem)
    table.insert(self.items, checklistItem)
end

-- get all checklist items as array
function Checklist:getAllItems()
    return self.items
end

-- return number of checklist items
function Checklist:getNumberOfItems()
	return table.getn(self.items)
end

-- get the currently active item
function Checklist:getActiveItem()
    return self.items[self.activeItemNumber]
end

-- set the active checklist item by index number
function Checklist:setActiveItemNumber(itemNumber)
    if itemNumber >= 1 and itemNumber <= #self.items then
		self.activeItemNumber = itemNumber
	else
		return -1
    end    
end

-- is there another item left or at end?
function Checklist:hasNextItem()
    return self.activeItemNumber < #self.items
end

-- Take the next checklist item as active item
function Checklist:setNextItemActive()
    if self:hasNextItem() then
		self.activeItemNumber = self.activeItemNumber + 1 
	else
		return -1
    end
end

-- reset the checklist and all below items
function Checklist:reset()
    self:setState(Checklist.stateNotStarted)
    self:setActiveItemNumber(1)

    for _, checklistItem in ipairs(self.items) do
        checklistItem:reset()
    end
end

-- get line length of checklist
function Checklist:getLineLength()
	return self.lineLength
end

-- change the line length
function Checklist:setLineLength(length)
	self.lineLength = length
end

-- return the checklist headline with its name and "="
function Checklist:getHeadline()
	local eqsigns = self.lineLength - string.len(self.name) - 2
	local line = {}
	
	for i=0,math.floor((eqsigns / 2) + 0.5) - 1,1 do
		line[#line + 1] = "="
	end
	
	line[#line + 1] = " "
	line[#line + 1] = self.name
	line[#line + 1] = " "
	
	for i=0,(eqsigns / 2) - 1,1 do
		line[#line + 1] = "="
	end
	return table.concat(line)
end

-- return the checklist bottom line
function Checklist:getBottomline()
	local bottomText = self.name .. " CHECKLIST COMPLETED"
	local eqsigns = self.lineLength - string.len(bottomText) - 2
	local line = {}
	
	for i=0,math.floor((eqsigns / 2) + 0.5) - 1,1 do
		line[#line + 1] = "="
	end
	
	line[#line + 1] = " "
	line[#line + 1] = bottomText
	line[#line + 1] = " "
	
	for i=0,(eqsigns / 2) - 1,1 do
		line[#line + 1] = "="
	end
	return table.concat(line)
end

-- ==== window related functions ===

function Checklist:render()
	-- start position in window
	imgui.SetCursorPosX(10)
	imgui.SetCursorPosY(10)

	-- Checklist output area with 
	-- ==== headline ====
	-- n times lines of challenge..response(actor)
	-- ==================

	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted(self:getHeadline())
	imgui.PopStyleColor()

	imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
	local items = self:getAllItems()
	for _, item in ipairs(items) do
		if item:isValid() ~= true then
			item:setColor(ChecklistItem.colorFailed)
		else
			item:setState(item.stateSuccess)
			item:setColor(item:getStateColor()) 
		end
		if item:getState() ~= ChecklistItem.stateSkipped then
			imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
			imgui.PushStyleColor(imgui.constant.Col.Text,item:getColor()) 
			imgui.TextUnformatted(item:getLine(self:getLineLength()))
			imgui.PopStyleColor()		
		end
	end

	imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted(self:getBottomline())
	imgui.PopStyleColor()
end

-- get the calculated height for the checklist window
function Checklist:getWndHeight()
	return (self:getNumberOfItems() + 2) * 22 + 15
end

-- get the calculated width for the checklist window
function Checklist:getWndWidth()
	return self:getLineLength() * 7 + 20
end

function Checklist:getWndXPos()
	return 30
end

function Checklist:getWndYPos()
	return 70
end

return Checklist
