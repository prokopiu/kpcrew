-- Base SOP for Laminar MD-82

-- @classmod SOP_MD82
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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
set("sim/private/controls/shadow/cockpit_near_adjust",1)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = SOP:new("Laminar MD-82 SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)


-- =========== PRELIMINARY COCKPIT PREPARATION ===========
-- === COCKPIT SAFETY INSPECTION (CM2)
-- BATTERY SWITCH...........................ON/LOCK   (FO)
-- METER SELECTOR.........................BATT VOLT   (FO)
-- BATTERY.........................CHECK ABOVE 25 V   (FO)
-- WING/NACL LIGHTS..............................ON   (FO)
-- DC TRANSFER BUS OFF LIGHT....................OFF   (FO)
-- WINDSHIELD WIPER SELECTORS...................OFF   (FO)
-- LANDING GEAR LEVER..........................DOWN   (FO)
-- AUX HYD PUMP SWITCH..........................OFF   (FO)
-- FLAP/SLAT LEVER...........................UP/RET   (FO)
-- SPEED BRAKE LEVER...........RETRACTED & DISARMED   (FO)
-- CIRCUIT BREAKERS....................CHECK ALL IN   (FO)
-- PARKING BRAKE.................................ON   (FO)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (FO)

-- === PRELIMINARY COCKPIT PREPARATION (CM2)
-- EXT POWER................................CONNECT   (FO)
-- EXT PWR L & R.............................ON BUS   (FO)

-- ===== IF APU REQUIRED NOW                           
-- FIRE LOOP TEST...........................PERFORM   (FO)
-- ANTI COLLISION LIGHT..........................ON   (FO)
-- START PUMP SW (DC)............................ON   (FO)
-- APU START SW...............................START   (FO)
--   APU STARTER LIGHT ON WAAP..........ILLUMINATED   (FO)
--   APU PWR AVAIL......................ILLUMINATED   (FO)
--   APU POWER 115V & 400HZ...................CHECK   (FO)
--   APU L & R BUS...............................ON   (FO)
--   APU POWER CONSUMPTION..........CHECK BELOW 1.0   (FO)
--   === AIR CONDITIONING SYSTEM AS REQUIRED
--   APU AIR.....................................ON   (FO)
--   PNEU-X-FEED..........................BOTH OPEN   (FO)
--   RIGHT AFT FUEL PUMP SW......................ON   (FO)
--   APU NORMAL/ECONOMY SWITCH.................ECON
--   AIR COND SUPPLY LEFT......................AUTO   (FO)
--   AIR COND SUPPLY RIGHT.....................AUTO   (FO)
--   CABIN TEMPERATURE SELECTORS...AUTO
--   START PUMP SW (DC).........................OFF   (FO)
-- EMERGENCY LIGHTS TEST....................PERFORM   (FO)
-- EMERGENCY LIGHTS SWITCH......................ARM   (FO)
-- EMER LIGHT.............................NOT ARMED   (FO)
-- INSTRUMENT LIGHTING..........................SET   (FO)
-- ANNUNCIATOR/DIGITAL LIGHTS..................TEST   (FO)
-- CABIN PRESS CONTROL LEVER...........CHECK & AUTO   (FO)
-- AILERON TRIM................................FREE   (FO)
-- RUDDER TRIM.................................ZERO   (FO)
-- =======================================================
local prelCockpitPrep = Procedure:new("PRELIMINARY COCKPIT PREP","","")
prelCockpitPrep:setFlightPhase(2)
prelCockpitPrep:addItem(SimpleProcedureItem:new("=== COCKPIT SAFETY INSPECTION (CM2)"))

prelCockpitPrep:addItem(IndirectProcedureItem:new("BATTERY SWITCH","ON/LOCK",FlowItem.actorFO,0,"battswitch_safe",
	function () return 
		get("sim/cockpit/electrical/battery_on") == 1 and
		get("laminar/md82/safeguard",3) == 1
	end,
	function () 
		command_once("sim/electrical/battery_1_on")
		if get("laminar/md82/safeguard",3) == 0 then 
			command_once("laminar/md82cmd/safeguard03")
		end
		kc_macro_lights_preflight()
		kc_macro_doors_preflight()
		sysGeneral.doorL2:actuate(1)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("METER SELECTOR","BATT VOLT",FlowItem.actorFO,0,
	function () return get("laminar/md82/electrical/voltmeter_source") == 4 end,
	function () 
		while get("laminar/md82/electrical/voltmeter_source") ~= 4 do
			command_once("laminar/md82cmd/electrical/voltmeter_source_up")
		end
	end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 25V",FlowItem.actorFO,0,"bat24v",
	function () return get("sim/cockpit2/electrical/battery_voltage_actual_volts") > 23 end))
prelCockpitPrep:addItem(ProcedureItem:new("WING/NACL LIGHTS","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/generic_lights_switch",3) == 1 end,
	function () set_array("sim/cockpit2/switches/generic_lights_switch",3,1) end))
-- DC TRANSFER BUS OFF LIGHT....................OFF   (FO)
prelCockpitPrep:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
prelCockpitPrep:addItem(ProcedureItem:new("AUX HYD PUMP SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("FLAP/SLAT LEVER","UP/RET",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:actuate(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE LEVER","RETRACTED & DISARMED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (FO)

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== PRELIMINARY COCKPIT PREPARATION (CM2)"))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuOnBus:getStatus() == 1
	end,
	function () kc_macro_gpu_connect() end))
-- EXT PWR L & R.............................ON BUS   (FO)
prelCockpitPrep:addItem(ProcedureItem:new("EXT PWR L & R","ON BUS",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuGenBus1:getStatus() == 1 and
		sysElectric.gpuGenBus2:getStatus() == 1
	end))
prelCockpitPrep:addItem(ProcedureItem:new("INSTRUMENT LIGHTING","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_preflight()
	end))
prelCockpitPrep:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () sysLights.positionSwitch:actuate(1) end))
	
prelCockpitPrep:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("FIRE LOOPS A TEST","TEST",FlowItem.actorFO,12,"testloopa",
	function () return get("sim/cockpit2/annunciators/engine_fires",0) == 1 end,
	function () command_begin("sim/annunciator/test_fire_L_annun") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("FIRE LOOPS B TEST","TEST",FlowItem.actorFO,12,"testloopb",
	function () return get("sim/cockpit2/annunciators/engine_fires",1) == 1 end,
	function () 
		command_end("sim/annunciator/test_fire_L_annun") 
		command_begin("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("START PUMP SW (DC)","ON",FlowItem.actorFO,0,"startuppmpapu",
	function () return get("sim/cockpit/engine/fuel_pump_on",0) == 1 end,
	function () 
		set_array("sim/cockpit/engine/fuel_pump_on",0,1)
		command_end("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,7,"apupwrstart",
	function () return get("sim/cockpit/engine/APU_switch") > 0 end,
	function () set("sim/cockpit/engine/APU_switch",2) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_N1_percent") > 90 end,
	function () set("sim/cockpit/engine/APU_switch",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  #spell|APU# L & R BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBus1:getStatus() == 1 and
		sysElectric.apuGenBus2:getStatus() == 1 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  #spell|APU# POWER CONSUMPTION","CHECK BELOW 1.0",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/bus_load_amps") < 59.0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  #spell|APU# AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  RIGHT PNEU-X-FEED","OPEN",FlowItem.actorFO,0,
	function () return sysAir.bleedEng2Switch:getStatus() > 0 end,
	function () sysAir.bleedEng2Switch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  RIGHT AFT FUEL PUMP SW","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpRightAft:getStatus() > 0 end,
	function () 
		sysFuel.fuelPumpGroup:actuate(0)
		sysFuel.fuelPumpRightAft:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- • AIR pressure centure duct CHECK  ?? ?where
prelCockpitPrep:addItem(ProcedureItem:new("START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit/engine/fuel_pump_on",0) == 0 end,
	function () 
		set_array("sim/cockpit/engine/fuel_pump_on",0,0)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("EMERGENCY LIGHTS TEST","PERFORM",FlowItem.actorFO,0,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("EMERGENCY LIGHTS SWITCH","ARM",FlowItem.actorFO,0,true,nil))
prelCockpitPrep:addItem(IndirectProcedureItem:new("ANNUNCIATOR/DIGITAL LIGHTS","TEST",FlowItem.actorFO,10,"annuntest",
	function () return get("sim/cockpit/warnings/annunciator_test_pressed") == 1 end,
	function () command_begin("sim/annunciator/test_all_annunciators") end,
	function () return activeBriefings:get("flight:firstFlightDay") == true end))
prelCockpitPrep:addItem(ProcedureItem:new("EFIS","TEST",FlowItem.actorFO,0,true,
	function () command_end("sim/annunciator/test_all_annunciators") end))
prelCockpitPrep:addItem(ProcedureItem:new("CABIN PRESS CONTROL LEVER","CHECK & AUTO",FlowItem.actorFO,0,true))
prelCockpitPrep:addItem(ProcedureItem:new("AILERON TRIM","FREE",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/aileron_trim") == 0
	end,
	function () set("sim/cockpit2/controls/aileron_trim",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("RUDDER TRIM","ZERO",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/rudder_trim") == 0
	end,
	function () set("sim/cockpit2/controls/rudder_trim",0) end))
prelCockpitPrep:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEF","PERFORM",FlowItem.actorCPT))

-- ============ COCKPIT PREPARATION PROCEDURE ============
-- === CM1 (CPT)
-- PARKING BRAKE................................SET  (CPT)
-- WING LDG LTS & NOSE LTS SWITCHES ........RET/OFF  (CPT)
-- FGCP/FGS...............................CHECK/SET  (CPT)
-- FD SWITCH.............................MOVE TO FD  (CPT)  
-- AUTOPILOT...................................TEST  (CPT) 
-- AUTOPILOT SWITCH.............................OFF  (CPT)
-- FLIGHT & NAV INSTRUMENTS......CHECK first flight
-- EFIS........................................TEST  (CPT)
-- CLOCK..................................CHECK/SET  (CPT)
-- STATIC AIR SELECTOR........................ NORM  (CPT)
-- CREW OXYGEN & MASK....................TEST/CHECK  (CPT) 
-- PRIMARY STABILIZER TRIM.....................TEST  (CPT)
-- ALTERNATE STABILIZER TRIM...................TEST  (CPT)
-- === PF
-- RADIO AIDS...................................SET   (PF)
-- SPEED READOUT................................SET   (PF)   
-- HDG READOUT..................................SET   (PF)  
-- DFGS.........................................SET   (PF)  
-- ALT READOUT..................................SET   (PF) 
-- FMS SETUP...............................FINISHED   (PF)
-- =======================================================

local cockpitPrepProc1 = Procedure:new("COCKPIT PREPARATION CM1","","")
cockpitPrepProc1:setFlightPhase(3)

cockpitPrepProc1:addItem(HoldProcedureItem:new("FMS DATA ENTRY","PERFORM",FlowItem.actorCPT))
cockpitPrepProc1:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))

cockpitPrepProc1:addItem(ProcedureItem:new("WING LDG LTS & NOSE LTS SWITCHES","RET/OFF",FlowItem.actorCPT,0,
	function () return 
		get("sim/cockpit2/switches/landing_lights_switch",1) == -1 and
		get("sim/cockpit2/switches/landing_lights_switch",2) == -1 and
		get("sim/cockpit/electrical/taxi_light_on") == 0
	end,
	function () 
		set_array("sim/cockpit2/switches/landing_lights_switch",1,-1)
		set_array("sim/cockpit2/switches/landing_lights_switch",2,-1)
		set("sim/cockpit/electrical/taxi_light_on",0)
	end))
cockpitPrepProc1:addItem(ProcedureItem:new("FGCP/FGS","CHECK/SET",FlowItem.actorCPT,0,
	function () return kc_is_preflight_fgcp_checked() end,
	function () kc_macro_mcp_preflight() end))
cockpitPrepProc1:addItem(HoldProcedureItem:new("FLIGHT & NAV INSTRUMENTS","CHECK",FlowItem.actorCPT))
cockpitPrepProc1:addItem(ProcedureItem:new("CLOCK LEFT","CHECK/SET",FlowItem.actorCPT,0,
	function () return get("sim/time/timer_is_running_sec") == 0 end,
	function () set("sim/time/timer_is_running_sec",0) end))
cockpitPrepProc1:addItem(ProcedureItem:new("STATIC AIR SELECTOR LEFT","NORM",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/switches/alternate_static_air_ratio") == 0 end,
	function () set("sim/cockpit2/switches/alternate_static_air_ratio",0) end))
-- CREW OXYGEN & MASK....................TEST/CHECK  (CPT) not supported
-- PRIMARY STABILIZER TRIM.....................TEST  (CPT) not supported
-- ALTERNATE STABILIZER TRIM...................TEST  (CPT) not supported
cockpitPrepProc1:addItem(HoldProcedureItem:new("RADIO AIDS","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("SPEED READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("HDG READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("DFGS","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("ALT READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("FMS SETUP","FINISHED",FlowItem.actorCPT))

-- ============ COCKPIT PREPARATION PROCEDURE ============
-- === CM2 (FO)
-- APU Start
-- GROUND SERVICE POWER SWITCHES................OFF   (FO)
-- MAINTENANCE INTERPHONE SWITCH................OFF   (FO)
-- FLIGHT RECORDER/AIDS TEST....................SET   (FO)
-- FIRE SUPPRESSION SYSTEM (SDFSS).............TEST   (FO)
-- FIRE DETECTOR LOOPS SWITCHES............... BOTH   (FO)
-- INSTRUMENT TRANSFER SELECTORS.............NORMAL   (FO) 
-- WAGS........................................TEST   (FO)
-- ELECTRICAL SYSTEM..........................CHECK   (FO) 
-- EMERGENCY ELECTRICAL POWER..............TEST/OFF   (FO) 
-- APU PANEL..................................CHECK   (FO) 
-- ENG IGN SELECTOR.............................OFF   (FO)
-- FUEL SYSTEM.....................TEST/AS REQUIRED   (FO)  
-- EMERGENCY LIGHTS.............................ARM   (FO)
-- CABIN SIGNS................................ON/ON   (FO) 
-- PITOT AND STATIC HEATERS................TEST/OFF   (FO)
-- AIRFOIL & ENG ANTI-ICE SWITCHES..............OFF   (FO) 
-- WINDSHIELD ANTI-FOG SWITCH...................OFF   (FO)  
-- WINDSHIELD ANTI-ICE SWITCH....................ON   (FO)
-- ENG SYNC SELECTOR............................OFF   (FO)  
-- GND PROX WARN SWITCH........................NORM   (FO)  
-- STALL WARNING SYSTEM........................TEST   (FO) 
-- YAW DAMP SWITCH...............................ON   (FO) 
-- OVERSPEED WARNING SYSTEM....................TEST   (FO)
-- MACH TRIM COMP SWITCH.......................NORM   (FO)  
-- LOGO LIGHTS..........................AS REQUIRED   (FO)
-- CKPT & CABIN TEMP SELECTORS.............TEST/SET   (FO) 
-- RADIO RACK SWITCH............................FAN   (FO) 
-- CABIN PRESSURE CONTROLLER....................SET   (FO) 
-- AIR COND SHUTOFF SWITCH.....................AUTO   (FO)
-- RAM AIR SWITCH.......................AS REQUIRED   (FO)
-- LIGHTS.......................................SET   (FO)  
-- FGCP/FGS...............................CHECK/SET   (FO)   
-- ENG FIRE SHUTOFF HANDLES......................IN   (FO)  
-- FIRE PROTECTION SYSTEM......................TEST   (FO)  
-- REVERSE THRUST LIGHTS........................OFF   (FO)  
-- ENGINE INDICATORS..........................CHECK   (FO)  
-- FUEL USED READOUTS.........................RESET   (FO)  
-- ENGINE OIL INDICATORS......................CHECK   (FO) 
-- TRC.........................................TEST   (FO)  
-- FUEL QTY INDICATOR..........................TEST   (FO) 
-- GEAR DOOR OPEN LIGHT.........................OFF   (FO)
-- GEAR LIGHTS & AURAL WARNING.................TEST   (FO)  
-- TAS/SAT....................................CHECK   (FO) 
-- FLIGHT & NAVIGATION INSTRUMENTS.......TEST/CHECK   (FO) 
-- CLOCK..................................CHECK/SET   (FO)  
-- SDP........................................CHECK   (FO)   
-- HYDRAULIC SYSTEM............................TEST   (FO) 
-- Hydraulic System.............................SET   (FO)  
-- BRAKE TEMP INDICATOR....................TEST/ALL   (FO)
-- STATIC AIR SELECTOR.........................NORM   (FO)  
-- CREW OXYGEN AND MASK..................TEST/CHECK   (FO) 
-- PRIMARY STABILIZER TRIM.....................TEST   (FO)   
-- RADAR...................................TEST/OFF   (FO)
-- RUD HYD CONT LEVER...........................PWR   (FO)  
-- TAKEOFF WARNING / THRUST LEVERS........TEST/IDLE   (FO)  
-- FUEL SHUTOFF LEVERS..........................OFF   (FO)
-- FUEL X-FEED LEVER............................OFF   (FO)  
-- FLAP T.O. SELECTOR..........................STOW   (FO) 
-- ATC/TCAS................................SET/TEST   (FO)  
-- ADF.........................................TEST   (FO) 
-- =======================================================

local cockpitPrepProc2 = Procedure:new("COCKPIT PREPARATION CM2","","")
cockpitPrepProc2:setFlightPhase(3)

cockpitPrepProc2:addItem(IndirectProcedureItem:new("START PUMP SW (DC)","ON",FlowItem.actorFO,0,"startuppmpapu",
	function () return get("sim/cockpit/engine/fuel_pump_on",0) == 1 end,
	function () 
		set_array("sim/cockpit/engine/fuel_pump_on",0,1)
		command_end("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,7,"apupwrstart",
	function () return get("sim/cockpit/engine/APU_switch") > 0 end,
	function () set("sim/cockpit/engine/APU_switch",2) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_N1_percent") > 90 end,
	function () set("sim/cockpit/engine/APU_switch",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  #spell|APU# L & R BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBus1:getStatus() == 1 and
		sysElectric.apuGenBus2:getStatus() == 1 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  #spell|APU# POWER CONSUMPTION","CHECK BELOW 1.0",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/bus_load_amps") < 59.0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  #spell|APU# AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  RIGHT PNEU-X-FEED","OPEN",FlowItem.actorFO,0,
	function () return sysAir.bleedEng2Switch:getStatus() > 0 end,
	function () sysAir.bleedEng2Switch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("  RIGHT AFT FUEL PUMP SW","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpRightAft:getStatus() > 0 end,
	function () 
		sysFuel.fuelPumpGroup:actuate(0)
		sysFuel.fuelPumpRightAft:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
-- • AIR pressure centure duct CHECK  ?? ?where
cockpitPrepProc2:addItem(ProcedureItem:new("START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit/engine/fuel_pump_on",0) == 0 end,
	function () 
		set_array("sim/cockpit/engine/fuel_pump_on",0,0)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
cockpitPrepProc2:addItem(ProcedureItem:new("GROUND SERVICE POWER SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuOnBus:getStatus() == 0
	end,
	function ()
		kc_macro_gpu_disconnect()
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
-- MAINTENANCE INTERPHONE SWITCH................OFF   (FO) -- not supported
-- FLIGHT RECORDER/AIDS TEST....................SET   (FO) -- not supported
-- FIRE SUPPRESSION SYSTEM (SDFSS).............TEST   (FO) -- not supported
-- FIRE DETECTOR LOOPS SWITCHES............... BOTH   (FO) -- not supported
-- INSTRUMENT TRANSFER SELECTORS.............NORMAL   (FO) -- not supported
-- WAGS........................................TEST   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("EMERGENCY ELECTRICAL POWER","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/battery_on",1) == 0 end,
	function () set_array("sim/cockpit2/electrical/battery_on",1,0) end))	
cockpitPrepProc2:addItem(ProcedureItem:new("ENG IGN SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
-- FUEL SYSTEM.....................TEST/AS REQUIRED   (FO) -- not supported
-- EMERGENCY LIGHTS.............................ARM   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("CABIN SIGNS","ON/ON",FlowItem.actorFO,0,
	function () return 
		sysGeneral.noSmokingSwitch:getStatus() == 1 and
		sysGeneral.seatBeltSwitch:getStatus() == 1
	end,
	function ()  
		sysGeneral.noSmokingSwitch:actuate(1)
		sysGeneral.seatBeltSwitch:actuate(1)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("PITOT AND STATIC HEATERS","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ice/heatmeter") == 0 end,
	function () 
		while get("laminar/md82/ice/heatmeter") ~= 0 do
			command_once("laminar/md82cmd/ice/selheatknob_up")
		end
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("AIRFOIL & ENG ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit/switches/anti_ice_inlet_heat_per_engine",0) == 0 and
		get("sim/cockpit/switches/anti_ice_inlet_heat_per_engine",1) == 0 and
		get("sim/cockpit/switches/anti_ice_surf_heat_left") == 0 and
		get("sim/cockpit/switches/anti_ice_surf_heat_right") == 0
	end,
	function ()  
		set_array("sim/cockpit/switches/anti_ice_inlet_heat_per_engine",0,0)
		set_array("sim/cockpit/switches/anti_ice_inlet_heat_per_engine",1,0)
		set("sim/cockpit/switches/anti_ice_surf_heat_left",0)		
		set("sim/cockpit/switches/anti_ice_surf_heat_right",0) 
	end))
-- WINDSHIELD ANTI-FOG SWITCH...................OFF   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("WINDSHIELD ANTI-ICE SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
-- ENG SYNC SELECTOR............................OFF   (FO) -- not supported 
cockpitPrepProc2:addItem(ProcedureItem:new("GND PROX WARN SWITCH","TEST/NORM",FlowItem.actorFO,0,
	function () return get("laminar/md82/safeguard") == 0 end,
	function () 
		if get("laminar/md82/safeguard") == 0 then
			command_once("laminar/md82cmd/safeguard02")
		end
	end))
-- STALL WARNING SYSTEM........................TEST   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysMCP.yawDamper:getStatus() == 1 end,
	function () sysMCP.yawDamper:actuate(1) end))
-- OVERSPEED WARNING SYSTEM....................TEST   (FO) -- not supported
-- MACH TRIM COMP SWITCH.......................NORM   (FO) -- not supported 
cockpitPrepProc2:addItem(ProcedureItem:new("LOGO LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () 
		if kc_is_daylight() then
			return get("sim/cockpit2/switches/generic_lights_switch",0) == 0 
		else
			return get("sim/cockpit2/switches/generic_lights_switch",0) == 1
		end			
	end,
	function () 
		if kc_is_daylight() then
			set_array("sim/cockpit2/switches/generic_lights_switch",0,0)
		else
			set_array("sim/cockpit2/switches/generic_lights_switch",0,1)
		end			
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("CKPT & CABIN TEMP SELECTORS","SET",FlowItem.actorFO,0,
	function () 
		return 
			get("laminar/md82/bleedair/HVAC_L_knob") == 0 and
			get("laminar/md82/bleedair/HVAC_R_knob") == 0 
	end,
	function () 
		set("laminar/md82/bleedair/HVAC_L_knob",0)
		set("laminar/md82/bleedair/HVAC_R_knob",0)
	end))
-- RADIO RACK SWITCH............................FAN   (FO) -- not supported
-- CABIN PRESSURE CONTROLLER....................SET   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("AIR COND SHUTOFF SWITCH","AUTO",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 2 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 2  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	end))
-- RAM AIR SWITCH.......................AS REQUIRED   (FO) -- not supported
cockpitPrepProc2:addItem(ProcedureItem:new("ENG FIRE SHUTOFF HANDLES","IN",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/generic_lights_switch",3) == 1 end,
	function () kc_macro_lights_preflight()	end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("FIRE LOOPS A TEST","TEST",FlowItem.actorFO,12,"testloopa",
	function () return get("sim/cockpit2/annunciators/engine_fires",0) == 1 end,
	function () command_begin("sim/annunciator/test_fire_L_annun") end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("FIRE LOOPS B TEST","TEST",FlowItem.actorFO,12,"testloopb",
	function () return get("sim/cockpit2/annunciators/engine_fires",1) == 1 end,
	function () 
		command_end("sim/annunciator/test_fire_L_annun") 
		command_begin("sim/annunciator/test_fire_R_annun") 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("ENG FIRE SHUTOFF HANDLES","IN",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/engine/actuators/fire_extinguisher_on",0) == 0 and
		get("sim/cockpit2/engine/actuators/fire_extinguisher_on",1) == 0
	end,
	function ()
		command_end("sim/annunciator/test_fire_R_annun") 
		set_array("sim/cockpit2/engine/actuators/fire_extinguisher_on",0,0)
		set_array("sim/cockpit2/engine/actuators/fire_extinguisher_on",1,0)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("REVERSE THRUST LIGHTS","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/engine/reverse_all") == 0 end,
	function () set("laminar/md82/engine/reverse_all",0) end))
-- ENGINE INDICATORS..........................CHECK   (FO)  
-- FUEL USED READOUTS.........................RESET   (FO) -- not supported 
-- ENGINE OIL INDICATORS......................CHECK   (FO) 
-- TRC.........................................TEST   (FO) -- not supported 
-- FUEL QTY INDICATOR..........................TEST   (FO) -- not supported 
-- GEAR DOOR OPEN LIGHT.........................OFF   (FO) -- not supported
-- GEAR LIGHTS & AURAL WARNING.................TEST   (FO) -- not supported  
-- TAS/SAT....................................CHECK   (FO) 
-- FLIGHT & NAVIGATION INSTRUMENTS.......TEST/CHECK   (FO) 
-- CLOCK..................................CHECK/SET   (FO)  
-- SDP........................................CHECK   (FO)   
-- HYDRAULIC SYSTEM............................TEST   (FO) 
-- Hydraulic System.............................SET   (FO)  
-- BRAKE TEMP INDICATOR....................TEST/ALL   (FO)
-- STATIC AIR SELECTOR.........................NORM   (FO)  
-- CREW OXYGEN AND MASK..................TEST/CHECK   (FO) 
-- PRIMARY STABILIZER TRIM.....................TEST   (FO)   
-- RADAR...................................TEST/OFF   (FO)
-- RUD HYD CONT LEVER...........................PWR   (FO)  
-- TAKEOFF WARNING / THRUST LEVERS........TEST/IDLE   (FO)  
cockpitPrepProc2:addItem(ProcedureItem:new("FUEL SHUTOFF LEVERS","OFF",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/engine/actuators/mixture_ratio",0) == 0 and
		get("sim/cockpit2/engine/actuators/mixture_ratio",1) == 0
	end,
	function ()
		set_array("sim/cockpit2/engine/actuators/mixture_ratio",0,0)
		set_array("sim/cockpit2/engine/actuators/mixture_ratio",1,0)
	end))
-- FUEL X-FEED LEVER............................OFF   (FO)  
-- FLAP T.O. SELECTOR..........................STOW   (FO) 
-- ATC/TCAS................................SET/TEST   (FO)  
cockpitPrepProc2:addItem(ProcedureItem:new("ATC/TCAS","ABOVE/STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() <= 1 end,
	function () 
		sysRadios.xpdrSwitch:actuate(0) 
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end))
-- ADF.........................................TEST   (FO) 

-- ============== FINAL COCKPIT PREPARATION ==============
-- AHRS ALIGNMENT...........................CONFIRM  (CPT)
-- T.O. DATA FORM & TRC/ART..............CROSSCHECK  (CPT)
-- ALTIMETERS.....................SET & CROSS-CHECK (BOTH) 
-- PREFLIGHT BRIEFING.......................PERFORM  (CPT)
-- ND MODE & RANGE..........................AS RQRD  (CPT)
-- RADIO AIDS...............................X-CHECK  (CPT)   
-- FGCP.....................................X-CHECK  (CPT)
-- COCKPIT CREW CHECKLIST..................COMPLETE (BOTH)
-- =======================================================

local cockpitPrepProc3 = Procedure:new("FINAL COCKPIT PREPARATION","","")
cockpitPrepProc3:setFlightPhase(3)
-- AHRS ALIGNMENT...........................CONFIRM  (CPT) -- not supported
cockpitPrepProc3:addItem(HoldProcedureItem:new("T.O. DATA FORM & TRC/ART","CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("ALTIMETERS","SET & CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("PREFLIGHT BRIEFING","PERFORM",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("ND MODE & RANGE","AS RQRD",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("RADIO AIDS","CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("FGCP","CROSSCHECK",FlowItem.actorCPT))

-- =============== COCKPIT CREW CHECKLIST ================
-- FLT RECORDER/AIDS.......................TEST/CKD   (FO)
-- AHRS ALIGNMENT..........................VERIFIED (BOTH)
-- FMS/GPS................................CKD/X-CKD (BOTH)
-- EMERGENCY LIGHTS...........................ARMED  (CPT) 
-- CABIN SIGNS................................ON/ON  (CPT) 
-- WINSHIELD ANTI-ICE SW.........................ON  (CPT) 
-- ENG SYNC SEL.................................OFF  (CPT)
-- STALL WARNING.............................TESTED   (FO)
-- AIR COND SHUTOFF SW........................ AUTO  (CPT)
-- FIRE PROTECTION SYS.......................TESTED   (FO)
-- TRP.......................................TESTED   (FO)
-- FUEL QUANTITY.............................___KGS (BOTH)
-- ALTIMETERS.........................QNH/QNH/X-CKD (BOTH)
-- FUEL SHUTOFF LEVERS..........................OFF  (CPT)
-- CABIN PRESS LEVER...........................AUTO  (CPT)
-- COCKPIT CREW CHECKLIST.................COMPLETED 
-- =======================================================

local cockpitCrewChecklist = Checklist:new("COCKPIT CREW CHECKLIST","","")
cockpitCrewChecklist:setFlightPhase(3)

-- FLT RECORDER/AIDS.......................TEST/CKD   (FO) -- not supported
cockpitCrewChecklist:addItem(ChecklistItem:new("FLIGHT RECORDER","CHECKED",FlowItem.actorFO,0,true,nil))
-- AHRS ALIGNMENT..........................VERIFIED (BOTH) -- not supported
cockpitCrewChecklist:addItem(ChecklistItem:new("A H R S ALIGNMENT","VERIFIED",FlowItem.actorFO,0,true,nil))
cockpitCrewChecklist:addItem(ManualChecklistItem:new("FMS/GPS","X-CHECKED",FlowItem.actorCPT,0,"fmgschkd",true,nil))
-- EMERGENCY LIGHTS...........................ARMED  (CPT) -- not supported
cockpitCrewChecklist:addItem(ManualChecklistItem:new("EMERGENCY LIGHTS","ARMED",FlowItem.actorCPT,0,"fmgschkd",true,nil))
cockpitCrewChecklist:addItem(ChecklistItem:new("CABIN SIGNS","ON/ON",FlowItem.actorCPT,0,
	function () 
		return sysGeneral.seatBeltSwitch:getStatus() > 0 and
		sysGeneral.noSmokingSwitch:getStatus() > 0
	end,
	function () 
		sysGeneral.seatBeltSwitch:actuate(1)		
		sysGeneral.noSmokingSwitch:actuate(1)
	end))
cockpitCrewChecklist:addItem(ChecklistItem:new("WINSHIELD ANTI-ICE SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
-- ENG SYNC SEL.................................OFF  (CPT) -- not supported
cockpitCrewChecklist:addItem(ChecklistItem:new("ENGINE SYNC SELECTOR","OFF",FlowItem.actorCPT,0,true,nil))
cockpitCrewChecklist:addItem(ChecklistItem:new("STALL WARNING","TESTED",FlowItem.actorFO,0,true,nil))
cockpitCrewChecklist:addItem(ChecklistItem:new("AIR CONDITION SHUTOFF SWITCHES","AUTO",FlowItem.actorCPT,0,
	function () 
		return get("laminar/md82/bleedair/bleedair_HVAC_L") == 2 and
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 2
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	end))
-- FIRE PROTECTION SYS.......................TESTED   (FO)
cockpitCrewChecklist:addItem(ChecklistItem:new("FIRE PROTECTION SYSTEM","TESTED",FlowItem.actorFO,0,true,nil))
-- TRP.......................................TESTED   (FO) -- not supported
cockpitCrewChecklist:addItem(ChecklistItem:new("T R P","TESTED",FlowItem.actorFO,0,true,nil))
-- FUEL QUANTITY.............................___KGS (BOTH)
cockpitCrewChecklist:addItem(ChecklistItem:new("FUEL QUANTITY","CHECKED",FlowItem.actorCPT,0,true,nil))
cockpitCrewChecklist:addItem(ChecklistItem:new("ALTIMETERS","QNH",FlowItem.actorCPT,0,true,
	function () kc_macro_set_local_baro() end))
-- FUEL SHUTOFF LEVERS..........................OFF  (CPT)
cockpitCrewChecklist:addItem(ChecklistItem:new("FUEL SHUTOFF LEVERS","OFF",FlowItem.actorCPT,0,
	function () return 
		get("sim/cockpit2/engine/actuators/mixture_ratio",0) == 0 and
		get("sim/cockpit2/engine/actuators/mixture_ratio",1) == 0
	end,
	function ()
		set_array("sim/cockpit2/engine/actuators/mixture_ratio",0,0)
		set_array("sim/cockpit2/engine/actuators/mixture_ratio",1,0)
	end))
-- CABIN PRESS LEVER...........................AUTO  (CPT) --not supported
cockpitCrewChecklist:addItem(ChecklistItem:new("CABIN PRESSURISATION LEVER","AUTO",FlowItem.actorCPT,0,true,nil))


-- ================= BEFORE-START PROC ===================
-- LOAD SHEET / TAKEOFF DATA................X-CHECK (BOTH) 
-- ZFW..........................................SET   (PF)  
-- FMS FINAL DATA ENTRY.....................PERFORM   (PF) 
-- FLAP TAKEOFF SELECTOR (IF REQUIRED)..........SET   (FO) 
-- T.O CONDITION LONGITUDINAL TRIM READOUTS.....SET  (CPT) -- not supported
-- STABILIZER TRIM..............................SET  (CPT) 
-- AIDS....................................SET DATA   (FO) -- not supported
-- PARKING BRAKE................................SET  (CPT)  
-- APU AIR SWITCH................................ON   (FO) 
-- APU NORM/ECON SWITCH........................NORM   (FO) -- not supported 
-- AIR CONDITION SUPPLY SWITCHES................OFF   (FO) 
-- FUEL SYSTEM..................................SET   (FO) 
-- ANTI-COLLISION LIGHTS.........................ON   (FO) 
-- PNEUMATIC X-FEED VALVE LEVERS...............OPEN  (CPT) 
-- THRUST LEVERS...............................IDLE  (CPT) 
-- PNEUMATIC PRESSURE.........................CHECK  (CPT) 
-- ENG IGN SELECTOR..................SYS A OR SYS B  (CPT) 
-- BEFORE START CHECKLIST...COMPLETE 
-- =======================================================
local beforeStartProc = Procedure:new("BEFORE START PROCEDURE","","")
beforeStartProc:setFlightPhase(4)
beforeStartProc:addItem(HoldProcedureItem:new("LOAD SHEET / TAKEOFF DATA","X-CHECKED",FlowItem.actorCPT))
-- ZFW..........................................SET   (PF) not supported
-- FMS FINAL DATA ENTRY.....................PERFORM   (PF) not supported
-- FLAP TAKEOFF SELECTOR (IF REQUIRED)..........SET   (FO) not supported
-- T.O CONDITION LONGITUDINAL TRIM READOUTS.....SET  (CPT) not supported
beforeStartProc:addItem(HoldProcedureItem:new("STABILIZER TRIM","SET",FlowItem.actorCPT))
-- AIDS....................................SET DATA   (FO) not supported
beforeStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("  #spell|APU# AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end))
-- APU NORM/ECON SWITCH........................NORM   (FO) not supported 
-- AIR CONDITION SUPPLY SWITCHES................OFF   (FO) 
beforeStartProc:addItem(ProcedureItem:new("AIR COND SUPPLY SWITCH","OFF",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 0 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 0  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
	end))
-- FUEL SYSTEM..................................SET   (FO) 
beforeStartProc:addItem(ProcedureItem:new("FUEL SYSTEM","SET",FlowItem.actorFO,0,true,
	function () 
		sysFuel.fuelPumpLeftAft:actuate(1)
		sysFuel.fuelPumpRightAft:actuate(1)
		sysFuel.fuelPumpCtrLeft:actuate(1)
	end))
-- ANTI-COLLISION LIGHTS.........................ON   (FO) 
beforeStartProc:addItem(ProcedureItem:new("ANTI-COLLISION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () kc_macro_lights_before_start() end))
-- PNEUMATIC X-FEED VALVE LEVERS...............OPEN  (CPT) 
beforeStartProc:addItem(ProcedureItem:new("PNEUMATIC X-FEED VALVE","OPEN",FlowItem.actorCPT,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
-- THRUST LEVERS...............................IDLE  (CPT) 
beforeStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
-- PNEUMATIC PRESSURE.........................CHECK  (CPT) 
beforeStartProc:addItem(ProcedureItem:new("ENG IGN SELECTOR","SYS A OR SYS B",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") ~= 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_dwn")
	end))
beforeStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorCPT,0,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))

-- =============== BEFORE START CHECKLIST ================
-- PARKING BRAKES...............................SET  (CPT)
-- EFB..................................FLIGHT MODE (BOTH) not supported 
-- PNEUMATIC PRESSURE.........................__PSI  (CPT) 
-- ENGINGE IGNITION SELECTOR.........SYS A OR SYS B  (CPT) 
-- FUEL TANK PUMPS...........................ALL ON  (CPT)
-- ANTI-COLLISION LIGHTS.........................ON   (FO)  
-- APU NORM/ECON SWITCH........................NORM   (FO) not supported
-- AIR CONDITION SUPPLY SWITCHES................OFF   (FO)
-- PNEUMATIC CROSS-FEED LEVERS.................OPEN   (FO)
-- THRUST LEVERS...............................IDLE   (FO)
-- BEFORE START CHECKLIST COMPLETED
-- =======================================================

local beforeStartChecklist = Checklist:new("BEFORE START CHECKLIST","before start checks","")
beforeStartChecklist:setFlightPhase(4)
beforeStartChecklist:addItem(ChecklistItem:new("PARKING BRAKES","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
	end))
-- EFB..................................FLIGHT MODE (BOTH) not supported 
beforeStartChecklist:addItem(ChecklistItem:new("PNEUMATIC PRESSURE","CHECKED",FlowItem.actorCPT,0,true))
beforeStartChecklist:addItem(ChecklistItem:new("ENGINE IGNITION SELECTOR","A OR B",FlowItem.actorCPT,0,
	function () return get("laminar/md82/ignition_sys") ~= 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_dwn")
	end))
beforeStartChecklist:addItem(ChecklistItem:new("FUEL PUMPS","ALL ON",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() > 0 end,
	function () 
		sysFuel.allFuelPumpGroup:actuate(1)
	end))  
beforeStartChecklist:addItem(ChecklistItem:new("ANTI-COLLISION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () kc_macro_lights_before_start() end))
-- APU NORM/ECON SWITCH........................NORM   (FO) not supported
beforeStartChecklist:addItem(ChecklistItem:new("AIR CONDITION SUPPLY SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 0 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 0  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
	end))
beforeStartChecklist:addItem(ChecklistItem:new("PNEUMATIC CROSS-FEED LEVERS","OPEN",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
beforeStartChecklist:addItem(ChecklistItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))


-- ============== PRE PUSH & ENGINE START ================
-- START-UP CLEARANCE.......................REQUEST  (CPT)
-- DOORS.....................................CLOSED  (F/O)
-- PARKING BRAKE................................SET  (CPT)
-- FLAP LEVER....................................UP  (F/O)
-- ANTI COLL LIGHTS..............................ON  (F/O)
-- AIR CONDITION SUPPLY SWITCHES................OFF  (F/O)
-- APU BLEED AIR.................................ON  (F/O)
-- SEAT BELT LTS.................................ON  (F/O)
-- TRANSPONDER..............................STANDBY  (F/O)
-- PNEUMATIC X-FEED VALVES.....................OPEN  (F/O)	
-- HYDRAULIC A PRESSURE.....................CHECKED  (F/O)
-- PARKING BRAKE................................SET  (F/O)
-- POWER LEVERS.............................CUT OFF  (F/O)
-- EXT PWR...........................OFF/DISCONNECT  (F/O)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- =======================================================

local prePushStartProc = Procedure:new("PRE PUSH & ENGINE START","","ready to start engines")
prePushStartProc:setFlightPhase(4)

prePushStartProc:addItem(HoldProcedureItem:new("START-UP CLEARANCE","REQUEST",FlowItem.actorCPT))
prePushStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
prePushStartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		sysLights.domeLightSwitch:actuate(0)
	end))
prePushStartProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
prePushStartProc:addItem(ProcedureItem:new("ANTI COLL LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () kc_macro_lights_before_start() end))
prePushStartProc:addItem(ProcedureItem:new("APU BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end))
prePushStartProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 1 end,
	function () sysGeneral.seatBeltSwitch:actuate(1) end))	
prePushStartProc:addItem(ProcedureItem:new("GALLEY POWER","OFF",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 0 end,
	function () sysElectric.galleyPower:actuate(0) end))
prePushStartProc:addItem(ChecklistItem:new("AIR CONDITION SUPPLY SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 0 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 0  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_up")
	end))
-- TRANSPONDER..............................STANDBY  (F/O)
prePushStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() <= 1 end,
	function () sysRadios.xpdrSwitch:actuate(0) end))
-- L & R ENG BLD AIR..........................HP/LP  (F/O)	
prePushStartProc:addItem(ProcedureItem:new("PNEUMATIC X-FEED VALVES","OPEN",FlowItem.actorCPT,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
prePushStartProc:addItem(ProcedureItem:new("HYDRAULIC PRESSURE","CHECK",FlowItem.actorFO,0,true,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
-- POWER LEVERS.............................CUT OFF  (F/O)
prePushStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
prePushStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
	function () return sysElectric.gpuOnBus:getStatus() == 0 end,
	function () kc_macro_gpu_disconnect() end))
prePushStartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
prePushStartProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
prePushStartProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () 
		if activePrefSet:get("default:betterPushback") == true then
			kc_pushback_call() 
		end
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
prePushStartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
prePushStartProc:addItem(HoldProcedureItem:new("START CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))


-- ==================== ENGINE START =====================
-- START SEQUENCE........................AS REQUIRED (CPT)
-- START FIRST ENG....................START ENGINE x (CPT)
--   ENGINE START SWITCH.....................PRESS x (CPT) 
--   1ST ENGINE N2........................INCREASING (CPT)
--   POWER LEVER........................LEVER x IDLE (CPT)
--   STARTER LIGHT OUT......................ANNOUNCE (CPT)
-- START SECOND ENGINE...............START ENGINE __ (CPT)
--   ENGINE START SWITCH.....................PRESS x (CPT) 
--   2ND ENGINE N2........................INCREASING (CPT)
--   POWER LEVER........................LEVER x IDLE (CPT)
--   STARTER LIGHT OUT......................ANNOUNCE (CPT)
-- When pushback/towing complete 
--   TOW BAR DISCONNECTED.....................VERIFY (CPT)  
--   LOCKOUT PIN REMOVED......................VERIFY (CPT)  
-- PARKING BRAKE.................................SET (F/O)
-- HYDRAULICS................................CHECKED (F/O)
-- FGC/YAW DAMPER.................................ON (F/O)
-- =======================================================

local engStartProc = Procedure:new("ENGINE START","")
engStartProc:setFlightPhase(4)
engStartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
engStartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,20,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/starter_is_running",1) == 1
		else 
			return get("sim/flightmodel2/engines/starter_is_running",0) == 1
		end 
	end,
	function () 
		command_once("sim/engines/mixture_max")
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_begin("sim/starters/engage_start_run_2")
			kc_speakNoText(0,"starting right hand engine")
		else 
			command_begin("sim/starters/engage_start_run_2")
			kc_speakNoText(0,"starting left hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end 
	end,
	function () 
		command_end("sim/starters/engage_start_run_1")
		command_end("sim/starters/engage_start_run_2")
	end))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/has_fuel_flow_after_mixture",1) == 1 
		else 
			return get("sim/flightmodel2/engines/has_fuel_flow_after_mixture",0) == 1 
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_once("sim/engines/throttle_up_2")
		else 
			command_once("sim/engines/throttle_up_1")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/starter_is_running",1) == 0
		else 
			return get("sim/flightmodel2/engines/starter_is_running",0) == 0
		end 
	end))
engStartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT))
engStartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","PRESS START SWITCH %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT,20,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/starter_is_running",0) == 1
		else 
			return get("sim/flightmodel2/engines/starter_is_running",1) == 1
		end 
	end,
	function () 
		command_once("sim/engines/mixture_max")
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_begin("sim/starters/engage_start_run_1")
		else 
			command_begin("sim/starters/engage_start_run_2")
			kc_speakNoText(0,"starting left hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 end 
	end,
	function () 
		command_end("sim/starters/engage_start_run_1")
		command_end("sim/starters/engage_start_run_2")
	end))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/starter_is_running",0) == 1
		else 
			return get("sim/flightmodel2/engines/starter_is_running",1) == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_once("sim/engines/throttle_up_1")
		else 
			command_once("sim/engines/throttle_up_2")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/starter_is_running",0) == 0
		else 
			return get("sim/flightmodel2/engines/starter_is_running",1) == 0
		end 
	end))
engStartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))


-- =============== AFTER START PROCEDURE =================
-- ELECTRICAL SYSTEM......................CHECK/SET  (CPT)
-- GALLEY POWER..................................ON  (CPT)
-- ENG IGN SELECTOR ............................OFF  (CPT)
-- PITOT AND STATIC HEATERS......................ON  (CPT)
-- AIR FOIL ANTI-LCE SWITCHES...........AS REQUIRED  (CPT) 
-- AIR COND SUPPLY SWITCHES....................AUTO  (CPT)
-- APU AIR SWITCH...............................OFF  (CPT)
-- APU MASTER SWITCH............................OFF  (CPT)
-- HYDRAULIC SYSTEM.....................CHECK & SET   (FO)
-- ATC/TCAS...............................SET/XPNDR (BOTH)
-- PNEU X-FEED VALVE LEVERS.............OPEN   (FO)
-- WINDOWS....................................CLOSE (BOTH)
-- DOOR LOCK SW................................DENY (BOTH)
-- DOOR ANNUNCIATIONS.....................CHECK OFF (BOTH)
-- SPOILERS...................................ARMED  (CPT)
-- AIDS..................................CHECK/PUSH   (FO)
-- GROUND CREW CLEARANCE....................RECEIVE  (CPT)
-- AFTER START CHECKLIST...................COMPLETE   (FO)
-- =======================================================
local afterStartProc = Procedure:new("AFTER START PROCEDURE","")
afterStartProc:setFlightPhase(5)

afterStartProc:addItem(ProcedureItem:new("ELECTRICAL SYSTEM","CHECK/SET",FlowItem.actorCPT,0,
	function () return
		get("sim/cockpit/electrical/generator_on",0) == 1 and 
		get("sim/cockpit/electrical/generator_on",1) == 1 and
		sysElectric.apuGenBusGroup:getStatus() == 0 and 
		sysElectric.apuStartSwitch:getStatus() == 0 and 
		get("laminar/md82/electrical/cross_tie_AC") == 1 and 
		get("laminar/md82/electrical/cross_tie_DC") == 0
	end,
	function () 
		set_array("sim/cockpit/electrical/generator_on",0,1)
		set_array("sim/cockpit/electrical/generator_on",1,1)
		sysElectric.apuGenBusGroup:actuate(0)
		sysElectric.apuStartSwitch:setValue(0)
		if get("laminar/md82/electrical/cross_tie_DC") == 1 then 
			command_once("laminar/md82cmd/electrical/cross_tie_DC")
		end
		if get("laminar/md82/electrical/cross_tie_AC") == 0 then 
			command_once("laminar/md82cmd/electrical/cross_tie_AC")
		end
	end))
afterStartProc:addItem(ProcedureItem:new("GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
afterStartProc:addItem(ProcedureItem:new("ENG IGN SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
afterStartProc:addItem(ProcedureItem:new("PITOT AND STATIC HEATERS","CAPT",FlowItem.actorFO,0,
	function () return get("laminar/md82/ice/heatknob") == 1 end,
	function () 
		while get("laminar/md82/ice/heatknob") ~= 1 do
			command_once("laminar/md82cmd/ice/selheatknob_up")
		end
	end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 1 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() > 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
-- AIR COND SUPPLY SWITCHES....................AUTO  (CPT)
afterStartProc:addItem(ProcedureItem:new("AIR COND SHUTOFF SWITCH","AUTO",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 2 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 2  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	end))
afterStartProc:addItem(ProcedureItem:new("APU AIR SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(0) end))
afterStartProc:addItem(ProcedureItem:new("APU MASTER SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(0) end))
afterStartProc:addItem(ProcedureItem:new("APU START SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit/engine/APU_switch") == 0 end,
	function () set("sim/cockpit/engine/APU_switch",0) end))
afterStartProc:addItem(IndirectProcedureItem:new("HYDRAULICS","CHECKED",FlowItem.actorCPT,0,"hydchecked",
	function () return 
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 and
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2") > 2000 
	end))
-- ATC/TCAS...............................SET/XPNDR (BOTH)
afterStartProc:addItem(ProcedureItem:new("AUX HYD PUMP SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
afterStartProc:addItem(ProcedureItem:new("PNEUMATIC X-FEED VALVE","OPEN",FlowItem.actorCPT,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
afterStartProc:addItem(ProcedureItem:new("WINDOWS","CLOSED",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/switches/custom_slider_on",5) == 0 end,
	function () set_array("sim/cockpit2/switches/custom_slider_on",5,0) end))
-- DOOR LOCK SW................................DENY (BOTH) not supported
-- DOOR ANNUNCIATIONS.....................CHECK OFF (BOTH) not supported
-- SPOILERS...................................ARMED  (CPT)
afterStartProc:addItem(ProcedureItem:new("SPOILERS","ARMED",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == -0.5 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",-0.5) end))
-- AIDS..................................CHECK/PUSH   (FO) not supported
afterStartProc:addItem(HoldProcedureItem:new("GROUND CREW CLEARANCE","RECEIVED",FlowItem.actorCPT,nil))

	
-- ============ AFTER ENGINE START CHECKLIST =============
-- ENGINE IGNITION SELECTOR.....................OFF   (FO)
-- PITOT & STATIC HEATERS........................ON  (CPT)
-- ANTI ICE SWITCHES....................AS REQUIRED   (FO)
-- AIR COND SUPPLY SWITCHES....................AUTO   (FO)
-- DOOR CUE LIGHT...........................CKD OFF (BOTH)
-- HYD SYS................................CKD & SET   (FO)
-- ELECTRICAL LOADS.........................CHECKED  (CPT)
-- GALLEY POWER..................................ON  (CPT)
-- PNEUMATIC X-FEED VALVES.....................OPEN  (CPT)
-- FLIGHT CONTROLS..........................CHECKED  (CPT)
-- ANNUNCIATOR PANEL........................CHECKED  (CPT)
-- GROUND EQUIPMENT.........................REMOVED  (CPT)
-- ALL CLEAR SIGNAL........................RECEIVED  (CPT)
-- FLAPS SLATS (READ AND DO)....................SET  (CPT)
-- =======================================================

local afterStartChkl = Checklist:new("AFTER ENGINE START CHECKLIST","after start checks","")
afterStartChkl:setFlightPhase(5)
afterStartChkl:addItem(ChecklistItem:new("ENGINE IGNITION SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
afterStartChkl:addItem(ChecklistItem:new("PITOT AND STATIC HEATERS","CAPTAIN",FlowItem.actorCPT,0,
	function () return get("laminar/md82/ice/heatknob") == 1 end,
	function () 
		while get("laminar/md82/ice/heatknob") ~= 1 do
			command_once("laminar/md82cmd/ice/selheatknob_up")
		end
	end))
-- ICE PROTECTION PANEL..................AS REQUIRED (CPT)
afterStartChkl:addItem(ChecklistItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorCPT,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartChkl:addItem(ChecklistItem:new("WING ANTI-ICE SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysAice.wingAiceGroup:getStatus() > 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartChkl:addItem(ChecklistItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorCPT,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartChkl:addItem(ChecklistItem:new("ENGINE ANTI-ICE SWITCHES","ON",FlowItem.actorCPT,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 1 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
-- AIR COND SUPPLY SWITCHES....................AUTO   (FO)
afterStartChkl:addItem(ChecklistItem:new("AIR CONDITIONING SHUTOFF SWITCH","AUTO",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 2 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 2  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	end))
-- DOOR CUE LIGHT...........................CKD OFF (BOTH) not supported
afterStartChkl:addItem(ChecklistItem:new("HYDRAULICS","CHECKED",FlowItem.actorCPT,0,
	function () return 
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 and
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2") > 2000 
	end))
afterStartChkl:addItem(ChecklistItem:new("ELECTRICAL LOADS","CHECKED",FlowItem.actorCPT,0,
	function () 
		return get("sim/cockpit2/electrical/bus_load_amps",0) < 100 and
		get("sim/cockpit2/electrical/bus_load_amps",1) < 100 and
		get("sim/cockpit2/electrical/bus_load_amps",2) < 100 
	end))
afterStartChkl:addItem(ChecklistItem:new("GALLEY POWER","ON",FlowItem.actorCPT,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
afterStartChkl:addItem(ChecklistItem:new("PNEUMATIC CROSS-FEED VALVE","OPEN",FlowItem.actorCPT,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
afterStartChkl:addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorCPT,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end))
afterStartChkl:addItem(ChecklistItem:new("HYDRAULIC PUMPS & PRESSURE","ON",FlowItem.actorCPT,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
afterStartChkl:addItem(ManualChecklistItem:new("ANNUNCIATOR PANEL","CHECKED",FlowItem.actorCPT,0,"anunciatorstart",true,nil))
afterStartChkl:addItem(ManualChecklistItem:new("GROUND EQUIPMENT","REMOVED",FlowItem.actorCPT,0,"groundequipment",true,nil))
afterStartChkl:addItem(ManualChecklistItem:new("ALL CLEAR SIGNAL","RECEIVED",FlowItem.actorCPT,0,"groundequipment",true,nil))
afterStartChkl:addItem(ChecklistItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		return math.floor(sysControls.flapsSwitch:getStatus()*10)/10 == flapsval 
	end,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		sysControls.flapsSwitch:setValue(flapsval) 
	end)) 	

-- ================= TAXIING PROCEDURE ===================
-- TAXI CLEARANCE...........................RECEIVE   (FO)
-- FLAP/SLAT LEVER..................SET FOR TAKEOFF   (FO)
-- EXTERIOR LIGHTS......................AS REQUIRED (BOTH)
-- SPEED AND DIRECTIONAL CONTROL...........MAINTAIN  (CPT)
-- FLIGHT INSTRUMENTS.........................CHECK (BOTH)
-- TAKEOFF DATA..............................REVIEW (BOTH)
-- V BUGS.....................................CHECK (BOTH)
-- TRC/ART..........................SET AS REQUIRED (BOTH)
-- AILERON, RUDDER & STABILIZER TRIM....0, 0, CHECK   (FO)
-- FUEL HEAT............................AS REQUIRED   (FO)   
-- ATC CLEARANCE............................RECEIVE (BOTH)
-- FGS..........................................SET (BOTH) 
-- TAKEOFF BRIEFING........................COMPLETE (BOTH)  
-- CABIN REPORT..............................OBTAIN  (CPT)
-- PARKING BRAKE............................RELEASE  (CPT)   
-- =======================================================

local taxiingProc = Procedure:new("TAXIING PROCEDURE","")
taxiingProc:setFlightPhase(6)
taxiingProc:addItem(HoldProcedureItem:new("TAXI CLEARANCE","RECEIVED",FlowItem.actorCPT,nil))
taxiingProc:addItem(ProcedureItem:new("FLAP/SLAT LEVER","SET FOR TAKEOFF",FlowItem.actorCPT,0,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		return math.floor(sysControls.flapsSwitch:getStatus()*10)/10 == flapsval 
	end,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		sysControls.flapsSwitch:setValue(flapsval) 
	end)) 
taxiingProc:addItem(ProcedureItem:new("EXTERIOR LIGHTS","AS REQUIRED",FlowItem.actorCPT,0,
	function () return sysLights.taxiSwitch:getStatus() == 1 end,
	function () kc_macro_lights_before_taxi() end)) 
-- SPEED AND DIRECTIONAL CONTROL...........MAINTAIN  (CPT)
-- FLIGHT INSTRUMENTS.........................CHECK (BOTH)
taxiingProc:addItem(HoldProcedureItem:new("TAKEOFF DATA","REVIEW",FlowItem.actorCPT,nil))
-- V BUGS.....................................CHECK (BOTH)
taxiingProc:addItem(ProcedureItem:new("SPEED BUGS","CHECK",FlowItem.actorCPT,0,
	function () return kc_macro_md82_check_to_speedbugs() end,
	function () kc_macro_md82_set_to_speedbugs() end)) 
-- TRC/ART..........................SET AS REQUIRED (BOTH) not supported
taxiingProc:addItem(HoldProcedureItem:new("AILERON, RUDDER & STABILIZER TRIM","0/0/CHECK",FlowItem.actorCPT,nil))
-- FUEL HEAT............................AS REQUIRED   (FO) not supported
taxiingProc:addItem(HoldProcedureItem:new("ATC CLEARANCE","RECEIVE",FlowItem.actorCPT,nil))
-- FGS..........................................SET (BOTH) 
taxiingProc:addItem(HoldProcedureItem:new("TAKEOFF BRIEFING","COMPLETE",FlowItem.actorCPT,nil))
taxiingProc:addItem(HoldProcedureItem:new("CABIN REPORT","OBTAIN",FlowItem.actorCPT,nil))



-- ================= TAXIING CHECKLIST ===================
-- APU AIR SWITCH................................OFF  (FO)
-- T R P/A R T................................AS RQD  (FO) not supported 
-- V BUGS.............................. __/__/__/__/  1/2 
-- FLT INSTRUMENTS/FGS...........................CKD  1/2 
-- FMS/GPS.......................................CKD     PF/PM 
-- FLT CONTROLS...............................TESTED  1/2 
-- FLAP/SLAT LEVER............................__/EXT  1/2 
-- AUTOBRAKE/AUTOSPOILER......................AS RQD  1/2 
-- AILERON, RUDDER & STABILIZER TRIM.....0/0/CHECKED    2 
-- T.O. BRIEFING...........................PERFORMED    PF/PM 
-- CABIN REPORT.............................OBTAINED    1 
-- =======================================================

local taxiingChkl = Checklist:new("TAXIING CHECKLIST","taxi checklist","")
taxiingChkl:setFlightPhase(6)
taxiingChkl:addItem(ChecklistItem:new("APU AIR SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(0) end))
-- T R P/A R T................................AS RQD  (FO) not supported	
taxiingChkl:addItem(ChecklistItem:new("SPEED BUGS","CHECK",FlowItem.actorCPT,0,
	function () return kc_macro_md82_check_to_speedbugs() end,
	function () kc_macro_md82_set_to_speedbugs() end)) 
taxiingChkl:addItem(ChecklistItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		return math.floor(sysControls.flapsSwitch:getStatus()*10)/10 == flapsval 
	end,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		sysControls.flapsSwitch:setValue(flapsval) 
	end)) 	
taxiingChkl:addItem(ChecklistItem:new("AUTOBRAKE & AUTOSPOILER","SET",FlowItem.actorCPT,0,
	function () return 
		get("sim/cockpit/switches/auto_brake_settings") == 0 and 
		get("sim/cockpit2/controls/speedbrake_ratio") == -0.5
	end,
	function () 
		set("sim/cockpit/switches/auto_brake_settings",0) 
		set("sim/cockpit2/controls/speedbrake_ratio",-0.5)
	end)) 
taxiingChkl:addItem(ManualChecklistItem:new("TAKEOFF BRIEFING","PERFORMED",FlowItem.actorCPT,0,"tobrief",true,nil))
taxiingChkl:addItem(ManualChecklistItem:new("CABIN REPORT","OBTAINED",FlowItem.actorCPT,0,"cabinreport",true,nil))
taxiingChkl:addItem(ChecklistItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))


-- ================= CLEARED FOR TAKEOFF =================
-- FLAPS............................CHECK T/O FLAPS  (CPT)
-- AP ALTITUDE..........................SET CHECKED  (CPT)
-- AP HEADING BUG...............................SET  (CPT)
-- AP HDG MODE..................................SET  (CPT)
-- AP VNAV......................................SET  (CPT)
-- AP MAC TRIM...................................ON  ----
-- ENGINE ANTI-ICE......................AS REQUIRED  (F/O)
-- STABILIZER ANTI-ICE..................AS REQUIRED  (F/O)
-- WINDSHIELD HEAT LH & RH.......................ON  (F/O)
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF","","")
beforeTakeoffProc:setFlightPhase(7)
beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		return math.floor(sysControls.flapsSwitch:getStatus()*10)/10 == flapsval 
	end,
	function () 
		local flapsind = tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])
		local flapsval = sysControls.flaps_pos[flapsind]
		sysControls.flapsSwitch:setValue(flapsval) 
	end))  
beforeTakeoffProc:addItem(ProcedureItem:new("AP ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP HEADING BUG","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTakeoffProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () 
		sysAice.windowHeatGroup:actuate(1)
	end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENG IGN SELECTOR","BOTH",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 3 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
	
-- =================== RUNWAY ENTRY  =====================
-- STROBE LIGHT.................................ON  (F/O)
-- TAXI LIGHT..................................OFF  (CPT)
-- TRANSPONDER..........................ATC ALT ON  (F/O)
-- PACS & BLEEDS.......................AS REQUIRED  (F/O)
-- LANDING LIGHT................................ON  (CPT)
-- WEATHER RADAR................................ON  (F/O)
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY","","")
runwayEntryProc:setFlightPhase(-7)
runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() == 1 end,
	function () kc_macro_lights_for_takeoff() end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ATC ALT ON",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == 3 end,
	function () 
		sysRadios.xpdrSwitch:actuate(3)
	end))
runwayEntryProc:addItem(ProcedureItem:new("PACKS & BLEEDS","AS REQUIRED",FlowItem.actorFO,0,true,
	function ()
		kc_macro_packs_takeoff() 
		kc_macro_bleeds_takeoff()
	end))

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- == TAKEOFF
-- TAKEOFF................................ANNOUNCE   (PF)
-- THRUST SETTING..........................TAKEOFF   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PM)

-- == GEAR UP
-- COMMAND GEAR.................................UP   (PM)

-- == RETRACT FLAPS
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)   (PF)
-- FLAPS 11.........................SET (OPTIONAL)   (PF)
-- FLAPS 11 SPEED..........................REACHED   (PF)
-- FLAPS UP....................................SET   (PF)
-- YAW DAMPER...................................ON   (PF)
-- A/P..........................................ON   (PF)

-- POWER LEVERS..........................SET CLIMB   (PF)
-- PAC & BLEED SWITCHES.........................ON   (PM)
-- APU STARTER...................PRESS DOWN TO STOP  (PM)
-- APU......................................STOPPED  (PM)
-- APU SYSTEM MASTER............................OFF  (PM)

-- Whatever comes first
-- TRANSITION ALTITUDE............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..................................STD (BOTH)
-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS..............................OFF   (PM)
-- FASTEN BELTS SWITCH.........................OFF   (PM)
-- ======================================================

local takeoffClimbProc = Procedure:new("TAKEOFF & INITIAL CLIMB","")
takeoffClimbProc:setFlightPhase(8)
takeoffClimbProc:addItem(HoldProcedureItem:new("TAKEOFF","ANNOUNCE",FlowItem.actorPF))
takeoffClimbProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_for_takeoff() 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in
	end))

-- =====================================================================================================================

local gearUpProc = Procedure:new("COMMAND GEAR UP","Gear up")
gearUpProc:setFlightPhase(-8)
gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_speakNoText(0,"gear coming up") 
	end))

-- =====================================================================================================================


local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(-8)
flapsUpProc:addItem(SimpleProcedureItem:new("Retract Flaps when Speed reached"))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 11","COMMAND AT >200 KTS",FlowItem.actorPF,nil,
	function () return activeBriefings:get("takeoff:flaps") < 2 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 11","SET",FlowItem.actorPM,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) kc_speakNoText(0,"speed check flaps 11") end,
	function () return activeBriefings:get("takeoff:flaps") < 1 end))
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND AT >230 KTS",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) kc_speakNoText(0,"speed check flaps up") end))
flapsUpProc:addItem(HoldProcedureItem:new("A/P","ON",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))

flapsUpProc:addItem(ProcedureItem:new("A/P","ON",FlowItem.actorPNF,0,true,
	function () 
		sysMCP.ap1Switch:actuate(1) 
	end))
flapsUpProc:addItem(ProcedureItem:new("PACKS & BLEEDS","ON",FlowItem.actorPM,0,true,
	function ()
		kc_macro_packs_on() 
		kc_macro_bleeds_on()
	end))

-- =====================================================================================================================


-- ================ AFTER TAKEOFF CHECK ==================
-- FLAPS.........................................UP   (PM)
-- TAXI LIGHT...................................OFF   (PM)
-- =======================================================

local afterTakeoffCheck = Checklist:new("AFTER TAKEOFF CHECK","after takeoff check","")
afterTakeoffCheck:setFlightPhase(8)
afterTakeoffCheck:addItem(ChecklistItem:new("GEAR","UP",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
	end))
afterTakeoffCheck:addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) end))
afterTakeoffCheck:addItem(ChecklistItem:new("TAXI LIGHT","OFF",FlowItem.actorPM,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))


-- ================= DESCENT CHECK ======================
-- KPCREW APPROACH BRIEFING................PERFORM   (PF)
-- VREF...............................CHECK IN FMC   (PF)
-- LANDING DATA...............VREF __, MINIMUMS __   (PF)
-- PRESSURIZATION...............SET LAND ALT __ FT   (PM)
-- ENGINE ANTI-ICE.....................AS REQUIRED   (PM)
-- STABILIZER ANTI-ICE.................AS REQUIRED   (PM)
-- CTR WING XFER LH & RH..................BOTH OFF   (PM)
-- LH & RH WNDSHLD ANTI-ICE................BOTH ON   (PM)
-- AUTO BRAKE..........................AS REQUIRED   (PM)
-- === Whatever comes first
-- TRANSITION LEVEL...............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..........................QNH AT DEST (BOTH)
-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................ON   (PM)
-- FASTEN BELTS SWITCH..........................ON   (PM)
-- ======================================================

local descentProc = Procedure:new("DESCENT CHECK","","")
descentProc:setFlightPhase(11)
descentProc:addItem(HoldProcedureItem:new("KPCREW APPROACH BRIEFING","PERFORM",FlowItem.actorPF))

descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () 
		return get("sim/cockpit/misc/radio_altimeter_minimum") == activeBriefings:get("approach:decision") end,
	function ()
		local flag = 0 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities
	end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
descentProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
descentProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
descentProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ALL ON",FlowItem.actorPM,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
descentProc:addItem(ProcedureItem:new("AUTO BRAKE","SET %s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorCPT,0,
	function () 
		local abind = tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])
		return get("sim/cockpit/switches/auto_brake_settings") == flapsval 
	end,
	function () 
		local abind = tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])
		set("sim/cockpit/switches/auto_brake_settings",abind)
	end)) 	
	
-- ================== DESCENT CHECKLIST ==================
-- APPROACH BRIEFING......................COMPLETED   (PF)
-- NAVIGATION RADIOS...........SET FOR THE APPROACH   (PF)
-- MINIMUMS.....................................SET   (PF)
-- FMS..........................PROGRAMMED/VERIFIED   (PF)
-- LANDING DATA...........................CONFIRMED   (PF)
-- V SPEEDS.....................................SET   (PF)
-- TRANSITION LEVEL DESCENT FORECAST............SET   (PF)
-- PRESSURIZATION...............................SET   (PF)
-- PASSEMGER BRIEFING.....................COMPLETED   (PM)
-- SEAT BELT LTS........................PASS SAFETY   (PM)
-- AUTO BRAKE...........................AS REQUIRED   (PM)
-- =======================================================

local descentChecklist = Checklist:new("DESCENT CHECKLIST","descent checklist","")
descentChecklist:setFlightPhase(11)
descentChecklist:addItem(ManualChecklistItem:new("APPROACH BRIEFING","COMPLETED",FlowItem.actorPF,0,"approachbrief"))
descentChecklist:addItem(ManualChecklistItem:new("NAVIGATION RADIOS","SET FOR THE APPROACH",FlowItem.actorPF,0,"navradioland"))
descentChecklist:addItem(ChecklistItem:new("MINIMUMS","%i|activeBriefings:get(\"approach:decision\")",FlowItem.actorPF,0,
	function () 
		return get("sim/cockpit/misc/radio_altimeter_minimum") == activeBriefings:get("approach:decision") end,
	function ()
		local flag = 0 
		if 
			activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
			sysEFIS.minsTypePilot:actuate(flag) 
			sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
			sysEFIS.minsResetPilot:actuate(1) 
		end))
descentChecklist:addItem(ManualChecklistItem:new("FMS","PROGRAMMED/VERIFIED",FlowItem.actorPF,0,"fmsprogramland"))
descentChecklist:addItem(ManualChecklistItem:new("LANDING DATA","CONFIRMED",FlowItem.actorPF,0,"landingdata"))
descentChecklist:addItem(ManualChecklistItem:new("V SPEEDS","SET VAPP %i, VREF %i|activeBriefings:get(\"approach:vapp\")|activeBriefings:get(\"approach:vref\")",FlowItem.actorPF,0,"vrefvapp"))
descentChecklist:addItem(ManualChecklistItem:new("TRANSITION LEVEL DESCENT FORECAST","SET",FlowItem.actorPF,0,"translevelset"))
descentChecklist:addItem(ManualChecklistItem:new("PASSENGER BRIEFING","COMPLETED",FlowItem.actorPF,0,"paxbrief"))
descentChecklist:addItem(ChecklistItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorPM,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 1 end,
	function () sysGeneral.seatBeltSwitch:actuate(1) end))	
descentChecklist:addItem(ChecklistItem:new("AUTO BRAKE","SET %s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorCPT,0,
	function () 
		local abind = tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])
		return get("sim/cockpit/switches/auto_brake_settings") == flapsval 
	end,
	function () 
		local abind = tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])
		set("sim/cockpit/switches/auto_brake_settings",abind)
	end)) 

-- ================== LANDING PROCEDURE ==================
-- ALTIMETERS...................................SET (BOTH)
-- LANDING LIGHTS................................ON   (PF)
-- LH & RH IGNITION SWITCHES...................NORM   (PM)
-- ENG SYNC.....................................OFF   (PM)
-- COURSE NAV 1.................................SET   (PF)
-- COURSE NAV 2.................................SET   (PM)
-- AIR CONDITIONING PACK SWITCHES.......AS REQUIRED   (PM)

-- ==== Flaps & Gear Schedule

-- === GEAR DOWN
-- LANDING GEAR........................DOWN 3 GREEN   (PM)

-- === FLAPS 5 (<250kt)
-- FLAPS 5......................................SET

-- === FLAPS 15 (<210kt)
-- FLAPS 15.....................................SET

-- === FLAPS FULL (<180kt)
-- FLAPS FULL...................................SET
-- GO AROUND ALTITUDE.......................... SET
-- GO AROUND HEADING............................SET
-- ======================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","")
landingProc:setFlightPhase(13)

landingProc:addItem(HoldProcedureItem:new("ALTIMETERS","QNH %s|activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH))
landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorPF,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
landingProc:addItem(ProcedureItem:new("COURSE NAV 2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorPM,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() > 1 end,
	function () sysAir.packSwitchGroup:actuate(1) end,
	function () return activeBriefings:get("approach:packs") > 1 end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:actuate(0) end,
	function () return activeBriefings:get("approach:packs") == 1 end))
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPF,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights_approach() end))	

-- =====================================================================================================================

local flaps1Proc = Procedure:new("FLAPS 11","","")
flaps1Proc:setFlightPhase(-13)
flaps1Proc:addItem(ProcedureItem:new("FLAPS 11","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[2] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) end))

-- =====================================================================================================================

local flaps2Proc = Procedure:new("FLAPS 15","","")
flaps2Proc:setFlightPhase(-13)
flaps2Proc:addItem(ProcedureItem:new("FLAPS 15","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[3] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[3]) end))

-- =====================================================================================================================
	
local gearDownProc = Procedure:new("GEAR DOWN","","")
gearDownProc:setFlightPhase(-13)
gearDownProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
gearDownProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorPM,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))

-- =====================================================================================================================

local flaps3Proc = Procedure:new("FLAPS 28","","")
flaps3Proc:setFlightPhase(-13)
flaps3Proc:addItem(ProcedureItem:new("FLAPS 28","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[4] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[4]) end))

-- =====================================================================================================================

local flapsFullProc = Procedure:new("FLAPS 40","","")
flapsFullProc:setFlightPhase(-13)
flapsFullProc:addItem(ProcedureItem:new("FLAPS 40","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[5] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[5]) end))
flapsFullProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
flapsFullProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))	

-- =====================================================================================================================

-- ================ FINAL DESCENT CHECKS ================
-- GEAR...............................DOWN 3 GREEN   (PF)
-- SPEED BRAKES..........................RETRACTED   (PF)
-- FLAPS........................................35   (PF)
-- AUTOPILOT...................................OFF   (PF)
-- ======================================================
local landingChecklist = Checklist:new("FINAL DESCENT CHECKS","","")
landingChecklist:setFlightPhase(13)
landingChecklist:addItem(ChecklistItem:new("GEAR","DOWN 3 GREEN",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.GearSwitch:actuate(1) 
	end))
landingChecklist:addItem(ChecklistItem:new("SPEED BRAKES","RETRACTED",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
landingChecklist:addItem(ChecklistItem:new("FLAPS","FULL",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 1 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[8]) end))
landingChecklist:addItem(ChecklistItem:new("AUTOPILOT","OFF",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/annunciators/autopilot") == 0 end))

-- ============== AFTER LANDING PROCEDURE ===============
-- AILERON & RUDDER TRIM.....................RESET  (F/O)
-- TRANSPONDER.........................AS REQUIRED  (F/O)
-- WEATHER RADAR..............................STBY  (F/O)
-- CHRONO & ET................................STOP  (F/O)
-- PITOT/STATIC...........................BOTH OFF  (F/O)
-- FLAPS........................................UP  (F/O)
-- SPEED BRAKES..........................RETRACTED  (F/O)
-- EXTERNAL LIGHTS.....................AS REQUIRED  (F/O)
-- STABILIZER ANTI-ICE.........................OFF  (F/O)
-- ENGINE ANTI-ICE.............................OFF  (F/O)
-- stabilizer trim reset
-- APU...........................START IF REQUIRED  (F/O)
-- ======================================================

local afterLandingProc = Procedure:new("AFTER LANDING","")
afterLandingProc:setFlightPhase(15)
afterLandingProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/aileron_trim") == 0 and
		get("sim/cockpit2/controls/rudder_trim") == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","AS REQUIRED",FlowItem.actorFO,0,
	function () 
		if activePrefSet:get("general:xpdrusa") == true then
			return get("sim/cockpit2/radios/actuators/transponder_mode") == 3 
		else
			return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 
		end
	end,
	function () 
		if activePrefSet:get("general:xpdrusa") == true then
			set("sim/cockpit2/radios/actuators/transponder_mode",3)	
		else
			set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		end
	end))
afterLandingProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/EFIS/EFIS_weather_on") == 0 end,
	function () 
		if get("sim/cockpit2/EFIS/EFIS_weather_on") > 0 then
			command_once("sim/instruments/EFIS_wxr")
		end
	end))
afterLandingProc:addItem(ProcedureItem:new("GROUND SPOILERS","RETRACT",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
afterLandingProc:addItem(ProcedureItem:new("CHRONO & ET","STOP",FlowItem.actorFO,0,
	function () return true end,
	function () activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
afterLandingProc:addItem(ProcedureItem:new("PITOT/STATIC","BOTH OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorFO,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () kc_macro_lights_cleanup() end))
afterLandingProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("#spell|APU# START SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuStartSwitch:getStatus() > 0 end,
	function () sysElectric.apuStartSwitch:setValue(2) end))
afterLandingProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTING",FlowItem.actorFO,0,"apustarting",
	function () return get("sim/cockpit/engine/APU_N1") > 3 end))
afterLandingProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTED",FlowItem.actorFO,0,"apurunning",
	function () return get("sim/cockpit/engine/APU_N1") == 100 end,
	function ()  end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))

-- =====================================================================================================================

local taxiLightOff = Procedure:new("TAXI LIGHT OFF","")
taxiLightOff:setFlightPhase(-15)
taxiLightOff:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () kc_macro_lights_after_shutdown() end))

-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- TRANSPONDER.............................STANDBY
-- THROTTLES..................................IDLE
-- TAXI LIGHT SWITCH...........................OFF 
-- PARKING BRAKE...............................SET
-- WHEEL CHOCKS................................SET
-- APU GEN............................ON IF NEEDED
-- APU BLEED AIR......................ON IF NEEDED
-- EXT PWR.............................AS REQUIRED
-- PSG BELT & SAFETY LT........................OFF
-- GEN LH & RH.................................OFF 
-- WINDSHIELD HEAT LH & RH.....................OFF
-- L & R ENG BLD AIR...........................OFF
-- EMEG LIGHTS.................................OFF
-- FUEL BOOST.............................BOTH OFF
-- PITOT / STATIC..............................OFF
-- ENGINE ANTI-ICE.............................OFF
-- STABILIZER ANTI-ICE.........................OFF
-- HYD PUMP A & B..............................OFF
-- AUX PUMP A..................................OFF
-- STANDBY ATTITUDE ADI......................CAGED
-- AVIONICS SWITCH.............................OFF
-- EICAS SWITCH................................OFF
-- STANDBY POWER...............................OFF
-- BATTERY SWITCHES............................OFF 
-- ======================================================

local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE","","")
shutdownProc:setFlightPhase(17)
shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","IDLE",FlowItem.actorFO,0,"throttleidleend",
	function ()
		return get("sim/cockpit2/engine/actuators/throttle_ratio_all") < 0.3
	end))
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		kc_macro_lights_after_shutdown() activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
shutdownProc:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () kc_macro_lights_after_shutdown() end))shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))

shutdownProc:addItem(ProcedureItem:new("APU","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function ()  end))
shutdownProc:addItem(IndirectProcedureItem:new("APU","RUNNING",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function ()  end))
shutdownProc:addItem(ProcedureItem:new("APU BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(1)
	end))
shutdownProc:addItem(ProcedureItem:new("APU L & R BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBus1:getStatus() == 1 and
		sysElectric.apuGenBus2:getStatus() == 1 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
	end))
shutdownProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))
shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","CUT",FlowItem.actorCAPT,0,"throttlescutland",
	function () return get("sim/cockpit2/engine/actuators/mixture_ratio_all") <= 0 end,
	function () set("sim/cockpit2/engine/actuators/mixture_ratio_all",0) end))
shutdownProc:addItem(ProcedureItem:new("PSG BELT & SAFETY LT","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("GENERATORS","OFF",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 0 and 
			sysElectric.gen2Switch:getStatus() == 0
	end,
	function ()
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("L & R ENG BLD AIR","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.engBleedGroup:getStatus() == 0
	end,
	function () 
		sysAir.engBleedGroup:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("FUEL BOOST BOTH","OFF",FlowItem.actorFO,0,
	function () 
		return get("sim/cockpit/engine/fuel_pump_on",0) == 0 and 
		get("sim/cockpit/engine/fuel_pump_on",1) == 0 
	end,
	function ()  
		set_array("sim/cockpit/engine/fuel_pump_on",0,0)
		set_array("sim/cockpit/engine/fuel_pump_on",1,0)
	end))
-- shutdownProc:addItem(ProcedureItem:new("PITOT/STATIC","OFF",FlowItem.actorFO,0,
	-- function () return get("laminar/md82/ice/heatmeter") == 0 end,
	-- function () 
		-- while get("laminar/md82/ice/heatmeter") ~= 0 do
			-- command_once("laminar/md82cmd/ice/selheatknob_dwn")
		-- end
	-- end))
shutdownProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ELECTRIC HYD PUMPS","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("DOOR","OPEN",FlowItem.actorFO,0,
	function () return sysGeneral.doorGroup:getStatus() > 0 end,
	function () kc_macro_doors_after_shutdown() end))	
	
-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("COLD & DARK","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))
coldAndDarkProc:addItem(ProcedureItem:new("POWER DOWN","DONE","SYS",0,true,
	function () 
		kc_macro_gpu_disconnect()
		sysElectric.apuGenBusGroup:actuate(0)
		command_once("sim/electrical/battery_1_off")
		getActiveSOP():setActiveFlowIndex(1)
	end))
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("TURNAROUND MODE","SET","SYS",6,true,
	function () 
		kc_macro_state_turnaround()
	end))
turnAroundProc:addItem(ProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,2,true,
	function () 
		set("sim/cockpit/engine/APU_switch",1) 
		getActiveSOP():setActiveFlowIndex(2)
	end))

-- === Recover Takeoff modes
local recoverTakeoff = State:new("Recover Takeoff","","")
recoverTakeoff:setFlightPhase(8)
recoverTakeoff:addItem(ProcedureItem:new("Recover","SET","SYS",0,true,
	function () 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
		kc_procvar_set("aftertakeoff",true) -- fo cleans up when flaps are in	--
	end))

-- === Recover Approach modes
local recoverApproach = State:new("Recover Approach","","")
recoverApproach:setFlightPhase(11)
recoverApproach:addItem(ProcedureItem:new("Recover","SET","SYS",0,true,
	function () 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities	
	end))	


-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("aftertakeoff", false) -- triggers after takeoff activities by FO
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
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
-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(prelCockpitPrep)
activeSOP:addProcedure(cockpitPrepProc1)
activeSOP:addProcedure(cockpitPrepProc2)
activeSOP:addProcedure(cockpitPrepProc3)
activeSOP:addProcedure(cockpitCrewChecklist)
activeSOP:addProcedure(beforeStartProc)
activeSOP:addProcedure(beforeStartChecklist)
activeSOP:addProcedure(prePushStartProc)
activeSOP:addProcedure(engStartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(afterStartChkl)
activeSOP:addProcedure(taxiingProc)
activeSOP:addProcedure(taxiingChkl)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(flapsUpProc)
activeSOP:addProcedure(afterTakeoffCheck)
activeSOP:addProcedure(descentProc)
activeSOP:addProcedure(descentChecklist)
activeSOP:addProcedure(landingProc)
activeSOP:addProcedure(flaps1Proc)
activeSOP:addProcedure(flaps2Proc)
activeSOP:addProcedure(gearDownProc)
activeSOP:addProcedure(flaps3Proc)
activeSOP:addProcedure(flapsFullProc)
activeSOP:addProcedure(landingChecklist)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(taxiLightOff)
activeSOP:addProcedure(shutdownProc)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)


kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end

return SOP_MD82
