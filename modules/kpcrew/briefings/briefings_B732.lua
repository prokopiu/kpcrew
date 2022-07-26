kc_acf_name = "FlyJsim Boeing 737-200"

kc_TakeoffThrust = "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps = "1|2|5|10|15|25"
kc_TakeoffAntiice = "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks = "ON|AUTO|OFF"
kc_TakeoffBleeds = "OFF|ON|UNDER PRESSURIZED"
kc_TakeoffApModes = "LNAV/VNAV|HDG/FLCH"
kc_apptypes = "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps = "15|30|40"
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingPacks = "OFF|ON|UNDER PRESSURIZED"
kc_LandingAntiice = "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence = "2 THEN 1|1 THEN 2"

-- full list of approach types can be overwritten by aircraft
APP_apptype_list = "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
APP_apu_list = "APU delayed start|APU|GPU"

-- Reverse Thrust
APP_rev_thrust_list = "NONE|MINIMUM|FULL"

function kc_get_total_fuel()
	if activePrefSet:get("general:weight_kgs") then
		return get("laminar/B738/fuel/total_tank_kgs")
	else
		return get("laminar/B738/fuel/total_tank_lbs")
	end
end

function kc_get_gross_weight()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.20462262
	end	
end

function kc_get_zfw()
	return kc_get_gross_weight()-kc_get_total_fuel()
end