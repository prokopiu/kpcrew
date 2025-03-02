-- E55P airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("E55P sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()

	logMsg("E55P kc_macro_state_cold_and_dark")
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	kc_macro_mcp_cold_dark()
	
	command_once("aerobask/lights/emer_lt_dn")
	command_once("aerobask/lights/emer_lt_dn")
	
	if get("aerobask/hide_static") == 1 then
		command_once("aerobask/options/toggle_static_elements")
	end
	sysGeneral.parkBrakeSwitch:actuate(1) 

	sysGeneral.GearSwitch:actuate(1)
	command_once("aerobask/speedbrakes_close")
	kc_macro_set_flap(0)
	sysEngines.throttlePos:actuate(0)

	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)
	
	command_once("aerobask/hyd/pump1_up")
	command_once("aerobask/hyd/pump2_up")
	
	sysFuel.allFuelPumpGroup:actuate(0)
	sysFuel.crossFeed:actuate(0)

	sysAir.packSwitchGroup:actuate(0)
	sysAir.engBleedGroup:actuate(0)
	sysAir.isoValveSwitch:actuate(0)
	if get("aerobask/oxygen/sw_cut_out") == 1 then
		command_once("aerobask/oxygen/cut_out")
	end
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_rt")
	
	sysGeneral.seatBeltSwitch:setValue(0)
	sysGeneral.noSmokingSwitch:setValue(0)

	sysEngines.engIgnitionGroup:actuate(0)
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_2_lt")
	command_once("aerobask/engines/knob_2_lt")

	command_once("aerobask/iceprot/wshld1_off")
	command_once("aerobask/iceprot/wshld2_off")
	command_once("aerobask/iceprot/ads_probes_lt")
	command_once("aerobask/iceprot/ads_probes_lt")
	command_once("aerobask/iceprot/ads_probes_rt")
	
	command_once("aerobask/iceprot/eng1_off")
	command_once("aerobask/iceprot/eng2_off")
	command_once("aerobask/iceprot/wingstab_dn")
	command_once("aerobask/iceprot/wingstab_dn")
	command_once("aerobask/iceprot/insp_light_off")

	command_once("aerobask/press/mode_up")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_lt")
	set("aerobask/airco/knob_ckpt_temp",0)
	set("aerobask/airco/knob_cabin_temp",0)
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/mode_dn")
	command_once("aerobask/airco/mode_dn")

	sysElectric.gpuConnect:actuate(0)
	command_once("sim/electrical/battery_1_off")
	command_once("sim/electrical/battery_2_off")
	command_once("aerobask/electrical/gen1_off")
	command_once("aerobask/electrical/gen2_off")
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_rt")
	sysElectric.gpuGenBusGroup:actuate(0)
	
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_lt")
	command_once("aerobask/test/test_lt")	
	
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_2_lt")
	command_once("aerobask/engines/knob_2_lt")	
		
	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_2_dn")
	command_once("aerobask/engines/ignition_2_dn")	
	
end

function kc_macro_state_turnaround()
	logMsg("E55P kc_macro_state_turnaround")

	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	-- if get("aerobask/hide_static") == 1 then
		-- command_once("aerobask/options/toggle_static_elements")
	-- end
	kc_macro_doors_preflight()
	sysElectric.gpuConnect:actuate(1)
	sysElectric.gpuGenBusGroup:actuate(1)
	if get("aerobask/oxygen/sw_cut_out") == 0 then
		command_once("aerobask/oxygen/cut_out")
	end	
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_rt")	

	command_once("sim/electrical/battery_1_off")
	command_once("sim/electrical/battery_2_off")
	command_once("aerobask/electrical/gen1_auto")
	command_once("aerobask/electrical/gen2_auto")
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_rt")
		
	command_once("aerobask/bleed/bleed1_auto")
	command_once("aerobask/bleed/bleed2_auto")	
	command_once("aerobask/bleed/xbleed_auto")

	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_lt")
	command_once("aerobask/test/test_lt")	
	
	command_once("aerobask/fuel/pump1_dn")
	command_once("aerobask/fuel/pump1_dn")
	command_once("aerobask/fuel/pump1_up")
	command_once("aerobask/fuel/pump2_dn")
	command_once("aerobask/fuel/pump2_dn")
	command_once("aerobask/fuel/pump2_up")
	command_once("aerobask/fuel/xfeed_lt")
	command_once("aerobask/fuel/xfeed_lt")
	command_once("aerobask/fuel/xfeed_rt")	
	
	command_once("aerobask/hyd/pump1_up")
	command_once("aerobask/hyd/pump2_up")
	
	command_once("aerobask/iceprot/wshld1_off")
	command_once("aerobask/iceprot/wshld2_off")
	command_once("aerobask/iceprot/ads_probes_lt")
	command_once("aerobask/iceprot/ads_probes_lt")
	command_once("aerobask/iceprot/ads_probes_rt")
	
	command_once("aerobask/iceprot/eng1_off")
	command_once("aerobask/iceprot/eng2_off")
	command_once("aerobask/iceprot/wingstab_dn")
	command_once("aerobask/iceprot/wingstab_dn")
	command_once("aerobask/iceprot/insp_light_off")

	command_once("aerobask/press/mode_up")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_lt")
	set("aerobask/airco/knob_ckpt_temp",0)
	set("aerobask/airco/knob_cabin_temp",0)
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/mode_dn")
	command_once("aerobask/airco/mode_dn")
	
	command_once("aerobask/engines/bottle_off")

	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_2_lt")
	command_once("aerobask/engines/knob_2_lt")	

	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_2_dn")
	command_once("aerobask/engines/ignition_2_dn")
		
	sysControls.flapsSwitch:setValue(0)
	sysGeneral.parkBrakeSwitch:actuate(1) 

	sysElectric.batterySwitch:actuate(1) 
	if kc_get_nr_batteries() > 1 then
		sysElectric.battery2Switch:actuate(1) 
	end	
	sysRadios.xpdrCode:actuate(2000) 
	set("sim/cockpit2/radios/actuators/transponder_mode",1)	

	command_once("aerobask/lights/emer_lt_dn")
	command_once("aerobask/lights/emer_lt_dn")	
	
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
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_up")
			command_once("aerobask/engines/knob_1_rt")
			command_begin("aerobask/engines/knob_1_rt")
		end
		if trigger == "engstart2" then
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_up")
			command_once("aerobask/engines/knob_2_rt")
			command_begin("aerobask/engines/knob_2_rt")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("aerobask/engines/knob_1_rt")
			end
			if trigger == "engstart2" then
				command_end("aerobask/engines/knob_2_rt")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_macro_set_flap(flapindex)

	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")

	if flapindex == 1 then
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 2 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 3 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 4 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

end

-- ====================================== Lights related functions
function kc_macro_lights_preflight()
	logMsg("E55P kc_macro_lights_preflight")
	
	-- set the lights as needed during preflight/turnaround
	command_once("aerobask/lights/ldg_taxi_dn")
	command_once("aerobask/lights/ldg_taxi_dn")
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.instrLightGroup:actuate(1)
	if kc_is_daylight() then		
		sysLights.domeLightGroup:setValue(0)
		sysLights.panelLightGroup:setValue(0)
	else
		sysLights.domeLightGroup:setValue(.3)
		sysLights.panelLightGroup:setValue(.5)
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	kc_macro_lights_preflight()
end

function kc_macro_lights_before_taxi()
	kc_macro_lights_before_start()
	command_once("aerobask/lights/ldg_taxi_up")
	sysLights.domeLightGroup:setValue(0)
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	kc_macro_lights_before_taxi()
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_up")
	sysLights.strobesSwitch:actuate(1)
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	kc_macro_lights_for_takeoff()
	command_once("aerobask/lights/ldg_taxi_dn")
	command_once("aerobask/lights/ldg_taxi_dn")
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	kc_macro_lights_climb_10k()
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_up")
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	kc_macro_lights_descend_10k()
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_up")
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	kc_macro_lights_approach()
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_dn")
	sysLights.strobesSwitch:actuate(0)
end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	kc_macro_lights_cleanup()
	command_once("aerobask/lights/ldg_taxi_dn")
	command_once("aerobask/lights/ldg_taxi_dn")
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	kc_macro_lights_arrive_parking()
	sysLights.positionSwitch:actuate(0)
	if kc_is_daylight() then		
		sysLights.domeLightGroup:setValue(0)
		sysLights.panelLightGroup:setValue(0)
	else
		sysLights.domeLightGroup:setValue(.3)
		sysLights.panelLightGroup:setValue(.5)
	end
end

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	-- external
	command_once("aerobask/lights/ldg_taxi_dn")
	command_once("aerobask/lights/ldg_taxi_dn")
	sysLights.positionSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	sysLights.domeLightGroup:setValue(0)
	sysLights.instrLightGroup:actuate(0)
	sysLights.panelLightGroup:setValue(0)
end

function kc_macro_lights_all_on()
	-- set the lights all on for test and checks
	-- external
	command_once("aerobask/lights/ldg_taxi_up")
	command_once("aerobask/lights/ldg_taxi_up")
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	sysLights.domeLightGroup:setValue(.3)
	sysLights.instrLightGroup:actuate(1)
	sysLights.panelLightGroup:actuate(.5)
end

-- ====================================== A/P & Glareshield related functions

function kc_macro_mcp_cold_dark()
	set("sim/cockpit2/autopilot/flight_director_mode",0)
	set("sim/cockpit/radios/nav2_obs_degm",1)
	set("sim/cockpit/radios/nav1_obs_degm",1)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("sim/cockpit2/switches/yaw_damper_on",0)
	command_once("sim/autopilot/servos_off_any")
end

function kc_macro_mcp_preflight()
	set("sim/cockpit2/autopilot/flight_director_mode",1)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("sim/cockpit2/switches/yaw_damper_on",0)
	command_once("sim/autopilot/servos_off_any")
end

function kc_macro_mcp_takeoff()
	set("sim/cockpit2/autopilot/flight_director_mode",1)
	sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("sim/cockpit2/switches/yaw_damper_on",0)
	command_once("sim/autopilot/servos_off_any")
	sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
	sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
end

function kc_macro_mcp_goaround()
	set("sim/cockpit2/autopilot/flight_director_mode",1)
	sysMCP.iasSelector:setValue(activeBriefings:get("approach:gav2"))
	sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading"))
	sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude"))
	command_once("sim/autopilot/heading")
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("sim/cockpit2/switches/yaw_damper_on",0)
	command_once("sim/autopilot/servos_off_any")
	sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
	sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
end

function kc_macro_mcp_after_landing()
	set("sim/cockpit2/autopilot/flight_director_mode",0)
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("sim/cockpit2/switches/yaw_damper_on",0)
	set("sim/cockpit2/autopilot/heading_mode",0)
	command_once("sim/autopilot/servos_off_any")
end


return sysMacros