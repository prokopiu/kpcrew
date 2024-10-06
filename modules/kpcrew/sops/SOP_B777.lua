-- Standard Operating Procedure for FF B777 v2

-- @classmod SOP_B777
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local SOP_B777 = {
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

activeSOP = kcSOP:new("FlightFactor B777v2 SOP")

-- =============== POWER UP / SAFETY CHECK ==============
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ===== Initial checks
-- DC Electric Power
-- CIRCUIT BREAKERS....................CHECK ALL IN (F/O)
-- BATTERY SWITCH...............ON AND GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH........................AUTO (F/O)
-- HYDRAULIC DEMAND PUMPS SWITCHES..............OFF (F/O)
-- WINDSHIELD WIPER SELECTORS...................OFF (F/O)
-- ALTERNATE FLAPS MASTER SWITCH.......GUARD CLOSED (F/O)
-- LANDING GEAR LEVER..........................DOWN (F/O)
-- FLAP LEVER..................................SET  (F/O)
--   Set the flap lever to agree with the flap position.
-- ==== Activate External Power
--   Use Ground Handling CDU menu to turn EXT Power on         
--   EXT POWER AVAILABLE LIGHTS.........ILLUMINATED (F/O)
--   EXT PWR 1 SWITCH............................ON (F/O)
-- ==== Activate APU 
--   APU......................................START (F/O)
--     Hold APU switch in START position for 3-4 seconds.
--   APU GEN OFF BUS LIGHT..............ILLUMINATED (F/O)
--   APU GENERATOR BUS 1 SWITCH..................ON (F/O)
--   APU BLEED AIR...............................ON (F/O)
-- ISOLATION VALVES............................OPEN (F/O)
-- PACK SWITCHES.............................NORMAL (F/O)
-- NAV LIGHTS....................................ON (F/O)

-- local electricalPowerUpProc = kcProcedure:new("POWER UP / SAFETY CHECK","powering up the aircraft")
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("All paper work on board and checked"))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("M E L and Technical Logbook checked"))

-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("== Initial Checks"))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== DC Electric Power"))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",kcFlowItem.actorFO,3,true))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","ON AND GUARD CLOSED",kcFlowItem.actorFO,2,
	-- function () return sysElectric.batteryCover:getStatus() == 0 and sysElectric.batterySwitch:getStatus() == 1 end,
	-- function () sysElectric.batterySwitch:actuate(1) sysElectric.batteryCover:actuate(0) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","AUTO",kcFlowItem.actorFO,2,
	-- function () return sysElectric.stbyPowerSwitch:getStatus() == 1 end,
	-- function () sysElectric.stbyPowerSwitch:setValue(1) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("HYDRAULIC DEMAND PUMP SWITCHES","OFF",kcFlowItem.actorFO,3,
	-- function () return sysHydraulic.demandPumpGroup:getStatus() == 0 end,
	-- function () sysHydraulic.demandPumpGroup:adjustValue(0,0,2) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("WINDSHIELD WIPERS","OFF",kcFlowItem.actorFO,2,
	-- function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	-- function () sysGeneral.wiperGroup:adjustValue(0,0,2) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","OFF",kcFlowItem.actorFO,3,
	-- function () return sysControls.altFlapsCtrl:getStatus() == 0 end,
	-- function () sysControls.altFlapsCtrl:setValue(0) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DOWN",kcFlowItem.actorFO,2,
	-- function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	-- function () sysGeneral.GearSwitch:actuate(modeOn) end))
-- electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("FLAP LEVER","SET CORRECTLY",kcFlowItem.actorFO,1,"initial_flap_lever",
	-- function () return get("laminar/B747/cablecontrols/flap_ratio") == 0 end))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))

-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate External Power",
	-- function () return activePrefSet:get("aircraft:powerup_apu") == true end))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use Ground Handling CDU menu to turn Ground Power on.",
	-- function () return activePrefSet:get("aircraft:powerup_apu") == true end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  #exchange|EXT|EXTERNAL# POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	-- function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,nil,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == true end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  EXTERNAL POWER 1 SWITCH","ON",kcFlowItem.actorFO,2,
	-- function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	-- function () sysElectric.extGen1Switch:actuate(modeOn) end,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == true end))

-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate APU",
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU#","START",kcFlowItem.actorFO,2,
	-- function () return sysElectric.apuRunningAnc:getStatus() == 1 end,
	-- function () sysElectric.apuStartSwitch:setValue(2) end,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 2 seconds",
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GENERATOR BUS 1 SWITCH","ON",kcFlowItem.actorFO,2,
	-- function () return sysElectric.apuOnBus:getStatus() == modeOn end,
	-- function () sysElectric.apuBus1:actuate(modeOn) end,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# BLEED AIR","ON",kcFlowItem.actorFO,2,
	-- function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	-- function () sysAir.apuBleedSwitch:actuate(modeOn) end,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))

-- electricalPowerUpProc:addItem(kcProcedureItem:new("ISOLATION VALVES","OPEN",kcFlowItem.actorFO,2,
	-- function () return sysAir.isoValveGroup:getStatus() == 2 end,
	-- function () sysAir.isoValveGroup:actuate(modeOn) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("PACK SWITCHES","NORMAL",kcFlowItem.actorFO,2,
	-- function () return sysAir.packSwitchGroup:getStatus() == 3 end,
	-- function () sysAir.packSwitchGroup:setValue(1) end))
-- electricalPowerUpProc:addItem(kcProcedureItem:new("NAV LIGHTS","ON",kcFlowItem.actorFO,2,
	-- function () return sysLights.positionSwitch:getStatus() == modeOn end,
	-- function () sysLights.positionSwitch:actuate(1) end))

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
	-- function () 
		-- if kc_procvar_get("toctest") == true then 
			-- kc_bck_b738_toc_test("toctest")
		-- end
	end))
	
-- ============ Cold & Dark =============
local coldAndDarkProc = kcProcedure:new("SET AIRCRAFT TO COLD & DARK")

-- coldAndDarkProc:addItem(kcProcedureItem:new("XPDR","SET 2000","F/O",1,

-- =========== States ===========
-- activeSOP:addState(turnAroundProc)
-- activeSOP:addState(coldAndDarkProc)
-- activeSOP:addState(recoverTakeoff)

-- ==== Background Flow ====
-- activeSOP:addBackground(backgroundFlow)

-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(electricalPowerUpProc)

function getActiveSOP()
	return activeSOP
end

return SOP_B777