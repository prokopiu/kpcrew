-- Procedure: Procedure as a collection of action items
-- Procedure:new(name)
require "kpcrew.genutils"

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
	obj.wnd = nil
	obj.lineLength = 55
	obj.classtype = "Procedure"

    return obj
end

function Procedure:getType()
	return self.classtype
end

-- get name of procedure
function Procedure:getName()
    return self.name
end

-- set state of procedure
function Procedure:setState(state)
    self.state = state
end

-- get state of procedure
function Procedure:getState()
    return self.state
end

-- add a procedure item
function Procedure:addItem(procedureItem)
    table.insert(self.items, procedureItem)
end

-- get all procedure items
function Procedure:getAllItems()
    return self.items
end

-- return number of procedure items
function Procedure:getNumberOfItems()
	local cnt = 0
	for _, item in ipairs(self.items) do
		if item:getState() ~= ProcedureItem.stateSkipped then
			cnt = cnt + 1
		end
	end
	return cnt
	-- return table.getn(self.items)
end

-- get the currently active item
function Procedure:getActiveItem()
    return self.items[self.activeItemNumber]
end

-- set the active procedure item
function Procedure:setActiveItemNumber(itemNumber)
    if itemNumber >= 1 and itemNumber <= #self.items then
		self.activeItemNumber = itemNumber
	else
		return -1
    end
end

-- is there another item left or at end?
function Procedure:hasNextItem()
    return self.activeItemNumber < #self.items
end

-- Take the next procedure item as active item
function Procedure:setNextItemActive()
    if self:hasNextItem() then
		self.activeItemNumber = self.activeItemNumber + 1
	else
		return -1
    end
end

-- reset procedure and all below items
function Procedure:reset()
    self:setState(Procedure.stateNotStarted)
    self:setActiveItemNumber(1)

    for _, procedureItem in ipairs(self.items) do
        procedureItem:reset()
    end
end

-- get line length of procedure
function Procedure:getLineLength()
	return self.lineLength
end

-- change the line length
function Procedure:setLineLength(length)
	self.lineLength = length
end

-- return the procedure headline with its name and "="
function Procedure:getHeadline()
	local svar = activeBckVars:findPreference("general:flight_state")
	local eqsigns = self.lineLength - string.len(self.name .. " - " .. split(svar:getTitle(),"|")[svar:getValue()+1]) - 2
	local line = {}
	
	for i=0,math.floor((eqsigns / 2) + 0.5) - 1,1 do
		line[#line + 1] = "="
	end
	
	line[#line + 1] = " "
	line[#line + 1] = self.name .. " - " .. split(svar:getTitle(),"|")[svar:getValue()+1]
	line[#line + 1] = " "
	
	for i=0,(eqsigns / 2) - 1,1 do
		line[#line + 1] = "="
	end
	return table.concat(line)
end

-- return the procedure bottom line
function Procedure:getBottomline()
	local bottomText = self.name .. " COMPLETED"
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

function Procedure:render()
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
			item:setColor(item.colorFailed)
		else
			item:setColor(item:getStateColor())
		end
		if item:getState() ~= ProcedureItem.stateSkipped then
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

function Procedure:getWndHeight()
	return (self:getNumberOfItems() + 2) * 22 + 15
end

function Procedure:getWndWidth()
	return self:getLineLength() * 7 + 20
end

function Procedure:getWndXPos()
	return 30
end

function Procedure:getWndYPos()
	return 70
end

return Procedure