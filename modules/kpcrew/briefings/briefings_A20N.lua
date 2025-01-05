-- Aircraft specific briefing values and functions - ToLiss A20N/A21N
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
kc_acf_name 		= "ToLiss A20N/A21N"

kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps 	= "0|1+F|2|3"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_TakeoffApModes 	= "MANAGED|HDG/VS"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "2|3|FULL"
kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingPacks 	= "OFF|ON"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_MELIssues 		= "no M E L issues|some M E L issues"

-- aircraft specs, weights in KG
-- EMPTY WEIGHT:			41000 KG -  90389 LBS
-- MAX ZERO FUEL WEIGHT:	63000 KG -  11684 LBS
-- MAX TAKEOFF WEIGHT:		78000 KG - 174200 LBS
-- MAX LANDING WEIGHT:		66000 KG - 171961 LBS
-- MAX FUEL CAPACITY:		18740 KG -  41315 LBS
-- FUEL FLOW PER HOUR:		 1352 KG -   2980 LBS
kc_DOW 				= 41000		-- Dry Operating Weight (aka OWE)kc_MZFW  			= 73800		-- Maximum Zero Fuel Weightkc_MaxFuel 			= 31322		-- Maximum Fuel Capacitykc_MaxPayld 		= 28400		-- Maximum Payload to be setkc_MTOW 			= 93000		-- Maximum Takeoff Weightkc_MLW  			= 77800		-- Maximum Landing Weightkc_FFPH 			=  2187		-- Average Fuel Flow per hour
kc_NumEngines		=     2		-- Number of engines
kc_NumTanks			=     3		-- Number of tankskc_MFL1				=  6114		-- max fuel in tank leftkc_MFL2				= 19093		-- max fuel in tank centerkc_MFL3				=  6114		-- max fuel in tank right-- Operating speedskc_speeds_vs0		= 115		-- Stall Speed, Landing Configuration Vso 115 KIASkc_speeds_vs1		= 136		-- Stall Speed, Clean Vs1 136 KIASkc_speeds_vs		= 140		-- Minimum Controllable Speed Vs 140 KIASkc_speeds_vx		= 270		-- Best Angle of Climb Vx 270 KIASkc_speeds_vy		= 300		-- Best Rate of Climb Vy 300 KIASkc_speeds_vfe		= 180		-- Maximum flaps Extended Speed Vfe 180 KIASkc_speeds_vmo1		= 270		-- Maximum Operating Speed (Sea Level to 8,000 ft) Vmo 270 KIASkc_speeds_vmo2		= 350		-- Maximum Operating Speed (Above 8,000 ft) Vmo 350 KIASkc_speeds_vmo3		= 0.935		-- Maximum Mach Number Vmo 0.935 Machkc_speeds_vle		= 210		-- Maximum Gear Operating Speed Vle 210 KIASkc_speeds_vlo		= 210		-- Maximum Gear Extended Speed Vlo 210 KIAS-- Altitudeskc_max_altitude		= 40000 -- Max Altitude
-- full list of approach types can be overwritten by aircraft
APP_apptype_list 	= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
APP_apu_list 		= "APU delayed start|APU|GPU"

-- Reverse Thrust
APP_rev_thrust_list = "NONE|MINIMUM|FULL"

-- ======= Aircraft specific functionsfunction kc_get_DOW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_DOW
	else
		return kc_DOW * 2.20462262
	end
end

function kc_get_MZFW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MZFW
	else
		return kc_MZFW * 2.20462262
	end
end

function kc_get_MaxFuel()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MaxFuel
	else
		return kc_MaxFuel * 2.20462262
	end
end

function kc_get_MTOW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MTOW
	else
		return kc_MTOW * 2.20462262
	end
end

function kc_get_MLW()
	if activePrefSet:get("general:weight_kgs") then
		return kc_MLW
	else
		return kc_MLW * 2.20462262
	end
end

function kc_get_FFPH()
	if activePrefSet:get("general:weight_kgs") then
		return kc_FFPH
	else
		return kc_FFPH * 2.20462262
	end
end

function kc_get_total_fuel()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_fuel_total")
	else
		return get("sim/flightmodel/weight/m_fuel_total")*2.20462262
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

function kc_set_payload()

end