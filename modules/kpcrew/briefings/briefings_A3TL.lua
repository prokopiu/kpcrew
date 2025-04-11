-- Aircraft specific briefing values and functions - A3TL ToLiss Airbusses
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "ToLiss Airbus"

-- === aircraft type
kc_is_airbus		= true		-- Aircraft is an Airbus

-- === Electric system
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	kc_NumBatteries		= 2			-- Number of batteries
else
	kc_NumBatteries		= 3			-- Number of batteries
end
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = false		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start

-- === Controls
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= -0.5
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|1+F|2"
kc_TakeoffFlapsInd 	= "0|1|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "3|FULL"
kc_LandingFlapsInd 	= "3|4"

-- === engines
kc_n2_after_start	= 50

-- === Fuel
kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= false		-- Load the aircraft fuel from kpxbrief

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = true		-- Aircraft has engine hydraulic pumps

-- === Air supply
kc_LandingPacks 	= "OFF|ON"
kc_TakeoffPacks 	= "ON|AUTO|OFF"
kc_TakeoffBleeds 	= "OFF|ON"
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= true		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = true		-- Aircraft has engine bleeds
kc_has_oxygen		= true		-- Aircraft has oxygen supply

-- === Anti Ice
kc_TakeoffAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_LandingAntiice 	= "NOT REQUIRED|ENGINE ONLY|ENGINE AND WING"
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_NumLandingLts	= 2			-- NUmber of landing light switches
kc_has_beacon		= true		-- Aircraft has beacon
kc_has_strb_as_bcn	= false		-- Aircraft uses strobe lights for beacon 
kc_has_taxi_light	= true		-- Aircraft has taxi light
kc_has_ll_as_taxi	= false		-- Aircraft uses landing lights to taxi
kc_has_wing_lights	= true		-- Aircraft has wing Lights
kc_has_wheel_lights	= false		-- Aircraft has wheel Lights
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
kc_MaxRamp			= -1		-- Max Ramp weight
kc_DOW 				= -1		-- Dry Operating Weight (aka OEW)
kc_MZFW  			= -1		-- Maximum Zero Fuel Weight
kc_MaxPayload 		= -1		-- Maximum Payload to be set
kc_MTOW 			= -1		-- Maximum Takeoff Weight
kc_MLW  			= -1		-- Maximum Landing Weight
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_irs			= true		-- Aircraft has IRS that must be aligned
kc_NumIRS			= 3			-- Number of IRS systems
kc_has_yawdamper	= false		-- Aircraft has switchable yaw damper
kc_has_ils			= true		-- Aircraft has ILS receiver
kc_has_rnav_cap		= true		-- Aircraft has rnav capability
kc_has_vnav			= true		-- Aircraft has VNAV
kc_has_lnav			= true		-- Aircraft has LNAV
kc_has_flch_ias		= true		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_radar_alt	= true		-- Aircraft has radar altitude
kc_has_dh_minimum	= true		-- Aircraft has decicion height

-- === other options
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_toc			= true		-- Airctaft has a takeof config check button
kc_has_chrono		= true		-- Aircraft has a chrono stopwatch

kc_has_autobrake	= true		-- Aircraft has autobrake
kc_LandingAutoBrake = "OFF|LO|MED|MAX"
kc_LandingAutoBrInd = "0|1|2|3"
kc_AutoBrakeOff		= 0
kc_AutoBrakeRTO		= 3

-- === Operating speeds

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude
