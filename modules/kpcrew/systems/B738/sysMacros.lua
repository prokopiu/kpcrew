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

	kc_macro_b738_navswitches_init()
	
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
	
	kc_macro_packs_off()
	kc_macro_bleeds_off()

	sysAir.maxCruiseAltitude:setValue(0)
	sysAir.landingAltitude:setValue(0)
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
	command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")		

	kc_macro_ext_lights_off()

	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")

	if activePrefSet:get("aircraft:powerup_apu") == false then
		sysElectric.gpuSwitch:actuate(cmdUp)
		kc_macro_gpu_disconnect()
	end

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
	kc_macro_b738_lowerdu_off()
	
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
		kc_macro_gpu_connect()
		sysElectric.gpuSwitch:actuate(cmdDown)
	end

	kc_macro_b738_navswitches_init()
	
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
	kc_macro_b738_lowerdu_off()
	
	set("laminar/B738/toggle_switch/air_temp_source",3)
	sysAir.contCabTemp:setValue(0.5) 
	sysAir.fwdCabTemp:setValue(0.5) 
	sysAir.aftCabTemp:setValue(0.5)
	set("laminar/B738/air/trim_air_pos",1)
	sysAir.recircFanLeft:actuate(modeOn) 
	sysAir.recircFanRight:actuate(modeOn)

	kc_macro_packs_on()
	kc_macro_bleeds_on()

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

-- glareshield landing setup
-- initialise IRS


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

-- connect and start gpu
function kc_macro_gpu_connect()
	if get("laminar/B738/gpu_available") == 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
	end
end

-- diconnect gpu
function kc_macro_gpu_disconnect()
	if get("laminar/B738/gpu_available") == 1 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
	end
end

-- prepare engine start
-- start 1st engine
-- start nth engine

-- packs all off
function kc_macro_packs_off()
	sysAir.packSwitchGroup:setValue(sysAir.packModeOff)
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvClosed)
end

-- packs for engine start
function kc_macro_packs_start()
	sysAir.packSwitchGroup:setValue(sysAir.packModeOff)
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvOpen)
end

-- packs for takeoff
function kc_macro_packs_takeoff()
	if activeBriefings:get("takeoff:packs") < 3 then 
		sysAir.packSwitchGroup:setValue(sysAir.packModeAuto)
	else
		sysAir.packSwitchGroup:setValue(sysAir.packModeOff)
	end
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvAuto)
end

-- packs all on
function kc_macro_packs_on()
	sysAir.packSwitchGroup:setValue(sysAir.packModeAuto)
	sysAir.isoValveSwitch:setValue(sysAir.isoVlvAuto)
end

-- bleeds all off
function kc_macro_bleeds_off()
	sysAir.bleedEng1Switch:actuate(0) 
	sysAir.bleedEng2Switch:actuate(0) 
	sysAir.apuBleedSwitch:actuate(0)
end

-- bleeds on
function kc_macro_bleeds_on()
	sysAir.bleedEng1Switch:actuate(1) 
	sysAir.bleedEng2Switch:actuate(1)
	if get("sim/cockpit/engine/APU_running") == 1 and 
		get("laminar/B738/engine/eng1_egt") < 50 and 
		get("laminar/B738/engine/eng2_egt") < 50 then
		sysAir.apuBleedSwitch:actuate(1)
	end
end

-- bleeds takeoff 
function kc_macro_bleeds_takeoff()
	if activeBriefings:get("takeoff:bleeds") > 1 then 
		sysAir.bleedEng1Switch:actuate(1) 
		sysAir.bleedEng2Switch:actuate(1) 
	else
		sysAir.bleedEng1Switch:actuate(0) 
		sysAir.bleedEng2Switch:actuate(0) 
	end
	sysAir.apuBleedSwitch:actuate(0)
end

-- xpdr standby
-- xpdr mode c
-- xpdr modus bck

-- flaps up
-- flaps for takeoff
-- flaps level during landing bck ??
-- flaps retract during takeoff bck??

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_ext_lights_above10()
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
end

function kc_macro_below_10000_ft()
	kc_macro_ext_lights_below10()
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
end

function kc_macro_at_trans_alt()
	if get("laminar/B738/EFIS/baro_set_std_pilot") == 0 then 
		command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
	end
	if get("laminar/B738/EFIS/baro_set_std_copilot") == 0 then 
		command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
	end
end

function kc_macro_at_trans_lvl()
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
					get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
		else
			return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
					get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
		end
	end
	if get("laminar/B738/EFIS/baro_set_std_pilot") == 1 then 
		command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
	end
	if get("laminar/B738/EFIS/baro_set_std_copilot") == 1 then 
		command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
	end
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
		else
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")))
		end
	end
end

-- B738 specific macros

-- B738 NAV switches initial
function kc_macro_b738_navswitches_init()
	sysMCP.vhfNavSwitch:actuate(0) 
	sysMCP.irsNavSwitch:setValue(0)
	sysMCP.fmcNavSwitch:setValue(0)
	sysMCP.displaySourceSwitch:setValue(0)
	sysMCP.displayControlSwitch:setValue(0) 
end

-- B738 Lower DU modes
function kc_macro_b738_lowerdu_off()
	set("laminar/B738/systems/lowerDU_page",0)
	set("laminar/B738/systems/lowerDU_page2",0)
end

function kc_macro_b738_lowerdu_sys()
	set("laminar/B738/systems/lowerDU_page",0)
	set("laminar/B738/systems/lowerDU_page2",1)
end

function kc_macro_b738_lowerdu_eng()
	set("laminar/B738/systems/lowerDU_page",1)
	set("laminar/B738/systems/lowerDU_page2",0)
end

-- set the autobrake value depending on the briefing setting
function kc_macro_b738_set_autobrake()
	if activeBriefings:get("approach:autobrake") == 2 then
		command_once("laminar/B738/knob/autobrake_1")
	elseif activeBriefings:get("approach:autobrake") == 3 then
		command_once("laminar/B738/knob/autobrake_2")
	elseif activeBriefings:get("approach:autobrake") == 4 then
		command_once("laminar/B738/knob/autobrake_3")
	elseif activeBriefings:get("approach:autobrake") == 5 then
		command_once("laminar/B738/knob/autobrake_max")
	end
end

-- bck callouts when needed

-- B738 takeoff config test
function kc_bck_b738_toc_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		set_array("sim/cockpit2/engine/actuators/throttle_ratio",0,1) 
		set_array("sim/cockpit2/engine/actuators/throttle_ratio",1,1)
	else
		if kc_procvar_get(delayvar) <= 0 then
			set_array("sim/cockpit2/engine/actuators/throttle_ratio",0,0) 
			set_array("sim/cockpit2/engine/actuators/throttle_ratio",1,0) 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 OVHT fire test
function kc_bck_b738_ovht_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		sysEngines.ovhtFireTestSwitch:repeatOn()
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysEngines.ovhtFireTestSwitch:repeatOff()
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 EXT1 fire test
function kc_bck_b738_ext1_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/toggle_switch/exting_test_lft")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/toggle_switch/exting_test_lft") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 EXT2 fire test
function kc_bck_b738_ext2_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/toggle_switch/exting_test_rgt")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/toggle_switch/exting_test_rgt") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 MACH1 OVSPD TEST
function kc_bck_b738_mach1_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/mach_warn1_test") 
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/mach_warn1_test") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 MACH2 OVSPD TEST
function kc_bck_b738_mach2_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/mach_warn2_test") 
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/mach_warn2_test") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 STALL1 TEST
function kc_bck_b738_stall1_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/stall_test1_press")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/stall_test1_press") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 STALL2 TEST
function kc_bck_b738_stall2_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/stall_test2_press")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/stall_test2_press")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 GPWS TEST
function kc_bck_b738_gpws_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/gpws_test") 
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/gpws_test") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 OXYGEN FO TEST
function kc_bck_b738_oxyfo_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/oxy_test_fo")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/oxy_test_fo")  
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 OXYGEN CPT TEST
function kc_bck_b738_oxycpt_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/oxy_test_cpt")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/oxy_test_cpt")  
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 OXYGEN CPT TEST
function kc_bck_b738_cargofire_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/push_button/cargo_fire_test_push")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/push_button/cargo_fire_test_push")  
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 APU START
function kc_bck_b738_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,1)
		command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
		command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 GEN1 Down
function kc_bck_b738_gen1down(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/toggle_switch/gen1_dn")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/toggle_switch/gen1_dn") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- B738 GEN2 Down
function kc_bck_b738_gen2down(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/toggle_switch/gen2_dn")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/toggle_switch/gen2_dn") 
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- wait for climbing through 10.000 ft then execute items
function kc_bck_climb_through_10k(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 then
		kc_speakNoText(0,"ten thousand")
		kc_macro_above_10000_ft()
		kc_procvar_set(trigger,false)
	end
end

-- wait for descending through 10.000 ft then execute items
function kc_bck_descend_through_10k(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 then
		kc_speakNoText(0,"ten thousand")
		kc_macro_below_10000_ft()
		kc_procvar_set(trigger,false)
	end
end

-- wait for climbing through trans alt then execute items
function kc_bck_transition_altitude(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > activeBriefings:get("departure:transalt") then
		kc_speakNoText(0,"transition altitude")
		kc_macro_at_trans_alt()
		kc_procvar_set(trigger,false)
	end
end

-- wait for descending through trans lvl then execute items
function kc_bck_transition_level(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < activeBriefings:get("arrival:translvl")*100 then
		kc_speakNoText(0,"transition level")
		kc_macro_at_trans_lvl()
		kc_procvar_set(trigger,false)
	end
end

return sysMacros