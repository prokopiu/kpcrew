-- ToLiss Airbusses 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A3TL sysMacros")

-- c&d setup
function kc_macro_state_cold_and_dark()
	logMsg("A3TL kc_macro_state_cold_and_dark")

	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")
	
	kc_macro_lights_cold_dark()
	kc_macro_doors_cold_dark()
	-- kc_macro_mcp_cold_dark()

	kc_macro_set_irs(0)
	
	sysGeneral.parkBrakeSwitch:actuate(1) 
	kc_macro_set_groundobjects(1)
	
	sysGeneral.GearSwitch:actuate(1)

	sysControls.Speedbrake:setValue(0)

	kc_macro_set_flap(0)

	sysGeneral.wiperGroup:actuate(0)

	sysEngines.throttlePos:actuate(0)
	
	sysControls.aileronReset:actuate(1)
	sysControls.rudderReset:actuate(1)

	kc_macro_hydraulic_off()	

	kc_macro_fuelpumps_off()

	sysAir.packSwitchGroup:actuate(0)
	sysAir.engBleedGroup:actuate(0)
	sysAir.isoValveSwitch:actuate(0)
	kc_macro_aircond_all_white_off()

	sysAice.engAntiIceGroup:actuate(0)
	sysAice.wingAntiIce:actuate(0)
	sysAice.windowHeatGroup:actuate(0)

	sysGeneral.seatBeltSwitch:actuate(0)
	sysGeneral.noSmokingSwitch:actuate(0)

	if kc_has_autobrake == true then
		sysControls.Autobrake:setValue(sysControls.autobrk_off)
	end

	kc_macro_elec_cold_dark()
	
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

	if (get("AirbusFBW/WXPowerSwitch") == 0) then
		command_once("toliss_airbus/WXRadarSwitchRight")
	end
	if (get("AirbusFBW/WXPowerSwitch") == 2) then
		command_once("toliss_airbus/WXRadarSwitchLeft")
	end
	
	set("AirbusFBW/XBleedSwitch",0)

-- yellow elec pump off

	command_once("toliss_airbus/engcommands/Master1Off")
	command_once("toliss_airbus/engcommands/Master2Off")
	if PLANE_ICAO == "A346" then
		command_once("toliss_airbus/engcommands/Master3Off")
		command_once("toliss_airbus/engcommands/Master4Off")
	end
	command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm")
	command_once("sim/flight_controls/landing_gear_down")

	set("AirbusFBW/CrewOxySwitch",0)
	set("AirbusFBW/CvrGndCtrl",0)

	set_array("AirbusFBW/GPWSSwitchArray",0,1)
	set_array("AirbusFBW/GPWSSwitchArray",1,1)
	set_array("AirbusFBW/GPWSSwitchArray",2,1)
	set_array("AirbusFBW/GPWSSwitchArray",3,0)
	set_array("AirbusFBW/GPWSSwitchArray",4,1)
	
	set("AirbusFBW/LandElev",-3)
	set("AirbusFBW/APUBleedSwitch",0)
	
	set("AirbusFBW/XBleedSwitch",1)

	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)

	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set("AirbusFBW/GravityExtendSwitchPos",0)
	else
		set("ckpt/gravityGearOn/anim",0) 
	end

	set("AirbusFBW/APUMaster",0)
	set("AirbusFBW/APUStarter",0)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		command_once("toliss_airbus/eleccommands/ExtPowAOff") 
		command_once("toliss_airbus/eleccommands/ExtPowBOff") 
	else
		command_once("toliss_airbus/eleccommands/ExtPowOff") 
	end
	set("AirbusFBW/EnableExternalPower",0)
	
	kc_macro_set_xpdrcode(2000)
	kc_macro_elec_cold_dark()	
	
end

function kc_macro_state_turnaround()
	logMsg("A3TL kc_macro_state_turnaround")

	kc_macro_doors_preflight()

	command_once("toliss_airbus/engcommands/Master1Off")
	command_once("toliss_airbus/engcommands/Master2Off")
	if PLANE_ICAO == "A346" then
		command_once("toliss_airbus/engcommands/Master3Off")
		command_once("toliss_airbus/engcommands/Master4Off")
	end
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
	set("AirbusFBW/EnableExternalPower",1)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		command_once("toliss_airbus/eleccommands/ExtPowAOn") 
	else
		command_once("toliss_airbus/eleccommands/ExtPowOn") 
	end
	command_once("toliss_airbus/eleccommands/Bat1On")
	command_once("toliss_airbus/eleccommands/Bat2On")
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set_array("AirbusFBW/ElecOHPArray",16,1)
		set_array("AirbusFBW/ElecOHPArray",18,1)
		set_array("AirbusFBW/ElecOHPArray",8,1)
		set_array("AirbusFBW/ElecOHPArray",9,1)
	end	

	set("AirbusFBW/RMP1Switch",1)
	set("AirbusFBW/RMP2Switch",1)
	set("AirbusFBW/RMP3Switch",1)
	
	kc_macro_set_xpdrcode(1234)
	
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

	set("AirbusFBW/XBleedSwitch",0)
	-- if PLANE_ICAO == "A321" then
		set("AirbusFBW/PackFlowSel",1)
	-- end

	set("AirbusFBW/CrewOxySwitch",1)
	set("AirbusFBW/CvrGndCtrl",1)
	set_array("AirbusFBW/GPWSSwitchArray",0,1)
	set_array("AirbusFBW/GPWSSwitchArray",1,1)
	set_array("AirbusFBW/GPWSSwitchArray",2,1)
	set_array("AirbusFBW/GPWSSwitchArray",3,0)
	set_array("AirbusFBW/GPWSSwitchArray",4,1)
	set_array("AirbusFBW/OHPLightSwitches",11,0)
	set_array("AirbusFBW/OHPLightSwitches",12,1)
	set_array("AirbusFBW/OHPLightSwitches",10,1) 

	command_once("toliss_airbus/antiicecommands/WingOff")
	command_once("toliss_airbus/antiicecommands/ENG1Off")
	command_once("toliss_airbus/antiicecommands/ENG2Off")
	if PLANE_ICAO == "A346" then
		command_once("toliss_airbus/antiicecommands/ENG3Off")
		command_once("toliss_airbus/antiicecommands/ENG4Off")
	end 
	
	set("AirbusFBW/ProbeHeatSwitch",0)

	set("AirbusFBW/LandElev",-3)
	set("AirbusFBW/APUBleedSwitch",1)
	set("AirbusFBW/XBleedSwitch",1)
	
	kc_macro_fuelpumps_stand()
	kc_macro_hydraulic_initial()
	
	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set("AirbusFBW/GravityExtendSwitchPos",0)
	else
		set("ckpt/gravityGearOn/anim",0) 
	end
	set("AirbusFBW/XPDRSystem",1)
	set("AirbusFBW/XPDRPower",0)
	set("AirbusFBW/FwdCargoTemp",15.5)
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
		set("AirbusFBW/BlowerSwitch",0)
		set("AirbusFBW/ExtractSwitch",0)
		set("AirbusFBW/CabinFanSwitch",1)
	-- set_array("AirbusFBW/HydOHPArray",3,1)
	
	kc_macro_aircond_all_white_off()
	kc_macro_elec_all_white_off()		
	-- kc_macro_fuel_all_white_off()
	kc_macro_mcp_preflight()
	
	activeBckVars:set("general:timesOFF","==:==")
	activeBckVars:set("general:timesOUT","==:==")
	activeBckVars:set("general:timesIN","==:==")
	activeBckVars:set("general:timesON","==:==")

end

-- ========= air conditioning

function kc_macro_aircond_all_white_off()
	set("AirbusFBW/Pack1Switch",1)
	set("AirbusFBW/Pack2Switch",1)
	set("AirbusFBW/HotAirSwitch",1)
	set("AirbusFBW/ENG1BleedSwitch",1)
	set("AirbusFBW/ENG2BleedSwitch",1)
	if PLANE_ICAO == "A346" then
		set("AirbusFBW/ENG3BleedSwitch",1)
		set("AirbusFBW/ENG4BleedSwitch",1)
	end 
	set("AirbusFBW/RamAirSwitch",0)
	set("AirbusFBW/PackFlowSel",1)
	
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
	
	set("AirbusFBW/BlowerSwitch",0)
	set("AirbusFBW/ExtractSwitch",0)
	set("AirbusFBW/CabinFanSwitch",1)
end

-- ========= doors

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
	set_array("AirbusFBW/OHPLightSwitches",11,0)
	set_array("AirbusFBW/OHPLightSwitches",12,0)
	set_array("AirbusFBW/OHPLightSwitches",10,0)
	
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

function kc_macro_lights_for_takeoff()

	command_once("toliss_airbus/lightcommands/LLandLightUp")
	command_once("toliss_airbus/lightcommands/RLandLightUp")
	command_once("toliss_airbus/lightcommands/TurnoffLightOn")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/NoseLightUp")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/NavLightDown")
	command_once("toliss_airbus/lightcommands/NavLightUp")
	command_once("toliss_airbus/lightcommands/BeaconOn")
	command_once("toliss_airbus/lightcommands/StrobeLightUp")
	command_once("toliss_airbus/lightcommands/StrobeLightUp")
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
		command_once("toliss_airbus/lightcommands/NavLightUp")
		set("AirbusFBW/OHPBrightnessLevel",0.4)
		set("AirbusFBW/PanelFloodBrightnessLevel",0.1)
		set("AirbusFBW/PanelBrightnessLevel",0.1)
		set("AirbusFBW/PedestalFloodBrightnessLevel",0.1)
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

-- ========= fuel
-- fuel pumps all off
function kc_macro_fuelpumps_off()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,0)
		set_array("AirbusFBW/FuelOHPArray",18,0)
		set_array("AirbusFBW/FuelOHPArray",19,0)
		set_array("AirbusFBW/FuelOHPArray",20,0)
		set_array("AirbusFBW/FuelOHPArray",21,0)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,0)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

function kc_macro_fuelpumps_stand()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end

end

function kc_macro_fuelpumps_shutdown()
	set_array("AirbusFBW/FuelOHPArray",0,0)
	set_array("AirbusFBW/FuelOHPArray",1,0)
	set_array("AirbusFBW/FuelOHPArray",2,0)
	set_array("AirbusFBW/FuelOHPArray",3,0)
	set_array("AirbusFBW/FuelOHPArray",4,0)
	set_array("AirbusFBW/FuelOHPArray",5,0)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,0)
		set_array("AirbusFBW/FuelOHPArray",9,0)
		set_array("AirbusFBW/FuelOHPArray",10,0)
		set_array("AirbusFBW/FuelOHPArray",11,0)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,0)
		set_array("AirbusFBW/FuelOHPArray",16,0)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

-- fuel pumps on as needed
function kc_macro_fuelpumps_on()
	set_array("AirbusFBW/FuelOHPArray",0,1)
	set_array("AirbusFBW/FuelOHPArray",1,1)
	set_array("AirbusFBW/FuelOHPArray",2,1)
	set_array("AirbusFBW/FuelOHPArray",3,1)
	set_array("AirbusFBW/FuelOHPArray",4,1)
	set_array("AirbusFBW/FuelOHPArray",5,1)

	set_array("AirbusFBW/FuelOHPArray",6,1)
	set_array("AirbusFBW/FuelOHPArray",7,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/FuelOHPArray",8,1)
		set_array("AirbusFBW/FuelOHPArray",9,1)
		set_array("AirbusFBW/FuelOHPArray",10,1)
		set_array("AirbusFBW/FuelOHPArray",11,1)
		set_array("AirbusFBW/FuelOHPArray",12,0)
		set_array("AirbusFBW/FuelOHPArray",13,0)
		set_array("AirbusFBW/FuelOHPArray",14,0)
		set_array("AirbusFBW/FuelOHPArray",15,1)
		set_array("AirbusFBW/FuelOHPArray",16,1)
		set_array("AirbusFBW/FuelOHPArray",17,1)
		set_array("AirbusFBW/FuelOHPArray",18,1)
		set_array("AirbusFBW/FuelOHPArray",19,1)
		set_array("AirbusFBW/FuelOHPArray",20,1)
		set_array("AirbusFBW/FuelOHPArray",21,1)
		set_array("AirbusFBW/FuelOHPArray",22,0)
		set_array("AirbusFBW/FuelOHPArray",23,1)
		set_array("AirbusFBW/FuelOHPArray",24,0)
	end
end

-- ========= hydraulic

-- hyd pumps initial setup
function kc_macro_hydraulic_initial()
	set_array("AirbusFBW/HydOHPArray",0,1)
	set_array("AirbusFBW/HydOHPArray",1,1)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,1)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/HydOHPArray",2,1)
		set_array("AirbusFBW/HydOHPArray",6,1)
		set_array("AirbusFBW/HydOHPArray",7,0)
		set_array("AirbusFBW/HydOHPArray",8,1)
		set_array("AirbusFBW/HydOHPArray",9,0)
		set_array("AirbusFBW/HydOHPArray",10,1)
		set_array("AirbusFBW/HydOHPArray",11,1)
	end
	if PLANE_ICAO == "A339" then
		set_array("AirbusFBW/HydOHPArray",2,1)
		set_array("AirbusFBW/HydOHPArray",3,1)
	end
end

-- hyd pumps all off
function kc_macro_hydraulic_off()
	set_array("AirbusFBW/HydOHPArray",0,0)
	set_array("AirbusFBW/HydOHPArray",1,0)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/HydOHPArray",2,0)
		set_array("AirbusFBW/HydOHPArray",6,0)
		set_array("AirbusFBW/HydOHPArray",8,0)
		set_array("AirbusFBW/HydOHPArray",10,0)
		set_array("AirbusFBW/HydOHPArray",6,0)
	end
	if PLANE_ICAO == "A339" then
		set_array("AirbusFBW/HydOHPArray",2,0)
	end
	
end

-- hyd pumps all on
function kc_macro_hydraulic_on()
	set_array("AirbusFBW/HydOHPArray",0,1)
	set_array("AirbusFBW/HydOHPArray",1,1)
	set_array("AirbusFBW/HydOHPArray",2,1)
	set_array("AirbusFBW/HydOHPArray",3,0)
	if PLANE_ICAO == "A346" then
		set_array("AirbusFBW/HydOHPArray",3,1)
		set_array("AirbusFBW/HydOHPArray",6,1)
		set_array("AirbusFBW/HydOHPArray",8,1)
		set_array("AirbusFBW/HydOHPArray",10,1)
		set_array("AirbusFBW/HydOHPArray",6,1)
	end
	if PLANE_ICAO == "A339" then
		set_array("AirbusFBW/HydOHPArray",3,1)
	end
end

-- ==== verify OHP status

function kc_aircond_has_white_lights()
	local stdbleeds = get("AirbusFBW/Pack1Switch") == 0 or
		get("AirbusFBW/Pack2Switch") == 0 or
		get("AirbusFBW/HotAirSwitch") == 0 or
		get("AirbusFBW/ENG1BleedSwitch") == 0 or
		get("AirbusFBW/ENG2BleedSwitch") == 0 or
		get("AirbusFBW/RamAirSwitch") == 1

	local a346bleeds = true
	if PLANE_ICAO == "A346" then
		a346bleeds = get("AirbusFBW/ENG3BleedSwitch") == 0 or
		get("AirbusFBW/ENG4BleedSwitch") == 0
	end 
	
	return stdbleeds and a346bleeds
end

function kc_macro_aircond_all_white_off()
	set("AirbusFBW/Pack1Switch",1)
	set("AirbusFBW/Pack2Switch",1)
	set("AirbusFBW/HotAirSwitch",1)
	set("AirbusFBW/ENG1BleedSwitch",1)
	set("AirbusFBW/ENG2BleedSwitch",1)
	if PLANE_ICAO == "A346" then
		set("AirbusFBW/ENG3BleedSwitch",1)
		set("AirbusFBW/ENG4BleedSwitch",1)
	end 
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

function kc_macro_elec_cold_dark()
	set_array("AirbusFBW/ElecOHPArray",8,1)
	set_array("AirbusFBW/ElecOHPArray",9,1)
	set_array("AirbusFBW/ElecOHPArray",5,1)
	set_array("AirbusFBW/ElecOHPArray",6,1)
	set_array("AirbusFBW/ElecOHPArray",7,0)
	set_array("AirbusFBW/ElecOHPArray",2,1)
	set_array("AirbusFBW/ElecOHPArray",4,1)
	set_array("AirbusFBW/ElecOHPArray",0,1)
	set_array("AirbusFBW/ElecOHPArray",1,1)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set_array("AirbusFBW/ElecOHPArray",16,0)
		set_array("AirbusFBW/ElecOHPArray",18,0)
		set_array("AirbusFBW/ElecOHPArray",8,0)
		set_array("AirbusFBW/ElecOHPArray",9,0)
	end
	command_once("toliss_airbus/eleccommands/Bat1Off")
	command_once("toliss_airbus/eleccommands/Bat2Off")
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

	local stdwhites = get("AirbusFBW/FuelOHPArray",0) == 1 and
	get("AirbusFBW/FuelOHPArray",1) == 1 and
	get("AirbusFBW/FuelOHPArray",2) == 1 and
	get("AirbusFBW/FuelOHPArray",3) == 1 and
	get("AirbusFBW/FuelOHPArray",4) == 1 and
	get("AirbusFBW/FuelOHPArray",5) == 1 and
	get("AirbusFBW/FuelOHPArray",6) == 1 and
	get("AirbusFBW/FuelOHPArray",7) == 0

	local a346whites = true 
	if PLANE_ICAO == "A346" then
		a346whites = get("AirbusFBW/FuelOHPArray",8) == 1 and
		get("AirbusFBW/FuelOHPArray",9) == 1 and
		get("AirbusFBW/FuelOHPArray",10) == 1 and
		get("AirbusFBW/FuelOHPArray",11) == 1 and
		get("AirbusFBW/FuelOHPArray",12) == 0 and
		get("AirbusFBW/FuelOHPArray",13) == 0 and
		get("AirbusFBW/FuelOHPArray",14) == 0 and
		get("AirbusFBW/FuelOHPArray",15) == 1 and
		get("AirbusFBW/FuelOHPArray",16) == 1 and
		get("AirbusFBW/FuelOHPArray",17) == 1 and
		get("AirbusFBW/FuelOHPArray",18) == 1 and
		get("AirbusFBW/FuelOHPArray",19) == 1 and
		get("AirbusFBW/FuelOHPArray",20) == 1 and
		get("AirbusFBW/FuelOHPArray",21) == 1 and
		get("AirbusFBW/FuelOHPArray",22) == 0 and
		get("AirbusFBW/FuelOHPArray",23) == 1 and
		get("AirbusFBW/FuelOHPArray",24) == 0
	end
	
	return stdwhites and a346whites
end

-- mcp

function kc_macro_mcp_cold_dark()
	sysMCP.fdirGroup:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:setValue(0)
	sysMCP.discAPSwitch:actuate(0)
	sysMCP.ap1Switch:actuate(0)
end

function kc_macro_mcp_preflight()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
	sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
	sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
	sysMCP.vspSelector:actuate(0)
	sysMCP.discAPSwitch:actuate(0)
end

function kc_macro_mcp_takeoff()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	sysMCP.vspSelector:actuate(0)
	sysMCP.discAPSwitch:actuate(0)
end

function kc_macro_mcp_goaround()
	sysMCP.fdirGroup:actuate(1)
	sysMCP.athrSwitch:actuate(1)
	sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude"))
end

function kc_macro_mcp_after_landing()
	sysMCP.fdirGroup:actuate(0)
	sysMCP.athrSwitch:actuate(0)
	sysMCP.hdgselSwitch:actuate(0)
	sysMCP.speedSwitch:actuate(0)
	sysMCP.ap1Switch:actuate(0)
end

-- autobrake
function kc_macro_set_autobrake(index)
	if index > 0 then
		if index == 1 then
			command_once("AirbusFBW/AbrkLo")
		elseif index == 2 then
			command_once("AirbusFBW/AbrkMed")
		elseif index == 3 then
			command_once("AirbusFBW/AbrkMax")
		end
	else
		command_once("AirbusFBW/AbrkLo")
		command_once("AirbusFBW/AbrkMed")
		command_once("AirbusFBW/AbrkMax")
		command_once("AirbusFBW/AbrkMax")
	end
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,3)
		set("AirbusFBW/APUMaster",1)
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
	if get("AirbusFBW/APUAvail") == 1 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,20)
		command_once("toliss_airbus/engcommands/EngineModeSwitchToStart")
		if trigger == "engstart1" then
			command_once("toliss_airbus/engcommands/Master1On")
		end
		if trigger == "engstart2" then
			command_once("toliss_airbus/engcommands/Master2On")
		end
		if trigger == "engstart3" then
			command_once("toliss_airbus/engcommands/Master3On")
		end
		if trigger == "engstart4" then
			command_once("toliss_airbus/engcommands/Master4On")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
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

-- IRS off 0=OFF, 1=NAV, 2=ATT
function kc_macro_set_irs(mode)
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
	command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
	if mode == 0 then -- OFF
		-- do nothing see above
	elseif mode == 1 then -- ALIGN
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchUp")
	elseif mode == 2 then -- NAV 
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchUp")		
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchUp")
	end
end

-- ground objects 1=on 0=off
function kc_macro_set_groundobjects(state)
	if state == 1 then
		set("AirbusFBW/Chocks",1)
		command_once("toliss_airbus/park_brake_release")
	else
		command_once("toliss_airbus/park_brake_set")
		set("AirbusFBW/Chocks",0)
	end
end

function kc_macro_set_xpdrmode(mode)
	sysRadios.xpdrSwitch:setValue(mode)
end

function kc_macro_set_xpdrcode(xpdrcode)
	local digit1 = math.floor(xpdrcode/1000)
	local digit2 = math.floor((xpdrcode-digit1*1000)/100)
	local digit3 = math.floor((xpdrcode-digit1*1000-digit2*100)/10)
	local digit4 = math.floor((xpdrcode-digit1*1000-digit2*100-digit3*10))
	set("AirbusFBW/XPDR1",digit4)
	set("AirbusFBW/XPDR2",digit3)
	set("AirbusFBW/XPDR3",digit2)
	set("AirbusFBW/XPDR4",digit1)
end

return sysMacros