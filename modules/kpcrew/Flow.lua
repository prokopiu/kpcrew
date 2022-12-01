-- Flow of activities during a specific phase of flight (checklist or procedure)
-- A procedure registers a number of activities/tasks to be executed and checked
--
-- @classmod Flow
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcFlow = {
    NEW 			= 0, -- Ready to start flow
    START 			= 1, -- Flow starting
    RUN 			= 2, -- Flow running
    PAUSE  			= 3, -- Flow paused
	WAIT			= 4, -- Flow waiting
	FINISH			= 5, -- Flow finished
	HALT			= 6, -- Flow halted

	states		= { "NEW", "START", "RUN", "PAUSE", "WAIT", "FINISH", "HALT" }, 
	
	colorNotStarted	= color_white,
	colorInProgress = color_left_display,
	colorPaused		= color_orange,
	colorCompleted 	= color_dark_green
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new Procedure
-- @tparam string name Name of the flow
-- @tparam string speakname name of the flow to be spoken at beginning
-- @tparam string finalstatement Text to speak at end of flow
-- @treturn Flow the created flow object
function kcFlow:new(name, speakname, finalstatement)
    kcFlow.__index = kcFlow
    local obj = {}
    setmetatable(obj, kcFlow)

    obj.name = name
    obj.state = self.NEW
	obj.finalStatement = finalstatement

    obj.items = {}
    obj.activeItemIndex = 0
	obj.wnd = nil
	obj.resize = true
	obj.spokenName = speakname
	obj.nameSpoken = false
	obj.finalSpoken = false
	obj.flightPhase = 0
	
	obj.className = "Flow"
	
    return obj
end

-- Get name/title of flow
-- @treturn string name of set
function kcFlow:getName()
    return self.name
end

-- Get name of flow object
-- @treturn string name of element
function kcFlow:setSpeakName(name)
	self.spokenName = name
end

-- Get name of element for speaking
-- @treturn string name of element
function kcFlow:getSpeakName()
	return self.spokenName
end

-- speak the name of the flow
function kcFlow:speakName()
	if self.spokenName ~= nil and self.nameSpoken == false then
		kc_speakNoText(0,self.spokenName)
	end
	self.nameSpoken = true
end

-- set flight phase
-- @tparam int id of phase in SOP
function kcFlow:setFlightPhase(phase)
	self.flightPhase = phase
end

-- get the current flight phase in SOP
-- @treturn string name
function kcFlow:getFlightPhase()
	return self.flightPhase
end

-- change final statement string
-- @tparam string statement
function kcFlow:setFinalStatement(statement)
	self.finalStatement = statement
end

-- get final statement
-- @treturn string statement
function kcFlow:getFinalStatement()
	return self.finalStatement
end

-- speak the final statement of flow
function kcFlow:speakFinal() 
	if self.finalStatement ~= nil and self.finalSpoken == false then
		kc_speakNoText(0,self:getFinalStatement())
	end
	self.finalSpoken = true
end

-- set the resize flag
-- @tparam boolean true enable resizing
function kcFlow:setResize(flag)
	self.resize = flag
end

-- get the resize flag
-- @treturn boolean flag
function kcFlow:getResize()
	return self.resize
end

-- return the type of flow for distinction later
-- @treturn string "Flow" or "Procedure" or "Checklist"
function kcFlow:getClassName()
	return self.className
end

-- set state of procedure
-- @tparam int state current state of flow (see list above)
function kcFlow:setState(state)
    self.state = state
end

-- get state of procedure
-- @treturn int state of flow
function kcFlow:getState()
    return self.state
end

-- return the color code linked to the state
-- @treturn int state matching color code
function kcFlow:getStateColor()
	local statecolors = { self.colorNotStarted, self.colorInProgress, self.colorPaused, self.colorPaused, self.colorCompleted, self.colorPaused }
	return statecolors[self.state + 1]
end

-- add a new procedure item at the end
-- @tparam FlowItem new flowitem to add at the end
function kcFlow:addItem(item)
    table.insert(self.items, item)
end

-- get all procedure items
-- @treturn array of flow items
function kcFlow:getAllItems()
    return self.items
end

-- return number of active procedure items
-- @treturn int number of items in flow
function kcFlow:getNumberOfItems()
	local cnt = 0
	for _, item in ipairs(self.items) do
		if item:getState() ~= FlowItem.SKIP then
			cnt = cnt + 1
		end
	end
	return cnt
end

-- get the currently active item
-- @treturn int current index
function kcFlow:getActiveItem()
	if self.activeItemIndex == 0 then 
		return self.items[1]
	else
		return self.items[self.activeItemIndex]
	end
end

-- set the active procedure item
-- @tparam int itemIndex index of next item to work on
function kcFlow:setActiveItemIndex(itemIndex)
    if itemIndex >= 1 and itemIndex <= #self.items then
		self.activeItemIndex = itemIndex
	else
		return -1
    end
end

-- get the active flow item
-- @treturn int index of currently active item
function kcFlow:getActiveItemIndex()
	return self.activeItemIndex
end 

-- is there another item left or at end?
-- @treturn boolean true if still items available
function kcFlow:hasNextItem()
    return self.activeItemIndex < #self.items
end

-- Take the next procedure item as active item
-- @treturn int index of next item to execute, -1 if at end
function kcFlow:setNextItemActive()
	if self:hasNextItem() then
		self.activeItemIndex = self.activeItemIndex + 1
	end
    while self:hasNextItem() 
	and (self.items[self.activeItemIndex]:getClassName() == "SimpleProcedureItem"
			or self.items[self.activeItemIndex]:getClassName() == "SimpleChecklistItem"
			or self.items[self.activeItemIndex]:getState() == FlowItem.SKIP) do
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
    self:setState(kcFlow.NEW)
    self.activeItemIndex = 0
	self.nameSpoken = false
	self.finalSpoken = false
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
			if item:getClassName() == "HoldProcedureItem" then
				item:setColor(FlowItem.colorActive)
			else
				item:setColor(FlowItem.colorFailed)
			end
		else
			item:setColor(item:getStateColor())
		end
		-- remove skipped items
		if item:getState() ~= FlowItem.SKIP then
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