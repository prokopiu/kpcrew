-- Aircraft specific briefing values and functions - PC12
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "LES Saab SF34"

-- === aircraft type
kc_is_turboprop		= false		-- Aircraft is turbo prop

-- === Electric system
kc_NumBatteries		= 2		-- Number of batteries from acf
kc_NumGenerators	= -1		-- Number of generators from acf
kc_NumInverters		= -1		-- Number of inverters from acf
kc_has_apu			= false		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= false		-- Aircraft has standby power

-- === Controls
kc_Numflap_detents	= -1 		-- Number of flap detents from acf
kc_has_speedbrake	= false		-- Aircraft has an air brake to extend
kc_has_aileron_trim	= true		-- Aircraft has aileron trim
kc_has_rudder_trim	= true		-- Aircraft has rudder trim
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 2
kc_TakeoffFlaps 	= "0|7|15| | | | "
kc_TakeoffFlapsInd 	= "0|1|2|2|2|2|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "20|35| | | | | "
kc_LandingFlapsInd 	= "3|4|4|4|4|4|4"
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
kc_n2_after_start	= 13
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_has_fuel_pumps   = false		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= true		-- Aircraft has switchable isolation valve
kc_has_oxygen		= true		-- Aircraft has oxygen supply
kc_has_recirc		= true		-- Aircraft has recirc system

-- === Anti Ice
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 2			-- Number of landing light switches
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= false		-- Aircraft has logo lights
kc_has_emer_lights	= true		-- Aircraft has emergency lights

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
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_vsp_sel		= false		-- Aircraft has vertical speed selector
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper
kc_has_ils			= true		-- Aircraft has ILS receiver
kc_has_rnav_cap		= false		-- Aircraft has rnav capability
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV
kc_has_flch_ias		= true		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= true		-- Aircraft needs atlsel to be selected

-- === other options
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_ground_obj	= false		-- Aircraft has its own ground objects (chocks etc)
kc_has_wipers		= true		-- Aircraft has wipers
kc_has_wx_radar		= true		-- Aircraft has weather radar
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_transponder	= true		-- Aircraft has transponder

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_has_antiskid		= false

-- === Altitudes
kc_max_altitude		= 25000 	-- Max Altitude
