-- B7x7 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B7x7 sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	set("1-sim/electrical/batteryCover",0)
	set("params/stairs",1)
	set("params/LSU",0)
	set("prep/loader",0)
	set("params/gpu",0)
	set("1-sim/engine/leftStartSelector",2)
	set("1-sim/engine/rightStartSelector",2)
	set("1-sim/cond/aftTempControl",0)
	set("1-sim/cond/fltdkTempControl",0)
	set("1-sim/cond/fwdTempControl",0)
	set("1-sim/emer/lightsCover",1)
	set("1-sim/eng/APUswitch",0)
	set("1-sim/WX/modeSwitcher",0)
	set("1-sim/press/modeSelector",0)
	set("anim/57/button",0)
	set("anim/57/button/anim",0)
	set("anim/58/button",0)
	set("anim/58/button/anim",0)
	set("1-sim/AP/desengageLever",1)
	set("1-sim/AP/desengageLever/anim",1)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	set("1-sim/electrical/batteryCover",1)
	set("params/stairs",1)
	set("params/LSU",1)
	set("prep/loader",1)
	set("params/gpu",1)
	set("1-sim/engine/leftStartSelector",2)
	set("1-sim/engine/rightStartSelector",2)
	set("1-sim/cond/aftTempControl",0.5)
	set("1-sim/cond/fltdkTempControl",0.5)
	set("1-sim/cond/fwdTempControl",0.5)
	set("1-sim/emer/lightsCover",0)
	set("1-sim/WX/modeSwitcher",1)
	set("1-sim/press/modeSelector",0)
	set("anim/57/button",1)
	set("anim/57/button/anim",1)
	set("anim/58/button",1)
	set("anim/58/button/anim",1)
	set("1-sim/AP/desengageLever",0)
	set("1-sim/AP/desengageLever/anim",0)
end
-- ====================================== Lights related functions
function kc_macro_lights(flightphase)
	logMsg("Lights flight phase: " .. kcSopFlightPhase[flightphase])

	-- Cold & dark
	if flightphase == kc_phase_colddark then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(0)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		-- turnaround
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(0)
		sysLights.beaconSwitch:actuate(0)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.positionSwitch:actuate(1)
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	elseif flightphase == kc_phase_before_start then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(0)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
		if kc_is_daylight() == false then
			sysLights.domeLightGroup:actuate(1)
			sysLights.logoSwitch:actuate(1)
			sysLights.wingSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	elseif flightphase == kc_phase_taxi_rwy then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	elseif flightphase == kc_phase_before_takeoff then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
		elseif flightphase == kc_phase_approach then
		sysLights.landLightGroup:actuate(1)
		sysLights.rwyLightGroup:actuate(1)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
		kc_macro_lights_descend_10k()
	elseif flightphase == kc_phase_afterland then
		sysLights.landLightGroup:actuate(0)
		sysLights.rwyLightGroup:actuate(0)
		sysLights.taxiSwitch:actuate(1)
		sysLights.positionSwitch:actuate(1)
		sysLights.beaconSwitch:actuate(1)
		sysLights.strobesSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(1)
		sysLights.domeLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.emerLights:actuate(1)
		if kc_is_daylight() == false then
			sysLights.logoSwitch:actuate(1)
			sysLights.panelLightGroup:actuate(1)
		end
	else
		logMsg("Invalid flightphase")
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
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
		sysElectric.stbyPowerSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
		sysElectric.apuGenBus1:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.avionicsSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
		sysElectric.acBusTie:actuate(1)
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPump1:actuate(0)
		sysHydraulic.elecHydPump2:actuate(0)
		sysHydraulic.elecHydPump3:actuate(0)
		sysHydraulic.elecHydPump4:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPump1:actuate(0)
		sysHydraulic.elecHydPump2:actuate(0)
		sysHydraulic.elecHydPump3:actuate(0)
		sysHydraulic.elecHydPump4:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPump1:actuate(1)
		sysHydraulic.elecHydPump2:actuate(1)
		sysHydraulic.elecHydPump3:actuate(1)
		sysHydraulic.elecHydPump4:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPump1:actuate(1)
		sysHydraulic.elecHydPump2:actuate(1)
		sysHydraulic.elecHydPump3:actuate(1)
		sysHydraulic.elecHydPump4:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPump1:actuate(1)
		sysHydraulic.elecHydPump2:actuate(1)
		sysHydraulic.elecHydPump3:actuate(1)
		sysHydraulic.elecHydPump4:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPump1:actuate(1)
		sysHydraulic.elecHydPump2:actuate(1)
		sysHydraulic.elecHydPump3:actuate(1)
		sysHydraulic.elecHydPump4:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPump1:actuate(0)
		sysHydraulic.elecHydPump2:actuate(0)
		sysHydraulic.elecHydPump3:actuate(0)
		sysHydraulic.elecHydPump4:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
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
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_approach then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(1)
		sysAir.engBleedGroup:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(1)
	else
		logMsg("Invalid flightphase")
	end	
end

-- ====================================== A/P & Glareshield related functions
function kc_macro_mcp(flightphase)
	logMsg("MCP flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.discAPSwitch:actuate(0)
		sysMCP.ap1Switch:actuate(0)
		sysMCP.yawDamper:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.yawDamper:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.yawDamper:actuate(1)
	elseif flightphase == kc_phase_before_takeoff then
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(1)
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.yawDamper:actuate(1)
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	elseif flightphase == kc_phase_afterland then
		sysMCP.fdirGroup:actuate(0)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(0)
		sysMCP.yawDamper:actuate(0)
	else 
		logMsg("Invalid flightphase")
	end
end 

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(1)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
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
		kc_procvar_set(delayvar,30)
		set("1-sim/engine/APUStartSelector",2)
		set("1-sim/engine/APUStartSelector/anim",2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			set("1-sim/engine/APUStartSelector",1)
			set("1-sim/engine/APUStartSelector/anim",1)
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
		sysElectric.gpuGenBusGroup:actuate(0)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- APU start background
function kc_macro_apustop()
	sysElectric.apuGenBusGroup:actuate(0)
	set("1-sim/engine/APUStartSelector",0)
	set("1-sim/engine/APUStartSelector/anim",0)
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,6)
		set("1-sim/engine/ignitionSelector",0)
		set("1-sim/engine/ignitionSelector/anim",0)
		if trigger == "engstart1" then
			set("1-sim/fuel/fuelCutOffLeft",0)
			set("1-sim/engine/leftStartSelector",0)
			set("anim/rhotery/8/anim",0)
		end
		if trigger == "engstart2" then
			set("1-sim/fuel/fuelCutOffRight",0)
			set("1-sim/engine/rightStartSelector",0)
			set("anim/rhotery/9/anim",0)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				set("1-sim/fuel/fuelCutOffLeft",2)
				set("1-sim/engine/leftStartSelector",1)
				set("anim/rhotery/8/anim",1)
			end
			if trigger == "engstart2" then
				set("1-sim/fuel/fuelCutOffRight",2)
				set("1-sim/engine/rightStartSelector",1)
				set("anim/rhotery/9/anim",1)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("1-sim/fuel/fuelCutOffLeft",0)
	set("1-sim/fuel/fuelCutOffRight",0)
end


-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
sysGeneral.irsUnit1Switch:setValue(0)
sysGeneral.irsUnit2Switch:setValue(0)
sysGeneral.irsUnit3Switch:setValue(0)
	elseif mode == 1 then -- ALIGN
sysGeneral.irsUnit1Switch:setValue(1)
sysGeneral.irsUnit2Switch:setValue(1)
sysGeneral.irsUnit3Switch:setValue(1)
	elseif mode == 2 then -- NAV 
sysGeneral.irsUnit1Switch:setValue(2)
sysGeneral.irsUnit2Switch:setValue(2)
sysGeneral.irsUnit3Switch:setValue(2)
	end
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return math.ceil(get("sim/cockpit/misc/barometer_setting")*100)/100 == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 
end

return sysMacros