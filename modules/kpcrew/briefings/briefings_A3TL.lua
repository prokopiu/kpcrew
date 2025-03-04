-- Aircraft specific briefing values and functions - A3TL ToLiss Airbusses
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "ToLiss Airbus"

kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingAutoBrInd = "0|1|2|3"
kc_AutoBrakeOff		= 0
kc_AutoBrakeRTO		= 3

kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1+F|2"
kc_TakeoffFlapsInd 	= "0|1|2"

kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "3|FULL"
kc_LandingFlapsInd 	= "3|4"

kc_NumBatteries		= 2		-- Number of batteries

kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_is_airbus		= true		-- Aircraft is an Airbus
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief	
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	
kc_has_toc			= true		-- Airctaft has a takeof config check button
kc_has_chrono		= true		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0