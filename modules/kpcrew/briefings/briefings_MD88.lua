-- Aircraft specific briefing values and functions - RotateSim MD88
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Rotate MD-88"

-- === aircraft type

-- === Electric system
kc_NumBatteries		= 1			-- Number of batteries from acf
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -1
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 4
kc_TakeoffFlaps 	= "UP|0|11|15| | | "
kc_TakeoffFlapsInd 	= "0|1|2|3|3|3|3"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "28|40| | | | | "
kc_LandingFlapsInd 	= "4|5|5|5|5|5|5"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_TakeoffThrust 	= "RATED|DE-RATED|ASSUMED TEMPERATURE|RATED AND ASSUMED|DE-RATED AND ASSUMED"
kc_n2_after_start	= 40
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= true		-- Aircraft has power transfer unit

-- === Air supply

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 2			-- Number of landing light switches
kc_has_emer_lights	= false		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_NumIRS			= 2			-- Number of IRS systems
kc_irs_off			= 0
kc_irs_align		= 1
kc_irs_nav			= 2
kc_irs_att			= 3
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper
kc_has_vnav			= true		-- Aircraft has VNAV
kc_has_lnav			= true		-- Aircraft has LNAV

-- === other options
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_oxygen		= true		-- Aircraft has oxygen supply

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|MIN|MED|MAX"
kc_LandingAutoBrInd = "1|2|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
