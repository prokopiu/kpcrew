-- Flow Executor - runs flows and checklists and also background flows.
--
-- @classmod FlowExecutor
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcFlowExecutor = {
	type_procedure = 0,
	type_checklist = 1,
	type_background = 2
}

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
		flow:setState(kcFlow.FINISH)
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
	if flowState == kcFlow.RUN then
	
		-- execute the flow step by step
		local stepState = step:getState()
		if self.flow:getClassName() == "Checklist" then
			kc_wnd_flow_action = 1 -- open flow window for checklist
		end

		if self.flow:getActiveItemIndex() == 0 then
			kc_speakNoText(0,self.flow:getSpeakName())
			self.flow:setActiveItemIndex(1)
			return
		end

		self.nextStepTime = kc_getPcTime() + step:getWaitTime()

		-- initial state
		if stepState == kcFlowItem.INIT then
			-- speak challenge text, for procedures this is the whole line
			step:speakChallengeText()
			-- execute automatic steps if available
			if getActivePrefs():get("general:assistance") > 2 then
				step:execute()
			end

			if not step:isValid() then
				step:setState(kcFlowItem.FAIL)
				self.flow:setState(kcFlow.HALT)
				if self.flow:getClassName() == "Checklist" then
					if step:getClassName() == "ManualChecklistItem" then
						step:execute()
					end
				end
			end
			if self.flow:getClassName() == "Checklist" and step:getState() ~= kcFlowItem.RUN and step:getClassName() ~= "SimpleChecklistItem" then
				step:setState(kcFlowItem.PAUSE)
				self.flow:setState(kcFlow.PAUSE)
			end
			if step:isValid() then
				if step:getWaitTime() > 0 then
					self.flow:setState(kcFlow.WAIT)
				else
					step:setState(kcFlowItem.DONE)
				end
			end
		elseif stepState == kcFlowItem.RUN then
			if step:isValid() then
				step:speakResponseText()
				if step:getWaitTime() > 0 then
					self.flow:setState(kcFlow.WAIT)
				else
					step:setState(kcFlowItem.DONE)
				end
			end

		elseif stepState == kcFlowItem.FAIL then
			if step:isValid() then
				step:setState(kcFlowItem.PAUSE)
			end
				
		elseif stepState == kcFlowItem.SKIP then
			jump2NextStep(self.flow)	
			
		elseif stepState == kcFlowItem.RESUME then
			if not step:isValid() then
				step:setState(kcFlowItem.FAIL)
			end
			if step:isValid() then
				if step:getWaitTime() > 0 then
					self.flow:setState(kcFlow.WAIT)
				else
					step:speakResponseText()
					step:setState(kcFlowItem.DONE)
				end
			end
		elseif stepState == kcFlowItem.DONE then
			jump2NextStep(self.flow)

		else
			-- do nothing
		end
		
	-- waiting on delay
	elseif flowState == kcFlow.WAIT then
		if kc_getPcTime() >= self.nextStepTime then 
			step:setState(kcFlowItem.DONE)
			jump2NextStep(self.flow)
			self.flow:setState(kcFlow.RUN)
		end
		
	-- paused by user or fail
	elseif flowState == kcFlow.HALT then
		if step:isValid() then
			step:setState(kcFlowItem.RESUME)
			self.flow:setState(kcFlow.RUN)
		end

	elseif flowState == kcFlow.FINISH then

	else
		-- whatever needed when states do not match
	end

end

return kcFlowExecutor