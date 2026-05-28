-- Aircraft specific briefing values and functions - PC12
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Thranda PC-12"

-- === aircraft type
kc_is_turboprop		= true		-- Aircraft is turbo prop

-- === Electric system
kc_has_apu			= false		-- Aircraft has an APU
kc_NumGenerators	= 2			-- Number of generators from acf
kc_NumBatteries		= 2			-- Number of batteries from acf

-- === Controls
kc_has_speedbrake	= false		-- Aircraft has an air brake to extend
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed
kc_NumFlapsTO		= 2
kc_TakeoffFlaps 	= "0|15"
kc_TakeoffFlapsInd 	= "0|1"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "15|30|40"
kc_LandingFlapsInd 	= "2|3|4"

-- === engines
kc_StartSequence 	= "|1"
kc_TakeoffThrust 	= "NO OPTION|"

-- === Fuel
kc_has_fuel_xfeed	= false		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief	

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = false		-- Aircraft has engine bleeds

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 1			-- NUmber of landing light switches

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_TakeoffApModes 	= "HDG/FLCH|"
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_dh_minimum	= false		-- Aircraft has decicion height

-- === other options
kc_has_ground_obj	= false		-- Aircraft has its own ground objects (chocks etc)
kc_has_wipers		= false		-- Aircraft has wipers
kc_has_cockpit_door	= false		-- Aircraft has cockpit door
kc_has_oxygen		= true		-- Aircraft has oxygen supply

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_LandingAutoBrake = "NO|"
kc_LandingAutoBrInd = "0|"

-- === Operating speeds
kc_speeds_vx		= 110		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 140		-- Best Rate of Climb - set for aircraft
kc_speeds_vr		= 100		-- Rotation speed - set for each aircraft

-- === Altitudes
kc_max_altitude		= 30000 	-- Max Altitude



