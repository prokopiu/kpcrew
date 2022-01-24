-- DFLT airplane 
-- Air and Pneumatics functionality
local sysAir = {
	Off = 0,
	On = 1,
	Toggle = 2,
	Left = "Left",
	Right = "Right"
}

local drefAirANC = "sim/cockpit/warnings/annunciators/bleed_air_off"

-- Vacuum light shows B738 PACK annunciator status
function sysAir.getVacuumLight()
	if get(drefAirANC,0) > 0 or get(drefAirANC,1) > 0 then
		return 1
	else
		return 0
	end
end

return sysAir