-- Aircraft specific briefing values and functions - Default aircraft
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

kc_acf_name 		= "X-Plane Default Aircraft"

kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps 	= "1|2|3|4|5"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_TakeoffApModes 	= "LNAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "3|4|5"
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingPacks 	= "OFF|ON"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_MELIssues 		= "no M E L issues|some M E L issues"

-- aircraft specs, weights in KG
-- EMPTY WEIGHT:			xxxxxx KG - xxxxxx LBS
-- MAX ZERO FUEL WEIGHT:	 xxxxx KG -  xxxxx LBS
-- MAX TAKEOFF WEIGHT:		 xxxxx KG - xxxxxx LBS
-- MAX LANDING WEIGHT:		 xxxxx KG - xxxxxx LBS
-- MAX FUEL CAPACITY:		 xxxxx KG -  xxxxx LBS
-- FUEL FLOW PER HOUR:		  xxxx KG -   xxxx LBS

kc_DOW 				= -1		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= -1		-- Maximum Zero Fuel Weight
kc_MaxFuel 			= -1		-- Maximum Fuel Capacity
kc_MaxPayld 		= -1		-- Maximum Payload to be set
kc_MTOW 			= -1		-- Maximum Takeoff Weight
kc_MLW  			= -1		-- Maximum Landing Weight
kc_FFPH 			= -1		-- Fuel Flow per hour
kc_NumEngines		= -1		-- Number of engines
kc_NumTanks			= -1		-- Number of tanks
kc_MFL1				= -1		-- max fuel in tank left
kc_MFL2				= -1		-- max fuel in tank center
kc_MFL3				= -1		-- max fuel in tank right

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

-- Briefing flags
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

-- ======= Aircraft specific functions

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
	set("sim/flightmodel/weight/m_fixed",activeBriefings:get("flight:payload"))
	local fgoal = activeBriefings:get("flight:takeoffFuel")
	set("sim/flightmodel/weight/m_fuel2",math.min(kc_MFL2,fgoal/2))
	set("sim/flightmodel/weight/m_fuel3",math.min(kc_MFL2,fgoal/2))
	local fdiff = fgoal - (kc_MFL2 + kc_MFL3)
	if fdiff > 0 then
		set("sim/flightmodel/weight/m_fuel1",math.min(kc_MFL1,fdiff))
	else
		set("sim/flightmodel/weight/m_fuel1",0)
	end
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