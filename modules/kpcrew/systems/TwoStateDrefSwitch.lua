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
			if self.datarefidx == 0 then
				set(self.dataref,action)
			else
				set_array(self.dataref,self.datarefidx,action)
			end
		end
	else
		if self:getStatus() ~= modeOff then
			if self.datarefidx == 0 then
				set(self.dataref,Switch.modeOff)
			else
				set_array(self.dataref,self.datarefidx,Switch.modeOff)
			end
		else
			if self.datarefidx == 0 then
				set(self.dataref,Switch.modeOn)
			else
				set_array(self.dataref,self.datarefidx,Switch.modeOn)
			end
		end
	end
end

-- set the value directly where possible (dref can be written)
function TwoStateDrefSwitch:setValue(value)
	if self.statusDrefIdx > 0 then
		set_array(self.statusDref,self.statusDrefIdx,value)
	else
		set(self.statusDref,value)
	end
end

return TwoStateDrefSwitch


