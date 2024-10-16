-- Base SOP Laminar Citation X 750 for XP12

-- @classmod SOP_C750
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
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
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = SOP:new("Laminar Citation X SOP")

-- test procedure not used in SOP
local testProc = Procedure:new("TEST","","")
testProc:setFlightPhase(1)
testProc:addItem(ProcedureItem:new("LIGHTS","ALL ON",FlowItem.actorFO,5,false,
	function () 
	  kc_macro_lights_all_on()
	end))
	
-- =====================================================================================================================

-- ================== ORIGINATING CHECK ==================
-- == INITIAL CHECKS
-- All paper work on board and checked
-- CIRCUIT BREAKERS..........................CHECKED
-- FIRE EXTINGUISHER.........................CHECKED
-- BATTERY SWITCHES 1 & 2.........................ON (F/O)		
-- AUX HYD PUMP A.................................ON (F/O)
-- PARKING BRAKE..................................ON (F/O)
-- LANDING GEAR HANDLE..........................DOWN (F/O)
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED (F/O)
-- SPEED BRAKES & GROUND SPOILERS...............DOWN (F/O)
-- POWER LEVERS..............................CUT OFF (F/O)
-- FLAP LEVER.....................................UP (F/O)
-- PANEL LIGHTS..........................AS REQUIRED (F/O)
-- DAY/NITE DIM SWITCH...................AS REQUIRED (F/O)
-- EICAS SWITCH...................................ON (F/O)		
-- BATTERIES, 23 VOLTS.........................CHECK (F/O)
-- EXT PWR...............................AS REQUIRED (F/O)		

-- OXYGEN PRESSURE................CHECK IN GREEN ARC (F/O)
-- EMERG LIGHTS......................CHECKED & ARMED (F/O)
-- STANDBY POWER................................TEST (F/O)
-- STANDBY POWER..................................ON (F/O)
-- DC LOAD SHED/EMER PWR................NORM/CHECKED (F/O)		
-- PRESS SYSTEM..............................CHECKED ???

-- == APU START
-- APU SYSTEM MASTER..............................ON (F/O)		
-- APU TEST.....................................PUSH (F/O)
-- APU STARTER.......................HOLD TILL START (F/O)		
-- APU N1 100%.................................READY (F/O)		
-- APU GEN........................................ON (F/O)		
-- APU AMPS LESS 200A..........................CHECK (F/O)		
-- CABIN POWER....................................ON (F/O)

-- AVIONICS SWITCH................................ON (F/O)		
-- DISPLAYS.......................................ON (F/O)
-- IRS NOT CODED
-- AILERON TRIM/RUDDER TRIM....................RESET (F/O)
-- ROTARY TEST.................................CHECK (CPT)		
-- FUEL XFER SELECTOR............................OFF (F/O)
-- AIR CONDITIONING PACK SWITCHES...............AUTO (F/O)
-- NAV LIGHTS.................................... ON (F/O)		
-- =======================================================

local electricalPowerUpProc = Procedure:new("ORIGINATING CHECK","","")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Circuit breakers checked (not coded)"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Fire extinguisher  checked (not coded)"))

electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH 1 & 2","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () kc_macro_lights_preflight() end))
electricalPowerUpProc:addItem(ProcedureItem:new("AUX HYD PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpA:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpA:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(ProcedureItem:new("SPEED BRAKES & GROUND SPOILERS","DOWN",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("POWER LEVERS","CUT OFF",FlowItem.actorFO,0,"powerleverscut",
	function ()
		return get("laminar/CitX/throttle/ratio_L") < 0 and 
			get("laminar/CitX/throttle/ratio_R") < 0
	end,
	function () 
		set("laminar/CitX/throttle/ratio_L",-1)
		set("laminar/CitX/throttle/ratio_R",-1)
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("PANEL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () 
		kc_macro_lights_preflight()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("DAY/NITE DIM SWITCH","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/dim_lights_switch") == 0 end,
	function () 
		if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
			command_once("laminar/CitX/lights/dimming_switch_toggle")
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EICAS SWITCH","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/avionics_eicas") == 1 end,
	function () 
		if get("laminar/CitX/electrical/avionics_eicas") == 0 then
			command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		end
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERIES, 23 VOLTS","CHECK",FlowItem.actorFO,0,"battat24",
	function () 
		return get("sim/cockpit2/electrical/battery_voltage_indicated_volts",0) > 22 and 
			get("sim/cockpit2/electrical/battery_voltage_indicated_volts",1) >22 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXT PWR","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))


electricalPowerUpProc:addItem(IndirectProcedureItem:new("OXYGEN PRESSURE","IN GREEN AREA",FlowItem.actorCPT,0,"oxypressure",
	function () return get("sim/cockpit2/oxygen/indicators/o2_bottle_pressure_psi") > 1500 end))
electricalPowerUpProc:addItem(ProcedureItem:new("EMERG LT","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/emerg_light_switch") > 0 end,
	function () 
		command_once("laminar/CitX/lights/emerg_light_switch_up") 
		command_once("laminar/CitX/lights/emerg_light_switch_up")
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("STANDBY POWER","TEST",FlowItem.actorFO,2,"stbytest",
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == -1 end,
	function () 
		command_once("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_begin("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("sim/flight_controls/door_open_1")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == 1 end,
	function () 
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("DC LOAD SHED/EMER PWR","NORM/CHECKED",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/electrical/load_shed") == 0
	end,
	function ()  
		command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
		command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
		command_once("laminar/CitX/electrical/cmd_load_shed_up")
	end))
	
electricalPowerUpProc:addItem(ProcedureItem:new("ISO VLV CLOSE","OFF / GUARDED",FlowItem.actorFO,0,
	function () return get("laminar/CitX/pressurization/iso_vlv") == 0 and get("laminar/CitX/pressurization/safeguard_iso_vlv") == 0 end,
	function ()
		if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
		end
		if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("BLEED ISOL VALVE","OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == 0 end,
	function ()
		sysAir.isoValveSwitch:actuate(0)
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("PRESSURIZATION ALT","(%i) %i FT|get(\"laminar/CitX/pressurization/altitude\")|get(\"sim/cockpit2/autopilot/altitude_readout_preselector\")",FlowItem.actorCPT,0,"pressalt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			get("sim/cockpit2/autopilot/altitude_readout_preselector")) < 100 
	end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== APU ON"))
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
electricalPowerUpProc:addItem(ProcedureItem:new("DISPLAYS","ON",FlowItem.actorFO,0,
	function () return sysLights.dispLightGroup:getStatus() > 0 end,
	function () sysLights.dispLightGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/aileron_trim") == 0 and
		get("sim/cockpit2/controls/rudder_trim") == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("ROTARY TEST","CHECK",FlowItem.actorCPT,0,"rotarytest",
	function () return get("sim/cockpit/warnings/autopilot_test_ap_lit") == 1 end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL XFER SELECTOR","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == 0 end,
	function ()  sysFuel.crossFeed:actuate(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() > 1 end,
	function () sysAir.packSwitchGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("NAV LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(1) end))

-- =====================================================================================================================

-- ================ ORIGINATING CHECKLIST ================
-- BATTERY SWITCH 1 & 2...........................ON (F/O)
-- LEFT & RIGHT GENERATOR........................OFF (F/O)
-- EXTERNAL POWER OR APU..........................ON (F/O)
-- AVIONICS SWITCH................................ON (F/O)
-- EICAS SWITCH...................................ON (F/O)
-- AUX HYD PUMP A.................................ON (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- STANDBY POWER..................................ON (F/O)
-- =======================================================

local preflightChkl = Checklist:new("ORIGINATING CHECKLIST","","originating checklist completed")
preflightChkl:setFlightPhase(3)
preflightChkl:addItem(ChecklistItem:new("BATTERY SWITCH 1 & 2","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
	end))
preflightChkl:addItem(ChecklistItem:new("LEFT & RIGHT GENERATOR","OFF",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 0 and 
			sysElectric.gen2Switch:getStatus() == 0
	end,
	function ()
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	end))
preflightChkl:addItem(ChecklistItem:new("EXTERNAL POWER OR #spell|APU#","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit/electrical/generator_apu_amps") > 0 or sysElectric.gpuSwitch:getStatus() == 1 end))
preflightChkl:addItem(ChecklistItem:new("AVIONICS SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.avionicsSwitchGroup:getStatus() == 1 end,
	function () sysElectric.avionicsSwitchGroup:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("EICAS SWITCH","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/avionics_eicas") == 1 end,
	function () 
		if get("laminar/CitX/electrical/avionics_eicas") == 0 then
			command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		end
	end))
preflightChkl:addItem(ChecklistItem:new("AUXILIARY HYDRAULIC PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpA:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpA:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == 1 end,
	function () 
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end))
-- =====================================================================================================================

-- ==================== CDU Preflight ====================
-- FILL OUT KPCREW DEPARTURE BRIEFING
-- SET UP FMS
-- =======================================================

local cduPreflightProc = Procedure:new("CDU PREFLIGHT BY CAPTAIN")
cduPreflightProc:setFlightPhase(-2)
cduPreflightProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
cduPreflightProc:addItem(HoldProcedureItem:new("KPCREW DEPARTURE BRIEFING","FILLED OUT",FlowItem.actorCPT))
cduPreflightProc:addItem(HoldProcedureItem:new("FMS SETUP","FINISHED",FlowItem.actorCPT))
-- =====================================================================================================================

-- ================= ENGINE START CHECK ===================
-- AUX HYD PUMP A.................................ON  (F/O)
-- PARKING BRAKE.................................SET  (F/O)
-- EICAS......................CHECK WARNING / ERRORS  (CPT)
-- IRS..............................ALIGNED/NO FLAGS  --- 
-- STANDBY ATTITUDE ADI......................UNCAGED  (CPT)
-- ATIS......................................BRIEFED  (CPT)
-- ALTIMETERS (3)............................SET QNH (BOTH)
-- CLEARANCE.................................BRIEFED  (CPT)
-- FLIGHT DIRECTOR...............................SET  (F/O)
-- FMS...........................PROGRAMMED/VERIFIED  (CPT)
-- FUEL QTY/BALANCE..........................CHECKED  (CPT)
-- PRESSURIZATION SOURCES...................ALL NORM  (F/O)
-- PRESSURIZATION...............SET CRUISE ALT __ FT  (CPT)
-- IGNITION SWITCHES..........................NORMAL  (F/O)
-- =======================================================

local beforeStart = Procedure:new("ENGINE START CHECK","","")
beforeStart:setFlightPhase(4)
beforeStart:addItem(ProcedureItem:new("AUX HYD PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpA:getStatus() == 1 end,
	function () 
		kc_macro_background_settings()
		sysHydraulic.elecHydPumpA:actuate(1) 
	end))
beforeStart:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStart:addItem(HoldProcedureItem:new("EICAS","CHECKED",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("STANDBY ATTITUDE ADI","UNCAGED",FlowItem.actorCPT,0,
	function () return get("sim/cockpit/gyros/gyr_cage_ratio",2) < 1 end))
beforeStart:addItem(HoldProcedureItem:new("ATIS","BRIEFED",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("ALTIMETERS","ALL SET QNH",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_set_local_baro() end))
beforeStart:addItem(HoldProcedureItem:new("CLEARANCE","BRIEFED",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("FLIGHT DIRECTOR","SET",FlowItem.actorFO,0,
	function () return sysMCP.fdirPilotSwitch:getStatus() == 1 end,
	function () sysMCP.fdirPilotSwitch:actuate(1) end))
beforeStart:addItem(HoldProcedureItem:new("FMS","PROGRAMMED/VERIFIED",FlowItem.actorCPT))
beforeStart:addItem(IndirectProcedureItem:new("FUEL QUANTITY","CHECK BAL IN EICAS",FlowItem.actorCPT,0,"fuelbalanced",
	function () return sysFuel.fuel_balanced() end))
beforeStart:addItem(ProcedureItem:new("PRESSURIZATION SOURCES","ALL NORM",FlowItem.actorFO,0,
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
beforeStart:addItem(IndirectProcedureItem:new("PRESSURIZATION","CRUISE ALT (%i) 7500 FT|get(\"laminar/CitX/pressurization/altitude\")",FlowItem.actorPM,0,"cruisealt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 7500) < 100 
	end,
	function ()
		set("laminar/CitX/pressurization/altitude",kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50)) 
	end))
beforeStart:addItem(ProcedureItem:new("IGNITION SWITCHES","NORMAL",FlowItem.actorFO,0,
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

-- =====================================================================================================================

-- ================== PUSHBACK (BOTH) ====================
-- DOORS.....................................CLOSED  (F/O)
-- PARKING BRAKE................................SET  (CPT)
-- IGNITION SWITCHES.........................NORMAL  (F/O)
-- EXT PWR...........................OFF/DISCONNECT  (F/O)
-- AUX PUMP A...................................OFF  (F/O)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- =======================================================

local pushProc = Procedure:new("PUSHBACK - SKIP IF NOT REQUIRED","")
pushProc:setFlightPhase(4)
pushProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/door_open") == 0 end,
	function () command_once("sim/flight_controls/door_close_1") end))
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		sysLights.domeLightSwitch:actuate(0)
		if activeBriefings:get("taxi:gateStand") <= 2 then
			if activePrefSet:get("default:betterPushback") == true then
				kc_pushback_plan()
			end
			if activePrefSet:get("default:sges") == true then
				kc_show_sges_window()
			end			
		end
	end))
pushProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 0 end,
	function () sysElectric.gpuSwitch:actuate(0) end))
pushProc:addItem(ProcedureItem:new("AUX PUMP A","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
pushProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () 
		if activePrefSet:get("default:betterPushback") == true then
			kc_pushback_call() 
		end
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))

pushProc:addItem(HoldProcedureItem:new("CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT,nil))

-- =====================================================================================================================

-- ============= DOORS CLOSED READY TO START =============
-- DOORS......................................CLOSED (F/O)
-- EXT PWR..........................OFF / DISCONNECT (F/O)
-- AUX PUMP A.....................................ON (F/O)	
-- FLAP LEVER.....................................UP (F/O)
-- GND REC (BEACON)...............................ON (F/O)
-- PAC ISOL VALVE.............................CLOSED (F/O)
-- APU BLEED AIR..................................ON (F/O)
-- SEAT BELT LTS.........................PASS SAFETY (F/O)
-- START PRESSURE................30 PSI (26 PSI MIN) (CPT)
-- TRANSPONDER...............................STANDBY (F/O)
-- CKPT PAC & CAB PAC............................OFF (F/O)		
-- L & R ENG BLD AIR...........................HP/LP (F/O)	
-- HYDRAULIC A PRESSURE..............CHECK >2000 PSI (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- POWER LEVERS..............................CUT OFF (F/O)		
-- =======================================================

local preStartProc = Procedure:new("DOORS CLOSED READY TO START","","ready to start engines")
preStartProc:setFlightPhase(4)
preStartProc:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/door_open") == 0 end,
	function () command_once("sim/flight_controls/door_close_1") end))
preStartProc:addItem(ProcedureItem:new("EXT PWR","OFF/DISCONNECT",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 0 end,
	function () sysElectric.gpuSwitch:actuate(0) end))
preStartProc:addItem(ProcedureItem:new("AUX PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
preStartProc:addItem(ProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
preStartProc:addItem(ProcedureItem:new("GND REC (BEACON)","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () kc_macro_lights_before_start() end))
preStartProc:addItem(ProcedureItem:new("PAC ISOL VALVE","CLOSED",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function ()
		sysAir.isoValveSwitch:actuate(1)
	end))
preStartProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () 
		command_once("laminar/CitX/APU/bleed_switch_dwn")
		command_once("laminar/CitX/APU/bleed_switch_dwn")
		command_once("laminar/CitX/APU/bleed_switch_up")
	end))
preStartProc:addItem(ProcedureItem:new("SEAT BELT LTS","PASS SAFETY",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/seat_belt_pass_safety") == 1 end,
	function () 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	end))
preStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
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
		sysAir.engBleedGroup:actuate(1)
	end))
preStartProc:addItem(IndirectProcedureItem:new("HYDRAULIC A PRESSURE","CHECK >2000 PSI",FlowItem.actorFO,0,"hydapress",
	function () return get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 end))
preStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preStartProc:addItem(IndirectProcedureItem:new("POWER LEVERS","CUT OFF",FlowItem.actorFO,0,"powerleverscut",
	function ()
		return get("laminar/CitX/throttle/ratio_L") < 0 and 
			get("laminar/CitX/throttle/ratio_R",1) < 0
	end))

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
-- FGC/YAW DAMPER.................................ON (F/O)
-- =======================================================

local pushstartProc = Procedure:new("ENGINE START","")
pushstartProc:setFlightPhase(-4)
pushstartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
pushstartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,0,"eng_start_1_grd",
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
pushstartProc:addItem(ProcedureItem:new("1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end 
	end,
	function () 
		command_end("laminar/CitX/engine/cmd_starter_left")
		command_end("laminar/CitX/engine/cmd_starter_right")
	end))
pushstartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
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
pushstartProc:addItem(ProcedureItem:new("STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/CitX/engine/starter_right") == 0
		else 
			return get("laminar/CitX/engine/starter_left") == 0
		end 
	end))
pushstartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","PRESS START SWITCH %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT,0,"eng_start_1_grd",
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
pushstartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 end 
	end,
	function () 
		command_end("laminar/CitX/engine/cmd_starter_left")
		command_end("laminar/CitX/engine/cmd_starter_right")
	end))
pushstartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
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
pushstartProc:addItem(ProcedureItem:new("STARTER LIGHT OUT","ANNOUNCE",FlowItem.actorCPT,0,
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
pushstartProc:addItem(IndirectProcedureItem:new("HYDRAULICS","CHECKED",FlowItem.actorCPT,0,"hydchecked",
	function () return 
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 and
		get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2") > 2000 
	end))
pushstartProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorCPT,0,
	function () return sysControls.yawDamper:getStatus() end,
	function () sysControls.yawDamper:actuate(1) end))

-- =====================================================================================================================

-- ===================== TAXI CHECK ======================
-- PARKING BRAKE................................SET  (F/O)
-- GEN LH & RH...................................ON  (F/O)			
-- CTR WING XFER LH & RH..................BOTH NORM  (F/O)
-- CKPT PAC & CAB PAC............................ON  (F/O)
-- APU GEN......................................OFF  (F/O)
-- APU GEN BLEED AIR............................OFF  (F/O)
-- PRESSURIZATION SOURCES..................ALL NORM  (F/O)
-- SPEED BRAKES & GROUND SPOILERS..............DOWN  (F/O)
-- == 
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

local afterStartProc = Procedure:new("TAXI CHECK","","")
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
		return get("laminar/CitX/fuel/transfer_left") == 2 and 
		get("laminar/CitX/fuel/transfer_right") == 2
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
afterStartProc:addItem(ProcedureItem:new("AUX PUMP A","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
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
afterStartProc:addItem(ProcedureItem:new("HYD PUMP A & B","NORM",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () 
		sysHydraulic.engHydPumpGroup:actuate(0)
		kc_macro_lights_before_taxi()
	end)) 
afterStartProc:addItem(IndirectProcedureItem:new("THRUST REVERSERS","CHECKED",FlowItem.actorPF,0,"reversercheck",
	function () return get("kp/xsp/bravo/anc_reverse") > 0 end))
afterStartProc:addItem(HoldProcedureItem:new("V SPEEDS","SET AND CHECKED",FlowItem.actorCPT,true))
afterStartProc:addItem(HoldProcedureItem:new("TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF))
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 14.9 end))


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
preTaxiProc:addItem(ChecklistItem:new("STABILIZER TRIM","IN GREEN BAND",FlowItem.actorCPT,0,
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
-- ANTI SKID...................................NORM  (F/O)
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
beforeTakeoffProc:addItem(ProcedureItem:new("AP LNAV MODE","ARM",FlowItem.actorCPT,0,
	function () return get("sim/cockpit/switches/HSI_selector") == 2 end,
	function () 
		if get("sim/cockpit/switches/HSI_selector") == 0 then
			command_once("sim/autopilot/hsi_toggle_gps")
		end
		sysMCP.vorlocSwitch:actuate(1) 
	end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP VNAV","ARM",FlowItem.actorCPT,0,
	function () return get("sim/cockpit2/autopilot/fms_vnav") > 0 end,
	function () 
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
		if get("sim/cockpit2/autopilot/fms_vnav") == 0 then
			command_once("laminar/CitX/autopilot/cmd_vnav_mode") 
		end
	end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP HDG MODE","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.hdgselSwitch:getStatus() > 0 end,
	function () sysMCP.hdgselSwitch:actuate(1) end,
	function () return activeBriefings:get("takeoff:apMode") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP VNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vnavSwitch:getStatus() > 0 end,
	function () 
		sysMCP.vnavSwitch:actuate(1) 
	end,
	function () return activeBriefings:get("takeoff:apMode") == 1 end))
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
	function () return sysGeneral.antiSkid:getStatus() == 0 end,
	function () 
		sysGeneral.antiSkid:actuate(0)
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
takeoffClimbProc:addItem(IndirectProcedureItem:new("THRUST SETTING","T/O",FlowItem.actorPM,0,"tomode",
	function () return get("laminar/CitX/throttle/ratio_ALL") > 0.98 end,
	function () 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
	end))

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
	function () return sysControls.yawDamper:getStatus() end,
	function () sysControls.yawDamper:actuate(1) end))

flapsUpProc:addItem(ProcedureItem:new("A/P","ON",FlowItem.actorPNF,0,true,
	function () 
		sysMCP.ap1Switch:actuate(1) 
	end))
flapsUpProc:addItem(ProcedureItem:new("POWER LEVERS","SET CLIMB",FlowItem.actorPF,0,
	function () return get("laminar/CitX/throttle/ratio_ALL") > .935 and get("laminar/CitX/throttle/ratio_ALL") < .96 end))
flapsUpProc:addItem(ProcedureItem:new("PACKS & BLEEDS","ON",FlowItem.actorPM,0,true,
	function ()
		kc_macro_packs_on() 
		kc_macro_bleeds_on()
	end))
flapsUpProc:addItem(ProcedureItem:new("#spell|APU# STARTER","PRESS DOWN TO STOP",FlowItem.actorPM,2,
	function () return get("sim/cockpit2/electrical/APU_starter_switch") == 0 end,
	function () 
		command_begin("laminar/CitX/APU/starter_switch_dwn") 
	end))
flapsUpProc:addItem(IndirectProcedureItem:new("#spell|APU#","STOPPED",FlowItem.actorPM,0,"apustopped",
	function () return get("sim/cockpit/engine/APU_N1") < 2 end,
	function () command_end("laminar/CitX/APU/starter_switch_dwn") end))
flapsUpProc:addItem(ProcedureItem:new("#spell|APU# SYSTEM MASTER","OFF",FlowItem.actorPM,0,
	function () return sysElectric.apuMasterSwitch:getStatus() == 0 end,
	function () sysElectric.apuMasterSwitch:actuate(0) end))

-- =====================================================================================================================

-- ================ AFTER TAKEOFF CHECK ==================
-- FLAPS.........................................UP   (PM)
-- CLB THRUST...................................SET   (PM)
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
afterTakeoffCheck:addItem(ChecklistItem:new("CLB THRUST","SET",FlowItem.actorPM,0,
	function () return get("laminar/CitX/throttle/ratio_ALL") > .935 and get("laminar/CitX/throttle/ratio_ALL") < .96 end))
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
descentProc:addItem(ProcedureItem:new("KPCREW BRIEFING WINDOW","OPEN",FlowItem.actorFO,0,true,
	function () kc_wnd_brief_action = 1 end))
descentProc:addItem(HoldProcedureItem:new("KPCREW APPROACH BRIEFING","PERFORM",FlowItem.actorPF))

descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () 
		return get("sim/cockpit/misc/radio_altimeter_minimum") == activeBriefings:get("approach:decision") end,
	function ()
		local flag = 0 
		if 
			activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
			sysEFIS.minsTypePilot:actuate(flag) 
			sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
			sysEFIS.minsResetPilot:actuate(1) 
			kc_procvar_set("below10k",true) -- background 10.000 ft activities
			kc_procvar_set("attranslvl",true) -- background transition level activities
		end))
descentProc:addItem(IndirectProcedureItem:new("PRESSURIZATION","LAND ALT (%i) %i FT|get(\"laminar/CitX/pressurization/altitude\")|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,"landalt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) < 100 
	end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
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
descentProc:addItem(ProcedureItem:new("CTR WING XFER LH & RH","BOTH OFF",FlowItem.actorPM,0,
	function () 
		return get("laminar/CitX/fuel/transfer_left") == 0 and 
		get("laminar/CitX/fuel/transfer_right") == 0
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_transfer_right_up")
		command_once("laminar/CitX/fuel/cmd_transfer_right_up")
		command_once("laminar/CitX/fuel/cmd_transfer_left_up")
		command_once("laminar/CitX/fuel/cmd_transfer_left_up")
	end))
descentProc:addItem(ProcedureItem:new("WINDSHIELD HEAT LH & RH","BOTH ON",FlowItem.actorPM,0,
	function () return sysAice.windowHeatGroup:getStatus() == 2 end,
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
descentChecklist:addItem(IndirectChecklistItem:new("PRESSURIZATION","LAND ALT (%i) %i FT SET|get(\"laminar/CitX/pressurization/altitude\")|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,"landalt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) < 100 
	end))
descentChecklist:addItem(ManualChecklistItem:new("PASSENGER BRIEFING","COMPLETED",FlowItem.actorPF,0,"paxbrief"))
descentChecklist:addItem(ChecklistItem:new("SEAT BELT LTS","PASS SAFETY",FlowItem.actorPM,0,
	function () return get("laminar/CitX/lights/seat_belt_pass_safety") == 1 end,
	function () 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
	end))

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
landingProc:addItem(ProcedureItem:new("LH & RH IGNITION SWITCHES","NORM",FlowItem.actorPM,0,
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
landingProc:addItem(ProcedureItem:new("ENG SYNC","OFF",FlowItem.actorPM,0,
	function () return get("laminar/CitX/engine/eng_sync") == 0 end,
	function ()
		if get("laminar/CitX/engine/eng_sync") < 0 then
			command_once("laminar/CitX/engine/cmd_eng_sync_up")
		end
		if get("laminar/CitX/engine/eng_sync") > 0 then
			command_once("laminar/CitX/engine/cmd_eng_sync_dwn")
		end
	end))

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
	function () sysAir.packSwitchGroup:setValue(0) end,
	function () return activeBriefings:get("approach:packs") == 1 end))
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPF,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights_approach() end))

-- =====================================================================================================================
	
local gearDownProc = Procedure:new("GEAR DOWN","","")
gearDownProc:setFlightPhase(-13)
gearDownProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
gearDownProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorPM,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))

-- =====================================================================================================================

local flaps5Proc = Procedure:new("FLAPS 5 (<245 kts)","","")
flaps5Proc:setFlightPhase(-13)
flaps5Proc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= 0.5 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[2]) end))

-- =====================================================================================================================

local flaps15Proc = Procedure:new("FLAPS 15 (<205 kts)","","")
flaps15Proc:setFlightPhase(-13)
flaps15Proc:addItem(ProcedureItem:new("FLAPS 15","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() >= 0.75 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[3]) end))

-- =====================================================================================================================

local flapsFullProc = Procedure:new("FLAPS Full (<180 kts)","","")
flapsFullProc:setFlightPhase(-13)
flapsFullProc:addItem(ProcedureItem:new("FLAPS FULL","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == 1 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[4]) end))
flapsFullProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
flapsFullProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))

-- =====================================================================================================================

local APLandOffProc = Procedure:new("AUTOPILOT OFF","","")
APLandOffProc:setFlightPhase(-13)
APLandOffProc:addItem(HoldProcedureItem:new("AUTOPILOT","OFF",FlowItem.actorPF))
APLandOffProc:addItem(ProcedureItem:new("AUTOPILOT","OFF",FlowItem.actorPNF,0,true,
	function () 
		sysMCP.ap1Switch:actuate(0) 
	end))

-- =====================================================================================================================

-- ================ FINAL DESCENT CHECKS ================
-- GEAR...............................DOWN 3 GREEN   (PF)
-- SPEED BRAKES..........................RETRACTED   (PF)
-- FLAPS........................................35   (PF)
-- AUTOPILOT...................................OFF   (PF)
-- ======================================================
local landingChecklist = Checklist:new("FINAL DESCENT CHECKS","","")
landingChecklist:setFlightPhase(13)
landingChecklist:addItem(ChecklistItem:new("GEAR","DOWN 3 GREEN",FlowItem.actorPF,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.GearSwitch:actuate(1) 
	end))
landingChecklist:addItem(ChecklistItem:new("SPEED BRAKES","RETRACTED",FlowItem.actorPF,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () set("sim/cockpit2/controls/speedbrake_ratio",0) end))
landingChecklist:addItem(ChecklistItem:new("FLAPS","35",FlowItem.actorPF,0,
	function () return sysControls.flapsSwitch:getStatus() == 1 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[4]) end))
landingChecklist:addItem(ChecklistItem:new("AUTOPILOT","OFF",FlowItem.actorPF,0,
	function () return sysMCP.ap1Switch:getStatus() == 0 end,
	function () 
		sysMCP.ap1Switch:actuate(0) 
	end))

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
afterLandingProc:addItem(ProcedureItem:new("WX RADAR","OFF",FlowItem.actorFO,0,
	function () return true end))
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
afterLandingProc:addItem(ProcedureItem:new("#spell|APU# SYSTEM MASTER","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuMasterSwitch:getStatus() == 1 end,
	function () sysElectric.apuMasterSwitch:actuate(1) end))
afterLandingProc:addItem(ProcedureItem:new("#spell|APU# STARTER","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/electrical/APU_starter_switch") > 0 end,
	function () 
		command_end("laminar/CitX/APU/test_button")
		command_begin("laminar/CitX/APU/starter_switch_up") 
	end))
afterLandingProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTING",FlowItem.actorFO,0,"apustarting",
	function () return get("sim/cockpit/engine/APU_N1") > 3 end))
afterLandingProc:addItem(IndirectProcedureItem:new("#spell|APU#","STARTED",FlowItem.actorFO,0,"apurunning",
	function () return get("sim/cockpit/engine/APU_N1") == 100 end,
	function () command_end("laminar/CitX/APU/starter_switch_up") end))
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
		return get("laminar/CitX/throttle/ratio_L") < 0.3 and 
			get("laminar/CitX/throttle/ratio_R",1) < 0.3
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
-- WHEEL CHOCKS................................SET
shutdownProc:addItem(ProcedureItem:new("#spell|APU# GEN","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/APU/gen_switch") == 1 end,
	function () 
		command_once("laminar/CitX/APU/gen_switch_up") 
		command_once("laminar/CitX/APU/gen_switch_up") 
	end))
shutdownProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() > 0 end,
	function () 
		sysAir.apuBleedSwitch:actuate(1)
	end))
shutdownProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))
shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","CUT",FlowItem.actorCAPT,0,"throttlescutland",
	function ()
		return get("laminar/CitX/throttle/ratio_L") < 0 and 
			get("laminar/CitX/throttle/ratio_R",1) < 0
	end))
shutdownProc:addItem(ProcedureItem:new("PSG BELT & SAFETY LT","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/seat_belt_pass_safety") == 0 end,
	function () 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_dwn") 
		command_once("laminar/CitX/lights/cmd_seat_belt_pass_safety_up") 
	end))
shutdownProc:addItem(ProcedureItem:new("GEN LH & RH","OFF",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 0 and 
			sysElectric.gen2Switch:getStatus() == 0
	end,
	function ()
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("WINDSHIELD HEAT LH & RH","OFF",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("L & R ENG BLD AIR","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.engBleedGroup:getStatus() == 0
	end,
	function () 
		sysAir.engBleedGroup:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("EMERG LT","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/lights/emerg_light_switch") == 0 end,
	function () 
		command_once("laminar/CitX/lights/emerg_light_switch_dwn")
		command_once("laminar/CitX/lights/emerg_light_switch_dwn")
	end))
shutdownProc:addItem(ProcedureItem:new("FUEL BOOST BOTH","OFF",FlowItem.actorFO,0,
	function () 
		return get("laminar/CitX/fuel/boost_left") == 0 and 
		get("laminar/CitX/fuel/boost_right") == 0 
	end,
	function ()  
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_left_up")
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_right_up")
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
shutdownProc:addItem(ProcedureItem:new("HYD PUMP A & B","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end)) 
shutdownProc:addItem(ProcedureItem:new("AUX PUMP A","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))





-- STANDBY ATTITUDE ADI|CAGED
-- shutdownProc:addItem(ProcedureItem:new("AVIONICS SWITCH","OFF",FlowItem.actorFO,0,
	-- function () return sysElectric.avionicsSwitchGroup:getStatus() == 0 end,
	-- function () sysElectric.avionicsSwitchGroup:actuate(0) end))
-- shutdownProc:addItem(ProcedureItem:new("EICAS SWITCH","OFF",FlowItem.actorFO,0,
	-- function () return get("laminar/CitX/electrical/avionics_eicas") == 0 end,
	-- function () 
		-- if get("laminar/CitX/electrical/avionics_eicas") == 1 then
			-- command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		-- end
	-- end))
-- shutdownProc:addItem(ProcedureItem:new("STANDBY POWER","OFF",FlowItem.actorFO,0,
	-- function () return get("laminar/CitX/electrical/battery_stby_pwr") == 0 end,
	-- function () 
		-- command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	-- end))
-- shutdownProc:addItem(ProcedureItem:new("BATTERY SWITCH 1 & 2","OFF",FlowItem.actorFO,0,
	-- function () return sysElectric.batterySwitch:getStatus() == 0 and sysElectric.battery2Switch:getStatus() == 0 end,
	-- function () 
		-- sysElectric.batterySwitch:actuate(0) 
		-- sysElectric.battery2Switch:actuate(0) 
	-- end))

-- PARKING:
-- Parking Brake ............... As Required
-- Anti Ice System ............. OFF
-- Throttle .................... IDLE
-- Fuel Control Switches ....... OFF
-- Beacon ...................... OFF

-- TERMINATION:
-- Parking Brake ............... OFF
-- IRS Mode .................... OFF
-- Passenger Advisory Lights ... OFF
-- STBY Power .................. OFF
-- Avionics Switch ............. OFF
-- Emergency Lgiths ............ OFF
-- GRVTY XFlow Switch .......... OFF
-- APU ......................... OFF

-- ============  =============
-- add the checklists and procedures to the active sop
-- local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(preflightChkl)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(beforeStart)
activeSOP:addProcedure(pushProc)
activeSOP:addProcedure(preStartProc)
activeSOP:addProcedure(pushstartProc)
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
activeSOP:addProcedure(gearDownProc)
activeSOP:addProcedure(flaps5Proc)
activeSOP:addProcedure(flaps15Proc)
activeSOP:addProcedure(flapsFullProc)
activeSOP:addProcedure(APLandOffProc)
activeSOP:addProcedure(landingChecklist)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(taxiLightOff)
activeSOP:addProcedure(shutdownProc)

-- === States ===
-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("C&D","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
		electricalPowerUpProc:setState(Flow.NEW)
		getActiveSOP():setActiveFlowIndex(1)
	end))

activeSOP:addState(coldAndDarkProc)

local turnaroundProc = State:new("TURNAROUND STATE","","")
turnaroundProc:setFlightPhase(18)
turnaroundProc:addItem(ProcedureItem:new("START APU","DONE","SYS",2,true,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
		sysElectric.apuMasterSwitch:actuate(1)
		command_begin("laminar/CitX/APU/starter_switch_up") 
	end))
turnaroundProc:addItem(ProcedureItem:new("TURNAROUND STATE","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
		command_once("laminar/CitX/APU/gen_switch_up") 
		command_once("laminar/CitX/APU/gen_switch_up") 
		command_once("laminar/CitX/APU/bleed_switch_dwn")
		command_once("laminar/CitX/APU/bleed_switch_dwn")
		command_once("laminar/CitX/APU/bleed_switch_up")
		electricalPowerUpProc:setState(Flow.FINISH)
		getActiveSOP():setActiveFlowIndex(3)
	end))

activeSOP:addState(turnaroundProc)

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

function getActiveSOP()
	return activeSOP
end


return SOP_C750
