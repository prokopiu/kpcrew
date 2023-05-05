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
-- CIRCUIT BREAKERS.....................CHECK ALL IN (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)
-- LANDING GEAR LEVER...........................DOWN (F/O)
-- FLAP LEVER....................................SET (F/O)
--   Set the flap lever to agree with the flap position.
-- PARKING BRAKE..................................ON (F/O)

-- DC Electric Power
-- BATTERY SWITCH..........................ON & LOCK (F/O)
-- ANTI COLLISION LIGHT...........................ON (F/O)
-- WING/NACL LIGHTS...............................ON (F/O)

-- ==== Activate External Power
-- EXT POWER.................................CONNECT (F/O)
-- EXT PWR L & R..............................ON BUS (F/O)

-- ==== Activate APU 
-- FIRE LOOP TEST............................PERFORM (F/O)
-- START PUMP SW (DC).............................ON (F/O)
-- APU START SW................................START (F/O)
--   APU STARTER LIGHT ON WAAP...........ILLUMINATED (F/O)
--   APU PWR AVAIL.......................ILLUMINATED (F/O)
--   APU POWER 115V & 400HZ....................CHECK (F/O)
--   APU L & R BUS................................ON (F/O)
--   APU POWER CONSUMPTION...........CHECK BELOW 1.0 (F/O)
--   APU AIR......................................ON (F/O)
-- • AIR pressure centure duct CHECK  ?? ?where
--   RIGHT PNEU-X-FEED..........................OPEN (F/O)
--   RIGHT AIR COND SUPPLY......................AUTO (F/O)
--   RIGHT AFT FUEL PUMP SW.......................ON (F/O)
--   START PUMP SW (DC)..........................OFF (F/O)
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
	function () return sysGeneral.wiperSwitch1:getStatus() == 0 end,
	function () sysGeneral.wiperSwitch1:actuate(0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:actuate(0) end))								 
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 24V",FlowItem.actorFO,0,"bat24v",
	function () return get("sim/flightmodel/engine/ENGN_bat_volt",0) > 23 end,
	function () sysElectric.voltmeterSwitch:actuate(4) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,0,"battswitch_safe",
	function () return 
		sysElectric.batterySwitch:getStatus() == 1 and
		get("laminar/md82/safeguard",3) == 1
	end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		if get("laminar/md82/safeguard",3) == 0 then 
			command_once("laminar/md82cmd/safeguard03")
		end
		kc_macro_ext_lights_stand()
		kc_macro_int_lights_on()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () sysLights.positionSwitch:actuate(1) end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuSwitch:getStatus() == 1 and
		sysElectric.gpuGenBus1:getStatus() == 1 and
		sysElectric.gpuGenBus2:getStatus() == 1
	end,
	function () kc_macro_gpu_connect() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FIRE LOOPS A TEST","TEST",FlowItem.actorFO,12,"testloopa",
	function () return get("sim/cockpit2/annunciators/engine_fires",0) == 1 end,
	function () command_begin("sim/annunciator/test_fire_L_annun") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FIRE LOOPS B TEST","TEST",FlowItem.actorFO,12,"testloopb",
	function () return get("sim/cockpit2/annunciators/engine_fires",1) == 1 end,
	function () 
		command_end("sim/annunciator/test_fire_L_annun") 
		command_begin("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("START PUMP SW (DC)","ON",FlowItem.actorFO,0,"startuppmp",
	function () return sysEngines.startPumpDc:getStatus() == 1 end,
	function () 
		sysEngines.startPumpDc:actuate(1)
		command_end("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,2,"apupwrstart",
	function () return sysElectric.apuStartSwitch:getStatus() == 2 end,
	function () sysElectric.apuStartSwitch:repeatOn() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_N1_percent") > 90 end,
	function () sysElectric.apuStartSwitch:repeatOff() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# L & R BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBus1:getStatus() == 1 and
		sysElectric.apuGenBus2:getStatus() == 1 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# POWER CONSUMPTION","CHECK BELOW 1.0",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/bus_load_amps") < 59.0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  RIGHT PNEU-X-FEED","OPEN",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() > 0 end,
	function () sysAir.bleedEng1Switch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  RIGHT AFT FUEL PUMP SW","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpRightAft:getStatus() > 0 end,
	function () 
		sysFuel.fuelPumpGroup:actuate(0)
		sysFuel.fuelPumpRightAft:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- • AIR pressure centure duct CHECK  ?? ?where
electricalPowerUpProc:addItem(ProcedureItem:new("START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return sysEngines.startPumpDc:getStatus() == 0 end,
	function () sysEngines.startPumpDc:actuate(0) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== "))
electricalPowerUpProc:addItem(ProcedureItem:new("AVIONICS BRIGHTNESS","SET",FlowItem.actorFO,0,
	function () return sysLights.instr7Light:getStatus() > 0 end,
	function () kc_macro_glareshield_initial() end))

-- ================= PREFLIGHT PROCEDURE =================
-- ELECTRICAL POWER UP......................COMPLETE (F/O)
-- PRIMARY FLIGHT DISPLAYS........................ON (F/O)
-- NAVIGATION DISPLAYS............................ON (F/O)
-- ANNUNCIATOR LIGHTS ..........................TEST (F/O)
-- FLIGHT DIRECTORS...............................ON (F/O)
-- EFIS ........................................TEST (F/O)
-- AUTOLAND AVAILABILITY........................TEST (F/O)
-- TRIM.........................................TEST (F/O)
-- ENGINE SYNC SELECTOR..........................OFF (F/O)
-- GALLEY POWER...................................ON (F/O)
-- FUEL PUMP SWITCH.............................TEST (F/O)
-- NO SMOKING.....................................ON (F/O)
-- PITOT HEATER.................................TEST (F/O)
-- WINDSHIELD HEAT................................ON (F/O)
-- PNEUMATIC X-FEEDS............................OPEN (F/O)
-- GPWS.........................................TEST (F/O)
-- WINDSHEAR....................................TEST (F/O)
-- ANTI SKID....................................TEST (F/O)
-- STALL........................................TEST (F/O)
-- OVERSPEED....................................TEST (F/O)
-- YAW DAMPER.....................................ON (F/O)
-- ICE FOD......................................TEST (F/O)
-- TCAS.........................................TEST (F/O)
-- SET XPONDER.................................ABOVE (F/O)
-- TAKEOFF WARNING..............................TEST (F/O)
-- HYDRAULIC PUMP...............................TEST (F/O)
-- GEAR.........................................TEST (F/O)
-- WX RADAR.....................................TEST (F/O)
-- SET ALTIMETERS................................SET (F/O)
-- TRP..........................................TEST (F/O)
-- TRP TO TAKEOFF................................SET (F/O)
-- ADF..........................................TEST (F/O)
-- ZFW..........................................TEST (F/O)

-- BRIEFING..................................PERFORM (CPT)
-- STANDBY ATTITUDE INDICATOR...................CAGE (CPT)
-- EMERGENCY LIGHT TEST......................PERFORM (CPT)
-- ARRIVAL ELEVATION.............................SET (CPT)
-- FLIGHT DATA RECORDER PANEL....................SET (CPT)
-- FLIGHT CONTROL PANEL..........................SET (CPT)
-- FMS MCDU PROGRAMMING......................PERFORM (CPT)
-- AUTOFLIGHT PANEL..............................SET (CPT)
-- TRANSPONDER CODE..............................SET (CPT)

-- APU.........................................START (CPT)
-- COM, NAV RADIO'S AND TRANSPONDER..............SET (CPT)
-- TRP (IF REDUCED TAKE OFF) ....................SET (CPT)
-- SPEED BUGS....................................SET (CPT)
-- DEPARTURE BRIEF...........................PERFORM (CPT)
-- =======================================================

local preflightProc = Procedure:new("PREFLIGHT PROCEDURE","starting pre flight procedure","")
preflightProc:setFlightPhase(2)
preflightProc:setResize(false)
preflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuRunningAnc:getStatus() > 0 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
preflightProc:addItem(ProcedureItem:new("PRIMARY FLIGHT DISPLAYS","ON",FlowItem.actorFO,0,
	function () return sysLights.instr6Light:getStatus() == 1 end,
	function () sysLights.instr6Light:actuate(1)end))
preflightProc:addItem(ProcedureItem:new("NAVIGATION DISPLAYS","ON",FlowItem.actorFO,0,
	function () return sysLights.instr7Light:getStatus() == 1 end,
	function () sysLights.instr7Light:actuate(1)end))
preflightProc:addItem(IndirectProcedureItem:new("ANNUNCIATOR LIGHTS","TEST",FlowItem.actorFO,3,"annuntest",
	function () return get("sim/cockpit/warnings/annunciator_test_pressed") == 1 end,
	function () command_begin("sim/annunciator/test_all_annunciators") end,
	function () return activeBriefings:get("flight:firstFlightDay") == true end))
preflightProc:addItem(ProcedureItem:new("EFIS","TEST",FlowItem.actorFO,0,true,
	function () command_end("sim/annunciator/test_all_annunciators") end))
preflightProc:addItem(ProcedureItem:new("AUTOLAND AVAILABILITY","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("TRIM","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("ENGINE SYNC SELECTOR","OFF",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
preflightProc:addItem(ProcedureItem:new("FUEL PUMP SWITCH","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("NO SMOKING","ON",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() == 1 end,
	function () sysGeneral.noSmokingSwitch:actuate(1) end))
preflightProc:addItem(ProcedureItem:new("PITOT HEATER","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 1 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightProc:addItem(ProcedureItem:new("PNEUMATIC X-FEEDS","OPEN",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
preflightProc:addItem(ProcedureItem:new("GPWS","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("WINDSHEAR","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("ANTI SKID","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("STALL","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("OVERSPEED","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorFO,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))
preflightProc:addItem(ProcedureItem:new("ICE FOD","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("TCAS","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("TRANSPONDER","ABOVE/SRBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() <= 1 end,
	function () sysRadios.xpdrSwitch:actuate(0) end))
preflightProc:addItem(ProcedureItem:new("TAKEOFF WARNING","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("HYDRAULIC PUMP","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("GEAR","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("WX RADAR","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString(kc_metar_local)",FlowItem.actorBOTH,0,true,
	function () 
		kc_macro_set_local_baro()
	end))
preflightProc:addItem(ProcedureItem:new("ADF","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("ZFW","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("TRP","TEST",FlowItem.actorFO,0,true,nil))
preflightProc:addItem(ProcedureItem:new("TRP TO TAKEOFF","SET",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action=1 end))

preflightProc:addItem(HoldProcedureItem:new("BRIEFING","PERFORM",FlowItem.actorCPT))
preflightProc:addItem(ProcedureItem:new("STANDBY ATTITUDE INDICATOR","CAGE",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("EMERGENCY LIGHT TEST","PERFORM",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("ARRIVAL ELEVATION","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("FLIGHT DATA RECORDER PANEL","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("FLIGHT CONTROL PANEL","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(HoldProcedureItem:new("FMS MCDU PROGRAMMING","PERFORM",FlowItem.actorCPT))
preflightProc:addItem(ProcedureItem:new("AUTOFLIGHT PANEL","SET",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		kc_macro_glareshield_initial()
		
	end))
preflightProc:addItem(ProcedureItem:new("FLIGHT DIRECTORS","ON",FlowItem.actorCPT,0,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end,
	function () 
		sysMCP.fdirPilotSwitch:actuate(1)													   
	end))
preflightProc:addItem(ProcedureItem:new("TRANSPONDER CODE","SET",FlowItem.actorCPT,0,
	function () return sysRadios.xpdrSwitch:getStatus() <= 1 end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) 
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end))
preflightProc:addItem(ProcedureItem:new("TAKEOFF FLAPS DIAL","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("CG TAKEOFF COMPUTER","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("STABILIZER TRIM","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(ProcedureItem:new("SEAT BELT SIGNS","ON",FlowItem.actorCPT,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () 
		sysGeneral.seatBeltSwitch:actuate(1)
	end))
	
-- APU
preflightProc:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(IndirectProcedureItem:new("FIRE LOOPS A TEST","TEST",FlowItem.actorFO,12,"testloopa",
	function () return get("sim/cockpit2/annunciators/engine_fires",0) == 1 end,
	function () command_begin("sim/annunciator/test_fire_L_annun") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(IndirectProcedureItem:new("FIRE LOOPS B TEST","TEST",FlowItem.actorFO,12,"testloopb",
	function () return get("sim/cockpit2/annunciators/engine_fires",1) == 1 end,
	function () 
		command_end("sim/annunciator/test_fire_L_annun") 
		command_begin("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(IndirectProcedureItem:new("START PUMP SW (DC)","ON",FlowItem.actorFO,0,"startuppmp",
	function () return sysEngines.startPumpDc:getStatus() == 1 end,
	function () 
		sysEngines.startPumpDc:actuate(1)
		command_end("sim/annunciator/test_fire_R_annun") 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(IndirectProcedureItem:new("#spell|APU# START SW","START",FlowItem.actorFO,2,"apupwrstart",
	function () return sysElectric.apuStartSwitch:getStatus() == 2 end,
	function () sysElectric.apuStartSwitch:repeatOn() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

preflightProc:addItem(ProcedureItem:new("  #spell|APU# PWR AVAIL LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_N1_percent") > 90 end,
	function () sysElectric.apuStartSwitch:repeatOff() end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("  #spell|APU# L & R BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBus1:getStatus() == 1 and
		sysElectric.apuGenBus2:getStatus() == 1 
	end,
	function () 
		sysElectric.apuGenBus1:actuate(1)
		sysElectric.apuGenBus2:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("  #spell|APU# POWER CONSUMPTION","CHECK BELOW 1.0",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/bus_load_amps") < 65.0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("  #spell|APU# AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("  RIGHT PNEU-X-FEED","OPEN",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() > 0 end,
	function () sysAir.bleedEng1Switch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("  RIGHT AFT FUEL PUMP SW","ON",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpRightAft:getStatus() > 0 end,
	function () 
		sysFuel.fuelPumpGroup:actuate(0)
		sysFuel.fuelPumpRightAft:actuate(1)
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
-- • AIR pressure centure duct CHECK  ?? ?where
preflightProc:addItem(ProcedureItem:new("START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return sysEngines.startPumpDc:getStatus() == 0 end,
	function () sysEngines.startPumpDc:actuate(0) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightProc:addItem(ProcedureItem:new("EXT POWER","DISCONNECT",FlowItem.actorCPT,0,
	function () return 
		sysElectric.gpuGenBus1:getStatus() == 0 and
		sysElectric.gpuGenBus2:getStatus() == 0 and
		sysElectric.gpuSwitch:getStatus() == 0 
	end,
	function () kc_macro_gpu_disconnect() end))


preflightProc:addItem(HoldProcedureItem:new("COM, NAV RADIO'S AND TRANSPONDER","SET",FlowItem.actorCPT))
preflightProc:addItem(ProcedureItem:new("TRP (IF REDUCED TAKE OFF)","SET",FlowItem.actorCPT,0,true,nil))
preflightProc:addItem(HoldProcedureItem:new("SPEED BUGS","SET",FlowItem.actorCPT))
preflightProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEF","PERFORM",FlowItem.actorCPT,
	function () kc_wnd_brief_action = 1 end))


-- ========= PRE-START CHECK ABOVE (F/O SILENT) ==========
-- CIRCUIT BREAKERS.....................CHECK ALL IN (F/O)
-- L & R AC BUS X TIE...........................AUTO (F/O)
-- DC BUS X TIE.................................OPEN (F/O)
-- EMERG POWER...........................CHECKED/OFF (F/O)
-- GALLEY POWER...................................ON (F/O)
-- CABIN ALT CNTRL WHEEL/LEVER AUTO/VALVE.......OPEN (F/O)
-- PNEUM X-FEED VALVE LEVERS....................OPEN (F/O)
-- CABIN PRESS CONTROL...........................SET (F/O)
-- COCKPIT / CABIN CONTROL..........TEMP AS REQUIRED (F/O)
-- OXYGEN CYL PRESS..........................CHECKED (F/O)
-- FLIGHT RECORDER.......................CHECKED/SET (F/O)
-- VOICE RECORDER............................CHECKED (F/O)
-- CADC/FD CMD/ EFIS SEL....................... NORM (F/O)
-- ENG SYNC SELECTOR ............................OFF (F/O)
-- GPWS......................................CHECKED (F/O)
-- ANTI-SKID ..........................CHECKED/ARMED (F/O)
-- STALL WARNING.............................CHECKED (F/O)
-- MAX SPEED WARNING.........................CHECKED (F/O)
-- MACH TRIM COMPENSATOR.....................ON/NORM (F/O)
-- YAW DAMPER.....................................ON (F/O)
-- RADIO RACK....................................FAN (F/O)
-- AIR COND SHUTOFF.............................AUTO (F/O)
-- RAM AIR.......................................OFF (F/O)
-- FUEL PUMPS................................CHECKED (F/O)
-- IGNITION......................................OFF (F/O)
-- EMER LIGHTS.........................CHECKED/ARMED (F/O)
-- NO SMOKING SW..................................ON (F/O)
-- SEATBELT SW....................................ON (F/O)
-- PITOT HEAT............................CHECKED/OFF (F/O)
-- AIRFOIL / ENG ANTI ICE....................... OFF (F/O)
-- WINDSHIELD HEAT................................ON (F/O)
-- ANNUNCIATOR / DIGITAL LIGHTS............. CHECKED (F/O)
-- DFGS / NAVAIDS................................SET (F/O)
-- FLIGHT INSTRUMENTS....................... CHECKED (F/O)
-- BRAKE PRESSURE & TEMP.................... CHECKED (F/O)
-- HYDRAULIC SYSTEM..........................CHECKED (F/O)
-- GEAR LIGHTS & AURAL WARNING.............. CHECKED (F/O)
-- FUEL USED...................................RESET (F/O)
-- ENGINE INSTRUMENTS........................CHECKED (F/O)
-- STATIC AIR SELECTOR..........................NORM (F/O)
-- TCAS......................................CHECKED (F/O)
-- RADAR.....................................CHECKED (F/O)
-- RUD HYD CONTROL.........................LEVER PWR (F/O)
-- FUEL X-FEED.............................LEVER OFF (F/O)
-- FUEL SWITCHES.............................CHECKED (F/O)

-- T/O WARNING.............................. CHECKED (F/O)
-- STABILIZER................................CHECKED (F/O)
-- SPOILERS.............................DISARMED/RET (F/O)
-- FLAPS/SLATS..............................UP / RET (F/O)
-- =======================================================

local preStartProc = Procedure:new("PRE-START CHECKS ABOVE THE LINE","performing pre-start checks","ready for pre start checklist")
preStartProc:setFlightPhase(4)
preStartProc:setResize(false)
preStartProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("L & R AC BUS X TIE","AUTO",FlowItem.actorFO,0,
	function () return sysElectric.acBusXTie:getStatus() == 1 end,
	function () sysElectric.acBusXTie:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("DC BUS X TIE","OPEN",FlowItem.actorFO,0,
	function () return sysElectric.dcBusXTie:getStatus() == 0 end,
	function () sysElectric.dcBusXTie:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("EMERG POWER","CHECKED/OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit/electrical/battery_array_on",1) == 0 end,
	function () command_once("sim/electrical/battery_2_off") end))
preStartProc:addItem(ProcedureItem:new("GALLEY POWER","OFF",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 0 end,
	function () sysElectric.galleyPower:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("CABIN ALT CNTRL WHEEL/LEVER AUTO/VALVE","OPEN",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("PNEUM X-FEED VALVE LEVERS","BOTH OPEN",FlowItem.actorFO,0,
	function () return 
		sysAir.bleedEng1Switch:getStatus() > 0 and
		sysAir.bleedEng2Switch:getStatus() > 0 
	end,
	function () 
		sysAir.bleedEng1Switch:actuate(1) 
		sysAir.bleedEng2Switch:actuate(1) 
	end))
preStartProc:addItem(ProcedureItem:new("CABIN PRESS CONTROL","SET",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("COCKPIT / CABIN CONTROL","AUTO",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/HVAC_L_knob") == 0 and
		get("laminar/md82/bleedair/HVAC_R_knob") == 0
	end,
	function () 
		set("laminar/md82/bleedair/HVAC_L_knob",0)
		set("laminar/md82/bleedair/HVAC_R_knob",0)
	end))
preStartProc:addItem(ProcedureItem:new("OXYGEN CYL PRESS","CHECK",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("FLIGHT RECORDER","CHECK/SET",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("VOICE RECORDER","CHECK",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("CADC/FD CMD/ EFIS SEL","NORM",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("ENG SYNC SELECTOR","OFF",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("GPWS","CHECK",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("ANTI-SKID","CHECKED/ARMED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/generic_lights_switch",35) > 0 end,
	function () 
		if get("sim/cockpit2/switches/generic_lights_switch",35) == 0 then
			command_once("sim/lights/generic_36_light_tog")
		end
	end))
preStartProc:addItem(IndirectProcedureItem:new("STALL WARNING","CHECK",FlowItem.actorFO,2,"stallwarn",
	function () return get("sim/cockpit2/annunciators/stall_warning") > 0 end,
	function () command_begin("sim/annunciator/test_stall") end))
preStartProc:addItem(ProcedureItem:new("MAX SPEED WARNING","CHECKED",FlowItem.actorFO,0,
	function () return true end,
	function () 
		command_end("sim/annunciator/test_stall") 
	end))
preStartProc:addItem(ProcedureItem:new("MACH TRIM COMPENSATOR","ON/NORM",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorFO,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("RADIO RACK","FAN",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("AIR COND SHUTOFF","AUTO",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("RAM AIR","OFF",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("FUEL PUMPS","CHECKED",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() > 2 end,
	function () sysFuel.fuelPumpGroup:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("IGNITION","OFF",FlowItem.actorFO,0,
	function () return sysEngines.ignition:getStatus() == 0 end,
	function () sysEngines.ignition:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("EMER LIGHTS","CHECKED/ARMED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("NO SMOKING SW","ON",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() == 1 end,
	function () sysGeneral.noSmokingSwitch:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("SEATBELT SW","ON",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 1 end,
	function () sysGeneral.seatBeltSwitch:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("PITOT HEAT","CHECKED/OFF",FlowItem.actorFO,0,
	function () return sysAice.pitotHeat:getStatus() < 2 end,
	function () sysAice.pitotHeat:actuate(2) end))
preStartProc:addItem(ProcedureItem:new("AIRFOIL ANTI ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.antiIceWingGroup:getStatus() == 0 end,
	function () sysAice.antiIceWingGroup:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("ENG ANTI ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.antiIceEngGroup:getStatus() == 0 end,
	function () sysAice.antiIceEngGroup:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preStartProc:addItem(IndirectProcedureItem:new("ANNUNCIATOR / DIGITAL LIGHTS","CHECKED",FlowItem.actorFO,5,"annuntest",
	function () return get("sim/cockpit/warnings/annunciator_test_pressed") == 1 end,
	function () command_begin("sim/annunciator/test_all_annunciators") end))
preStartProc:addItem(ProcedureItem:new("DFGS / NAVAIDS","SET",FlowItem.actorFO,0,true,
	function () command_end("sim/annunciator/test_all_annunciators") end))
preStartProc:addItem(ProcedureItem:new("FLIGHT INSTRUMENTS","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("BRAKE PRESSURE & TEMP","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("HYDRAULIC SYSTEM","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("GEAR LIGHTS & AURAL WARNING","CHECKED",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/controls/landing_gear_handle") == 1
	end,
	function () set("laminar/md82/controls/landing_gear_handle",1) end))
preStartProc:addItem(ProcedureItem:new("FUEL USED","RESET",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("ENGINE INSTRUMENTS","CHECKED",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/engine/indicators/EPR_ratio",0) == 1.0 and
		get("sim/cockpit2/engine/indicators/EPR_ratio",1) == 1.0 and
		get("sim/flightmodel/engine/ENGN_N1_",0) == 0 and
		get("sim/flightmodel/engine/ENGN_N1_",1) == 0 and
		get("sim/flightmodel2/engines/EGT_deg_C",0) < 10 and
		get("sim/flightmodel2/engines/EGT_deg_C",1) < 10 and
		get("sim/flightmodel/engine/ENGN_N2_",0) == 0 and
		get("sim/flightmodel/engine/ENGN_N2_",1) == 0
	end))
preStartProc:addItem(ProcedureItem:new("STATIC AIR SELECTOR","NORM",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("TCAS","CHECKED",FlowItem.actorFO,0,
	function () return get("sim/cockpit/radios/transponder_mode") == 1 end,
	function () set("sim/cockpit/radios/transponder_mode",1) end))
preStartProc:addItem(ProcedureItem:new("RADAR","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("RUD HYD CONTROL","LEVER PWR",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("FUEL X-FEED","LEVER OFF",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("FUEL SWITCHES","CHECKED",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() > 0 end,
	function () sysFuel.fuelPumpGroup:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("T/O WARNING","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("STABILIZER","CHECKED",FlowItem.actorFO,0,true))
preStartProc:addItem(ProcedureItem:new("SPOILERS","DISARMED/RET",FlowItem.actorFO,0,
	function () return sysControls.speedBrake:getStatus() == 0 end,
	function () sysControls.speedBrake:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("FLAPS/SLATS","UP/RETRACTED",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:actuate(0) end))

-- ================ PRE-START CHECK BELOW ================
-- COVERS & PINS.............................REMOVED (CPT)
-- AIRCRAFT LOG & DOCUMENTS.........CHECKED ON BOARD (CPT)
-- ALTIMETERS....................QNH…. SET / CHECKED (CPT)
-- FUEL/OIL/HYD QUANTITY.....................CHECKED (CPT)
-- ZERO FUEL WEIGHT..............................SET (CPT)
-- TRP......................TAKEOFF / … TAKEOFF FLEX (CPT)
-- STABILIZER..........POINT ZERO SET (.. = 1 TO 12) (CPT)
-- FLAPS TAKEOFF SELECTOR.....................STOWED (CPT)
-- SPEED BUGS....................................SET (CPT)
-- =======================================================

local preStartChecklist = Checklist:new("PRE-START CHECKLIST BELOW","pre start checklist","")
preStartChecklist:setFlightPhase(4)

preStartChecklist:addItem(ChecklistItem:new("COVERS & PINS","REMOVED",FlowItem.actorCPT,0,true))
preStartChecklist:addItem(ChecklistItem:new("AIRCRAFT LOG & DOCUMENTS","CHECKED ON BOARD",FlowItem.actorCPT,0,true))
preStartChecklist:addItem(ChecklistItem:new("ALTIMETERS","SET TO LOCAL: QNH %s|activeBriefings:get(\"departure:atisQNH\")",FlowItem.actorCPT,0,
	function () 
		return kc_macro_test_local_baro()
	end,
	function () 
		kc_macro_set_local_baro()
	end))
preStartChecklist:addItem(ChecklistItem:new("FUEL/OIL/HYDRAULIC QUANTITY","CHECKED",FlowItem.actorCPT,0,true))
preStartChecklist:addItem(ChecklistItem:new("ZERO FUEL WEIGHT","SET",FlowItem.actorCPT,0,true))
preStartChecklist:addItem(ChecklistItem:new("TRP","AS REQUIRED",FlowItem.actorCPT,0,
	function () return true end,
	function ()  end))
preStartChecklist:addItem(ChecklistItem:new("STABILIZER","SET",FlowItem.actorCPT,0,
	function () return true end,
	function ()  end))
preStartChecklist:addItem(ChecklistItem:new("FLAPS TAKEOFF SELECTOR","SET 15",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/controls/flap_ratio") >= 0.6 end,
	function () set("sim/cockpit2/controls/flap_ratio",0.6) end))
preStartChecklist:addItem(ChecklistItem:new("SPEED BUGS","SET",FlowItem.actorCPT,0,
	function () return  
		get("laminar/md82/IAS/custom_bug1") == (0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038) and
		get("laminar/md82/IAS/custom_bug2") == 0.376973 and
		get("laminar/md82/IAS/custom_bug3") == 0.495849 and
		get("laminar/md82/IAS/custom_bug4") == 0.680363 and
		sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2")
	end,
	function () kc_macro_md82_set_to_speedbugs() end))

-- ================= BEFORE-START CHECK ==================
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
-- =======================================================

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
-- ENGINE START SWITCH.......HOLD TO START ENGINE _  (CPT)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 15%,
--   ENGINE FUEL LEVER...................LEVER _ ON  (CPT)
--   Release starter switch

-- PACKS................................AUTO OR OFF  (F/O)
-- SYSTEM A HYDRAULIC PUMPS......................ON  (F/O)
-- START FIRST ENGINE.............STARTING ENGINE _  (CPT)
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
--  Check Electrical Loads (AC and DC) in limits CHECK  Engine generator volts and frequencies correct CHECK
--  Galley Power ON  Engine Ignition off OFF
--  Sets air conditioning supply AUTO  Set CAPT Pitot Heater ON
--  Check Hydraulic pumps and switcheS HI/ON

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
			sysEngines.engStart2Switch:repeatOn(0) 
			kc_speakNoText(0,"starting engine 2")
		else 
			sysEngines.engStart1Switch:repeatOn(0) 
			kc_speakNoText(0,"starting engine 1")
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(ProcedureItem:new("  N2 ROTATION","AT 15%",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/flightmodel2/engines/N2_percent",0) > 14.9 else 
		return get("sim/flightmodel2/engines/N2_percent") > 14.9 end end,
	function () 
			if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart2Switch:repeatOff(0) 
			kc_speakNoText(0,"starting engine 2")
		else 
			sysEngines.engStart1Switch:repeatOff(0) 
			kc_speakNoText(0,"starting engine 1")
		end 
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT,3,"eng_start_1_lever",
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




-- ============ AFTER ENGINE START CHECKLIST =============
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
-- =======================================================

-- beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	-- function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end,



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
	
-- ============= Background Flow ==============
-- kc_procvar_initialize_bool("toctest", false)

local backgroundFlow = Background:new("","","")
backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		return
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(beforeStartProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(preflightProc)
activeSOP:addProcedure(preStartProc)
activeSOP:addProcedure(preStartChecklist)

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
