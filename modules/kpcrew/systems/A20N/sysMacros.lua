-- A20N airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysMacros = {
	spd_mode = 0,
	alt_mode = 0,
	hdg_mode = 0,
	hdg_arm = 0,
	alt_arm = 0
}

-- preflight events app 30 minutes
function kc_bck_preflight_events()
end

-- ====================================== States related macros

function kc_macro_state_cold_and_dark()
	-- set aircraft to cold & dark
	kc_macro_doors_cold_dark()

	set("AirbusFBW/Chocks",1)
	command_once("toliss_airbus/park_brake_release")

	set("AirbusFBW/EnableExternalPower",0)
	set("AirbusFBW/RMP1Switch",0)
	set("AirbusFBW/RMP2Switch",0)
	set("AirbusFBW/RMP3Switch",0)
	set("sim/cockpit/radios/com2_freq_hz",12150)
	set("AirbusFBW/XPDRSystem",1)
	set("AirbusFBW/XPDRPower",0)
	set("AirbusFBW/XPDR4",2)
	set("AirbusFBW/XPDR3",0)
	set("AirbusFBW/XPDR2",0)
	set("AirbusFBW/XPDR1",0)

	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")

	if (get("AirbusFBW/WXPowerSwitch") == 0) then
		command_once("toliss_airbus/WXRadarSwitchRight")
	end
	if (get("AirbusFBW/WXPowerSwitch") == 2) then
		command_once("toliss_airbus/WXRadarSwitchLeft")
	end
	
	set("AirbusFBW/XBleedSwitch",0)

	set("sim/cockpit2/controls/speedbrake_ratio",0)
	set("sim/cockpit2/controls/flap_ratio",0)

-- yellow elec pump off

	command_once("toliss_airbus/engcommands/Master1Off")
	command_once("toliss_airbus/engcommands/Master2Off")
	command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm")
	command_once("sim/flight_controls/landing_gear_down")
	set("AirbusFBW/LeftWiperSwitch",0) 
	set("AirbusFBW/RightWiperSwitch",0)
	

	set("AirbusFBW/CrewOxySwitch",0)
	set("AirbusFBW/CvrGndCtrl",0)

	set_array("AirbusFBW/GPWSSwitchArray",0,1)
	set_array("AirbusFBW/GPWSSwitchArray",1,1)
	set_array("AirbusFBW/GPWSSwitchArray",2,1)
	set_array("AirbusFBW/GPWSSwitchArray",3,0)
	set_array("AirbusFBW/GPWSSwitchArray",4,1)

	set_array("AirbusFBW/OHPLightSwitches",11,0)
	set_array("AirbusFBW/OHPLightSwitches",12,0)
	set_array("AirbusFBW/OHPLightSwitches",10,0)

	set("AirbusFBW/EconFlowSel",1)
	command_once("toliss_airbus/antiicecommands/WingOff")
	command_once("toliss_airbus/antiicecommands/ENG1Off")
	command_once("toliss_airbus/antiicecommands/ENG2Off")

	set("AirbusFBW/ProbeHeatSwitch",0)
	set("AirbusFBW/LandElev",-3)
	set("AirbusFBW/APUBleedSwitch",0)
	set("AirbusFBW/XBleedSwitch",1)
	set("AirbusFBW/EconFlowSel",1)

	set_array("AirbusFBW/ElecOHPArray",8,1)
	set_array("AirbusFBW/ElecOHPArray",9,1)
	set_array("AirbusFBW/ElecOHPArray",5,1)
	set_array("AirbusFBW/ElecOHPArray",6,1)
	set_array("AirbusFBW/ElecOHPArray",7,0)
	set_array("AirbusFBW/ElecOHPArray",2,1)
	set_array("AirbusFBW/ElecOHPArray",4,1)
	set_array("AirbusFBW/ElecOHPArray",0,1)
	set_array("AirbusFBW/ElecOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)
	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	set_array("AirbusFBW/HydOHPArray",0,1)
	set_array("AirbusFBW/HydOHPArray",1,1)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,0)

	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)
	set("ckpt/gravityGearOn/anim",0) 
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
		set("AirbusFBW/BlowerSwitch",0)
		set("AirbusFBW/ExtractSwitch",0)
		set("AirbusFBW/CabinFanSwitch",1)

	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

	kc_macro_lights_cold_dark()
	-- kc_macro_mcp_cold_dark()
	kc_macro_aircond_all_white_off()
	
	set("AirbusFBW/APUMaster",0)
	set("AirbusFBW/APUStarter",0)
	command_once("toliss_airbus/eleccommands/ExtPowOff")
	command_once("toliss_airbus/eleccommands/Bat1Off")
	command_once("toliss_airbus/eleccommands/Bat2Off")

end

function kc_macro_state_turnaround()
	-- set aircraft into turnaround mode

	kc_macro_doors_preflight()

	command_once("toliss_airbus/engcommands/Master1Off")
	command_once("toliss_airbus/engcommands/Master2Off")
	command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm")
	if (get("AirbusFBW/WXPowerSwitch") == 0) then
		command_once("toliss_airbus/WXRadarSwitchRight")
	end
	if (get("AirbusFBW/WXPowerSwitch") == 2) then
		command_once("toliss_airbus/WXRadarSwitchLeft")
	end
	command_once("sim/flight_controls/landing_gear_down")
	set("AirbusFBW/LeftWiperSwitch",0) 
	set("AirbusFBW/RightWiperSwitch",0)
	command_once("toliss_airbus/eleccommands/Bat1On")
	command_once("toliss_airbus/eleccommands/Bat2On")
	set("AirbusFBW/EnableExternalPower",1)
	command_once("toliss_airbus/eleccommands/ExtPowOn")
	set("AirbusFBW/RMP1Switch",1)
	set("AirbusFBW/RMP2Switch",1)
	set("AirbusFBW/RMP3Switch",1)
	set("AirbusFBW/XPDR4",2)
	set("AirbusFBW/XPDR3",0)
	set("AirbusFBW/XPDR2",0)
	set("AirbusFBW/XPDR1",0)
	set("sim/cockpit2/controls/flap_ratio",0)
	set("sim/cockpit2/controls/speedbrake_ratio",0)
	set("AirbusFBW/Chocks",1)
	command_once("toliss_airbus/park_brake_set")
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchUp")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchUp")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchUp")

	kc_macro_lights_preflight()

	-- set("AirbusFBW/APUMaster",1)
	-- set("AirbusFBW/APUStarter",1)
	set("AirbusFBW/XBleedSwitch",0)
	set("AirbusFBW/EconFlowSel",1)

	set("AirbusFBW/CrewOxySwitch",1)
	set("AirbusFBW/CvrGndCtrl",1)
	set_array("AirbusFBW/GPWSSwitchArray",0,1)
	set_array("AirbusFBW/GPWSSwitchArray",1,1)
	set_array("AirbusFBW/GPWSSwitchArray",2,1)
	set_array("AirbusFBW/GPWSSwitchArray",3,0)
	set_array("AirbusFBW/GPWSSwitchArray",4,1)
	set_array("AirbusFBW/OHPLightSwitches",11,0)
	set_array("AirbusFBW/OHPLightSwitches",12,2)
	set_array("AirbusFBW/OHPLightSwitches",10,1) 

	command_once("toliss_airbus/antiicecommands/WingOff")
	command_once("toliss_airbus/antiicecommands/ENG1Off")
	command_once("toliss_airbus/antiicecommands/ENG2Off")

	set("AirbusFBW/ProbeHeatSwitch",0)

	set("AirbusFBW/LandElev",-3)
	set("AirbusFBW/APUBleedSwitch",1)
	set("AirbusFBW/XBleedSwitch",1)
	set("AirbusFBW/EconFlowSel",1)
	set_array("AirbusFBW/ElecOHPArray",8,1)
	set_array("AirbusFBW/ElecOHPArray",9,1)
	set_array("AirbusFBW/ElecOHPArray",5,1)
	set_array("AirbusFBW/ElecOHPArray",6,1)
	set_array("AirbusFBW/ElecOHPArray",7,0)
	set_array("AirbusFBW/ElecOHPArray",2,1)
	set_array("AirbusFBW/ElecOHPArray",4,1)
	set_array("AirbusFBW/ElecOHPArray",0,1)
	set_array("AirbusFBW/ElecOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",0,1)
	set_array("AirbusFBW/FuelOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",2,1)
	set_array("AirbusFBW/FuelOHPArray",3,1)
	set_array("AirbusFBW/FuelOHPArray",4,1)
	set_array("AirbusFBW/FuelOHPArray",5,1)
	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	set_array("AirbusFBW/HydOHPArray",0,1)
	set_array("AirbusFBW/HydOHPArray",1,1)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,0)
	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)
	set("ckpt/gravityGearOn/anim",0) 
	set("AirbusFBW/XPDRSystem",1)
	set("AirbusFBW/XPDRPower",0)
	set("AirbusFBW/FwdCargoTemp",15.5)
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
		set("AirbusFBW/BlowerSwitch",0)
		set("AirbusFBW/ExtractSwitch",0)
		set("AirbusFBW/CabinFanSwitch",1)
	set_array("AirbusFBW/HydOHPArray",3,1)
	
	kc_macro_aircond_all_white_off()
	kc_macro_elec_all_white_off()		
	kc_macro_fuel_all_white_off()
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

end

function kc_aircond_has_white_lights()
	return 
		get("AirbusFBW/Pack1Switch") == 0 or
		get("AirbusFBW/Pack2Switch") == 0 or
		get("AirbusFBW/HotAirSwitch") == 0 or
		get("AirbusFBW/ENG1BleedSwitch") == 0 or
		get("AirbusFBW/ENG2BleedSwitch") == 0 or
		get("AirbusFBW/RamAirSwitch") == 1
end

function kc_macro_aircond_all_white_off()
	set("AirbusFBW/Pack1Switch",1)
	set("AirbusFBW/Pack2Switch",1)
	set("AirbusFBW/HotAirSwitch",1)
	set("AirbusFBW/ENG1BleedSwitch",1)
	set("AirbusFBW/ENG2BleedSwitch",1)
	set("AirbusFBW/RamAirSwitch",0)
end

function kc_elec_has_lights_on()
	return 
		get("AirbusFBW/ElecOHPArray",0) == 0 or
		get("AirbusFBW/ElecOHPArray",1) == 0 or
		get("AirbusFBW/ElecOHPArray",2) == 0 or
		get("AirbusFBW/ElecOHPArray",4) == 0 or
		get("AirbusFBW/ElecOHPArray",5) == 0 or
		get("AirbusFBW/ElecOHPArray",6) == 0 or
		get("AirbusFBW/ElecOHPArray",7) == 1 or
		get("AirbusFBW/ElecOHPArray",8) == 0 or
		get("AirbusFBW/ElecOHPArray",9) == 0 
end

function kc_macro_elec_all_white_off()
	set_array("AirbusFBW/ElecOHPArray",0,1)
	set_array("AirbusFBW/ElecOHPArray",1,1)
	set_array("AirbusFBW/ElecOHPArray",2,1)
	set_array("AirbusFBW/ElecOHPArray",4,1)
	set_array("AirbusFBW/ElecOHPArray",5,1)
	set_array("AirbusFBW/ElecOHPArray",6,1)
	set_array("AirbusFBW/ElecOHPArray",7,0)
	set_array("AirbusFBW/ElecOHPArray",8,1)
	set_array("AirbusFBW/ElecOHPArray",9,1)
end

function kc_fuel_all_white_off()
	return
	get("AirbusFBW/FuelOHPArray",0) == 0 or
	get("AirbusFBW/FuelOHPArray",1) == 0 or
	get("AirbusFBW/FuelOHPArray",2) == 0 or
	get("AirbusFBW/FuelOHPArray",3) == 0 or
	get("AirbusFBW/FuelOHPArray",4) == 0 or
	get("AirbusFBW/FuelOHPArray",5) == 0 or
	get("AirbusFBW/FuelOHPArray",6) == 0 or
	get("AirbusFBW/FuelOHPArray",7) == 1 or
	get("AirbusFBW/FuelOHPArray",8) == 0 or
	get("AirbusFBW/FuelOHPArray",9) == 0
end

function kc_macro_fuel_all_white_off()
	set_array("AirbusFBW/FuelOHPArray",0,1)
	set_array("AirbusFBW/FuelOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",2,1)
	set_array("AirbusFBW/FuelOHPArray",3,1)
	set_array("AirbusFBW/FuelOHPArray",4,1)
	set_array("AirbusFBW/FuelOHPArray",5,1)
	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	set_array("AirbusFBW/FuelOHPArray",8,1)
	set_array("AirbusFBW/FuelOHPArray",9,0)
end

-- start SGES start sequence
function kc_macro_start_sges_sequence()
		-- show_windoz()
		show_Automatic_sequence_start = true
		SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
end

-- ====================================== Lights related functions

function kc_macro_lights_cold_dark()
	-- set the lights for cold & dark mode
	-- external
	command_once("toliss_airbus/lightcommands/LLandLightDown")
	command_once("toliss_airbus/lightcommands/RLandLightDown")
	command_once("toliss_airbus/lightcommands/TurnoffLightOff")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/BeaconOff")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")
	command_once("toliss_airbus/lightcommands/WingLightOff")
	
	-- internal
	command_once("toliss_airbus/lightcommands/DomeLightDown")
	command_once("toliss_airbus/lightcommands/DomeLightDown")
	set("AirbusFBW/OHPBrightnessLevel",0)
	set("AirbusFBW/PanelFloodBrightnessLevel",0)
	set("AirbusFBW/PanelBrightnessLevel",0)
	set("AirbusFBW/PedestalFloodBrightnessLevel",0)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/SupplLightLevelRehostats",0,0)
	set_array("AirbusFBW/SupplLightLevelRehostats",1,0)

end

function kc_macro_lights_preflight()

	-- set the lights as needed during preflight/turnaround
	-- external
	command_once("toliss_airbus/lightcommands/LLandLightDown")
	command_once("toliss_airbus/lightcommands/RLandLightDown")
	command_once("toliss_airbus/lightcommands/TurnoffLightOff")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/NavLightUp")
	command_once("toliss_airbus/lightcommands/BeaconOff")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")
	command_once("toliss_airbus/lightcommands/WingLightOff")
	
	-- internal
	command_once("toliss_airbus/lightcommands/DomeLightDown")
	command_once("toliss_airbus/lightcommands/DomeLightDown")
	if kc_is_daylight() then		
		command_once("toliss_airbus/lightcommands/DomeLightDown")
		command_once("toliss_airbus/lightcommands/DomeLightDown")
		set("AirbusFBW/OHPBrightnessLevel",0)
		set("AirbusFBW/PanelFloodBrightnessLevel",0)
		set("AirbusFBW/PanelBrightnessLevel",0)
		set("AirbusFBW/PedestalFloodBrightnessLevel",0)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/DUBrightness",0,1)
		set_array("AirbusFBW/SupplLightLevelRehostats",0,0)
		set_array("AirbusFBW/SupplLightLevelRehostats",1,0)
	else
		command_once("toliss_airbus/lightcommands/DomeLightUp")
		command_once("toliss_airbus/lightcommands/NavLightUp")
		command_once("toliss_airbus/lightcommands/WingLightOn")
		set("AirbusFBW/OHPBrightnessLevel",1)
		set("AirbusFBW/PanelFloodBrightnessLevel",1)
		set("AirbusFBW/PanelBrightnessLevel",1)
		set("AirbusFBW/PedestalFloodBrightnessLevel",0.6)
		set_array("AirbusFBW/SupplLightLevelRehostats",0,1)
		set_array("AirbusFBW/SupplLightLevelRehostats",1,1)
		set_array("AirbusFBW/DUBrightness",0,0.8)
		set_array("AirbusFBW/DUBrightness",0,0.8)
		set_array("AirbusFBW/DUBrightness",0,0.8)
		set_array("AirbusFBW/DUBrightness",0,0.8)
		set_array("AirbusFBW/DUBrightness",0,0.8)
		set_array("AirbusFBW/DUBrightness",0,0.8)
	end
end

function kc_macro_lights_before_start()
	-- set the lights as needed when preparing for push and engine start
	-- external
	kc_macro_lights_preflight()
	command_once("toliss_airbus/lightcommands/BeaconOn")
	command_once("toliss_airbus/lightcommands/WingLightOff")
end

function kc_macro_lights_before_taxi()
	-- set the lights as needed when ready to taxi
	-- external
	kc_macro_lights_before_start()
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/TurnoffLightOn")
	command_once("toliss_airbus/lightcommands/DomeLightDown")
	command_once("toliss_airbus/lightcommands/DomeLightDown")
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	-- external
	kc_macro_lights_before_taxi()
	
	command_once("toliss_airbus/lightcommands/LLandLightUp")
	command_once("toliss_airbus/lightcommands/RLandLightUp")
	command_once("toliss_airbus/lightcommands/TurnoffLightOn")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/StrobeLightUp")
end

function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	-- external
	kc_macro_lights_for_takeoff()
	command_once("toliss_airbus/lightcommands/LLandLightDown")
	command_once("toliss_airbus/lightcommands/RLandLightDown")
	command_once("toliss_airbus/lightcommands/TurnoffLightOff")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
end

function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	-- external
	kc_macro_lights_climb_10k()
	command_once("toliss_airbus/lightcommands/LLandLightUp")
	command_once("toliss_airbus/lightcommands/RLandLightUp")
end

function kc_macro_lights_approach()
	-- set the lights when in the approach
	-- external
	kc_macro_lights_descend_10k()
	command_once("toliss_airbus/lightcommands/TurnoffLightOn")
end

function kc_macro_lights_cleanup()
	-- set the lights on cleaning up after landing
	-- external
	kc_macro_lights_approach()
	command_once("toliss_airbus/lightcommands/LLandLightDown")
	command_once("toliss_airbus/lightcommands/RLandLightDown")
	command_once("toliss_airbus/lightcommands/TurnoffLightOff")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")
	command_once("toliss_airbus/lightcommands/StrobeLightDown")

end

function kc_macro_lights_arrive_parking()
	-- set the lights when arriving the parking position
	-- external
	kc_macro_lights_cleanup()
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/NoseLightDown")
	command_once("toliss_airbus/lightcommands/DomeLightUp")
end

function kc_macro_lights_after_shutdown()
	-- set the lights when engines are stopped
	-- external
	kc_macro_lights_arrive_parking()
	command_once("toliss_airbus/lightcommands/BeaconOff")
end

function kc_macro_lights_all_on()
	-- set the lights all on for test and checks
	-- external
	command_once("toliss_airbus/lightcommands/LLandLightUp")
	command_once("toliss_airbus/lightcommands/RLandLightUp")
	command_once("toliss_airbus/lightcommands/TurnoffLightOn")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/NavLightUp")
	command_once("toliss_airbus/lightcommands/NavLightUp")
	command_once("toliss_airbus/lightcommands/BeaconOn")
	command_once("toliss_airbus/lightcommands/StrobeLightUp")
	command_once("toliss_airbus/lightcommands/StrobeLightUp")
	command_once("toliss_airbus/lightcommands/WingLightOn")
	
	-- internal
	command_once("toliss_airbus/lightcommands/DomeLightUp")
	command_once("toliss_airbus/lightcommands/DomeLightUp")
	set("AirbusFBW/OHPBrightnessLevel",1)
	set("AirbusFBW/PanelFloodBrightnessLevel",1)
	set("AirbusFBW/PanelBrightnessLevel",1)
	set("AirbusFBW/PedestalFloodBrightnessLevel",1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/DUBrightness",0,1)
	set_array("AirbusFBW/SupplLightLevelRehostats",0,1)
	set_array("AirbusFBW/SupplLightLevelRehostats",1,1)
end

-- ====================================== Door related functions
function kc_macro_doors_preflight()
	set_array("AirbusFBW/PaxDoorModeArray",0,2)
	set_array("AirbusFBW/PaxDoorModeArray",1,0)
	set_array("AirbusFBW/PaxDoorModeArray",2,0)
	set_array("AirbusFBW/PaxDoorModeArray",3,0)
	set_array("AirbusFBW/PaxDoorModeArray",4,0)
	set_array("AirbusFBW/PaxDoorModeArray",5,0)
	set_array("AirbusFBW/PaxDoorModeArray",6,0)
	set_array("AirbusFBW/PaxDoorModeArray",7,0)
	set_array("AirbusFBW/CargoDoorModeArray",0,2)
	set_array("AirbusFBW/CargoDoorModeArray",1,2)
	set_array("AirbusFBW/CargoDoorModeArray",2,0)
end

function kc_macro_doors_before_start()
	set_array("AirbusFBW/PaxDoorModeArray",0,0)
	set_array("AirbusFBW/PaxDoorModeArray",1,0)
	set_array("AirbusFBW/PaxDoorModeArray",2,0)
	set_array("AirbusFBW/PaxDoorModeArray",3,0)
	set_array("AirbusFBW/PaxDoorModeArray",4,0)
	set_array("AirbusFBW/PaxDoorModeArray",5,0)
	set_array("AirbusFBW/PaxDoorModeArray",6,0)
	set_array("AirbusFBW/PaxDoorModeArray",7,0)
	set_array("AirbusFBW/CargoDoorModeArray",0,0)
	set_array("AirbusFBW/CargoDoorModeArray",1,0)
	set_array("AirbusFBW/CargoDoorModeArray",2,0)
end

function kc_macro_doors_after_shutdown()
	set_array("AirbusFBW/PaxDoorModeArray",0,2)
	set_array("AirbusFBW/PaxDoorModeArray",1,0)
	set_array("AirbusFBW/PaxDoorModeArray",2,0)
	set_array("AirbusFBW/PaxDoorModeArray",3,0)
	set_array("AirbusFBW/PaxDoorModeArray",4,0)
	set_array("AirbusFBW/PaxDoorModeArray",5,0)
	set_array("AirbusFBW/PaxDoorModeArray",6,0)
	set_array("AirbusFBW/PaxDoorModeArray",7,0)
	set_array("AirbusFBW/CargoDoorModeArray",0,2)
	set_array("AirbusFBW/CargoDoorModeArray",1,2)
	set_array("AirbusFBW/CargoDoorModeArray",2,0)
end

function kc_macro_doors_cold_dark()
	set_array("AirbusFBW/PaxDoorModeArray",0,2)
	set_array("AirbusFBW/PaxDoorModeArray",1,0)
	set_array("AirbusFBW/PaxDoorModeArray",2,0)
	set_array("AirbusFBW/PaxDoorModeArray",3,0)
	set_array("AirbusFBW/PaxDoorModeArray",4,0)
	set_array("AirbusFBW/PaxDoorModeArray",5,0)
	set_array("AirbusFBW/PaxDoorModeArray",6,0)
	set_array("AirbusFBW/PaxDoorModeArray",7,0)
	set_array("AirbusFBW/CargoDoorModeArray",0,0)
	set_array("AirbusFBW/CargoDoorModeArray",1,0)
	set_array("AirbusFBW/CargoDoorModeArray",2,0)
end

function kc_macro_doors_all_open()
	set_array("AirbusFBW/PaxDoorModeArray",0,2)
	set_array("AirbusFBW/PaxDoorModeArray",1,2)
	set_array("AirbusFBW/PaxDoorModeArray",2,2)
	set_array("AirbusFBW/PaxDoorModeArray",3,2)
	set_array("AirbusFBW/PaxDoorModeArray",4,2)
	set_array("AirbusFBW/PaxDoorModeArray",5,2)
	set_array("AirbusFBW/PaxDoorModeArray",6,2)
	set_array("AirbusFBW/PaxDoorModeArray",7,2)
	set_array("AirbusFBW/CargoDoorModeArray",0,2)
	set_array("AirbusFBW/CargoDoorModeArray",1,2)
	set_array("AirbusFBW/CargoDoorModeArray",2,2)

end

function kc_macro_doors_all_closed()
	set_array("AirbusFBW/PaxDoorModeArray",0,0)
	set_array("AirbusFBW/PaxDoorModeArray",1,0)
	set_array("AirbusFBW/PaxDoorModeArray",2,0)
	set_array("AirbusFBW/PaxDoorModeArray",3,0)
	set_array("AirbusFBW/PaxDoorModeArray",4,0)
	set_array("AirbusFBW/PaxDoorModeArray",5,0)
	set_array("AirbusFBW/PaxDoorModeArray",6,0)
	set_array("AirbusFBW/PaxDoorModeArray",7,0)
	set_array("AirbusFBW/CargoDoorModeArray",0,0)
	set_array("AirbusFBW/CargoDoorModeArray",1,0)
	set_array("AirbusFBW/CargoDoorModeArray",2,0)
end

-- ====================================== A/P & Glareshield related functions

function kc_macro_mcp_cold_dark()
	set("AirbusFBW/FD1Engage",0)
	set("AirbusFBW/FD2Engage",0)
	if get("AirbusFBW/ATHRmode") == 1 then
		command_once("AirbusFBW/ATHRbutton")
	end
	set("sim/cockpit/autopilot/airspeed",activePrefSet:get("aircraft:mcp_def_spd"))
	set("sim/cockpit/autopilot/heading_mag",activePrefSet:get("aircraft:mcp_def_hdg"))
	set("sim/cockpit/autopilot/altitude",activePrefSet:get("aircraft:mcp_def_alt"))
	set("sim/cockpit2/autopilot/vvi_dial_fpm",0)
	set("AirbusFBW/AP1Engage",0)
	set("AirbusFBW/AP2Engage",0)
end


function kc_macro_mcp_preflight()
	set("AirbusFBW/FD1Engage",1)
	if get("AirbusFBW/ATHRmode") == 1 then
		command_once("AirbusFBW/ATHRbutton")
	end
	set("sim/cockpit/autopilot/airspeed",activeBriefings:get("takeoff:v2"))
	set("sim/cockpit/autopilot/heading_mag",activeBriefings:get("departure:initHeading"))
	set("sim/cockpit/autopilot/altitude",activeBriefings:get("departure:initAlt"))
end

function kc_macro_mcp_takeoff()
	set("AirbusFBW/FD1Engage",1)
	set("sim/cockpit/autopilot/airspeed",activeBriefings:get("takeoff:v2"))
	set("sim/cockpit/autopilot/heading_mag",activeBriefings:get("departure:initHeading"))
	set("sim/cockpit/autopilot/altitude",activeBriefings:get("departure:initAlt"))
end

function kc_macro_mcp_goaround()
	set("AirbusFBW/FD1Engage",1)
	set("sim/cockpit/autopilot/airspeed",activeBriefings:get("approach:gav2"))
	set("sim/cockpit/autopilot/heading_mag",activeBriefings:get("approach:gaheading"))
	set("sim/cockpit/autopilot/altitude",activeBriefings:get("approach:gaaltitude"))
end

function kc_macro_mcp_after_landing()
	set("AirbusFBW/FD1Engage",0)
	set("sim/cockpit/autopilot/airspeed",100)
	set("sim/cockpit/autopilot/heading_mag",1)
	set("sim/cockpit/autopilot/altitude",900)
	set("AirbusFBW/ILSonCapt",0)
end

-- =====================================================

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
	set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
	set("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) 
end

-- test if all baros are set to local baro
function kc_macro_test_local_baro()
	return true
		-- math.ceil(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")*100)/100 == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		-- math.ceil(get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")*100)/100 == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 
end

-- set baros to briefng
function kc_macro_set_briefed_baro()
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

-- test if all baros are set to local baro
function kc_macro_test_briefed_baro()
	if activePrefSet:get("general:baro_mode_hpa") then
		return 	get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
				get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
	else
		return 	get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
				get("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
	end
end

-- glareshield landing setup
-- initialise IRS


-- fuel pumps all off
function kc_macro_fuelpumps_off()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)
end

function kc_macro_fuelpumps_stand()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)
end

function kc_macro_fuelpumps_shutdown()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)
end

-- fuel pumps on as needed
function kc_macro_fuelpumps_on()
	set_array("AirbusFBW/FuelOHPArray",0,1)
	set_array("AirbusFBW/FuelOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",2,1)
	set_array("AirbusFBW/FuelOHPArray",3,1)
	set_array("AirbusFBW/FuelOHPArray",4,1)
	set_array("AirbusFBW/FuelOHPArray",5,1)
end

-- hyd pumps initial setup
function kc_macro_hydraulic_initial()
	set_array("AirbusFBW/HydOHPArray",0,0)
	set_array("AirbusFBW/HydOHPArray",1,0)
	set_array("AirbusFBW/HydOHPArray",2,0)
	set_array("AirbusFBW/HydOHPArray",3,0)
end

-- hyd pumps all off
function kc_macro_hydraulic_off()
	set_array("AirbusFBW/HydOHPArray",0,0)
	set_array("AirbusFBW/HydOHPArray",1,0)
	set_array("AirbusFBW/HydOHPArray",2,0)
	set_array("AirbusFBW/HydOHPArray",3,0)
end

-- hyd pumps all on
function kc_macro_hydraulic_on()
	set_array("AirbusFBW/HydOHPArray",0,1)
	set_array("AirbusFBW/HydOHPArray",1,1)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,0)
end

-- connect and start gpu
function kc_macro_gpu_connect()
	set("AirbusFBW/EnableExternalPower",1)
	command_once("toliss_airbus/eleccommands/ExtPowOn")
end

-- diconnect gpu
function kc_macro_gpu_disconnect()
	command_once("toliss_airbus/eleccommands/ExtPowOff")
	set("AirbusFBW/EnableExternalPower",0)
end

-- prepare engine start
-- start 1st engine
-- start nth engine

-- packs all off
function kc_macro_packs_off()
	set("AirbusFBW/Pack1Switch",0)
	set("AirbusFBW/Pack2Switch",0)
end

-- packs for engine start
function kc_macro_packs_start()
end

-- packs for takeoff
function kc_macro_packs_takeoff()
	if activeBriefings:get("takeoff:packs") < 2 then 
		set("AirbusFBW/Pack1Switch",1)
		set("AirbusFBW/Pack2Switch",1)
	else
		set("AirbusFBW/Pack1Switch",0)
		set("AirbusFBW/Pack2Switch",0)
	end
end

-- packs all on
function kc_macro_packs_on()
	set("AirbusFBW/Pack1Switch",1)
	set("AirbusFBW/Pack2Switch",1)
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
	command_once("toliss_airbus/lightcommands/FSBSignOff")
end

function kc_macro_below_10000_ft()
	kc_macro_lights_descend_10k()
	command_once("toliss_airbus/lightcommands/FSBSignOn")
end

function kc_macro_at_trans_alt()
	set("AirbusFBW/BaroStdCapt",1)
	set("AirbusFBW/BaroStdFO",1)
end

function kc_macro_at_trans_lvl()
	set("AirbusFBW/BaroStdCapt",0)
	set("AirbusFBW/BaroStdFO",0)
	kc_macro_set_briefed_baro()
end

-- bck callouts when needed

function kc_macro_set_autobrake()
	if activeBriefings:get("approach:autobrake") > 1 then
		if activeBriefings:get("approach:autobrake") == 2 then
			command_once("AirbusFBW/AbrkLo")
		elseif activeBriefings:get("approach:autobrake") == 3 then
			command_once("AirbusFBW/AbrkMed")
		elseif activeBriefings:get("approach:autobrake") == 4 then
			command_once("AirbusFBW/AbrkMax")
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
	if get("sim/cockpit2/controls/flap_ratio") == 0 then
		kc_procvar_set(trigger,false)
		kc_speakNoText(0,"ready for after takeoff checklist")
	end
	set("AirbusFBW/APUMaster",0)
end

return sysMacros