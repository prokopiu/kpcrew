-- "Hold" Procedure Item to be added to procedures
-- This will stop the procedure until the CPT/PF presses the Master button
--
-- @classmod HoldProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcHoldProcedureItem = {
	colorInitial		= color_white,
	colorActive 		= color_white,
	colorPause			= color_orange,
	colorFailed 		= color_white,
	colorSuccess		= color_white,
	colorSkipped		= color_white,
	colorManual			= color_white
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new IndirectProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcHoldProcedureItem:new(challengeText,responseText,actor,actionFunc,skipFunc)
    kcHoldProcedureItem.__index = kcHoldProcedureItem
    setmetatable(kcHoldProcedureItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,0,nil,actionFunc,skipFunc)
    setmetatable(obj, kcHoldProcedureItem)

	obj.valid = false
	obj.color = color_white

	obj.className = "HoldProcedureItem"
	
	kc_procvar_initialize_bool("waitformaster",false)

    return obj
end

function kcHoldProcedureItem:getWaitTime()
	return 0
end
-- reset the item to its initial state
function kcHoldProcedureItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = false
	self.color = color_white
	kc_procvar_set("waitformaster",false)
end

-- are the conditions for this item met?
function kcHoldProcedureItem:isValid()
	return kc_procvar_get("waitformaster")
end

-- speak the challenge text
function kcHoldProcedureItem:speakChallengeText()
 -- do nothing
end

-- no challenge response
function kcHoldProcedureItem:speakResponseText()
	-- do nothing
end

function kcHoldProcedureItem:getStateColor()
	local statecolors = { 
		self.colorInitial,	-- INIT 
		self.colorActive,   -- RUN
		self.colorPause,    -- PAUSE
		self.colorFailed,   -- FAIL
		self.colorSuccess,  -- DONE
		self.colorManual,   -- SKIP
		self.colorActive	-- RESUME 
	}
	return statecolors[self.state + 1]
end

-- get the current state of this checklist item
-- @treturn int get state id
function kcHoldProcedureItem:getState()
	if type(self.skipFunc) == 'function' then
		if self.skipFunc() then
			return self.SKIP
		end
	end
    return self.state
end

return kcHoldProcedureItem