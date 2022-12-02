-- Flow Executor - runs flows and checklists and also background flows.
--
-- @classmod FlowExecutor
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcFlowExecutor = {
}

local Flow				= require "kpcrew.Flow"
local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate FlowExecutor
function kcFlowExecutor:new(flow, bgrFlag)
    kcFlowExecutor.__index = kcFlowExecutor
    local obj = {}
    setmetatable(obj, kcFlowExecutor)

	obj.flow = flow
	if bgrFlag ~= nil then
		obj.bgr = bgrFlag
	else
		obj.bgr = false
	end
	obj.current_step = 0
	obj.nextStepTime = 0

    return obj
end

-- set flow to execute
function kcFlowExecutor:setFlow(flow)
	self.flow = flow
end

-- step forward in flow or stop
local function jump2NextStep(flow, bgr)
	local bgrFlag = false
	if bgr == nil then
		bgrFlag = false
	else
		bgrFlag = bgr
	end
	if not flow:hasNextItem() then
		if bgrFlag == true then
			flow:reset()
		else
			flow:setState(Flow.FINISH)
		end
	else
		flow:setNextItemActive()
	end
end

-- regular background executor function
function kcFlowExecutor:execute()

	-- retrieve current state of flow and to be executed step
	if self.bgr == true then
		self.flow = getActiveSOP():getBackgroundFlow()
		self.flow:setState(Flow.RUN)
	else
		self.flow = getActiveSOP():getActiveFlow()
	end
	local flowState = self.flow:getState()
	local step = self.flow:getActiveItem()
	-- stop if no valid step can be found
	if step == nil then
		return
	end
	-- local stepState = step:getState()
	
	-- logMsg("Flow: [" .. self.flow:getClassName() .. "] " .. "State: " .. self.flow.states[flowState+1] )
	
	-- initializes the flow by setting it into START mode
	if flowState == Flow.START then

		self.nextStepTime = 0

		-- if preferences have the flow windows open automatically
		if activePrefSet:get("general:flowAutoOpen") == true and self.flow:getClassName() ~= "State" then
			if kc_show_flow ~= true or kc_flow_wnd == nil then
				kc_wnd_flow_action = 1 -- open flow window for active flow
				kc_toggle_flow_window()
			end
		end
		
		-- set the associated flight state
		activeBckVars:set("general:flight_state",self.flow:getFlightPhase())
		
		-- speak initial string of the Flow
		if self.flow:getActiveItemIndex() == 0 then
			self.flow:speakName()
			self.flow:setActiveItemIndex(1)
		end

		-- checklist have special steps
		if self.flow:getClassName() == "Checklist" then
			
			-- if checklist execute all automatic items prior to running the checklist
			if activePrefSet:get("general:assistance") > 2 then
				for _, item in ipairs(self.flow:getAllItems()) do
					if item:getState() ~= FlowItem.SKIP then
						item:execute()
					end
				end
			end
		end

		-- make flow start executing
		self.flow:setState(Flow.RUN)
		
	-- running flow
	elseif flowState == Flow.RUN then
	
		-- execute the flow step by step
		logMsg("Step: [" .. step:getClassName() .. "] State: " .. step.states[step:getState()+1] .. " \"" .. step:getChallengeText() .. "\"")

		-- initial state
		if step:getState() == FlowItem.INIT then

			-- speak challenge text. procedure items remain silent
			step:speakChallengeText()

			if self.flow:getClassName() == "Checklist" then
				-- calculate delay for challenge spoken text
				if self.nextStepTime == 0 then
					local _,n = string.gsub(step:getChallengeText(),"%S+","")
					self.nextStepTime = kc_getPcTime() + n/3
					step:setState(FlowItem.PAUSE)
				end
			else
				-- execute automatic steps if available for procedures only
				if getActivePrefs():get("general:assistance") > 2 then
					step:execute()
				end
				step:setState(FlowItem.RUN)
			end 
			kc_procvar_set("waitformaster",false)

		end

		-- running steps 
		if step:getState() == FlowItem.RUN then

			-- check procedure item validity and set into FAIL mode and stop flow until the problem is fixed
			if not step:isValid() then
				step:setState(FlowItem.FAIL)
				self.flow:setState(Flow.HALT)
				return -- do not continue from here
			end

			-- calculate wait time against PC time
			if step:getWaitTime() > 0 then 
				if self.nextStepTime == 0 then
					self.nextStepTime = kc_getPcTime() + step:getWaitTime()
					step:setState(FlowItem.PAUSE)
					return
				end
			end

			if self.nextStepTime > 0 then 
				step:setState(FlowItem.PAUSE)
				return
			end

			if self.flow:getClassName() == "Checklist" then
				if step:isUserRole() then
					step:setState(FlowItem.PAUSE)
					self.flow:setState(Flow.PAUSE)
				else
					step:setState(FlowItem.DONE)
				end
			else
				step:setState(FlowItem.DONE)
			end
		end

		-- if in pause mode check the time and finish the item after being done
		if step:getState() == FlowItem.PAUSE then
			if kc_getPcTime() >= self.nextStepTime then 
				step:setState(FlowItem.RESUME)
				self.nextStepTime = 0
			end
		end

		-- Resume from halt
		if step:getState() == FlowItem.RESUME then
			if self.flow:getClassName() ~= "Checklist" then
				step:setState(FlowItem.DONE)
			else
				step:setState(FlowItem.RUN)
			end
		end 
		
		-- step is done and can be closed - next one to be selected if available
		if step:getState() == FlowItem.DONE then
			jump2NextStep(self.flow, self.bgr)
			kc_procvar_set("waitformaster",false)
		end 

	-- paused
	elseif flowState == Flow.PAUSE then

	-- halted by failure
	elseif flowState == Flow.HALT then

		-- check if current step is valid and the item can be continued
		if step:getState() == FlowItem.FAIL then
			if step:isValid() then
				step:setState(FlowItem.RESUME)
				self.flow:setState(Flow.RUN)
			end
		end

	--. At the end of the flow close window if set and speak final text
	elseif flowState == Flow.FINISH then
		if self.flow:getClassName() == "State" then 
			self.flow:reset()
		else
			if activePrefSet:get("general:flowAutoOpen") == true then
				if kc_show_flow then
					kc_toggle_flow_window()
				end
			end
			self.flow:speakFinal()
			if activePrefSet:get("general:flowAutoJump") == true then
				getActiveSOP():setNextFlowActive()
			end
		end
	else
		-- whatever needed when states do not match
	end

end

return kcFlowExecutor