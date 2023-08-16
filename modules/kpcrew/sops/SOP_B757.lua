-- Base SOP for FlightFactor B757

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

-- addList(list, {'AMPLIFIED'}) --tested
-- addList(list, {'AMPLIFIED','POWER-UP'})
-- addItem(list['AMPLIFIED']['POWER-UP'], createItemWithCondition('Battery switch','ON', globalProperty('anim/14/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['POWER-UP'], createItemWithCondition('Standby Power selector','AUTO', globalProperty('1-sim/electrical/stbyPowerSelector'), 1, CH_EQUAL, CH_DEFAULT), 'Verify APU BAT DISCH and MAIN BAT DISCH lights illuminated and standby bus OFF light extinguishes', CH_BELOW)
-- addItem(list['AMPLIFIED']['POWER-UP'], createItemWithCondition('Landing Gear Lever','DN', globalProperty('1-sim/cockpit/switches/gear_handle'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['POWER-UP'], createItemWithCondition('Alt Flaps selector','NORM', globalProperty('1-sim/gauges'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['POWER-UP'], createCheckItem('Electrical Power', 'ESTABLISH'))
-- addItem(list['AMPLIFIED']['POWER-UP'], createItemWithDoubleCondition('Bus Tie switches', 'AUTO', globalProperty('anim/17/button'),1, CH_EQUAL, globalProperty('anim/18/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['POWER-UP'], createIfItem('APU Generator','ON', globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('anim/15/button'), 1, CH_EQUAL, CH_DEFAULT), 'Skip if external power is available', CH_BELOW)
-- addItem(list['AMPLIFIED']['POWER-UP'], createIfItem('APU selector','START', globalProperty('params/gpu'), 1, CH_EQUAL, globalProperty('anim/16/button'), 1, CH_EQUAL, globalProperty('1-sim/engine/APUStartSelector'), 2, CH_EQUAL, CH_DEFAULT), 'Use EXT PWR switch instead if available. Position the APU selector back to the ON position, do not allow the APU Selector to spring back to the ON position', CH_BELOW)

-- addList(list, {'AMPLIFIED','PRELIMINARY PREFLIGHT'})
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createTextItem('The Preliminary Preflight Procedure assumes that the Electrical Power Up supplementary procedure is complete'))
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createItemWithCondition('L IRS mode selector','NAV', globalProperty('1-sim/irs/1/modeSel'), 2, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createItemWithCondition('C IRS mode selector','NAV', globalProperty('1-sim/irs/2/modeSel'), 2, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PRELIMINARY PREFLIGHT'], createItemWithCondition('R IRS mode selector','NAV', globalProperty('1-sim/irs/3/modeSel'), 2, CH_EQUAL, CH_DEFAULT), 'Verify that the ON DC lights illuminate then extinguish [next] Verify that the ALIGN lights are illuminated', CH_BELOW)
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


-- addList(list, {'AMPLIFIED','PREFLIGHT CONTROLLING'}) --tested
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('YAW DAMPER switches', 'ON', globalProperty('anim/1/button'),1, CH_EQUAL, globalProperty('anim/2/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'The INOP lights stay illuminated until IRS alignment is complete', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('EEC switches', 'ON', globalProperty('anim/3/button'),1, CH_EQUAL, globalProperty('anim/4/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Hydraulic panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('SYS PRESS lights', 'CHECK'), 'Verify lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('Left and Right ENGINE pump switches', 'ON', globalProperty('anim/8/button'),1, CH_EQUAL, globalProperty('anim/11/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the PRESS lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('L R ELECTRIC pumps', 'OFF', globalProperty('anim/12/button'),0, CH_EQUAL, globalProperty('anim/13/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('C1 C2 ELECTRIC pumps', 'OFF', globalProperty('anim/9/button'),0, CH_EQUAL, globalProperty('anim/10/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the PRESS lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('ELT switch','ARMED', globalProperty('1-sim/elt/mode'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the ON light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Electrical panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('BATTERY switch','ON', globalProperty('anim/14/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('STANDBY POWER selector','AUTO', globalProperty('1-sim/electrical/stbyPowerSelector'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the standby power bus OFF light is  extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('APU GENERATOR switch','ON', globalProperty('anim/15/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('BUS TIE switches', 'AUTO', globalProperty('anim/17/button'),1, CH_EQUAL, globalProperty('anim/18/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the AC BUS OFF lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('UTILITY BUS switches', 'ON', globalProperty('anim/20/button'),1, CH_EQUAL, globalProperty('anim/21/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the OFF lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('GENERATOR CONTROL switches', 'ON', globalProperty('anim/22/button'),1, CH_EQUAL, globalProperty('anim/25/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the OFF lights are illuminated [next] Verify that the DRIVE lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('APU selector','START', globalProperty('sim/cockpit2/electrical/APU_N1_percent'), 30, CH_LESS, globalProperty('1-sim/engine/APUStartSelector'), 2, CH_EQUAL, globalProperty('1-sim/engine/APUStartSelector'), 1, CH_EQUAL, CH_DEFAULT), 'Do not allow the APU selector to spring back to the [next] ON position [next] Verify that the RUN light is illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Lighting panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('RUNWAY TURNOFF light switches', 'OFF', globalProperty('1-sim/lights/runwayL/switch'),0, CH_EQUAL, globalProperty('1-sim/lights/runwayR/switch'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('EMERGENCY LIGHTS switch','GUARDED', globalProperty('1-sim/emer/lightsCover'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('EMERGENCY LIGHTS switch','ARMED', globalProperty('1-sim/emer/lights'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the UNARMED light is extinguished [next] Note: Do not push the PASSENGER OXYGEN switch, the switch causes deployment of the passenger oxygen masks', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('PASSENGER OXYGEN ON light', 'CHECK'), 'Verify extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("WARNING: Do not push the RAM AIR TURBINE switch, The switch causes deployment of the ram air turbine"))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Ram air turbine UNLKD light', 'VERIFY'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Engine control panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('Engine limiter buttons', 'ON', globalProperty('anim/30/button'),1, CH_EQUAL, globalProperty('anim/31/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('Engine start selectors', 'AUTO', globalProperty('1-sim/engine/leftStartSelector'),1, CH_EQUAL, globalProperty('1-sim/engine/rightStartSelector'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("FUEL panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('CROSSFEED switches', 'OFF', globalProperty('anim/33/button'),0, CH_EQUAL, globalProperty('anim/36/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the VALVE lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('L FUEL PUMP switches', 'OFF', globalProperty('anim/32/button'),0, CH_EQUAL, globalProperty('anim/32/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('R FUEL PUMP switches', 'OFF', globalProperty('anim/34/button'),0, CH_EQUAL, globalProperty('anim/37/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('C FUEL PUMP switches', 'OFF', globalProperty('anim/38/button'),0, CH_EQUAL, globalProperty('anim/39/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the left forward pump PRESS light is extinguished if the APU is on or is illuminated if the APU is off, Verify that the other left and right pump PRESS lights are illuminated [next] Verify that both center pump PRESS lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("ANTI ICE panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('WING anti ice switch','OFF', globalProperty('anim/40/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('ENGINE anti ice switches', 'OFF', globalProperty('anim/41/button'),0, CH_EQUAL, globalProperty('anim/42/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('WIPER selector','OFF', globalProperty('anim/rhotery/10'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Lighting panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('POSITION light switch','ON', globalProperty('anim/43/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('ANTI COLLISION light switches', 'OFF', globalProperty('anim/44/button'),0, CH_EQUAL, globalProperty('anim/45/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('WING light switch', 'AS NEEDED'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('L R LANDING light switches', 'OFF', globalProperty('1-sim/lights/landingL/switch'),0, CH_EQUAL, globalProperty('1-sim/lights/landingR/switch'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('N LANDING light switches','OFF', globalProperty('1-sim/lights/landingN/switch'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('L WINDOW HEAT switches', 'ON', globalProperty('anim/47/button'),1, CH_EQUAL, globalProperty('anim/48/button'),1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('R WINDOW HEAT switches', 'ON', globalProperty('anim/49/button'),1, CH_EQUAL, globalProperty('anim/50/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the INOP lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Passenger signs panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('NO SMOKING selector','AUTO', globalProperty('sim/cockpit/switches/no_smoking'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('SEATBELTS selector','AUTO', globalProperty('sim/cockpit/switches/fasten_seat_belts'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Cabin Altitude panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('AUTO RATE control', 'SET'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('LANDING ALT selector', 'SET'), 'Destination airport elevation', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('MODE SELECTOR','AUTO', globalProperty('1-sim/press/modeSelector'), 2, CH_LESS, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('ALTN EQUIP COOLING switch','OFF', globalProperty('anim/51/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Air conditioning panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('FWD CABIN temperature controls','AUTO', globalProperty('1-sim/cond/fwdTempControl'), 0.50, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('AFT CABIN temperature controls','AUTO', globalProperty('1-sim/cond/aftTempControl'), 0.50, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('FLIGHT DECK CABIN temperature controls','AUTO', globalProperty('1-sim/cond/fltdkTempControl'), 0.50, CH_EQUAL, CH_DEFAULT), 'The INOP lights stay illuminated until the trim air switch is ON', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('TRIM AIR switch','ON', globalProperty('anim/54/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('RECIRCULATION FAN switches', 'ON', globalProperty('anim/55/button'),1, CH_EQUAL, globalProperty('anim/56/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the INOP lights are extinguished.', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('PACK CONTROL selectors', 'AUTO', globalProperty('1-sim/cond/leftPackSelector'),1, CH_EQUAL, globalProperty('1-sim/cond/rightPackSelector'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'The PACK OFF lights stay illuminated until bleed air or external air is supplied', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Bleed air panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('ISOLATION switch','ON', globalProperty('anim/59/button'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the VALVE light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('ENGINE bleed air switches', 'ON', globalProperty('anim/60/button'),1, CH_EQUAL, globalProperty('anim/62/button'), 1, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT), 'Verify that the OFF lights are illuminated', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('APU bleed air switch','ON', globalProperty('anim/61/button'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the VALVE light is extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('FLIGHT DIRECTOR switch','ON', globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('1-sim/AP/fd1Switcher'), 0, CH_EQUAL, globalProperty('1-sim/AP/fd2Switcher'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('VOR/DME switch','AUTO', globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('anim/78/button'), 1, CH_EQUAL, globalProperty('anim/79/button'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('Oxygen','TEST', globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('misc/oxyTest'), 1, CH_EQUAL, globalProperty('misc/oxyTest/622'), 1, CH_EQUAL, CH_DEFAULT), 'Select the status display [next] Oxygen mask stowed and doors closed', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Crew oxygen pressure', 'CHECK'), 'Check EICAS', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Instrument source select panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('NAVIGATION instrument source selector','SET', globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/navSel_right'), 1, CH_EQUAL, globalProperty('1-sim/gauges/navSel_left'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('FLIGHT DIRECTOR source selector','SET', globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/flightDirSel_right'), 0, CH_EQUAL, globalProperty('1-sim/gauges/flightDirSel_left'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('ELECTRONIC FLIGHT INSTRUMENT button','OFF', globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('anim/76/button'), 0, CH_EQUAL, globalProperty('anim/67/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('INERTIAL REFERENCE SYSTEM button','OFF', globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('anim/77/button'), 0, CH_EQUAL, globalProperty('anim/68/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('AIR DATA source button','OFF', globalProperty('params/constrol'), 1, CH_EQUAL, globalProperty('1-sim/gauges/airdataAltnClick_right'), 0, CH_EQUAL, globalProperty('1-sim/gauges/airdataAltnClick_left'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Flight instruments', 'CHECK'), 'Set the altimeter [next] Verify that the flight instrument indications are correct', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Verify that only these flags are shown:"), "TCAS expected RDMI flags", CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Verify that the flight mode annunciations are correct:"), "autothrottle mode is blank [next] roll mode is TO [next] pitch mode is TO [next] AFDS status is FD", CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('AUTOLAND STATUS annunciator', 'CHECK'), 'Verify that the indications are blank', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Landing gear panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('Landing gear lever','DN', globalProperty('1-sim/cockpit/switches/gear_handle'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('ALTERNATE GEAR switch','GUARDED', globalProperty('1-sim/gauges/altnGearCover'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('GPWS FLAP OVERRIDE switch','OFF', globalProperty('anim/72/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('GPWS GEAR OVERRIDE switch','OFF', globalProperty('anim/74/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('GPWS TERR OVERRIDE switch','OFF', globalProperty('anim/75/button'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('HEADING REFERENCE switch','NORM', globalProperty('1-sim/gauges/hdgRefSwitcher'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Alternate flaps panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('ALTERNATE FLAPS selector','NORM', globalProperty('1-sim/gauges/flapsALTNswitcher'), 0, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('Alternate flaps switches','OFF', globalProperty('anim/70/button'), 0, CH_EQUAL, globalProperty('anim/71/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT)) --check conditions
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("EICAS display", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Upper EICAS display', 'CHECK'), 'Verify that the primary engine indications show existing conditions [next] Verify that no exceedance is shown', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Secondary ENGINE indications', 'CHECK'), 'Verify that the secondary engine indications show existing conditions [next] Verify that no exceedance is shown', CH_BELOW) --OK
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('STATUS display','SELECT', globalProperty('1-sim/eicas/StatusFlag'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('COMPUTER selector','AUTO', globalProperty('1-sim/eicas/compSelector'), 1, CH_EQUAL, CH_DEFAULT))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithCondition('THRUST REFERENCE selector','BOTH', globalProperty('1-sim/eicas/thrustRefSetRotary'), 1, CH_EQUAL, CH_DEFAULT), 'Verify that the TO mode is shown', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("EFIS control panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Decision height selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('TERRAIN switch', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI RANGE selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI TRAFFIC switch', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI mode selector', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('HSI CENTER switch', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createIfItem('WXR RADAR switch','OFF', globalProperty('params/constrol'), 0, CH_EQUAL, globalProperty('1-sim/ndpanel/1/hsiWxr'), 0, CH_EQUAL, globalProperty('1-sim/ndpanel/2/hsiWxr'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that weather radar indications are not shown on the HSI', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Left VHF communications panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('ADF panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Engine fire panel', 'CHECK'), 'Verify that the ENG BTL 1 DISCH and ENG BTL 2 DISCH lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Engine fire switches', 'IN', globalProperty('1-sim/fire/right/EngExtHandle'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that the LEFT and RIGHT lights are extinguished', CH_BELOW)
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('Transponder panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('ILS panel', 'CHECK'))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("Cargo Fire panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createItemWithDoubleCondition('CARGO FIRE ARM switches','OFF', globalProperty('anim/63/button'), 0, CH_EQUAL, globalProperty('anim/64/button'), 0, CH_EQUAL, CH_CONTACT_AND, CH_DEFAULT),'Verify that the FWD and AFT lights are extinguished [next] Verify that the DISCH lights are extinguished', CH_BELOW )
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createTextItem("APU fire panel", CH_BLUE))
-- addItem(list['AMPLIFIED']['PREFLIGHT CONTROLLING'], createCheckItem('APU fire switch', 'IN', globalProperty('1-sim/fire/apu/EngExtHandle'), 0, CH_EQUAL, CH_DEFAULT), 'Verify that the APU light is extinguished', CH_BELOW)
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
addItem(list['AMPLIFIED']['BEFORE START PROCEDURE'], createIfItem('L CENTER FUEL PUMP switches','AS REQUIRED', globalPropertyfae('sim/flightmodel/weight/m_fuel', 2), 545, CH_LARGER, globalProperty('anim/38/button'), 1, CH_EQUAL, globalProperty('anim/38/button'), 1, CH_EQUAL, CH_DEFAULT))
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




-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

activeSOP:addProcedure(testProc)
-- activeSOP:addProcedure(electricalPowerUpProc)
-- activeSOP:addProcedure(prelPreflightProc)

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
