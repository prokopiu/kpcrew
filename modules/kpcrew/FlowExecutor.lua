-- Flow Executor - runs flows and checklists and also background flows.
--
-- @classmod FlowExecutor
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
-- New branch for flow executor refactoring
local kcFlowExecutor = {
	type_procedure = 0,
	type_checklist = 1,
	type_background = 2
}

local Flow				= require "kpcrew.Flow"
local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate FlowExecutor
function kcFlowExecutor:new(flow)
    kcFlowExecutor.__index = kcFlowExecutor
    local obj = {}
    setmetatable(obj, kcFlowExecutor)

	obj.flow = flow
	obj.type = type_procedure
	obj.current_step = 0
	obj.nextStepTime = 0

    return obj
end

function kcFlowExecutor:getType()
	return self.type
end

function kcFlowExecutor:setType(flowtype)
	self.type = flowtype
end

function kcFlowExecutor:setFlow(flow)
	self.flow = flow
end

local function jump2NextStep(flow)
	if not flow:hasNextItem() then
		flow:setState(Flow.FINISH)
	else
		flow:setNextItemActive()
	end
end

function kcFlowExecutor:execute()
	self.flow = getActiveSOP():getActiveFlow()
	local flowState = self.flow:getState()
	local step = self.flow:getActiveItem()
	if step == nil then
		return
	end
	-- logMsg("Flow: [" .. self.flow:getClassName() .. "] " .. flowState .. " - Step: " .. step:getState())

	-- running flow
	if flowState == Flow.RUN then
	
		-- execute the flow step by step
		local stepState = step:getState()
		if activePrefSet:get("general:flowAutoOpen") == true then
			if kc_show_flow ~= true or kc_flow_wnd == nil then
				-- kc_wnd_flow_action = 1 -- open flow window for active flow
				kc_toggle_flow_window()
			end
		end
		activeBckVars:set("general:flight_state",self.flow:getFlightPhase())

		if self.flow:getActiveItemIndex() == 0 then
			self.flow:speakName()
			self.flow:setActiveItemIndex(1)
			return
		end

		self.nextStepTime = kc_getPcTime() + step:getWaitTime()

		-- initial state
		if stepState == FlowItem.INIT then
			-- speak challenge text, for procedures this is the whole line
			step:speakChallengeText()
			-- execute automatic steps if available
			if getActivePrefs():get("general:assistance") > 2 then
				step:execute()
			end

			if not step:isValid() then
				step:setState(FlowItem.FAIL)
				self.flow:setState(Flow.HALT)
				if self.flow:getClassName() == "Checklist" then
					if step:getClassName() == "ManualChecklistItem" then
						step:execute()
					end
				end
			end
			if self.flow:getClassName() == "Checklist" and step:getState() ~= FlowItem.RUN and step:getClassName() ~= "SimpleChecklistItem" then
				step:setState(FlowItem.PAUSE)
				self.flow:setState(Flow.PAUSE)
			end
			if step:isValid() then
				if step:getWaitTime() > 0 then
					self.flow:setState(Flow.WAIT)
				else
					step:setState(FlowItem.DONE)
				end
			end
		elseif stepState == FlowItem.RUN then
			if step:isValid() then
				-- step:speakResponseText()
				if step:getWaitTime() > 0 then
					self.flow:setState(Flow.WAIT)
				else
					step:setState(FlowItem.DONE)
				end
			end

		elseif stepState == FlowItem.FAIL then
			if step:isValid() then
				step:setState(FlowItem.PAUSE)
			end
				
		elseif stepState == FlowItem.SKIP then
			jump2NextStep(self.flow)	
			
		elseif stepState == FlowItem.RESUME then
			if not step:isValid() then
				step:setState(FlowItem.FAIL)
			end
			if step:isValid() then
				if step:getWaitTime() > 0 then
					self.flow:setState(Flow.WAIT)
				else
					step:speakResponseText()
					step:setState(FlowItem.DONE)
				end
			end
		elseif stepState == FlowItem.DONE then
			jump2NextStep(self.flow)

		else
			-- do nothing
		end
		
	-- waiting on delay
	elseif flowState == Flow.WAIT then
		if kc_getPcTime() >= self.nextStepTime then 
			step:setState(FlowItem.DONE)
			jump2NextStep(self.flow)
			self.flow:setState(Flow.RUN)
		end
		
	-- paused by user or fail
	elseif flowState == Flow.HALT then
		if step:isValid() then
			step:setState(FlowItem.RESUME)
			self.flow:setState(Flow.RUN)
		end

	elseif flowState == Flow.FINISH then
		if activePrefSet:get("general:flowAutoOpen") == true then
			if kc_show_flow then
				kc_toggle_flow_window()
			end
		end
		self.flow:speakFinal()
		if activePrefSet:get("general:flowAutoJump") == true then
			getActiveSOP():setNextFlowActive()
		end
	else
		-- whatever needed when states do not match
	end

end

return kcFlowExecutor