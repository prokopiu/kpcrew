-- Aircraft specific briefing values and functions - E55P
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "AEROBASK PHENOM 300"
-- ACF_ICAO 695353800

-- === aircraft type

-- === Electric system
kc_has_apu			= false		-- Aircraft has an APU
kc_remove_gpu_after	= true		-- remove GPU after start

-- === Controls
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1|2"
kc_TakeoffFlapsInd 	= "0|1|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "3|FULL"
kc_LandingFlapsInd 	= "3|4"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_has_reversers	= false		-- Aircraft has reversers
kc_TakeoffThrust 	= "RATED"
kc_n2_after_start	= 40

-- === Fuel
kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief	

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps

-- === Air supply
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 1			-- Number of landing light switches
kc_has_beacon		= false		-- Aircraft has beacon
kc_has_strb_as_bcn	= true		-- Aircraft uses strobe lights for beacon 
kc_has_wing_lights	= true		-- Aircraft has wing Lights
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= false		-- Aircraft has logo lights
kc_has_seatbelt_sgn	= false		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= false		-- Aircraft has no smoking signs
kc_has_emer_lights	= true		-- Aircraft has emergency lights

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
kc_has_cockpit_door	= false		-- Aircraft has cockpit door
kc_has_oxygen		= false		-- Aircraft has oxygen supply
kc_has_toc			= false		-- Airctaft has a takeof config check button

kc_has_autobrake	= false		-- Aircraft has autobrake

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 45000 	-- Max Altitude
