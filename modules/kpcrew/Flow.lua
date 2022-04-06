-- Flow of activities during a specific phase of flight (checklist or procedure)
-- A procedure registers a number of activities/tasks to be executed and checked
--
-- @classmod Flow
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcFlow = {
    stateNotStarted = 0,
    stateInProgress = 1,
    stateCompleted = 2,
	statePaused = 3,
	colorNotStarted = color_white,
	colorInProgress = color_left_display,
	colorCompleted = color_dark_green
}

-- Instantiate a new Procedure
-- @tparam string name Name of the set (also used as title)
function kcFlow:new(name)
    kcFlow.__index = kcFlow
    local obj = {}
    setmetatable(obj, kcFlow)

    obj.name = name
    obj.state = self.stateNotStarted
    obj.items = {}
    obj.activeItemIndex = 1
	obj.wnd = nil
	obj.className = "Flow"

    return obj
end

-- Get name/title of procedure
-- @treturn string name of set
function kcFlow:getName()
    return self.name
end

-- return the type of flow for distinction later
-- @treturn string "Procedure"
function kcFlow:getClassName()
	return self.className
end

-- set state of procedure
function kcFlow:setState(state)
    self.state = state
end

-- get state of procedure
function kcFlow:getState()
    return self.state
end

-- return the color code linked to the state
function kcFlow:getStateColor()
	local statecolors = { self.colorNotStarted, self.colorInProgress, self.colorCompleted }
	return statecolors[self.state + 1]
end

-- add a new procedure item at the end
function kcFlow:addItem(item)
    table.insert(self.items, item)
end

-- get all procedure items
function kcFlow:getAllItems()
    return self.items
end

-- return number of active procedure items
function kcFlow:getNumberOfItems()
	local cnt = 0
	for _, item in ipairs(self.items) do
		if item:getState() ~= kcFlowItem.stateSkipped then
			cnt = cnt + 1
		end
	end
	return cnt
end

-- get the currently active item
function kcFlow:getActiveItem()
    return self.items[self.activeItemIndex]
end

-- set the active procedure item
function kcFlow:setActiveItemIndex(itemIndex)
    if itemIndex >= 1 and itemIndex <= #self.items then
		self.activeItemIndex = itemIndex
	else
		return -1
    end
end

-- is there another item left or at end?
function kcFlow:hasNextItem()
    return self.activeItemIndex < #self.items
end

-- Take the next procedure item as active item
function kcFlow:setNextItemActive()
	if self:hasNextItem() then
		self.activeItemIndex = self.activeItemIndex + 1
	end
    while self:hasNextItem() 
	and (self.items[self.activeItemIndex]:getClassName() == "SimpleProcedureItem"
			or self.items[self.activeItemIndex]:getClassName() == "SimpleChecklistItem"
			or self.items[self.activeItemIndex]:getState() == kcFlowItem.stateSkipped) do
		self.activeItemIndex = self.activeItemIndex + 1
	end
	if self.activeItemIndex <= #self.items then
		return self.activeItemIndex
	else
		return -1
    end
end

-- reset procedure and all below items
function kcFlow:reset()
    self:setState(kcFlow.stateNotStarted)
    self:setActiveItemIndex(1)
	kc_flow_executor:setState(kcFlowExecutor.state_stopped)
	-- reset all items in procedure
    for _, item in ipairs(self.items) do
        item:reset()
    end
end

-- ===== UI related functions =====

-- get line length of procedure
function kcFlow:getLineLength()
	return activeBckVars:get("ui:flow_line_length")
end

-- return the procedure headline with its name and "="
function kcFlow:getHeadline()
	local eqsigns = self:getLineLength() - string.len(self.name) - 2
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

-- return the procedure bottom line
function kcFlow:getBottomline()
	local bottomText = self.name .. " COMPLETED"
	local eqsigns = self:getLineLength() - string.len(bottomText) - 2
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

-- Render all procedure items as text lines in window
function kcFlow:render()
	-- start position in window
	imgui.SetCursorPosX(10)
	imgui.SetCursorPosY(10)
	imgui.SetWindowFontScale(1.05)
	
	imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF00007F)
	if imgui.Button("RESET", 50, 18) then
		self:reset()
	end
	imgui.PopStyleColor()

	-- Flow output area with 
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
			item:setColor(kcFlowItem.colorFailed)
		else
			item:setColor(item:getStateColor())
		end
		-- remove skipped items
		if item:getState() ~= kcFlowItem.stateSkipped then
			imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
			imgui.PushStyleColor(imgui.constant.Col.Text,item:getColor()) 
				imgui.TextUnformatted(item:getLine(self:getLineLength()))
				-- logMsg(item:getLine(self:getLineLength()))
			imgui.PopStyleColor()
		end
	end

	imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted(self:getBottomline())
	imgui.PopStyleColor()
end

-- get calculated window height
function kcFlow:getWndHeight()
	return (self:getNumberOfItems() + 2) * 22 + 40
end

-- get calculated winow width
function kcFlow:getWndWidth()
	return self:getLineLength() * 7 + 30
end

-- get calculated window x position
function kcFlow:getWndXPos()
	return activeBckVars:get("ui:flow_wnd_xpos")
end

-- get calculated window y position
function kcFlow:getWndYPos()
	return activeBckVars:get("ui:flow_wnd_ypos")
end

return kcFlow