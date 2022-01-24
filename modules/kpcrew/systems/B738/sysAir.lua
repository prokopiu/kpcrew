-- B738 airplane 
-- Air and Pneumatics functionality
local sysAir = {
	Off = 0,
	On = 1,
	Toggle = 2,
	Left = "Left",
	Right = "Right"
}

local drefPackLeftANC = "laminar/B738/annunciator/pack_left"
local drefPackRightANC = "laminar/B738/annunciator/pack_right"

-- Vacuum light shows B738 PACK annunciator status
function sysAir.getVacuumLight()
	if get(drefPackLeftANC) > 0 or get(drefPackRightANC) > 0 then
		return 1
	else
		return 0
	end
end

return sysAir