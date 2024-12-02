-- Standard Operating Procedure for ToLiss A20N/A21N

-- @classmod SOP_A20N
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_A20N = {
}

-- SOP related imports
local SOP					= require "kpcrew.sops.SOP"

local Flow					= require "kpcrew.Flow"
local FlowItem 				= require "kpcrew.FlowItem"

local Checklist 			= require "kpcrew.checklists.Checklist"
local ChecklistItem 		= require "kpcrew.checklists.ChecklistItem"
local SimpleChecklistItem 	= require "kpcrew.checklists.SimpleChecklistItem"
local IndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"
local ManualChecklistItem 	= require "kpcrew.checklists.ManualChecklistItem"

local Procedure 			= require "kpcrew.procedures.Procedure"
local State		 			= require "kpcrew.procedures.State"
local Background 			= require "kpcrew.procedures.Background"
local ProcedureItem 		= require "kpcrew.procedures.ProcedureItem"
local SimpleProcedureItem 	= require "kpcrew.procedures.SimpleProcedureItem"
local IndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"
local BackgroundProcedureItem = require "kpcrew.procedures.BackgroundProcedureItem"
local HoldProcedureItem 	= require "kpcrew.procedures.HoldProcedureItem"

sysLights 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	
sysFMC 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysFMC")	
sysRadios					= require("kpcrew.systems." .. kc_acf_icao .. ".sysRadios")	
sysMacros					= require("kpcrew.systems." .. kc_acf_icao .. ".sysMacros")	

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = " " }

-- Set up SOP =========================================================================

activeSOP = SOP:new("ToLiss A20N/A21N SOP")

-- =========== PRELIMINARY COCKPIT PREPARATION ===========
-- ENGINE MASTERS 1 & 2.........................OFF   (FO)
-- ENGINE MODE SELECTOR........................NORM   (FO)
-- LANDING GEAR LEVER..........................DOWN   (FO)
-- BOTH WIPER SELECTORS.........................OFF   (FO)
-- BAT 1 / BAT 2................................OFF   (FO)
-- BAT 1 / BAT 2............CHECK BOTH ABOVE 25.5 V   (FO)
-- EXT POWER..............................CONNECTED   (FO)
-- EXT POWER SWITCH..............................ON   (FO)
-- BAT 1 / BAT 2...............................AUTO   (FO)
-- COCKPIT LIGHTS.......................AS REQUIRED   (FO)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (FO)
-- CHOCKS..................................IN PLACE   (FO)
-- PARKING BRAKE................................OFF   (FO)
-- FLAPS.............................CHECK POSITION   (FO)
-- SPEED BRAKE LEVER.....CHECK RETRACTED & DISARMED   (FO)
-- PROBE WINDOW HEAT.....................CHECK AUTO   (FO)
-- AIR COND PANEL..............ALL WHITE LIGHTS OFF   (FO)
-- CROSS BLEED.................................AUTO   (FO)
-- ZONE TEMP SEL........................AS REQUIRED   (FO)
-- WEATHER RADAR................................OFF   (FO)
-- ELECTRIC PANEL.........NO AMBER EXCEPT GEN FAULT   (FO)
-- VENT PANEL..................ALL WHITE LIGHTS OFF   (FO)
-- ECAM OXY PRESS...........................CHECKED   (FO)
-- ECAM HYD QTY.............................CHECKED   (FO)
-- ADIRS L,R,C..................................NAV  (CPT)
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.
-- RADIO MANAGEMENT PANELS...............ON AND SET   (FO)
-- CLOCK ET...................................RESET  (CPT)
-- =======================================================

local prelCockpitPrep = Procedure:new("PRELIMINARY COCKPIT PREP","","")
prelCockpitPrep:setFlightPhase(2)
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MASTERS 1 & 2","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ENG1MasterSwitch") == 0 and get("AirbusFBW/ENG2MasterSwitch") == 0 end,
	function () 
		command_once("toliss_airbus/engcommands/Master1Off")
		command_once("toliss_airbus/engcommands/Master2Off")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
prelCockpitPrep:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return get("ckpt/gearHandle") == 1 end,
	function () command_once("sim/flight_controls/landing_gear_down") end))
prelCockpitPrep:addItem(ProcedureItem:new("BOTH WIPER SELECTORS","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/LeftWiperSwitch") == 0 and get("AirbusFBW/RightWiperSwitch") == 0 end,
	function () 
		set("AirbusFBW/LeftWiperSwitch",0) 
		set("AirbusFBW/RightWiperSwitch",0)
	end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("BAT 1 / BAT 2","OFF",FlowItem.actorFO,0,"bat12off",
	function () return get("AirbusFBW/SDELBatterySupply") == 0 end,
	function () 
		command_once("toliss_airbus/eleccommands/Bat1Off")
		command_once("toliss_airbus/eleccommands/Bat2Off")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","CHECK BOTH ABOVE 25.5 V",FlowItem.actorFO,0,
	function () return get("AirbusFBW/BatVolts",0) > 25.5 and get("AirbusFBW/BatVolts",1) > 25.5 end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorFO,0,
	function () return get("AirbusFBW/EnableExternalPower") == 1 end,
	function () set("AirbusFBW/EnableExternalPower",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ExtPowOHPArray",0) == 1 end,
	function () command_once("toliss_airbus/eleccommands/ExtPowOn") end))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","AUTO",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		command_once("toliss_airbus/eleccommands/Bat1On")
		command_once("toliss_airbus/eleccommands/Bat2On")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("COCKPIT LIGHTS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_preflight()
	end))
prelCockpitPrep:addItem(ProcedureItem:new("ACCU PRESS INDICATOR","CHECK GREEN BAND",FlowItem.actorFO,0,
	function () return get("AirbusFBW/BrakeAccu") > 0.93 end,
	function () -- turn Y pump on until pressure reached
	end))
prelCockpitPrep:addItem(ProcedureItem:new("CHOCKS","ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/Chocks") == 1 end,
	function () set("AirbusFBW/Chocks",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKE","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ParkBrake") == 0 end,
	function () command_once("toliss_airbus/park_brake_release") end))
prelCockpitPrep:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == 0 end,
	function () set("sim/cockpit2/controls/flap_ratio",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE LEVER","CHECK RETRACTED & DISARMED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 and get("AirbusFBW/SpdBrakeDeployed") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))
prelCockpitPrep:addItem(ProcedureItem:new("PROBE WINDOW HEAT","CHECK AUTO",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ProbeHeatSwitch") == 0 end,
	function () set("AirbusFBW/ProbeHeatSwitch",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("AIR COND PANEL","ALL WHITE LIGHTS OFF",FlowItem.actorFO,0,
	function () return kc_aircond_has_white_lights() == false end,
	function () kc_macro_aircond_all_white_off() end))
prelCockpitPrep:addItem(ProcedureItem:new("CROSS BLEED","AUTO",FlowItem.actorPF,0,
	function () return get("AirbusFBW/XBleedSwitch") == 1 end,
	function () set("AirbusFBW/XBleedSwitch",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("ZONE TEMP SEL","AS REQUIRED",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/CockpitTemp") == 22 and
		get("AirbusFBW/FwdCabinTemp") == 22 and
		get("AirbusFBW/AftCabinTemp") == 22
	end,
	function () 
		set("AirbusFBW/CockpitTemp",22)
		set("AirbusFBW/FwdCabinTemp",22)
		set("AirbusFBW/AftCabinTemp",22)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/WXPowerSwitch") == 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 0) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
		if (get("AirbusFBW/WXPowerSwitch") == 2) then
			command_once("toliss_airbus/WXRadarSwitchLeft")
		end
	end))
prelCockpitPrep:addItem(ProcedureItem:new("ELECTRIC PANEL","NO AMBER EXCEPT GEN FAULT",FlowItem.actorFO,0,
	function () return kc_elec_has_lights_on() == false end,
	function () kc_macro_elec_all_white_off() end))
prelCockpitPrep:addItem(ProcedureItem:new("VENT PANEL","ALL WHITE LIGHTS OFF",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/BlowerSwitch") == 0 and 
		get("AirbusFBW/ExtractSwitch") == 0 and
		get("AirbusFBW/CabinFanSwitch") == 1
	end,
	function ()
		set("AirbusFBW/BlowerSwitch",0)
		set("AirbusFBW/ExtractSwitch",0)
		set("AirbusFBW/CabinFanSwitch",1)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("ECAM OXY PRESS","CHECKED",FlowItem.actorFO,0,
	function() return 
		get("sim/cockpit2/oxygen/indicators/o2_bottle_pressure_psi") > 1600 end,
	function () set("AirbusFBW/SDDOOR",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("ECAM HYD QTY","CHECKED",FlowItem.actorFO,0,
	function() return 
		get("AirbusFBW/HydSysQtyArray",0) > 0.7 and
		get("AirbusFBW/HydSysQtyArray",1) > 0.7 and
		get("AirbusFBW/HydSysQtyArray",2) > 0.7 
	end,
	function () set("AirbusFBW/SDHYD",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("ADIRS L,R,C","NAV",FlowItem.actorCPT,0,
	function () return 
		get("AirbusFBW/ADIRUSwitchArray",0) == 1 and 
		get("AirbusFBW/ADIRUSwitchArray",1) == 1 and 
		get("AirbusFBW/ADIRUSwitchArray",2) == 1
	end,
	function () 
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU1SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU2SwitchUp")
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchDown")
		command_once("toliss_airbus/adirucommands/ADIRU3SwitchUp")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANELS","ON AND SET",FlowItem.actorFO,0,
	function () return  
		(get("AirbusFBW/RMP1Switch") + get("AirbusFBW/RMP2Switch") + get("AirbusFBW/RMP3Switch")) == 3
	end,
	function () 
		set("AirbusFBW/RMP1Switch",1)
		set("AirbusFBW/RMP2Switch",1)
		set("AirbusFBW/RMP3Switch",1)
		set("sim/cockpit/radios/com2_freq_hz",12150)
		set("AirbusFBW/XPDR4",2)
		set("AirbusFBW/XPDR3",0)
		set("AirbusFBW/XPDR2",0)
		set("AirbusFBW/XPDR1",0)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("CLOCK ET","RESET",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/ClockETSwitch") == 2 end,
	function () set("AirbusFBW/ClockETSwitch",2) end))

-- ============== CDU PREFLIGHT BY CAPTAIN ===============
-- QNH ON EFIS..................................SET (BOTH)
-- KPCREW BRIEFING WINDOW......................OPEN  (CPT)
-- KPCREW DEPARTURE BRIEFING.............FILLED OUT  (CPT)
-- FMGC PREFLIGHT...................D-I-F-R-I-P+P-S  (CPT)
-- FCU..........................................SET  (CPT)
-- LOAD SHEET........................CHECK / REVISE (BOTH)
-- FUEL......CROSS CHECK (ECAM FOB & FPL/LOADSHEET)   (PF)
-- FMGS T/O DATA.............................REVISE (BOTH)
-- =======================================================

local cduPreflightProc = Procedure:new("CDU PREFLIGHT BY CAPTAIN")
cduPreflightProc:setFlightPhase(2)
cduPreflightProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
cduPreflightProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEFING","FILLED OUT",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("FMGC PREFLIGHT","D-I-F-R-I-P+P-S",FlowItem.actorCPT))
cduPreflightProc:addItem(ProcedureItem:new("FCU","SET",FlowItem.actorFO,0,true,
	function () kc_macro_mcp_preflight() end))
cduPreflightProc:addItem(HoldProcedureItem:new("LOAD SHEET","CHECK / REVISE",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("FUEL","CROSS CHECK (ECAM FOB & FPL/LOADSHEET)",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("FMGS T/O DATA","REVISE",FlowItem.actorCPT))

-- D-I-F-R-I-P+P-S

-- ================= COCKPIT PREPARATION =================
-- RCRD GND CTL..................................ON   (FO)  
-- EXTERIOR LIGHTS......................AS REQUIRED   (FO)
-- SEAT BELTS....................................ON   (FO)
-- NO SMOKING...............................ON/AUTO   (FO)
-- EMERGENCY EXIT LIGHT.........................ARM   (FO)
-- CABIN PRESSURE LDG ELEV.....................AUTO   (FO)
-- PACK FLOW............................AS REQUIRED   (FO)
-- APU FIRE..........................IN and GUARDED (CKPT)
-- A/SKID & N/W STRG SWITCH......................ON (CKPT)
-- THRUST LEVERS.........................CHECK IDLE (CKPT)
-- ENGINE MASTERS 1 & 2.........................OFF (CKPT)
-- ENGINE MODE SELECTOR........................NORM   (FO)
-- GRAVITY GEAR EXTN.........................STOWED (CKPT)
-- XPDR CODE...................................2000 (CKPT)
-- XPDR SYSTEM 1................................SET (CKPT)
-- XPDR.....................................STANDBY (CKPT)
-- RADIO MANAGEMENT PANELS...............ON AND SET   (FO)
-- CREW OXY SUPPLY...............................ON (CKPT)  
-- WEATHER RADAR SYS............................OFF (CKPT)
-- PWS..........................................OFF (CKPT)
-- ENGINE ANTI-ICE..............................OFF (CKPT)
-- WING-ANTI-ICE................................OFF (CKPT)
-- FUEL PUMP SWITCHES........................ALL ON (CKPT)
-- FUEL MODE SELECTOR..........................AUTO (CKPT)
-- AFT CARGO HEAT.........................MID RANGE (CKPT)
-- CLOCK..................................CHECK/SET (CKPT)
--   Check time is UTC, switch to GPS
-- BARO REF.................................SET QNH (BOTH)
-- ND RANGE......................................10   (PF)
-- =======================================================

local cockpitPrep = Procedure:new("COCKPIT PREPARATION","","")
cockpitPrep:setFlightPhase(3)
-- cockpitPrep:setResize(false)
cockpitPrep:addItem(ProcedureItem:new("RCRD GND CTL","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/CvrGndCtrl") == 1 end,
	function () set("AirbusFBW/CvrGndCtrl",1) end))
cockpitPrep:addItem(IndirectProcedureItem:new("CVR TEST","PRESS & HOLD 3 SECS",FlowItem.actorPF,3,"cvrtest",
	function () return get("AirbusFBW/CVRTestSwitchAnim") == 1 end,
	function () command_begin("AirbusFBW/CVRTest") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(ProcedureItem:new("EXTERIOR LIGHTS","AS REQUIRED",FlowItem.actorPF,0,true,
	function () kc_macro_lights_preflight() end))
cockpitPrep:addItem(ProcedureItem:new("SEAT BELTS","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/OHPLightSwitches",11) == 1 end,
	function () 
		command_end("AirbusFBW/CVRTest") 
		command_once("toliss_airbus/lightcommands/FSBSignOn") 
	end))
cockpitPrep:addItem(ProcedureItem:new("NO SMOKING","ON/AUTO",FlowItem.actorPF,0,
	function () return get("AirbusFBW/OHPLightSwitches",12) == 2 end,
	function () set_array("AirbusFBW/OHPLightSwitches",12,2) end))
cockpitPrep:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM",FlowItem.actorPF,0,
	function () return get("AirbusFBW/OHPLightSwitches",10) == 1 end,
	function () 
		set_array("AirbusFBW/OHPLightSwitches",10,1) 
	end))
cockpitPrep:addItem(ProcedureItem:new("CABIN PRESSURE LDG ELEV","AUTO",FlowItem.actorPF,0,
	function () return get("AirbusFBW/LandElev") == -3 end,
	function () set("AirbusFBW/LandElev",-3) end))
cockpitPrep:addItem(ProcedureItem:new("PACK FLOW","NORM",FlowItem.actorPF,0,
	function () return get("AirbusFBW/PackFlowSel") == 1 end,
	function () set("AirbusFBW/PackFlowSel",1) end))
cockpitPrep:addItem(ProcedureItem:new("APU FIRE","IN AND GUARDED",FlowItem.actorPF,0,true,
	function () return 
		get("ckpt/fireCenter/cover") == 0 and 
		get("AirbusFBW/FireExOHPArray",0) == 0 end,
	function () 
		set("ckpt/fireCenter/cover",0) 
	end))
cockpitPrep:addItem(IndirectProcedureItem:new("APU FIRE TEST","PRESS",FlowItem.actorPF,6,"apufiretest",
	function () return get("AirbusFBW/FireAgentSwitchAnim",14) == 1 end,
	function () command_begin("AirbusFBW/FireTestAPU") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(ProcedureItem:new("ENG 1&2 FIRE P/B","IN AND GUARDED",FlowItem.actorPF,0,true,
	function () return 
		get("ckpt/fireLeft/cover") == 0 and 
		get("AirbusFBW/ENGFireSwitchArray",0) == 0 and
		get("ckpt/fireRight/cover") == 0 and 
		get("AirbusFBW/ENGFireSwitchArray",1) == 0 end,
	function () 
		command_end("AirbusFBW/FireTestAPU")
		set("ckpt/fireLeft/cover",0) 
		set_array("AirbusFBW/ENGFireSwitchArray",0,0)
		set("ckpt/fireRight/cover",0) 
		set_array("AirbusFBW/ENGFireSwitchArray",1,0)
	end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(IndirectProcedureItem:new("ENG 1 FIRE TEST","PRESS & HOLD",FlowItem.actorPF,10,"eng1firetest",
	function () return get("AirbusFBW/FireAgentSwitchAnim",10) == 1 end,
	function () command_begin("AirbusFBW/FireTestENG1") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(IndirectProcedureItem:new("ENG 2 FIRE TEST","PRESS & HOLD",FlowItem.actorPF,10,"eng2firetest",
	function () return get("AirbusFBW/FireAgentSwitchAnim",11) == 1 end,
	function () 
		command_end("AirbusFBW/FireTestENG1") 
		command_begin("AirbusFBW/FireTestENG2") 
	end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(ProcedureItem:new("A/SKID & N/W STRG SWITCH","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/NWSnAntiSkid") == 1 end,
	function () 
		command_end("AirbusFBW/FireTestENG2") 
		set("AirbusFBW/NWSnAntiSkid",1) 
	end))
cockpitPrep:addItem(ProcedureItem:new("THRUST LEVERS","CHECK IDLE",FlowItem.actorPF,0,
	function () return get("toliss_airbus/joystick/throttle/rawLeverPos",0) == 0 and get("toliss_airbus/joystick/throttle/rawLeverPos",1) == 0 end))
cockpitPrep:addItem(ProcedureItem:new("ENGINE MASTERS 1 & 2","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENG1MasterSwitch") == 0 and get("AirbusFBW/ENG2MasterSwitch") == 0 end,
	function () 
		command_once("toliss_airbus/engcommands/Master1Off")
		command_once("toliss_airbus/engcommands/Master2Off")
	end))
cockpitPrep:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
cockpitPrep:addItem(ProcedureItem:new("GRAVITY GEAR EXTN","STOWED",FlowItem.actorPF,0,
	function () return get("ckpt/gravityGearOn/anim") == 0 end,
	function () set("ckpt/gravityGearOn/anim",0) end))
cockpitPrep:addItem(ProcedureItem:new("XPDR CODE","2000",FlowItem.actorPF,0,
	true,
	function () 
		set("AirbusFBW/XPDR4",2)
		set("AirbusFBW/XPDR3",0)
		set("AirbusFBW/XPDR2",0)
		set("AirbusFBW/XPDR1",0)
	end))
cockpitPrep:addItem(ProcedureItem:new("XPDR SYSTEM 1","SET",FlowItem.actorPF,0,
	function () return get("AirbusFBW/XPDRSystem") == 1 end,
	function () set("AirbusFBW/XPDRSystem",1) end))
cockpitPrep:addItem(ProcedureItem:new("XPDR","STANDBY",FlowItem.actorPF,0,
	function () return get("AirbusFBW/XPDRPower") == 0 end,
	function () set("AirbusFBW/XPDRPower",0) end))
cockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANELS","ON AND SET",FlowItem.actorPF,0,
	function () return 
		get("AirbusFBW/RMP1Switch") == 1 and
		get("AirbusFBW/RMP2Switch") == 1 and
		get("AirbusFBW/RMP3Switch") == 1
	end,
	function () 
		set("AirbusFBW/RMP1Switch",1)
		set("AirbusFBW/RMP2Switch",1)
		set("AirbusFBW/RMP3Switch",1)
	end))
cockpitPrep:addItem(ProcedureItem:new("CREW OXY SUPPLY","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/CrewOxySwitch") == 1 end,
	function () set("AirbusFBW/CrewOxySwitch",1) end))
cockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR SYS","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/WXPowerSwitch") == 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 0) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
		if (get("AirbusFBW/WXPowerSwitch") == 2) then
			command_once("toliss_airbus/WXRadarSwitchLeft")
		end
	end))
cockpitPrep:addItem(ProcedureItem:new("PWS","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/WXSwitchPWS") == 0 end,
	function () set("AirbusFBW/WXSwitchPWS",0) end))
cockpitPrep:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPF,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",3) == 0 and
		get("AirbusFBW/ATA30SwitchAnims",4) == 0
		end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG1Off")
		command_once("toliss_airbus/antiicecommands/ENG2Off")
	end))
cockpitPrep:addItem(ProcedureItem:new("WING-ANTI-ICE","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/ATA30SwitchAnims",2) == 0 end,
	function () command_once("toliss_airbus/antiicecommands/WingOff") end))
cockpitPrep:addItem(ProcedureItem:new("FUEL PUMP SWITCHES","ALL ON",FlowItem.actorPF,0,
	function () return 
		get("AirbusFBW/FuelOHPArray",0) == 1 and
		get("AirbusFBW/FuelOHPArray",1) == 1 and
		get("AirbusFBW/FuelOHPArray",2) == 1 and
		get("AirbusFBW/FuelOHPArray",3) == 1 
	end,
	function () 
		set_array("AirbusFBW/FuelOHPArray",0,1)
		set_array("AirbusFBW/FuelOHPArray",1,1)
		set_array("AirbusFBW/FuelOHPArray",2,1)
		set_array("AirbusFBW/FuelOHPArray",3,1)
		set_array("AirbusFBW/FuelOHPArray",4,1)
		set_array("AirbusFBW/FuelOHPArray",5,1)
	end))
cockpitPrep:addItem(ProcedureItem:new("FUEL MODE SELECTOR","AUTO",FlowItem.actorPF,0,
	function () return get("AirbusFBW/FuelOHPArray",6) == 1 end,
	function ()
		set_array("AirbusFBW/FuelOHPArray",6,1)
		set_array("AirbusFBW/FuelOHPArray",7,0)
	end))
cockpitPrep:addItem(ProcedureItem:new("AFT CARGO HEAT","MID RANGE",FlowItem.actorPF,0,
	function () return get("AirbusFBW/FwdCargoTemp") == 15.5 end,
	function () set("AirbusFBW/FwdCargoTemp",15.5) end))
cockpitPrep:addItem(IndirectProcedureItem:new("CARGO SMOKE TEST","PUSH",FlowItem.actorPF,10,"cargotest",
	function () return get("AirbusFBW/FireAgentSwitchAnim",15) == 1 end,
	function () command_begin("AirbusFBW/FireTestCargo") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
cockpitPrep:addItem(ProcedureItem:new("CLOCK","CHECK/SET",FlowItem.actorPF,0,
	function () return get("AirbusFBW/FireAgentSwitchAnim",15) == 0 end,
	function () command_end("AirbusFBW/FireTestCargo") end))	
cockpitPrep:addItem(ProcedureItem:new("BARO REF","%s|math.ceil(get(\"sim/weather/aircraft/qnh_pas\")/100)",FlowItem.actorBOTH,1,
	function () 
		return kc_macro_test_local_baro()
	end,
	function () 
		kc_macro_set_local_baro()
	end))
cockpitPrep:addItem(ProcedureItem:new("ND RANGE","10",FlowItem.actorPF,0,
	function () return get("AirbusFBW/NDrangeCapt",0) == 0 end,
	function () set("AirbusFBW/NDrangeCapt",0) end))

-- ================ BEFORE PUSHBACK/START ================
-- PARKING BRAKE................................SET (CAPT)
-- CHOCKS.......................................OFF   (PM)
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s
-- APU START PB...............................PRESS   (PM)
-- APU BLEED.....................................ON   (PM)
-- EXT POWER.......................OFF & DISCONNECT (CAPT)
-- PUSHBACK TRUCK.........................REQUESTED (CAPT)
-- PUSHBACK / START CLEARANCE..............OBTAINED (CAPT)
-- BEACON........................................ON   (PF)
-- A/SKID & N/W STRG SWITCH......................ON (CAPT)
-- YELLOW ELEC PUMP.........................TURN ON (CAPT)
-- EXTERNAL DOORS............................CLOSED   (FO)
-- WINDOWS AND DOORS.........................CLOSED (BOTH)
-- THRUST LEVERS...............................IDLE   (PF)
-- ACCU PRESSURE INDICATOR...........CHECK IN GREEN   (PF)
-- TAKEOFF CG/TRIM POS....................___ UNITS   (PF)
-- RUDDER TRIM....................................0   (PF)
-- YELLOW ELEC PUMP.............................OFF (CAPT)
-- =======================================================

local beforePushStart = Procedure:new("BEFORE PUSHBACK AND START","","")
beforePushStart:setFlightPhase(4)
beforePushStart:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_on_push",
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () 
		command_once("toliss_airbus/park_brake_set") 
	end))
beforePushStart:addItem(ProcedureItem:new("CHOCKS","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/Chocks") == 0 end,
	function () set("AirbusFBW/Chocks",0) end))
beforePushStart:addItem(ProcedureItem:new("EXTERNAL DOORS","CLOSED",FlowItem.actorFO,0,
	function () return true end,
	function () command_once("toliss_airbus/door_commands/all_to_mode_close") end))
beforePushStart:addItem(ProcedureItem:new("WINDOWS / DOORS","CHECKED CLOSED",FlowItem.actorBOTH,0,
	function () return
		get("AirbusFBW/CockpitWindowPosition",0) == 0 and
		get("AirbusFBW/CockpitWindowPosition",1) == 0 and
		get("ckpt/door") == 0
	end,
	function () 
		set_array("AirbusFBW/CockpitWindowSwitchPosition",0,1)
		set_array("AirbusFBW/CockpitWindowSwitchPosition",1,1)
		command_once("AirbusFBW/CaptainWindowClose")
		command_once("AirbusFBW/CopilotWindowClose")
		set("ckpt/doorLock",1)
		set("ckpt/door",0)
	end))
beforePushStart:addItem(HoldProcedureItem:new("PUSHBACK TRUCK","REQUESTED",FlowItem.actorCPT,0))
beforePushStart:addItem(HoldProcedureItem:new("PUSH / START CLEARANCE","OBTAIN",FlowItem.actorPF,0,true,nil))
beforePushStart:addItem(ProcedureItem:new("APU MASTER PB","PRESS",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 1 end,
	function () set("AirbusFBW/APUMaster",1) end))
beforePushStart:addItem(SimpleProcedureItem:new("  After master switch, wait 3s"))
beforePushStart:addItem(IndirectProcedureItem:new("APU START PB","PRESS",FlowItem.actorPM,50,"apustart1",
	function () return get("AirbusFBW/APUStarter") > 0 end,
	function () set("AirbusFBW/APUStarter",1) end))
beforePushStart:addItem(ProcedureItem:new("APU BLEED","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/APUBleedSwitch") == 1 end,
	function () set("AirbusFBW/APUBleedSwitch",1) end))
beforePushStart:addItem(HoldProcedureItem:new("EXT POWER","OFF & DISCONNECT",FlowItem.actorCPT,0))
beforePushStart:addItem(ProcedureItem:new("BEACON","ON",FlowItem.actorPF,0,true,
	function () kc_macro_lights_before_start() end))
beforePushStart:addItem(ProcedureItem:new("A/SKID & N/W STRG SWITCH","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/NWSnAntiSkid") == 1 end,
	function () 
		set("AirbusFBW/NWSnAntiSkid",1) 
	end))
-- beforePushStart:addItem(ProcedureItem:new("YELLOW ELEC PUMP","TURN ON",FlowItem.actorPM,0,
	-- function () return get("AirbusFBW/HydYElecMode") > 0 end,
	-- function () 
		-- set_array("AirbusFBW/HydOHPArray",3,1)
	-- end))
beforePushStart:addItem(ProcedureItem:new("THRUST LEVERS","CHECK IDLE",FlowItem.actorPF,0,
	function () return get("toliss_airbus/joystick/throttle/rawLeverPos",0) == 0 and get("toliss_airbus/joystick/throttle/rawLeverPos",1) == 0 end))
beforePushStart:addItem(ProcedureItem:new("ACCU PRESS INDICATOR","CHECK GREEN BAND",FlowItem.actorPM,0,
	function () return get("AirbusFBW/BrakeAccu") > 0.93 end,
	function () -- turn Y pump on until pressure reached
	end))
beforePushStart:addItem(ProcedureItem:new("RUDDER TRIM","0 UNITS (%3.2f)|get(\"AirbusFBW/YawTrimPosition\")",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/YawTrimPosition") == 0 end,
	function () command_once("sim/flight_controls/rudder_trim_center") end))
beforePushStart:addItem(ProcedureItem:new("YELLOW ELEC PUMP","TURN OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/HydYElecMode") == 0 end,
	function () 
		set_array("AirbusFBW/HydOHPArray",3,0)
	end))


-- =============== PUSHBACK & ENGINE START ===============
-- START SEQUENCE 2 THEN 1
-- THRUST LEVERS...............................IDLE   (PF)
-- ENGINE MODE SELECTOR.................IGN / START   (PF)
-- RCRD GND CTL.................................OFF   (PF)
-- START FIRST ENGINE.............STARTING ENGINE _   (PF)
--   1ST ENGINE MASTER SWITCH.....................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- START SECOND ENGINE............STARTING ENGINE _   (PF)
--   2ND ENGINE MASTER SWITCH........................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- PARKING BRAKE................................SET   (PM)
--   When instructed by ground crew after pushback/towing
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY   (PF)
--   LOCKOUT PIN REMOVED.....................VERIFY   (PF)
-- =======================================================

local pushstartProc = Procedure:new("ENGINE START","")
pushstartProc:setFlightPhase(4)
pushstartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
pushstartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorPF,0,
	function () return get("toliss_airbus/joystick/throttle/rawLeverPos",0) == 0 and get("toliss_airbus/joystick/throttle/rawLeverPos",1) == 0 end))
pushstartProc:addItem(IndirectProcedureItem:new("ENGINE MODE SELECTOR","IGN / START",FlowItem.actorCPT,0,"engmdpre",
	function () return get("AirbusFBW/ENGModeSwitch") == 2 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToStart") end))

pushstartProc:addItem(ProcedureItem:new("RCRD GND CTL","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/CvrGndCtrl") == 0 end,
	function () set("AirbusFBW/CvrGndCtrl",0) end))
pushstartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/ENG2MasterSwitch") == 1
		else 
			return get("AirbusFBW/ENG1MasterSwitch") == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_once("toliss_airbus/engcommands/Master2On")
			kc_speakNoText(0,"starting engine 2")
		else 
			command_once("toliss_airbus/engcommands/Master1On")
			kc_speakNoText(0,"starting engine 1")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/ENGN2Speed",1) > 8 
		else 
			return get("AirbusFBW/ENGN2Speed",0) > 8 
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE N1","INCREASING",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/anim/ENGN1Speed",1) > 5 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",0) > 5 
		end
	end,
	function () kc_speakNoText(0,"N2 increasing") end))
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE STARTED","ANNOUNCE",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/anim/ENGN1Speed",1) >= 18.8 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",0) >= 18.8 
		end 
	end,
	function () kc_speakNoText(0,"N1 increasing") end))
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE AVAIL","ANNOUNCE",FlowItem.actorCPT,0,true,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_speakNoText(0,"engine 2 available")  
		else 
			kc_speakNoText(0,"engine 1 available")  
		end 
	end))
pushstartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorFO,0,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/ENG1MasterSwitch") == 1
		else 
			return get("AirbusFBW/ENG2MasterSwitch") == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_once("toliss_airbus/engcommands/Master1On")
			kc_speakNoText(0,"starting engine 1")
		else 
			command_once("toliss_airbus/engcommands/Master2On")
			kc_speakNoText(0,"starting engine 2")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/ENGN2Speed",0) > 8 
		else 
			return get("AirbusFBW/ENGN2Speed",1) > 8 
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("2ND ENGINE N1","INCREASING",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/anim/ENGN1Speed",0) > 5 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",1) > 5 
		end 
	end,
	function () kc_speakNoText(0,"N2 increasing") end))
pushstartProc:addItem(ProcedureItem:new("2ND ENGINE STARTED","ANNOUNCE",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("AirbusFBW/anim/ENGN1Speed",0) >= 18.8 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",1) >= 18.8 
		end 
	end,
	function () kc_speakNoText(0,"N1 increasing") end))	
pushstartProc:addItem(ProcedureItem:new("2ND ENGINE AVAIL","ANNOUNCE",FlowItem.actorCPT,0,true,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_speakNoText(0,"engine 1 available")  
		else 
			kc_speakNoText(0,"engine 2 available")  
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () 
		if get("AirbusFBW/ParkBrake") ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))

-- ===================== AFTER START =====================
-- CLOCK ET...................................START (CAPT)
-- ENGINE MODE SELECTOR......................NORMAL   (PF)
-- APU BLEED....................................OFF   (PF)
-- GROUND SPOILERS..............................ARM   (PM)
-- RUDDER TRIM.................................ZERO   (PM)
-- FLAPS...........................TAKEOFF POSITION   (PM)
-- TAKEOFF CG/TRIM POS..............SET FOR TAKEOFF (BOTH)
-- WING ANTI-ICE........................AS REQUIRED   (PF)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PF)
-- FLIGHT CONTROLS CHECK...................AILERONS (BOTH)
-- FLIGHT CONTROLS CHECK..................ELEVATORS (BOTH)
-- FLIGHT CONTROLS CHECK.....................RUDDER (BOTH)
-- =======================================================

local afterStartProc = Procedure:new("AFTER START ITEMS","","")
afterStartProc:setFlightPhase(5)
afterStartProc:addItem(ProcedureItem:new("CLOCK ET","START",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/ClockETSwitch") == 0 end,
	function () set("AirbusFBW/ClockETSwitch",0) end))
afterStartProc:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
afterStartProc:addItem(ProcedureItem:new("APU BLEED","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/APUBleedSwitch") == 0 end,
	function () set("AirbusFBW/APUBleedSwitch",0) end))
afterStartProc:addItem(ProcedureItem:new("GROUND SPOILERS","ARMED",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == -0.5 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",-0.5)  end))
afterStartProc:addItem(ProcedureItem:new("RUDDER TRIM","0 UNITS (%3.2f)|get(\"AirbusFBW/YawTrimPosition\")",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/YawTrimPosition") == 0 end,
	function () command_once("sim/flight_controls/rudder_trim_center") end))
afterStartProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")-1] end,
	function () set("sim/cockpit2/controls/flap_ratio",sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")-1]) end)) 
afterStartProc:addItem(ProcedureItem:new("TAKEOFF CG/TRIM POS","%4.6f UNITS (%4.6f)|math.floor(get(\"AirbusFBW/PitchTrimPosition\")*100)/100|math.floor(activeBriefings:get(\"takeoff:elevatorTrim\")*100)/100",FlowItem.actorCPT,0,
	function () return math.floor(get("AirbusFBW/PitchTrimPosition")*100)/100 == math.floor(activeBriefings:get("takeoff:elevatorTrim")*100)/100 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",2) == 1 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/WingOn")
	end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",2) == 0
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/WingOff")
	end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",0) == 0 and
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",1) == 0 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG2Off")
		command_once("toliss_airbus/antiicecommands/ENG1Off")
	end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",0) == 1 and
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",1) == 1 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG2On")
		command_once("toliss_airbus/antiicecommands/ENG1On")
	end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartProc:addItem(ProcedureItem:new("APU MASTER","OFF",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 0 end,
	function () set("AirbusFBW/APUMaster",0) end))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","AILERONS",FlowItem.actorBOTH,0,"fccheck1",
	function () return get("sim/flightmodel2/wing/aileron1_deg",6) > 20 end))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","ELEVATORS",FlowItem.actorBOTH,0,"fccheck2",
	function () return get("sim/flightmodel2/wing/elevator1_deg",8) > 14 end))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","RUDDER",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg",10) > 29 end))

-- ================= BEFORE TAXI PROCEDURE ===============
-- AUTO BRAKES..................................MAX   (PM) 
-- ATC CODE/MODE........................CONFIRM/SET   (PM) 
-- ENGINE MODE SELECTOR.................AS REQUIRED   (PM) 
-- WEATHER RADAR.............................ON/ALL   (PF)
-- PREDICTIVE WINDSHEAR.....................AUTO/ON   (PM) 
-- TERRAIN ON ND........................AS REQUIRED   (PM) 
-- FINAL CHECK TO MEMO................CHECK NO BLUE   (PM)
-- TAXI / TURN OFF LIGHT.........................ON   (PF)
-- TCAS.......................................TA/RA   (PF)
-- PARKING BRAKE..........OFF – BRAKE PRESSURE ZERO   (PF)
-- BRAKE PEDALS.........PRESS & CALL: “BRAKE CHECK”   (PF)
-- =======================================================

local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE","","")
beforeTaxiProc:addItem(ProcedureItem:new("AUTO BRAKES","MAX",FlowItem.actorFO,0,
	function () return get("AirbusFBW/AutoBrkMax") == 1 end,
	function () command_once("AirbusFBW/AbrkMax") end))
beforeTaxiProc:addItem(HoldProcedureItem:new("ATC CODE/MODE","CONFIRM/SET",FlowItem.actorCPT,0))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
beforeTaxiProc:addItem(ProcedureItem:new("WEATHER RADAR","ON/ALL",FlowItem.actorPM,0,
	function () return get("AirbusFBW/WXPowerSwitch") ~= 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 1) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
	end))
beforeTaxiProc:addItem(ProcedureItem:new("PREDICTIVE WINDSHEAR","AUTO/ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/WXSwitchPWS") == 2 end,
	function () set("AirbusFBW/WXSwitchPWS",2) end))
beforeTaxiProc:addItem(ProcedureItem:new("TERRAIN ON ND","AS REQUIRED",FlowItem.actorPF,0,
	function () return get("AirbusFBW/TerrainSelectedND1") == 1 end,
	function () set("AirbusFBW/TerrainSelectedND1",1) end))
beforeTaxiProc:addItem(HoldProcedureItem:new("FINAL CHECK TO MEMO","CHECK NO BLUE",FlowItem.actorCPT,0))
beforeTaxiProc:addItem(HoldProcedureItem:new("TAXI CLEARANCE","OBTAINED",FlowItem.actorCPT,0))
beforeTaxiProc:addItem(ProcedureItem:new("TAXI / TURN OFF LIGHT","ON",FlowItem.actorFO,0,
	function () return get("ckpt/oh/taxiLight/anim") == 1 end,
	function () kc_macro_lights_before_taxi() end))
beforeTaxiProc:addItem(ProcedureItem:new("TCAS","TA/RA",FlowItem.actorPM,0,
	function () return get("AirbusFBW/XPDRPower") == 4 end,
	function () set("AirbusFBW/XPDRPower",4) end))
beforeTaxiProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ParkBrake") == 0 end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("BRAKE PEDALS","PRESS & CALL BRAKE CHECK",FlowItem.actorFO,0,"braketest",
	function () return get("AirbusFBW/BrakePedalAnim",0) > 0 end))
	
-- =============== BEFORE TAKEOFF PROCEDURE ==============
-- FINAL CHECK TO CONFIG.......................TEST   (PF)
-- TCAS.................................TA OR TA/RA   (PM)
-- EXTERIOR LIGHTS......................STROBE – ON   (PF)
-- PACKS................................AS REQUIRED   (PM)
-- SLIDING TABLE.............................STOWED (BOTH)
-- CABIN CREW................................ADVISE   (PM)
-- CHRONO.....................................START   (PF)
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE","runway entry","")
beforeTakeoffProc:setFlightPhase(7)
beforeTaxiProc:addItem(IndirectProcedureItem:new("FINAL CHECK TO CONFIG","TEST",FlowItem.actorPF,0,"toconfig",
	function () return get("AirbusFBW/ATA31ECPAnimations",25) > 0 end,
	function () command_once("AirbusFBW/TOConfigPress") end))
beforeTakeoffProc:addItem(ProcedureItem:new("XPDR","TA/RA",FlowItem.actorPM,0,
	function () return get("AirbusFBW/XPDRPower") == 4 end,
	function () set("AirbusFBW/XPDRPower",4) end))
beforeTakeoffProc:addItem(ProcedureItem:new("TCAS","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/XPDRTCASMode") == 1 end,
	function () set("AirbusFBW/XPDRTCASMode",1) end))
beforeTakeoffProc:addItem(ProcedureItem:new("EXTERIOR LIGHTS","ON FOR TAKEOFF",FlowItem.actorPM,0,
	function () return get("ckpt/oh/strobeLight/anim") > 0 end,
	function () kc_macro_lights_for_takeoff() end))
beforeTakeoffProc:addItem(ProcedureItem:new("PACKS","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/Pack1Switch") > 0 and get("AirbusFBW/Pack2Switch") > 0 end,
	function () kc_macro_packs_takeoff() end,
	function () return activeBriefings:get("takeoff:packs") == 2 end))
beforeTakeoffProc:addItem(ProcedureItem:new("PACKS","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/Pack1Switch") == 0 and get("AirbusFBW/Pack2Switch") == 0 end,
	function () kc_macro_packs_takeoff() end,
	function () return activeBriefings:get("takeoff:packs") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("SLIDING TABLE","STOWED",FlowItem.actorBOTH,0,
	function () return get("AirbusFBW/TrayTableAnimation",0) == 0 and get("AirbusFBW/TrayTableAnimation",1) == 0 end,
	function () 
		command_once("AirbusFBW/CaptTableIn")
		command_once("AirbusFBW/CopilotTableIn")
	end))
beforeTakeoffProc:addItem(IndirectProcedureItem:new("CABIN CREW","ADVISED",FlowItem.actorPM,0,"crewadvised",
	function () return true end,
	function () 
		command_once("AirbusFBW/purser/all")
	end))
beforeTakeoffProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorPF,0,
	function () return get("AirbusFBW/ChronoTimeND1") > 0 end,
	function () 
		if get("AirbusFBW/ChronoTimeND1") == 0 then
			command_once("AirbusFBW/CaptChronoButton")
		end
	end))	

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ============
-- NOSE LIGHT....................................ON   (PF)
-- TURN OFF LIGHTS...............................ON   (PF)
-- LAND LIGHTS...................................ON   (PF)
-- == Gear Up
-- LANDING GEAR..................................UP   (PM)
-- == AP1
-- AP1...........................................ON   (PF)
-- FLAPS...................................CHECK UP   (PF)
-- == Climb
-- TERRAIN ON ND................................OFF   (PM) 
-- ENGINE ANTI-ICE..............................OFF   (PF)
-- WING-ANTI-ICE................................OFF   (PF)
-- ND RANGE.....................................160
-- GROUND SPOILERS...........................DISARM   (PF)
-- Whatever comes first
-- TRANSITION ALTITUDE.............ANNOUNCE REACHED   (PM)
-- ALTIMETERS...................................STD (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...........................RETRACT   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF   (PM)
-- BELTS SWITCH.................................OFF   (PM)
-- =======================================================

local takeoffProc = Procedure:new("TAKEOFF & INITIAL CLIMB","takeoff")
takeoffProc:setFlightPhase(8)
takeoffProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_for_takeoff() 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in
	end))

local gearUpProc = Procedure:new("GEAR UP","")
gearUpProc:setFlightPhase(-8)
gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return get("ckpt/gearHandle") == 1 end,
	function () 
		command_once("sim/flight_controls/landing_gear_up") 
		kc_speakNoText(0,"gear coming up") 
	end))
	
local AP1Proc = Procedure:new("AP1","")
AP1Proc:setFlightPhase(-8)
AP1Proc:addItem(IndirectProcedureItem:new("AP1","ON",FlowItem.actorPM,0,"ap1_on_to",
	function () return get("AirbusFBW/AP1Engage") == 1 end,
	function () 
		if get("AirbusFBW/AP1Engage") == 0 then
			command_once("toliss_airbus/ap1_push") 
		end
	end))
AP1Proc:addItem(ProcedureItem:new("FLAPS","CHECK UP",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == 0 end))

-- CLIMB PROCEDURE


local climbProc = Procedure:new("CLIMB","")
climbProc:setFlightPhase(-9)
climbProc:addItem(ProcedureItem:new("TERRAIN ON ND","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/TerrainSelectedND1") == 0 end,
	function () set("AirbusFBW/TerrainSelectedND1",0) end))
climbProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPF,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",3) == 0 and
		get("AirbusFBW/ATA30SwitchAnims",4) == 0
		end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG1Off")
		command_once("toliss_airbus/antiicecommands/ENG2Off")
	end))
climbProc:addItem(ProcedureItem:new("WING-ANTI-ICE","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/ATA30SwitchAnims",2) == 0 end,
	function () command_once("toliss_airbus/antiicecommands/WingOff") end))
climbProc:addItem(ProcedureItem:new("ND RANGE","160",FlowItem.actorPF,0,
	function () return get("AirbusFBW/NDrangeCapt") == 4 end,
	function () set("AirbusFBW/NDrangeCapt",4) end))
climbProc:addItem(ProcedureItem:new("GROUND SPOILERS","DOWN",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))

-- ================= DESCENT PROCEDURE ===================
-- KPCREW BRIEFING WINDOW......................OPEN   (PF)
-- KPCREW APPROACH BRIEFING..............FILLED OUT   (PF)
-- MCDU...................PF=PROG/PERF DES,PM=F-PLN   (PF)
-- AUTO BRAKES..........................AS REQUIRED   (PF)
-- WING ANTI-ICE........................AS REQUIRED   (PF)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PF)
-- LANDING SYSTEM................................ON   (PM)
-- XPDR.........................................BLW   (PM)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................SET   (PM)
-- SEAT BELTS....................................ON   (PM)
-- =======================================================

local descentProc = Procedure:new("DESCENT PROCEDURE","","")
descentProc:setFlightPhase(11)
descentProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () 
		kc_wnd_brief_action = 1 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities		
	end))
descentProc:addItem(HoldProcedureItem:new("KPCREW APPROACH BRIEFING","FILLED OUT",FlowItem.actorCPT))
descentProc:addItem(HoldProcedureItem:new("MCDU","PF=PROG/PERF DES,PM=F-PLN",FlowItem.actorBOTH))
descentProc:addItem(ProcedureItem:new("AUTO BRAKES","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/AutoBrkMax") == 1 or
		get("AirbusFBW/AutoBrkMed") == 1 or
		get("AirbusFBW/AutoBrkLo") == 1
	end,
	function () kc_macro_set_autobrake() end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",2) == 1 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/WingOn")
	end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",2) == 0
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/WingOff")
	end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",0) == 0 and
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",1) == 0 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG2Off")
		command_once("toliss_airbus/antiicecommands/ENG1Off")
	end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",0) == 1 and
		get("sim/cockpit2/ice/ice_inlet_heat_on_per_engine",1) == 1 
	end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG2On")
		command_once("toliss_airbus/antiicecommands/ENG1On")
	end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
descentProc:addItem(ProcedureItem:new("LANDING SYSTEM","ON",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ILSonCapt") == 1
	end,
	function () 
		set("AirbusFBW/ILSonCapt",1)
	end))
descentProc:addItem(ProcedureItem:new("XPDR","BLW",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/XPDRTCASAltSelect") == 2
	end,
	function () 
		set("AirbusFBW/XPDRTCASAltSelect",2)
	end))
	
-- ================= LANDING PROCEDURE ===================
-- TERRAIN ON ND.................................ON   (PF)
-- LANDING LIGHTS................................ON   (PF)
-- APPROACH PHASE..........................ACTIVATE   (PF)
-- GROUND SPOILERS............................ARMED   (PF)
-- XPDR...........................................N   (PF)
-- =======================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","")
landingProc:setFlightPhase(12)
landingProc:addItem(ProcedureItem:new("TERRAIN ON ND","ON",FlowItem.actorPF,0,
	function () return get("AirbusFBW/TerrainSelectedND1") == 1 end,
	function () set("AirbusFBW/TerrainSelectedND1",1) end))
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPM,0,
	function () return get("sim/cockpit/electrical/landing_lights_on") == 1 end,
	function () kc_macro_lights_approach() end))
landingProc:addItem(HoldProcedureItem:new("APPROACH PHASE","ACTIVATE",FlowItem.actorPM,0))
landingProc:addItem(ProcedureItem:new("GROUND SPOILERS","ARMED",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == -0.5 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",-0.5)  end))
landingProc:addItem(ProcedureItem:new("XPDR","N",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/XPDRTCASAltSelect") == 1
	end,
	function () 
		set("AirbusFBW/XPDRTCASAltSelect",1)
	end))

-- ============== AFTER LANDING PROCEDURE ================
-- CHRONO & ET.................................STOP  (CPT)
-- GROUND SPOILERS...........................DISARM   (PF)
-- EXTERNAl LIGHTS......................AS REQUIRED   (PF)
-- WEATHER RADAR................................OFF   (PM)
-- PWS..........................................OFF   (PM)
-- ENGINE MODE SELECTOR........................NORM   (PM)
-- FLAPS....................................RETRACT   (PM)
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PM)
-- WING ANTI-ICE........................AS REQUIRED   (PM)
-- LANDING SYSTEM...............................OFF   (PF)
-- TAXI LIGHTS..................................OFF   (PF)
-- TERRAIN ON ND................................OFF   (PF)
-- =======================================================

local afterLandingProc = Procedure:new("AFTER LANDING PROCEDURE","","")
afterLandingProc:setFlightPhase(15)
afterLandingProc:addItem(ProcedureItem:new("CHRONO","STOP",FlowItem.actorPF,0,true,
	function () 
		if get("AirbusFBW/ChronoTimeND1") > 0 then
			command_once("AirbusFBW/CaptChronoButton")
		end
	end))	
afterLandingProc:addItem(ProcedureItem:new("GROUND SPOILERS","DISARM",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAl LIGHTS","AS RQUIRED",FlowItem.actorPM,0,
	function () return get("sim/cockpit/electrical/landing_lights_on") == 0 end,
	function () kc_macro_lights_cleanup() end))
afterLandingProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/WXPowerSwitch") == 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 0) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
		if (get("AirbusFBW/WXPowerSwitch") == 2) then
			command_once("toliss_airbus/WXRadarSwitchLeft")
		end
	end))
afterLandingProc:addItem(ProcedureItem:new("PWS","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/WXSwitchPWS") == 0 end,
	function () set("AirbusFBW/WXSwitchPWS",0) end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS","RETRACT",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == 0 end,
	function () set("sim/cockpit2/controls/flap_ratio",0) end))
afterLandingProc:addItem(ProcedureItem:new("APU MASTER PB","PRESS",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 1 end,
	function () set("AirbusFBW/APUMaster",1) end))
afterLandingProc:addItem(SimpleProcedureItem:new("  After master switch, wait 3s"))
afterLandingProc:addItem(IndirectProcedureItem:new("APU START PB","PRESS",FlowItem.actorPM,12,"apustart1",
	function () return get("AirbusFBW/APUStarter") > 0 end,
	function () set("AirbusFBW/APUStarter",1) end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",3) == 0 and
		get("AirbusFBW/ATA30SwitchAnims",4) == 0
		end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG1Off")
		command_once("toliss_airbus/antiicecommands/ENG2Off")
	end))
afterLandingProc:addItem(ProcedureItem:new("WING-ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ATA30SwitchAnims",2) == 0 end,
	function () command_once("toliss_airbus/antiicecommands/WingOff") end))
afterLandingProc:addItem(ProcedureItem:new("LANDING SYSTEM","OFF",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/ILSonCapt") == 0
	end,
	function () 
		set("AirbusFBW/ILSonCapt",0)
	end))
afterLandingProc:addItem(HoldProcedureItem:new("TAXI LIGHTS","COMMAND OFF",FlowItem.actorPF,0))
afterLandingProc:addItem(ProcedureItem:new("TAXI LIGHTS","OFF",FlowItem.actorPF,0,
	function () return get("ckpt/oh/taxiLight/anim") == 0 end,
	function () 
		command_once("toliss_airbus/lightcommands/NoseLightDown")
		command_once("toliss_airbus/lightcommands/NoseLightDown")
	end))
afterLandingProc:addItem(ProcedureItem:new("TERRAIN ON ND","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/TerrainSelectedND1") == 0 end,
	function () set("AirbusFBW/TerrainSelectedND1",0) end))
afterLandingProc:addItem(ProcedureItem:new("TCAS","AUTO",FlowItem.actorPM,0,
	function () return get("AirbusFBW/XPDRTCASMode") == 0 end,
	function () set("AirbusFBW/XPDRTCASMode",0) end))


-- ================== PARKING PROCEDURE ==================
-- XPDR........................................STBY   (PM)
-- GROUND SPOILERS...........................DISARM   (PF)
-- PARKING BRAKES................................ON   (PF)
-- APU BLEED.....................................ON   (PM)
-- ENGINE MASTER SWITCHES.......................OFF   (PF) 
-- SEAT BELTS...................................OFF   (PF)
-- FUEL PUMPS...................................OFF   (PM)
-- CHOCKS..................................IN PLACE   (PF)
-- EXT POWER..............................CONNECTED   (PM)
-- EXT POWER.....................................ON   (PM)
-- APU MASTER PB..............................PRESS   (PM)
-- APU BLEED....................................OFF   (PF)
-- CLOCK ET....................................STOP   (PF)
-- FCU........................................RESET   (PF)
-- =======================================================

local parkingProc = Procedure:new("PARKING PROCEDURE","","")
parkingProc:setFlightPhase(17)
parkingProc:addItem(ProcedureItem:new("XPDR","STBY",FlowItem.actorPF,0,
	function () return get("AirbusFBW/XPDRPower") == 0 end,
	function () set("AirbusFBW/XPDRPower",0) end))	
parkingProc:addItem(ProcedureItem:new("GROUND SPOILERS","DISARM",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))
parkingProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_on_push",
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () 
		command_once("toliss_airbus/park_brake_set") 
	end))
parkingProc:addItem(IndirectProcedureItem:new("APU BLEED","ON",FlowItem.actorPF,0,"parkapubleedon",
	function () return get("AirbusFBW/APUBleedSwitch") == 1 end,
	function () set("AirbusFBW/APUBleedSwitch",1) end))
parkingProc:addItem(HoldProcedureItem:new("ENGINES","SHUTDOWN",FlowItem.actorPM,0))
parkingProc:addItem(ProcedureItem:new("ENGINE MASTERS 1","OFF",FlowItem.actorPM,2,
	function () return get("AirbusFBW/ENG1MasterSwitch") == 0 end,
	function () 
		command_once("toliss_airbus/engcommands/Master1Off")
	end))
parkingProc:addItem(ProcedureItem:new("ENGINE MASTERS 2","OFF",FlowItem.actorPM,2,
	function () return get("AirbusFBW/ENG2MasterSwitch") == 0 end,
	function () 
		command_once("toliss_airbus/engcommands/Master2Off")
		kc_macro_lights_arrive_parking()
	end))
parkingProc:addItem(ProcedureItem:new("SEAT BELT SIGNS","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/OHPLightSwitches",11) == 0 end,
	function () 
		command_once("toliss_airbus/lightcommands/FSBSignOff") 
	end))
parkingProc:addItem(ProcedureItem:new("FUEL PUMPS","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/FuelOHPArray",0) == 0 end,
	function () kc_macro_fuelpumps_off()  end))
parkingProc:addItem(ProcedureItem:new("CHOCKS","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/Chocks") == 1 end,
	function () set("AirbusFBW/Chocks",1) end))
parkingProc:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorPM,2,
	function () return get("AirbusFBW/EnableExternalPower") == 1 end,
	function () set("AirbusFBW/EnableExternalPower",1) end))
parkingProc:addItem(ProcedureItem:new("EXT POWER","ON",FlowItem.actorPM,6,
	function () return get("AirbusFBW/ExtPowOHPArray",0) == 1 end,
	function () command_once("toliss_airbus/eleccommands/ExtPowOn") end))
parkingProc:addItem(ProcedureItem:new("APU MASTER PB","PRESS",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 0 end,
	function () set("AirbusFBW/APUMaster",0) end))
parkingProc:addItem(ProcedureItem:new("APU BLEED","OFF",FlowItem.actorPF,0,
	function () return get("AirbusFBW/APUBleedSwitch") == 0 end,
	function () set("AirbusFBW/APUBleedSwitch",0) end))
parkingProc:addItem(ProcedureItem:new("CLOCK ET","STOP",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/ClockETSwitch") == 1 end,
	function () set("AirbusFBW/ClockETSwitch",1) end))
parkingProc:addItem(ProcedureItem:new("FCU","RESET",FlowItem.actorFO,0,
	function () return get("AirbusFBW/FD1Engage") == 0 end,
	function () kc_macro_mcp_after_landing() end))


-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		getActiveSOP():setActiveFlowIndex(1)
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)

turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
		getActiveSOP():setActiveFlowIndex(2)
	end))

-- === Recover Takeoff modes
local recoverTakeoff = State:new("Recover Takeoff","","")
recoverTakeoff:setFlightPhase(8)
recoverTakeoff:addItem(ProcedureItem:new("Recover","SET","SYS",0,true,
	function () 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in	--
	end))

-- === Recover Approach modes
local recoverApproach = State:new("Recover Approach","","")
recoverApproach:setFlightPhase(11)
recoverApproach:addItem(ProcedureItem:new("Recover","SET","SYS",0,true,
	function () 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities	
	end))

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

-- kc_procvar_initialize_bool("apustart", false) -- start apu
kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("aftertakeoff", false) -- triggers after takeoff activities by FO
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		-- if kc_procvar_get("apustart") == true then 
			-- kc_bck_apustart("apustart")
		-- end
		if kc_procvar_get("above10k") == true then 
			kc_bck_climb_through_10k("above10k")
		end
		if kc_procvar_get("attransalt") == true then 
			kc_bck_transition_altitude("attransalt")
		end
		if kc_procvar_get("aftertakeoff") == true then 
			kc_bck_after_takeoff_items("aftertakeoff")
		end
		if kc_procvar_get("below10k") == true then 
			kc_bck_descend_through_10k("below10k")
		end
		if kc_procvar_get("attranslvl") == true then 
			kc_bck_transition_level("attranslvl")
		end
	end))

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(prelCockpitPrep)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(cockpitPrep)
activeSOP:addProcedure(beforePushStart)
activeSOP:addProcedure(pushProc)
activeSOP:addProcedure(pushstartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(beforeTaxiProc)
activeSOP:addProcedure(TaxiProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(takeoffProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(AP1Proc)
activeSOP:addProcedure(climbProc)
activeSOP:addProcedure(descentProc)
activeSOP:addProcedure(landingProc)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(parkingProc)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)
activeSOP:addState(recoverTakeoff)
activeSOP:addState(recoverApproach)


function getActiveSOP()
	return activeSOP
end

return SOP_A20N