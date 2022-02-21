require "kpcrew.genutils"

local SOP = {}

function SOP:new(name)

    SOP.__index = SOP

    local obj = {}
    setmetatable(obj, SOP)

    obj.name = name
    obj.checklists = {}
    obj.procedures = {}
	obj.flows = {}
	obj.activeFlowNumber = 1
	obj.activeChecklistNumber = 1
	obj.activeProcedureNumber = 1
    obj.bgrOnDemandProcs = {}
    obj.bgrMonitoringProcs = {}

    return obj
end

function SOP:getName()
    return self.name
end

function SOP:addChecklist(checklist)
    table.insert(self.checklists, checklist)
    table.insert(self.flows, checklist)
end

function SOP:addProcedure(procedure)
    table.insert(self.procedures, procedure)
    table.insert(self.flows, procedure)
end

function SOP:getAllChecklists()
    return self.checklists
end

function SOP:getAllProcedures()
    return self.procedures
end

function SOP:getAllFlows()
	return self.flows
end

function SOP:getFlowNames()
	local names = {}
	for _, flow in ipairs(self.flows) do
		table.insert(names, flow:getName())
	end
	return names
end

function SOP:setActiveFlowNumber(flowNumber)   
	if flowNumber >= 1 and flowNumber <= #self.flows then
		self.activeFlowNumber = flowNumber
	else
		return -1
    end
end

function SOP:setActiveChecklistNumber(flowNumber)   
	if flowNumber >= 1 and flowNumber <= #self.checklists then
		self.activeChecklistNumber = flowNumber
	else
		return -1
    end
end

function SOP:setActiveProcedureNumber(flowNumber)   
	if flowNumber >= 1 and flowNumber <= #self.procedures then
		self.activeProcedureNumber = flowNumber
	else
		return -1
    end
end

function SOP:getActiveFlow()
	return self.flows[self.activeFlowNumber]
end

function SOP:getActiveChecklist()
	if self.checklists ~= nil then
		return self.checklists[self.activeChecklistNumber]
	end
end

function SOP:getNumberOfFlows()
	return table.getn(self.flows)
end


function SOP:getActiveProcedure()
	return self.flows[self.activeProcedureNumber]
end

function SOP:reset()
    self.activeFlowNumber = 1
	self.activeChecklistNumber = 1
	self.activeProcedureNumber = 1

    for _, flow in ipairs(self.flows) do
        flow:reset()
    end
end

function SOP:render()
	local flows = self:getAllFlows()
	for _, flow in ipairs(flows) do
		imgui.SetCursorPosY(imgui.GetCursorPosY() + 1)
		local color = color_procedure
		if flow:getType() == "Checklist" then	
			color = color_checklist
		end
		if indexOf(flows,flow) == self.activeFlowNumber then
			color = color_red
		end
        imgui.PushStyleColor(imgui.constant.Col.Button, color)
		if imgui.Button(flow:getName(), self:getBtnWidth(), 18) then
			self:setActiveFlowNumber(indexOf(flows,flow))
			wnd_flow_action = 1
		end
        imgui.PopStyleColor()
	end
end

-- get the calculated height for the window
function SOP:getWndHeight()
	return self:getNumberOfFlows() * 23 + 12
end

function SOP:getBtnWidth()
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
function SOP:getWndWidth()
	return self:getBtnWidth() + 15
end

function SOP:getWndXPos()
	local win_width = get("sim/graphics/view/window_width")
	return win_width - self:getWndWidth() - 50
end

function SOP:getWndYPos()
	return 50
end

return SOP