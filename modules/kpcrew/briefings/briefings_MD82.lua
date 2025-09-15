-- Aircraft specific briefing values and functions - Laminar MD82
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar MD-82"

-- === aircraft type

-- === Electric system
kc_has_inv_ess_bus	= false		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 4
kc_TakeoffFlaps 	= "UP|0|11|15| | | "
kc_TakeoffFlapsInd 	= "0|1|2|3|3|3|3"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "28|40| | | | | "
kc_LandingFlapsInd 	= "4|5|5|5|5|5|5"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_has_rated_to		= true		-- Aircraft has rated thrust setting for T/O
kc_TakeoffThrust 	= "T/O|T/O FLEX|GA| | "
kc_n2_after_start	= 40
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief
kc_FuelTankLeftInd	= 1
kc_FuelTankRghtInd	= 2
kc_FuelTankCntrInd  = 0

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_has_oxygen		= true		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 2			-- Number of landing light switches
kc_has_emer_lights	= false		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_yawdamper	= false		-- Aircraft has switchable yaw damper
kc_has_vnav			= false
kc_has_lnav			= false
kc_sets_climb_speed	= true		-- ias is set to climbspeed
kc_has_autothrottle = true		-- Aircraft has autothrottle

-- === other options
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_oxygen		= false		-- Aircraft has oxygen supply

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|MIN|MED|MAX"
kc_LandingAutoBrInd = "1|2|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0

-- === Callouts
kc_callout_v1		= true
kc_callout_vr		= true
kc_callout_v2		= true

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
