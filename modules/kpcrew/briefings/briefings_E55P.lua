-- Aircraft specific briefing values and functions - E55P
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "AEROBASK PHENOM 300"

kc_has_apu			= false		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_irs			= false		-- Aircraft has IRS that must be aligned
kc_has_wipers		= false		-- Aircraft has wipers
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_beacon		= false
kc_has_autobrake	= false		-- Aircraft has autobrake

kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1|2"
kc_TakeoffFlapsInd 	= "0|1|2"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "2|3|FULL"
kc_LandingFlapsInd 	= "2|3|4"