-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local sysMacros = {
}

logMsg("DFLT sysMacros")

-- ====================================== States related macros
function kc_macro_state_cold_and_dark()
	logMsg("DFLT kc_macro_state_cold_and_dark")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()
	
	if kc_has_irs == true then
		kc_macro_set_irs(0)
	end
	
	sysGeneral.parkBrakeSwitch:actuate(1) 
	
	if kc_has_ground_obj == true then
		kc_macro_set_groundobjects(1)
	end
	
	if kc_has_retractgear == true then
		sysGeneral.GearSwitch:actuate(1)
	end
	if kc_has_speedbrake == true then
		sysControls.Speedbrake:setValue(0)
	end
	
	kc_macro_set_flap(0)
	
	if kc_has_wipers == true then
		sysGeneral.wiperGroup:actuate(0)
	end
	
	sysEngines.throttlePos:actuate(0)

	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)
	
	kc_macro_hydraulic_off()
	
	kc_macro_fuelpumps_off()

	if kc_has_press_cab == true then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.isoValveSwitch:actuate(0)
	end

	sysAice.engAntiIceGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	if kc_has_window_heat == true then
		sysAice.windowHeatGroup:actuate(0)
	end
	
	sysGeneral.seatBeltSwitch:actuate(0)
	sysGeneral.noSmokingSwitch:actuate(0)

	if kc_has_autobrake == true then
		kc_macro_set_autobrake(0)
	end
	
	if kc_is_airbus == false then
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)

		sysEngines.engIgnitionGroup:actuate(0)	
		set_array("sim/cockpit/engine/ignition_on",0,0)
		set_array("sim/cockpit/engine/ignition_on",1,0)
		set_array("sim/cockpit/engine/ignition_on",2,0)
		set_array("sim/cockpit/engine/ignition_on",3,0)
	end 
	
	sysElectric.genSwitchGroup:actuate(0)
	if kc_has_apu == true then
		sysElectric.apuStartSwitch:actuate(0)
	end
	if kc_has_gpu == true then
		sysElectric.gpuConnect:actuate(0)
	end
	
	kc_macro_elec_cold_dark()
end

function kc_macro_state_turnaround()
	logMsg("DFLT kc_macro_state_turnaround")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	sysGeneral.parkBrakeSwitch:actuate(1) 

	if kc_has_retractgear == true then
		sysGeneral.GearSwitch:actuate(1)
	end
	if kc_has_speedbrake == true then
		sysControls.Speedbrake:setValue(0)
	end
	
	kc_macro_set_flap(0)
	
	if kc_has_wipers == true then
		sysGeneral.wiperGroup:actuate(0)
	end
	
	sysEngines.throttlePos:actuate(0)

	if kc_has_autobrake == true then
		kc_macro_set_autobrake(0)
	end
	
	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1)
	
	kc_macro_lights_preflight()
	
	if kc_has_wipers == true then
		sysGeneral.wiperGroup:actuate(0)
	end
	if kc_has_gpu == true then
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
	end
	
	if kc_has_apu == true and activeBriefings:get("departure:activateAPUPowerUp") == 1 then
		kc_procvar_set("apustart",true)
		kc_procvar_set("apuonline",true)
	end 
	
	kc_macro_hydraulic_initial()

	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)

	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
	
	if kc_has_press_cab == true then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.isoValveSwitch:actuate(0)
	end
	
	sysElectric.genSwitchGroup:actuate(1)
	
	if kc_has_avionics_sw == true then
		sysElectric.avionicsSwitchGroup:actuate(1)
	end
	if kc_has_inv_ess_bus == true then
		sysElectric.inverterSwitchGroup:actuate(1)
	end
	if kc_has_bus_ties == true then
		sysElectric.dcBusTie:actuate(1)
	end

	sysGeneral.seatBeltSwitch:actuate(1)
	sysGeneral.noSmokingSwitch:actuate(1)

	if kc_has_window_heat == true then
		sysAice.windowHeatGroup:actuate(1)
	end

	sysAice.probeHeatGroup:actuate(0)

	if kc_has_window_heat == true then 
		if kc_is_airbus == true then	
			sysAice.probeHeatGroup:actuate(0)
		else	
			sysAice.probeHeatGroup:actuate(1)
		end 	
	end

	kc_macro_set_local_baro()

	kc_macro_set_xpdrmode(sysRadios.stby)
	kc_macro_set_xpdrcode(2000)
	
	if kc_is_airbus == false then
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",0,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",1,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",2,0)
		set_array("sim/cockpit2/engine/actuators/auto_ignite_on",3,0)

		set_array("sim/cockpit/engine/ignition_on",0,0)
		set_array("sim/cockpit/engine/ignition_on",1,0)
		set_array("sim/cockpit/engine/ignition_on",2,0)
		set_array("sim/cockpit/engine/ignition_on",3,0)
	end 
	
	kc_macro_doors_preflight()
	kc_macro_mcp_preflight()
	
end

-- ====================================== Lights related functions
function kc_macro_lights_preflight()
	logMsg("DFLT kc_macro_lights_preflight")
	-- set the lights as needed during preflight/turnaround
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.instrLightGroup:actuate(1)
	if kc_is_daylight() then		
		sysLights.domeLightSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
		sysLights.panelLightGroup:actuate(1)
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	kc_macro_lights_preflight()
	sysLights.beaconSwitch:actuate(1)
	if kc_is_daylight() == false then		
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	end
end

function kc_macro_lights_before_taxi()
	kc_macro_lights_preflight()
	sysLights.taxiSwitch:actuate(1)
	sysLights.domeLightSwitch:actuate(0)
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	kc_macro_lights_before_taxi()
	sysLights.taxiSwitch:actuate(0)
	sysLights.landLightGroup:actuate(1)
	sysLights.rwyLightGroup:actuate(1)
	sysLights.strobesSwitch:actuate(1)
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	kc_macro_lights_for_takeoff()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.logoSwitch:actuate(0)
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	kc_macro_lights_climb_10k()
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() == false then		
		sysLights.logoSwitch:actuate(1)
	end
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	kc_macro_lights_descend_10k()
	sysLights.rwyLightGroup:actuate(1)
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() == false then		
		sysLights.logoSwitch:actuate(1)
	end	
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	kc_macro_lights_approach()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	kc_macro_lights_cleanup()
	sysLights.taxiSwitch:actuate(0)	
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	kc_macro_lights_arrive_parking()
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.domeLightSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
	else
		sysLights.domeLightSwitch:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
		sysLights.panelLightGroup:actuate(1)
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
	sysLights.taxiSwitch:actuate(0)
	-- internal
	sysLights.domeLightSwitch:actuate(0)
	sysLights.instrLightGroup:actuate(0)
	sysLights.panelLightGroup:actuate(0)
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
	sysLights.domeLightSwitch:actuate(1)
	sysLights.instrLightGroup:actuate(1)
	sysLights.panelLightGroup:actuate(1)
end

-- ====================================== Door related functions
function kc_macro_doors_preflight()
	sysGeneral.doorL1:actuate(1)
	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairsL1:actuate(1)
	else
		sysGeneral.stairsL1:actuate(0)
	end
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_before_start()
	sysGeneral.doorL1:actuate(0)
	sysGeneral.stairsL1:actuate(0)
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(0)
end

function kc_macro_doors_after_shutdown()
	sysGeneral.doorL1:actuate(1)
	if activeBriefings:get("approach:gateStand") > 1 then
		sysGeneral.stairsL1:actuate(1)
	else
		sysGeneral.stairsL1:actuate(0)
	end
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(1)
	sysGeneral.doorACargo:actuate(1)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_cold_dark()
	sysGeneral.doorL1:actuate(1)
	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairsL1:actuate(1)
	else
		sysGeneral.stairsL1:actuate(0)
	end
	sysGeneral.doorL2:actuate(0)
	sysGeneral.doorR1:actuate(0)
	sysGeneral.doorR2:actuate(0)
	sysGeneral.doorFCargo:actuate(0)
	sysGeneral.doorACargo:actuate(0)
	sysGeneral.cockpitDoor:actuate(1)
end

function kc_macro_doors_all_open()
	sysGeneral.doorGroup:actuate(1)
end

function kc_macro_doors_all_closed()
	sysGeneral.doorGroup:actuate(0)
end

-- ====================================== A/P & Glareshield related functions

function kc_macro_mcp_cold_dark()
	sysMCP.fdirGroup:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.crs1Selector:setValue(1)
	sysMCP.crs2Selector:setValue(1)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:setValue(0)
	sysMCP.discAPSwitch:actuate(0)
	sysMCP.yawDamper:actuate(0)
	sysMCP.ap1Switch:actuate(0)
end

function kc_macro_mcp_preflight()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.yawDamper:actuate(0)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	sysMCP.vspSelector:actuate(0)
	sysMCP.discAPSwitch:actuate(0)
end

function kc_macro_mcp_takeoff()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	if activeBriefings:get("takeoff:apMode") == 1 then
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	else
		sysMCP.hdgselSwitch:actuate(1)
		sysMCP.vsSwitch:actuate(0)
	end
	sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
	sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
	sysMCP.vspSelector:actuate(0)
	sysMCP.discAPSwitch:actuate(0)
end

function kc_macro_mcp_goaround()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.iasSelector:setValue(activeBriefings:get("approach:gav2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading"))
	sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude"))
	if activeBriefings:get("takeoff:apMode") == 1 then
		sysMCP.lnavSwitch:actuate(1)
		sysMCP.vnavSwitch:actuate(1)
	else
		sysMCP.hdgselSwitch:actuate(1)
	end
	sysMCP.speedSwitch:actuate(1)
	sysMCP.yawDamper:actuate(1)
end

function kc_macro_mcp_after_landing()
	sysMCP.fdirGroup:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.hdgselSwitch:actuate(0)
	sysMCP.speedSwitch:actuate(0)
	sysMCP.ap1Switch:actuate(0)
	sysMCP.yawDamper:actuate(0)
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- packs all on
function kc_macro_packs_on()
	sysAir.packSwitchGroup:actuate(1)
end

-- packs all on
function kc_macro_packs_off()
	sysAir.packSwitchGroup:actuate(0)
end

-- packs for takeoff
function kc_macro_packs_takeoff()
	if activeBriefings:get("takeoff:packs") < 2 then 
		sysAir.packSwitchGroup:setValue(1)
	else
		sysAir.packSwitchGroup:setValue(0)
	end
end

-- bleeds on
function kc_macro_bleeds_on()
	sysAir.engBleedGroup:actuate(1) 
end

-- bleeds off
function kc_macro_bleeds_off()
	sysAir.engBleedGroup:actuate(0) 
end

-- bleeds takeoff 
function kc_macro_bleeds_takeoff()
	if activeBriefings:get("takeoff:bleeds") > 1 then 
		sysAir.engBleedGroup:actuate(1) 
	else
		sysAir.engBleedGroup:actuate(0) 
	end
	sysAir.apuBleedSwitch:actuate(0)
end

-- =============

-- hyd pumps initial setup
function kc_macro_hydraulic_initial()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	end 
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(0)
	end
end

-- hyd pumps all off
function kc_macro_hydraulic_off()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(0)
	end
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(0)
	end
end

-- hyd pumps all on
function kc_macro_hydraulic_on()
	if kc_has_hyd_elec_pmps == true then
		sysHydraulic.elecHydPumpGroup:actuate(1)
	end
	if kc_has_hyd_eng_pmps == true then
		sysHydraulic.engHydPumpGroup:actuate(1)
	end
end

function kc_macro_elec_cold_dark()
	sysElectric.genSwitchGroup:actuate(0)
	if kc_has_avionics_sw == true then
		sysElectric.avionicsSwitchGroup:actuate(0)
	end
	if kc_has_inv_ess_bus == true then
		sysElectric.inverterSwitchGroup:actuate(0)
	end
	if kc_has_bus_ties == true then
		sysElectric.dcBusTie:actuate(0)
	end
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 	
end

-- ===========
function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
	sysGeneral.seatBeltSwitch:actuate(1)
end

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_lights_climb_10k()
	sysGeneral.seatBeltSwitch:actuate(0)
end

function kc_macro_at_trans_alt()
	command_once("sim/instruments/barometer_std")
	command_once("sim/instruments/barometer_copilot_std")
end

function kc_macro_at_trans_lvl()
	if math.abs(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")-29.921249) < 0.01 then 
		command_once("sim/instruments/barometer_std")
	end
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
		else
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH"))) 
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
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > tonumber(activeBriefings:get("departure:transalt")) then
		kc_speakNoText(0,"transition altitude")
		kc_macro_at_trans_alt()
		kc_procvar_set(trigger,false)
	end
end

-- wait for descending through trans lvl then execute items
function kc_bck_transition_level(trigger)
	if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < tonumber(activeBriefings:get("arrival:translvl")) then
		kc_speakNoText(0,"transition level")
		kc_macro_at_trans_lvl()
		kc_procvar_set(trigger,false)
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
		sysElectric.apuStartSwitch:setValue(2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStartSwitch:setValue(1)
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

function kc_macro_set_autobrake(index)
	sysControls.Autobrake:setValue(index)	
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
		end
		if trigger == "engstart2" then
			command_begin("sim/starters/engage_start_run_2")
		end
		if trigger == "engstart3" then
			command_begin("sim/starters/engage_start_run_3")
		end
		if trigger == "engstart4" then
			command_begin("sim/starters/engage_start_run_4")
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
			if trigger == "engstart3" then
				command_end("sim/starters/engage_start_run_3")
			end
			if trigger == "engstart4" then
				command_end("sim/starters/engage_start_run_4")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- set flaps based on index
function kc_macro_set_flap(flapindex)

	for i = 1, kc_Numflap_detents do
		command_once("sim/flight_controls/flaps_up")
	end 
	
	for i = 1, flapindex do
		command_once("sim/flight_controls/flaps_down")
	end

end

-- IRS off 0=OFF, 1=ALIGN, 2=NAV
function kc_macro_set_irs(mode)
	if mode == 0 then -- off
		-- do nothing in DFLT
	elseif mode == 1 then -- ALIGN
		-- do nothing in DFLT
	elseif mode == 2 then -- NAV 
		-- do nothing in DFLT
	end
end

-- ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		-- nothing for DFLT
	else
		-- nothing for DFLT
	end
end

-- ======== fuel
function kc_macro_fuelpumps_off()
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
end

function kc_macro_fuelpumps_on()
	sysFuel.allFuelPumpGroup:actuate(1)
	sysFuel.crossFeed:actuate(0)
end

function kc_macro_fuelpumps_stand()
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)
end

function kc_macro_fuelpumps_shutdown()
	kc_macro_fuelpumps_off()
end

function kc_macro_set_xpdrmode(mode)
	sysRadios.xpdrSwitch:setValue(mode)
end

function kc_macro_set_xpdrcode(code)
	sysRadios.xpdrCode:setValue(code)
end

return sysMacros