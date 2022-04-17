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


-- Set up SOP =========================================================================

activeSOP = kcSOP:new("Zibo Mod SOP")

-- ============ Electrical Power Up Procedures ========== OK
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- ALTERNATE FLAPS MASTER SWITCH.......GUARD CLOSED (F/O)
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)
-- LANDING GEAR LEVER..........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT.....CHECK ILLUMINATED (F/O)
--   RED LANDING GEAR LIGHT......CHECK EXTINGUISHED (F/O)
-- TAKEOFF CONFIG WARNING......................TEST (F/O)
--   Move thrust levers full forward and back to idle.

-- If external power is needed:                    
--   Use Zibo EFB to turn Ground Power on.         
--   GRD POWER AVAILABLE LIGHT..........ILLUMINATED (F/O)
--   GROUND POWER SWITCH.........................ON (F/O)

-- If APU power is needed:                         
--  OVHT FIRE TEST SWITCH...............HOLD RIGHT (F/O)
--  MASTER FIRE WARN LIGHT....................PUSH (F/O)
--  ENGINES EXT TEST SWITCH.........TEST 1 TO LEFT (F/O)
--  ENGINES EXT TEST SWITCH........TEST 2 TO RIGHT (F/O)
--  APU......................................START (F/O)
--    Hold APU switch in START position for 3-4 seconds.
--  APU GEN OFF BUS LIGHT..............ILLUMINATED (F/O)
--  APU GENERATOR BUS SWITCHES..................ON (F/O)
--     TRANSFER BUS LIGHTS.......CHECK EXTINGUISHED (F/O)
--     SOURCE OFF LIGHTS.........CHECK EXTINGUISHED (F/O)
-- STANDBY POWER.................................ON (F/O)
--   STANDBY PWR LIGHT..........CHECK EXTINGUISHED (F/O)
-- Next: Preliminary Preflight Procedure           

local electricalPowerUpProc = kcProcedure:new("ELECTRICAL POWER UP (F/O)")
electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == 0 end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end,
	function () sysElectric.stbyPowerCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,2,
	function () return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end,
	function () sysGeneral.wiperLeftSwitch:actuate(modeOff) sysGeneral.wiperRightSwitch:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end,
	function () sysHydraulic.elecHydPump1:actuate(modeOff) sysHydraulic.elecHydPump2:actuate(modeOff) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DOWN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearLightsRed:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",kcFlowItem.actorFO,2,"takeoff_config_warn",
	function () return get("laminar/B738/system/takeoff_config_warn") > 0 end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("If external power is needed:",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use Zibo EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GROUND POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(cmdDown) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("If APU power is needed:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- OVHT Switch not coded
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,function (self) return true end,nil,nil))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,2,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,2,"master_fire_warn",
	function () return sysGeneral.fireWarningAnc:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,2,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("    TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.transferBus1:getStatus() == 0 and sysElectric.transferBus2:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("    SOURCE OFF LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.sourceOff1:getStatus() == 0 and sysElectric.sourceOff2:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER","ON",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/electric/standby_bat_pos") > 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPwrOff:getStatus() == 0 end))
-- does not exist in Zibo
-- electricalPowerUpProc:addItem(kcProcedureItem:new("WHEEL WELL FIRE WARNING SYSTEM","TEST",kcFlowItem.actorFO,1,nil,nil,nil))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))

-- ============ Preliminary Preflight Procedures ========OK
-- EMERGENCY EXIT LIGHT.........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON..........................PRESS (F/O)
--   Electrical Power Up supplementary procedure complete
-- IRS MODE SELECTORS...........................OFF (F/O)
-- IRS MODE SELECTORS......................THEN NAV (F/O)
--   Verify ON DC lights illuminate then extinguish
--   Verify ALIGN lights are illuminated           
-- VOICE RECORDER SWITCH.......................AUTO (F/O)
-- MACH OVERSPEED TEST......................PERFORM (F/O)
-- STALL WARNING TEST.......................PERFORM (F/O)
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
-- not coded in Zibo
-- prelPreflightProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (P6 PANEL)","CHECK",kcFlowItem.actorFO,1,nil,nil,nil))
-- prelPreflightProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL)","CHECK",kcFlowItem.actorFO,1,nil,nil,nil))
prelPreflightProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHT","ARM/ON GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0  end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",kcFlowItem.actorFO,1,"attendence_button",
	function () return sysGeneral.attendanceButton:getStatus() > 0 end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Electrical Power Up supplementary procedure completed."))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","OFF",kcFlowItem.actorFO,1,"irs_mode_initial_off",
	function () return sysGeneral.irsUnit1Switch:getStatus() == 0 and sysGeneral.irsUnit2Switch:getStatus() == 0 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",kcFlowItem.actorFO,1,"irs_mode_nav_again",
	function () return sysGeneral.irsUnit1Switch:getStatus() == 2 and sysGeneral.irsUnit2Switch:getStatus() == 2 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS LEFT ON DC","ILLUMINATES & EXTINGUISHES",kcFlowItem.actorFO,1,"irs_left_dc",
	function () return sysGeneral.irs1OnDC:getStatus() == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS RIGHT ON DC","ILLUMINATES & EXTINGUISHES",kcFlowItem.actorFO,1,"irs_right_dc",
	function () return sysGeneral.irs2OnDC:getStatus() == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS LEFT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,1,"irs_left_align",
	function () return sysGeneral.irs1Align:getStatus() == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS RIGHT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,1,"irs_right_align",
	function () return sysGeneral.irs2Align:getStatus() == 1 end))
prelPreflightProc:addItem(kcProcedureItem:new("VOICE RECORDER SWITCH","AUTO",kcFlowItem.actorFO,1,
	function () return  sysGeneral.voiceRecSwitch:getStatus() == 0 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",kcFlowItem.actorFO,1,"mach_ovspd_test",
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 or get("laminar/B738/push_button/mach_warn2_pos") == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST","PERFORM",kcFlowItem.actorFO,1,"stall_warning_test",
	function () return get("laminar/B738/push_button/stall_test1") == 1 or get("laminar/B738/push_button/stall_test2") == 1 end))
prelPreflightProc:addItem(kcProcedureItem:new("XPDR","SET 2000",kcFlowItem.actorFO,1,
	function () return get("sim/cockpit/radios/transponder_code") == 2000 end))
prelPreflightProc:addItem(kcProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"SET AS NEEDED\" or \"ON\"",kcFlowItem.actorFO,1))
prelPreflightProc:addItem(kcProcedureItem:new("WING & WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"SET AS REQUIRED\" or \"ON\"",kcFlowItem.actorFO,1))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","%s|(activePrefSet:get(\"aircraft:powerup_apu\")) and \"APU 1 PUMP ON, REST OFF\" or \"ALL OFF\"",kcFlowItem.actorFO,1,
	function () return sysFuel.allFuelPumpsOff:getStatus() == 1 end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/knobs/cross_feed_pos") == 0 end))
prelPreflightProc:addItem(kcProcedureItem:new("POSITION LIGHTS","ON",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/toggle_switch/position_light_pos") ~= 0 end))
prelPreflightProc:addItem(kcProcedureItem:new("MCP","INITIALIZE",kcFlowItem.actorFO,1))
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
prelPreflightProc:addItem(kcProcedureItem:new("IFE & GALLEY POWER","ON",kcFlowItem.actorFO,1))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("Next: CDU Preflight"))

-- ================== CDU Preflight ================== OK
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
	function () return sysFMC.fmcRouteEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ROUTE","ACTIVATE",kcFlowItem.actorCPT,1,"route_activated",
	function () return sysFMC.fmcRouteActivated:getStatus() end))
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
cduPreflightProc:addItem(kcSimpleProcedureItem:new("CDU PREFLIGHT COMPLETE"))

-- ================ Preflight Procedure =================OK
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
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,1,
	function () return sysControls.fltCtrlACover:getStatus() == 0 and sysControls.fltCtrlBCover:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,1,
	function () return sysControls.spoilerACover:getStatus() == 0 and sysControls.spoilerBCover:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("YAW DAMPER SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysControls.yawDamper:getStatus() == 1 end))
preflightFOProc:addItem(kcSimpleProcedureItem:new("NAVIGATION & DISPLAYS panel"))
preflightFOProc:addItem(kcProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,1,
	function() return sysMCP.vhfNavSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,1,
	function() return sysMCP.irsNavSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,1,
	function() return sysMCP.fmcNavSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("SOURCE SELECTOR","AUTO",kcFlowItem.actorFO,1,
	function() return sysMCP.displaySourceSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",kcFlowItem.actorFO,1,
	function() return sysMCP.displayControlSwitch:getStatus() == 0 end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Fuel panel"))
preflightFOProc:addItem(kcProcedureItem:new("CROSSFEED SELECTOR","CLOSED",kcFlowItem.actorFO,1,
	function () return sysFuel.crossFeed:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL PUMP SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelPumpLeftAft:getStatus() == 0 and sysFuel.fuelPumpLeftFwd:getStatus() == 0 and sysFuel.fuelPumpRightAft:getStatus() == 0 and sysFuel.fuelPumpRightFwd:getStatus() == 0 and sysFuel.fuelPumpCtrLeft:getStatus() == 0 and sysFuel.fuelPumpCtrRight:getStatus() == 0 end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Electrical panel"))
preflightFOProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.batterySwitch:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("CAB/UTIL POWER SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.cabUtilPwr:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("IFE/PASS SEAT POWER SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.ifePwr:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.genDrive1Cover:getStatus() == 0 and sysElectric.genDrive2Cover:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.busTransCover:getStatus() == 0 end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("Overheat and fire protection panel"))
-- preflightFOProc:addItem(kcProcedureItem:new("OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,function (self) return true end,nil,nil))
preflightFOProc:addItem(kcIndirectProcedureItem:new("OVHT FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,1,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,"master_fire_warn",
	function () return sysGeneral.fireWarningAnc:getStatus() > 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,1,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,1,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end))
preflightFOProc:addItem(kcProcedureItem:new("APU SWITCH","START",kcFlowItem.actorFO,1,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("APU GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("APU GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end))

preflightFOProc:addItem(kcProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",kcFlowItem.actorFO,1,
	function () return sysGeneral.equipCoolExhaust:getStatus() == 0 and sysGeneral.equipCoolSupply:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("NO SMOKING SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end))
preflightFOProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end))
preflightFOProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,1,
	function () return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("WINDOW HEAT SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.probeHeatASwitch:getStatus() == 0 and sysAice.probeHeatBSwitch:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.wingAntiIce:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.engAntiIce1:getStatus() == 0 and sysAice.engAntiIce2:getStatus() == 0 end))
	

preflightFOProc:addItem(kcSimpleProcedureItem:new("NEXT Prelimibary Preflight Part 2"))

-- ========== PREFLIGHT PROCEDURE PART 2 (F/O) ==========
-- Air conditioning panel                          
-- AIR TEMPERATURE SOURCE SELECTOR........AS NEEDED (F/O)
-- TRIM AIR SWITCH...............................ON (F/O)
-- RECIRCULATION FAN SWITCHES..................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH......................OPEN (F/O)
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
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.engHydPump2:getStatus() == 1 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end))
	
preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Air conditioning panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","AS NEEDED",kcFlowItem.actorFO,1,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("TRIM AIR SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysAir.trimAirSwitch:getStatus() == 1 end))
preflightFO2Proc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.recircFanLeft:getStatus() == 1 and sysAir.recircFanRight:getStatus() == 1 end))
preflightFO2Proc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",kcFlowItem.actorFO,1,
	function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",kcFlowItem.actorFO,1,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end))
preflightFO2Proc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysAir.apuBleedSwitch:getStatus() == 1 end))

preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Cabin pressurization panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("FLIGHT ALTITUDE INDICATOR","CRUISE ALTITUDE",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("LANDING ALTITUDE INDICATOR","DEST FIELD ELEVATION",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.pressModeSelector:getStatus() == 0 end))

preflightFO2Proc:addItem(kcSimpleProcedureItem:new("Lighting panel"))
preflightFO2Proc:addItem(kcProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",kcFlowItem.actorFO,1,
	function () return sysLights.llRetLeftSwitch:getStatus() == 0 and sysLights.llRetRightSwitch:getStatus() == 0 and sysLights.llLeftSwitch:getStatus() == 0 and sysLights.llRightSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.rwyLeftSwitch:getStatus() == 0 and sysLights.rwyRightSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.taxiSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("LOGO LIGHT SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("POSITION LIGHT SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("WING ILLUMINATION SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("WHEEL WELL LIGHT SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO2Proc:addItem(kcProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",kcFlowItem.actorFO,1,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysEngines.engStart1Switch:getStatus() == 1 and sysEngines.engStart2Switch:getStatus() == 1 end))

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
preflightFO3Proc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 and sysMCP.fdirCoPilotSwitch:getStatus() == 1 end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BARO",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MINIMUMS SELECTOR","SET DH OR DA REFERENCE",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysMCP.fpvSwitch:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("METERS SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysMCP.mtrsSwitch:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("CENTER SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("RANGE SELECTOR","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("OXYGEN","TEST AND SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,1,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,1,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("GROUND PROXIMITY panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("Landing gear panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DN",kcFlowItem.actorFO,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end))
preflightFO3Proc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","RTO",kcFlowItem.actorFO,1,
	function () return sysGeneral.autobreak:getStatus() == 0 end))
preflightFO3Proc:addItem(kcProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))
	
preflightFO3Proc:addItem(kcSimpleProcedureItem:new("Radio tuning panel"))
preflightFO3Proc:addItem(kcProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("AUDIO CONTROL PANEL","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("ADF RADIOS","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("WEATHER RADAR PANEL","SET",kcFlowItem.actorFO,1))
preflightFO3Proc:addItem(kcProcedureItem:new("TRANSPONDER PANEL","SET",kcFlowItem.actorFO,1))

-- ===== PREFLIGHT PROCEDURE CAPT =====

local preflightCPTProc = kcProcedure:new("PREFLIGHT PROCEDURE (CAPT)")
preflightCPTProc:addItem(kcIndirectProcedureItem:new("LIGHTS","TEST",kcFlowItem.actorCPT,1,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",kcFlowItem.actorCPT,1,
	function () return (sysEFIS.minsTypePilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mins_dh") == true) or (sysEFIS.minsTypePilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mins_dh") == false) end )) 
preflightCPTProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",kcFlowItem.actorCPT,1,
	function () return sysEFIS.minsResetPilot:getStatus() == 1 end))
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
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",kcFlowItem.actorCPT,1,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end))
preflightCPTProc:addItem(kcProcedureItem:new("BANK ANGLE SELECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",kcFlowItem.actorCPT,1,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Display select panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("INTEGRATED STANDBY FLIGHT DISPLAY","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",kcFlowItem.actorCPT,1,
	function () return sysControls.spoilerLever:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("REVERSE THRUST LEVERS","DOWN",kcFlowItem.actorCPT,1,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",kcFlowItem.actorCPT,1,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("FLAP LEVER","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
preflightCPTProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
preflightCPTProc:addItem(kcProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("RADIO TUNING PANEL","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))

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


-- ============ before start Procedure =============
local beforeStartProc = kcProcedure:new("BEFORE START PROCEDURE (BOTH)")
beforeStartProc:addItem(kcProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorFO,1,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end))
beforeStartProc:addItem(kcProcedureItem:new("CDU DISPLAY","SET",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("N1 BUGS","CHECK",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("IAS BUGS","SET",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(kcProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",kcFlowItem.actorCPT,1,
	function () return sysMCP.athrSwitch:getStatus() == 1 end))
beforeStartProc:addItem(kcProcedureItem:new("  IAS/MACH SELECTOR","SET V2",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  LNAV","ARM AS NEEDED",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  VNAV","ARM AS NEEDED",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL HEADING","SET",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL ALTITUDE","SET",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS","COMPLETE",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.doorGroup:getStatus() == 0 end))
beforeStartProc:addItem(kcProcedureItem:new("START CLEARANCE","OBTAIN",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to pressurize the hydraulic systems."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to start the engines."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,nil,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 4 end,nil,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 6 end,nil,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Hydraulic panel"))
beforeStartProc:addItem(kcProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end))
beforeStartProc:addItem(kcProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end))
beforeStartProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 1 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Trim"))
beforeStartProc:addItem(kcProcedureItem:new("  STABILIZER TRIM","___ UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  AILERON TRIM","0 UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  RUDDER TRIM","0 UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Call for Before Start Checklist"))


-- ============ BEFORE START CHECKLIST (F/O) ============OK
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
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end ))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorCPT,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 4 end,nil,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorCPT,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 6 end,nil,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartChkl:addItem(kcChecklistItem:new("PASSENGER SIGNS","SET",kcFlowItem.actorCPT,1,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end ))
beforeStartChkl:addItem(kcFlowItem:new("WINDOWS","LOCKED",kcFlowItem.actorBOTH,1))
beforeStartChkl:addItem(kcChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|sysFMC.V2:getStatus()|sysMCP.hdgSelector:getStatus()|sysMCP.altSelector:getStatus()",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|sysFMC.V1:getStatus()|sysFMC.Vr:getStatus()|sysFMC.V2:getStatus()",kcFlowItem.actorBOTH,1))
beforeStartChkl:addItem(kcChecklistItem:new("CDU PREFLIGHT","COMPLETED",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",kcFlowItem.actorCPT,1,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end ))
beforeStartChkl:addItem(kcChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",kcFlowItem.actorCPT,1))

-- ============ Pushback Towing Procedure =============
local pushstartProc = kcProcedure:new("PUSHBACK & ENGINE START (BOTH)")
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
pushstartProc:addItem(kcSimpleProcedureItem:new("Engine Start may be done during pushback or towing"))
pushstartProc:addItem(kcProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","RELEASED",kcFlowItem.actorFO,1,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
pushstartProc:addItem(kcSimpleProcedureItem:new("When pushback/towing complete"))
pushstartProc:addItem(kcProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("  SYSTEM A HYDRAULIC PUMPS","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.elecHydPump1:getStatus() == 1 end ))
-- Call “START ___ ENGINE 1”
-- ENGINE START switch GRD
-- Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- Engine start lever .....................................................IDLE
-- Call “STARTER CUTOUT.” F/O
-- Call “START ___ ENGINE 1”
-- ENGINE START switch GRD
-- Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- Engine start lever .....................................................IDLE
-- Call “STARTER CUTOUT.” F/O


-- ============ Before Taxi =============
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
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end,
	function () sysEngines.startLeverGroup:actuate(cmdUp) end))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(kcProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcProcedureItem:new("FLIGHT CONTROLS","CHECK",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcProcedureItem:new("TRANSPONDER","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("Recall","CHECK",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  Verify all annunciators illuminate and then extinguish."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

-- ======= Before Taxi checklist =======
local beforeTaxiChkl = kcChecklist:new("BEFORE TAXI CHECKLIST (F/O)")
beforeTaxiChkl:addItem(kcChecklistItem:new("GENERATORS","ON",kcChecklistItem.actorCPT,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end ))
beforeTaxiChkl:addItem(kcChecklistItem:new("PROBE HEAT","ON",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","AS REQUIRED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ISOLATION VALVE","AUTO",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("AUTOBRAKE","RTO",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("FLIGHT CONTROLS","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("GROUND EQUIPMENT","CLEAR",kcChecklistItem.actorBOTH,1))

-- ============ Before Takeoff =============
local beforeTakeoffProc = kcProcedure:new("BEFORE TAKEOFF PROCEDURE (F/O)")
-- verify an increase in engine oil temperature before takeoff
-- Engine warm up recommendations:
-- • run the engines for at least 2 minutes
-- • use a thrust setting normally used for taxi operations
-- takeoff briefing
-- notify cabin
-- wx as needed
-- terr as needed

-- ======= Before Takeoff checklist =======
local beforeTakeoffChkl = kcChecklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
beforeTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","Green light",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("STABILIZER TRIM","___ Units",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("CABIN","Secure",kcChecklistItem.actorCPT,nil))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)

local runwayEntryProc = kcProcedure:new("RUNWAY ENTRY PROCEDURE (F/O)")

-- ======= After Takeoff checklist =======

local afterTakeoffChkl = kcChecklist:new("AFTER TAKEOFF CHECKLIST (PM)")
afterTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(kcChecklistItem:new("ENGINE BLEEDS","ON",kcChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(kcChecklistItem:new("PACKS","AUTO",kcChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(kcChecklistItem:new("LANDING GEAR","UP AND OFF",kcChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","UP, NO LIGHTS",kcChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(kcChecklistItem:new("ALTIMETERS","SET",kcChecklistItem.actorBOTH,nil))

-- ======= Descent checklist =======

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

local landingChkl = kcChecklist:new("LANDING CHECKLIST (PM)")
landingChkl:addItem(kcChecklistItem:new("CABIN","SECURE",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("SPEEDBRAKE","ARMED",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("LANDING GEAR","DOWN",kcChecklistItem.actorPF,nil))
landingChkl:addItem(kcChecklistItem:new("FLAPS","___, GREEN LIGHT",kcChecklistItem.actorPF,nil))

-- ======= Shutdown checklist =======

local shutdownChkl = kcChecklist:new("SHUTDOWN CHECKLIST (F/O)")
shutdownChkl:addItem(kcChecklistItem:new("HYDRAULIC PANEL","SET",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("PROBE HEAT","AUTO/OFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","OFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("FLAPS","UP",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcChecklistItem.actorCPT,nil))
shutdownChkl:addItem(kcChecklistItem:new("WEATHER RADAR","OFF",kcChecklistItem.actorBOTH,nil))
shutdownChkl:addItem(kcChecklistItem:new("PARKING BRAKE","___",kcChecklistItem.actorCPT,nil))


-- ======= Secure checklist =======

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



-- ============ External Walkaround =============
local exteriorInspectionProc = kcProcedure:new("EXTERIOR INSPECTION")
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Forward Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Nose Wheel Well"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Exterior light","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Gear strut and doors","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Nose wheel steering assembly","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Forward Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Wing Root, Pack, and Lower Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Exterior lights","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Leading edge flaps","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Number 2 Engine"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Fan blades, probes, and spinner","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Thrust reverser","Stowed"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Exhaust area and tailcone","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Wing and Leading Edge"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Leading edge flaps and slats","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Wing Surfaces","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Wing Tip and Trailing Edge"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Position and strobe lights","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Aileron and trailing edge flaps","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Main Gear"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Tires, brakes and wheels","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Gear strut, actuators, and doors","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Main Wheel Well"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Wheel well","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Right Aft Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Outflow valve","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  APU air inlet","Open"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Tail"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Vertical stabilizer and rudder","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Horizontal stabilizer and elevator","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Strobe light","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Aft Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Main Gear"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Tires, brakes and wheels","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Gear strut, actuators, and doors","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Main Wheel Well"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Wheel well","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Wing Tip and Trailing Edge"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Aileron and trailing edge flaps","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Position and strobe lights","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Wing and Leading Edge"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Wing Surfaces","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Leading edge flaps and slats","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Number 1 Engine"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Exhaust area and tailcone","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Thrust reverser","Stowed"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Fan blades, probes, and spinner","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcSimpleProcedureItem:new("Left Wing Root, Pack, and Lower Fuselage"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Leading edge flaps","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(kcProcedureItem:new("  Exterior lights","Check"))






-- ============ start and initial climb =============
local takeoffClimbProc = kcProcedure:new("TAKEOFF & INITIAL CLIMB")

-- ============ climb & cuise =============
local climbCruiseProc = kcProcedure:new("CLIMB & CRUISE")

-- ============ descent =============
local descentProc = kcProcedure:new("DESCENT PROCEDURE")

-- ============ approach =============
local approachProc = kcProcedure:new("APPROACH PROCEDURE")

-- ============ landing =============
local landingProc = kcProcedure:new("LANDING PROCEDURE")

-- ============ after landing =============
local afterLandingProc = kcProcedure:new("AFTER LANDING PROCEDURE")

-- ============ shutdown =============
local shutdownProc = kcProcedure:new("SHUTDOWN PROCEDURE")

-- ============ secure =============
local secureProc = kcProcedure:new("SECURE PROCEDURE")

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
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addChecklist(beforeTakeoffChkl)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffClimbProc)
activeSOP:addChecklist(afterTakeoffChkl)
activeSOP:addProcedure(climbCruiseProc)
activeSOP:addProcedure(descentProc)
activeSOP:addChecklist(descentChkl)
activeSOP:addProcedure(approachProc)
activeSOP:addChecklist(approachChkl)
activeSOP:addProcedure(landingProc)
activeSOP:addChecklist(landingChkl)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(shutdownProc)
activeSOP:addChecklist(shutdownChkl)
activeSOP:addProcedure(secureProc)
activeSOP:addChecklist(secureChkl)

function getActiveSOP()
	return activeSOP
end

return SOP_B738