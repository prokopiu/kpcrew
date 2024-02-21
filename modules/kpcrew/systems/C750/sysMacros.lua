-- C750 airplane macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysMacros = {
}

-- ====================================== States related macros
function kc_macro_state_cold_and_dark()
	kc_macro_lights_cold_dark()
	kc_macro_bleeds_off()
	kc_macro_packs_off()

	set_array("sim/cockpit2/engine/actuators/mixture_ratio",0,0)
	set_array("sim/cockpit2/engine/actuators/mixture_ratio",1,0)
	set("sim/cockpit2/radios/actuators/transponder_mode",3)	
	sysGeneral.parkBrakeSwitch:actuate(1)
	sysElectric.gen1Switch:actuate(0)
	sysElectric.gen2Switch:actuate(0)
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_up") 
	sysAice.windowHeatGroup:actuate(0)
	sysAir.engBleedGroup:actuate(0)
	command_once("laminar/CitX/lights/emerg_light_switch_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_left_up")
	command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_right_up")
	sysAice.probeHeatGroup:actuate(0)
	sysAice.engAntiIceGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	sysHydraulic.engHydPumpGroup:actuate(0)
	sysHydraulic.elecHydPumpGroup:actuate(0)
	sysElectric.avionicsSwitchGroup:actuate(0)
	if get("laminar/CitX/electrical/avionics_eicas") == 1 then
		command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
	end
	command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
	command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
	sysFuel.crossFeed:actuate(0)
	if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
		command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
	end
	if get("laminar/CitX/engine/gnd_idle") ~= 0 then
		command_once("laminar/CitX/engine/gnd_idle")
	end
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	if get("laminar/CitX/engine/ignition_switch_left") > 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
	elseif get("laminar/CitX/engine/ignition_switch_left") < 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
	end
	if get("laminar/CitX/engine/ignition_switch_right") > 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	elseif get("laminar/CitX/engine/ignition_switch_right") < 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
	end
	if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
	end
	if get("laminar/CitX/pressurization/manual") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_manual_toggle")
	end
	if get("laminar/CitX/pressurization/cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_cabin_dump_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_cabin_dump_toggle")
	end
	if get("laminar/CitX/ice/wing_crossover") ~= 0 then
		command_once("laminar/CitX/ice/cmd_wing_crossover_toggle")
	end
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	if get("laminar/CitX/engine/eng_sync") < 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_up")
	end
	if get("laminar/CitX/engine/eng_sync") > 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_dwn")
	end
	if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
	end
	sysGeneral.antiSkid:actuate(1)
	if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
	end
	if get("laminar/CitX/pressurization/manual") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_manual_toggle")
	end
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/APU/gen_switch_dwn") 
	command_once("laminar/CitX/APU/gen_switch_dwn") 
	sysAir.apuBleedSwitch:actuate(0)
	command_begin("laminar/CitX/APU/starter_switch_dwn") 
	sysElectric.apuMasterSwitch:actuate(0)
	command_end("laminar/CitX/APU/starter_switch_dwn")
	sysLights.dispLightGroup:actuate(0)
	sysElectric.gpuSwitch:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	sysElectric.batterySwitch:actuate(0)
	sysElectric.battery2Switch:actuate(0) 
	while get("laminar/CitX/controls/split_pull") ~= 0 do
		command_once("laminar/CitX/controls/cmd_controls_split")
	end
	command_once("sim/flight_controls/door_open_1")
end

-- ========================================================
function kc_macro_state_turnaround()
	sysGeneral.parkBrakeSwitch:actuate(1)
	set_array("sim/cockpit2/engine/actuators/mixture_ratio",0,0)
	set_array("sim/cockpit2/engine/actuators/mixture_ratio",1,0)
	command_once("laminar/CitX/lights/emerg_light_switch_up")
	if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
		command_once("laminar/CitX/lights/dimming_switch_toggle")
	end
	sysElectric.gen1Switch:actuate(0)
	sysElectric.gen2Switch:actuate(0)
	command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	if get("laminar/CitX/engine/ignition_switch_left") > 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
	elseif get("laminar/CitX/engine/ignition_switch_left") < 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
	end
	if get("laminar/CitX/engine/ignition_switch_right") > 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	elseif get("laminar/CitX/engine/ignition_switch_right") < 0 then 
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
	end
	command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	sysElectric.gpuSwitch:actuate(1)
	sysElectric.batterySwitch:actuate(1) 
	sysElectric.battery2Switch:actuate(1) 
	sysGeneral.GearSwitch:actuate(1)
	sysControls.flapsSwitch:setValue(0)
	sysHydraulic.elecHydPumpGroup:actuate(0)
	if get("laminar/CitX/lights/cabin_lights_on") == 0 then 
		command_once("laminar/CitX/lights/cmd_cabin_master_toggle") 
	end
	sysElectric.apuMasterSwitch:actuate(1)
	sysElectric.avionicsSwitchGroup:actuate(1)
	if get("laminar/CitX/electrical/avionics_eicas") == 0 then
		command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
	end
	kc_macro_lights_preflight()
	sysLights.dispLightGroup:actuate(1)
	sysLights.positionSwitch:actuate(1)
	if get("laminar/CitX/oxygen/pass_oxy") == 0 then 
		command_once("laminar/CitX/oxygen/cmd_pass_oxy_up")
	elseif get("laminar/CitX/oxygen/pass_oxy") == 2 then 
		command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
	end
	sysFuel.crossFeed:actuate(0)
	if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
		command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
	end
	command_end("laminar/CitX/ahrs/cmd_mode_copilot_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_up")
	command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
	command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
	command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	command_once("laminar/CitX/APU/starter_switch_up")
	command_once("laminar/CitX/APU/gen_switch_up") 
	command_once("laminar/CitX/APU/gen_switch_up") 
	if get("laminar/CitX/throttle/stow_emer_R") ~= 0 then
		command_once("laminar/CitX/throttle/stow_emer_R_toggle")
	end
	if get("laminar/CitX/throttle/stow_emer_L") ~= 0 then
		command_once("laminar/CitX/throttle/stow_emer_L_toggle")
	end
	if get("laminar/CitX/ice/wing_crossover") ~= 0 then
		command_once("laminar/CitX/ice/cmd_wing_crossover_toggle")
	end
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	if get("laminar/CitX/pressurization/cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_cabin_dump_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_cabin_dump_toggle")
	end
	if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
	end
	if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
	end
	if get("laminar/CitX/pressurization/manual") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_manual_toggle")
	end
	sysAice.windowHeatGroup:actuate(1)
	if get("laminar/CitX/engine/gnd_idle") ~= 0 then
		command_once("laminar/CitX/engine/gnd_idle")
	end
	if get("laminar/CitX/engine/eng_sync") < 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_up")
	end
	if get("laminar/CitX/engine/eng_sync") > 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_dwn")
	end
	while get("laminar/CitX/controls/split_pull") ~= 0 do
		command_once("laminar/CitX/controls/cmd_controls_split")
	end
	command_end("laminar/CitX/ahrs/cmd_mode_pilot_dwn")
	command_once("sim/flight_controls/door_open_1")
	kc_wnd_brief_action=1  -- open briefing window
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(1)
		sysLights.wheelSwitch:actuate(1)
		sysLights.domeLightSwitch:actuate(1)
		set("laminar/CitX/lights/flood_knob",1)
		set("laminar/CitX/lights/elec_knob",1)
		set("laminar/CitX/lights/left_knob",1)
		set("laminar/CitX/lights/ctr_knob",1)
		set("laminar/CitX/lights/right_knob",1)
		set("laminar/CitX/lights/map_left_knob",1)
		set("laminar/CitX/lights/map_right_knob",1)
		set("laminar/CitX/lights/aux_knob",1)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(1)
		sysLights.logoSwitch:actuate(1)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",1)
		set("laminar/CitX/lights/elec_knob",1)
		set("laminar/CitX/lights/left_knob",1)
		set("laminar/CitX/lights/ctr_knob",1)
		set("laminar/CitX/lights/right_knob",1)
		set("laminar/CitX/lights/map_left_knob",1)
		set("laminar/CitX/lights/map_right_knob",1)
		set("laminar/CitX/lights/aux_knob",1)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
	else
		sysLights.domeLightGroup:actuate(0)
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
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
		set("laminar/CitX/lights/flood_knob",0)
		set("laminar/CitX/lights/elec_knob",0.5)
		set("laminar/CitX/lights/left_knob",0)
		set("laminar/CitX/lights/ctr_knob",0)
		set("laminar/CitX/lights/right_knob",0)	
		set("laminar/CitX/lights/map_left_knob",0)
		set("laminar/CitX/lights/map_right_knob",0)
		set("laminar/CitX/lights/aux_knob",0.5)
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
	sysLights.domeLightGroup:actuate(0)
	sysLights.instrLightGroup:actuate(0)
	set("laminar/CitX/lights/flood_knob",0)
	set("laminar/CitX/lights/elec_knob",0)
	set("laminar/CitX/lights/left_knob",0)
	set("laminar/CitX/lights/ctr_knob",0)
	set("laminar/CitX/lights/right_knob",0)
	set("laminar/CitX/lights/map_left_knob",0)
	set("laminar/CitX/lights/map_right_knob",0)
	set("laminar/CitX/lights/aux_knob",0)
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

-- =====================================================

-- bleeds all off
function kc_macro_bleeds_off()
	sysAir.engBleedGroup:actuate(0) 
	sysAir.apuBleedSwitch:actuate(0)
end

-- bleeds on
function kc_macro_bleeds_on()
	sysAir.engBleedGroup:actuate(1) 
	if get("sim/cockpit/engine/APU_N1") == 100 and 
		get("sim/cockpit2/engine/indicators/N2_percent",0) < 8 and 
		get("sim/cockpit2/engine/indicators/N2_percent",1) < 8 then
		sysAir.apuBleedSwitch:actuate(1)
	end
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

-- packs all off
function kc_macro_packs_off()
	sysAir.packSwitchGroup:actuate(0)
end

-- packs for engine start
function kc_macro_packs_start()
	sysAir.packSwitchGroup:setValue(1)
end

-- packs for takeoff
function kc_macro_packs_takeoff()
	if activeBriefings:get("takeoff:packs") < 2 then 
		sysAir.packSwitchGroup:setValue(1)
	else
		sysAir.packSwitchGroup:setValue(0)
	end
end

-- packs for landing
function kc_macro_packs_landing()
	if activeBriefings:get("approach:packs") < 2 then 
		sysAir.packSwitchGroup:setValue(1)
	else
		sysAir.packSwitchGroup:setValue(0)
	end
end

-- packs all on
function kc_macro_packs_on()
	sysAir.packSwitchGroup:actuate(1)
end

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_lights_climb_10k()
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_up") 
end

function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
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

-- baro mode as in preference
function kc_macro_set_pref_baro_mode()
	if activePrefSet:get("general:baro_mode_hpa") then 
		set("sim/physics/metric_press",1)
	else 
		set("sim/physics/metric_press",0)
	end
end

-- set baros to local pressure at departure airport
function kc_macro_set_local_baro()
	set("sim/cockpit/misc/barometer_setting",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit/misc/barometer_setting2",math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return get("sim/cockpit/misc/barometer_setting") == math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("sim/cockpit/misc/barometer_setting2") == math.floor(get("sim/weather/barometer_sealevel_inhg")*100)/100 
end

-- internal lights all off
-- function kc_macro_int_lights_off()
	-- sysLights.domeLightGroup:setValue(0)
	-- sysLights.instrLightGroup:setValue(0)
	-- if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
		-- command_once("laminar/CitX/lights/dimming_switch_toggle")
	-- end
	-- sysLights.domeLightSwitch:actuate(0)
	-- set("laminar/CitX/lights/flood_knob",0)
	-- set("laminar/CitX/lights/elec_knob",0)
	-- set("laminar/CitX/lights/left_knob",0)
	-- set("laminar/CitX/lights/ctr_knob",0)
	-- set("laminar/CitX/lights/right_knob",0)
	-- set("laminar/CitX/lights/map_left_knob",0)
	-- set("laminar/CitX/lights/map_right_knob",0)
	-- set("laminar/CitX/lights/aux_knob",0)
	-- sysLights.dispLightGroup:setValue(0)
	-- sysLights.cabinLight:actuate(0)
-- end

-- internal lights at stand
-- function kc_macro_int_lights_on()
	-- if kc_is_daylight() then		
		-- sysLights.domeLightGroup:setValue(0)
		-- sysLights.instrLightGroup:setValue(0)
		-- if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
			-- command_once("laminar/CitX/lights/dimming_switch_toggle")
		-- end
		-- sysLights.domeLightSwitch:actuate(0)
		-- set("laminar/CitX/lights/flood_knob",0)
		-- set("laminar/CitX/lights/elec_knob",0.5)
		-- set("laminar/CitX/lights/left_knob",0)
		-- set("laminar/CitX/lights/ctr_knob",0)
		-- set("laminar/CitX/lights/right_knob",0)	
		-- set("laminar/CitX/lights/map_left_knob",0)
		-- set("laminar/CitX/lights/map_right_knob",0)
		-- set("laminar/CitX/lights/aux_knob",0.5)
		-- sysLights.cabinLight:actuate(0)
	-- else
		-- sysLights.domeLightGroup:setValue(1)
		-- sysLights.instrLightGroup:setValue(0.75)
		-- if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
			-- command_once("laminar/CitX/lights/dimming_switch_toggle")
		-- end
		-- sysLights.domeLightSwitch:actuate(1)
		-- set("laminar/CitX/lights/flood_knob",1)
		-- set("laminar/CitX/lights/elec_knob",1)
		-- set("laminar/CitX/lights/left_knob",1)
		-- set("laminar/CitX/lights/ctr_knob",1)
		-- set("laminar/CitX/lights/right_knob",1)
		-- set("laminar/CitX/lights/map_left_knob",1)
		-- set("laminar/CitX/lights/map_right_knob",1)
		-- set("laminar/CitX/lights/aux_knob",1)
		-- sysLights.cabinLight:actuate(1)
	-- end
-- end

-- internal lights at stand
-- function kc_macro_int_lights_taxi()
	-- if kc_is_daylight() then		
		-- sysLights.domeLightGroup:setValue(0)
		-- sysLights.instrLightGroup:setValue(0)
		-- if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
			-- command_once("laminar/CitX/lights/dimming_switch_toggle")
		-- end
		-- sysLights.domeLightSwitch:actuate(0)
		-- set("laminar/CitX/lights/flood_knob",0)
		-- set("laminar/CitX/lights/elec_knob",0)
		-- set("laminar/CitX/lights/left_knob",0)
		-- set("laminar/CitX/lights/ctr_knob",0)
		-- set("laminar/CitX/lights/right_knob",0)	
		-- sysLights.cabinLight:actuate(0)
	-- else
		-- sysLights.domeLightSwitch:actuate(0)
		-- set("laminar/CitX/lights/flood_knob",0.5)
		-- set("laminar/CitX/lights/elec_knob",0.5)
		-- set("laminar/CitX/lights/left_knob",0.5)
		-- set("laminar/CitX/lights/ctr_knob",0.5)
		-- set("laminar/CitX/lights/right_knob",0.5)
		-- sysLights.domeLightGroup:setValue(0.1)
		-- sysLights.instrLightGroup:setValue(0.5)
		-- if get("laminar/CitX/lights/dim_lights_switch") == 0 then
			-- command_once("laminar/CitX/lights/dimming_switch_toggle")
		-- end
		-- sysLights.cabinLight:actuate(1)
	-- end
-- end

-- === backgorund functions

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
		kc_speakNoText(0,"transition level")
		kc_macro_at_trans_lvl()
		kc_procvar_set(trigger,false)
	end
end


return sysMacros