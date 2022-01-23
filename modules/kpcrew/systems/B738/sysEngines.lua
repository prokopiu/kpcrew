-- B738 airplane 
-- Engine related functionality
local sysEngines = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local cmdReverseThrustSet = "sim/engines/thrust_reverse_hold"
local drefReverseThrustMode = "sim/cockpit/warnings/annunciators/reverse"

local drefEngine1Starter = "laminar/B738/air/engine1/starter_valve"
local drefEngine2Starter = "laminar/B738/air/engine2/starter_valve"

local drefEngine1Oil = "laminar/B738/engine/eng1_oil_press"
local drefEngine2Oil = "laminar/B738/engine/eng2_oil_press"

local drefEngine1Fire = "laminar/B738/annunciator/engine1_fire"
local drefEngine2Fire = "laminar/B738/annunciator/engine2_fire"
local drefAPUFire = "laminar/B738/annunciator/apu_fire"

-- Honeycomb engine fire annunciator (includes APU)
function sysEngines.getFireLight()
	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then
		return 1
	else
		return 0
	end
end

-- Honeycomb engine oil pressure annunciator
function sysEngines.getOilLight()
	if get(drefEngine1Oil) == 0 or get(drefEngine2Oil) == 0 then
		return 1
	else
		return 0
	end
end

-- Honeycomb engine starter annunciator
function sysEngines.getStarterLight()
	if get(drefEngine1Starter) == 0 and get(drefEngine2Starter) == 0 then
		return 0
	else
		return 1
	end
end

-- Reverse 0=OFF 1=Full and in between values
function sysEngines.setReverseThrust(mode)
	if mode == sysEngines.On then
		command_begin(cmdReverseThrustSet)
	end
	if mode == sysEngines.Off then
		command_end(cmdReverseThrustSet)
	end
end

function sysEngines.getReverseThrust()
	set(drefReverseThrustMode)
end

return sysEngines