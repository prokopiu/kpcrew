-- Aircraft specific briefing values and functions - E1XX
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "X-Crafts E-JET FAMILY"

-- === aircraft type

-- === Electric system
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= false		-- Aircraft has standby power

-- === Controls
kc_spdbrk_can_arm	= false		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_NumFlapsTO		= 4
kc_TakeoffFlaps 	= "UP|1|2|3| | | "
kc_TakeoffFlapsInd 	= "0|1|2|3|3|3|3"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "4|5|FULL| | | | "
kc_LandingFlapsInd 	= "4|5|6|6|6|6|6"
kc_full_rgt_rudder	= 29		-- Threshold where the rudder is almost fully to the right
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines

-- === Fuel
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics
kc_has_hyd_elec_pmps= false		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= true		-- Aircraft has power transfer unit

-- === Air supply
kc_has_recirc		= true		-- Aircraft has recirc system

-- === Anti Ice
kc_has_pitot_heat	= false		-- Aircraft has pitot heat
kc_has_wing_antiice	= false		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= false		-- Aircraft has engine antiice measures

-- === Lights
kc_NumLandingLts	= 3			-- Number of landing light switches
kc_has_emer_lights	= true		-- Aircraft has emergency lights

-- === MCP & autopilot
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV

-- === Payload & weights
kc_MaxRamp			= -1		-- Max Ramp weight
kc_DOW 				= -1		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= -1		-- Maximum Zero Fuel Weight
kc_MaxPayload 		= -1		-- Maximum Payload to be set
kc_MTOW 			= -1		-- Maximum Takeoff Weight
kc_MLW  			= -1		-- Maximum Landing Weight
kc_pld_ld_button	= false		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV

-- === other options
kc_has_stairs		= true		-- Aircraft has autonomous stairs on L1
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_wx_radar		= true		-- Aircraft has weather radar
kc_has_toc			= false		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0
kc_has_windows		= true		-- Aircraft has openable windows

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "RTO|OFF|LO|MED|HI"
kc_LandingAutoBrInd = "0|1|2|3|4"
kc_AutoBrakeOff		= 1
kc_AutoBrakeRTO		= 0
kc_has_antiskid		= false

-- === Operating speeds
kc_speeds_vs0		= -1		-- Stall Speed, Landing Configuration from ACF
kc_speeds_vs1		= -1		-- Stall Speed, Clean (near landing speed)
kc_speeds_vs		= -1		-- Minimum Controllable Speed from ACF

kc_speeds_vx		= 270		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 300		-- Best Rate of Climb - set for aircraft
kc_speeds_vr		= 125		-- Rotation speed - set for each aircraft

kc_speeds_vfe		= -1		-- Maximum flaps Extended Speed 

kc_speeds_vmo1		= -1		-- Maximum Operating Speed (Sea Level to 8,000 ft) 
kc_speeds_vmo2		= -1		-- Maximum Operating Speed (Above 8,000 ft) 
kc_speeds_vmo3		= -1		-- Maximum Mach Number 

kc_speeds_vle		= -1		-- Maximum Gear Operating Speed Vle from ACF
kc_speeds_vlo		= -1		-- Maximum Gear Extended Speed vle+20 if not known

kc_speeds_vne		= -1		-- V never exceed from acf
kc_speeds_vno		= -1		-- V maximum ctructural speed from acf 

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
