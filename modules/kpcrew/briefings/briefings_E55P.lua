-- Aircraft specific briefing values and functions - E55P
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "AEROBASK PHENOM 300"
-- ACF_ICAO 695353800

kc_has_apu			= false		-- Aircraft has an APU
kc_has_gpu			= true		-- Aircraft has GPU connection
kc_has_irs			= false		-- Aircraft has IRS that must be aligned
kc_has_wipers		= false		-- Aircraft has wipers
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_beacon		= false
kc_has_autobrake	= false		-- Aircraft has autobrake
kc_has_reversers	= false		-- Aircraft has reversers
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= false		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0

kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1|2"
kc_TakeoffFlapsInd 	= "0|1|2"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "2|3|FULL"
kc_LandingFlapsInd 	= "2|3|4"
kc_LandingAutoBrake = "NO A/B|"

kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"