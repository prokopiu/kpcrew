-- ToLiss Airbusses 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A3TL sysMacros")


-- custom cold & dark activities
function kc_macro_custom_cold_dark()

	logMsg("kc_macro_custom_cold_dark A3TL")
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set_array("AirbusFBW/ElecOHPArray",16,0)
		set_array("AirbusFBW/ElecOHPArray",18,0)
		set_array("AirbusFBW/ElecOHPArray",8,0)
		set_array("AirbusFBW/ElecOHPArray",9,0)
	end	
	-- if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		-- command_once("toliss_airbus/eleccommands/ExtPowAOff") 
		-- command_once("toliss_airbus/eleccommands/ExtPowBOff") 
	-- else
		-- command_once("toliss_airbus/eleccommands/ExtPowOff") 
	-- end
	-- set("AirbusFBW/EnableExternalPower",0)
	
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

	set("AirbusFBW/XBleedSwitch",1)
	
	set("AirbusFBW/APUMaster",0)
	set("AirbusFBW/APUStarter",0)

	if (get("AirbusFBW/WXPowerSwitch") == 0) then
		command_once("toliss_airbus/WXRadarSwitchRight")
	end
	if (get("AirbusFBW/WXPowerSwitch") == 2) then
		command_once("toliss_airbus/WXRadarSwitchLeft")
	end
	
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
	
	set_array("AirbusFBW/ADIRUSwitchArray",0,0)
	set_array("AirbusFBW/ADIRUSwitchArray",1,0)
	set_array("AirbusFBW/ADIRUSwitchArray",2,0)
	
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set_array("AirbusFBW/ElecOHPArray",16,1)
		set_array("AirbusFBW/ElecOHPArray",18,1)
		set_array("AirbusFBW/ElecOHPArray",8,1)
		set_array("AirbusFBW/ElecOHPArray",9,1)
	end	
	set("AirbusFBW/EnableExternalPower",1)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		command_once("toliss_airbus/eleccommands/ExtPowAOn") 
	else
		command_once("toliss_airbus/eleccommands/ExtPowOn") 
	end

	set("AirbusFBW/RMP1Switch",1)
	set("AirbusFBW/RMP2Switch",1)
	set("AirbusFBW/RMP3Switch",1)
	set("sim/cockpit/radios/com2_freq_hz",12150)

	set("AirbusFBW/XPDRSystem",1)
	set("AirbusFBW/XPDRPower",0)
	set("AirbusFBW/XPDR4",2)
	set("AirbusFBW/XPDR3",0)
	set("AirbusFBW/XPDR2",0)
	set("AirbusFBW/XPDR1",0)

	set("AirbusFBW/XBleedSwitch",1)

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
	
	set("sim/cockpit2/controls/flap_ratio",0)
	set("sim/cockpit2/controls/speedbrake_ratio",0)
	set("AirbusFBW/Chocks",1)

	set("AirbusFBW/PackFlowSel",1)
	set("AirbusFBW/CrewOxySwitch",1)
	set("AirbusFBW/CvrGndCtrl",1)

	set_array("AirbusFBW/GPWSSwitchArray",0,1)
	set_array("AirbusFBW/GPWSSwitchArray",1,1)
	set_array("AirbusFBW/GPWSSwitchArray",2,1)
	set_array("AirbusFBW/GPWSSwitchArray",3,0)
	set_array("AirbusFBW/GPWSSwitchArray",4,1)

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

	set("AirbusFBW/NWSnAntiSkid",1)
	set("AirbusFBW/WXSwitchPWS",0)
	if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		set("AirbusFBW/GravityExtendSwitchPos",0)
	else
		set("ckpt/gravityGearOn/anim",0) 
	end

	set("AirbusFBW/FwdCargoTemp",15.5)
	set("AirbusFBW/CockpitTemp",22)
	set("AirbusFBW/FwdCabinTemp",22)
	set("AirbusFBW/AftCabinTemp",22)
	set("AirbusFBW/BlowerSwitch",0)
	set("AirbusFBW/ExtractSwitch",0)
	set("AirbusFBW/CabinFanSwitch",1)

	set_array("AirbusFBW/ADIRUSwitchArray",0,1)
	set_array("AirbusFBW/ADIRUSwitchArray",1,1)
	set_array("AirbusFBW/ADIRUSwitchArray",2,1)
	
	sysHydraulic.elecHydPumpGroup:actuate(0)
end

-- ========= fuel
-- fuel pumps all off
-- function xkc_macro_fuelpumps_off()
	-- set_array("AirbusFBW/FuelOHPArray",0,0)
	-- set_array("AirbusFBW/FuelOHPArray",1,0)
	-- set_array("AirbusFBW/FuelOHPArray",2,0)
	-- set_array("AirbusFBW/FuelOHPArray",3,0)
	-- set_array("AirbusFBW/FuelOHPArray",4,0)
	-- set_array("AirbusFBW/FuelOHPArray",5,0)

	-- set_array("AirbusFBW/FuelOHPArray",6,1)
	-- set_array("AirbusFBW/FuelOHPArray",7,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/FuelOHPArray",8,0)
		-- set_array("AirbusFBW/FuelOHPArray",9,0)
		-- set_array("AirbusFBW/FuelOHPArray",10,0)
		-- set_array("AirbusFBW/FuelOHPArray",11,0)
		-- set_array("AirbusFBW/FuelOHPArray",12,0)
		-- set_array("AirbusFBW/FuelOHPArray",13,0)
		-- set_array("AirbusFBW/FuelOHPArray",14,0)
		-- set_array("AirbusFBW/FuelOHPArray",15,0)
		-- set_array("AirbusFBW/FuelOHPArray",16,0)
		-- set_array("AirbusFBW/FuelOHPArray",17,0)
		-- set_array("AirbusFBW/FuelOHPArray",18,0)
		-- set_array("AirbusFBW/FuelOHPArray",19,0)
		-- set_array("AirbusFBW/FuelOHPArray",20,0)
		-- set_array("AirbusFBW/FuelOHPArray",21,0)
		-- set_array("AirbusFBW/FuelOHPArray",22,0)
		-- set_array("AirbusFBW/FuelOHPArray",23,0)
		-- set_array("AirbusFBW/FuelOHPArray",24,0)
	-- end
-- end

-- function xkc_macro_fuelpumps_stand()
	-- set_array("AirbusFBW/FuelOHPArray",0,0)
	-- set_array("AirbusFBW/FuelOHPArray",1,0)
	-- set_array("AirbusFBW/FuelOHPArray",2,0)
	-- set_array("AirbusFBW/FuelOHPArray",3,0)
	-- set_array("AirbusFBW/FuelOHPArray",4,0)
	-- set_array("AirbusFBW/FuelOHPArray",5,0)

	-- set_array("AirbusFBW/FuelOHPArray",6,1)
	-- set_array("AirbusFBW/FuelOHPArray",7,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/FuelOHPArray",8,0)
		-- set_array("AirbusFBW/FuelOHPArray",9,0)
		-- set_array("AirbusFBW/FuelOHPArray",10,0)
		-- set_array("AirbusFBW/FuelOHPArray",11,0)
		-- set_array("AirbusFBW/FuelOHPArray",12,0)
		-- set_array("AirbusFBW/FuelOHPArray",13,0)
		-- set_array("AirbusFBW/FuelOHPArray",14,0)
		-- set_array("AirbusFBW/FuelOHPArray",15,0)
		-- set_array("AirbusFBW/FuelOHPArray",16,0)
		-- set_array("AirbusFBW/FuelOHPArray",17,1)
		-- set_array("AirbusFBW/FuelOHPArray",18,1)
		-- set_array("AirbusFBW/FuelOHPArray",19,1)
		-- set_array("AirbusFBW/FuelOHPArray",20,1)
		-- set_array("AirbusFBW/FuelOHPArray",21,1)
		-- set_array("AirbusFBW/FuelOHPArray",22,0)
		-- set_array("AirbusFBW/FuelOHPArray",23,1)
		-- set_array("AirbusFBW/FuelOHPArray",24,0)
	-- end

-- end

-- function xkc_macro_fuelpumps_shutdown()
	-- set_array("AirbusFBW/FuelOHPArray",0,0)
	-- set_array("AirbusFBW/FuelOHPArray",1,0)
	-- set_array("AirbusFBW/FuelOHPArray",2,0)
	-- set_array("AirbusFBW/FuelOHPArray",3,0)
	-- set_array("AirbusFBW/FuelOHPArray",4,0)
	-- set_array("AirbusFBW/FuelOHPArray",5,0)

	-- set_array("AirbusFBW/FuelOHPArray",6,1)
	-- set_array("AirbusFBW/FuelOHPArray",7,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/FuelOHPArray",8,0)
		-- set_array("AirbusFBW/FuelOHPArray",9,0)
		-- set_array("AirbusFBW/FuelOHPArray",10,0)
		-- set_array("AirbusFBW/FuelOHPArray",11,0)
		-- set_array("AirbusFBW/FuelOHPArray",12,0)
		-- set_array("AirbusFBW/FuelOHPArray",13,0)
		-- set_array("AirbusFBW/FuelOHPArray",14,0)
		-- set_array("AirbusFBW/FuelOHPArray",15,0)
		-- set_array("AirbusFBW/FuelOHPArray",16,0)
		-- set_array("AirbusFBW/FuelOHPArray",17,1)
		-- set_array("AirbusFBW/FuelOHPArray",18,1)
		-- set_array("AirbusFBW/FuelOHPArray",19,1)
		-- set_array("AirbusFBW/FuelOHPArray",20,1)
		-- set_array("AirbusFBW/FuelOHPArray",21,1)
		-- set_array("AirbusFBW/FuelOHPArray",22,0)
		-- set_array("AirbusFBW/FuelOHPArray",23,1)
		-- set_array("AirbusFBW/FuelOHPArray",24,0)
	-- end
-- end

-- fuel pumps on as needed
-- function xkc_macro_fuelpumps_on()
	-- set_array("AirbusFBW/FuelOHPArray",0,1)
	-- set_array("AirbusFBW/FuelOHPArray",1,1)
	-- set_array("AirbusFBW/FuelOHPArray",2,1)
	-- set_array("AirbusFBW/FuelOHPArray",3,1)
	-- set_array("AirbusFBW/FuelOHPArray",4,1)
	-- set_array("AirbusFBW/FuelOHPArray",5,1)

	-- set_array("AirbusFBW/FuelOHPArray",6,1)
	-- set_array("AirbusFBW/FuelOHPArray",7,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/FuelOHPArray",8,1)
		-- set_array("AirbusFBW/FuelOHPArray",9,1)
		-- set_array("AirbusFBW/FuelOHPArray",10,1)
		-- set_array("AirbusFBW/FuelOHPArray",11,1)
		-- set_array("AirbusFBW/FuelOHPArray",12,0)
		-- set_array("AirbusFBW/FuelOHPArray",13,0)
		-- set_array("AirbusFBW/FuelOHPArray",14,0)
		-- set_array("AirbusFBW/FuelOHPArray",15,1)
		-- set_array("AirbusFBW/FuelOHPArray",16,1)
		-- set_array("AirbusFBW/FuelOHPArray",17,1)
		-- set_array("AirbusFBW/FuelOHPArray",18,1)
		-- set_array("AirbusFBW/FuelOHPArray",19,1)
		-- set_array("AirbusFBW/FuelOHPArray",20,1)
		-- set_array("AirbusFBW/FuelOHPArray",21,1)
		-- set_array("AirbusFBW/FuelOHPArray",22,0)
		-- set_array("AirbusFBW/FuelOHPArray",23,1)
		-- set_array("AirbusFBW/FuelOHPArray",24,0)
	-- end
-- end

-- ========= hydraulic

-- hyd pumps initial setup
-- function xkc_macro_hydraulic_initial()
	-- set_array("AirbusFBW/HydOHPArray",0,1)
	-- set_array("AirbusFBW/HydOHPArray",1,1)
	-- set_array("AirbusFBW/HydOHPArray",2,1)
	-- set_array("AirbusFBW/HydOHPArray",3,1)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/HydOHPArray",2,1)
		-- set_array("AirbusFBW/HydOHPArray",6,1)
		-- set_array("AirbusFBW/HydOHPArray",7,0)
		-- set_array("AirbusFBW/HydOHPArray",8,1)
		-- set_array("AirbusFBW/HydOHPArray",9,0)
		-- set_array("AirbusFBW/HydOHPArray",10,1)
		-- set_array("AirbusFBW/HydOHPArray",11,1)
	-- end
	-- if PLANE_ICAO == "A339" then
		-- set_array("AirbusFBW/HydOHPArray",2,1)
		-- set_array("AirbusFBW/HydOHPArray",3,1)
	-- end
-- end

-- hyd pumps all off
-- function xkc_macro_hydraulic_off()
	-- set_array("AirbusFBW/HydOHPArray",0,0)
	-- set_array("AirbusFBW/HydOHPArray",1,0)
	-- set_array("AirbusFBW/HydOHPArray",2,1)
	-- set_array("AirbusFBW/HydOHPArray",3,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/HydOHPArray",2,0)
		-- set_array("AirbusFBW/HydOHPArray",6,0)
		-- set_array("AirbusFBW/HydOHPArray",8,0)
		-- set_array("AirbusFBW/HydOHPArray",10,0)
		-- set_array("AirbusFBW/HydOHPArray",6,0)
	-- end
	-- if PLANE_ICAO == "A339" then
		-- set_array("AirbusFBW/HydOHPArray",2,0)
	-- end
	
-- end

-- hyd pumps all on
-- function xkc_macro_hydraulic_on()
	-- set_array("AirbusFBW/HydOHPArray",0,1)
	-- set_array("AirbusFBW/HydOHPArray",1,1)
	-- set_array("AirbusFBW/HydOHPArray",2,1)
	-- set_array("AirbusFBW/HydOHPArray",3,0)
	-- if PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/HydOHPArray",3,1)
		-- set_array("AirbusFBW/HydOHPArray",6,1)
		-- set_array("AirbusFBW/HydOHPArray",8,1)
		-- set_array("AirbusFBW/HydOHPArray",10,1)
		-- set_array("AirbusFBW/HydOHPArray",6,1)
	-- end
	-- if PLANE_ICAO == "A339" then
		-- set_array("AirbusFBW/HydOHPArray",3,1)
	-- end
-- end

-- ==== verify OHP status



-- function xkc_elec_has_lights_on()
	-- return 
		-- get("AirbusFBW/ElecOHPArray",0) == 0 or
		-- get("AirbusFBW/ElecOHPArray",1) == 0 or
		-- get("AirbusFBW/ElecOHPArray",2) == 0 or
		-- get("AirbusFBW/ElecOHPArray",4) == 0 or
		-- get("AirbusFBW/ElecOHPArray",5) == 0 or
		-- get("AirbusFBW/ElecOHPArray",6) == 0 or
		-- get("AirbusFBW/ElecOHPArray",7) == 1 or
		-- get("AirbusFBW/ElecOHPArray",8) == 0 or
		-- get("AirbusFBW/ElecOHPArray",9) == 0 
-- end

-- function xkc_macro_elec_cold_dark()
	-- set_array("AirbusFBW/ElecOHPArray",8,1)
	-- set_array("AirbusFBW/ElecOHPArray",9,1)
	-- set_array("AirbusFBW/ElecOHPArray",5,1)
	-- set_array("AirbusFBW/ElecOHPArray",6,1)
	-- set_array("AirbusFBW/ElecOHPArray",7,0)
	-- set_array("AirbusFBW/ElecOHPArray",2,1)
	-- set_array("AirbusFBW/ElecOHPArray",4,1)
	-- set_array("AirbusFBW/ElecOHPArray",0,1)
	-- set_array("AirbusFBW/ElecOHPArray",1,1)
	-- if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
		-- set_array("AirbusFBW/ElecOHPArray",16,0)
		-- set_array("AirbusFBW/ElecOHPArray",18,0)
		-- set_array("AirbusFBW/ElecOHPArray",8,0)
		-- set_array("AirbusFBW/ElecOHPArray",9,0)
	-- end
	-- command_once("toliss_airbus/eleccommands/Bat1Off")
	-- command_once("toliss_airbus/eleccommands/Bat2Off")
-- end

-- function xkc_macro_elec_all_white_off()
	-- set_array("AirbusFBW/ElecOHPArray",0,1)
	-- set_array("AirbusFBW/ElecOHPArray",1,1)
	-- set_array("AirbusFBW/ElecOHPArray",2,1)
	-- set_array("AirbusFBW/ElecOHPArray",4,1)
	-- set_array("AirbusFBW/ElecOHPArray",5,1)
	-- set_array("AirbusFBW/ElecOHPArray",6,1)
	-- set_array("AirbusFBW/ElecOHPArray",7,0)
	-- set_array("AirbusFBW/ElecOHPArray",8,1)
	-- set_array("AirbusFBW/ElecOHPArray",9,1)
-- end

-- function xkc_fuel_all_white_off()

	-- local stdwhites = get("AirbusFBW/FuelOHPArray",0) == 1 and
	-- get("AirbusFBW/FuelOHPArray",1) == 1 and
	-- get("AirbusFBW/FuelOHPArray",2) == 1 and
	-- get("AirbusFBW/FuelOHPArray",3) == 1 and
	-- get("AirbusFBW/FuelOHPArray",4) == 1 and
	-- get("AirbusFBW/FuelOHPArray",5) == 1 and
	-- get("AirbusFBW/FuelOHPArray",6) == 1 and
	-- get("AirbusFBW/FuelOHPArray",7) == 0

	-- local a346whites = true 
	-- if PLANE_ICAO == "A346" then
		-- a346whites = get("AirbusFBW/FuelOHPArray",8) == 1 and
		-- get("AirbusFBW/FuelOHPArray",9) == 1 and
		-- get("AirbusFBW/FuelOHPArray",10) == 1 and
		-- get("AirbusFBW/FuelOHPArray",11) == 1 and
		-- get("AirbusFBW/FuelOHPArray",12) == 0 and
		-- get("AirbusFBW/FuelOHPArray",13) == 0 and
		-- get("AirbusFBW/FuelOHPArray",14) == 0 and
		-- get("AirbusFBW/FuelOHPArray",15) == 1 and
		-- get("AirbusFBW/FuelOHPArray",16) == 1 and
		-- get("AirbusFBW/FuelOHPArray",17) == 1 and
		-- get("AirbusFBW/FuelOHPArray",18) == 1 and
		-- get("AirbusFBW/FuelOHPArray",19) == 1 and
		-- get("AirbusFBW/FuelOHPArray",20) == 1 and
		-- get("AirbusFBW/FuelOHPArray",21) == 1 and
		-- get("AirbusFBW/FuelOHPArray",22) == 0 and
		-- get("AirbusFBW/FuelOHPArray",23) == 1 and
		-- get("AirbusFBW/FuelOHPArray",24) == 0
	-- end
	
	-- return stdwhites and a346whites
-- end

return sysMacros