-- Aircraft specific briefing values and functions - A33L
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar A330 & Variants"

-- === aircraft type
kc_is_airbus		= true		-- Aircraft is an Airbus

-- === Electric system
kc_NumBatteries		= 3			-- Number of batteries
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= false		-- remove GPU after start

-- === Controls
kc_has_aileron_trim	= false		-- Aircraft has aileron trim
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1+F|2| | | "
kc_TakeoffFlapsInd 	= "0|1|2|2|2|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "3|FULL| | | | "
kc_LandingFlapsInd 	= "3|4|4|4|4|4"

-- === engines
kc_ab_engm_norm		= 0			-- Airbus engine mode norm
kc_ab_engm_strt		= 1			-- Airbus engine mode start
kc_ab_engm_crnk		= -1		-- Airbus engine mode crank
kc_TakeoffThrust 	= "RATED"
kc_n2_after_start	= 40

-- === Fuel
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_has_iso_valvle	= false		-- Aircraft has switchable isolation valve
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_has_emer_lights	= true		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_TakeoffApModes 	= "LNAV/VNAV|"
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_has_yawdamper	= false		-- Aircraft has switchable yaw damper

-- === other options
kc_has_toc			= true		-- Airctaft has a takeof config check button
kc_has_chrono		= true		-- Aircraft has a chrono stopwatch
kc_has_clock		= true
kc_et_timer_on		= 1
kc_et_timer_off		= 0
kc_has_transponder	= true		-- Aircraft has transponder
kc_has_doors		= true		-- Aircraft has doors
kc_has_cargo_doors	= true		-- Aircraft has cargo doors
kc_has_cockpit_door	= true		-- Aircraft has cockpit door
kc_has_oxygen		= false		-- Aircraft has oxygen supply

kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingAutoBrInd = "0|1|2|3"
kc_AutoBrakeOff		= 0
kc_AutoBrakeRTO		= 3

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
