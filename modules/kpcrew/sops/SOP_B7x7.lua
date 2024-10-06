-- Base SOP for FlightFactor B757 & B767

-- @classmod SOP_B7x7
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local SOP_B7x7 = {
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

activeSOP = SOP:new("FlightFactor B757/B767")

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
-- STANDBY POWER SELECTOR.......................AUTO (F/O)
-- LANDING GEAR LEVER...........................DOWN (F/O)
-- GREEN LANDING GEAR LIGHT........CHECK ILLUMINATED (F/O)
-- ALTERNATE FLAPS SELECTOR.....................NORM (F/O)
--  Verify APU BAT DISCH & MAIN BAT DISCH lights illuminated
-- BUS TIE SWITCHES.............................AUTO (F/O)

-- HYDRAULIC ELECTRIC PUMP SWITCHES..............OFF (F/O)
-- HYDRAULIC DEMAND PUMP BUTTONS.................OFF (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)

-- ==== Activate External Power
--   Use EFB to turn Ground Power on.
--   GROUND POWER SWITCH..........................ON (F/O)

-- ==== Activate APU 
--   APU.......................................START (F/O)
--     Start APU if available and specific to the aircraft
--   APU.....................................RUNNING
--     Bring APU power on bus
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)

electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== DC Electric Power"))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY VOLTAGE, MIN 24V","CHECKED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/battery_voltage_actual_volts") > 23 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH, ON","SET",FlowItem.actorFO,0,
	function () return get("anim/14/button") == 1 end,
	function () set("anim/14/button",1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER SELECTOR, AUTO","SET",FlowItem.actorFO,0,
	function () return get("1-sim/electrical/stbyPowerSelector") == 1 end,
	function () set("1-sim/electrical/stbyPowerSelector",1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER, DOWN","CHECKED",FlowItem.actorFO,0,
	function () return get("1-sim/cockpit/switches/gear_handle") == 1 end,
	function () set("1-sim/cockpit/switches/gear_handle",1) end))
-- electricalPowerUpProc:addItem(ProcedureItem:new("ALTERNATE FLAPS SELECTOR, NORM","CHECKED",FlowItem.actorFO,0,
	-- function () return get("1-sim/gauges/flapsALTNswitcher") == 0 end,
	-- function () set("1-sim/gauges/flapsALTNswitcher",1) end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new(" Verify APU BAT DISCH & MAIN BAT DISCH lights illuminated"))
electricalPowerUpProc:addItem(ProcedureItem:new("BUS TIE SWITCHES, AUTO","CHECKED",FlowItem.actorFO,0,
	function () return get("anim/17/button") == 1 and get("anim/18/button") == 1 end,
	function () 
		set("anim/17/button",1)
		set("anim/18/button",1)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("HYDRAULIC ELECTRIC PUMP SWITCHES, OFF","CHECKED",FlowItem.actorFO,0,
	function () return get("anim/9/button") == 0 and get("anim/10/button") == 0 end,
	function () 
		set("anim/9/button",0)
		set("anim/10/button",0)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("HYDRAULIC DEMAND PUMP BUTTONS, OFF", "CHECKED",FlowItem.actorFO,0,
	function () return get("1-sim/hyd/elecSwitchLeft") == 0 and get("1-sim/hyd/elecSwitchRight") == 0 and get("1-sim/hyd/airSwitch") == 0 end,
	function () 
		set("1-sim/hyd/elecSwitchLeft",0)
		set("1-sim/hyd/elecSwitchRight",0)
		set("1-sim/hyd/airSwitch",0)
	end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new(":::::::::::::::: Activate External Power ::",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Use EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("GROUND POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return get("params/gpu") == 1 end,
	function () set("params/gpu",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

-- addItem(list['AMPLIFIED']['POWER-UP'], createIfItem('APU Generator','ON', globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('anim/15/button'), 1, CH_EQUAL, CH_DEFAULT), 'Skip if external power is available', CH_BELOW)
-- addItem(list['AMPLIFIED']['POWER-UP'], createIfItem('APU selector','START', globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('anim/16/button'), 1, CH_EQUAL, globalProperty('1-sim/engine/APUStartSelector'), 2, CH_EQUAL, CH_DEFAULT), 'Use EXT PWR switch instead if available. Position the APU selector back to the ON position, do not allow the APU Selector to spring back to the ON position', CH_BELOW)

-- ================ PRELIMINARY PREFLIGHT ================

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight","I will do the walk around now")
prelPreflightProc:setFlightPhase(2)
prelPreflightProc:addItem(SimpleProcedureItem:new("Electrical Power Up procedure to be completed first"))

prelPreflightProc:addItem(ProcedureItem:new("L IRS mode selector","NAV",FlowItem.actorFO,0,
	function () return get("1-sim/irs/1/modeSel") == 2 end,
	function () set("1-sim/irs/1/modeSel",2) end))
prelPreflightProc:addItem(ProcedureItem:new("C IRS mode selector","NAV",FlowItem.actorFO,0,
	function () return get("1-sim/irs/2/modeSel") == 2 end,
	function () set("1-sim/irs/2/modeSel",2) end))
prelPreflightProc:addItem(ProcedureItem:new("R IRS mode selector","NAV",FlowItem.actorFO,0,
	function () return get("1-sim/irs/3/modeSel") == 2 end,
	function () set("1-sim/irs/3/modeSel",2) end))
-- Verify that the ON DC lights illuminate then extinguish [next] Verify that the ALIGN lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createCheckItem('STATUS display', 'CHECK'), 'Verify that only expected messages are shown', CH_BELOW)
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createCheckItem('Verify quantities', 'CHECK'), 'Oxygen pressure. Hydraulic quantity, Engine oil quantity.', CH_BELOW)


-- addList(list, {'AMPLIFIED','CDU PREFLIGHT'})
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("Enter data in all the boxed items on the following CDU pages, enter data in the dashed items or modify small font items that are listed in this procedure, enter or modify other items at pilot's discretion."))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Initial Data', 'SET'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("IDENT page:", CH_BLUE), 'Verify that the MODEL is correct [next] Verify that the navigation data base ACTIVE date range is current', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("POS INIT page:", CH_BLUE), 'Verify that the time is correct [next] Enter the present position on the SET IRS POS line [next] Use the most accurate latitude and longitude', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Navigation Data', 'SET'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("RTE page:", CH_BLUE), 'Enter the route', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Route', 'EXECUTE'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("DEPARTURES page:", CH_BLUE))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Runway routing', 'SELECT'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('runway and departure routing', 'EXECUTE'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("POS REF page:", CH_BLUE))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('The correct RNP for the departure', 'VERIFY'), 'Verify that the route is correct on the RTE pages [next] Check the LEGS pages as needed to ensure [next] compliance with the flight plan', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Performance Data', 'SET'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("PERF INIT page:", CH_BLUE), 'CAUTION: Do not enter the ZFW into the GRWT boxes [next] The FMC will calculate performance data with significant errors', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('ZFW', 'ENTER'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('FUEL on the CDU', 'VERIFY'), 'The dispatch papers, and the fuel quantity indicators agree', CH_BELOW)
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Fuel is sufficient for flight', 'VERIFY'))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createTextItem("TAKEOFF REF page:", CH_BLUE))
-- addItem(list['AMPLIFIED']['CDU PREFLIGHT'], createCheckItem('Takeoff V speeds', 'SET'))

local preflightFOProc = Procedure:new("PREFLIGHT PROCEDURE","I have returned from the walk around, starting preflight setup","preflight setup finished")
preflightFOProc:setResize(false)
preflightFOProc:setFlightPhase(3)


preflightFOProc:addItem(ProcedureItem:new("YAW DAMPER SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/1/button") == 1 and get("anim/2/button") == 1 end,
	function () 
		set("anim/1/button",1) 
		set("anim/2/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("EEC SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/3/button") == 1 and get("anim/4/button") == 1 end,
	function () 
		set("anim/3/button",1) 
		set("anim/4/button",1)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("Hydraulic panel"))

-- preflightFOProc:addItem(ProcedureItem:new("SYS PRESS LIGHTS","CHECK"),FlowItem.actorFO,0,
 -- 'Verify lights are illuminated', CH_BELOW)

preflightFOProc:addItem(ProcedureItem:new("L & R ENGINE PUMP SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/8/button") == 1 and get("anim/11/button") == 1 end,
	function () 
		set("anim/8/button",1) 
		set("anim/11/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("L & R ELECTRIC PUMPS","OFF",FlowItem.actorFO,0,
	function () return get("anim/12/button") == 0 and get("anim/13/button") == 0 end,
	function () 
		set("anim/12/button",0) 
		set("anim/13/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("C1 C2 ELECTRIC PUMPS","OFF",FlowItem.actorFO,0,
	function () return get("anim/9/button") == 0 and get("anim/10/button") == 0 end,
	function () 
		set("anim/9/button",0) 
		set("anim/10/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("ELT SWITCH","ARMED",FlowItem.actorFO,0,
	function () return get("1-sim/elt/mode") == 1 end,
	function () set("1-sim/elt/mode",1) end))

preflightFOProc:addItem(SimpleProcedureItem:new("Electrical panel"))
preflightFOProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/14/button") == 1 end,
	function () set("anim/14/button",1) end))
preflightFOProc:addItem(ProcedureItem:new("STANDBY POWER SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/electrical/stbyPowerSelector") == 1 end,
	function () set("1-sim/electrical/stbyPowerSelector",1) end))
preflightFOProc:addItem(ProcedureItem:new("APU GENERATOR SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/15/button") == 1 end,
	function () set("anim/15/button",1) end))
preflightFOProc:addItem(ProcedureItem:new("BUS TIE SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return get("anim/17/button") == 1 and get("anim/18/button") == 1 end,
	function () 
		set("anim/17/button",1) 
		set("anim/18/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("UTILITY BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/20/button") == 1 and get("anim/21/button") == 1 end,
	function () 
		set("anim/20/button",1) 
		set("anim/21/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("GENERATOR CONTROL SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/22/button") == 1 and get("anim/25/button") == 1 end,
	function () 
		set("anim/22/button",1) 
		set("anim/25/button",1)
	end))

-- preflightFOProc:addItem(ProcedureItem:new("APU selector","START",FlowItem.actorFO,0,
 -- globalProperty('sim/cockpit2/electrical/APU_N1_percent'), 30, CH_LESS, globalProperty('1-sim/engine/APUStartSelector'), 2, CH_EQUAL, globalProperty('1-sim/engine/APUStartSelector'), 1, CH_EQUAL, CH_DEFAULT), 
 -- 'Do not allow the APU selector to spring back to the [next] ON position [next] Verify that the RUN light is illuminated', CH_BELOW)

preflightFOProc:addItem(SimpleProcedureItem:new("Lighting panel"))
preflightFOProc:addItem(ProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("1-sim/lights/runwayL/switch") == 0 and get("1-sim/lights/runwayR/switch") == 0 end,
	function () 
		set("1-sim/lights/runwayL/switch",0) 
		set("1-sim/lights/runwayR/switch",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("EMERGENCY LIGHTS SWITCH","GUARDED",FlowItem.actorFO,0,
	function () return get("1-sim/emer/lightsCover") == 0 end,
	function () set("1-sim/emer/lightsCover",0) end))
preflightFOProc:addItem(ProcedureItem:new("EMERGENCY LIGHTS SWITCH","ARMED",FlowItem.actorFO,0,
	function () return get("1-sim/emer/lights") == 1 end,
	function () set("1-sim/emer/lights",1) end))

-- preflightFOProc:addItem(ProcedureItem:new("PASSENGER OXYGEN ON LIGHT","EXTINGUISHED"
-- ), 'Verify extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("WARNING: Do not push the RAM AIR TURBINE switch, The switch causes deployment of the ram air turbine"))
-- preflightFOProc:addItem(ProcedureItem:new("RAM AIR TURBINE UNLKD LIGHT","EXTINGUISHED"
-- ))

preflightFOProc:addItem(SimpleProcedureItem:new("Engine control panel"))
preflightFOProc:addItem(ProcedureItem:new("ENGINE LIMITER BUTTONS","ON",FlowItem.actorFO,0,
	function () return get("anim/30/button") == 1 and get("anim/31/button") == 1 end,
	function () 
		set("anim/30/button",1) 
		set("anim/31/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE START SELECTORS","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/engine/leftStartSelector") == 1 and get("1-sim/engine/rightStartSelector") == 1 end,
	function () 
		set("1-sim/engine/leftStartSelector",1) 
		set("1-sim/engine/rightStartSelector",1)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("FUEL panel"))
preflightFOProc:addItem(ProcedureItem:new("CROSSFEED switches","OFF",FlowItem.actorFO,0,
	function () return get("anim/33/button") == 0 and get("anim/36/button") == 0 end,
	function () 
		set("anim/33/button",0) 
		set("anim/36/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("L FUEL PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/32/button") == 0 and get("anim/32/button") == 0 end,
	function () 
		set("anim/32/button",0) 
		set("anim/32/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("R FUEL PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/34/button") == 0 and get("anim/37/button") == 0 end,
	function () 
		set("anim/34/button",0) 
		set("anim/37/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("C FUEL PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/38/button") == 0 and get("anim/39/button") == 0 end,
	function () 
		set("anim/38/button",0) 
		set("anim/39/button",0)
	end))
-- 'Verify that the left forward pump PRESS light is extinguished if the APU is on or is illuminated if the APU is off, Verify that the other left and right pump PRESS lights are illuminated [next] Verify that both center pump PRESS lights are extinguished', CH_BELOW)

preflightFOProc:addItem(SimpleProcedureItem:new("ANTI ICE panel"))
preflightFOProc:addItem(ProcedureItem:new("WING ANTI ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("anim/40/button") == 0 end,
	function () set("anim/40/button",0) end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE ANTI ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/41/button") == 0 and get("anim/42/button") == 0 end,
	function () 
		set("anim/41/button",0) 
		set("anim/42/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("WIPER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("anim/rhotery/10") == 0 end,
	function () set("anim/rhotery/10",0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("Lighting panel"))
preflightFOProc:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/43/button") == 1 end,
	function () set("anim/43/button",1) end))
preflightFOProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/44/button") == 0 and get("anim/45/button") == 0 end,
	function () 
		set("anim/44/button",0) 
		set("anim/45/button",0)
	end))
-- preflightFOProc:addItem(ProcedureItem:new("WING LIGHT SWITCH","AS NEEDED"))
preflightFOProc:addItem(ProcedureItem:new("L R LANDING LIGHT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("1-sim/lights/landingL/switch") == 0 and get("1-sim/lights/landingR/switch") == 0 end,
	function () 
		set("1-sim/lights/landingL/switch",0) 
		set("1-sim/lights/landingR/switch",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("N LANDING LIGHT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("1-sim/lights/landingN/switch") == 0 end,
	function () set("1-sim/lights/landingN/switch",0) end))
preflightFOProc:addItem(ProcedureItem:new("L WINDOW HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/47/button") == 1 and get("anim/48/button") == 1 end,
	function () 
		set("anim/47/button",1) 
		set("anim/48/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("R WINDOW HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/49/button") == 1 and get("anim/50/button") == 1 end,
	function () 
		set("anim/49/button",1) 
		set("anim/50/button",1)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("Passenger signs panel"))
preflightFOProc:addItem(ProcedureItem:new("NO SMOKING SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return get("sim/cockpit/switches/no_smoking") == 1 end,
	function () set("sim/cockpit/switches/no_smoking",1) end))
preflightFOProc:addItem(ProcedureItem:new("SEATBELTS SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return get("sim/cockpit/switches/fasten_seat_belts") == 1 end,
	function () set("sim/cockpit/switches/fasten_seat_belts",1) end))

preflightFOProc:addItem(SimpleProcedureItem:new("Cabin Altitude panel"))
-- preflightFOProc:addItem(ProcedureItem:new("AUTO RATE CONTROL","SET"))
-- preflightFOProc:addItem(ProcedureItem:new("LANDING ALT SELECTOR","SET"), 'Destination airport elevation', CH_BELOW)
preflightFOProc:addItem(ProcedureItem:new("MODE SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/press/modeSelector") == 2 end,
	function () set("1-sim/press/modeSelector",2) end))
preflightFOProc:addItem(ProcedureItem:new("ALTN EQUIP COOLING SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("anim/51/button") == 0 end,
	function () set("anim/51/button",0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("Air conditioning panel"))
preflightFOProc:addItem(ProcedureItem:new("FWD CABIN TEMPERATURE CONTROLS","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/cond/fwdTempControl") == 0.5 end,
	function () set("1-sim/cond/fwdTempControl",0.5) end))
preflightFOProc:addItem(ProcedureItem:new("AFT CABIN TEMPERATURE CONTROLS","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/cond/aftTempControl") == 0.5 end,
	function () set("1-sim/cond/aftTempControl",0.5) end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT DECK CABIN TEMPERATURE CONTROLS","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/cond/fltdkTempControl") == 0.5 end,
	function () set("1-sim/cond/fltdkTempControl",0.5) end))
preflightFOProc:addItem(ProcedureItem:new("TRIM AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/54/button") == 1 end,
	function () set("anim/54/button",1) end))
preflightFOProc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/55/button") == 1 and get("anim/56/button") == 1 end,
	function () 
		set("anim/55/button",1) 
		set("anim/56/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("PACK CONTROL SELECTORS","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/cond/leftPackSelector") == 1 and get("1-sim/cond/rightPackSelector") == 1 end,
	function () 
		set("1-sim/cond/leftPackSelector",1) 
		set("1-sim/cond/rightPackSelector",1)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("Bleed air panel"))
preflightFOProc:addItem(ProcedureItem:new("ISOLATION SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/59/button") == 1 end,
	function () set("anim/59/button",1) end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,0,
	function () return get("anim/60/button") == 1 and get("anim/62/button") == 1 end,
	function () 
		set("anim/60/button",1) 
		set("anim/62/button",1)
	end))
preflightFOProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return get("anim/61/button") == 1 end,
	function () set("anim/61/button",1) end))
-- preflightFOProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('1-sim/AP/fd1Switcher'), 0, CH_EQUAL, globalProperty('1-sim/AP/fd2Switcher'), 0, CH_EQUAL, CH_DEFAULT))
preflightFOProc:addItem(ProcedureItem:new("VOR/DME SWITCH","AUTO",FlowItem.actorFO,0,
	function () return get("anim/78/button") == 1 and get("anim/79/button") == 1 end,
	function () 
		set("anim/78/button",1) 
		set("anim/79/button",1)
	end))
-- preflightFOProc:addItem(ProcedureItem:new("OXYGEN","TEST",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('misc/oxyTest'), 1, CH_EQUAL, globalProperty('misc/oxyTest/622'), 1, CH_EQUAL, CH_DEFAULT), 'Select the status display [next] Oxygen mask stowed and doors closed', CH_BELOW)
-- preflightFOProc:addItem(ProcedureItem:new("CREW OXYGEN PRESSURE","CHECK"),
 -- 'Check EICAS', CH_BELOW)

preflightFOProc:addItem(SimpleProcedureItem:new("Instrument source select panel"))
-- preflightFOProc:addItem(ProcedureItem:new("NAVIGATION INSTRUMENT SOURCE SELECTOR","SET",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/navSel_right'), 1, CH_EQUAL, globalProperty('1-sim/gauges/navSel_left'), 1, CH_EQUAL, CH_DEFAULT))
-- preflightFOProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SOURCE SELECTOR","SET",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/flightDirSel_right'), 0, CH_EQUAL, globalProperty('1-sim/gauges/flightDirSel_left'), 0, CH_EQUAL, CH_DEFAULT))
preflightFOProc:addItem(ProcedureItem:new("ELECTRONIC FLIGHT INSTRUMENT BUTTON","OFF",FlowItem.actorFO,0,
	function () return get("anim/76/button") == 0 and get("anim/67/button") == 0 end,
	function () 
		set("anim/76/button",0) 
		set("anim/67/button",0)
	end))
preflightFOProc:addItem(ProcedureItem:new("INERTIAL REFERENCE SYSTEM BUTTON","OFF",FlowItem.actorFO,0,
	function () return get("anim/77/button") == 0 and get("anim/68/button") == 0 end,
	function () 
		set("anim/77/button",0) 
		set("anim/68/button",0)
	end))
-- preflightFOProc:addItem(ProcedureItem:new("AIR DATA SOURCE BUTTON","OFF",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/airdataAltnClick_right'), 0, CH_EQUAL, globalProperty('1-sim/gauges/airdataAltnClick_left'), 0, CH_EQUAL, CH_DEFAULT))
-- preflightFOProc:addItem(ProcedureItem:new("FLIGHT INSTRUMENTS","CHECK",FlowItem.actorFO,0,
-- ), 'Set the altimeter [next] Verify that the flight instrument indications are correct', CH_BELOW)
-- preflightFOProc:addItem(ProcedureItem:new("Verify that only these flags are shown:"), "TCAS expected RDMI flags", CH_BELOW)
-- preflightFOProc:addItem(ProcedureItem:new("Verify that the flight mode annunciations are correct:"), "autothrottle mode is blank [next] roll mode is TO [next] pitch mode is TO [next] AFDS status is FD", CH_BELOW)
-- preflightFOProc:addItem(ProcedureItem:new("AUTOLAND STATUS ANNUNCIATOR', 'CHECK'),
 -- 'Verify that the indications are blank', CH_BELOW)

preflightFOProc:addItem(SimpleProcedureItem:new("Landing gear panel"))
preflightFOProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return get("1-sim/cockpit/switches/gear_handle") == 1 end,
	function () set("1-sim/cockpit/switches/gear_handle",1) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE GEAR SWITCH","GUARDED",FlowItem.actorFO,0,
	function () return get("1-sim/gauges/altnGearCover") == 0 end,
	function () set("1-sim/gauges/altnGearCover",0) end))
preflightFOProc:addItem(ProcedureItem:new("GPWS FLAP OVERRIDE SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("anim/72/button") == 0 end,
	function () set("anim/72/button",0) end))
preflightFOProc:addItem(ProcedureItem:new("GPWS GEAR OVERRIDE SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("anim/74/button") == 0 end,
	function () set("anim/74/button",0) end))
preflightFOProc:addItem(ProcedureItem:new("GPWS TERR OVERRIDE SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("anim/75/button") == 0 end,
	function () set("anim/75/button",0) end))
preflightFOProc:addItem(ProcedureItem:new("HEADING REFERENCE SWITCH","NORM",FlowItem.actorFO,0,
	function () return get("1-sim/gauges/hdgRefSwitcher") == 1 end,
	function () set("1-sim/gauges/hdgRefSwitcher",1) end))

preflightFOProc:addItem(SimpleProcedureItem:new("Alternate flaps panel"))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS SELECTOR","NORM",FlowItem.actorFO,0,
	function () return get("1-sim/gauges/flapsALTNswitcher") == 0 end,
	function () set("1-sim/gauges/flapsALTNswitcher",0) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/70/button") == 0 and get("anim/71/button") == 0 end,
	function () 
		set("anim/70/button",0) 
		set("anim/71/button",0)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("EICAS display"))
-- preflightFOProc:addItem(ProcedureItem:new("UPPER EICAS DISPLAY","CHECK"),
 -- 'Verify that the primary engine indications show existing conditions [next] Verify that no exceedance is shown', CH_BELOW)
-- preflightFOProc:addItem(ProcedureItem:new("SECONDARY ENGINE INDICATIONS","CHECK"),
 -- 'Verify that the secondary engine indications show existing conditions [next] Verify that no exceedance is shown', CH_BELOW) --OK
preflightFOProc:addItem(ProcedureItem:new("STATUS DISPLAY","SELECT",FlowItem.actorFO,0,
	function () return get("1-sim/eicas/StatusFlag") == 1 end,
	function () set("1-sim/eicas/StatusFlag",1) end))
preflightFOProc:addItem(ProcedureItem:new("COMPUTER SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return get("1-sim/eicas/compSelector") == 1 end,
	function () set("1-sim/eicas/compSelector",1) end))
preflightFOProc:addItem(ProcedureItem:new("THRUST REFERENCE SELECTOR","BOTH",FlowItem.actorFO,0,
	function () return get("1-sim/eicas/thrustRefSetRotary") == 1 end,
	function () set("1-sim/eicas/thrustRefSetRotary",1) end))

preflightFOProc:addItem(SimpleProcedureItem:new("EFIS control panel"))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Decision height selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('TERRAIN switch', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI RANGE selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI TRAFFIC switch', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI mode selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI CENTER switch', 'CHECK'))
-- preflightFOProc:addItem(ProcedureItem:new("WXR RADAR SWITCH","OFF",FlowItem.actorFO,0,
 -- globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('1-sim/ndpanel/1/hsiWxr'), 0, CH_EQUAL, globalProperty('1-sim/ndpanel/2/hsiWxr'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that weather radar indications are not shown on the HSI', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Left VHF communications panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('ADF panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Engine fire panel', 'CHECK'), 'Verify that the ENG BTL 1 DISCH and ENG BTL 2 DISCH lights are extinguished', CH_BELOW)
preflightFOProc:addItem(ProcedureItem:new("ENGINE FIRE SWITCHES","IN",FlowItem.actorFO,0,
	function () return get("1-sim/fire/right/EngExtHandle") == 0 end,
	function () set("1-sim/fire/right/EngExtHandle",0) end))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Transponder panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('ILS panel', 'CHECK'))

preflightFOProc:addItem(SimpleProcedureItem:new("Cargo Fire panel"))
preflightFOProc:addItem(ProcedureItem:new("CARGO FIRE ARM SWITCHES","OFF",FlowItem.actorFO,0,
	function () return get("anim/63/button") == 0 and get("anim/64/button") == 0 end,
	function () 
		set("anim/63/button",0) 
		set("anim/64/button",0)
	end))

preflightFOProc:addItem(SimpleProcedureItem:new("APU fire panel"))
preflightFOProc:addItem(ProcedureItem:new("APU FIRE SWITCH","IN",FlowItem.actorFO,0,
	function () return get("1-sim/fire/apu/EngExtHandle") == 0 end,
	function () set("1-sim/fire/apu/EngExtHandle",0) end))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Right VHF communications panel', 'CHECK'))



-- ============ PREFLIGHT ============
-- addItem(list['NORMAL']['PREFLIGHT'], createIfItem('Oxygen','TEST', globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('misc/oxyTest'), 1, CH_EQUAL, globalProperty('misc/oxyTest/622'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['PREFLIGHT'], createItemWithCondition('Pressurization Mode Selector','AUTO', globalProperty('1-sim/press/modeSelector'), 2, CH_LESS, CH_DEFAULT)) --wait??
-- addItem(list['NORMAL']['PREFLIGHT'], createCheckItem('Flight instruments', 'TEST'))
-- addItem(list['NORMAL']['PREFLIGHT'], createItemWithCondition('Parking brake','SET', globalProperty('sim/cockpit2/controls/parking_brake_ratio'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['PREFLIGHT'], createItemWithDoubleCondition('Fuel control switches','CUTOFF', globalProperty('1-sim/fuel/fuelCutOffLeft'),0, CH_EQUAL, globalProperty('1-sim/fuel/fuelCutOffRight'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['PREFLIGHT'], createCheckItem('Gear pins', 'REMOVE'))


-- addList(list, {'AMPLIFIED','BEFORE START PROCEDURE'}) -- need retest
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithDoubleCondition('Flight deck door','LOCKED', globalProperty('1-sim/cockpitDoor/switch'), 1, CH_EQUAL, globalProperty('anim/cabindoor'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT),'Verify that the UNLKD light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('Do the CDU Preflight Procedure – Performance Data steps beforecompleting this procedure'))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('CDU display', CH_BLUE))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('Takeoff thrust reference', 'CHECK'), 'Set and verify that the thrust reference mode is correct', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('IAS bugs', 'CHECK'), 'Set the bugs at V1, VR, VREF 30+40, and VREF 30+80', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('MCP', CH_BLUE))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('IAS/MACH selector', 'CHECK'), 'Arm LNAV as needed', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('Initial heading', 'CHECK'))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('Initial altitude', 'CHECK'))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('Front Exterior door','CLOSED', globalPropertyiae('sim/cockpit2/switches/custom_slider_on', 1), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('Main Cargo door','CLOSED', globalPropertyiae('sim/cockpit2/switches/custom_slider_on', 3), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('HYDRAULIC panel', CH_BLUE))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('Right ELECTRIC pump switch','ON', globalProperty('anim/13/button'), 1, CH_EQUAL, CH_DEFAULT),'Verify that the PRESS light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithDoubleCondition('C1 C2 ELECTRIC pump switches','ON', globalProperty('anim/9/button'), 1, CH_EQUAL, globalProperty('anim/10/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT),'Verify that the center 1 PRESS light is extinguished [next] The center 2 PRESS light stays illuminated until after the engine start because of load shedding', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('Left ELECTRIC pump switch','ON', globalProperty('anim/12/button'), 1, CH_EQUAL, CH_DEFAULT),'Verify that the PRESS light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('Fuel panel', CH_BLUE))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithDoubleCondition('LEFT FUEL PUMP switches','ON', globalProperty('anim/32/button'), 1, CH_EQUAL, globalProperty('anim/35/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithDoubleCondition('RIGHT FUEL PUMP switches','ON', globalProperty('anim/34/button'), 1, CH_EQUAL, globalProperty('anim/37/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the PRESS lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createTextItem('If there is fuel in the center tank:'))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createIfItem('L CENTER FUEL PUMP switches','AS REQUIRED', globalPropertyfae('sim/flightmodel/weight/m_fuel', 2), 545, CH_LARGER, globalProperty('anim/38/button'), 1, CH_EQUAL, globalProperty('anim/38/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createIfItem('R CENTER FUEL PUMP switches','AS REQUIRED', globalPropertyfae('sim/flightmodel/weight/m_fuel', 1), 545, CH_LARGER, globalProperty('anim/39/button'), 1, CH_EQUAL, globalProperty('anim/39/button'), 1, CH_EQUAL, CH_DEFAULT), 'Verify both PRESS lights are illuminated and CTR L FUEL PUMP and CTR R FUEL PUMP messages are shown', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('RED ANTI COLLISION light switch','ON', globalProperty('anim/44/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createItemWithCondition('RECALL switch','PUSH', globalProperty('1-sim/gauges/caution_recall'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that only the expected alert messages are shown', CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createCheckItem('Trim', 'CHECK'))

-- ============ BEFORE START ============
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('Fuel', 'CHECK'))
-- addItem(list['NORMAL']['BEFORE START'], createItemWithDoubleCondition('Passenger signs','SET', globalProperty('sim/cockpit/switches/no_smoking'),0, CH_LARGER, globalProperty('sim/cockpit/switches/fasten_seat_belts'), 0, CH_LARGER, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('Windows', 'LOCKED'))
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('MCP', 'SET'))
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('Takeoff thrust', 'CHECK'))
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('Takeoff speeds', 'CHECK'))
-- addItem(list['NORMAL']['BEFORE START'], createItemWithCondition('CDU preflight','COMPLETE', globalProperty('757Avionics/fmc_preflight_done'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE START'], createItemWithDoubleCondition('Rudder and aileron trim','SET', globalProperty('sim/flightmodel2/controls/rudder_trim'),0, CH_EQUAL, globalProperty('sim/flightmodel2/controls/aileron_trim'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE START'], createCheckItem('Taxi and takeoff briefing', 'COMPLETE'))
-- addItem(list['NORMAL']['BEFORE START'], createItemWithDoubleCondition('Flight deck door','LOCKED', globalProperty('1-sim/cockpitDoor/switch'),1, CH_EQUAL, globalProperty('anim/cabindoor'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE START'], createItemWithCondition('Red anti collision light','ON', globalProperty('anim/44/button'), 1, CH_EQUAL, CH_DEFAULT))


-- addList(list, {'AMPLIFIED','ENGINE START'}) --tested
-- addItem(list['AMPLIFIED']['ENGINE START'], createCheckItem('Secondary ENGINE indications', 'CHECK'))
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithDoubleCondition('PACK CONTROL selectors','OFF', globalProperty('1-sim/cond/leftPackSelector'), 0, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the PACK OFF lights are illuminated', CH_BELOW) 
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Left Engine start selector','GND', globalProperty('1-sim/engine/leftStartSelector'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that the oil pressure increases. Verify N3 rotation.', CH_BELOW)
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Wait for N3 increase to 25%','VERIFY', globalProperty('1-sim/eng/N3/L'), 25, CH_LARGER, CH_WAIT))
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('FUEL CONTROL switch','RUN', globalProperty('1-sim/fuel/fuelCutOffLeft'), 2, CH_EQUAL, CH_DEFAULT), 'Do not increase thrust above that needed to taxi until the oil temperature is a minimum of 50C', CH_BELOW)
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Wait for idle','VERIFY', globalProperty('1-sim/eng/N1/L'), 21, CH_LARGER, CH_WAIT))
-- addItem(list['AMPLIFIED']['ENGINE START'], createTextItem('After the engine is stabilized at idle, start the other engine:', CH_BLUE))
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Right Engine start selector','GND', globalProperty('1-sim/engine/rightStartSelector'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that the oil pressure increases. Verify N3 rotation.', CH_BELOW)
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Wait for N3 increase to 25%','VERIFY', globalProperty('1-sim/eng/N3/R'), 25, CH_LARGER, CH_WAIT)) 
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('FUEL CONTROL switch','RUN', globalProperty('1-sim/fuel/fuelCutOffRight'), 2, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['ENGINE START'], createItemWithCondition('Wait for idle','VERIFY', globalProperty('1-sim/eng/N1/R'), 21, CH_LARGER, CH_WAIT))

-- addList(list, {'AMPLIFIED','BEFORE TAXI'}) --tested
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createItemWithDoubleCondition('PACK CONTROL selectors','AUTO', globalProperty('1-sim/cond/leftPackSelector'), 1, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createItemWithCondition('ISOLATION switch','OFF', globalProperty('anim/59/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createItemWithCondition('APU selector','OFF', globalProperty('1-sim/engine/APUStartSelector'), 0, CH_EQUAL, CH_DEFAULT)) 
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createCheckItem('STATUS display', 'CHECK'))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createCheckItem('Flap lever', 'CHECK'), 'Set as needed for takeoff',CH_BELOW)
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createCheckItem('Flight controls', 'CHECK'))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createCheckItem('Transponder', 'CHECK'))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createItemWithDoubleCondition('RUNWAY TURNOFF light switches','ON', globalProperty('1-sim/lights/runwayL/switch'), 1, CH_EQUAL, globalProperty('1-sim/lights/runwayR/switch'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAXI'], createIfItem('LOGO LIGHT','SET', globalProperty('sim/graphics/scenery/percent_lights_on'), 0, CH_LARGER, globalProperty('anim/52/button'), 1, CH_EQUAL, globalProperty('anim/52/button'), 0, CH_EQUAL, CH_DEFAULT), 'Turn ON if dark', CH_BELOW)

-- ============ BEFORE TAXI ============
-- addItem(list['NORMAL']['BEFORE TAXI'], createCheckItem('Anti-ice', 'AS REQUIRED'))
-- addItem(list['NORMAL']['BEFORE TAXI'], createItemWithCondition('Isolation switch','OFF', globalProperty('anim/59/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE TAXI'], createCheckItem('Recall', 'CHECKED'))
-- addItem(list['NORMAL']['BEFORE TAXI'], createItemWithCondition('Autobrake','RTO', globalProperty('anim/rhotery/25'), -1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE TAXI'], createCheckItem('Ground equipment', 'CLEAR'))
-- addItem(list['NORMAL']['BEFORE TAXI'], createItemWithDoubleCondition('TAXI (RUNWAY TURNOFF) light switches','ON', globalProperty('1-sim/lights/runwayL/switch'),1, CH_EQUAL, globalProperty('1-sim/lights/runwayR/switch'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))

-- addList(list, {'AMPLIFIED','BEFORE TAKEOFF'}) --tested
-- addItem(list['AMPLIFIED']['BEFORE TAKEOFF'], createItemWithCondition('WHITE ANTI COLLISION light switch','ON', globalProperty('anim/45/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAKEOFF'], createItemWithCondition('TRANSPONDER','.TA/RA', globalProperty('1-sim/transponder/systemMode'), 5, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAKEOFF'], createItemWithCondition('AUTOBRAKE','RTO', globalProperty('1-sim/gauges/autoBrakeModeSwitcher'), -1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAKEOFF'], createItemWithDoubleCondition('RUNWAY TURNOFF light switches','OFF', globalProperty('1-sim/lights/runwayL/switch'), 0, CH_EQUAL, globalProperty('1-sim/lights/runwayR/switch'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['BEFORE TAKEOFF'], createItemWithDoubleCondition('WING LANDING LIGHTS switches','ON', globalProperty('1-sim/lights/landingL/switch'), 1, CH_EQUAL, globalProperty('1-sim/lights/landingR/switch'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))


-- addList(list, {'NORMAL','BEFORE TAKEOFF'})
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createCheckItem('Takeoff briefing', 'REVIEWED'))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createItemWithDoubleCondition('Packs', 'AUTO/OFF', globalProperty('1-sim/cond/leftPackSelector'),2, CH_LESS, globalProperty('1-sim/cond/rightPackSelector'), 2, CH_LESS, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createCheckItem('Flaps', 'SET'))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createCheckItem('Stabilizer Trim', 'SET'))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createCheckItem('Flight controls', 'CHECKED'))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createCheckItem('Cabin', 'SECURED'))
-- addItem(list['NORMAL']['BEFORE TAKEOFF'], createItemWithDoubleCondition('TAXI (RUNWAY TURNOFF) light switches', 'OFF', globalProperty('1-sim/lights/runwayL/switch'),0, CH_EQUAL, globalProperty('1-sim/lights/runwayR/switch'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))


-- addList(list, {'NORMAL','AFTER TAKEOFF'})
-- addItem(list['NORMAL']['AFTER TAKEOFF'], createItemWithDoubleCondition('Packs', 'AUTO', globalProperty('1-sim/cond/leftPackSelector'),1, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['AFTER TAKEOFF'], createItemWithCondition('Landing gear','UP', globalProperty('sim/cockpit/switches/gear_handle_status'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['AFTER TAKEOFF'], createItemWithCondition('Flaps','UP', globalProperty('sim/flightmodel2/controls/flap_handle_deploy_ratio'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['AFTER TAKEOFF'], createCheckItem('Altimeters', 'SET'))


-- addList(list, {'AMPLIFIED','CLIMB & CRUISE'})
-- addItem(list['AMPLIFIED']['CLIMB & CRUISE'], createCheckItem('TMCP', 'CLB'))
-- addItem(list['AMPLIFIED']['CLIMB & CRUISE'], createCheckItem('WX RADAR', 'As Req'))
-- addItem(list['AMPLIFIED']['CLIMB & CRUISE'], createCheckItem('WIND LANDING LIGHTS', 'OFF passing 10000 MSL'))
-- addItem(list['AMPLIFIED']['CLIMB & CRUISE'], createCheckItem('NO SMOKING/SEATBELTS', 'OFF as req'))
-- addItem(list['AMPLIFIED']['CLIMB & CRUISE'], createCheckItem('Monitor fuel flows', 'OFF as req'))

-- addList(list, {'AMPLIFIED','DESCENT'}) --tested
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('Landing altitude', 'Set'))
-- addItem(list['AMPLIFIED']['DESCENT'], createItemWithCondition('EICAS messages','RECALL', globalProperty('1-sim/gauges/caution_recall'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('Arrival', 'INSTALLED IN FMS'))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('Radios (NAV, ILS, ADF & Comm)', 'TUNED'))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('Landing flaps', 'SELECTED IN FMS'))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('VREF', 'ENTERED'))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('DH REF', 'SET'))
-- addItem(list['AMPLIFIED']['DESCENT'], createCheckItem('Autobrake', 'SET AS REQURED'))

-- addList(list, {'NORMAL','DESCENT'})
-- addItem(list['NORMAL']['DESCENT'], createCheckItem('Pressurization', 'LDG'))
-- addItem(list['NORMAL']['DESCENT'], createCheckItem('Recall', 'CHECKED'))
-- addItem(list['NORMAL']['DESCENT'], createCheckItem('Autobrake', 'SET'))
-- addItem(list['NORMAL']['DESCENT'], createCheckItem('Landing data', 'VREF'))
-- addItem(list['NORMAL']['DESCENT'], createCheckItem('Approach briefing', 'COMPLETED'))

-- addList(list, {'AMPLIFIED','APPROACH'})
-- addItem(list['AMPLIFIED']['APPROACH'], createItemWithDoubleCondition('NO SMOKING/SEATBELTS','ON', globalProperty('sim/cockpit/switches/fasten_seat_belts'), 2, CH_EQUAL, globalProperty('sim/cockpit/switches/no_smoking'), 2, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['APPROACH'], createCheckItem('WIND LANDING LIGHTS', 'ON passing 10000 MSL'))
-- addItem(list['AMPLIFIED']['APPROACH'], createCheckItem('Altimeters', 'QNH set & crosschecked passing Transitin Level'))
-- addItem(list['AMPLIFIED']['APPROACH'], createCheckItem('Arrival & Approach', 'Updated in FMC as req'))

-- addList(list, {'NORMAL','APPROACH'})
-- addItem(list['NORMAL']['APPROACH'], createCheckItem('Altimeters', 'CHECK'))
-- addItem(list['NORMAL']['APPROACH'], createCheckItem('Nav aids', 'SET'))

-- addList(list, {'NORMAL','LANDING'})
-- addItem(list['NORMAL']['LANDING'], createCheckItem('Cabin', 'SECURED'))
-- addItem(list['NORMAL']['LANDING'], createItemWithCondition('Speedbrake','ARMED', globalProperty('sim/cockpit2/controls/speedbrake_ratio'), 0, CH_LESS, CH_DEFAULT))
-- addItem(list['NORMAL']['LANDING'], createItemWithCondition('Landing gear','DOWN', globalProperty('1-sim/cockpit/switches/gear_handle'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['LANDING'], createItemWithCondition('Flaps','SET', globalProperty('sim/flightmodel2/controls/flap_handle_deploy_ratio'), 0, CH_LARGER, CH_DEFAULT))

-- addList(list, {'AMPLIFIED','AFTER LANDING'}) --tested
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createIfItem('APU Generator','ON', globalProperty('params/gpu'), 1, CH_LARGER, globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('anim/15/button'), 1, CH_EQUAL, CH_DEFAULT), 'Skip if external power is available', CH_BELOW)
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createIfItem('APU selector','START', globalProperty('params/gpu'), 1, CH_LARGER, globalProperty('anim/16/button'), 1, CH_EQUAL, globalProperty('1-sim/engine/APUStartSelector'), 2, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createCheckItem('Electrical power APU/GPU', 'VERIFY'))
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createCheckItem('Exteriour Lights', 'CHECK'), 'Set as needed', CH_BELOW)
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createItemWithCondition('Flap lever','UP', globalProperty('sim/cockpit2/controls/flap_ratio'), 0, CH_EQUAL, CH_DEFAULT)) --check it
-- addItem(list['AMPLIFIED']['AFTER LANDING'], createItemWithCondition('Transponder','STBY', globalProperty('1-sim/transponder/systemMode'), 1, CH_EQUAL, CH_DEFAULT))

-- addList(list, {'AMPLIFIED','SHUTDOWN'}) --tested
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('Parking brake','SET', globalProperty('sim/cockpit2/controls/parking_brake_ratio'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the PARK BRAKE light is illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('WING ANTI ICE switch','OFF', globalProperty('anim/40/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('ENGINE ANTI ICE switches','OFF', globalProperty('anim/41/button'), 0, CH_EQUAL, globalProperty('anim/42/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('FUEL CONTROL switches','CUTOFF', globalProperty('1-sim/fuel/fuelCutOffLeft'), 0, CH_EQUAL, globalProperty('1-sim/fuel/fuelCutOffRight'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('SEATBELTS selector','OFF', globalProperty('sim/cockpit/switches/fasten_seat_belts'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createTextItem('Hydraulic panel', CH_BLUE))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('Left ELECTRIC pump switch','ON', globalProperty('anim/13/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('C1 C2 ELECTRIC pump switches','ON', globalProperty('anim/9/button'), 1, CH_EQUAL, globalProperty('anim/10/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('Right ELECTRIC pump switch','ON', globalProperty('anim/12/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createTextItem('Fuel panel', CH_BLUE))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('L FUEL PUMP switches','OFF', globalProperty('anim/32/button'), 0, CH_EQUAL, globalProperty('anim/35/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('R FUEL PUMP switches','OFF', globalProperty('anim/34/button'), 0, CH_EQUAL, globalProperty('anim/37/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('C FUEL PUMP switches','OFF', globalProperty('anim/38/button'), 0, CH_EQUAL, globalProperty('anim/39/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('RED ANTI COLLISION light switch','OFF', globalProperty('anim/44/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('ISOLATION switch','ON', globalProperty('anim/59/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithDoubleCondition('FLIGHT DIRECTOR switches','OFF', globalProperty('1-sim/AP/fd1Switcher'), 1, CH_EQUAL, globalProperty('1-sim/AP/fd2Switcher'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('Wheel chocks','PLACE', globalProperty('params/stop'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SHUTDOWN'], createItemWithCondition('Flight deck door','UNLOCKED', globalProperty('1-sim/cockpitDoor/switch'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that the flight deck door UNLKD lights are illuminated', CH_BELOW)

-- addList(list, {'NORMAL','SHUTDOWN'})
-- addItem(list['NORMAL']['SHUTDOWN'], createCheckItem('Hydraulic panel SET', 'CHECK'))
-- addItem(list['NORMAL']['SHUTDOWN'], createCheckItem('Fuel pumps OFF', 'CHECK'))
-- addItem(list['NORMAL']['SHUTDOWN'], createItemWithCondition('Flaps','UP', globalProperty('sim/flightmodel2/controls/flap_handle_deploy_ratio'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SHUTDOWN'], createItemWithCondition('Parking brake','SET', globalProperty('sim/cockpit2/controls/parking_brake_ratio'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SHUTDOWN'], createItemWithDoubleCondition('Fuel control switches', 'CUTOFF', globalProperty('1-sim/fuel/fuelCutOffLeft'),0, CH_EQUAL, globalProperty('1-sim/fuel/fuelCutOffRight'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['SHUTDOWN'], createCheckItem('Weather radar', 'OFF'))

-- addList(list, {'AMPLIFIED','SECURE'}) --tested
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('L IRS mode selector','OFF', globalProperty('1-sim/irs/1/modeSel'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('C IRS mode selector','OFF', globalProperty('1-sim/irs/2/modeSel'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('R IRS mode selector','OFF', globalProperty('1-sim/irs/3/modeSel'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('EMERGENCY LIGHTS switch','UNGUARDED', globalProperty('1-sim/emer/lightsCover'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('EMERGENCY LIGHTS switch','OFF', globalProperty('1-sim/emer/lights'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithDoubleCondition('L WINDOW HEAT switches','OFF', globalProperty('anim/47/button'), 0, CH_EQUAL, globalProperty('anim/48/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithDoubleCondition('R WINDOW HEAT switches','OFF', globalProperty('anim/49/button'), 0, CH_EQUAL, globalProperty('anim/50/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithDoubleCondition('PACK CONTROL selectors','OFF', globalProperty('1-sim/cond/leftPackSelector'), 0, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('Front Exterior door','OPENED', globalPropertyiae('sim/cockpit2/switches/custom_slider_on', 1), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['SECURE'], createItemWithCondition('Main cargo door','OPENED', globalPropertyiae('sim/cockpit2/switches/custom_slider_on', 3), 1, CH_EQUAL, CH_DEFAULT))

-- addList(list, {'NORMAL','SECURE'})
-- addItem(list['NORMAL']['SECURE'], createCheckItem('IRSs OFF', 'CHECK'))
-- addItem(list['NORMAL']['SECURE'], createItemWithCondition('Emergency lights','OFF', globalProperty('1-sim/emer/lights'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithDoubleCondition('Window heat left', 'OFF', globalProperty('anim/47/button'),0, CH_EQUAL, globalProperty('anim/48/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithDoubleCondition('Window heat right', 'OFF', globalProperty('anim/49/button'),0, CH_EQUAL, globalProperty('anim/50/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithDoubleCondition('Packs', 'OFF', globalProperty('1-sim/cond/leftPackSelector'),0, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithCondition('External power','SET', globalProperty('params/gpu'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithCondition('APU','OFF', globalProperty('sim/cockpit/engine/APU_N1'), 5, CH_LESS, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithCondition('Standby power selector','OFF', globalProperty('1-sim/electrical/stbyPowerSelector'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createItemWithCondition('Battery','OFF', globalProperty('anim/14/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['NORMAL']['SECURE'], createCheckItem('Ground service bus', 'CHECK'))



-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
-- coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	-- function () 
		-- kc_macro_state_cold_and_dark()
		-- if activePrefSet:get("general:sges") == true then
			-- kc_macro_start_sges_sequence()
		-- end
		-- getActiveSOP():setActiveFlowIndex(1)
	-- end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
-- turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	-- function () 
		-- kc_macro_state_turnaround()
		-- if activePrefSet:get("general:sges") == true then
			-- kc_macro_start_sges_sequence()
		-- end
	-- end))
-- turnAroundProc:addItem(ProcedureItem:new("GPU","ON BUS","SYS",0,true,
	-- function () 
		-- command_once("laminar/B738/toggle_switch/gpu_dn")
		-- electricalPowerUpProc:setState(Flow.FINISH)
		-- prelPreflightProc:setState(Flow.FINISH)
		-- getActiveSOP():setActiveFlowIndex(3)
	-- end))

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

-- kc_procvar_initialize_bool("toctest", false) -- B738 takeoff config test

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		-- if kc_procvar_get("toctest") == true then 
			-- kc_bck_b738_toc_test("toctest")
		-- end
	end))
	


-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
activeSOP:addProcedure(preflightFOProc)

-- =========== States ===========
-- activeSOP:addState(turnAroundProc)
-- activeSOP:addState(coldAndDarkProc)
-- activeSOP:addState(recoverTakeoff)

function getActiveSOP()
	return activeSOP
end

return SOP_B7x7
