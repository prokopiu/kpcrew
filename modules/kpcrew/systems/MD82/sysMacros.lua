-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

function kc_macro_state_cold_and_dark()
	sysGeneral.doorGroup:actuate(0)
	sysGeneral.doorL1:actuate(1)
	sysGeneral.stairsLeft:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
	sysElectric.gpuSwitch:actuate(0)
	if get("laminar/md82/safeguard",2) > 0 then
		command_once("laminar/md82cmd/safeguard02")
	end
	-- antiskid off
	if get("sim/cockpit2/switches/generic_lights_switch",35) > 0 then
		command_once("sim/lights/generic_36_light_tog")
	end
	sysControls.yawDamper:actuate(0)
	kc_macro_ext_lights_off()
	sysGeneral.wiperSwitch1:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	sysAir.engBleedGroup:actuate(0)
	sysAir.packSwitchGroup:actuate(0)
	sysFuel.fuelPumpGroup:actuate(0)
	kc_macro_gpu_disconnect()
	if get("laminar/md82/safeguard",3) == 1 then 
		command_once("laminar/md82cmd/safeguard03")
	end
	command_once("sim/electrical/APU_off")
	sysElectric.apuGenBus1:actuate(0)
	sysElectric.apuGenBus2:actuate(0)
	sysAir.apuBleedSwitch:actuate(0)
	sysAir.bleedEng1Switch:actuate(0)
	sysAir.packLeftSwitch:actuate(0)
	sysFuel.fuelPumpRightAft:actuate(0)
	sysElectric.batterySwitch:actuate(0) 
	sysLights.positionSwitch:actuate(0)
	sysElectric.voltmeterSwitch:actuate(1) 
	sysEngines.startPumpDc:actuate(0)
end

function kc_macro_state_turnaround()
	sysGeneral.wiperSwitch1:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	sysElectric.voltmeterSwitch:actuate(4) 
	sysElectric.batterySwitch:actuate(1) 
	if get("laminar/md82/safeguard",3) == 0 then 
		command_once("laminar/md82cmd/safeguard03")
	end
	kc_macro_ext_lights_stand()
	kc_macro_int_lights_on()
	sysAir.engBleedGroup:actuate(0)
	sysAir.packSwitchGroup:actuate(0)
	sysFuel.fuelPumpGroup:actuate(0)
	sysLights.positionSwitch:actuate(1)
	if activePrefSet:get("aircraft:powerup_apu") == false then 
		kc_macro_gpu_connect()
	else
		sysEngines.startPumpDc:actuate(1)
	end
end

-- external lights all off
function kc_macro_ext_lights_off()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
end

-- external lights at the stand
function kc_macro_ext_lights_stand()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.wingSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.wingSwitch:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
end


-- internal lights at stand
function kc_macro_int_lights_on()
	if kc_is_daylight() then		
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.instr2Light:actuate(1)
		sysLights.instr6Light:actuate(1)
		sysLights.instr7Light:actuate(1)
	else
		sysLights.domeLightSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
	end
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
	set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") == math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100
end

-- glareshield initial setup
function kc_macro_glareshield_initial()
	sysMCP.fdirGroup:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.crs1Selector:setValue(1)
	sysMCP.crs2Selector:setValue(1)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:setValue(0)
	sysMCP.discAPSwitch:actuate(0)
	sysMCP.turnRateSelector:actuate(5)
end

-- glareshield takeoff setup
function kc_macro_glareshield_takeoff()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	if activeBriefings:get("takeoff:apMode") == 1 then
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	end
end


-- function kc_bck_()
-- end

return sysMacros