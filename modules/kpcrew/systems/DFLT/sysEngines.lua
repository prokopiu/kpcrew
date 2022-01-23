-- DFLT airplane 
-- Engine related functionality
local sysEngines = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local cmdReverseThrustSet = "sim/engines/thrust_reverse_hold"
local drefReverseThrustMode = "sim/cockpit/warnings/annunciators/reverse"

local drefEngine1Starter = "sim/flightmodel2/engines/starter_is_running"
local drefEngine2Starter = "sim/flightmodel2/engines/starter_is_running"

local drefEngine1Oil = "sim/cockpit2/annunciators/oil_pressure"
local drefEngine2Oil = "sim/cockpit2/annunciators/oil_pressure"

local drefEngine1Fire = "sim/cockpit2/annunciators/engine_fire"
local drefEngine2Fire = "sim/cockpit2/annunciators/engine_fire"

-- Honeycomb engine fire annunciator (includes APU)
function sysEngines.getFireLight()
	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 then
		return 1
	else
		return 0
	end
end

-- Honeycomb engine oil pressure annunciator
function sysEngines.getOilLight()
	if get(drefEngine1Oil) == 1 or get(drefEngine2Oil) == 1 then
		return 1
	else
		return 0
	end
end

-- Honeycomb engine starter annunciator
function sysEngines.getStarterLight()
	if get(drefEngine1Starter,0) == 0 and get(drefEngine2Starter,1) == 0 then
		return 0
	else
		return 1
	end
end

-- Reverse 0=OFF 1=Full and in between values
function sysEngines.setReverseThrust(mode)
	if mode == sysEngines.On then
		command_once(cmdReverseThrustSet)
	end
end

function sysEngines.getReverseThrust()
	-- set(drefReverseThrustMode)
end

return sysEngines