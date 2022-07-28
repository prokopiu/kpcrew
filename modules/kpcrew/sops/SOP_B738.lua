local SOP_B738 = {
}

-- SOP related imports
kcSOP = require "kpcrew.sops.SOP"

kcFlow = require "kpcrew.Flow"
kcFlowItem = require ("kpcrew.FlowItem")

kcChecklist = require "kpcrew.checklists.Checklist"
kcChecklistItem = require "kpcrew.checklists.ChecklistItem"
kcSimpleChecklistItem = require "kpcrew.checklists.SimpleChecklistItem"
kcIndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"
kcManualChecklistItem = require "kpcrew.checklists.ManualChecklistItem"

kcProcedure = require "kpcrew.procedures.Procedure"
kcProcedureItem = require "kpcrew.procedures.ProcedureItem"
kcSimpleProcedureItem = require "kpcrew.procedures.SimpleProcedureItem"
kcIndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

-- Systems related imports

-- classes for systems switches 
TwoStateDrefSwitch 		= require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch 		= require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
TwoStateToggleSwitch 	= require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch 				= require "kpcrew.systems.InopSwitch"

SwitchGroup  			= require "kpcrew.systems.SwitchGroup"

SimpleAnnunciator 		= require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator 		= require "kpcrew.systems.CustomAnnunciator"

sysLights 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	
sysFMC 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysFMC")	

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

-- Set up SOP =========================================================================

activeSOP = kcSOP:new("Zibo Mod SOP")

-- ============ Electrical Power Up Procedure ===========
-- ===== Initial checks
-- DC Electric Power
-- CIRCUIT BREAKERS (P6 PANEL)................CHECK (F/O)
-- CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL).CHECK (F/O)
-- DC POWER SWITCH..............................BAT (F/O)
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
-- TAKEOFF CONFIG WARNING......................TEST (F/O)
--   Move thrust levers full forward and back to idle.

-- ==== Activate External Power
--   Use Zibo EFB to turn Ground Power on.         
--   GRD POWER AVAILABLE LIGHT..........ILLUMINATED (F/O)
--   GROUND POWER SWITCH.........................ON (F/O)

-- ==== Activate APU 
--   OVHT FIRE TEST SWITCH...............HOLD RIGHT (F/O)
--   MASTER FIRE WARN LIGHT....................PUSH (F/O)
--   ENGINES EXT TEST SWITCH.........TEST 1 TO LEFT (F/O)
--   ENGINES EXT TEST SWITCH........TEST 2 TO RIGHT (F/O)
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
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("BATTERY VOLTAGE","MIN 24V",kcFlowItem.actorFO,2,"bat24v",
	function () return sysElectric.batt1Volt:getStatus() > 23 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
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
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsAnc:getStatus() == modeOn end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsRed:getStatus() == modeOff end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",kcFlowItem.actorFO,2,"takeoff_config_warn",
	function () return get("laminar/B738/system/takeoff_config_warn") > 0 end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use Zibo EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GROUND POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuSwitch:getStatus() == modeOn end,
	function () sysElectric.gpuSwitch:actuate(cmdDown) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,2,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > modeOff end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,2,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBus1:getStatus() == modeOn and sysElectric.apuGenBus2:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(kcProcedureItem:new("SOURCE OFF LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.sourceOff1:getStatus() == modeOff and sysElectric.sourceOff2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER","ON",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/electric/standby_bat_pos") > 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPwrOff:getStatus() == modeOff end))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))

-- ============ PRELIMINARY PREFLIGHT PROCEDURES ========
-- EMERGENCY EXIT LIGHT.........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON..........................PRESS (F/O)
-- ELECTRICAL POWER UP.....................COMPLETE (F/O)
-- VOICE RECORDER SWITCH.......................AUTO (F/O)
-- MACH OVERSPEED TEST......................PERFORM (F/O)
-- STALL WARNING TEST.......................PERFORM (F/O)
-- IRS MODE SELECTORS...........................OFF (F/O)
-- IRS MODE SELECTORS......................THEN NAV (F/O)
--   Verify ON DC lights illuminate then extinguish
--   Verify ALIGN lights are illuminated           
-- XPDR....................................SET 2000 (F/O)
-- COCKPIT LIGHTS.....................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS.........SET AS REQUIRED (F/O)
-- FUEL PUMPS...............................ALL OFF (F/O)
-- FUEL CROSS FEED..............................OFF (F/O)
-- POSITION LIGHTS...............................ON (F/O)
-- MCP...................................INITIALIZE (F/O)
-- PARKING BRAKE................................SET (F/O)
-- IFE & GALLEY POWER............................ON (F/O)
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
		(sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1) or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
prelPreflightProc:addItem(kcProcedureItem:new("VOICE RECORDER SWITCH","AUTO",kcFlowItem.actorFO,2,
	function () return  sysGeneral.voiceRecSwitch:getStatus() == modeOff and sysGeneral.vcrCover:getStatus() == modeOff end,
	function () sysGeneral.voiceRecSwitch:actuate(modeOn) sysGeneral.vcrCover:actuate(modeOff) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",kcFlowItem.actorFO,2,"mach_ovspd_test",
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 or get("laminar/B738/push_button/mach_warn2_pos") == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST","PERFORM",kcFlowItem.actorFO,2,"stall_warning_test",
	function () return get("laminar/B738/push_button/stall_test1") == 1 or get("laminar/B738/push_button/stall_test2") == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","OFF",kcFlowItem.actorFO,2,"irs_mode_initial_off",
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitOFF) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","THEN ALIGN",kcFlowItem.actorFO,2,"irs_mode_nav_again",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitALIGN*2 end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitALIGN) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS LEFT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,2,"irs_left_align",
	function () return sysGeneral.irs1Align:getStatus() == modeOn end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS RIGHT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,2,"irs_right_align",
	function () return sysGeneral.irs2Align:getStatus() == modeOn end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",kcFlowItem.actorFO,2,"irs_mode_nav_again",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitNAV*2 end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitNAV) end))
-- prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS LEFT ON DC","ILLUMINATES & EXTINGUISHES",kcFlowItem.actorFO,1,"irs_left_dc",
	-- function () return sysGeneral.irs1OnDC:getStatus() == modeOn end))
-- prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS RIGHT ON DC","ILLUMINATES & EXTINGUISHES",kcFlowItem.actorFO,1,"irs_right_dc",
	-- function () return sysGeneral.irs2OnDC:getStatus() == modeOn end))

prelPreflightProc:addItem(kcProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",kcFlowItem.actorFO,2,
	function () return get("sim/cockpit/radios/transponder_code") == 2000 end))
prelPreflightProc:addItem(kcProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))
prelPreflightProc:addItem(kcProcedureItem:new("POSITION LIGHTS","ON",kcFlowItem.actorFO,2,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(kcProcedureItem:new("#spell|MCP#","INITIALIZE",kcFlowItem.actorFO,2,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		sysMCP.fdirGroup:actuate(modeOff)
		sysMCP.athrSwitch:actuate(modeOff)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.turnRateSelector:adjustValue(3,0,4)
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(modeOff)
		sysMCP.discAPSwitch:actuate(modeOff)
		sysEFIS.mtrsPilot:actuate(modeOff)
		sysEFIS.fpvPilot:actuate(modeOff)
	end))
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(kcProcedureItem:new("#spell|IFE# & GALLEY POWER","ON",kcFlowItem.actorFO,3,
	function () return sysElectric.ifePwr:getStatus() == modeOn and sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.ifePwr:actuate(modeOn) sysElectric.cabUtilPwr:actuate(modeOn) end))
-- prelPreflightProc:addItem(kcSimpleProcedureItem:new("Next CDU Preflight by Captain."))

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
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  IDENT page:","OPEN",kcFlowItem.actorCPT,1,"ident_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"IDENT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify Model and ENG RATING"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  POS INIT page:","OPEN",kcFlowItem.actorCPT,1,"pos_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"POS INIT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    REF AIRPORT","SET",kcFlowItem.actorCPT,1,"ref_airport_set",
	function () return sysFMC.fmcRefAirportSet:getStatus() end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("NAVIGATION DATA (CPT)"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  RTE page:","OPEN",kcFlowItem.actorCPT,1,"rte_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"RTE ") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ORIGIN","SET",kcFlowItem.actorCPT,1,"origin_set",
	function () return sysFMC.fmcOrigin:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    DEST","SET",kcFlowItem.actorCPT,1,"dest_set",
	function () return sysFMC.fmcDestination:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    FLT NO","SET",kcFlowItem.actorCPT,1,"flt_no_entered",
	function () return sysFMC.fmcFltNo:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ROUTE","ENTER",kcFlowItem.actorCPT,1,"route_entered",
	function () return sysFMC.fmcRouteEntered:getStatus() == true end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ROUTE","ACTIVATE",kcFlowItem.actorCPT,1,"route_activated",
	function () return sysFMC.fmcRouteActivated:getStatus() == true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE","EXECUTE",kcFlowItem.actorCPT,1,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  DEPARTURES page:","OPEN",kcFlowItem.actorCPT,1,"departures_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"DEPARTURES") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE:","EXECUTE",kcFlowItem.actorCPT,1,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  LEGS page:","OPEN",kcFlowItem.actorCPT,1,"legs_page_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"LEGS") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("PERFORMANCE DATA (CPT)"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  PERF INIT page:","OPEN",kcFlowItem.actorCPT,1,"perf_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"PERF INIT") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ZFW","ENTER",kcFlowItem.actorCPT,1,"zfw_entered",
	function () return sysFMC.fmcZFWEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    GW","ENTER/VERIFY",kcFlowItem.actorCPT,1,"gw_entered",
	function () return sysFMC.fmcGWEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    RESERVES","ENTER/VERIFY",kcFlowItem.actorCPT,1,"reserves_entered",
	function () return sysFMC.fmcReservesEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    COST INDEX","ENTER",kcFlowItem.actorCPT,1,"cost_index_entered",
	function () return sysFMC.fmcCIEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    CRZ ALT","ENTER",kcFlowItem.actorCPT,1,"crz_alt_entered",
	function () return sysFMC.fmcCrzAltEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  N1 LIMIT page:","OPEN",kcFlowItem.actorCPT,1,"n1_limit_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"N1 LIMIT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  TAKEOFF REF page:","OPEN",kcFlowItem.actorCPT,1,"takeoff_ref_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"TAKEOFF REF") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    FLAPS","ENTER",kcFlowItem.actorCPT,1,"flaps_entered",
	function () return sysFMC.fmcFlapsEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    CG","ENTER",kcFlowItem.actorCPT,1,"cg_entered",
	function () return sysFMC.fmcCGEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    V SPEEDS","ENTER",kcFlowItem.actorCPT,1,"vspeeds_entered",
	function () return sysFMC.fmcVspeedsEntered:getStatus() == true end))
-- cduPreflightProc:addItem(kcSimpleProcedureItem:new("CDU PREFLIGHT COMPLETE"))

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

local preflightFOProc = kcProcedure:new("PREFLIGHT PROCEDURE (F/O)")
preflightFOProc:setResize(false)
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
-- preflightFOProc:addItem(kcSimpleProcedureItem:new("Continue with part 2"))

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

-- local preflightFO2Proc = kcProcedure:new("PREFLIGHT PROCEDURE PART 2 (F/O)")

preflightFOProc:addItem(kcSimpleProcedureItem:new("Hydraulic panel"))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("Air conditioning panel"))
preflightFOProc:addItem(kcProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","AS NEEDED",kcFlowItem.actorFO,2,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end))
preflightFOProc:addItem(kcProcedureItem:new("TRIM AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",kcFlowItem.actorFO,2,
	function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,
	function () sysAir.packLeftSwitch:setValue(1) sysAir.packRightSwitch:setValue(1) end))
preflightFOProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Cabin pressurization panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT ALTITUDE INDICATOR","CRUISE ALTITUDE",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("LANDING ALTITUDE INDICATOR","DEST FIELD ELEVATION",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Lighting panel"))
preflightFOProc:addItem(kcProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("LOGO LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.logoSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.logoSwitch:actuate( kc_is_daylight() and 0 or 1) end ))
preflightFOProc:addItem(kcProcedureItem:new("POSITION LIGHT SWITCH","AS NEEDED",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WING ILLUMINATION SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightFOProc:addItem(kcProcedureItem:new("WHEEL WELL LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightFOProc:addItem(kcProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",kcFlowItem.actorFO,2,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:adjustValue(1,0,3) end)) 
-- preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Continue with part 3"))

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

-- local preflightFO3Proc = kcProcedure:new("PREFLIGHT PROCEDURE PART 3 (F/O)")
preflightFOProc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightFOProc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysMCP.fdirGroup:getStatus() == 2 end,
	function () sysMCP.fdirGroup:actuate(1) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightFOProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BARO",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("MINIMUMS SELECTOR","SET DH OR DA REFERENCE",kcFlowItem.actorFO,2))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.fpvPilot:getStatus() == 0 end,
	function () sysEFIS.fpvPilot:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("METERS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.mtrsPilot:getStatus() == 0 end,
	function () sysEFIS.mtrsPilot:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorFO,2,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModePilot:adjustValue(sysEFIS.mapModeMAP,0,3) end))
preflightFOProc:addItem(kcProcedureItem:new("CENTER SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("RANGE SELECTOR","AS NEEDED",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("OXYGEN","TEST AND SET",kcFlowItem.actorFO,2,"oxygentested",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
preflightFOProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("GROUND PROXIMITY panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	function () sysGeneral.flapInhibitCover:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	function () sysGeneral.gearInhibitCover:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	function () sysGeneral.terrainInhibitCover:actuate(0) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("Landing gear panel"))
preflightFOProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 0 end,
	function () sysGeneral.autobreak:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("Radio tuning panel"))
preflightFOProc:addItem(kcProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("AUDIO CONTROL PANEL","SET",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("ADF RADIOS","SET",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("WEATHER RADAR PANEL","SET",kcFlowItem.actorFO,1))
preflightFOProc:addItem(kcProcedureItem:new("TRANSPONDER PANEL","SET",kcFlowItem.actorFO,1))

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
-- COURSE(S)...................................SET (CPT)
-- FLIGHT DIRECTOR SWITCH.......................ON (CPT)
-- BANK ANGLE SELECTOR...................AS NEEDED (CPT)
-- AUTOPILOT DISENGAGE BAR......................UP (CPT)
-- Main panel
-- OXYGEN RESET/TEST SWITCH..........PUSH AND HOLD (CPT)
-- CLOCK.......................................SET (CPT)
-- NOSE WHEEL STEERING SWITCH.........GUARD CLOSED (CPT)
-- Display select panel
-- MAIN PANEL DISPLAY UNITS SELECTOR..........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR................NORM (F/O)
-- INTEGRATED STANDBY FLIGHT DISPLAY...........SET (CPT)
-- SPEED BRAKE LEVER...................DOWN DETENT (CPT)
-- REVERSE THRUST LEVERS......................DOWN (CPT)
-- FORWARD THRUST LEVERS....................CLOSED (CPT)
-- FLAP LEVER..................................SET (CPT)
--   Set the flap lever to agree with the flap position.
-- PARKING BRAKE...............................SET (F/O)
-- ENGINE START LEVERS......................CUTOFF (CPT)
-- STABILIZER TRIM CUTOUT SWITCHES..........NORMAL (CPT)
-- RADIO TUNING PANEL..........................SET (CPT)

local preflightCPTProc = kcProcedure:new("PREFLIGHT PROCEDURE (CAPT)")
preflightCPTProc:addItem(kcIndirectProcedureItem:new("LIGHTS","TEST",kcFlowItem.actorCPT,1,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",kcFlowItem.actorCPT,1,
	function () return ((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=1 else flag=0 end
		sysEFIS.minsTypePilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",kcFlowItem.actorCPT,1,
	function () return sysEFIS.minsResetPilot:getStatus() == 1 and math.ceil(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("arrival:decision") end,
	function () sysEFIS.minsPilot:adjustValue(activeBriefings:get("arrival:decision"),0,9000) end))
preflightCPTProc:addItem(kcProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",kcFlowItem.actorCPT,1,
	function () 
		return (sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
		or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",kcFlowItem.actorCPT,1,
	function () 
		return (sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
		or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",kcFlowItem.actorCPT,1,
	function () 
		return (sysGeneral.baroModePilot:getStatus() == 1 and activePrefSet:get("general:baro_mode_hpa") == true) 
		or (sysGeneral.baroModePilot:getStatus() == 0 and activePrefSet:get("general:baro_mode_hpa") == false) end,
	function () 
		local flag = 0 
		if activePrefSet:get("general:baro_mode_hpa") then flag=1 else flag=0 end
		sysGeneral.baroModePilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorCPT,3,
	function () return sysGeneral.baroPilot:getStatus() == get("sim/weather/barometer_sealevel_inhg") end,
	function () sysGeneral.baroGroup:setValue(get("sim/weather/barometer_sealevel_inhg")) end))
preflightCPTProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","VOR",kcFlowItem.actorCPT,1,
	function () return sysEFIS.voradf1Pilot:getStatus() == 1 and sysEFIS.voradf2Pilot:getStatus() == 1 end,
	function () sysEFIS.voradf1Pilot:actuate(1) sysEFIS.voradf2Pilot:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorCPT,1,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModePilot:setValue(sysEFIS.mapModeMAP) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set CENTER SWITCH as needed"))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set RANGE SELECTOR as needed"))
preflightCPTProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","ON",kcFlowItem.actorCPT,1,
	function () return sysEFIS.tfcPilot:getStatus() == 1 end,
	function () sysEFIS.tfcPilot:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorCPT,1,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set MAP SWITCHES as needed"))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorCPT,1,
	function () return math.floor(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") 
		and math.floor(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function () 
		sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course"))
		sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course"))
	end))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",kcFlowItem.actorCPT,1,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end,
	function () sysMCP.fdirPilotSwitch:actuate(1) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set BANK ANGLE SELECTOR as needed"))
preflightCPTProc:addItem(kcProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",kcFlowItem.actorCPT,1,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end,
	function () sysMCP.discAPSwitch:actuate(0) end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Main panel"))
preflightCPTProc:addItem(kcProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set the CLOCK"))
preflightCPTProc:addItem(kcProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",kcFlowItem.actorCPT,1,
	function () return get("laminar/B738/switches/nose_steer_pos") == 1 end,
	function () set("laminar/B738/switches/nose_steer_pos",1) end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Display select panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
preflightCPTProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set INTEGRATED STANDBY FLIGHT DISPLAY"))
preflightCPTProc:addItem(kcProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",kcFlowItem.actorCPT,1,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("REVERSE THRUST LEVERS","DOWN",kcFlowItem.actorCPT,1,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/reverse_lever1",0) set("laminar/B738/flt_ctrls/reverse_lever2",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",kcFlowItem.actorCPT,1,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end,
	function () set("laminar/B738/engine/thrust1_leveler",0) set("laminar/B738/engine/thrust2_leveler",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("FLAP LEVER","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () sysEngines.startLever1:actuate(0) sysEngines.startLever2:actuate(0) end))
preflightCPTProc:addItem(kcProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",kcFlowItem.actorCPT,1,
	function () return get("laminar/B738/toggle_switch/ap_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/ap_trim_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_pos") == 0 end,
	function () set("laminar/B738/toggle_switch/ap_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/el_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/ap_trim_pos",0)
		set("laminar/B738/toggle_switch/el_trim_pos",0) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set RADIO TUNING PANEL"))
-- preflightCPTProc:addItem(kcSimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))

-- =============== PREFLIGHT CHECKLIST (PM) ============== 
-- OXYGEN..............................TESTED, 100% (BOTH)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO   (PF)
-- WINDOW HEAT...................................ON   (PF)
-- PRESSURIZATION MODE SELECTOR................AUTO   (PF)
-- PARKING BRAKE................................SET   (PF)
-- ENGINE START LEVERS.......................CUTOFF   (PF)
-- GEAR PINS................................REMOVED   (PF)

local preflightChkl = kcChecklist:new("PREFLIGHT CHECKLIST (PM)")
preflightChkl:addItem(kcIndirectChecklistItem:new("OXYGEN","TESTED #exchange|100 PERC|one hundred percent#",kcFlowItem.actorALL,2,"oxygentested",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(kcChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",kcFlowItem.actorALL,1,
	function () return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end))
preflightChkl:addItem(kcChecklistItem:new("WINDOW HEAT","ON",kcFlowItem.actorPF,1,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end))
preflightChkl:addItem(kcChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorPF,1,
	function () return sysAir.pressModeSelector:getStatus() == 0 end))
preflightChkl:addItem(kcManualChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",kcFlowItem.actorBOTH,6,"mc_flight_instruments",nil,nil,nil))
preflightChkl:addItem(kcChecklistItem:new("PARKING BRAKE","SET",kcFlowItem.actorPF,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
preflightChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorPF,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
preflightChkl:addItem(kcManualChecklistItem:new("GEAR PINS","REMOVED",kcFlowItem.actorPF,1,"mc_gearpins_removed",nil,nil,nil))
-- preflightChkl:addItem(kcSimpleChecklistItem:new("Preflight Checklist Completed"))

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
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set required CDU DISPLAY"))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Check N1 BUGS"))
beforeStartProc:addItem(kcProcedureItem:new("IAS BUGS","SET",kcFlowItem.actorBOTH,2,
	function () return sysFMC.noVSpeeds:getStatus() == 0 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(kcProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))
beforeStartProc:addItem(kcProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end,
	function () sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2")) end))
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
beforeStartProc:addItem(kcSimpleProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS - COMPLETE?"))
beforeStartProc:addItem(kcProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Obtain START CLEARANCE"))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to pressurize hydraulic systems."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to start engines."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(0) end,
	function () return sysFuel.centerTankLbs:getStatus() > 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () sysFuel.wingFuelPumpGroup:actuate(1) end))
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
beforeStartProc:addItem(kcProcedureItem:new("  STABILIZER TRIM","%3.2f UNITS (%3.2f)|sysControls.pitchTrimSwitch:getStatus()|activeBriefings:get(\"takeoff:elevatorTrim\")",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartProc:addItem(kcProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))
-- beforeStartProc:addItem(kcSimpleProcedureItem:new("Call for Before Start Checklist"))

-- ============= BEFORE START CHECKLIST (F/O) ============
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED  (CPT)
-- FUEL..........................9999 KGS, PUMPS ON  (CPT)
-- PASSENGER SIGNS..............................SET  (CPT)
-- WINDOWS...................................LOCKED (BOTH)
-- MCP...................V2 999, HDG 999, ALT 99999  (CPT)
-- TAKEOFF SPEEDS............V1 999, VR 999, V2 999 (BOTH)
-- CDU PREFLIGHT..........................COMPLETED  (CPT)
-- RUDDER & AILERON TRIM.................FREE AND 0  (CPT)
-- TAXI AND TAKEOFF BRIEFING..            COMPLETED  (CPT)
-- ANTI COLLISION LIGHT..........................ON  (CPT)

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
beforeStartChkl:addItem(kcProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","ON",kcFlowItem.actorCPT,2,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))

-- =========== PUSHBACK & ENGINE START (BOTH) ===========
-- PARKING BRAKE...............................SET  (F/O)
-- PUSHBACK SERVICE.........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND.............ESTABLISH  (CPT)
-- PARKING BRAKE..........................RELEASED  (F/O)
-- PACKS...............................AUTO OR OFF  (F/O)
-- When pushback/towing complete
--   TOW BAR DISCONNECTED...................VERIFY  (CPT)
--   LOCKOUT PIN REMOVED....................VERIFY  (CPT)
--   SYSTEM A HYDRAULIC PUMPS...................ON  (F/O)
-- START FIRST ENGINE............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......START SWITCH _ TO GRD  (F/O)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER...............LEVER _ IDLE  (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- START SECOND ENGINE...........STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......START SWITCH _ TO GRD  (F/O)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER...............LEVER _ IDLE  (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- PARKING BRAKE...............................SET  (F/O)
--   When instructed by ground crew after pushback/towing
-- Next BEFORE TAXI PROCEDURE

local pushstartProc = kcProcedure:new("PUSHBACK & ENGINE START (BOTH)")
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end ))
pushstartProc:addItem(kcProcedureItem:new("PUSHBACK SERVICE","ENGAGE",kcFlowItem.actorCPT,2))
pushstartProc:addItem(kcSimpleProcedureItem:new("Engine Start may be done during pushback or towing"))
pushstartProc:addItem(kcProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",kcFlowItem.actorCPT,2))
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","RELEASED",kcFlowItem.actorFO,2,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
pushstartProc:addItem(kcChecklistItem:new("PACKS","AUTO or OFF",kcChecklistItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () sysAir.packSwitchGroup:setValue(1) end))
pushstartProc:addItem(kcSimpleProcedureItem:new("When pushback/towing complete"))
pushstartProc:addItem(kcProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  SYSTEM A HYDRAULIC PUMPS","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.elecHydPump1:getStatus() == 1 end,
	function () sysHydraulic.engHydPump1:actuate(1) sysHydraulic.elecHydPump1:actuate(1) end))
pushstartProc:addItem(kcProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorFO,2,"eng_start_1_grd",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart2Switch:getStatus() == 0 else 
		return sysEngines.engStart1Switch:getStatus() == 0 end end,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		sysEngines.engStart2Switch:actuate(0) else
		sysEngines.engStart1Switch:actuate(0) end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When N1 rotation is seen and N2 is at 25%,"))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorFO,2,"eng_start_1_lever",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.startLever2:getStatus() == 1 else 
		return sysEngines.startLever1:getStatus() == 1 end end,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		sysEngines.startLever2:actuate(1) else
		sysEngines.startLever1:actuate(1) end
	end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorFO,2,"eng_start_2_grd",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart1Switch:getStatus() == 0 else 
		return sysEngines.engStart2Switch:getStatus() == 0 end end,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		sysEngines.engStart1Switch:actuate(0) else
		sysEngines.engStart2Switch:actuate(0) end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When N1 rotation is seen and N2 is at 25%,"))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorFO,2,"eng_start_2_lever",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.startLever1:getStatus() == 1 else 
		return sysEngines.startLever2:getStatus() == 1 end end,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		sysEngines.startLever1:actuate(1) else
		sysEngines.startLever2:actuate(1) end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,"pb_parkbrk_after_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
-- pushstartProc:addItem(kcSimpleProcedureItem:new("  When instructed by ground crew after pushback/towing"))
-- pushstartProc:addItem(kcSimpleProcedureItem:new("Next BEFORE TAXI PROCEDURE"))


-- ============ BEFORE TAXI PROCEDURE (F/O) ============
-- HYDRAULIC PUMP SWITCHES..................ALL ON (F/O)
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
beforeTaxiProc:addItem(kcProcedureItem:new("HYDRAULIC PUMP SWITCHES","ALL ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.hydPumpGroup:getStatus() == 4 end,
	function () sysHydraulic.hydPumpGroup:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () sysElectric.genSwitchGroup:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.probeHeatGroup:getStatus() == 1 end,
	function () sysAice.probeHeatGroup:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  When temperature <10 C & visible moisture"))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  When temperature <10 C & visible moisture"))
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
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(kcProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcProcedureItem:new("FLIGHT CONTROLS","CHECK",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcProcedureItem:new("TRANSPONDER","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("Recall","CHECK",kcFlowItem.actorBOTH,1))
-- beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  Verify annunciators illuminate and then extinguish."))
-- beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

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
-- beforeTaxiChkl:addItem(kcSimpleChecklistItem:new("Next BEFORE TAKEOFF CHECKLIST"))

-- ============ BEFORE TAKEOFF CHECKLIST (F/O) ============
-- TAKEOFF BRIEFING.......................REVIEWED (CPT)
-- FLAPS...........................__, GREEN LIGHT (CPT)
-- STABILIZER TRIM...................... ___ UNITS (CPT)
-- CABIN....................................SECURE (CPT)
-- Next RUNWAY ENTRY PROCEDURE

local beforeTakeoffChkl = kcChecklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
beforeTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","___ GREEN LIGHT",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("STABILIZER TRIM","%3.2f UNITS (%3.2f)|sysControls.pitchTrimSwitch:getStatus()|activeBriefings:get(\"takeoff:elevatorTrim\")",kcChecklistItem.actorCPT,1))
beforeTakeoffChkl:addItem(kcChecklistItem:new("CABIN","SECURE",kcChecklistItem.actorCPT,1))
-- beforeTakeoffChkl:addItem(kcSimpleChecklistItem:new("Next RUNWAY ENTRY PROCEDURE"))

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
-- runwayEntryProc:addItem(kcSimpleChecklistItem:new("Next TAKEOFF AND INITIAL CLIMB"))

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- AUTOTHROTTLE................................ARM   (PF)
-- A/P MODES...........................AS REQUIRED   (PF)
-- THRUST SETTING...........................40% N1  (PNF)
-- SET TAKEOFF THRUST.....................T/O MODE   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PF)
-- GEAR.........................................UP	(PNF)
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)
-- FLAPS 10.........................SET (OPTIONAL)	(PNF)
-- FLAPS 10 SPEED...............REACHED (OPTIONAL)
-- FLAPS 5..........................SET (OPTIONAL)	(PNF)
-- FLAPS 5 SPEED...........................REACHED
-- FLAPS 1.....................................SET 	(PNF)
-- FLAPS 1 SPEED...........................REACHED 
-- FLAPS UP....................................SET 	(PNF)
-- ACCELERATION ALTITUDE.............GT 300 FT AGL
-- CMD-A........................................ON	(PNF)
-- AUTO BRAKE SELECT SWITCH....................OFF	(PNF)
-- GEAR........................................OFF	(PNF)
-- Next AFTER TAKEOFF CHECKLIST

local takeoffClimbProc = kcProcedure:new("TAKEOFF & INITIAL CLIMB")
takeoffClimbProc:addItem(kcProcedureItem:new("AUTOTHROTTLE","ARM",kcFlowItem.actorPF,2,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))
takeoffClimbProc:addItem(kcProcedureItem:new("A/P MODES","%s|kc_pref_split(kc_TakeoffApModes)[activeBriefings:get(\"takeoff:apMode\")]",kcFlowItem.actorPF,2,
	function () 
		if activeBriefings:get("takeoff:apMode") == 1 then
			return sysMCP.lnavSwitch:getStatus() == 1 and sysMCP.vnavSwitch:getStatus() == 1 
		elseif activeBriefings:get("takeoff:apMode") == 2 then
			return sysMCP.hdgselSwitch:getStatus() == 1 and sysMCP.lvlchgSwitch:getStatus() == 1 
		else
			return true
		end
	end, 
	function () 
		if activeBriefings:get("takeoff:apMode") == 1 then
			sysMCP.lnavSwitch:actuate(1) 
			sysMCP.vnavSwitch:actuate(1) 
		elseif activeBriefings:get("takeoff:apMode") == 2 then
			sysMCP.hdgselSwitch:actuate(1)
			sysMCP.lvlchgSwitch:actuate(1)
		else
		end
	end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("THRUST SETTING","40% N1",kcFlowItem.actorPNF,1,"to40percent",
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 40 end))
takeoffClimbProc:addItem(kcProcedureItem:new("SET TAKEOFF THRUST","T/O MODE",kcFlowItem.actorPF,2,
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 70 end,
	function () command_once("laminar/B738/autopilot/left_toga_press") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",kcFlowItem.actorPNF,2,"toposrate",
	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 150 and get("sim/flightmodel/position/y_agl") > 40 end))
takeoffClimbProc:addItem(kcProcedureItem:new("GEAR","UP",kcFlowItem.actorPF,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () sysGeneral.GearSwitch:actuate(0) kc_speakNoText(0,"gear up") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 15 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap15spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_15") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.625 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 10","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/flaps_10") kc_speakNoText(0,"speed check flaps 10") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 10 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap10spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_10") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 5","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.375 end,
	function () command_once("laminar/B738/push_button/flaps_5") kc_speakNoText(0,"speed check flaps 5") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 5 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap5spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_5") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 1","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.125 end,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 1 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap1spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_1") end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS UP","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/push_button/flaps_0") kc_speakNoText(0,"speed check flaps up") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("ACCELERATION ALTITUDE","GT 300 FT AGL",kcFlowItem.actorPNF,2,"toaccalt",
	function () return get("sim/flightmodel/position/y_agl") > 300 end))
takeoffClimbProc:addItem(kcProcedureItem:new("CMD-A","ON",kcFlowItem.actorPF,2,
	function () return sysMCP.ap1Switch:getStatus() == 1 end,
	function () if activePrefSet:get("takeoff_cmda") == true then sysMCP.ap1Switch:actuate(1) end kc_speakNoText(0,"command a") end))
takeoffClimbProc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 1 end,
	function () sysGeneral.autobreak:actuate(1) end))
takeoffClimbProc:addItem(kcProcedureItem:new("GEAR","OFF",kcFlowItem.actorPF,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/gear_off") end))
	
-- takeoffClimbProc:addItem(kcSimpleChecklistItem:new("Next AFTER TAKEOFF CHECKLIST"))

-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- ENGINE BLEEDS................................ON   (PM)
-- PACKS......................................AUTO   (PM)
-- LANDING GEAR.........................UP AND OFF   (PM)
-- FLAPS.............................UP, NO LIGHTS   (PM)
-- ALTIMETERS..................................SET (BOTH)
-- Next CLIMB & CRUISE

local afterTakeoffChkl = kcChecklist:new("AFTER TAKEOFF CHECKLIST (PM)")
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
-- afterTakeoffChkl:addItem(kcSimpleChecklistItem:new("Next CLIMB & CRUISE"))


-- =============== CLIMB & CRUISE (BOTH) ================
-- If the center tank fuel pump switches were OFF for takeoff	
--   and the center tank contains more than 1000 lbs/500 kgs,	
--   set both center tank fuel pump switches ON above 10,000 feet	
-- During climb, set both center tank fuel pump switches OFF	
--   when center tank fuel quantity reaches approx. 1000 lbs/500 kgs	
-- LANDING LIGHTS	OFF AT OR ABOVE 10.000 FT
-- Set the passenger signs as needed.	
-- At transition altitude, set and crosscheck the altimeters to standard.	
-- Set both center tank fuel pump switches OFF when center tank	
--   fuel quantity reaches approx. 1000 lbs/500 kgs	
-- Before the top of descent, modify the active route 	
-- as needed for the arrival and approach.	


local climbCruiseProc = kcProcedure:new("CLIMB & CRUISE")
climbCruiseProc:addItem(kcSimpleChecklistItem:new("If center tank fuel pump switches were OFF for takeoff"))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("  and the center tank contains more than 1000 lbs/500 kgs,"))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("  set both center tank fuel pump switches ON above 10,000 feet"))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("During climb, set both center tank fuel pump switches OFF"))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("  when center tank fuel quantity reaches approx. 1000 lbs/500 kgs"))
climbCruiseProc:addItem(kcChecklistItem:new("LANDING LIGHTS","OFF AT OR ABOVE 10.000 FT",kcChecklistItem.actorPNF,2))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("Set the passenger signs as needed."))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("At transition altitude, set altimeters to standard."))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("Before the top of descent, modify the active route"))
climbCruiseProc:addItem(kcSimpleChecklistItem:new("  as needed for the arrival and approach."))

-- ============ descent =============
local descentProc = kcProcedure:new("DESCENT PROCEDURE")
descentProc:addItem(kcSimpleChecklistItem:new("Set both center tank fuel pump switches OFF when center tank "))
descentProc:addItem(kcSimpleChecklistItem:new("  fuel quantity reaches approximately 3000 pounds/1400 kilograms."))
descentProc:addItem(kcSimpleChecklistItem:new("Verify that pressurization is set to landing altitude."))
descentProc:addItem(kcSimpleChecklistItem:new("Review the system annunciator lights."))
descentProc:addItem(kcSimpleChecklistItem:new("Recall and review the system annunciator lights."))
descentProc:addItem(kcSimpleChecklistItem:new("Enter VREF on the APPROACH REF page."))
descentProc:addItem(kcSimpleChecklistItem:new("Set the RADIO/BARO minimums as needed for the approach."))
descentProc:addItem(kcSimpleChecklistItem:new("Set or verify the navigation radios and course for the approach."))
descentProc:addItem(kcSimpleChecklistItem:new("Set the AUTO BRAKE select switch to the needed brake setting."))
descentProc:addItem(kcSimpleChecklistItem:new("Do the approach briefing."))
-- descentProc:addItem(kcSimpleChecklistItem:new("Call DESCENT CHECKLIST"))

-- =============== DESCENT CHECKLIST (PM) ===============
-- PRESSURISATION...................LAND ALT _____   (PM)
-- RECALL..................................CHECKED   (PM)
-- AUTOBRAKE...................................___   (PM)
-- LANDING DATA...............VREF___, MINIMUMS___ (BOTH)
-- APPROACH BRIEFING.....................COMPLETED   (PM)
-- ======================================================

local descentChkl = kcChecklist:new("DESCENT CHECKLIST (PM)")
descentChkl:addItem(kcChecklistItem:new("PRESSURISATION","LAND ALT___",kcChecklistItem.actorPM,1))
descentChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorPM,1))
descentChkl:addItem(kcChecklistItem:new("AUTOBRAKE","___",kcChecklistItem.actorPM,1))
descentChkl:addItem(kcChecklistItem:new("LANDING DATA","VREF___, MINIMUMS___",kcChecklistItem.actorBOTH,1))
descentChkl:addItem(kcChecklistItem:new("APPROACH BRIEFING","COMPLETED",kcChecklistItem.actorPM,1))
-- descentChkl:addItem(kcSimpleChecklistItem:new("Next APPROACH CHECKLIST"))

-- ============ approach =============
local approachProc = kcProcedure:new("APPROACH PROCEDURE")

 -- =============== APPROACH CHECKLIST (PM) ==============
 -- ALTIMETERS............................QNH _____ (BOTH)
 -- NAV AIDS....................................SET   (PM)
 -- ======================================================

local approachChkl = kcChecklist:new("APPROACH CHECKLIST (PM)")
approachChkl:addItem(kcChecklistItem:new("ALTIMETERS","QNH ___",kcChecklistItem.actorBOTH,1))
approachChkl:addItem(kcChecklistItem:new("NAV AIDS","SET",kcChecklistItem.actorPM,1))
-- approachChkl:addItem(kcSimpleChecklistItem:new("Next LANDING CHECKLIST"))

local landingProc = kcProcedure:new("LANDING PROCEDURE (BOTH)")


 -- =============== LANDING CHECKLIST (PM) ===============
 -- ALTIMETERS............................QNH _____ (BOTH)
 -- CABIN....................................SECURE   (PF)
 -- ENGINE START SWITCHES......................CONT   (PF)
 -- SPEEDBRAKE................................ARMED   (PF)
 -- LANDING GEAR...............................DOWN   (PF)
 -- FLAPS..........................___, GREEN LIGHT   (PF)
 -- ======================================================

local landingChkl = kcChecklist:new("LANDING CHECKLIST (PM)")
landingChkl:addItem(kcChecklistItem:new("CABIN","SECURE",kcChecklistItem.actorPF,2))
landingChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorPF,2,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:adjustValue(2,0,3) end)) 
landingChkl:addItem(kcChecklistItem:new("SPEED BRAKE","ARMED",kcChecklistItem.actorPF,1,
	function () return sysControls.spoilerLever:getStatus() == 0 end))
landingChkl:addItem(kcChecklistItem:new("LANDING GEAR","DOWN",kcChecklistItem.actorPF,2,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
landingChkl:addItem(kcChecklistItem:new("FLAPS","___, GREEN LIGHT",kcChecklistItem.actorPF,2))
-- landingChkl:addItem(kcSimpleChecklistItem:new("Next AFTER LANDING PROCEDURE"))

-- ============ after landing =============
local afterLandingProc = kcProcedure:new("AFTER LANDING PROCEDURE (F/O)")
afterLandingProc:addItem(kcChecklistItem:new("SPEED BRAKE","DOWN",kcChecklistItem.actorPF,2,
	function () return sysControls.spoilerLever:getStatus() == 0 end))
afterLandingProc:addItem(kcChecklistItem:new("CHRONO & ET","STOP",kcChecklistItem.actorCPT,2))
afterLandingProc:addItem(kcChecklistItem:new("WX RADAR","OFF",kcChecklistItem.actorCPT,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("APU SWITCH","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end))
afterLandingProc:addItem(kcProcedureItem:new("APU GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end))
afterLandingProc:addItem(kcProcedureItem:new("FLAPS","UP",kcFlowItem.actorFO,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () sysControls.flapsSwitch:adjustValue(0) end))
afterLandingProc:addItem(kcProcedureItem:new("PROBE HEAT","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("STROBES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.strobesSwitch:getStatus() == 0 end,
	function () sysLights.strobesSwitch:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("LANDING LIGHTS","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("TAXI LIGHTS","ON",kcFlowItem.actorCPT,2,
	function () return sysLights.taxiSwitch:getStatus() > 0 end,
	function () sysLights.taxiSwitch:actuate(1) end))
afterLandingProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:adjustValue(1,0,3) end))
afterLandingProc:addItem(kcProcedureItem:new("TRAFFIC","OFF",kcFlowItem.actorFO,2))
afterLandingProc:addItem(kcProcedureItem:new("AUTOBRAKE","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 1 end,
	function () sysGeneral.autobreak:actuate(1) end))
afterLandingProc:addItem(kcProcedureItem:new("TRANSPONDER","STBY",kcFlowItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrSTBY end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrSTBY,0,5) end))
-- afterLandingProc:addItem(kcSimpleChecklistItem:new("Next SHUTDOWN PROCEDURE"))

-- ============ shutdown =============
local shutdownProc = kcProcedure:new("SHUTDOWN PROCEDURE")
shutdownProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorCPT,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownProc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
shutdownProc:addItem(kcSimpleChecklistItem:new("Electrical power...Set"))
--   If APU power is needed: F/O
-- 	   Verify that the APU GENERATOR OFF BUS light is illuminated.
--     APU GENERATOR bus switches – ON
--     Verify that the SOURCE OFF lights are extinguished.
--   If external power is needed:
--     Verify that the GRD POWER AVAILABLE light is illuminated.
--     GRD POWER switch – ON
--     Verify that the SOURCE OFF lights are extinguished.
shutdownProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
shutdownProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:adjustValue(0,0,2) end))
shutdownProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))
shutdownProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
shutdownProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
shutdownProc:addItem(kcProcedureItem:new("CAB/UTIL POWER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
shutdownProc:addItem(kcProcedureItem:new("IFE/PASS SEAT POWER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
shutdownProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
-- Hydraulic panel....Set F/O
shutdownProc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
shutdownProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
shutdownProc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
shutdownProc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,
	function () sysAir.packLeftSwitch:setValue(1) sysAir.packRightSwitch:setValue(1) end))
shutdownProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
shutdownProc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
shutdownProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end))
-- Exterior lights switches....As needed F/O
shutdownProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysMCP.fdirGroup:getStatus() == 0 end,
	function () sysMCP.fdirGroup:actuate(0) end))
shutdownProc:addItem(kcChecklistItem:new("TRANSPONDER","STBY",kcChecklistItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrSTBY end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrSTBY,0,5) end))
-- shutdownProc:addItem(kcSimpleChecklistItem:new("Next SHUTDOWN CHECKLIST"))
-- Reset MCP
-- [15] = {["activity"] = "DOORS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
-- [16] = {["activity"] = "RESET ELAPSED TIME", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
-- After the wheel chocks are in place: Parking brake – Release C or F/O
-- APU switch....As needed F/O
-- Call “SHUTDOWN CHECKLIST.

 -- ============== SHUTDOWN CHECKLIST (F/O) ==============
 -- HYDRAULIC PANEL.............................SET  (CPT)
 -- PROBE HEAT.............................AUTO/OFF  (CPT)
 -- FUEL PUMPS..................................OFF  (CPT)
 -- FLAPS........................................UP  (CPT)
 -- ENGINE START LEVERS......................CUTOFF  (CPT)
 -- WEATHER RADAR...............................OFF (BOTH)
 -- PARKING BRAKE...............................___  (CPT)
 -- ======================================================

local shutdownChkl = kcChecklist:new("SHUTDOWN CHECKLIST (F/O)")
shutdownChkl:addItem(kcChecklistItem:new("HYDRAULIC PANEL","SET",kcChecklistItem.actorCPT,2))
shutdownChkl:addItem(kcChecklistItem:new("PROBE HEAT","AUTO/OFF",kcChecklistItem.actorCPT,2,
	function () return sysAice.probeHeatGroup:getStatus() < 3 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","ONE PUMP ON FOR APU, REST OFF",kcChecklistItem.actorCPT,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","OFF",kcChecklistItem.actorCPT,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
shutdownChkl:addItem(kcChecklistItem:new("FLAPS","UP",kcChecklistItem.actorCPT,2))
shutdownChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcChecklistItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(cmdDown) end))
shutdownChkl:addItem(kcChecklistItem:new("WEATHER RADAR","OFF",kcChecklistItem.actorBOTH,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
shutdownChkl:addItem(kcChecklistItem:new("PARKING BRAKE","ON",kcChecklistItem.actorCPT,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))


-- ============ secure =============
local secureProc = kcProcedure:new("SECURE PROCEDURE")

-- IRS mode selectors....OFF F/O
-- EMERGENCY EXIT LIGHTS switch....OFF F/O
-- WINDOW HEAT switches....OFF F/O
-- Air conditioning PACK switches....OFF F/O

-- =============== SECURE CHECKLIST (F/O) ===============
-- EFBs (if installed)...................SHUT DOWN  (CPT)
-- IRSs........................................OFF  (CPT)
-- EMERGENCY EXIT LIGHTS.......................OFF  (CPT)
-- WINDOW HEAT.................................OFF  (CPT)
-- PACKS.......................................OFF  (CPT)
  -- If the aircraft is not handed over to succeeding 
  -- flight crew or maintenance personnel:
    -- EFB switches (if installed).............OFF  (CPT)
    -- APU/GRD PWR.............................OFF  (CPT)
    -- GROUND SERVICE SWITCH....................ON  (CPT)
    -- BAT SWITCH..............................OFF  (CPT)
-- ======================================================

local secureChkl = kcChecklist:new("SECURE CHECKLIST (F/O)")
-- secureChkl:addItem(kcChecklistItem:new("EFBs (if installed)","SHUT DOWN",kcChecklistItem.actorCPT))
secureChkl:addItem(kcChecklistItem:new("IRS MODE SELECTORS","OFF",kcChecklistItem.actorCPT,1,
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitOFF) end))
secureChkl:addItem(kcChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",kcChecklistItem.actorCPT,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff  end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
secureChkl:addItem(kcChecklistItem:new("WINDOW HEAT","OFF",kcChecklistItem.actorCPT,2,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
secureChkl:addItem(kcChecklistItem:new("PACKS","OFF",kcChecklistItem.actorCPT,2,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:setValue(0) end))
secureChkl:addItem(kcSimpleChecklistItem:new("  If the aircraft is not handed over to succeeding flight"))
secureChkl:addItem(kcSimpleChecklistItem:new("  crew or maintenance personnel:"))
-- secureChkl:addItem(kcChecklistItem:new("  EFB switches (if installed)","OFF",kcChecklistItem.actorCPT,2))
secureChkl:addItem(kcChecklistItem:new("  APU/GRD PWR","OFF",kcChecklistItem.actorCPT,2))
secureChkl:addItem(kcChecklistItem:new("  GROUND SERVICE SWITCH","ON",kcChecklistItem.actorCPT,2))
secureChkl:addItem(kcChecklistItem:new("  BAT SWITCH","OFF",kcChecklistItem.actorCPT,2,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))

-- ============ Cold & Dark =============
local coldAndDarkProc = kcProcedure:new("SET AIRCRAFT TO COLD & DARK")
-- coldAndDarkProc:addItem(kcProcedureItem:new("XPDR","SET 2000","F/O",1,

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(preflightFOProc)
activeSOP:addProcedure(preflightFO2Proc)
activeSOP:addProcedure(preflightFO3Proc)
activeSOP:addProcedure(preflightCPTProc)
activeSOP:addChecklist(preflightChkl)
activeSOP:addProcedure(beforeStartProc)
activeSOP:addChecklist(beforeStartChkl)
activeSOP:addProcedure(pushstartProc)
activeSOP:addProcedure(beforeTaxiProc)
activeSOP:addChecklist(beforeTaxiChkl)
-- activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addChecklist(beforeTakeoffChkl)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffClimbProc)
activeSOP:addChecklist(afterTakeoffChkl)
activeSOP:addProcedure(climbCruiseProc)
activeSOP:addProcedure(descentProc)
activeSOP:addChecklist(descentChkl)
-- activeSOP:addProcedure(approachProc)
activeSOP:addChecklist(approachChkl)
activeSOP:addProcedure(landingProc)
activeSOP:addChecklist(landingChkl)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(shutdownProc)
activeSOP:addChecklist(shutdownChkl)
activeSOP:addProcedure(secureProc)
activeSOP:addChecklist(secureChkl)
-- activeSOP:addChecklist(coldAndDarkProc)

function getActiveSOP()
	return activeSOP
end

return SOP_B738