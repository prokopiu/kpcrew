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

-- ============ COCKPIT CHECK PROCEDURE ============
-- ==== AIRCRAFT SETUP
-- ENGINE MASTERS 1 & 2.........................OFF   (PM)
-- ENGINE MODE SELECTOR........................NORM   (PM)
-- WEATHER RADAR................................OFF   (PM)
-- LANDING GEAR LEVER..........................DOWN   (PM)
-- BOTH WIPER SELECTORS.........................OFF   (PM)

-- ==== BATTERY CHECK & EXTERNAL POWER
-- BAT 1 / BAT 2............CHECK BOTH ABOVE 25.5 V   (PM)
-- BAT 1 / BAT 2.................................ON   (PM)
-- EXT POWER..............................CONNECTED   (PM)
-- EXT POWER SWITCH..............................ON   (PM)
-- COCKPIT LIGHTS.......................AS REQUIRED   (PM)

-- ==== FCTL
-- FLAPS.............................CHECK POSITION   (PM)
-- SPEED BRAKE LEVER.....CHECK RETRACTED & DISARMED   (PM)
-- CHOCKS........................................ON   (PM)
-- PARKING BRAKE.................................ON   (PM)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (PM)
--  If not use Y elec pump"
-- RADIO MANAGEMENT PANELS...............ON AND SET   (PM)
-- AUDIO CONTROL PANEL..................AS REQUIRED   (PM)
-- ADIRS L,R,C..................................NAV   (PF)
-- =======================================================

local prelCockpitPrep = Procedure:new("COCKPIT CHECKS","performing cockpit checks","Setup finished")
prelCockpitPrep:setFlightPhase(2)
prelCockpitPrep:setResize(true)
prelCockpitPrep:addItem(SimpleProcedureItem:new("==== AIRCRAFT SETUP"))
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MASTERS 1 & 2","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENG1MasterSwitch") == 0 and get("AirbusFBW/ENG2MasterSwitch") == 0 end,
	function () 
		command_once("toliss_airbus/engcommands/Master1Off")
		command_once("toliss_airbus/engcommands/Master2Off")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
prelCockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/WXPowerSwitch") == 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 0) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
		if (get("AirbusFBW/WXPowerSwitch") == 2) then
			command_once("toliss_airbus/WXRadarSwitchLeft")
		end
	end))
prelCockpitPrep:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorPM,0,
	function () return get("ckpt/gearHandle") == 1 end,
	function () command_once("sim/flight_controls/landing_gear_down") end))
prelCockpitPrep:addItem(ProcedureItem:new("BOTH WIPER SELECTORS","OFF",FlowItem.actorPM,0,
	function () return get("AirbusFBW/LeftWiperSwitch") == 0 and get("AirbusFBW/RightWiperSwitch") == 0 end,
	function () 
		set("AirbusFBW/LeftWiperSwitch",0) 
		set("AirbusFBW/RightWiperSwitch",0)
	end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== BATTERY CHECK & EXTERNAL POWER"))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","CHECK BOTH ABOVE 25.5 V",FlowItem.actorPM,0,
	function () return get("AirbusFBW/BatVolts",0) > 25.5 and get("AirbusFBW/BatVolts",1) > 25.5 end))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","ON",FlowItem.actorPM,1,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		command_once("toliss_airbus/eleccommands/Bat1On")
		command_once("toliss_airbus/eleccommands/Bat2On")
	end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorPM,0,
	function () return get("AirbusFBW/EnableExternalPower") == 1 end,
	function () set("AirbusFBW/EnableExternalPower",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ExtPowOHPArray",0) == 1 end,
	function () command_once("toliss_airbus/eleccommands/ExtPowOn") end))

-- prelCockpitPrep:addItem(SimpleProcedureItem:new("==== LIGHT UP"))
prelCockpitPrep:addItem(ProcedureItem:new("COCKPIT LIGHTS","AS REQUIRED",FlowItem.actorPM,0,true,
	function () 
		kc_macro_lights_preflight()
	end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== FCTL"))
prelCockpitPrep:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == 0 end,
	function () set("sim/cockpit2/controls/flap_ratio",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE","CHECK RETRACTED & DISARMED",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 and get("AirbusFBW/SpdBrakeDeployed") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))

-- prelCockpitPrep:addItem(SimpleProcedureItem:new("==== BRAKES"))
prelCockpitPrep:addItem(ProcedureItem:new("CHOCKS","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/Chocks") == 1 end,
	function () set("AirbusFBW/Chocks",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKE","ON",FlowItem.actorPM,0,
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () command_once("toliss_airbus/park_brake_set") end))
prelCockpitPrep:addItem(ProcedureItem:new("ACCU PRESS INDICATOR","CHECK GREEN BAND",FlowItem.actorPM,0,
	function () return get("AirbusFBW/AccuNeedle") > 0.95 end))
prelCockpitPrep:addItem(SimpleProcedureItem:new("  If not use Y elec pump"))

prelCockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANELS","ON AND SET",FlowItem.actorPM,0,
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
prelCockpitPrep:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","AS REQUIRED",FlowItem.actorPM,0,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("ADIRS L,R,C","NAV",FlowItem.actorPF,0,
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

-- ================= COCKPIT PREPARATION =================
-- == Overhead Left Column
-- CREW OXY SUPPLY...............................ON   (PF)  
-- RCRD GND CTL..................................ON   (PF)  
-- CVR TEST.....................PRESS & HOLD 3 SECS   (PF)  
-- GPWS.............................NO WHITE LIGHTS   (PF)
-- EVAC SWITCH..........................CAPT & PURS   (PF)  
-- ADIRS L,R,C..................................NAV   (PF)
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.

-- == Overhead Center Column
-- ==== Lights panel
-- SEAT BELTS....................................ON   (PF)
-- NO SMOKING...............................ON/AUTO   (PF)
-- EMERGENCY EXIT LIGHT.........................ARM   (PF)
-- ANNUNCIATOR LIGHT...........................TEST   (PF)

-- ==== ANTI-ICE & PRESSURIZATION
-- WING-ANTI-ICE................................OFF   (PF)
-- ENGINE ANTI-ICE..............................OFF   (PF)
-- PROBE/WINDOW HEAT.....................CHECK AUTO   (PF)
-- CABIN PRESSURE LDG ELEV.....................AUTO   (PF)
--   ECAM PRESS page check LDG ELEV being AUTO

-- ==== AIR COND Panel
-- APU BLEED............................AS REQUIRED   (PF)
-- CROSSBLEED..................................AUTO   (PF)
-- PACK FLOW SELECTOR.......................AS RQRD   (PF)

-- ==== Electrical Panel
-- NO WHITE LIGHTS..........................CHECKED   (PF)
-- BAT 1 PB & BAT 2 PB..................OFF then ON   (PF)
--   This initiates a charging cycle of the batts.
--   10 s after setting all BAT PB ON, check on the
--   ECAM ELEC page that the current charge of the
--   battery is below 60 A, and is decreasing.
-- 
-- ==== FUEL Panel
-- FUEL PUMP SWITCHES........................ALL ON   (PF)
-- FUEL MODE SELECTOR..........................AUTO   (PF)
--
-- ==== FIRE Panel
-- ENG 1 and 2 FIRE TEST.............PRESS and HOLD   (PF)
--   (check for 7 items)
-- APU FIRE..........................IN and GUARDED   (PF)
-- APU FIRE TEST..............................PRESS   (PF)
--
-- == Overhead Left Column
-- ==== CARGO Panel
-- AFT CARGO HEAT.........................MID RANGE   (PF)
-- CARGO SMOKE TEST............................PUSH   (PF)
-- ====
-- THIRD AUDIO CONTROL PANEL.......PA knob – Recept   (PF)
--   - This allows cabin attendant announcements to
--     be recorded on the CVR.
--   - Set volume at or above medium range.

-- == Central Panel
-- STANDBY INSTR (ISIS).......................CHECK   (PF)
--   Indications normal – no flags / Set QNH
-- CLOCK..................................CHECK/SET   (PF)
--   Check time is UTC, switch to GPS
-- A/SKID & N/W STRG SWITCH......................ON   (PF)

-- == Pedestal
-- RMP (Radio Management Panel)............ON & SET   (PF)
-- ACP (Audio Control Panel)............AS REQUIRED   (PF)
-- WEATHER RADAR................................OFF   (PF)
-- PWS..........................................OFF   (PF)
-- COCKPIT DOOR..............................NORMAL   (PF)
-- SWITCHING PANEL...........................NORMAL   (PF)
-- THRUST LEVERS.........................CHECK IDLE   (PF)
-- SPEED BRAKE LEVER...............RETRACT & DISARM   (PF)
-- PARK BRK HANDLE.........................CHECK ON   (PF)
-- GRAVITY GEAR EXTN.........................STOWED   (PF)
-- RMP2 (Radio Management Panel)...........ON & SET   (PF)
-- ACP2 (Audio Control Panel)...........AS REQUIRED   (PF)

-- ==== ATC / TCAS
--   XPDR CODE.................................2000   (PF)
--   SYSTEM 1...................................SET   (PF)
--   XPDR...................................STANDBY   (PF)
--   ALT REPORTING...............................ON   (PF)

-- ==== Activate APU 
-- APU FIRE..........................IN and GUARDED   (PM)
-- APU FIRE TEST.........................CHECK/TEST   (PM)
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)

-- =======================================================

local cockpitPrep = Procedure:new("COCKPIT PREPARATION","","")
cockpitPrep:setFlightPhase(3)
cockpitPrep:setResize(false)

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Left Column"))
cockpitPrep:addItem(ProcedureItem:new("CREW OXY SUPPLY","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/CrewOxySwitch") == 1 end,
	function () set("AirbusFBW/CrewOxySwitch",1) end))
-- cockpitPrep:addItem(ProcedureItem:new("PASSENGER OXYGEN","ON",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("RCRD GND CTL","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/CvrGndCtrl") == 1 end,
	function () set("AirbusFBW/CvrGndCtrl",1) end))
-- cockpitPrep:addItem(ProcedureItem:new("CVR TEST","PRESS & HOLD 3 SECS",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("GPWS","NO WHITE LIGHTS",FlowItem.actorPF,1,
	function () return 
		get("AirbusFBW/GPWSSwitchArray",0) == 1 and 
		get("AirbusFBW/GPWSSwitchArray",1) == 1 and 
		get("AirbusFBW/GPWSSwitchArray",2) == 1 and 
		get("AirbusFBW/GPWSSwitchArray",3) == 0 and 
		get("AirbusFBW/GPWSSwitchArray",4) == 1 
	end,
	function () 
		set_array("AirbusFBW/GPWSSwitchArray",0,1)
		set_array("AirbusFBW/GPWSSwitchArray",1,1)
		set_array("AirbusFBW/GPWSSwitchArray",2,1)
		set_array("AirbusFBW/GPWSSwitchArray",3,0)
		set_array("AirbusFBW/GPWSSwitchArray",4,1)
	end))
-- cockpitPrep:addItem(ProcedureItem:new("EVAC SWITCH","CAPT & PURS",FlowItem.actorPF,1,true,nil))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  Switch one at a time waiting for the BAT light"))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  to go off before switching the next one on."))

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Center Column"))

-- cockpitPrep:addItem(SimpleProcedureItem:new("==== FIRE Panel"))
-- cockpitPrep:addItem(IndirectProcedureItem:new("ENG 1 FIRE TEST","PRESS AND HOLD",FlowItem.actorPF,6,"eng1firetest",
	-- function () return sysEngines.eng1FireTest:getStatus() == 1 end,
	-- function () sysEngines.eng1FireTest:setValue(1) end))
-- cockpitPrep:addItem(IndirectProcedureItem:new("ENG 2 FIRE TEST","PRESS AND HOLD",FlowItem.actorPF,6,"eng2firetest",
	-- function () return sysEngines.eng2FireTest:getStatus() == 1 end,
	-- function () sysEngines.eng1FireTest:setValue(0) sysEngines.eng2FireTest:setValue(1) end))
-- cockpitPrep:addItem(ProcedureItem:new("APU FIRE","IN AND GUARDED",FlowItem.actorPF,1,true,
	-- function () sysEngines.eng2FireTest:setValue(0) end))
-- cockpitPrep:addItem(IndirectProcedureItem:new("APU FIRE TEST","PRESS",FlowItem.actorPF,6,"apufiretest",
	-- function () return sysEngines.eng2FireTest:getStatus() == 1 end,
	-- function () sysEngines.apuFireTest:setValue(1) end))
-- cockpitPrep:addItem(ProcedureItem:new("FIRE TEST","FINISHED",FlowItem.actorPF,1,true,
	-- function () sysEngines.apuFireTest:setValue(0) end))

cockpitPrep:addItem(SimpleProcedureItem:new("==== Start APU"))
cockpitPrep:addItem(ProcedureItem:new("APU FIRE","IN AND GUARDED",FlowItem.actorPM,1,
	function () return get("AirbusFBW/OHPGuardsAllATA",19) == 0	end,
	function () set_array("AirbusFBW/OHPGuardsAllATA",19,0) end))
cockpitPrep:addItem(HoldProcedureItem:new("APU FIRE TEST","CHECK/TEST",FlowItem.actorCPT,1))
cockpitPrep:addItem(ProcedureItem:new("APU MASTER PB","PRESS",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 1 end,
	function () set("AirbusFBW/APUMaster",1) end))
cockpitPrep:addItem(SimpleProcedureItem:new("  After master switch, wait 3s"))
cockpitPrep:addItem(IndirectProcedureItem:new("APU START PB","PRESS",FlowItem.actorPM,12,"apustart1",
	function () return get("AirbusFBW/APUStarter") > 0 end,
	function () set("AirbusFBW/APUStarter",1) end))
	
cockpitPrep:addItem(SimpleProcedureItem:new("==== Lights panel"))
cockpitPrep:addItem(ProcedureItem:new("SEAT BELTS","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/OHPLightSwitches",11) == 1 end,
	function () command_once("toliss_airbus/lightcommands/FSBSignOn") end))
cockpitPrep:addItem(ProcedureItem:new("NO SMOKING","ON/AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/OHPLightSwitches",12) == 2 end,
	function () set_array("AirbusFBW/OHPLightSwitches",12,2) end))
cockpitPrep:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM",FlowItem.actorPF,1,
	function () return get("AirbusFBW/OHPLightSwitches",10) == 1 end,
	function () 
		set_array("AirbusFBW/OHPLightSwitches",10,1) 
		kc_macro_lights_preflight()
	end))
-- cockpitPrep:addItem(HoldProcedureItem:new("ANNUNCIATOR LIGHT","TEST",FlowItem.actorCPT,1,nil))

cockpitPrep:addItem(SimpleProcedureItem:new("==== ANTI-ICE & PRESSURIZATION"))
cockpitPrep:addItem(ProcedureItem:new("WING-ANTI-ICE","OFF",FlowItem.actorPF,1,
	function () return get("AirbusFBW/ATA30SwitchAnims",2) == 0 end,
	function () command_once("toliss_airbus/antiicecommands/WingOff") end))
cockpitPrep:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPF,1,
	function () return 
		get("AirbusFBW/ATA30SwitchAnims",3) == 0 and
		get("AirbusFBW/ATA30SwitchAnims",4) == 0
		end,
	function () 
		command_once("toliss_airbus/antiicecommands/ENG1Off")
		command_once("toliss_airbus/antiicecommands/ENG2Off")
	end))
cockpitPrep:addItem(ProcedureItem:new("PROBE/WINDOW HEAT","CHECK AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/ATA30SwitchAnims",1) == 0 end,
	function () set("AirbusFBW/ProbeHeatSwitch",0) end))
cockpitPrep:addItem(ProcedureItem:new("CABIN PRESSURE LDG ELEV","AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/LandElev") == -3 end,
	function () set("AirbusFBW/LandElev",-3) end))

cockpitPrep:addItem(SimpleProcedureItem:new("==== AIR COND Panel"))
cockpitPrep:addItem(ProcedureItem:new("APU BLEED","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/APUBleedSwitch") == 1 end,
	function () set("AirbusFBW/APUBleedSwitch",1) end))
cockpitPrep:addItem(ProcedureItem:new("CROSSBLEED","AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/XBleedSwitch") == 1 end,
	function () set("AirbusFBW/XBleedSwitch",1) end))
cockpitPrep:addItem(ProcedureItem:new("HI FLOW SELECTOR","NORM",FlowItem.actorPF,1,
	function () return get("AirbusFBW/EconFlowSel") == 1 end,
	function () set("AirbusFBW/EconFlowSel",1) end))

cockpitPrep:addItem(SimpleProcedureItem:new("==== Electrical Panel"))
cockpitPrep:addItem(ProcedureItem:new("NO WHITE LIGHTS","CHECKED",FlowItem.actorPF,1,
	function () return 
		get("AirbusFBW/ElecOHPArray",8) == 1 and
		get("AirbusFBW/ElecOHPArray",9) == 1 and
		get("AirbusFBW/ElecOHPArray",5) == 1 and
		get("AirbusFBW/ElecOHPArray",6) == 1 and
		get("AirbusFBW/ElecOHPArray",7) == 0 and
		get("AirbusFBW/ElecOHPArray",2) == 1 and
		get("AirbusFBW/ElecOHPArray",4) == 1 and
		get("AirbusFBW/ElecOHPArray",0) == 1 and
		get("AirbusFBW/ElecOHPArray",1) == 1
	end,
	function () 
		set_array("AirbusFBW/ElecOHPArray",8,1)
		set_array("AirbusFBW/ElecOHPArray",9,1)
		set_array("AirbusFBW/ElecOHPArray",5,1)
		set_array("AirbusFBW/ElecOHPArray",6,1)
		set_array("AirbusFBW/ElecOHPArray",7,0)
		set_array("AirbusFBW/ElecOHPArray",2,1)
		set_array("AirbusFBW/ElecOHPArray",4,1)
		set_array("AirbusFBW/ElecOHPArray",0,1)
		set_array("AirbusFBW/ElecOHPArray",1,1)
	end))
-- cockpitPrep:addItem(SimpleProcedureItem:new("BAT 1 PB & BAT 2 PB..................OFF then ON"))
-- cockpitPrep:addItem(SimpleProcedureItem:new("   This initiates a charging cycle of the batts."))
-- cockpitPrep:addItem(SimpleProcedureItem:new("   10 s after setting all BAT PB ON, check on the"))
-- cockpitPrep:addItem(SimpleProcedureItem:new("   ECAM ELEC page that the current charge of the"))
-- cockpitPrep:addItem(SimpleProcedureItem:new("   battery is below 60 A, and is decreasing."))

cockpitPrep:addItem(SimpleProcedureItem:new("==== FUEL Panel"))
cockpitPrep:addItem(ProcedureItem:new("FUEL PUMP SWITCHES","ALL ON",FlowItem.actorPF,1,
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
cockpitPrep:addItem(SimpleProcedureItem:new("==== HYDRAULIC Panel"))
cockpitPrep:addItem(ProcedureItem:new("NO WHITE LIGHTS","CHECKED",FlowItem.actorPF,1,
	function () return 
		get("AirbusFBW/HydOHPArray",0) == 1 and
		get("AirbusFBW/HydOHPArray",1) == 1 and
		get("AirbusFBW/HydOHPArray",2) == 1 and
		get("AirbusFBW/HydOHPArray",3) == 0
	end,
	function () 
		set_array("AirbusFBW/HydOHPArray",0,1)
		set_array("AirbusFBW/HydOHPArray",1,1)
		set_array("AirbusFBW/HydOHPArray",2,1)
		set_array("AirbusFBW/HydOHPArray",3,0)
	end))
cockpitPrep:addItem(ProcedureItem:new("FUEL MODE SELECTOR","AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/FuelOHPArray",6) == 1 end,
	function ()
		set_array("AirbusFBW/FuelOHPArray",6,1)
		set_array("AirbusFBW/FuelOHPArray",7,0)
	end))

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Left Column"))
cockpitPrep:addItem(SimpleProcedureItem:new("==== CARGO Panel"))
cockpitPrep:addItem(ProcedureItem:new("AFT CARGO HEAT","MID RANGE",FlowItem.actorPF,1,
	function () return get("AirbusFBW/FwdCargoTemp") == 15.5 end,
	function () set("AirbusFBW/FwdCargoTemp",15.5) end))
-- cockpitPrep:addItem(ProcedureItem:new("CARGO SMOKE TEST","PUSH",FlowItem.actorPF,1,true,nil))
-- cockpitPrep:addItem(SimpleProcedureItem:new("==== Audio & Radio"))
-- cockpitPrep:addItem(ProcedureItem:new("THIRD AUDIO CONTROL PANEL","PA KNOB – RECEPT",FlowItem.actorPF,1,true,nil))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  - This allows cabin attendant announcements to"))
-- cockpitPrep:addItem(SimpleProcedureItem:new("    be recorded on the CVR."))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  - Set volume at or above medium range."))

cockpitPrep:addItem(SimpleProcedureItem:new("== Central Panel"))
-- cockpitPrep:addItem(ProcedureItem:new("STANDBY INSTR (ISIS)","CHECK",FlowItem.actorPF,1,true,nil))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  Indications normal – no flags / Set QNH"))
-- cockpitPrep:addItem(ProcedureItem:new("CLOCK","CHECK/SET","CHECK",FlowItem.actorPF,1,true,nil))
-- cockpitPrep:addItem(SimpleProcedureItem:new("  Check time is UTC, switch to GPS"))
cockpitPrep:addItem(ProcedureItem:new("A/SKID & N/W STRG SWITCH","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/NWSnAntiSkid") == 1 end,
	function () set("AirbusFBW/NWSnAntiSkid",1) end))

cockpitPrep:addItem(SimpleProcedureItem:new("== Pedestal"))
-- cockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANEL","ON AND SET",FlowItem.actorPF,1,
	-- function () return sysRadios.com1OnOff:getStatus() > 0 end,
	-- function () sysRadios.com1OnOff:setValue(1) end))
-- cockpitPrep:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","AS REQUIRED",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorPF,1,
	function () return get("AirbusFBW/WXPowerSwitch") == 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 0) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
		if (get("AirbusFBW/WXPowerSwitch") == 2) then
			command_once("toliss_airbus/WXRadarSwitchLeft")
		end
	end))
cockpitPrep:addItem(ProcedureItem:new("PWS","OFF",FlowItem.actorPF,1,
	function () return get("AirbusFBW/WXSwitchPWS") == 0 end,
	function () set("AirbusFBW/WXSwitchPWS",0) end))
-- cockpitPrep:addItem(ProcedureItem:new("COCKPIT DOOR","NORMAL",FlowItem.actorPF,1,
	-- function () return sysGeneral.cockpitLock:getStatus() == 0 end,
	-- function () sysGeneral.cockpitLock:setValue(0) sysGeneral.cockpitDoor:setValue(1) end))
-- SWITCHING PANEL...........................NORMAL   (PF)
cockpitPrep:addItem(ProcedureItem:new("THRUST LEVERS","CHECK IDLE",FlowItem.actorPF,1,
	function () return get("toliss_airbus/joystick/throttle/rawLeverPos",0) == 0 and get("toliss_airbus/joystick/throttle/rawLeverPos",1) == 0 end))
cockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE","RETRACT & DISARM",FlowItem.actorPF,1,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 and get("AirbusFBW/SpdBrakeDeployed") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0)  end))
cockpitPrep:addItem(ProcedureItem:new("PARK BRAKE HANDLE","CHECK ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () command_once("toliss_airbus/park_brake_set") end))
cockpitPrep:addItem(ProcedureItem:new("GRAVITY GEAR EXTN","STOWED",FlowItem.actorPF,1,
	function () return get("ckpt/gravityGearOn/anim") == 0 end,
	function () set("ckpt/gravityGearOn/anim",0) end))

cockpitPrep:addItem(SimpleProcedureItem:new("==== ATC / TCAS"))
cockpitPrep:addItem(ProcedureItem:new("XPDR CODE","2000",FlowItem.actorPF,1,
	true,
	function () 
		set("AirbusFBW/XPDR4",2)
		set("AirbusFBW/XPDR3",0)
		set("AirbusFBW/XPDR2",0)
		set("AirbusFBW/XPDR1",0)
	end))
cockpitPrep:addItem(ProcedureItem:new("SYSTEM 1","SET",FlowItem.actorPF,1,
	function () return get("AirbusFBW/XPDRSystem") == 1 end,
	function () set("AirbusFBW/XPDRSystem",1) end))
cockpitPrep:addItem(ProcedureItem:new("XPDR","STANDBY",FlowItem.actorPF,1,
	function () return get("AirbusFBW/XPDRPower") == 0 end,
	function () set("AirbusFBW/XPDRPower",0) end))
-- cockpitPrep:addItem(ProcedureItem:new("ALT REPORTING","ON",FlowItem.actorPF,1,
	-- function () return sysRadios.xpdrAltRpt:getStatus() == 1 end,
	-- function () sysRadios.xpdrAltRpt:setValue(1) end))


-- FMGC SETUP PROCEDURE
-- D-I-F-R-I-P+P-S

-- =========== FINAL COCKPIT PREPARATION (F/O) ===========
-- ==== EFIS Panel
-- QNH ON EFIS..................................SET (BOTH)
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTORS..............................ON (BOTH)
-- ILS/LS.......................................OFF (BOTH)
-- NAVIGATION DISPLAY MODE & RANGE..............SET (BOTH)
-- ADF/VOR SWITCHES.............................VOR (BOTH)
-- CSTR..........................................ON (BOTH)

-- ==== FCU for Departure
-- FMGC.................................INITIALIZED   (PF)
-- SPD MACH WINDOW...........................DASHED   (PF)
--   100 displayed until Perf page is completed
-- HDG WINDOW................................DASHED   (PF)
-- ALT WINDOW...................INITIAL CLEARED ALT   (PF)
-- V/S WINDOW................................DASHED   (PF)

-- ==== Cockpit
-- OXYGEN MASK.................................TEST (BOTH)
-- LOUDSPEAKERS VOLUME...........................ON (BOTH)
-- SLIDING WINDOWS..................CLOSED & LOCKED (BOTH)
-- PFD & ND BRIGHTNESS......................AS RQRD (BOTH)
--   PFD / ND indications CHECK NORMAL

-- ==== Pedestal
-- RMP (Radio Management Panel)............ON & SET (BOTH)
-- ACP..................................AS REQUIRED (BOTH)
-- TRANSPONDER.................................STBY (BOTH)
-- =======================================================

-- local finalCockpitPrep = Procedure:new("FINAL COCKPIT PREPARATION","","ready for cockpit preparation checklist")
-- finalCockpitPrep:setFlightPhase(3)

-- finalCockpitPrep:addItem(SimpleProcedureItem:new("==== EFIS Panel"))
-- finalCockpitPrep:addItem(ProcedureItem:new("QNH ON EFIS","SET",FlowItem.actorBOTH,1,
	-- function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		-- get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	-- function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				-- set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))

-- ==== EFIS Panel
-- QNH ON EFIS..................................SET (BOTH)
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTORS..............................ON (BOTH)
-- ILS/LS.......................................OFF (BOTH)
-- NAVIGATION DISPLAY MODE & RANGE..............SET (BOTH)
-- ADF/VOR SWITCHES.............................VOR (BOTH)
-- CSTR..........................................ON (BOTH)


-- =========== DEPARTURE BRIEFING ========
-- == AIRCRAFT
	-- FMS
	-- ➢ DATA Page
		-- ▪ Type and Model
		-- ▪ APD & Nav Database Date
	-- ➢ FMS INIT- B Pag
		-- ▪ Block Fuel (FOB on EWD)
		-- ▪ Estimated TOW
		-- ▪ Extra Time / Fuel at Destination
	-- ➢ PERF TAKEOFF Pag
		-- ▪ TO RWY
		-- ▪ TO CONF
		-- ▪ Flex / TOGA
		-- ▪ V1, VR, V2
		-- ▪ Transition Altitude
		-- ▪ Thrust Reduction / ACC Altitude
	-- ➢ F-PLN & PROG Page
		-- ▪ Route Waypoints
		-- ▪ Time, Distance and Fuel
		-- ▪ Strategy in secondary flight plan
-- == WEATHER
	-- • Weather reports and applicable procedures
	-- • Applicable NOTAMS and procedures
-- == STARTUP & TAXI
	-- • ATC Procedures (push and start procedures)
	-- • A/C Procedures (engine start etc.)
	-- • Routing to the anticipated runway
-- == RUNWAY
	-- • Dimensions (Length, Width, Stopway)
	-- • Surface Condition
	-- • Lighting
	-- • Packs / Anti ice – On/Off Takeoff
-- == DEPARTURE
	-- • Normal SID – Routing and Constraints
	-- • Engine Out SID – Routing and Constraint
	-- • Navigation Frequencies to be used (RAD NAV)
	-- • MSA
-- == SPECIAL PROCEDURES
	-- • NADP
	-- • Weather
	-- • Terrain
	-- • Failures (Communication etc.)

-- == Emergency Briefing
-- This will be a left hand seat takeoff.
-- Failure Before 100 Knots or V1
	-- • For any failure before 100 knots or V1, clearly CALL OUT THE MALFUNCTION and I will call STOP or GO.
	-- • If the call is STOP, I will apply the REJECTED TAKEOFF PROCEDURE and bring the aeroplane to a complete stop.
	-- • I will set the PARKING BRAKE and call “ATTENTION CREW AT STATION”.
	-- • You will monitor REV GREEN and DECEL and silence any AURAL WARNING and inform ATC.
	-- • Thereafter you will carry out ECAM actions on my command.
	-- • IF EVACUATION is required, we will carry out the “Emergency Evacuation Checklist”.
	
-- Failure After V1
	-- • For any failure after V1, takeoff will be continued and NO ACTION BEFORE 400 feet AGL EXCEPT silencing of any AURAL WARNING and GEAR UP.
	-- • Reaching 400 feet AGL, ECAM actions on my command.
	-- • For engine failure / damage / fire, when ENGINE IS SECURED: Stop ECAM, level off, accelerate and cleanup.
	-- • If ENGINE IS NOT SECURED: Continue climbing until engine is secured, but not above EO maximum acceleration altitude.
	-- • At GREEN DOT OPEN CLB, select MCT.
	-- • Resume ECAM, complete AFTER T/O C/L and check the STATUS.
	-- • FLY (a) EO Routing (b) SID (c) Radar Vectors (c) Immediate Turn Back.

-- REJECTED TAKEOFF: 
	-- Before 100 knots (Less serious. Abort is at Captain’s discretion depending on the circumstances)
	-- Any ECAM Warning / Caution. 
	-- Between 100 knots & V1 (More Serious. Be go minded except for a few situations, as mentioned below)
	-- Failures with ECAM
		-- Left Hand Items
			-- Side Stick Fault
		-- Right Hand Items
			-- Thrust Lever Fault
		-- Engine Items
			-- Fire
			-- Failure
			-- Reverser Unlocked or Fault.
	-- Failures without ECAM
		-- Sudden loss of thrust.
		-- Any major failure.
		-- If aeroplane is unsafe to fly due any reason.
		-- Tire failure within 20 knots of V1: Unless debris from tire causes noticeable engine parameter fluctuation, takeoff, reduce fuel load & land with full RWY length available.
	-- Weather
		-- Windshear.
	-- Note: Exceeding EGT red line or nose gear vibration should not result in an abort above 100 knots *

-- ============ COCKPIT PREPARATION CHECKLIST ============
-- GEAR PINS & COVERS.......................REMOVED   (PF)
-- FUEL QUANTITY............................ ___ KG   (PF)
--   check FOB & distribution on FUEL SD page
-- SEAT BELT.....................................ON   (PF)
-- ADIRS........................................NAV   (PF)
-- BARO REF....................................____ (BOTH)
-- =======================================================

local cockpitPrepChkl = Checklist:new("COCKPIT PREPARATION CHECKLIST","","COCKPIT PREPARATION CHECKLIST completed")
cockpitPrepChkl:setFlightPhase(3)
cockpitPrepChkl:addItem(ChecklistItem:new("GEAR PINS & COVERS","REMOVED",FlowItem.actorPF,1,
	function () return true end))
cockpitPrepChkl:addItem(ChecklistItem:new("FUEL","%i KG|get(\"sim/flightmodel/weight/m_fuel_total\")",FlowItem.actorPF,3,
	function () return true end))
cockpitPrepChkl:addItem(SimpleChecklistItem:new("  check FOB & distribution on FUEL SD page"))
cockpitPrepChkl:addItem(ChecklistItem:new("SEAT BELT","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/SeatBeltSignsOn") == 1 end,
	function () command_once("toliss_airbus/lightcommands/FSBSignOn") end))
cockpitPrepChkl:addItem(ChecklistItem:new("ADIRS","NAV",FlowItem.actorPF,1,
	function () return 
		get("AirbusFBW/ADIRUSwitchArray",0) == 1 and 
		get("AirbusFBW/ADIRUSwitchArray",1) == 1 and 
		get("AirbusFBW/ADIRUSwitchArray",2) == 1
	end))
cockpitPrepChkl:addItem(ChecklistItem:new("BARO REF","%s|math.ceil(get(\"sim/weather/aircraft/qnh_pas\")/100)",FlowItem.actorBOTH,1,
	function () 
		return kc_macro_test_local_baro()
	end,
	function () 
		kc_macro_set_local_baro()
	end))

local cduPreflightProc = Procedure:new("CDU PREFLIGHT BY CAPTAIN")
cduPreflightProc:setFlightPhase(2)
cduPreflightProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
cduPreflightProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEFING","FILLED OUT",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("CDU PREFLIGHT","FINISHED",FlowItem.actorCPT))
cduPreflightProc:addItem(ProcedureItem:new("FCU","SET",FlowItem.actorFO,0,true,
	function () kc_macro_mcp_preflight() end))

-- ========= BEFORE PUSHBACK AND START CLEARANCE =========
-- SEAT POSITION.............................ADJUST (BOTH)
-- FUEL......CROSS CHECK (ECAM FOB & FPL/LOADSHEET)   (PF)
-- LOAD SHEET........................CHECK / REVISE (BOTH)
-- FMS T/O DATA..............................REVISE (BOTH)
-- MCDU............................FMS PERF TO PAGE   (PF)
-- MCDU..............................FMS F-PLN PAGE   (PM)
-- EXTERNAL POWER........................DISCONNECT   (PM)
-- PUSH / START CLEARANCE....................OBTAIN   (PM)
-- BEACON........................................ON   (PF)
-- ATC TRANSPONDER..................SET AS REQUIRED   (PM)
-- WINDOWS / DOORS...................CHECKED CLOSED (BOTH)
-- THRUST LEVERS...............................IDLE   (PF)
-- ACCU PRESSURE INDICATOR....................CHECK   (PF)
--   TAKEOFF CG/TRIM POS..check and set (BOTH)

-- APU START NOW and GPU disconnected
-- =======================================================


local beforePushStart = Procedure:new("BEFORE PUSHBACK AND START CLEARANCE","","ready for before start checklist")
beforePushStart:setFlightPhase(4)
-- beforePushStart:addItem(ProcedureItem:new("SEAT POSITION","ADJUST",FlowItem.actorBOTH,1,true,nil))
-- beforePushStart:addItem(ProcedureItem:new("FUEL","CROSS CHECK (ECAM FOB & FPL/LOADSHEET)",FlowItem.actorPF,1,true,nil))
-- beforePushStart:addItem(ProcedureItem:new("LOAD SHEET","CHECK / REVISE",FlowItem.actorBOTH,1,true,nil))
-- beforePushStart:addItem(ProcedureItem:new("FMS T/O DATA","REVISE",FlowItem.actorBOTH,1,true,nil))
-- beforePushStart:addItem(ProcedureItem:new("MCDU","FMS PERF TO PAGE",FlowItem.actorPF,1,true,nil))
-- beforePushStart:addItem(ProcedureItem:new("MCDU","FMS F-PLN PAGE",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("EXT POWER","OFF",FlowItem.actorPM,1,
	function () return get("AirbusFBW/ExtPowOHPArray",0) == 0 end,
	function () command_once("toliss_airbus/eleccommands/ExtPowOff") end))
beforePushStart:addItem(ProcedureItem:new("EXTERNAL POWER","DISCONNECT",FlowItem.actorPM,1,
	function () return get("AirbusFBW/EnableExternalPower") == 0 end,
	function () set("AirbusFBW/EnableExternalPower",0) end))
-- beforePushStart:addItem(ProcedureItem:new("PUSH / START CLEARANCE","OBTAIN",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("BEACON","ON",FlowItem.actorPF,1,true,
	function () kc_macro_lights_before_start() end))
-- beforePushStart:addItem(ProcedureItem:new("ATC TRANSPONDER","SET AS REQUIRED",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("WINDOWS / DOORS","CHECKED CLOSED",FlowItem.actorBOTH,1,
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
-- beforePushStart:addItem(ProcedureItem:new("ACCU PRESSURE INDICATOR","CHECK",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("TAKEOFF CG/TRIM POS","%4.6f UNITS (%4.6f)|math.floor(get(\"AirbusFBW/PitchTrimPosition\")*100)/100|math.floor(activeBriefings:get(\"takeoff:elevatorTrim\")*100)/100",FlowItem.actorCPT,0,
	function () return math.floor(get("AirbusFBW/PitchTrimPosition")*100)/100 == math.floor(activeBriefings:get("takeoff:elevatorTrim")*100)/100 end))
beforePushStart:addItem(ProcedureItem:new("RUDDER TRIM","0 UNITS (%3.2f)|get(\"AirbusFBW/YawTrimPosition\")",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/YawTrimPosition") == 0 end,
	function () command_once("sim/flight_controls/rudder_trim_center") end))



-- =============== BEFORE START CHECKLIST ================
-- PARKING BRAKE.................................ON   (PF)
-- T.O. SPEEDS & THRUST......................._____ (BOTH)
--   PF V1,VR,V2 & thrust setting FMS PERF
-- WINDOWS...................................CLOSED (BOTH)
-- BEACON........................................ON   (PF)
-- =======================================================

local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST","","BEFORE START CHECKLIST completed")
beforeStartChkl:setFlightPhase(4)
beforeStartChkl:addItem(ChecklistItem:new("PARKING BRAKE","ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () command_once("toliss_airbus/park_brake_set") end))
beforeStartChkl:addItem(ChecklistItem:new("T.O. SPEEDS & THRUST","____",FlowItem.actorPF,1,true,nil))
beforeStartChkl:addItem(SimpleChecklistItem:new("  PF V1,VR,V2 & thrust setting FMS PERF"))
beforeStartChkl:addItem(ChecklistItem:new("WINDOWS","CLOSED",FlowItem.actorBOTH,1,
	function () return
		get("AirbusFBW/CockpitWindowPosition",0) == 0 and
		get("AirbusFBW/CockpitWindowPosition",1) == 0 
	end,
	function () 
		set_array("AirbusFBW/CockpitWindowSwitchPosition",0,1)
		set_array("AirbusFBW/CockpitWindowSwitchPosition",1,1)
		command_once("AirbusFBW/CaptainWindowClose")
		command_once("AirbusFBW/CopilotWindowClose")
	end))
beforeStartChkl:addItem(ChecklistItem:new("BEACON","ON",FlowItem.actorPM,1,
	function () return get("sim/cockpit2/switches/beacon_on") == 1 end,
	function () command_once("toliss_airbus/lightcommands/BeaconOn") end))

-- ================== PUSHBACK (BOTH) ====================
-- DOORS.....................................CLOSED  (F/O)
-- PARKING BRAKE................................SET  (CPT)
-- IGNITION SWITCHES.........................NORMAL  (F/O)
-- EXT PWR...........................OFF/DISCONNECT  (F/O)
-- AUX PUMP A...................................OFF  (F/O)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- =======================================================

local pushProc = Procedure:new("PUSHBACK - SKIP IF NOT REQUIRED","")
pushProc:setFlightPhase(4)
pushProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return true end,
	function () command_once("toliss_airbus/door_commands/all_to_mode_close") end))
pushProc:addItem(ProcedureItem:new("CHOCKS","REMOVED",FlowItem.actorFO,0,
	function () return get("AirbusFBW/Chocks") == 0 end,
	function () set("AirbusFBW/Chocks",0) end))
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return get("AirbusFBW/ParkBrake") == 1 end,
	function () 
		command_once("toliss_airbus/park_brake_set") 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		if activeBriefings:get("taxi:gateStand") <= 2 then
			if activePrefSet:get("default:betterPushback") == true then
				kc_pushback_plan()
			end
			if activePrefSet:get("default:sges") == true then
				kc_show_sges_window()
			end			
		end
	end))
pushProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () 
		if activePrefSet:get("default:betterPushback") == true then
			kc_pushback_call() 
		end
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return get("AirbusFBW/ParkBrake") == 0 end,
	function () command_once("toliss_airbus/park_brake_release") end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(HoldProcedureItem:new("CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT,nil))

-- =============== PUSHBACK & ENGINE START ===============
-- == AUTOMATIC START
-- THRUST LEVERS...............................IDLE   (PF)
-- ENGINE MODE SELECTOR.................IGN / START   (PF)
-- PARKING BRAKE...........................RELEASED   (PF)
-- START FIRST ENGINE.............STARTING ENGINE _   (PF)
--   ENGINE MASTER SWITCH........................ON   (PF)
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
--   ENGINE MASTER SWITCH........................ON   (PF)
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
pushstartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorPF,1,
	function () return get("toliss_airbus/joystick/throttle/rawLeverPos",0) == 0 and get("toliss_airbus/joystick/throttle/rawLeverPos",1) == 0 end))
pushstartProc:addItem(IndirectProcedureItem:new("ENGINE MODE SELECTOR","IGN / START",FlowItem.actorCPT,1,"engmdpre",
	function () return get("AirbusFBW/ENGModeSwitch") == 2 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToStart") end))

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
			return get("AirbusFBW/anim/ENGN1Speed",1) > 18.9 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",0) > 18.9 
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
			return get("AirbusFBW/anim/ENGN1Speed",0) > 18.9 
		else 
			return get("AirbusFBW/anim/ENGN1Speed",1) > 18.9 
		end 
	end,
	function () kc_speakNoText(0,"N1 increasing") end))	
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE AVAIL","ANNOUNCE",FlowItem.actorCPT,0,true,
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
-- ENGINE MODE SELECTOR......................NORMAL   (PF)
-- APU BLEED....................................OFF   (PF)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PF)
-- WING ANTI-ICE........................AS REQUIRED   (PF)
-- APU MASTER SWITCH............................OFF   (PF)
-- GROUND SPOILERS..............................ARM   (PM)
-- RUDDER TRIM.................................ZERO   (PM)
-- FLAPS...........................TAKEOFF POSITION   (PM)
-- PITCH TRIM HANDWHEEL.........................SET   (PM)
-- STATUS REMINDER..............CHECK NOT DISPLAYED   (PF)
-- N/W STEER DISC MEMO..........CHECK NOT DISPLAYED   (PF)
-- GROUND CREW.........ANNOUNCE CLEAR TO DISCONNECT   (PF)
-- GROUND CREW.....ANNOUNCE HAND SIGNAL ON LEFT/RGT   (PF)
-- =======================================================

local afterStartProc = Procedure:new("AFTER START ITEMS","","")
afterStartProc:setFlightPhase(5)
afterStartProc:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorCPT,1,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
afterStartProc:addItem(ProcedureItem:new("APU BLEED","OFF",FlowItem.actorPF,1,
	function () return get("AirbusFBW/APUBleedSwitch") == 0 end,
	function () set("AirbusFBW/APUBleedSwitch",0) end))
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
afterStartProc:addItem(ProcedureItem:new("APU MASTER","OFF",FlowItem.actorPM,5,
	function () return get("AirbusFBW/APUMaster") == 0 end,
	function () set("AirbusFBW/APUMaster",0) end))
afterStartProc:addItem(ProcedureItem:new("SPEED BRAKE","ARMED",FlowItem.actorPM,1,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == -0.5 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",-0.5)  end))
afterStartProc:addItem(ProcedureItem:new("RUDDER TRIM","0 UNITS (%3.2f)|get(\"AirbusFBW/YawTrimPosition\")",FlowItem.actorCPT,0,
	function () return get("AirbusFBW/YawTrimPosition") == 0 end,
	function () command_once("sim/flight_controls/rudder_trim_center") end))
afterStartProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/controls/flap_ratio") == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () set("sim/cockpit2/controls/flap_ratio",sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
afterStartProc:addItem(ProcedureItem:new("TAKEOFF CG/TRIM POS","%4.6f UNITS (%4.6f)|math.floor(get(\"AirbusFBW/PitchTrimPosition\")*100)/100|math.floor(activeBriefings:get(\"takeoff:elevatorTrim\")*100)/100",FlowItem.actorCPT,0,
	function () return math.floor(get("AirbusFBW/PitchTrimPosition")*100)/100 == math.floor(activeBriefings:get("takeoff:elevatorTrim")*100)/100 end))
afterStartProc:addItem(HoldProcedureItem:new("STATUS REMINDER","CHECK NOT DISPLAYED",FlowItem.actorCPT,1))
afterStartProc:addItem(HoldProcedureItem:new("N/W STEER DISC MEMO","CHECK NOT DISPLAYED",FlowItem.actorCPT,1))
afterStartProc:addItem(HoldProcedureItem:new("GROUND CREW","ANNOUNCE CLEAR TO DISCONNECT",FlowItem.actorCPT,1))
afterStartProc:addItem(HoldProcedureItem:new("GROUND CREW","ANNOUNCE HAND SIGNAL ON LEFT/RGT",FlowItem.actorCPT,1))

-- ================= AFTER START CHECKLIST ===============
-- ANTI ICE.............................AS REQUIRED   (PF)
-- ECAM STATUS..............................CHECKED   (PF)
-- PITCH TRIM................................_% SET   (PF)
-- RUDDER TRIM..............................NEUTRAL   (PF)
-- =======================================================

local afterStartChkl = Checklist:new("AFTER START CHECKLIST","","AFTER START CHECKLIST completed")
afterStartChkl:setFlightPhase(5)
afterStartChkl:addItem(ChecklistItem:new("ANTI ICE","AS REQUIRED",FlowItem.actorPF,1,true,nil))
afterStartChkl:addItem(ChecklistItem:new("ECAM STATUS","CHECKED",FlowItem.actorPF,1,true,nil))
afterStartChkl:addItem(ChecklistItem:new("PITCH TRIM","%4.6f UNITS (%4.6f)|math.floor(get(\"AirbusFBW/PitchTrimPosition\")*100)/100|math.floor(activeBriefings:get(\"takeoff:elevatorTrim\")*100)/100",FlowItem.actorPF,1,
function () return math.floor(get("AirbusFBW/PitchTrimPosition")*100)/100 == math.floor(activeBriefings:get("takeoff:elevatorTrim")*100)/100 end))afterStartChkl:addItem(ChecklistItem:new("RUDDER TRIM","NEUTRAL",FlowItem.actorPF,1,
	function () return get("AirbusFBW/YawTrimPosition") == 0 end,
	function () command_once("sim/flight_controls/rudder_trim_center") end))

-- ================= BEFORE TAXI PROCEDURE ===============
-- == PRE-REQ
-- FLIGHT CONTROLS............................CHECK (BOTH)
--   Flight Controls Before or During Taxi 
-- TAXI CLEARANCE............................OBTAIN   (PM)
-- TAXI / TURN OFF LIGHT.........................ON   (PF)
-- PARKING BRAKE..........OFF – BRAKE PRESSURE ZERO   (PF)
-- BRAKE PEDALS.........PRESS & CALL: “BRAKE CHECK”   (PF)
-- == CLEARANCE
-- ATC CLEARANCE............................CONFIRM   (PM)
-- FLIGHT DIRECTORS.........................BOTH ON   (PM)
-- == DO ITEMS
-- AUTO BRAKES......................AUTO BRK MAX ON   (PM) 
-- ATC CODE/MODE........................CONFIRM/SET   (PM) 
-- ENGINE MODE SELECTOR.................AS REQUIRED   (PM) 
-- WEATHER RADAR.............................ON/ALL   (PF)
-- PREDICTIVE WINDSHEAR.....................AUTO/ON   (PM) 
-- TERRAIN ON ND........................AS REQUIRED   (PM) 
-- FINAL CHECK TO CONFIG.......................TEST   (PM) 
-- FINAL CHECK TO MEMO................CHECK NO BLUE   (PM)
-- “CABIN SECURED FOR TAKEOFF”
-- =======================================================

local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE","","ready for before taxi checklist")
beforeTaxiProc:addItem(SimpleProcedureItem:new("=== PRE-REQ"))
beforeTaxiProc:setFlightPhase(5)beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","AILERONS",FlowItem.actorBOTH,0,"fccheck1",
	function () return get("sim/flightmodel2/wing/aileron1_deg",6) > 20 end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","ELEVATORS",FlowItem.actorBOTH,0,"fccheck2",
	function () return get("sim/flightmodel2/wing/elevator1_deg",8) > 14 end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","RUDDER",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg",10) > 29 end))
beforeTaxiProc:addItem(HoldProcedureItem:new("TAXI CLEARANCE","OBTAINED",FlowItem.actorCPT,1))
beforeTaxiProc:addItem(ProcedureItem:new("TAXI / TURN OFF LIGHT","ON",FlowItem.actorFO,0,
	function () return get("ckpt/oh/taxiLight/anim") == 1 end,
	function () kc_macro_lights_before_taxi() end))
beforeTaxiProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ParkBrake") == 0 end,
	function () command_once("toliss_airbus/park_brake_release") end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("BRAKE PEDALS","PRESS & CALL BRAKE CHECK",FlowItem.actorFO,0,"braketest",
	function () return get("AirbusFBW/BrakePedalAnim",0) > 0 end))
beforeTaxiProc:addItem(SimpleProcedureItem:new("=== CLEARANCE"))
beforeTaxiProc:addItem(HoldProcedureItem:new("ATC CLEARANCE","CONFIRM",FlowItem.actorCPT,1))
beforeTaxiProc:addItem(ProcedureItem:new("FLIGHT DIRECTORS","BOTH ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/FD1Engage") == 1 and get("AirbusFBW/FD2Engage") == 1 end,
	function ()
		if get("AirbusFBW/FD1Engage") == 0 then 
			command_once("toliss_airbus/fd1_push")
		end
		if get("AirbusFBW/FD2Engage") == 0 then 
			command_once("toliss_airbus/fd2_push") 
		end
	end))
beforeTaxiProc:addItem(SimpleProcedureItem:new("=== OTHER ITEMS"))
beforeTaxiProc:addItem(ProcedureItem:new("AUTO BRAKES","ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/AutoBrkMax") == 1 end,
	function () command_once("AirbusFBW/AbrkMax") end))
beforeTaxiProc:addItem(HoldProcedureItem:new("ATC CODE/MODE","CONFIRM/SET",FlowItem.actorCPT,1))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,1,
	function () return get("AirbusFBW/ENGModeSwitch") == 1 end,
	function () command_once("toliss_airbus/engcommands/EngineModeSwitchToNorm") end))
beforeTaxiProc:addItem(ProcedureItem:new("WEATHER RADAR","ON/ALL",FlowItem.actorPM,1,
	function () return get("AirbusFBW/WXPowerSwitch") ~= 1 end,
	function () 
		if (get("AirbusFBW/WXPowerSwitch") == 1) then
			command_once("toliss_airbus/WXRadarSwitchRight")
		end
	end))
beforeTaxiProc:addItem(ProcedureItem:new("PREDICTIVE WINDSHEAR","AUTO/ON",FlowItem.actorPF,1,
	function () return get("AirbusFBW/WXSwitchPWS") == 2 end,
	function () set("AirbusFBW/WXSwitchPWS",2) end))
beforeTaxiProc:addItem(ProcedureItem:new("TERRAIN ON ND","AS REQUIRED",FlowItem.actorPF,1,
	function () return get("AirbusFBW/TerrainSelectedND1") == 1 end,
	function () set("AirbusFBW/TerrainSelectedND1",1) end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("FINAL CHECK TO CONFIG","TEST",FlowItem.actorPF,1,"toconfig",
	function () return get("AirbusFBW/ATA31ECPAnimations",25) > 0 end,
	function () command_once("AirbusFBW/TOConfigPress") end))
beforeTaxiProc:addItem(HoldProcedureItem:new("FINAL CHECK TO MEMO","CHECK NO BLUE",FlowItem.actorCPT,1))

-- ==================== TAXI CHECKLIST ===================
-- FLIGHT CONTROLS..........................CHECKED (BOTH)
-- FLAP SETTINGS...........................CONF ___ (BOTH)
-- RADAR & PRED W/S.......................ON & AUTO   (PF)
-- ENG MODE.................IGNITION|NORM (on A320)   (PF)
-- ECAM MEMO.............................TO NO BLUE   (PF)
--   - AUTO BRK MAX
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS TO
--   - TO CONFIG NORM
-- =======================================================

local taxiChkl = Checklist:new("TAXI CHECKLIST","","TAXI CHECKLIST completed")
taxiChkl:setFlightPhase(6)
taxiChkl:addItem(ChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("FLAP SETTINGS","CONF ___",FlowItem.actorBOTH,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("RADAR & PRED W/S","ON & AUTO",FlowItem.actorPF,1,
	function () return get("AirbusFBW/WXPowerSwitch") ~= 1 and get("AirbusFBW/WXSwitchPWS") == 2 end))
taxiChkl:addItem(ChecklistItem:new("ENG MODE","IGNITION|NORM",FlowItem.actorPF,1,
	function () return get("AirbusFBW/ENGModeSwitch") < 2 end))
taxiChkl:addItem(ChecklistItem:new("ECAM MEMO","TO - NO BLUE",FlowItem.actorPF,1,true,nil))
taxiChkl:addItem(SimpleChecklistItem:new("  - AUTO BRK MAX"))
taxiChkl:addItem(SimpleChecklistItem:new("  - SIGNS ON"))
taxiChkl:addItem(SimpleChecklistItem:new("  - CABIN READY"))
taxiChkl:addItem(SimpleChecklistItem:new("  - SPLRS ARM"))
taxiChkl:addItem(SimpleChecklistItem:new("  - FLAPS TO"))
taxiChkl:addItem(SimpleChecklistItem:new("  - TO CONFIG NORM"))

local TaxiProc = Procedure:new("BEGIN TAXI","","")
TaxiProc:setFlightPhase(5)
TaxiProc:addItem(HoldProcedureItem:new("CLEAR LEFT","",FlowItem.actorCPT))
TaxiProc:addItem(ProcedureItem:new("CLEAR RIGHT","",FlowItem.actorFO,0,true))
	
-- =============== BEFORE TAKEOFF PROCEDURE ==============
-- BRAKE FANS.................................CHECK   (PM)
-- LINEUP CLEARANCE..........................OBTAIN   (PM)
-- TCAS.................................TA OR TA/RA   (PM)
-- TAKEOFF RUNWAY...........................CONFIRM (BOTH)
-- APPROACH PATH...................CLEAR OF TRAFFIC (BOTH)
-- EXTERIOR LIGHTS......................STROBE – ON   (PF)
-- PACKS................................AS REQUIRED   (PM)
-- SLIDING TABLE.............................STOWED (BOTH)
-- CABIN CREW................................ADVISE   (PM)
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE","runway entry","aircraft ready for takeoff")
beforeTakeoffProc:setFlightPhase(7)
beforeTakeoffProc:addItem(HoldProcedureItem:new("LINEUP CLEARANCE","OBTAINED",FlowItem.actorCPT,1))
beforeTakeoffProc:addItem(ProcedureItem:new("TCAS","TA/RA",FlowItem.actorPM,1,
	function () return get("AirbusFBW/XPDRPower") == 4 end,
	function () set("AirbusFBW/XPDRPower",4) end))
beforeTakeoffProc:addItem(HoldProcedureItem:new("TAKEOFF RUNWAY","CONFIRM",FlowItem.actorBOTH,1))
beforeTakeoffProc:addItem(HoldProcedureItem:new("APPROACH PATH","CLEAR OF TRAFFIC",FlowItem.actorBOTH,1))
beforeTakeoffProc:addItem(ProcedureItem:new("EXTERIOR LIGHTS","ON FOR TAKEOFF",FlowItem.actorPM,1,
	function () return get("ckpt/oh/strobeLight/anim") > 0 end,
	function () kc_macro_lights_for_takeoff() end))
beforeTakeoffProc:addItem(ProcedureItem:new("PACKS","ON",FlowItem.actorPM,1,
	function () return get("AirbusFBW/Pack1Switch") > 0 and get("AirbusFBW/Pack2Switch") > 0 end,
	function () kc_macro_packs_takeoff() end,
	function () return activeBriefings:get("takeoff:packs") == 2 end))
beforeTakeoffProc:addItem(ProcedureItem:new("PACKS","OFF",FlowItem.actorPM,1,
	function () return get("AirbusFBW/Pack1Switch") == 0 and get("AirbusFBW/Pack2Switch") == 0 end,
	function () kc_macro_packs_takeoff() end,
	function () return activeBriefings:get("takeoff:packs") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("SLIDING TABLE","STOWED",FlowItem.actorBOTH,1,
	function () return get("AirbusFBW/TrayTableAnimation",0) == 0 and get("AirbusFBW/TrayTableAnimation",1) == 0 end,
	function () 
		command_once("AirbusFBW/CaptTableIn")
		command_once("AirbusFBW/CopilotTableIn")
	end))
beforeTakeoffProc:addItem(IndirectProcedureItem:new("CABIN CREW","ADVISED",FlowItem.actorPM,1,"crewadvised",
	function () return get("AirbusFBW/fmod/env/cabinChime") == 1 end,
	function () 
		command_once("AirbusFBW/purser/all")
	end))
	
-- =================== LINE-UP CHECKLIST =================
-- T.O RWY......................................___ (BOTH)
-- TCAS.......................................TA/RA   (PM)
-- PACK 1 & 2......................____ AS REQUIRED   (PM)
-- =======================================================

local lineUpChkl = Checklist:new("LINE-UP CHECKLIST","","line up CHECKLIST completed")
lineUpChkl:setFlightPhase(7)
lineUpChkl:addItem(ChecklistItem:new("T.O. RUNWAY","____",FlowItem.actorBOTH,1,true,nil))
lineUpChkl:addItem(ChecklistItem:new("TCAS","TA/RA",FlowItem.actorPM,1,true,nil))
lineUpChkl:addItem(ChecklistItem:new("PACK 1 & 2","__ AS REQUIRED",FlowItem.actorPM,1,true,nil))

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ============
-- TAKEOFF CLEARANCE........................OBTAIN   (PM)
--   Weather around departure path
--   Terrain around departure path
--   Fuel check before takeoff
-- FCU.................................AS REQUIRED   (PF)
-- == Exterior Lights
-- NOSE LIGHT...................................ON   (PF)
-- TURN OFF LIGHTS..............................ON   (PF)
-- LAND LIGHTS..................................ON   (PF)
-- == Thrust Setting
-- ANNOUNCE..............................“TAKEOFF”   (PF)
--   STANDARD TAKEOFF
--     • Thrust – N1 50% (1.05 EPR)
--     • Brakes – Release
--     • Thrust – FLX / TOGA
--     • Sidestick – ½ FWD up to 80, Neutral by 100
-- CHRONO.....................................START   (PM)
-- == Below 80 Knots
-- TAKEOFF N1(EPR)............................CHECK   (PM)
-- ANNOUNCE............................“THRUST SET”   (PM)
-- ANNOUNCE...............................100 KNOTS   (PM)
-- AT V1 & VR..............ANNOUNCE “V1” & “ROTATE”   (PM)
-- POSITIVE CLIMB......................GT 40 FT AGL   (PM)
-- LANDING GEAR..................................UP   (PM)
-- == Thrust Reduction Altitude (>xxxft)
-- THRUST LEVERS..........................CL DETENT   (PF)
-- PACKS.........................................ON   (PM)
-- == Acceleration Altitude (> xxxxft)
--   Check Target Speed – Monitor FMA
-- AP1...........................................ON   (PF)
-- F SPEED..................................REACHED
-- FLAPS 1......................................SET   (PM)
-- S SPEED..................................REACHED
-- FLAPS 0......................................SET   (PM)
-- SPOILERS..................................DISARM   (PM)
-- EXT LIGHTS...................................SET   (PM)
-- TCAS.....................................TA / RA   (PM)
-- ENGINE MODE..........................AS REQUIRED   (PM)
-- == APU 
--   BLEED SWITCH.......................AS REQUIRED   (PM)
--   MASTER SWITCH......................AS REQUIRED   (PM)
-- == Anti-Ice 
--   ENGINE ANTI-ICE....................AS REQUIRED   (PM)
--   WING ANTI-ICE......................AS REQUIRED   (PM)
-- MCDU.......................PF=PERF CLB, PM=F-PLN (BOTH)
-- Whatever comes first
-- TRANSITION ALTITUDE.............ANNOUNCE REACHED   (PM)
-- ALTIMETERS...................................STD (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...........................RETRACT   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF   (PM)
-- BELTS SWITCH.................................OFF   (PM)
-- EFIS.......................PF=CSTR/ARPT, PM=ARPT (BOTH)
-- TILT/TERRAIN........PF=WX ON, PF=TERR OFF, WX=ON (BOTH)
-- =======================================================

local takeoffProc = Procedure:new("TAKEOFF & INITIAL CLIMB","takeoff")
takeoffProc:setFlightPhase(8)
takeoffProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_for_takeoff() 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
-- takeoffProc:addItem(ProcedureItem:new("SET TAKEOFF THRUST","T/O MODE",FlowItem.actorPF,0,
	-- function () return get("laminar/B738/engine/indicators/N1_percent_1") > 70 end,
	-- function () command_once("laminar/B738/autopilot/left_toga_press") kc_speakNoText(0,"takeoff thrust set") end))
--takeoffProc:addItem(IndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",FlowItem.actorPNF,0,"toposrate",
--	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 0 and get("sim/flightmodel/position/y_agl") > 40 end))

local gearUpProc = Procedure:new("GEAR UP","Gear up")
gearUpProc:setFlightPhase(-8)
gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return get("ckpt/gearHandle") == 1 end,
	function () 
		command_once("sim/flight_controls/landing_gear_down") 
		kc_speakNoText(0,"gear coming up") 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in
	end))

-- flaps schedule
local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(-8)
flapsUpProc:addItem(SimpleProcedureItem:new("Retract Flaps when Speed reached"))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 2","COMMAND",FlowItem.actorCPT,nil,
 	function () return sysControls.flapsSwitch:getStatus() < 0.75 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 2","SET",FlowItem.actorPNF,0,true,
	function () set("sim/cockpit2/controls/flap_ratio",0.5) kc_speakNoText(0,"speed check flaps 2") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.75 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 1","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,true,
	function () set("sim/cockpit2/controls/flap_ratio",0.25) kc_speakNoText(0,"speed check flaps 1") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,true,
	function () set("sim/cockpit2/controls/flap_ratio",0) kc_speakNoText(0,"speed check flaps up") end))


-- ================== DESCENT PREPARATION ================
-- == Planning
--   Weather & Landing Info 1 – Check pm
--   ECAM Status – Check pm 
--   Nav Charts – Prepare both
--   Landing Conditions – Confirm 2 both
--   Landing Performance – Compute & Cross Check 3 both
--   AUTO BRK – AS REQ 4 pf
--   No Full Flaps – Select GPWS LDG FLAP 3 pm
-- == Preparation (PF)
--   • F-PLN A (DES WINDS / ARRIVAL) 5
--   • RAD NAV
--   • PROG (BRG / DIST TO RWY)
--   • PERF:
--     o CRUISE (cabin descent rate)
--     o DES (Mach / Speed)
--     o APPR:
--       ▪ QNH
--       ▪ Temperature
--       ▪ Destination Wind 6
--       ▪ Minimum
--       ▪ Landing CONF
--     o GO-AROUND:
--       ▪ Thrust reduction
--       ▪ Acceleration altitude
--   • FUEL PREDICTION
--   • SEC F-PLN (Alternate Runway etc.)
--   • Landing Elevation – Mode & Value
-- == Arrival Briefing (PF)
-- == Descent Clearance Obtained by PM
--   ALTITUDE WINDOW..SET CLEARED ALTITUDE pf
--   TCAS..SET PM
-- =======================================================

-- =================== ARRIVAL BRIEFING ==================
-- == AIRCRAFT 
--   Technical Status
-- == AIRFIELD (DEST & ALT)
--   Weather
--   Terminal information – NOTAMS etc.
--   Fuel – Extra Holding
-- == STAR
--   • NAV Frequencies
--   • Routing and Constraints
--   • Transition Level
--   • MSA
-- == APPRPOACH
--   • NAV Frequencies
--   • Approach and Minima
--   • Transition Level
--   • MSA
--   • Obstacles
--   • Restricted / Prohibited areas
-- == GOAROUND
--   • ATC Procedure
--   • Aircraft Procedure
-- == RUNWAY
--   Dimensions (Length, Width, Distance beyond G/S)
--   Surface Condition
--   Lighting
-- ==TAXI
--   Routing and Parking
-- == SPECIAL PROCEDURES
--   Weather (Circumnavigation etc.)
--   Terrain
--   Failures (Communication, MEL etc.)
-- =======================================================

-- ================= DESCENT PROCEDURE ==================
-- MCDU..PF=PROG / PERF DES, PM=F-PLN (BOTH)
-- == Speeds
--   Managed – If Not then:
--     o 0.78 / 300 till FL100
--     o 250 below FL100
-- == Tilt / Terrain
--   Tilt – Adjust WX Radar PF
--   Terrain ON ND 3 PM
-- Whatever comes first
-- TRANSITION LEVEL................ANNOUNCE REACHED   (PM)
-- ALTIMETERS...............................QNH SET (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................SET   (PM)
-- SEAT BELTS............................ON   (PM)
-- EFIS.......................CSTR (BOTH)
-- LS...AS REQUIRED (BOTH)
-- RAD / NAV..SELECTED & IDENTIFIED PM
-- ENG MODE.. AS REQUIRED (PM)
-- =======================================================

local descentProc = Procedure:new("DESCENT PROCEDURE","I have control","you have control")
descentProc:setFlightPhase(11)
descentProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () 
		kc_wnd_brief_action = 1 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities		
	end))
descentProc:addItem(HoldProcedureItem:new("KPCREW APPROACH BRIEFING","FILLED OUT",FlowItem.actorCPT))
descentProc:addItem(HoldProcedureItem:new("MCDU","PF=PROG/PERF DES,PM=F-PLN",FlowItem.actorBOTH))


descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|get(\"laminar/B738/FMS/vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 and 
				sysEFIS.minsResetPilot:getStatus() == 1 and 
				math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("approach:decision") end,
	function ()
				local flag = 0 
				if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
				sysEFIS.minsTypePilot:actuate(flag) 
				sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
descentProc:addItem(ProcedureItem:new("VREF","SELECT IN FMC",FlowItem.actorPF,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 end))
descentProc:addItem(HoldProcedureItem:new("NAVIGATION RADIOS","SET FOR THE APPROACH",FlowItem.actorPF))
descentProc:addItem(HoldProcedureItem:new("TRANSITION LEVEL DESCENT FORECAST","SET",FlowItem.actorPF))
descentProc:addItem(HoldProcedureItem:new("FMC","SET FOR APPROACH",FlowItem.actorPF))
descentProc:addItem(HoldProcedureItem:new("APPROACH BRIEFING","PERFORM",FlowItem.actorPF))
descentProc:addItem(ProcedureItem:new("LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",FlowItem.actorPM,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(0) end,
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(SimpleProcedureItem:new("  If center tank quantity at or below 3,000 lbs/1400 kgs",
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(ProcedureItem:new("PRESSURIZATION","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentProc:addItem(ProcedureItem:new("RECALL","CHECKED ALL OFF",FlowItem.actorPM,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,0,
	function () return sysGeneral.autobrake:getStatus() == activeBriefings:get("approach:autobrake") end,
	function () 
		kc_macro_b738_set_autobrake()
	end))
descentProc:addItem(ProcedureItem:new("F/O MONITORS TRANS LVL AND 10000 FT","CHECK",FlowItem.actorPM,0,true,
	function () 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities
	end))
descentProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,0,
	function () return sysGeneral.autobrake:getStatus() == activeBriefings:get("approach:autobrake") end,
	function () 
		kc_macro_b738_set_autobrake()
	end))


-- ================== APPROACH CHECKLIST =================
-- BARO REF....................................____ (BOTH)
-- SEAT BELTS....................................ON   (PM)
-- MINIMUM.....................................____   (PF)
-- AUTO BRAKE..................................____   (PF)
-- ENG MODE SEL................................____   (PF)
-- =======================================================

local approachChkl = Checklist:new("APPROACH CHECKLIST","","approach CHECKLIST completed")
approachChkl:setFlightPhase(12)
approachChkl:addItem(ChecklistItem:new("BARO REF","____",FlowItem.actorBOTH,1,true,nil))
approachChkl:addItem(ChecklistItem:new("SEAT BELTS","ON",FlowItem.actorPM,1,true,nil))
approachChkl:addItem(ChecklistItem:new("MINIMUM","____",FlowItem.actorPF,1,true,nil))
approachChkl:addItem(ChecklistItem:new("AUTO BRAKE","____",FlowItem.actorPF,1,true,nil))
approachChkl:addItem(ChecklistItem:new("ENG MODE SEL","____",FlowItem.actorPF,1,true,nil))

-- =============== LANDING PROCEDURE (PM) ================
-- LANDING LIGHTS................................ON   (PF)
-- APPROACH PHASE..........................ACTIVATE   (PF)
-- 3NM FROM FDP OR S-SPEED..................REACHED
-- FLAPS 1......................................SET   (PM)
-- 2000 FT AGL..............................REACHED
-- FLAPS 2......................................SET   (PM)
-- LANDING GEAR................................DOWN   (PM)
-- AUTO BRAKE...........................SET/CONFIRM   (PM)
-- RWY TURNOFF LIGHTS............................ON   (PM)
-- NODE LIGHTS...................................ON   (PM)
-- GROUND SPOILERS..............................ARM   (PM)
-- FLAPS 3......................................SET   (PM)
-- ECAM WHEEL PAGE............................CHECK   (PM)
-- GO AROUND ALTITUDE.......................... SET   (PM)
-- FLAPS FULL...................................SET   (PM)
-- LANDING MEMO.......................CHECK NO BLUE
-- CABIN REPORT.............................RECEIVE
-- A/THR..........................SPEED MODE OR OFF
-- WING ANTI-ICE................................OFF
-- =======================================================

-- ================== LANDING CHECKLIST ==================
-- ECAM MEMO..........................LDG - NO BLUE   (PM)
--   - LDG GEAR DN
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS SET
-- =======================================================

local landingChkl = Checklist:new("LANDING CHECKLIST","","landing CHECKLIST completed")
landingChkl:setFlightPhase(14)
landingChkl:addItem(ChecklistItem:new("ECAM MEMO","LDG - NO BLUE",FlowItem.actorPM,1,true,nil))
landingChkl:addItem(SimpleChecklistItem:new("  - LDG GEAR DN"))
landingChkl:addItem(SimpleChecklistItem:new("  - SIGNS ON"))
landingChkl:addItem(SimpleChecklistItem:new("  - CABIN READY"))
landingChkl:addItem(SimpleChecklistItem:new("  - SPLRS ARM"))
landingChkl:addItem(SimpleChecklistItem:new("  - FLAPS SET"))

-- ============== AFTER LANDING PROCEDURE ================
-- GROUND SPOILERS...........................DISARM   (PF)
-- STROBES......................................OFF   (PF)
-- LANDING LIGHTS...............................OFF   (PF)
-- TAXI LIGHTS...................................ON   (PF)
-- CHRONO & ET.................................STOP  (CPT)
-- RADAR........................................OFF
-- PWS..........................................OFF
-- ENGINE MODE SELECTOR........................NORM
-- FLAPS....................................RETRACT
-- TCAS.....................................STANDBY
-- ATC..................................AS REQUIRED
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)
-- ENGINE ANTI-ICE......................AS REQUIRED
-- WING ANTI-ICE........................AS REQUIRED
-- BRAKE TEMPERATURE..........................CHECK
-- =======================================================

-- =============== AFTER LANDING CHECKLIST ===============
-- RADAR & PRED W/S.............................OFF   (PM)
-- =======================================================

local afterLandingChkl = Checklist:new("AFTER LANDING CHECKLIST","","after landing CHECKLIST completed")
afterLandingChkl:setFlightPhase(15)
afterLandingChkl:addItem(ChecklistItem:new("RADAR & PRED W/S","OFF",FlowItem.actorPM,1,true,nil))

-- ================== PARKING PROCEDURE ==================
-- TAXI LIGHT SWITCH............................OFF   (PF) 
-- == Parked at Gate
--   ACCU PRESSURE............................CHECK   (PF)
--   PARKING BRAKES..............................ON   (PF)
--   BRAKE PRESSURE INDICATOR.................CHECK   (PF)
--   ENGINE ANTI-ICE............................OFF   (PM)
--   WING ANTI-ICE..............................OFF   (PM)
--   ELECTRIC POWER:
--     IF APU AVAILABLE – APU BLEED..............ON   (PM)
--     IF EXT PWR AVAIL – EXT PWR................ON   (PM)
-- ENGINE MASTER SWITCHES.......................OFF   (PF) 
-- == MISC. Do Items
--   WING LIGHTS................................OFF   (PF)
--   BEACON.....................................OFF   (PF)
--   SEAT BELTS.................................OFF   (PF)
--   FUEL PUMPS.................................OFF   (PM)
--   ATC....................................STANDBY   (PM)
--   BRAKE FAN..................................OFF   (PM)
-- == Ground Contact
--   PARKING BRAKE......................AS REQUIRED   (PF)
--   CHOCKS................................IN PLACE   (PF)
-- =======================================================


-- ================== PARKING CHECKLIST ==================
-- PARK BRK OR CHOCKS...........................SET   (PF)
-- ENGINES......................................OFF   (PF)
-- WING LIGHTS..................................OFF   (PF)
-- FUEL PUMPS...................................OFF   (PF)
-- =======================================================

local parkingChkl = Checklist:new("PARKING CHECKLIST","","parking CHECKLIST completed")
parkingChkl:setFlightPhase(17)
parkingChkl:addItem(ChecklistItem:new("PARK BRK OR CHOCKS","SET",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("ENGINES","OFF",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("WING LIGHTS","OFF",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("FUEL PUMPS","OFF",FlowItem.actorPF,1,true,nil))

-- =========== SECURING THE AIRCRAFT PROCEDURE ===========
-- PARKING BRAKE...........................CHECK ON   (PF)
-- ADIRS..................ALL IR MODE SELECTORS OFF   (PF)
-- OXYGEN CREW SUPPLY...........................OFF   (PM)
-- EXTERIOR LIGHTS..............................OFF   (PM)
-- MAINTENANCE BUS......................AS REQUIRED   (PM)
-- APU..................BLEED AND MASTER SWITCH OFF   (PM)
-- EMERGENCY EXIT LIGHTS AND SIGNS..............OFF   (PM)
-- EXTERNAL POWER.......................AS REQUIRED   (PM)
-- BATTERY................................1 & 2 OFF   (PM)
-- =======================================================



-- =========== SECURING THE AIRCRAFT CHECKLIST ===========
-- OXYGEN.......................................OFF   (PM)
-- EMER EXIT LIGHT..............................OFF   (PM)
-- EFB..........................................OFF   (PM)
-- BATTERIES....................................OFF   (PM)
-- =======================================================

local securingChkl = Checklist:new("SECURING THE AIRCRAFT CHECKLIST","","securing the aircraft CHECKLIST completed")
securingChkl:setFlightPhase(1)
securingChkl:addItem(ChecklistItem:new("OXYGEN","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("EFB","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("BATTERIES","OFF",FlowItem.actorPM,1,true,nil))

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		-- getActiveSOP():setActiveFlowIndex(1)
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)

turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
	end))

-- === Recover Takeoff modes
local recoverTakeoff = State:new("Recover Takeoff","","")
recoverTakeoff:setFlightPhase(8)
-- recoverTakeoff:addItem(ProcedureItem:new("Recover","SET","SYS",0,true,
	-- function () 
		-- kc_procvar_set("fmacallouts",true) -- activate FMA callouts
		-- sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA)
		-- sysRadios.xpdrCode:actuate(activeBriefings:get("departure:squawk"))
		-- kc_procvar_set("above10k",true) -- background 10.000 ft activities
		-- kc_procvar_set("attransalt",true) -- background transition altitude activities
		-- kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in

	-- end))


-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("apustart", false) -- start apu
kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("aftertakeoff", false) -- triggers after takeoff activities by FO
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		if kc_procvar_get("apustart") == true then 
			kc_bck_apustart("apustart")
		end
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
activeSOP:addProcedure(cockpitPrepChkl)
activeSOP:addProcedure(beforePushStart)
activeSOP:addProcedure(beforeStartChkl)
activeSOP:addProcedure(pushProc)
activeSOP:addProcedure(pushstartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(afterStartChkl)
activeSOP:addProcedure(beforeTaxiProc)
activeSOP:addProcedure(taxiChkl)
activeSOP:addProcedure(TaxiProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(takeoffProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(flapsUpProc)
-- activeSOP:addProcedure(afterLandingChkl)
-- activeSOP:addProcedure(securingChkl)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)
-- activeSOP:addState(recoverTakeoff)


function getActiveSOP()
	return activeSOP
end

return SOP_A20N