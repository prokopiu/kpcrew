-- Aircraft specific briefing values and functions - ADC3
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Aeroworx DC-3 Freeware"

-- === aircraft type
kc_is_turboprop		= true		-- Aircraft is turbo prop

-- === Electric system
kc_has_apu			= false		-- Aircraft has an APU
kc_has_gpu			= false		-- Aircraft has GPU connection
kc_has_inv_ess_bus	= false		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= false		-- Aircraft has bus ties for AC & DC
kc_has_standby_pwr	= false		-- Aircraft has standby power

-- === Controls
kc_has_speedbrake	= false		-- Aircraft has an air brake to extend
kc_has_aileron_trim	= true		-- Aircraft has aileron trim
kc_has_rudder_trim	= true		-- Aircraft has rudder trim
kc_full_rgt_rudder	= -20		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "UP|25%|50%| | | | "
kc_TakeoffFlapsInd 	= "0|1|2|2|2|2|2"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "50%|75%|FULL| | | | "
kc_LandingFlapsInd 	= "2|3|4|2|2|2|2"
kc_gear_ext_index	= 1			-- When to extend gear in flaps extend

-- === engines
kc_has_reversers	= false		-- Aircraft has reversers
kc_has_proplever	= false		-- Aircraft has prop lever
kc_has_mixlever		= false		-- Airctaft has mixture lever
kc_n2_after_start	= 27
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= false		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief
kc_has_fuel_select	= true		-- Aircraft has fuel tank selector

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "NO|NO"
kc_has_press_cab	= false		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = false		-- Aircraft has engine bleeds
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 1			-- Number of landing light switches
kc_has_beacon		= true		-- Aircraft has beacon
kc_has_strb_as_bcn	= false		-- Aircraft uses strobe lights for beacon 
kc_has_taxi_light	= true		-- Aircraft has taxi light
kc_has_ll_as_taxi	= false		-- Aircraft uses landing lights to taxi
kc_has_wing_lights	= true		-- Aircraft has wing Lights
kc_has_wheel_lights	= false		-- Aircraft has wheel Lights
kc_has_pos_lights	= true		-- Aircraft has switchable position Lights
kc_has_strobe_lights= true		-- Aircraft has strobe lights
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= false		-- Aircraft has logo lights
kc_has_dome_lights	= true		-- Aircraft has dome/cockpit lights
kc_has_instr_lights	= true		-- Aircraft has instrument Lights
kc_has_panel_lights = true		-- Aircraft has panel lights
kc_has_seatbelt_sgn	= true		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= true		-- Aircraft has no smoking signs
kc_has_emer_lights	= false		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_flightdir	= false		-- Aircraft has flight director
kc_has_autopilot	= true		-- Aircraft has autopilot
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_ias_sel		= false		-- Aircraft has IAS selector
kc_has_hdg_sel		= true		-- Aircraft has Heading selector
kc_has_alt_sel		= true		-- Aircraft has ALT selector
kc_has_vsp_sel		= true		-- Aircraft has vertical speed selector
kc_has_yawdamper	= false		-- Aircraft has switchable yaw damper
kc_has_ils			= true		-- Aircraft has ILS receiver
kc_has_rnav_cap		= false		-- Aircraft has rnav capability
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV
kc_has_flch_ias		= false		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_radar_alt	= false		-- Aircraft has radar altitude
kc_has_dh_minimum	= false		-- Aircraft has decicion height

-- === other options
kc_has_stairs		= false		-- Aircraft has autonomous stairs on L1
kc_has_retractgear	= true		-- Aircraft has retractable gear
kc_has_ground_obj	= false		-- Aircraft has its own ground objects (chocks etc)
kc_has_wipers		= true		-- Aircraft has wipers
kc_has_wx_radar		= false		-- Aircraft has weather radar
kc_has_toc			= false		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= false		-- Aircraft has a clock stopwatch
kc_has_transponder	= true		-- Aircraft has transponder
kc_has_doors		= true		-- Aircraft has doors
kc_has_cargo_doors	= true		-- Aircraft has cargo doors
kc_has_cockpit_door	= false		-- Aircraft has cockpit door
kc_has_adf_radios	= true		-- Aircraft has ADF radios
kc_has_nav_radios	= true		-- Aircraft has NAV radios

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_has_antiskid		= false

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 24000 	-- Max Altitude
