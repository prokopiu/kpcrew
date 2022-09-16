-- switch with mode on/off and toggle function via dataref
--
-- @classmod TwoStateDrefSwitch
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local khTwoStateDrefSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, dref to set mode in
-- @tparam string name of element
-- @tparam string dataref for elemnts status
-- @tparam int index of element dataref
-- @treturn Switch the created base element
function khTwoStateDrefSwitch:new(name, dataref, datarefidx)

    khTwoStateDrefSwitch.__index = khTwoStateDrefSwitch
    setmetatable(khTwoStateDrefSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name, dataref, datarefidx)
    setmetatable(obj, khTwoStateDrefSwitch)

    return obj
end

-- actuate the switch with given mode
-- @tparam int action 0=off 1=on 2=tgl
function khTwoStateDrefSwitch:actuate(action)
	if action ~= modeToggle then
		if self:getStatus() ~= action then
			self:setValue(action)
		end
	else
		if self:getStatus() ~= 0 then
			self:setValue(0)
		else
			self:setValue(1)
		end
	end
end

return khTwoStateDrefSwitch


