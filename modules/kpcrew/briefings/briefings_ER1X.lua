-- Aircraft specific briefing values and functions - ER1X
--
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

require("kpcrew.briefings.briefings_DFLT")

kc_acf_name 		= "X-Crafts ERJ Family " .. PLANE_ICAO

-- === aircraft type

-- === Electric system
kc_has_inv_ess_bus	= true		-- Aircraft has inverters and essential busses
kc_has_bus_ties		= true		-- Aircraft has bus ties for AC & DC
kc_has_avionics_sw  = true		-- Aircraft has Avionics switch
kc_remove_gpu_after	= true		-- remove GPU after start
kc_has_standby_pwr	= true		-- Aircraft has standby power

-- === Controls
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_NumFlapsTO		= 3
kc_TakeoffFlaps 	= "0|9|18||||"
kc_TakeoffFlapsInd 	= "0|1|2|2|2|2|2"
kc_NumFlapsLDG		= 2
kc_LandingFlaps 	= "22|45|||||"
kc_LandingFlapsInd 	= "3|4|4|4|4|4|4"
kc_gear_ext_index	= 2			-- When to extend gear in flaps extend

-- === engines
kc_n2_after_start	= 30
kc_has_ignition		= true		-- has ignition switch

-- === Fuel
kc_FuelTankLeftInd	= 0
kc_FuelTankRghtInd	= 1
kc_FuelTankCntrInd  = 2
kc_FFPH 			= -1		-- Fuel Flow per hour from acf
kc_has_fuel_pumps   = true		-- Aircraft has switchable fuel pumps
kc_has_fuel_xfeed	= true		-- Aircraft has fuel crossfeed
kc_fuel_ld_button	= true		-- Load the aircraft fuel from kpxbrief
kc_has_fuel_select	= false		-- Aircraft has fuel tank selector

-- === Hydraulics
kc_has_hyd_elec_pmps= true		-- Aircraft has electric hydraulic pumps
kc_has_hyd_eng_pmps = false		-- Aircraft has engine hydraulic pumps
kc_has_ptu			= false		-- Aircraft has power transfer unit

-- === Air supply
kc_has_press_cab	= true		-- Aircraft has pressurized cabine
kc_has_iso_valvle	= true		-- Aircraft has switchable isolation valve
kc_has_engine_bleed = true		-- Aircraft has engine bleeds
kc_has_oxygen		= false		-- Aircraft has oxygen supply

-- === Anti Ice
kc_has_window_heat	= true		-- Aircraft has dedicated window heat
kc_has_wing_antiice	= true		-- Aircraft has anti ice measures for wings
kc_has_eng_antiice	= true		-- Aircraft has engine antiice measures
kc_has_pitot_heat	= true		-- Aircraft has pitot heat

-- === Lights
kc_has_wheel_lights	= true		-- Aircraft has wheel Lights
kc_has_rwy_lights	= false		-- Aircraft has rwy turnoff lights
kc_has_emer_lights	= true		-- Aircraft has emergency lights

-- === Payload & weights
kc_pld_ld_button	= true		-- Load the aircraft payload from kpxbrief	

-- === MCP & autopilot
kc_has_autothrottle = true		-- Aircraft has autothrottle
kc_has_vsp_sel		= false		-- Aircraft has vertical speed selector
kc_has_rnav_cap		= false		-- Aircraft has rnav capability
kc_has_vnav			= false		-- Aircraft has VNAV
kc_has_lnav			= false		-- Aircraft has LNAV
kc_has_flch_ias		= true		-- Aircraft has FLCH/IAS mode
kc_has_altsel_mode	= false		-- Aircraft needs atlsel to be selected
kc_has_radar_alt	= true		-- Aircraft has radar altitude
kc_has_dh_minimum	= true		-- Aircraft has decicion height
kc_has_yawdamper	= true		-- Aircraft has switchable yaw damper

-- === other options
kc_has_ground_obj	= true		-- Aircraft has its own ground objects (chocks etc)
kc_has_toc			= true		-- Airctaft has a takeof config check button
kc_has_chrono		= false		-- Aircraft has a chrono stopwatch
kc_has_clock		= true		-- Aircraft has a clock stopwatch
kc_et_timer_on		= -1
kc_et_timer_off		= 0

kc_has_autobrake	= false		-- Aircraft has autobrake
kc_has_antiskid		= false
kc_can_load_speeds	= true		-- Aircraft can pass speeds to kpxbrief

-- === Operating speeds
kc_speeds_vx		= 270		-- Best Angle of Climb - set for aircraft
kc_speeds_vy		= 300		-- Best Rate of Climb - set for aircraft
kc_speeds_vr		= 125		-- Rotation speed - set for each aircraft

-- === Altitudes
kc_max_altitude		= 40000 	-- Max Altitude

-- Set the fuel for the aircraft
function kc_set_fuel(totalfuel)
	if totalfuel > kc_get_MaxFuel() then 
		totalfuel = kc_get_MaxFuel()
	end
	-- left tanks 1,3,6
	local lefttankmax = kc_get_MFL(0)+kc_get_MFL(2)+kc_get_MFL(5)
	-- right tanks 2,4,7
	local righttankmax = kc_get_MFL(1)+kc_get_MFL(3)+kc_get_MFL(5)	
	-- center tank 5
	local centertankmax = kc_get_MFL(4)

	if totalfuel <= lefttankmax+righttankmax then
		local halftotal = totalfuel/2
		set_array("sim/flightmodel/weight/m_fuel",4,0)
		if halftotal <= kc_get_MFL(0) then
			set_array("sim/flightmodel/weight/m_fuel",0,halftotal)
			set_array("sim/flightmodel/weight/m_fuel",2,0)
			set_array("sim/flightmodel/weight/m_fuel",5,0)
		else
			if halftotal <= kc_get_MFL(0) + kc_get_MFL(2) then
				set_array("sim/flightmodel/weight/m_fuel",0,kc_get_MFL(0))
				set_array("sim/flightmodel/weight/m_fuel",2,halftotal-kc_get_MFL(0))
				set_array("sim/flightmodel/weight/m_fuel",5,0)
			else
				set_array("sim/flightmodel/weight/m_fuel",0,kc_get_MFL(0))
				set_array("sim/flightmodel/weight/m_fuel",2,kc_get_MFL(2))
				set_array("sim/flightmodel/weight/m_fuel",5,halftotal-kc_get_MFL(0)-kc_get_MFL(2))
			end
		end
		if halftotal <= kc_get_MFL(1) then
			set_array("sim/flightmodel/weight/m_fuel",1,halftotal)
			set_array("sim/flightmodel/weight/m_fuel",3,0)
			set_array("sim/flightmodel/weight/m_fuel",6,0)
		else
			if halftotal <= kc_get_MFL(1) + kc_get_MFL(2) then
				set_array("sim/flightmodel/weight/m_fuel",1,kc_get_MFL(1))
				set_array("sim/flightmodel/weight/m_fuel",3,halftotal-kc_get_MFL(1))
				set_array("sim/flightmodel/weight/m_fuel",6,0)
			else
				set_array("sim/flightmodel/weight/m_fuel",1,kc_get_MFL(1))
				set_array("sim/flightmodel/weight/m_fuel",3,kc_get_MFL(3))
				set_array("sim/flightmodel/weight/m_fuel",6,halftotal-kc_get_MFL(1)-kc_get_MFL(3))
			end
		end
	else
			set_array("sim/flightmodel/weight/m_fuel",0,kc_get_MFL(0))
			set_array("sim/flightmodel/weight/m_fuel",2,kc_get_MFL(2))
			set_array("sim/flightmodel/weight/m_fuel",5,kc_get_MFL(5))
			set_array("sim/flightmodel/weight/m_fuel",1,kc_get_MFL(1))
			set_array("sim/flightmodel/weight/m_fuel",3,kc_get_MFL(3))
			set_array("sim/flightmodel/weight/m_fuel",6,kc_get_MFL(6))
			
			set_array("sim/flightmodel/weight/m_fuel",4,totalfuel-kc_get_MFL(0)-kc_get_MFL(1)-kc_get_MFL(2)-kc_get_MFL(3)-kc_get_MFL(5)-kc_get_MFL(6))
	end
end

-- get MAC% CG from x-plane
function kc_get_mac_cg()
	return get("sim/flightmodel2/misc/cg_offset_z_mac") + 3
end

-- set the takeoff details v-speeds, trim
function kc_set_takeoff_details()
	activeBriefings:set("takeoff:v1",get("XCrafts/ERJ/PFD_V1_speed_bug")*-1)
	activeBriefings:set("takeoff:vr",get("XCrafts/ERJ/PFD_VR_speed_bug")*-1)
	activeBriefings:set("takeoff:v2",get("XCrafts/ERJ/PFD_V2_speed_bug")*-1)
	activeBriefings:set("takeoff:elevatorTrim",6)
end

-- set the landing details v-speeds, trim
function kc_set_landing_details()
	activeBriefings:set("approach:vref",get("XCrafts/ERJ/Vapp_speed_bug")*-1-5)
	activeBriefings:set("approach:vapp",get("XCrafts/ERJ/Vapp_speed_bug")*-1)
	activeBriefings:set("approach:altnvref",get("XCrafts/ERJ/Vapp_speed_bug")*-1-5)
	activeBriefings:set("approach:altnvapp",get("XCrafts/ERJ/Vapp_speed_bug")*-1)
end