-- Aircraft specific briefing values and functions - TMPL
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar SF50"

-- === Electric system
kc_NumGenerators	= 2			-- Number of generators from acf
kc_has_apu			= false		-- Aircraft has an APU
kc_has_gpu			= false		-- Aircraft has GPU connection
kc_has_inv_ess_bus	= false		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= false		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch

-- === Controls
kc_has_aileron_trim	= false		-- Aircraft has aileron trim
kc_has_rudder_trim	= false		-- Aircraft has rudder trim
kc_NumFlapsTO		= 2
kc_TakeoffFlaps 	= "UP|50%"
kc_TakeoffFlapsInd 	= "0|1"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "50%|100%"
kc_LandingFlapsInd 	= "1|2"
kc_has_speedbrake	= false		-- Aircraft has an air brake to extend
kc_full_rgt_rudder	= 0.9		-- Threshold where the rudder is almost fully to the right
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed

-- === engines
kc_StartSequence 	= " |1 THEN 2"
kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_has_reversers	= false		-- Aircraft has reversers

-- === Fuel
kc_has_fuel_pumps   = false		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= false		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief	

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve
kc_has_press_cab	= false		-- Aircraft has pressurized cabine
kc_has_oxygen		= true		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 1			-- Number of landing light switches
kc_has_taxi_light	= false		-- Aircraft has taxi light
kc_has_ll_as_taxi	= true		-- Aircraft uses landing lights to taxi
kc_has_strb_as_bcn	= true		-- Aircraft uses strobe lights for beacon 
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= false		-- Aircraft has logo lights
kc_has_dome_lights	= false		-- Aircraft has dome/cockpit lights
kc_has_wing_lights	= false		-- Aircraft has wing Lights
kc_has_seatbelt_sgn	= false		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= false		-- Aircraft has no smoking signs
kc_has_beacon		= false		-- Aircraft has beacon

-- === Payload & weights
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_TakeoffApModes 	= "HDG/FLCH|"
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_yawdamper	= false		-- Aircraft has switchable yaw damper
kc_has_ias_sel		= false		-- Aircraft has IAS selector
kc_has_radar_alt	= false		-- Aircraft has radar altitude
kc_has_dh_minimum	= false		-- Aircraft has decicion height
kc_has_vnav			= false		-- Aircraft has VNAV

-- === other options
kc_has_wipers		= false		-- Aircraft has wipers
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_cargo_doors	= false		-- Aircraft has cargo doors
kc_has_cockpit_door	= false		-- Aircraft has cockpit door

kc_has_autobrake	= false		-- Aircraft has autobrake

-- === Operating speeds
kc_speeds_vr		= 90		-- Rotation speed - set for each aircraft
kc_speeds_vx		= 91		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 160		-- Best Rate of Climb - set for aircraft

-- === Altitudes
kc_max_altitude		= 31500 	-- Max Altitude