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

kc_num_visible_sop_items = 12 -- number of visible flows with positive phase number

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplan", 	[20] = "Go Around", [0] = "" }
					 
kc_phase_colddark 		= 1
kc_phase_turnaround 	= 18
kc_phase_prel_preflight	= 2
kc_phase_preflight 		= 3
kc_phase_before_start 	= 4
kc_phase_after_start 	= 5
kc_phase_taxi_rwy		= 6
kc_phase_before_takeoff = 7
kc_phase_takeoff 		= 8
kc_phase_climb 			= 9
kc_phase_enroute 		= 10
kc_phase_descent 		= 11
kc_phase_arrival 		= 12
kc_phase_approach 		= 13
kc_phase_landing 		= 14
kc_phase_afterland 		= 15
kc_phase_taxi_stand 	= 16
kc_phase_shutdown 		= 17
kc_phase_flight_plan	= 19

-- Set up SOP =========================================================================

activeSOP = SOP:new("Default Aircraft SOP")

-- *optional activities if system available
-- ================== SAFETY & POWER ON ==================
-- PARKING BRAKE..................................ON (F/O)
-- *LANDING GEAR HANDLE.........................DOWN (F/O)
-- *SPEED BRAKES / GROUND SPOILERS..............DOWN (F/O)
-- FLAP LEVER.....................................UP (F/O)
-- *WINDSHIELD WIPER SELECTORS..............PARK/OFF (F/O)
-- BATTERY SWITCHES...............................ON (F/O)	

-- **If GPU available and power up with GPU selected	
-- *EXTERNAL POWER...........................CONNECT (F/O)
-- *EXTERNAL POWER................................ON (F/O)

-- ** If APU available & APU power up selected
-- *APU START................................PERFORM (F/O)

-- *GREEN LANDING GEAR LIGHT.......CHECK ILLUMINATED (F/O)
-- LIGHTS................................AS REQUIRED (F/O)
-- POWER LEVERS.................................IDLE (F/O)
-- *HYDRAULIC PUMPS.................INITIAL SETTINGS (F/O)
-- *AVIONICS SWITCH...............................ON (F/O)		
-- *AILERON & RUDDER TRIM......................RESET (F/O)
-- *FUEL TRANSFER/XFEED..........................OFF (F/O)
-- *AIR CONDITIONING PACK SWITCHES...........AUTO/ON (F/O)
-- *NAV/POSITION LIGHTS.......................... ON (F/O)
-- ** if Airbus	
-- *ENGINE GENERATORS...........................AUTO (F/O)
-- ** other aircraft
-- *ENGINE GENERATORS............................OFF (F/O)
-- ** if Airbus	
-- *ESSENTIAL BUS................................OFF (F/O)
-- ** other aircraft
-- *INVERTER/ESSENTIAL BUS...................ON/AUTO (F/O)
-- *DC & AC BUS TIES.........................ON/AUTO (F/O)
-- "ALTIMETERS...........................ALL SET QNH (BOTH)
-- *TRANSPONDER CODE........................SET 2000 (F/O)
-- *TRANSPONDER MODE............................STBY (F/O)
-- *ADIRU/IRS..............................ALIGN/NAV (F/O)
-- *SEAT BELT LIGHTS..............................ON (F/O)
-- *NO SMOKING LIGHTS............................ARM (F/O)
-- *STANDBY POWER.................................ON (F/O)
-- =======================================================

local electricalPowerUpProc = Procedure:new("SAFETY & POWER ON","","")
electricalPowerUpProc:setFlightPhase(kc_phase_preflight)

electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		kc_macro_doors_ext(kc_phase_turnaround)
		sysGeneral.parkBrakeSwitch:actuate(1) 
	end))
if kc_has_retractgear then
	electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
		function () return sysGeneral.GearSwitch:getStatus() == 1 end,
		function () sysGeneral.GearSwitch:actuate(1) end))
end
if kc_has_speedbrake then
	electricalPowerUpProc:addItem(ProcedureItem:new("SPEEDBRAKES","DOWN",FlowItem.actorFO,0,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
end
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))	
if kc_has_wipers then
	electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK/OFF",FlowItem.actorFO,0,
		function () return sysGeneral.wiperGroup:getStatus() == 0 end,
		function () sysGeneral.wiperGroup:actuate(0) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY & ELECTRIC SYSTEM","ON/SET",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() > 0 end,
	function () kc_macro_elec_system(kc_phase_turnaround) end))
	
-- If GPU available and power up with GPU selected
if kc_has_gpu then
	electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","CONNECT",FlowItem.actorFO,1,
		function () return 
			sysElectric.gpuConnect:getStatus() > 0
		end,
		function () 
			sysElectric.gpuConnect:actuate(1)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") ~= 2 end))	
	electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
		function () return 
			sysElectric.gpuOnBus:getStatus() > 0
		end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(1)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") ~= 2 end))
end

-- If APU available & APU power up selected
if kc_has_apu then
	electricalPowerUpProc:addItem(IndirectProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,20,"initapustart",
		function () return sysElectric.apuRunningAnc:getStatus() == 1 end,
		function () 
			kc_procvar_set("apustart",true)
			kc_procvar_set("apuonline",true)
		end,
		function () return activeBriefings:get("departure:activateAPUPowerUp") > 1 end))
end

if kc_has_retractgear then
	electricalPowerUpProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
		function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () kc_macro_lights(kc_phase_turnaround) end))
electricalPowerUpProc:addItem(ProcedureItem:new("POWER LEVERS","IDLE",FlowItem.actorFO,0,
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () 
		sysEngines.throttlePos:actuate(0) 
		if kc_is_turboprop or kc_is_ga then
			sysEngines.mixtureLever:actuate(kc_mixture_off)
		end
		if kc_has_proplever then
			sysEngines.propLever:setValue(kc_prop_lvr_feather)
		end	
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL SYSTEM","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_fuel(kc_phase_turnaround) end))
electricalPowerUpProc:addItem(ProcedureItem:new("HYDRAULIC PUMPS","INITIAL SETTINGS",FlowItem.actorFO,0,true,
	function () kc_macro_hyd(kc_phase_turnaround) end))
if kc_has_aileron_trim then
	electricalPowerUpProc:addItem(ProcedureItem:new("AILERON TRIM","RESET",FlowItem.actorFO,0,
		function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
		function () sysControls.aileronReset:actuate(1)	end))
end
if kc_has_rudder_trim then
	electricalPowerUpProc:addItem(ProcedureItem:new("RUDDER TRIM","RESET",FlowItem.actorFO,0,
		function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
		function () sysControls.rudderReset:actuate(1) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("AIR CONDITIONING","AS REQUIRED",FlowItem.actorPM,0,
	function () return true end,
	function () kc_macro_air(kc_phase_turnaround) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTIMETERS","ALL SET QNH",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_set_local_baro() end))
if kc_has_transponder then
	electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER CODE","SET 2000",FlowItem.actorFO,0,
		function () return sysRadios.xpdrCode:getStatus() == 2000 end,
		function () kc_macro_set_xpdrcode(2000) end))
	electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER MODE","STBY",FlowItem.actorFO,0,
		function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
		function () kc_macro_set_xpdrmode(sysRadios.stby) end))
end
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
if kc_has_seatbelt_sgn then
	electricalPowerUpProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
		function () return sysGeneral.passSignsSwitch:getStatus() > 0 end,
		function () sysGeneral.passSignsSwitch:actuate(1) end))
end
if kc_has_nosmoke_sgn then
	electricalPowerUpProc:addItem(ProcedureItem:new("NO SMOKING LIGHTS","ARM",FlowItem.actorFO,0,
		function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
		function () sysGeneral.noSmokingSwitch:actuate(1) end))
end
electricalPowerUpProc:addItem(ProcedureItem:new("ANTI-ICE SYSTEMS","AS REQUIRED",FlowItem.actorFO,0,
		function () return true end,
		function () kc_macro_aice(kc_phase_turnaround) end))
		
-- =====================================================================================================================

-- ================= ENGINE START CHECKS ==================
-- ELECTRICAL POWER UP (SKIP IF BATT ONLY)..COMPLETE  (F/O)
-- *ELECTRIC HYDRAULIC PUMPS......................ON  (F/O)
-- *DOORS.....................................CLOSED  (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED  (F/O)
-- PARKING BRAKE.................................SET  (F/O)
-- *FLIGHT DIRECTOR..............................SET  (F/O)
-- *FUEL PUMPS................................ALL ON  (F/O)
-- APU Start (runs in background)
-- *APU START................................PERFORM  (F/O)
-- *ENGINE BLEED SWITCHES.........................ON  (F/O)
-- ========================================================

local beforeStart = Procedure:new("ENGINE START CHECKS","","")
beforeStart:setFlightPhase(kc_phase_before_start)

beforeStart:addItem(ProcedureItem:new("ELECTRICAL POWER UP (SKIP IF BATT ONLY)","COMPLETE",FlowItem.actorFO,0,
	function () 
		if (kc_has_apu == false and kc_has_gpu == false) or activeBriefings:get("departure:activateAPUPowerUp") == 3 then
			return true
		else
			return 
			sysElectric.apuRunningAnc:getStatus() == 1 or
			sysElectric.gpuOnBus:getStatus() == 1
		end
	end))
if kc_has_hyd_elec_pmps then
	beforeStart:addItem(IndirectProcedureItem:new("HYDRAULIC SYSTEM","AS REQUIRED",FlowItem.actorFO,0,"elechydstart",
		function () return sysHydraulic.elecHydPumpGroup:getStatus() > 0 end,
		function () kc_macro_hyd(kc_phase_before_start)	end))	
end
if kc_has_doors then
	beforeStart:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
		function () return sysGeneral.doorsAnc:getStatus() == 0 end,
		function () kc_macro_doors_ext(kc_phase_before_start) end))
end
beforeStart:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () 
		kc_macro_lights(kc_phase_before_start) 
	end))
beforeStart:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("FUEL SYSTEM","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_fuel(kc_phase_before_start) end))
if kc_has_apu == true then
	beforeStart:addItem(ProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,15,
			function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
			function () 
				kc_procvar_set("apustart",true)
			end))
end
if kc_has_engine_bleed then
	beforeStart:addItem(ProcedureItem:new("ENGINE BLEED SWITCHES","ON",FlowItem.actorFO,0,
		function () return sysAir.engBleedGroup:getStatus() > 0 end,
		function () 
			kc_procvar_set("apuonline",true)
			kc_macro_air(kc_phase_before_start) 
		end))
end
if kc_has_flightdir then
	beforeStart:addItem(ProcedureItem:new("FLIGHT DIRECTOR","SET",FlowItem.actorFO,0,
		function () return sysMCP.fdirAnc:getStatus() > 0 end,
		function () 
			if sysMCP.fdirAnc:getStatus() == 0 then
				sysMCP.fdirGroup:actuate(1) 
			end
		end))
end

-- =====================================================================================================================

-- prepare the aircraft for push and engine start
-- ============== PRE PUSH & ENGINE START ================
-- *DOORS....................................CLOSED  (F/O)
-- PARKING BRAKE................................SET  (CPT)
-- FLAP LEVER....................................UP  (F/O)
-- *BEACON.......................................ON  (F/O)
-- or
-- *STROBES......................................ON  (F/O)
-- *APU BLEED AIR................................ON  (F/O)
-- *EXTERNAL POWER..............................OFF  (F/O)
-- *EXTERNAL POWER.......................DISCONNECT  (F/O)
-- *SEAT BELT LIGHTS.............................ON  (F/O)
-- *NO SMOKING LIGHTS............................ON  (F/O)
-- *TRANSPONDER................................STBY  (F/O)
-- **if pushback selected in briefing
-- *PUSHBACK SERVICE...............ENGAGE IF NEEDED  (CPT)
-- *EXT PWR..........................OFF/DISCONNECT  (F/O)
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- START CLEARANCE FROM GROUND CREW........RECEIVED  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- THRUST LEVERS...............................IDLE  (F/O)		
-- =======================================================

local prePushStartProc = Procedure:new("PRE PUSH & ENGINE START","","ready to start engines")
prePushStartProc:setFlightPhase(kc_phase_before_start)

if kc_has_doors then
prePushStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.doorsAnc:getStatus() == 0 end,
	function () kc_macro_doors_ext(kc_phase_before_start) end))
end
prePushStartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		kc_macro_lights(kc_phase_before_start)
	end))
prePushStartProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
prePushStartProc:addItem(ProcedureItem:new("SET EXTERNAL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_lights(kc_phase_before_start) end))
if kc_has_apu == true then
	prePushStartProc:addItem(ProcedureItem:new("APU BLEED AIR","ON",FlowItem.actorFO,0,
		function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
		function () sysAir.apuBleedSwitch:actuate(1) end))
end
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
if kc_has_seatbelt_sgn == true then
	prePushStartProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorFO,0,
		function () return sysGeneral.passSignsSwitch:getStatus() > 0 end,
		function () sysGeneral.passSignsSwitch:actuate(1) end))
end
if kc_has_nosmoke_sgn == true then
	prePushStartProc:addItem(ProcedureItem:new("NO SMOKING LIGHTS","ARM",FlowItem.actorFO,0,
		function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
		function () sysGeneral.noSmokingSwitch:actuate(1) end))
end
if kc_has_transponder then 
	prePushStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
		function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
		function () 
			 kc_macro_set_xpdrmode(sysRadios.stby)	
			local xpdrcode = activeBriefings:get("departure:squawk")
			sysRadios.xpdrCode:setValue(xpdrcode)
		end))
end
prePushStartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE IF NEEDED",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:pushDirection") == 1 end))
if kc_has_gpu == true and kc_remove_gpu_after == false then
	prePushStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
		function () return sysElectric.gpuConnect:getStatus() == 0 end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(0)
			sysElectric.gpuConnect:actuate(0)
		end))	
end
prePushStartProc:addItem(HoldProcedureItem:new("COMMUNICATION WITH GROUND CREW","ESTABLISH",FlowItem.actorCPT))
prePushStartProc:addItem(HoldProcedureItem:new("START CLEARANCE","RECEIVED",FlowItem.actorCPT))
prePushStartProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:pushDirection") == 1 end))
prePushStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () 
		sysEngines.throttlePos:actuate(0) 
		if kc_is_turboprop or kc_is_ga then
			sysEngines.mixtureLever:actuate(kc_mixture_min)
		end
		if kc_has_proplever then
			sysEngines.propLever:setValue(kc_prop_lvr_max)
		end	
	end))
	
-- =====================================================================================================================

-- **starting engines
-- ==================== ENGINE START =====================
-- START SEQUENCE..........................ANNOUNCE  (CPT)
-- *FUEL SWITCH..................................ON  (F/O)
-- *AIR CONDITIONING PACK SWITCHES..............OFF  (F/O)
-- **if airbus
-- *ENGINE MODE...........................IGN/START  (F/O)
-- **if not airbus
-- *"IGNITION....................................ON  (F/O)

-- START FIRST ENGINE.........STARTING FIRST ENGINE  (CPT)
-- *CHRONO..............................RESET/START  (CPT)
-- POWER LEVERS................................IDLE  (CPT)
-- START SWITCH FIRST ENGINE.................ENGAGE  (F/O) 
-- ENGINE N2.............................INCREASING  (CPT)

-- **if 2 engines
-- START SECOND ENGINE.......STARTING SECOND ENGINE  (CPT)
-- *CHRONO..............................RESET/START  (CPT)
-- POWER LEVERS................................IDLE  (CPT)
-- START SWITCH SECOND ENGINE................ENGAGE  (F/O) 
-- ENGINE N2.............................INCREASING  (CPT)

-- **if 3 engines
-- START THIRD ENGINE.........STARTING THIRD ENGINE  (CPT)
-- *CHRONO..............................RESET/START  (CPT)
-- POWER LEVERS................................IDLE  (CPT)
-- START SWITCH THIRD ENGINE.................ENGAGE  (F/O) 
-- ENGINE N2.............................INCREASING  (CPT)

-- **if 4 engines
-- START FOURTH ENGINE.......STARTING FOURTH ENGINE  (CPT)
-- *CHRONO..............................RESET/START  (CPT)
-- POWER LEVERS................................IDLE  (CPT)
-- START SWITCH FOURTH ENGINE................ENGAGE  (F/O) 
-- ENGINE N2.............................INCREASING  (CPT)

-- **When pushback/towing complete 
-- **TOW BAR DISCONNECTED....................VERIFY  (CPT)  
-- **LOCKOUT PIN REMOVED.....................VERIFY  (CPT)  
-- PARKING BRAKE................................SET  (F/O)
-- ** if airbus
-- *ENGINE MODE................................NORM  (F/O)
-- *PACK SWITCHES.................................ON (F/O)
-- =======================================================

local engStartProc = Procedure:new("ENGINE START","")
engStartProc:setFlightPhase(0-kc_phase_before_start)

if kc_get_nr_engines() == 2 then
engStartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
end
if kc_has_fuel_select then
	engStartProc:addItem(ProcedureItem:new("FUEL SYSTEM","AS REQUIRED",FlowItem.actorFO,0,
		function () return sysFuel.fuelSwitchGroup:getStatus() == 1 end,
		function () kc_macro_fuel(kc_phase_before_start) end))
end
engStartProc:addItem(ProcedureItem:new("AIR CONDITIONING / PACKS","AS REQUIRED",FlowItem.actorPM,0,
	function () return true end,
	function () kc_macro_air(kc_phase_before_start) end))
if kc_is_airbus == true then
	engStartProc:addItem(IndirectProcedureItem:new("ENGINE MODE","IGN/START",FlowItem.actorFO,0,"ignitionstart",
		function () return sysEngines.engIgnitionGroup:getStatus() == kc_ab_engm_strt end,
		function () kc_macro_set_eng_mode(1) end))
else
	engStartProc:addItem(IndirectProcedureItem:new("IGNITION","ON",FlowItem.actorFO,0,"ignitionstart",
		function () return sysEngines.engIgnitionGroup:getStatus() > 0 end,
		function () sysEngines.engIgnitionGroup:actuate(1) end))
end
if kc_get_nr_engines() == 1 then
	engStartProc:addItem(HoldProcedureItem:new("ENGINE","START",FlowItem.actorCPT))
	if kc_has_chrono == true then
		engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
			function () return sysGeneral.chrono:getStatus() > 0 end,
			function () 
				if sysGeneral.chrono:getStatus() == 0 then 
					sysGeneral.chrono:actuate(1)
				end
			end))
	end
else
	engStartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","STARTING FIRST ENGINE",FlowItem.actorCPT))
	if kc_has_chrono == true then
		engStartProc:addItem(ProcedureItem:new("CHRONO","RESET/START",FlowItem.actorCPT,0,
			function () return sysGeneral.chrono:getStatus() > 0 end,
			function () 
				if sysGeneral.chrono:getStatus() == 0 then 
					sysGeneral.chrono:actuate(1)
				end
			end))
	end
end
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVERS","IDLE",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () 
		sysEngines.throttlePos:actuate(0) 
		if kc_is_turboprop or kc_is_ga then
			sysEngines.mixtureLever:actuate(kc_mixture_min)
		end
		if kc_has_proplever then
			sysEngines.propLever:setValue(kc_prop_lvr_max)
		end	
	end))
if kc_get_nr_engines() == 1 then
	engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","ENGAGE",FlowItem.actorFO,20,"eng_start_1_grd",
		function () return sysEngines.engStart1Switch:getStatus() > 0 end,
		function () 
			kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting engine")
		end))
else
	engStartProc:addItem(IndirectProcedureItem:new("START SWITCH FIRST ENGINE","ENGAGE",FlowItem.actorFO,20,"eng_start_1_grd",
		function () 
			if activeBriefings:get("taxi:startSequence") == 1 and kc_get_nr_engines() > 1 then
				return sysEngines.engStart2Switch:getStatus() > 0
			else 
				return sysEngines.engStart1Switch:getStatus() > 0
			end 
		end,
		function () 
			if activeBriefings:get("taxi:startSequence") == 1 and kc_get_nr_engines() > 1 then
				kc_procvar_set("engstart2",true)
			else 
				kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting first engine")
		end 
	end))
end
if kc_get_nr_engines() == 1 then
	engStartProc:addItem(ProcedureItem:new("ENGINE N2","INCREASING",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end,
		function () end))
else
	engStartProc:addItem(ProcedureItem:new("FIRST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
		function () if activeBriefings:get("taxi:startSequence") == 1 and kc_get_nr_engines() > 1 then
			return get("sim/cockpit2/engine/indicators/N2_percent",1) > kc_n2_after_start else 
			return get("sim/cockpit2/engine/indicators/N2_percent",0) > kc_n2_after_start end 
		end,
		function () end))	
end
if kc_get_nr_engines() >= 2 then
	engStartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","STARTING SECOND ENGINE",FlowItem.actorCPT))
	if kc_has_chrono == true then
		engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
			function () return sysGeneral.chrono:getStatus() > 0 end,
			function () 
				if sysGeneral.chrono:getStatus() == 0 then 
					sysGeneral.chrono:actuate(1)
				end
			end))
	end
	engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","IDLE",FlowItem.actorCPT,3,"eng_start_2_lever",
		function () return sysEngines.throttlePos:getStatus() == 0	end,
		function () 
			command_once("sim/engines/throttle_idle")
		end))
	engStartProc:addItem(IndirectProcedureItem:new("START SWITCH SECOND ENGINE","ENGAGE",FlowItem.actorCPT,20,"eng_start_2_grd",
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
			else 
				kc_procvar_set("engstart2",true)
			end 
			kc_speakNoText(0,"starting second engine")
		end))
	engStartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
		function () if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/cockpit2/engine/indicators/N2_percent",0) > kc_n2_after_start else 
			return get("sim/cockpit2/engine/indicators/N2_percent",1) > kc_n2_after_start end 
		end,
		function () 
		end))
end
if kc_get_nr_engines() >= 3 then
	engStartProc:addItem(HoldProcedureItem:new("START THIRD ENGINE","STARTING THIRD ENGINE",FlowItem.actorCPT))
	if kc_has_chrono == true then
		engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
			function () return sysGeneral.chrono:getStatus() > 0 end,
			function () 
				if sysGeneral.chrono:getStatus() == 0 then 
					sysGeneral.chrono:actuate(1)
				end
			end))
	end
	engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","IDLE",FlowItem.actorCPT,3,"eng_start_3_lever",
		function () return sysEngines.throttlePos:getStatus() == 0	end,
		function () 
			command_once("sim/engines/throttle_idle")
		end))
	engStartProc:addItem(IndirectProcedureItem:new("START SWITCH THIRD ENGINE","ENGAGE",FlowItem.actorCPT,20,"eng_start_3_grd",
		function () return sysEngines.engStart3Switch:getStatus() == 1 end,
		function () 
			kc_procvar_set("engstart3",true)
			kc_speakNoText(0,"starting third engine")
		end))
	engStartProc:addItem(ProcedureItem:new("3RD ENGINE N2","INCREASING",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/engine/indicators/N2_percent",2) > kc_n2_after_start end,
		function () 
		end))
end
if kc_get_nr_engines() >= 4 then
	engStartProc:addItem(HoldProcedureItem:new("START FOURTH ENGINE","STARTING FOURTH ENGINE",FlowItem.actorCPT))
	if kc_has_chrono == true then
		engStartProc:addItem(ProcedureItem:new("CHRONO","START",FlowItem.actorCPT,0,
			function () return sysGeneral.chrono:getStatus() > 0 end,
			function () 
				if sysGeneral.chrono:getStatus() == 0 then 
					sysGeneral.chrono:actuate(1)
				end
			end))
	end
	engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","IDLE",FlowItem.actorCPT,3,"eng_start_4_lever",
		function () return sysEngines.throttlePos:getStatus() == 0	end,
		function () 
			command_once("sim/engines/throttle_idle")
		end))
	engStartProc:addItem(IndirectProcedureItem:new("START SWITCH FOURTH ENGINE","ENGAGE",FlowItem.actorCPT,20,"eng_start_4_grd",
		function () return sysEngines.engStart4Switch:getStatus() == 1 end,
		function () 
			kc_procvar_set("engstart4",true)
			kc_speakNoText(0,"starting fourth engine")
		end))
	engStartProc:addItem(ProcedureItem:new("4TH ENGINE N2","INCREASING",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/engine/indicators/N2_percent",3) > kc_n2_after_start end,
		function () 
		end))
end
engStartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(HoldProcedureItem:new("TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))
if kc_is_airbus == true then
	engStartProc:addItem(ProcedureItem:new("ENGINE MODE","NORM",FlowItem.actorFO,0,
		function () return sysEngines.engIgnitionGroup:getStatus() == kc_ab_engm_norm end,
		function () kc_macro_set_eng_mode(0) end))
end

-- =====================================================================================================================

-- ================= AFTER START CHECK ===================
-- PARKING BRAKE................................SET  (F/O)
-- GENERATORS....................................ON  (F/O)			
-- *PACKS........................................ON  (F/O)
-- **not airbus
-- *ISOLATION VALVES........................ON/AUTO  (F/O)
-- *"EXT PWR.........................OFF/DISCONNECT  (F/O)
-- *APU GENERATOR...............................OFF  (F/O)
-- *APU BLEED AIR...............................OFF  (F/O)
-- *APU (MASTER)................................OFF  (F/O)
-- *SPEED BRAKES & GROUND SPOILERS.............DOWN  (F/O)
-- *ENGINE ANTI-ICE...................AS CONFIGURED  (F/O)
-- *WING ANTI-ICE.....................AS CONFIGURED  (F/O)
-- *ENGINE HYDRAULIC PUMPS.......................ON  (F/O)
-- *PITOT STATIC............................AUTO/ON  (F/O)
-- V SPEEDS.........................SET AND CHECKED   (PF)
-- TAKEOFF BRIEFING.......................COMPLETED   (PF)
-- TIME.......................................NOTED   (PF)
-- FLIGHT CONTROLS............................CHECK (BOTH)
-- FLAPS............................SET FOR TAKEOFF   (PF)
-- MCP...................................INITIALIZE  (F/O)
-- *TRANSPONDER..................................ON  (F/O)
-- =======================================================

local afterStartProc = Procedure:new("AFTER START CHECK","","")
afterStartProc:setFlightPhase(kc_phase_after_start)

afterStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () end))
afterStartProc:addItem(ProcedureItem:new("ELECTRIC SYSTEM","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysElectric.genSwitchGroup:getStatus() > 0 end,
	function () kc_macro_elec_system(kc_phase_after_start) end))
afterStartProc:addItem(ProcedureItem:new("AIR CONDITIONING","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_air(kc_phase_after_start) end))
if kc_has_gpu then
	afterStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
		function () return sysElectric.gpuConnect:getStatus() == 0 end,
		function () 
			sysElectric.gpuGenBusGroup:actuate(0)
			sysElectric.gpuConnect:actuate(0)
		end))	
end
if kc_has_apu then
	afterStartProc:addItem(ProcedureItem:new("APU GENERATOR","OFF",FlowItem.actorFO,0,
		function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
		function () sysElectric.apuStartSwitch:actuate(0) end))
	afterStartProc:addItem(ProcedureItem:new("APU BLEED AIR","OFF",FlowItem.actorFO,0,
		function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
		function () 
			sysAir.apuBleedSwitch:actuate(0)
		end))
	if kc_is_airbus then
		afterStartProc:addItem(ProcedureItem:new("APU MASTER","OFF",FlowItem.actorFO,3,
			function () return sysElectric.apuMaster:getStatus() == 0 end,
			function () sysElectric.apuMaster:setValue(0) end))
	else
		afterStartProc:addItem(ProcedureItem:new("APU","OFF",FlowItem.actorFO,3,
			function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
			function () sysElectric.apuStartSwitch:setValue(0) end))
	end
end
if kc_has_speedbrake then
	afterStartProc:addItem(ProcedureItem:new("SPEED BRAKES & GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
end
afterStartProc:addItem(ProcedureItem:new("ANTI-ICE SYSTEMS","AS REQUIRED",FlowItem.actorFO,0,
		function () return true end,
		function () kc_macro_aice(kc_phase_after_start) end))
afterStartProc:addItem(ProcedureItem:new("HYDRAULIC PUMPS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_hyd(kc_phase_after_start) end)) 
afterStartProc:addItem(HoldProcedureItem:new("V SPEEDS","SET AND CHECKED",FlowItem.actorCPT))
afterStartProc:addItem(HoldProcedureItem:new("TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () 
		if kc_full_rgt_rudder > 0 then 
			return sysControls.rudderDeflection:getStatus() > kc_full_rgt_rudder
		else
			return sysControls.rudderDeflection:getStatus() < kc_full_rgt_rudder
		end
	 end))
afterStartProc:addItem(IndirectProcedureItem:new("TIME","NOTED",FlowItem.actorCPT,0,"timesetblockoff",
	function () return true end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:gateStand") < 3 end))
	
afterStartProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPF,0,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end))
afterStartProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () kc_macro_mcp(kc_phase_turnaround) end))
if kc_has_transponder then
	afterStartProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
		function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
		function () 
			kc_macro_set_xpdrmode(sysRadios.tara)
			local xpdrcode = activeBriefings:get("departure:squawk")
			sysRadios.xpdrCode:setValue(xpdrcode)
	end))
end 
afterStartProc:addItem(ProcedureItem:new("TAXI LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 1 end,
	function () 
		kc_macro_lights(kc_phase_taxi_rwy)
	end))
-- =====================================================================================================================

-- =================== BEFORE TAKEOFF ====================
-- FLAPS............................CHECK T/O FLAPS  (CPT)
-- *A/P ALTITUDE........................SET CHECKED  (CPT)
-- *A/P HEADING BUG.............................SET  (CPT)
-- *ENGINE ANTI-ICE...................AS CONFIGURED  (F/O)
-- *WING ANTI-ICE.....................AS CONFIGURED  (F/O)
-- *WINDSHIELD HEAT..............................ON  (F/O)
-- *AUTOBRAKE.................................R T O  (F/O)
-- MCP...................................INITIALIZE  (F/O)
-- *TAKEOFF CONFIG............................CHECK  (CPT)
-- *"ELEVATOR TRIM..........SET FOR TAKEOFF & CHECK  (CPT)
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE","","")
beforeTakeoffProc:setFlightPhase(kc_phase_before_takeoff)

beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end)) 
if kc_has_alt_sel then
	beforeTakeoffProc:addItem(ProcedureItem:new("A/P ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
		function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
		function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end))
end
if kc_is_airbus == false and kc_has_hdg_sel == true then
	beforeTakeoffProc:addItem(ProcedureItem:new("A/P HEADING BUG","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
		function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
		function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end))
end
beforeTakeoffProc:addItem(ProcedureItem:new("ANTI-ICE SETTINGS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_aice(kc_phase_after_start) end))
if kc_has_autobrake then
	beforeTakeoffProc:addItem(ProcedureItem:new("AUTOBRAKE","R T O",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeRTO end,
		function () kc_macro_set_autobrake(kc_AutoBrakeRTO) end))
end
beforeTakeoffProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () kc_macro_mcp(kc_phase_before_takeoff) end))
beforeTakeoffProc:addItem(HoldProcedureItem:new("ELEVATOR TRIM","SET FOR TAKEOFF & CHECK",FlowItem.actorCPT))
if kc_has_speedbrake and kc_spdbrk_can_arm then
	beforeTakeoffProc:addItem(ProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == kc_spdbrk_arm_pos end,
	function () sysControls.Speedbrake:setValue(kc_spdbrk_arm_pos) end))
end 
if kc_has_toc then
	beforeTakeoffProc:addItem(HoldProcedureItem:new("TAKEOFF CONFIG","CHECK",FlowItem.actorCPT))
end
-- =====================================================================================================================

-- =================== RUNWAY ENTRY  =====================
-- EXTERNAL LIGHTS.............................SET  (F/O)
-- *TRANSPONDER...........................ON/TA RA  (F/O)
-- *PACS & BLEEDS......................AS REQUIRED  (F/O)
-- *WEATHER RADAR...............................ON  (F/O)
-- *CLOCK....................................START  (F/O)
-- *OXYGEN SUPPLY...............................ON  (F/O)
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY","","")
runwayEntryProc:setFlightPhase(0-kc_phase_before_takeoff)

runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() > 0 end,
	function () kc_macro_lights(kc_phase_before_takeoff) end))
if kc_has_transponder then 
	runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON/TA RA",FlowItem.actorFO,0,
		function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
		function () 
			sysRadios.xpdrSwitch:actuate(sysRadios.tara)
			activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			kc_procvar_set("above10k",true) -- background 10.000 ft activities
			kc_procvar_set("attransalt",true) -- background transition altitude activities
		end))
end
runwayEntryProc:addItem(ProcedureItem:new("PACKS / BLEEDS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () kc_macro_air(kc_phase_before_takeoff) end))
if kc_has_wx_radar then
	runwayEntryProc:addItem(ProcedureItem:new("WEATHER RADAR","ON",FlowItem.actorFO,0,
		function () return sysEFIS.wxrPilot:getStatus() ~= 0 end,
		function () sysEFIS.wxrPilot:actuate(1) end))
end
if kc_has_clock then
	runwayEntryProc:addItem(ProcedureItem:new("CLOCK","START",FlowItem.actorFO,0,
		function () return sysGeneral.clock:getStatus() == 1 end,
		function () sysGeneral.clock:actuate(1) end))
end

-- =====================================================================================================================

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========

-- == GEAR UP
-- COMMAND GEAR.................................UP   (PM)

-- == RETRACT FLAPS
-- *YAW DAMPER..................................ON   (PF)
-- *GEAR........................................UP
-- FLAPS x SPEED....................RETRACT AT 999   (PF)
-- ...
-- FLAPS UP....................................SET   (PF)
-- *A/P 1.......................................ON   (PF)
-- *PACKS.......................................ON   (PF)
-- *BLEEDS......................................ON   (PF)

-- **Whatever comes first
-- TRANSITION ALTITUDE............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..................................STD (BOTH)
-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS..............................OFF   (PM)
-- FASTEN BELTS SWITCH.........................OFF   (PM)
-- ======================================================

-- =====================================================================================================================

local gearUpProc = Procedure:new("COMMAND GEAR UP","")
gearUpProc:setFlightPhase(0-kc_phase_takeoff)

if kc_has_retractgear then
	gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
		function () return sysGeneral.GearSwitch:getStatus() == 0 end,
		function () 
			sysGeneral.GearSwitch:actuate(0) 
			kc_speakNoText(0,"gear coming up") 
		end))
end

-- =====================================================================================================================

local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(0-kc_phase_takeoff)

if kc_is_airbus == false then
	flapsUpProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
		function () return sysControls.yawDamper:getStatus() == 1 end,
		function () sysControls.yawDamper:actuate(1) end))
end
if kc_has_retractgear then
	flapsUpProc:addItem(ProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,
		function () return sysGeneral.GearSwitch:getStatus() == 0 end,
		function () sysGeneral.GearSwitch:actuate(0) end))
end
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
if kc_has_autopilot then
	flapsUpProc:addItem(HoldProcedureItem:new("A/P 1","ACTIVATE",FlowItem.actorCPT))
	flapsUpProc:addItem(ProcedureItem:new("A/P 1","ON",FlowItem.actorPF,0,true,
		function () 
			sysMCP.ap1Switch:actuate(1) 
		end))
end
flapsUpProc:addItem(ProcedureItem:new("BLEEDS / PACKS","ON",FlowItem.actorPM,0,true,
		function () kc_macro_air(kc_phase_takeoff) end))

-- =====================================================================================================================

-- ================ AFTER TAKEOFF CHECK ==================
-- *LANDING GEAR..........................RETRACTED   (PM)
-- FLAPS.........................................UP   (PM)
-- *AUTOBRAKE...................................OFF   (PM)
-- =======================================================

local afterTakeoffCheck = Checklist:new("AFTER TAKEOFF CHECK","after takeoff check","")
afterTakeoffCheck:setFlightPhase(kc_phase_climb)

if kc_has_retractgear then
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
if kc_has_autobrake then
	afterTakeoffCheck:addItem(ChecklistItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeOff end,
		function () kc_macro_set_autobrake(kc_AutoBrakeOff) end))
end
-- =====================================================================================================================


-- ==================== CLIMB CHECKS ======================
-- *PACKS & ENGINE BLEEDS.........................ON   (PM)
-- *OXYGEN SUPPLY.................................ON   (PM)
-- *ENGINE ANTI-ICE..............................OFF   (PM)
-- *WING ANTI-ICE................................OFF   (PM)
-- ========================================================

local climbCheck = Procedure:new("CLIMB CHECKS","","")
climbCheck:setFlightPhase(kc_phase_climb)

climbCheck:addItem(ProcedureItem:new("PACKS / BLEEDS","ON",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_air(kc_phase_takeoff) end))
if kc_has_oxygen then 
	climbCheck:addItem(ProcedureItem:new("OXYGEN SUPPLY","ON",FlowItem.actorFO,0,
		function () return sysAir.oxygenMaster:getStatus() > 0 end,
		function () sysAir.oxygenMaster:actuate(1) end))
end
if kc_has_eng_antiice or kc_has_wing_antiice then
	climbCheck:addItem(HoldProcedureItem:new("ANTI-ICE","OFF",FlowItem.actorCPT))
end
if kc_has_eng_antiice then
	climbCheck:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
		function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
		function () sysAice.engAntiIceGroup:actuate(0) end))
end
if kc_has_wing_antiice then
	climbCheck:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
		function () return sysAice.wingAntiIce:getStatus() == 0 end,
		function () sysAice.wingAntiIce:actuate(0) end))
end

-- =====================================================================================================================

-- =================== DESCENT CHECK ====================
-- VREF...............................CHECK IN FMC   (PF)
-- LANDING DATA...............VREF __, MINIMUMS __   (PF)
-- PRESSURIZATION...............SET LAND ALT __ FT   (PM)
-- *ENGINE ANTI-ICE..................AS CONFIGURED   (PM)
-- *WING ANTI-ICE....................AS CONFIGURED   (PM)
-- *WINDSHIELD HEAT....................AUTO/ALL ON   (PM)
-- *AUTOBRAKE........................AS CONFIGURED   (PM)
-- *SEAT BELT LIGHTS............................ON   (PM)
-- === Whatever comes first
-- TRANSITION LEVEL...............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..........................QNH AT DEST (BOTH)
-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................ON   (PM)
-- FASTEN BELTS SWITCH..........................ON   (PM)
-- ======================================================

local descentProc = Procedure:new("DESCENT CHECK","","")
descentProc:setFlightPhase(kc_phase_descent)

descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
if kc_is_airbus then
	descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
		function () 
			return true end,
		function ()
			-- sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
			kc_procvar_set("below10k",true) -- background 10.000 ft activities
			kc_procvar_set("attranslvl",true) -- background transition level activities
			kc_procvar_set("above10k",false) 
			kc_procvar_set("attransalt",false) 
		end))
else
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
descentProc:addItem(ProcedureItem:new("ANTI-ICE SETTINGS","AS REQUIRED",FlowItem.actorPM,0,
	function () return true end,
	function () kc_macro_aice(kc_phase_descent) end))
if kc_has_autobrake then
	descentProc:addItem(ProcedureItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")]) end,
		function () kc_macro_set_autobrake(tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])) 
		end))
end
if kc_has_seatbelt_sgn then
	descentProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","ON",FlowItem.actorPM,0,
		function () return sysGeneral.passSignsSwitch:getStatus() == 1 end,
		function () sysGeneral.passSignsSwitch:actuate(1) end))
end 

-- =====================================================================================================================

-- ================== LANDING PROCEDURE ==================
-- ALTIMETERS...............................QNH SET (BOTH)
-- *COURSE NAV 1....................SET FOR LANDING   (PF)
-- *COURSE NAV 2....................SET FOR LANDING   (PF)
-- *AIR CONDITIONING PACK SWITCHES......AS REQUIRED   (PM)
-- LANDING LIGHTS................................ON   (PF)

-- ==== EXTEND FLAPS
-- FLAPS x............................EXTEND AT 999   (PF)
-- ...
-- FLAPS.......................................FULL   (PF)

-- === GEAR DOWN
-- LANDING GEAR........................DOWN 3 GREEN   (PM)

-- GO AROUND ALTITUDE.......................... SET   (PM)
-- GO AROUND HEADING............................SET   (PM)
-- *SPEEDBRAKE..................................ARM   (PM)
-- =======================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","")
landingProc:setFlightPhase(kc_phase_approach)

landingProc:addItem(HoldProcedureItem:new("ALTIMETERS","QNH %s|activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH))
if kc_is_airbus == false and kc_has_ils then 
	landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorPF,0,
		function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
		function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
	landingProc:addItem(ProcedureItem:new("COURSE NAV 2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorPM,0,
		function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
		function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
end
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AS REQUIRED",FlowItem.actorPM,0,true,
		function () kc_macro_air(kc_phase_approach) end))
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPF,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights(kc_phase_approach) end))	

-- =====================================================================================================================

local flapsProc = Procedure:new("EXTEND FLAPS","","")
flapsProc:setFlightPhase(0-kc_phase_approach)

for ldgflapidx=1,kc_get_nr_flapdetents(),1 do
	flapsProc:addItem(HoldProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"EXTEND AT " .. sysControls.flaps_spd[ldgflapidx] .. " KTS",FlowItem.actorPF,nil,
		function () return tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")]) < ldgflapidx end))
	flapsProc:addItem(ProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"SET",FlowItem.actorPNF,0,
		function () return true end,
		-- function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[ldgflapidx] end,
		function () kc_macro_set_flap(ldgflapidx) end,
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
if kc_has_alt_sel then
	flapsProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
		function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
		function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
end
if kc_has_hdg_sel then
	flapsProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
		function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
		function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))	
end
if kc_has_speedbrake and kc_spdbrk_can_arm then
	flapsProc:addItem(IndirectProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,"armspdbrk",
	function () return sysControls.Speedbrake:getStatus() == kc_spdbrk_arm_pos end,
	function () sysControls.Speedbrake:setValue(kc_spdbrk_arm_pos) end))
end 


-- =====================================================================================================================

-- ================== LANDING CHECKLIST ==================
-- FLAPS..............................LANDING FLAPS   (PM)
-- *LANDING GEAR...............................DOWN   (PM) 
-- LANDING LIGHTS................................ON   (PM)
-- *AUTOBRAKE...........................AS REQUIRED   (PM)
-- *SPEEDBRAKE................................ARMED   (PM)
-- =======================================================	
	
local LandingCheck = Checklist:new("LANDING CHECKLIST","landing checklist","")
LandingCheck:setFlightPhase(kc_phase_approach)

LandingCheck:addItem(ChecklistItem:new("FLAPS","LANDING FLAPS %s|kc_pref_split(kc_LandingFlaps)[activeBriefings:get(\"approach:flaps\")]",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")])] end,
	function () kc_macro_set_flap(tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")])) end))
if kc_has_retractgear == true then
	LandingCheck:addItem(ChecklistItem:new("LANDING GEAR","DOWN",FlowItem.actorPM,0,
		function () return sysGeneral.GearSwitch:getStatus() == 1 end,
		function () 
			sysGeneral.GearSwitch:actuate(1) 
		end))
end
LandingCheck:addItem(ChecklistItem:new("LANDING LIGHTS","ON",FlowItem.actorPM,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights(kc_phase_approach)end))
if kc_has_autobrake then
	LandingCheck:addItem(ChecklistItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,0,
		function () return sysControls.Autobrake:getStatus() == tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")]) end))
end
if kc_has_speedbrake and kc_spdbrk_can_arm then
	LandingCheck:addItem(ChecklistItem:new("SPEEDBRAKE","ARM",FlowItem.actorPM,0,
	function () return sysControls.Speedbrake:getStatus() == kc_spdbrk_arm_pos end,
	function () sysControls.Speedbrake:setValue(kc_spdbrk_arm_pos) end))
end 

-- =====================================================================================================================

local ap1off = Procedure:new("A/P 1","OFF")
ap1off:setFlightPhase(0-kc_phase_approach)

if kc_has_autopilot then
	ap1off:addItem(ProcedureItem:new("A/P 1","OFF",FlowItem.actorFO,0,
		function () return sysMCP.ap1Switch:getStatus() == 0 end,
		function () sysMCP.ap1Switch:actuate(0) end))
end

if kc_has_autothrottle then
	ap1off:addItem(ProcedureItem:new("A/T","OFF",FlowItem.actorFO,0,
		function () return sysMCP.athrSwitch:getStatus() == 0 end,
		function () sysMCP.athrSwitch:actuate(0) end))
end
-- =====================================================================================================================

-- ============== AFTER LANDING PROCEDURE ===============
-- *CLOCK.....................................STOP  (F/O)
-- *AILERON & RUDDER TRIM....................RESET  (F/O)
-- *TRANSPONDER........................AS REQUIRED  (F/O)
-- *WEATHER RADAR.........................OFF/STBY  (F/O)
-- *SPEEDBRAKE................................DOWN  (F/O)
-- *CHRONO & ET...............................STOP  (F/O)
-- *PITOT/STATIC..........................OFF/AUTO  (F/O)
-- FLAPS........................................UP  (F/O)
-- EXTERNAL LIGHTS.....................AS REQUIRED  (F/O)
-- *SPEED BRAKES.........................RETRACTED  (F/O)
-- *TAXI LIGHT...........................RETRACTED  (F/O)
-- *ENGINE ANTI-ICE............................OFF  (F/O)
-- *WING ANTI-ICE..............................OFF  (F/O)
-- *APU START..............................PERFORM  (F/O)
-- *AUTOBRAKE..................................OFF  (F/O)
-- MCP.........................................SET  (F/O)
-- *OXYGEN SUPPLY..............................OFF  (F/O)
-- ======================================================

local afterLandingProc = Procedure:new("AFTER LANDING","")
afterLandingProc:setFlightPhase(kc_phase_afterland)

if kc_has_clock then
	afterLandingProc:addItem(ProcedureItem:new("CLOCK","STOP",FlowItem.actorFO,0,
		function () return sysGeneral.clock:getStatus() == kc_et_timer_off end,
		function () sysGeneral.clock:actuate(kc_et_timer_off) end))
end
if kc_has_aileron_trim or kc_has_rudder_trim then
	afterLandingProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
		function () return 
			get("sim/cockpit2/controls/aileron_trim") == 0 and
			get("sim/cockpit2/controls/rudder_trim") == 0
		end,
		function () 
			sysControls.aileronReset:actuate(1)
			sysControls.rudderReset:actuate(1)
		end))
end
if kc_has_transponder then 
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
end
if kc_has_wx_radar then
	afterLandingProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF/STBY",FlowItem.actorFO,0,
		function () return sysEFIS.wxrPilot:getStatus() == 0 end,
		function () sysEFIS.wxrPilot:actuate(0) end))
end
if kc_has_speedbrake then
	afterLandingProc:addItem(ProcedureItem:new("SPEEDBRAKES","DOWN",FlowItem.actorFO,0,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
end
afterLandingProc:addItem(ProcedureItem:new("CHRONO & ET","STOP",FlowItem.actorFO,0,
	function () return true end,
	function () activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
afterLandingProc:addItem(ProcedureItem:new("ANTI ICE SETTINGS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_aice(kc_phase_afterland) end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorFO,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() == 0 end,
	function () kc_macro_lights(kc_phase_afterland) end))
if kc_has_apu == true then
	afterLandingProc:addItem(ProcedureItem:new("APU START","PERFORM",FlowItem.actorFO,0,
		function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
		function () 
			kc_procvar_set("apustart",true)
			kc_procvar_set("apuonline",true)
		end,
		function () return activeBriefings:get("approach:activateAPUafterLand") == 2 end))
end

if kc_has_autobrake == true then
	afterLandingProc:addItem(ProcedureItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeOff end,
		function () kc_macro_set_autobrake(kc_AutoBrakeOff) end))
end
afterLandingProc:addItem(ProcedureItem:new("MCP","SET",FlowItem.actorFO,0,
	function () return sysMCP.fdirGroup:getStatus() == 0 end,
	function () kc_macro_mcp(kc_phase_afterland) end))
if kc_has_oxygen then 
	afterLandingProc:addItem(ProcedureItem:new("OXYGEN SUPPLY","OFF",FlowItem.actorFO,0,
		function () return sysAir.oxygenMaster:getStatus() == 0 end,
		function () sysAir.oxygenMaster:actuate(0) end))
end
-- =====================================================================================================================

local taxiLightOff = Procedure:new("TAXI LIGHT OFF","")
taxiLightOff:setFlightPhase(0-kc_phase_shutdown)

if kc_has_taxi_light then
	taxiLightOff:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
		function () return sysLights.taxiSwitch:getStatus() == 0 end,
		function () sysLights.taxiSwitch:actuate(0) end))
end

if kc_has_ll_as_taxi then
	taxiLightOff:addItem(ProcedureItem:new("LANDING LIGHTS","OFF",FlowItem.actorFO,0,
		function () return sysLights.landLightGroup:getStatus() == 0 end,
		function () sysLights.landLightGroup:actuate(0) end))
end

-- =====================================================================================================================

-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- ELECTRIC POWER ESTABLISHED........SET AND CHECK  (CPT)
-- THROTTLES..................................IDLE  (F/O)
-- *EXTERNAL POWER..............................ON  (F/O)
-- *TRANSPONDER...............................STBY  (F/O)
-- *TAXI LIGHT.................................OFF  (F/O) 
-- PARKING BRAKE...............................SET  (F/O)
-- ENGINES.....................................CUT  (CPT)
-- *ENGINE/MASTERS.............................OFF  (CPT)
-- *THROTTLE LEVERS.........................CUTOFF  (CPT)
-- *FUEL SWITCH................................OFF  (F/O)
-- *CHRONO....................................STOP  (F/O)
-- *SEAT BELT SIGNS............................OFF  (F/O)
-- *GENERATORS.................................OFF  (F/O)
-- *BLEED AIR..................................OFF  (F/O)
-- *FUEL PUMPS.................................OFF  (F/O)
-- WINDSHIELD HEAT.............................OFF  (F/O)
-- PITOT / STATIC.........................AUTO/OFF  (F/O)
-- *ENGINE ANTI-ICE............................OFF  (F/O)
-- *WING ANTI-ICE..............................OFF  (F/O)
-- *ENGINE HYDRAULIC PUMPS.....................OFF  (F/O)
-- *ELECTRIC HYDRAULIC PUMPS...................OFF  (F/O)
-- *DOORS.....................................OPEN  (F/O)
-- ======================================================

local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE","","")
shutdownProc:setFlightPhase(kc_phase_shutdown)

shutdownProc:addItem(HoldProcedureItem:new("ELECTRIC POWER ESTABLISHED","SET AND CHECK",FlowItem.actorCPT))
shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","IDLE",FlowItem.actorFO,0,"throttleidleend",
	function ()
		return get("sim/cockpit2/engine/actuators/throttle_ratio_all") < 0.3
	end))
if kc_has_gpu then
	shutdownProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
		function () return sysElectric.gpuOnBus:getStatus() == 1 end,
		function () 
			sysElectric.gpuConnect:actuate(1)
			sysElectric.gpuGenBusGroup:actuate(1)
		end,
		function () return activeBriefings:get("approach:powerAtGate") > 1 end))
end
if kc_has_transponder then
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.stby end,
	function () 
		kc_macro_set_xpdrmode(sysRadios.stby) 
		activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
end
shutdownProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () kc_macro_lights(kc_phase_turnaround) end))
shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
shutdownProc:addItem(HoldProcedureItem:new("ENGINES","CUT",FlowItem.actorCPT))
if kc_is_airbus then
	shutdownProc:addItem(IndirectProcedureItem:new("ENGINE MASTERS","OFF",FlowItem.actorCPT,10,"throttlescutland",
		function () return sysEngines.engStarterGroup:getStatus() == 0 end,
		function () sysEngines.engStarterGroup:actuate(0) end))
else
	shutdownProc:addItem(IndirectProcedureItem:new("ENGINES","OFF",FlowItem.actorCPT,0,"throttlescutland",
		function () return get("sim/cockpit2/engine/indicators/engine_speed_rpm",0) < 1500 end,
		function () kc_macro_stop_engine() end))
end
shutdownProc:addItem(ProcedureItem:new("POWER LEVERS","CUT OFF",FlowItem.actorFO,0,
	function () return sysEngines.throttlePos:getStatus() == 0 end,
	function () 
		sysEngines.throttlePos:actuate(0) 
		if kc_is_turboprop or kc_is_ga then
			sysEngines.mixtureLever:actuate(kc_mixture_off)
		end
		if kc_has_proplever then
			sysEngines.propLever:setValue(kc_prop_lvr_feather)
		end	
	end))
if kc_has_fuel_select then
	shutdownProc:addItem(ProcedureItem:new("FUEL SYSTEM","OFF",FlowItem.actorFO,0,
		function () return sysFuel.fuelSwitchGroup:getStatus() == 0 end,
		function () kc_macro_fuel(kc_phase_shutdown) end))
end
if kc_has_chrono then
	shutdownProc:addItem(ProcedureItem:new("CHRONO","STOP",FlowItem.actorCPT,0,
		function () return sysGeneral.chrono:getStatus() > 0 end,
		function () 
			if sysGeneral.chrono:getStatus() > 0 then 
				sysGeneral.chrono:actuate(1)
			end
		end))
end
if kc_has_seatbelt_sgn then
	shutdownProc:addItem(ProcedureItem:new("SEAT BELT SIGNS","OFF",FlowItem.actorFO,0,
		function () return sysGeneral.passSignsSwitch:getStatus() == 0 end,
		function () sysGeneral.passSignsSwitch:actuate(0) end))
end
shutdownProc:addItem(ProcedureItem:new("ELECTRIC SYSTEM","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_elec_system(kc_phase_shutdown) end))
shutdownProc:addItem(ProcedureItem:new("PACK/BLEED AIR/OXYGEN","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysAir.engBleedGroup:getStatus() == 0 end,
	function () kc_macro_air(kc_phase_shutdown)	end))
shutdownProc:addItem(ProcedureItem:new("FUEL BOOST BOTH","OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(0)	end))
shutdownProc:addItem(ProcedureItem:new("ANTI-ICE SETTINGS","AS REQUIRED",FlowItem.actorPM,0,
	function () return true end,
	function () kc_macro_aice(kc_phase_colddark) end))
shutdownProc:addItem(ProcedureItem:new("HYDRAULIC PUMPS","OFF",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_hyd(kc_phase_colddark) end)) 
if kc_has_doors then
	shutdownProc:addItem(ProcedureItem:new("DOOR","OPEN",FlowItem.actorFO,0,
		function () return sysGeneral.doorGroup:getStatus() > 0 end,
		function () kc_macro_doors_ext(kc_phase_shutdown) end))	
end

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","")
coldAndDarkProc:setFlightPhase(SOP.phaseColdAndDark)
coldAndDarkProc:addItem(ProcedureItem:new("COLD & DARK","SET","SYS",1,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))
coldAndDarkProc:addItem(ProcedureItem:new("GPU DISCONNECT","SET","SYS",0,true,
	function ()
		if kc_has_gpu then
			sysElectric.gpuConnect:actuate(0)
		end
		getActiveSOP():reset()
		getActiveSOP():setActiveFlowIndex(1)
	end))
		
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(SOP.phaseTurnAround)
turnAroundProc:addItem(ProcedureItem:new("TURNAROUND","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
		getActiveSOP():reset()
		getActiveSOP():setActiveFlowIndex(2)
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

proc_ind_electrical 		= 1
proc_ind_beforeStart 		= 2
proc_ind_prePushStart 		= 3
proc_ind_engStart 			= 4
proc_ind_afterStart 		= 5
proc_ind_beforeTakeoff 		= 6
proc_ind_runwayEntry 		= 7
proc_ind_gearUp 			= 8
proc_ind_flapsUp 			= 9
proc_ind_afterTakeoff 		= 10
proc_ind_climbCheck 		= 11
proc_ind_descent 			= 12
proc_ind_landing 			= 13
proc_ind_flapsland			= 14
proc_ind_LandingCheck 		= 15
proc_ind_ap1off 			= 16
proc_ind_afterLandingProc	= 17
proc_ind_taxiLightOff 		= 18
proc_ind_shutdownProc 		= 19

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
activeSOP:addProcedure(LandingCheck)
activeSOP:addProcedure(ap1off)
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