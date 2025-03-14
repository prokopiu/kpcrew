-- Aircraft specific briefing values and functions - X-Crafts Free E-Jets
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "E195/E175 Free X-Crafts"

-- === aircraft type

-- === Electric system

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_NumFlapsTO		= 4
kc_TakeoffFlaps 	= "UP|1|2|3"
kc_TakeoffFlapsInd 	= "0|1|2|3"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "4|5|FULL"
kc_LandingFlapsInd 	= "4|5|6"
kc_full_rgt_rudder	= -14.9		-- Threshold where the rudder is almost fully to the right

-- === engines

-- === Fuel

-- === Hydraulics

-- === Air supply
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_NumLandingLts	= 3			-- Number of landing light switches

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_apptypes 		= "ILS CAT 1|VOR|NDB|RNAV|VISUAL|TOUCH AND GO|CIRCLING"
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_vnav			= false		-- Aircraft has VNAV

-- === other options
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_toc			= true		-- Airctaft has a takeof config check button
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= 1
kc_et_timer_off		= 0

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "RTO|OFF|LO|MED|HI"
kc_LandingAutoBrInd = "0|1|2|3|4"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 41000 	-- Max Altitude


