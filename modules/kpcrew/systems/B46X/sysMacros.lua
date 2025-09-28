-- B46X airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B46X sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("thranda/autopilot/Power",0) -- AP MASTER
	set("thranda/electrical/GrndIgnition",1) -- GND IGN BOTH
	set("thranda/pneumatic/DISCH_Valve",1) -- DISH VALVE NORM
	set("thranda/ACSYST/PassTemp",0)
	set("thranda/ACSYST/PilotTemp",0)
	set("thranda/ACSYST/CabinTempMode",1)
	set("thranda/ACSYST/FltDeckTempMode",1)
	if get("thranda/SwitchMonitor",36) > 1 then
		command_once("thranda/switches/SwitchDn36")
	end
	set("thranda/gear/AntiSkid",1) -- ANTI SKID
	set("thranda/hydraulics/SpoilerGreen",0) -- LIFT SPLRS
	set("thranda/hydraulics/SpoilerYellow",0)
	set("thranda/fuel/InterconnectSw",1)
	set("thranda/fuel/StbyPumpL",0)
	set("thranda/fuel/StbyPumpR",0) -- STBY PUMPS
	set("thranda/fuel/CrossFeedL",0) -- CROSS FEED 
	set("thranda/fuel/CrossFeedR",0)
	set("thranda/brakes/brakeFanOn",0)
	set("thranda/DME1/DMESelBtn",0)
	set("thranda/radios/VHF_Power",0)
	set("thranda/generic/com1/genCom1Pwr",0)
	set("thranda/generic/com1/genCom2Pwr",0)
	if get("thranda/SwitchMonitor",87) > 0.8 then
		command_once("thranda/switches/SwitchDn87")
	end
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("thranda/autopilot/Power",1) -- AP MASTER
	set("thranda/electrical/GrndIgnition",1) -- GND IGN BOTH
	set("thranda/pneumatic/DISCH_Valve",1) -- DISH VALVE NORM
	set("thranda/ACSYST/PassTemp",0.5) -- TEMP SELECT
	set("thranda/ACSYST/PilotTemp",0.5)	
	set("thranda/ACSYST/CabinTempMode",1)
	set("thranda/ACSYST/FltDeckTempMode",1)
	if get("thranda/SwitchMonitor",36) < 1 then -- GALLEY PWR ON
		command_once("thranda/switches/SwitchDn36")
	end
	set("thranda/gear/AntiSkid",2) -- ANTI SKID
	set("thranda/hydraulics/SpoilerGreen",1) -- LIFT SPLRS
	set("thranda/hydraulics/SpoilerYellow",1)
	set("thranda/fuel/InterconnectSw",2)
	set("thranda/fuel/StbyPumpL",1)
	set("thranda/fuel/StbyPumpR",1) -- STBY PUMPS
	set("thranda/fuel/CrossFeedL",0) -- CROSS FEED 
	set("thranda/fuel/CrossFeedR",0)
	set("thranda/brakes/brakeFanOn",1)
	-- NAV1 Radio on
	set("thranda/DME1/DMESelBtn",2)
	set("thranda/radios/VHF_Power",1)
	set("thranda/generic/com1/genCom1Pwr",1)
	set("thranda/generic/com1/genCom2Pwr",1)
	if get("thranda/SwitchMonitor",87) < 0.9 then
		command_once("thranda/switches/SwitchUp87")
	end

end

-- ====================================== Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(0)
		sysElectric.dcBusTie:actuate(0)
		sysElectric.acBusTie:actuate(0)
		sysElectric.batterySwitch:actuate(0) 
		sysElectric.battery2Switch:actuate(0) 
		sysElectric.stbyPowerSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
		sysElectric.gen1Switch:actuate(1)
		sysElectric.gen2Switch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(0)
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		sysAir.oxygenMaster:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		if activeBriefings:get("takeoff:packs") < 2 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
	elseif flightphase == kc_phase_takeoff then
		sysAir.oxygenMaster:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenMaster:actuate(1)
	elseif flightphase == kc_phase_approach then
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenMaster:actuate(1)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
		sysAir.trimAirSwitch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenMaster:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,5)
		-- start master on
		set("thranda/electrical/StarterSw",1)
		if trigger == "engstart1" then
			set("thranda/electrical/StarterSel",0)
			command_begin("thranda/switches/SwitchUp51")
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			set("thranda/electrical/StarterSel",1)
			command_begin("thranda/switches/SwitchUp51")
			kc_speakNoText(0,"Starting Engine 2")
		end
		if trigger == "engstart3" then
			set("thranda/electrical/StarterSel",3)
			command_begin("thranda/switches/SwitchUp51")
			kc_speakNoText(0,"Starting Engine 3")
		end
		if trigger == "engstart4" then
			set("thranda/electrical/StarterSel",4)
			command_begin("thranda/switches/SwitchUp51")
			kc_speakNoText(0,"Starting Engine 4")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("thranda/switches/SwitchUp51")
				set_array("thranda/cockpit/ThrottleLatch",0,1)
				set_array("thranda/cockpit/Throttle",0,0)
			end
			if trigger == "engstart2" then
				command_end("thranda/switches/SwitchUp51")
				set_array("thranda/cockpit/ThrottleLatch",1,1)
				set_array("thranda/cockpit/Throttle",1,0)
			end
			if trigger == "engstart3" then
				command_end("thranda/switches/SwitchUp51")
				set_array("thranda/cockpit/ThrottleLatch",2,1)
				set_array("thranda/cockpit/Throttle",2,0)
			end
			if trigger == "engstart4" then
				command_end("thranda/switches/SwitchUp51")
				set_array("thranda/cockpit/ThrottleLatch",3,1)
				set_array("thranda/cockpit/Throttle",3,0)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set_array("thranda/cockpit/ThrottleLatch",0,1)
	set_array("thranda/cockpit/ThrottleLatch",1,1)
	set_array("thranda/cockpit/ThrottleLatch",2,1)
	set_array("thranda/cockpit/ThrottleLatch",3,1)

	set_array("thranda/cockpit/Throttle",0,-0.1)
	set_array("thranda/cockpit/Throttle",1,-0.1)
	set_array("thranda/cockpit/Throttle",2,-0.1)
	set_array("thranda/cockpit/Throttle",3,-0.1)

	set_array("thranda/cockpit/ThrottleLocked",0,1)
	set_array("thranda/cockpit/ThrottleLocked",1,1)
	set_array("thranda/cockpit/ThrottleLocked",2,1)
	set_array("thranda/cockpit/ThrottleLocked",3,1)

	set_array("thranda/cockpit/ThrottleLatch",0,0)
	set_array("thranda/cockpit/ThrottleLatch",1,0)
	set_array("thranda/cockpit/ThrottleLatch",2,0)
	set_array("thranda/cockpit/ThrottleLatch",3,0)
end

return sysMacros