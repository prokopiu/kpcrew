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
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	
	command_once("sim/electrical/battery_1_on")
	kc_macro_lights_cold_dark()
	kc_macro_mcp_cold_dark()
	kc_macro_doors_cold_dark()

	sysGeneral.parkBrakeSwitch:actuate(1)
	sysRadios.xpdrSwitch:actuate(0)
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
	set("sim/cockpit/engine/APU_switch",0)
	sysElectric.apuGenBusGroup:actuate(0)
	sysElectric.gpuGenBusGroup:actuate(0)
	command_once("laminar/md82cmd/bleedair/APU_up")
	command_once("laminar/md82cmd/bleedair/APU_up")
	set("laminar/md82/electrical/voltmeter_source",0)
	set_array("sim/cockpit2/electrical/battery_on",1,0)
	command_once("laminar/md82cmd/ignition_sys_dwn")
	command_once("laminar/md82cmd/ignition_sys_dwn")
	command_once("laminar/md82cmd/ignition_sys_up")
	sysGeneral.seatBeltSwitch:actuate(0)
	sysGeneral.noSmokingSwitch:actuate(0)
	sysAir.engBleedGroup:actuate(0)
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
	sysMCP.yawDamper:actuate(0)
	set("laminar/md82/bleedair/HVAC_L_knob",0)
	set("laminar/md82/bleedair/HVAC_R_knob",0)
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
	sysElectric.galleyPower:actuate(0)
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
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	
	command_once("sim/electrical/battery_1_on")
	if get("laminar/md82/safeguard",3) == 0 then 
		command_once("laminar/md82cmd/safeguard03")
	end
	kc_macro_lights_preflight()
	kc_macro_doors_preflight()
	sysGeneral.doorL2:actuate(1)
	sysGeneral.wiperGroup:actuate(0)	
	sysGeneral.GearSwitch:actuate(1)	
	sysHydraulic.elecHydPumpGroup:actuate(0)
	sysControls.flapsSwitch:actuate(0)
	sysElectric.voltmeterSwitch:actuate(4) 
	sysGeneral.parkBrakeSwitch:actuate(1)
	set("sim/cockpit2/controls/speedbrake_ratio",0)
	kc_macro_gpu_connect()
	sysElectric.gpuGenBus1:actuate(1)
	sysElectric.gpuGenBus2:actuate(1)
	sysFuel.fuelPumpGroup:actuate(0)
	set_array("sim/cockpit/engine/fuel_pump_on",0,0)
	set("sim/cockpit2/controls/aileron_trim",0)
	set("sim/cockpit2/controls/rudder_trim",0)
	set("sim/time/timer_is_running_sec",0)
	set("sim/cockpit2/switches/alternate_static_air_ratio",0)
	sysAir.engBleedGroup:actuate(0)
	sysAir.packSwitchGroup:actuate(0)
	set("laminar/md82/IAS/custom_bug1",0.15439)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug4",0.680363)
	sysElectric.galleyPower:actuate(1)
	set("sim/cockpit/engine/APU_switch",2)
	command_once("laminar/md82cmd/bleedair/APU_dwn")
	command_once("laminar/md82cmd/bleedair/APU_dwn")
	sysElectric.apuGenBus1:actuate(1)
	sysElectric.apuGenBus2:actuate(1)
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
		sysMCP.fdirPilotSwitch:getStatus() == 1 and
		sysMCP.athrSwitch:getStatus() == 0 and
		sysMCP.yawDamper:getStatus() == 0 and
		sysMCP.apAnc:getStatus() == 0
end

-- speedbugs set
function kc_macro_md82_set_to_speedbugs()
	set("laminar/md82/IAS/custom_bug4",0.680363)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug1",0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
end

function kc_macro_md82_check_to_speedbugs()
	return
		get("laminar/md82/IAS/custom_bug1") == (0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038) and
		get("laminar/md82/IAS/custom_bug2") == 0.376973 and
		get("laminar/md82/IAS/custom_bug3") == 0.495849 and
		get("laminar/md82/IAS/custom_bug4") == 0.680363 and
		sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2")
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