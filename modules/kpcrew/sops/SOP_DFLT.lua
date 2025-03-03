-- Base SOP for Default Aircraft

-- @classmod SOP_DFLT
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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
	
-- ========= SAFETY & POWER ON:SAFETY & POWER ON =========
-- PARKING BRAKE..................................ON (F/O)
-- LANDING GEAR HANDLE..........................DOWN (F/O)
-- SPEED BRAKES / GROUND SPOILERS...............DOWN (F/O)
-- FLAP LEVER.....................................UP (F/O)
-- WINDSHIELD WIPER SELECTORS...............PARK/OFF (F/O)
-- BATTERY SWITCHES...............................ON (F/O)	

-- if GPU power up selected	
-- EXT PWR........................................ON (F/O)

-- if APU power up selected (runs in background)
-- APU START.................................PERFORM (F/O)

-- GREEN LANDING GEAR LIGHT........CHECK ILLUMINATED (F/O)
-- LIGHTS................................AS REQUIRED (F/O)
-- POWER LEVERS.................................IDLE (F/O)
-- ELECTRIC HYDRAULIC PUMPS.......................ON (F/O)
-- ENGINE HYDRAULIC PUMPS........................OFF (F/O)
-- AVIONICS SWITCH................................ON (F/O)		
-- AILERON & RUDDER TRIM.......................RESET (F/O)
-- FUEL TRANSFER SELECTOR........................OFF (F/O)
-- AIR CONDITIONING PACK SWITCHES...............AUTO (F/O)
-- NAV LIGHTS.................................... ON (F/O)		
-- ENGINE GENERATOR..............................OFF (F/O)
-- DC & ESSENTIAL BUS......................AUTOMATIC (F/O)
-- TRANSPONDER CODE.........................SET 2000 (F/O)
-- TRANSPONDER MODE.............................STBY (F/O)
-- ADIRS/IRS...................................ALIGN (F/O)
-- KPCREW DEPARTURE BRIEF....................PERFORM (F/O)
-- =======================================================

local electricalPowerUpProc = Procedure:new("SAFETY & POWER ON","","")
electricalPowerUpProc:setFlightPhase(1)

electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if kc_has_ground_obj == true then
			kc_macro_set_groundobjects(1)
		end
		sysGeneral.parkBrakeSwitch:actuate(1) 
		kc_macro_doors_preflight()
	end))
if kc_has_retractgear == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
		function () return sysGeneral.GearSwitch:getStatus() == 1 end,
		function () sysGeneral.GearSwitch:actuate(1) end))
end
if kc_has_speedbrake == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("SPEED BRAKES / GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
end
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))	
if kc_has_wipers == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
		function () return sysGeneral.wiperGroup:getStatus() == 0 end,
		function () sysGeneral.wiperGroup:actuate(0) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() > 0 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		if kc_get_nr_batteries() > 1 then
			sysElectric.battery2Switch:actuate(1) 
		end
		if kc_get_nr_batteries() > 2 then
			sysElectric.battery3Switch:actuate(1) 
		end
	end))
	
-- GPU if AVAILABLE
if kc_has_gpu == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","CONNECT",FlowItem.actorFO,1,
		function () return 
			sysElectric.gpuConnect:getStatus() > 0
		end,
		function () 
			sysElectric.gpuConnect:actuate(1)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") == 1 end))	
	electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
		function () return 
			sysElectric.gpuOnBus:getStatus() > 0
		end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(1)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") == 1 end))
end

-- if APU available
if kc_has_apu == true then
	electricalPowerUpProc:addItem(IndirectProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,20,"initapustart",
		function () return sysElectric.apuStartSwitch:getStatus() > 0 end,
		function () 
			kc_procvar_set("apustart",true)
			kc_procvar_set("apuonline",true)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") == 2 end))
end

if kc_has_retractgear == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
		function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() > 0 end,
	function () kc_macro_lights_preflight() end))
electricalPowerUpProc:addItem(ProcedureItem:new("POWER LEVERS","IDLE",FlowItem.actorFO,0,
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () sysEngines.throttlePos:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("HYDRAULIC PUMPS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () kc_macro_hydraulic_initial() end))	
if kc_has_avionics_sw == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("AVIONICS SWITCH","ON",FlowItem.actorFO,0,
		function () return sysElectric.avionicsSwitchGroup:getStatus() > 0 end,
		function () sysElectric.avionicsSwitchGroup:actuate(1) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		sysControls.aileronTrimSwitch:getStatus() == 0 and
		sysControls.rudderTrimSwitch:getStatus() == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL TRANSFER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function ()  sysFuel.crossFeed:actuate(0) end))
if kc_has_press_cab == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorPM,0,
		function () return sysAir.packSwitchGroup:getStatus() >= 1 end,
		function () sysAir.packSwitchGroup:actuate(1) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("NAV/POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(1) end))
if kc_is_airbus == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE GENERATORS","AUTO",FlowItem.actorFO,0,
		function () return sysElectric.genSwitchGroup:getStatus() >= 1 end,
		function () sysElectric.genSwitchGroup:actuate(1) end))
else
	electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE GENERATORS","OFF",FlowItem.actorFO,0,
		function () return sysElectric.genSwitchGroup:getStatus() == 0 end,
		function () sysElectric.genSwitchGroup:actuate(0) end))
end
if kc_has_inv_ess_bus == true then
	if kc_is_airbus == true then
		electricalPowerUpProc:addItem(ProcedureItem:new("ESSENTIAL BUS","OFF",FlowItem.actorFO,0,
			function () return 
				sysElectric.inverterSwitchGroup:getStatus() == 0 
			end,
			function () 
				sysElectric.inverterSwitchGroup:actuate(0)
			end))
	else
		electricalPowerUpProc:addItem(ProcedureItem:new("INVERTER/ESSENTIAL BUS","ON/AUTO",FlowItem.actorFO,0,
			function () return 
				sysElectric.inverterSwitchGroup:getStatus() > 0 
			end,
			function () 
				sysElectric.inverterSwitchGroup:actuate(1)
			end))
	end
end
if kc_has_bus_ties == true then
	electricalPowerUpProc:addItem(ProcedureItem:new("DC & AC BUS TIES","ON/AUTO",FlowItem.actorFO,0,
		function () return 
			sysElectric.dcBusTie:getStatus() == 1
		end,
		function () 
			sysElectric.dcBusTie:actuate(1)
		end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("ALTIMETERS","ALL SET QNH",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_set_local_baro() end))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER CODE","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () kc_macro_set_xpdrcode(2000) end))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER MODE","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
	function () kc_macro_set_xpdrmode(sysRadios.stby) end))
if kc_has_irs then
	electricalPowerUpProc:addItem(ProcedureItem:new("ADIRU/IRS","ALIGN/NAV",FlowItem.actorFO,0,
		function () return sysGeneral.irsUnitGroup:getStatus() > 1 end,
		function () 
			if kc_is_airbus == true then 
				kc_macro_set_irs(1)
			else
				kc_macro_set_irs(2)
			end
		end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () sysGeneral.seatBeltSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("NO SMOKING LIGHTS","ARM",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:actuate(1) end))

-- =====================================================================================================================

-- ================= ENGINE START CHECKS ==================
-- ELECTRICAL POWER UP......................COMPLETE  (F/O)
-- ELECTRIC HYDRAULIC PUMPS.......................ON  (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED  (F/O)
-- PARKING BRAKE.................................SET  (F/O)
-- ATIS......................................BRIEFED  (CPT)
-- CLEARANCE.................................BRIEFED  (CPT)
-- FLIGHT DIRECTOR...............................SET  (F/O)
-- FMS...........................PROGRAMMED/VERIFIED  (CPT)
-- FUEL PUMPS.................................ALL ON  (F/O)
-- APU Start (runs in background)
-- APU START.................................PERFORM  (F/O)
-- ENGINE BLEED SWITCHES..........................ON  (F/O)
-- EXTERNAL POWER.........................DISCONNECT  (F/O)
-- ========================================================

local beforeStart = Procedure:new("ENGINE START CHECKS","","")
beforeStart:setFlightPhase(4)

beforeStart:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuRunningAnc:getStatus() == 1 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
if kc_has_hyd_elec_pmps == true then
	beforeStart:addItem(IndirectProcedureItem:new("ELECTRIC HYDRAULIC PUMPS","ON",FlowItem.actorFO,0,"elechydstart",
		function () return sysHydraulic.elecHydPumpGroup:getStatus() > 0 end,
		function () 
			sysHydraulic.elecHydPumpGroup:actuate(1) 
			sysHydraulic.engHydPumpGroup:actuate(1)
		end))	
end
beforeStart:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.doorsAnc:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
beforeStart:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () 
		kc_macro_lights_before_start() 
	end))
beforeStart:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("FLIGHT DIRECTOR","SET",FlowItem.actorFO,0,
	function () return sysMCP.fdirAnc:getStatus() > 0 end,
	function () 
		if sysMCP.fdirAnc:getStatus() == 0 then
			sysMCP.fdirGroup:actuate(1) 
		end
	end))
beforeStart:addItem(ProcedureItem:new("FUEL PUMPS","ALL ON",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() > 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(1) end))
if kc_has_apu == true then
	beforeStart:addItem(ProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,35,
			function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
			function () 
				kc_procvar_set("apustart",true)
				kc_procvar_set("apuonline",true)
			end,
			function () return sysElectric.apuRunningAnc:getStatus() > 0 end))
end
beforeStart:addItem(ProcedureItem:new("ENGINE BLEED SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
	
if kc_has_gpu == true and kc_has_apu == true then
	beforeStart:addItem(ProcedureItem:new("EXTERNAL POWER","OFF",FlowItem.actorFO,2,
		function () return 
			sysElectric.gpuOnBus:getStatus() == 0
		end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(0)
		end))
end
if kc_has_gpu == true and kc_has_apu == true then
	beforeStart:addItem(ProcedureItem:new("EXTERNAL POWER","DISCONNECT",FlowItem.actorFO,0,
		function () return 
			sysElectric.gpuConnect:getStatus() == 0 
		end,
		function () 
			sysElectric.gpuConnect:actuate(0)
		end))
end

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
		if kc_has_ground_obj == true then
			kc_macro_set_groundobjects(0)
		end
		sysGeneral.parkBrakeSwitch:actuate(1) 
		sysLights.domeLightSwitch:actuate(0)
		kc_macro_lights_before_start()
	end))
prePushStartProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
if kc_has_beacon == true then
	prePushStartProc:addItem(ProcedureItem:new("BEACON","ON",FlowItem.actorFO,0,
		function () return sysLights.beaconSwitch:getStatus() > 0 end,
		function () end))
end
if kc_has_apu == true then
	prePushStartProc:addItem(ProcedureItem:new("APU BLEED AIR","ON",FlowItem.actorFO,0,
		function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
		function () sysAir.apuBleedSwitch:actuate(1) end))
end
prePushStartProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () sysGeneral.seatBeltSwitch:setValue(1) end))
prePushStartProc:addItem(ProcedureItem:new("NO SMOKING LIGHTS","ARM",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:setValue(1) end))
prePushStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
	function () 
		 kc_macro_set_xpdrmode(sysRadios.stby)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		sysRadios.xpdrCode:setValue(xpdrcode)
	end))
if kc_has_press_cab == true then
	prePushStartProc:addItem(ProcedureItem:new("PACK SWITCHES","OFF",FlowItem.actorFO,0,
		function () 
			return sysAir.packSwitchGroup:getStatus() == 0
		end,
		function () 
			kc_macro_packs_off()
		end))
end
prePushStartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE IF NEEDED",FlowItem.actorCPT))
if kc_has_gpu == true then
	prePushStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
		function () return sysElectric.gpuConnect:getStatus() == 0 end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(0)
			sysElectric.gpuConnect:actuate(0)
		end))	
end
prePushStartProc:addItem(HoldProcedureItem:new("COMMUNICATION WITH GROUND CREW","ESTABLISH",FlowItem.actorCPT))
prePushStartProc:addItem(HoldProcedureItem:new("START CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT))
prePushStartProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:pushDirection") == 1 end))
prePushStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
	
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
if kc_has_press_cab == true then
	engStartProc:addItem(IndirectProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorFO,0,"engstartpackoff",
		function () return sysAir.packSwitchGroup:getStatus() == 0 end,
		function () sysAir.packSwitchGroup:actuate(0) end))
end
if kc_is_airbus == false then
	engStartProc:addItem(IndirectProcedureItem:new("IGNITION","BOTH AUTO",FlowItem.actorFO,0,"ignitionstart",
		function () return sysEngines.engIgnitionGroup:getStatus() > 0 end,
		function () sysEngines.engIgnitionGroup:actuate(1) end))
end
engStartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
	function () return sysGeneral.chrono:getStatus() > 0 end,
	function () 
		if sysGeneral.chrono:getStatus() == 0 then 
			sysGeneral.chrono:actuate(1)
		end
	end))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () return sysEngines.throttlePos:getStatus() == 0	end,
	function () 
		command_once("sim/engines/throttle_idle")
	end))
engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,20,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() > 0
		else 
			return sysEngines.engStart1Switch:getStatus() > 0
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_procvar_set("engstart2",true)
			kc_speakNoText(0,"starting right hand engine")
		else 
			kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting left hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end 
	end,
	function () 
	end))

engStartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT))
engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
	function () return sysGeneral.chrono:getStatus() > 0 end,
	function () 
		if sysGeneral.chrono:getStatus() == 0 then 
			sysGeneral.chrono:actuate(1)
		end
	end))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_2_lever",
	function () return sysEngines.throttlePos:getStatus() == 0	end,
	function () 
		command_once("sim/engines/throttle_idle")
	end))
engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS  %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT,20,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 1
		else 
			return sysEngines.engStart2Switch:getStatus() == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting left hand engine")
		else 
			kc_procvar_set("engstart2",true)
			kc_speakNoText(0,"starting right hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 end 
	end,
	function () 
	end))

engStartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))
if kc_has_press_cab == true then
	engStartProc:addItem(ProcedureItem:new("PACK SWITCHES","ON",FlowItem.actorFO,0,
		function () 
			return sysAir.packSwitchGroup:getStatus() > 0
		end,
		function () 
			kc_macro_packs_on()
		end))
end
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
		set("sim/private/controls/shadow/cockpit_near_adjust",1)
	end))
afterStartProc:addItem(ProcedureItem:new("PACKS","ON",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() > 0
	end,
	function () 
		kc_macro_packs_on()
	end))	
if kc_has_apu == true then
	afterStartProc:addItem(ProcedureItem:new("APU GENERATOR","OFF",FlowItem.actorFO,0,
		function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
		function () sysElectric.apuStartSwitch:actuate(0) end))
	afterStartProc:addItem(ProcedureItem:new("APU BLEED AIR","OFF",FlowItem.actorFO,0,
		function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
		function () 
			sysAir.apuBleedSwitch:actuate(0)
		end))
	if kc_is_airbus == true then
		afterStartProc:addItem(ProcedureItem:new("APU MASTER","OFF",FlowItem.actorFO,3,
			function () return sysElectric.apuMaster:getStatus() == 0 end,
			function () sysElectric.apuMaster:setValue(0) end))
	else
		afterStartProc:addItem(ProcedureItem:new("APU","OFF",FlowItem.actorFO,3,
			function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
			function () sysElectric.apuStartSwitch:setValue(0) end))
	end
end
afterStartProc:addItem(ProcedureItem:new("SPEED BRAKES & GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == 0 end,
	function () sysControls.Speedbrake:setValue(0) end))
if kc_is_airbus == false then	
	afterStartProc:addItem(ProcedureItem:new("ISOLATION VALVES","ON/AUTO",FlowItem.actorFO,0,
		function () return sysAir.isoValveSwitch:getStatus() == 1 end,
		function () sysAir.isoValveSwitch:actuate(1) end))
end
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() > 0 end,
	function () 
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(0)
	end)) 
if kc_is_airbus == true then	
	afterStartProc:addItem(ProcedureItem:new("PITOT/STATIC","AUTO",FlowItem.actorFO,0,
		function () return sysAice.probeHeatGroup:getStatus() == 0 end,
		function () sysAice.probeHeatGroup:actuate(0) end))
else	
	afterStartProc:addItem(ProcedureItem:new("PITOT/STATIC","ON",FlowItem.actorFO,0,
		function () return sysAice.probeHeatGroup:getStatus() > 0 end,
		function () sysAice.probeHeatGroup:actuate(1) end))
end 
afterStartProc:addItem(IndirectProcedureItem:new("HYDRAULIC PRESSURE","CHECKED",FlowItem.actorCPT,0,"hydchecked",
	function () return 
		sysHydraulic.hydPressureLow:getStatus() == 0
	end))
afterStartProc:addItem(HoldProcedureItem:new("V SPEEDS","SET AND CHECKED",FlowItem.actorCPT))
afterStartProc:addItem(HoldProcedureItem:new("TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () return sysControls.rudderDeflection:getStatus() > 14.9 end))
	
afterStartProc:addItem(IndirectProcedureItem:new("TIME","NOTED",FlowItem.actorFO,0,"pb_parkbrk_release",true,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:gateStand") < 3 end))
	
afterStartProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPF,0,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end))
if kc_has_window_heat == true then 
	if kc_is_airbus == true then	
		afterStartProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","AUTO",FlowItem.actorFO,0,
			function () return sysAice.probeHeatGroup:getStatus() == 0 end,
			function () sysAice.probeHeatGroup:actuate(0) end))
	else	
		afterStartProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
			function () return sysAice.probeHeatGroup:getStatus() > 0 end,
			function () sysAice.probeHeatGroup:actuate(1) end))
	end 	
end
afterStartProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () 
		kc_macro_mcp_preflight()
	end))
afterStartProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
	function () 
		kc_macro_set_xpdrmode(sysRadios.tara)
		local xpdrcode = activeBriefings:get("departure:squawk")
		sysRadios.xpdrCode:setValue(xpdrcode)
		kc_macro_lights_before_taxi()
	end))

-- afterStartProc:addItem(ProcedureItem:new("PITCH TRIM","SET %5.2f (%5.2f)|activeBriefings:get(\"takeoff:elevatorTrim\")|get(\"AirbusFBW/PitchTrimPosition\")",FlowItem.actorFO,0,
	-- function () return string.format("%5.2f",sysControls.pitchTrimSwitch:getStatus()) == string.format("%5.2f",activeBriefings:get("takeoff:elevatorTrim")) end))

	
-- =====================================================================================================================

-- =================== BEFORE TAKEOFF ====================
-- FLAPS............................CHECK T/O FLAPS  (CPT)
-- AP ALTITUDE..........................SET CHECKED  (CPT)
-- AP HEADING BUG...............................SET  (CPT)
-- ENGINE ANTI-ICE......................AS REQUIRED  (F/O)
-- WING ANTI-ICE........................AS REQUIRED  (F/O)
-- WINDSHIELD HEAT...............................ON  (F/O)
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE","","")
beforeTakeoffProc:setFlightPhase(7)

beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return true end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")-1]) end)) 
beforeTakeoffProc:addItem(ProcedureItem:new("AP ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end))
if kc_is_airbus == false then
	beforeTakeoffProc:addItem(ProcedureItem:new("AP HEADING BUG","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
		function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
		function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end))
end
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
if kc_has_window_heat == true then 
	if kc_is_airbus == true then	
		beforeTakeoffProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","AUTO",FlowItem.actorFO,0,
			function () return sysAice.probeHeatGroup:getStatus() == 0 end,
			function () sysAice.probeHeatGroup:actuate(0) end))
	else	
		beforeTakeoffProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
			function () return sysAice.probeHeatGroup:getStatus() > 0 end,
			function () sysAice.probeHeatGroup:actuate(1) end))
	end 	
end
if kc_has_autobrake == true then
	beforeTakeoffProc:addItem(ProcedureItem:new("AUTOBRAKE","R T O",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeRTO end,
		function () kc_macro_set_autobrake(kc_AutoBrakeRTO) end))
end
beforeTakeoffProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () 
		kc_macro_mcp_takeoff()
	end))
if kc_has_toc == true then
	beforeTakeoffProc:addItem(IndirectProcedureItem:new("TAKEOFF CONFIG","CHECK",FlowItem.actorFO,0,"tocheck",
	function () return sysGeneral.tocheck:getStatus() > 0 end))
end
if kc_has_speedbrake == true and kc_spdbrk_can_arm == true then
	beforeTakeoffProc:addItem(ProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == kc_spdbrk_arm_pos end,
	function () sysControls.Speedbrake:setValue(kc_spdbrk_arm_pos) end))
end 

-- =====================================================================================================================

-- =================== RUNWAY ENTRY  =====================
-- EXTERNAL LIGHTS.............................SET  (F/O)
-- TRANSPONDER............................ON/TA RA  (F/O)
-- PACS & BLEEDS.......................AS REQUIRED  (F/O)
-- WEATHER RADAR................................ON  (F/O)
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY","","")
runwayEntryProc:setFlightPhase(-7)

runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() > 0 end,
	function () kc_macro_lights_for_takeoff() end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON/TA RA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.tara)
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
	end))
if kc_has_press_cab == true then
	runwayEntryProc:addItem(ProcedureItem:new("PACKS & BLEEDS","AS REQUIRED",FlowItem.actorFO,0,true,
		function ()
			kc_macro_packs_takeoff() 
			kc_macro_bleeds_takeoff()
		end))
end
if kc_has_wx_radar == true then
	runwayEntryProc:addItem(ProcedureItem:new("WEATHER RADAR","ON",FlowItem.actorFO,0,
		function () return sysEFIS.wxrPilot:getStatus() ~= 0 end,
		function () sysEFIS.wxrPilot:actuate(1) end))
end
runwayEntryProc:addItem(ProcedureItem:new("CLOCK","START",FlowItem.actorFO,0,
	function () return sysGeneral.clock:getStatus() == -1 end,
	function () sysGeneral.clock:actuate(1) end))


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

-- =====================================================================================================================

local gearUpProc = Procedure:new("COMMAND GEAR UP","Gear up")
gearUpProc:setFlightPhase(-8)

if kc_has_retractgear == true then
gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_speakNoText(0,"gear coming up") 
	end))
end

-- =====================================================================================================================

local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(-8)

if kc_is_airbus == false then
	flapsUpProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
		function () return sysControls.yawDamper:getStatus() == 1 end,
		function () sysControls.yawDamper:actuate(1) end))
end
flapsUpProc:addItem(ProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () sysGeneral.GearSwitch:actuate(0) end))
	
for toflapidx=kc_NumFlapsTO-1, 2, -1 do
	flapsUpProc:addItem(HoldProcedureItem:new("FLAPS " .. kc_pref_split(kc_TakeoffFlaps)[toflapidx],"RETRACT AT " .. sysControls.flaps_spd[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[toflapidx])] .. " KTS",FlowItem.actorPF,nil,
		-- function () return sysControls.flapsSwitch:getStatus() < sysControls.flaps_pos[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])]-0.01 end
		function () return (toflapidx >= kc_NumFlapsTO) or (toflapidx >= tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])) end))
	
	flapsUpProc:addItem(ProcedureItem:new("FLAPS ".. kc_pref_split(kc_TakeoffFlaps)[toflapidx],"SET",FlowItem.actorPF,0,true,
		function () 
			kc_macro_set_flap(toflapidx-1) 
			kc_speakNoText(0,"speed check flaps " .. kc_pref_split(kc_TakeoffFlaps)[toflapidx]) 
		end,
		function () return (toflapidx >= kc_NumFlapsTO) or (toflapidx >= tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])) end))
end	
	
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS " .. kc_pref_split(kc_TakeoffFlaps)[1],"RETRACT AT " .. sysControls.flaps_spd[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[1])] .. " KTS",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("FLAPS ".. kc_pref_split(kc_TakeoffFlaps)[1],"SET",FlowItem.actorPF,0,true,
	function () 
		kc_macro_set_flap(0)
		kc_speakNoText(0,"speed check flaps " .. kc_pref_split(kc_TakeoffFlaps)[1]) 
	end))
flapsUpProc:addItem(HoldProcedureItem:new("A/P 1","ACTIVATE",FlowItem.actorCPT))
flapsUpProc:addItem(HoldProcedureItem:new("A/P","ON",FlowItem.actorPF,
	function () 
		sysMCP.ap1Switch:actuate(1) 
	end))
if kc_has_press_cab == true then
	flapsUpProc:addItem(ProcedureItem:new("PACKS & BLEEDS","ON",FlowItem.actorPM,0,true,
		function ()
			kc_macro_packs_on() 
			kc_macro_bleeds_on()
		end))
end

-- =====================================================================================================================

-- ================ AFTER TAKEOFF CHECK ==================
-- LANDING GEAR...........................RETRACTED   (PM)
-- FLAPS.........................................UP   (PM)
-- AUTOBRAKE....................................OFF   (PM)
-- =======================================================

local afterTakeoffCheck = Checklist:new("AFTER TAKEOFF CHECK","after takeoff check","")
afterTakeoffCheck:setFlightPhase(8)

if kc_has_retractgear == true then
	afterTakeoffCheck:addItem(ChecklistItem:new("LANDING GEAR","RETRACTED",FlowItem.actorPM,0,
		function () return sysGeneral.GearSwitch:getStatus() == 0 end,
		function () 
			sysGeneral.GearSwitch:actuate(0) 
			sysLights.taxiSwitch:actuate(0)
		end))
end
afterTakeoffCheck:addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) end))
if kc_has_autobrake == true then
	afterTakeoffCheck:addItem(ChecklistItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeOff end,
		function () kc_macro_set_autobrake(kc_AutoBrakeOff) end))
end
-- =====================================================================================================================


-- ==================== CLIMB CHECKS ======================
-- PACKS & ENGINE BLEEDS..........................ON   (PM)
-- ANTI-ICE......................................OFF   (PM)
-- =======================================================

local climbCheck = Procedure:new("CLIMB CHECKS","","")
climbCheck:setFlightPhase(9)

if kc_has_press_cab == true then
	climbCheck:addItem(ProcedureItem:new("PACKS","ON",FlowItem.actorFO,0,
		function () return sysAir.packSwitchGroup:getStatus() > 0 end,
		function () sysAir.packSwitchGroup:actuate(1) end))
climbCheck:addItem(ProcedureItem:new("BLEEDS","ON",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
end
climbCheck:addItem(HoldProcedureItem:new("ANTI-ICE","OFF",FlowItem.actorCPT))
climbCheck:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () 
		sysAice.engAntiIce1:actuate(0)
 		sysAice.engAntiIce2:actuate(0) 
	end))
climbCheck:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))

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

descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
if kc_is_airbus == false then
	descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
		function () 
			return get("sim/cockpit/misc/radio_altimeter_minimum") == activeBriefings:get("approach:decision") end,
		function ()
			sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
			kc_procvar_set("below10k",true) -- background 10.000 ft activities
			kc_procvar_set("attranslvl",true) -- background transition level activities
			kc_procvar_set("above10k",false) 
			kc_procvar_set("attransalt",false) 
		end))
end
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
if kc_has_window_heat == true then
	if kc_is_airbus == true then 
		descentProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","AUTO",FlowItem.actorPM,0,
			function () return sysAice.windowHeatGroup:getStatus() == 0 end,
			function () sysAice.windowHeatGroup:actuate(0) end))	
	else
		descentProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ALL ON",FlowItem.actorPM,0,
			function () return sysAice.windowHeatGroup:getStatus() > 0 end,
			function () sysAice.windowHeatGroup:actuate(1) end))
	end
end 
if kc_has_autobrake == true then
	descentProc:addItem(ProcedureItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")]) end,
		function () kc_macro_set_autobrake(tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])) 
		end))
end
descentProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorPM,0,
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
if kc_is_airbus == false then 
	landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorPF,0,
		function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
		function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
	landingProc:addItem(ProcedureItem:new("COURSE NAV 2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorPM,0,
		function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
		function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
end
if kc_has_press_cab == true then
	landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorPM,0,
		function () return sysAir.packSwitchGroup:getStatus() > 1 end,
		function () sysAir.packSwitchGroup:actuate(1) end,
		function () return activeBriefings:get("approach:packs") == 1 end))
	landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorPM,0,
		function () return sysAir.packSwitchGroup:getStatus() == 0 end,
		function () sysAir.packSwitchGroup:actuate(0) end,
		function () return activeBriefings:get("approach:packs") > 1 end))
end
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPF,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights_approach() end))	

-- =====================================================================================================================

local flapsProc = Procedure:new("EXTEND FLAPS","","")
flapsProc:setFlightPhase(-13)

for ldgflapidx=1,kc_Numflap_detents,1 do
	flapsProc:addItem(HoldProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"EXTEND AT " .. sysControls.flaps_spd[ldgflapidx] .. " KTS",FlowItem.actorPF,nil,
		function () return tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")]) < ldgflapidx end))
	flapsProc:addItem(ProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"SET",FlowItem.actorPNF,0,
		function () return true end,
		-- function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[ldgflapidx] end,
		function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[ldgflapidx]) end,
		function () return tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")]) < ldgflapidx end))
	if ldgflapidx == 2 then
		if kc_has_retractgear == true then
			flapsProc:addItem(HoldProcedureItem:new("LANDING GEAR DOWN","COMMAND",FlowItem.actorPF))
			flapsProc:addItem(ProcedureItem:new("GEAR ","DOWN",FlowItem.actorPNF,0,true,
				function () sysGeneral.GearSwitch:actuate(1) end))
			flapsProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorPM,0,
			function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
		end
	end
end
flapsProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
flapsProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))	
if kc_has_speedbrake == true and kc_spdbrk_can_arm == true then
	flapsProc:addItem(IndirectProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,"armspdbrk",
	function () return sysControls.Speedbrake:getStatus() == kc_spdbrk_arm_pos end))
end 
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

afterLandingProc:addItem(ProcedureItem:new("CLOCK","STOP",FlowItem.actorFO,0,
	function () return sysGeneral.clock:getStatus() == 0 end,
	function () sysGeneral.clock:actuate(0) end))
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
			return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara 
		else
			return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby 
		end
	end,
	function () 
		if activePrefSet:get("general:xpdrusa") == true then
			kc_macro_set_xpdrmode(sysRadios.tara)
		else
			kc_macro_set_xpdrmode(sysRadios.stby)	
		end
	end))
if kc_has_wx_radar == true then
	afterLandingProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,0,
		function () return sysEFIS.wxrPilot:getStatus() == 0 end,
		function () sysEFIS.wxrPilot:actuate(0) end))
end
if kc_has_speedbrake == true then
	afterLandingProc:addItem(ProcedureItem:new("GROUND SPOILERS","RETRACT",FlowItem.actorFO,0,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
end
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
afterLandingProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end))
if kc_has_apu == true then
	afterLandingProc:addItem(ProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,0,
		function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
		function () 
			kc_procvar_set("apustart",true)
			kc_procvar_set("apuonline",true)
		end,
		function () return activeBriefings:get("approach:activateAPUafterLand") == 2 end))
end
afterLandingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
if kc_has_autobrake == true then
	afterLandingProc:addItem(ProcedureItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeOff end,
		function () kc_macro_set_autobrake(kc_AutoBrakeOff) end))
end
	
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
if kc_has_gpu == true then
	shutdownProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
		function () return sysElectric.gpuOnBus:getStatus() == 1 end,
		function () 
			sysElectric.gpuConnect:actuate(1)
			sysElectric.gpuGenBusGroup:actuate(1)
		end,
		function () return activeBriefings:get("approach:powerAtGate") > 1 end))
end
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
	function () 
		kc_macro_set_xpdrmode(sysRadios.stby) 
		kc_macro_lights_after_shutdown() 
		activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
shutdownProc:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () kc_macro_lights_after_shutdown() end))
shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
if kc_is_airbus == true then
	shutdownProc:addItem(IndirectProcedureItem:new("ENGINE MASTERS","OFF",FlowItem.actorCAPT,10,"throttlescutland",
		function () return sysEngines.engStarterGroup:getStatus() == 0 end,
		function () sysEngines.engStarterGroup:actuate(0) end))
else
	shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","CUT",FlowItem.actorCAPT,0,"throttlescutland",
		function () return get("sim/cockpit2/engine/actuators/mixture_ratio_all") <= 0 end,
		function () set("sim/cockpit2/engine/actuators/mixture_ratio_all",0) end))
end
shutdownProc:addItem(ProcedureItem:new("CHRONO","STOP",FlowItem.actorCPT,0,
	function () return sysGeneral.chrono:getStatus() > 0 end,
	function () 
		if sysGeneral.chrono:getStatus() > 0 then 
			sysGeneral.chrono:actuate(1)
		end
	end))

shutdownProc:addItem(ProcedureItem:new("SEAT BELT SIGNS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:actuate(0) end))
if kc_is_airbus == false then
	shutdownProc:addItem(ProcedureItem:new("GENERATORS","OFF",FlowItem.actorFO,0,
		function () 
			return sysElectric.gen1Switch:getStatus() == 0 and 
				sysElectric.gen2Switch:getStatus() == 0
		end,
		function ()
			sysElectric.gen1Switch:actuate(0)
			sysElectric.gen2Switch:actuate(0)
		end))
end
if kc_has_window_heat == true and kc_is_airbus == false then
	shutdownProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","OFF",FlowItem.actorFO,0,
		function () return sysAice.windowHeatGroup:getStatus() == 0 end,
		function () sysAice.windowHeatGroup:actuate(0) end))
end
shutdownProc:addItem(ProcedureItem:new("L & R ENG BLD AIR","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.engBleedGroup:getStatus() == 0
	end,
	function () 
		sysAir.engBleedGroup:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("FUEL BOOST BOTH","OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(0)	end))
shutdownProc:addItem(ProcedureItem:new("PITOT/STATIC","BOTH OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end))
if kc_has_kc_has_hyd_eng_pmps == true then
	shutdownProc:addItem(ProcedureItem:new("HYD PUMPS","OFF",FlowItem.actorFO,0,
		function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
		function () sysHydraulic.engHydPumpGroup:actuate(0) end)) 
end
if kc_has_hyd_elec_pmps == true then
	shutdownProc:addItem(ProcedureItem:new("ELECTRIC HYD PUMPS","OFF",FlowItem.actorFO,0,
		function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
		function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
end
if kc_has_apu == true then
	shutdownProc:addItem(ProcedureItem:new("APU","SHUTDOWN",FlowItem.actorFO,0,
		function () return sysElectric.apuRunningAnc:getStatus() == 0 end,
		function () sysElectric.apuStartSwitch:actuate(0) end,
		function () return 
			activeBriefings:get("approach:activateAPUafterLand") == 2 or
			activeBriefings:get("approach:powerAtGate") == 2 
		end))
end
shutdownProc:addItem(ProcedureItem:new("DOOR","OPEN",FlowItem.actorFO,0,
	function () return sysGeneral.doorGroup:getStatus() > 0 end,
	function () sysGeneral.doorL1:actuate(1) end))	
	
	
-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("COLD & DARK","SET","SYS",1,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))
coldAndDarkProc:addItem(ProcedureItem:new("GPU DISCONNECT","SET","SYS",0,true,
	function ()
		if kc_has_gpu == true then
			sysElectric.gpuConnect:actuate(0)
		end
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

activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(beforeStart)
activeSOP:addProcedure(prePushStartProc)
activeSOP:addProcedure(engStartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(flapsUpProc)
activeSOP:addProcedure(afterTakeoffCheck)
activeSOP:addProcedure(climbCheck)
activeSOP:addProcedure(descentProc)
activeSOP:addProcedure(landingProc)
activeSOP:addProcedure(flapsProc)
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
kc_procvar_initialize_bool("apustart", false) -- Start apu
kc_procvar_initialize_bool("apuonline", false) -- APU Gen & Bleed online
kc_procvar_initialize_bool("engstart1", false) 
kc_procvar_initialize_bool("engstart2", false) 
kc_procvar_initialize_bool("engstart3", false) 
kc_procvar_initialize_bool("engstart4", false) 

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
		if kc_procvar_get("apustart") == true then 
			kc_bck_apustart("apustart")
		end
		if kc_procvar_get("apuonline") == true then 
			kc_bck_apuonline("apuonline")
		end
		if kc_procvar_get("engstart1") == true then 
			kc_bck_start_engine("engstart1")
		end
		if kc_procvar_get("engstart2") == true then 
			kc_bck_start_engine("engstart2")
		end
		if kc_procvar_get("engstart3") == true then 
			kc_bck_start_engine("engstart3")
		end
		if kc_procvar_get("engstart4") == true then 
			kc_bck_start_engine("engstart4")
		end
	end))

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_DFLT

-- A33L
-- beacon gets turned off befroe takeoff