-- DFLT airplane 
-- Hydraulic system functionality
local sysHydraulic = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefHydPressure1 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

-- Low hydraukic pressure light
function sysHydraulic.getLowHydPressLight()
	if get(drefHydPressure1) < 0.1 or get(drefHydPressure2) < 0.1 then
		return 1
	else
		return 0
	end
end

return sysHydraulic