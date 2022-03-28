-- Flow Executor - runs flows and checklists and also background flows.
--
-- @classmod FlowExecutor
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcFlowExecutor = {
	type_procedure = 0,
	type_checklist = 1,
	type_background = 2,
	
	state_stopped = 0,
	state_running = 1,
	state_paused = 2,
	state_finished = 3
}

-- Instantiate FlowExecutor
function kcFlowExecutor:new(flow)
    kcFlowExecutor.__index = kcFlowExecutor
    local obj = {}
    setmetatable(obj, kcFlowExecutor)

	obj.flow = flow
	obj.state = state_stopped
	obj.type = type_procedure
	obj.current_step = 0

    return obj
end

function kcFlowExecutor:getState()
	return self.state
end

function kcFlowExecutor:setState(state)
	self.state = state
end

function kcFlowExecutor:getType()
	return self.type
end

function kcFlowExecutor:setType(flowtype)
	self.type = flowtype
end

function kcFlowExecutor:execute()
	if self.state == self.state_stopped then
	elseif self.state == self.state_running then
		if self.flow:getState() == kcFlow.stateNotStarted then
			self.flow:setState(kcFlow.stateInProgress)
		elseif self.flow:getState() == kcFlow.stateInProgress then
			-- execute next step
			local step = self.flow:getActiveItem()
			if step ~= nil then
-- execute
				if getActivePrefs():get("general:assistance") > 2 then
					step:execute()
				end
-- execute
			end
			if not step:isValid() then
				self.flow:setState(kcFlow.statePaused)
			else
				step:setState(kcFlowItem.stateSuccess)
				self.state = self.state_running
				if not self.flow:hasNextItem() then
					self.flow:setState(kcFlow.stateCompleted)
					self.state = self.state_finished
				else
					self.flow:setNextItemActive()
				end
			end
		elseif self.flow:getState() == kcFlow.stateCompleted then
			self.state = self.state_finished
		elseif self.flow:getState() == kcFlow.statePaused then
			local step = self.flow:getActiveItem()
			if step ~= nil then
				if getActivePrefs():get("general:assistance") > 2 then
					step:execute()
				end
				if step:isValid() then
					self.flow:setState(kcFlow.stateInProgress)
					step:setState(kcFlowItem.stateSuccess)
					self.state = self.state_running
				end
			end
			-- pause actions?
		end
	elseif self.state == self.state_finished then
		-- do nothing
	end
end

return kcFlowExecutor