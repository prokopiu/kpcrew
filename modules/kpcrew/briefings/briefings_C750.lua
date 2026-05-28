-- Aircraft specific briefing values and functions - Laminar C750
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Laminar Citation X 750"

-- === aircraft type

-- === Electric system
kc_has_standby_pwr	= false		-- Aircraft has standby power
kc_NumBatteries		= 2			-- Number of batteries acf

-- === Controls
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -1
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "UP|SLAT|5|15| | | "
kc_TakeoffFlapsInd 	= "0|1|2|3|3|3|3"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "15|FULL| | | | | | "
kc_LandingFlapsInd 	= "3|4|4|4|4|4|4"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_n2_after_start	= 40
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_FuelTankLeftInd	= 1
kc_FuelTankRghtInd	= 2
kc_FuelTankCntrInd  = 0
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice

-- === Lights
kc_has_nosmoke_sgn	= false		-- Aircraft has no smoking signs
kc_has_emer_lights	= true		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_irs			= false		-- Aircraft has IRS that must be aligned
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_autothrottle = false		-- Aircraft has autothrottle
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV

-- === other options
kc_has_toc			= false		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_transponder	= true		-- Aircraft has transponder
kc_has_doors		= true		-- Aircraft has doors
kc_has_cargo_doors	= true		-- Aircraft has cargo doors
kc_has_cockpit_door	= false		-- Aircraft has cockpit door
kc_has_wipers		= false		-- Aircraft has wipers

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|1|2|3|MAX"
kc_LandingAutoBrInd = "1|2|3|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0
kc_has_antiskid		= true

kc_can_load_speeds	= true		-- Aircraft can pass speeds to kpxbrief

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude

-- set the takeoff details v-speeds, trim
function kc_set_takeoff_details()
	activeBriefings:set("takeoff:v1",145)
	activeBriefings:set("takeoff:vr",145)
	activeBriefings:set("takeoff:v2",155)
	activeBriefings:set("takeoff:elevatorTrim",-6)
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	activeBriefings:set("approach:vref",132)
	activeBriefings:set("approach:vapp",137)
	activeBriefings:set("approach:altnvref",132)
	activeBriefings:set("approach:altnvapp",137)
end