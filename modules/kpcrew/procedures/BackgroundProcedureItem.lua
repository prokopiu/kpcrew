-- "Background" Procedure Item to be added to procedures
-- An background item will start when the procvar is true and stop when the procvar is set to false
--
-- @classmod BackgroundProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcBackgroundProcedureItem = {
	colorFailed = color_orange
}

local FlowItem 			= require "kpcrew.FlowItem"

-- Instantiate a new IndirectProcedureItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcBackgroundProcedureItem:new(challengeText,responseText,actor,waittime,actionFunc)
    kcBackgroundProcedureItem.__index = kcBackgroundProcedureItem
    setmetatable(kcBackgroundProcedureItem, {
        __index = FlowItem
    })
    local obj = FlowItem:new(challengeText,responseText,actor,waittime,nil,actionFunc,nil)
    setmetatable(obj, kcBackgroundProcedureItem)

	obj.valid = true
	obj.color = color_orange
	-- obj.procvar = procvar

	obj.conditionMet = false  -- if condition was met set to true
	obj.className = "BackgroundProcedureItem"
	
    return obj
end

-- reset the item to its initial state
function kcBackgroundProcedureItem:reset()
    self:setState(FlowItem.INIT)
	self.valid = true
	self.color = color_orange
	self.conditionMet = true
end

-- are the conditions for this item met?
function kcBackgroundProcedureItem:isValid()
	return true
end

-- speak the challenge text
function kcBackgroundProcedureItem:speakChallengeText()
	-- do nothing
end

-- no challenge response
function kcBackgroundProcedureItem:speakResponseText()
	-- do nothing
end

return kcBackgroundProcedureItem