-- DFLT airplane 
-- Fuel related functionality
local sysFuel = {
	Off = 0,
	On = 1,
	Toggle = 2
}

local drefFuelPressLow = "sim/cockpit2/annunciators/fuel_pressure_low"

-- fuel press low light
function sysFuel.getFuelPressLowLight()
	local sumit = get(drefFuelPressLow,0) + get(drefFuelPressLow,1) + get(drefFuelPressLow,2) + get(drefFuelPressLow,3)
	if sumit > 0 then
		return 1
	else
		return 0
	end
end

return sysFuel