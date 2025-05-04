-- Aircraft specific briefing values and functions - Laminar B737
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "X-Plane Laminar B737"

-- === aircraft type
kc_is_boeing		= true		-- Aircraft is a Boeing
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

if kc_is_zibo then 
	kc_acf_name 		= "Zibo Mod 738"
end

-- === Electric system
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_NumBatteries		= 1			-- Number of batteries from acf
kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 5
kc_TakeoffFlaps 	= "UP|1|5|10|15"
kc_TakeoffFlapsInd 	= "0|1|3|4|5"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "25|30|40"
kc_LandingFlapsInd 	= "6|7|8"
kc_gear_ext_index	= 4			-- When to extend gear in flaps extend

-- === engines
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_has_mixlever		= false		-- Aircraft has mixture lever
kc_n2_after_start	= 40
kc_has_ignition		= false		-- has ignition switch

-- === Fuel
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics

-- === Air supply
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 4			-- Number of landing light switches
kc_has_wheel_lights	= true		-- Aircraft has wheel Lights
kc_has_nosmoke_sgn	= true		-- Aircraft has no smoking signs
kc_has_emer_lights	= true		-- Aircraft has emergency lights
kc_has_seatbelt_sgn	= true		-- Aircraft has seatbelt signs

-- === Payload & weights
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
if kc_is_zibo then
	kc_has_irs			= true		-- Aircraft has IRS that must be aligned
	kc_NumIRS			= 2			-- Number of IRS systems
	kc_irs_off			= 0
	kc_irs_align		= 1
	kc_irs_nav			= 2
	kc_irs_att			= 3
end

-- === other options
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_oxygen		= true		-- Aircraft has oxygen supply
kc_has_stairs		= false		-- Aircraft has autonomous stairs on L1

kc_LandingAutoBrake = "RTO|OFF|1|2|3|MAX"
kc_LandingAutoBrInd = "0|1|2|3|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude