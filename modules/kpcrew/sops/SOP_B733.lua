-- Standard Operating Procedure for IXEG B733

-- @classmod SOP_B733
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local SOP_B733 = {
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
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }


-- Set up SOP =========================================================================

activeSOP = SOP:new("IXEG B733 SOP")

local testProc = Checklist:new("TEST","","")
testProc:addItem(ChecklistItem:new("APU","ON",FlowItem.actorFO,3,
	function () 
			kc_procvar_set("apustart",true)
	end))

-- ============ Electrical Power Up Procedure ===========
-- == Initial checks
-- PARKING BRAKE................................SET (F/O)
-- ENGINE START LEVERS.......................CUTOFF (F/O)
-- FLAP LEVER....................................UP (F/O)
-- DC POWER SELECTOR........................BAT BUS (F/O)
-- AC POWER SELECTOR........................APU GEN (F/O)
-- BATTERY VOLTAGE..........................MIN 24V (F/O)
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- ==== Hydraulic System
-- ALTERNATE FLAPS MASTER SWITCH.......GUARD CLOSED (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)
-- ==== Other
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- LANDING GEAR LEVER..........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT.....CHECK ILLUMINATED (F/O)
--   RED LANDING GEAR LIGHT......CHECK EXTINGUISHED (F/O)

-- == Activate External Power
--   Use Zibo EFB to turn Ground Power on.         
--   GRD POWER AVAILABLE LIGHT..........ILLUMINATED (F/O)
--   GROUND POWER SWITCH.........................ON (F/O)

-- == Activate APU 
--   OVHT FIRE TEST SWITCH...............HOLD RIGHT (F/O)
--   MASTER FIRE WARN LIGHT....................PUSH (F/O)
--   ENGINES EXT TEST SWITCH...........TEST TO LEFT (F/O)
--   APU......................................START (F/O)
--     Hold APU switch in START position for 3-4 seconds.
--     APU GEN OFF BUS LIGHT............ILLUMINATED (F/O)
--     APU GENERATOR BUS SWITCHES................ON (F/O)

-- TRANSFER BUS LIGHTS...........CHECK EXTINGUISHED (F/O)
-- SOURCE OFF LIGHTS.............CHECK EXTINGUISHED (F/O)
-- STANDBY POWER.................................ON (F/O)
--   STANDBY PWR LIGHT...........CHECK EXTINGUISHED (F/O)          
-- ======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP (F/O)","performing ELECTRICAL POWER UP")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end))
	
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(ProcedureItem:new("DC POWER SELECTOR","BAT BUS",FlowItem.actorFO,1,
	function () return sysElectric.dcPowerSwitch:getStatus() == sysElectric.dcPwrBBUS end,
	function () sysElectric.dcPowerSwitch:setValue(sysElectric.dcPwrBBUS) end))
electricalPowerUpProc:addItem(ProcedureItem:new("AC POWER SELECTOR","APU GEN",FlowItem.actorFO,1,
	function () return sysElectric.acPowerSwitch:getStatus() == sysElectric.acPwrAPU end,
	function () sysElectric.acPowerSwitch:setValue(sysElectric.acPwrAPU) end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","ON",FlowItem.actorFO,1,
	function () return sysElectric.batterySwitch:getStatus() == 1 end,
	function () sysElectric.batterySwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,1,
	function () return sysElectric.batteryCover:getStatus() == 0 end,
	function () sysElectric.batteryCover:actuate(0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","MIN 24V",FlowItem.actorFO,1,"bat24v",
	function () return sysElectric.batt1Volt:getStatus() > 23 end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,1,
	function () return sysElectric.stbyPowerCover:getStatus() == 0 end,
	function () sysElectric.stbyPowerCover:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS","ALL IN",FlowItem.actorFO,1,true))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Hydraulic System"))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",FlowItem.actorFO,1,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Other"))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,1,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,1,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,1,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(ProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysGeneral.gearLightsRed:getStatus() == 0 end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Use IXEG Menu to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",FlowItem.actorFO,2,
	function () return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GROUND POWER SWITCH","ON",FlowItem.actorFO,2,
	function () return get("ixeg/733/electrical/stdby_power_off_ann") == 0 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  OVHT DET SWITCHES","NORMAL",FlowItem.actorFO,1,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,3,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () kc_procvar_set("ovhttest",true) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,2,"masterfire",
	function () return get("ixeg/733/firewarning/fire_bell_co_pt_act") > 0 end,
	function () set("ixeg/733/firewarning/fire_bell_co_pt_act",1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST TO LEFT",FlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("ixeg/733/firewarning/fire_ext_test_act") < 0 end,
	function () set("ixeg/733/firewarning/fire_ext_test_act",-1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU#","START",FlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
	function () kc_procvar_set("apustart",true) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,1,"apu_gen_off_bus",
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,2,"apugenson",
	function () return sysElectric.apuGenSwitches:getStatus() > 0 end,
	function () sysElectric.apuGenSwitches:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
	
electricalPowerUpProc:addItem(SimpleProcedureItem:new("=="))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysElectric.transferBus1:getStatus() == 0 and sysElectric.transferBus2:getStatus() == 0 end,
	function () if activePrefSet:get("aircraft:powerup_apu") == true then sysElectric.apuGenSwitches:actuate(0) end end))
electricalPowerUpProc:addItem(ProcedureItem:new("SOURCE OFF LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysElectric.sourceOff1:getStatus() == 0 and sysElectric.sourceOff2:getStatus() == 0 end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,1,
	function () return get("ixeg/733/electrical/elec_stby_power_act") == 2 end))
electricalPowerUpProc:addItem(ProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,1,
	function () return sysElectric.stbyPwrOff:getStatus() == 0 end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))


-- Cockpit Preparation
-- sw_item:Throttle|IDLE:sim/cockpit2/engine/actuators/throttle_ratio_all:0.06|0.09
-- sw_item:Left pack|OFF:ixeg/733/bleedair/bleedair_lpack_act:0
-- sw_item:Right pack|OFF:ixeg/733/bleedair/bleedair_rpack_act:0
-- sw_item:All Bleeds|OFF:(ixeg/733/bleedair/bleedair_apu_act:0)&&(ixeg/733/bleedair/bleedair_eng1_act:0)&&(ixeg/733/bleedair/bleedair_eng2_act:0)
-- sw_item:All Fuel Pumps|OFF:(ixeg/733/fuel/fuel_1_aft_act:0)&&(ixeg/733/fuel/fuel_2_aft_act:0)&&(ixeg/733/fuel/fuel_1_fwd_act:0)&&(ixeg/733/fuel/fuel_2_fwd_act:0)&&(ixeg/733/fuel/fuel_ctr_left_act:0)&&(ixeg/733/fuel/fuel_ctr_right_act:0)
-- sw_item:Spoilers|RETRACTED:sim/cockpit2/controls/speedbrake_ratio:0
-- sw_item:Flaps|UP:sim/cockpit2/controls/flap_ratio:0.0
-- sw_item:Stab Trims|NORMAL & LOCKS:(ixeg/733/hydraulics/stab_trim_ovrd_act:0)&&(ixeg/733/hydraulics/stab_trim_ovrd_guard:0)
-- sw_item:Weather Radar|OFF:ixeg/733/wxr/wxr_onoff_act:0
-- sw_item:Panel Light Bright on Overhead|FULL:ixeg/733/rheostats/light_overhead_act:1
-- sw_item:All Panel Lights Bright Left and Right Side|FULL:(ixeg/733/lighting/light_main_pilot_side:>0.2)&&(ixeg/733/lighting/light_main_background:>0.2)&&(ixeg/733/lighting/light_afds_flood:>0.2)&&(ixeg/733/lighting/light_main_copilot_side:>0.2)
-- sw_item:All Flood and Panel Lights Bright Lower Pedestal|FULL:(ixeg/733/lighting/light_pedflood:>1)&&(ixeg/733/lighting/light_pedpanel:>0.2)
-- sw_item:All Extrenal Lights|OFF:(ixeg/733/lighting/wheel_well_lt_act:0)&&(ixeg/733/lighting/wing_lt_act:0)&&(ixeg/733/lighting/anti_col_lt_act:0)&&(ixeg/733/lighting/position_lt_act:0)&&(ixeg/733/lighting/strobe_lt_act:0)&&(ixeg/733/lighting/logo_lt_act:0)&&(ixeg/733/lighting/taxi_lt_act:0)&&(ixeg/733/lighting/r_rwy_turnoff_act:0)&&(ixeg/733/lighting/l_rwy_turnoff_act:0)&&(sim/cockpit2/switches/landing_lights_switch[2]:0)&&(sim/cockpit2/switches/landing_lights_switch[3]:0)&&(sim/cockpit2/switches/landing_lights_switch[4]:0)&&(sim/cockpit2/switches/landing_lights_switch{5}:0)
-- sw_item:Position light|ON:ixeg/733/lighting/position_lt_act:1
-- sw_item:Logo wing & wheel lights|AS NEEDED
-- sw_item:Oxygen|CHECK:ixeg/733/pressurization/pilots_oxy_test_act:1
-- sw_item:IRS selector|NAV:(ixeg/733/irs/irs_left_mode_act:2)&&(ixeg/733/irs/irs_right_mode_act:2)
-- sw_itemvoid:Verify that the ON DC lights illuminate then extinguish
-- sw_itemvoid:Verify that the ALIGN lights are illuminated
-- sw_item:stall warning test 1|CHECK:ixeg/733/airspeed/stallwarn_test_01_act:1
-- sw_item:stall warning test 2|CHECK:ixeg/733/airspeed/stallwarn_test_02_act:1
-- sw_item:match airspedd warning 1|CHECK:ixeg/733/airspeed/clacker_test_01_act:1
-- sw_item:match airspedd warning 2|CHECK:ixeg/733/airspeed/clacker_test_02_act:1
-- sw_item:Flight Controls A and B guard|CLOSED:(ixeg/733/hydraulics/flt_control_A_guard:0)&&(ixeg/733/hydraulics/flt_control_B_guard:0)
-- sw_item:Spoiler A and B guard|CLOSED(ixeg/733/hydraulics/spoiler_A_guard:0)&&(ixeg/733/hydraulics/spoiler_B_guard:0)
-- sw_item:Alternate Flaps guard|CLOSED:ixeg/733/hydraulics/alt_flaps_guard:0
-- sw_item:Yaw damper|ON:ixeg/733/hydraulics/yaw_damper_act:1
-- sw_item:All intrumental transfer Switches Audio EFI IRS|NORMAL:ixeg/733/misc/audio_obs_act:0



-- ============ Preliminary Preflight Procedures ========
-- EMERGENCY EXIT LIGHT.........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON..........................PRESS (F/O)
-- ELECTRICAL POWER UP.....................COMPLETE (F/O)
-- VOICE RECORDER SWITCH.......................AUTO (F/O)
-- MACH OVERSPEED TEST......................PERFORM (F/O)
-- STALL WARNING TEST.......................PERFORM (F/O)
-- XPDR....................................SET 2000 (F/O)
-- COCKPIT LIGHTS.....................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS.........SET AS REQUIRED (F/O)
-- POSITION LIGHTS...............................ON (F/O)
-- ==== FUEL PUMPS
-- FUEL PUMPS...............................ALL OFF (F/O)
-- FUEL CROSS FEED..............................OFF (F/O)
-- MCP...................................INITIALIZE (F/O)
-- PARKING BRAKE................................SET (F/O)
-- GALLEY POWER..................................ON (F/O)
-- Next: CDU Preflight                             

-- local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE (F/O)")
-- prelPreflightProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM #exchange|/ON GUARD CLOSED| #",FlowItem.actorFO,2,
	-- function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff  end,
	-- function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
-- prelPreflightProc:addItem(IndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",FlowItem.actorFO,2,"attendence_button",
	-- function () return sysGeneral.attendanceButton:getStatus() > modeOff end))

-- prelPreflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,1,
	-- function () return 
		-- sysElectric.apuAvailAnc:getStatus() > 0 or sysElectric.gpuAvailAnc:getStatus() > 0
	-- end))
-- prelPreflightProc:addItem(ProcedureItem:new("FLT RECORDER SWITCH","AUTO",FlowItem.actorFO,2,
	-- function () return  sysGeneral.voiceRecSwitch:getStatus() == modeOff and sysGeneral.vcrCover:getStatus() == modeOff end,
	-- function () sysGeneral.voiceRecSwitch:actuate(modeOn) sysGeneral.vcrCover:actuate(modeOff) end))
-- prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",FlowItem.actorFO,2,"mach_ovspd_test",
	-- function () return get("FJS/732/Annun/MachWarningTestButton") == 1 end))
-- prelPreflightProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST","PERFORM",FlowItem.actorFO,2,"stall_warning_test",
	-- function () return get("FJS/732/Annun/StallWarningSwitch") == 1 end))
-- prelPreflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,2,
	-- function () return get("sim/cockpit/radios/transponder_code") == 2000 end))
-- prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,2,
	-- function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
-- prelPreflightProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,2,
	-- function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
-- prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,2,
	-- function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	-- function () sysLights.positionSwitch:actuate(modeOn) end))

-- prelPreflightProc:addItem(SimpleProcedureItem:new("==== FUEL PUMPS"))
-- prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.allFuelPumpsOff:getStatus() == 1 end,nil,
	-- function () return activePrefSet:get("aircraft:powerup_apu") end))
-- prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.allFuelPumpsOff:getStatus() == 0 end,nil,
	-- function () return not activePrefSet:get("aircraft:powerup_apu") end))
-- prelPreflightProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.crossFeed:getStatus() == modeOff end,
	-- function () sysFuel.crossFeed:actuate(modeOff) end))

-- prelPreflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,2,
	-- function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	-- function () 
		-- sysMCP.fltdirSelector:adjustValue(0,-1,5)
		-- sysMCP.crsSelectorGroup:setValue(1)
		-- sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		-- sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		-- sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		-- sysMCP.apmodeSelector:adjustValue(0,0,3)
		-- sysMCP.hdgmodeSelector:adjustValue(1,0,2)
		-- sysMCP.pitchSelect:adjustValue(0,-1,1)
		-- sysMCP.rollEngage:actuate(0)
		-- sysMCP.pitchEngage:actuate(0)
	-- end))
-- prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,2,
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	-- function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
-- prelPreflightProc:addItem(ProcedureItem:new("#spell|GALLEY POWER","ON",FlowItem.actorFO,3,
	-- function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	-- function () sysElectric.cabUtilPwr:actuate(modeOn) end))

-- ================== CDU Preflight ==================
-- INITIAL DATA (CPT)                              
--   IDENT page:...............................OPEN (CPT)
--     Verify Model and ENG RATING                 
--     Verify navigation database ACTIVE date      
--   POS INIT page:............................OPEN (CPT)
--     Verify time                                 
--     REF AIRPORT..............................SET (CPT)
-- NAVIGATION DATA (CPT)                           
--   RTE page:.................................OPEN (CPT)
--     ORIGIN...................................SET (CPT)
--     DEST.....................................SET (CPT)
--     FLT NO...................................SET (CPT)
--     ROUTE..................................ENTER (CPT)
--     ROUTE...............................ACTIVATE (CPT)
--     ROUTE................................EXECUTE (CPT)
--   DEPARTURES page:..........................OPEN (CPT)
--     Select runway and departure routing         
--     ROUTE:...............................EXECUTE (CPT)
--   LEGS page:................................OPEN (CPT)
--     Verify or enter correct RNP for departure   
-- PERFORMANCE DATA (CPT)                          
--   PERF INIT page:...........................OPEN (CPT)
--     ZFW....................................ENTER (CPT)
--     GW..............................ENTER/VERIFY (CPT)
--     RESERVES........................ENTER/VERIFY (CPT)
--     COST INDEX.............................ENTER (CPT)
--     CRZ ALT................................ENTER (CPT)
--   N1 LIMIT page:............................OPEN (CPT)
--     Select assumed temp and/or fixed t/o rating 
--     Select full or derated climb thrust         
--   TAKEOFF REF page:.........................OPEN (CPT)
--     FLAPS..................................ENTER (CPT)
--     CG.....................................ENTER (CPT)
--     V SPEEDS...............................ENTER (CPT)
-- PREFLIGHT COMPLETE?.......................VERIFY (CPT)


-- local cduPreflightProc = Procedure:new("CDU PREFLIGHT PROCEDURE (CPT)")
-- cduPreflightProc:addItem(SimpleProcedureItem:new("INITIAL DATA (CPT)"))
-- cduPreflightProc:addItem(ProcedureItem:new("  IDENT page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify Model and ENG RATING"))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
-- cduPreflightProc:addItem(ProcedureItem:new("  POS INIT page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify time"))
-- cduPreflightProc:addItem(ProcedureItem:new("    REF AIRPORT","SET",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("NAVIGATION DATA (CPT)"))
-- cduPreflightProc:addItem(ProcedureItem:new("  RTE page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    ORIGIN","SET",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    DEST","SET",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    FLT NO","SET",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    ROUTE","ENTER",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    ROUTE","ACTIVATE",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    ROUTE","EXECUTE",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("  DEPARTURES page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Select runway and departure routing"))
-- cduPreflightProc:addItem(ProcedureItem:new("    ROUTE:","EXECUTE",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("  LEGS page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("PERFORMANCE DATA (CPT)"))
-- cduPreflightProc:addItem(ProcedureItem:new("  PERF INIT page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    ZFW","ENTER",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    GW","ENTER/VERIFY",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    RESERVES","ENTER/VERIFY",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    COST INDEX","ENTER",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("    CRZ ALT","ENTER",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(ProcedureItem:new("  N1 LIMIT page:","OPEN",FlowItem.actorCPT,1,function () return true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("    Select full or derated climb thrust"))
-- cduPreflightProc:addItem(ProcedureItem:new("  TAKEOFF REF page:","OPEN",FlowItem.actorCPT,1,"takeoff_ref_page",
	-- function () return string.find(sysFMC.fmcPageTitle:getStatus(),"TAKEOFF REF") end))
-- cduPreflightProc:addItem(IndirectProcedureItem:new("    FLAPS","ENTER",FlowItem.actorCPT,1,"flaps_entered",
	-- function () return sysFMC.fmcFlapsEntered:getStatus() end))
-- cduPreflightProc:addItem(IndirectProcedureItem:new("    CG","ENTER",FlowItem.actorCPT,1,"cg_entered",
	-- function () return sysFMC.fmcCGEntered:getStatus() end))
-- cduPreflightProc:addItem(IndirectProcedureItem:new("    V SPEEDS","ENTER",FlowItem.actorCPT,1,"vspeeds_entered",
	-- function () return sysFMC.fmcVspeedsEntered:getStatus() == true end))
-- cduPreflightProc:addItem(SimpleProcedureItem:new("CDU PREFLIGHT COMPLETE"))

-- ================ Preflight Procedure =================
-- Flight control panel                            
-- FLIGHT CONTROL SWITCHES............GUARDS CLOSED (F/O)
-- FLIGHT SPOILER SWITCHES............GUARDS CLOSED (F/O)
-- YAW DAMPER SWITCH.............................ON (F/O)
-- NAVIGATION & DISPLAYS panel                     
-- VHF NAV TRANSFER SWITCH...................NORMAL (F/O)
-- IRS TRANSFER SWITCH.......................NORMAL (F/O)
-- FMC TRANSFER SWITCH.......................NORMAL (F/O)
-- SOURCE SELECTOR.............................AUTO (F/O)
-- CONTROL PANEL SELECT SWITCH...............NORMAL (F/O)
-- Fuel panel                                      
-- CROSSFEED SELECTOR........................CLOSED (F/O)
-- FUEL PUMP SWITCHES...........................OFF (F/O)
-- Electrical panel                                
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH.........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH....................ON (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH.................GUARD CLOSED (F/O)
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH.................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH..........TEST 2 TO RIGHT (F/O)
-- APU SWITCH.................................START (F/O)
-- APU GEN OFF BUS LIGHT................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES....................ON (F/O)
-- EQUIPMENT COOLING SWITCHES..................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH.............................ON (F/O)
-- FASTEN BELTS SWITCH...........................ON (F/O)
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- WINDOW HEAT SWITCHES..........................ON (F/O)
-- PROBE HEAT SWITCHES..........................OFF (F/O)
-- WING ANTI-ICE SWITCH.........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES.....................OFF (F/O)
-- Hydraulic panel                                 
-- ENGINE HYDRAULIC PUMPS SWITCHES...............ON (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)

-- local preflightFOProc = Procedure:new("PREFLIGHT PROCEDURE PART 1 (F/O)")
-- preflightFOProc:addItem(SimpleProcedureItem:new("Flight control panel"))
-- preflightFOProc:addItem(ProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",FlowItem.actorFO,2,
	-- function () return sysControls.fltCtrlCovers:getStatus() == modeOff end,
	-- function () sysControls.fltCtrlCovers:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",FlowItem.actorFO,2,
	-- function () return sysControls.spoilerCovers:getStatus() == modeOff  end,
	-- function () sysControls.spoilerCovers:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysControls.yawDamper:getStatus() == modeOn end,
	-- function () sysControls.yawDamper:actuate(modeOn) end))
	
-- preflightFOProc:addItem(SimpleProcedureItem:new("NAVIGATION & DISPLAYS panel"))
-- preflightFOProc:addItem(ProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",FlowItem.actorFO,2,
	-- function() return sysMCP.vhfNavSwitch:getStatus() == 0 end,
	-- function () sysMCP.vhfNavSwitch:setValue(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",FlowItem.actorFO,2,
	-- function() return sysMCP.irsNavSwitch:getStatus() == 0 end,
	-- function () sysMCP.irsNavSwitch:setValue(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",FlowItem.actorFO,2,
	-- function() return sysMCP.fmcNavSwitch:getStatus() == 0 end,
	-- function () sysMCP.fmcNavSwitch:setValue(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("SOURCE SELECTOR","AUTO",FlowItem.actorFO,2,
	-- function() return sysMCP.displaySourceSwitch:getStatus() == 0 end,
	-- function () sysMCP.displaySourceSwitch:setValue(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",FlowItem.actorFO,2,
	-- function() return sysMCP.displayControlSwitch:getStatus() == 0 end,
	-- function () sysMCP.displayControlSwitch:setValue(0) end))

-- preflightFOProc:addItem(SimpleProcedureItem:new("Fuel panel"))
-- preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	-- function () return not activePrefSet:get("aircraft:powerup_apu") end))
-- preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	-- function () return activePrefSet:get("aircraft:powerup_apu") end))
-- preflightFOProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF",FlowItem.actorFO,2,
	-- function () return sysFuel.crossFeed:getStatus() == modeOff end,
	-- function () sysFuel.crossFeed:actuate(modeOff) end))

-- preflightFOProc:addItem(SimpleProcedureItem:new("Electrical panel"))
-- preflightFOProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysElectric.batteryCover:getStatus() == modeOff end,
	-- function () sysElectric.batteryCover:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	-- function () sysElectric.cabUtilPwr:actuate(modeOn) end))
-- preflightFOProc:addItem(ProcedureItem:new("#spell|IFE# POWER SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysElectric.ifePwr:getStatus() == modeOn end,
	-- function () sysElectric.ifePwr:actuate(modeOn) end))
-- preflightFOProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysElectric.stbyPowerCover:getStatus() == modeOff end,
	-- function () sysElectric.stbyPowerCover:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",FlowItem.actorFO,2,
	-- function () return sysElectric.genDriveCovers:getStatus() == 0 end))
-- preflightFOProc:addItem(ProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysElectric.busTransCover:getStatus() == 0 end))

-- preflightFOProc:addItem(SimpleProcedureItem:new("Overheat and fire protection panel"))
-- preflightFOProc:addItem(ProcedureItem:new("OVHT DET SWITCHES","NORMAL",FlowItem.actorFO,1,function (self) return true end,nil,nil))
-- preflightFOProc:addItem(IndirectProcedureItem:new("OVHT FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,2,"ovht_fire_test",
	-- function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end))
-- preflightFOProc:addItem(IndirectProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,1,"master_fire_warn",
	-- function () return sysGeneral.fireWarningAnc:getStatus() > 0 end))
-- preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",FlowItem.actorFO,2,"eng_ext_test_1",
	-- function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end))
-- preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",FlowItem.actorFO,2,"eng_ext_test_2",
	-- function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end))
-- preflightFOProc:addItem(ProcedureItem:new("APU SWITCH","START",FlowItem.actorFO,2,
	-- function () return sysElectric.apuRunningAnc:getStatus() == 1 end))
-- preflightFOProc:addItem(ProcedureItem:new("APU GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,2,
	-- function () return sysElectric.apuGenBusOff:getStatus() == 1 end))
-- preflightFOProc:addItem(ProcedureItem:new("APU GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end))

-- preflightFOProc:addItem(ProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",FlowItem.actorFO,2,
	-- function () return sysGeneral.equipCoolExhaust:getStatus() == modeOff and sysGeneral.equipCoolSupply:getStatus() == 0 end,
	-- function () sysGeneral.equipCoolExhaust:actuate(modeOff) sysGeneral.equipCoolSupply:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff end,
	-- function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
-- preflightFOProc:addItem(ProcedureItem:new("NO SMOKING SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	-- function () sysGeneral.noSmokingSwitch:adjustValue(1,0,2) end))
-- preflightFOProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	-- function () sysGeneral.seatBeltSwitch:adjustValue(1,0,2) end))
-- preflightFOProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,2,
	-- function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	-- function () sysGeneral.wiperGroup:actuate(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("WINDOW HEAT SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	-- function () sysAice.windowHeatGroup:actuate(1) end))
-- preflightFOProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	-- function () sysAice.probeHeatGroup:actuate(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,2,
	-- function () return sysAice.wingAntiIce:getStatus() == 0 end,
	-- function () sysAice.wingAntiIce:actuate(0) end))
-- preflightFOProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	-- function () sysAice.engAntiIceGroup:actuate(0) end))
-- preflightFOProc:addItem(SimpleProcedureItem:new("Continue with part 2"))

-- ========== PREFLIGHT PROCEDURE PART 2 (F/O) ==========
-- Air conditioning panel                          
-- AIR TEMPERATURE SOURCE SELECTOR........AS NEEDED (F/O)
-- TRIM AIR SWITCH...............................ON (F/O)
-- RECIRCULATION FAN SWITCHES..................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH..............AUTO OR OPEN (F/O)
-- ENGINE BLEED AIR SWITCHES.....................ON (F/O)
-- APU BLEED AIR SWITCH..........................ON (F/O)
-- Cabin pressurization panel                      
-- FLIGHT ALTITUDE INDICATOR........CRUISE ALTITUDE (F/O)
-- LANDING ALTITUDE INDICATOR..DEST FIELD ELEVATION (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO (F/O)
-- Lighting panel                                  
-- LANDING LIGHT SWITCHES...........RETRACT AND OFF (F/O)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF (F/O)
-- TAXI LIGHT SWITCH............................OFF (F/O)
-- LOGO LIGHT SWITCH......................AS NEEDED (F/O)
-- POSITION LIGHT SWITCH..................AS NEEDED (F/O)
-- ANTI-COLLISION LIGHT SWITCH..................OFF (F/O)
-- WING ILLUMINATION SWITCH...............AS NEEDED (F/O)
-- WHEEL WELL LIGHT SWITCH................AS NEEDED (F/O)
-- IGNITION SELECT SWITCH................IGN L OR R (F/O)
-- ENGINE START SWITCHES........................OFF (F/O)

-- local preflightFO2Proc = Procedure:new("PREFLIGHT PROCEDURE PART 2 (F/O)")

-- preflightFO2Proc:addItem(SimpleProcedureItem:new("Hydraulic panel"))
-- preflightFO2Proc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	-- function () sysHydraulic.engHydPumpGroup:actuate(1) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	-- function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
	
-- preflightFO2Proc:addItem(SimpleProcedureItem:new("Air conditioning panel"))
-- preflightFO2Proc:addItem(ProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","AS NEEDED",FlowItem.actorFO,2,
	-- function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end))
-- preflightFO2Proc:addItem(ProcedureItem:new("TRIM AIR SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	-- function () sysAir.trimAirSwitch:actuate(modeOn) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",FlowItem.actorFO,2,
	-- function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	-- function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",FlowItem.actorFO,2,
	-- function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,
	-- function () sysAir.packLeftSwitch:setValue(1) sysAir.packRightSwitch:setValue(1) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",FlowItem.actorFO,2,
	-- function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	-- function () sysAir.trimAirSwitch:actuate(modeOn) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	-- function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	-- function () sysAir.apuBleedSwitch:actuate(modeOn) end))

-- preflightFO2Proc:addItem(SimpleProcedureItem:new("Cabin pressurization panel"))
-- preflightFO2Proc:addItem(ProcedureItem:new("FLIGHT ALTITUDE INDICATOR","CRUISE ALTITUDE",FlowItem.actorFO,2))
-- preflightFO2Proc:addItem(ProcedureItem:new("LANDING ALTITUDE INDICATOR","DEST FIELD ELEVATION",FlowItem.actorFO,2))
-- preflightFO2Proc:addItem(ProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorFO,2,
	-- function () return sysAir.pressModeSelector:getStatus() == 0 end,
	-- function () sysAir.pressModeSelector:actuate(0) end))

-- preflightFO2Proc:addItem(SimpleProcedureItem:new("Lighting panel"))
-- preflightFO2Proc:addItem(ProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",FlowItem.actorFO,2,
	-- function () return sysLights.landLightGroup:getStatus() == 0 end,
	-- function () sysLights.landLightGroup:actuate(0) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	-- function () sysLights.rwyLightGroup:actuate(0) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("TAXI LIGHT SWITCH","OFF",FlowItem.actorFO,2,
	-- function () return sysLights.taxiSwitch:getStatus() == 0 end,
	-- function () sysLights.taxiSwitch:actuate(0) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("LOGO LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,2,
	-- function () return sysLights.logoSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.logoSwitch:actuate( kc_is_daylight() and 0 or 1) end ))
-- preflightFO2Proc:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","AS NEEDED",FlowItem.actorFO,2))
-- preflightFO2Proc:addItem(ProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",FlowItem.actorFO,2,
	-- function () return sysLights.beaconSwitch:getStatus() == 0 end,
	-- function () sysLights.beaconSwitch:actuate(0) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("WING ILLUMINATION SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,2,
	-- function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("WHEEL WELL LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,2,
	-- function () return sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	-- function () sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
-- preflightFO2Proc:addItem(ProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",FlowItem.actorFO,2,
	-- function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
-- preflightFO2Proc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	-- function () sysEngines.engStarterGroup:adjustValue(1,0,3) end)) 
-- preflightFO2Proc:addItem(SimpleProcedureItem:new("Continue with part 3"))

-- ========== PREFLIGHT PROCEDURE PART 3 (F/O) ==========
-- Mode control panel                              
-- COURSE(S)....................................SET (F/O)
-- FLIGHT DIRECTOR SWITCHES......................ON (F/O)
-- EFIS control panel                              
-- MINIMUMS REFERENCE SELECTOR........RADIO OR BARO (F/O)
-- MINIMUMS SELECTOR.........SET DH OR DA REFERENCE (F/O)
-- FLIGHT PATH VECTOR SWITCH....................OFF (F/O)
-- METERS SWITCH................................OFF (F/O)
-- BAROMETRIC REFERENCE SELECTOR..........IN OR HPA (F/O)
-- BAROMETRIC SELECTOR..SET LOCAL ALTIMETER SETTING (F/O)
-- VOR/ADF SWITCHES.......................AS NEEDED (F/O)
-- MODE SELECTOR................................MAP (F/O)
-- CENTER SWITCH..........................AS NEEDED (F/O)
-- RANGE SELECTOR.........................AS NEEDED (F/O)
-- TRAFFIC SWITCH.........................AS NEEDED (F/O)
-- WEATHER RADAR................................OFF (F/O)
-- MAP SWITCHES...........................AS NEEDED (F/O)
-- OXYGEN..............................TEST AND SET (F/O)
-- CLOCK........................................SET (F/O)
-- MAIN PANEL DISPLAY UNITS SELECTOR...........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR.................NORM (F/O)
-- GROUND PROXIMITY panel                          
-- FLAP INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- GEAR INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- TERRAIN INHIBIT SWITCH..............GUARD CLOSED (F/O)
-- Landing gear panel                              
-- LANDING GEAR LEVER............................DN (F/O)
-- AUTO BRAKE SELECT SWITCH.....................RTO (F/O)
-- ANTISKID INOP LIGHT..........VERIFY EXTINGUISHED (F/O)
-- Radio tuning panel                              
-- VHF COMMUNICATIONS RADIOS....................SET (F/O)
-- VHF NAVIGATION RADIOS..........SET FOR DEPARTURE (F/O)
-- AUDIO CONTROL PANEL..........................SET (F/O)
-- ADF RADIOS...................................SET (F/O)
-- WEATHER RADAR PANEL..........................SET (F/O)
-- TRANSPONDER PANEL............................SET (F/O)

-- local preflightFO3Proc = Procedure:new("PREFLIGHT PROCEDURE PART 3 (F/O)")
-- preflightFO3Proc:addItem(SimpleProcedureItem:new("Mode control panel"))
-- preflightFO3Proc:addItem(ProcedureItem:new("COURSE(S)","SET",FlowItem.actorFO,2))
-- preflightFO3Proc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysMCP.fdirGroup:getStatus() == 2 end,
	-- function () sysMCP.fdirGroup:actuate(1) end))
	
-- preflightFO3Proc:addItem(SimpleProcedureItem:new("EFIS control panel"))
-- preflightFO3Proc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BARO",FlowItem.actorFO,2))
-- preflightFO3Proc:addItem(ProcedureItem:new("MINIMUMS SELECTOR","SET DH OR DA REFERENCE",FlowItem.actorFO,2))
-- preflightFO3Proc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR SWITCH","OFF",FlowItem.actorFO,2,
	-- function () return sysEFIS.fpvPilot:getStatus() == 0 end,
	-- function () sysEFIS.fpvPilot:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("METERS SWITCH","OFF",FlowItem.actorFO,2,
	-- function () return sysEFIS.mtrsPilot:getStatus() == 0 end,
	-- function () sysEFIS.mtrsPilot:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorFO,2,
	-- function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	-- function () sysEFIS.mapModePilot:adjustValue(sysEFIS.mapModeMAP,0,3) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("CENTER SWITCH","AS NEEDED",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("RANGE SELECTOR","AS NEEDED",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,2,
	-- function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	-- function () sysEFIS.wxrPilot:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("OXYGEN","TEST AND SET",FlowItem.actorFO,2,"oxygentested",
	-- function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
-- preflightFO3Proc:addItem(ProcedureItem:new("CLOCK","SET",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorFO,2,
	-- function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	-- function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorFO,2,
	-- function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	-- function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
	
-- preflightFO3Proc:addItem(SimpleProcedureItem:new("GROUND PROXIMITY panel"))
-- preflightFO3Proc:addItem(ProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	-- function () sysGeneral.flapInhibitCover:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	-- function () sysGeneral.gearInhibitCover:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,2,
	-- function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	-- function () sysGeneral.terrainInhibitCover:actuate(0) end))
	
-- preflightFO3Proc:addItem(SimpleProcedureItem:new("Landing gear panel"))
-- preflightFO3Proc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DN",FlowItem.actorFO,2,
	-- function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	-- function () sysGeneral.GearSwitch:actuate(1) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",FlowItem.actorFO,2,
	-- function () return sysGeneral.autobreak:getStatus() == 0 end,
	-- function () sysGeneral.autobreak:actuate(0) end))
-- preflightFO3Proc:addItem(ProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",FlowItem.actorFO,2,
	-- function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))
	
-- preflightFO3Proc:addItem(SimpleProcedureItem:new("Radio tuning panel"))
-- preflightFO3Proc:addItem(ProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","SET",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("ADF RADIOS","SET",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("WEATHER RADAR PANEL","SET",FlowItem.actorFO,1))
-- preflightFO3Proc:addItem(ProcedureItem:new("TRANSPONDER PANEL","SET",FlowItem.actorFO,1))

-- ============= PREFLIGHT PROCEDURE (CAPT) ============
-- LIGHTS.....................................TEST (CPT)
-- EFIS control panel
-- MINIMUMS REFERENCE SELECTOR..........RADIO/BARO (CPT)
-- DECISION HEIGHT OR ALTITUDE REFERENCE.......SET (CPT)
-- METERS SWITCH.........................MTRS/FEET (CPT)
-- FLIGHT PATH VECTOR.......................ON/OFF (CPT)
-- BAROMETRIC REFERENCE SELECTOR............HPA/IN (CPT)
-- BAROMETRIC SELECTOR.SET LOCAL ALTIMETER SETTING (CPT)
-- VOR/ADF SWITCHES......................AS NEEDED (CPT)
-- MODE SELECTOR...............................MAP (CPT)
-- CENTER SWITCH.........................AS NEEDED (CPT)
-- RANGE SELECTOR........................AS NEEDED (CPT)
-- TRAFFIC SWITCH........................AS NEEDED (CPT)
-- WEATHER RADAR...............................OFF (CPT)
-- MAP SWITCHES..........................AS NEEDED (CPT)
-- Mode control panel


-- local preflightCPTProc = Procedure:new("PREFLIGHT PROCEDURE (CAPT)")
-- preflightCPTProc:addItem(IndirectProcedureItem:new("LIGHTS","TEST",FlowItem.actorCPT,1,"internal_lights_test",
	-- function () return sysGeneral.lightTest:getStatus() == 1 end))

-- preflightCPTProc:addItem(SimpleProcedureItem:new("EFIS control panel"))
-- preflightCPTProc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",FlowItem.actorCPT,1,
	-- function () return ((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end )) 
-- preflightCPTProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",FlowItem.actorCPT,1,
	-- function () return sysEFIS.minsResetPilot:getStatus() == 1 and math.ceil(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("arrival:decision") end))
-- preflightCPTProc:addItem(ProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",FlowItem.actorCPT,1,
	-- function () return (sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) end ))
-- preflightCPTProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",FlowItem.actorCPT,1,
	-- function () return (sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end ))
-- preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",FlowItem.actorCPT,1,
	-- function () return (sysGeneral.baroModePilot:getStatus() == 1 and activePrefSet:get("general:baro_mode_hpa") == true) or (sysGeneral.baroModePilot:getStatus() == 0 and activePrefSet:get("general:baro_mode_hpa") == false) end ))
-- preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorCPT,1,
	-- function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end))
-- preflightCPTProc:addItem(ProcedureItem:new("CENTER SWITCH","AS NEEDED",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("RANGE SELECTOR","AS NEEDED",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorCPT,1,
	-- function () return sysEFIS.wxrPilot:getStatus() == 0 end))
-- preflightCPTProc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",FlowItem.actorCPT,1))

-- preflightCPTProc:addItem(SimpleProcedureItem:new("Mode control panel"))
-- preflightCPTProc:addItem(ProcedureItem:new("COURSE(S)","SET",FlowItem.actorCPT,1,
	-- function () return math.floor(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") and math.floor(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end))
-- preflightCPTProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",FlowItem.actorCPT,1,
	-- function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end))
-- preflightCPTProc:addItem(ProcedureItem:new("BANK ANGLE SELECTOR","AS NEEDED",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",FlowItem.actorCPT,1,
	-- function () return sysMCP.discAPSwitch:getStatus() == 0 end))

-- preflightCPTProc:addItem(SimpleProcedureItem:new("Main panel"))
-- preflightCPTProc:addItem(ProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("CLOCK","SET",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",FlowItem.actorCPT,1))

-- preflightCPTProc:addItem(SimpleProcedureItem:new("Display select panel"))
-- preflightCPTProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorFO,2,
	-- function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	-- function () sysGeneral.displayUnitsFO:adjustValue(0,-1,3) sysGeneral.displayUnitsCPT:adjustValue(0,-1,3) end))
-- preflightCPTProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorFO,2,
	-- function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,
	-- function () sysGeneral.lowerDuFO:adjustValue(0,-1,1) sysGeneral.lowerDuCPT:adjustValue(0,-1,1) end))
-- preflightCPTProc:addItem(ProcedureItem:new("INTEGRATED STANDBY FLIGHT DISPLAY","SET",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",FlowItem.actorCPT,1,
	-- function () return sysControls.spoilerLever:getStatus() == 0 end))
-- preflightCPTProc:addItem(ProcedureItem:new("REVERSE THRUST LEVERS","DOWN",FlowItem.actorCPT,1,
	-- function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end))
-- preflightCPTProc:addItem(ProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",FlowItem.actorCPT,1,
	-- function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end))
-- preflightCPTProc:addItem(ProcedureItem:new("FLAP LEVER","SET",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(SimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
-- preflightCPTProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,1,
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
-- preflightCPTProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,1,
	-- function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
-- preflightCPTProc:addItem(ProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(ProcedureItem:new("RADIO TUNING PANEL","SET",FlowItem.actorCPT,1))
-- preflightCPTProc:addItem(SimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))

-- old checklist
-- =============== BEFORE START CHECKLIST ==============
-- FLIGHT DECK PREPARATION. . . . . . . . . . . . . . . COMPLETED
-- LIGHT TEST . . . . . . . . . . . . . . . . . . . . . CHECKED
-- OXYGEN & INTERPHONE . . . . . . . . . . . . . . . . .CHECKED
-- YAW DAMPER. . . . . . . . . . . . . . . . . . . . . .ON
-- NAVIGATION TRANSFER AND DISPLAY SWITCHES . . . . . . AUTO & NORMAL
-- FUEL . . . . . . . . . . . . . . . . . . . . . . . . _____KGS & PUMPS ON
-- GALLEY POWER . . . . . . . . . . . . . . . . . . . . ON
-- EMERGENCY EXIT LIGHTS. . . . . . . . . . . . . . . . ARMED
-- PASSENGER SIGNS. . . . . . . . . . . . . . . . . . . SET
-- WINDOW HEAT . . . . . . . . . . . . . . . . . . . . .ON
-- HYDRAULICS . . . . . . . . . . . . . . . . . . . . . NORMAL
-- AIR COND & PRESS. . . . . . . .......................___ PACK(S), BLEEDS ON, SET
-- AUTOPILOTS . . . . . . . . . . . . . . . . . . . . . DISENGAGED
-- INSTRUMENTS . . . . . . . . . . . . . . . . . . . . .X-CHECKED
-- AUTOBRAKE. . . . . . . . . . . . . . . . . . . . . . RTO
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . . . .DOWN DETENT
-- PARKING BRAKE . . . . . . . . . . . . . . . . . . . .SET
-- STABILIZER TRIM CUTOUT SWITCHES. . . . . . . . . . ..NORMAL
-- WHEEL WELL FIRE WARNING . . . . . . . . . . . . . . .CHECKED
-- RADIOS, RADAR, TRANSPONDER & HUD . . . . . . . . . . SET
-- RUDDER & AILERON TRIM . . . . . . . . . . . . . . . .FREE & ZERO
-- PAPERS. . . . . . . . . . . . . . . . . . . . . . . .ABOARD
-- FMC/CDU. . . . . . . . . . . . . . . . . . . . . . . SET
-- N1 & IAS BUGS. . . . . . . . . . . . . . . . . . . . SET


-- ============== PREFLIGHT CHECKLIST (PM) ============= OK
-- OXYGEN..............................TESTED, 100% (PF)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO (PF)
-- WINDOW HEAT...................................ON (PF)
-- PRESSURIZATION MODE SELECTOR................AUTO (PF)
-- PARKING BRAKE................................SET (PF)
-- ENGINE START LEVERS.......................CUTOFF (PF)
-- GEAR PINS................................REMOVED (PF)

-- local preflightChkl = Checklist:new("PREFLIGHT CHECKLIST (PM)")
-- preflightChkl:addItem(IndirectChecklistItem:new("OXYGEN","TESTED #exchange|100 PERC|one hundred percent#",FlowItem.actorALL,2,"oxygentested",
	-- function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
-- preflightChkl:addItem(ChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",FlowItem.actorPF,1,
	-- function () return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end))
-- preflightChkl:addItem(ChecklistItem:new("WINDOW HEAT","ON",FlowItem.actorPF,1,
	-- function () return sysAice.windowHeatGroup:getStatus() == 4 end))
-- preflightChkl:addItem(ChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorPF,1,
	-- function () return sysAir.pressModeSelector:getStatus() == 0 end))
-- preflightChkl:addItem(ChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",FlowItem.actorBOTH,3))
-- preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorPF,1,
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))
-- preflightChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorPF,1,
	-- function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
-- preflightChkl:addItem(ChecklistItem:new("GEAR PINS","REMOVED",FlowItem.actorPF,1))
-- preflightChkl:addItem(SimpleChecklistItem:new("Preflight Checklist Completed"))

-- ============= BEFORE START PROCEDURE (BOTH) ============
-- FLIGHT DECK DOOR..............CLOSED AND LOCKED (F/O)
-- CDU DISPLAY.................................SET (BOTH)
-- N1 BUGS...................................CHECK (BOTH)
-- IAS BUGS....................................SET (BOTH)
-- Set MCP
--   AUTOTHROTTLE ARM SWITCH...................ARM (CPT)
--   IAS/MACH SELECTOR......................SET V2 (CPT)
--   LNAV............................ARM AS NEEDED (CPT)
--   VNAV............................ARM AS NEEDED (CPT)
--   INITIAL HEADING...........................SET (CPT)
--   INITIAL ALTITUDE..........................SET (CPT)
-- TAXI AND TAKEOFF BRIEFINGS.............COMPLETE (BOTH)
-- EXTERIOR DOORS....................VERIFY CLOSED (F/O)
-- START CLEARANCE..........................OBTAIN (BOTH)
--   Obtain a clearance to pressurize hydraulic systems.
--   Obtain a clearance to start engines.
-- Set Fuel panel
--   CENTER FUEL PUMPS SWITCHES.................ON (F/O)
--     If center tank quantity exceeds 1,000 lbs/460 kgs
--   AFT AND FORWARD FUEL PUMPS SWITCHES........ON (F/O)
-- Set Hydraulic panel
--   ENGINE HYDRAULIC PUMP SWITCHES............OFF (F/O)
--   ELECTRIC HYDRAULIC PUMP SWITCHES...........ON (F/O)
-- ANTI COLLISION LIGHT SWITCH..................ON (F/O)
-- Set Trim
--   STABILIZER TRIM.....................___ UNITS (CPT)
--   AILERON TRIM..........................0 UNITS (CPT)
--   RUDDER TRIM...........................0 UNITS (CPT)
-- Call for Before Start Checklist

-- local beforeStartProc = Procedure:new("BEFORE START PROCEDURE (BOTH)")
-- beforeStartProc:addItem(ProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",FlowItem.actorFO,2,
	-- function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	-- function () sysGeneral.cockpitDoor:actuate(0) end))
-- beforeStartProc:addItem(ProcedureItem:new("CDU DISPLAY","SET",FlowItem.actorBOTH,1))
-- beforeStartProc:addItem(ProcedureItem:new("N1 BUGS","CHECK",FlowItem.actorBOTH,1))
-- beforeStartProc:addItem(ProcedureItem:new("IAS BUGS","SET",FlowItem.actorBOTH,2,
	-- function () return sysFMC.noVSpeeds:getStatus() == 0 end))
-- beforeStartProc:addItem(SimpleProcedureItem:new("Set MCP"))
-- beforeStartProc:addItem(ProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",FlowItem.actorCPT,2,
	-- function () return sysMCP.athrSwitch:getStatus() == 1 end,
	-- function () sysMCP.athrSwitch:actuate(modeOn) end))
-- beforeStartProc:addItem(ProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorCPT,2,
	-- function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end))
-- beforeStartProc:addItem(ProcedureItem:new("  LNAV","ARM",FlowItem.actorCPT,2,
	-- function () return sysMCP.lnavSwitch:getStatus() == 1 end, 
	-- function () sysMCP.lnavSwitch:actuate(modeOn) end,
	-- function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
-- beforeStartProc:addItem(ProcedureItem:new("  VNAV","ARM",FlowItem.actorCPT,2,
	-- function () return sysMCP.vnavSwitch:getStatus() == 1 end, 
	-- function () sysMCP.vnavSwitch:actuate(modeOn) end,
	-- function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
-- beforeStartProc:addItem(ProcedureItem:new("  INITIAL HEADING","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,2,
	-- function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	-- function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end ))
-- beforeStartProc:addItem(ProcedureItem:new("  INITIAL ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,2,
	-- function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	-- function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end ))
-- beforeStartProc:addItem(ProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS","COMPLETE",FlowItem.actorBOTH,1))
-- beforeStartProc:addItem(ProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",FlowItem.actorFO,1,
	-- function () return sysGeneral.doorGroup:getStatus() == 0 end,
	-- function () sysGeneral.doorGroup:actuate(0) end))
-- beforeStartProc:addItem(ProcedureItem:new("START CLEARANCE","OBTAIN",FlowItem.actorBOTH,1))
-- beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to pressurize hydraulic systems."))
-- beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to start engines."))
-- beforeStartProc:addItem(SimpleProcedureItem:new("Set Fuel panel"))
-- beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	-- function () sysFuel.ctrFuelPumpGroup:actuate(1) end,
	-- function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
-- beforeStartProc:addItem(SimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	-- function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
-- beforeStartProc:addItem(ProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	-- function () sysFuel.wingFuelPumpGroup:actuate(1) end,
	-- function () return sysFuel.centerTankLbs:getStatus() > 999 end))
-- beforeStartProc:addItem(ProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	-- function () sysFuel.allFuelPumpGroup:actuate(1) end,
	-- function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
-- beforeStartProc:addItem(SimpleProcedureItem:new("Set Hydraulic panel"))
-- beforeStartProc:addItem(ProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",FlowItem.actorFO,2,
	-- function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	-- function () sysHydraulic.engHydPumpGroup:actuate(0) end))
-- beforeStartProc:addItem(ProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",FlowItem.actorFO,2,
	-- function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	-- function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
-- beforeStartProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",FlowItem.actorFO,2,
	-- function () return sysLights.beaconSwitch:getStatus() == 1 end,
	-- function () sysLights.beaconSwitch:actuate(1) end))
-- beforeStartProc:addItem(SimpleProcedureItem:new("Set Trim"))
-- beforeStartProc:addItem(ProcedureItem:new("  STABILIZER TRIM","___ UNITS",FlowItem.actorCPT,1)) --******
-- beforeStartProc:addItem(ProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",FlowItem.actorCPT,2,
	-- function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	-- function () sysControls.aileronTrimSwitch:setValue(0) end))
-- beforeStartProc:addItem(ProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",FlowItem.actorCPT,2,
	-- function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	-- function () sysControls.rudderTrimSwitch:setValue(0) end))
-- beforeStartProc:addItem(SimpleProcedureItem:new("Call for Before Start Checklist"))


-- – – – – – – – – – – CLEARED FOR START – – – – – – – – –
-- MOBILE PHONES. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- DOORS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .CLOSED
-- AIR CONDITIONING PACKS . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ANTICOLLISION LIGHT . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

-- ============ BEFORE START CHECKLIST (F/O) ============
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED (CPT)
-- FUEL..........................9999 KGS, PUMPS ON (CPT)
-- PASSENGER SIGNS..............................SET (CPT)
-- WINDOWS...................................LOCKED (CPT)
-- MCP...................V2 999, HDG 999, ALT 99999 (CPT)
-- TAKEOFF SPEEDS............V1 999, VR 999, V2 999 (CPT)
-- CDU PREFLIGHT..........................COMPLETED (CPT)
-- RUDDER & AILERON TRIM.................FREE AND 0 (CPT)
-- TAXI AND TAKEOFF BRIEFING..            COMPLETED (CPT)

-- local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST (F/O)")
-- beforeStartChkl:addItem(ChecklistItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",FlowItem.actorCPT,2,
	-- function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	-- function () sysGeneral.cockpitDoor:actuate(0) end))
-- beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",FlowItem.actorCPT,1,
	-- function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	-- function () sysFuel.wingFuelPumpGroup:actuate(1) end,
	-- function () return sysFuel.centerTankLbs:getStatus() > 999 end))
-- beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",FlowItem.actorCPT,1,
	-- function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	-- function () sysFuel.allFuelPumpGroup:actuate(1) end,
	-- function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
-- beforeStartChkl:addItem(ChecklistItem:new("PASSENGER SIGNS","SET",FlowItem.actorCPT,2,
	-- function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	-- function () sysGeneral.seatBeltSwitch:adjustValue(1,0,2)  sysGeneral.noSmokingSwitch:adjustValue(1,0,2) end))
-- beforeStartChkl:addItem(FlowItem:new("WINDOWS","LOCKED",FlowItem.actorBOTH,2))
-- beforeStartChkl:addItem(ChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|sysFMC.V2:getStatus()|sysMCP.hdgSelector:getStatus()|sysMCP.altSelector:getStatus()",FlowItem.actorCPT,2,
	-- function () return sysMCP.iasSelector:getStatus() == sysFMC.V2:getStatus() and sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") and sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end))
-- beforeStartChkl:addItem(ChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|sysFMC.V1:getStatus()|sysFMC.Vr:getStatus()|sysFMC.V2:getStatus()",FlowItem.actorBOTH,2))
-- beforeStartChkl:addItem(ChecklistItem:new("CDU PREFLIGHT","COMPLETED",FlowItem.actorCPT,1))
-- beforeStartChkl:addItem(ChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",FlowItem.actorCPT,1,
	-- function () return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end ))
-- beforeStartChkl:addItem(ChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",FlowItem.actorCPT,1))

-- =========== PUSHBACK & ENGINE START (BOTH) ==========
-- PARKING BRAKE...............................SET (F/O)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND.............ESTABLISH (CPT)
-- PARKING BRAKE..........................RELEASED (F/O)
-- When pushback/towing complete
--   TOW BAR DISCONNECTED...................VERIFY (CPT)
--   LOCKOUT PIN REMOVED....................VERIFY (CPT)
--   SYSTEM A HYDRAULIC PUMPS...................ON (F/O)
-- Call START ENGINE 2
-- ENGINE START SWITCH 2.......................GRD (F/O)
--   Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- ENGINE START LEVER 2.......................IDLE (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- Call START ENGINE 1
-- ENGINE START SWITCH 1.......................GRD (F/O)
--   Verify that the N2 RPM increases.
-- When N1 rotation is seen and N2 is at 25%,
-- ENGINE START LEVER 1.......................IDLE (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- Next BEFORE TAXI PROCEDURE

-- local pushstartProc = Procedure:new("PUSHBACK & ENGINE START (BOTH)")
-- pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,2,"pb_parkbrk_initial_set",
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	-- function () sysGeneral.parkBrakeSwitch:actuate(1) end ))
-- pushstartProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing"))
-- pushstartProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2))
-- pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,2,"pb_parkbrk_release",
	-- function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	-- function () sysGeneral.parkBrakeSwitch:actuate(0) end))
-- pushstartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete"))
-- pushstartProc:addItem(ProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,1))
-- pushstartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,1))
-- pushstartProc:addItem(ProcedureItem:new("  SYSTEM A HYDRAULIC PUMPS","ON",FlowItem.actorFO,1,
	-- function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.elecHydPump1:getStatus() == 1 end,
	-- function () sysHydraulic.engHydPump1:actuate(1) sysHydraulic.elecHydPump1:actuate(1) end))
-- pushstartProc:addItem(SimpleProcedureItem:new("Call START ENGINE 2"))
-- pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH 2","GRD",FlowItem.actorFO,2,"eng_start_2_grd",
	-- function () return sysEngines.engStart2Switch:getStatus() == 0 end ))
-- pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
-- pushstartProc:addItem(SimpleProcedureItem:new("When N1 rotation is seen and N2 is at 25%,"))
-- pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START LEVER 2","IDLE",FlowItem.actorFO,2,"eng_start_2_lever",
	-- function () return sysEngines.startLever2:getStatus() == 1 end ))
-- pushstartProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
-- pushstartProc:addItem(SimpleProcedureItem:new("Call START ENGINE 1"))
-- pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH 1","GRD",FlowItem.actorFO,2,"eng_start_1_grd",
	-- function () return sysEngines.engStart1Switch:getStatus() == 0 end ))
-- pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
-- pushstartProc:addItem(SimpleProcedureItem:new("When N1 rotation is seen and N2 is at 25%,"))
-- pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START LEVER 1","IDLE",FlowItem.actorFO,2,"eng_start_1_lever",
	-- function () return sysEngines.startLever1:getStatus() == 1 end ))
-- pushstartProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
-- pushstartProc:addItem(SimpleProcedureItem:new("Next BEFORE TAXI PROCEDURE"))


-- ============ BEFORE TAXI PROCEDURE (F/O) ============
-- GENERATOR 1 AND 2 SWITCHES...................ON (F/O)
-- PROBE HEAT SWITCHES..........................ON (F/O)
-- WING ANTI-ICE SWITCH..................AS NEEDED (F/O)
-- ENGINE ANTI-ICE SWITCHES..............AS NEEDED (F/O)
-- PACK SWITCHES..............................AUTO (F/O)
-- ISOLATION VALVE SWITCH.....................AUTO (F/O)
-- APU BLEED AIR SWITCH........................OFF (F/O)
-- APU SWITCH..................................OFF (F/O)
-- ENGINE START SWITCHES......................CONT (F/O)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- Verify that the ground equipment is clear.
-- Call 'FLAPS ___' as needed for takeoff.         (CPT)
-- FLAP LEVER....................SET TAKEOFF FLAPS (F/O)
-- LE FLAPS EXT GREEN LIGHT............ILLUMINATED (BOTH)
-- FLIGHT CONTROLS...........................CHECK (CPT)
-- TRANSPONDER...........................AS NEEDED (F/O)
-- RECALL....................................CHECK (BOTH)
--   Verify annunciators illuminate and then extinguish.
-- Call BEFORE TAXI CHECKLIST

-- local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE (F/O)")
-- beforeTaxiProc:addItem(ProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",FlowItem.actorFO,1,
	-- function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	-- function () sysElectric.genSwitchGroup:actuate(modeOn) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","ON",FlowItem.actorFO,1,
	-- function () return sysAice.probeHeatASwitch:getStatus() == 1 and sysAice.probeHeatBSwitch:getStatus() == 1 end,
	-- function () sysAice.probeHeatASwitch:actuate(modeOn) sysAice.probeHeatBSwitch:actuate(modeOn) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","AS NEEDED",FlowItem.actorFO,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","AS NEEDED",FlowItem.actorFO,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("PACK SWITCHES","AUTO",FlowItem.actorFO,1,
	-- function () return sysAir.packLeftSwitch:getStatus() == 1 and sysAir.packRightSwitch:getStatus() == 1 end,
	-- function () sysAir.packLeftSwitch:actuate(modeOn) sysAir.packRightSwitch:actuate(modeOn) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",FlowItem.actorFO,1,
	-- function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	-- function () sysAir.isoValveSwitch:actuate(modeOn) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","OFF",FlowItem.actorFO,1,
	-- function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	-- function () sysAir.apuBleedSwitch:actuate(modeOff) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("APU SWITCH","OFF",FlowItem.actorFO,1,
	-- function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	-- function () sysElectric.apuStartSwitch:adjustValue(modeOff) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorFO,1,
	-- function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	-- function () sysEngines.engStarterGroup:actuate(cmdUp) end))
-- beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",FlowItem.actorCPT,2,
	-- function () return sysEngines.startLeverGroup:getStatus() == 2 end,
	-- function () sysEngines.startLeverGroup:actuate(cmdUp) end))
-- beforeTaxiProc:addItem(SimpleProcedureItem:new("Verify that the ground equipment is clear."))
-- beforeTaxiProc:addItem(SimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
-- beforeTaxiProc:addItem(ProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",FlowItem.actorFO,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",FlowItem.actorBOTH,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("FLIGHT CONTROLS","CHECK",FlowItem.actorCPT,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","AS NEEDED",FlowItem.actorFO,1))
-- beforeTaxiProc:addItem(ProcedureItem:new("Recall","CHECK",FlowItem.actorBOTH,1))
-- beforeTaxiProc:addItem(SimpleProcedureItem:new("  Verify annunciators illuminate and then extinguish."))
-- beforeTaxiProc:addItem(SimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

-- AFTER START
-- ELECTRICAL . . . . . . . . . . . . . . . . . . . . . . . .GENERATORS ON
-- PROBE HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON
-- ANTI–ICE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- AIR COND & PRESS . . . . . . . . . . . . . . . . . . . . . . . . PACKS ON
-- ISOLATION VALVE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AUTO
-- APU . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- START LEVERS . . . . . . . . . . . . . . . . . . . . . . . . . .IDLE DETENT

-- ============ BEFORE TAXI CHECKLIST (F/O) ============
-- GENERATORS...................................ON (CPT)
-- PROBE HEAT...................................ON (CPT)
-- ANTI-ICE............................AS REQUIRED (CPT)
-- ISOLATION VALVE............................AUTO (CPT)
-- ENGINE START SWITCHES......................CONT (CPT)
-- RECALL..................................CHECKED (CPT)
-- AUTOBRAKE...................................RTO (CPT)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- FLIGHT CONTROLS.........................CHECKED (CPT)
-- GROUND EQUIPMENT..........................CLEAR (BOTH)
-- Next BEFORE TAKEOFF CHECKLIST

-- local beforeTaxiChkl = Checklist:new("BEFORE TAXI CHECKLIST (F/O)")
-- beforeTaxiChkl:addItem(ChecklistItem:new("GENERATORS","ON",ChecklistItem.actorCPT,1,
	-- function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	-- function () sysElectric.gen1Switch:actuate(1) sysElectric.gen2Switch:actuate(1)	end ))
-- beforeTaxiChkl:addItem(ChecklistItem:new("PROBE HEAT","ON",ChecklistItem.actorCPT,2,
	-- function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	-- function () sysAice.probeHeatGroup:actuate(1) end))
-- beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","AS REQUIRED",ChecklistItem.actorCPT,1))
-- beforeTaxiChkl:addItem(ChecklistItem:new("ISOLATION VALVE","AUTO",ChecklistItem.actorCPT,2,
	-- function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	-- function () sysAir.trimAirSwitch:actuate(modeOn) end))
-- beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",ChecklistItem.actorCPT,2,
	-- function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	-- function () sysEngines.engStarterGroup:adjustValue(2,0,3) end)) 
-- beforeTaxiChkl:addItem(ChecklistItem:new("RECALL","CHECKED",ChecklistItem.actorCPT,1))
-- beforeTaxiChkl:addItem(ChecklistItem:new("AUTOBRAKE","RTO",ChecklistItem.actorCPT,2,
	-- function () return sysGeneral.autobreak:getStatus() == 0 end,
	-- function () sysGeneral.autobreak:actuate(0) end))
-- beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",ChecklistItem.actorCPT,2,
	-- function () return sysEngines.startLeverGroup:getStatus() == 2 end))
-- beforeTaxiChkl:addItem(ChecklistItem:new("FLIGHT CONTROLS","CHECKED",ChecklistItem.actorCPT,1))
-- beforeTaxiChkl:addItem(ChecklistItem:new("GROUND EQUIPMENT","CLEAR",ChecklistItem.actorBOTH,1))
-- beforeTaxiChkl:addItem(SimpleChecklistItem:new("Next BEFORE TAKEOFF CHECKLIST"))

-- BEFORE TAKEOFF
-- RECALL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .CHECKED
-- FLIGHT CONTROLS. . . . . . . . . . . . . . . . . . . . . . . . . .CHECKED
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . _____, GREEN LIGHT
-- STABILIZER TRIM . . . . . . . . . . . . . . . . . . . . . . . . . _____UNITS
-- CABIN DOOR . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .LOCKED
-- TAKEOFF BRIEFING . . . . . . . . . . . . . . . . . . . . . . . .REVIEWED
-- – – – – – – – – – CLEARED FOR TAKEOFF – – – – – – – –
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . . .ON
-- TRANSPONDER . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

-- ============ BEFORE TAKEOFF CHECKLIST (F/O) ============
-- GENERATORS...................................ON (CPT)
-- TAKEOFF BRIEFING.......................REVIEWED (CPT)
-- FLAPS...........................__, GREEN LIGHT (CPT)
-- STABILIZER TRIM...................... ___ UNITS (CPT)
-- CABIN....................................SECURE (CPT)
-- Next RUNWAY ENTRY PROCEDURE

-- local beforeTakeoffChkl = Checklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
-- beforeTakeoffChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorCPT,1))
-- beforeTakeoffChkl:addItem(ChecklistItem:new("FLAPS","GREEN LIGHT",ChecklistItem.actorCPT,1))
-- beforeTakeoffChkl:addItem(ChecklistItem:new("STABILIZER TRIM","___ UNITS",ChecklistItem.actorCPT,1))
-- beforeTakeoffChkl:addItem(ChecklistItem:new("CABIN","SECURE",ChecklistItem.actorCPT,1))
-- beforeTakeoffChkl:addItem(SimpleChecklistItem:new("Next RUNWAY ENTRY PROCEDURE"))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)
-- Next TAKEOFF AND INITIAL CLIMB 

-- local runwayEntryProc = Procedure:new("RUNWAY ENTRY PROCEDURE (F/O)")
-- runwayEntryProc:addItem(ChecklistItem:new("STROBES","ON",ChecklistItem.actorFO,2,
	-- function () return sysLights.strobesSwitch:getStatus() == 1 end,
	-- function () sysLights.strobesSwitch:actuate(1) end))
-- runwayEntryProc:addItem(ChecklistItem:new("TRANSPONDER","ON",ChecklistItem.actorFO,2,
	-- function () return sysRadios.xpdrSwitch:getStatus() == 5 end,
	-- function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrTARA,0,5) end))
-- runwayEntryProc:addItem(ChecklistItem:new("LANDING LIGHTS","ON",ChecklistItem.actorCPT,2,
	-- function () return sysLights.landLightGroup:getStatus() > 1 end,
	-- function () sysLights.landLightGroup:actuate(1) end))
-- runwayEntryProc:addItem(ChecklistItem:new("RWY TURNOFF LIGHTS","ON",ChecklistItem.actorCPT,2,
	-- function () return sysLights.rwyLightGroup:getStatus() > 0 end,
	-- function () sysLights.rwyLightGroup:actuate(1) end))
-- runwayEntryProc:addItem(ChecklistItem:new("TAXI LIGHTS","OFF",ChecklistItem.actorCPT,2,
	-- function () return sysLights.taxiSwitch:getStatus() == 0 end,
	-- function () sysLights.taxiSwitch:actuate(0) end))
-- runwayEntryProc:addItem(SimpleChecklistItem:new("Next TAKEOFF AND INITIAL CLIMB"))

-- ============ start and initial climb =============
-- local takeoffClimbProc = Procedure:new("TAKEOFF & INITIAL CLIMB")
	-- [2] = {["activity"] = "A/T -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "SET A/P MODES", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "SET TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "SETTING TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "FLAPS 10", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "SPEED CHECK FLAPS 10", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "FLAPS 5", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "SPEED CHECK FLAPS 5", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "FLAPS 1", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "SPEED CHECK FLAPS 1", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "CMD A", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [15] = {["activity"] = "SETTING CMD A", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,

-- AFTER TAKEOFF
-- AIR COND & PRESS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .SET
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- LANDING GEAR. . . . . . . . . . . . . . . . . . . . . . . . . . . . .UP & OFF
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . UP, NO LIGHTS

-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- TAKEOFF BRIEFING.......................REVIEWED (PM)
-- ENGINE BLEEDS................................ON (PM)
-- PACKS......................................AUTO (PM)
-- LANDING GEAR.........................UP AND OFF (PM)
-- FLAPS.............................UP, NO LIGHTS (PM)
-- ALTIMETERS..................................SET (BOTH)
-- Next CLIMB & CRUISE

-- ======= After Takeoff checklist =======

-- local afterTakeoffChkl = Checklist:new("AFTER TAKEOFF CHECKLIST (PM)")
-- afterTakeoffChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorPM,1))
-- afterTakeoffChkl:addItem(ChecklistItem:new("ENGINE BLEEDS","ON",ChecklistItem.actorPM,2,
	-- function () return sysAir.engBleedGroup:getStatus() == 2 end,
	-- function () sysAir.engBleedGroup:actuate(1) end))
-- afterTakeoffChkl:addItem(ChecklistItem:new("PACKS","AUTO",ChecklistItem.actorPM,2,
	-- function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	-- function () sysAir.packSwitchGroup:setValue(1) end))
-- afterTakeoffChkl:addItem(ChecklistItem:new("LANDING GEAR","UP AND OFF",ChecklistItem.actorPM,2,
	-- function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	-- function () sysGeneral.GearSwitch:setValue(0.5) end))
-- afterTakeoffChkl:addItem(ChecklistItem:new("FLAPS","UP, NO LIGHTS",ChecklistItem.actorPM,2,
	-- function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	-- function () sysControls.flapsSwitch:adjustValue(0) end))
-- afterTakeoffChkl:addItem(ChecklistItem:new("ALTIMETERS","SET",ChecklistItem.actorBOTH,1))
-- afterTakeoffChkl:addItem(SimpleChecklistItem:new("Next CLIMB & CRUISE"))

-- ============ climb & cuise =============
-- local climbCruiseProc = Procedure:new("CLIMB & CRUISE")

-- If the center tank fuel pump switches were OFF for takeoff and the center tank contains more than 1000 pounds/500 kilograms, set both center tank fuel pump switches ON above 10,000 feet or after the pitch attitude has been reduced to begin acceleration to a climb speed of 250 knots or greater.
-- During climb, set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 1000 pounds/500 kilograms.
-- At or above 10,000 feet MSL, set the LANDING light switches to OFF.
-- Set the passenger signs as needed.
-- At transition altitude, set and crosscheck the altimeters to standard.
-- When established in a level attitude at cruise, if the center tank contains more than 1000 pounds/500 kilograms and the center tank fuel pump switches are OFF, set the center tank fuel pump switches ON again.
-- Set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 1000 pounds/500 kilograms.
-- During an ETOPS flight, additional steps must be done. See the ETOPS supplementary procedure in SP.1.
-- Before the top of descent, modify the active route as needed for the arrival and approach.
-- Verify or enter the correct RNP for arrival.


-- ============ descent =============
-- local descentProc = Procedure:new("DESCENT PROCEDURE")

-- Set both center tank fuel pump switches OFF when center tank fuel quantity reaches approximately 3000 pounds/1400 kilograms.
-- Verify that pressurization is set to landing altitude.
-- Review the system annunciator lights.
-- Recall and review the system annunciator lights.
-- Verify VREF on the APPROACH REF page.
-- Enter VREF on the APPROACH REF page.
-- Set the RADIO/BARO minimums as needed for the approach.
-- Set or verify the navigation radios and course for the approach.
-- Set the AUTO BRAKE select switch to the needed brake setting
-- Do the approach briefing.
-- Call “DESCENT CHECKLIST.”Do the DESCENT checklist.
-- ======= Descent checklist =======


-- DESCENT – APPROACH
-- ANTI–ICE. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- AIR COND & PRESS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .SET
-- ALTIMETER & INSTRUMENTS . . . . . . . . SET & X–CHECKED
-- N1 & IAS BUGS. . . . . . . . . . . . . . . . . . . . . . . .CHECKED & SET

-- local descentChkl = Checklist:new("DESCENT CHECKLIST (PM)")
-- descentChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorPM,nil))
-- descentChkl:addItem(ChecklistItem:new("PRESSURISATION","LAND ALT___",ChecklistItem.actorPM,nil))
-- descentChkl:addItem(ChecklistItem:new("RECALL","CHECKED",ChecklistItem.actorPM,nil))
-- descentChkl:addItem(ChecklistItem:new("AUTOBRAKE","___",ChecklistItem.actorPM,nil))
-- descentChkl:addItem(ChecklistItem:new("LANDING DATA","VREF___, MINIMUMS___",ChecklistItem.actorBOTH,nil))
-- descentChkl:addItem(ChecklistItem:new("APPROACH BRIEFING","COMPLETED",ChecklistItem.actorPM,nil))

-- ======= Approach checklist =======

-- local approachChkl = Checklist:new("APPROACH CHECKLIST (PM)")
-- approachChkl:addItem(ChecklistItem:new("ALTIMETERS","QNH ___",ChecklistItem.actorBOTH,nil))
-- approachChkl:addItem(ChecklistItem:new("NAV AIDS","SET",ChecklistItem.actorPM,nil))

-- ======= Landing checklist =======
-- LANDING
-- ENGINE START SWITCHES. . . . . . . . . . . . . . . . . . . . . . . . .ON
-- RECALL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . CHECKED
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . .ARMED,GREEN LIGHT
-- LANDING GEAR. . . . . . . . . . . . . . . . . . . . . . .DOWN, 3 GREEN
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . _____, GREEN LIGHT

-- local landingChkl = Checklist:new("LANDING CHECKLIST (PM)")
-- landingChkl:addItem(ChecklistItem:new("CABIN","SECURE",ChecklistItem.actorPF,nil))
-- landingChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",ChecklistItem.actorPF,nil))
-- landingChkl:addItem(ChecklistItem:new("SPEEDBRAKE","ARMED",ChecklistItem.actorPF,nil))
-- landingChkl:addItem(ChecklistItem:new("LANDING GEAR","DOWN",ChecklistItem.actorPF,nil))
-- landingChkl:addItem(ChecklistItem:new("FLAPS","___, GREEN LIGHT",ChecklistItem.actorPF,nil))

-- ============ after landing =============
-- local afterLandingProc = Procedure:new("AFTER LANDING PROCEDURE")
	-- [2] = {["activity"] = "SPEED BRAKES -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "CHRONO and ET -- STOP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "WX RADAR -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "APU -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "FLAPS -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "PROBE HEAT -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "STROBES -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "LANDING LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "TAXI LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "ENGINE START SWITCHES -- AUTO", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "TRAFFIC -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "AUTOBRAKE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "TRANSPONDER -- STBY", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,



-- ============ shutdown =============
-- local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE")
-- Start the Shutdown Procedure after taxi is complete.
-- Parking brake...Set CAPT
--   Verify that the parking brake warning light is illuminated.
-- Electrical power...Set F/O
--   If APU power is needed:
-- 	   Verify that the APU GENERATOR OFF BUS light is illuminated.
--     APU GENERATOR bus switches – ON
--     Verify that the SOURCE OFF lights are extinguished.
--   If external power is needed:
--     Verify that the GRD POWER AVAILABLE light is illuminated.
--     GRD POWER switch – ON
--     Verify that the SOURCE OFF lights are extinguished.
-- Engine start levers...CUTOFF CAPT
-- FASTEN BELTS switch...OFF F/O
-- ANTI COLLISION light switch...OFF F/O
-- FUEL PUMP switches...OFF F/O
-- CAB/UTIL power switch...As needed F/O
-- IFE/PASS SEAT power switch...As needed F/O
-- WING ANTI–ICE switch...OFF F/O
-- ENGINE ANTI–ICE switches....OFF F/O
-- Hydraulic panel....Set F/O
-- ENGINE HYDRAULIC PUMPS switches - ON
-- ELECTRIC HYDRAULIC PUMPS switches - OFF
-- RECIRCULATION FAN switches....As needed F/O
-- Air conditioning PACK switches....AUTO F/O
-- ISOLATION VALVE switch.... OPEN F/O
-- Engine BLEED air switches....ON F/O
-- APU BLEED air switch....ON F/O
-- Exterior lights switches....As needed F/O
-- FLIGHT DIRECTOR switches....OFF F/O
-- Transponder mode selector....STBY F/O
-- After the wheel chocks are in place: Parking brake – Release C or F/O
-- APU switch....As needed F/O
-- Call “SHUTDOWN CHECKLIST.
	-- [2] = {["activity"] = "TAXI LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [3] = {["activity"] = "SHUTDOWN ENGINES!", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [4] = {["activity"] = "SHUTTING DOWN ENGINES", ["wait"] = 10, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [5] = {["activity"] = "SEATBELT SIGNS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [6] = {["activity"] = "BEACON -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [7] = {["activity"] = "FUEL PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [8] = {["activity"] = "WING & ENGINE ANTIICE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [9] = {["activity"] = "ELECTRICAL HYDRAULIC PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [10] = {["activity"] = "ISOLATION VALVE -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [11] = {["activity"] = "APU BLEED -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [12] = {["activity"] = "FLIGHT DIRECTORS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [13] = {["activity"] = "RESET MCP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [14] = {["activity"] = "RESET TRANSPONDER", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [15] = {["activity"] = "DOORS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	-- [16] = {["activity"] = "RESET ELAPSED TIME", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,



-- ======= Shutdown checklist =======
-- SHUTDOWN
-- FUEL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .PUMPS OFF
-- GALLEY POWER . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- ELECTRICAL . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON_____
-- FASTEN BELTS. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- WINDOW HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- PROBE HEAT . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ANTI–ICE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ELECTRIC HYDRAULIC PUMPS . . . . . . . . . . . . . . . . . . . . .OFF
-- AIR COND . . . . . . . . . . . . . . . . . . . ___ PACK(S), BLEEDS ON
-- EXTERIOR LIGHTS . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- ANTICOLLISION LIGHT . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- ENGINE START SWITCHES . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- AUTOBRAKE . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- SPEED BRAKE . . . . . . . . . . . . . . . . . . . . . . . . . DOWN DETENT
-- FLAPS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . UP, NO LIGHTS
-- PARKING BRAKE . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- START LEVERS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . CUTOFF
-- WEATHER RADAR . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- TRANSPONDER . . . . . . . . . . . . . . . . . . . . . . . . .AS REQUIRED
-- MOBILE PHONES. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .ON

-- local shutdownChkl = Checklist:new("SHUTDOWN CHECKLIST (F/O)")
-- shutdownChkl:addItem(ChecklistItem:new("HYDRAULIC PANEL","SET",ChecklistItem.actorCPT,nil))
-- shutdownChkl:addItem(ChecklistItem:new("PROBE HEAT","AUTO/OFF",ChecklistItem.actorCPT,nil))
-- shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","OFF",ChecklistItem.actorCPT,nil))
-- shutdownChkl:addItem(ChecklistItem:new("FLAPS","UP",ChecklistItem.actorCPT,nil))
-- shutdownChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",ChecklistItem.actorCPT,nil))
-- shutdownChkl:addItem(ChecklistItem:new("WEATHER RADAR","OFF",ChecklistItem.actorBOTH,nil))
-- shutdownChkl:addItem(ChecklistItem:new("PARKING BRAKE","___",ChecklistItem.actorCPT,nil))


-- ============ secure =============
-- local secureProc = Procedure:new("SECURE PROCEDURE")

-- IRS mode selectors....OFF F/O
-- EMERGENCY EXIT LIGHTS switch....OFF F/O
-- WINDOW HEAT switches....OFF F/O
-- Air conditioning PACK switches....OFF F/O

-- ======= Secure checklist =======

-- SECURE
-- IRS MODE SELECTORS . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- EMERGENCY EXIT LIGHTS. . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- AIR CONDITIONING PACKS . . . . . . . . . . . . . . . . . . . . . . .OFF
-- APU/GROUND POWER . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- BATTERY. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF

-- local secureChkl = Checklist:new("SECURE CHECKLIST (F/O)")
-- secureChkl:addItem(ChecklistItem:new("EFBs (if installed)","SHUT DOWN",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("IRSs","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("WINDOW HEAT","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("PACKS","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(SimpleChecklistItem:new(	"If the aircraft is not handed over to succeeding flight"))
-- secureChkl:addItem(SimpleChecklistItem:new(	"crew or maintenance personnel:"))
-- secureChkl:addItem(ChecklistItem:new("  EFB switches (if installed)","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("  APU/GRD PWR","OFF",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("  GROUND SERVICE SWITCH","ON",ChecklistItem.actorCPT))
-- secureChkl:addItem(ChecklistItem:new("  BAT SWITCH","OFF",ChecklistItem.actorCPT))

-- ============ Procedures =============


-- ============ approach =============
-- local approachProc = Procedure:new("APPROACH PROCEDURE")

-- ============ landing =============
-- local landingProc = Procedure:new("LANDING PROCEDURE")


-- ============ Cold & Dark =============

-- local coldAndDarkProc = Procedure:new("SET AIRCRAFT TO COLD & DARK")
-- coldAndDarkProc:addItem(ProcedureItem:new("XPDR","SET 2000","F/O",1,

-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)


-- === States ===
-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("C&D","SET","SYS",0,true,
	function () 
		-- kc_macro_state_cold_and_dark()
		-- electricalPowerUpProc:setState(Flow.NEW)
		-- preFlightProc:setState(Flow.NEW)
		-- getActiveSOP():setActiveFlowIndex(1)
	end))

activeSOP:addState(coldAndDarkProc)

local turnaroundProc = State:new("TURNAROUND STATE","","")
turnaroundProc:setFlightPhase(18)
turnaroundProc:addItem(ProcedureItem:new("START APU","DONE","SYS",2,true,
	function () 
		-- sysElectric.batterySwitch:actuate(1) 
		-- sysElectric.battery2Switch:actuate(1) 
		-- sysElectric.apuMasterSwitch:actuate(1)
		-- command_begin("laminar/CitX/APU/starter_switch_up") 
	end))
turnaroundProc:addItem(ProcedureItem:new("TURNAROUND STATE","SET","SYS",0,true,
	function () 
		-- kc_macro_state_turnaround()
		-- command_once("laminar/CitX/APU/gen_switch_up") 
		-- command_once("laminar/CitX/APU/gen_switch_up") 
		-- command_once("laminar/CitX/APU/bleed_switch_dwn")
		-- command_once("laminar/CitX/APU/bleed_switch_dwn")
		-- command_once("laminar/CitX/APU/bleed_switch_up")
		-- electricalPowerUpProc:setState(Flow.FINISH)
		-- preFlightProc:setState(Flow.FINISH)
		-- getActiveSOP():setActiveFlowIndex(3)
	end))

activeSOP:addState(turnaroundProc)

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")
kc_procvar_initialize_bool("apustart", false) -- B733 apu start
kc_procvar_initialize_bool("ovhttest", false) -- B733 OVHT test

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		if kc_procvar_get("apustart") == true then 
			kc_bck_b733_apustart("apustart")
		end
		if kc_procvar_get("ovhttest") == true then 
			kc_bck_b733_ovht_test("ovhttest")
		end
	end))
	
activeSOP:addBackground(backgroundFlow)

function getActiveSOP()
	return activeSOP
end


return SOP_B733