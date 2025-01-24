-- MD82 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("MD82 sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("MD82 kc_macro_state_cold_and_dark")
	command_once("sim/electrical/battery_1_on")
	kc_macro_lights_cold_dark()
	kc_macro_mcp_cold_dark()
	kc_macro_doors_cold_dark()

	sysGeneral.parkBrakeSwitch:actuate(1)
	set("sim/cockpit2/switches/electric_hydraulic_pump_on",0)
	set_array("sim/cockpit2/engine/actuators/mixture_ratio",0,0)
	set_array("sim/cockpit2/engine/actuators/mixture_ratio",1,0)
	set("sim/cockpit2/controls/rudder_trim",0) 
	set("sim/cockpit2/controls/aileron_trim",0)	
	command_once("laminar/md82cmd/bleedair/APU_up")
	command_once("laminar/md82cmd/bleedair/APU_up")
	command_once("sim/fuel/fuel_pumps_off")
	set_array("sim/cockpit2/fuel/fuel_tank_pump_on",0,0)
	set_array("sim/cockpit2/fuel/fuel_tank_pump_on",1,0)
	set_array("sim/cockpit2/fuel/fuel_tank_pump_on",2,0)
	set("laminar/md82/bleedair/bleedair_HVAC_L",0)
	set("laminar/md82/bleedair/bleedair_HVAC_R",0)
	set("sim/cockpit2/switches/auto_brake_level",1)
	set("laminar/md82/electrical/cross_tie_APU_L",0)
	set("laminar/md82/electrical/cross_tie_APU_R",0)
	set("laminar/md82/electrical/cross_tie_GPU_L",0)
	set("laminar/md82/electrical/cross_tie_GPU_R",0)
	set("laminar/md82/electrical/voltmeter_source",0)
	set_array("sim/cockpit2/electrical/battery_on",1,0)
	command_once("laminar/md82cmd/ignition_sys_dwn")
	command_once("laminar/md82cmd/ignition_sys_dwn")
	command_once("laminar/md82cmd/ignition_sys_up")
	set("sim/cockpit/switches/no_smoking",0)
	set("sim/cockpit/switches/fasten_seat_belts",0)
	set_array("laminar/md82/safeguard",3,0)
	while get("laminar/md82/ice/heatmeter") ~= 0 do
		command_once("laminar/md82cmd/ice/selheatknob_up")
	end
	command_once("sim/ice/inlet_heat0_off")
	command_once("sim/ice/inlet_heat1_off")
	command_once("sim/ice/window_heat_off")
	command_once("sim/ice/wing_heat0_off")
	command_once("sim/ice/wing_heat1_off")
	set_array("sim/cockpit2/switches/generic_lights_switch",35,0)
	set("sim/cockpit/switches/yaw_damper_on",0)
	set("laminar/md82/bleedair/HVAC_L_knob",0.5)
	set("laminar/md82/bleedair/HVAC_R_knob",0.5)
	command_once("sim/transponder/transponder_standby")
	command_once("sim/electrical/generator_1_off")
	command_once("sim/electrical/generator_2_off")
	set_array("sim/cockpit2/switches/generic_lights_switch",36,0)
	set("sim/cockpit2/autopilot/flight_director_mode",0)
	if get("laminar/md82/electrical/cross_tie_AC") > 0 then	
		command_once("laminar/md82cmd/electrical/cross_tie_AC")
	end
	set("laminar/md82/electrical/voltmeter_source",0)
	set("sim/cockpit2/controls/flap_ratio",0)
	set("sim/cockpit2/switches/wiper_speed",0)
	-- sysGeneral.doorGroup:actuate(0)
	-- sysGeneral.doorL1:actuate(1)
	-- sysGeneral.stairsLeft:actuate(1)
	-- sysGeneral.cockpitDoor:actuate(1)
	-- sysElectric.gpuSwitch:actuate(0)
	if get("laminar/md82/safeguard",2) > 0 then
		command_once("laminar/md82cmd/safeguard02")
	end
	-- antiskid off
	if get("sim/cockpit2/switches/generic_lights_switch",35) > 0 then
		command_once("sim/lights/generic_36_light_tog")
	end
	sysGeneral.GearSwitch:actuate(1)
	-- kc_macro_gpu_disconnect()
	if get("laminar/md82/safeguard",3) == 1 then 
		command_once("laminar/md82cmd/safeguard03")
	end
	-- command_once("sim/electrical/APU_off")
	-- sysElectric.apuGenBusGroup:actuate(0)
	-- command_once("sim/electrical/battery_1_off")
	-- sysEngines.startPumpDc:actuate(0)
	set("laminar/md82/IAS/custom_bug1",0.15439)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug4",0.680363)
end

function kc_macro_state_turnaround()
	logMsg("MD82 kc_macro_state_turnaround")
	sysGeneral.wiperSwitch1:actuate(0)
	set("sim/cockpit2/controls/flap_ratio",0)
	sysGeneral.GearSwitch:actuate(1)
	sysElectric.voltmeterSwitch:actuate(4) 
	sysElectric.batterySwitch:actuate(1) 
	if get("laminar/md82/safeguard",3) == 0 then 
		command_once("laminar/md82cmd/safeguard03")
	end
	kc_macro_ext_lights_stand()
	kc_macro_int_lights_on()
	sysLights.positionSwitch:actuate(1)
	sysAir.engBleedGroup:actuate(0)
	sysAir.packSwitchGroup:actuate(0)
	sysFuel.fuelPumpGroup:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysEngines.startPumpDc:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	set("laminar/md82/IAS/custom_bug1",0.15439)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug4",0.680363)
end






-- connect and start gpu
function kc_macro_gpu_connect()
	if get("sim/cockpit/electrical/gpu_on") == 0 then
		command_once("sim/electrical/GPU_on")
		if get("laminar/md82/electrical/cross_tie_GPU_L") == 0 then
			command_once("laminar/md82cmd/electrical/cross_tie_GPU_L")
		end
		if get("laminar/md82/electrical/cross_tie_GPU_R") == 0 then
			command_once("laminar/md82cmd/electrical/cross_tie_GPU_R")
		end
	end
end

-- diconnect gpu
function kc_macro_gpu_disconnect()
	if get("sim/cockpit/electrical/gpu_on") == 1 then
		if get("laminar/md82/electrical/cross_tie_GPU_L") > 0 then
			command_once("laminar/md82cmd/electrical/cross_tie_GPU_L")
		end
		if get("laminar/md82/electrical/cross_tie_GPU_R") > 0 then
			command_once("laminar/md82cmd/electrical/cross_tie_GPU_R")
		end
		command_once("sim/electrical/GPU_off")
	end
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return math.floor(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")*100)/100 == math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100
end

function kc_is_preflight_fgcp_checked()
	return
		get("sim/cockpit2/autopilot/flight_director_mode") == 0 and
		get("laminar/md82/autopilot/autothrottle_switch") == 0 and
		get("sim/cockpit/autopilot/autopilot_mode") == 0 and
		get("sim/cockpit/switches/yaw_damper_on") == 0
-- A/P OFF
end

function kc_macro_mcp_cold_dark()
	set("sim/cockpit2/autopilot/flight_director_mode",0)
	if get("laminar/md82/autopilot/autothrottle_switch") > 0 then
		command_once("laminar/md82cmd/autopilot/autothrottle_switch")
	end
	set("sim/cockpit/radios/nav1_obs_degm",1)
	set("sim/cockpit/radios/nav2_obs_degm",1)
	set("sim/cockpit/autopilot/airspeed",activePrefSet:get("aircraft:mcp_def_spd"))
	set("sim/cockpit/autopilot/heading_mag",activePrefSet:get("aircraft:mcp_def_hdg"))
	set("sim/cockpit/autopilot/altitude",activePrefSet:get("aircraft:mcp_def_alt"))
	set("sim/cockpit/autopilot/vertical_velocity",0)
	set("sim/cockpit/autopilot/autopilot_mode",0)
	set("sim/cockpit/switches/yaw_damper_on",0)
end

function kc_macro_mcp_preflight()
	set("sim/cockpit2/autopilot/flight_director_mode",0)
	if get("laminar/md82/autopilot/autothrottle_switch") > 0 then
		command_once("laminar/md82cmd/autopilot/autothrottle_switch")
	end
	set("sim/cockpit/autopilot/airspeed", activeBriefings:get("takeoff:v2"))
	set("sim/cockpit/autopilot/heading_mag",activeBriefings:get("departure:initHeading"))
	set("sim/cockpit/autopilot/altitude",activeBriefings:get("departure:initAlt"))
	set("sim/cockpit/autopilot/vertical_velocity",0)
	set("sim/cockpit/autopilot/autopilot_mode",0)
	set("sim/cockpit/switches/yaw_damper_on",0)
end

-- speedbugs set
function kc_macro_md82_set_to_speedbugs()
	set("laminar/md82/IAS/custom_bug4",0.680363)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug1",0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
end

-- speedbugs set
function kc_macro_md82_set_ldg_speedbugs()
	set("laminar/md82/IAS/custom_bug4",0.57328)
	set("laminar/md82/IAS/custom_bug3",0.284922)
	set("laminar/md82/IAS/custom_bug2",0.270964)
	set("laminar/md82/IAS/custom_bug1",0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038)
end

-- function kc_bck_()
-- end

return sysMacros