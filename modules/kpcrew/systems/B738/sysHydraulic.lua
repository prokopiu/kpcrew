-- B738 airplane 
-- Hydraulic system functionality
local sysHydraulic = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefHydPressure1 = "laminar/B738/annunciator/hyd_el_press_a"
local drefHydPressure2 = "laminar/B738/annunciator/hyd_el_press_b"

-- Low hydraukic pressure light
function sysHydraulic.getLowHydPressLight()
	if get(drefHydPressure1) == 1 or get(drefHydPressure2) == 1 then
		return 1
	else
		return 0
	end
end

return sysHydraulic