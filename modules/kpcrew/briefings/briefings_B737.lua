-- Aircraft specific briefing values and functions - Laminar B737
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "Zibo Mod & LEVELUP"

-- === aircraft type
kc_is_boeing		= true		-- Aircraft is a Boeing
kc_is_zibo			= true

if kc_is_zibo then 
	kc_acf_name 		= "Zibo Mod 738 / LevelUp"
end

if get("sim/aircraft2/metadata/is_cargo") == 1 then
	kc_is_cargo			= true		-- This is a cargo version
else
	kc_is_cargo			= false
end

-- === Electric system
-- kc_has_apu			= true		-- Aircraft has an APU
-- kc_has_gpu			= true		-- Aircraft has GPU connection
-- kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
-- kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
-- kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
-- kc_remove_gpu_after	= true		-- remove GPU after start
-- kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
-- kc_has_speedbrake	= true		-- Aircraft has an air brake to extend
-- kc_has_aileron_trim	= true		-- Aircraft has aileron trim
-- kc_has_rudder_trim	= true		-- Aircraft has rudder trim
-- kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
-- kc_spdbrk_arm_pos	= 0.0889
-- kc_spdbrk_arm_to	= false		-- Speedbrake to be armed for takeoff (e.g. Airbus)
-- kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
-- kc_NumFlapsTO		= 5
-- kc_TakeoffFlaps 	= "UP|1|5|10|15| | "
-- kc_TakeoffFlapsInd 	= "0|1|3|4|5|2|2"
-- kc_NumFlapsLDG		= 3
-- kc_LandingFlaps 	= "25|30|40| | | | "
-- kc_LandingFlapsInd 	= "6|7|8|8|8|8|8"
-- kc_gear_ext_index	= 3			-- When to extend gear in flaps extend
-- kc_announce_flaps	= true 

-- === engines
kc_StartSequence 	= "2 THEN 1|1 THEN 2"
kc_StartBackground	= { [1] = {"2", "1"}, [2] = {"1", "2"} }
kc_has_reversers	= true		-- Aircraft has reversers
kc_has_rated_to		= true		-- Aircraft has rated thrust setting for T/O
kc_TakeoffThrust 	= "TOGA|FLEX|D-TO"
kc_n2_after_start	= 40
kc_has_ignition		= false		-- has ignition switch
kc_needs_throttle_idle = true	-- Aircraft needs idle throttle on start

-- === Fuel
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector

-- === Hydraulics
-- kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
-- kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps
-- kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
-- kc_has_iso_valvle	= true		-- Aircraft has switchable isolation valve
-- kc_has_engine_bleed = true		-- Aircraft has engine bleeds
-- kc_has_oxygen		= true		-- Aircraft has oxygen supply
-- kc_has_recirc		= true		-- Aircraft has recirc system
-- kc_has_trim_air		= true		-- Aircraft has trim air

-- === Anti Ice
-- kc_has_window_heat	= true		-- Aircraft has dedicated window heat
-- kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
-- kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
-- kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 4			-- Number of landing light switches
kc_has_beacon		= true		-- Aircraft has beacon
kc_has_taxi_light	= true		-- Aircraft has taxi light
kc_has_wing_lights	= true		-- Aircraft has wing Lights
kc_has_wheel_lights	= true		-- Aircraft has wheel Lights
kc_has_pos_lights	= true		-- Aircraft has switchable position Lights
kc_has_strobe_lights= true		-- Aircraft has strobe lights
kc_has_rwy_lights	= true		-- Aircraft has rwy turnoff lights
kc_has_logo_lights	= true		-- Aircraft has logo lights
kc_has_dome_lights	= true		-- Aircraft has dome/cockpit lights
kc_has_instr_lights	= true		-- Aircraft has instrument Lights
kc_has_panel_lights = true		-- Aircraft has panel lights
kc_has_seatbelt_sgn	= true		-- Aircraft has seatbelt signs
kc_has_nosmoke_sgn	= true		-- Aircraft has no smoking signs
kc_has_emer_lights	= true		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief
-- B738 weights
kc_MZFW				= 61690
kc_MaxPayload 		= 20540		-- Maximum Payload to be set
if PLANE_ICAO == "B736"	then
	kc_MZFW				= 54180
	kc_MaxPayload 		= 15600		-- Maximum Payload to be set
end
if PLANE_ICAO == "B737"	then
	kc_MZFW				= 54650
	kc_MaxPayload 		= 16500		-- Maximum Payload to be set
end
if PLANE_ICAO == "B739"	then
	kc_MZFW				= 119200
	kc_MaxPayload 		= 20240		-- Maximum Payload to be set
end

-- === MCP & autopilot
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_NumIRS			= 2			-- Number of IRS systems
kc_irs_off			= 0
kc_irs_align		= 1
kc_irs_nav			= 2
kc_irs_att			= 3
kc_has_flightdir	= true		-- Aircraft has flight director
kc_has_autopilot	= true		-- Aircraft has autopilot
kc_has_autothrottle = true		-- Aircraft has autothrottle
kc_has_ias_sel		= true		-- Aircraft has IAS selector
kc_has_hdg_sel		= true		-- Aircraft has Heading selector
kc_has_alt_sel		= true		-- Aircraft has ALT selector
kc_has_vsp_sel		= true		-- Aircraft has vertical speed selector
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper
kc_has_ils			= true		-- Aircraft has ILS receiver
kc_has_rnav_cap		= true		-- Aircraft has rnav capability
kc_has_vnav			= true		-- Aircraft has VNAV
kc_has_lnav			= true		-- Aircraft has LNAV
kc_has_flch_ias		= true		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_radar_alt	= true		-- Aircraft has radar altitude
kc_has_dh_minimum	= true		-- Aircraft has decicion height
kc_has_meter_pfd	= true		-- Aircraft can show meters in PFD
kc_has_mach_switch	= true		-- Aircraft can switch between ias mach
kc_has_xp_g1000		= false     -- Aircraft has XP G1000
kc_sets_climb_speed	= false		-- ias is set to climbspeed
kc_show_ilsfrq_btn	= true		-- can set frequency

-- === other options
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_retractgear	= true		-- Aircraft has retractable gear
kc_has_ground_obj	= false		-- Aircraft has its own ground objects (chocks etc)
kc_has_wipers		= true		-- Aircraft has wipers
kc_has_wx_radar		= true		-- Aircraft has weather radar
kc_has_toc			= false		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_transponder	= true		-- Aircraft has transponder
kc_has_doors		= true		-- Aircraft has doors
kc_has_cargo_doors	= true		-- Aircraft has cargo doors
kc_has_cockpit_door	= true		-- Aircraft has cockpit door
kc_has_adf_radios	= true		-- Aircraft has ADF radios
kc_has_nav_radios	= true		-- Aircraft has NAV radios
kc_has_windows		= false		-- Aircraft has openable windows
kc_can_load_speeds	= true		-- Aircraft can pass speeds to kpxbrief


kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "RTO|OFF|1|2|3|MAX"
kc_LandingAutoBrInd = "0|1|2|3|4|5"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0
kc_has_antiskid		= true

-- === Callouts
kc_callout_v1		= false
kc_callout_vr		= false
kc_callout_v2		= false

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude

-- set the takeoff details v-speeds, trim
function kc_set_takeoff_details()
	activeBriefings:set("takeoff:v1",get("laminar/B738/FMS/v1_set"))
	activeBriefings:set("takeoff:vr",get("laminar/B738/FMS/vr"))
	activeBriefings:set("takeoff:v2",get("laminar/B738/FMS/v2_set"))
	activeBriefings:set("takeoff:elevatorTrim",get("laminar/B738/FMS/trim_calc"))
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	activeBriefings:set("approach:vref",get("laminar/B738/FMS/vref"))
	activeBriefings:set("approach:vapp",get("laminar/B738/FMS/vref")+get("laminar/B738/FMS/approach_wind_corr"))
	activeBriefings:set("approach:altnvref",get("laminar/B738/FMS/vref"))
	activeBriefings:set("approach:altnvapp",get("laminar/B738/FMS/vref")+get("laminar/B738/FMS/approach_wind_corr"))
	-- local ldgflaps = get("laminar/B738/FMS/approach_flaps")
	-- if ldgflaps == 30 then
		-- activeBriefings:set("approach:flaps",1)
	-- elseif ldgflaps == 40 then
		-- activeBriefings:set("approach:flaps",2)
	-- end
end