-- Base SOP Laminar Citation X 750

-- @classmod SOP_C750
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_C750 = {
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

activeSOP = SOP:new("Laminar Citation X SOP")

-- ============ Electrical Power Up Procedure ============
-- All paper work on board and checked
-- == Initial checks
-- STANDBY POWER................................TEST 
-- STANDBY POWER..................................ON		
-- PANEL LIGHTS..........................AS REQUIRED
-- EMERG LT.......................................ON
-- GEN LH & RH...................................OFF
-- EXT PWR...............................AS REQUIRED		
-- BATTERY SWITCH 1 & 2...........................ON		
-- LANDING GEAR HANDLE..........................DOWN
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED
-- FLAP LEVER.....................................UP
-- == APU ON
-- APU SYSTEM MASTER..............................ON		
-- APU TEST.....................................PUSH
-- APU STARTER.......................HOLD TILL START		
-- APU N1 100%.................................READY		
-- APU GEN........................................ON		
-- APU AMPS LESS 200A..........................CHECK		
-- ==
-- AVIONICS SWITCH................................ON		
-- EICAS SWITCH...................................ON		
-- DISPLAYS.......................................ON
-- BATTERIES, 24 VOLTS.........................CHECK
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","","")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("STANDBY POWER","TEST",FlowItem.actorFO,2,"stbytest",
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == -1 end,
	function () 
		command_once("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_begin("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == 1 end,
	function () 
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("PANEL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () 
		kc_macro_int_lights_on()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EMERG LT","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/emerg_light_switch") > 0 end,
	function () command_once("laminar/CitX/lights/emerg_light_switch_up") end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH 1 & 2","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("GEN LH & RH","OFF",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 0 and 
			sysElectric.gen2Switch:getStatus() == 0
	end,
	function ()
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== APU ON"))
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# SYSTEM MASTER","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuMasterSwitch:getStatus() == 1 end,
	function () sysElectric.apuMasterSwitch:actuate(1) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#spell|APU# TEST","PUSH",FlowItem.actorFO,2,"aputest",
	function () return get("laminar/CitX/APU/test_button") == 1 end,
	function () command_begin("laminar/CitX/APU/test_button") end))
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# STARTER","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_starter_switch") > 0 end,
	function () 
		command_end("laminar/CitX/APU/test_button")
		command_begin("laminar/CitX/APU/starter_switch_up") 
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTING",FlowItem.actorFO,0,"apustarting",
	function () return get("sim/cockpit/engine/APU_N1") > 3 end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTED",FlowItem.actorFO,0,"apurunning",
	function () return get("sim/cockpit/engine/APU_N1") == 100 end,
	function () command_end("laminar/CitX/APU/starter_switch_up") end))
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# GEN","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/APU/gen_switch") == 1 end,
	function () 
		command_once("laminar/CitX/APU/gen_switch_up") 
		command_once("laminar/CitX/APU/gen_switch_up") 
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("#spell|APU# AMPS","< 200 A",FlowItem.actorFO,0,"apubelow200",
	function () return get("sim/cockpit/electrical/generator_apu_amps") < 200 end))
electricalPowerUpProc:addItem(ProcedureItem:new("AVIONICS SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.avionicsSwitchGroup:getStatus() == 1 end,
	function () sysElectric.avionicsSwitchGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("EICAS SWITCH","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/avionics_eicas") == 1 end,
	function () 
		if get("laminar/CitX/electrical/avionics_eicas") == 0 then
			command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("DISPLAYS","ON",FlowItem.actorFO,0,
	function () return sysLights.dispLightGroup:getStatus() > 0 end,
	function () sysLights.dispLightGroup:actuate(1) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERIES, 24 VOLTS","CHECK",FlowItem.actorFO,0,"battat24",
	function () 
		return get("sim/cockpit2/electrical/battery_voltage_indicated_volts",0) > 24 and 
			get("sim/cockpit2/electrical/battery_voltage_indicated_volts",1) >24 
	end))
	
-- ===================== PRE FLIGHT ======================
-- NAV LIGHTS.................................... ON		
-- PASSENGER OXYGEN.............................AUTO		
-- OXY PRESSURE........................IN GREEN AREA		
-- FUEL XFER SELECTOR............................OFF		
-- GRVTY XFLOW...................................OFF		
-- CTR WING XFER LH & RH........................NORM		
-- FUEL BOOST BOTH..............................NORM
-- LOAD SHED....................................NORM		
-- IGNITION SWITCHES.............................OFF		
-- FADEC SWITCHES.............................NORMAL		
-- FUEL QUANTITY..................CHECK BAL IN EICAS		
-- PRESSURIZATION SOURCES...................ALL NORM		
-- PRESSURIZATION ALT............................SET
-- FLAP LEVER.....................................UP		
-- ROTARY TEST.................................CHECK		
-- == Flight Preps
--   SETUP FMS
--   GET ATIS
--   GET CLEARANCE
--   T/O BRIEF
--   PFD CONFIG
-- =======================================================

local preFlightProc = Procedure:new("PRE FLIGHT","","")
preFlightProc:setFlightPhase(3)
preFlightProc:addItem(ProcedureItem:new("NAV LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(1) end))
preFlightProc:addItem(ProcedureItem:new("PASSENGER OXYGEN","AUTO",FlowItem.actorFO,0,
	function () return get("laminar/CitX/oxygen/pass_oxy") == 1 end,
	function ()  
		if get("laminar/CitX/oxygen/pass_oxy") == 0 then 
			command_once("laminar/CitX/oxygen/cmd_pass_oxy_up")
		elseif get("laminar/CitX/oxygen/pass_oxy") == 2 then 
			command_once("laminar/CitX/oxygen/cmd_pass_oxy_dwn")
		end
	end))
preFlightProc:addItem(IndirectProcedureItem:new("OXY PRESSURE","IN GREEN AREA",FlowItem.actorFO,0,"oxypressure",
	function () return get("sim/cockpit2/oxygen/indicators/o2_bottle_pressure_psi") > 1600 end))
preFlightProc:addItem(ProcedureItem:new("FUEL XFER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function ()  sysFuel.crossFeed:actuate(0) end))
preFlightProc:addItem(ProcedureItem:new("GRVTY XFLOW","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/fuel/gravity_flow") == 0 end,
	function ()  
		if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
			command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
		end
	end))
preFlightProc:addItem(ProcedureItem:new("CTR WING XFER LH & RH","BOTH OFF",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/fuel/transfer_left") == 0 and 
		get("laminar/CitX/fuel/transfer_right") == 0
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	end))
preFlightProc:addItem(ProcedureItem:new("FUEL BOOST BOTH","NORM",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/fuel/boost_left") == -1 and 
		get("laminar/CitX/fuel/boost_right") == -1 
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	end))

-- LOAD SHED....................................NORM		laminar/CitX/electrical/load_shed ??

preFlightProc:addItem(ProcedureItem:new("IGNITION SWITCHES","OFF",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/engine/ignition_switch_right") == 0 and 
		get("laminar/CitX/engine/ignition_switch_left") == 0 
	end,
	function ()  
		if get("laminar/CitX/engine/ignition_switch_left") > 0 then 
			command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
		elseif get("laminar/CitX/engine/ignition_switch_left") < 0 then 
			command_once("laminar/CitX/engine/cmd_ignition_switch_left_up")
		end
		if get("laminar/CitX/engine/ignition_switch_right") > 0 then 
			command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
		elseif get("laminar/CitX/engine/ignition_switch_right") < 0 then 
			command_once("laminar/CitX/engine/cmd_ignition_switch_right_up")
		end
	end))
preFlightProc:addItem(ProcedureItem:new("FADEC SWITCHES","NORMAL",FlowItem.actorFO,0,
	function () return get("sim/cockpit/engine/fadec_on",0) == 1 and get("sim/cockpit/engine/fadec_on") == 1 end))
preFlightProc:addItem(IndirectProcedureItem:new("FUEL QUANTITY","CHECK BAL IN EICAS",FlowItem.actorFO,0,"fuelbalanced",
	function () return sysFuel.fuel_balanced() end))
preFlightProc:addItem(ProcedureItem:new("PRESSURIZATION SOURCES","ALL NORM",FlowItem.actorFO,0,
	function () return get("laminar/CitX/pressurization/alt_sel") == 0 and 
		get("laminar/CitX/pressurization/manual") == 0 and 
		get("laminar/CitX/pressurization/pac_bleed") == 0 
	end,
	function ()  
		if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
		end
		if get("laminar/CitX/pressurization/manual") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_manual_toggle")
		end
		command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
		command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	end))
preFlightProc:addItem(IndirectProcedureItem:new("PRESSURIZATION ALT","SET",FlowItem.actorFO,0,"pressalt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			get("sim/cockpit2/autopilot/altitude_readout_preselector")) < 100 
	end))
preFlightProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end))
preFlightProc:addItem(IndirectProcedureItem:new("ROTARY TEST","CHECK",FlowItem.actorFO,0,"rotarytest",
	function () return get("sim/cockpit/warnings/autopilot_test_ap_lit") == 1 end))
preFlightProc:addItem(SimpleProcedureItem:new("== Flight Preps"))
preFlightProc:addItem(SimpleProcedureItem:new("  SETUP FMS"))
preFlightProc:addItem(SimpleProcedureItem:new("  GET ATIS"))
preFlightProc:addItem(SimpleProcedureItem:new("  GET CLEARANCE"))
preFlightProc:addItem(SimpleProcedureItem:new("  T/O BRIEF"))
preFlightProc:addItem(SimpleProcedureItem:new("  PFD CONFIG"))

-- ====================== PRE START ======================
-- AUX PUMP A.....................................ON		
-- HYDRAULIC A PRESSURE..............CHECK >2000 PSI		
-- GND REC........................................ON		
-- PARKING BRAKE.................................SET		
-- DOORS......................................CLOSED		
-- SEAT BELT LTS.........................PASS SAFETY		
-- CKPT PAC & CAB PAC............................OFF		
-- L & R ENG BLD AIR...........................HP/LP		
-- POWER LEVERS..............................CUT OFF		
-- APU BLEED AIR..................................ON		
-- =======================================================

local preStartProc = Procedure:new("PRE START","","")
preStartProc:setFlightPhase(4)
preStartProc:addItem(ProcedureItem:new("AUX PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
preStartProc:addItem(IndirectProcedureItem:new("HYDRAULIC A PRESSURE","CHECK >2000 PSI",FlowItem.actorFO,0,"hydapress",
	function () return get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 end))
preStartProc:addItem(ProcedureItem:new("GND REC (BEACON)","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () sysLights.beaconSwitch:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/door_open") == 0 end,
	function () command_once("sim/flight_controls/door_close_1") end))
preStartProc:addItem(ProcedureItem:new("SEAT BELT LTS","PASS SAFETY",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/seat_belt_pass_safety") == 1 end,
	function () 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	end))
preStartProc:addItem(ProcedureItem:new("CKPT PAC & CAB PAC","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() == 0
	end,
	function () 
		kc_macro_packs_off()
	end))
preStartProc:addItem(ProcedureItem:new("L & R ENG BLD AIR","HP/LP",FlowItem.actorFO,0,
	function () 
		return sysAir.engBleedGroup:getStatus() == 2
	end,
	function () 
		sysAice.engBleedGroup:actuate(1)
	end))
preStartProc:addItem(IndirectProcedureItem:new("POWER LEVERS","CUT OFF",FlowItem.actorFO,0,"powerleverscut",
	function ()
		return get("sim/flightmodel2/engines/has_fuel_flow_after_mixture") == 0 and 
			get("sim/flightmodel2/engines/has_fuel_flow_after_mixture",1) == 0
	end))
preStartProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(1)
	end))

-- ======================= STARTUP =======================
-- PARKING BRAKE................................SET  
-- PUSHBACK SERVICE..........................ENGAGE  
--   Engine Start may be done during push or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  
-- PARKING BRAKE...........................RELEASED  
-- IGNITION SWITCHES.........................NORMAL
-- EXT PWR.............................DISCONNECTED
-- AUX PUMP A...................................OFF
--   Wait for start clearance from ground crew		
-- START SEQUENCE.......................AS REQUIRED
-- START FIRST ENG...................START ENGINE x
--   ENGINE START SWITCH....................PRESS x 
--   1ST ENGINE N2.......................INCREASING
--   POWER LEVER.......................LEVER x IDLE
--   STARTER LIGHT OUT.....................ANNOUNCE
-- START SECOND ENGINE..............START ENGINE __
--   ENGINE START SWITCH....................PRESS x 
--   2ND ENGINE N2.......................INCREASING
--   POWER LEVER.......................LEVER x IDLE
--   STARTER LIGHT OUT.....................ANNOUNCE
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY  
--   LOCKOUT PIN REMOVED.....................VERIFY  
-- PARKING BRAKE................................SET  
-- =======================================================

local pushstartProc = Procedure:new("ENGINE START","")
pushstartProc:setFlightPhase(4)
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_pushback_plan()
	end))
pushstartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(SimpleProcedureItem:new("  Engine Start may be done during push or tow",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () kc_pushback_call() end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("IGNITION SWITCHES","NORMAL",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/engine/ignition_switch_right") == -1 and 
		get("laminar/CitX/engine/ignition_switch_left") == -1 
	end,
	function ()  
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
		command_once("laminar/CitX/engine/cmd_ignition_switch_left_dwn")
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
		command_once("laminar/CitX/engine/cmd_ignition_switch_right_dwn")
	end))
pushstartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 0 end,
	function () sysElectric.gpuSwitch:actuate(0) end))
pushstartProc:addItem(ProcedureItem:new("AUX PUMP A","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
pushstartProc:addItem(SimpleChecklistItem:new("  Wait for start clearance from ground crew"))
pushstartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
pushstartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/CitX/engine/starter_right") == 1
		else 
			return get("laminar/CitX/engine/starter_left") == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_begin("laminar/CitX/engine/cmd_starter_right")
			kc_speakNoText(0,"starting right hand engine")
		else 
			command_begin("laminar/CitX/engine/cmd_starter_left")
			kc_speakNoText(0,"starting left hand engine")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("  1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end 
	end,
	function () 
		command_end("laminar/CitX/engine/cmd_starter_left")
		command_end("laminar/CitX/engine/cmd_starter_right")
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
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
pushstartProc:addItem(ProcedureItem:new("  STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/CitX/engine/starter_right") == 0
		else 
			return get("laminar/CitX/engine/starter_left") == 0
		end 
	end))
pushstartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","PRESS START SWITCH %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/CitX/engine/starter_left") == 1 
		else 
			return get("laminar/CitX/engine/starter_right") == 1 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_begin("laminar/CitX/engine/cmd_starter_left")
			kc_speakNoText(0,"starting left hand engine")
		else 
			command_begin("laminar/CitX/engine/cmd_starter_right")
			kc_speakNoText(0,"starting right hand engine")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("  2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 end 
	end,
	function () 
		command_end("laminar/CitX/engine/cmd_starter_left")
		command_end("laminar/CitX/engine/cmd_starter_right")
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("sim/flightmodel2/engines/has_fuel_flow_after_mixture",0) == 1 
		else 
			return get("sim/flightmodel2/engines/has_fuel_flow_after_mixture",1) == 1 
		end
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			command_once("sim/engines/throttle_up_1")
		else 
			command_once("sim/engines/throttle_up_2")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("  STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/CitX/engine/starter_left") == 0
		else 
			return get("laminar/CitX/engine/starter_right") == 0
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))

-- ===================== AFTER START =====================
-- PARKING BRAKE................................SET  
-- GEN LH & RH...................................ON			
-- CTR WING XFER LH & RH..................BOTH NORM			
-- CKPT PAC & CAB PAC............................ON			
-- APU GEN......................................OFF			
-- APU GEN BLEED AIR............................OFF			
-- APU STARTER...................PRESS DOWN TO STOP
-- APU......................................STOPPED
-- APU SYSTEM MASTER............................OFF			
-- PRESSURIZATION SOURCES..................ALL NORM			
-- SPEED BRAKES & GROUND SPOILERS..............DOWN			
-- == 
-- EICAS.....................CHECK WARNING / ERRORS
-- PITOT STATIC..................................ON			
-- ENGINE ANTI-ICE......................AS REQUIRED
-- STABILIZER ANTI-ICE..................AS REQUIRED
-- FUEL QTY BALANCE...........................CHECK
-- HYD PUMP A & B..............................NORM		:(laminar/CitX/hydraulics/unload_pump_B:1)&&(laminar/CitX/hydraulics/unload_pump_A:1)
-- FLIGHT CONTROLS............................CHECK
-- =======================================================

local afterStartProc = Procedure:new("AFTER START","","")
afterStartProc:setFlightPhase(5)
afterStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))
afterStartProc:addItem(ProcedureItem:new("GEN LH & RH","ON",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 1 and 
			sysElectric.gen2Switch:getStatus() == 1
	end,
	function ()
		sysElectric.gen1Switch:actuate(1)
		sysElectric.gen2Switch:actuate(1)
	end))
afterStartProc:addItem(ProcedureItem:new("CTR WING XFER LH & RH","BOTH NORMAL",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/fuel/transfer_left") == 0 and 
		get("laminar/CitX/fuel/transfer_right") == 0
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	end))
afterStartProc:addItem(ProcedureItem:new("CKPT PAC & CAB PAC","ON",FlowItem.actorFO,0,
	function () 
		return sysAir.packSwitchGroup:getStatus() == 2
	end,
	function () 
		kc_macro_packs_on()
	end))	
afterStartProc:addItem(ProcedureItem:new("#spell|APU# GEN","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/APU/gen_switch") == 0 end,
	function () 
		command_once("laminar/CitX/APU/gen_switch_dwn") 
		command_once("laminar/CitX/APU/gen_switch_dwn") 
	end))
afterStartProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(0)
	end))
afterStartProc:addItem(ProcedureItem:new("#spell|APU# STARTER","PRESS DOWN TO STOP",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_starter_switch") < 0 end,
	function () 
		command_begin("laminar/CitX/APU/starter_switch_dwn") 
	end))
afterStartProc:addItem(IndirectProcedureItem:new("#spell|APU#","STOPPED",FlowItem.actorFO,0,"apustopped",
	function () return get("sim/cockpit/engine/APU_N1") < 2 end,
	function () command_end("laminar/CitX/APU/starter_switch_dwn") end))
afterStartProc:addItem(ProcedureItem:new("#spell|APU# SYSTEM MASTER","OFF",FlowItem.actorFO,0,
	function () return sysElectric.apuMasterSwitch:getStatus() == 0 end,
	function () sysElectric.apuMasterSwitch:actuate(0) end))
afterStartProc:addItem(ProcedureItem:new("PRESSURIZATION SOURCES","ALL NORM",FlowItem.actorFO,0,
	function () return get("laminar/CitX/pressurization/alt_sel") == 0 and 
		get("laminar/CitX/pressurization/manual") == 0 and 
		get("laminar/CitX/pressurization/pac_bleed") == 0 
	end,
	function ()  
		if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
		end
		if get("laminar/CitX/pressurization/manual") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_manual_toggle")
		end
		command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
		command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	end))
afterStartProc:addItem(ProcedureItem:new("SPEED BRAKES & GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
afterStartProc:addItem(SimpleProcedureItem:new("== "))
afterStartProc:addItem(HoldProcedureItem:new("EICAS","CHECK WARNING / ERRORS",FlowItem.actorCPT,nil))
afterStartProc:addItem(ProcedureItem:new("PITOT/STATIC","BOTH ON",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
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
afterStartProc:addItem(IndirectProcedureItem:new("FUEL QUANTITY","CHECK BAL IN EICAS",FlowItem.actorFO,0,"fuelbalanced2",
	function () return sysFuel.fuel_balanced() end))
-- HYD PUMP A & B..............................NORM		:(laminar/CitX/hydraulics/unload_pump_B:1)&&(laminar/CitX/hydraulics/unload_pump_A:1)
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end))

-- ====================== PRE-TAXI =======================
-- FLAPS.............................SET AS REQUIRED 
-- TRANSPONDER...........................AS REQUIRED
-- STABILIZER TRIM.........................SET GREEN
-- TAXI LIGHT.....................................ON			
-- PARKING BRAKE............................RELEASED
-- =======================================================

local preTaxiProc = Procedure:new("PRE TAXI","","")
preTaxiProc:setFlightPhase(6)
preTaxiProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
preTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
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
preTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",3)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
preTaxiProc:addItem(ProcedureItem:new("STABILIZER TRIM","IN GREEN",FlowItem.actorCPT,0,
	function () 
		local trimwheel = get("sim/cockpit2/controls/elevator_trim")
		if get("sim/cockpit2/controls/flap_system_deploy_ratio") == 0.5 then
			return trimwheel >= -0.43 and trimwheel <= 0 
		elseif get("sim/cockpit2/controls/flap_system_deploy_ratio") == 0.75 then
			return trimwheel >= -0.21 and trimwheel <= 0.42 
		else
			return false
		end
	end))
preTaxiProc:addItem(ProcedureItem:new("PARKING BRAKE","RELEASE",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
preTaxiProc:addItem(ProcedureItem:new("TAXI LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() > 0 end,
	function () sysLights.taxiSwitch:actuate(1) end))

-- =================== BEFORE TAKEOFF ====================
-- FLAPS.............................CHECK T/O FLAPS
-- V SPEEDS..........................SET AND CHECKED
-- AP ALTITUDE...........................SET CHECKED
-- AP HEADING BUG................................SET
-- AP HDG MODE...................................SET
-- AP VNAV.......................................SET
-- AP MAC TRIM....................................ON
-- ENGINE ANTI-ICE.......................AS REQUIRED
-- STABILIZER ANTI-ICE...................AS REQUIRED
-- WINDSHIELD HEAT LH & RH........................ON
-- ANTI SKID ON : laminar/CitX/hydraulics/antiskid:1
-- =======================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF","","")
beforeTakeoffProc:setFlightPhase(7)
beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
beforeTakeoffProc:addItem(HoldProcedureItem:new("V SPEEDS","SET AND CHECKED",FlowItem.actorCPT,nil))
beforeTakeoffProc:addItem(ProcedureItem:new("AP ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP HEADING BUG","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP NAV MODE","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vorlocSwitch:getStatus() > 0 end,
	function () sysMCP.vorlocSwitch:actuate(1) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP VNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vnavSwitch:getStatus() > 0 end,
	function () sysMCP.vnavSwitch:actuate(1) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP HDG MODE","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.hdgselSwitch:getStatus() > 0 end,
	function () sysMCP.hdgselSwitch:actuate(1) end,
	function () return activeBriefings:get("takeoff:apMode") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP VNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vnavSwitch:getStatus() > 0 end,
	function () sysMCP.vnavSwitch:actuate(1) end,
	function () return activeBriefings:get("takeoff:apMode") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP MAC TRIM","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/autopilot/left_mtrim") > 0 end,
	function () 
		if get("laminar/CitX/autopilot/left_mtrim") == 0 then 
			command_once("laminar/CitX/autopilot/cmd_mtrim_toggle")
		end
	end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
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
beforeTakeoffProc:addItem(ProcedureItem:new("WINDSHIELD HEAT LH & RH","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 2 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
beforeTakeoffProc:addItem(ProcedureItem:new("ANTISKID","NORM",FlowItem.actorFO,0,
	function () return get("laminar/CitX/hydraulics/antiskid") == 0 end,
	function () 
		if get("laminar/CitX/hydraulics/antiskid") ~= 0 then
			command_once("laminar/CitX/hydraulics/cmd_antiskid_toggle")
		end
	end))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBE LIGHT..................................ON	
-- TAXI LIGHT....................................ON
-- LANDING LIGHT.................................ON
-- TRANSPONDER...........................ATC ALT ON	
-- PACS & BLEEDS........................AS REQUIRED
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY","","")
runwayEntryProc:setFlightPhase(7)
runwayEntryProc:addItem(ProcedureItem:new("STROBE LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() == 1 end,
	function () sysLights.strobesSwitch:actuate(1) end))
runwayEntryProc:addItem(ProcedureItem:new("TAXI LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 1 end,
	function () sysLights.taxiSwitch:actuate(1) end))
runwayEntryProc:addItem(ProcedureItem:new("LANDING LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () sysLights.landLightGroup:actuate(1) end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 3 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",3)
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
runwayEntryProc:addItem(ProcedureItem:new("PACKS & BLEEDS","SET",FlowItem.actorFO,0,true,
	function ()
		kc_macro_packs_takeoff() 
		kc_macro_bleeds_takeoff()
	end))

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- TAKEOFF................................ANNOUNCE
-- THRUST SETTING...........................40% N1
-- sw_item_c:\white\POWER LEVERS|T/O SET			
-- SET TAKEOFF THRUST.....................T/O MODE 
-- POSITIVE RATE......................GT 40 FT AGL 
-- GEAR.........................................UP 
-- A/P..........................................ON 
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)   
-- FLAPS 5..........................SET (OPTIONAL) 
-- FLAPS 5 SPEED...........................REACHED   
-- FLAPS UP....................................SET 
-- POWER LEVERS..........................SET CLIMB	
-- PAC & BLEED SWITCHES.........................ON
-- Whatever comes first
-- TRANSITION ALTITUDE............ANNOUNCE REACHED  
-- ALTIMETERS..................................STD 
-- =====
-- 10.000 FT......................ANNOUNCE REACHED 
-- LANDING LIGHTS..............................OFF 
-- FASTEN BELTS SWITCH.........................OFF 
-- ======================================================

local takeoffClimbProc = Procedure:new("TAKEOFF & INITIAL CLIMB","")
takeoffClimbProc:setFlightPhase(8)
takeoffClimbProc:addItem(HoldProcedureItem:new("TAKEOFF","ANNOUNCE",FlowItem.actorPF))
takeoffClimbProc:addItem(IndirectProcedureItem:new("THRUST SETTING","T/O",FlowItem.actorPNF,0,"tomode",
	function () return get("laminar/CitX/throttle/ratio_ALL") > 0.98 end))
takeoffClimbProc:addItem(IndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",FlowItem.actorPNF,0,"toposrate",
	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 100 and get("sim/flightmodel/position/y_agl") > 40 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("GEAR","COMMAND UP",FlowItem.actorPF))
takeoffClimbProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPF,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
	end))
takeoffClimbProc:addItem(HoldProcedureItem:new("A/P","ON",FlowItem.actorPF))
takeoffClimbProc:addItem(ProcedureItem:new("A/P","ON",FlowItem.actorPNF,0,true,
	function () 
		sysMCP.ap1Switch:actuate(1) 
	end))
-- flaps schedule
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND AT >190 KTS",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.75 end))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) kc_speakNoText(0,"speed check flaps 5") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.75 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND AT >230 KTS",FlowItem.actorPF))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,true,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) kc_speakNoText(0,"speed check flaps up") end))
takeoffClimbProc:addItem(ProcedureItem:new("POWER LEVERS","CLIMB",FlowItem.actorPF,0,
	function () return get("laminar/CitX/throttle/ratio_ALL") == .9 end))
takeoffClimbProc:addItem(ProcedureItem:new("PACKS & BLEEDS","ON",FlowItem.actorFO,0,true,
	function ()
		kc_macro_packs_on() 
		kc_macro_bleeds_on()
	end))

-- ================= DESCENT PROCEDURE ==================
-- PRESSURIZATION...................LAND ALT __ FT
-- VREF..............................SELECT IN FMC
-- LANDING DATA...............VREF __, MINIMUMS __
--   Set/verify navigation radios & course for approach
-- sw_item_c:\white\BANK|AS REQUIRED						????
-- ATIS CHECKED & APPROACH BRIEFING...........DONE
-- FUEL......................................CHECK
-- ENGINE ANTI-ICE......................AS REQUIRED
-- STABILIZER ANTI-ICE..................AS REQUIRED
-- CTR WING XFER LH & RH...................BOTH OFF		
-- FUEL XFER SELECTOR...........................OFF		

-- Whatever comes first
-- TRANSITION LEVEL...............ANNOUNCE REACHED  
-- ALTIMETERS...........................QNH AT DEST 
-- =====
-- 10.000 FT......................ANNOUNCE REACHED 
-- LANDING LIGHTS..............................ON 
-- FASTEN BELTS SWITCH.........................ON 
-- ======================================================

local descentProc = Procedure:new("DESCENT PROCEDURE","","")
descentProc:setFlightPhase(11)
descentProc:addItem(ProcedureItem:new("PRESSURIZATION","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			kc_round_step(activeBriefings:get("arrival:aptElevation"),50) < 100 
	end))
descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|get(\"laminar/B738/FMS/vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () return 
				-- get("laminar/B738/FMS/vref") ~= 0 and 
				sysEFIS.minsResetPilot:getStatus() == 1 and 
				math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("approach:decision") end,
	function ()
				local flag = 0 
				if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
				sysEFIS.minsTypePilot:actuate(flag) 
				sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
descentProc:addItem(SimpleProcedureItem:new("Set or verify the navigation radios and course for the approach."))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
descentProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
descentProc:addItem(ProcedureItem:new("STABILIZER ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
descentProc:addItem(ProcedureItem:new("CTR WING XFER LH & RH","BOTH OFF",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/fuel/transfer_left") == 0 and 
		get("laminar/CitX/fuel/transfer_right") == 0
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
		command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	end))
descentProc:addItem(ProcedureItem:new("FUEL XFER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function ()  sysFuel.crossFeed:actuate(0) end))
descentProc:addItem(ProcedureItem:new("MONITOR TRANS LVL AND 10000 FT","CHECK",FlowItem.actorPM,0,true,
	function () 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities
	end))

-- =============== LANDING PROCEDURE      ===============
-- LANDING LIGHTS...............................ON
-- COURSE NAV 1................................SET
-- COURSE NAV 2................................SET
-- ==== Flaps & Gear Schedule
-- LANDING GEAR...............................DOWN
-- FLAPS 5 SPEED...........................REACHED
-- FLAPS 5.....................................SET
-- FLAPS 15 SPEED..........................REACHED
-- FLAPS 15....................................SET
-- FLAPS FULL SPEED........................REACHED
-- FLAPS FULL..................................SET
-- GO AROUND ALTITUDE......................... SET
-- GO AROUND HEADING...........................SET
-- ======================================================

-- sw_item_c:\white\V SPEEDS|CHECKED
-- sw_item_c:\white\LANDING GEAR|DOWN 3 GREEN:(sim/aircraft/parts/acf_gear_deploy[0]:1)&&(sim/aircraft/parts/acf_gear_deploy[1]:1)&&(sim/aircraft/parts/acf_gear_deploy[2]:1)
-- sw_item_c:\white\FLAPS 5|SPEED CHECK:sim/cockpit2/gauges/indicators/airspeed_kts_pilot:<250
-- sw_item_c:\white\FLAPS 5|FLAPS 5:sim/cockpit2/controls/flap_system_deploy_ratio:0.5
-- sw_item_c:\white\FLAPS 15|SPEED CHECK:sim/cockpit2/gauges/indicators/airspeed_kts_pilot:<210
-- sw_item_c:\white\FLAPS 15|FLAPS 15:sim/cockpit2/controls/flap_system_deploy_ratio:0.75
-- sw_itemvoid_c:\yellow\ CHECK Flaps Full if not required
-- sw_item_c:\white\FLAPS FULL|SPEED CHECK:sim/cockpit2/gauges/indicators/airspeed_kts_pilot:<180
-- sw_item_c:\white\FLAPS FULL|FLAPS DOWN:sim/cockpit2/controls/flap_system_deploy_ratio:1
-- sw_item_c:\white\TAXI LIGHT|ON:sim/cockpit/electrical/taxi_light_on:1
-- sw_item_c:\white\AP & YD|DISCONNECT:(sim/cockpit/autopilot/autopilot_mode:<2)&&(sim/cockpit/switches/yaw_damper_on:0)
-- ======================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","ready for landing checklist")
landingProc:setFlightPhase(13)
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorFO,0,true,
	function () kc_macro_ext_lights_land() end))
landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorCPT,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
landingProc:addItem(ProcedureItem:new("COURSE NAV2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorFO,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 1 end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeAuto) end,
	function () return activeBriefings:get("approach:packs") > 1 end))
landingProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:setValue(0) end,
	function () return activeBriefings:get("approach:packs") > 1 end))

-- ====================== GO AROUND ======================
-- GO AROUND ALTITUDE...........................SET   (PM)
-- GO AROUND HEADING............................SET   (PM)
-- GO AROUND THRUST.............................SET  (CPT)
-- mode HDG
-- mode LVL CHG
-- GEAR..................................COMMAND UP  (CPT)
-- GEAR..........................................UP   (PM)
-- flaps 15
-- CMD-A.. Command
-- set modes lnav/vnav is applicable
-- flaps schedule
-- flaps 5
-- flaps 1
-- flaps up
-- =======================================================

-- ============== AFTER LANDING PROCEDURE ===============
-- SPEED BRAKE................................DOWN   (PF)
-- CHRONO & ET................................STOP  (CPT)
-- WX RADAR....................................OFF  (CPT)
-- APU.......................................START   (FO)
--   Hold APU switch in START position for 3-4 seconds
--   APU GEN OFF BUS LIGHT.............ILLUMINATED   (FO)
-- PROBE HEAT..................................OFF   (FO)
-- STROBES.....................................OFF   (FO)
-- LANDING LIGHTS..............................OFF   (FO)
-- TAXI LIGHTS..................................ON  (CPT)
-- ENGINE START SWITCHES.......................OFF   (FO)
-- TRAFFIC SWITCH..............................OFF   (FO)
-- AUTOBRAKE...................................OFF   (FO)
-- FLAPS........................................UP   (FO)
-- APU...........................START IF REQUIRED   (FO)
-- sw_item_c:\white\LANDING LIGHT|OFF:(sim/cockpit2/switches/landing_lights_switch[0]:0)&&(sim/cockpit2/switches/landing_lights_switch[1]:0)
-- sw_item_c:\white\STROBE LIGHT|OFF:sim/cockpit/electrical/strobe_lights_on:0
-- sw_item_c:\white\GND SPOILERS|RETRACT:sim/cockpit2/controls/speedbrake_ratio:0
-- sw_item_c:\white\FLAPS|UP:sim/flightmodel2/wing/flap1_deg[1]:0
-- sw_item_c:\white\PITOT STATIC HEAT|OFF:(sim/cockpit/switches/pitot_heat_on:0)&&(sim/cockpit/switches/pitot_heat_on2:0)
-- sw_item_c:\white\ICE PROT|AS REQD
-- sw_item_c:\white\TRANSPONDER|STANDBY:sim/cockpit2/radios/actuators/transponder_mode:1
-- sw_item_c:\white\WX RADAR|OFF
-- ======================================================


-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- TAXI LIGHT SWITCH...........................OFF  (CPT) 
-- PARKING BRAKE...............................SET  (CPT)
-- ==== Electrical power
-- APU GENERATOR BUS SWITCHES.........ON IF NEEDED   (FO)
-- GRD POWER AVAILABLE LIGHT...........ILLUMINATED   (FO)
-- GROUND POWER SWITCH................ON IF NEEDED   (FO)
-- ENGINE START LEVERS......................CUTOFF  (CPT)
-- FASTEN BELTS SWITCH.........................OFF   (FO)
-- ANTI COLLISION LIGHT SWITCH.................OFF   (FO)
-- FUEL PUMPS..............APU 1 PUMP ON, REST OFF  (CPT)
-- FUEL PUMPS............ALL OFF IF APU NOT RUNNIG  (CPT)
-- CAB/UTIL POWER SWITCH........................ON  (CPT)
-- IFE/PASS SEAT POWER SWITCH..................OFF  (CPT)
-- PROBE HEAT..................................OFF   (FO)
-- WING ANTI-ICE SWITCH........................OFF   (FO)
-- ENGINE ANTI-ICE SWITCHES....................OFF   (FO)
-- ENGINE HYDRAULIC PUMPS SWITCHES..............ON   (FO)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES...........OFF   (FO)
-- RECIRCULATION FAN SWITCHES.................AUTO   (FO)
-- AIR CONDITIONING PACK SWITCHES.............AUTO   (FO)
-- ISOLATION VALVE SWITCH.....................OPEN   (FO)
-- ENGINE BLEED AIR SWITCHES....................ON   (FO)
-- APU BLEED AIR SWITCH...............ON IF NEEDED   (FO)
-- FLIGHT DIRECTOR SWITCHES....................OFF   (FO)
-- TRANSPONDER................................STBY   (FO)
-- MCP.......................................RESET   (FO)
-- sw_item_c:\white\THROTTLES|IDLE:sim/multiplayer/controls/engine_throttle_request:0
-- sw_item_c:\white\PARK BRAKE|SET:sim/cockpit2/controls/parking_brake_ratio:1
-- sw_item_c:\white\WHEEL CHOCKS|SET
-- sw_item_c:\white\EXTERNAL POWER|AS REQUIRED
-- sw_item_c:\white\PSG BELT & SAFETY LT|OFF:sim/cockpit2/switches/fasten_seat_belts:0
-- sw_item_c:\white\WINDSHIELD HEAT LH & RH|OFF:(sim/cockpit2/ice/ice_window_heat_on_window[0]:0)&&(sim/cockpit2/ice/ice_window_heat_on_window[1]:0)
-- sw_item_c:\white\ENGINE BLEED AIR|OFF:(sim/cockpit2/bleedair/actuators/engine_bleed_sov[0]:0)&&(sim/cockpit2/bleedair/actuators/engine_bleed_sov[1]:0)
-- sw_item_c:\white\EMR LIGHTS|OFF
-- sw_item_c:\white\STANDBY ATTITUDE ADI|CAGED
-- sw_item_c:\white\AVIONICS SWITCH|OFF:sim/cockpit2/switches/avionics_power_on:0
-- sw_item_c:\white\EICAS SWITCH|OFF:sim/cockpit2/switches/gnd_com_power_on:0
-- sw_item_c:\white\ICE PROT|OFF
-- sw_item_c:\white\POWER LEVERS|CUT OFF:(sim/flightmodel2/engines/has_fuel_flow_after_mixture[0]:0)&&(sim/flightmodel2/engines/has_fuel_flow_after_mixture[1]:0)
-- sw_item_c:\white\FUEL BOOST BOTH|OFF:(sim/cockpit2/engine/actuators/fuel_pump_on[1]:0)&&(sim/cockpit2/engine/actuators/fuel_pump_on[0]:0)
-- sw_item_c:\white\GEN 1 & 2|OFF:(sim/cockpit/electrical/generator_on[0]:0)&&(sim/cockpit/electrical/generator_on[1]:0)
-- sw_item_c:\white\BCN / EXT LIGHTS|OFF
-- sw_item_c:\white\STANDBY POWER|OFF:sim/cockpit/electrical/battery_array_on[0]:0
-- sw_item_c:\white\BATTERY SWITCHES|OFF:(sim/cockpit2/electrical/battery_on[1]:0)&&(sim/cockpit2/electrical/battery_on[2]:0)
-- ======================================================

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(preFlightProc)
activeSOP:addProcedure(preStartProc)
activeSOP:addProcedure(pushstartProc)
activeSOP:addProcedure(preTaxiProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffClimbProc)
activeSOP:addProcedure(descentProc)
activeSOP:addProcedure(landingProc)

-- === States ===
-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("C&D","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))

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


return SOP_C750
