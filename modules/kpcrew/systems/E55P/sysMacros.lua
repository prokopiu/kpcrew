-- E55P airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("E55P sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("E55P kc_macro_state_cold_and_dark")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()
	if kc_has_gpu == true then
		sysElectric.gpuGenBusGroup:actuate(0)
	end
	
	sysControls.Speedbrake:setValue(0)
	if kc_has_wipers == true then
		sysGeneral.wiperGroup:actuate(0)
	end
	sysGeneral.GearSwitch:actuate(1)
	sysEngines.throttlePos:actuate(0)
	kc_macro_hydraulic_off()
	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
	sysAir.packSwitchGroup:actuate(0)
	sysElectric.genSwitchGroup:actuate(0)
	sysGeneral.seatBeltSwitch:actuate(0)
	sysGeneral.noSmokingSwitch:actuate(0)
	sysElectric.inverterSwitchGroup:actuate(0)
	sysElectric.dcBusTie:actuate(0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)
	set_array("sim/cockpit/engine/ignition_on",0,0)
	set_array("sim/cockpit/engine/ignition_on",1,0)
	set_array("sim/cockpit/engine/ignition_on",2,0)
	set_array("sim/cockpit/engine/ignition_on",3,0)
	sysAice.windowHeatGroup:actuate(0)
	sysElectric.avionicsSwitchGroup:actuate(0)
	if kc_has_apu == true then
		sysElectric.apuStartSwitch:actuate(0)
	end
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 
	sysControls.Autobrake:setValue(1)
	sysControls.flapsSwitch:setValue(0)
	if kc_has_gpu == true then
		sysElectric.gpuConnect:actuate(0)
	end
end

function kc_macro_state_turnaround()
	logMsg("E55P kc_macro_state_turnaround")

	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1)
	kc_macro_lights_preflight()
	if kc_has_wipers == true then
		sysGeneral.wiperGroup:actuate(0)
	end
	sysGeneral.GearSwitch:actuate(1)
	sysControls.Speedbrake:setValue(0)
	sysEngines.throttlePos:actuate(0)
	kc_macro_hydraulic_initial()
	if kc_has_gpu == true then
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
	end
	sysElectric.avionicsSwitchGroup:actuate(1)
	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)
	sysFuel.crossFeed:actuate(0)
	sysAir.packSwitchGroup:actuate(1)
	sysElectric.genSwitchGroup:actuate(0)
	sysFuel.allFuelPumpGroup:actuate(1)
	sysGeneral.seatBeltSwitch:actuate(1)
	sysGeneral.noSmokingSwitch:actuate(1)
	sysElectric.inverterSwitchGroup:actuate(1)
	sysElectric.dcBusTie:actuate(1)
	sysAice.windowHeatGroup:actuate(1)
	sysRadios.xpdrCode:actuate(2000)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
	set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)
	set_array("sim/cockpit/engine/ignition_on",0,0)
	set_array("sim/cockpit/engine/ignition_on",1,0)
	set_array("sim/cockpit/engine/ignition_on",2,0)
	set_array("sim/cockpit/engine/ignition_on",3,0)
	sysControls.Autobrake:setValue(1)
	sysControls.flapsSwitch:setValue(0)
	kc_macro_doors_preflight()
	kc_macro_mcp_preflight()

end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_up")
			command_once("aerobask/engines/knob_1_rt")
			command_begin("aerobask/engines/knob_1_rt")
		end
		if trigger == "engstart2" then
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_up")
			command_once("aerobask/engines/knob_2_rt")
			command_begin("aerobask/engines/knob_2_rt")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("aerobask/engines/knob_1_rt")
			end
			if trigger == "engstart2" then
				command_end("aerobask/engines/knob_2_rt")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

return sysMacros