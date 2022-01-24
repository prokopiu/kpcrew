-- B738 airplane 
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

local drefAiceWingLeft = "laminar/B738/annunciator/wing_ice_on_L"
local drefAiceWingRight = "laminar/B738/annunciator/wing_ice_on_R"
local drefAiceEng1 = "laminar/B738/annunciator/cowl_ice_on_0"
local drefAiceEng2 = "laminar/B738/annunciator/cowl_ice_on_1"

-- Honeycomb anti ice annunciatir
function sysAice.getAntiIceLight()
	if get(drefAiceWingLeft) > 0 or get(drefAiceWingRight) > 0 or get(drefAiceEng1) > 0 or get(drefAiceEng2) > 0  then
		return 1
	else
		return 0
	end
end

return sysAice