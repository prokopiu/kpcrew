-- DFLT airplane 
-- Anti Ice functionality
local sysAice = {
	Off = 0,
	On = 1,
	Toggle = 2,
	Left = "Left",
	Right = "Right",
	Wing = "Wing",
	Engine = "Engine"
}

local drefAiceWingLeft = "sim/cockpit/switches/anti_ice_surf_heat"
local drefAiceEng1 = "sim/cockpit/switches/anti_ice_inlet_heat"

-- Honeycomb anti ice annunciatir
function sysAice.getAntiIceLight()
	if get(drefAiceWingLeft) > 0 or get(drefAiceEng1) > 0 then
		return 1
	else
		return 0
	end
end

return sysAice