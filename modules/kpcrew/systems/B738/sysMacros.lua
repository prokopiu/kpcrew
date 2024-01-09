-- B738 airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
	spd_mode = 0,
	alt_mode = 0,
	hdg_mode = 0,
	hdg_arm = 0,
	alt_arm = 0
}

-- preflight events app 30 minutes
function kc_bck_preflight_events()
-- 	if SGES installed then
 	command_once("Simple_Ground_Equipment_and_Services/Window/Show")
	command_once("sges/sequence/start")
-- 	end

-- +25 minutes
-- Connect jetways (default scenery) or stair out, Door 1L open, cargo doors open, set chocks
-- if counter == 25 and done counter ~= 25 then
	if get("laminar/B738/fms/chock_status") ~= 1 then
		command_once("laminar/B738/toggle_switch/chock")
	end

-- end
-- +24 run Electrical power up if not yet done

-- +23 FO starte pre-peflight

-- +21 Minuten FO starts walkaround, at night turn on wheel well lights

-- +18 Minutes Boarding ask start 

-- +14 minuten FO from walk around starts preflight

-- +10 preflight checklist

-- +8 departure briefing

-- +7 Load sheet

-- +6 Start APU?

-- +5 CPT arm authothrottle, set v2 in MCP, arm lnav/vnav

-- +3 cargo doors closed

-- +2 permission to powr hyd

-- +1 boading complete Before start procedure

-- + 0 , wheel chocks remove all carts removed when APU running
end

-- ====================================== States related macros

function kc_macro_state_cold_and_dark()
	-- set aircraft to cold & dark
	kc_macro_doors_cold_dark()

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

	kc_macro_lights_cold_dark()

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

function kc_macro_state_turnaround()
	-- set aircraft into turnaround mode

	kc_macro_doors_preflight()

	set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
	sysElectric.batteryCover:actuate(modeOff)
	sysElectric.batterySwitch:actuate(modeOn)

	kc_macro_lights_preflight()

	sysGeneral.fdrSwitch:actuate(modeOff) 
	sysGeneral.fdrCover:actuate(modeOn)
	sysGeneral.vcrSwitch:actuate(modeOn)
	sysEngines.eecSwitchGroup:actuate(modeOn)
	sysEngines.eecGuardGroup:actuate(modeOff)
	sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitNAV)

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

end

-- start SGES start sequence
function kc_macro_start_sges_sequence()
		-- show_windoz()
		show_Automatic_sequence_start = true
		SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
end

-- ====================================== Lights related functions

function kc_macro_lights_preflight()
	-- set the lights as needed during preflight/turnaround
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_before_taxi()
	-- set the lights as needed when ready to taxi
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0.3)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
		if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
	end
end

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	-- internal
	if sysLights.domeLightSwitch:getStatus() > 0 then sysLights.domeLightSwitch:actuate(0) end
	if sysLights.domeLightSwitch:getStatus() < 0 then sysLights.domeLightSwitch:actuate(1) end
	sysLights.instrLightGroup:actuate(0)
end

function kc_macro_lights_all_on()
	-- set the lights all on for test and checks
	-- external
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.logoSwitch:actuate(1)
	sysLights.wingSwitch:actuate(1)
	sysLights.wheelSwitch:actuate(1)
	-- internal
	sysLights.domeLightGroup:actuate(1)
	sysLights.instrLightGroup:actuate(1)
end

-- ====================================== Door related functions
function kc_macro_doors_preflight()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairs:actuate(0)
	else
		sysGeneral.stairs:actuate(1)
	end
end

function kc_macro_doors_before_start()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(0)
	sysGeneral.stairs:actuate(1)
end

function kc_macro_doors_after_shutdown()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
	if activeBriefings:get("approach:gateStand") > 1 then
		sysGeneral.stairs:actuate(0)
	else
		sysGeneral.stairs:actuate(1)
	end
end

function kc_macro_doors_cold_dark()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(1)
	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairs:actuate(0)
	else
		sysGeneral.stairs:actuate(1)
	end
end

function kc_macro_doors_all_open()
	sysGeneral.doorL1:actuate(1)
	sysGeneral.doorL2:actuate(1)
	sysGeneral.doorR1:actuate(1)
	sysGeneral.doorR2:actuate(1)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
	sysGeneral.stairs:actuate(0)
end

function kc_macro_doors_all_closed()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(0)
	sysGeneral.stairs:actuate(1)
end

-- =====================================================

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

-- glareshield go around setup
function kc_macro_glareshield_goaround()
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

-- baro mode as in preference
function kc_macro_set_pref_baro_mode()
	if activePrefSet:get("general:baro_mode_hpa") then 
		sysGeneral.baroModeGroup:actuate(1) 
	else 
		sysGeneral.baroModeGroup:actuate(0) 
	end
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 
end

-- set baros to briefng
function kc_macro_set_briefed_baro()
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

-- test if all baros are set to local baro
function kc_macro_test_briefed_baro()
	if activePrefSet:get("general:baro_mode_hpa") then
		return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
				get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
	else
		return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
				get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
	end
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
		sysFuel.fuelPumpLeftFwd:actuate(1)
	end
end

function kc_macro_fuelpumps_shutdown()
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
	if activeBriefings:get("approach:powerAtGate") == 2 then
		sysFuel.fuelPumpLeftFwd:actuate(1)
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
	kc_macro_lights_climb_10k()
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
end

function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
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
	if get("laminar/B738/systems/lowerDU_page2") > 0 then
		command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
	end
end

function kc_macro_b738_lowerdu_sys()
	if get("laminar/B738/systems/lowerDU_page2") == 0 then
		command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
	end
end

function kc_macro_b738_lowerdu_eng()
	if get("laminar/B738/systems/lowerDU_page") == 0 then
		command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
	end
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

-- B738 TCAS TEST
function kc_bck_b738_tcas_test(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,0)
		command_begin("laminar/B738/knob/transponder_mode_dn")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/knob/transponder_mode_dn")  
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
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < 10000 then
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
		kc_macro_at_trans_lvl()
		kc_procvar_set(trigger,false)
		kc_speakNoText(0,"transition level                  ready for approach checklist")
	end
end

-- after takeoff FO steps
function kc_bck_after_takeoff_items(trigger)
	if sysControls.flapsSwitch:getStatus() == 0 then
		command_once("laminar/B738/knob/autobrake_off")
		command_once("laminar/B738/push_button/gear_off")
		sysEngines.engStarterGroup:actuate(1)
		kc_procvar_set(trigger,false)
		kc_speakNoText(0,"ready for after takeoff checklist")
	end
end

-- fma callouts from captain's PFD
function kc_bck_fma_callouts(trigger)
	local hdgmode = get("laminar/B738/autopilot/pfd_hdg_mode")
	if sysMacros.hdg_mode ~= hdgmode then
		if 		hdgmode == 1 then kc_speakNoText(0,"Heading select") 
		elseif 	hdgmode == 2 then kc_speakNoText(0,"V O R lock captured") 
		elseif 	hdgmode == 3 then kc_speakNoText(0,"L naff active") 
		elseif 	hdgmode == 4 then kc_speakNoText(0,"rollout") 
		elseif 	hdgmode == 5 then kc_speakNoText(0,"F A C") 
		elseif 	hdgmode == 6 then kc_speakNoText(0,"back course active") 
		end
		sysMacros.hdg_mode = hdgmode
		return
	end

	local hdgarm = get("laminar/B738/autopilot/pfd_hdg_mode_arm")
	if sysMacros.hdg_arm ~= hdgarm then
		if 		hdgarm == 1 then kc_speakNoText(0,"V O R lock armed") 
		elseif 	hdgarm == 2 then kc_speakNoText(0,"rollout armed") 
		elseif 	hdgarm == 3 then kc_speakNoText(0,"L naff armed") 
		elseif 	hdgarm == 4 then kc_speakNoText(0,"f a c  armed") 
		elseif 	hdgarm == 5 then kc_speakNoText(0,"L naff v o r armed") 
		elseif 	hdgarm == 6 then kc_speakNoText(0,"L naff r o l armed") 
		elseif 	hdgarm == 7 then kc_speakNoText(0,"L naff f a c armed") 
		end
		sysMacros.hdg_arm = hdgarm
		return
	end

	local altmode = get("laminar/B738/autopilot/pfd_alt_mode")
	if sysMacros.alt_mode ~= altmode then
		if 		altmode == 1 then kc_speakNoText(0,"vertical speed active") 
		elseif 	altmode == 2 then kc_speakNoText(0,"m c p speed") 
		elseif 	altmode == 3 then kc_speakNoText(0,"altitude acquired") 
		elseif 	altmode == 4 then kc_speakNoText(0,"altitude hold") 
		elseif 	altmode == 5 then kc_speakNoText(0,"glide slope captured") 
		elseif 	altmode == 6 then kc_speakNoText(0,"flare active") 
		elseif 	altmode == 7 then kc_speakNoText(0,"glide path captured") 
		elseif 	altmode == 8 then kc_speakNoText(0,"v naff speed") 
		elseif 	altmode == 9 then kc_speakNoText(0,"v naff path") 
		elseif 	altmode == 10 then kc_speakNoText(0,"v naff alt") 
		elseif 	altmode == 11 then kc_speakNoText(0,"tow gah") 
		end
		sysMacros.alt_mode = altmode
		return
	end
	
	local altarm = get("laminar/B738/autopilot/pfd_alt_mode_arm")
	if sysMacros.alt_arm ~= altarm then
		if 		altarm == 1 then kc_speakNoText(0,"glide slope armed") 
		elseif 	altarm == 2 then kc_speakNoText(0,"vertical speed armed") 
		elseif 	altarm == 6 then kc_speakNoText(0,"glide slope vertical speed armed") 
		elseif 	altarm == 3 then kc_speakNoText(0,"flare armed") 
		elseif 	altarm == 4 then kc_speakNoText(0,"glide path armed") 
		elseif 	altarm == 5 then kc_speakNoText(0,"v naff armed") 
		end
		sysMacros.alt_arm = altarm
		return
	end

	local spdmode = get("laminar/B738/autopilot/pfd_spd_mode")
	if sysMacros.spd_mode ~= spdmode then
		if 		spdmode == 1 then kc_speakNoText(0,"auto throttle arm") 
		elseif 	spdmode == 2 then kc_speakNoText(0,"n 1") 
		elseif 	spdmode == 3 then kc_speakNoText(0,"m c p speed") 
		elseif 	spdmode == 4 then kc_speakNoText(0,"f m c speed") 
		elseif 	spdmode == 5 then kc_speakNoText(0,"go around") 
		elseif 	spdmode == 6 then kc_speakNoText(0,"throttle hold") 
		elseif 	spdmode == 7 then kc_speakNoText(0,"retard") 
		end
		sysMacros.spd_mode = spdmode
		return
	end

end

return sysMacros