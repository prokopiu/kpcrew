-- SF50 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("SF50 sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("SF50 kc_macro_state_cold_and_dark")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()
	
	sysGeneral.parkBrakeSwitch:actuate(1) 

	sysGeneral.GearSwitch:actuate(1)

	kc_macro_set_flap(0)
	
	sysEngines.throttlePos:actuate(0)

	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)

	sysAice.engAntiIceGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	sysAice.windowHeatGroup:actuate(0)
	sysAir.engBleedGroup:actuate(0)
	sysAice.probeHeatGroup:actuate(0)
	
	sysGeneral.seatBeltSwitch:actuate(0)
	sysGeneral.noSmokingSwitch:actuate(0)

	sysElectric.genSwitchGroup:actuate(0)
	
	kc_macro_elec_cold_dark()
	
	set("sim/cockpit2/oxygen/actuators/demand_flow_setting",0)
	set_array("sim/cockpit2/switches/custom_slider_on",21,0)
	set_array("sim/cockpit2/switches/custom_slider_on",22,0)
	
	kc_macro_stop_engine()
end

function kc_macro_state_turnaround()
	logMsg("SF50 kc_macro_state_turnaround")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	sysGeneral.parkBrakeSwitch:actuate(1) 

	sysGeneral.GearSwitch:actuate(1)
	
	kc_macro_set_flap(0)
	
	sysEngines.throttlePos:actuate(0)

	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1)
	
	-- kc_macro_lights_preflight()
	
	-- sysControls.aileronReset:actuate(1)
	-- sysControls.rudderReset:actuate(1)
	
	-- sysElectric.genSwitchGroup:actuate(1)

	-- sysGeneral.seatBeltSwitch:actuate(1)
	-- sysGeneral.noSmokingSwitch:actuate(1)

	sysAice.windowHeatGroup:actuate(1)
	sysAice.probeHeatGroup:actuate(0)
	sysAir.engBleedGroup:actuate(0)
	
	kc_macro_set_local_baro()

	kc_macro_set_xpdrcode(sysRadios.stby)
	kc_macro_set_xpdrcode(2000)
	
	kc_macro_doors_preflight()
	kc_macro_mcp_preflight()
	
	set("sim/cockpit2/oxygen/actuators/demand_flow_setting",0)
	set_array("sim/cockpit2/switches/custom_slider_on",21,0)
	set_array("sim/cockpit2/switches/custom_slider_on",22,0)
	
	kc_macro_stop_engine()
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
			command_begin("laminar/SF50/eng_start_stop_toggle")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("laminar/SF50/eng_start_stop_toggle")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	command_once("laminar/SF50/ignition_down")
	command_once("laminar/SF50/eng_start_stop_toggle")
end

return sysMacros