-- Aircraft specific briefing values and functions - Laminar C750
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar Citation X 750"

kc_has_irs			= false		-- Aircraft has IRS that must be aligned
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_beacon		= false
kc_has_autobrake	= false		-- Aircraft has autobrake

kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "UP|5|15"
kc_TakeoffFlapsInd 	= "0|2|3"
kc_TakeoffPacks 	= "ON|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_TakeoffApModes 	= "NAV/VNAV|HDG/FLCH"
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "15|FULL|"
kc_LandingFlapsInd 	= "3|4"
kc_LandingAutoBrake = "NO A/B|"
kc_StartSequence 	= "2 THEN 1|1 THEN 2"

kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief	
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- Weights (lb/kg)	Citation X, CE-750
-- Max Ramp					36,400/16.510
-- Max Takeoff				36,100/14.242
-- Max Landing				31,800/14.424
-- Zero Fuel				24,400/11.067
-- BOW						22,100/10.024
-- Max Payload				 2,300/1.043
-- Useful Load				14,300/6.486
-- Executive Payload		 1,800/816
-- Max Fuel					12,931/5.865
-- Avail Payload Max Fuel	 1,369/620
-- Avail Fuel Max Payload	12,000/5.443
-- Avail Fuel Exec Payload	12,500/5.669

-- Altitudes
kc_max_altitude		= 32000		-- Max Altitude
