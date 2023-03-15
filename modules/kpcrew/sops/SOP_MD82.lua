-- Base SOP for Laminar MD-82

-- @classmod SOP_MD82
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local SOP_MD82 = {
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
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = SOP:new("Default Aircraft SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,true,
	function () 
		command_end("sim/ignition/engage_starter_1")
		command_end("sim/starters/engage_start_run_1")
		command_end("sim/starters/engage_starter_1")
	end))

	
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

-- CIRCUIT BREAKERS (P6 PANEL)..........CHECK ALL IN (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)
-- LANDING GEAR LEVER...........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED (F/O)
--   RED LANDING GEAR LIGHT.......CHECK EXTINGUISHED (F/O)

-- Parking brake ON
--  Battery Switch ON / LOCK
--  Fire loop test PERFORM
--  POS/STROBE LIGHTS BOTH rotatniug beacon
-- ==== Activate External Power
--   GRD POWER AVAILABLE LIGHT...........ILLUMINATED (F/O)
--   AC POWER SWITCH.............................GRD (F/O)
--   GROUND POWER SWITCH..........................ON (F/O)
-- ==== Activate APU 
--   APU.......................................START (F/O)
--     Start APU if available and specific to the aircraft
--   APU.....................................RUNNING
--     Bring APU power on bus
-- • START PUMP SW (DC) ON
-- • APU START SW START
-- • Monitor light 'APU STARTER ON' on WAAP
-- • Monitor light 'APU PWR AVAIL'
-- • APU POWER 115Volt, 400Hz CHECK
-- • APU L and R BUS ON
-- • power consumption is below 1.0 CHECK
-- • APU AIR (>60 seconds) ON
-- • AIR pressure centure duct CHECK
-- • Right PNEU-X-FEED OPEN
-- • Right AIR COND SUPPLY AUTO
--  Right AFT FUEL PUMP SW ON
--  START PUMP SW (DC) OFF
--  WING/NACL LIGHTS ON if required


local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 24V",FlowItem.actorFO,0,"bat24v",
	function () return get("sim/flightmodel/engine/ENGN_bat_volt",0) > 23 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == modeOn end,
	function () 
		sysElectric.batterySwitch:actuate(modeOff) 
		if kc_is_daylight() then		
			sysLights.domeLightSwitch:actuate(0)
			sysLights.instrLightGroup:actuate(0)
		else
			sysLights.domeLightSwitch:actuate(1)
			sysLights.instrLightGroup:actuate(1)
		end
		sysLights.instr3Light:actuate(1)
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


-- ================= PREFLIGHT PROCEDURE =================
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

-- PRIMARY FLIGHT DISPLAY'S.......................ON
-- NAVIGATION DISPLAY'S .......................ON
-- ANNUNCIATOR LIGHTS .......................TEST
-- FLIGHT DIRECTOR’S .......................ON
-- EFIS .......................TEST
-- AUTOLAND AVAILABILITY .......................TEST
-- TRIM .......................TEST
-- ENGINE SYNC SELECTOR .......................OFF
-- GALLEY POWER .......................ON
-- FUEL PUMP SWITCH .......................TEST
-- NO SMOKING .......................ON
-- PITOT HEATER .......................TEST
-- WINDSHIELD HEAT .......................ON
-- PNEUMATIC X-FEEDS .......................OPEN
-- GPWS .......................TEST
-- WINDSHEAR .......................TEST
-- ANTI SKID .......................TEST
-- STALL .......................TEST
-- OVERSPEED .......................TEST
-- YAW DAMPER .......................ON
-- ICE FOD .......................TEST
-- TCAS .......................TEST
-- SET XPONDER .......................ABOVE
-- TAKEOFF WARNING .......................TEST
-- HYDRAULIC PUMP .......................TEST
-- GEAR .......................TEST
-- WX RADAR .......................TEST
-- SET ALTIMETERS .......................SET
-- TRP .......................TEST
-- TRP TO TAKEOFF .......................SET
-- ADF .......................TEST
-- ZFW .......................TEST
-- SHOW .......................ZFW

-- STANDBY ATTITUDE INDICATOR .......................CAGE
-- EMERGENCY LIGHT TEST (WITH FA VIA PA CALL BUTTON) .......................PERFORM 
-- ARRIVAL ELEVATION (PRESSURIZATION AND FS2CREW PANEL) .......................SET 
-- FLIGHT DATA RECORDER PANEL .......................SET 
-- AIRCRAFT WALK ARROUND .......................PERFORM 
-- PAPERS .......................CHECK 
-- FLIGHT MANAGEMENT SYSTEM, MCDU PROGRAMMING .......................SET 
-- FLIGHT CONTROL PANEL .......................SET 
-- COM, NAV RADIO'S AND TRANSPONDER .......................SET 
-- ALTIMETER .......................SET
-- TRP (IF REDUCED TAKE OFF) .......................SET


local preflightProc = Procedure:new("PREFLIGHT PROCEDURE","starting pre flight procedure","I finished the preflight procedure")
preflightProc:setFlightPhase(2)
preflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 1 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
preflightProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",FlowItem.actorFO,0,"stall_warning_test1",
	function () return get("sim/cockpit2/annunciators/stall_warning") == 1 end,
	function () command_begin("sim/annunciator/test_stall") end))
preflightProc:addItem(SimpleProcedureItem:new("  AC power must be available"))
preflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () command_end("sim/annunciator/test_stall") sysRadios.xpdrCode:actuate(2000) end))
preflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
preflightProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 1 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) sysFuel.fuelPumpLeftAft:actuate(modeOn) end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
preflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
preflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
preflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,0,
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
preflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
preflightProc:addItem(SimpleProcedureItem:new("Electric hydraulic pumps on for F/O walk-around"))
preflightProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
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


-- pre start above the line checklists

-- CIRCUIT BREAKERS...........................CHECKED
-- L & R BUS TIE/ DC BUS X TIE...........................AUTO/OPEN
-- EMERG POWER...........................CHECKED/OFF
-- GALLEY POWER...........................ON
-- CABIN ALT CNTRL WHEEL/LEVER AUTO/VALVE...........................OPEN
-- PNEUM X-FEED VALVE LEVERS...........................OPEN
-- CABIN PRESS CONTROL...........................SET
-- COCKPIT / CABIN CONTROL...........................TEMP AS REQUIRED
-- OXYGEN CYL PRESS...........................CHECKED
-- FLIGHT RECORDER...........................CHECKED/SET
-- VOICE RECORDER...........................CHECKED
-- CADC/FD CMD/ EFIS SEL........................... NORM
-- ENG SYNC SELECTOR ...........................OFF
-- GPWS ...........................CHECKED
-- ANTI-SKID ...........................CHECKED/ARMED
-- STALL WARNING ...........................CHECKED
-- MAX SPEED WARNING ...........................CHECKED
-- MACH TRIM COMPENSATOR ...........................ON/NORM
-- YAW DAMPER ...........................ON
-- RADIO RACK ...........................FAN
-- AIR COND SHUTOFF ...........................AUTO
-- RAM AIR ...........................OFF
-- FUEL PUMPS ...........................CHECKED
-- IGNITION ...........................OFF
-- EMER LIGHTS ...........................CHECKED/ARMED
-- NO SMOKING/SEATBELT SW ...........................ON/ON
-- PITOT HEAT ...........................CHECKED/OFF
-- AIRFOIL / ENG ANTI ICE........................... OFF
-- WINDSHIELD HEAT ...........................ON
-- ANNUNCIATOR/ DIGITAL LIGHTS........................... CHECKED
-- DFGS / NAVAIDS ...........................SET
-- FLIGHT INSTRUMENTS........................... CHECKED
-- BRAKE PRESSURE & TEMP........................... CHECKED
-- HYDRAULIC SYSTEM ...........................CHECKED
-- GEAR LIGHTS & AURAL WARNING........................... CHECKED
-- FUEL USED ...........................RESET
-- ENGINE INSTRUMENTS ...........................CHECKED
-- STATIC AIR SELECTOR ...........................NORM
-- TCAS ...........................CHECKED
-- RADAR ...........................CHECKED
-- RUD HYD CONTROL ...........................LEVER PWR
-- FUEL X-FEED ...........................LEVER OFF
-- FUEL SWITCHES ...........................CHECKED
-- T/O WARNING........................... CHECKED
-- STABILIZER ...........................CHECKED
-- SPOILERS ...........................DISARMED/RET
-- FLAPS/SLATS ...........................UP / RET



-- pre start procedure
-- briefings and atc
-- fms programming

-- AUTOFLIGHT PANEL SET
-- •Initial altitude
-- •Heading departure runway
-- •V2 Air speed selecter
-- Set speed bugs (clickspot ASI 12 o'clock for T/O speed bugs) SET
-- TRANSPONDER SET
-- "Are you ready for the Departure Brief?"
-- Flap setting and CG takeoff condition computer SET
-- Stabilizer trim SET
-- APU / APU Air ON or START
-- Seatbelt sign ON
-- "PRE START CHECK BELOW THE LINE" Challenge


-- pre start checklist below the line
-- "PRE START CHECK BELOW THE LINE" CHALLENGE: FIRST OFFICER
-- COVERS & PINS..REMOVED
-- AIRCRAFT LOG & DOCUMENTS..CHECKED ON BOARD
-- ALTIMETERS..QNH…. SET / CHECKED
-- FUEL/OIL/HYD QUANTITY..CHECKED
-- ZERO FUEL WEIGHT..SET
-- TRP..TAKEOFF / … TAKEOFF FLEX
-- STABILIZER..POINT ZERO SET (.. = 1 TO 12)
-- FLAPS TAKEOFF SELECTOR..STOWED
-- SPEED BUGS..SET


-- "BEFORE START CHECK" (part 1)
-- Parking Brakes..Set/Released
-- Doors..Closed
-- Start-up & Pushback Clrnce..Approved 
-- BEFORE START CHECK (part 2 ) Challenge: First Officer (Silently DO - items)
-- Pneum X-Feed Valve Levers OPEN
-- Aux & Trans Hyd Pumps ON
-- Anti-Collision Light ON
-- Air Cond Supply OFF,BOTH
-- Fuel Pumps ON
-- Galley Power OFF
-- Ignition A / B
-- Pneum Press CHECK
-- “BEFORE START CHECK COMPLETE, READY FOR ENGINE START”


-- =========== PUSHBACK & ENGINE START (BOTH) ============
-- PARKING BRAKE................................SET  (CPT)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- PACKS................................AUTO OR OFF  (F/O)
-- SYSTEM A HYDRAULIC PUMPS......................ON  (F/O)
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

-- PUCHBACK and ENGINE START
--  "Cockpit to ground" / "Ground from cockpit"
--  "We’re ready for the pushback and engine start"  pushback dialogue
--  Brakes released
-- Pushback will start
--  "Cabin crew close doors and arm slides"
--  check sufficient pneumatic pressure and doors closed
--  “START RIGHT ENGINE”  Engage start switch right engine and checks pressure
-- “RIGHT START VALVE OPEN”
--  fuel lever ON  “FUEL ON”
--  “FUEL ON” “N2”, “OIL PRESSURE”, “N1”, “FUEL FLOW,” “EGT”
-- Cabin crew close doors and arm slides  40% N1: Release start switch (Engine generator
-- switched to the electrical bus)
-- “RIGHT START VALVE CLOSED”
-- Engine stabilized:  “STABILIZING” and resets timer
--  Engine Anti Ice AS REQUIRED
--  Reset timer
--  “START LEFT ENGINE”  Engage start switch left engine and checks pressure
-- “LEFT START VALVE OPEN”
--  fuel lever ON  “FUEL ON”
--  “FUEL ON” “N2”, “OIL PRESSURE”, “N1”, “FUEL FLOW,” “EGT”
--  40% N1: Release start switch (Engine generator
-- switched to the electrical bus)
-- “LEFT START VALVE CLOSED”
-- Engine stabilized:  “STABILIZING” and resets timer
--  Engine Anti Ice AS REQUIRED
--  Reset timer
-- "ABORT START"  The FO will release the Start Switches. If the fuel levers
-- are on, the FO will hold the Start Switches for 30
-- seconds before releasing them.
-- After pushback is finished:
--  "Brakes set"
--  "Thanks for the guidance" / "Good bye"


-- "Cockpit to ground" / "Ground from cockpit"  Start up dialogue
--  "We’re ready"
-- Start engines
--  "You can disconnect now"

--  Check Electrical Loads (AC and DC) in limits CHECK  Engine generator volts and frequencies correct CHECK
--  Galley Power ON  Engine Ignition off OFF
--  Sets air conditioning supply AUTO  Set CAPT Pitot Heater ON
--  Check Hydraulic pumps and switcheS HI/ON


-- "AFTER (ENGINE) START CHECK"
--  "Off"  Ignition
--  "Checked"  Electrical Loads
--  "Auto"  Air Cond Supply
--  "On"  Galley Power
--  "Off/ Eng anti ice on/ Both on"  Ice Protection Panel
--  "“CLOSE THEM”, “OPEN THEM”." (FO will set! ; Open for airfoil anti-ice)  Pneumatic X-Feed Valve (Read and DO)
-- Check Flight controls :  Flight Controls
--  AILERONS FULL LEFT : “LEFT… SPOILER DEPLOYED”
--  AILERONS FULL RIGHT: “RIGHT…SPOILER DEPLOYED”
--  ELEVATOR FULL FORWARD: “ELEVATOR POWER ON”*
--  PEDALS FULL RIGHT/LEFT: “PEDALS”
--  "Flight Controls Check Completed"
--  "Checked"  Hyd Pumps & Press "Checked/Hi/On"
--  "Checked"  Annunciator Panel
--  "Removed"  Ground Equipment
--  "Received"  All Clear Signal
-- Flaps Slats (Read and DO) "Set"


-- Obtain TAXI clearance
--  “WE ARE CLEAR ON THE LEFT”  Flood lights ON
--  Nose Light ON Wing/Nacelle Lights ON
-- Start taxi
--  "TAXI CHECK" (in clear area)
--  "Not required/ On / Off" (FO will set!)   Fuel Heat (Read and Do)
--  "0 / 11 / 15 Degrees Takeoff *"  Flaps & Slats
--  "Set and Checked"  EPR Bugs & TRP
--  "No Changes, Verified*"  Takeoff Speeds
--  "Performed"  TO Briefing
--  "Set and Checked"  ATC/DFGS/Navaids
--  "Pre-Flight Completed"  FMS
-- APU Air/APU Master OFF / Leave APU on
--  "Both Off / Air Off / "ON"  APU Air/Master SW
--  "Checked"  Brake Temp & Pressure


-- When ready for departure:
--  “CABIN CREW BE SEATED FOR TAKEOFF”  Strobes ON
-- Autobrake SET
-- Ignition A
--  Brake temperature <205 degrees C CHECK
--  Weather Radar ON (3 degrees NU) IF REQUIRED
--  Landing Lights ON Xpndr TARA
--  "LINE UP CHECK"
--  "Secured"  Cabin
--  "Left Side Closed"  Windows
--  "Checked"  Annunciator Panel
--  "Set to A / Set to B"  Ignition
--  "Auto / Manual"  Air Cond Supply
-- Transponder (READ AND DO) "TARA"
--  "Received / TO GO "  Takeoff Clearance
--  "TAKEOFF CLEARANCE RECEIVED


-- When cleared for Takeoff :
--  Press TOGA button (FMA will announce TAK OFF TAK OFF)
--  Wing Landing lights ON
--  Cycles seatbelt switch.
--  Asks FO: “READY?"
--  Start timing (Turn on the clock to show flight time)  "Yes"
--  “TAKEOFF”
--  Throttles 1.40 EPR (brakes ON)
--  Autothrottle, release brake (FMA will announce EPR T/O) ON
-- "CLAMP" (A/T 60 knots)
-- Rotate at Vr / RTO BEFORE V1  "V1", "Vr"
--  8 degrees pitch; V2 + 10 knots
--  Landing and mose Lights OFF  “GEAR UP”
-- 200 ft  “AUTOPILOT ON”
-- 400 ft  "ENGAGE HEADING SELECT" / "ARM NAVIGATION"
-- 1500 ft  "ENGAGE VNAV" / "SET VERTICAL SPEED UP __"  Climb mode (CL on TRP)
-- Accelerating to 250 knots
--  "FLAPS UP” (speed > 3rd bug)
--  “SLATS RETRACT” (speed > last bug)
--  Autobrake
-- F/O
-- Ignition OFF
--  Disarm autospoilers and autobrake DISARM
--  Flaps TO selector STOWED
--  Eng Hyd Pumps to LOW
-- Aux & Xfer Hyd Pumps to OFF
-- SET
--  Engine Sync to N1 SET

-- CLIMB CHECK Challenge: First Officer (silently)
-- Response: NONE
-- Gear "Up"
-- Flaps/Slats "Up / Retracted"
-- Autospoilers/ABS "Off / Disarmed"
-- Flaps TO Selector "STOW"
-- Trans & Aux Hyd Pumps "Off"
-- Pressurization "Checked"
-- Ignition "Set"
-- Fuel Pumps "As Required"
--  "On / Off/ Auto"  "Seatbelts" (READ) "On / Off/ Auto"

-- 10000 feet  Wing Landing lights OFF
-- Transition Altitude or cleared above :
--  “TRANSITION 2992 / 1013"  Altimeter FO 2992 / 1013 SET
--  Altimeter CA 2992 / 1013 SET
--  "PASSING FLIGHT LEVEL xxx …. --> "NOW”


-- descend
-- 20000 feet  Flood, logo and Wing Nacelle lights ON
-- 10000 feet  Wing Landing lights ON
-- APPROACH  Setup Nav Radios SET
-- "APPROACH CHECK"
--  Engine Sync OFF
--  "Set"  Navigation

-- Reduce speed 235 knots: "SLATS EXTEND" and "FLAPS 11"
--  NAV 1 TO ILS/LOCALIZER/VOR frequency / course SET
-- Setup Nav Radios by FO:
--  “SET ILS / LOCALISER / VOR ON NAV 2”
--  "FLAPS 15" and reduce speed 210 knots
-- Localiser/VOR active
--  "ARM LOCALISER" / "ARM VOR"
--  “LOCALISER CAPTURE"
-- Glideslope +1 TO 1.5 DOT
--  "GEAR DOWN"
--  "ARM ILS"
--  Reduce speed 180 knots
--  “GLIDESLOPE CAPTURE”
--  "FLAPS 28" and reduce speed 160 knots
--  Go Arround altitude SET
--  Bank limit 15 degrees SET
--  "FLAPS 40" and reduce speed Vref
-- After receive landing clearance
--  Nose landing light ON
-- CATII/CATIII approach, set Decision Altitude in the FS2Crew Configuration panel to 0.
-- During the approach brief, when you ask the FO “Any Questions?” the FO will ask you if you want
-- to do an Autoland. Reply “YES“ or “NO“.
-- If Yes, the autoland calls (FLARE and ALIGN) will be enabled, and the DH selector on the FS2Crew
-- FS2Crew Voice Flow Maddog 2008 SP3 version 1.00 Page 4 of 5
--  Autobrake SET


-- "FINAL CHECK"
--  Set Engine Ignition
--  "Down"  Gear
--  Push GA on TRP
--  Arm spoiler
--  Autobrake SET
--  "Set to A / Set to B"  Ignition
--  "Armed"  Autospoilers & Autobrakes
--  "Flaps ___ land"  Flaps & Slats
--  "Received" / “TO GO”"  Landing Clearance
--  "LANDING CLEARANCE RECEIVED"


-- "AFTER LANDING CHECK" / "AFTER LANDING CHECK WITHOUT APU" Challenge: First Officer (silently)
-- Response: NONE
-- Timer stopped
-- Spoiler/ ABS Ret & Off
-- Flaps/ Slats 15 Degrees TO
-- Pneum X-Feed Open
-- Xpdr Standbyd
-- Radar Off
-- Left Air Cond Supply Off
-- APU As Required


-- Reaching gate
--  “FLAPS AND SLATS”  Flaps and slats UP
--  Parking Brake SET  Connect APU to the buses IF REQUIRED
--  Connect external power and tie buses IF REQUIRED
--  Fuel levers OFF  Anti Collision light OFF
--  Seatbelt signs OFF
--  "Cabin crew disarm slides and open doors"

-- "PARKING CHECK"
--  Fuel pumps excl. right aft if APU running OFF
-- Hydraulic pumps OFF
--  "Set"  Parking Brakes
--  "Retracted"  Flaps/Slats
--  "Established"  APU/EXT Power
--  "Off"  Fuel Levers
--  "Off"  Anti Collision
--  "Off"  Hyd Pumps
--  "Off"  Seat Belt SW
--  "Off"  Ice Protection Panel
--  "Standby"  Xpdr

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
	
-- ============= Background Flow ==============
-- kc_procvar_initialize_bool("toctest", false)

local backgroundFlow = Background:new("","","")
backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		return
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(testProc)
-- activeSOP:addProcedure(electricalPowerUpProc)
-- activeSOP:addProcedure(preflightProc)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_MD82
