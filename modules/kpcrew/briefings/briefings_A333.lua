-- Aircraft specific briefing values and functions - Laminar A330-300
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

kc_acf_name = "Laminar A330-300"

kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps 	= "1|2"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON|UNDER PRESSURIZED"
kc_TakeoffApModes 	= "LNAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "3|4"
kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingPacks 	= "OFF|ON|UNDER PRESSURIZED"
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

kc_DOW 				= 41000  -- Dry Operating Weight (aka OEW)
kc_MZFW  			= 63000  -- Maximum Zero Fuel Weight
kc_MaxFuel 			= 18740  -- Maximum Fuel Capacity
kc_MaxPayld 		= 22000  -- Maximum Payload to be set
kc_MTOW 			= 78000  -- Maximum Takeoff Weight
kc_MLW  			= 66000  -- Maximum Landing Weight
kc_FFPH 			=  1352  -- Fuel Flow per hour
kc_MFL1				=   850  -- max fuel in tank left aux
kc_MFL2				=  5530  -- max fuel in tank left
kc_MFL3				=  5960  -- max fuel in tank center
kc_MFL4				=  5530  -- max fuel in tank right
kc_MFL5				=   850  -- max fuel in tank right aux

-- Operating speeds
kc_speeds_vs0		= 115		-- Stall Speed, Landing Configuration Vso 115 KIAS
kc_speeds_vs1		= 136		-- Stall Speed, Clean Vs1 136 KIAS
kc_speeds_vs		= 140		-- Minimum Controllable Speed Vs 140 KIAS
kc_speeds_vx		= 270		-- Best Angle of Climb Vx 270 KIAS
kc_speeds_vy		= 300		-- Best Rate of Climb Vy 300 KIAS
kc_speeds_vfe		= 180		-- Maximum flaps Extended Speed Vfe 180 KIAS
kc_speeds_vmo1		= 270		-- Maximum Operating Speed (Sea Level to 8,000 ft) Vmo 270 KIAS
kc_speeds_vmo2		= 350		-- Maximum Operating Speed (Above 8,000 ft) Vmo 350 KIAS
kc_speeds_vmo3		= 0.935		-- Maximum Mach Number Vmo 0.935 Mach
kc_speeds_vle		= 210		-- Maximum Gear Operating Speed Vle 210 KIAS
kc_speeds_vlo		= 210		-- Maximum Gear Extended Speed Vlo 210 KIAS

-- Altitudes
kc_max_altitude		= 40000 -- Max Altitude

-- Briefing flags (not used at this time)
-- kc_show_load_button = false
-- kc_show_cost_index 	= false
-- kc_show_fmc_buttons = false
-- kc_show_arr_atis_button = false
-- kc_type_airbus = false
-- kc_type_boeing = false

-- full list of approach types can be overwritten by aircraft
APP_apptype_list 	= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
APP_apu_list 		= "APU delayed start|APU|GPU"

-- Reverse Thrust
APP_rev_thrust_list = "NONE|MINIMUM|FULL"

-- Get Dry Operating Weight. 
-- Use X-Planes empty weight if variable not set
function kc_get_DOW()
	if kc_DOW == -1 then
		kc_DOW = get("sim/aircraft/weight/acf_m_empty")
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_DOW
	else
		return kc_DOW * 2.20462262
	end
end

-- Maximum Fuel Capacity
function kc_get_MaxFuel()
	if kc_MaxFuel == -1 then
		kc_MaxFuel = get("sim/aircraft/weight/acf_m_fuel_tot")
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MaxFuel
	else
		return kc_MaxFuel * 2.20462262
	end
end

-- Maximum Zero Fuel Weight
-- Calculated from max weight - max fuel weight
function kc_get_MZFW()
	if kc_MZFW == -1 then
		kc_MZFW = get("sim/aircraft/weight/acf_m_max") - kc_get_MaxFuel()
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MZFW
	else
		return kc_MZFW * 2.20462262
	end
end

-- Maximum takeoff weight as approximation = max aircraft weight
function kc_get_MTOW()
	if kc_MTOW == -1 then
		kc_MTOW = get("sim/aircraft/weight/acf_m_max")
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MTOW
	else
		return kc_MTOW * 2.20462262
	end
end

-- Maximum Landing Weight as approximation 80% of MTOW
function kc_get_MLW()
	if kc_MLW == -1 then
		kc_MLW = kc_MTOW * 0.8
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MLW
	else
		return kc_MLW * 2.20462262
	end
end

-- Get current overall fuel flow
function kc_get_FFPH()
	if activePrefSet:get("general:weight_kgs") then
		return kc_FFPH
	else
		return kc_FFPH * 2.20462262
	end
end

-- Get total fuel loaded
function kc_get_total_fuel()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_fuel_total")
	else
		return get("sim/flightmodel/weight/m_fuel_total")*2.20462262
	end
end

-- Get current gross weight
function kc_get_gross_weight()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.20462262
	end	
end

-- Calculate current ZFW
function kc_get_zfw()
	return kc_get_gross_weight()-kc_get_total_fuel()
end

-- Set the payload for the aircraft
function kc_set_payload()
	local fgoal = activeBriefings:get("flight:takeoffFuel")
	
	if fgoal < kc_MFL2+kc_MFL4 then
		set("sim/custom/xap/fuel/t0",0)
		set("sim/custom/xap/fuel/t1",fgoal / 2)
		set("sim/custom/xap/fuel/t2",0)
		set("sim/custom/xap/fuel/t3",fgoal / 2)
		set("sim/custom/xap/fuel/t4",0)
	end
	if fgoal > kc_MFL2+kc_MFL4 then
		set("sim/custom/xap/fuel/t0",0)
		set("sim/custom/xap/fuel/t1",kc_MFL2)
		set("sim/custom/xap/fuel/t2",fgoal-kc_MFL2-kc_MFL4)
		set("sim/custom/xap/fuel/t3",kc_MFL4)
		set("sim/custom/xap/fuel/t4",0)
	end
	if fgoal > kc_MaxFuel-2*kc_MFL1 then
		set("sim/custom/xap/fuel/t0",(kc_MaxFuel-fgoal)/2)
		set("sim/custom/xap/fuel/t1",kc_MFL2)
		set("sim/custom/xap/fuel/t2",kc_MFL3)
		set("sim/custom/xap/fuel/t3",kc_MFL4)
		set("sim/custom/xap/fuel/t4",(kc_MaxFuel-fgoal)/2)
	end
	set("sim/aircraft/weight/acf_m_fuel_tot",fgoal)
end

-- set the takeoff details v-speeds, trim from the aircraft
function kc_set_takeoff_details()
	-- activeBriefings:set("takeoff:v1",get(""))
	-- activeBriefings:set("takeoff:vr",get(""))
	-- activeBriefings:set("takeoff:v2",get(""))
	-- activeBriefings:set("takeoff:elevatorTrim",get(""))
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	-- activeBriefings:set("approach:vref",get(""))
	-- activeBriefings:set("approach:vapp",get("")+5)
end