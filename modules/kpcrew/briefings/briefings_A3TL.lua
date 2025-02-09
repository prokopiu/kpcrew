-- Aircraft specific briefing values and functions - A3TL ToLiss Airbusses
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "ToLiss Airbus"

kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingAutoBrInd = "0|1|2|3"
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1|2"
kc_TakeoffFlapsInd 	= "0|1|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "3|FULL"
kc_LandingFlapsInd 	= "3|4"
kc_NumBatteries		= 2		-- Number of batteries
kc_has_irs			= true		-- Aircraft has IRS that must be aligned