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
	return self.procedures[self.activeFlowNumber]
end

function SOP:getActiveChecklist()
	if self.checklists ~= nil then
		return self.checklists[self.activeChecklistNumber]
	end
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

return SOP