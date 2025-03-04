-- Aircraft specific briefing values and functions - X-Crafts Free E-Jets
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "E195/E175 Free X-Crafts"

kc_has_apu			= true		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_stairs		= false		-- Aircraft has autonomous stairs on L1
kc_has_autobrake	= true		-- Aircraft has autobrake
kc_has_speedbrake	= true		-- Aircraft has an air brake to extend
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_has_reversers	= true		-- Aircraft has reversers
kc_has_retractgear	= true		-- Aircraft has retractable gear
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_clock		= true
kc_et_timer_on		= 1
kc_et_timer_off		= 0

kc_Numflap_detents	= 6 		-- Number of flap detents
kc_NumFlapsTO		= 4
kc_TakeoffFlaps 	= "UP|1|2|3"
kc_TakeoffFlapsInd 	= "0|1|2|3"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "4|5|FULL"
kc_LandingFlapsInd 	= "4|5|6"
kc_LandingAutoBrake = "RTO|OFF|LO|MED|HI"
kc_LandingAutoBrInd = "0|1|2|3|4"
