-- DFLT airplane 
-- Engine related functionality
local sysEngines = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local cmdReverseThrustSet = "sim/engines/thrust_reverse_hold"
local drefReverseThrustMode = "sim/cockpit/warnings/annunciators/reverse"

-- Reverse 0=OFF 1=Full and in between values
function sysEngines.setReverseThrust(mode)
	if mode == sysEngines.On then
		command_once(cmdReverseThrustSet)
	end
end

function sysEngines.getReverseThrust()
	set(drefReverseThrustMode)
end

return sysEngines