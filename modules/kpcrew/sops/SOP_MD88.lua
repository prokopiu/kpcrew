-- Base SOP for RotateSim MD-88 XP 12

-- @classmod SOP_MD88
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

local SOP_MD88 = {
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

activeSOP = SOP:new("Rotate MD-88 SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,true,
	function () 
		command_end("sim/ignition/engage_starter_1")
		command_end("sim/starters/engage_start_run_1")
		command_end("sim/starters/engage_starter_1")
	end))

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
	function () return get("Rotate/md80/electrical/battery_on") == 2 end,
	function () set("Rotate/md80/electrical/battery_on",2) end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("METER SELECTOR","BATT VOLT",FlowItem.actorFO,0,"metervoltinit",
	function () return get("Rotate/md80/electrical/power_indicator_switch") == 4 end,
	function () set("Rotate/md80/electrical/power_indicator_switch",4) end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 25V",FlowItem.actorFO,0,"bat24v",
	function () return get("Rotate/md80/electrical/dc_indicator_volt_amp") > 24.9 end))
-- DC TRANSFER BUS OFF LIGHT....................OFF   (FO)
prelCockpitPrep:addItem(ProcedureItem:new("LIGHTS & INSTRUMENT LIGHTING","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_preflight()
		kc_macro_doors_preflight()
	end))
prelCockpitPrep:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() <= 2 end,
	function () sysGeneral.wiperGroup:actuate(1) end))
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
	function () return get("Rotate/md80/systems/speedbrake_position") == 0 end,
	function () set("Rotate/md80/systems/speedbrake_position",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
prelCockpitPrep:addItem(ProcedureItem:new("IRS UNITS","NAV",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/instruments/irs_mode_switch") == 2 and
		get("Rotate/md80/instruments/irs2_mode_switch") == 2
	end,
	function () 
		set("Rotate/md80/instruments/irs_mode_switch",2)
		set("Rotate/md80/instruments/irs2_mode_switch",2)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("RUDDER TRIM","ZERO",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/systems/rudder_deg") == 0
	end,
	function () 
		set("sim/cockpit2/controls/rudder_trim",0) 
	end))
prelCockpitPrep:addItem(SimpleProcedureItem:new("==== PRELIMINARY COCKPIT PREPARATION (CM2)"))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/electrical/GPU_power_available") == 1
	end,
	function () set("Rotate/md80/electrical/GPU_power_available",1) end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT PWR L & R","ON BUS",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuGenBus1:getStatus() == 1 and
		sysElectric.gpuGenBus2:getStatus() == 1
	end,
	function () 
		sysElectric.gpuGenBus1:actuate(1)
		sysElectric.gpuGenBus2:actuate(1)
	end))
prelCockpitPrep:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () sysLights.positionSwitch:actuate(1) end))
	
prelCockpitPrep:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("  START PUMP SW (DC)","ON",FlowItem.actorFO,0,"startuppmpapu",
	function () return get("Rotate/md80/fuel/start_pump") == 1 end,
	function () set("Rotate/md80/fuel/start_pump",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("  #spell|APU# L & R BUS SWITCHES","OFF",FlowItem.actorFO,0,"preapubusoff",
	function () return 
		sysElectric.apuGenBus1:getStatus() == 0 and
		sysElectric.apuGenBus2:getStatus() == 0 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(0)
		sysElectric.apuGenBus2:actuate(0)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("#spell|  APU# START SW","START",FlowItem.actorFO,7,"apupwrstart",
	function () return sysElectric.apuStartSwitch:getStatus() > 0 end,
	function () sysElectric.apuStartSwitch:repeatOn() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("Rotate/md80/electrical/APU_power_available") == 1 end,
	function () sysElectric.apuStartSwitch:repeatOff() end,
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
	function () return get("sim/cockpit2/electrical/bus_load_amps") < 59.0 end,
	function () set("Rotate/md80/electrical/power_indicator_switch",0) end,
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
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelPumpRightAft:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

prelCockpitPrep:addItem(ProcedureItem:new("  START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/fuel/start_pump",0) == 0 end,
	function () 
		set("Rotate/md80/fuel/start_pump",0)
		set("Rotate/md80/fuel/right_aft_pump",1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("  APU AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return get("Rotate/md80/air/APU_bleed_air_switch") > 0 end,
	function () set("Rotate/md80/air/APU_bleed_air_switch",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("EMERGENCY LIGHTS SWITCH","ARM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/emergency_lights_switch") == 1 end,
	function () set("Rotate/md80/systems/emergency_lights_switch",1) end))

prelCockpitPrep:addItem(IndirectProcedureItem:new("ANNUNCIATOR/DIGITAL LIGHTS","TEST",FlowItem.actorFO,10,"annuntest",
	function () return get("Rotate/md80/test/annun_digital_click") == 1 end,
	function () command_begin("Rotate/md80/test/annun_digital") end,
	function () return activeBriefings:get("flight:firstFlightDay") == 2 end))
prelCockpitPrep:addItem(ProcedureItem:new("EFIS","TEST",FlowItem.actorFO,0,true,
	function () command_end("Rotate/md80/test/annun_digital") end))
prelCockpitPrep:addItem(ProcedureItem:new("CABIN PRESS CONTROL LEVER","CHECK & AUTO",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/air/cabin_press_control_lever") == 1 and
		get("Rotate/md80/air/cabin_press_control_wheel") == 147
	end,
	function () 
		set("Rotate/md80/air/cabin_press_control_lever",0) 
		set("Rotate/md80/air/cabin_press_control_wheel",147)
		set("Rotate/md80/air/cabin_press_control_lever",1) 
	end))
prelCockpitPrep:addItem(ProcedureItem:new("AILERON TRIM","FREE",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/systems/aileron_l_deg") < 0.001 and
		get("Rotate/md80/systems/aileron_r_deg") < 0.001
	end,
	function () set("sim/cockpit2/controls/aileron_trim",0) end))
prelCockpitPrep:addItem(ProcedureItem:new("RUDDER TRIM","ZERO",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/systems/rudder_deg") == 0
	end,
	function () 
		set("sim/cockpit2/controls/rudder_trim",0) 
		kc_speakNoText(0,"I am out for the walk around")
	end))
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
-- Clock..................................CHECK/SET  (CPT)
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
		get("Rotate/md80/lights/wing_ldg_light_switch_l") == 0 and
		get("Rotate/md80/lights/wing_ldg_light_switch_r") == 0 and
		get("Rotate/md80/lights/nose_light_switch") == 0
	end,
	function () 
		set("Rotate/md80/lights/wing_ldg_light_switch_l",0)
		set("Rotate/md80/lights/wing_ldg_light_switch_r",0)
		set("Rotate/md80/lights/nose_light_switch",0)
	end))
cockpitPrepProc1:addItem(ProcedureItem:new("FGCP/FGS","CHECK/SET",FlowItem.actorCPT,0,
	function () return kc_is_preflight_fgcp_checked() end,
	function () kc_macro_mcp_preflight() end))
cockpitPrepProc1:addItem(HoldProcedureItem:new("FLIGHT & NAV INSTRUMENTS","CHECK",FlowItem.actorCPT))
cockpitPrepProc1:addItem(ProcedureItem:new("CLOCK LEFT","CHECK/SET",FlowItem.actorCPT,0,
	function () return get("Rotate/md80/instruments/timer_switch") == 1 end,
	function () set("Rotate/md80/instruments/timer_switch",2) end))
cockpitPrepProc1:addItem(ProcedureItem:new("STATIC AIR SELECTOR LEFT","NORM",FlowItem.actorCPT,0,
	function () return get("Rotate/md80/systems/static_air_l") == 0 end,
	function () set("Rotate/md80/systems/static_air_l",0) end))
-- CREW OXYGEN & MASK....................TEST/CHECK  (CPT) not supported

cockpitPrepProc1:addItem(HoldProcedureItem:new("RADIO AIDS","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("SPEED READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("HDG READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("DFGS","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("ALT READOUT","SET",FlowItem.actorCPT))
cockpitPrepProc1:addItem(HoldProcedureItem:new("FMS SETUP","FINISHED",FlowItem.actorCPT))

-- ============ COCKPIT PREPARATION PROCEDURE ============
-- === CM2 (FO)
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
cockpitPrepProc2:addItem(ProcedureItem:new("GROUND SERVICE POWER SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/electrical/APU_gs_bus_switch") == 0 and
		get("Rotate/md80/electrical/GPU_gs_bus_switch") == 0
	end,
	function ()  
		set("Rotate/md80/electrical/APU_gs_bus_switch",0)
		set("Rotate/md80/electrical/GPU_gs_bus_switch",0)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("FLIGHT RECORDER/AIDS","TEST/NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/flt_recorder_switch") == 0 end,
	function () set("Rotate/md80/systems/flt_recorder_switch",0) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("FIRE DETECTOR LOOPS SWITCHES","BOTH",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/systems/fire_det_loop_selector_apu") == 1 and
		get("Rotate/md80/systems/fire_det_loop_selector_l") == 1 and
		get("Rotate/md80/systems/fire_det_loop_selector_r") == 1
	end,
	function ()  
		set("Rotate/md80/systems/fire_det_loop_selector_apu",1) 
		set("Rotate/md80/systems/fire_det_loop_selector_l",1) 
		set("Rotate/md80/systems/fire_det_loop_selector_r",1) 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("EMERGENCY ELECTRICAL POWER","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/electrical/emergency_power_switch") == 0 end,
	function () set("Rotate/md80/electrical/emergency_power_switch",0) end))	
cockpitPrepProc2:addItem(ProcedureItem:new("ENG IGN SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/engines/igniter_switch") == 1 end,
	function () set("Rotate/md80/engines/igniter_switch",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("EMERGENCY LIGHTS","ARM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/emergency_lights_switch") == 1 end,
	function () set("Rotate/md80/systems/emergency_lights_switch",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("CABIN SIGNS","ON/ON",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/systems/seatbelts_switch") == 1 and
		get("Rotate/md80/systems/no_smoking_switch") == 1
	end,
	function ()  
		set("Rotate/md80/systems/seatbelts_switch",1)
		set("Rotate/md80/systems/no_smoking_switch",1)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("PITOT AND STATIC HEATERS","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/ice/probes_antiice_switch") == 0 end,
	function () set("Rotate/md80/ice/probes_antiice_switch",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("AIRFOIL & ENG ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("Rotate/md80/ice/airfoil_antiice") == 0 and
		get("Rotate/md80/ice/tail_heat_switch_clicked") == 0 and
		get("Rotate/md80/ice/engine_antiice_left") == 0 and
		get("Rotate/md80/ice/engine_antiice_right") == 0
	end,
	function ()  
		set("Rotate/md80/ice/airfoil_antiice",0) 
		set("Rotate/md80/ice/engine_antiice_left",0)		
		set("Rotate/md80/ice/engine_antiice_right",0) 
		if get("Rotate/md80/ice/tail_heat_switch_clicked") == 1 then
			command_once("Rotate/md80/ice/tail_heat_switch")
		end
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("WINDSHIELD ANTI-FOG SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/windshield_antifog_switch") == 0 end,
	function () set("Rotate/md80/systems/windshield_antifog_switch",0) end))	
cockpitPrepProc2:addItem(ProcedureItem:new("WINDSHIELD ANTI-ICE SWITCH","ON",FlowItem.actorFO,0,
	function () return get("Rotate/md80/ice/windshield_antiice_switch") == 1 end,
	function () set("Rotate/md80/ice/windshield_antiice_switch",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("ENG SYNC SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/eng_sync_switch") == 0 end,
	function () set("Rotate/md80/systems/eng_sync_switch",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("GND PROX WARN SWITCH","TEST/NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/test/gpws_test_switch") == 0 end,
	function () command_once("Rotate/md80/test/gpws_test_switch_up") end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("STALL WARNING SYSTEM 1","TEST",FlowItem.actorFO,4,"stalltest1",
	function () return get("Rotate/md80/test/stall_test_switch") == 1 end,
	function () set("Rotate/md80/test/stall_test_switch",1) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("STALL WARNING SYSTEM 2","TEST",FlowItem.actorFO,4,"stalltest2",
	function () return get("Rotate/md80/test/stall_test_switch") == -1 end,
	function () set("Rotate/md80/test/stall_test_switch",-1) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("STALL WARNING SYSTEM","NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/test/stall_test_switch") == 0 end,
	function () set("Rotate/md80/test/stall_test_switch",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/yaw_damper_switch") == 1 end,
	function () set("Rotate/md80/systems/yaw_damper_switch",1) end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("OVERSPEED WARNING SYSTEM 1","TEST",FlowItem.actorFO,4,"ovspdtest1",
	function () return get("Rotate/md80/test/max_speed_test_switch") == 1 end,
	function () set("Rotate/md80/test/max_speed_test_switch",1) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(IndirectProcedureItem:new("OVERSPEED WARNING SYSTEM 2","TEST",FlowItem.actorFO,4,"ovspdtest2",
	function () return get("Rotate/md80/test/max_speed_test_switch") == -1 end,
	function () set("Rotate/md80/test/max_speed_test_switch",-1) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("OVERSPEED WARNING SYSTEM","NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/test/max_speed_test_switch") == 0 end,
	function () set("Rotate/md80/test/max_speed_test_switch",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("MACH TRIM COMP SWITCH","NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/mach_trim_comp_override") == 0 end,
	function () set("Rotate/md80/systems/mach_trim_comp_override",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("LOGO LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () 
		if kc_is_daylight() then
			return get("Rotate/md80/lights/logo_light_switch") == 0 
		else
			return get("Rotate/md80/lights/logo_light_switch") == 1
		end			
	end,
	function () 
		if kc_is_daylight() then
			set("Rotate/md80/lights/logo_light_switch",0)
		else
			set("Rotate/md80/lights/logo_light_switch",1)
		end			
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("CKPT & CABIN TEMP SELECTORS","SET",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/air/temp_control_cockpit_setting") == 0.5 and
			get("Rotate/md80/air/temp_control_cabin_setting") == 0.5 
	end,
	function () 
		set("Rotate/md80/air/temp_control_cockpit_setting",0.5)
		set("Rotate/md80/air/temp_control_cabin_setting",0.5 )
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("RADIO RACK SWITCH","FAN",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/radio_rack_switch") == 1 end,
	function () set("Rotate/md80/systems/radio_rack_switch",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("CABIN PRESSURE CONTROLLER","SET",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/air/land_altitude_set") == math.floor(get("sim/flightmodel2/position/pressure_altitude")/10) and
			get("Rotate/md80/air/land_pressure_set") == get("sim/weather/barometer_sealevel_inhg") 
	end,
	function () 
		set("Rotate/md80/air/land_altitude_set",get("sim/flightmodel2/position/pressure_altitude")/10)
		set("Rotate/md80/air/land_pressure_set",get("sim/weather/barometer_sealevel_inhg"))
	end))	
cockpitPrepProc2:addItem(ProcedureItem:new("AIR COND SHUTOFF SWITCH","AUTO",FlowItem.actorFO,0,
	function () return get("Rotate/md80/air/aircon_shutoff_ovrd") == 0 end,
	function () set("Rotate/md80/air/aircon_shutoff_ovrd",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("RAM AIR SWITCH","AS REQUIRED",FlowItem.actorFO,0,
	function () return get("Rotate/md80/air/aircon_ram_air") == 0 end,
	function () set("Rotate/md80/air/aircon_ram_air",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("FGCP/FGS","CHECK/SET",FlowItem.actorFO,0,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end,
	function () kc_macro_mcp_preflight() end))

-- FIRE PROTECTION SYSTEM......................TEST   (FO)  
-- REVERSE THRUST LIGHTS........................OFF   (FO) 
 
cockpitPrepProc2:addItem(ProcedureItem:new("FUEL USED READOUTS","RESET",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/fuel/fuel_flow_used_switched_l") == 0 and
			get("Rotate/md80/fuel/fuel_flow_used_switched_r") == 0
	end,
	function () 
		command_once("Rotate/md80/fuel/reset_burned_fuel_counter")
	end))


-- ENGINE OIL INDICATORS......................CHECK   (FO)

cockpitPrepProc2:addItem(ProcedureItem:new("FUEL QTY INDICATOR","TEST",FlowItem.actorFO,2,
	function () return get("Rotate/md80/fuel/fuel_test_button_active") == 1 end,
	function () set("Rotate/md80/fuel/fuel_test_button_active",1) end))

-- GEAR DOOR OPEN LIGHT.........................OFF   (FO)
-- GEAR LIGHTS & AURAL WARNING.................TEST   (FO)
-- TAS/SAT....................................CHECK   (FO) 
-- SDP........................................CHECK   (FO)   

cockpitPrepProc2:addItem(ProcedureItem:new("HYDRAULIC SYSTEM","SET",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/hydraulic/hyd_switch_electric") == 0 and
			get("Rotate/md80/hydraulic/hyd_trans") == 0
	end,
	function () 
		set("Rotate/md80/hydraulic/hyd_switch_electric",0)
		set("Rotate/md80/hydraulic/hyd_trans",0)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("BRAKE TEMP INDICATOR","TEST",FlowItem.actorFO,2,
	function () return get("Rotate/md80/test/brake_temp_test_active") == 1 end,
	function () set("Rotate/md80/test/brake_temp_test_active",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("BRAKE TEMP INDICATOR","ALL",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/brake_temp_selector") == 0 end,
	function () 
		set("Rotate/md80/test/brake_temp_test_active",0)
		set("Rotate/md80/systems/brake_temp_selector",0) 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("STATIC AIR SELECTOR RIGHT","NORM",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/static_air_r") == 0 end,
	function () set("Rotate/md80/systems/static_air_r",0) end))
-- CREW OXYGEN AND MASK..................TEST/CHECK   (FO) 
cockpitPrepProc2:addItem(ProcedureItem:new("WX RADAR","TEST",FlowItem.actorFO,2,
	function () return get("Rotate/md80/instruments/wx_switch") == 0 end,
	function () set("Rotate/md80/instruments/wx_switch",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("WX RADAR","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/instruments/wx_switch") == 1 end,
	function () set("Rotate/md80/instruments/wx_switch",1) end))
cockpitPrepProc2:addItem(ProcedureItem:new("RUD HYD CONT LEVER","PWR",FlowItem.actorFO,0,
	function () return get("Rotate/md80/hydraulic/rudder_control_manual") == 0 end,
	function () set("Rotate/md80/hydraulic/rudder_control_manual",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("TAKEOFF WARNING / THRUST LEVERS","TEST/IDLE",FlowItem.actorFO,3,
	function () return get("Rotate/md80/controls/throttle_ratio_all") == 1 end,
	function () set("Rotate/md80/controls/throttle_ratio_all",1) end,
	function ()
		return activeBriefings:get("flight:firstFlightDay") == 2 
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("FUEL SHUTOFF LEVERS","OFF",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/fuel/fuel_valve_ratio_l") == 0 and
			get("Rotate/md80/fuel/fuel_valve_ratio_r") == 0 
	end,
	function () 
		set("Rotate/md80/controls/throttle_ratio_all",0)
		set("Rotate/md80/fuel/fuel_valve_ratio_l",0)
		set("Rotate/md80/fuel/fuel_valve_ratio_r",0)
	end))
cockpitPrepProc2:addItem(ProcedureItem:new("FUEL X-FEED LEVER","OFF",FlowItem.actorFO,0,
	function () return get("Rotate/md80/fuel/fuel_xfeed_valve_ratio") == 0 end,
	function () set("Rotate/md80/fuel/fuel_xfeed_valve_ratio",0) end))
cockpitPrepProc2:addItem(ProcedureItem:new("FLAP T.O. SELECTOR","STOW",FlowItem.actorFO,0,
	function () return get("Rotate/md80/systems/flap_to_sel") == 25 end,
	function () set("Rotate/md80/systems/flap_to_sel",25) end))
cockpitPrepProc2:addItem(ProcedureItem:new("ATC/TCAS","SET/TEST",FlowItem.actorFO,0,
	function () 
		return get("Rotate/md80/instruments/transponder_mode_switch") == 1 and
			get("sim/cockpit2/radios/actuators/transponder_code") == 2000
	end,
	function () 
		set("Rotate/md80/instruments/transponder_mode_switch",1) 
		set("sim/cockpit2/radios/actuators/transponder_code",2000)
		command_once("Rotate/md80/instruments/transponder_test")
	end))


-- ============== FINAL COCKPIT PREPARATION ==============
-- AHRS ALIGNMENT...........................CONFIRM  (CPT)
-- T.O. DATA FORM & TRC/ART..............CROSSCHECK  (CPT)
-- ALTIMETERS.....................SET & CROSS-CHECK (BOTH) 
-- PREFLIGHT BRIEFING.......................PERFORM  (CPT)
-- ND MODE & RANGE..........................AS RQRD  (CPT)
-- RADIO AIDS...............................X-CHECK  (CPT)   
-- FGCP.....................................X-CHECK  (CPT)
-- START-UP CLEARANCE.......................REQUEST  (CPT)
-- COCKPIT CREW CHECKLIST..................COMPLETE (BOTH)
-- =======================================================

local cockpitPrepProc3 = Procedure:new("FINAL COCKPIT PREPARATION","","")
cockpitPrepProc3:setFlightPhase(3)
cockpitPrepProc3:addItem(ProcedureItem:new("AHRS ALIGNMENT","CONFIRM",FlowItem.actorFO,0,
	function () 
		return 
			get("Rotate/md80/fms/irs_align_light") == 0 and
			get("Rotate/md80/fms/irs2_align_light") == 0 
	end))
cockpitPrepProc3:addItem(HoldProcedureItem:new("T.O. DATA FORM & TRC/ART","CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("ALTIMETERS","SET & CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("PREFLIGHT BRIEFING","PERFORM",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("ND MODE & RANGE","AS RQRD",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("RADIO AIDS","CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("FGCP","CROSSCHECK",FlowItem.actorCPT))
cockpitPrepProc3:addItem(HoldProcedureItem:new("START-UP CLEARANCE","REQUEST",FlowItem.actorCPT))


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










-- ================= BEFORE-START CHECK ==================
-- Load Sheet / Takeoff Data ..................................................................................................... X-CHECK PN/PM  
-- ZFW ........................................................................................................................................................ SET PF  
-- FMS final data entry ................................................................................................................... PERFORM PF 
-- INIT REF ....................................................................................................................................... DEPRESS PF  
-- PERF INIT> ..................................................................................................................................... SELECT PF 
-- <INDEX ............................................................................................................................................ SELECT PF  
-- <TAKEOFF ...................................................................................................................................... SELECT PF 
-- MCDU TAKEOFF CONFIGURATION .............................................................................................. SET PF/PM 
-- FLAP T.O. Selector (If Required) ............................................................................................................ SET 2 
-- Takeoff Condition Longitudinal Trim Readouts .................................................................................... SET 1 
-- Stabilizer Trim .......................................................................................................................................... SET 1 
-- AIDS ............................................................................................................................................... SET DATA 2 
-- Parking Brake ........................................................................................................................................... SET 1  
-- APU AIR Switch ...................................................................................................................... AS REQUIRED 2 
-- APU NORM/ECON Switch ................................................................................................................... NORM 2 
-- AIR COND SUPPLY Switches ................................................................................................................. OFF 2 
-- Fuel System ............................................................................................................................................. SET  2 
-- Anti-Collision Lights ................................................................................................................................. ON 2 
-- PNEU X-FEED VALVE Levers ….......................................................................................................... OPEN 1 
-- Thrust Levers .......................................................................................................................................... IDLE 1 
-- Pneumatic Pressure .......................................................................................................................... CHECK 1 
-- ENG IGN Selector ................................................................................................................ SYS A or SYS B 1 
-- Before Start Checklist ................................................................................................................ COMPLETE 2 
-- =======================================================


-- =============== BEFORE START CHECKLIST ================
-- Parking Brakes........................................SET     1 
-- EFB.....................................FLIGHT MODE     1/2 
-- Pneumatic Pressure..............................__PSI    1 
-- ENG ING Sel.....................SYS A or SYS B    2 
-- Left/Right/Centre Fuel 
-- Tank Pumps.....................................ALL ON    1 
-- Anti-Collision Lts....................................ON    2 
-- APU NORM/ECON Sw.....................NORM    2 
-- AIR COND SUPPLY Sw.......................OFF    2 
-- PNEU X-FEED Levers.......................OPEN    2 
-- Thrust Levers........................................IDLE    2 
-- Before Start Checklist Completed
-- =======================================================

-- xxx
-- PARKING BRAKE.................................SET (CPT)
-- DOORS......................................CLOSED (CPT)
-- START-UP & PUSHBACK CLRNCE...............APPROVED (CPT)
-- PNEUM X-FEED VALVE LEVERS....................OPEN (F/O)
-- AUX & TRANS HYD PUMPS..........................ON (F/O)
-- ANTI-COLLISION LIGHT...........................ON (F/O)
-- AIR COND SUPPLY..........................OFF,BOTH (F/O)
-- FUEL PUMPS.....................................ON (F/O)
-- GALLEY POWER..................................OFF (F/O)
-- IGNITION....................................A / B (F/O)
-- PNEUM PRESS.................................CHECK (F/O)

local beforeStartProc = Procedure:new("BEFORE START CHECKS","","")
beforeStartProc:setFlightPhase(4)
beforeStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorCPT,0,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
beforeStartProc:addItem(HoldProcedureItem:new("START-UP & PUSHBACK CLEARANCE","APPROVED",FlowItem.actorCPT,0))
beforeStartProc:addItem(ProcedureItem:new("PNEUM X-FEED VALVE LEVERS","OPEN",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("AUX & TRANS HYD PUMPS","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.auxHydPump:getStatus() == 1 end,
	function () sysHydraulic.auxHydPump:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("ANTI-COLLISION LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("AIR COND SUPPLY","OFF, BOTH",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:actuate(0) end))
beforeStartProc:addItem(ProcedureItem:new("FUEL PUMPS","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 6 end,
	function () sysFuel.fuelPumpGroup:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("GALLEY POWER","OFF",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 0 end,
	function () sysElectric.galleyPower:actuate(0) end))
beforeStartProc:addItem(ProcedureItem:new("IGNITION","A OR B",FlowItem.actorFO,0,
	function () return sysEngines.ignition:getStatus() ~= 0 end,
	function () sysEngines.ignition:actuate(2) end))
beforeStartProc:addItem(ProcedureItem:new("PNEUM PRESS","CHECK",FlowItem.actorFO,0,
	function () return get("laminar/md82/bleedair/bleedair_needle") > 2 end))

-- =========== PUSHBACK & ENGINE START (BOTH) ============
-- PARKING BRAKE................................SET  (CPT)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- START SEQUENCE IS....................AS REQUIRED  (CPT)
-- START FIRST ENGINE.............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......HOLD TO START ENGINE _  (CPT)
--   Verify that the N2 RPM increases.
--   When N2 is at 15%,
--   ENGINE FUEL LEVER...................LEVER _ ON  (CPT)
--   When N1 rotation is at 24%, release starter switch
-- START SECOND ENGINE............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......HOLD TO START ENGINE _  (CPT)
--   Verify that the N2 RPM increases.
--   When N2 is at 15%,
--   ENGINE FUEL LEVER...................LEVER _ ON  (CPT)
--   When N1 rotation is at 24%, release starter switch
-- ===
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY  (CPT)
--   LOCKOUT PIN REMOVED.....................VERIFY  (CPT)
-- =======================================================


-- PUCHBACK and ENGINE START
-- Start Sequence 2 then 1
-- “START RIGHT ENGINE” Engage start switch right engine and checks pressure
-- “RIGHT START VALVE OPEN”
-- fuel lever ON “FUEL ON”
-- “FUEL ON” “N2”, “OIL PRESSURE”, “N1”, “FUEL FLOW,” “EGT”
-- Cabin crew close doors and arm slides: 40% N1: Release start switch (Engine generator
-- switched to the electrical bus)
-- “RIGHT START VALVE CLOSED”
-- Engine stabilized: “STABILIZING” and resets timer
-- Engine Anti Ice AS REQUIRED
-- Reset timer
-- “START LEFT ENGINE”  Engage start switch left engine and checks pressure
-- “LEFT START VALVE OPEN”
-- fuel lever ON  “FUEL ON”
-- “FUEL ON” “N2”, “OIL PRESSURE”, “N1”, “FUEL FLOW,” “EGT”
-- 40% N1: Release start switch (Engine generator
-- switched to the electrical bus)
-- “LEFT START VALVE CLOSED”
-- Engine stabilized:  “STABILIZING” and resets timer
-- Engine Anti Ice AS REQUIRED
-- Reset timer
-- "ABORT START"  The FO will release the Start Switches. If the fuel levers
-- are on, the FO will hold the Start Switches for 30
-- seconds before releasing them.
-- After pushback is finished:
-- "Brakes set"
-- "Thanks for the guidance" / "Good bye"
-- Check Electrical Loads (AC and DC) in limits CHECK  Engine generator volts and frequencies correct CHECK
-- Galley Power ON  Engine Ignition off OFF

-- beforeStartProc:addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function ()   end))

local pushstartProc = Procedure:new("PUSHBACK & ENGINE START","let's get ready for push and start")
pushstartProc:setFlightPhase(4)
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		sysLights.domeLightSwitch:actuate(0)
		if activeBriefings:get("taxi:gateStand") <= 2 then
			kc_pushback_plan()
		end
	end))
pushstartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () kc_pushback_call() end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(SimpleChecklistItem:new("Wait for start clearance from ground crew"))
pushstartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
pushstartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","HOLD START SWITCH %s ON|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() == 1 
		else 
			return sysEngines.engStart1Switch:getStatus() == 1 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart2Cover:actuate(1)
			sysEngines.engStart2Switch:repeatOn(0) 
			kc_speakNoText(0,"right start valve open")
		else 
			sysEngines.engStart1Cover:actuate(1)
			sysEngines.engStart1Switch:repeatOn(0) 
			kc_speakNoText(0,"left start valve open")
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(ProcedureItem:new("  N2 ROTATION","AT 15%",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/N2_percent",1) > 14.9 
		else 
			return get("sim/flightmodel2/engines/N2_percent",0) > 14.9 
		end
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE FUEL LEVER","LEVER %s ON|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.fuelLever2:getStatus() == 1 
		else 
			return sysEngines.fuelLever1:getStatus() == 1 
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.fuelLever2:actuate(1)
		else 
			sysEngines.fuelLever1:actuate(1) 
		end 
		kc_speakNoText(0,"fuel on")
	end))
pushstartProc:addItem(ProcedureItem:new("  N1 ROTATION AT 24%","RELEASE STARTER",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/N1_percent",1) > 23.9 
		else 
			return get("sim/flightmodel2/engines/N1_percent",0) > 23.9
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart2Switch:repeatOff(0) 
			sysEngines.engStart2Cover:actuate(0)
		else 
			sysEngines.engStart1Switch:repeatOff(0) 
			sysEngines.engStart1Cover:actuate(0)
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysAice.antiIceEngRight:getStatus() == 0
		else
			return sysAice.antiIceEngLeft:getStatus() == 0
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysAice.antiIceEngRight:actuate(0) 
			kc_speakNoText(0,"right start valve closed")
		else
			sysAice.antiIceEngLeft:actuate(0) 
			kc_speakNoText(0,"left start valve closed")
		end
	end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
pushstartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysAice.antiIceEngRight:getStatus() == 1
		else
			return sysAice.antiIceEngLeft:getStatus() == 1
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysAice.antiIceEngRight:actuate(1) 
		else
			sysAice.antiIceEngLeft:actuate(1) 
		end
	end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))

pushstartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","HOLD START SWITCH %s ON|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorFO,0,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 1 
		else 
			return sysEngines.engStart2Switch:getStatus() == 1 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart1Cover:actuate(1)
			sysEngines.engStart1Switch:repeatOn(0) 
			kc_speakNoText(0,"left start valve open")
		else 
			sysEngines.engStart2Cover:actuate(1)
			sysEngines.engStart2Switch:repeatOn(0) 
			kc_speakNoText(0,"right start valve open")
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(ProcedureItem:new("  N2 ROTATION","AT 15%",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/N2_percent",0) > 14.9 
		else 
			return get("sim/flightmodel2/engines/N2_percent",1) > 14.9 
		end
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE FUEL LEVER","LEVER %s ON|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,3,"eng_start_2_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.fuelLever1:getStatus() == 1 
		else 
			return sysEngines.fuelLever2:getStatus() == 1 
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.fuelLever1:actuate(1) 
		else 
			sysEngines.fuelLever2:actuate(1) 
		end 
		kc_speakNoText(0,"fuel on")
	end))
pushstartProc:addItem(ProcedureItem:new("  N1 ROTATION AT 24%","RELEASE STARTER",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/N1_percent",0) > 23.9
		else 
			return get("sim/flightmodel2/engines/N1_percent",1) > 23.9 
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart1Switch:repeatOff(0) 
			sysEngines.engStart1Cover:actuate(0)
		else 
			sysEngines.engStart2Switch:repeatOff(0) 
			sysEngines.engStart2Cover:actuate(0)
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysAice.antiIceEngLeft:getStatus() == 0
		else
			return sysAice.antiIceEngRight:getStatus() == 0
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysAice.antiIceEngLeft:actuate(0) 
			kc_speakNoText(0,"left start valve closed")
		else
			sysAice.antiIceEngRight:actuate(0) 
			kc_speakNoText(0,"right start valve closed")
		end
	end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
pushstartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysAice.antiIceEngLeft:getStatus() == 1
		else
			return sysAice.antiIceEngRight:getStatus() == 1
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysAice.antiIceEngLeft:actuate(1) 
		else
			sysAice.antiIceEngRight:actuate(1) 
		end
	end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))

pushstartProc:addItem(SimpleProcedureItem:new("=== When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,
	function () 
		kc_speakNoText(0,"starter cutout") 
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))

-- ==== AFTER START =====
-- Electrical System ..................................................................................................................... CHECK/TEST 1 
-- Galley Power .............................................................................................................................................. ON 1  
-- ENG IGN Selector .................................................................................................................................... OFF 1 
-- Pitot and Static Heaters ............................................................................................................... ON (CAPT) 1 
-- AIR FOIL Anti-lce Switches ................................................................................................... AS REQUIRED 1  
-- AIR COND SUPPLY Switches ............................................................................................................. AUTO 1
-- APU AIR Switch ....................................................................................................................................... OFF 1  
-- APU MASTER Switch .............................................................................................................................. OFF 1  
-- Hydraulic System ................................................................................................................... CHECK & SET 2  
-- ATC/TCAS ................................................................................................................................ SET/XPNDR 1/2  
-- PNEU X-FEED VALVE Levers ............................................................................................... AS REQUIRED 2 
-- Windows .......................................................................................................................................... CLOSE 1/2  
-- DOOR LOCK Sw ................................................................................................................................. DENY 1/2 
-- Door Annunciations ................................................................................................................ CHECK OFF 1/2
-- SPOILERS …....................................................................................................................................... ARMED 1
-- AIDS ......................................................................................................................................... CHECK/PUSH 2
-- Ground Crew Clearance ................................................................................................................  RECEIVE 1   
-- After Start Checklist ................................................................................................................... COMPLETE 2 
-- =======================================================



-- =============== AFTER START CHECKLIST =================
-- ENG IGN Sel..........................................OFF    2 
-- Pitot & Static 
-- Heaters........................................ON(CAPT)    2 
-- AIR FOIL & ENG 
-- Anti Ice Sws....................................AS RQD    1 
-- AIR COND SUPPLY Sws.................AUTO    2 
-- Door Cue Light.............................CKD OFF  1/2 
-- Hyd Sys.....................................CKD & SET    2 
-- After Start Checklist Completed 
-- =======================================================

-- xxx
-- IGNITION......................................OFF (CPT)
-- ELECTRICAL LOADS..........................CHECKED (CPT)
-- AIR COND SUPPLY..............................AUTO (CPT)
-- GALLEY POWER...................................ON (CPT)
-- ICE PROTECTION PANEL..................AS REQUIRED (CPT)
-- PNEUMATIC X-FEED VALVE................AS REQUIRED (CPT)
-- FLIGHT CONTROLS...........................CHECKED (CPT)
-- HYD PUMPS & PRESS.........................CHECKED (CPT)
-- ANNUNCIATOR PANEL.........................CHECKED (CPT)
-- GROUND EQUIPMENT..........................REMOVED (CPT)
-- ALL CLEAR SIGNAL.........................RECEIVED (CPT)
-- FLAPS SLATS (READ AND DO).....................SET (CPT)

local afterStartChkl = Checklist:new("AFTER ENGINE START CHECKLIST","","")
afterStartChkl:setFlightPhase(5)
-- IGNITION......................................OFF (CPT)
afterStartChkl:addItem(ChecklistItem:new("IGNITION","OFF",FlowItem.actorCPT,0,
	function () return sysEngines.ignition:getStatus() == 0 end,
	function () sysEngines.ignition:actuate(0) end))

-- ELECTRICAL LOADS..........................CHECKED (CPT)
afterStartChkl:addItem(ChecklistItem:new("ELECTRICAL LOAD","CHECKED",FlowItem.actorCPT,0,
	function () 
		return get("sim/cockpit2/electrical/bus_load_amps",0) < 60 and
		get("sim/cockpit2/electrical/bus_load_amps",1) < 60 and
		get("sim/cockpit2/electrical/bus_load_amps",2) < 60 
	end))
-- AIR COND SUPPLY..............................AUTO (CPT)
afterStartChkl:addItem(ChecklistItem:new("AIR COND SUPPLY","AUTO",FlowItem.actorCPT,0,
	function () return sysAir.packSwitchGroup:getStatus() == 4 end,
	function () sysAir.packSwitchGroup:actuate(1) end))
-- GALLEY POWER...................................ON (CPT)
afterStartChkl:addItem(ChecklistItem:new("GALLEY POWER","ON",FlowItem.actorCPT,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
-- ICE PROTECTION PANEL..................AS REQUIRED (CPT)
afterStartChkl:addItem(ChecklistItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorCPT,0,
	function () return sysAice.antiIceWingGroup:getStatus() == 0 end,
	function () sysAice.antiIceWingGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartChkl:addItem(ChecklistItem:new("WING ANTI-ICE SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysAice.antiIceWingGroup:getStatus() == 1 end,
	function () sysAice.antiIceWingGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartChkl:addItem(ChecklistItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorCPT,0,
	function () return sysAice.antiIceEngGroup:getStatus() == 0 end,
	function () sysAice.antiIceEngGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartChkl:addItem(ChecklistItem:new("ENGINE ANTI-ICE SWITCHES","ON",FlowItem.actorCPT,0,
	function () return sysAice.antiIceEngGroup:getStatus() == 2 end,
	function () sysAice.antiIceEngGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartChkl:addItem(ChecklistItem:new("WINDSHIELD HEAT","ON",FlowItem.actorCPT,0,
	function () return sysAice.windowHeatGroup:getStatus() == 1 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
-- PNEUMATIC X-FEED VALVE................AS REQUIRED (CPT)
afterStartChkl:addItem(ChecklistItem:new("PNEUMATIC X-FEED VALVE","ON",FlowItem.actorCPT,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
-- FLIGHT CONTROLS...........................CHECKED (CPT)
afterStartChkl:addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorCPT,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end))
-- HYD PUMPS & PRESS.........................CHECKED (CPT)
afterStartChkl:addItem(ChecklistItem:new("HYD PUMPS & PRESS","ON",FlowItem.actorCPT,0,
	function () return sysHydraulic.auxHydPump:getStatus() == 1 end,
	function () sysHydraulic.auxHydPump:actuate(1) end))
-- ANNUNCIATOR PANEL.........................CHECKED (CPT)
afterStartChkl:addItem(ManualChecklistItem:new("ANNUNCIATOR PANEL","CHECKED",FlowItem.actorCPT,0,"anunciatorstart",true,nil))
-- GROUND EQUIPMENT..........................REMOVED (CPT)
afterStartChkl:addItem(ManualChecklistItem:new("GROUND EQUIPMENT","REMOVED",FlowItem.actorCPT,0,"groundequipment",true,nil))
-- FLAPS SLATS (READ AND DO).....................SET (CPT)
afterStartChkl:addItem(ChecklistItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 


-- ================= TAXIING PROCEDURE ===================
-- Taxi Clearance ................................................................................................................................. RECEIVE 2   
-- FLAP/SLAT Lever .......................................................................................................... SET FOR TAKEOFF 2   
-- Exterior Lights ..................................................................................................................... AS REQUIRED 1/2   
-- Parking Brake ................................................................................................................................. RELEASE 1   
-- Speed and Directional Control ..................................................................................................... MAINTAIN 1   
-- Flight Instruments ........................................................................................................................... CHECK 1/2   
-- Flight Controls .................................................................................................................................... TEST 1/2   
-- Takeoff Data ................................................................................................................................... REVIEW 1/2    
-- V Bugs .............................................................................................................................................. CHECK 1/2   
-- TRC/ART ...................................................................................................................... SET AS REQUIRED 1/2   
-- Aileron, Rudder and Stabilizer Trim ......................................................................... ZERO, ZERO, CHECK 2   
-- Fuel Heat ................................................................................................................................. AS REQUIRED 2   
-- ATC Clearance ............................................................................................................................. RECEIVE 1/2 
-- FGS ........................................................................................................................................................ SET 1/2    
-- Takeoff Briefing ................................................................................................................. COMPLETE PF/PM   
-- Cabin Report ..................................................................................................................................... OBTAIN 1    
-- Taxiing Checklist ........................................................................................................................ COMPLETE 2
-- =======================================================

-- ================= TAXIING CHECKLIST ===================
-- APU AIR  Sw.........................................OFF    2 
-- TRP/ART.........................................AS RQD  1/2 
-- V Bugs.......................................__/__/__/__/  1/2 
-- Flt Instruments/FGS..............................CKD  1/2 
-- FMS/GPS..............................................CKD     PF/PM 
-- Flt Controls.....................................TESTED  1/2 
-- FLAP/SLAT Lever...........................__/EXT  1/2 
-- Autobrake/Autospoiler...................AS RQD  1/2 
-- Ail,Rudder & 
-- Stab Trim........................ZERO/ZERO/CKD    2 
-- T.O. Briefing..........................PERFORMED    PF/PM 
-- Cabin Report..............................OBTAINED    1 
-- Taxiing Checklist Completed 
-- =======================================================







-- Sets air conditioning supply AUTO  Set CAPT Pitot Heater ON
-- Check Hydraulic pumps and switcheS HI/ON
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

-- ============== BEFORE TAKEOFF PROCEDURE ===============
-- Line-Up and Takeoff Clearance ..................................................................................................... RECEIVE 2   
-- ATC/TCAS ............................................................................................................................................ TA/RA 2   
-- Fuel Balance .................................................................................................................................... CHECK 1/2   
-- Brake Temperatures .......................................................................................................................... CHECK 2   
-- Takeoff Immanency ................................................................................................................ ANNOUNCE 1/2   
-- EGPWS TERR Sw ................................................................................................................................... ON PM 
-- Radar ................................................................................................................................... AS REQUIRED 1/2   
-- ENG IGN Selector ................................................................................................................................. BOTH 1   
-- EOAP ................................................................................................................................................ CHECK 1/2   
-- Before Takeoff Checklist ............................................................................................................ COMPLETE 2
-- =======================================================

-- ============== BEFORE TAKEOFF CHECKLIST ===============
-- T.O. RWY......RWY ___/ENTRY POINT__        1/2 
-- T.O. Data................................CONFIRMED  1/2 
-- Fuel Balance..........................................CKD  1/2 
-- Brake Temperatures..............................CKD    2 
-- ENG IGN Sel......................................BOTH    2 
-- EOAP....................................................CKD
-- =======================================================

-- ================= TAKEOFF PROCEDURE ===================
-- Landing and Exterior Lights ................................................................................................. AS REQUIRED 1    
-- Thrust Levers .................................................................................................................................. 1.4 EPR 1/2   
-- Autothrottle .................................................................................................................................. ENGAGE 1/2    
-- Thrust Levers ...................................................................................... SET T.O. THRUST/CHECK MIN N1 1/2    
-- Clocks ............................................................................................................................................... START 1/2    
-- Airplane Directional Control ...................................................................................................... MAINTAIN 1/2  
-- EEDP/ESDP ................................................................................................................................ MONITOR 1/2   
-- Airspeed Indicators (80 knots) ......................................................................................... CROSS-CHECK 1/2   
-- V Speeds .................................................................................................................................. ANNOUNCE 1/2   
-- Airplane Rotation ......................................................................................................................... ACHIEVE 1/2   
-- Landing Gear .............................................................................................................................. RETRACT 1/2  
-- Landing Lights ............................................................................................................................... RETRACT 1   
-- Autopilot .......................................................................................................................................... ON   PF/PM   
-- FGS .........................................………………...………………………………………….....……… AS RQD PF/PM  
-- FMS …………………………………………………………...............................…….......................... SET PF/PM   

-- At Thrust Reduction Altitude
-- Climb EPR ............................................................................................................................................. SET 1/2   

-- At Acceleration Altitude  
-- FGS ...........................................………………………………………………….…………… VNAV/IAS SET PF  
-- Flaps/Slats .................................................................................................................................. RETRACT 1/2    
-- FLAP T.O. Selector ............................................................................................................................... STOW 2
-- ART Switch (if T.O. Flex Used) ............................................................................................................ AUTO 2  
-- =======================================================


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


-- ============== AFTER TAKEOFF PROCEDURE ================
-- FMS ................................................................................................................................ AS REQUIRED PF/PM   
-- ENG IGN Selector ............................................................................................................... AS REQUIRED PM   
-- Fuel System ........................................................................................................................ AS REQUIRED PM    
-- Hydraulic System …................................................................................................................ CHECK/SET PM    
-- Brake Temperatures .......................................................................................................................... CHECK 2    
-- Spoilers ................................................................................................................................... FLIGHT MODE 1   
-- Altimeters (CM1/CM2/Stand-by) ....................................................................................... 1013/1013/1013 1/2    
-- After Takeoff Checklist ........................................................................................................... COMPLETE PM  
-- =======================================================

-- ============== AFTER TAKEOFF CHECKLIST ================
-- Brake Temperatures..............................CKD 
-- Landing Gear...........................UP/LTS OUT 
-- Autobrake...............................................OFF 
-- SPEEDBRAKE Lever............................RET  
-- FLAP/SLAT Lever..........................UP/RET 
-- ENG IGN Sel..................................AS RQD 
-- Center Fuel Tank Pump..................AS RQD 
-- Altimeters............................1013/1013/1013  1/2 
-- After Takeoff Checklist Completed 
-- =======================================================

-- 10000 feet  Wing Landing lights OFF
-- Transition Altitude or cleared above :
--  “TRANSITION 2992 / 1013"  Altimeter FO 2992 / 1013 SET
--  Altimeter CA 2992 / 1013 SET
--  "PASSING FLIGHT LEVEL xxx …. --> "NOW”

-- ================== CLIMB PROCEDURE ====================
-- EOAP ................................................................................................................................................... CHECK 2   
-- Radar .................................................................................................................................... AS REQUIRED 1/2   
-- EGPWS ................................................................................................................................ AS REQUIRED PM   
-- Cabin Signs ............................................................................................................................ AS REQUIRED 1   
-- FMS ........................................................................................................................................... AS RQD PF/PM   
-- TCAS A/N/B button ................................................................................................................... B (BELOW) 1/2   
-- Engine/Airplane Systems ........................................................................................................... MONITOR 1/2    
-- Altimeters .................................................................................................................... CROSS-CHECK PF/PM  
-- =======================================================



-- ================= DESCEND PREPARTION ==================
-- Weather Information .................................................................................................................... RECEIVE PM   
-- Landing Data .......................................................................................................................... CONFIRMED 1/2   
-- V Bugs ................................................................................................................................................... SET 1/2   
-- MSA .................................................................................................................................................. CHECK 1/2   
-- APPROACH and LANDING BRIEFING ................................................................................ PERFORM PF/PM  
-- FMS ........................................................................................................................................... AS RQD PF/PM   
-- Altitude Reference Bugs (If required) .................................................................................................. SET 1/2   
-- MDF ........................................................................................................................................... _____/X-CK 1/2   
-- Radio Altimeters ................................................................................................................................... SET 1/2    
-- TCAS A/N/B button ................................................................................................................... B (BELOW) 1/2  
-- EGPWS TERR Sw .......................................................................................................................... AS RQD PM    
-- Fuel Heat System ................................................................................................................... AS REQUIRED 1   
-- WINDSHIELD ANTI-FOG Switch ........................................................................................... AS REQUIRED 1   
-- Hydraulic System ................................................................................................................... SET & CHECK 2   
-- Pressurization ......................................................................................................................... CHECK/SET PM  
-- Descent Clearance ........................................................................................................................ OBTAIN PM    
-- FGS ........................................................................................................................................... AS RQD PF/PM 
-- Descent Checklist ................................................................................................................... COMPLETE PM  
-- =======================================================

-- ================= DESCEND CHECKLIST ===================
-- MSA......................................................CKD    PF/PM 
-- APPR and LND Briefing.......PERFORMED    PF/PM 
-- MDF......................................._____/X-CKD    PF/PM 
-- Landing Data..........................CONFIRMED  1/2 
-- V Bugs.......................................__/__/__/__/ PF/PM 
-- Radio Altimeter/Audio Marker........SET/ON    PF/PM 
-- Hyd Sys......................................SET & CKD    2 
-- Pressurization….............................CKD/SET     PM 
-- Descent Checklist Completed 
-- =======================================================


-- ================= DESCEND PROCEDURE ===================
-- DESCENT ..................................................................................................................................... MONITOR PF  
-- SPEEDBRAKE Lever ........................................................................................................... AS REQUIRED PF   
-- Radio and Flight Instruments ................................................................................... SET/CROSS CHECK 1/2   
-- Cabin Signs ................................................................................................................................................ ON 1   
-- Fuel System .............................................................................................................................................. SET 1   
-- Altimeters ................................................................................................................................ QNH & X-CK 1/2   
-- ENG SYNC Selector ................................................................................................................................. OFF 2    
-- Approach Checklist ................................................................................................................. COMPLETE PM  
-- =======================================================

-- ================= APPROACH CHECKLIST ==================
-- Cabin Signs.......................................ON/ON   PM 
-- Fuel Sys..................................................SET   PM 
-- Altimeters and Bugs......... __/__/__/X-CKD   1/2 
-- Approach Checklist Completed 
-- =======================================================

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

-- ================== FINAL PROCEDURE ====================
-- Initial Approach Configuration ................................................................................................... ACHIEVE 1/2   
-- FGS .......................................................................................................................... SET FOR APPROACH 1/2   
-- FGS (AUTOLAND) ................................................................................................... SET FOR APPROACH 1/2   
-- Localizer/VOR Capture ............................................................................................................... MONITOR 1/2   
-- Glide Slope Capture .................................................................................................................... MONITOR 1/2   
-- Landing Gear ................................................................................................................................. EXTEND 1/2
-- TRC .......................................................................................................................................................... GA 1/2   
-- Landing Lights …....................................................................................................................... EXT ON/BRT 1   
-- Final Approach Configuration .................................................................................................... ACHIEVE 1/2  
-- FLAP/SLAT Lever (If Required) ....................................................................................................... 40/EXT 1/2   
-- SPEEDBRAKE Lever .............................................................................................................................. ARM 1   
-- ENG IGN Selector ................................................................................................................................. BOTH 1    
-- FUEL HEAT Sw ........................................................................................................................................ OFF 1    
-- EOAP ................................................................................................................................................ CHECK 1/2 
-- FGS ......................................................................................................................................... SET FOR G/A PF   
-- Final Checklist ......................................................................................................................... COMPLETE PM    
-- Radio Altimeter Callouts ............................................................................................................ MONITOR 1/2   
-- Windshield Wipers ............................................................................................................. AS REQUIRED PM   
-- Autopilot (If AUTOLAND Not Used) ..................................................................................................... OFF 1/2
-- =======================================================

-- ================== FINAL CHECKLIST ====================
-- Land Gear/Lts..................DOWN/3 GREEN  1/2 
-- FLAP/SLAT Lever...........................__/EXT  PM 
-- SPEEDBRAKE Lever.........................ARM  PM 
-- Autobrake.......................................AS RQD  PM 
-- ENG IGN Sel.....................................BOTH  PM 
-- EOAP....................................................CKD  PM 
-- Final Checklist Completed 
-- =======================================================

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



-- ============== AFTER LANDING PROCEDURE ================
-- SPEEDBRAKE Lever ........................................................................................................................ DISARM 1   
-- Exterior Lights ..................................................................................................................... AS REQUIRED 1/2    
-- FLAP/SLAT Lever ............................................................................................................................... 15/EXT 2   
-- ENG IGN Selector .................................................................................................................................... OFF 2 
-- Pitot and Static Heaters .......................................................................................................................... OFF 2   
-- AIR FOIL and ENG Anti-Ice Switches .................................................................................................... OFF 2   
-- WINDSHIELD ANTI-FOG Switch ............................................................................................................. OFF 2   
-- WINDSHIELD ANTI-ICE Switch ............................................................................................. AS REQUIRED 2   
-- EGPWS TERR Sw ................................................................................................................................. OFF PM    
-- ATC/TCAS ........................................................................................................................................... XPNDR 2     
-- APU (If Required) ................................................................................................................. START/BUS ON 2   
-- Air Cond Sys ........................................................................................................................ AS REQUIRED 1/2  
-- One Engine (If applicable) ....................................................................................................... SHUT DOWN 1   
-- Radar ........................................................................................................................................................ OFF 2    
-- After Landing Checklist ............................................................................................................. COMPLETE 2
-- =======================================================

-- ============== AFTER LANDING CHECKLIST ================
-- FLAP/SLAT Lever...........................15/EXT 
-- Autobrake...............................................OFF 
-- SPEEDBRAKE Lever............................RET 
-- ENG IGN Sel.........................................OFF 
-- Pitot & Static Heaters.............................OFF 
-- AIR FOIL & ENG Anti- 
-- Ice Sw....................................................OFF 
-- WX Radar..............................................OFF 
-- After Landing Checklist Completed 
-- =======================================================


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

-- ================= PARKING PROCEDURE ===================
-- APU (If Required) ................................................................................................................. START/BUS ON 2   
-- Exterior Lights ...................................................................................................................................... OFF 1/2   
-- FLAP/SLAT Lever .............................................................................................................................. UP/RET 2   
-- Stabilizer Trim (If Required) ................................................................................................................. ZERO 2   
-- Parking Brake .......................................................................................................................................... SET 1    
-- Electrical Power .............................................................................................................................. APU/EXT 2   
-- FUEL Shutoff Levers ............................................................................................................................... OFF 1   
-- SEAT BELTS Switch ................................................................................................................................ OFF 2   
-- FUEL TANK PUMP Switches ................................................................................................ AS REQUIRED 2   
-- Pneu X-Feed Valves .............................................................................................................................. OPEN 2 
-- APU AIR Switch ......................................................................................................................................... ON 2  
-- AIR COND SUPPLY Sws (one at a time) ............................................................................................. AUTO 2  
-- SUPPLY AIR PRESS Indicator .......................................................................................... 12 PSI or greater 2  
-- Anti- Collision Lights ............................................................................................................................... OFF 2   
-- Galley Power ............................................................................................................................................ OFF 2   
-- EFIS/FD Switches .................................................................................................................. AS RQD/OFF 1/2   
-- EOAP ................................................................................................................................................... CHECK 2    
-- Parking Brake (If Chocks In Place) .............................................................................................. RELEASE 1   
-- Auxiliary and Transfer Hydraulic Pumps .............................................................................................. OFF 2   
-- ATC/TCAS .............................................................................................................................................. STBY 2   
-- Cabin Air Outflow Valves ...................................................................................................... AS REQUIRED 2
-- DOOR LOCK Sw .............................................................................................................................. UNLKD 1/2   
-- Parking Checklist ........................................................................................................................ COMPLETE 2  
-- =======================================================

-- ================= PARKING CHECKLIST ===================
-- FUEL TANK PUMP Sw................AS RQD    2 
-- Aux & Trans Hyd Pumps......................OFF    2 
-- Parking Brake........................................SET    1 
-- Parking Checklist Completed 
-- =======================================================


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

-- ================== LEAVING AIRCRAFT ===================
-- Emergency Lights ................................................................................................................................... OFF 2   
-- Position Lights ......................................................................................................................................... OFF 2    
-- Station Lighting ....................................................................................................................................... OFF 2    
-- APU ......................................................................................................................................... AS REQUIRED 2    
-- BATT Switch ........................................................................................................................... AS REQUIRED 2   
-- Leaving the Airplane Checklist .................................................................................................. COMPLETE 2  
-- =======================================================

-- ============= LEAVING AIRCRAFT CHECKLIST ==============
-- Emergency Lts........................................OFF    2 
-- EFB ....................................................... OFF     1/2 
-- APU.................................................AS RQD    2 
-- BATT Sw........................................AS RQD    2 
-- Leaving The Airplane Checklist Completed
-- =======================================================






-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		getActiveSOP():setActiveFlowIndex(1)
	end))

-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",6,true,
	function () 
		kc_macro_state_turnaround()
	end))
turnAroundProc:addItem(ProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,2,
	function () return sysElectric.apuStartSwitch:getStatus() == 2 end,
	function () sysElectric.apuStartSwitch:repeatOn() end))
turnAroundProc:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_N1_percent") > 90 end,
	function () 
		sysElectric.apuStartSwitch:repeatOff() 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		sysAir.bleedEng1Switch:actuate(1)
		sysAir.packLeftSwitch:actuate(1)
		sysFuel.fuelPumpRightAft:actuate(1)
		getActiveSOP():setActiveFlowIndex(1)
		sysEngines.startPumpDc:actuate(0)								   
	end))
turnAroundProc:addItem(ProcedureItem:new("SET REST","SET","SYS",6,true,
	function () 
		kc_macro_state_turnaround2()
		getActiveSOP():setActiveFlowIndex(3)
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
activeSOP:addProcedure(cockpitPrepProc2)
activeSOP:addProcedure(cockpitPrepProc1)
activeSOP:addProcedure(cockpitPrepProc3)
-- activeSOP:addProcedure(preStartChecklist)
-- activeSOP:addProcedure(beforeStartProc)
-- activeSOP:addProcedure(pushstartProc)
-- activeSOP:addProcedure(afterStartChkl)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_MD82
