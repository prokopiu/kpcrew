-- B738 airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

-- cold & dark
function kc_macro_state_cold_and_dark()
	kc_macro_ext_doors_stand()

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

	kc_macro_int_lights_off()	

	sysMCP.vhfNavSwitch:actuate(0)
	sysMCP.irsNavSwitch:setValue(0)
	sysMCP.fmcNavSwitch:setValue(0)
	sysMCP.displaySourceSwitch:setValue(0)
	sysMCP.displayControlSwitch:setValue(0)
	sysControls.yawDamper:actuate(modeOff)
	
	kc_macro_fuelpumps_off()

	sysElectric.dcPowerSwitch:actuate(sysElectric.dcPwrBAT)
	sysElectric.stbyPowerSwitch:actuate(modeOn)
	sysElectric.stbyPowerCover:actuate(modeOn) 
	sysElectric.ifePwr:actuate(modeOff)
	sysElectric.cabUtilPwr:actuate(modeOff)
	sysElectric.acPowerSwitch:actuate(sysElectric.acPwrGRD)
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

	kc_macro_hydraulic_off()

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

	kc_macro_ext_lights_off()

	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")

	if activePrefSet:get("aircraft:powerup_apu") == false then
		sysElectric.gpuSwitch:actuate(cmdUp)
		if get("laminar/B738/gpu_available") == 1 then
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6")
			command_once("laminar/B738/tab/menu1")
		end
	end

	-- command_once("laminar/B738/toggle_switch/gpu_up")
	command_once("laminar/B738/push_button/flaps_0")
	set("laminar/B738/flt_ctrls/speedbrake_lever",0)
	sysGeneral.parkBrakeSwitch:actuate(modeOn)
	sysEngines.startLever1:actuate(0) 
	sysEngines.startLever2:actuate(0)
	set("laminar/B738/fms/chock_status",1)
	sysEngines.engStarterGroup:actuate(1)
	sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby)
	sysGeneral.autobrake:actuate(1)

	kc_macro_glareshield_initial()
	kc_macro_efis_initial()
	
	sysElectric.batteryCover:actuate(modeOn)
	sysElectric.batterySwitch:actuate(modeOff)
	command_once("sim/electrical/APU_off")
	command_once("sim/electrical/GPU_off")
	sysGeneral.emerExitLightsCover:actuate(1)
	sysGeneral.emerExitLightsSwitch:actuate(0)

	if activeBriefings:get("taxi:gateStand") > 1 then
		if get("laminar/B738/airstairs_hide") == 1  then
			command_once("laminar/B738/airstairs_toggle")
		end
	end
end

-- turn around state
function kc_macro_state_turnaround()
	kc_macro_ext_doors_stand()

	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	sysElectric.batteryCover:actuate(modeOff)
	sysElectric.batterySwitch:actuate(modeOn)

	kc_macro_int_lights_on()

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

	kc_macro_fuelpumps_off()

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
	
	kc_macro_hydraulic_initial()

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

	kc_macro_ext_lights_stand()

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

	kc_macro_glareshield_initial()

	kc_macro_efis_initial()

	kc_wnd_brief_action=1  -- open briefing window
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
-- B738
	sysLights.wheelSwitch:actuate(0)
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
		sysLights.wheelSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights runway entry
function kc_macro_ext_lights_rwyentry()
	sysLights.landLightGroup:actuate(0)
	sysLights.llLeftSwitch:actuate(1)
	sysLights.llRightSwitch:actuate(1)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.rwyLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.rwyLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights takeoff
function kc_macro_ext_lights_takeoff()
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.rwyLightGroup:actuate(0)
		sysLights.landLightGroup:actuate(0)
		sysLights.llLeftSwitch:actuate(1)
		sysLights.llRightSwitch:actuate(1)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.rwyLightGroup:actuate(1)
		sysLights.landLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights above 10000
function kc_macro_ext_lights_above10()
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights below 10000
function kc_macro_ext_lights_below10()
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.landLightGroup:actuate(0)
	sysLights.llLeftSwitch:actuate(1)
	sysLights.llRightSwitch:actuate(1)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights for landing
function kc_macro_ext_lights_land()
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() then		
		sysLights.rwyLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.rwyLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights runway vacated
function kc_macro_ext_lights_rwyvacate()
	sysLights.taxiSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- internal lights all off
function kc_macro_int_lights_off()
	sysLights.domeLightSwitch:actuate(0)
	sysLights.instrLightGroup:actuate(0)
end

-- internal lights at stand
function kc_macro_int_lights_on()
	if kc_is_daylight() then		
		sysLights.domeLightSwitch:actuate(0)
		sysLights.instrLightGroup:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(-1)
		sysLights.instrLightGroup:actuate(0)
	end
end

-- doors all closed
function kc_macro_ext_doors_closed()
	if get("laminar/B738/airstairs_hide") == 0  then
		command_once("laminar/B738/airstairs_toggle")
	end
	-- sysGeneral.doorGroup:actuate(0)
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
end

-- doors at stand 
function kc_macro_ext_doors_stand()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
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
	sysMCP.turnRateSelector:actuate(3)
end

-- initialise IRS

-- efis initial setup
function kc_macro_efis_initial()
	sysEFIS.mtrsPilot:actuate(0)
	sysEFIS.fpvPilot:actuate(0)
	sysEFIS.minsResetPilot:actuate(0)
	sysEFIS.minsResetCopilot:actuate(0)
	sysEFIS.mapZoomPilot:actuate(0)
	sysEFIS.mapModePilot:actuate(0)
	sysEFIS.tfcPilot:actuate(0)
	sysEFIS.wxrPilot:actuate(0)
	local flag = 0
	if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
		sysEFIS.minsTypeCopilot:actuate(flag) 
	if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
		sysEFIS.minsTypePilot:actuate(flag) 
end

-- glareshield takeoff setup
-- glareshield landing setup

-- fuel pumps all off
function kc_macro_fuelpumps_off()
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)		
end

function kc_macro_fuelpumps_stand()
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
	if activePrefSet:get("aircraft:powerup_apu") == true then
		sysFuel.fuelPumpLeftAft:actuate(1)
	end
end

-- fuel pumps on as needed
function kc_macro_fuelpumps_on()
	sysFuel.wingFuelPumpGroup:actuate(1)
	if sysFuel.centerTankLbs:getStatus() > 1000 then
		sysFuel.ctrFuelPumpGroup:actuate(1)
	end
end

-- hyd pumps initial setup
function kc_macro_hydraulic_initial()
	sysHydraulic.elecHydPumpGroup:actuate(0)
	sysHydraulic.engHydPumpGroup:actuate(1)
end

-- hyd pumps all off
function kc_macro_hydraulic_off()
	sysHydraulic.elecHydPumpGroup:actuate(0)
	sysHydraulic.engHydPumpGroup:actuate(0)
end

-- hyd pumps all on
function kc_macro_hydraulic_on()
	sysHydraulic.elecHydPumpGroup:actuate(1)
	sysHydraulic.engHydPumpGroup:actuate(1)
end

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

-- 10000 feet activities up and down

-- fire tests ?!? as bck
-- apu start bck
-- gpu start bck

-- bck callouts when needed

-- function kc_bck_()
-- end

return sysMacros