-- A333 airplane 
-- macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysMacros = {
}

require "kpcrew.systems.DFLT.sysMacros"

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
	if PLANE_ICAO == "A346" then
		command_once("toliss_airbus/engcommands/Master3Off")
		command_once("toliss_airbus/engcommands/Master4Off")
	end
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

	set("AirbusFBW/PackFlowSel",1)
	command_once("toliss_airbus/antiicecommands/WingOff")
	command_once("toliss_airbus/antiicecommands/ENG1Off")
	command_once("toliss_airbus/antiicecommands/ENG2Off")
	if PLANE_ICAO == "A346" then
		command_once("toliss_airbus/antiicecommands/ENG3Off")
		command_once("toliss_airbus/antiicecommands/ENG4Off")
	end 
	
	set("AirbusFBW/ProbeHeatSwitch",0)
	set("AirbusFBW/LandElev",-3)
	set("AirbusFBW/APUBleedSwitch",0)
	set("AirbusFBW/XBleedSwitch",1)

	set_array("AirbusFBW/ElecOHPArray",8,1)
	set_array("AirbusFBW/ElecOHPArray",9,1)
	set_array("AirbusFBW/ElecOHPArray",5,1)
	set_array("AirbusFBW/ElecOHPArray",6,1)
	set_array("AirbusFBW/ElecOHPArray",7,0)
	set_array("AirbusFBW/ElecOHPArray",2,1)
	set_array("AirbusFBW/ElecOHPArray",4,1)
	set_array("AirbusFBW/ElecOHPArray",0,1)
	set_array("AirbusFBW/ElecOHPArray",1,1)

	kc_macro_fuelpumps_off()
	kc_macro_hydraulic_initial()	

	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)

	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set("AirbusFBW/GravityExtendSwitchPos",0)
	else
		set("ckpt/gravityGearOn/anim",0) 
	end

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
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		command_once("toliss_airbus/eleccommands/ExtPowAOff") 
		command_once("toliss_airbus/eleccommands/ExtPowBOff") 
	else
		command_once("toliss_airbus/eleccommands/ExtPowOff") 
	end
	command_once("toliss_airbus/eleccommands/Bat1Off")
	command_once("toliss_airbus/eleccommands/Bat2Off")
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set_array("AirbusFBW/ElecOHPArray",16,0)
		set_array("AirbusFBW/ElecOHPArray",18,0)
		set_array("AirbusFBW/ElecOHPArray",8,0)
		set_array("AirbusFBW/ElecOHPArray",9,0)
	end
end

-- ====================================== Lights related functions
function kc_macro_lights_preflight()
	-- set the lights as needed during preflight/turnaround
	-- external
	sysLights.landLightGroup:actuate(0)
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.rwyLightGroup:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(0.6)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(0.6)
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
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(1)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(1)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0.6)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(1)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	-- internal
	if kc_is_daylight() then		
		sysLights.domeLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.logoSwitch:actuate(0)
		sysLights.wingSwitch:actuate(0)
		sysLights.wheelSwitch:actuate(0)
	else
		sysLights.domeLightGroup:actuate(1)
		sysLights.instrLightGroup:actuate(0.6)
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
	sysLights.taxiSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.positionSwitch:actuate(0)
	sysLights.beaconSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.strobesSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.logoSwitch:actuate(0)
	sysLights.wingSwitch:actuate(0)
	sysLights.wheelSwitch:actuate(0)
	-- internal
	sysLights.domeLightGroup:actuate(0)
	sysLights.instrLightGroup:actuate(0)
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

return sysMacros

