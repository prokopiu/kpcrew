-- switch with mode on/off and toggle function via dataref
local TwoStateDrefSwitch = {}

local Switch = require "kpcrew.systems.Switch"

-- provide the dataref with switch state, dref to set mode in
function TwoStateDrefSwitch:new(name, dataref, datarefidx)

    TwoStateDrefSwitch.__index = TwoStateDrefSwitch
    setmetatable(TwoStateDrefSwitch, {
        __index = Switch
    })

    local obj = Switch:new(name)
    setmetatable(obj, TwoStateDrefSwitch)

	obj.name = name
	obj.dataref = dataref
	obj.datarefidx = datarefidx
	
    return obj
end

-- return value of status dataref
function TwoStateDrefSwitch:getStatus()
	if self.datarefidx < 0 then
		return get(self.dataref,0)
	else
		return get(self.dataref,self.datarefidx)
	end
end

-- actuate the switch with given mode
function TwoStateDrefSwitch:actuate(action)
	if action ~= modeToggle then
		if self:getStatus() ~= action then
			if self.datarefidx == 0 then
				set(self.dataref,action)
			else
				if self.datarefidx == -1 then
					set_array(self.dataref,0,action)
				else
					set_array(self.dataref,self.datarefidx,action)
				end
			end
		end
	else
		if self:getStatus() ~= 0 then
			if self.datarefidx == 0 then
				set(self.dataref,0)
			else
				if self.datarefidx == -1 then
					set_array(self.dataref,0,0)
				else
					set_array(self.dataref,self.datarefidx,0)
				end
			end
		else
			if self.datarefidx == 0 then
				set(self.dataref,1)
			else
				if self.datarefidx == -1 then
					set_array(self.dataref,0,1)
				else
					set_array(self.dataref,self.datarefidx,1)
				end
			end
		end
	end
end

-- set the value directly where possible (dref can be written)
function TwoStateDrefSwitch:setValue(value)
	if self.datarefidx == 0 then
		set(self.dataref,value)
	else
		if self.datarefidx == -1 then
			set_array(self.dataref,0,value)
		else
			set_array(self.dataref,self.datarefidx,value)
		end
	end
end

return TwoStateDrefSwitch


