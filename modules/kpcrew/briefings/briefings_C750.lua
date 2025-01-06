-- Aircraft specific briefing values and functions - Laminar C750
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

kc_acf_name 		= "Laminar Citation X 750"

kc_TakeoffThrust 	= "NORMAL"
kc_TakeoffFlaps 	= "UP|5|15"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|OFF"
kc_TakeoffBleeds 	= "ON|OFF"
kc_TakeoffApModes 	= "NAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "15|FULL"
kc_LandingAutoBrake = "NO A/B|"
kc_LandingPacks 	= "ON|OFF"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_MELIssues 		= "no M E L issues|some M E L issues"

-- Weights (lb/kg)	Citation X, CE-750
-- Max Ramp					36,400/16.510
-- Max Takeoff				36,100/14.242
-- Max Landing				31,800/14.424
-- Zero Fuel				24,400/11.067
-- BOW						22,100/10.024
-- Max Payload				 2,300/1.043
-- Useful Load				14,300/6.486
-- Executive Payload		 1,800/816
-- Max Fuel					12,931/5.865
-- Avail Payload Max Fuel	 1,369/620
-- Avail Fuel Max Payload	12,000/5.443
-- Avail Fuel Exec Payload	12,500/5.669

kc_MaxRamp			= 17300 	-- Max Ramp weight
kc_DOW 				= 10024		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= 11068		-- Maximum Zero Fuel Weight
kc_MaxFuel 			=  5865		-- Maximum Fuel Capacity (lbs)
kc_MaxPayload		=  1043		-- Maximum Payload
kc_MTOW 			= 16510		-- Maximum Takeoff Weight
kc_MLW  			= 14424		-- Maximum Landing Weight
kc_FFPH 			=  1315		-- Fuel Flow per hour
kc_NumEngines		=     2		-- Number of engines
kc_NumTanks			= 	  3		-- Number of tanks
kc_MFL1				=  1595		-- max fuel in tank left
kc_MFL2				=  2719		-- max fuel in tank center
kc_MFL3				=  1595		-- max fuel in tank right

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
kc_max_altitude		= 32000		-- Max Altitude

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
APP_rev_thrust_list = "NONE|FULL"

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
	-- payload
	set("sim/flightmodel/weight/m_fixed",activeBriefings:get("flight:toweight"))

	-- fuel
	set("sim/aircraft/weight/acf_m_fuel_tot",10000)
	local fgoal = activeBriefings:get("flight:takeoffFuel")
	set_array("sim/flightmodel/weight/m_fuel",1,math.min(kc_MFL1,fgoal/2))
	set_array("sim/flightmodel/weight/m_fuel",2,math.min(kc_MFL3,fgoal/2))
	local fdiff = fgoal - (kc_MFL1 + kc_MFL3)
	if fdiff > 0 then
		set_array("sim/flightmodel/weight/m_fuel",0,math.min(kc_MFL2,fdiff))
	else
		set_array("sim/flightmodel/weight/m_fuel",0,0)
	end
end

-- set the takeoff details v-speeds, trim
function kc_set_takeoff_details()
	command_once("sim/FMS/clb")
	command_once("sim/FMS/ls_2r")
	command_once("sim/FMS/ls_4r")
	local line = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line0") 
	command_once("sim/FMS/next")
	activeBriefings:set("takeoff:v1",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2"),1,3)) 
	activeBriefings:set("takeoff:vr",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4"),1,3)) 
	activeBriefings:set("takeoff:v2",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line6"),1,3)) 
	-- activeBriefings:set("takeoff:elevatorTrim",get("laminar/B738/FMS/trim_calc"))
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	command_once("sim/FMS/clb")
	command_once("sim/FMS/ls_4r")
	command_once("sim/FMS/next")
	command_once("sim/FMS/next")
	command_once("sim/FMS/next")
	local vrefline = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2")
	print(vrefline)
	if vrefline ~= "" then 
		activeBriefings:set("approach:vref",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2"),1,3))
	end
	local vappline = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4")
	if vappline ~= "" then 
		activeBriefings:set("approach:vapp",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4"),1,3))
	end
end