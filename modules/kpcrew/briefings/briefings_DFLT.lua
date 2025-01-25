-- Aircraft specific briefing values and functions - Default aircraft
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

kc_acf_name 		= "X-Plane Default Aircraft"

kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_TakeoffFlaps 	= "0|1|2|3|4|5"
kc_TakeoffFlapsInd 	= "0|1|2|3|4|5"
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_TakeoffApModes 	= "LNAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_LandingFlaps 	= "3|4|5"
kc_LandingFlapsInd 	= "3|4|5"
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingPacks 	= "OFF|ON"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"

-- full list of approach types can be overwritten by aircraft
APP_apptype_list 	= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"

-- APU/GPU startup after landing
APP_apu_list 		= "APU delayed start|APU|GPU"

-- Reverse Thrust
APP_rev_thrust_list = "NONE|MINIMUM|FULL"

-- aircraft specs, weights in KG
-- EMPTY WEIGHT:			xxxxxx KG - xxxxxx LBS
-- MAX ZERO FUEL WEIGHT:	 xxxxx KG -  xxxxx LBS
-- MAX TAKEOFF WEIGHT:		 xxxxx KG - xxxxxx LBS
-- MAX LANDING WEIGHT:		 xxxxx KG - xxxxxx LBS
-- MAX FUEL CAPACITY:		 xxxxx KG -  xxxxx LBS
-- FUEL FLOW PER HOUR:		  xxxx KG -   xxxx LBS

kc_MaxRamp			= -1		-- Max Ramp weight
kc_DOW 				= -1		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= -1		-- Maximum Zero Fuel Weight
kc_MaxFuel 			= -1		-- Maximum Fuel Capacity
-- Max Fuel per tank
kc_MFL				= {[0]=-1,[1]=-1,[2]=-1,[3]=-1,[4]=-1,[5]=-1,[6]=-1,[7]=-1,[8]=-1}
kc_MaxPayload 		= -1		-- Maximum Payload to be set
kc_MTOW 			= -1		-- Maximum Takeoff Weight
kc_MLW  			= -1		-- Maximum Landing Weight
kc_FFPH 			= -1		-- Fuel Flow per hour
kc_NumEngines		= -1		-- Number of engines
kc_NumTanks			= -1		-- Number of tanks
kc_NumBatteries		= -1		-- Number of batteries
kc_NumGenerators	= -1		-- Number of generators
kc_NumInverters		= -1		-- Number of inverters

-- Operating speeds
kc_speeds_vso		= -1		-- Stall Speed, Landing Configuration Vso 115 KIAS
kc_speeds_vs1		= 136		-- Stall Speed, Clean Vs1 136 KIAS
kc_speeds_vs		= 140		-- Minimum Controllable Speed Vs 140 KIAS
kc_speeds_vx		= 270		-- Best Angle of Climb Vx 270 KIAS
kc_speeds_vy		= 300		-- Best Rate of Climb Vy 300 KIAS
kc_speeds_vfe		= -1		-- Maximum flaps Extended Speed Vfe 180 KIAS
kc_speeds_vmo1		= 270		-- Maximum Operating Speed (Sea Level to 8,000 ft) Vmo 270 KIAS
kc_speeds_vmo2		= 350		-- Maximum Operating Speed (Above 8,000 ft) Vmo 350 KIAS
kc_speeds_vmo3		= 0.935		-- Maximum Mach Number Vmo 0.935 Mach
kc_speeds_vle		= -1		-- Maximum Gear Operating Speed Vle 210 KIAS
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



-- ======= Aircraft specific functions


-- Maximum takeoff weight as approximation = max aircraft weight
function kc_get_MaxRampWeight()
	if kc_MaxRamp == -1 then
		kc_MaxRamp = get("sim/aircraft/weight/acf_m_max")
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MaxRamp
	else
		return kc_MaxRamp * 2.20462262
	end
end

-- Get Dry Operating Weight. 
-- use Empty Weight if not specified
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
		kc_MZFW = kc_get_MaxRampWeight() - kc_get_MaxFuel()
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MZFW
	else
		return kc_MZFW * 2.20462262
	end
end

-- Maximum takeoff weight as approximation = max aircraft weight
-- if not specified we use Max Ramp Weight
function kc_get_MTOW()
	if kc_MTOW == -1 then
		kc_MTOW = kc_get_MaxRampWeight()
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

-- Maximum Payload Weight 
function kc_get_MaxPayload()
	if kc_MaxPayload == -1 then
		kc_MaxPayload = kc_get_MaxRampWeight() - kc_get_DOW() - kc_get_MaxFuel()
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MaxPayload
	else
		return kc_MaxPayload * 2.20462262
	end
end

-- Current Payload WEIGHT
function kc_get_Payload()
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/flightmodel/weight/m_fixed")
	else
		return get("sim/flightmodel/weight/m_fixed") * 2.20462262
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

-- Get fuel loaded in up to 9 tanks kgs
function kc_get_tank_weight(tanknr)
	if activePrefSet:get("general:weight_kgs") then
		return get("sim/cockpit2/fuel/fuel_quantity", tanknr)
	else
		return get("sim/cockpit2/fuel/fuel_quantity", tanknr)*2.20462262
	end
end

-- Get max fuel level per tank
function kc_get_MFL(tanknr)
	if kc_MFL[tanknr] == -1 then
		kc_MFL[tanknr] = kc_get_MaxFuel() * get("sim/aircraft/overflow/acf_tank_rat",tanknr)
	end
	if activePrefSet:get("general:weight_kgs") then
		return kc_MFL[tanknr]
	else
		return kc_MFL[tanknr]*2.20462262
	end
end

-- Calculate current ZFW
function kc_get_zfw()
	return kc_get_gross_weight()-kc_get_total_fuel()
end

-- get number of tanks
function kc_get_nr_tanks()
	if kc_NumTanks == -1 then
		kc_NumTanks = get("sim/aircraft/overflow/acf_num_tanks")
	end
	return kc_NumTanks
end

-- get number of tanks
function kc_get_nr_engines()
	if kc_NumEngines == -1 then
		kc_NumEngines = get("sim/aircraft/engine/acf_num_engines")
	end
	return kc_NumEngines
end

-- get number of batteries
function kc_get_nr_batteries()
	if kc_NumBatteries == -1 then
		kc_NumBatteries = get("sim/aircraft/electrical/num_batteries")
	end
	return kc_NumBatteries
end

-- get number of generators
function kc_get_nr_batteries()
	if kc_NumGenerators == -1 then
		kc_NumGenerators = get("sim/aircraft/electrical/num_generators")
	end
	return kc_NumGenerators
end

-- get number of inverters
function kc_get_nr_inverters()
	if kc_NumInverters == -1 then
		kc_NumInverters = get("sim/aircraft/electrical/num_inverters")
	end
	return kc_NumInverters
end

-- speeds
-- Maximum flaps Extended Speed VFe
function kc_get_VFe()
	if kc_speeds_vfe == -1 then
		kc_speeds_vfe = get("sim/aircraft/view/acf_Vfe")
	end
	return kc_speeds_vfe
end

-- Maximum Gear Operating Speed Vle
function kc_get_VLe()
	if kc_speeds_vle == -1 then
		kc_speeds_vle = get("sim/aircraft/view/acf_Vle")
	end
	return kc_speeds_vle
end

-- Maximum Velocity Stall 0 Speed Vle
function kc_get_VSo()
	if kc_speeds_vso == -1 then
		kc_speeds_vso = get("sim/aircraft/view/acf_Vso")
	end
	return kc_speeds_vso
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