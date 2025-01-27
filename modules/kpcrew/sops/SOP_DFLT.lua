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
set("sim/private/controls/shadow/cockpit_near_adjust",1)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = "" }
					 

-- Set up SOP =========================================================================

activeSOP = SOP:new("Default Aircraft SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () kc_macro_lights_all_on() end))


	
-- ========= SAFETY & POWER ON:SAFETY & POWER ON =========
-- == INITIAL CHECKS
-- PARKING BRAKE..................................ON (F/O)
-- optional GROUND OBJECTS..................ACTIVATE
-- LANDING GEAR HANDLE..........................DOWN (F/O)
-- SPEED BRAKES & GROUND SPOILERS...............DOWN (F/O)
-- FLAP LEVER.....................................UP (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)

-- BATTERY SWITCHES...............................ON (F/O)		
-- BATTERIES, 21 VOLTS.........................CHECK (F/O)
-- EXT PWR........................................ON (F/O)		
-- GREEN LANDING GEAR LIGHT........CHECK ILLUMINATED (F/O)
-- LIGHTS................................AS REQUIRED (F/O)
-- POWER LEVERS.................................IDLE (F/O)
-- ELECTRIC HYDRAULIC PUMP........................ON (F/O)

-- AVIONICS SWITCH................................ON (F/O)		
-- AILERON TRIM/RUDDER TRIM....................RESET (F/O)
-- FUEL XFER SELECTOR............................OFF (F/O)
-- AIR CONDITIONING PACK SWITCHES...............AUTO (F/O)
-- NAV LIGHTS.................................... ON (F/O)		
-- ENGINE GENERATOR..............................OFF (F/O)
-- XPDR.....................................SET 2000 (F/O)
-- KPCREW DEPARTURE BRIEF....................PERFORM (F/O)
-- =======================================================

local electricalPowerUpProc = Procedure:new("SAFETY & POWER ON","","")
electricalPowerUpProc:setFlightPhase(1)

electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
	
if kc_has_ground_obj then -- optional ground bjects of some aircraft
	electricalPowerUpProc:addItem(ProcedureItem:new("GROUND OBJECTS","ACTIVATE",FlowItem.actorFO,0,
		function () return sysGeneral.groundObjects:getStatus() == 0 end,
		function () sysGeneral.groundObjects:actuate(0) end))
end

electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("SPEED BRAKES / GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == 0 end,
	function () sysControls.Speedbrake:setValue(0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end))	
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))
	
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() > 0 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		if kc_get_nr_batteries() > 1 then
			sysElectric.battery2Switch:actuate(1) 
		end
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERIES, 21 VOLTS","CHECK",FlowItem.actorFO,0,"battat24",
	function () 
		return sysElectric.batt1Volt:getStatus() >= 21 or sysElectric.batt1Volt:getStatus() >= 21 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuConnect:getStatus() == 1 and 
		sysElectric.gpuGenBusGroup:getStatus() > 0
	end,
	function () 
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
	end))
	
electricalPowerUpProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () kc_macro_lights_preflight() end))
electricalPowerUpProc:addItem(ProcedureItem:new("POWER LEVERS","IDLE",FlowItem.actorFO,0,
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () sysEngines.throttlePos:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() > 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))	
electricalPowerUpProc:addItem(ProcedureItem:new("AVIONICS SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.avionicsSwitchGroup:getStatus() > 0 end,
	function () sysElectric.avionicsSwitchGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE HYDRAULICS","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end))

electricalPowerUpProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		sysControls.aileronTrimSwitch:getStatus() == 0 and
		sysControls.rudderTrimSwitch:getStatus() == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL XFER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function ()  sysFuel.crossFeed:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() > 1 end,
	function () sysAir.packSwitchGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("NAV LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE GENERATORS","OFF",FlowItem.actorFO,0,
	function () return sysElectric.genSwitchGroup:getStatus() == 0 end,
	function () sysElectric.genSwitchGroup:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("DC & ESS BUS","AUTOMATIC",FlowItem.actorFO,0,
	function () return 
		sysElectric.inverterSwitchGroup:getStatus() > 0 and
		sysElectric.dcBusTie:getStatus() == 1
	end,
	function () 
		sysElectric.inverterSwitchGroup:actuate(1)
		sysElectric.dcBusTie:actuate(1)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTIMETERS","ALL SET QNH",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_set_local_baro() end))
electricalPowerUpProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () sysRadios.xpdrCode:actuate(2000) end))
electricalPowerUpProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEF","PERFORM",FlowItem.actorCPT))

-- =====================================================================================================================

-- ================= ENGINE START CHECK ===================
-- ELECTRICAL POWER UP......................COMPLETE  (F/O)
-- ELECTRIC HYDRAULIC PUMP........................ON  (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED  (F/O)
-- PARKING BRAKE.................................SET  (F/O)
-- ATIS......................................BRIEFED  (CPT)
-- CLEARANCE.................................BRIEFED  (CPT)
-- FLIGHT DIRECTOR...............................SET  (F/O)
-- FMS...........................PROGRAMMED/VERIFIED  (CPT)
-- FUEL PUMPS.................................ALL ON  (F/O)
-- ALTIMETERS (3)............................SET QNH (BOTH)
-- APU.........................................START  (F/O)
-- APU RUNNING.................................CHECK  (F/O)
-- APU BUS........................................ON  (F/O)
-- APU BLEED......................................ON  (F/O)
-- ENGINE BLEED SWITCHES..........................ON  (F/O)
-- EXTERNAL POWER.........................DISCONNECT  (F/O)
-- MCP....................................INITIALIZE  (F/O)
-- ========================================================

local beforeStart = Procedure:new("ENGINE START CHECK","","")
beforeStart:setFlightPhase(4)
beforeStart:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuRunningAnc:getStatus() == 1 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
beforeStart:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))	
beforeStart:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () kc_macro_lights_before_start() end))
beforeStart:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStart:addItem(HoldProcedureItem:new("ATIS","BRIEFED",FlowItem.actorCPT))
beforeStart:addItem(HoldProcedureItem:new("CLEARANCE","BRIEFED",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("FLIGHT DIRECTOR","SET",FlowItem.actorFO,0,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end,
	function () sysMCP.fdirPilotSwitch:actuate(1) end))
beforeStart:addItem(HoldProcedureItem:new("FMS","PROGRAMMED/VERIFIED",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("FUEL PUMPS","ALL ON",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() > 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("APU","START",FlowItem.actorFO,35,
	function () return sysElectric.apuStartSwitch:getStatus() > 0 end,
	function () sysElectric.apuStartSwitch:setValue(2) end))
beforeStart:addItem(IndirectProcedureItem:new("APU RUNNING","CHECK",FlowItem.actorFO,0,"apu_prestart_run",
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,nil))
beforeStart:addItem(ProcedureItem:new("APU BUS","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusGroup:getStatus() == 1 end,
	function () sysElectric.apuGenBusGroup:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("APU BLEED","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("ENGINE BLEED SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("EXT PWR","OFF",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuConnect:getStatus() == 0 and 
		sysElectric.gpuGenBusGroup:getStatus() == 0
	end,
	function () 
		sysElectric.gpuGenBusGroup:actuate(0)
		sysElectric.gpuConnect:actuate(0)
	end))
beforeStart:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () 
		sysMCP.fdirGroup:actuate(1)
		sysMCP.athrSwitch:actuate(0)
		sysMCP.crs1Selector:actuate(activeBriefings:get("departure:nav1Course"))
		sysMCP.crs2Selector:actuate(activeBriefings:get("departure:nav2Course"))
		sysMCP.iasSelector:actuate(activeBriefings:get("takeoff:v2"))
		sysMCP.hdgSelector:actuate(activeBriefings:get("departure:initHeading"))
		sysMCP.altSelector:actuate(activeBriefings:get("departure:initAlt"))
		sysMCP.vspSelector:actuate(0)
		sysMCP.discAPSwitch:actuate(0)
	end))	

-- =====================================================================================================================

-- ============== PRE PUSH & ENGINE START ================
-- DOORS.....................................CLOSED  (F/O)
-- PARKING BRAKE................................SET  (CPT)
-- FLAP LEVER....................................UP  (F/O)
-- BEACON........................................ON  (F/O)
-- APU BLEED AIR.................................ON  (F/O)
-- SEAT BELT LTS........................PASS SAFETY  (F/O)
-- TRANSPONDER..............................STANDBY  (F/O)
-- PACK SWITCHES................................OFF  (F/O)		
-- L & R ENG BLD AIR..........................HP/LP  (F/O)	
-- HYDRAULIC A PRESSURE.............CHECK >2000 PSI  (F/O)
-- POWER LEVERS.............................CUT OFF  (F/O)		
-- IGNITION SWITCHES.........................NORMAL  (F/O)
-- EXT PWR...........................OFF/DISCONNECT  (F/O)
-- AUX PUMP A...................................OFF  (F/O)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- =======================================================

local prePushStartProc = Procedure:new("PRE PUSH & ENGINE START","","ready to start engines")
prePushStartProc:setFlightPhase(4)

prePushStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.doorsAnc:getStatus() == 0 end,
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
prePushStartProc:addItem(ProcedureItem:new("BEACON","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () kc_macro_lights_before_start() end))
prePushStartProc:addItem(ProcedureItem:new("APU BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () sysAir.apuBleedSwitch:actuate(1) end))
prePushStartProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 1 end,
	function () sysGeneral.seatBeltSwitch:actuate(1) end))
prePushStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end))
prePushStartProc:addItem(ProcedureItem:new("PACK SWITCHES","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() == 0
	end,
	function () 
		kc_macro_packs_off()
	end))
prePushStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
	
prePushStartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE IF NEEDED",FlowItem.actorCPT))
prePushStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
	function () return sysElectric.gpuConnect:getStatus() == 0 end,
	function () 
		sysElectric.gpuGenBusGroup:actuate(0)
		sysElectric.gpuConnect:actuate(0)
	end))	
prePushStartProc:addItem(HoldProcedureItem:new("COMMUNICATION WITH GROUND CREW","ESTABLISH",FlowItem.actorCPT))
prePushStartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
prePushStartProc:addItem(HoldProcedureItem:new("START CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT))

-- =====================================================================================================================

-- ==================== ENGINE START =====================
--   Wait for start clearance from ground crew
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
-- PACK SWITCHES..................................ON (F/O)
-- FGC/YAW DAMPER.................................ON (F/O)
-- =======================================================

local engStartProc = Procedure:new("ENGINE START","")
engStartProc:setFlightPhase(-4)
engStartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
engStartProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:actuate(0) end))
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
engStartProc:addItem(IndirectProcedureItem:new("HYDRAULIC PRESSURE","CHECKED",FlowItem.actorCPT,0,"hydchecked",
	function () return 
		sysHydraulic.hydPressure1:getStatus() > 2000 and 
		sysHydraulic.hydPressure2:getStatus() > 2000
	end))
engStartProc:addItem(ProcedureItem:new("PACK SWITCHES","ON",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() > 0
	end,
	function () 
		kc_macro_packs_on()
	end))
engStartProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorCPT,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))

-- =====================================================================================================================

-- ================= AFTER START CHECK ===================
-- PARKING BRAKE................................SET  (F/O)
-- GENERATORS....................................ON  (F/O)			
-- PACKS.........................................ON  (F/O)
-- APU GEN......................................OFF  (F/O)
-- APU BLEED AIR................................OFF  (F/O)
-- APU..........................................OFF  (F/O)
-- PRESSURIZATION SOURCES..................ALL NORM  (F/O)
-- SPEED BRAKES & GROUND SPOILERS..............DOWN  (F/O)
-- EICAS.....................CHECK WARNING / ERRORS  (CPT)
-- PITOT STATIC..................................ON  (F/O)
-- ENGINE ANTI-ICE......................AS REQUIRED  (F/O)
-- STABILIZER ANTI-ICE..................AS REQUIRED  (F/O)
-- FUEL QTY BALANCE...........................CHECK  (F/O)
-- HYD PUMP A & B..............................NORM  (F/O)
-- THRUST REVERSERS.........................CHECKED   (PF)
-- V SPEEDS.........................SET AND CHECKED   (PF)
-- TAKEOFF BRIEFING.......................COMPLETED   (PF)
-- FLIGHT CONTROLS............................CHECK (BOTH)
-- =======================================================

local afterStartProc = Procedure:new("AFTER START CHECK","","")
afterStartProc:setFlightPhase(5)
afterStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))
afterStartProc:addItem(ProcedureItem:new("GENERATORS","ON",FlowItem.actorFO,0,
	function () 
		return sysElectric.genSwitchGroup:getStatus() > 0
	end,
	function ()
		sysElectric.genSwitchGroup:actuate(1)
	end))
afterStartProc:addItem(ProcedureItem:new("PACKS","ON",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() > 0
	end,
	function () 
		kc_macro_packs_on()
	end))	
afterStartProc:addItem(ProcedureItem:new("APU GENERATOR","OFF",FlowItem.actorFO,0,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () sysElectric.apuStartSwitch:actuate(0) end))
afterStartProc:addItem(ProcedureItem:new("APU BLEED AIR","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(0)
	end))
afterStartProc:addItem(ProcedureItem:new("APU","OFF",FlowItem.actorFO,3,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () sysElectric.apuStartSwitch:setValue(0) end))
afterStartProc:addItem(ProcedureItem:new("SPEED BRAKES & GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == 0 end,
	function () sysControls.Speedbrake:setValue(0) end))
afterStartProc:addItem(ProcedureItem:new("ISOLATION VALVES","ON/AUTO",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function () sysAir.isoValveSwitch:actuate(1) end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() > 0 end,
	function () 
		sysHydraulic.engHydPumpGroup:actuate(1)
		kc_macro_lights_before_taxi()
	end)) 
afterStartProc:addItem(HoldProcedureItem:new("V SPEEDS","SET AND CHECKED",FlowItem.actorCPT,true))
afterStartProc:addItem(HoldProcedureItem:new("TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 14.9 end))
afterStartProc:addItem(IndirectProcedureItem:new("TIME","NOTED",FlowItem.actorFO,0,"pb_parkbrk_release",true,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:gateStand") == 2 end))
afterStartProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))

-- =====================================================================================================================

-- ================= PRE-TAXI CHECKLIST ==================
-- FLAPS............................SET AS REQUIRED  (PF)
-- TRANSPONDER..........................AS REQUIRED  (F/O)
-- STABILIZER TRIM........................SET GREEN  (CPT)
-- INTERNAL LIGHTS..............................SET  (F/O)
-- TAXI LIGHT....................................ON  (CPT)	
-- PARKING BRAKE...........................RELEASED  (CPT)
-- =======================================================

local preTaxiProc = Checklist:new("PRE-TAXI CHECKLIST","","")
preTaxiProc:setFlightPhase(6)
preTaxiProc:addItem(ChecklistItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPF,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
preTaxiProc:addItem(ChecklistItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 3 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",3)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end,
	function () return activePrefSet:get("general:xpdrusa") == false end))
preTaxiProc:addItem(ChecklistItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
preTaxiProc:addItem(IndirectChecklistItem:new("INTERNAL & EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,"pretaxiintlight",
	function () return true end,
	function () kc_macro_lights_before_taxi() end))
preTaxiProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASE",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
preTaxiProc:addItem(IndirectProcedureItem:new("BRAKE CHECK","PERFORMED",FlowItem.actorCPT,0,"brakecheck",
	function () return get("sim/cockpit2/controls/left_brake_ratio") > 0.1 and
					   get("sim/cockpit2/controls/right_brake_ratio") > 0.1
	end)) 

-- =====================================================================================================================

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

local beforeTakeoffProc = Procedure:new("CLEARED FOR TAKEOFF","","")
beforeTakeoffProc:setFlightPhase(7)
beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
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

-- =====================================================================================================================

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
runwayEntryProc:addItem(ProcedureItem:new("WEATHER RADAR","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/EFIS/EFIS_weather_on") > 0 end,
	function () 
		if get("sim/cockpit2/EFIS/EFIS_weather_on") == 0 then
			command_once("sim/instruments/EFIS_wxr")
		end
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
	end))

-- =====================================================================================================================

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- == TAKEOFF
-- TAKEOFF................................ANNOUNCE   (PF)
-- THRUST SETTING..........................TAKEOFF   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PM)

-- == GEAR UP
-- COMMAND GEAR.................................UP   (PM)

-- == RETRACT FLAPS
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)   (PF)
-- FLAPS 5..........................SET (OPTIONAL)   (PF)
-- FLAPS 5 SPEED...........................REACHED   (PF)
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
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND AT >200 KTS",FlowItem.actorPF,nil,
	function () return activeBriefings:get("takeoff:flaps") < 3 end))
flapsUpProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPM,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) kc_speakNoText(0,"speed check flaps 5") end,
	function () return activeBriefings:get("takeoff:flaps") < 3 end))
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
	
-- =====================================================================================================================

-- ================= DESCENT CHECK ======================
-- KPCREW APPROACH BRIEFING................PERFORM   (PF)
-- VREF...............................CHECK IN FMC   (PF)
-- LANDING DATA...............VREF __, MINIMUMS __   (PF)
-- PRESSURIZATION...............SET LAND ALT __ FT   (PM)
-- ENGINE ANTI-ICE.....................AS REQUIRED   (PM)
-- STABILIZER ANTI-ICE.................AS REQUIRED   (PM)
-- CTR WING XFER LH & RH..................BOTH OFF   (PM)
-- LH & RH WNDSHLD ANTI-ICE................BOTH ON   (PM)
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

-- =====================================================================================================================

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
	
-- =====================================================================================================================

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

local flaps1Proc = Procedure:new("FLAPS 1","","")
flaps1Proc:setFlightPhase(-13)
flaps1Proc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[2] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) end))

-- =====================================================================================================================

local flaps2Proc = Procedure:new("FLAPS 2","","")
flaps2Proc:setFlightPhase(-13)
flaps2Proc:addItem(ProcedureItem:new("FLAPS 2","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[4] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[4]) end))

-- =====================================================================================================================
	
local gearDownProc = Procedure:new("GEAR DOWN","","")
gearDownProc:setFlightPhase(-13)
gearDownProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
gearDownProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorPM,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))

-- =====================================================================================================================

local flaps3Proc = Procedure:new("FLAPS 3","","")
flaps3Proc:setFlightPhase(-13)
flaps3Proc:addItem(ProcedureItem:new("FLAPS 3","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[6] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[6]) end))

-- =====================================================================================================================

local flapsFullProc = Procedure:new("FLAPS Full","","")
flapsFullProc:setFlightPhase(-13)
flapsFullProc:addItem(ProcedureItem:new("FLAPS FULL","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[8] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[8]) end))
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

-- =====================================================================================================================

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
	function () return sysElectric.apuStartSwitch:getStatus() == 1 end,
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
	
-- =====================================================================================================================

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

shutdownProc:addItem(ProcedureItem:new("  #spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function ()  end))
shutdownProc:addItem(IndirectProcedureItem:new("  #spell|APU#","RUNNING",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function ()  end))
shutdownProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(1)
	end))
shutdownProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuConnect:getStatus() == 1 end,
	function () sysElectric.gpuConnect:actuate(1) end,
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
shutdownProc:addItem(ProcedureItem:new("PITOT/STATIC","BOTH OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("HYD PUMPS","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end)) 
shutdownProc:addItem(ProcedureItem:new("ELECTRIC HYD PUMPS","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("DOOR","OPEN",FlowItem.actorFO,0,
	function () return sysGeneral.doorGroup:getStatus() > 0 end,
	function () sysGeneral.doorL1:actuate(1) end))	
	
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
		getActiveSOP():setActiveFlowIndex(2)
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
-- activeSOP:addProcedure(preflightChkl)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(beforeStart)
-- activeSOP:addProcedure(pushProc)
activeSOP:addProcedure(prePushStartProc)
activeSOP:addProcedure(engStartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(preTaxiProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffClimbProc)
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

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
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
	end))

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_DFLT
