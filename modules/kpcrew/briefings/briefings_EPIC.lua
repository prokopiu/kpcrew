-- Aircraft specific briefing values and functions - EPIC
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Aerobask EPIC E1000"

-- === aircraft type
kc_is_ga			= true		-- Aircraft is general aviation
kc_is_turboprop		= true		-- Aircraft is turbo prop

-- === Electric system
kc_has_apu			= false		-- Aircraft has an APU
kc_has_inv_ess_bus	= false		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= false		-- Aircraft has bus ties for AC & DC

-- === Controls
kc_has_speedbrake	= false		-- Aircraft has an air brake to extend
kc_has_aileron_trim	= false		-- Aircraft has aileron trim
kc_has_rudder_trim	= false		-- Aircraft has rudder trimrim
kc_full_rgt_rudder	= -14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 2
kc_TakeoffFlaps 	= "UP|TO"
kc_TakeoffFlapsInd 	= "0|1"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "TO|LAND"
kc_LandingFlapsInd 	= "1|2"

-- === engines
kc_StartSequence 	= "|1 THEN 2"
kc_has_reversers	= false		-- Aircraft has reversers
kc_TakeoffThrust 	= "RATED|"
kc_has_proplever	= true		-- Aircraft has prop lever
kc_prop_lvr_min		= 125		-- Prop lever Minimum
kc_prop_lvr_feather	= 105		-- Prop lever feather
kc_prop_lvr_max		= 178		-- Prop lever maximum

-- === Fuel
kc_has_fuel_xfeed	= false		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief	
kc_has_fuel_select	= true		-- Aircraft has fuel tank selector

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = true		-- Aircraft has engine bleeds

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 1			-- NUmber of landing light switches
kc_has_wing_lights	= false		-- Aircraft has wing Lights
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= false		-- Aircraft has logo lights
kc_has_seatbelt_sgn	= false		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= false		-- Aircraft has no smoking signs

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_TakeoffApModes 	= "HDG/FLCH|"
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_radar_alt	= false		-- Aircraft has radar altitude
kc_has_dh_minimum	= false		-- Aircraft has decicion height

-- === other options
kc_has_wipers		= false		-- Aircraft has wipers
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_cargo_doors	= false		-- Aircraft has cargo doors
kc_has_cockpit_door	= false		-- Aircraft has cockpit door
kc_has_oxygen		= true		-- Aircraft has oxygen supply

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_LandingAutoBrake = "NO|"
kc_LandingAutoBrInd = "0|1"

-- === Operating speeds
kc_speeds_vx		= 270		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 300		-- Best Rate of Climb - set for aircraft
kc_speeds_vr		= 125		-- Rotation speed - set for each aircraft

-- === Altitudes
kc_max_altitude		= 34000 	-- Max Altitude



