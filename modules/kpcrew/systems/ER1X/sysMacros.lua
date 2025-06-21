-- ER1X airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("ER1X sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set_array("sim/cockpit2/switches/generic_lights_switch",28,0) -- SHED BUSES OFF
	sysElectric.apuGenBusGroup:actuate(1)

	set_array("sim/cockpit2/switches/generic_lights_switch",31,0) -- ENG 1A FUELPUMP
	set_array("sim/cockpit2/switches/generic_lights_switch",32,0) -- ENG 2A FUEL PUMP
	set_array("sim/cockpit2/switches/generic_lights_switch",37,1) -- FUS TK XFER OFF

	set_array("sim/cockpit2/switches/generic_lights_switch",12,1) -- ICE PROT STAB AUTO	
	set_array("sim/cockpit2/switches/generic_lights_switch",34,1) -- ICE DETECTION OVERRIDE AUTO
	
	sysAir.recircSwitchGroup:actuate(0)
	set_array("sim/cockpit2/switches/generic_lights_switch",34,1) -- ICE DETECTION OVERRIDE AUTO
	set_array("sim/cockpit2/switches/generic_lights_switch",19,0) -- GASPER OFF
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set_array("sim/cockpit2/switches/generic_lights_switch",28,1) -- SHED BUSES AUTO
	sysElectric.apuGenBusGroup:actuate(1)

	set_array("sim/cockpit2/switches/generic_lights_switch",31,0) -- ENG 1A FUELPUMP
	set_array("sim/cockpit2/switches/generic_lights_switch",32,0) -- ENG 2A FUEL PUMP
	set_array("sim/cockpit2/switches/generic_lights_switch",37,1) -- FUS TK XFER OFF

	set_array("sim/cockpit2/switches/generic_lights_switch",12,1) -- ICE PROT STAB AUTO	
	set_array("sim/cockpit2/switches/generic_lights_switch",34,1) -- ICE DETECTION OVERRIDE AUTO
	
	sysAir.recircSwitchGroup:actuate(1)
	set_array("sim/cockpit2/switches/generic_lights_switch",34,1) -- ICE DETECTION OVERRIDE AUTO
	set_array("sim/cockpit2/switches/generic_lights_switch",19,1) -- GASPER AUTO
	
	command_once("sim/annunciator/clear_master_warning")
end

-- ====================================== anti-ice system flight phase 
function kc_macro_aice(flightphase)
	logMsg("Anti-Ice flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	elseif flightphase == kc_phase_turnaround then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	elseif flightphase == kc_phase_descent then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	elseif flightphase == kc_phase_afterland then
		sysAice.engAntiIceGroup:actuate(1)
		sysAice.wingAiceGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		sysAice.probeHeatGroup:actuate(1)
	else 
		logMsg("Invalid flightphase")
	end
end

-- ====================================== Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_press_cab then
			if activeBriefings:get("takeoff:packs") < 2 then 
				sysAir.packSwitchGroup:setValue(1)
			else
				sysAir.packSwitchGroup:setValue(0)
			end
		end
		sysAir.isoValveSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
	elseif flightphase == kc_phase_takeoff then
		if kc_has_press_cab then
			if activeBriefings:get("takeoff:packs") < 2 then 
				sysAir.packSwitchGroup:setValue(1)
			else
				sysAir.packSwitchGroup:setValue(0)
			end
		end
		sysAir.isoValveSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
	elseif flightphase == kc_phase_approach then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		if kc_has_press_cab then
			if activeBriefings:get("approach:packs") == 1 then
				sysAir.packSwitchGroup:actuate(0)
			else
				sysAir.packSwitchGroup:actuate(1)
			end
		end
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(0)
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

return sysMacros