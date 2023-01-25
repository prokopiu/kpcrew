-- DFLT airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysMacros = {
}

function kc_macro_state_cold_and_dark()
	kc_macro_int_lights_off()
	kc_macro_ext_lights_off()
	kc_macro_bleeds_off()
	kc_macro_packs_off()

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
	command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 
	command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
	command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
	sysFuel.crossFeed:actuate(0)
	if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
		command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
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
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
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
	command_end("laminar/CitX/APU/starter_switch_dwn")
	sysElectric.apuMasterSwitch:actuate(0)
	command_once("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	command_begin("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	sysElectric.gpuSwitch:actuate(0)
	sysGeneral.GearSwitch:actuate(1)
	sysElectric.batterySwitch:actuate(0) 
	sysElectric.battery2Switch:actuate(0) 
end

function kc_macro_state_turnaround()
end

-- external lights all off
function kc_macro_ext_lights_off()
	sysLights.landLightGroup:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
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
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights runway entry
function kc_macro_ext_lights_rwyentry()
	sysLights.landLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights takeoff
function kc_macro_ext_lights_takeoff()
	sysLights.landLightGroup:actuate(1)
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights above 10000
function kc_macro_ext_lights_above10()
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.landLightGroup:actuate(0)
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
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights for landing
function kc_macro_ext_lights_land()
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

-- external lights runway vacated
function kc_macro_ext_lights_rwyvacate()
	sysLights.taxiSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.landLightGroup:actuate(0)
	if kc_is_daylight() then		
		sysLights.logoSwitch:actuate(0)
	else
		sysLights.logoSwitch:actuate(1)
	end
end

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
	sysAir.packSwitchGroup:setValue(0)
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
	sysAir.packSwitchGroup:setValue(1)
end

-- 10000 feet activities up and down
function kc_macro_above_10000_ft()
	kc_macro_ext_lights_above10()
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_up") 
end

function kc_macro_below_10000_ft()
	kc_macro_ext_lights_below10()
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
end

function kc_macro_at_trans_alt()
	if math.abs(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")-29.921249) > 0.01 then 
		command_once("sim/instruments/barometer_std")
	end
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

-- internal lights all off
function kc_macro_int_lights_off()
	sysLights.domeLightGroup:setValue(0)
	sysLights.instrLightGroup:actuate(0)
	if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
		command_once("laminar/CitX/lights/dimming_switch_toggle")
	end
end

-- internal lights at stand
function kc_macro_int_lights_on()
	if kc_is_daylight() then		
		sysLights.domeLightGroup:setValue(0)
		sysLights.instrLightGroup:actuate(0)
		if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
			command_once("laminar/CitX/lights/dimming_switch_toggle")
		end
	else
		sysLights.domeLightGroup:setValue(1)
		sysLights.instrLightGroup:actuate(1)
		if get("laminar/CitX/lights/dim_lights_switch") == 0 then
			command_once("laminar/CitX/lights/dimming_switch_toggle")
		end
	end
end

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