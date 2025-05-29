-- Aircraft specific briefing values and functions - Default aircraft as base for all others
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

kc_acf_name 		= "X-Plane Default Aircraft"

-- === aircraft type
kc_is_airbus		= false		-- Aircraft is an Airbus
kc_is_boeing		= false		-- Aircraft is a Boeing
kc_is_zibo			= false
kc_is_ga			= false		-- Aircraft is general aviation
kc_is_turboprop		= false		-- Aircraft is turbo prop

-- === Electric system
kc_NumBatteries		= -1		-- Number of batteries from acf
kc_NumGenerators	= -1		-- Number of generators from acf
kc_NumInverters		= -1		-- Number of inverters from acf
kc_has_apu			= true		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= false		-- Aircraft has standby power

-- === Controls
kc_Numflap_detents	= -1 		-- Number of flap detents from acf
kc_has_speedbrake	= true		-- Aircraft has an air brake to extend
kc_has_aileron_trim	= true		-- Aircraft has aileron trim
kc_has_rudder_trim	= true		-- Aircraft has rudder trim
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -1
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1|2|2|2|2|2"
kc_TakeoffFlapsInd 	= "0|1|2|2|2|2|2"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "0|1|2|2|2|2|2"
kc_LandingFlapsInd 	= "0|1|2|2|2|2|2"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_NumEngines		= -1		-- Number of engines from acf
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_has_reversers	= true		-- Aircraft has reversers
kc_ab_engm_norm		= 1			-- Airbus engine mode norm
kc_ab_engm_strt		= 2			-- Airbus engine mode start
kc_ab_engm_crnk		= 0			-- Airbus engine mode crank
kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_has_proplever	= false		-- Aircraft has prop lever
kc_prop_lvr_min		= 125		-- Prop lever Minimum
kc_prop_lvr_feather	= 105		-- Prop lever feather
kc_prop_lvr_max		= 178		-- Prop lever maximum
kc_has_mixlever		= false		-- Airctaft has mixture lever
kc_mixture_off		= 0
kc_mixture_min		= 0.4
kc_mixture_rich		= 1
kc_n2_after_start	= 40
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_NumTanks			= -1		-- Number of tanks from acf
kc_MaxFuel 			= -1		-- Maximum Fuel Capacity from ACF
-- Max Fuel per tank
kc_MFL				= {[0]=-1,[1]=-1,[2]=-1,[3]=-1,[4]=-1,[5]=-1,[6]=-1,[7]=-1,[8]=-1}
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_FFPH 			= -1		-- Fuel Flow per hour from acf
kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= true		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = true		-- Aircraft has engine bleeds
kc_has_oxygen		= true		-- Aircraft has oxygen supply
kc_has_recirc		= false		-- Aircraft has recirc system

-- === Anti Ice
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 2			-- Number of landing light switches
kc_has_beacon		= true		-- Aircraft has beacon
kc_has_strb_as_bcn	= false		-- Aircraft uses strobe lights for beacon 
kc_has_taxi_light	= true		-- Aircraft has taxi light
kc_has_ll_as_taxi	= false		-- Aircraft uses landing lights to taxi
kc_has_wing_lights	= true		-- Aircraft has wing Lights
kc_has_wheel_lights	= false		-- Aircraft has wheel Lights
kc_has_pos_lights	= true		-- Aircraft has switchable position Lights
kc_has_strobe_lights= true		-- Aircraft has strobe lights
kc_has_rwy_lights	= true		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= true		-- Aircraft has logo lights
kc_has_dome_lights	= true		-- Aircraft has dome/cockpit lights
kc_has_instr_lights	= true		-- Aircraft has instrument Lights
kc_has_panel_lights = true		-- Aircraft has panel lights
kc_has_seatbelt_sgn	= true		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= true		-- Aircraft has no smoking signs
kc_has_emer_lights	= false		-- Aircraft has emergency lights

-- === Payload & weights
kc_MaxRamp			= -1		-- Max Ramp weight
kc_DOW 				= -1		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= -1		-- Maximum Zero Fuel Weight
kc_MaxPayload 		= -1		-- Maximum Payload to be set
kc_MTOW 			= -1		-- Maximum Takeoff Weight
kc_MLW  			= -1		-- Maximum Landing Weight
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_TakeoffApModes 	= "HDG/FLCH|LNAV/VNAV"
kc_apptypes 		= "ILS CAT 1|ILS CAT 2 OR 3|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_irs			= false		-- Aircraft has IRS that must be aligned
kc_NumIRS			= 3			-- Number of IRS systems
kc_irs_off			= 0
kc_irs_align		= 0
kc_irs_nav			= 1
kc_irs_att			= 0
kc_has_flightdir	= true		-- Aircraft has flight director
kc_has_autopilot	= true		-- Aircraft has autopilot
kc_has_autothrottle = true		-- Aircraft has autothrottle
kc_has_ias_sel		= true		-- Aircraft has IAS selector
kc_has_hdg_sel		= true		-- Aircraft has Heading selector
kc_has_alt_sel		= true		-- Aircraft has ALT selector
kc_has_vsp_sel		= true		-- Aircraft has vertical speed selector
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper
kc_has_ils			= true		-- Aircraft has ILS receiver
kc_has_rnav_cap		= true		-- Aircraft has rnav capability
kc_has_vnav			= true		-- Aircraft has VNAV
kc_has_lnav			= true		-- Aircraft has LNAV
kc_has_flch_ias		= true		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_radar_alt	= true		-- Aircraft has radar altitude
kc_has_dh_minimum	= true		-- Aircraft has decicion height

-- === other options
kc_has_stairs		= false		-- Aircraft has autonomous stairs on L1
kc_has_retractgear	= true		-- Aircraft has retractable gear
kc_has_ground_obj	= false		-- Aircraft has its own ground objects (chocks etc)
kc_has_wipers		= true		-- Aircraft has wipers
kc_has_wx_radar		= true		-- Aircraft has weather radar
kc_has_toc			= false		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_transponder	= true		-- Aircraft has transponder
kc_has_doors		= true		-- Aircraft has doors
kc_has_cargo_doors	= true		-- Aircraft has cargo doors
kc_has_cockpit_door	= true		-- Aircraft has cockpit door
kc_has_adf_radios	= true		-- Aircraft has ADF radios
kc_has_nav_radios	= true		-- Aircraft has NAV radios

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingAutoBrInd = "1|2|3|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0
kc_has_antiskid		= false

-- === Operating speeds
kc_speeds_vs0		= -1		-- Stall Speed, Landing Configuration from ACF
kc_speeds_vs1		= -1		-- Stall Speed, Clean (near landing speed)
kc_speeds_vs		= -1		-- Minimum Controllable Speed from ACF

kc_speeds_vx		= 270		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 300		-- Best Rate of Climb - set for aircraft
kc_speeds_vr		= 125		-- Rotation speed - set for each aircraft

kc_speeds_vfe		= -1		-- Maximum flaps Extended Speed 

kc_speeds_vmo1		= -1		-- Maximum Operating Speed (Sea Level to 8,000 ft) 
kc_speeds_vmo2		= -1		-- Maximum Operating Speed (Above 8,000 ft) 
kc_speeds_vmo3		= -1		-- Maximum Mach Number 

kc_speeds_vle		= -1		-- Maximum Gear Operating Speed Vle from ACF
kc_speeds_vlo		= -1		-- Maximum Gear Extended Speed vle+20 if not known

kc_speeds_vne		= -1		-- V never exceed from acf
kc_speeds_vno		= -1		-- V maximum ctructural speed from acf 

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude

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

-- get number of engines
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
function kc_get_nr_generators()
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

-- get number of flap detents
function kc_get_nr_flapdetents()
	if kc_Numflap_detents == -1 then
		kc_Numflap_detents = get("sim/aircraft/controls/acf_flap_detents")
	end
	return kc_Numflap_detents
end

-- ==================== speeds

-- Maximum flaps Extended Speed VFe
function kc_get_VFe()
	if kc_speeds_vfe == -1 then
		kc_speeds_vfe = get("sim/aircraft/view/acf_Vfe")
	end
	return kc_speeds_vfe
end

-- Maximum Gear Extend Speed Vle
function kc_get_VLe()
	if kc_speeds_vle == -1 then
		kc_speeds_vle = get("sim/aircraft/view/acf_Vle")
	end
	return kc_speeds_vle
end

-- Maximum Gear Operating Speed Vlo
function kc_get_VLo()
	if kc_speeds_vlo == -1 then
		kc_speeds_vlo = get("sim/aircraft/view/acf_Vle") + 20
	end
	return kc_speeds_vlo
end

-- Maximum controllable speed VS
function kc_get_VS()
	if kc_speeds_vs == -1 then
		kc_speeds_vs = get("sim/aircraft/view/acf_Vs")
	end
	return kc_speeds_vs
end

-- Maximum Velocity Stall landing configuration
function kc_get_VS0()
	if kc_speeds_vs0 == -1 then
		kc_speeds_vs0 = get("sim/aircraft/view/acf_Vso")
	end
	return kc_speeds_vs0
end

-- Maximum Velocity Stall clean vs1
function kc_get_VS1()
	if kc_speeds_vs1 == -1 then
		kc_speeds_vs1 = get("sim/aircraft/view/acf_Vs") + 20
	end
	return kc_speeds_vs1
end

-- V never exceed Vne
function kc_get_Vne()
	if kc_speeds_vne == -1 then
		kc_speeds_vne = get("sim/aircraft/view/acf_Vne")
	end
	return kc_speeds_vne
end

-- V max structural speed Vno
function kc_get_Vno()
	if kc_speeds_vno == -1 then
		kc_speeds_vno = get("sim/aircraft/view/acf_Vno")
	end
	return kc_speeds_vno
end

-- V max operating speed < 8000
function kc_get_Vmo1()
	if kc_speeds_vmo1 == -1 then
		kc_speeds_vmo1 = get("sim/aircraft/view/acf_Vno") - 10
	end
	return kc_speeds_vmo1
end

-- V max operating speed < 8000
function kc_get_Vmo2()
	if kc_speeds_vmo2 == -1 then
		kc_speeds_vmo2 = get("sim/aircraft/view/acf_Vno")
	end
	return kc_speeds_vmo2
end

-- V max mach number
function kc_get_Vmo3()
	if kc_speeds_vmo3 == -1 then
		kc_speeds_vmo3 = get("sim/aircraft/engine/acf_max_mach_eff")
	end
	return kc_speeds_vmo3
end

-- ========================== weights

-- Set the payload for the aircraft
function kc_set_payload(payload)
	if payload > kc_get_MaxPayload() then 
		payload = kc_get_MaxPayload()
	end
	set("sim/flightmodel/weight/m_fixed",payload)
end

-- Set the fuel for the aircraft
function kc_set_fuel(totalfuel)
	if totalfuel > kc_get_MaxFuel() then 
		totalfuel = kc_get_MaxFuel()
	end
	set_array("sim/flightmodel/weight/m_fuel",0,0)
	set_array("sim/flightmodel/weight/m_fuel",1,0)
	set_array("sim/flightmodel/weight/m_fuel",2,0)
	set_array("sim/flightmodel/weight/m_fuel",3,0)
	set_array("sim/flightmodel/weight/m_fuel",4,0)
	if kc_get_nr_tanks() == 1 then 
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankCntrInd,totalfuel)
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankLeftInd,0)
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankRghtInd,0)
	elseif kc_get_nr_tanks() == 2 then 
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankLeftInd,totalfuel/2)
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankRghtInd,totalfuel/2)
		set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankCntrInd,0)
	elseif kc_get_nr_tanks() == 3 then 
		if kc_get_MFL(kc_FuelTankLeftInd) + kc_get_MFL(kc_FuelTankRghtInd) < totalfuel then 
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankLeftInd,kc_get_MFL(kc_FuelTankLeftInd))
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankRghtInd,kc_get_MFL(kc_FuelTankRghtInd))
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankCntrInd,totalfuel - (kc_get_MFL(kc_FuelTankLeftInd) + kc_get_MFL(kc_FuelTankRghtInd)))
		else
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankLeftInd,totalfuel/2)
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankRghtInd,totalfuel/2)
			set_array("sim/flightmodel/weight/m_fuel",kc_FuelTankCntrInd,0)
		end
	end
end

-- set the takeoff details v-speeds, trim from the aircraft if available
function kc_set_takeoff_details()
	-- activeBriefings:set("takeoff:v1",get(""))
	-- activeBriefings:set("takeoff:vr",get(""))
	-- activeBriefings:set("takeoff:v2",get(""))
	-- activeBriefings:set("takeoff:elevatorTrim",get(""))
end

-- set the landing details v-speeds, trim from aircraft if available
function kc_set_landing_details()
	-- activeBriefings:set("approach:vref",get(""))
	-- activeBriefings:set("approach:vapp",get("")+5)
end