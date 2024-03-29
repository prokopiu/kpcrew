-- Standard Operating Procedure for FlyJsim B732

-- @classmod SOP_B732
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_B732 = {
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
local ProcedureItem 		= require "kpcrew.procedures.ProcedureItem"
local SimpleProcedureItem 	= require "kpcrew.procedures.SimpleProcedureItem"
local IndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

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

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Cockpit Prep", [3] = "Cockpit Prep", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }


-- Set up SOP =========================================================================

activeSOP = kcSOP:new("FJS B732 SOP")

-- ============ Electrical Power Up Procedure ===========
-- ===== Initial checks
-- DC Electric Power
-- CIRCUIT BREAKERS (P6 PANEL)................CHECK (F/O)
-- CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL).CHECK (F/O)
-- DC METER SWITCH..............................BAT (F/O)
-- BATTERY VOLTAGE..........................MIN 24V (F/O)
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- CIRCUIT BREAKERS..........................ALL IN (F/O)
-- Hydraulic System
-- ALTERNATE FLAPS MASTER SWITCH.......GUARD CLOSED (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)
-- Other
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- LANDING GEAR LEVER..........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT.....CHECK ILLUMINATED (F/O)
--   RED LANDING GEAR LIGHT......CHECK EXTINGUISHED (F/O)

-- ==== Activate External Power
--   Use Zibo EFB to turn Ground Power on.         
--   GRD POWER AVAILABLE LIGHT..........ILLUMINATED (F/O)
--   GROUND POWER SWITCH.........................ON (F/O)

-- ==== Activate APU 
--   OVHT FIRE TEST SWITCH...............HOLD RIGHT (F/O)
--   MASTER FIRE WARN LIGHT....................PUSH (F/O)
--   ENGINES EXT TEST SWITCH...........TEST TO LEFT (F/O)
--   APU......................................START (F/O)
--     Hold APU switch in START position for 3-4 seconds.
--     APU GEN OFF BUS LIGHT............ILLUMINATED (F/O)
--     APU GENERATOR BUS SWITCHES................ON (F/O)

-- TRANSFER BUS LIGHTS...........CHECK EXTINGUISHED (F/O)
-- SOURCE OFF LIGHTS.............CHECK EXTINGUISHED (F/O)
-- STANDBY POWER.................................ON (F/O)
--   STANDBY PWR LIGHT...........CHECK EXTINGUISHED (F/O)
-- Next: Preliminary Preflight Procedure           

local electricalPowerUpProc = kcProcedure:new("ELECTRICAL POWER UP (F/O)","performing ELECTRICAL POWER UP")
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Initial Checks"))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("DC Electric Power"))
electricalPowerUpProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (P6 PANEL)","CHECK",kcFlowItem.actorFO,1,true))
electricalPowerUpProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL)","CHECK",kcFlowItem.actorFO,1,true))
electricalPowerUpProc:addItem(kcProcedureItem:new("DC POWER SWITCH","BAT",kcFlowItem.actorFO,2,
	function () return sysElectric.dcPowerSwitch:getStatus() == sysElectric.dcPwrBAT end,
	function () sysElectric.dcPowerSwitch:setValue(sysElectric.dcPwrBAT) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("BATTERY VOLTAGE","MIN 24V",kcFlowItem.actorFO,2,"bat24v",
	function () return sysElectric.batt1Volt:getStatus() > 23 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPowerCover:getStatus() == modeOff end,
	function () sysElectric.stbyPowerCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS","ALL IN",kcFlowItem.actorFO,2,true))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Hydraulic System"))
electricalPowerUpProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,3,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,3,
	function () return sysControls.altFlapsCover:getStatus() == modeOff end,
	function () sysControls.altFlapsCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Other"))
electricalPowerUpProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,2,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DOWN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsRed:getStatus() == 0 end))

electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use FJS Menu to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GROUND POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return get("FJS/732/Elec/P_GPUPwr1On") == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,2,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > modeOff end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,"masterfire",
	function () return get("FJS/732/FireProtect/FireWarnBellCutoutButtonL") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST TO LEFT",kcFlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("FJS/732/FireProtect/ExtinguisherTestSwitch") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,"apu_gen_off_bus",
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuStartSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,2,"apugenson",
	function () return sysElectric.apuGenSwitches:getStatus() > 0 end,
	function () sysElectric.apuGenSwitches:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
	
electricalPowerUpProc:addItem(kcProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end,
	function () if activePrefSet:get("aircraft:powerup_apu") == true then sysElectric.apuGenSwitches:actuate(0) end end))
electricalPowerUpProc:addItem(kcProcedureItem:new("SOURCE OFF LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.sourceOff1:getStatus() == modeOff and sysElectric.sourceOff2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER","ON",kcFlowItem.actorFO,2,
	function () return get("FJS/732/Elec/StbyPowerSwitch") > 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPwrOff:getStatus() == modeOff end))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))

-- ============ Preliminary Preflight Procedures ========
-- EMERGENCY EXIT LIGHT.........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON..........................PRESS (F/O)
-- ELECTRICAL POWER UP.....................COMPLETE (F/O)
-- VOICE RECORDER SWITCH.......................AUTO (F/O)
-- MACH OVERSPEED TEST......................PERFORM (F/O)
-- STALL WARNING TEST.......................PERFORM (F/O)
-- XPDR....................................SET 2000 (F/O)
-- COCKPIT LIGHTS.....................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS.........SET AS REQUIRED (F/O)
-- POSITION LIGHTS...............................ON (F/O)
-- ==== FUEL PUMPS
-- FUEL PUMPS...............................ALL OFF (F/O)
-- FUEL CROSS FEED..............................OFF (F/O)
-- MCP...................................INITIALIZE (F/O)
-- PARKING BRAKE................................SET (F/O)
-- GALLEY POWER..................................ON (F/O)
-- Next: CDU Preflight                             

local prelPreflightProc = kcProcedure:new("PREL PREFLIGHT PROCEDURE (F/O)")
prelPreflightProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHT","ARM #exchange|/ON GUARD CLOSED| #",kcFlowItem.actorFO,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff  end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",kcFlowItem.actorFO,2,"attendence_button",
	function () return sysGeneral.attendanceButton:getStatus() > modeOff end))
	-- ,function () sysGeneral.attendanceButton:actuate(modeOn)))
prelPreflightProc:addItem(kcProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",kcFlowItem.actorFO,1,
	function () return 
		sysElectric.apuAvailAnc:getStatus() > 0 or sysElectric.gpuAvailAnc:getStatus() > 0
	end))
prelPreflightProc:addItem(kcProcedureItem:new("FLT RECORDER SWITCH","AUTO",kcFlowItem.actorFO,2,
	function () return  sysGeneral.voiceRecSwitch:getStatus() == modeOff and sysGeneral.vcrCover:getStatus() == modeOff end,
	function () sysGeneral.voiceRecSwitch:actuate(modeOn) sysGeneral.vcrCover:actuate(modeOff) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",kcFlowItem.actorFO,2,"mach_ovspd_test",
	function () return get("FJS/732/Annun/MachWarningTestButton") == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST","PERFORM",kcFlowItem.actorFO,2,"stall_warning_test",
	function () return get("FJS/732/Annun/StallWarningSwitch") == 1 end))
prelPreflightProc:addItem(kcProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",kcFlowItem.actorFO,2,
	function () return get("sim/cockpit/radios/transponder_code") == 2000 end))
prelPreflightProc:addItem(kcProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("POSITION LIGHTS","ON",kcFlowItem.actorFO,2,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))

prelPreflightProc:addItem(kcSimpleProcedureItem:new("==== FUEL PUMPS"))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == 0 end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))

prelPreflightProc:addItem(kcProcedureItem:new("#spell|MCP#","INITIALIZE",kcFlowItem.actorFO,2,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		sysMCP.fltdirSelector:adjustValue(0,-1,5)
		sysMCP.crsSelectorGroup:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.apmodeSelector:adjustValue(0,0,3)
		sysMCP.hdgmodeSelector:adjustValue(1,0,2)
		sysMCP.pitchSelect:adjustValue(0,-1,1)
		sysMCP.rollEngage:actuate(0)
		sysMCP.pitchEngage:actuate(0)
	end))
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(kcProcedureItem:new("#spell|GALLEY POWER","ON",kcFlowItem.actorFO,3,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))

-- ================== CDU Preflight ==================
-- INITIAL DATA (CPT)                              
--   IDENT page:...............................OPEN (CPT)
--     Verify Model and ENG RATING                 
--     Verify navigation database ACTIVE date      
--   POS INIT page:............................OPEN (CPT)
--     Verify time                                 
--     REF AIRPORT..............................SET (CPT)
-- NAVIGATION DATA (CPT)                           
--   RTE page:.................................OPEN (CPT)
--     ORIGIN...................................SET (CPT)
--     DEST.....................................SET (CPT)
--     FLT NO...................................SET (CPT)
--     ROUTE..................................ENTER (CPT)
--     ROUTE...............................ACTIVATE (CPT)
--     ROUTE................................EXECUTE (CPT)
--   DEPARTURES page:..........................OPEN (CPT)
--     Select runway and departure routing         
--     ROUTE:...............................EXECUTE (CPT)
--   LEGS page:................................OPEN (CPT)
--     Verify or enter correct RNP for departure   
-- PERFORMANCE DATA (CPT)                          
--   PERF INIT page:...........................OPEN (CPT)
--     ZFW....................................ENTER (CPT)
--     GW..............................ENTER/VERIFY (CPT)
--     RESERVES........................ENTER/VERIFY (CPT)
--     COST INDEX.............................ENTER (CPT)
--     CRZ ALT................................ENTER (CPT)
--   N1 LIMIT page:............................OPEN (CPT)
--     Select assumed temp and/or fixed t/o rating 
--     Select full or derated climb thrust         
--   TAKEOFF REF page:.........................OPEN (CPT)
--     FLAPS..................................ENTER (CPT)
--     CG.....................................ENTER (CPT)
--     V SPEEDS...............................ENTER (CPT)
-- PREFLIGHT COMPLETE?.......................VERIFY (CPT)


local cduPreflightProc = kcProcedure:new("CDU PREFLIGHT PROCEDURE (CPT)")
cduPreflightProc:addItem(kcSimpleProcedureItem:new("INITIAL DATA (CPT)"))
cduPreflightProc:addItem(kcProcedureItem:new("  IDENT page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify Model and ENG RATING"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(kcProcedureItem:new("  POS INIT page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(kcProcedureItem:new("    REF AIRPORT","SET",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("NAVIGATION DATA (CPT)"))
cduPreflightProc:addItem(kcProcedureItem:new("  RTE page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ORIGIN","SET",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    DEST","SET",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    FLT NO","SET",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE","ENTER",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE","ACTIVATE",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE","EXECUTE",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("  DEPARTURES page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE:","EXECUTE",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("  LEGS page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("PERFORMANCE DATA (CPT)"))
cduPreflightProc:addItem(kcProcedureItem:new("  PERF INIT page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ZFW","ENTER",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    GW","ENTER/VERIFY",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    RESERVES","ENTER/VERIFY",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    COST INDEX","ENTER",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("    CRZ ALT","ENTER",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcProcedureItem:new("  N1 LIMIT page:","OPEN",kcFlowItem.actorCPT,1,function () return true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(kcProcedureItem:new("  TAKEOFF REF page:","OPEN",kcFlowItem.actorCPT,1,"takeoff_ref_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"TAKEOFF REF") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    FLAPS","ENTER",kcFlowItem.actorCPT,1,"flaps_entered",
	function () return sysFMC.fmcFlapsEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    CG","ENTER",kcFlowItem.actorCPT,1,"cg_entered",
	function () return sysFMC.fmcCGEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    V SPEEDS","ENTER",kcFlowItem.actorCPT,1,"vspeeds_entered",
	function () return sysFMC.fmcVspeedsEntered:getStatus() == true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("CDU PREFLIGHT COMPLETE"))

-- ================ Preflight Procedure =================
-- Flight control panel                            
-- FLIGHT CONTROL SWITCHES............GUARDS CLOSED (F/O)
-- FLIGHT SPOILER SWITCHES............GUARDS CLOSED (F/O)
-- YAW DAMPER SWITCH.............................ON (F/O)
-- NAVIGATION & DISPLAYS panel                     
-- VHF NAV TRANSFER SWITCH...................NORMAL (F/O)
-- IRS TRANSFER SWITCH.......................NORMAL (F/O)
-- FMC TRANSFER SWITCH.......................NORMAL (F/O)
-- SOURCE SELECTOR.............................AUTO (F/O)
-- CONTROL PANEL SELECT SWITCH...............NORMAL (F/O)
-- Fuel panel                                      
-- CROSSFEED SELECTOR........................CLOSED (F/O)
-- FUEL PUMP SWITCHES...........................OFF (F/O)
-- Electrical panel                                
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH.........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH....................ON (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH.................GUARD CLOSED (F/O)
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH.................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH..........TEST 2 TO RIGHT (F/O)
-- APU SWITCH.................................START (F/O)
-- APU GEN OFF BUS LIGHT................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES....................ON (F/O)
-- EQUIPMENT COOLING SWITCHES..................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH.............................ON (F/O)
-- FASTEN BELTS SWITCH...........................ON (F/O)
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- WINDOW HEAT SWITCHES..........................ON (F/O)
-- PROBE HEAT SWITCHES..........................OFF (F/O)
-- WING ANTI-ICE SWITCH.........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES.....................OFF (F/O)
-- Hydraulic panel                                 
-- ENGINE HYDRAULIC PUMPS SWITCHES...............ON (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)

local preflightFOProc = kcProcedure:new("PREFLIGHT PROCEDURE PART 1 (F/O)")
preflightFOProc:addItem(kcSimpleProcedureItem:new("Flight control panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysControls.fltCtrlCovers:getStatus() == modeOff end,
	function () sysControls.fltCtrlCovers:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysControls.spoilerCovers:getStatus() == modeOff  end,
	function () sysControls.spoilerCovers:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("YAW DAMPER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysControls.yawDamper:getStatus() == modeOn end,
	function () sysControls.yawDamper:actuate(modeOn) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("NAVIGATION & DISPLAYS panel"))
preflightFOProc:addItem(kcProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.vhfNavSwitch:getStatus() == 0 end,
	function () sysMCP.vhfNavSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.irsNavSwitch:getStatus() == 0 end,
	function () sysMCP.irsNavSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.fmcNavSwitch:getStatus() == 0 end,
	function () sysMCP.fmcNavSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("SOURCE SELECTOR","AUTO",kcFlowItem.actorFO,2,
	function() return sysMCP.displaySourceSwitch:getStatus() == 0 end,
	function () sysMCP.displaySourceSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.displayControlSwitch:getStatus() == 0 end,
	function () sysMCP.displayControlSwitch:setValue(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Fuel panel"))
preflightFOProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Electrical panel"))
preflightFOProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("CAB/UTIL POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("#spell|IFE# POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.ifePwr:getStatus() == modeOn end,
	function () sysElectric.ifePwr:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPowerCover:getStatus() == modeOff end,
	function () sysElectric.stbyPowerCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.genDriveCovers:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.busTransCover:getStatus() == 0 end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Overheat and fire protection panel"))
-- preflightFOProc:addItem(kcProcedureItem:new("OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,function (self) return true end,nil,nil))
preflightFOProc:addItem(kcIndirectProcedureItem:new("OVHT FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,2,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end))
-- preflightFOProc:addItem(kcIndirectProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,"master_fire_warn",
	-- function () return sysGeneral.fireWarningAnc:getStatus() > 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,2,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end))
preflightFOProc:addItem(kcProcedureItem:new("APU SWITCH","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("APU GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("APU GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end))

preflightFOProc:addItem(kcProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.equipCoolExhaust:getStatus() == modeOff and sysGeneral.equipCoolSupply:getStatus() == 0 end,
	function () sysGeneral.equipCoolExhaust:actuate(modeOff) sysGeneral.equipCoolSupply:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("NO SMOKING SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:adjustValue(1,0,2) end))
preflightFOProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () sysGeneral.seatBeltSwitch:adjustValue(1,0,2) end))
preflightFOProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,2,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WINDOW HEAT SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
preflightFOProc:addItem(kcSimpleProcedureItem:new("Continue with part 2"))

-- ========== PREFLIGHT PROCEDURE PART 2 (F/O) ==========
-- Air conditioning panel                          
-- AIR TEMPERATURE SOURCE SELECTOR........AS NEEDED (F/O)
-- TRIM AIR SWITCH...............................ON (F/O)
-- RECIRCULATION FAN SWITCHES..................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH..............AUTO OR OPEN (F/O)
-- ENGINE BLEED AIR SWITCHES.....................ON (F/O)
-- APU BLEED AIR SWITCH..........................ON (F/O)
-- Cabin pressurization panel                      
-- FLIGHT ALTITUDE INDICATOR........CRUISE ALTITUDE (F/O)
-- LANDING ALTITUDE INDICATOR..DEST FIELD ELEVATION (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO (F/O)
-- Lighting panel                                  
-- LANDING LIGHT SWITCHES...........RETRACT AND OFF (F/O)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF (F/O)
-- TAXI LIGHT SWITCH............................OFF (F/O)
-- LOGO LIGHT SWITCH......................AS NEEDED (F/O)
-- POSITION LIGHT SWITCH..................AS NEEDED (F/O)
-- ANTI-COLLISION LIGHT SWITCH..................OFF (F/O)
-- WING ILLUMINATION SWITCH...............AS NEEDED (F/O)
-- WHEEL WELL LIGHT SWITCH................AS NEEDED (F/O)
-- IGNITION SELECT SWITCH................IGN L OR R (F/O)
-- ENGINE START SWITCHES........................OFF (F/O)

local preflightFO2Proc = kcProcedure:new("PREFLIGHT PROCEDURE PART 2 (F/O)")

preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Hydraulic panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
preflightFO2Proc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
	
preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Air conditioning panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","AS NEEDED",kcFlowItem.actorFO,2,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("TRIM AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFO2Proc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
preflightFO2Proc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",kcFlowItem.actorFO,2,
	function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,
	function () sysAir.packLeftSwitch:setValue(1) sysAir.packRightSwitch:setValue(1) end))
preflightFO2Proc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
preflightFO2Proc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end))

preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Cabin pressurization panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("FLIGHT ALTITUDE INDICATOR","CRUISE ALTITUDE",kcFlowItem.actorFO,2))
preflightFO2Proc:addItem(kcProcedureItem:new("LANDING ALTITUDE INDICATOR","DEST FIELD ELEVATION",kcFlowItem.actorFO,2))
preflightFO2Proc:addItem(kcProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))

preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Lighting panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end))
preflightFO2Proc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(0) end))
preflightFO2Proc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
preflightFO2Proc:addItem(kcProcedureItem:new("LOGO LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.logoSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.logoSwitch:actuate( kc_is_daylight() and 0 or 1) end ))
preflightFO2Proc:addItem(kcProcedureItem:new("POSITION LIGHT SWITCH","AS NEEDED",kcFlowItem.actorFO,2))
preflightFO2Proc:addItem(kcProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))
preflightFO2Proc:addItem(kcProcedureItem:new("WING ILLUMINATION SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightFO2Proc:addItem(kcProcedureItem:new("WHEEL WELL LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightFO2Proc:addItem(kcProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",kcFlowItem.actorFO,2,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:adjustValue(1,0,3) end)) 
preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Continue with part 3"))

-- ========== PREFLIGHT PROCEDURE PART 3 (F/O) ==========
-- Mode control panel                              
-- COURSE(S)....................................SET (F/O)
-- FLIGHT DIRECTOR SWITCHES......................ON (F/O)
-- EFIS control panel                              
-- MINIMUMS REFERENCE SELECTOR........RADIO OR BARO (F/O)
-- MINIMUMS SELECTOR.........SET DH OR DA REFERENCE (F/O)
-- FLIGHT PATH VECTOR SWITCH....................OFF (F/O)
-- METERS SWITCH................................OFF (F/O)
-- BAROMETRIC REFERENCE SELECTOR..........IN OR HPA (F/O)
-- BAROMETRIC SELECTOR..SET LOCAL ALTIMETER SETTING (F/O)
-- VOR/ADF SWITCHES.......................AS NEEDED (F/O)
-- MODE SELECTOR................................MAP (F/O)
-- CENTER SWITCH..........................AS NEEDED (F/O)
-- RANGE SELECTOR.........................AS NEEDED (F/O)
-- TRAFFIC SWITCH.........................AS NEEDED (F/O)
-- WEATHER RADAR................................OFF (F/O)
-- MAP SWITCHES...........................AS NEEDED (F/O)
-- OXYGEN..............................TEST AND SET (F/O)
-- CLOCK........................................SET (F/O)
-- MAIN PANEL DISPLAY UNITS SELECTOR...........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR.................NORM (F/O)
-- GROUND PROXIMITY panel                          
-- FLAP INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- GEAR INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- TERRAIN INHIBIT SWITCH..............GUARD CLOSED (F/O)
-- Landing gear panel                              
-- LANDING GEAR LEVER............................DN (F/O)
-- AUTO BRAKE SELECT SWITCH.....................RTO (F/O)
-- ANTISKID INOP LIGHT..........VERIFY EXTINGUISHED (F/O)
-- Radio tuning panel                              
-- VHF COMMUNICATIONS RADIOS....................SET (F/O)
-- VHF NAVIGATION RADIOS..........SET FOR DEPARTURE (F/O)
-- AUDIO CONTROL PANEL..........................SET (F/O)
-- ADF RADIOS...................................SET (F/O)
-- WEATHER RADAR PANEL..........................SET (F/O)
-- TRANSPONDER PANEL............................SET (F/O)

local preflightFO3Proc = kcProcedure:new("PREFLIGHT PROCEDURE PART 3 (F/O)")
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorFO,2))
preflightFO3Proc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysMCP.fdirGroup:getStatus() == 2 end,
	function () sysMCP.fdirGroup:actuate(1) end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BARO",kcFlowItem.actorFO,2))
preflightFO3Proc:addItem(kcProcedureItem:new("MINIMUMS SELECTOR","SET DH OR DA REFERENCE",kcFlowItem.actorFO,2))
preflightFO3Proc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.fpvPilot:getStatus() == 0 end,
	function () sysEFIS.fpvPilot:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("METERS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.mtrsPilot:getStatus() == 0 end,
	function () sysEFIS.mtrsPilot:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorFO,2,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModePilot:adjustValue(sysEFIS.mapModeMAP,0,3) end))
preflightFO3Proc:addItem(kcProcedureItem:new("CENTER SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("RANGE SELECTOR","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("OXYGEN","TEST AND SET",kcFlowItem.actorFO,2,"oxygentested",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightFO3Proc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
preflightFO3Proc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("GROUND PROXIMITY panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	function () sysGeneral.flapInhibitCover:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	function () sysGeneral.gearInhibitCover:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	function () sysGeneral.terrainInhibitCover:actuate(0) end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("Landing gear panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
preflightFO3Proc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 0 end,
	function () sysGeneral.autobreak:actuate(0) end))
preflightFO3Proc:addItem(kcProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("Radio tuning panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("AUDIO CONTROL PANEL","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("ADF RADIOS","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("WEATHER RADAR PANEL","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("TRANSPONDER PANEL","SET",kcFlowItem.actorFO,1))

-- ============= PREFLIGHT PROCEDURE (CAPT) ============
-- LIGHTS.....................................TEST (CPT)
-- EFIS control panel
-- MINIMUMS REFERENCE SELECTOR..........RADIO/BARO (CPT)
-- DECISION HEIGHT OR ALTITUDE REFERENCE.......SET (CPT)
-- METERS SWITCH.........................MTRS/FEET (CPT)
-- FLIGHT PATH VECTOR.......................ON/OFF (CPT)
-- BAROMETRIC REFERENCE SELECTOR............HPA/IN (CPT)
-- BAROMETRIC SELECTOR.SET LOCAL ALTIMETER SETTING (CPT)
-- VOR/ADF SWITCHES......................AS NEEDED (CPT)
-- MODE SELECTOR...............................MAP (CPT)
-- CENTER SWITCH.........................AS NEEDED (CPT)
-- RANGE SELECTOR........................AS NEEDED (CPT)
-- TRAFFIC SWITCH........................AS NEEDED (CPT)
-- WEATHER RADAR...............................OFF (CPT)
-- MAP SWITCHES..........................AS NEEDED (CPT)
-- Mode control panel


local preflightCPTProc = kcProcedure:new("PREFLIGHT PROCEDURE (CAPT)")
preflightCPTProc:addItem(kcIndirectProcedureItem:new("LIGHTS","TEST",kcFlowItem.actorCPT,1,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",kcFlowItem.actorCPT,1,
	function () return ((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end )) 
preflightCPTProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",kcFlowItem.actorCPT,1,
	function () return sysEFIS.minsResetPilot:getStatus() == 1 and math.ceil(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("arrival:decision") end))
preflightCPTProc:addItem(kcProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",kcFlowItem.actorCPT,1,
	function () return (sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) end ))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",kcFlowItem.actorCPT,1,
	function () return (sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end ))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",kcFlowItem.actorCPT,1,
	function () return (sysGeneral.baroModePilot:getStatus() == 1 and activePrefSet:get("general:baro_mode_hpa") == true) or (sysGeneral.baroModePilot:getStatus() == 0 and activePrefSet:get("general:baro_mode_hpa") == false) end ))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorCPT,1,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end))
preflightCPTProc:addItem(kcProcedureItem:new("CENTER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("RANGE SELECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorCPT,1,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorCPT,1,
	function () return math.floor(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") and math.floor(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",kcFlowItem.actorCPT,1,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end))
preflightCPTProc:addItem(kcProcedureItem:new("BANK ANGLE SELECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",kcFlowItem.actorCPT,1,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Main panel"))
preflightCPTProc:addItem(kcProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Display select panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
preflightCPTProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
preflightCPTProc:addItem(kcProcedureItem:new("INTEGRATED STANDBY FLIGHT DISPLAY","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",kcFlowItem.actorCPT,1,
	function () return sysControls.spoilerLever:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("REVERSE THRUST LEVERS","DOWN",kcFlowItem.actorCPT,1,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",kcFlowItem.actorCPT,1,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("FLAP LEVER","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
preflightCPTProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("RADIO TUNING PANEL","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))

-- old checklist
-- =============== BEFORE START CHECKLIST ==============
-- FLIGHT DECK PREPARATION. . . . . . . . . . . . . . . COMPLETED
-- LIGHT TEST . . . . . . . . . . . . . . . . . . . . . CHECKED
-- OXYGEN & INTERPHONE . . . . . . . . . . . . . . . . .CHECKED
-- YAW DAMPER. . . . . . . . . . . . . . . . . . . . . .ON
-- NAVIGATION TRANSFER AND DISPLAY SWITCHES . . . . . . AUTO & NORMAL
-- FUEL . . . . . . . . . . . . . . . . . . . . . . . . _____KGS & PUMPS ON
-- GALLEY POWER . . . . . . . . . . . . . . . . . . . . ON
-- EMERGENCY EXIT LIGHTS. . . . . . . . . . . . . . . . ARMED
-- PASSENGER SIGNS. . . . . . . . . . . . . . . . . . . SET
-- WINDOW HEAT . . . . . . . . . . . . . . . . . . . . .ON
-- HYDRAULICS . . . . . . . . . . . . . . . . . . . . . NORMAL
-- AIR COND & PRESS. . . . . . . .......................___ PACK(S), BLEEDS ON, SET
-- AUTOPILOTS . . . . . . . . . . . . . . . . . . . . . DISENGAGED
-- INSTRUMENTS . . . . . . . . . . . . . . . . . . . . .X-CHECKED
-- AUTOBRAKE. . . . . . . . . . . . . . . . . . . . . . RTO
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . . . .DOWN DETENT
-- PARKING BRAKE . . . . . . . . . . . . . . . . . . . .SET
-- STABILIZER TRIM CUTOUT SWITCHES. . . . . . . . . . ..NORMAL
-- WHEEL WELL FIRE WARNING . . . . . . . . . . . . . . .CHECKED
-- RADIOS, RADAR, TRANSPONDER & HUD . . . . . . . . . . SET
-- RUDDER & AILERON TRIM . . . . . . . . . . . . . . . .FREE & ZERO
-- PAPERS. . . . . . . . . . . . . . . . . . . . . . . .ABOARD
-- FMC/CDU. . . . . . . . . . . . . . . . . . . . . . . SET
-- N1 & IAS BUGS. . . . . . . . . . . . . . . . . . . . SET


-- ============== PREFLIGHT CHECKLIST (PM) ============= OK
-- OXYGEN..............................TESTED, 100% (PF)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO (PF)
-- WINDOW HEAT...................................ON (PF)
-- PRESSURIZATION MODE SELECTOR................AUTO (PF)
-- PARKING BRAKE................................SET (PF)
-- ENGINE START LEVERS.......................CUTOFF (PF)
-- GEAR PINS................................REMOVED (PF)

local preflightChkl = kcChecklist:new("PREFLIGHT CHECKLIST (PM)")
preflightChkl:addItem(kcIndirectChecklistItem:new("OXYGEN","TESTED #exchange|100 PERC|one hundred percent#",kcFlowItem.actorALL,2,"oxygentested",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(kcChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",kcFlowItem.actorPF,1,
	function () return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end))
preflightChkl:addItem(kcChecklistItem:new("WINDOW HEAT","ON",kcFlowItem.actorPF,1,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end))
preflightChkl:addItem(kcChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorPF,1,
	function () return sysAir.pressModeSelector:getStatus() == 0 end))
preflightChkl:addItem(kcChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",kcFlowItem.actorBOTH,3))
preflightChkl:addItem(kcChecklistItem:new("PARKING BRAKE","SET",kcFlowItem.actorPF,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
preflightChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorPF,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
preflightChkl:addItem(kcChecklistItem:new("GEAR PINS","REMOVED",kcFlowItem.actorPF,1))
preflightChkl:addItem(kcSimpleChecklistItem:new("Preflight Checklist Completed"))

-- ============= BEFORE START PROCEDURE (BOTH) ============
-- FLIGHT DECK DOOR..............CLOSED AND LOCKED (F/O)
-- CDU DISPLAY.................................SET (BOTH)
-- N1 BUGS...................................CHECK (BOTH)
-- IAS BUGS....................................SET (BOTH)
-- Set MCP
--   AUTOTHROTTLE ARM SWITCH...................ARM (CPT)
--   IAS/MACH SELECTOR......................SET V2 (CPT)
--   LNAV............................ARM AS NEEDED (CPT)
--   VNAV............................ARM AS NEEDED (CPT)
--   INITIAL HEADING...........................SET (CPT)
--   INITIAL ALTITUDE..........................SET (CPT)
-- TAXI AND TAKEOFF BRIEFINGS.............COMPLETE (BOTH)
-- EXTERIOR DOORS....................VERIFY CLOSED (F/O)
-- START CLEARANCE..........................OBTAIN (BOTH)
--   Obtain a clearance to pressurize hydraulic systems.
--   Obtain a clearance to start engines.
-- Set Fuel panel
--   CENTER FUEL PUMPS SWITCHES.................ON (F/O)
--     If center tank quantity exceeds 1,000 lbs/460 kgs
--   AFT AND FORWARD FUEL PUMPS SWITCHES........ON (F/O)
-- Set Hydraulic panel
--   ENGINE HYDRAULIC PUMP SWITCHES............OFF (F/O)
--   ELECTRIC HYDRAULIC PUMP SWITCHES...........ON (F/O)
-- ANTI COLLISION LIGHT SWITCH..................ON (F/O)
-- Set Trim
--   STABILIZER TRIM.....................___ UNITS (CPT)
--   AILERON TRIM..........................0 UNITS (CPT)
--   RUDDER TRIM...........................0 UNITS (CPT)
-- Call for Before Start Checklist

local beforeStartProc = kcProcedure:new("BEFORE START PROCEDURE (BOTH)")
beforeStartProc:addItem(kcProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorFO,2,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartProc:addItem(kcProcedureItem:new("CDU DISPLAY","SET",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("N1 BUGS","CHECK",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("IAS BUGS","SET",kcFlowItem.actorBOTH,2,
	function () return sysFMC.noVSpeeds:getStatus() == 0 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(kcProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))
beforeStartProc:addItem(kcProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end))
beforeStartProc:addItem(kcProcedureItem:new("  LNAV","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.lnavSwitch:getStatus() == 1 end, 
	function () sysMCP.lnavSwitch:actuate(modeOn) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(kcProcedureItem:new("  VNAV","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.vnavSwitch:getStatus() == 1 end, 
	function () sysMCP.vnavSwitch:actuate(modeOn) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL HEADING","SET %03d|activeBriefings:get(\"departure:initHeading\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end ))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end ))
beforeStartProc:addItem(kcProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS","COMPLETE",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
beforeStartProc:addItem(kcProcedureItem:new("START CLEARANCE","OBTAIN",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to pressurize hydraulic systems."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to start engines."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () sysFuel.wingFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	function () sysFuel.allFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Hydraulic panel"))
beforeStartProc:addItem(kcProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end))
beforeStartProc:addItem(kcProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
beforeStartProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Trim"))
beforeStartProc:addItem(kcProcedureItem:new("  STABILIZER TRIM","___ UNITS",kcFlowItem.actorCPT,1)) --******
beforeStartProc:addItem(kcProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartProc:addItem(kcProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Call for Before Start Checklist"))


-- – – – – – – – – – – CLEARED FOR START – – – – – – – – –
-- MOBILE PHONES. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- DOORS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .CLOSED
-- AIR CONDITIONING PACKS . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ANTICOLLISION LIGHT . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

-- ============ BEFORE START CHECKLIST (F/O) ============
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED (CPT)
-- FUEL..........................9999 KGS, PUMPS ON (CPT)
-- PASSENGER SIGNS..............................SET (CPT)
-- WINDOWS...................................LOCKED (CPT)
-- MCP...................V2 999, HDG 999, ALT 99999 (CPT)
-- TAKEOFF SPEEDS............V1 999, VR 999, V2 999 (CPT)
-- CDU PREFLIGHT..........................COMPLETED (CPT)
-- RUDDER & AILERON TRIM.................FREE AND 0 (CPT)
-- TAXI AND TAKEOFF BRIEFING..            COMPLETED (CPT)

local beforeStartChkl = kcChecklist:new("BEFORE START CHECKLIST (F/O)")
beforeStartChkl:addItem(kcChecklistItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorCPT,2,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorCPT,1,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () sysFuel.wingFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorCPT,1,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	function () sysFuel.allFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartChkl:addItem(kcChecklistItem:new("PASSENGER SIGNS","SET",kcFlowItem.actorCPT,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.seatBeltSwitch:adjustValue(1,0,2)  sysGeneral.noSmokingSwitch:adjustValue(1,0,2) end))
beforeStartChkl:addItem(kcFlowItem:new("WINDOWS","LOCKED",kcFlowItem.actorBOTH,2))
beforeStartChkl:addItem(kcChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|sysFMC.V2:getStatus()|sysMCP.hdgSelector:getStatus()|sysMCP.altSelector:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysMCP.iasSelector:getStatus() == sysFMC.V2:getStatus() and sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") and sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end))
beforeStartChkl:addItem(kcChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|sysFMC.V1:getStatus()|sysFMC.Vr:getStatus()|sysFMC.V2:getStatus()",kcFlowItem.actorBOTH,2))
beforeStartChkl:addItem(kcChecklistItem:new("CDU PREFLIGHT","COMPLETED",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",kcFlowItem.actorCPT,1,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end ))
beforeStartChkl:addItem(kcChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",kcFlowItem.actorCPT,1))

-- =========== PUSHBACK & ENGINE START (BOTH) ==========
-- PARKING BRAKE...............................SET (F/O)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND.............ESTABLISH (CPT)
-- PARKING BRAKE..........................RELEASED (F/O)
-- When pushback/towing complete
--   TOW BAR DISCONNECTED...................VERIFY (CPT)
--   LOCKOUT PIN REMOVED....................VERIFY (CPT)
--   SYSTEM A HYDRAULIC PUMPS...................ON (F/O)
-- Call START ENGINE 2
-- ENGINE START SWITCH 2.......................GRD (F/O)
--   Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- ENGINE START LEVER 2.......................IDLE (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- Call START ENGINE 1
-- ENGINE START SWITCH 1.......................GRD (F/O)
--   Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- ENGINE START LEVER 1.......................IDLE (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- Next BEFORE TAXI PROCEDURE

local pushstartProc = kcProcedure:new("PUSHBACK & ENGINE START (BOTH)")
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end ))
pushstartProc:addItem(kcSimpleProcedureItem:new("Engine Start may be done during pushback or towing"))
pushstartProc:addItem(kcProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",kcFlowItem.actorCPT,2))
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","RELEASED",kcFlowItem.actorFO,2,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () sysGeneral.parkBrakeSwitch:actuate(0) end))
pushstartProc:addItem(kcSimpleProcedureItem:new("When pushback/towing complete"))
pushstartProc:addItem(kcProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  SYSTEM A HYDRAULIC PUMPS","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.elecHydPump1:getStatus() == 1 end,
	function () sysHydraulic.engHydPump1:actuate(1) sysHydraulic.elecHydPump1:actuate(1) end))
pushstartProc:addItem(kcSimpleProcedureItem:new("Call START ENGINE 2"))
pushstartProc:addItem(kcIndirectProcedureItem:new("ENGINE START SWITCH 2","GRD",kcFlowItem.actorFO,2,"eng_start_2_grd",
	function () return sysEngines.engStart2Switch:getStatus() == 0 end ))
pushstartProc:addItem(kcSimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(kcSimpleProcedureItem:new("When N1 rotation is seen and N2 is at 25%,"))
pushstartProc:addItem(kcIndirectProcedureItem:new("ENGINE START LEVER 2","IDLE",kcFlowItem.actorFO,2,"eng_start_2_lever",
	function () return sysEngines.startLever2:getStatus() == 1 end ))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcSimpleProcedureItem:new("Call START ENGINE 1"))
pushstartProc:addItem(kcIndirectProcedureItem:new("ENGINE START SWITCH 1","GRD",kcFlowItem.actorFO,2,"eng_start_1_grd",
	function () return sysEngines.engStart1Switch:getStatus() == 0 end ))
pushstartProc:addItem(kcSimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(kcSimpleProcedureItem:new("When N1 rotation is seen and N2 is at 25%,"))
pushstartProc:addItem(kcIndirectProcedureItem:new("ENGINE START LEVER 1","IDLE",kcFlowItem.actorFO,2,"eng_start_1_lever",
	function () return sysEngines.startLever1:getStatus() == 1 end ))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcSimpleProcedureItem:new("Next BEFORE TAXI PROCEDURE"))


-- ============ BEFORE TAXI PROCEDURE (F/O) ============
-- GENERATOR 1 AND 2 SWITCHES...................ON (F/O)
-- PROBE HEAT SWITCHES..........................ON (F/O)
-- WING ANTI-ICE SWITCH..................AS NEEDED (F/O)
-- ENGINE ANTI-ICE SWITCHES..............AS NEEDED (F/O)
-- PACK SWITCHES..............................AUTO (F/O)
-- ISOLATION VALVE SWITCH.....................AUTO (F/O)
-- APU BLEED AIR SWITCH........................OFF (F/O)
-- APU SWITCH..................................OFF (F/O)
-- ENGINE START SWITCHES......................CONT (F/O)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- Verify that the ground equipment is clear.
-- Call 'FLAPS ___' as needed for takeoff.         (CPT)
-- FLAP LEVER....................SET TAKEOFF FLAPS (F/O)
-- LE FLAPS EXT GREEN LIGHT............ILLUMINATED (BOTH)
-- FLIGHT CONTROLS...........................CHECK (CPT)
-- TRANSPONDER...........................AS NEEDED (F/O)
-- RECALL....................................CHECK (BOTH)
--   Verify annunciators illuminate and then extinguish.
-- Call BEFORE TAXI CHECKLIST

local beforeTaxiProc = kcProcedure:new("BEFORE TAXI PROCEDURE (F/O)")
beforeTaxiProc:addItem(kcProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () sysElectric.genSwitchGroup:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.probeHeatASwitch:getStatus() == 1 and sysAice.probeHeatBSwitch:getStatus() == 1 end,
	function () sysAice.probeHeatASwitch:actuate(modeOn) sysAice.probeHeatBSwitch:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("PACK SWITCHES","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.packLeftSwitch:getStatus() == 1 and sysAir.packRightSwitch:getStatus() == 1 end,
	function () sysAir.packLeftSwitch:actuate(modeOn) sysAir.packRightSwitch:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function () sysAir.isoValveSwitch:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(modeOff) end))
beforeTaxiProc:addItem(kcProcedureItem:new("APU SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () sysElectric.apuStartSwitch:adjustValue(modeOff) end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","CONT",kcFlowItem.actorFO,1,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(cmdUp) end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",kcFlowItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end,
	function () sysEngines.startLeverGroup:actuate(cmdUp) end))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(kcProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcProcedureItem:new("FLIGHT CONTROLS","CHECK",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcProcedureItem:new("TRANSPONDER","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("Recall","CHECK",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  Verify annunciators illuminate and then extinguish."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

-- AFTER START
-- ELECTRICAL . . . . . . . . . . . . . . . . . . . . . . . .GENERATORS ON
-- PROBE HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON
-- ANTI–ICE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- AIR COND & PRESS . . . . . . . . . . . . . . . . . . . . . . . . PACKS ON
-- ISOLATION VALVE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AUTO
-- APU . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- START LEVERS . . . . . . . . . . . . . . . . . . . . . . . . . .IDLE DETENT

-- ============ BEFORE TAXI CHECKLIST (F/O) ============
-- GENERATORS...................................ON (CPT)
-- PROBE HEAT...................................ON (CPT)
-- ANTI-ICE............................AS REQUIRED (CPT)
-- ISOLATION VALVE............................AUTO (CPT)
-- ENGINE START SWITCHES......................CONT (CPT)
-- RECALL..................................CHECKED (CPT)
-- AUTOBRAKE...................................RTO (CPT)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- FLIGHT CONTROLS.........................CHECKED (CPT)
-- GROUND EQUIPMENT..........................CLEAR (BOTH)
-- Next BEFORE TAKEOFF CHECKLIST

local beforeTaxiChkl = kcChecklist:new("BEFORE TAXI CHECKLIST (F/O)")
beforeTaxiChkl:addItem(kcChecklistItem:new("GENERATORS","ON",kcChecklistItem.actorCPT,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () sysElectric.gen1Switch:actuate(1) sysElectric.gen2Switch:actuate(1)	end ))
beforeTaxiChkl:addItem(kcChecklistItem:new("PROBE HEAT","ON",kcChecklistItem.actorCPT,2,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","AS REQUIRED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ISOLATION VALVE","AUTO",kcChecklistItem.actorCPT,2,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorCPT,2,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:adjustValue(2,0,3) end)) 
beforeTaxiChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("AUTOBRAKE","RTO",kcChecklistItem.actorCPT,2,
	function () return sysGeneral.autobreak:getStatus() == 0 end,
	function () sysGeneral.autobreak:actuate(0) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",kcChecklistItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("FLIGHT CONTROLS","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("GROUND EQUIPMENT","CLEAR",kcChecklistItem.actorBOTH,1))
beforeTaxiChkl:addItem(kcSimpleChecklistItem:new("Next BEFORE TAKEOFF CHECKLIST"))

-- BEFORE TAKEOFF
-- RECALL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .CHECKED
-- FLIGHT CONTROLS. . . . . . . . . . . . . . . . . . . . . . . . . .CHECKED
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . _____, GREEN LIGHT
-- STABILIZER TRIM . . . . . . . . . . . . . . . . . . . . . . . . . _____UNITS
-- CABIN DOOR . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .LOCKED
-- TAKEOFF BRIEFING . . . . . . . . . . . . . . . . . . . . . . . .REVIEWED
-- – – – – – – – – – CLEARED FOR TAKEOFF – – – – – – – –
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . . .ON
-- TRANSPONDER . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

-- ============ BEFORE TAKEOFF CHECKLIST (F/O) ============
-- GENERATORS...................................ON (CPT)
-- TAKEOFF BRIEFING.......................REVIEWED (CPT)
-- FLAPS...........................__, GREEN LIGHT (CPT)
-- STABILIZER TRIM...................... ___ UNITS (CPT)
-- CABIN....................................SECURE (CPT)
-- Next RUNWAY ENTRY PROCEDURE

local beforeTakeoffChkl = kcChecklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
beforeTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","GREEN LIGHT",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("STABILIZER TRIM","___ UNITS",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("CABIN","SECURE",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcSimpleChecklistItem:new("Next RUNWAY ENTRY PROCEDURE"))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)
-- Next TAKEOFF AND INITIAL CLIMB 

local runwayEntryProc = kcProcedure:new("RUNWAY ENTRY PROCEDURE (F/O)")
runwayEntryProc:addItem(kcChecklistItem:new("STROBES","ON",kcChecklistItem.actorFO,2,
	function () return sysLights.strobesSwitch:getStatus() == 1 end,
	function () sysLights.strobesSwitch:actuate(1) end))
runwayEntryProc:addItem(kcChecklistItem:new("TRANSPONDER","ON",kcChecklistItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == 5 end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrTARA,0,5) end))
runwayEntryProc:addItem(kcChecklistItem:new("LANDING LIGHTS","ON",kcChecklistItem.actorCPT,2,
	function () return sysLights.landLightGroup:getStatus() > 1 end,
	function () sysLights.landLightGroup:actuate(1) end))
runwayEntryProc:addItem(kcChecklistItem:new("RWY TURNOFF LIGHTS","ON",kcChecklistItem.actorCPT,2,
	function () return sysLights.rwyLightGroup:getStatus() > 0 end,
	function () sysLights.rwyLightGroup:actuate(1) end))
runwayEntryProc:addItem(kcChecklistItem:new("TAXI LIGHTS","OFF",kcChecklistItem.actorCPT,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
runwayEntryProc:addItem(kcSimpleChecklistItem:new("Next TAKEOFF AND INITIAL CLIMB"))

-- ============ start and initial climb =============
local takeoffClimbProc = kcProcedure:new("TAKEOFF & INITIAL CLIMB")
	-- [2] = {["activity"] = "A/T -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "SET A/P MODES", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "SET TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "SETTING TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "FLAPS 10", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "SPEED CHECK FLAPS 10", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "FLAPS 5", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "SPEED CHECK FLAPS 5", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "FLAPS 1", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "SPEED CHECK FLAPS 1", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "CMD A", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [15] = {["activity"] = "SETTING CMD A", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,

-- AFTER TAKEOFF
-- AIR COND & PRESS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .SET
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- LANDING GEAR. . . . . . . . . . . . . . . . . . . . . . . . . . . . .UP & OFF
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . UP, NO LIGHTS

-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- TAKEOFF BRIEFING.......................REVIEWED (PM)
-- ENGINE BLEEDS................................ON (PM)
-- PACKS......................................AUTO (PM)
-- LANDING GEAR.........................UP AND OFF (PM)
-- FLAPS.............................UP, NO LIGHTS (PM)
-- ALTIMETERS..................................SET (BOTH)
-- Next CLIMB & CRUISE

-- ======= After Takeoff checklist =======

local afterTakeoffChkl = kcChecklist:new("AFTER TAKEOFF CHECKLIST (PM)")
afterTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorPM,1))
afterTakeoffChkl:addItem(kcChecklistItem:new("ENGINE BLEEDS","ON",kcChecklistItem.actorPM,2,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("PACKS","AUTO",kcChecklistItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () sysAir.packSwitchGroup:setValue(1) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("LANDING GEAR","UP AND OFF",kcChecklistItem.actorPM,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () sysGeneral.GearSwitch:setValue(0.5) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","UP, NO LIGHTS",kcChecklistItem.actorPM,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () sysControls.flapsSwitch:adjustValue(0) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("ALTIMETERS","SET",kcChecklistItem.actorBOTH,1))
afterTakeoffChkl:addItem(kcSimpleChecklistItem:new("Next CLIMB & CRUISE"))

-- ============ climb & cuise =============
local climbCruiseProc = kcProcedure:new("CLIMB & CRUISE")

-- If the center tank fuel pump switches were OFF for takeoff and the center tank contains more than 1000 pounds/500 kilograms, set both center tank fuel pump switches ON above 10,000 feet or after the pitch attitude has been reduced to begin acceleration to a climb speed of 250 knots or greater.
-- During climb, set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 1000 pounds/500 kilograms.
-- At or above 10,000 feet MSL, set the LANDING light switches to OFF.
-- Set the passenger signs as needed.
-- At transition altitude, set and crosscheck the altimeters to standard.
-- When established in a level attitude at cruise, if the center tank contains more than 1000 pounds/500 kilograms and the center tank fuel pump switches are OFF, set the center tank fuel pump switches ON again.
-- Set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 1000 pounds/500 kilograms.
-- During an ETOPS flight, additional steps must be done. See the ETOPS supplementary procedure in SP.1.
-- Before the top of descent, modify the active route as needed for the arrival and approach.
-- Verify or enter the correct RNP for arrival.


-- ============ descent =============
local descentProc = kcProcedure:new("DESCENT PROCEDURE")

-- Set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 3000 pounds/1400 kilograms.
-- Verify that pressurization is set to landing altitude.
-- Review the system annunciator lights.
-- Recall and review the system annunciator lights.
-- Verify VREF on the APPROACH REF page.
-- Enter VREF on the APPROACH REF page.
-- Set the RADIO/BARO minimums as needed for the approach.
-- Set or verify the navigation radios and course for the approach.
-- Set the AUTO BRAKE select switch to the needed brake setting
-- Do the approach briefing.
-- Call “DESCENT CHECKLIST.”Do the DESCENT checklist.
-- ======= Descent checklist =======


-- DESCENT – APPROACH
-- ANTI–ICE. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- AIR COND & PRESS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .SET
-- ALTIMETER & INSTRUMENTS . . . . . . . . SET & X–CHECKED
-- N1 & IAS BUGS. . . . . . . . . . . . . . . . . . . . . . . .CHECKED & SET

local descentChkl = kcChecklist:new("DESCENT CHECKLIST (PM)")
descentChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorPM,nil))
descentChkl:addItem(kcChecklistItem:new("PRESSURISATION","LAND ALT___",kcChecklistItem.actorPM,nil))
descentChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorPM,nil))
descentChkl:addItem(kcChecklistItem:new("AUTOBRAKE","___",kcChecklistItem.actorPM,nil))
descentChkl:addItem(kcChecklistItem:new("LANDING DATA","VREF___, MINIMUMS___",kcChecklistItem.actorBOTH,nil))
descentChkl:addItem(kcChecklistItem:new("APPROACH BRIEFING","COMPLETED",kcChecklistItem.actorPM,nil))

-- ======= Approach checklist =======

local approachChkl = kcChecklist:new("APPROACH CHECKLIST (PM)")
approachChkl:addItem(kcChecklistItem:new("ALTIMETERS","QNH ___",kcChecklistItem.actorBOTH,nil))
approachChkl:addItem(kcChecklistItem:new("NAV AIDS","SET",kcChecklistItem.actorPM,nil))

-- ======= Landing checklist =======
-- LANDING
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . .ON
-- RECALL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . CHECKED
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . .ARMED,GREEN LIGHT
-- LANDING GEAR. . . . . . . . . . . . . . . . . . . . . . .DOWN, 3 GREEN
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . _____, GREEN LIGHT

local landingChkl = kcChecklist:new("LANDING CHECKLIST (PM)")
landingChkl:addItem(kcChecklistItem:new("CABIN","SECURE",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("SPEEDBRAKE","ARMED",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("LANDING GEAR","DOWN",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("FLAPS","___, GREEN LIGHT",kcChecklistItem.actorPF,nil))

-- ============ after landing =============
local afterLandingProc = kcProcedure:new("AFTER LANDING PROCEDURE")
	-- [2] = {["activity"] = "SPEED BRAKES -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "CHRONO and ET -- STOP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "WX RADAR -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "APU -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "FLAPS -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "PROBE HEAT -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "STROBES -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "LANDING LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "TAXI LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "ENGINE START SWITCHES -- AUTO", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "TRAFFIC -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "AUTOBRAKE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "TRANSPONDER -- STBY", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,



-- ============ shutdown =============
local shutdownProc = kcProcedure:new("SHUTDOWN PROCEDURE")
-- Start the Shutdown Procedure after taxi is complete.
-- Parking brake...Set CAPT
--   Verify that the parking brake warning light is illuminated.
-- Electrical power...Set F/O
--   If APU power is needed:
-- 	   Verify that the APU GENERATOR OFF BUS light is illuminated.
--     APU GENERATOR bus switches – ON
--     Verify that the SOURCE OFF lights are extinguished.
--   If external power is needed:
--     Verify that the GRD POWER AVAILABLE light is illuminated.
--     GRD POWER switch – ON
--     Verify that the SOURCE OFF lights are extinguished.
-- Engine start levers...CUTOFF CAPT
-- FASTEN BELTS switch...OFF F/O
-- ANTI COLLISION light switch...OFF F/O
-- FUEL PUMP switches...OFF F/O
-- CAB/UTIL power switch...As needed F/O
-- IFE/PASS SEAT power switch...As needed F/O
-- WING ANTI–ICE switch...OFF F/O
-- ENGINE ANTI–ICE switches....OFF F/O
-- Hydraulic panel....Set F/O
-- ENGINE HYDRAULIC PUMPS switches - ON
-- ELECTRIC HYDRAULIC PUMPS switches - OFF
-- RECIRCULATION FAN switches....As needed F/O
-- Air conditioning PACK switches....AUTO F/O
-- ISOLATION VALVE switch.... OPEN F/O
-- Engine BLEED air switches....ON F/O
-- APU BLEED air switch....ON F/O
-- Exterior lights switches....As needed F/O
-- FLIGHT DIRECTOR switches....OFF F/O
-- Transponder mode selector....STBY F/O
-- After the wheel chocks are in place: Parking brake – Release C or F/O
-- APU switch....As needed F/O
-- Call “SHUTDOWN CHECKLIST.
	-- [2] = {["activity"] = "TAXI LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "SHUTDOWN ENGINES!", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "SHUTTING DOWN ENGINES", ["wait"] = 10, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "SEATBELT SIGNS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "BEACON -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "FUEL PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "WING & ENGINE ANTIICE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "ELECTRICAL HYDRAULIC PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "ISOLATION VALVE -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "APU BLEED -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "FLIGHT DIRECTORS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "RESET MCP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "RESET TRANSPONDER", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [15] = {["activity"] = "DOORS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [16] = {["activity"] = "RESET ELAPSED TIME", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,



-- ======= Shutdown checklist =======
-- SHUTDOWN
-- FUEL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .PUMPS OFF
-- GALLEY POWER . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- ELECTRICAL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON_____
-- FASTEN BELTS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- WINDOW HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- PROBE HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ANTI–ICE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ELECTRIC HYDRAULIC PUMPS . . . . . . . . . . . . . . . . . . . . .OFF
-- AIR COND . . . . . . . . . . . . . . . . . . . ___ PACK(S), BLEEDS ON
-- EXTERIOR LIGHTS . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- ANTICOLLISION LIGHT . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ENGINE START SWITCHES . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- AUTOBRAKE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . . . . . . . . DOWN DETENT
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . UP, NO LIGHTS
-- PARKING BRAKE . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- START LEVERS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . CUTOFF
-- WEATHER RADAR . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- TRANSPONDER . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- MOBILE PHONES. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

local shutdownChkl = kcChecklist:new("SHUTDOWN CHECKLIST (F/O)")
shutdownChkl:addItem(kcChecklistItem:new("HYDRAULIC PANEL","SET",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("PROBE HEAT","AUTO/OFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","OFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("FLAPS","UP",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("WEATHER RADAR","OFF",kcChecklistItem.actorBOTH,nil))
shutdownChkl:addItem(kcChecklistItem:new("PARKING BRAKE","___",kcChecklistItem.actorCPT,nil))


-- ============ secure =============
local secureProc = kcProcedure:new("SECURE PROCEDURE")

-- IRS mode selectors....OFF F/O
-- EMERGENCY EXIT LIGHTS switch....OFF F/O
-- WINDOW HEAT switches....OFF F/O
-- Air conditioning PACK switches....OFF F/O

-- ======= Secure checklist =======

-- SECURE
-- IRS MODE SELECTORS . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- EMERGENCY EXIT LIGHTS. . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- AIR CONDITIONING PACKS . . . . . . . . . . . . . . . . . . . . . . .OFF
-- APU/GROUND POWER . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- BATTERY. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF

local secureChkl = kcChecklist:new("SECURE CHECKLIST (F/O)")
secureChkl:addItem(kcChecklistItem:new("EFBs (if installed)","SHUT DOWN",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("IRSs","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("WINDOW HEAT","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("PACKS","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcSimpleChecklistItem:new(	"If the aircraft is not handed over to succeeding flight"))
secureChkl:addItem(kcSimpleChecklistItem:new(	"crew or maintenance personnel:"))
secureChkl:addItem(kcChecklistItem:new("  EFB switches (if installed)","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("  APU/GRD PWR","OFF",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("  GROUND SERVICE SWITCH","ON",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("  BAT SWITCH","OFF",kcChecklistItem.actorCPT))

-- ============ Procedures =============


-- ============ approach =============
local approachProc = kcProcedure:new("APPROACH PROCEDURE")

-- ============ landing =============
local landingProc = kcProcedure:new("LANDING PROCEDURE")


-- ============ Cold & Dark =============

local coldAndDarkProc = kcProcedure:new("SET AIRCRAFT TO COLD & DARK")
-- coldAndDarkProc:addItem(kcProcedureItem:new("XPDR","SET 2000","F/O",1,

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
-- activeSOP:addProcedure(cduPreflightProc)
-- activeSOP:addProcedure(preflightFOProc)
-- activeSOP:addProcedure(preflightFO2Proc)
-- activeSOP:addProcedure(preflightFO3Proc)
-- activeSOP:addProcedure(preflightCPTProc)
-- activeSOP:addChecklist(preflightChkl)
-- activeSOP:addProcedure(beforeStartProc)
-- activeSOP:addChecklist(beforeStartChkl)
-- activeSOP:addProcedure(pushstartProc)
-- activeSOP:addProcedure(beforeTaxiProc)
-- activeSOP:addChecklist(beforeTaxiChkl)
-- activeSOP:addProcedure(beforeTakeoffProc)
-- activeSOP:addChecklist(beforeTakeoffChkl)
-- activeSOP:addProcedure(runwayEntryProc)
-- activeSOP:addProcedure(takeoffClimbProc)
-- activeSOP:addChecklist(afterTakeoffChkl)
-- activeSOP:addProcedure(climbCruiseProc)
-- activeSOP:addProcedure(descentProc)
-- activeSOP:addChecklist(descentChkl)
-- activeSOP:addProcedure(approachProc)
-- activeSOP:addChecklist(approachChkl)
-- activeSOP:addProcedure(landingProc)
-- activeSOP:addChecklist(landingChkl)
-- activeSOP:addProcedure(afterLandingProc)
-- activeSOP:addProcedure(shutdownProc)
-- activeSOP:addChecklist(shutdownChkl)
-- activeSOP:addProcedure(secureProc)
-- activeSOP:addChecklist(secureChkl)

function getActiveSOP()
	return activeSOP
end

return SOP_B738