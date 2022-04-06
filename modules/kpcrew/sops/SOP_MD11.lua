local SOP_MD11 = {
}

-- SOP related imports
kcSOP = require "kpcrew.sops.SOP"

kcFlow = require "kpcrew.Flow"
kcFlowItem = require ("kpcrew.FlowItem")

kcChecklist = require "kpcrew.checklists.Checklist"
kcChecklistItem = require "kpcrew.checklists.ChecklistItem"
kcSimpleChecklistItem = require "kpcrew.checklists.SimpleChecklistItem"
kcIndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"

kcProcedure = require "kpcrew.procedures.Procedure"
kcProcedureItem = require "kpcrew.procedures.ProcedureItem"
kcSimpleProcedureItem = require "kpcrew.procedures.SimpleProcedureItem"
kcIndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

-- Systems related imports

-- classes for systems switches 
TwoStateDrefSwitch 		= require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch 		= require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
TwoStateToggleSwitch 	= require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch 				= require "kpcrew.systems.InopSwitch"

SwitchGroup  			= require "kpcrew.systems.SwitchGroup"

SimpleAnnunciator 		= require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator 		= require "kpcrew.systems.CustomAnnunciator"

sysLights 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	


-- Set up SOP =========================================================================

activeSOP = kcSOP:new("Rotate MD-11 SOP")

-- ======== COCKPIT PREPARATION PROCEDURE 1 (F/O) ========
-- WX RADAR SYS SWITCH...........................OFF (F/O)
-- FUEL SWITCHES.................................OFF (F/O)
-- PARKING BRAKE..................................ON (F/O)
-- SPOILER HANDLE.....................RETRACT DETEND (F/O)
-- FLAPS / SLAT HANDLE............................UP (F/O)
-- GEAR HANDLE..................................DOWN (F/O)
-- FUEL DUMP SWITCHES.............GUARDED & SAFETIED (F/O)
-- MANF DRAIN SWITCH.........................GUARDED (F/O)
-- EMER PWR SELECTOR.............................OFF (F/O)
-- BATTERY SWITCH..................ON & GUARD CLOSED (F/O)
-- If External Power used
--   EXTERNAL ELECTRICAL POWER.............AVAILABLE (F/O)
--   EXT PWR....................................PUSH (F/O)
--   EXT PWR ON LIGHT..............CHECK ILLUMINATED (F/O)
-- If APU Power used
--   ENG/APU FIRE TEST..........................PUSH (F/O)
--   ALL ENG FIRE HANDLE LIGHTS..........ILLUMINATED (F/O)
--   APU FIRE HANDLE.....................ILLUMINATED (F/O)
--   APU PWR SWITCH.............................PUSH (F/O)
--   APU PWR ON LIGHT.......................BLINKING (F/O)
--   APU PWR ON LIGHT............STEADY WHEN STARTED (F/O)
-- AC & DC OFF LIGHTS...................EXTINGUISHED (F/O)
-- GEN ARM LIGHTS........................ILLUMINATED (F/O)
-- ALL BUS OFF LIGHTS...................EXTINGUISHED (F/O)
-- APU AIR........................................ON (F/O)
-- TRIM AIR OFF ANNUNCIATOR.............EXTINGUISHED (F/O)
-- ANNUN LT TEST.............................PERFORM (F/O)
-- IRS NAV 1 SWITCH..............................NAV (F/O)
-- IRS NAV 2 SWITCH..............................NAV (F/O)
-- IRS NAV AUX SWITCH............................NAV (F/O)
-- CARGO FIRE TEST..............STARTED WITH IRS NAV (F/O)

local cockpitPrepProcFO = kcProcedure:new("COCKPIT PREPARATION PROCEDURE 1 (F/O)")
cockpitPrepProcFO:addItem(kcProcedureItem:new("WX RADAR SYS SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysGeneral.wxSystemSwitch:getStatus() == 1 end,
	function () sysGeneral.wxSystemSwitch:setValue(1) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("FUEL SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelLeverGroup:getStatus() == 0 end,
	function () sysFuel.fuelLeverGroup:actuate(modeOff) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("PARKING BRAKE","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("SPOILER HANDLE","RETRACT DETEND",kcFlowItem.actorFO,1,
	function () return sysControls.speedBrake:getStatus() == 0 end,
	function () sysControls.speedBrake:actuate(modeOff) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("FLAPS/SLAT HANDLE","UP",kcFlowItem.actorFO,1,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("GEAR HANDLE","DOWN",kcFlowItem.actorFO,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("FUEL DUMP SWITCH","GUARDED",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelDumpGuard:getStatus() == 0 end,
	function () sysFuel.fuelDumpGuard:actuate(modeOff) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("MANF DRAIN SWITCH","GUARDED",kcFlowItem.actorFO,1,
	function () return sysFuel.manifoldDrainGuard:getStatus() == 0 end,
	function () sysFuel.manifoldDrainGuard:actuate(modeOff) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("EMER PWR SELECTOR","OFF",kcFlowItem.actorFO,1,
	function () return sysElectric.emerPwrSelector:getStatus() == 0 end,
	function () sysElectric.emerPwrSelector:actuate(modeOff) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("BATTERY SWITCH","ON & GUARD CLOSED",kcFlowItem.actorFO,1,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.batteryGuard:getStatus() == 0 end,
	function () sysElectric.batterySwitch:actuate(modeOn) sysElectric.batteryGuard:actuate(modeOff) end))

cockpitPrepProcFO:addItem(kcSimpleProcedureItem:new("If external power is needed:",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("  EXTERNAL ELECTRICAL POWER","AVAILABLE",kcFlowItem.actorFO,1,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,
	function () sysElectric.GPU:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("  EXT PWR","PUSH",kcFlowItem.actorFO,1,
	function () return sysElectric.extPWRSwitch:getStatus() == 1 end,
	function () sysElectric.extPWRSwitch:actuate(modeOn)  end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
cockpitPrepProcFO:addItem(kcSimpleProcedureItem:new("If APU power used:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcIndirectProcedureItem:new("  ENG/APU FIRE TEST","PUSH AND HOLD",kcFlowItem.actorFO,1,"eng_ext_test_1",
	function () return get("Rotate/aircraft/controls/apu_fire_test") > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcIndirectProcedureItem:new("  ALL ENG FIRE HANDLE LIGHTS","ILLUMINATED",kcFlowItem.actorFO,1,"eng_ext_test_2",
	function () return sysEngines.engFireLights:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcIndirectProcedureItem:new("  APU FIRE HANDLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,"apu_fire_test",
	function () return sysEngines.apuFireLight:getStatus() > 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("  APU PWR SWITCH","PUSH",kcFlowItem.actorFO,1,
	function () return sysElectric.apuPwrSwitch:getStatus() > 0 end,
	function () sysElectric.apuPwrSwitch:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcSimpleProcedureItem:new("  APU PWR ON light blinking:",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("  APU POWER","AVAILABLE",kcFlowItem.actorFO,1,
	function () return get("Rotate/aircraft/systems/elec_apu_avail") == 2 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

cockpitPrepProcFO:addItem(kcProcedureItem:new("AC, DC OFF LIGHTS","EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysElectric.dcOffLights:getStatus() == 0 and sysElectric.acOffLights:getStatus() == 0 end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("GEN ARM LIGHTS","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysElectric.genArmLights:getStatus() > 0 end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("ALL BUS OFF LIGHTS","EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysElectric.acTies:getStatus() == 0 and sysElectric.dcTies:getStatus() == 0 end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("APU AIR","ON",kcFlowItem.actorFO,1,
	function () return sysAir.apuAir:getStatus() == 1 end,
	function () sysAir.apuAir:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("TRIM AIR OFF ANNUNCIATOR","EXTINGUISHED",kcFlowItem.actorFO,1,
	function () return sysAir.trimAirAnc:getStatus() == 0 end))
cockpitPrepProcFO:addItem(kcIndirectProcedureItem:new("ANNUN LT TEST","PERFORM",kcFlowItem.actorFO,1,"internal_lights_test",
	function () return sysGeneral.ancLightTest:getStatus() > 0 end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("IRS NAV 1 SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.irsUnit1Switch:getStatus() == 1 end,
	function () sysGeneral.irsUnit1Switch:actuate(modeOn) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("IRS NAV 2 SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.irsUnit2Switch:getStatus() == 1 end,
	function () sysGeneral.irsUnit2Switch:actuate(modeOn) end))
cockpitPrepProcFO:addItem(kcProcedureItem:new("IRS NAV AUX SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.irsUnit3Switch:getStatus() == 1 end,
	function () sysGeneral.irsUnit3Switch:actuate(modeOn) end))
cockpitPrepProcFO:addItem(kcIndirectProcedureItem:new("CARGO FIRE TEST","STARTED WITH IRS NAV",kcFlowItem.actorFO,1,"cargo_fire_test",
	function () return sysGeneral.cargoFireTestAnc:getStatus() > 0 end))


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

local cockpitPrepProcFO2 = kcProcedure:new("COCKPIT PREPARATION PROCEDURE 2 (F/O)")
cockpitPrepProcFO2:addItem(kcIndirectProcedureItem:new("VOICE RECODER","TEST",kcFlowItem.actorFO,1,"voice_recorder_test",
	function () return sysGeneral.vrcTest:getStatus() > 0 end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("ENG IGN OFF LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,
	function () return sysEngines.engIgnOffLight:getStatus() > 0 end))
cockpitPrepProcFO2:addItem(kcSimpleProcedureItem:new("Before performing HYD PRESS TEST contact ground crew"))
cockpitPrepProcFO2:addItem(kcIndirectProcedureItem:new("HYD PRESS TEST","PUSH",kcFlowItem.actorFO,1,"hyd_press_test",
	function () return sysHydraulic.hydTestSwitch:getStatus() > 0 end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("ENG GEN DRIVE SWITCHES","GUARDED",kcFlowItem.actorFO,1,
	function () return sysElectric.engDriveGuards:getStatus() == 0 end,
	function () sysElectric.engDriveGuards:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("EMER PWR SELECTOR","ARM",kcFlowItem.actorFO,1,
	function () return sysElectric.emerPwrSelector:getStatus() == 1 end,
	function () sysElectric.emerPwrSelector:actuate(modeOn) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("EMER PWR ON LIGHT","OFF",kcFlowItem.actorFO,1,
	function () return sysElectric.emerPwrOnLight:getStatus() == 0 end))
cockpitPrepProcFO2:addItem(kcSimpleProcedureItem:new("  PWR ON light will estinguish after 15 sec"))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("AIR MASKS SWITCH","GUARDED",kcFlowItem.actorFO,1,
	function () return sysAir.maskGuard:getStatus() == 0 end,
	function () sysAir.maskGuard:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("ALL FUEL PUMPS","OFF",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 3 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("FUEL PUMPS 1 & 3","OFF",kcFlowItem.actorFO,1,
	function () return sysFuel.fuelPumpGroup:getStatus() == 2 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("EMER EXIT LIGHT SWITCH","ARM",kcFlowItem.actorFO,1,
	function () return sysGeneral.emerExitSwitch:getStatus() == 1 end,
	function () sysGeneral.emerExitSwitch:setValue(1) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("NO SMOKE SIGNS","ON",kcFlowItem.actorFO,1,
	function () return sysGeneral.noSmokeSigns:getStatus() == 2 end,
	function () sysGeneral.noSmokeSigns:setValue(2) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("SEAT BELTS SIGNS","AUTO",kcFlowItem.actorFO,1,
	function () return sysGeneral.seatBeltSigns:getStatus() == 1 end,
	function () sysGeneral.seatBeltSigns:setValue(1) end))
cockpitPrepProcFO2:addItem(kcSimpleProcedureItem:new("Exterior Lights"))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("LANDING LIGHTS","RETRACTED",kcFlowItem.actorFO,1,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("NOSE LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("RWY LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("NAV LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.positionSwitch:getStatus() == 0 end,
	function () sysLights.positionSwitch:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("LOGO LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.logoSwitch:getStatus() == 0 end,
	function () sysLights.logoSwitch:actuate(modeOff) end,
	function () return kc_is_daylight() == false end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("LOGO LIGHTS","ON",kcFlowItem.actorFO,1,
	function () return sysLights.logoSwitch:getStatus() == 1 end,
	function () sysLights.logoSwitch:actuate(modeOn) end,
	function () return kc_is_daylight() == true end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("BEACON LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(modeOff) end))
cockpitPrepProcFO2:addItem(kcProcedureItem:new("H-INT LIGHTS","OFF",kcFlowItem.actorFO,1,
	function () return sysLights.strobesSwitch:getStatus() == 0 end,
	function () sysLights.strobesSwitch:actuate(modeOff) end))
	

-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(cockpitPrepProcFO)
activeSOP:addProcedure(cockpitPrepProcFO2)

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