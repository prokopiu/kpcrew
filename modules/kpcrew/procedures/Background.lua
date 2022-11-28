-- Procedure with background items
--
-- @classmod Background
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local kcBackground = {
}

local Flow				= require "kpcrew.Flow"

-- Instantiate a new Background flow
-- @tparam string name Name of the set (also used as title)
function kcBackground:new(name, speakname, finalstatement)
    kcBackground.__index = kcBackground
   setmetatable(kcBackground, {
        __index = Flow
    })
    local obj = Flow:new(name, speakname, finalStatement)
    setmetatable(obj, kcBackground)

	obj.className = "Background"
	obj.finalStatement = finalstatement
	obj.spokenName = speakname

    return obj
end

-- reset procedure and all below items
function kcBackground:reset()
    self:setState(Flow.RUN)
    self.activeItemIndex = 0
	self.nameSpoken = false
	self.finalSpoken = false
	-- reset all items in procedure
    for _, item in ipairs(self.items) do
        item:reset()
    end
end

return kcBackground