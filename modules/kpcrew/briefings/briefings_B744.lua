-- Aircraft specific briefing values and functions - Default aircraft as base for all others
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "MSparks Boeing 747"

-- === aircraft type
kc_is_boeing		= true		-- Aircraft is a Boeing

-- === Electric system
kc_NumBatteries		= 1		-- Number of batteries from acf
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= 0.125
kc_full_rgt_rudder	= 31		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 5
kc_TakeoffFlaps 	= "UP|1|5|10|20| | "
kc_TakeoffFlapsInd 	= "0|1|2|3|4|4|4"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "25|30| | | | | "
kc_LandingFlapsInd 	= "5|6|6|6|6|6|6"
kc_gear_ext_index	= 3			-- When to extend gear in flaps extend

-- === engines
kc_StartSequence 	= "1 TO 4| "
kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_has_ignition		= false		-- has ignition switch
kc_n2_after_start	= 55

-- === Fuel
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics

-- === Air supply
kc_has_oxygen		= true		-- Aircraft has oxygen supply

-- === Anti Ice
kc_has_pitot_heat	= false		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 4			-- Number of landing light switches
kc_has_emer_lights	= false		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_NumIRS			= 3			-- Number of IRS systems
kc_irs_off			= 0
kc_irs_align		= 0
kc_irs_nav			= 0
kc_irs_att			= 0

-- === other options
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_oxygen		= false		-- Aircraft has oxygen supply
kc_has_doors		= false		-- Aircraft has doors

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|1|2|3|4|MAX"
kc_LandingAutoBrInd = "1|2|3|4|5|6"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
