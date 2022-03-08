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


-- Set up SOP =========================================================================

activeSOP = kcSOP:new("Zibo Mod SOP")

-- ============ Electrical Power Up Procedures =============

local electricalPowerUpProc = kcProcedure:new("ELECTRICAL POWER UP (F/O)")
electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.batteryCover:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysControls.altFlapsCover:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,1,
	function () return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DOWN",kcFlowItem.actorFO,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysGeneral.gearLightsRed:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/system/takeoff_config_warn") > 0 end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("If external power is needed:",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use Zibo EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GRD POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  GROUND POWER SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("If APU power is needed:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- OVHT Switch not coded
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,function (self) return true end,nil,nil))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  OVHT FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,1,
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,
	function () return sysGeneral.fireWarningAnc:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("  ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  APU","START",kcFlowItem.actorFO,1,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  APU GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  APU GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("    TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysElectric.transferBus1:getStatus() == 0 and sysElectric.transferBus2:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("    SOURCE OFF LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysElectric.sourceOff1:getStatus() == 0 and sysElectric.sourceOff2:getStatus() == 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER","ON",kcFlowItem.actorFO,1,
	function (state) return get("laminar/B738/electric/standby_bat_pos") > 0 end))
electricalPowerUpProc:addItem(kcProcedureItem:new("   STANDBY PWR LIGHT","CHECK EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysElectric.stbyPwrOff:getStatus() == 0 end))
-- does not exist in Zibo
-- electricalPowerUpProc:addItem(kcProcedureItem:new("WHEEL WELL FIRE WARNING SYSTEM","TEST",kcFlowItem.actorFO,1,nil,nil,nil))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))

-- ============ Preliminary Preflight Procedures =============

local prelPreflightProc = kcProcedure:new("PREL PREFLIGHT PROCEDURE (F/O)")
-- not coded in Zibo
-- prelPreflightProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (P6 PANEL)","CHECK",kcFlowItem.actorFO,1,nil,nil,nil))
-- prelPreflightProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL)","CHECK",kcFlowItem.actorFO,1,nil,nil,nil))
prelPreflightProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHT","ARM/ON GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0  end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",kcFlowItem.actorFO,1,
	function () return sysGeneral.attendanceButton:getStatus() > 0 end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Electrical Power Up supplementary procedure is complete."))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","OFF",kcFlowItem.actorFO,1,
	function () return sysGeneral.irsUnit1Switch:getStatus() == 0 and sysGeneral.irsUnit2Switch:getStatus() == 0 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",kcFlowItem.actorFO,1,
	function () return sysGeneral.irsUnit1Switch:getStatus() == 2 and sysGeneral.irsUnit2Switch:getStatus() == 2 end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Verify ON DC lights illuminate then extinguish"))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Verify ALIGN lights are illuminated"))
prelPreflightProc:addItem(kcProcedureItem:new("VOICE RECORDER SWITCH","AUTO",kcFlowItem.actorFO,1,
	function () return  sysGeneral.voiceRecSwitch:getStatus() == 0 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 or get("laminar/B738/push_button/mach_warn2_pos") == 1 end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST","PERFORM",kcFlowItem.actorFO,1,
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
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,1))
prelPreflightProc:addItem(kcProcedureItem:new("IFE & GALLEY POWER","ON",kcFlowItem.actorFO,1))

-- ============ Preflight Procedure =============
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
	function(self) return sysMCP.displayControlSwitch:getStatus() == 0 end))

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
preflightFOProc:addItem(kcIndirectProcedureItem:new("OVHT FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,1,
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,
	function () return sysGeneral.fireWarningAnc:getStatus() > 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,1,
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
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("Hydraulic panel"))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.engHydPump2:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end))

local preflightFO2Proc = kcProcedure:new("PREFLIGHT PROCEDURE PART 2 (F/O)")
preflightFO2Proc:addItem(kcProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",kcFlowItem.actorFO,1,
	function () return sysGeneral.equipCoolExhaust:getStatus() == 0 and sysGeneral.equipCoolSupply:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("NO SMOKING SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,1,
	function () return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("WINDOW HEAT SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end))
preflightFO2Proc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.probeHeatASwitch:getStatus() == 0 and sysAice.probeHeatBSwitch:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.wingAntiIce:getStatus() == 0 end))
preflightFO2Proc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.engAntiIce1:getStatus() == 0 and sysAice.engAntiIce2:getStatus() == 0 end))

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

local preflightCPTProc = kcProcedure:new("PREFLIGHT PROCEDURE (CAPT)")
preflightCPTProc:addItem(kcProcedureItem:new("LIGHTS","TEST",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("EFIS control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BAROMINIMUMS SELECTOR",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("METERS SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("CENTER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("RANGE SELECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Mode control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("COURSE(S)","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("BANK ANGLE SELECTOR","AS NEEDED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("CLOCK","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",kcFlowItem.actorCPT,1))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("Display select panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("INTEGRATED STANDBY FLIGHT DISPLAY","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("REVERSE THRUST LEVERS","DOWN",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("FLAP LEVER","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("RADIO TUNING PANEL","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))


-- ======= Preflight checklist =======

local preflightChkl = kcChecklist:new("PREFLIGHT CHECKLIST (PM)")

preflightChkl:addItem(kcIndirectChecklistItem:new("OXYGEN","Tested, 100%",kcFlowItem.actorALL,1,
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(kcFlowItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",kcFlowItem.actorPF,1,
	function () return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end))
preflightChkl:addItem(kcFlowItem:new("WINDOW HEAT","ON",kcFlowItem.actorPF,1,
	function () return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end))
preflightChkl:addItem(kcFlowItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorPF,1,
	function () return sysAir.pressModeSelector:getStatus() == 0 end))
preflightChkl:addItem(kcFlowItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",kcFlowItem.actorBOTH,1))
preflightChkl:addItem(kcFlowItem:new("PARKING BRAKE","SET",kcFlowItem.actorPF,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
preflightChkl:addItem(kcFlowItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorPF,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
preflightChkl:addItem(kcFlowItem:new("GEAR PINS","REMOVED",kcFlowItem.actorPF,1))

-- ======= Before Start Checklist

local beforeStartChkl = kcChecklist:new("BEFORE START CHECKLIST (F/O)")
beforeStartChkl:addItem(kcFlowItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorCPT,1,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end ))
beforeStartChkl:addItem(kcFlowItem:new("FUEL","___ LBS/KGS, PUMPS ON",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcFlowItem:new("PASSENGER SIGNS","SET",kcFlowItem.actorCPT,1,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end ))
beforeStartChkl:addItem(kcFlowItem:new("WINDOWS","LOCKED",kcFlowItem.actorBOTH,1))
beforeStartChkl:addItem(kcFlowItem:new("MCP","V2___, HDG___, ALT___",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcFlowItem:new("TAKEOFF SPEEDS","V1___, VR___, V2___",kcFlowItem.actorBOTH,1))
beforeStartChkl:addItem(kcFlowItem:new("CDU PREFLIGHT","COMPLETED",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcFlowItem:new("RUDDER & AILERON TRIM","FREE AND 0",kcFlowItem.actorCPT,1,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end ))
beforeStartChkl:addItem(kcFlowItem:new("TAXI AND TAKEOFF BRIEFING","Completed",kcFlowItem.actorCPT,1))
beforeStartChkl:addItem(kcFlowItem:new("ANTI COLLISION LIGHT","ON",kcFlowItem.actorCPT,
	function () return sysLights.beaconSwitch:getStatus() == 1 end ))

-- ======= Before Taxi checklist =======

local beforeTaxiChkl = kcChecklist:new("BEFORE TAXI CHECKLIST (F/O)")
beforeTaxiChkl:addItem(kcChecklistItem:new("GENERATORS","ON",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("PROBE HEAT","ON",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","AS REQUIRED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ISOLATION VALVE","AUTO",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("AUTOBRAKE","RTO",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("FLIGHT CONTROLS","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("GROUND EQUIPMENT","CLEAR",kcChecklistItem.actorBOTH,1))

-- ======= Before Takeoff checklist =======

local beforeTakeoffChkl = kcChecklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
beforeTakeoffChkl:addItem(kcChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","Green light",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("STABILIZER TRIM","___ Units",kcChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(kcChecklistItem:new("CABIN","Secure",kcChecklistItem.actorCPT,nil))

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


-- ============ CDU Preflight =============
local cduPreflightProc = kcProcedure:new("CDU PREFLIGHT PROCEDURE (CPT)")
cduPreflightProc:addItem(kcProcedureItem:new("INITIAL DATA","SET",kcFlowItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  IDENT page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify Model"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify ENG RATING"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  POS INIT page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Set present position"))
cduPreflightProc:addItem(kcProcedureItem:new("NAVIGATION DATA","SET",kcFlowItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  ROUTE page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Enter ORIGIN, route, flight number, activate and execute"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  DEPARTURES page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Execute"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  LEGS page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(kcProcedureItem:new("PERFORMANCE DATA","SET",kcFlowItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  PERF INIT page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Enter ZFW or let it be calculated"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify fuel on CDU"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify gross weight and cruise CG"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  Thrust mode display:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify that TO and dashes show"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  N1 LIMIT page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("  TAKEOFF REF page:"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Enter CG"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify trim value"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select or enter takeoff V speeds"))
cduPreflightProc:addItem(kcProcedureItem:new("PREFLIGHT COMPLETE?","VERIFY",kcFlowItem.actorCPT,1,nil,nil,nil))

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


-- ============ before start Procedure =============
local beforeStartProc = kcProcedure:new("BEFORE START PROCEDURE (BOTH)")
beforeStartProc:addItem(kcProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcProcedureItem:new("CDU DISPLAY","SET",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("N1 BUGS","CHECK",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("IAS BUGS","SET",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(kcProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  IAS/MACH SELECTOR","SET V2",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  LNAV","ARM AS NEEDED",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  VNAV","ARM AS NEEDED",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL HEADING","SET",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL ALTITUDE","SET",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS","COMPLETE",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcProcedureItem:new("START CLEARANCE","OBTAIN",kcFlowItem.actorBOTH,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to pressurize the hydraulic systems."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to start the engines."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("    If the center tank fuel quantity exceeds 1,000 pounds/460 kilograms"))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Hydraulic panel"))
beforeStartProc:addItem(kcProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",kcFlowItem.actorFO,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Trim"))
beforeStartProc:addItem(kcProcedureItem:new("  STABILIZER TRIM","___ UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  AILERON TRIM","0 UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcProcedureItem:new("  RUDDER TRIM","0 UNITS",kcFlowItem.actorCPT,1))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Call for Before Start Checklist"))

-- ============ Pushback Towing Procedure =============
local pushstartProc = kcProcedure:new("PUSHBACK & ENGINE START (BOTH)")

-- ============ Before Taxi =============
local beforeTaxiProc = kcProcedure:new("BEFORE TAXI PROCEDURE (F/O)")
beforeTaxiProc:addItem(kcProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","ON",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("WING ANTI–ICE SWITCH","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE ANTI–ICE SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("PACK SWITCHES","AUTO",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","OFF",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("APU SWITCH","OFF",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","CONT",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(kcProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcProcedureItem:new("FLIGHT CONTROLS","CHECK",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcProcedureItem:new("TRANSPONDER","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("Recall","CHECK",kcFlowItem.actorBOTH,1))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  Verify all annunciators illuminate and then extinguish."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

-- ============ Before Takeoff =============
local beforeTakeoffProc = kcProcedure:new("BEFORE TAKEOFF PROCEDURE (F/O)")

-- ============ Runway entry =============
local runwayEntryProc = kcProcedure:new("RUNWAY ENTRY PROCEDURE (F/O)")

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
-- activeSOP:addProcedure(cduPreflightProc)
-- activeSOP:addProcedure(exteriorInspectionProc)
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