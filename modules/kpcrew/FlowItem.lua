-- Standard Flow Item to be added to procedures or checklists
--
-- @classmod ProcedureItem
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu

local kcFlowItem = {
    stateInitial 		= 0,
    stateInProgress 	= 1,
    stateSuccess 		= 2,
    stateFailed 		= 3,
    stateDoneManually 	= 4,
	stateSkipped		= 5,

	actorPF 			= "PF",		-- pilot flying (you)
	actorPNF 			= "PNF",	-- pilot not flying (virtual)
	actorPM 			= "PM",		-- pilot monitoring (virtual)
	actorBOTH 			= "BOTH",	-- both have responses
	actorFO 			= "F/O",	-- first officer (virtual)
	actorCPT 			= "CPT",	-- captain (you)
	actorLHS 			= "LHS",	-- left hand seat (you)
	actorRHS 			= "RHS",	-- right hand seat (virtual)
	actorFE				= "FE",		-- flight engineer on some aircraft (virtual)
	actorALL 			= "ALL",
	actorNONE 			= "",

	colorInitial		= color_grey,
	colorActive 		= color_white,
	colorSuccess		= color_green,
	colorFailed 		= color_red,
	colorManual			= color_dark_green,
	colorSkipped		= color_white
}

-- Instantiate a new FlowItem
-- @tparam string challengeText is the left hand text 
-- @tparam string responseText is specific state of the item
-- @tparam string actor is the actor for the item; see list below
-- @tparam int wait time in seconds during execution 
-- @tparam function reference validFunc shall return true or false to verify if condition is met
-- @tparam function reference  actionFunc will be executed and make changes to aircraft settings
-- @tparam function reference  skipFunc if true will skip the item and not diaply in list
function kcFlowItem:new(challengeText,responseText,actor,waittime,validFunc,actionFunc,skipFunc)
    kcFlowItem.__index = kcFlowItem
    local obj = {}
    setmetatable(obj, kcFlowItem)

	obj.state = kcFlowItem.stateInitial
	obj.challengeText = challengeText
	obj.responseText = responseText	
	obj.origResponseText = responseText
	obj.actor = actor
	obj.waittime = waittime
	obj.valid = true
	obj.color = kcFlowItem.colorInitial
	obj.validFunc = validFunc
	obj.actionFunc = actionFunc
	obj.skipFunc = skipFunc
	obj.className = "FlowItem"

    return obj
end

function kcFlowItem:getClassName()
	return self.className
end

-- get the actor string for this checklist item
function kcFlowItem:getActor()
	return self.actor
end

-- get the left hand action text for the item
function kcFlowItem:getChallengeText()
    return self.challengeText
end

-- set left hand action text
function kcFlowItem:setChallengeText(text)
	self.challengeText = text
end

-- get the right hand result text for the item
function kcFlowItem:getResponseText()
	if string.find(self.responseText,"%%") == nil then
		return self.responseText
	else
		if string.find(self.responseText,"|") == nil then
			return self.responseText
		else
			local resArr = kc_split(self.responseText,"|")
			kcLoadString = "return string.format(\"" .. resArr[1] .. "\""
			if table.getn(resArr) > 1 then kcLoadString = kcLoadString .. "," .. resArr[2] end
			if table.getn(resArr) > 2 then kcLoadString = kcLoadString .. "," .. resArr[3] end
			if table.getn(resArr) > 3 then kcLoadString = kcLoadString .. "," .. resArr[4] end
			kcLoadString = kcLoadString .. ")"
			local resStr = loadstring(kcLoadString)
			return resStr()
		end
	end
end

-- set the right hand result text for the item
function kcFlowItem:setResponseText(text)
	self.responseText = text
end

-- get the time in seconds this item is to be waited on
function kcFlowItem:getWaitTime()
	return self.waittime
end

-- set the wait time in seconds
function kcFlowItem:setWaitTime(seconds)
	self.waittime = seconds
end

-- change the state of the checklist item
function kcFlowItem:setState(state)
    self.state = state
end

-- get the current state of this checklist item
function kcFlowItem:getState()
	if type(self.skipFunc) == 'function' then
		if self.skipFunc() then
			return kcFlowItem.stateSkipped
		end
	end
    return self.state
end

-- get current color of the procedure item
function kcFlowItem:getColor()
	return self.color
end

-- set the color of the checklist item
function kcFlowItem:setColor(color)
	self.color = color
end

-- return the color code linked to the state
function kcFlowItem:getStateColor()
	local statecolors = { self.colorInitial, self.colorActive, self.colorSuccess, self.colorFailed, self.colorManual, self.colorWhite }
	return statecolors[self.state + 1]
end

-- reset the item to its initial state
function kcFlowItem:reset()
    self:setState(kcFlowItem.stateInitial)
	self.challengeText = self.origChallengeText
	self.responseText = self.origResponseText
	self.valid = true
	self.color = kcFlowItem.colorInitial
end

-- are the conditions for this item met?
function kcFlowItem:isValid()
	if type(self.validFunc) == 'function' then
		self.valid = self.validFunc(self)
	end
    return self.valid
end

function kcFlowItem:execute()
	if type(self.actionFunc) == 'function' then
		self.actionFunc()
	end
end
	
-- return the visual line to put in the checklist displays
function kcFlowItem:getLine(lineLength)
	local line = {}
	local dots = lineLength - string.len(self.challengeText) - string.len(self:getResponseText()) - 7
	line[#line + 1] = self.challengeText
	local dotchar = "."
	if self:getResponseText() == "" then
		dotchar = " "
	end
	for i=0,dots-1,1 do
		line[#line + 1] = dotchar
	end
	line[#line + 1] = self:getResponseText()
	if self.actor ~= "" then
		line[#line + 1] = " ("
		line[#line + 1] = self.actor
		line[#line + 1] = ")"
	end
	
	return table.concat(line)
end

return kcFlowItem