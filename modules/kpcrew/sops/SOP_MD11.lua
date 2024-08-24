-- Base SOP for Rotate MD-11

-- @classmod SOP_MD11
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local SOP_MD11 = {
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

activeSOP = SOP:new("Rotate MD-11 SOP")

local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(0)
-- testProc:addItem(ProcedureItem:new("MCP","C&D",FlowItem.actorFO,5,false,
	-- function () 
	  -- kc_macro_mcp_cold_dark()
	-- end))

-- ============== COCKPIT ENTRY & POWER UP ===============

-- === Cockpit Entry
-- All paper work on board and checked
-- M E L and Technical Logbook checked
-- CIRCUIT BREAKERS.....................CHECK ALL IN (F/O)
-- WX RADAR SYS SWITCH...........................OFF (F/O)
-- FUEL SWITCHES.................................OFF (F/O)
-- PARKING BRAKE..................................ON (F/O)
-- SPOILER HANDLE.....................RETRACT DETEND (F/O)
-- FLAPS / SLAT HANDLE............................UP (F/O)
-- GEAR HANDLE..................................DOWN (F/O)
-- FUEL DUMP SWITCHES.............GUARDED & SAFETIED (F/O)
-- MANF DRAIN SWITCH.........................GUARDED (F/O)
-- EMER PWR SELECTOR.............................OFF (F/O)
-- 
-- === Power Up
-- BATTERY SWITCH..................ON & GUARD CLOSED (F/O)
-- EXTERNAL ELECTRICAL POWER...............AVAILABLE (F/O)
-- EXT PWR......................................PUSH (F/O)
-- EXT PWR ON LIGHT................CHECK ILLUMINATED (F/O)
--
-- If APU Power used
--   ENG/APU FIRE TEST..........................PUSH (F/O)
--   ALL ENG FIRE HANDLE LIGHTS..........ILLUMINATED (F/O)
--   APU FIRE HANDLE.....................ILLUMINATED (F/O)
--   APU PWR SWITCH.............................PUSH (F/O)
--   APU PWR ON LIGHT.......................BLINKING (F/O)
--   APU PWR ON LIGHT............STEADY WHEN STARTED (F/O)
--   APU AIR......................................ON (F/O)
-- AC & DC OFF LIGHTS...................EXTINGUISHED (F/O)
-- GEN ARM LIGHTS........................ILLUMINATED (F/O)
-- ALL BUS OFF LIGHTS...................EXTINGUISHED (F/O)
-- =======================================================	

-- #########
-- sw_checklist:COCKPIT ENTRY & POWER UP:COCKPIT ENTRY & POWER UP
-- #########
-- sw_itemvoid:::::::::::::::: Cockpit Entry ::
-- sw_itemvoid:All paper work on board and checked
-- sw_itemvoid:M E L and Technical Logbook checked
-- sw_item_c:\white\CIRCUIT BREAKERS|CHECK ALL IN:1:1
-- sw_item_c:\white\WX RADAR SYS SWITCH|OFF:Rotate/aircraft/controls/wx_sys:1
-- sw_item_c:\white\ENGINE FUEL SWITCHES|OFF:(Rotate/aircraft/controls/eng_fuel_1:0)&&(Rotate/aircraft/controls/eng_fuel_2:0)&&(Rotate/aircraft/controls/eng_fuel_3:0)
-- sw_item_c:\white\PARKING BRAKE|ON:Rotate/aircraft/controls/park_brake:1
-- sw_item_c:\white\SPOILER HANDLE|RETRACT DETEND:Rotate/aircraft/controls/speed_brake:0
-- sw_item_c:\white\FLAPS/SLAT HANDLE|UP & RETRACTED:Rotate/aircraft/controls/flap_handle:0
-- sw_item_c:\white\GEAR HANDLE|DOWN:Rotate/aircraft/controls/gear_handle:1
-- sw_item_c:\white\FUEL DUMP SWITCH|GUARDED:Rotate/aircraft/controls/fuel_dump_stop_grd:0
-- sw_item_c:\white\MANF DRAIN SWITCH|GUARDED:Rotate/aircraft/controls/fuel_manif_drain_grd:0
-- sw_item_c:\white\EMER PWR SELECTOR|OFF:Rotate/aircraft/controls/emer_pwr:0
-- sw_itemvoid:::::::::::::::: Power Up ::
-- sw_item_c:\white\BATTERY SWITCH|ON & GUARD CLOSED:(Rotate/aircraft/systems/batt_sw_action:1)&&(Rotate/aircraft/controls/battery_grd:0)
-- sw_item_c:\white\EXTERNAL ELECTRICAL POWER|AVAILABLE:Rotate/aircraft/systems/elec_ext_avail:1
-- sw_item_c:\white\EXT PWR|PUSH:Rotate/aircraft/systems/elec_ext_pwr_on_lt:1
-- sw_itemvoid:If APU power used
-- sw_item_c:\white\  ENG/APU FIRE TEST|PUSH AND HOLD:Rotate/aircraft/controls/apu_fire_test:>0
-- sw_item_c:\white\  ALL ENG FIRE HANDLE LIGHTS|ILLUMINATED:(Rotate/aircraft/systems/fire_eng_1_alert_lt:1) && (Rotate/aircraft/systems/fire_eng_2_alert_lt:1) && (Rotate/aircraft/systems/fire_eng_3_alert_lt:1)
-- sw_item_c:\white\  APU FIRE HANDLE LIGHT|ILLUMINATED:Rotate/aircraft/systems/fire_apu_alert_lt:>0
-- sw_item_c:\white\  APU PWR SWITCH|PUSHRotate/aircraft/systems/elec_apu_on_lt:>0
-- sw_itemvoid:  .. APU PWR ON light blinking
-- sw_item_c:\white\  APU POWER|AVAILABLE:Rotate/aircraft/systems/elec_apu_avail:2
-- sw_item_c:\white\APU AIR|ON:Rotate/aircraft/systems/air_apu_on_lt:>0
-- sw_item_c:\white\AC & DC OFF LIGHTS|EXTINGUISHED:(Rotate/aircraft/systems/elec_dc_1_off_lt:0) && (Rotate/aircraft/systems/elec_dc_2_off_lt:0) && (Rotate/aircraft/systems/elec_dc_3_off_lt:0) && (Rotate/aircraft/systems/elec_emer_dc_l_off_lt:0) && (Rotate/aircraft/systems/elec_emer_dc_r_off_lt:0) && (Rotate/aircraft/systems/elec_dc_gs_off_lt:0)
-- sw_item_c:\white\GEN ARM LIGHTS|ILLUMINATED:(Rotate/aircraft/systems/elec_gen2_lt:1) && (Rotate/aircraft/systems/elec_gen1_lt:1) && (Rotate/aircraft/systems/elec_gen3_lt:1)
-- sw_item_c:\white\ALL BUS OFF LIGHTS|EXTINGUISHED:(Rotate/aircraft/systems/elec_ac_1_off_lt:0) && (Rotate/aircraft/systems/elec_ac_2_off_lt:0) && (Rotate/aircraft/systems/elec_ac_3_off_lt:0)

local cockpitEntryPowerUp = Procedure:new("COCKPIT ENTRY & POWER UP")
cockpitEntryPowerUp:setFlightPhase(1)

cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("=== Cockpit Entry"))
cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))
cockpitEntryPowerUp:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
cockpitEntryPowerUp:addItem(ProcedureItem:new("WX RADAR SYS SWITCH","OFF",FlowItem.actorFO,1,
	function () return sysGeneral.wxSystemSwitch:getStatus() == 1 end,
	function () sysGeneral.wxSystemSwitch:setValue(1) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("ENGINE FUEL SWITCHES","OFF",FlowItem.actorFO,1,
	function () return sysFuel.fuelLeverGroup:getStatus() == 0 end,
	function () sysFuel.fuelLeverGroup:actuate(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("PARKING BRAKE","ON",FlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("SPOILER HANDLE","RETRACT DETEND",FlowItem.actorFO,1,
	function () return sysControls.speedBrake:getStatus() == 0 end,
	function () sysControls.speedBrake:actuate(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("FLAPS/SLAT HANDLE","UP",FlowItem.actorFO,1,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("GEAR HANDLE","DOWN",FlowItem.actorFO,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("FUEL DUMP SWITCH","GUARDED",FlowItem.actorFO,1,
	function () return sysFuel.fuelDumpGuard:getStatus() == 0 end,
	function () sysFuel.fuelDumpGuard:actuate(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("MANF DRAIN SWITCH","GUARDED",FlowItem.actorFO,1,
	function () return sysFuel.manifoldDrainGuard:getStatus() == 0 end,
	function () sysFuel.manifoldDrainGuard:actuate(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("EMER PWR SELECTOR","OFF",FlowItem.actorFO,1,
	function () return sysElectric.emerPwrSelector:getStatus() == 0 end,
	function () sysElectric.emerPwrSelector:actuate(0) end))

cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("=== Power Up"))
cockpitEntryPowerUp:addItem(ProcedureItem:new("BATTERY SWITCH","ON & GUARD CLOSED",FlowItem.actorFO,7,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.batteryGuard:getStatus() == 0 end,
	function () sysElectric.batterySwitch:actuate(1) sysElectric.batteryGuard:actuate(0) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("EXTERNAL ELECTRICAL POWER","AVAILABLE",FlowItem.actorFO,7,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,
	function () sysElectric.GPU:actuate(1) end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("EXT PWR","PUSH",FlowItem.actorFO,1,
	function () return sysElectric.extPWRSwitch:getStatus() == 1 end,
	function () sysElectric.extPWRSwitch:actuate(1)  end))
cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("If APU power used:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(IndirectProcedureItem:new("  ENG/APU FIRE TEST","PUSH AND HOLD",FlowItem.actorFO,13,"eng_ext_test_1",
	function () return get("Rotate/aircraft/controls/apu_fire_test") > 0 end,
	function () command_begin("Rotate/aircraft/controls_c/apu_fire_test") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(IndirectProcedureItem:new("  ALL ENG FIRE HANDLE LIGHTS","ILLUMINATED",FlowItem.actorFO,1,"eng_ext_test_2",
	function () return sysEngines.engFireLights:getStatus() > 0 end,
	function () command_end("Rotate/aircraft/controls_c/apu_fire_test") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(IndirectProcedureItem:new("  APU FIRE HANDLE LIGHT","ILLUMINATED",FlowItem.actorFO,1,"apu_fire_test",
	function () return sysEngines.apuFireLight:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("  APU PWR SWITCH","PUSH",FlowItem.actorFO,1,
	function () return sysElectric.apuPwrSwitch:getStatus() > 0 end,
	function () sysElectric.apuPwrSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(SimpleProcedureItem:new("  APU PWR ON light blinking:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("  APU POWER","AVAILABLE",FlowItem.actorFO,1,
	function () return get("Rotate/aircraft/systems/elec_apu_avail") == 2 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("APU AIR","ON",FlowItem.actorFO,1,
	function () return sysAir.apuAir:getStatus() == 1 end,
	function () sysAir.apuAir:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

cockpitEntryPowerUp:addItem(ProcedureItem:new("AC, DC OFF LIGHTS","EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysElectric.dcOffLights:getStatus() == 0 and sysElectric.acOffLights:getStatus() == 0 end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("GEN ARM LIGHTS","ILLUMINATED",FlowItem.actorFO,1,
	function () return sysElectric.genArmLights:getStatus() > 0 end))
cockpitEntryPowerUp:addItem(ProcedureItem:new("ALL BUS OFF LIGHTS","EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysElectric.acTies:getStatus() == 0 and sysElectric.dcTies:getStatus() == 0 end))
	
	
	
-- cockpitEntryPowerUp:addItem(ProcedureItem:new("TRIM AIR OFF ANNUNCIATOR","EXTINGUISHED",FlowItem.actorFO,1,
	-- function () return sysAir.trimAirAnc:getStatus() == 0 end))
-- cockpitEntryPowerUp:addItem(IndirectProcedureItem:new("ANNUN LT TEST","PERFORM",FlowItem.actorFO,1,"internal_lights_test",
	-- function () return sysGeneral.ancLightTest:getStatus() > 0 end))
-- cockpitEntryPowerUp:addItem(ProcedureItem:new("IRS NAV 1 SWITCH","ON",FlowItem.actorFO,1,
	-- function () return sysGeneral.irsUnit1Switch:getStatus() == 1 end,
	-- function () sysGeneral.irsUnit1Switch:actuate(modeOn) end))
-- cockpitEntryPowerUp:addItem(ProcedureItem:new("IRS NAV 2 SWITCH","ON",FlowItem.actorFO,1,
	-- function () return sysGeneral.irsUnit2Switch:getStatus() == 1 end,
	-- function () sysGeneral.irsUnit2Switch:actuate(modeOn) end))
-- cockpitEntryPowerUp:addItem(ProcedureItem:new("IRS NAV AUX SWITCH","ON",FlowItem.actorFO,1,
	-- function () return sysGeneral.irsUnit3Switch:getStatus() == 1 end,
	-- function () sysGeneral.irsUnit3Switch:actuate(modeOn) end))
-- cockpitEntryPowerUp:addItem(IndirectProcedureItem:new("CARGO FIRE TEST","STARTED WITH IRS NAV",FlowItem.actorFO,1,"cargo_fire_test",
	-- function () return sysGeneral.cargoFireTestAnc:getStatus() > 0 end))

-- ======== COCKPIT PREPARATION PROCEDURE 1 (F/O) ========
-- TRIM AIR OFF ANNUNCIATOR.............EXTINGUISHED (F/O)
-- ANNUN LT TEST.............................PERFORM (F/O)
-- IRS NAV 1 SWITCH..............................NAV (F/O)
-- IRS NAV 2 SWITCH..............................NAV (F/O)
-- IRS NAV AUX SWITCH............................NAV (F/O)
-- CARGO FIRE TEST..............STARTED WITH IRS NAV (F/O)


-- ======== COCKPIT PREPARATION PROCEDURE 2 (F/O) ========
-- VOICE RECODER................................TEST (F/O)
-- ENG IGN OFF LIGHT.....................ILLUMINATED (F/O)
-- Before performing HYD PRESS TEST contact ground crew
-- HYD PRESS TEST...............................PUSH (F/O)
-- ENG GEN DRIVE SWITCHES....................GUARDED (F/O)
-- EMER PWR SELECTOR.............................ARM (F/O)
-- EMER PWR ON LIGHT.............................OFF (F/O)
-- AIR MASKS SWITCH..........................GUARDED (F/O)
-- ALL FUEL PUMPS................................OFF (F/O)
-- EMER EXIT LIGHT SWITCH........................ARM (F/O)
-- NO SMOKE SIGNS.................................ON (F/O)
-- SEAT BELTS SIGNS...............................ON (F/O)
-- Exterior Lights
-- LANDING LIGHTS..........................RETRACTED (F/O)
-- NOSE LIGHTS...................................OFF (F/O)
-- RWY LIGHTS....................................OFF (F/O)
-- NAV LIGHTS....................................OFF (F/O)
-- LOGO LIGHTS...........................AS REQUIRED (F/O)
-- BEACON LIGHTS.................................OFF (F/O)
-- H-INT LIGHTS..................................OFF (F/O)

-- GPWS TEST - PUSH

-- All ANTI-ICE and DEFROG lights extinguished

-- Glareshield
-- IN/HP, BAROSET QNH, set baro pressure
-- MINIMUMS CTRL KNOB - RA
-- HDG READOUT - MAG
-- slelect nd mode as desired
-- IAS/MACH set to 250
-- HDG/TRACK dispalys actual aircreaft heading
-- Bank angle selector AUTO
-- AFS OVRD - OFF
-- ALT - 10000

-- OXYGEN Systems
-- TEST 

-- EIS SOURCE selector  - 2
-- STATIC AIR - NORM
-- check displays powered and on
-- check CLOCK
-- scan through displays horse shoe
-- standby altimeter etc check and set
-- takeoff warning move throttle
-- check STATUS page
-- set audio control panel
-- rudder aileron trim
-- ADG Release handle down and safe
-- ship papers - check


-- == captains cockpit prep

-- == Final cockpit prep (BOTH)

-- local cockpitEntryPowerUp2 = kcProcedure:new("COCKPIT PREPARATION PROCEDURE 2 (F/O)")
-- cockpitEntryPowerUp2:addItem(IndirectProcedureItem:new("VOICE RECODER","TEST",FlowItem.actorFO,1,"voice_recorder_test",
	-- function () return sysGeneral.vrcTest:getStatus() > 0 end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("ENG IGN OFF LIGHT","ILLUMINATED",FlowItem.actorFO,1,
	-- function () return sysEngines.engIgnOffLight:getStatus() > 0 end))
-- cockpitEntryPowerUp2:addItem(SimpleProcedureItem:new("Before performing HYD PRESS TEST contact ground crew"))
-- cockpitEntryPowerUp2:addItem(IndirectProcedureItem:new("HYD PRESS TEST","PUSH",FlowItem.actorFO,1,"hyd_press_test",
	-- function () return sysHydraulic.hydTestSwitch:getStatus() > 0 end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("ENG GEN DRIVE SWITCHES","GUARDED",FlowItem.actorFO,1,
	-- function () return sysElectric.engDriveGuards:getStatus() == 0 end,
	-- function () sysElectric.engDriveGuards:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("EMER PWR SELECTOR","ARM",FlowItem.actorFO,1,
	-- function () return sysElectric.emerPwrSelector:getStatus() == 1 end,
	-- function () sysElectric.emerPwrSelector:actuate(modeOn) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("EMER PWR ON LIGHT","OFF",FlowItem.actorFO,1,
	-- function () return sysElectric.emerPwrOnLight:getStatus() == 0 end))
-- cockpitEntryPowerUp2:addItem(SimpleProcedureItem:new("  PWR ON light will estinguish after 15 sec"))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("AIR MASKS SWITCH","GUARDED",FlowItem.actorFO,1,
	-- function () return sysAir.maskGuard:getStatus() == 0 end,
	-- function () sysAir.maskGuard:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("ALL FUEL PUMPS","OFF",FlowItem.actorFO,1,
	-- function () return sysFuel.fuelPumpGroup:getStatus() == 3 end,nil,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == true end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("FUEL PUMPS 1 & 3","OFF",FlowItem.actorFO,1,
	-- function () return sysFuel.fuelPumpGroup:getStatus() == 2 end,nil,
	-- function () return activePrefSet:get("aircraft:powerup_apu") == false end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("EMER EXIT LIGHT SWITCH","ARM",FlowItem.actorFO,1,
	-- function () return sysGeneral.emerExitSwitch:getStatus() == 1 end,
	-- function () sysGeneral.emerExitSwitch:setValue(1) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("NO SMOKE SIGNS","ON",FlowItem.actorFO,1,
	-- function () return sysGeneral.noSmokeSigns:getStatus() == 2 end,
	-- function () sysGeneral.noSmokeSigns:setValue(2) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("SEAT BELTS SIGNS","AUTO",FlowItem.actorFO,1,
	-- function () return sysGeneral.seatBeltSigns:getStatus() == 1 end,
	-- function () sysGeneral.seatBeltSigns:setValue(1) end))
-- cockpitEntryPowerUp2:addItem(SimpleProcedureItem:new("Exterior Lights"))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("LANDING LIGHTS","RETRACTED",FlowItem.actorFO,1,
	-- function () return sysLights.landLightGroup:getStatus() == 0 end,
	-- function () sysLights.landLightGroup:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("NOSE LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.taxiSwitch:getStatus() == 0 end,
	-- function () sysLights.taxiSwitch:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("RWY LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	-- function () sysLights.rwyLightGroup:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("NAV LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.positionSwitch:getStatus() == 0 end,
	-- function () sysLights.positionSwitch:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("LOGO LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.logoSwitch:getStatus() == 0 end,
	-- function () sysLights.logoSwitch:actuate(modeOff) end,
	-- function () return kc_is_daylight() == false end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("LOGO LIGHTS","ON",FlowItem.actorFO,1,
	-- function () return sysLights.logoSwitch:getStatus() == 1 end,
	-- function () sysLights.logoSwitch:actuate(modeOn) end,
	-- function () return kc_is_daylight() == true end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("BEACON LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.beaconSwitch:getStatus() == 0 end,
	-- function () sysLights.beaconSwitch:actuate(modeOff) end))
-- cockpitEntryPowerUp2:addItem(ProcedureItem:new("H-INT LIGHTS","OFF",FlowItem.actorFO,1,
	-- function () return sysLights.strobesSwitch:getStatus() == 0 end,
	-- function () sysLights.strobesSwitch:actuate(modeOff) end))

-- BEFORE START Checklist
 -- Aircraft log C Reviewed
 -- Fuel quantity F
 -- C
 -- ________
 -- Released with _____
 -- *Oxygen CF
 -- IRS C
 -- Altimeters CF ________
 -- Status page C Checked
 -- *Takeoff warning C Checked
 -- *Radar C Checked
 -- _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
 -- >Custom forms F On board (if req)
 -- Aux pump C On
 -- Parking brake C Set/Released
 -- Windows CF Closed & locked
 -- Doors C Closed
 -- Beacon C On
 -- Ignition C A/B
 -- Fuel Manual F 1, 2, 3 pumps On
 -- F L/R aux trans Off
 -- F Tail tnk trans Off


 -- AFTER START Checklist
 -- Anti-ice C Off/On
 -- >APU/APU Air F Off
 -- Hyd Manual F Aux pumps Off
 -- F 1, 2, 3 L pumps Off
 -- F 1, 2, 3 R pumps Ck Off


 -- BEFORE TAKEOFF
 -- Flaps F
 -- C
 -- ________
 -- Checked
 -- Spoilers F Armed
 -- Flight controls CF Checked
 -- Trim F
 -- C
 -- Zero, Zero, ______
 -- Checked
 -- Briefing C Complete
 -- >Seat belts ALL Fastened
 -- _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
 -- Hyd Manual F 1-3, 2-3 RPMs On
 -- V Speeds CF Checked
 -- Radar C Off/On
 -- EAD CF Checked
 -- FCP C ____ , ____
 -- >Lights F On

 -- AFTER TAKEOFF
 -- >Gear PM Up & lights out
 -- >Flaps & slats PM Up & retracted
 -- >Spoilers PM Disarmed
 -- >Auto brakes PM Off/Not installed
 -- >Flap T. O. sel PM 15/0 deg Stop
 -- >EAD PM Checked
 -- Hyd Manual PM 1-3, 2-3 RMPs Off
 -- Fuel Manual PM L/R aux trans Off/On
 -- PM Tail tnk trans Off/On
 -- PM Fill valves Off/Arm
 -- PM Tnk 2 trans Off/On
 -- _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
 -- Altimeters CF ______

-- IN RANGE
 -- Altimeters CF _______
 -- >Windshld anti-ice PM On
 -- >Seat belt sign PM On
 -- >Wing&Rwy lights PM On
 -- >Status page PM Checked
 -- >Seat belts ALL Fastened
 -- Hyd Manual PM 1-3, 2-3 RMPs On
 -- Fuel Manual PM L/R aux trans Off
 -- PM Tail tnk trans Off

 -- APPROACH
 -- Briefing C Complete
 -- Altimeters CF _______
 -- Minimums CF _______RA/BARO
 -- Navaids PM Checked

 -- BEFORE LANDING
 -- >Lights PM As required
 -- Spoilers PM
 -- PF
 -- Armed
 -- Checked
 -- Autobrakes PM _____/Not installed
 -- Gear PM
 -- PF
 -- Down, In, $/3 Green
 -- Checked
 -- Flaps PM
 -- PF
 -- _______
 -- Checked

-- AFTER LANDING
 -- >APU F Off/On
 -- >Lights F As required
 -- >Stab trim F 3/2 deg ANU
 -- >Flaps & slats F Up & retracted
 -- >Autobrakes F Off/Not installed
 -- >Spoilers F Retracted
 -- >Radar F Off
 -- >Oxygen F Checked

-- SHUT DOWN
 -- >IRS C Off
 -- >Emergency pwr C Off
 -- >Anti-ice C Off
 -- >Windshld anti-ice C Off
 -- >Defog C Off
 -- >Ignition override C Off
 -- >Emergency lights C Off
 -- >Seat belt sign C Off
 -- >Beacon C Off
 -- >Fuel levers C Off
 -- >Status page C Off
 -- >Hyd Manual C 1-3, 2-3 RMPs
 -- >Fuel Manual C 1, 2, 3 Pumps Off
 -- >Debrief C Complete/Deferred

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		if activePrefSet:get("general:sges") == true then
			kc_macro_start_sges_sequence()
		end
		getActiveSOP():setActiveFlowIndex(1)
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		-- kc_macro_state_turnaround()
		-- if activePrefSet:get("general:sges") == true then
			-- kc_macro_start_sges_sequence()
		-- end
	end))
turnAroundProc:addItem(ProcedureItem:new("GPU","ON BUS","SYS",0,true,
	function () 
		-- command_once("laminar/B738/toggle_switch/gpu_dn")
		-- electricalPowerUpProc:setState(Flow.FINISH)
		-- prelPreflightProc:setState(Flow.FINISH)
		-- getActiveSOP():setActiveFlowIndex(3)
	end))

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

-- kc_procvar_initialize_bool("toctest", false) -- B738 takeoff config test

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		-- if kc_procvar_get("toctest") == true then 
			-- kc_bck_b738_toc_test("toctest")
		-- end
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(cockpitEntryPowerUp)

-- =========== States ===========
-- activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

function getActiveSOP()
	return activeSOP
end

-- reset actuators - special "feature" in the MD-11
function reset_actuators()
	if get("Rotate/aircraft/controls/fgs_hdg_mode_sel") == -1 then
		set("Rotate/aircraft/controls/fgs_hdg_mode_sel",0)
	end
	if get("Rotate/aircraft/controls/fgs_nav") == 1 then
		set("Rotate/aircraft/controls/fgs_nav",0)
	end
	if get("Rotate/aircraft/controls/fgs_appr_land") == 1 then
		set("Rotate/aircraft/controls/fgs_appr_land",0)
	end
	if get("Rotate/aircraft/controls/fgs_alt_mode_sel") == -1 then
		set("Rotate/aircraft/controls/fgs_alt_mode_sel",0)
	end
	if get("Rotate/aircraft/controls/fgs_spd_sel_mode") == -1 then
		set("Rotate/aircraft/controls/fgs_spd_sel_mode",0)
	end
	if get("Rotate/aircraft/controls/fgs_fms_spd") == 1 then
		set("Rotate/aircraft/controls/fgs_fms_spd",0)
	end
	if get("Rotate/aircraft/controls/fgs_autoflight") == 1 then
		set("Rotate/aircraft/controls/fgs_autoflight",0)
	end
	if get("Rotate/aircraft/controls/fgs_prof") == 1 then
		set("Rotate/aircraft/controls/fgs_prof",0)
	end
	if get("Rotate/aircraft/controls/ap_disc_l") == 1 then
		set("Rotate/aircraft/controls/ap_disc_l",0)
	end
	if get("Rotate/aircraft/controls/baro_std_set_l") == -1 then
		set("Rotate/aircraft/controls/baro_std_set_l",0)
	end
	if get("Rotate/aircraft/controls/baro_std_set_r") == -1 then
		set("Rotate/aircraft/controls/baro_std_set_r",0)
	end
	if get("Rotate/aircraft/controls/apu_pwr") == 1 then
		set("Rotate/aircraft/controls/apu_pwr",0)
	end
	
end

do_often("reset_actuators()")

return SOP_MD11