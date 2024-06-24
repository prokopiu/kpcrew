-- Standard Operating Procedure for Laminar A330-300

-- @classmod SOP_A333
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local SOP_A333 = {
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

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Cockpit Prep", [3] = "Cockpit Prep", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = SOP:new("Laminar A333 SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("LIGHTS","ALL ON",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_lights_all_on()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","COLD&DARK",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_cold_dark()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","PREFLIGHT",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_preflight()
	  sysLights.domeLightSwitch:actuate(0)
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","BEFORE START",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_before_start()
	  
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","BEFORE TAXI",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_before_taxi()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","TAKEOFF",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_for_takeoff()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","CLMB 10K",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_climb_10k()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","DESC 10K",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_descend_10k()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","APPROACH",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_approach()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","CLEANUP",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_cleanup()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","ARRIVE PARKING",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_arrive_parking()
	end))
testProc:addItem(ProcedureItem:new("LIGHTS","SHUTDOWN",FlowItem.actorFO,5,true,
	function () 
	  kc_macro_lights_after_shutdown()
	end))

	


-- ============ PRELIMINARY COCKPIT PREP (PM) ============
-- ==== AIRCRAFT SETUP
-- ENGINE MASTERS 1 & 2.........................OFF   (PM)
-- ENGINE MODE SELECTOR........................NORM   (PM)
-- WEATHER RADAR................................OFF   (PM)
-- LANDING GEAR LEVER..........................DOWN   (PM)
-- BOTH WIPER SELECTORS.........................OFF   (PM)

-- ==== BATTERY CHECK & EXTERNAL POWER
-- BAT 1 / BAT 2............CHECK BOTH ABOVE 25.5 V   (PM)
-- BAT 1 / BAT 2.................................ON   (PM)

-- ==== Activate External Power
-- EXT POWER if available........................ON   (PM)
--   Use Ground Handling CDU menu to turn EXT Power on         

-- ==== Activate APU 
-- APU FIRE..........................IN and GUARDED   (PM)
-- APU FIRE TEST.........................CHECK/TEST   (PM)
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)

-- ==== LIGHT UP
-- COCKPIT LIGHTS...........................AS RQRD   (PM) 

-- ==== AIRCRAFT ACCEPTANCE
-- ECAM RCL...............................PRESS 3 S   (PM)
--   Recalls warnings cleared during last flight
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ==== ECAM SD PAGES
-- ENG SD PAGE.........................OIL QUANTITY   (PM)
--   NEO=10.6qt+0.45qt/h
-- HYD SD PAGE..........CHECK RESERVOIR FLUID LEVEL   (PM)
-- DOOR SD PAGE..................CHECK OXY PRESSURE   (PM)

-- ==== FCTL
-- FLAPS.............................CHECK POSITION   (PM)
--   ECAM flaps position agrees with handle position
-- SPEEDBRAKE LEVER......CHECK RETRACTED & DISARMED   (PM)

-- ==== BRAKES
-- PARKING BRAKE.................................ON   (PM)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (PM)
--   (if not use Y elec pump)
-- PARKING BRAKE INDICATOR....................CHECK   (PM)
-- Alternate Brake – Check:
--   YELLOW ELEC PUMP...........................OFF   (PM) 
--   CHOCKS......................................ON   (PM)
--   PARKING BRAKES.............................OFF   (PM)
--     Brake Pedals – Press to Check Pressure on 
--     Brake Pressure Indicator
--     Brake Pedals Release – Parking Brakes ON
--   PARKING BRAKES..............................ON   (PM)
  
-- ==== REST
-- EMERGENCY EQUIPMENT........................CHECK   (PM)
-- CB PANELS..................................CHECK   (PM)
-- RAIN REPELLENT.............................CHECK   (PM)
-- CIRCUIT BREAKERS..........................ALL IN   (PM)
-- GEAR PINS & COVERS............ONBOARD AND STOWED   (PM)
-- RMP2 (Radio Management Panel)...........ON & SET   (PF)
-- ACP2 (Audio Control Panel)...........AS REQUIRED   (PF)
-- =======================================================

local prelCockpitPrep = Procedure:new("PRELIMINARY COCKPIT PREPARATION","performing preliminary cockpit preparation","Setup finished")
prelCockpitPrep:setFlightPhase(2)
prelCockpitPrep:setResize(false)
prelCockpitPrep:addItem(SimpleProcedureItem:new("==== AIRCRAFT SETUP"))
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MASTERS 1 & 2","OFF",FlowItem.actorPM,1,
	function () return sysEngines.engStarterGroup:getStatus() == 0 end,
	function () sysEngines.engStarterGroup:actuate(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorPM,1,
	function () return sysEngines.engModeSelector:getStatus() == sysEngines.engModeNorm end,
	function () sysEngines.engModeSelector:setValue(sysEngines.engModeNorm) end))
prelCockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorPM,1,
	function () return sysGeneral.wxRadar:getStatus() == 0 end,
	function () sysGeneral.wxRadar:actuate(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorPM,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
prelCockpitPrep:addItem(ProcedureItem:new("BOTH WIPER SELECTORS","OFF",FlowItem.actorPM,1,
	function () return sysGeneral.wiperGroup:getStatus() == sysGeneral.wiperPosOff end,
	function () sysGeneral.wiperGroup:setValue(sysGeneral.wiperPosOff) end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== BATTERY CHECK & EXTERNAL POWER"))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","CHECK BOTH ABOVE 25.5 V",FlowItem.actorPM,1,
	function () return sysElectric.bat1Volt:getStatus() > 25.5 and sysElectric.bat2Volt:getStatus() > 25.5 end))
prelCockpitPrep:addItem(ProcedureItem:new("BAT 1 / BAT 2","ON",FlowItem.actorPM,1,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () sysElectric.batterySwitch:actuate(1) 
				sysElectric.battery2Switch:actuate(1) 
	end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","CONNECTED",FlowItem.actorPM,1,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
prelCockpitPrep:addItem(ProcedureItem:new("EXT POWER","ON",FlowItem.actorPM,1,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:setValue(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("APU FIRE","IN AND GUARDED",FlowItem.actorPM,1,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(IndirectProcedureItem:new("APU FIRE TEST","CHECK/TEST",FlowItem.actorPM,2,"apufiretest",
	function () return sysEngines.apuFireTest:getStatus() == 1 end,
	function () sysEngines.apuFireTest:setValue(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("APU MASTER PB","PRESS",FlowItem.actorPM,3,
	function () return sysElectric.apuMaster:getStatus() == 1 end,
	function () sysEngines.apuFireTest:setValue(0) sysElectric.apuMaster:setValue(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(SimpleProcedureItem:new("  After master switch, wait 3s",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
prelCockpitPrep:addItem(ProcedureItem:new("APU START PB","PRESS",FlowItem.actorPM,3,
	function () return sysElectric.apuStarter:getStatus() > 0 end,
	function () sysElectric.apuStarter:setValue(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== LIGHT UP"))
prelCockpitPrep:addItem(ProcedureItem:new("COCKPIT LIGHTS","AS REQUIRED",FlowItem.actorPM,1,true,
	function () 
		if kc_is_daylight() then		
			sysLights.instrLightGroup:actuate(0)
			sysLights.domeLightSwitch:actuate(0)
		else
			sysLights.instrLightGroup:actuate(0.5)
			sysLights.domeLightSwitch:actuate(1)
		end
	end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== AIRCRAFT ACCEPTANCE"))
prelCockpitPrep:addItem(ProcedureItem:new("ECAM RCL","PRESS 3 S",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(SimpleProcedureItem:new("   Recalls warnings cleared during last flight"))
prelCockpitPrep:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
prelCockpitPrep:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== ECAM SD PAGES"))
prelCockpitPrep:addItem(ProcedureItem:new("ENG SD PAGE","OIL QTY > 10.6 QT",FlowItem.actorPM,1,
	function () return sysEngines.oilqty1:getStatus() > 10 and sysEngines.oilqty2:getStatus() > 10 end,
	function () sysGeneral.ECAMMode:setValue(sysGeneral.ecamModeENG) end))
prelCockpitPrep:addItem(SimpleProcedureItem:new("  NEO=10.6qt+0.45qt/h"))
prelCockpitPrep:addItem(ProcedureItem:new("HYD SD PAGE","CHECK RESERVOIR FLUID LEVEL",FlowItem.actorPM,3,true,
	function () sysGeneral.ECAMMode:setValue(sysGeneral.ecamModeHYD) end))
prelCockpitPrep:addItem(ProcedureItem:new("DOOR SD PAGE","CHECK OXY PRESSURE",FlowItem.actorPM,3,true,
	function () sysGeneral.ECAMMode:setValue(sysGeneral.ecamModeDOOR) end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== FCTL"))
prelCockpitPrep:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorPM,1,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE","CHECK RETRACTED & DISARMED",FlowItem.actorPM,1,
	function () return sysControls.speedBrake:getStatus() == 0 end,
	function () sysControls.speedBrake:setValue(0) end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== BRAKES"))
prelCockpitPrep:addItem(ProcedureItem:new("CHOCKS","ON",FlowItem.actorPM,1,
	function () return sysGeneral.chocksGroup:getStatus() == 0 end,
	function () sysGeneral.chocksGroup:setValue(0) end))
prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKE","ON",FlowItem.actorPM,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
prelCockpitPrep:addItem(ProcedureItem:new("ACCU PRESS INDICATOR","CHECK GREEN BAND",FlowItem.actorPM,1,
	function () return sysHydraulic.accuPress:getStatus() > 3 end))
prelCockpitPrep:addItem(SimpleProcedureItem:new("  If not use Y elec pump"))
prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKE INDICATOR","CHECK",FlowItem.actorPM,1,
	function () return sysHydraulic.leftBrakePress:getStatus() > 1 and sysHydraulic.rightBrakePress:getStatus() > 1 end))
-- prelCockpitPrep:addItem(SimpleProcedureItem:new("  Alternate Brake – Check:"))
-- prelCockpitPrep:addItem(ProcedureItem:new("  YELLOW ELEC PUMP","OFF",FlowItem.actorPM,1,
	-- function () return sysHydraulic.yellowElecPumpSwitch:getStatus() == 0 end,
	-- function () sysHydraulic.yellowElecPumpSwitch:setValue(0) end))
-- prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKES","OFF",FlowItem.actorPM,1,
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	-- function () sysGeneral.parkBrakeSwitch:actuate(0) end))
-- prelCockpitPrep:addItem(SimpleProcedureItem:new("    Brake Pedals – Press to Check Pressure on "))
-- prelCockpitPrep:addItem(SimpleProcedureItem:new("    Brake Pressure Indicator"))
-- prelCockpitPrep:addItem(SimpleProcedureItem:new("    Brake Pedals Release – Parking Brakes ON"))
-- prelCockpitPrep:addItem(ProcedureItem:new("PARKING BRAKES","ON",FlowItem.actorPM,1,
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	-- function () sysGeneral.parkBrakeSwitch:actuate(1) end))

prelCockpitPrep:addItem(SimpleProcedureItem:new("==== REST"))
prelCockpitPrep:addItem(ProcedureItem:new("EMERGENCY EQUIPMENT","CHECK",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("CB PANELS","CHECK",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("RAIN REPELLENT","CHECK",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("CIRCUIT BREAKERS","ALL IN",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("GEAR PINS & COVERS","ONBOARD AND STOWED",FlowItem.actorPM,1,true,nil))
prelCockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANEL","ON AND SET",FlowItem.actorPM,1,
	function () return sysRadios.com2OnOff:getStatus() > 0 end,
	function () sysRadios.com2OnOff:setValue(1) end))
prelCockpitPrep:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","AS REQUIRED",FlowItem.actorPM,1,true,nil))

-- ================= COCKPIT PREPARATION =================
-- == Overhead Left Column
-- CREW OXY SUPPLY...............................ON   (PF)  
-- RCRD GND CTL..................................ON   (PF)  
-- CVR TEST.....................PRESS & HOLD 3 SECS   (PF)  
-- GPWS.............................NO WHITE LIGHTS   (PF)
-- EVAC SWITCH..........................CAPT & PURS   (PF)  
-- ADIRS L,R,C..................................NAV   (PF)
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.

-- == Overhead Center Column
-- ==== Lights panel
-- SEAT BELTS...................................OFF   (PF)
-- NO SMOKING...............................ON/AUTO   (PF)
-- EMERGENCY EXIT LIGHT.........................ARM   (PF)
-- ANNUNCIATOR LIGHT...........................TEST   (PF)

-- ==== ANTI-ICE & PRESSURIZATION
-- WING-ANTI-ICE................................OFF   (PF)
-- ENGINE ANTI-ICE..............................OFF   (PF)
-- PROBE/WINDOW HEAT.....................CHECK AUTO   (PF)
-- CABIN PRESSURE LDG ELEV.....................AUTO   (PF)
--   ECAM PRESS page check LDG ELEV being AUTO

-- ==== AIR COND Panel
-- APU BLEED............................AS REQUIRED   (PF)
-- CROSSBLEED..................................AUTO   (PF)
-- PACK FLOW SELECTOR.......................AS RQRD   (PF)

-- ==== Electrical Panel
-- NO WHITE LIGHTS..........................CHECKED   (PF)
-- BAT 1 PB & BAT 2 PB..................OFF then ON   (PF)
--   This initiates a charging cycle of the batts.
--   10 s after setting all BAT PB ON, check on the
--   ECAM ELEC page that the current charge of the
--   battery is below 60 A, and is decreasing.
-- 
-- ==== FUEL Panel
-- FUEL PUMP SWITCHES........................ALL ON   (PF)
-- FUEL MODE SELECTOR..........................AUTO   (PF)
--
-- ==== FIRE Panel
-- ENG 1 and 2 FIRE TEST.............PRESS and HOLD   (PF)
--   (check for 7 items)
-- APU FIRE..........................IN and GUARDED   (PF)
-- APU FIRE TEST..............................PRESS   (PF)
--
-- == Overhead Left Column
-- ==== CARGO Panel
-- AFT CARGO HEAT.........................MID RANGE   (PF)
-- CARGO SMOKE TEST............................PUSH   (PF)
-- ====
-- THIRD AUDIO CONTROL PANEL.......PA knob – Recept   (PF)
--   - This allows cabin attendant announcements to
--     be recorded on the CVR.
--   - Set volume at or above medium range.

-- == Central Panel
-- STANDBY INSTR (ISIS).......................CHECK   (PF)
--   Indications normal – no flags / Set QNH
-- CLOCK..................................CHECK/SET   (PF)
--   Check time is UTC, switch to GPS
-- A/SKID & N/W STRG SWITCH......................ON   (PF)

-- == Pedestal
-- RMP (Radio Management Panel)............ON & SET   (PF)
-- ACP (Audio Control Panel)............AS REQUIRED   (PF)
-- WEATHER RADAR................................OFF   (PF)
-- PWS..........................................OFF   (PF)
-- COCKPIT DOOR..............................NORMAL   (PF)
-- SWITCHING PANEL...........................NORMAL   (PF)
-- THRUST LEVERS.........................CHECK IDLE   (PF)
-- SPEED BRAKE LEVER...............RETRACT & DISARM   (PF)
-- PARK BRK HANDLE.........................CHECK ON   (PF)
-- GRAVITY GEAR EXTN.........................STOWED   (PF)
-- RMP2 (Radio Management Panel)...........ON & SET   (PF)
-- ACP2 (Audio Control Panel)...........AS REQUIRED   (PF)

-- ==== ATC / TCAS
--   XPDR CODE.................................2000   (PF)
--   SYSTEM 1...................................SET   (PF)
--   XPDR...................................STANDBY   (PF)
--   ALT REPORTING...............................ON   (PF)
-- =======================================================

local cockpitPrep = Procedure:new("COCKPIT PREPARATION","","")
cockpitPrep:setFlightPhase(3)
cockpitPrep:setResize(false)

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Left Column"))
cockpitPrep:addItem(ProcedureItem:new("CREW OXY SUPPLY","ON",FlowItem.actorPF,1,
	function () return sysGeneral.oxyCrewSupply:getStatus() == 0 end,
	function () sysGeneral.oxyCrewSupply:actuate(0) end))
cockpitPrep:addItem(ProcedureItem:new("PASSENGER OXYGEN","ON",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("RCRD GND CTL","ON",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("CVR TEST","PRESS & HOLD 3 SECS",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("GPWS","NO WHITE LIGHTS",FlowItem.actorPF,1,
	function () return sysGeneral.gpwsAnnunciators:getStatus() == 0 end))
cockpitPrep:addItem(ProcedureItem:new("EVAC SWITCH","CAPT & PURS",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("ADIRS L,R,C","NAV",FlowItem.actorPF,1,
	function () return sysGeneral.irsUnitGroup:getStatus() == 3 end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.adirsModeNAV) end))
cockpitPrep:addItem(SimpleProcedureItem:new("  Switch one at a time waiting for the BAT light"))
cockpitPrep:addItem(SimpleProcedureItem:new("  to go off before switching the next one on."))

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Center Column"))
cockpitPrep:addItem(SimpleProcedureItem:new("==== Lights panel"))
cockpitPrep:addItem(ProcedureItem:new("SEAT BELTS","OFF",FlowItem.actorPF,1,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("NO SMOKING","ON/AUTO",FlowItem.actorPF,1,
	function () return sysGeneral.noSmokingSwitch:getStatus() == 1 end,
	function () sysGeneral.noSmokingSwitch:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM",FlowItem.actorPF,1,
	function () return sysGeneral.emerExitLights:getStatus() == 1 end,
	function () sysGeneral.emerExitLights:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("ANNUNCIATOR LIGHT","TEST",FlowItem.actorPF,1,true,nil))

cockpitPrep:addItem(SimpleProcedureItem:new("==== ANTI-ICE & PRESSURIZATION"))
cockpitPrep:addItem(ProcedureItem:new("WING-ANTI-ICE","OFF",FlowItem.actorPF,1,
	function () return sysAice.wingAiceSwitch:getStatus() == 0 end,
	function () sysAice.wingAiceSwitch:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPF,1,
	function () return sysAice.engAiceGroup:getStatus() == 0 end,
	function () sysAice.engAiceGroup:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("PROBE/WINDOW HEAT","CHECK AUTO",FlowItem.actorPF,1,
	function () return sysAice.probeSwitch:getStatus() == 0 end,
	function () sysAice.probeSwitch:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("CABIN PRESSURE LDG ELEV","AUTO",FlowItem.actorPF,1,
	function () return sysAir.cabPressSwitch:getStatus() == 0 end,
	function () sysAir.cabPressSwitch:setValue(0) end))
cockpitPrep:addItem(SimpleProcedureItem:new("  ECAM PRESS page check LDG ELEV being AUTO"))

cockpitPrep:addItem(SimpleProcedureItem:new("==== AIR COND Panel"))
cockpitPrep:addItem(ProcedureItem:new("APU BLEED","OFF",FlowItem.actorPF,1,
	function () return sysAir.apuBleed:getStatus() == 0 end,
	function () sysAir.apuBleed:setValue(0) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
cockpitPrep:addItem(ProcedureItem:new("APU BLEED","ON",FlowItem.actorPF,1,
	function () return sysAir.apuBleed:getStatus() == 1 end,
	function () sysAir.apuBleed:setValue(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrep:addItem(ProcedureItem:new("CROSSBLEED","AUTO",FlowItem.actorPF,1,
	function () return sysAir.crossBleed:getStatus() == 1 end,
	function () sysAir.crossBleed:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("HI FLOW SELECTOR","OFF",FlowItem.actorPF,1,
	function () return sysAir.highFlow:getStatus() == 0 end,
	function () sysAir.highFlow:setValue(0) end))


cockpitPrep:addItem(SimpleProcedureItem:new("==== Electrical Panel"))
cockpitPrep:addItem(ProcedureItem:new("NO WHITE LIGHTS","CHECKED",FlowItem.actorPF,1,
	function () return sysElectric.elecWhiteLights:getStatus() == 0 end))
cockpitPrep:addItem(SimpleProcedureItem:new("BAT 1 PB & BAT 2 PB..................OFF then ON"))
cockpitPrep:addItem(SimpleProcedureItem:new("   This initiates a charging cycle of the batts."))
cockpitPrep:addItem(SimpleProcedureItem:new("   10 s after setting all BAT PB ON, check on the"))
cockpitPrep:addItem(SimpleProcedureItem:new("   ECAM ELEC page that the current charge of the"))
cockpitPrep:addItem(SimpleProcedureItem:new("   battery is below 60 A, and is decreasing."))

cockpitPrep:addItem(SimpleProcedureItem:new("==== FUEL Panel"))
cockpitPrep:addItem(ProcedureItem:new("FUEL PUMP SWITCHES","ALL ON",FlowItem.actorPF,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 6 end,
	function () sysFuel.fuelPumpGroup:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("FUEL MODE SELECTOR","AUTO",FlowItem.actorPF,1,
	function () return sysFuel.fuelMode:getStatus() == 0 end,
	function () sysFuel.fuelMode:setValue(0) end))

cockpitPrep:addItem(SimpleProcedureItem:new("==== FIRE Panel"))
cockpitPrep:addItem(IndirectProcedureItem:new("ENG 1 FIRE TEST","PRESS AND HOLD",FlowItem.actorPF,6,"eng1firetest",
	function () return sysEngines.eng1FireTest:getStatus() == 1 end,
	function () sysEngines.eng1FireTest:setValue(1) end))
cockpitPrep:addItem(IndirectProcedureItem:new("ENG 2 FIRE TEST","PRESS AND HOLD",FlowItem.actorPF,6,"eng2firetest",
	function () return sysEngines.eng2FireTest:getStatus() == 1 end,
	function () sysEngines.eng1FireTest:setValue(0) sysEngines.eng2FireTest:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("APU FIRE","IN AND GUARDED",FlowItem.actorPF,1,true,
	function () sysEngines.eng2FireTest:setValue(0) end))
cockpitPrep:addItem(IndirectProcedureItem:new("APU FIRE TEST","PRESS",FlowItem.actorPF,6,"apufiretest",
	function () return sysEngines.eng2FireTest:getStatus() == 1 end,
	function () sysEngines.apuFireTest:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("FIRE TEST","FINISHED",FlowItem.actorPF,1,true,
	function () sysEngines.apuFireTest:setValue(0) end))

cockpitPrep:addItem(SimpleProcedureItem:new("== Overhead Left Column"))
cockpitPrep:addItem(SimpleProcedureItem:new("==== CARGO Panel"))
cockpitPrep:addItem(ProcedureItem:new("AFT CARGO HEAT","MID RANGE",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("CARGO SMOKE TEST","PUSH",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(SimpleProcedureItem:new("==== Audio & Radio"))
cockpitPrep:addItem(ProcedureItem:new("THIRD AUDIO CONTROL PANEL","PA KNOB – RECEPT",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(SimpleProcedureItem:new("  - This allows cabin attendant announcements to"))
cockpitPrep:addItem(SimpleProcedureItem:new("    be recorded on the CVR."))
cockpitPrep:addItem(SimpleProcedureItem:new("  - Set volume at or above medium range."))

cockpitPrep:addItem(SimpleProcedureItem:new("== Central Panel"))
cockpitPrep:addItem(ProcedureItem:new("STANDBY INSTR (ISIS)","CHECK",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(SimpleProcedureItem:new("  Indications normal – no flags / Set QNH"))
cockpitPrep:addItem(ProcedureItem:new("CLOCK","CHECK/SET","CHECK",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(SimpleProcedureItem:new("  Check time is UTC, switch to GPS"))
cockpitPrep:addItem(ProcedureItem:new("A/SKID & N/W STRG SWITCH","ON",FlowItem.actorPF,1,
	function () return sysGeneral.antiSkid:getStatus() == 1 end,
	function () sysGeneral.antiSkid:setValue(1) end))

cockpitPrep:addItem(SimpleProcedureItem:new("== Pedestal"))
cockpitPrep:addItem(ProcedureItem:new("RADIO MANAGEMENT PANEL","ON AND SET",FlowItem.actorPF,1,
	function () return sysRadios.com1OnOff:getStatus() > 0 end,
	function () sysRadios.com1OnOff:setValue(1) end))
cockpitPrep:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","AS REQUIRED",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorPF,1,
	function () return sysGeneral.wxRadar:getStatus() == 0 end,
	function () sysGeneral.wxRadar:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("PWS","OFF",FlowItem.actorPF,1,true,nil))
cockpitPrep:addItem(ProcedureItem:new("COCKPIT DOOR","NORMAL",FlowItem.actorPF,1,
	function () return sysGeneral.cockpitLock:getStatus() == 0 end,
	function () sysGeneral.cockpitLock:setValue(0) sysGeneral.cockpitDoor:setValue(1) end))
-- SWITCHING PANEL...........................NORMAL   (PF)
cockpitPrep:addItem(ProcedureItem:new("THRUST LEVERS","CHECK IDLE",FlowItem.actorPF,1,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end))
cockpitPrep:addItem(ProcedureItem:new("SPEED BRAKE","RETRACT & DISARM",FlowItem.actorPF,1,
	function () return sysControls.speedBrake:getStatus() == 0 end,
	function () sysControls.speedBrake:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("PARK BRAKE HANDLE","CHECK ON",FlowItem.actorPF,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
cockpitPrep:addItem(ProcedureItem:new("GRAVITY GEAR EXTN","STOWED",FlowItem.actorPF,1,true,nil))

cockpitPrep:addItem(SimpleProcedureItem:new("==== ATC / TCAS"))
cockpitPrep:addItem(ProcedureItem:new("XPDR CODE","2000",FlowItem.actorPF,1,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () sysRadios.xpdrCode:setValue(2000) end))
cockpitPrep:addItem(ProcedureItem:new("SYSTEM 1","SET",FlowItem.actorPF,1,
	function () return sysRadios.systemSelector:getStatus() == 0 end,
	function () sysRadios.systemSelector:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("XPDR","STANDBY",FlowItem.actorPF,1,
	function () return sysRadios.xpdrMode:getStatus() == 0 end,
	function () sysRadios.xpdrMode:setValue(0) end))
cockpitPrep:addItem(ProcedureItem:new("ALT REPORTING","ON",FlowItem.actorPF,1,
	function () return sysRadios.xpdrAltRpt:getStatus() == 1 end,
	function () sysRadios.xpdrAltRpt:setValue(1) end))

-- FMGC SETUP PROCEDURE
-- D-I-F-R-I-P+P-S

-- =========== FINAL COCKPIT PREPARATION (F/O) ===========
-- ==== EFIS Panel
-- QNH ON EFIS..................................SET (BOTH)
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTORS..............................ON (BOTH)
-- ILS/LS.......................................OFF (BOTH)
-- NAVIGATION DISPLAY MODE & RANGE..............SET (BOTH)
-- ADF/VOR SWITCHES.............................VOR (BOTH)
-- CSTR..........................................ON (BOTH)

-- ==== FCU for Departure
-- FMGC.................................INITIALIZED   (PF)
-- SPD MACH WINDOW...........................DASHED   (PF)
--   100 displayed until Perf page is completed
-- HDG WINDOW................................DASHED   (PF)
-- ALT WINDOW...................INITIAL CLEARED ALT   (PF)
-- V/S WINDOW................................DASHED   (PF)

-- ==== Cockpit
-- OXYGEN MASK.................................TEST (BOTH)
-- LOUDSPEAKERS VOLUME...........................ON (BOTH)
-- SLIDING WINDOWS..................CLOSED & LOCKED (BOTH)
-- PFD & ND BRIGHTNESS......................AS RQRD (BOTH)
--   PFD / ND indications CHECK NORMAL

-- ==== Pedestal
-- RMP (Radio Management Panel)............ON & SET (BOTH)
-- ACP..................................AS REQUIRED (BOTH)
-- TRANSPONDER.................................STBY (BOTH)
-- =======================================================

local finalCockpitPrep = Procedure:new("FINAL COCKPIT PREPARATION","","ready for cockpit preparation checklist")
finalCockpitPrep:setFlightPhase(3)

finalCockpitPrep:addItem(SimpleProcedureItem:new("==== EFIS Panel"))
-- finalCockpitPrep:addItem(ProcedureItem:new("QNH ON EFIS","SET",FlowItem.actorBOTH,1,
	-- function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		-- get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	-- function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				-- set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))

-- ==== EFIS Panel
-- QNH ON EFIS..................................SET (BOTH)
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTORS..............................ON (BOTH)
-- ILS/LS.......................................OFF (BOTH)
-- NAVIGATION DISPLAY MODE & RANGE..............SET (BOTH)
-- ADF/VOR SWITCHES.............................VOR (BOTH)
-- CSTR..........................................ON (BOTH)


-- =========== DEPARTURE BRIEFING ========
-- == AIRCRAFT
	-- FMS
	-- ➢ DATA Page
		-- ▪ Type and Model
		-- ▪ APD & Nav Database Date
	-- ➢ FMS INIT- B Pag
		-- ▪ Block Fuel (FOB on EWD)
		-- ▪ Estimated TOW
		-- ▪ Extra Time / Fuel at Destination
	-- ➢ PERF TAKEOFF Pag
		-- ▪ TO RWY
		-- ▪ TO CONF
		-- ▪ Flex / TOGA
		-- ▪ V1, VR, V2
		-- ▪ Transition Altitude
		-- ▪ Thrust Reduction / ACC Altitude
	-- ➢ F-PLN & PROG Page
		-- ▪ Route Waypoints
		-- ▪ Time, Distance and Fuel
		-- ▪ Strategy in secondary flight plan
-- == WEATHER
	-- • Weather reports and applicable procedures
	-- • Applicable NOTAMS and procedures
-- == STARTUP & TAXI
	-- • ATC Procedures (push and start procedures)
	-- • A/C Procedures (engine start etc.)
	-- • Routing to the anticipated runway
-- == RUNWAY
	-- • Dimensions (Length, Width, Stopway)
	-- • Surface Condition
	-- • Lighting
	-- • Packs / Anti ice – On/Off Takeoff
-- == DEPARTURE
	-- • Normal SID – Routing and Constraints
	-- • Engine Out SID – Routing and Constraint
	-- • Navigation Frequencies to be used (RAD NAV)
	-- • MSA
-- == SPECIAL PROCEDURES
	-- • NADP
	-- • Weather
	-- • Terrain
	-- • Failures (Communication etc.)

-- == Emergency Briefing
-- This will be a left hand seat takeoff.
-- Failure Before 100 Knots or V1
	-- • For any failure before 100 knots or V1, clearly CALL OUT THE MALFUNCTION and I will call STOP or GO.
	-- • If the call is STOP, I will apply the REJECTED TAKEOFF PROCEDURE and bring the aeroplane to a complete stop.
	-- • I will set the PARKING BRAKE and call “ATTENTION CREW AT STATION”.
	-- • You will monitor REV GREEN and DECEL and silence any AURAL WARNING and inform ATC.
	-- • Thereafter you will carry out ECAM actions on my command.
	-- • IF EVACUATION is required, we will carry out the “Emergency Evacuation Checklist”.
	
-- Failure After V1
	-- • For any failure after V1, takeoff will be continued and NO ACTION BEFORE 400 feet AGL EXCEPT silencing of any AURAL WARNING and GEAR UP.
	-- • Reaching 400 feet AGL, ECAM actions on my command.
	-- • For engine failure / damage / fire, when ENGINE IS SECURED: Stop ECAM, level off, accelerate and cleanup.
	-- • If ENGINE IS NOT SECURED: Continue climbing until engine is secured, but not above EO maximum acceleration altitude.
	-- • At GREEN DOT OPEN CLB, select MCT.
	-- • Resume ECAM, complete AFTER T/O C/L and check the STATUS.
	-- • FLY (a) EO Routing (b) SID (c) Radar Vectors (c) Immediate Turn Back.

-- REJECTED TAKEOFF: 
	-- Before 100 knots (Less serious. Abort is at Captain’s discretion depending on the circumstances)
	-- Any ECAM Warning / Caution. 
	-- Between 100 knots & V1 (More Serious. Be go minded except for a few situations, as mentioned below)
	-- Failures with ECAM
		-- Left Hand Items
			-- Side Stick Fault
		-- Right Hand Items
			-- Thrust Lever Fault
		-- Engine Items
			-- Fire
			-- Failure
			-- Reverser Unlocked or Fault.
	-- Failures without ECAM
		-- Sudden loss of thrust.
		-- Any major failure.
		-- If aeroplane is unsafe to fly due any reason.
		-- Tire failure within 20 knots of V1: Unless debris from tire causes noticeable engine parameter fluctuation, takeoff, reduce fuel load & land with full RWY length available.
	-- Weather
		-- Windshear.
	-- Note: Exceeding EGT red line or nose gear vibration should not result in an abort above 100 knots *

-- ============ COCKPIT PREPARATION CHECKLIST ============
-- GEAR PINS & COVERS.......................REMOVED   (PF)
-- FUEL QUANTITY............................ ___ KG   (PF)
--   check FOB & distribution on FUEL SD page
-- SEAT BELT.....................................ON   (PF)
-- ADIRS........................................NAV   (PF)
-- BARO REF....................................____ (BOTH)
-- =======================================================

local cockpitPrepChkl = Checklist:new("COCKPIT PREPARATION CHECKLIST","","COCKPIT PREPARATION CHECKLIST completed")
cockpitPrepChkl:setFlightPhase(3)
cockpitPrepChkl:addItem(ChecklistItem:new("GEAR PINS & COVERS","REMOVED",FlowItem.actorPF,1,true,nil))
cockpitPrepChkl:addItem(ChecklistItem:new("FUEL QUANTITY","____KG",FlowItem.actorPF,1,true,nil))
cockpitPrepChkl:addItem(SimpleChecklistItem:new("  check FOB & distribution on FUEL SD page"))
cockpitPrepChkl:addItem(ChecklistItem:new("SEAT BELT","ON",FlowItem.actorPF,1,true,nil))
cockpitPrepChkl:addItem(ChecklistItem:new("ADIRS","NAV",FlowItem.actorPF,1,true,nil))
cockpitPrepChkl:addItem(ChecklistItem:new("BARO REF","____",FlowItem.actorBOTH,1,true,nil))


-- ========= BEFORE PUSHBACK AND START CLEARANCE =========
-- SEAT POSITION.............................ADJUST (BOTH)
-- FUEL......CROSS CHECK (ECAM FOB & FPL/LOADSHEET)   (PF)
-- LOAD SHEET........................CHECK / REVISE (BOTH)
-- FMS T/O DATA..............................REVISE (BOTH)
-- MCDU............................FMS PERF TO PAGE   (PF)
-- MCDU..............................FMS F-PLN PAGE   (PM)
-- EXTERNAL POWER........................DISCONNECT   (PM)
-- PUSH / START CLEARANCE....................OBTAIN   (PM)
-- BEACON........................................ON   (PF)
-- ATC TRANSPONDER..................SET AS REQUIRED   (PM)
-- WINDOWS / DOORS...................CHECKED CLOSED (BOTH)
-- THRUST LEVERS...............................IDLE   (PF)
-- ACCU PRESSURE INDICATOR....................CHECK   (PF)
--   TAKEOFF CG/TRIM POS..check and set (BOTH)

-- APU START NOW and GPU disconnected
-- =======================================================


local beforePushStart = Procedure:new("FINAL COCKPIT PREPARATION","","ready for cockpit preparation checklist")
beforePushStart:setFlightPhase(4)
beforePushStart:addItem(ProcedureItem:new("SEAT POSITION","ADJUST",FlowItem.actorBOTH,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("FUEL","CROSS CHECK (ECAM FOB & FPL/LOADSHEET)",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("LOAD SHEET","CHECK / REVISE",FlowItem.actorBOTH,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("FMS T/O DATA","REVISE",FlowItem.actorBOTH,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("MCDU","FMS PERF TO PAGE",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("MCDU","FMS F-PLN PAGE",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("EXTERNAL POWER","DISCONNECT",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("PUSH / START CLEARANCE","OBTAIN",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("BEACON","ON",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("ATC TRANSPONDER","SET AS REQUIRED",FlowItem.actorPM,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("WINDOWS / DOORS","CHECKED CLOSED",FlowItem.actorBOTH,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(ProcedureItem:new("ACCU PRESSURE INDICATOR","CHECK",FlowItem.actorPF,1,true,nil))
beforePushStart:addItem(SimpleProcedureItem:new("  TAKEOFF CG/TRIM POS..check and set (BOTH)"))
beforePushStart:addItem(SimpleProcedureItem:new("  APU START NOW and GPU disconnected"))


-- =============== BEFORE START CHECKLIST ================
-- PARKING BRAKE.................................ON   (PF)
-- T.O. SPEEDS & THRUST......................._____ (BOTH)
--   PF V1,VR,V2 & thrust setting FMS PERF
-- WINDOWS...................................CLOSED (BOTH)
-- BEACON........................................ON   (PF)
-- =======================================================

local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST","","BEFORE START CHECKLIST completed")
beforeStartChkl:setFlightPhase(4)
beforeStartChkl:addItem(ChecklistItem:new("PARKING BRAKE","ON",FlowItem.actorPF,1,true,nil))
beforeStartChkl:addItem(ChecklistItem:new("T.O. SPEEDS & THRUST","____",FlowItem.actorBOTH,1,true,nil))
beforeStartChkl:addItem(SimpleChecklistItem:new("  PF V1,VR,V2 & thrust setting FMS PERF"))
beforeStartChkl:addItem(ChecklistItem:new("WINDOWS","CLOSED",FlowItem.actorBOTH,1,true,nil))
beforeStartChkl:addItem(ChecklistItem:new("BEACON","ON",FlowItem.actorPF,1,true,nil))

-- =============== PUSHBACK & ENGINE START ===============
-- PARKING BRAKE................................SET   (PF)
-- PUSHBACK SERVICE..........................ENGAGE   (PF)
--   Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH   (PF)
-- == AUTOMATIC START
-- THRUST LEVERS...............................IDLE   (PF)
-- ENGINE MODE SELECTOR.................IGN / START   (PF)
-- PARKING BRAKE...........................RELEASED   (PF)
-- START FIRST ENGINE.............STARTING ENGINE _   (PF)
--   ENGINE MASTER SWITCH........................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- START SECOND ENGINE............STARTING ENGINE _   (PF)
--   ENGINE MASTER SWITCH........................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- PARKING BRAKE................................SET   (PM)
--   When instructed by ground crew after pushback/towing
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY   (PF)
--   LOCKOUT PIN REMOVED.....................VERIFY   (PF)
-- =======================================================

-- beforePushStart:addItem(ProcedureItem:new("","",FlowItem.actorPF,1,true,nil))
-- beforePushStart:addItem(SimpleProcedureItem:new(""))


-- ===================== AFTER START =====================
-- ENGINE MODE SELECTOR......................NORMAL   (PF)
-- APU BLEED....................................OFF   (PF)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PF)
-- WING ANTI-ICE........................AS REQUIRED   (PF)
-- APU MASTER SWITCH............................OFF   (PF)
-- GROUND SPOILERS..............................ARM   (PM)
-- RUDDER TRIM.................................ZERO   (PM)
-- FLAPS...........................TAKEOFF POSITION   (PM)
-- PITCH TRIM HANDWHEEL.........................SET   (PM)
-- STATUS REMINDER..............CHECK NOT DISPLAYED   (PF)
-- N/W STEER DISC MEMO..........CHECK NOT DISPLAYED   (PF)
-- GROUND CREW.........ANNOUNCE CLEAR TO DISCONNECT   (PF)
-- GROUND CREW.....ANNOUNCE HAND SIGNAL ON LEFT/RGT   (PF)
-- =======================================================


-- ================= AFTER START CHECKLIST ===============
-- ANTI ICE.............................AS REQUIRED   (PF)
-- ECAM STATUS..............................CHECKED   (PF)
-- PITCH TRIM................................_% SET   (PF)
-- RUDDER TRIM..............................NEUTRAL   (PF)
-- =======================================================

local afterStartChkl = Checklist:new("AFTER START CHECKLIST","","AFTER START CHECKLIST completed")
afterStartChkl:setFlightPhase(5)
afterStartChkl:addItem(ChecklistItem:new("ANTI ICE","AS REQUIRED",FlowItem.actorPF,1,true,nil))
afterStartChkl:addItem(ChecklistItem:new("ECAM STATUS","CHECKED",FlowItem.actorPF,1,true,nil))
afterStartChkl:addItem(ChecklistItem:new("PITCH TRIM","_% SET",FlowItem.actorPF,1,true,nil))
afterStartChkl:addItem(ChecklistItem:new("RUDDER TRIM","NEUTRAL",FlowItem.actorPF,1,true,nil))

-- ================= BEFORE TAXI PROCEDURE ===============
-- == PRE-REQ
-- FLIGHT CONTROLS............................CHECK (BOTH)
--   Flight Controls Before or During Taxi 
-- TAXI CLEARANCE............................OBTAIN   (PM)
-- TAXI / TURN OFF LIGHT.........................ON   (PF)
-- AREA CLEARANCE...........“CLEAR LEFT/RIGHT SIDE” (BOTH)
-- PARKING BRAKE..........OFF – BRAKE PRESSURE ZERO   (PF)
-- BRAKE PEDALS.........PRESS & CALL: “BRAKE CHECK”   (PF)
-- == CLEARANCE
-- ATC CLEARANCE............................CONFIRM   (PM)
-- FLIGHT DIRECTORS.........................BOTH ON   (PM)
-- == DO ITEMS
-- AUTO BRAKES......................AUTO BRK MAX ON   (PM) 
-- ATC CODE/MODE........................CONFIRM/SET   (PM) 
-- ENGINE MODE SELECTOR.................AS REQUIRED   (PM) 
-- WEATHER RADAR.............................ON/ALL   (PF)
-- PREDICTIVE WINDSHEAR.....................AUTO/ON   (PM) 
-- TERRAIN ON ND........................AS REQUIRED   (PM) 
-- FINAL CHECK TO CONFIG.......................TEST   (PM) 
-- FINAL CHECK TO MEMO................CHECK NO BLUE   (PM)
-- “CABIN SECURED FOR TAKEOFF”
-- =======================================================


-- ==================== TAXI CHECKLIST ===================
-- FLIGHT CONTROLS..........................CHECKED (BOTH)
-- FLAP SETTINGS...........................CONF ___ (BOTH)
-- RADAR & PRED W/S.......................ON & AUTO   (PF)
-- ENG MODE.................IGNITION|NORM (on A320)   (PF)
-- START SEL................IGNITION|NORM (on A340)   (PF)
-- ECAM MEMO.............................TO NO BLUE   (PF)
--   - AUTO BRK MAX
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS TO
--   - TO CONFIG NORM
-- =======================================================

local taxiChkl = Checklist:new("TAXI CHECKLIST","","TAXI CHECKLIST completed")
taxiChkl:setFlightPhase(6)
taxiChkl:addItem(ChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("FLAP SETTINGS","CONF ___",FlowItem.actorBOTH,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("RADAR & PRED W/S","ON & AUTO",FlowItem.actorPF,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("ENG MODE","IGNITION|NORM",FlowItem.actorPF,1,true,nil))
-- taxiChkl:addItem(ChecklistItem:new("START SEL","",FlowItem.actorPF,1,true,nil))
taxiChkl:addItem(ChecklistItem:new("ECAM MEMO","TO - NO BLUE",FlowItem.actorPF,1,true,nil))
taxiChkl:addItem(SimpleChecklistItem:new("  - AUTO BRK MAX"))
taxiChkl:addItem(SimpleChecklistItem:new("  - SIGNS ON"))
taxiChkl:addItem(SimpleChecklistItem:new("  - CABIN READY"))
taxiChkl:addItem(SimpleChecklistItem:new("  - SPLRS ARM"))
taxiChkl:addItem(SimpleChecklistItem:new("  - FLAPS TO"))
taxiChkl:addItem(SimpleChecklistItem:new("  - TO CONFIG NORM"))

-- =============== BEFORE TAKEOFF PROCEDURE ==============
-- BRAKE FANS.................................CHECK   (PM)
-- LINEUP CLEARANCE..........................OBTAIN   (PM)
-- TCAS.................................TA OR TA/RA   (PM)
-- TAKEOFF RUNWAY...........................CONFIRM (BOTH)
-- APPROACH PATH...................CLEAR OF TRAFFIC (BOTH)
-- EXTERIOR LIGHTS......................STROBE – ON   (PF)
-- PACKS................................AS REQUIRED   (PM)
-- SLIDING TABLE.............................STOWED (BOTH)
-- CABIN CREW................................ADVISE   (PM)
-- =======================================================

-- =================== LINE-UP CHECKLIST =================
-- T.O RWY......................................___ (BOTH)
-- TCAS.......................................TA/RA   (PM)
-- PACK 1 & 2......................____ AS REQUIRED   (PM)
-- =======================================================

local lineUpChkl = Checklist:new("LINE-UP CHECKLIST","","line up CHECKLIST completed")
lineUpChkl:setFlightPhase(7)
lineUpChkl:addItem(ChecklistItem:new("T.O. RUNWAY","____",FlowItem.actorBOTH,1,true,nil))
lineUpChkl:addItem(ChecklistItem:new("TCAS","TA/RA",FlowItem.actorPM,1,true,nil))
lineUpChkl:addItem(ChecklistItem:new("PACK 1 & 2","__ AS REQUIRED",FlowItem.actorPM,1,true,nil))

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ============
-- TAKEOFF CLEARANCE........................OBTAIN   (PM)
--   Weather around departure path
--   Terrain around departure path
--   Fuel check before takeoff
-- FCU.................................AS REQUIRED   (PF)
-- == Exterior Lights
-- NOSE LIGHT...................................ON   (PF)
-- TURN OFF LIGHTS..............................ON   (PF)
-- LAND LIGHTS..................................ON   (PF)
-- == Thrust Setting
-- ANNOUNCE..............................“TAKEOFF”   (PF)
--   STANDARD TAKEOFF
--     • Thrust – N1 50% (1.05 EPR)
--     • Brakes – Release
--     • Thrust – FLX / TOGA
--     • Sidestick – ½ FWD up to 80, Neutral by 100
-- CHRONO.....................................START   (PM)
-- == Below 80 Knots
-- TAKEOFF N1(EPR)............................CHECK   (PM)
-- ANNOUNCE............................“THRUST SET”   (PM)
-- ANNOUNCE...............................100 KNOTS   (PM)
-- AT V1 & VR..............ANNOUNCE “V1” & “ROTATE”   (PM)
-- POSITIVE CLIMB......................GT 40 FT AGL   (PM)
-- LANDING GEAR..................................UP   (PM)
-- == Thrust Reduction Altitude (>xxxft)
-- THRUST LEVERS..........................CL DETENT   (PF)
-- PACKS.........................................ON   (PM)
-- == Acceleration Altitude (> xxxxft)
--   Check Target Speed – Monitor FMA
-- AP1...........................................ON   (PF)
-- F SPEED..................................REACHED
-- FLAPS 1......................................SET   (PM)
-- S SPEED..................................REACHED
-- FLAPS 0......................................SET   (PM)
-- SPOILERS..................................DISARM   (PM)
-- EXT LIGHTS...................................SET   (PM)
-- TCAS.....................................TA / RA   (PM)
-- ENGINE MODE..........................AS REQUIRED   (PM)
-- == APU 
--   BLEED SWITCH.......................AS REQUIRED   (PM)
--   MASTER SWITCH......................AS REQUIRED   (PM)
-- == Anti-Ice 
--   ENGINE ANTI-ICE....................AS REQUIRED   (PM)
--   WING ANTI-ICE......................AS REQUIRED   (PM)
-- MCDU.......................PF=PERF CLB, PM=F-PLN (BOTH)
-- Whatever comes first
-- TRANSITION ALTITUDE.............ANNOUNCE REACHED   (PM)
-- ALTIMETERS...................................STD (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...........................RETRACT   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF   (PM)
-- BELTS SWITCH.................................OFF   (PM)
-- EFIS.......................PF=CSTR/ARPT, PM=ARPT (BOTH)
-- TILT/TERRAIN........PF=WX ON, PF=TERR OFF, WX=ON (BOTH)
-- =======================================================

-- ================== DESCENT PREPARATION ================
-- == Planning
--   Weather & Landing Info 1 – Check pm
--   ECAM Status – Check pm 
--   Nav Charts – Prepare both
--   Landing Conditions – Confirm 2 both
--   Landing Performance – Compute & Cross Check 3 both
--   AUTO BRK – AS REQ 4 pf
--   No Full Flaps – Select GPWS LDG FLAP 3 pm
-- == Preparation (PF)
--   • F-PLN A (DES WINDS / ARRIVAL) 5
--   • RAD NAV
--   • PROG (BRG / DIST TO RWY)
--   • PERF:
--     o CRUISE (cabin descent rate)
--     o DES (Mach / Speed)
--     o APPR:
--       ▪ QNH
--       ▪ Temperature
--       ▪ Destination Wind 6
--       ▪ Minimum
--       ▪ Landing CONF
--     o GO-AROUND:
--       ▪ Thrust reduction
--       ▪ Acceleration altitude
--   • FUEL PREDICTION
--   • SEC F-PLN (Alternate Runway etc.)
--   • Landing Elevation – Mode & Value
-- == Arrival Briefing (PF)
-- == Descent Clearance Obtained by PM
--   ALTITUDE WINDOW..SET CLEARED ALTITUDE pf
--   TCAS..SET PM
-- =======================================================

-- =================== ARRIVAL BRIEFING ==================
-- == AIRCRAFT 
--   Technical Status
-- == AIRFIELD (DEST & ALT)
--   Weather
--   Terminal information – NOTAMS etc.
--   Fuel – Extra Holding
-- == STAR
--   • NAV Frequencies
--   • Routing and Constraints
--   • Transition Level
--   • MSA
-- == APPRPOACH
--   • NAV Frequencies
--   • Approach and Minima
--   • Transition Level
--   • MSA
--   • Obstacles
--   • Restricted / Prohibited areas
-- == GOAROUND
--   • ATC Procedure
--   • Aircraft Procedure
-- == RUNWAY
--   Dimensions (Length, Width, Distance beyond G/S)
--   Surface Condition
--   Lighting
-- ==TAXI
--   Routing and Parking
-- == SPECIAL PROCEDURES
--   Weather (Circumnavigation etc.)
--   Terrain
--   Failures (Communication, MEL etc.)
-- =======================================================

-- ================= DESCENT PROCEDURE ==================
-- MCDU..PF=PROG / PERF DES, PM=F-PLN (BOTH)
-- == Speeds
--   Managed – If Not then:
--     o 0.78 / 300 till FL100
--     o 250 below FL100
-- == Tilt / Terrain
--   Tilt – Adjust WX Radar PF
--   Terrain ON ND 3 PM
-- Whatever comes first
-- TRANSITION LEVEL................ANNOUNCE REACHED   (PM)
-- ALTIMETERS...............................QNH SET (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................SET   (PM)
-- SEAT BELTS............................ON   (PM)
-- EFIS.......................CSTR (BOTH)
-- LS...AS REQUIRED (BOTH)
-- RAD / NAV..SELECTED & IDENTIFIED PM
-- ENG MODE.. AS REQUIRED (PM)
-- =======================================================


-- ================== APPROACH CHECKLIST =================
-- BARO REF....................................____ (BOTH)
-- SEAT BELTS....................................ON   (PM)
-- MINIMUM.....................................____   (PF)
-- AUTO BRAKE..................................____   (PF)
-- ENG MODE SEL................................____   (PF)
-- =======================================================

local approachChkl = Checklist:new("APPROACH CHECKLIST","","approach CHECKLIST completed")
approachChkl:setFlightPhase(12)
approachChkl:addItem(ChecklistItem:new("BARO REF","____",FlowItem.actorBOTH,1,true,nil))
approachChkl:addItem(ChecklistItem:new("SEAT BELTS","ON",FlowItem.actorPM,1,true,nil))
approachChkl:addItem(ChecklistItem:new("MINIMUM","____",FlowItem.actorPF,1,true,nil))
approachChkl:addItem(ChecklistItem:new("AUTO BRAKE","____",FlowItem.actorPF,1,true,nil))
approachChkl:addItem(ChecklistItem:new("ENG MODE SEL","____",FlowItem.actorPF,1,true,nil))

-- =============== LANDING PROCEDURE (PM) ================
-- LANDING LIGHTS................................ON   (PF)
-- APPROACH PHASE..........................ACTIVATE   (PF)
-- 3NM FROM FDP OR S-SPEED..................REACHED
-- FLAPS 1......................................SET   (PM)
-- 2000 FT AGL..............................REACHED
-- FLAPS 2......................................SET   (PM)
-- LANDING GEAR................................DOWN   (PM)
-- AUTO BRAKE...........................SET/CONFIRM   (PM)
-- RWY TURNOFF LIGHTS............................ON   (PM)
-- NODE LIGHTS...................................ON   (PM)
-- GROUND SPOILERS..............................ARM   (PM)
-- FLAPS 3......................................SET   (PM)
-- ECAM WHEEL PAGE............................CHECK   (PM)
-- GO AROUND ALTITUDE.......................... SET   (PM)
-- FLAPS FULL...................................SET   (PM)
-- LANDING MEMO.......................CHECK NO BLUE
-- CABIN REPORT.............................RECEIVE
-- A/THR..........................SPEED MODE OR OFF
-- WING ANTI-ICE................................OFF
-- =======================================================

-- ================== LANDING CHECKLIST ==================
-- ECAM MEMO..........................LDG - NO BLUE   (PM)
--   - LDG GEAR DN
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS SET
-- =======================================================

local landingChkl = Checklist:new("LANDING CHECKLIST","","landing CHECKLIST completed")
landingChkl:setFlightPhase(14)
landingChkl:addItem(ChecklistItem:new("ECAM MEMO","LDG - NO BLUE",FlowItem.actorPM,1,true,nil))
landingChkl:addItem(SimpleChecklistItem:new("  - LDG GEAR DN"))
landingChkl:addItem(SimpleChecklistItem:new("  - SIGNS ON"))
landingChkl:addItem(SimpleChecklistItem:new("  - CABIN READY"))
landingChkl:addItem(SimpleChecklistItem:new("  - SPLRS ARM"))
landingChkl:addItem(SimpleChecklistItem:new("  - FLAPS SET"))

-- ============== AFTER LANDING PROCEDURE ================
-- GROUND SPOILERS...........................DISARM   (PF)
-- STROBES......................................OFF   (PF)
-- LANDING LIGHTS...............................OFF   (PF)
-- TAXI LIGHTS...................................ON   (PF)
-- CHRONO & ET.................................STOP  (CPT)
-- RADAR........................................OFF
-- PWS..........................................OFF
-- ENGINE MODE SELECTOR........................NORM
-- FLAPS....................................RETRACT
-- TCAS.....................................STANDBY
-- ATC..................................AS REQUIRED
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)
-- ENGINE ANTI-ICE......................AS REQUIRED
-- WING ANTI-ICE........................AS REQUIRED
-- BRAKE TEMPERATURE..........................CHECK
-- =======================================================

-- =============== AFTER LANDING CHECKLIST ===============
-- RADAR & PRED W/S.............................OFF   (PM)
-- =======================================================

local afterLandingChkl = Checklist:new("AFTER LANDING CHECKLIST","","after landing CHECKLIST completed")
afterLandingChkl:setFlightPhase(15)
afterLandingChkl:addItem(ChecklistItem:new("RADAR & PRED W/S","OFF",FlowItem.actorPM,1,true,nil))

-- ================== PARKING PROCEDURE ==================
-- TAXI LIGHT SWITCH............................OFF   (PF) 
-- == Parked at Gate
--   ACCU PRESSURE............................CHECK   (PF)
--   PARKING BRAKES..............................ON   (PF)
--   BRAKE PRESSURE INDICATOR.................CHECK   (PF)
--   ENGINE ANTI-ICE............................OFF   (PM)
--   WING ANTI-ICE..............................OFF   (PM)
--   ELECTRIC POWER:
--     IF APU AVAILABLE – APU BLEED..............ON   (PM)
--     IF EXT PWR AVAIL – EXT PWR................ON   (PM)
-- ENGINE MASTER SWITCHES.......................OFF   (PF) 
-- == MISC. Do Items
--   WING LIGHTS................................OFF   (PF)
--   BEACON.....................................OFF   (PF)
--   SEAT BELTS.................................OFF   (PF)
--   FUEL PUMPS.................................OFF   (PM)
--   ATC....................................STANDBY   (PM)
--   BRAKE FAN..................................OFF   (PM)
-- == Ground Contact
--   PARKING BRAKE......................AS REQUIRED   (PF)
--   CHOCKS................................IN PLACE   (PF)
-- =======================================================


-- ================== PARKING CHECKLIST ==================
-- PARK BRK OR CHOCKS...........................SET   (PF)
-- ENGINES......................................OFF   (PF)
-- WING LIGHTS..................................OFF   (PF)
-- FUEL PUMPS...................................OFF   (PF)
-- =======================================================

local parkingChkl = Checklist:new("PARKING CHECKLIST","","parking CHECKLIST completed")
parkingChkl:setFlightPhase(17)
parkingChkl:addItem(ChecklistItem:new("PARK BRK OR CHOCKS","SET",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("ENGINES","OFF",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("WING LIGHTS","OFF",FlowItem.actorPF,1,true,nil))
parkingChkl:addItem(ChecklistItem:new("FUEL PUMPS","OFF",FlowItem.actorPF,1,true,nil))

-- =========== SECURING THE AIRCRAFT PROCEDURE ===========
-- PARKING BRAKE...........................CHECK ON   (PF)
-- ADIRS..................ALL IR MODE SELECTORS OFF   (PF)
-- OXYGEN CREW SUPPLY...........................OFF   (PM)
-- EXTERIOR LIGHTS..............................OFF   (PM)
-- MAINTENANCE BUS......................AS REQUIRED   (PM)
-- APU..................BLEED AND MASTER SWITCH OFF   (PM)
-- EMERGENCY EXIT LIGHTS AND SIGNS..............OFF   (PM)
-- EXTERNAL POWER.......................AS REQUIRED   (PM)
-- BATTERY................................1 & 2 OFF   (PM)
-- =======================================================



-- =========== SECURING THE AIRCRAFT CHECKLIST ===========
-- OXYGEN.......................................OFF   (PM)
-- EMER EXIT LIGHT..............................OFF   (PM)
-- EFB..........................................OFF   (PM)
-- BATTERIES....................................OFF   (PM)
-- =======================================================

local securingChkl = Checklist:new("SECURING THE AIRCRAFT CHECKLIST","","securing the aircraft CHECKLIST completed")
securingChkl:setFlightPhase(1)
securingChkl:addItem(ChecklistItem:new("OXYGEN","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("EFB","OFF",FlowItem.actorPM,1,true,nil))
securingChkl:addItem(ChecklistItem:new("BATTERIES","OFF",FlowItem.actorPM,1,true,nil))

-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(prelCockpitPrep)
-- activeSOP:addProcedure(cockpitPrep)
-- activeSOP:addProcedure(finalCockpitPrep)
-- activeSOP:addProcedure(cockpitPrepChkl)
-- activeSOP:addProcedure(beforePushStart)
-- activeSOP:addProcedure(beforeStartChkl)
-- activeSOP:addProcedure(afterStartChkl)
-- activeSOP:addProcedure(lineUpChkl)
-- activeSOP:addProcedure(approachChkl)
-- activeSOP:addProcedure(landingChkl)
-- activeSOP:addProcedure(afterLandingChkl)
-- activeSOP:addProcedure(securingChkl)

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
		getActiveSOP():setActiveFlowIndex(1)
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

activeSOP:addProcedure(testProc)
activeSOP:addProcedure(prelCockpitPrep)

-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

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

return SOP_A333

