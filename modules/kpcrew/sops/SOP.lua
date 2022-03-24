-- Base class for a Standard Operating Procedure 
-- A SOP will receive checklists and procedures in the sequence they are intended to be executed
--
-- @classmod kcSOP
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcSOP = {
}

-- Instantiate a new preference set
-- @tparam string name Name of the SOP (also used as title)
function kcSOP:new(name)
    kcSOP.__index = kcSOP
    local obj = {}
    setmetatable(obj, kcSOP)

    obj.name = name
    obj.checklists = {} -- separate list of only checklists
    obj.procedures = {} -- Separate list of only procedures
	obj.flows = {} -- combined list of flows (chkl & proc) in sequence
	obj.activeFlowIndex = 1
	obj.activeChecklistIndex = 1
	obj.activeProcedureIndex = 1
    obj.bgrOnDemandProcs = {} -- list of SOP related background tasks
    obj.bgrMonitoringProcs = {} -- list of SOP related monitoring tasks

    return obj
end

-- Get name/title of SOP
-- @treturn string name of SOP
function kcSOP:getName()
    return self.name
end

-- Add a checklist object to checklists and flows
-- @tparam kcChecklist checklist object
function kcSOP:addChecklist(checklist)
    table.insert(self.checklists, checklist)
    table.insert(self.flows, checklist)
end

-- Add a procedure object to checklists and flows
-- @tparam kcProcedure procedure object
function kcSOP:addProcedure(procedure)
    table.insert(self.procedures, procedure)
    table.insert(self.flows, procedure)
end

-- Return all registered checklists in sequence
-- @tparam list of kcChecklist objects
function kcSOP:getAllChecklists()
    return self.checklists
end

-- Return all registered procedures in sequence
-- @tparam list of kcProcedure objects
function kcSOP:getAllProcedures()
    return self.procedures
end

-- Return all registered flows (chkl & proc) in sequence
-- @tparam list of kcChecklist and kcProcedure objects
function kcSOP:getAllFlows()
	return self.flows
end

-- Return a list of flow titles to display
-- @treturn list of string
function kcSOP:getFlowNames()
	local names = {}
	for _, flow in ipairs(self.flows) do
		table.insert(names, flow:getName())
	end
	return names
end

-- set the active flow index directly
-- @tparam int new index of flow
function kcSOP:setActiveFlowIndex(flowIndex)   
	if flowIndex >= 1 and flowIndex <= #self.flows then
		self.activeFlowIndex = flowIndex
	else
		return -1
    end
end

-- set the active checklist index directly
-- @tparam int new index of checklist
function kcSOP:setActiveChecklistIndex(flowIndex)   
	if flowIndex >= 1 and flowIndex <= #self.flows then
		self.activeChecklistIndex = flowIndex
	else
		return -1
    end	
end

-- set the active procedure index directly
-- @tparam int new index of procedure
function kcSOP:setActiveProcedureIndex(flowIndex)   
	if flowIndex >= 1 and flowIndex <= #self.flows then
		self.activeProcedureIndex = flowIndex
	else
		return -1
    end	
end

-- return the currently active flow in the SOP
-- @treturn kcProcedure or kcChecklist object
function kcSOP:getActiveFlow()
	return self.flows[self.activeFlowIndex]
end

function kcSOP:getActiveFlowIndex()
	return self.activeFlowIndex
end

-- return the currently active checklist in the SOP
-- @treturn kcChecklist object
function kcSOP:getActiveChecklist()
	if self.checklists ~= nil then
		return self.checklists[self.activeChecklistIndex]
	end
end

-- return the currently active procedure in the SOP
-- @treturn kcProcedure object
function kcSOP:getActiveProcedure()
	return self.procedures[self.activeProcedureIndex]
end

-- get the number of registered flows
function kcSOP:getNumberOfFlows()
	return table.getn(self.flows)
end

-- is there another item left or at end?
function kcSOP:hasNextFlow()
    return self.activeFlowIndex < #self.flows
end

-- Take the next procedure item as active item
function kcSOP:setNextFlowActive()
    if self:hasNextFlow() then
		self.activeFlowIndex = self.activeFlowIndex + 1
	else
		return -1
    end
end

-- reset the whole SOP and all its flows
function kcSOP:reset()
    self.activeFlowIndex = 1
	self.activeChecklistIndex = 1
	self.activeProcedureIndex = 1

    for _, flow in ipairs(self.flows) do
        flow:reset()
    end
end

-- ============ SOP specific UIs ================

-- render the SOP button list
function kcSOP:render()
	local flows = self:getAllFlows()
	for _, flow in ipairs(flows) do
		imgui.SetCursorPosY(imgui.GetCursorPosY() + 1)
		local color = color_procedure
		if flow:getClassName() == "Checklist" then	
			color = color_checklist
		end
		if flow:getState() == 2 then
			color = color_green
		end
		if kc_indexOf(flows,flow) == self.activeFlowIndex then
			color = color_red
		end
        imgui.PushStyleColor(imgui.constant.Col.Button, color)
		if imgui.Button(flow:getName(), self:getBtnWidth(), 18) then
			self:setActiveFlowIndex(kc_indexOf(flows,flow))
			-- kc_wnd_flow_action = 1
		end
        imgui.PopStyleColor()
	end
end

-- get the calculated height for the window
function kcSOP:getWndHeight()
	return self:getNumberOfFlows() * 23 + 12
end

-- get the max width of buttons in the list based on labels
function kcSOP:getBtnWidth()
	local namelen = 0
	local flows = self:getAllFlows()
	for _, flow in ipairs(flows) do
		local nrchars = string.len(flow:getName())
		if nrchars > namelen then
			namelen = nrchars
		end
	end
	return namelen * 8
end

-- get the calculated width for the checklist window
function kcSOP:getWndWidth()
	return self:getBtnWidth() + 15
end

-- get the calculated X position based on window width
function kcSOP:getWndXPos()
	local win_width = get("sim/graphics/view/window_width")
	return win_width - self:getWndWidth() - activeBckVars:get("ui:sop_wnd_xoffset") --50
end

-- get the calculated Y position
function kcSOP:getWndYPos()
	return activeBckVars:get("ui:sop_wnd_ypos")
end

return kcSOP