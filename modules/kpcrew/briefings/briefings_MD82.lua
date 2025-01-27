-- Aircraft specific briefing values and functions - Laminar MD82
--
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar MD-82"

kc_TakeoffFlaps 	= "0|11|15"
kc_TakeoffFlapsInd 	= "0|2|3"
kc_LandingFlaps 	= "|28|40"
kc_LandingFlapsInd 	= "5|4|5"
kc_LandingAutoBrake = "OFF|MIN|MED|MAX"
kc_LandingAutoBrInd = "1|2|4|5"

kc_has_apu			= true		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_autobrake	= true		-- Aircraft has autobrake
kc_has_speedbrake	= true		-- Aircraft has an air brake to extend
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_has_reversers	= true		-- Aircraft has reversers
kc_has_retractgear	= true		-- Aircraft has retractable gear