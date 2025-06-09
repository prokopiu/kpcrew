-- E1XX airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("E1XX sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("XCrafts/temp_cabin_switch",23)
	set("XCrafts/temp_cockpit_switch",23)
	set("sim/cockpit2/switches/generic_lights_switch",35,0)
	command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
	set("XCrafts/light/sterile_switch",0)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("XCrafts/temp_cabin_switch",23)
	set("XCrafts/temp_cockpit_switch",23)
	set("sim/cockpit2/switches/generic_lights_switch",35,0)
	command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_DC_pump_switch_cw_cmnd")
	command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
	command_once("XCrafts/fuel/fuel_transfer_sw_cw_cmnd")
	set("XCrafts/light/sterile_switch",0)
end

-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.yawDamper:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.yawDamper:actuate(0)
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.yawDamper:actuate(1)
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.athrSwitch:actuate(1)
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.yawDamper:actuate(o)
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.yawDamper:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end
-- ====================================== anti-ice system flight phase 
function kc_macro_aice(flightphase)
	logMsg("Anti-Ice flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
	elseif flightphase == kc_phase_turnaround then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
	elseif flightphase == kc_phase_descent then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
	elseif flightphase == kc_phase_afterland then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
	else 
		logMsg("Invalid flightphase")
	end
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,6)
		sysElectric.apuGenBusGroup:actuate(1)
		sysElectric.apuStartSwitch:setValue(2)
		command_once("XCrafts/APU_CW")
		command_once("XCrafts/APU_CW")
		set("sim/cockpit2/electrical/APU_starter_switch",2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("sim/cockpit2/electrical/APU_N1_percent") == 100 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- APU start background
function kc_macro_apustop()
	command_once("XCrafts/APU_CCW")
	command_once("XCrafts/APU_CCW")
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		command_once("sim/engines/mixture_max")
		if trigger == "engstart1" then
			command_begin("sim/starters/engage_start_run_1")
			command_once("XCrafts/Starter_Eng_1_up_CW")
			command_once("XCrafts/Starter_Eng_1_up_CW")
		end
		if trigger == "engstart2" then
			command_begin("sim/starters/engage_start_run_2")
			command_once("XCrafts/Starter_Eng_2_up_CW")
			command_once("XCrafts/Starter_Eng_2_up_CW")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_start_run_1")
			end
			if trigger == "engstart2" then
				command_end("sim/starters/engage_start_run_2")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("sim/cockpit2/engine/actuators/mixture_ratio_all",0)
	command_once("XCrafts/Starter_Eng_1_down_CCW")
	command_once("XCrafts/Starter_Eng_1_down_CCW")
	command_once("XCrafts/Starter_Eng_2_down_CCW")
	command_once("XCrafts/Starter_Eng_2_down_CCW")
end

-- Set ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		set("XCrafts/other/ground_objects",0)
		set("XCrafts/other/remove_before_flight",1)
	else
		set("XCrafts/other/ground_objects",1)
		set("XCrafts/other/remove_before_flight",1)
	end
end

return sysMacros