-- DFLT  airplane 
-- Electric system functionality
local sysElectric = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefAPURunning = "sim/cockpit2/electrical/APU_running"

local drefLowVoltage = "sim/cockpit2/annunciators/low_voltage"

-- LOW VOLTAGE 0=off 1=running
function sysElectric.getLowVoltageLight()
	return get(drefLowVoltage)
end

-- APU status 0=off 1=running
function sysElectric.getAPULight()
	return get(drefAPURunning)
end

return sysElectric