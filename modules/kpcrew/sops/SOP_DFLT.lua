-- Base SOP for Default Aircraft

-- @classmod SOP_DFLT
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_DFLT = {
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
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = "" }
					 

-- Set up SOP =========================================================================

activeSOP = SOP:new("Default Aircraft SOP")

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


-- testProc:addItem(ProcedureItem:new("DOORS","ALL OPEN",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_all_open()
	-- end))
-- testProc:addItem(ProcedureItem:new("DOORS","ALL CLOSED",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_all_closed()
	-- end))
-- testProc:addItem(ProcedureItem:new("DOORS","PREFLIGHT",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_preflight()
	-- end))
-- testProc:addItem(ProcedureItem:new("DOORS","BEFORE START",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_before_start()
	-- end))
-- testProc:addItem(ProcedureItem:new("DOORS","SHUTDOWN",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_after_shutdown()
	-- end))
-- testProc:addItem(ProcedureItem:new("DOORS","C&D",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_doors_cold_dark()
	-- end))

-- testProc:addItem(ProcedureItem:new("LIGHTS","ALL ON",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_lights_all_on()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","COLD&DARK",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_cold_dark()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","PREFLIGHT",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_preflight()
	  -- sysLights.domeLightSwitch:actuate(0)
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","BEFORE START",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_before_start()
	  
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","BEFORE TAXI",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_before_taxi()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","TAKEOFF",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_for_takeoff()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","CLMB 10K",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_climb_10k()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","DESC 10K",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_descend_10k()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","APPROACH",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_approach()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","CLEANUP",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_cleanup()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","ARRIVE PARKING",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_arrive_parking()
	-- end))
-- testProc:addItem(ProcedureItem:new("LIGHTS","SHUTDOWN",FlowItem.actorFO,5,true,
	-- function () 
	  -- kc_macro_lights_after_shutdown()
	-- end))

-- ============ Electrical Power Up Procedure ============
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ===== Initial checks
-- DC Electric Power
-- BATTERY VOLTAGE...........................MIN 24V (F/O)
-- BATTERY SWITCH.................................ON (F/O)

-- Hydraulic System
-- ELECTRIC HYDRAULIC PUMP.......................OFF (F/O)
-- FLAP LEVER....................................SET (F/O)
--   Set the flap lever to agree with the flap position.

-- Other
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)
-- LANDING GEAR LEVER...........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED (F/O)

-- ==== Activate External Power
--   GROUND POWER..........................CONNECTED (F/O)
--     Ensure that GPU is on Bus

-- ==== Activate APU 
--   APU.......................................START (F/O)
--     Start APU if available and specific to the aircraft
--   APU.....................................RUNNING
--     Bring APU power on bus
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 24V",FlowItem.actorFO,0,"bat24v",
	function () return sysElectric.batt1Vold.getStatus() >= 24 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		kc_macro_lights_preflight()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL & INTERNAL LIGHTS","AS NEEDED",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_preflight()
	end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Hydraulic System"))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Other"))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
	function () return sysGeneral.wiperSwitch:getStatus() == 0 end,
	function () sysGeneral.wiperSwitch:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == modeOn end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GROUND POWER","CONNECTED",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Ensure that GPU is on Bus",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () sysElectric.apuStartSwitch:repeatOn() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Start the APU if available and specific to the aircraft.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #spell|APU#","RUNNING",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () sysElectric.apuStartSwitch:repeatOff() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Bring #spell|APU# power on bus",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))


-- ============ PRELIMINARY PREFLIGHT PROCEDURES =========
-- ELECTRICAL POWER UP......................COMPLETE (F/O)
-- STALL WARNING TEST........................PERFORM (F/O)
--   AC power must be available
-- XPDR.....................................SET 2000 (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS..........SET AS REQUIRED (F/O)
-- FUEL PUMPS................................ALL OFF (F/O)
-- POSITION LIGHTS................................ON (F/O)
-- MCP....................................INITIALIZE (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- Electric hydraulic pumps on for F/O walk-around
-- ELECTRIC HYDRAULIC PUMPS SWITCHES..............ON (F/O)
-- =======================================================

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight","I finished the preliminary preflight")
prelPreflightProc:setFlightPhase(2)
prelPreflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 1 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
prelPreflightProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",FlowItem.actorFO,0,"stall_warning_test1",
	function () return get("sim/cockpit2/annunciators/stall_warning") == 1 end,
	function () command_begin("sim/annunciator/test_stall") end))
prelPreflightProc:addItem(SimpleProcedureItem:new("  AC power must be available"))
prelPreflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () command_end("sim/annunciator/test_stall") sysRadios.xpdrCode:actuate(2000) end))
prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 1 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) sysFuel.fuelPumpLeftAft:actuate(modeOn) end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		sysMCP.fdirGroup:actuate(modeOff)
		sysMCP.athrSwitch:actuate(modeOff)
		sysMCP.crs1Selector:actuate(1)
		sysMCP.crs2Selector:actuate(1)
		sysMCP.iasSelector:actuate(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:actuate(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:actuate(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:actuate(modeOff)
		sysMCP.discAPSwitch:actuate(modeOff)
	end))
prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(SimpleProcedureItem:new("Electric hydraulic pumps on for F/O walk-around"))
prelPreflightProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOn) end))

-- ================ Preflight Procedure ==================
-- ==== Flight control panel                            
-- YAW DAMPER SWITCH..............................ON (F/O)

-- ==== Fuel panel                                      
-- FUEL PUMP SWITCHES........................ALL OFF (F/O)
--   If APU running turn one of the left fuel pumps on
-- FUEL CROSS FEED...............................OFF (F/O)
-- CROSS FEED VALVE LIGHT...............EXTINGUISHED (F/O)

-- ==== Electrical panel                                
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

-- ==== Anti-Ice
-- WINDOW HEAT SWITCHES...........................ON (F/O)
-- WINDOW HEAT ANNUNCIATORS............. ILLUMINATED (F/O)
-- PROBE HEAT SWITCHES...........................OFF (F/O)
-- WING ANTI-ICE SWITCH..........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES......................OFF (F/O)
-- =======================================================


-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("COLD & DARK","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		getActiveSOP():setActiveFlowIndex(1)
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("TURNAROUND","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		return
	end))

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_DFLT
