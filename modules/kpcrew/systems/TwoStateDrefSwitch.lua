-- switch with mode on/off and toggle function via dataref
local TwoStateDrefSwitch = {}

utils = require "kpcrew.genutils"
Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, dref to set mode in
function TwoStateDrefSwitch:new(name, dataref, datarefidx)

    TwoStateDrefSwitch.__index = TwoStateDrefSwitch
    setmetatable(TwoStateDrefSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, TwoStateDrefSwitch)

	obj.dataref = dataref
	obj.datarefidx = datarefidx
	
    return obj
end

-- return value of status dataref
function TwoStateDrefSwitch:getStatus()
	return get(self.dataref,self.datarefidx)
end

-- actuate the switch with given mode
function TwoStateDrefSwitch:actuate(action)
	if action ~= Switch.modeToggle then
		if self:getStatus() ~= action then
			set_array(self.dataref,self.datarefidx,action)
		end
	else
		if self:getStatus() ~= modeOff then
			set_array(self.dataref,self.datarefidx,Switch.modeOff)
		else
			set_array(self.dataref,self.datarefidx,Switch.modeOn)
		end
	end
end

return TwoStateDrefSwitch


