-- B738 airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

function kc_macro_state_cold_and_dark()
	sysGeneral.doorL1:actuate(1)
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	sysGeneral.fdrSwitch:actuate(modeOff) 
	sysGeneral.fdrCover:actuate(modeOn)
	sysGeneral.vcrSwitch:actuate(modeOff)
	sysEngines.eecSwitchGroup:actuate(modeOn)
	sysEngines.eecGuardGroup:actuate(modeOff)
	sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitOFF)
	sysLights.domeLightSwitch:actuate(0)
	sysLights.instrLightGroup:actuate(modeOff)
	sysMCP.vhfNavSwitch:actuate(0)
	sysMCP.irsNavSwitch:setValue(0)
	sysMCP.fmcNavSwitch:setValue(0)
	sysMCP.displaySourceSwitch:setValue(0)
	sysMCP.displayControlSwitch:setValue(0)
	sysControls.yawDamper:actuate(modeOff)
	sysFuel.allFuelPumpGroup:actuate(modeOff)
	sysFuel.crossFeed:actuate(modeOff)		
	sysElectric.dcPowerSwitch:actuate(sysElectric.dcPwrBAT)
	sysElectric.stbyPowerSwitch:actuate(modeOn)
	sysElectric.stbyPowerCover:actuate(modeOn) 
	sysElectric.ifePwr:actuate(modeOff)
	sysElectric.cabUtilPwr:actuate(modeOff)
	sysElectric.acPowerSwitch:actuate(sysElectric.acPwrGRD)
	if activeBriefings:get("taxi:gateStand") > 1 then
		if get("laminar/B738/airstairs_hide") == 1  then
			command_once("laminar/B738/airstairs_toggle")
		end
	end
	sysGeneral.wiperGroup:actuate(modeOff)
	set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
	set("laminar/B738/toggle_switch/eq_cool_supply",0)
	sysGeneral.emerExitLightsCover:actuate(1)
	sysGeneral.emerExitLightsSwitch:actuate(0)
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	sysGeneral.noSmokingSwitch:setValue(0)
	sysAice.windowHeatGroup:actuate(0)
	sysAice.probeHeatGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	sysAice.engAntiIceGroup:actuate(0)
	sysHydraulic.elecHydPumpGroup:actuate(modeOff)
	sysHydraulic.engHydPumpGroup:actuate(modeOff)
	set("laminar/B738/toggle_switch/air_temp_source",3)
	sysAir.contCabTemp:setValue(0.5) 
	sysAir.fwdCabTemp:setValue(0.5) 
	sysAir.aftCabTemp:setValue(0.5)
	set("laminar/B738/air/trim_air_pos",1)
	sysAir.recircFanLeft:actuate(modeOff) 
	sysAir.recircFanRight:actuate(modeOff)
	sysAir.packSwitchGroup:setValue(sysAir.packModeOff)
	sysAir.bleedEng1Switch:actuate(0) 
	sysAir.bleedEng2Switch:actuate(0)
	sysAir.apuBleedSwitch:actuate(modeOff)
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvClosed)
	sysAir.maxCruiseAltitude:setValue(0)
	sysAir.landingAltitude:setValue(0)
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")		
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/tab/home")
	command_once("laminar/B738/tab/menu6")
	command_once("laminar/B738/tab/menu1")
	command_once("laminar/B738/toggle_switch/gpu_up")
	command_once("laminar/B738/push_button/flaps_0")
	set("laminar/B738/flt_ctrls/speedbrake_lever",0)
	sysGeneral.parkBrakeSwitch:actuate(modeOn)
	sysEngines.startLever1:actuate(0) 
	sysEngines.startLever2:actuate(0)
	set("laminar/B738/fms/chock_status",1)
	sysEngines.engStarterGroup:actuate(1)
	sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby)
	sysGeneral.autobrake:actuate(1)
	sysMCP.fdirGroup:actuate(0)
	sysElectric.batteryCover:actuate(modeOn)
	sysElectric.batterySwitch:actuate(modeOff)
	command_once("sim/electrical/APU_off")
	command_once("sim/electrical/GPU_off")
	sysGeneral.emerExitLightsCover:actuate(1)
	sysGeneral.emerExitLightsSwitch:actuate(0)
	sysEFIS.minsResetPilot:actuate(0)
	sysEFIS.minsResetCopilot:actuate(0)
end

function kc_macro_state_turnaround()
	sysGeneral.doorL1:actuate(1)
	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	sysElectric.batteryCover:actuate(modeOff)
	sysElectric.batterySwitch:actuate(modeOn)
	sysGeneral.fdrSwitch:actuate(modeOff) 
	sysGeneral.fdrCover:actuate(modeOn)
	sysGeneral.vcrSwitch:actuate(modeOn)
	sysEngines.eecSwitchGroup:actuate(modeOn)
	sysEngines.eecGuardGroup:actuate(modeOff)
	sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitOFF)

	if activePrefSet:get("aircraft:powerup_apu") == false then
		if get("laminar/B738/gpu_available") == 0 then
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6")
			command_once("laminar/B738/tab/menu1")
		end
		sysElectric.gpuSwitch:actuate(cmdDown)
	end

	sysMCP.vhfNavSwitch:actuate(0)
	sysMCP.irsNavSwitch:setValue(0)
	sysMCP.fmcNavSwitch:setValue(0)
	sysMCP.displaySourceSwitch:setValue(0)
	sysMCP.displayControlSwitch:setValue(0)
	sysControls.yawDamper:actuate(modeOff)
	sysFuel.allFuelPumpGroup:actuate(modeOff)
	sysFuel.crossFeed:actuate(modeOff)
	sysElectric.dcPowerSwitch:actuate(sysElectric.dcPwrBAT)
	sysElectric.stbyPowerCover:actuate(modeOff) 
	sysElectric.ifePwr:actuate(modeOn)
	sysElectric.cabUtilPwr:actuate(modeOn)
	sysElectric.acPowerSwitch:actuate(sysElectric.acPwrGRD)
	sysGeneral.wiperGroup:actuate(modeOff)
	set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
	set("laminar/B738/toggle_switch/eq_cool_supply",0)
	sysGeneral.emerExitLightsCover:actuate(0)
	sysGeneral.emerExitLightsSwitch:actuate(1)
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
	sysGeneral.noSmokingSwitch:setValue(1)
	sysAice.windowHeatGroup:actuate(0)
	sysAice.probeHeatGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	sysAice.engAntiIceGroup:actuate(0)
	sysHydraulic.elecHydPumpGroup:actuate(modeOff)
	sysHydraulic.engHydPumpGroup:actuate(modeOn)
	set("laminar/B738/toggle_switch/air_temp_source",3)
	sysAir.contCabTemp:setValue(0.5) 
	sysAir.fwdCabTemp:setValue(0.5) 
	sysAir.aftCabTemp:setValue(0.5)
	set("laminar/B738/air/trim_air_pos",1)
	sysAir.recircFanLeft:actuate(modeOn) 
	sysAir.recircFanRight:actuate(modeOn)
	sysAir.packSwitchGroup:setValue(sysAir.packModeAuto)
	sysAir.bleedEng1Switch:actuate(1) 
	sysAir.bleedEng2Switch:actuate(1)
	sysAir.apuBleedSwitch:actuate(modeOff)
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvOpen)
	sysAir.maxCruiseAltitude:setValue(0)
	sysAir.landingAltitude:setValue(0)
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
	if kc_is_daylight() then		
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(modeOff)
	else
		sysLights.domeLightSwitch:actuate(-1)
		sysLights.instrLightGroup:actuate(modeOn)
	end
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	command_once("laminar/B738/push_button/flaps_0")
	set("laminar/B738/flt_ctrls/speedbrake_lever",0)
	sysGeneral.parkBrakeSwitch:actuate(modeOn)
	sysEngines.startLever1:actuate(0) 
	sysEngines.startLever2:actuate(0)
	set("laminar/B738/fms/chock_status",1)
	sysEngines.engStarterGroup:actuate(1)
	sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby)
	sysGeneral.autobrake:actuate(1)
	sysMCP.fdirGroup:actuate(0)
	sysMCP.fdirGroup:actuate(modeOff)
	sysMCP.athrSwitch:actuate(modeOff)
	sysMCP.crs1Selector:setValue(1)
	sysMCP.crs2Selector:setValue(1)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.turnRateSelector:actuate(3)
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:setValue(modeOff)
	sysMCP.discAPSwitch:actuate(modeOff)
	sysEFIS.mtrsPilot:actuate(modeOff)
	sysEFIS.fpvPilot:actuate(modeOff)
	if activeBriefings:get("taxi:gateStand") > 1 then
		if get("laminar/B738/airstairs_hide") == 1  then
			command_once("laminar/B738/airstairs_toggle")
		end
	end
	sysEFIS.minsResetPilot:actuate(0)
	sysEFIS.minsResetCopilot:actuate(0)
	kc_wnd_brief_action=1
end


-- external lights all off
-- external lights runway entry
-- external lights takeoff
-- external lights above 10000
-- external lights below 10000
-- external lights runway vacated
-- external lights at the stand

-- internal lights all off
-- internal lights at stand

-- doors all closed
-- doors at stand 

-- initialise IRS

-- glareshield initial setup
-- efis initial setup
-- glareshield takeoff setup
-- glareshield landing setup

-- fuel pumps all off
-- fuel pumps all on

-- hyd pumps initial setup
-- hyd pumps all off
-- hyd pumps all on

-- prepare engine start
-- start 1st engine
-- start nth engine

-- air switches for takeoff
-- air switches all on

-- xpdr standby
-- xpdr mode c
-- xpdr modus bck

-- flaps up
-- flaps for takeoff
-- flaps level during landing bck ??
-- flaps retract during takeoff bck??

-- abrk off
-- abrk for takeoff

-- fds off
-- fds for takeoff

-- 10000 feet activities up and down

-- fire tests ?!? as bck
-- apu start bck
-- gpu start bck

-- bck callouts when needed

-- function kc_bck_()
-- end

return sysMacros