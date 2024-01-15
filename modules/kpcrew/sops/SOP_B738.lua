-- Standard Operating Procedure for Zibo Mod B738 module

-- @classmod SOP_B738
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_B738 = {
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

activeSOP = SOP:new("Zibo Mod SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("MCP","C&D",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_mcp_cold_dark()
	end))
testProc:addItem(ProcedureItem:new("MCP","PREFLIGHT",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_mcp_preflight()
	end))
testProc:addItem(ProcedureItem:new("MCP","TAKEOFF",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_mcp_takeoff()
	end))
testProc:addItem(ProcedureItem:new("MCP","GA",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_mcp_goaround()
	end))
testProc:addItem(ProcedureItem:new("MCP","AFTER LAND",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_mcp_after_landing()
	end))
	
-- ============ Electrical Power Up Procedure ============
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ===== Initial checks
-- DC Electric Power
-- CIRCUIT BREAKERS (P6 PANEL)..........CHECK ALL IN (F/O)
-- CIRCUIT BREAKERS (P18 PANEL).........CHECK ALL IN (F/O)
-- DC POWER SWITCH...............................BAT (F/O)
-- BATTERY VOLTAGE.....................CHECK MIN 24V (F/O)
-- BATTERY SWITCH.......................GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH.................GUARD CLOSED (F/O)

-- Hydraulic System
-- ELECTRIC HYDRAULIC PUMPS SWITCHES.............OFF (F/O)
-- ALTERNATE FLAPS MASTER SWITCH........GUARD CLOSED (F/O)
-- FLAP LEVER.....................................UP (F/O)
--   Ensure flap lever agrees with indicated flap position.

-- Other
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)
-- LANDING GEAR LEVER...........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED (F/O)
--   RED LANDING GEAR LIGHT.......CHECK EXTINGUISHED (F/O)
-- TAKEOFF CONFIG WARNING.......................TEST (F/O)
--   Move thrust levers full forward and back to idle.

-- ==== Activate External Power
-- Use Zibo EFB to turn Ground Power on.         
-- GRD POWER AVAILABLE LIGHT...........ILLUMINATED (F/O)
-- AC POWER SWITCH.............................GRD (F/O)
-- GROUND POWER SWITCH..........................ON (F/O)

-- ==== Activate APU 
--   OVHT DET SWITCHES........................NORMAL (F/O)
--   OVHT FIRE TEST SWITCH................HOLD RIGHT (F/O)
--   MASTER FIRE WARN LIGHT.....................PUSH (F/O)
--   ENGINES EXT TEST SWITCH..........TEST 1 TO LEFT (F/O)
--   ENGINES EXT TEST SWITCH.........TEST 2 TO RIGHT (F/O)
--   APU.......................................START (F/O)
--     Hold APU switch in START position for 3-4 seconds.
--   APU GEN OFF BUS LIGHT...............ILLUMINATED (F/O)
--   AC POWER SWITCH.............................APU (F/O)
--   APU GENERATOR BUS SWITCHES...................ON (F/O)
--   LEFT FORWARD FUEL PUMP.......................ON (F/O)

-- TRANSFER BUS LIGHTS............CHECK EXTINGUISHED (F/O)
-- SOURCE OFF LIGHTS..............CHECK EXTINGUISHED (F/O)
-- STANDBY POWER..................................ON (F/O)
--   STANDBY PWR LIGHT............CHECK EXTINGUISHED (F/O)
-- POSITION LIGHTS................................ON (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- WING & WHEEL WELL LIGHTS..............AS REQUIRED (F/O)
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS (P6 PANEL)","CHECK ALL IN",FlowItem.actorFO,0,true))
electricalPowerUpProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS (CONTROL,P18 PANEL)","CHECK ALL IN",FlowItem.actorFO,0,true))
electricalPowerUpProc:addItem(ProcedureItem:new("DC POWER SWITCH","BAT",FlowItem.actorFO,0,
	function () return sysElectric.dcPowerSwitch:getStatus() == sysElectric.dcPwrBAT end,
	function () 
		sysElectric.dcPowerSwitch:actuate(sysElectric.dcPwrBAT) 
		if activePrefSet:get("general:sges") == true then
			kc_macro_start_sges_sequence()
		end
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 24V",FlowItem.actorFO,0,"bat24v",
	function () return get("laminar/B738/dc_volt_value") > 23 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.batteryCover:getStatus() == 0 end,
	function () 
		kc_macro_lights_preflight()
		sysElectric.batteryCover:actuate(0) 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end,
	function () sysElectric.stbyPowerCover:actuate(0) end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Hydraulic System"))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () kc_macro_hydraulic_initial() end))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Ensure flap lever agrees with indicated flap position."))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  In Cold&Dark in SIM this is the UP position."))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Other"))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(modeOff) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == modeOn end))
electricalPowerUpProc:addItem(ProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsRed:getStatus() == modeOff end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",FlowItem.actorFO,3,"takeoff_config_warn",
	function () return get("laminar/B738/system/takeoff_config_warn") > 0 end,
	function () 
		kc_procvar_set("toctest",true) -- background test
	end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Use Zibo EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("#exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,
	function () 
		kc_macro_gpu_connect()
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("AC/GRD POWER SWITCH","GRD",FlowItem.actorFO,0,
	function () return sysElectric.acPowerSwitch:getStatus() == sysElectric.acPwrGRD end,
	function () sysElectric.acPowerSwitch:actuate(sysElectric.acPwrGRD) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("GROUND POWER VOLTAGE","CHECK > 110 VOLT",FlowItem.actorFO,0,
	function () return get("laminar/B738/ac_volt_value") > 110 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GROUND POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:step(cmdDown) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL PUMPS","OFF/LEFT FWD ON",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("OVHT DET SWITCH","NORMAL",FlowItem.actorFO,0,true,
	function () sysElectric.gpuSwitch:step(cmdUp) end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == false or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,0,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () 
		kc_procvar_set("ovhttest",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == false or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,0,true,nil,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == false or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",FlowItem.actorFO,0,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,
	function () 
		kc_procvar_set("ext1test",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == false or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",FlowItem.actorFO,0,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,
	function () 
		kc_procvar_set("ext2test",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == false or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_procvar_set("apustart",true) -- background start
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("AC POWER SWITCH","APU",FlowItem.actorFO,0,
	function () return sysElectric.acPowerSwitch:getStatus() == sysElectric.acPwrAPU end,
	function () sysElectric.acPowerSwitch:actuate(sysElectric.acPwrAPU) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("APU GENERATOR VOLTAGE","> 110 VOLT",FlowItem.actorFO,0,
	function () return get("laminar/B738/ac_volt_value") > 110 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("LEFT FORWARD FUEL PUMP","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpLeftFwd:getStatus() == 1 end,
	function () sysFuel.fuelPumpLeftFwd:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== "))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(ProcedureItem:new("SOURCE OFF LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.sourceOff1:getStatus() == modeOff and sysElectric.sourceOff2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/B738/electric/standby_bat_pos") > 0 end))
electricalPowerUpProc:addItem(ProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPwrOff:getStatus() == modeOff end))
electricalPowerUpProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(ProcedureItem:new("WING LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == 1 end,
	function () sysLights.wingSwitch:actuate(1) end,
	function () return kc_is_daylight() == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("WING LIGHTS","OFF",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == 0 end,
	function () sysLights.wingSwitch:actuate(0) end,
	function () return kc_is_daylight() == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))

-- ============ PRELIMINARY PREFLIGHT PROCEDURES =========
   
-- ==== Verify quantities
-- OXYGEN PRESSURE...........................CHECKED (F/O)
-- HYDRAULIC QUANTITY A & B..................CHECKED (F/O)
-- ENGINE OIL QUANTITY 1 & 2.................CHECKED (F/O)

-- ==== Overhead
-- VOICE RECORDER SWITCH........................AUTO (F/O)
-- SERVICE INTERPHONE............................OFF (F/O)
-- ====== Engine Panel
-- EEC SWITCHES...................................ON (F/O)
-- EEC GUARDS.................................CLOSED (F/O)
-- EEC FAIL LIGHTS......................EXTINGUISHED (F/O)
-- REVERSER FAIL LIGHTS.................EXTINGUISHED (F/O)
-- ====
-- PASSENGER OXYGEN SWITCH......NORMAL, GUARD CLOSED (F/O)
-- EMERGENCY EXIT LIGHT..........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON...........................PRESS (F/O)
-- ELECTRICAL POWER UP......................COMPLETE (F/O)
-- FLIGHT DATA RECORDER SWITCH..................AUTO (F/O)
-- MACH OVERSPEED TEST.......................PERFORM (F/O)

-- ==== IRS Alignment
-- IRS MODE SELECTORS............................OFF (CPT)
-- IRS MODE SELECTORS.......................THEN NAV (CPT)
--   Verify ON DC lights illuminate then extinguish
--   Verify ALIGN lights are illuminated  
-- =======================================================

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight","I will do the walk around now")
prelPreflightProc:setFlightPhase(2)

prelPreflightProc:addItem(SimpleProcedureItem:new("==== Verify quantities"))
prelPreflightProc:addItem(ProcedureItem:new("OXYGEN PRESSURE","CHECKED",FlowItem.actorFO,0,true))
prelPreflightProc:addItem(ProcedureItem:new("HYDRAULIC QUANTITY A & B","CHECKED",FlowItem.actorFO,0,
	function () 
		return get("laminar/B738/hydraulic/hyd_A_qty") > 80 and
		get("laminar/B738/hydraulic/hyd_B_qty") > 80
	end))
prelPreflightProc:addItem(ProcedureItem:new("ENGINE OIL QUANTITY 1 & 2","CHECKED",FlowItem.actorFO,0,
	function () 
		return get("sim/flightmodel/engine/ENGN_oil_quan",0) > 0.80 and
		get("sim/flightmodel/engine/ENGN_oil_quan",1) > 0.80
	end))

prelPreflightProc:addItem(SimpleProcedureItem:new("==== Overhead"))
prelPreflightProc:addItem(ProcedureItem:new("VOICE RECORDER SWITCH","AUTO",FlowItem.actorCPT,0,
	function () return  sysGeneral.vcrSwitch:getStatus() == 0 end,
	function () sysGeneral.vcrSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(ProcedureItem:new("SERVICE INTERPHONE","OFF",FlowItem.actorCPT,0,
	function () return  get("laminar/B738/toggle_switch/service_interphone") == 0 end,
	function () set("laminar/B738/toggle_switch/service_interphone",0) end))
prelPreflightProc:addItem(SimpleProcedureItem:new("======= Engine Panel"))
prelPreflightProc:addItem(ProcedureItem:new("EEC SWITCHES","ON",FlowItem.actorCPT,0,
	function () return sysEngines.eecSwitchGroup:getStatus() == 0 end,
	function () sysEngines.eecSwitchGroup:actuate(1) end))
prelPreflightProc:addItem(ProcedureItem:new("EEC GUARDS","CLOSED",FlowItem.actorCPT,0,
	function () return sysEngines.eecGuardGroup:getStatus() == 0 end,
	function () sysEngines.eecGuardGroup:actuate(0) end))
prelPreflightProc:addItem(ProcedureItem:new("EEC FAIL LIGHTS","EXTINGUISHED",FlowItem.actorCPT,0,
	function () return sysEngines.fadecFail:getStatus() == 0 end))
prelPreflightProc:addItem(ProcedureItem:new("REVERSER FAIL LIGHTS","EXTINGUISHED",FlowItem.actorCPT,0,
	function () return sysEngines.reversersFail:getStatus() == 0 end))

prelPreflightProc:addItem(SimpleProcedureItem:new("======="))
prelPreflightProc:addItem(ProcedureItem:new("PASSENGER OXYGEN SWITCH","NORMAL, GUARD CLOSED",FlowItem.actorFO,0,
	function () 
		return sysGeneral.PaxOxySwitch:getStatus() == 0 and
		sysGeneral.PaxOxyCover:getStatus() == 0
	end,
	function () 
		sysGeneral.PaxOxyCover:actuate(0) 
	end))
prelPreflightProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM #exchange|/ON GUARD CLOSED| #",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0  end,
	function () sysGeneral.emerExitLightsCover:actuate(0) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",FlowItem.actorFO,0,"attendence_button",
	function () return sysGeneral.attendanceButton:getStatus() > modeOff end,
	function () sysGeneral.attendanceButton:repeatOn() end))
prelPreflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 0 or
		sysElectric.gpuOnBus:getStatus() == 1
	end,
	function 
		() sysGeneral.attendanceButton:repeatOff() 
	end))
prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST 1","PERFORM",FlowItem.actorCPT,0,"mach_ovspd_test1",
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 end,
	function () 
		kc_procvar_set("mach1test",true) -- background test
	end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST 2","PERFORM",FlowItem.actorCPT,0,"mach_ovspd_test2",
	function () return get("laminar/B738/push_button/mach_warn2_pos") == 1 end,
	function () 
		kc_procvar_set("mach2test",true) -- background test
	end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
prelPreflightProc:addItem(ProcedureItem:new("FLIGHT DATA RECORDER SWITCH","GUARD CLOSED",FlowItem.actorCPT,0,
	function () return  sysGeneral.fdrSwitch:getStatus() == modeOff and sysGeneral.fdrCover:getStatus() == modeOff end,
	function () 
		sysGeneral.fdrSwitch:actuate(modeOn) 
		sysGeneral.fdrCover:actuate(modeOff) 
	end))

prelPreflightProc:addItem(SimpleProcedureItem:new("==== IRS Alignment"))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","OFF",FlowItem.actorCPT,0,"irs_mode_initial_off",
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitOFF) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","ALIGN",FlowItem.actorCPT,0,"irs_mode_align",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitALIGN*2 end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitALIGN) end))
prelPreflightProc:addItem(SimpleProcedureItem:new("  Verify ON DC lights illuminate then extinguish"))
prelPreflightProc:addItem(IndirectProcedureItem:new("  IRS LEFT ALIGN LIGHT","ILLUMINATES",FlowItem.actorCPT,0,"irs_left_align",
	function () return sysGeneral.irs1Align:getStatus() > 0 end))
prelPreflightProc:addItem(IndirectProcedureItem:new("  IRS RIGHT ALIGN LIGHT","ILLUMINATES",FlowItem.actorCPT,0,"irs_right_align",
	function () return sysGeneral.irs2Align:getStatus() > 0 end))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",FlowItem.actorCPT,0,"irs_mode_nav_again",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitNAV*2 end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitNAV) end))
	

-- ==================== CDU Preflight ====================
-- ==== INITIAL DATA (CPT)                              
--   IDENT page:................................OPEN (CPT)
--     Verify Model and ENG RATING                 
--     Verify navigation database ACTIVE date      
--   POS INIT page:.............................OPEN (CPT)
--     Verify time                                 
--     REF AIRPORT...............................SET (CPT)
-- ==== NAVIGATION DATA (CPT)                           
--   RTE page:..................................OPEN (CPT)
--     ORIGIN....................................SET (CPT)
--     DEST......................................SET (CPT)
--     FLT NO....................................SET (CPT)
--     ROUTE...................................ENTER (CPT)
--     ROUTE................................ACTIVATE (CPT)
--     ROUTE.................................EXECUTE (CPT)
--   DEPARTURES page:...........................OPEN (CPT)
--     Select runway and departure routing         
--     ROUTE:................................EXECUTE (CPT)
--   LEGS page:.................................OPEN (CPT)
--     Verify or enter correct RNP for departure   
-- ==== PERFORMANCE DATA (CPT)                          
--   PERF INIT page:............................OPEN (CPT)
--     ZFW.....................................ENTER (CPT)
--     GW...............................ENTER/VERIFY (CPT)
--     RESERVES.........................ENTER/VERIFY (CPT)
--     COST INDEX..............................ENTER (CPT)
--     CRZ ALT.................................ENTER (CPT)
--   N1 LIMIT page:.............................OPEN (CPT)
--     Select assumed temp and/or fixed t/o rating 
--     Select full or derated climb thrust         
--   TAKEOFF REF page:..........................OPEN (CPT)
--     FLAPS...................................ENTER (CPT)
--     CG......................................ENTER (CPT)
--     V SPEEDS................................ENTER (CPT)
-- PREFLIGHT COMPLETE?........................VERIFY (CPT)
-- PREPARE KPCREW DEPARTURE BRIEFING
-- =======================================================


local cduPreflightProc = Procedure:new("CDU PREFLIGHT BY CAPTAIN")
cduPreflightProc:setFlightPhase(2)
cduPreflightProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
cduPreflightProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEFING","FILLED OUT",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("CDU PREFLIGHT","FINISHED",FlowItem.actorCPT))

-- ================ Preflight Procedure ==================
-- ==== Flight control panel                            
-- FLIGHT CONTROL SWITCHES.............GUARDS CLOSED (F/O)
-- FLIGHT SPOILER SWITCHES.............GUARDS CLOSED (F/O)
-- ALTERNATE FLAPS MASTER SWITCH........GUARD CLOSED (F/O)
-- ALTERNATE FLAPS CONTROL SWITCH................OFF (F/O)
-- FLAPS PANEL ANNUNCIATORS.............EXTINGUISHED (F/O)
-- YAW DAMPER SWITCH..............................ON (F/O)

-- ==== NAVIGATION panel                     
-- VHF NAV TRANSFER SWITCH....................NORMAL (F/O)
-- IRS TRANSFER SWITCH........................NORMAL (F/O)
-- FMC TRANSFER SWITCH........................NORMAL (F/O)
-- ==== DISPLAYS panel                     
-- SOURCE SELECTOR..............................AUTO (F/O)
-- CONTROL PANEL SELECT SWITCH................NORMAL (F/O)

-- ==== FUEL panel                                      
-- FUEL PUMP SWITCHES........................ALL OFF (F/O)
--   If APU running turn one of the left fuel pumps on
-- FUEL VALVE ANNUNCIATORS.................CHECK DIM (F/O)
-- FUEL CROSS FEED.......................ON FOR TEST (F/O)
-- CROSS FEED VALVE LIGHT..................CHECK DIM (F/O)
-- FUEL CROSS FEED...............................OFF (F/O)
-- CROSS FEED VALVE LIGHT...............EXTINGUISHED (F/O)

-- ==== ELECTRICAL panel                                
-- BATTERY SWITCH.......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH..........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH.....................ON (F/O)
-- STANDBY POWER SWITCH.................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES.......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH..................GUARD CLOSED (F/O)

-- ==== APU start if required
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH..................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT.......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH............TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 2 TO RIGHT (F/O)
-- APU PANEL
-- APU SWITCH..................................START (F/O)
--   Hold APU switch in START position for 3-4 seconds.
-- APU GEN OFF BUS LIGHT.................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES.....................ON (F/O)

-- ==== Overhead items
-- EQUIPMENT COOLING SWITCHES...................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH.........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH..............................ON (F/O)
-- FASTEN BELTS SWITCH............................ON (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)

-- ==== ANTI-ICE
-- WINDOW HEAT SWITCHES...........................ON (F/O)
-- PROBE HEAT SWITCHES...........................OFF (F/O)
-- WING ANTI-ICE SWITCH..........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES......................OFF (F/O)

-- ==== HYDRAULIC panel                                 
-- ENGINE HYDRAULIC PUMPS SWITCHES................ON (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES.............OFF (F/O)

-- ==== AIR CONDITIONING panel                          
-- AIR TEMPERATURE SOURCE SELECTOR...........FWD CAB (F/O)
-- CABIN TEMPERATURE SELECTORS.....AUTO OR AS NEEDED (F/O)
-- TRIM AIR SWITCH................................ON (F/O)
-- RECIRCULATION FAN SWITCHES...................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES.......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH...............AUTO OR OPEN (F/O)
-- ENGINE BLEED AIR SWITCHES......................ON (F/O)
-- APU BLEED AIR SWITCH..................AS REQUIRED (F/O)
--  If APU running turn it ON

-- ==== CABIN PRESSURIZATION panel                      
-- FLIGHT ALTITUDE INDICATOR.........CRUISE ALTITUDE (F/O)
-- LANDING ALTITUDE INDICATOR........FIELD ELEVATION (F/O)
-- PRESSURIZATION MODE SELECTOR.................AUTO (F/O)

-- ==== LIGHTING panel                                  
-- LANDING LIGHT SWITCHES............RETRACT AND OFF (F/O)
-- RUNWAY TURNOFF LIGHT SWITCHES.................OFF (F/O)
-- TAXI LIGHT SWITCH.............................OFF (F/O)
-- LOGO LIGHT SWITCH.......................AS NEEDED (F/O)
-- POSITION LIGHT SWITCH...................AS NEEDED (F/O)
-- ANTI-COLLISION LIGHT SWITCH...................OFF (F/O)
-- WING ILLUMINATION SWITCH................AS NEEDED (F/O)
-- WHEEL WELL LIGHT SWITCH.................AS NEEDED (F/O)

-- ==== ENGINE STARTERS
-- IGNITION SELECT SWITCH.................IGN L OR R (F/O)
-- ENGINE START SWITCHES.........................OFF (F/O)

-- ==== MODE CONTROL panels
-- COURSE NAV2...................................SET (F/O)
-- FLIGHT DIRECTOR SWITCHES..........ON, LEFT MASTER (F/O)
-- COURSE NAV1...................................SET (CPT)
-- FLIGHT DIRECTOR SWITCHES..........ON, LEFT MASTER (CPT)
-- Set BANK ANGLE SELECTOR AS NEEDED
-- AUTOPILOT DISENGAGE BAR........................UP (CPT)

-- ==== EFIS CONTROL panels
-- MINIMUMS REFERENCE SELECTOR.........RADIO OR BARO (BOTH)
-- MINIMUMS SELECTOR..........SET DH OR DA REFERENCE (BOTH)
-- DECISION HEIGHT OR ALTITUDE REFERENCE.........SET (BOTH)
-- FLIGHT PATH VECTOR SWITCH.....................OFF (BOTH)
-- METERS SWITCH...........................MTRS/FEET (BOTH)
-- BAROMETRIC REFERENCE SELECTOR...........IN OR HPA (BOTH)
-- BAROMETRIC SELECTOR...SET LOCAL ALTIMETER SETTING (BOTH)
-- VOR/ADF SWITCHES..............................VOR (BOTH)
-- MODE SELECTOR.................................MAP (BOTH)
-- CENTER SWITCH.................................OFF (BOTH)
-- RANGE SELECTOR..............................10 NM (BOTH)
-- TRAFFIC SWITCH.................................ON (BOTH)
-- WEATHER RADAR.................................OFF (BOTH)
-- MAP SWITCHES............................AS NEEDED (BOTH)

-- ==== FORWARD PANEL
-- CLOCK..............................SET LOCAL TIME (F/O)
-- MAIN PANEL DISPLAY UNITS SELECTOR............NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR..................NORM (F/O)
-- OXYGEN...............................TEST AND SET (F/O)
-- NOSE WHEEL STEERING SWITCH...........GUARD CLOSED (CPT)
--   Set INTEGRATED STANDBY FLIGHT DISPLAY
-- LIGHTS TEST...............................PERFORM (CPT)

-- ==== GROUND PROXIMITY panel
-- FLAP INHIBIT SWITCH..................GUARD CLOSED (F/O)
-- GEAR INHIBIT SWITCH..................GUARD CLOSED (F/O)
-- TERRAIN INHIBIT SWITCH...............GUARD CLOSED (F/O)
-- GPWS SYSTEM TEST..........................PERFORM (F/O)

-- ==== LANDING GEAR panel                              
-- LANDING GEAR LEVER.............................DN (F/O)
-- AUTO BRAKE SELECT SWITCH......................RTO (F/O)
-- ANTISKID INOP LIGHT...........VERIFY EXTINGUISHED (F/O)
-- FUEL FLOW...................................RESET (F/O)
-- LOWER EICAS DISPLAY...........................SYS (F/O)

-- ==== PEDESTAL
-- SPEED BRAKE LEVER.....................DOWN DETENT (CPT)
-- REVERSE THRUST LEVERS........................DOWN (CPT)
-- FORWARD THRUST LEVERS......................CLOSED (CPT)
-- FLAP LEVER....................................SET (CPT)
--   Set the flap lever to agree with the flap position.
-- PARKING BRAKE.................................SET (CPT)
-- ENGINE START LEVERS........................CUTOFF (CPT)
-- STABILIZER TRIM CUTOUT SWITCHES............NORMAL (CPT)
-- CARGO FIRE TEST...........................PERFORM (F/O)
-- TCAS TEST (with aligend IRS)..............PERFORM (F/O)
-- WEATHER RADAR PANEL...........................SET (F/O)
-- TRANSPONDER PANEL.............................SET (F/O)

-- ==== Set MCP
--   AUTOTHROTTLE ARM SWITCH....................ARM  (CPT)
--   IAS/MACH SELECTOR.......................SET V2  (CPT)
--   LNAV.............................ARM AS NEEDED  (CPT)
--   VNAV.............................ARM AS NEEDED  (CPT)
--   INITIAL HEADING............................SET  (CPT)
--   INITIAL ALTITUDE...........................SET  (CPT)

-- ==== RADIO TUNING panel                              
-- VHF COMMUNICATIONS RADIOS.....................SET (F/O)
-- VHF NAVIGATION RADIOS...........SET FOR DEPARTURE (F/O)
-- AUDIO CONTROL PANEL...........................SET (F/O)
-- ADF RADIOS....................................SET (F/O)

-- ==== OTHER
-- STALL WARNING TEST........................PERFORM (F/O)
--   Wait for 4 minutes AC power if not functioning

-- XPDR.....................................SET 2000 (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS..........SET AS REQUIRED (F/O)
-- FUEL PUMPS................................ALL OFF (F/O)
-- FUEL CROSS FEED...............................OFF (F/O)
-- POSITION LIGHTS................................ON (F/O)
-- MCP....................................INITIALIZE (F/O)


-- =======================================================

local preflightFOProc = Procedure:new("PREFLIGHT PROCEDURE","I have returned from the walk around, starting preflight setup","preflight setup finished")
preflightFOProc:setResize(false)
preflightFOProc:setFlightPhase(3)

preflightFOProc:addItem(SimpleProcedureItem:new("==== FLT CONTROL panel"))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysControls.fltCtrlCovers:getStatus() == 0 end,
	function () sysControls.fltCtrlCovers:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysControls.spoilerCovers:getStatus() == 0  end,
	function () sysControls.spoilerCovers:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS CONTROL SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCtrl:getStatus() == 0 end,
	function () sysControls.altFlapsCtrl:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("FLAPS PANEL ANNUNCIATORS","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysControls.flapsPanelStatus:getStatus() == 0 end))
preflightFOProc:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysControls.yawDamper:getStatus() == modeOn end,
	function () sysControls.yawDamper:actuate(modeOn) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== NAVIGATION panel"))
preflightFOProc:addItem(ProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.vhfNavSwitch:getStatus() == 0 end,
	function () sysMCP.vhfNavSwitch:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.irsNavSwitch:getStatus() == 0 end,
	function () sysMCP.irsNavSwitch:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.fmcNavSwitch:getStatus() == 0 end,
	function () sysMCP.fmcNavSwitch:setValue(0) end))
preflightFOProc:addItem(SimpleProcedureItem:new("==== DISPLAYS panel"))
preflightFOProc:addItem(ProcedureItem:new("SOURCE SELECTOR","AUTO",FlowItem.actorFO,0,
	function() return sysMCP.displaySourceSwitch:getStatus() == 0 end,
	function () sysMCP.displaySourceSwitch:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.displayControlSwitch:getStatus() == 0 end,
	function () sysMCP.displayControlSwitch:setValue(0) end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== FUEL panel"))
preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(ProcedureItem:new("FUEL VALVE ANNUNCIATORS","DIM",FlowItem.actorFO,0,
	function () return sysFuel.valveAnns:getStatus() == 1 end))
preflightFOProc:addItem(IndirectProcedureItem:new("FUEL CROSS FEED","ON FOR TEST",FlowItem.actorFO,0,"xfeedtest",
	function () return sysFuel.crossFeed:getStatus() == 1 end,
	function () sysFuel.crossFeed:actuate(1) end))
preflightFOProc:addItem(IndirectProcedureItem:new("CROSS FEED VALVE","CHECK DIM",FlowItem.actorFO,0,"xfeeddim",
	function () return sysFuel.xfeedVlvAnn:getStatus() > 0 end))
preflightFOProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function () sysFuel.crossFeed:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("CROSS FEED VALVE","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysFuel.xfeedVlvAnn:getStatus() == 0 end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== ELECTRICAL panel"))
preflightFOProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.batteryCover:getStatus() == 0 end,
	function () sysElectric.batteryCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.cabUtilPwr:getStatus() == 1 end,
	function () sysElectric.cabUtilPwr:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("#spell|IFE# POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.ifePwr:getStatus() == 1 end,
	function () sysElectric.ifePwr:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end,
	function () sysElectric.stbyPowerCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.genDriveCovers:getStatus() == 0 end))
preflightFOProc:addItem(ProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.busTransCover:getStatus() == 0 end,
	function () sysElectric.busTransCover:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== APU start if required",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("OVHT DET SWITCH","NORMAL",FlowItem.actorFO,0,true,nil,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == true or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,0,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () 
		kc_procvar_set("ovhttest",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == true or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(ProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,0,true,nil,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == true or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",FlowItem.actorFO,0,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,
	function () 
		kc_procvar_set("ext1test",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == true or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",FlowItem.actorFO,0,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,
	function () 
		kc_procvar_set("ext2test",true) -- background test 
	end,
	function () 
		return activePrefSet:get("aircraft:powerup_apu") == true or 
		activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(ProcedureItem:new("#spell|APU# SWITCH","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_procvar_set("apustart",true) -- background start
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(SimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(IndirectProcedureItem:new("#spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("#spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Overhead items"))
preflightFOProc:addItem(ProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",FlowItem.actorFO,0,
	function () return sysGeneral.equipCoolExhaust:getStatus() == modeOff and sysGeneral.equipCoolSupply:getStatus() == 0 end,
	function () sysGeneral.equipCoolExhaust:actuate(modeOff) sysGeneral.equipCoolSupply:actuate(modeOff) end))
preflightFOProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0 end,
	function () sysGeneral.emerExitLightsCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("NO SMOKING SWITCH","ON OR AUTO",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:setValue(1) end))
preflightFOProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON OR AUTO",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
	end))
preflightFOProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== ANTI-ICE"))
preflightFOProc:addItem(ProcedureItem:new("WINDOW HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== HYDRAULIC panel"))
preflightFOProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () kc_macro_hydraulic_initial() end))
preflightFOProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () kc_macro_hydraulic_initial() end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== AIR CONDITIONING panel"))
preflightFOProc:addItem(ProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","FWD CAB",FlowItem.actorFO,0,
	function () return get("laminar/B738/toggle_switch/air_temp_source") == 3 end,
	function () set("laminar/B738/toggle_switch/air_temp_source",3) end))
preflightFOProc:addItem(ProcedureItem:new("CABIN TEMPERATURE SELECTORS","AUTO OR AS NEEDED",FlowItem.actorFO,0,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end,
	function () sysAir.contCabTemp:setValue(0.5) sysAir.fwdCabTemp:setValue(0.5) sysAir.aftCabTemp:setValue(0.5) end))
preflightFOProc:addItem(ProcedureItem:new("TRIM AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() > 0 end,
	function () 
		kc_macro_packs_on() 
	end))
preflightFOProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() > sysAir.isoVlvClosed end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () 
		kc_macro_bleeds_on()
	end))
preflightFOProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end, 
	function () sysAir.apuBleedSwitch:actuate(1) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== CABIN PRESSURIZATION panel"))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT ALTITUDE INDICATOR","%i FT|activeBriefings:get(\"flight:cruiseLevel\")*100",FlowItem.actorFO,0,
	function () return sysAir.maxCruiseAltitude:getStatus() == activeBriefings:get("flight:cruiseLevel")*100 end,
	function () sysAir.maxCruiseAltitude:setValue(activeBriefings:get("flight:cruiseLevel")*100) end))
preflightFOProc:addItem(ProcedureItem:new("LANDING ALTITUDE INDICATOR","%i FT|kc_round_step(get(\"sim/cockpit2/autopilot/altitude_readout_preselector\"),50)",FlowItem.actorFO,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50)) end))
preflightFOProc:addItem(ProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== LIGHTING panel"))
preflightFOProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () kc_macro_lights_preflight() end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== ENGINE STARTERS"))
preflightFOProc:addItem(ProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",FlowItem.actorFO,0,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end)) 

preflightFOProc:addItem(SimpleProcedureItem:new("==== MODE CONTROL panel"))
preflightFOProc:addItem(ProcedureItem:new("COURSE NAV 2","SET %s|activeBriefings:get(\"departure:crs2\")",FlowItem.actorFO,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("departure:crs2") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("departure:crs2")) end))
preflightFOProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"departure:crs1\")",FlowItem.actorCPT,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("departure:crs1") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("departure:crs1")) end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON, LEFT MASTER",FlowItem.actorCPT,0,
	function () return sysMCP.fdirGroup:getStatus() == 2 and get("laminar/B738/autopilot/master_capt_status") == 1 end,
	function () sysMCP.fdirGroup:actuate(1) end))
preflightFOProc:addItem(SimpleProcedureItem:new("Set BANK ANGLE SELECTOR as needed"))
preflightFOProc:addItem(ProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",FlowItem.actorCPT,0,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end,
	function () sysMCP.discAPSwitch:actuate(0) end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== EFIS CONTROL panels"))
preflightFOProc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",FlowItem.actorBOTH,0,
	function () 
		return ((sysEFIS.minsTypeCopilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) and 
		((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
		sysEFIS.minsTypeCopilot:actuate(flag) 
		sysEFIS.minsTypePilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"departure:decision\")",FlowItem.actorFO,0,
	function () 
		return sysEFIS.minsResetCopilot:getStatus() == 1 and 
		math.floor(sysEFIS.minsCopilot:getStatus()) == activeBriefings:get("departure:decision") 
	end,
	function () 
		sysEFIS.minsCopilot:setValue(activeBriefings:get("departure:decision")) 
		sysEFIS.minsResetCopilot:actuate(1) 
	end))
preflightFOProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"departure:decision\")",FlowItem.actorCPT,0,
	function () 
		return sysEFIS.minsResetPilot:getStatus() == 1 and 
		math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("departure:decision")
	end,
	function () 
		sysEFIS.minsPilot:setValue(activeBriefings:get("departure:decision")) 
		sysEFIS.minsResetPilot:actuate(1)
	end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR SWITCH","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",FlowItem.actorFO,0,
	function () 
		return 
			(sysEFIS.fpvCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
			or (sysEFIS.fpvCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true)
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvCopilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR SWITCH","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",FlowItem.actorCPT,0,
	function () 
		return 
			(sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
			or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true)
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvPilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",FlowItem.actorFO,0,
	function () 
		return 
			(sysEFIS.mtrsCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
			or (sysEFIS.mtrsCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true)
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsCopilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",FlowItem.actorCPT,0,
	function () 
		return 
			(sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
			or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true)
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsPilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",FlowItem.actorFO,0,
	function () 
		return 
			sysGeneral.baroModeGroup:getStatus() == (activePrefSet:get("general:baro_mode_hpa") == true and 3 or 0)
	end,
	function () 
		kc_macro_set_pref_baro_mode()
	end))
preflightFOProc:addItem(ProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString(kc_metar_local)",FlowItem.actorFO,0,
	function () 
		return kc_macro_test_local_baro()
	end,
	function () 
		kc_macro_set_local_baro()
	end))
preflightFOProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",FlowItem.actorFO,0,
	function () return 
		sysEFIS.voradf1Copilot:getStatus() == 1 and sysEFIS.voradf2Copilot:getStatus() == 1 
	end,
	function () 
		sysEFIS.voradf1Copilot:actuate(1) sysEFIS.voradf2Copilot:actuate(1) 
	end))
preflightFOProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.voradf1Pilot:getStatus() == 1 and sysEFIS.voradf2Pilot:getStatus() == 1
	end,
	function () 
		sysEFIS.voradf1Pilot:actuate(1) sysEFIS.voradf2Pilot:actuate(1)
	end))
preflightFOProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorFO,0,
	function () return 
		sysEFIS.mapModeCopilot:getStatus() == sysEFIS.mapModeMAP
	end,
	function () 
		sysEFIS.mapModeCopilot:actuate(sysEFIS.mapModeMAP) 
	end))
preflightFOProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP
	end,
	function () 
		sysEFIS.mapModePilot:actuate(sysEFIS.mapModeMAP)
	end))
preflightFOProc:addItem(ProcedureItem:new("CENTER SWITCH","OFF",FlowItem.actorFO,0,
	function () return 
		sysEFIS.ctrCopilot:getStatus() == 1
	end))
preflightFOProc:addItem(ProcedureItem:new("CENTER SWITCH","OFF",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.ctrPilot:getStatus() == 1
	end))
preflightFOProc:addItem(ProcedureItem:new("RANGE SELECTOR","10 NM",FlowItem.actorFO,0,
	function () return 
		sysEFIS.mapZoomCopilot:getStatus() == sysEFIS.mapRange10 and
		sysEFIS.mapZoomPilot:getStatus() == sysEFIS.mapRange10
	end,
	function () 
		sysEFIS.mapZoomCopilot:setValue(sysEFIS.mapRange10) 
		sysEFIS.mapZoomPilot:setValue(sysEFIS.mapRange10)
	end))
preflightFOProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","ON",FlowItem.actorFO,0,
	function () return 
		sysEFIS.tfcCopilot:getStatus() == 1 
	end,
	function () 
		sysEFIS.tfcCopilot:actuate(1) 
	end))
preflightFOProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","ON",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.tfcPilot:getStatus() == 1
	end,
	function () 
		sysEFIS.tfcPilot:actuate(1)
	end))
preflightFOProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,0,
	function () return 
		sysEFIS.wxrCopilot:getStatus() == 0 
	end,
	function () 
		sysEFIS.wxrCopilot:actuate(0) 
	end))
preflightFOProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.wxrPilot:getStatus() == 0
	end,
	function () 
		sysEFIS.wxrPilot:actuate(0)
	end))
preflightFOProc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",FlowItem.actorBOTH,1))

preflightFOProc:addItem(SimpleProcedureItem:new("==== FORWARD panel"))
preflightFOProc:addItem(IndirectProcedureItem:new("LIGHTS TEST","ON",FlowItem.actorCPT,0,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end,
	function () command_once("laminar/B738/toggle_switch/bright_test_up") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
preflightFOProc:addItem(ProcedureItem:new("LIGHTS TEST","OFF",FlowItem.actorCPT,0,
	function () return sysGeneral.lightTest:getStatus() == 0 end,
	function () kc_speakNoText(0,"test all lights then turn test off") end,
	function () return activeBriefings:get("flight:firstFlightDay") == false end))
preflightFOProc:addItem(ProcedureItem:new("CLOCK","SET LOCAL TIME",FlowItem.actorFO,0,
	function() return sysGeneral.clockDispModeFO:getStatus() == 3 end,
	function () sysGeneral.clockDispModeFO:actuate(3) end))
preflightFOProc:addItem(ProcedureItem:new("CLOCK","SET UTC",FlowItem.actorCPT,0,
	function() return sysGeneral.clockDispModeGrp:getStatus() == 4 end,
	function () sysGeneral.clockDispModeCPT:actuate(1) sysGeneral.clockDispModeFO:actuate(3) end))
preflightFOProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorFO,0,
	function () return 
		sysGeneral.displayUnitsFO:getStatus() == 0 
	end,
	function () 
		sysGeneral.displayUnitsFO:setValue(0) 
	end))
preflightFOProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorCPT,0,
	function () return 
		sysGeneral.displayUnitsCPT:getStatus() == 0
	end,
	function () 
		sysGeneral.displayUnitsCPT:setValue(0)
	end))
preflightFOProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorFO,0,
	function () return 
		sysGeneral.lowerDuFO:getStatus() == 0 
	end,
	function () 
		sysGeneral.lowerDuFO:setValue(0) 
	end))
preflightFOProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorCPT,0,
	function () return 
		sysGeneral.lowerDuCPT:getStatus() == 0
	end,
	function () 
		sysGeneral.lowerDuCPT:setValue(0) 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("OXYGEN","TEST AND SET",FlowItem.actorFO,0,"oxygentestedfo",
	function () return 
		get("laminar/B738/push_button/oxy_test_fo_pos") == 1  
	end,
	function () 
		kc_procvar_set("oxyfotest",true) -- background test
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("OXYGEN","TEST AND SET",FlowItem.actorCPT,0,"oxygentestedcpt",
	function () return 
		get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 
	end,
	function () 
		kc_procvar_set("oxycpttest",true)
	end))
preflightFOProc:addItem(ProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",FlowItem.actorCPT,0,
	function () return get("laminar/B738/switches/nose_steer_pos") == 1 end,
	function () command_once("laminar/B738/switch/nose_steer_norm")  end))
preflightFOProc:addItem(SimpleProcedureItem:new("Set INTEGRATED STANDBY FLIGHT DISPLAY"))

preflightFOProc:addItem(SimpleProcedureItem:new("==== GROUND PROXIMITY panel"))
preflightFOProc:addItem(ProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	function () sysGeneral.flapInhibitCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	function () sysGeneral.gearInhibitCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	function () sysGeneral.terrainInhibitCover:actuate(0) end))
preflightFOProc:addItem(IndirectProcedureItem:new("GPWS SYSTEM TEST","PERFORM",FlowItem.actorFO,0,"gpws_test",
	function () return get("laminar/B738/push_button/gpws_test_pos") > 0 end,
	function () 
		kc_procvar_set("gpwstest",true) -- background test
	end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== LANDING GEAR panel"))
preflightFOProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == 0 end,
	function () sysGeneral.autobrake:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",FlowItem.actorFO,0,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))
preflightFOProc:addItem(IndirectProcedureItem:new("FUEL FLOW","RESET",FlowItem.actorFO,0,"fuelflowreset",
	function () return get("laminar/B738/toggle_switch/fuel_flow_pos") ~= 0 end,
	function () command_begin("laminar/B738/toggle_switch/fuel_flow_up") end))
preflightFOProc:addItem(ProcedureItem:new("LOWER DU","SYS",FlowItem.actorFO,0,
	function () return 
		get("laminar/B738/systems/lowerDU_page2") == 1 and
		get("laminar/B738/systems/lowerDU_page") == 0
	end,
	function ()
		command_end("laminar/B738/toggle_switch/fuel_flow_up")
		kc_macro_b738_lowerdu_sys()
	end))


preflightFOProc:addItem(SimpleProcedureItem:new("==== PEDESTAL"))
preflightFOProc:addItem(ProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",FlowItem.actorCPT,0,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) end))
preflightFOProc:addItem(ProcedureItem:new("REVERSE THRUST LEVERS","DOWN",FlowItem.actorCPT,0,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/reverse_lever1",0) set("laminar/B738/flt_ctrls/reverse_lever2",0) end))
preflightFOProc:addItem(ProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",FlowItem.actorCPT,0,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end,
	function () set("laminar/B738/engine/thrust1_leveler",0) set("laminar/B738/engine/thrust2_leveler",0) end))
preflightFOProc:addItem(ProcedureItem:new("FLAP LEVER","SET",FlowItem.actorCPT,1))
preflightFOProc:addItem(SimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightFOProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () sysEngines.startLever1:actuate(0) sysEngines.startLever2:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",FlowItem.actorCPT,0,
	function () return get("laminar/B738/toggle_switch/ap_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/ap_trim_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_pos") == 0 
	end,
	function () set("laminar/B738/toggle_switch/ap_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/el_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/ap_trim_pos",0)
		set("laminar/B738/toggle_switch/el_trim_pos",0) 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("CARGO FIRE TEST","PERFORM",FlowItem.actorFO,3,"cargo_fire_test",
	function () return get("laminar/B738/push_botton/cargo_fire_test") == 1 end,
	function () 
		kc_procvar_set("cargofiretest",true) -- background test
	end,
	function () 
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("TCAS TEST (with aligend IRS)","PERFORM",FlowItem.actorFO,1,"tcas_fire_test",
	function () return get("laminar/B738/knob/transponder_pos") == 0 end,
	function () 
		kc_procvar_set("tcastest",true) -- background test
	end,
	function () 
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(ProcedureItem:new("WEATHER RADAR PANEL","SET",FlowItem.actorCPT,0,true,nil))
preflightFOProc:addItem(ProcedureItem:new("TRANSPONDER PANEL","SET",FlowItem.actorCPT,0,true,
	function ()
		sysRadios.xpdrCode:actuate(2000)
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby)
	end))


preflightFOProc:addItem(SimpleProcedureItem:new("==== Set MCP"))
preflightFOProc:addItem(ProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.athrSwitch:getStatus() == 1 end))
preflightFOProc:addItem(ProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorCPT,0,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end))
preflightFOProc:addItem(ProcedureItem:new("  LNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.lnavSwitch:getStatus() == 1 end,nil,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 or
		activeBriefings:get("departure:type") > 1 end))
preflightFOProc:addItem(ProcedureItem:new("  VNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vnavSwitch:getStatus() == 1 end,nil,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
preflightFOProc:addItem(ProcedureItem:new("  INITIAL HEADING","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end))
preflightFOProc:addItem(ProcedureItem:new("  INITIAL ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end))
preflightFOProc:addItem(ProcedureItem:new("AUTOTHROTTLE","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))

preflightFOProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== RADIO TUNING panel"))
preflightFOProc:addItem(HoldProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",FlowItem.actorCPT,1))
preflightFOProc:addItem(HoldProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",FlowItem.actorCPT,1))
preflightFOProc:addItem(HoldProcedureItem:new("AUDIO CONTROL PANEL","SET",FlowItem.actorCPT,1))
preflightFOProc:addItem(HoldProcedureItem:new("ADF RADIOS","SET",FlowItem.actorCPT,1))
preflightFOProc:addItem(SimpleProcedureItem:new("==== Briefing"))
preflightFOProc:addItem(HoldProcedureItem:new("FLIGHT PLAN","VERIFIED",FlowItem.actorCPT,1))
preflightFOProc:addItem(HoldProcedureItem:new("DEPARTURE BRIEFING","PERFORM",FlowItem.actorCPT,1))

preflightFOProc:addItem(SimpleProcedureItem:new("==== OTHER"))
preflightFOProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",FlowItem.actorFO,0,"stall_warning_test1",
	function () return get("laminar/B738/push_button/stall_test1") == 1 end,
	function () 
		kc_procvar_set("stall1test",true) -- background test
	end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 2","PERFORM",FlowItem.actorFO,0,"stall_warning_test",
	function () return get("laminar/B738/push_button/stall_test2") == 1 end,
	function () 
		kc_procvar_set("stall2test",true) -- background test
	end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == false 
	end))
preflightFOProc:addItem(SimpleProcedureItem:new("  Wait for 4 minutes AC power if stall warning not functioning"))



-- prelPreflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	-- function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	-- function () sysRadios.xpdrCode:actuate(2000) end))
-- prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	-- function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or -1) end))
-- prelPreflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,0,
	-- function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	-- function () 
		-- kc_macro_glareshield_initial()
		-- sysEFIS.mtrsPilot:actuate(modeOff)
		-- sysEFIS.fpvPilot:actuate(modeOff)
	-- end))

-- ================= PREFLIGHT CHECKLIST ================= 
-- OXYGEN..............................TESTED, 100% (BOTH)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO  (F/O)
-- WINDOW HEAT...................................ON  (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO  (F/O)
-- FLIGHT INSTRUMENTS.........HEADING__ ALTIMETER__ (BOTH)
-- PARKING BRAKE................................SET  (CPT)
-- ENGINE START LEVERS.......................CUTOFF  (CPT)
-- =======================================================

local preflightChkl = Checklist:new("PREFLIGHT CHECKLIST","","preflight checklist completed")
preflightChkl:setFlightPhase(3)
preflightChkl:addItem(IndirectChecklistItem:new("#exchange|OXYGEN|pre flight checklist. oxygen","TESTED 100 #exchange|PERC|percent",FlowItem.actorBOTH,0,"oxygentestedcpt",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(ChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",FlowItem.actorFO,0,
	function () 
		return sysMCP.vhfNavSwitch:getStatus() == 0 and 
			sysMCP.irsNavSwitch:getStatus() == 0 and 
			sysMCP.fmcNavSwitch:getStatus() == 0 and 
			sysMCP.displaySourceSwitch:getStatus() == 0 and 
			sysMCP.displayControlSwitch:getStatus() == 0 
	end,
	function () 
		kc_macro_b738_navswitches_init()
	end))
preflightChkl:addItem(ChecklistItem:new("WINDOW HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))
preflightChkl:addItem(ChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",FlowItem.actorBOTH,0,true,nil,nil))
preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(0) end))

-- === end of preflight phase

-- =============== BEFORE START PROCEDURE ================
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED  (F/O)
-- CDU DISPLAY..................................SET (BOTH)
-- N1 BUGS....................................CHECK (BOTH)
-- IAS BUGS.....................................SET (BOTH)
-- TAXI AND TAKEOFF BRIEFINGS..............COMPLETE (BOTH)
-- EXTERIOR DOORS.....................VERIFY CLOSED  (F/O)
-- ==== START CLEARANCE
--   Obtain a clearance to pressurize hydraulic systems.
--   Obtain a clearance to start engines.
-- ==== Set Fuel panel
--   CENTER FUEL PUMPS SWITCHES..................ON  (F/O)
--     If center tank quantity exceeds 1,000 lbs/460 kgs
--   AFT AND FORWARD FUEL PUMPS SWITCHES.........ON  (F/O)
-- ==== Set Hydraulic panel
--   ENGINE HYDRAULIC PUMP SWITCHES.............OFF  (F/O)
--   ELECTRIC HYDRAULIC PUMP SWITCHES............ON  (F/O)
-- ==== Set Trim
--   STABILIZER TRIM......................___ UNITS  (CPT)
--   AILERON TRIM...........................0 UNITS  (CPT)
--   RUDDER TRIM............................0 UNITS  (CPT)
-- ANTI COLLISION LIGHT SWITCH...................ON  (F/O)
-- WING & WHEEL WELL LIGHTS.....................OFF  (F/O)
-- =======================================================

local beforeStartProc = Procedure:new("BEFORE START PROCEDURE","Before start items","ready for before start checklist")
beforeStartProc:setFlightPhase(4)
beforeStartProc:addItem(ProcedureItem:new("ALL DOORS","VERIFY CLOSED",FlowItem.actorFO,0,true,
	function () 
		if get("laminar/B738/airstairs_hide") == 0  then
			command_once("laminar/B738/airstairs_toggle")
		end
		kc_macro_doors_all_closed()
	end))
beforeStartProc:addItem(SimpleProcedureItem:new("Set required CDU DISPLAY"))
beforeStartProc:addItem(SimpleProcedureItem:new("Check N1 BUGS"))
beforeStartProc:addItem(ProcedureItem:new("IAS BUGS","SET",FlowItem.actorBOTH,0,
	function () return sysFMC.noVSpeeds:getStatus() == 0 end,
	function () kc_macro_glareshield_takeoff() end))
beforeStartProc:addItem(SimpleProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS - COMPLETE?"))
beforeStartProc:addItem(SimpleProcedureItem:new("==== START CLEARANCE"))
beforeStartProc:addItem(HoldProcedureItem:new("CLEARANCE TO PRESSURIZE HYDRAULIC SYSTEM","OBTAIN",FlowItem.actorCPT,1))
beforeStartProc:addItem(HoldProcedureItem:new("CLEARANCE TO START ENGINES","OBTAIN",FlowItem.actorCPT,1))

beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Fuel panel"))
beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() > 1000 end))
beforeStartProc:addItem(SimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(ProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () kc_macro_fuelpumps_on() end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Hydraulic panel"))
beforeStartProc:addItem(ProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end))
beforeStartProc:addItem(ProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Trim"))
beforeStartProc:addItem(ProcedureItem:new("  STABILIZER TRIM","%4.2f UNITS (%4.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*10000,100)/10000|activeBriefings:get(\"takeoff:elevatorTrim\")",FlowItem.actorCPT,0,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*10000,100)/10000) == activeBriefings:get("takeoff:elevatorTrim") end))
beforeStartProc:addItem(SimpleProcedureItem:new("  Use trim wheel and bring values to match."))
beforeStartProc:addItem(ProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",FlowItem.actorCPT,0,
	function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartProc:addItem(ProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",FlowItem.actorCPT,0,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))
beforeStartProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","OFF",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == 0 and sysLights.wheelSwitch:getStatus() == 0 end,
	function () 
		sysLights.wingSwitch:actuate(0) 
		sysLights.wheelSwitch:actuate(0) 
		-- also turn off DH display in PFDs
		sysEFIS.minsResetPilot:actuate(0)
		sysEFIS.minsResetCopilot:actuate(0)
	end))
beforeStartProc:addItem(ProcedureItem:new("LOWER DU","ENG",FlowItem.actorFO,0,
	function () return 
		get("laminar/B738/systems/lowerDU_page") == 1 and
		get("laminar/B738/systems/lowerDU_page2") == 0
	end,
	function ()
		kc_macro_b738_lowerdu_eng()
	end))

-- ============= BEFORE START CHECKLIST (F/O) ============
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED  (F/O)
-- FUEL..........................9999 KGS, PUMPS ON  (F/O)
-- PASSENGER SIGNS..............................SET  (F/O)
-- WINDOWS...................................LOCKED (BOTH)
-- MCP...................V2 999, HDG 999, ALT 99999  (CPT)
-- TAKEOFF SPEEDS............V1 999, VR 999, V2 999   (PF)
-- CDU PREFLIGHT..........................COMPLETED   (PF)
-- RUDDER & AILERON TRIM.................FREE AND 0  (CPT)
-- TAXI AND TAKEOFF BRIEFING..            COMPLETED   (PF)
-- ANTI COLLISION LIGHT..........................ON  (F/O)
-- =======================================================

local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST","","before start checklist completed")
beforeStartChkl:setFlightPhase(4)
beforeStartChkl:addItem(ChecklistItem:new("#exchange|FLIGHT DECK DOOR|before start checklist. FLIGHT DECK DOOR","CLOSED AND LOCKED",FlowItem.actorFO,0,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s , PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KG\" or \"LB\"",FlowItem.actorFO,3,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s , PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KG\" or \"LB\"",FlowItem.actorFO,3,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartChkl:addItem(ChecklistItem:new("PASSENGER SIGNS","SET",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () 
		sysGeneral.seatBeltSwitch:actuate(1)
		sysGeneral.noSmokingSwitch:actuate(1) 
	end))
beforeStartChkl:addItem(ChecklistItem:new("WINDOWS","LOCKED",FlowItem.actorBOTH,0,true))
beforeStartChkl:addItem(ChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|activeBriefings:get(\"takeoff:v2\")|activeBriefings:get(\"departure:initHeading\")|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () 
		return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") and 
			sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") and 
			sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") 
	end,
	function () 
		kc_macro_mcp_takeoff()
	end))
beforeStartChkl:addItem(ChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|activeBriefings:get(\"takeoff:v1\")|activeBriefings:get(\"takeoff:vr\")|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("CDU PREFLIGHT","COMPLETED",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",FlowItem.actorCPT,0,
	function () 
		return sysControls.rudderTrimSwitch:getStatus() == 0 and 
			sysControls.aileronTrimSwitch:getStatus() == 0 
	end,
	function () 
		sysControls.rudderTrimSwitch:setValue(0) 
		sysControls.aileronTrimSwitch:setValue(0) 
	end))
beforeStartChkl:addItem(ChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("ANTI-COLLISION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))

-- ================== PUSHBACK (BOTH) ===================
-- PARKING BRAKE................................SET  (CPT)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- PACKS................................AUTO OR OFF  (F/O)
-- SYSTEM A HYDRAULIC PUMPS......................ON  (F/O)
-- =======================================================

-- ================= ENGINE START (BOTH) =================
-- START FIRST ENGINE.............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH........START SWITCH _ TO GRD  (CPT)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER................LEVER _ IDLE  (CPT)
--   When starter switch jumps back call STARTER CUTOUT
-- START SECOND ENGINE............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH........START SWITCH _ TO GRD  (CPT)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER................LEVER _ IDLE  (CPT)
--   When starter switch jumps back call STARTER CUTOUT
-- PARKING BRAKE................................SET  (F/O)
--   When instructed by ground crew after pushback/towing
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY  (CPT)
--   LOCKOUT PIN REMOVED.....................VERIFY  (CPT)
-- =======================================================

-- XPDR TO ALT OFF?

local pushProc = Procedure:new("PUSHBACK","")
pushProc:setFlightPhase(4)
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		sysLights.domeLightSwitch:actuate(0)
		kc_macro_b738_lowerdu_eng()
		if activeBriefings:get("taxi:gateStand") <= 2 then
			kc_pushback_plan()
		end
	end))
pushProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () kc_pushback_call() end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))

pushProc:addItem(ProcedureItem:new("PACKS","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == sysAir.packModeOff end,
	function () 
		kc_macro_packs_start()
	end))
pushProc:addItem(ProcedureItem:new("SYSTEM A HYDRAULIC PUMP","ON",FlowItem.actorFO,0,
	function () 
		return sysHydraulic.engHydPump1:getStatus() == 1 and 
			sysHydraulic.elecHydPump1:getStatus() == 1 
	end,
	function () 
		kc_macro_hydraulic_on()
	end))
pushProc:addItem(HoldProcedureItem:new("CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT,nil))

local startProc = Procedure:new("ENGINE START","cleared to start engines")
startProc:setFlightPhase(4)
startProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
startProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT))
startProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() == 0 
		else 
			return sysEngines.engStart1Switch:getStatus() == 0 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart2Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 2")
		else 
			sysEngines.engStart1Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 1")
		end 
	end))
startProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
startProc:addItem(ProcedureItem:new("  N2 ROTATION","AT 25%",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 else 
		return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 end end))
startProc:addItem(IndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.startLever2:getStatus() == 1 
		else 
			return sysEngines.startLever1:getStatus() == 1 
		end
	end,
	function () 
		kc_speakNoText(0,"N1 at 25 percent") 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.startLever2:actuate(1) 
		else 
			sysEngines.startLever1:actuate(1) 
		end 
	end))
startProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
startProc:addItem(ProcedureItem:new("STARTER CUTOUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() == 1 
		else 
			return sysEngines.engStart1Switch:getStatus() == 1 
		end 
	end))
startProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,
	function () kc_speakNoText(0,"starter cutout") end))
startProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorFO,3,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 0 
		else 
			return sysEngines.engStart2Switch:getStatus() == 0 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart1Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 1")
		else 
			sysEngines.engStart2Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 2")
		end 
	end))
startProc:addItem(ProcedureItem:new("N2 ROTATION","AT 25%",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 
		else 
			return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 
		end 
	end))
startProc:addItem(IndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,3,"eng_start_2_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.startLever1:getStatus() == 1 
		else 
			return sysEngines.startLever2:getStatus() == 1 
		end 
	end,
	function () 
		kc_speakNoText(0,"N1 at 25 percent") 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.startLever1:actuate(1) 
		else 
			sysEngines.startLever2:actuate(1) 
		end 
	end))
startProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
startProc:addItem(ProcedureItem:new("STARTER CUTOUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 1 
		else 
			return sysEngines.engStart2Switch:getStatus() == 1 
		end 
	end))
startProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
startProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,
	function () 
		kc_speakNoText(0,"starter cutout") 
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
startProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
startProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))

-- ============= BEFORE TAXI PROCEDURE (F/O) =============
-- HYDRAULIC PUMP SWITCHES...................ALL ON  (F/O)
-- GENERATOR 1 AND 2 SWITCHES....................ON  (F/O)
-- PROBE HEAT SWITCHES...........................ON  (F/O)
-- WING ANTI-ICE SWITCH...................AS NEEDED  (F/O)
-- ENGINE ANTI-ICE SWITCHES...............AS NEEDED  (F/O)
-- PACK SWITCHES...............................AUTO  (F/O)
-- ISOLATION VALVE SWITCH......................AUTO  (F/O)
-- APU BLEED AIR SWITCH.........................OFF  (F/O)
-- APU SWITCH...................................OFF  (F/O)
-- ENGINE START SWITCHES.......................CONT  (F/O)
-- =======================================================

-- ============= BEFORE TAXI PROCEDURE (CPT) =============
-- Verify that the ground equipment is clear.
-- Call 'FLAPS ___' as needed for takeoff.           
-- FLAP LEVER.....................SET TAKEOFF FLAPS  (F/O)
-- LE FLAPS EXT GREEN LIGHT.............ILLUMINATED  (F/O)
-- FLIGHT CONTROLS............................CHECK (BOTH)
-- TRANSPONDER............................AS NEEDED  (F/O)
-- ENGINE START LEVERS..................IDLE DETENT  (CPT)
-- RECALL.....................................CHECK (BOTH)
--   Verify annunciators illuminate and then extinguish.
-- =======================================================

local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE","","ready for before taxi checklist")
beforeTaxiProc:setFlightPhase(5)
beforeTaxiProc:addItem(ProcedureItem:new("HYDRAULIC PUMP SWITCHES","ALL ON",FlowItem.actorFO,0,
	function () return sysHydraulic.hydPumpGroup:getStatus() == 4 end,
	function () 
		kc_macro_hydraulic_on() 
	end))
beforeTaxiProc:addItem(ProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () 
		kc_procvar_set("gen1down",true)
		kc_procvar_set("gen2down",true)
	end))
beforeTaxiProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTaxiProc:addItem(SimpleProcedureItem:new("  When temperature <10 C & visible moisture"))
beforeTaxiProc:addItem(ProcedureItem:new("PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () 
		kc_macro_packs_on()
	end))
beforeTaxiProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == sysAir.isoVlvAuto end))
beforeTaxiProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(0) end))
beforeTaxiProc:addItem(ProcedureItem:new("APU SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up") end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () 
		if sysEngines.engStarterGroup:getStatus() == 2 then
			sysEngines.engStarterGroup:step(cmdUp) 
		end
	end))
beforeTaxiProc:addItem(HoldProcedureItem:new("SET TAKEOFF FLAPS","ANNOUNCE",FlowItem.actorCPT))
beforeTaxiProc:addItem(ProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
beforeTaxiProc:addItem(ProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("laminar/B738/annunciator/slats_extend") > 0 end))

beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","AILERONS",FlowItem.actorBOTH,0,"fccheck1",
	function () return get("sim/flightmodel2/wing/aileron1_deg") > 19 end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","ELEVATORS",FlowItem.actorBOTH,0,"fccheck2",
	function () return get("sim/flightmodel2/wing/elevator1_deg") < -19 end))
beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS CHECK","RUDDER",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end,
	function () 
		kc_macro_b738_lowerdu_sys()
	end))
beforeTaxiProc:addItem(ProcedureItem:new("RECALL","CHECK",FlowItem.actorFO,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/fo_six_pack") end))
beforeTaxiProc:addItem(ProcedureItem:new("RECALL","CHECK",FlowItem.actorCPT,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","TARA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA) 
		sysRadios.xpdrCode:actuate(activeBriefings:get("departure:squawk"))
	end,
	function () return activePrefSet:get("general:xpdrusa") == false end))
beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) 
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
beforeTaxiProc:addItem(ProcedureItem:new("LOWER DU","OFF",FlowItem.actorFO,0,
	function () return get("laminar/B738/systems/lowerDU_page2") == 0 end,
	function () 
		kc_macro_b738_lowerdu_off()
	end))

	
-- ============= BEFORE TAXI CHECKLIST (F/O) =============
-- GENERATORS....................................ON  (F/O)
-- PROBE HEAT....................................ON  (F/O)
-- ANTI-ICE.............................AS REQUIRED  (F/O)
-- ISOLATION VALVE.............................AUTO  (F/O)
-- ENGINE START SWITCHES.......................CONT  (F/O)
-- RECALL...................................CHECKED (BOTH)
-- AUTOBRAKE....................................RTO  (F/O)
-- ENGINE START LEVERS..................IDLE DETENT  (CPT)
-- FLIGHT CONTROLS..........................CHECKED  (CPT)
-- GROUND EQUIPMENT...........................CLEAR (BOTH)
-- =======================================================

local beforeTaxiChkl = Checklist:new("BEFORE TAXI CHECKLIST","","before taxi checklist completed")
beforeTaxiChkl:setFlightPhase(5)
beforeTaxiChkl:addItem(ChecklistItem:new("#exchange|GENERATORS|before taxi checklist. generators","ON",FlowItem.actorFO,0,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end))
beforeTaxiChkl:addItem(ChecklistItem:new("PROBE HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 1 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","ENGINE ANTI-ICE",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 2 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","ENGINE & WING ANTI-ICE",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 3 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ISOLATION VALVE","AUTO",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.isoValveSwitch:setValue(sysAir.isoVlvAuto) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorCPT,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
beforeTaxiChkl:addItem(ChecklistItem:new("RECALL","CHECKED",FlowItem.actorCPT,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
beforeTaxiChkl:addItem(ChecklistItem:new("AUTOBRAKE","RTO",FlowItem.actorCPT,0,
	function () return sysGeneral.autobrake:getStatus() == 0 end,
	function () sysGeneral.autobrake:actuate(0) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiChkl:addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorCPT,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end,
	function () 
		kc_macro_b738_lowerdu_sys() 
	end))
beforeTaxiChkl:addItem(ChecklistItem:new("GROUND EQUIPMENT","CLEAR",FlowItem.actorBOTH,0,true,
	function () 
		kc_macro_b738_lowerdu_off()
		sysLights.taxiSwitch:actuate(1) 
	end))


local TaxiProc = Procedure:new("BEGIN TAXI","","")
TaxiProc:setFlightPhase(5)
TaxiProc:addItem(HoldProcedureItem:new("CLEAR LEFT","",FlowItem.actorCPT))
TaxiProc:addItem(ProcedureItem:new("CLEAR RIGHT","",FlowItem.actorFO,0,true,
	function () kc_speakNoText(0,"clear right") end))


-- =========== BEFORE TAKEOFF CHECKLIST (F/O) ============
-- FLAPS............................__, GREEN LIGHT  (CPT)
-- STABILIZER TRIM....................... ___ UNITS  (CPT)
-- =======================================================

local beforeTakeoffChkl = Checklist:new("BEFORE TAKEOFF CHECKLIST","","before takeoff checklist completed")
beforeTakeoffChkl:setFlightPhase(7)
beforeTakeoffChkl:addItem(ChecklistItem:new("#exchange|FLAPS|before takeoff checklist. Flaps","%s, GREEN LIGHT|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () 
		return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] and 
			get("laminar/B738/annunciator/slats_extend") > 0 end,
	function () 
		sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) 
	end)) 
beforeTakeoffChkl:addItem(ChecklistItem:new("STABILIZER TRIM","%3.2f UNITS (%3.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*1000,10)/1000|activeBriefings:get(\"takeoff:elevatorTrim\")",FlowItem.actorCPT,0,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*1000,10)/1000 == activeBriefings:get("takeoff:elevatorTrim")*100/100) end))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY PROCEDURE","runway entry","aircraft ready for takeoff")
runwayEntryProc:setFlightPhase(7)
runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_for_takeoff() 
		kc_macro_b738_lowerdu_off()
		kc_procvar_set("fmacallouts",true) -- activate FMA callouts
	end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA)
		sysRadios.xpdrCode:actuate(activeBriefings:get("departure:squawk"))
	end))		
runwayEntryProc:addItem(ProcedureItem:new("PACKS & BLEEDS","SET",FlowItem.actorFO,0,true,
	function ()
		kc_macro_packs_takeoff() 
		kc_macro_bleeds_takeoff()
	end))
runwayEntryProc:addItem(ProcedureItem:new("TRAFFIC ON ND","ON",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.tfcPilot:getStatus() == 1
	end,
	function () 
		sysEFIS.tfcPilot:actuate(1)
	end))
runwayEntryProc:addItem(ProcedureItem:new("WEATHER RADAR","ON",FlowItem.actorCPT,0,
	function () return 
		sysEFIS.wxrPilot:getStatus() == 1
	end,
	function () 
		sysEFIS.wxrPilot:actuate(1)
	end))

--	center pumps off

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- TAKEOFF
-- AUTOTHROTTLE................................ARM   (PF)
-- A/P MODES...........................AS REQUIRED   (PF)
-- THRUST SETTING...........................40% N1   (PF)
-- SET TAKEOFF THRUST.....................T/O MODE   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PF)

-- GEAR UP
-- GEAR.........................................UP   (PM)

-- RETRACT FLAPS
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)   
-- FLAPS 10.........................SET (OPTIONAL)   (PM)
-- FLAPS 10 SPEED...............REACHED (OPTIONAL)   
-- FLAPS 5..........................SET (OPTIONAL)   (PM)
-- FLAPS 5 SPEED...........................REACHED   
-- FLAPS 1.....................................SET   (PM)
-- FLAPS 1 SPEED...........................REACHED   
-- FLAPS UP....................................SET   (PM)

-- background FO when flaps are up
-- AUTO BRAKE SELECT SWITCH....................OFF   (PM)
-- GEAR........................................OFF   (PM)
-- ENGINE START SWITCHES.......................OFF   (PM)

-- Whatever comes first
-- TRANSITION ALTITUDE............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..................................STD (BOTH)

-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS..............................OFF   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES...............OFF   (PM)
-- FASTEN BELTS SWITCH.........................OFF   (PM)
-- ======================================================

local takeoffProc = Procedure:new("TAKEOFF & INITIAL CLIMB","takeoff")
takeoffProc:setFlightPhase(8)
takeoffProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_for_takeoff() 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
takeoffProc:addItem(ProcedureItem:new("A/P MODES","%s|kc_pref_split(kc_TakeoffApModes)[activeBriefings:get(\"takeoff:apMode\")]",FlowItem.actorPF,0,
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
		kc_macro_doors_all_closed()
	end))
takeoffProc:addItem(IndirectProcedureItem:new("THRUST SETTING","40% N1",FlowItem.actorPNF,0,"to40percent",
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 40 end))
takeoffProc:addItem(ProcedureItem:new("SET TAKEOFF THRUST","T/O MODE",FlowItem.actorPF,0,
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 70 end,
	function () command_once("laminar/B738/autopilot/left_toga_press") kc_speakNoText(0,"takeoff thrust set") end))
--takeoffProc:addItem(IndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",FlowItem.actorPNF,0,"toposrate",
--	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 0 and get("sim/flightmodel/position/y_agl") > 40 end))

-- ====
local gearUpProc = Procedure:new("GEAR UP","Gear up")
gearUpProc:setFlightPhase(8)
gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_speakNoText(0,"gear coming up") 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in
	end))

-- flaps schedule
local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(8)
flapsUpProc:addItem(SimpleProcedureItem:new("Retract Flaps when Speed reached"))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 10","COMMAND",FlowItem.actorCPT,nil,
 	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 10","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_10") kc_speakNoText(0,"speed check flaps 10") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_5") kc_speakNoText(0,"speed check flaps 5") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 1","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_0") kc_speakNoText(0,"speed check flaps up") end))

-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- ENGINE BLEEDS................................ON   (PM)
-- PACKS......................................AUTO   (PM)
-- LANDING GEAR.........................UP AND OFF   (PM)
-- FLAPS.............................UP, NO LIGHTS   (PM)
-- ======================================================

local afterTakeoffChkl = Checklist:new("AFTER TAKEOFF CHECKLIST","","after takeoff checklist completed")
afterTakeoffChkl:setFlightPhase(9)
afterTakeoffChkl:addItem(ChecklistItem:new("#exchange|ENGINE BLEEDS|after takeoff checklist. engine bleeds","ON",FlowItem.actorPM,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () kc_macro_bleeds_on() end))
afterTakeoffChkl:addItem(ChecklistItem:new("PACKS","AUTO",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () kc_macro_packs_on() end))
afterTakeoffChkl:addItem(ChecklistItem:new("LANDING GEAR","UP AND OFF",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () sysGeneral.GearSwitch:actuate(2) end))
afterTakeoffChkl:addItem(ChecklistItem:new("FLAPS","UP, NO LIGHTS",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/flap_lever",0) end))

-- ================= DESCENT PROCEDURE ==================
-- LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES...OFF   (PM)
--   If center tank quantity below 3,000 lbs/1400 kgs
-- PRESSURIZATION...................LAND ALT __ FT   (PM)
-- RECALL..........................CHECKED ALL OFF   (PM)
-- VREF..............................SELECT IN FMC   (PF)
-- LANDING DATA...............VREF __, MINIMUMS __   (PM)
-- Set/verify navigation radios & course for the approach.
-- AUTO BRAKE SELECT SWITCH..............AS NEEDED   (PM)
-- Whatever comes first
-- TRANSITION LEVEL...............ANNOUNCE REACHED   (PM)
-- ALTIMETERS............................LOCAL QNH (BOTH)
-- ====
-- ======================================================

local descentProc = Procedure:new("DESCENT PROCEDURE","I have control","you have control")
descentProc:setFlightPhase(11)
descentProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
descentProc:addItem(HoldProcedureItem:new("KPCREW APPROACH BRIEFING","FILLED OUT",FlowItem.actorCPT))
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

-- =============== DESCENT CHECKLIST (PM) ===============
-- PRESSURIZATION...................LAND ALT _____   (PM)
-- RECALL..................................CHECKED   (PM)
-- AUTOBRAKE...................................___   (PM)
-- LANDING DATA...............VREF___, MINIMUMS___ (BOTH)
-- APPROACH BRIEFING.....................COMPLETED   (PF)
-- ======================================================

local descentChkl = Checklist:new("DESCENT CHECKLIST","","descent checklist completed")
descentChkl:setFlightPhase(11)
descentChkl:addItem(ChecklistItem:new("#exchange|PRESSURIZATION|descent checklist. pressurization","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentChkl:addItem(ChecklistItem:new("RECALL","CHECKED",FlowItem.actorPM,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentChkl:addItem(ChecklistItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,0))
descentChkl:addItem(ChecklistItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorBOTH,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 and math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("approach:decision") end,
	function () 
				local flag = 0 
				if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
				sysEFIS.minsTypePilot:actuate(flag) 
				sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
descentChkl:addItem(ChecklistItem:new("APPROACH BRIEFING","COMPLETED",FlowItem.actorPF,0))

-- =============== APPROACH CHECKLIST (PM) ==============
-- ALTIMETERS............................QNH _____ (BOTH)
-- ======================================================

local approachChkl = Checklist:new("APPROACH CHECKLIST","","approach checklist completed")
approachChkl:setFlightPhase(13)
approachChkl:addItem(ChecklistItem:new("#exchange|ALTIMETERS|approach checklist. altimeters","QNH %s |activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH,0,true,
	function () return kc_macro_test_briefed_baro() end,
	function () kc_macro_set_briefed_baro() end))

-- =============== LANDING PROCEDURE (PM) ===============
-- LANDING LIGHTS...............................ON  (CPT)
-- RWY TURNOFF LIGHTS...........................ON  (CPT)
-- ENGINE START SWITCHES......................CONT   (PM)
-- SPEED BRAKE...............................ARMED   (PF)
-- COURSE NAV 1................................SET  (CPT)
-- COURSE NAV2.................................SET   (FO)

-- ==== Flaps1
-- FLAPS 1 SPEED...........................REACHED   (PM)
-- FLAPS 1.....................................SET   (PM)
-- FLAPS 5 SPEED...........................REACHED   (PM)
-- FLAPS 5.....................................SET   (PM)

-- ==== GEAR DOWN FLAPS 15
-- LANDING GEAR...............................DOWN   (PM)
-- FLAPS 15 SPEED..........................REACHED   (PM)
-- FLAPS 15....................................SET   (PM)

-- === FLAPS 30 or 40
-- FLAPS 30........................SET IF REQUIRED   (PM)
-- FLAPS 40........................SET IF REQUIRED   (PM)
-- SPEED BRAKE...............................ARMED   (PM)
-- GO AROUND ALTITUDE......................... SET   (PM)
-- GO AROUND HEADING...........................SET   (PM)
-- ======================================================

local landingProc = Procedure:new("PREPARE LANDING","","")
landingProc:setFlightPhase(13)
landingProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorPM,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorCPT,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
landingProc:addItem(ProcedureItem:new("COURSE NAV2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorFO,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 1 end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeAuto) end,
	function () return activeBriefings:get("approach:packs") > 1 end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:setValue(0) end,
	function () return activeBriefings:get("approach:packs") > 1 end))
landingProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
landingProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
landingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
landingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
landingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorCPT,0,true,
	function () kc_macro_lights_approach() end))

local flaps1Proc = Procedure:new("FLAPS 1","","")
flaps1Proc:setFlightPhase(13)
flaps1Proc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end))
flaps1Proc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND",FlowItem.actorPF))
flaps1Proc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_5") kc_speakNoText(0,"speed check flaps 5") end))

local gearDownProc = Procedure:new("GEAR DOWN - FLAPS 15","","")
gearDownProc:setFlightPhase(13)
gearDownProc:addItem(ProcedureItem:new("GEAR","DOWN",FlowItem.actorPNF,0,true,
	function () sysGeneral.GearSwitch:actuate(modeOn) kc_speakNoText(0,"gear coming down") end))
gearDownProc:addItem(ProcedureItem:new("FLAPS 15","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_15") kc_speakNoText(0,"speed check flaps 15") end))

local flaps30Proc = Procedure:new("COMMAND FLAPS 30 OR 40","","")
flaps30Proc:setFlightPhase(13)
flaps30Proc:addItem(ProcedureItem:new("FLAPS 30","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_30") kc_speakNoText(0,"speed check flaps 30") end,
	function () return activeBriefings:get("approach:flaps") == 2 end))
flaps30Proc:addItem(ProcedureItem:new("FLAPS 40","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_40") kc_speakNoText(0,"speed check flaps 40") end,
	function () return activeBriefings:get("approach:flaps") == 1 end))
flaps30Proc:addItem(ProcedureItem:new("SPEED BRAKE","ARMED",FlowItem.actorPF,0,
	function () return get("laminar/B738/annunciator/speedbrake_armed") == 1 end,
	function () kc_speakNoText(0,"Speed brake armed?") end))
flaps30Proc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
flaps30Proc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))

-- =============== LANDING CHECKLIST (PM) ===============
-- ENGINE START SWITCHES......................CONT   (PF)
-- SPEEDBRAKE................................ARMED   (PF)
-- LANDING GEAR...............................DOWN   (PF)
-- FLAPS..........................___, GREEN LIGHT   (PF)
-- ======================================================

local landingChkl = Checklist:new("LANDING CHECKLIST","","landing checklist completed")
landingChkl:setFlightPhase(13)
landingChkl:addItem(ChecklistItem:new("#exchange|ENGINE START SWITCHES|landing checklist. ENGINE START SWITCHES","CONT",FlowItem.actorPF,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
landingChkl:addItem(ChecklistItem:new("SPEED BRAKE","ARMED",FlowItem.actorPF,0,
	function () return get("laminar/B738/annunciator/speedbrake_armed") == 1 end))
landingChkl:addItem(ChecklistItem:new("LANDING GEAR","DOWN",FlowItem.actorPF,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
landingChkl:addItem(ChecklistItem:new("FLAPS","%s, GREEN LIGHT|kc_pref_split(kc_LandingFlaps)[activeBriefings:get(\"approach:flaps\")]",FlowItem.actorPF,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("approach:flaps")+5] 
	and get("laminar/B738/annunciator/slats_extend") == 1 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("approach:flaps")+5]) end))

-- ====================== GO AROUND ======================
-- GO AROUND ALTITUDE...........................SET   (PM)
-- GO AROUND HEADING............................SET   (PM)
-- GO AROUND THRUST.............................SET  (CPT)
-- mode HDG
-- mode LVL CHG
-- GEAR..................................COMMAND UP  (CPT)
-- GEAR..........................................UP   (PM)
-- flaps 15
-- CMD-A.. Command
-- set modes lnav/vnav is applicable
-- flaps schedule
-- flaps 5
-- flaps 1
-- flaps up
-- =======================================================

local goAroundProc = Procedure:new("GO AROUND","going around","")
goAroundProc:setFlightPhase(20)
goAroundProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
goAroundProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))
goAroundProc:addItem(ProcedureItem:new("GO AROUND THRUST","SET",FlowItem.actorPF,0,true,
	function () command_once("laminar/B738/autopilot/left_toga_press") kc_speakNoText(0,"go around thrust set") end))
goAroundProc:addItem(ProcedureItem:new("HDG MODE","SET",FlowItem.actorPF,0,true,
	function () sysMCP.hdgselSwitch:actuate(1) end))
goAroundProc:addItem(HoldProcedureItem:new("GEAR","COMMAND UP",FlowItem.actorPF))
goAroundProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPF,0,"gear_up_ga",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_speakNoText(0,"gear coming up") 
	end))
goAroundProc:addItem(ProcedureItem:new("FLAPS 15","SET",FlowItem.actorPNF,0,true,
	function () 
		command_once("laminar/B738/push_button/flaps_15") 
		kc_speakNoText(0,"speed check flaps 15") 
	end))
goAroundProc:addItem(HoldProcedureItem:new("LVL CHG","COMMAND",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("LVL CHG","SET",FlowItem.actorPF,0,
	function () return sysMCP.lvlchgSwitch:getStatus() == 1 end,
	function () 
		sysMCP.lvlchgSwitch:actuate(1) 
		kc_speakNoText(0,"level change") 
	end))
goAroundProc:addItem(ProcedureItem:new("FLAPS UP SPEED","SET %s|get(\"laminar/B738/pfd/flaps_up\")",FlowItem.actorPM,0,
	function() return sysMCP.iasSelector:getStatus() ==  get("laminar/B738/pfd/flaps_up") end,
	function() sysMCP.iasSelector:setValue(get("laminar/B738/pfd/flaps_up")) end))
goAroundProc:addItem(HoldProcedureItem:new("CMD-A","COMMAND ON",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("CMD-A","ON",FlowItem.actorPNF,0,true,
	function () 
		sysMCP.ap1Switch:actuate(1) 
		kc_speakNoText(0,"command a") 
	end))
goAroundProc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,true,
	function () 
		command_once("laminar/B738/push_button/flaps_5") 
		kc_speakNoText(0,"speed check flaps 5") 
	end))
goAroundProc:addItem(HoldProcedureItem:new("LNAV & VNAV","COMMAND",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("LNAV VNAV","SET",FlowItem.actorPNF,0,
	function () 
		return sysMCP.lnavSwitch:getStatus() == 1 and sysMCP.vnavSwitch:getStatus() == 1 
	end, 
	function () 
		sysMCP.lnavSwitch:actuate(1) 
		sysMCP.vnavSwitch:actuate(1) 
	end))
goAroundProc:addItem(HoldProcedureItem:new("FLAPS 1","COMMAND",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end))
goAroundProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND",FlowItem.actorPF))
goAroundProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,true,
	function () command_once("laminar/B738/push_button/flaps_0") kc_speakNoText(0,"speed check flaps up") end))


-- ============== AFTER LANDING PROCEDURE ===============
-- SPEED BRAKE................................DOWN   (PF)
-- CHRONO & ET................................STOP  (CPT)
-- WX RADAR....................................OFF  (CPT)
-- APU.......................................START   (FO)
--   Hold APU switch in START position for 3-4 seconds
--   APU GEN OFF BUS LIGHT.............ILLUMINATED   (FO)
-- PROBE HEAT..................................OFF   (FO)
-- STROBES.....................................OFF   (FO)
-- LANDING LIGHTS..............................OFF   (FO)
-- TAXI LIGHTS..................................ON  (CPT)
-- ENGINE START SWITCHES.......................OFF   (FO)
-- TRAFFIC SWITCH..............................OFF   (FO)
-- AUTOBRAKE...................................OFF   (FO)
-- FLAPS........................................UP   (FO)
-- APU...........................START IF REQUIRED   (FO)
-- TAXI LIGHT BEFORE GATE..............COMMAND OFF  (CPT)
-- TAXI LIGHT SWITCH...........................OFF  (CPT) 
-- ======================================================

local afterLandingProc = Procedure:new("AFTER LANDING PROCEDURE","cleaning up")
afterLandingProc:setFlightPhase(15)
afterLandingProc:addItem(ProcedureItem:new("SPEED BRAKE","DOWN",FlowItem.actorCPT,0,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () 
		set("laminar/B738/flt_ctrls/speedbrake_lever",0) 
		activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_procvar_set("fmacallouts",false) -- deactivate FMA callouts
	end))
afterLandingProc:addItem(ProcedureItem:new("CHRONO & ET","STOP",FlowItem.actorCPT,0))
afterLandingProc:addItem(ProcedureItem:new("WX RADAR","OFF",FlowItem.actorCPT,0,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () kc_macro_lights_cleanup() end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end))
afterLandingProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysEFIS.tfcPilot:getStatus() == 0 end,
	function () sysEFIS.tfcPilot:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == 1 end,
	function () sysGeneral.autobrake:actuate(1) end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","TARA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA) end,
	function () return activePrefSet:get("general:xpdrusa") == false end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
afterLandingProc:addItem(ProcedureItem:new("#spell|APU# ","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_macro_b738_lowerdu_sys()
		kc_procvar_set("apustart",true)
	end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
afterLandingProc:addItem(SimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds.",
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
afterLandingProc:addItem(IndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_end",
	function () return sysElectric.apuGenBusOff:getStatus() == 1 end,nil,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
afterLandingProc:addItem(ProcedureItem:new("AIRCRAFT","CLEAN",FlowItem.actorFO,0,true,
	function () kc_speakNoText(9,"aircraft cleaned up") end))
afterLandingProc:addItem(HoldProcedureItem:new("TAXI LIGHT BEFORE STAND","COMMAND OFF",FlowItem.actorPF))
afterLandingProc:addItem(ProcedureItem:new("LIGHTS & DOORS","SET",FlowItem.actorFO,0,true,
	function () sysLights.taxiSwitch:actuate(0) end))

-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- PARKING BRAKE...............................SET  (CPT)
-- ==== Electrical power
-- APU GENERATOR BUS SWITCHES.........ON IF NEEDED   (FO)
-- GRD POWER AVAILABLE LIGHT...........ILLUMINATED   (FO)
-- GROUND POWER SWITCH................ON IF NEEDED   (FO)
-- ENGINE START LEVERS......................CUTOFF  (CPT)
-- FASTEN BELTS SWITCH.........................OFF   (FO)
-- ANTI COLLISION LIGHT SWITCH.................OFF   (FO)
-- FUEL PUMPS..............APU 1 PUMP ON, REST OFF  (CPT)
-- FUEL PUMPS............ALL OFF IF APU NOT RUNNIG  (CPT)
-- CAB/UTIL POWER SWITCH........................ON  (CPT)
-- IFE/PASS SEAT POWER SWITCH..................OFF  (CPT)
-- PROBE HEAT..................................OFF   (FO)
-- WING ANTI-ICE SWITCH........................OFF   (FO)
-- ENGINE ANTI-ICE SWITCHES....................OFF   (FO)
-- ENGINE HYDRAULIC PUMPS SWITCHES..............ON   (FO)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES...........OFF   (FO)
-- RECIRCULATION FAN SWITCHES.................AUTO   (FO)
-- AIR CONDITIONING PACK SWITCHES.............AUTO   (FO)
-- ISOLATION VALVE SWITCH.....................OPEN   (FO)
-- ENGINE BLEED AIR SWITCHES....................ON   (FO)
-- APU BLEED AIR SWITCH...............ON IF NEEDED   (FO)
-- FLIGHT DIRECTOR SWITCHES....................OFF   (FO)
-- TRANSPONDER................................STBY   (FO)
-- MCP.......................................RESET   (FO)
-- ======================================================

local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE","shutting down","ready for shutdown checklist")
shutdownProc:setFlightPhase(17)
shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownProc:addItem(SimpleChecklistItem:new("==== Electrical power"))
shutdownProc:addItem(ProcedureItem:new("#spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,
	function () 
		kc_macro_gpu_connect()
	end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("GROUND POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(cmdDown) end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () kc_speakNoText(0,"ready to cut engines") end))
shutdownProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	end))
shutdownProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorCPT,0,true,
	function () kc_macro_lights_after_shutdown() activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
shutdownProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorCPT,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_shutdown() end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_shutdown() end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))
shutdownProc:addItem(ProcedureItem:new("IFE/PASS SEAT POWER SWITCH","OFF",FlowItem.actorCPT,0,
	function () return sysElectric.ifePwr:getStatus() == modeOff end,
	function () sysElectric.ifePwr:actuate(modeOff) end))
shutdownProc:addItem(ProcedureItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () kc_macro_hydraulic_initial() end))
shutdownProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () kc_macro_hydraulic_initial() end))
shutdownProc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
shutdownProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() > 1 end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeAuto) end))
shutdownProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == sysAir.isoVlvOpen end,
	function () sysAir.isoValveSwitch:setValue(sysAir.isoVlvOpen) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () kc_macro_bleeds_on() end))
shutdownProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(1) end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysMCP.fdirGroup:getStatus() == 0 end,
	function () sysMCP.fdirGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) end))
shutdownProc:addItem(ProcedureItem:new("DOORS","OPEN",FlowItem.actorFO,0,true,
	function () kc_macro_doors_after_shutdown() end))
shutdownProc:addItem(ProcedureItem:new("MCP","RESET",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		kc_macro_b738_lowerdu_off()
		kc_macro_mcp_cold_dark()
		-- stairs need a delay to be extended
		if activeBriefings:get("taxi:gateStand") > 1 then
			if get("laminar/B738/airstairs_hide") == 1  then
				command_once("laminar/B738/airstairs_toggle")
			end
		end
	end))

 -- ============== SHUTDOWN CHECKLIST (F/O) ==============
 -- FUEL PUMPS..................................OFF  (F/O)
 -- PROBE HEAT.............................AUTO/OFF  (F/O)
 -- HYDRAULIC PANEL.............................SET  (F/O)
 -- FLAPS........................................UP  (CPT)
 -- PARKING BRAKE.......................AS REQUIRED  (CPT)
 -- ENGINE START LEVERS......................CUTOFF  (CPT)
 -- WEATHER RADAR...............................OFF (BOTH)
 -- ======================================================

local shutdownChkl = Checklist:new("SHUTDOWN CHECKLIST","","shutdown checklist completed")
shutdownChkl:setFlightPhase(17)
shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_shutdown() end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_shutdown() end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownChkl:addItem(ChecklistItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownChkl:addItem(ChecklistItem:new("HYDRAULIC PANEL","SET",FlowItem.actorFO,0))
shutdownChkl:addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorCPT,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end)) 
shutdownChkl:addItem(ChecklistItem:new("PARKING BRAKE","ON",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(cmdDown) end))
shutdownChkl:addItem(ChecklistItem:new("WEATHER RADAR","OFF",FlowItem.actorBOTH,0,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) sysEFIS.wxrCopilot:actuate(0) end))

-- =============== SECURE CHECKLIST (F/O) ===============
-- IRSs........................................OFF  (F/O)
-- EMERGENCY EXIT LIGHTS.......................OFF  (F/O)
-- WINDOW HEAT.................................OFF  (F/O)
-- PACKS.......................................OFF  (F/O)
-- ======================================================

local secureChkl = Checklist:new("SECURE CHECKLIST","","secure checklist completed")
secureChkl:setFlightPhase(1)
secureChkl:addItem(ChecklistItem:new("#exchange|IRS MODE SELECTORS|SECURE CHECKLIST. I R S MODE SELECTORS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitOFF) end))
secureChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsSwitch:getStatus() == 0  end,
	function () sysGeneral.emerExitLightsCover:actuate(1) sysGeneral.emerExitLightsSwitch:actuate(0) end))
secureChkl:addItem(ChecklistItem:new("WINDOW HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
secureChkl:addItem(ChecklistItem:new("PACKS","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == sysAir.packModeOff end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeOff) end))

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		if activePrefSet:get("general:sges") == true then
			kc_macro_start_sges_sequence()
		end
		getActiveSOP():setActiveFlowIndex(1)
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
		if activePrefSet:get("general:sges") == true then
			kc_macro_start_sges_sequence()
		end
	end))
turnAroundProc:addItem(ProcedureItem:new("GPU","ON BUS","SYS",0,true,
	function () 
		command_once("laminar/B738/toggle_switch/gpu_dn")
		electricalPowerUpProc:setState(Flow.FINISH)
		prelPreflightProc:setState(Flow.FINISH)
		getActiveSOP():setActiveFlowIndex(3)
	end))

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("toctest", false) -- B738 takeoff config test
kc_procvar_initialize_bool("ovhttest", false) -- B738  OVHT fire test
kc_procvar_initialize_bool("ext1test", false) -- B738  EXT1 fire test
kc_procvar_initialize_bool("ext2test", false) -- B738  EXT2 fire test
kc_procvar_initialize_bool("mach1test", false) -- B738 MACH OVSPD L test
kc_procvar_initialize_bool("mach2test", false) -- B738 MACH OVSPD R test
kc_procvar_initialize_bool("stall1test", false) -- B738 STALL L test
kc_procvar_initialize_bool("stall2test", false) -- B738 STALL R test
kc_procvar_initialize_bool("gpwstest", false) -- B738 GPWS test
kc_procvar_initialize_bool("oxyfotest", false) -- B738 OXY FO test
kc_procvar_initialize_bool("oxycpttest", false) -- B738 OXY CPT test
kc_procvar_initialize_bool("cargofiretest", false) -- B738 CARGO FIRE test
kc_procvar_initialize_bool("tcastest", false) -- B738 TCAS test
kc_procvar_initialize_bool("apustart", false) -- B738 start apu
kc_procvar_initialize_bool("gen1down", false) -- B738 hold GEN1 switch down
kc_procvar_initialize_bool("gen2down", false) -- B738 hold GEN2 switch down
kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level
kc_procvar_initialize_bool("fmacallouts", false) -- make callouts when FMA modes change
kc_procvar_initialize_bool("aftertakeoff", false) -- triggers after takeoff activities by FO


backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		if kc_procvar_get("toctest") == true then 
			kc_bck_b738_toc_test("toctest")
		end
		if kc_procvar_get("ovhttest") == true then 
			kc_bck_b738_ovht_test("ovhttest")
		end
		if kc_procvar_get("ext1test") == true then 
			kc_bck_b738_ext1_test("ext1test")
		end
		if kc_procvar_get("ext2test") == true then 
			kc_bck_b738_ext2_test("ext2test")
		end
		if kc_procvar_get("mach1test") == true then 
			kc_bck_b738_mach1_test("mach1test")
		end
		if kc_procvar_get("mach2test") == true then 
			kc_bck_b738_mach2_test("mach2test")
		end
		if kc_procvar_get("stall1test") == true then 
			kc_bck_b738_stall1_test("stall1test")
		end
		if kc_procvar_get("stall2test") == true then 
			kc_bck_b738_stall2_test("stall2test")
		end
		if kc_procvar_get("gpwstest") == true then 
			kc_bck_b738_gpws_test("gpwstest")
		end
		if kc_procvar_get("oxyfotest") == true then 
			kc_bck_b738_oxyfo_test("oxyfotest")
		end
		if kc_procvar_get("oxycpttest") == true then 
			kc_bck_b738_oxycpt_test("oxycpttest")
		end
		if kc_procvar_get("cargofiretest") == true then 
			kc_bck_b738_cargofire_test("cargofiretest")
		end
		if kc_procvar_get("tcastest") == true then 
			kc_bck_b738_tcas_test("tcastest")
		end
		if kc_procvar_get("apustart") == true then 
			kc_bck_b738_apustart("apustart")
		end
		if kc_procvar_get("gen1down") == true then 
			kc_bck_b738_gen1down("gen1down")
		end
		if kc_procvar_get("gen2down") == true then 
			kc_bck_b738_gen2down("gen2down")
		end
		if kc_procvar_get("above10k") == true then 
			kc_bck_climb_through_10k("above10k")
		end
		if kc_procvar_get("below10k") == true then 
			kc_bck_descend_through_10k("below10k")
		end
		if kc_procvar_get("attransalt") == true then 
			kc_bck_transition_altitude("attransalt")
		end
		if kc_procvar_get("attranslvl") == true then 
			kc_bck_transition_level("attranslvl")
		end
		if kc_procvar_get("fmacallouts") == true then 
			kc_bck_fma_callouts("fmacallouts")
		end
		if kc_procvar_get("aftertakeoff") == true then 
			kc_bck_after_takeoff_items("aftertakeoff")
		end
	end))
	

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(preflightFOProc)
activeSOP:addChecklist(preflightChkl)
activeSOP:addProcedure(beforeStartProc)
activeSOP:addChecklist(beforeStartChkl)
activeSOP:addProcedure(pushProc)
activeSOP:addProcedure(startProc)
activeSOP:addProcedure(beforeTaxiProc)
activeSOP:addChecklist(beforeTaxiChkl)
activeSOP:addChecklist(TaxiProc)
activeSOP:addChecklist(beforeTakeoffChkl)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(flapsUpProc)
activeSOP:addChecklist(afterTakeoffChkl)
activeSOP:addProcedure(descentProc)
activeSOP:addChecklist(descentChkl)
activeSOP:addChecklist(approachChkl)
activeSOP:addProcedure(landingProc)
activeSOP:addProcedure(flaps1Proc)
activeSOP:addProcedure(gearDownProc)
activeSOP:addProcedure(flaps30Proc)
activeSOP:addChecklist(landingChkl)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(shutdownProc)
activeSOP:addChecklist(shutdownChkl)
activeSOP:addChecklist(secureChkl)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

function getActiveSOP()
	return activeSOP
end

return SOP_B738
