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
-- BATTERY SWITCH 1 & 2...........................ON		:(laminar/CitX/electrical/battery_right:1)&&(laminar/CitX/electrical/battery_left:1)
-- LANDING GEAR HANDLE..........................DOWN
--   GREEN LANDING GEAR LIGHT......CHECK ILLUMINATED
-- FLAP LEVER.....................................UP		:sim/cockpit2/controls/flap_ratio:0
-- AUX PUMP A.....................................ON		:laminar/CitX/hydraulics/aux_pump:1
-- HYDRAULIC A PRESSURE..............CHECK >2000 PSI		:sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1:>2000
-- PARKING BRAKE.................................SET		:laminar/CitX/brakes/park_handle:1
-- EXTERNAL POWER........................AS REQUIRED		depends on setting
-- IGNITION......................................OFF		:(laminar/CitX/engine/ignition_switch_right:0)&&(laminar/CitX/engine/ignition_switch_left:0)
-- COCKPIT LIGHTS........................AS REQUIRED		depends on daylight

-- == Electric Power
-- STANDBY POWER................................TEST 
-- STANDBY POWER..................................ON		:laminar/CitX/electrical/battery_stby_pwr:1
-- AVIONICS SWITCH................................ON		:laminar/CitX/electrical/avionics:1
-- EICAS SWITCH...................................ON		:laminar/CitX/electrical/avionics_eicas:1
-- NAV GND REC (BEACON)...........................ON		:sim/cockpit/electrical/beacon_lights_on:1
-- FUEL BOOST..............................BOTH NORM		:(sim/cockpit2/engine/actuators/fuel_pump_on[1]:2)&&(sim/cockpit2/engine/actuators/fuel_pump_on[0]:2)

-- == APU ON
-- APU SYSTEM MASTER..............................ON		:laminar/CitX/APU/master_switch:1
-- APU START.........................HOLD TILL START		:laminar/CitX/APU/starter_switch:1
-- APU N1 100%.................................READY		:sim/cockpit2/electrical/APU_N1_percent:>=99
-- APU GEN........................................ON		when available :sim/cockpit/electrical/generator_apu_on:1
-- APU BLEED AIR..................................ON		:sim/cockpit2/bleedair/actuators/apu_bleed:1
-- APU AMPS LESS 200A..........................CHECK		:sim/cockpit/electrical/generator_apu_amps:<200
-- BATTERIES..........................CHECK 24 VOLTS		:(sim/cockpit2/electrical/battery_voltage_indicated_volts[1]:>24)&&(sim/cockpit2/electrical/battery_voltage_indicated_volts[2]:>24)
-- =======================================================

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","","")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH 1 & 2","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() == 1 and sysElectric.battery2Switch:getStatus() == 1 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.battery2Switch:actuate(1) 
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXT PWR","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuSwitch:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("AVIONICS SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.avionicsSwitchGroup:getStatus() == 1 end,
	function () sysElectric.avionicsSwitchGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("DISPLAYS","ON",FlowItem.actorFO,0,
	function () return sysLights.dispLightGroup:getStatus() > 0 end,
	function () sysLights.dispLightGroup:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("PANEL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,true,
	function () 
		if kc_is_daylight() then		
			sysLights.domeLightGroup:setValue(0)
			sysLights.instrLightGroup:actuate(0)
			if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
				command_once("laminar/CitX/lights/dimming_switch_toggle")
			end
		else
			sysLights.domeLightGroup:setValue(1)
			sysLights.instrLightGroup:actuate(1)
			if get("laminar/CitX/lights/dim_lights_switch") == 0 then
				command_once("laminar/CitX/lights/dimming_switch_toggle")
			end
		end	
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR HANDLE","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
electricalPowerUpProc:addItem(ProcedureItem:new("AUX PUMP A","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("HYDRAULIC A PRESSURE","CHECK >2000 PSI",FlowItem.actorFO,0,"hydapress",
	function () return get("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1") > 2000 end))
electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("IGNITION LH & RH","OFF",FlowItem.actorFO,0,
	function () return sysEngines.igniterGroup:getStatus() == 0 end,
	function () sysEngines.igniterGroup:actuate(0) end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Electric Power"))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("STANDBY POWER","TEST",FlowItem.actorFO,2,"stbytest",
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == -1 end,
	function () 
		command_begin("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == 1 end,
	function () 
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EICAS SWITCH","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/avionics_eicas") == 1 end,
	function () 
		if get("laminar/CitX/electrical/avionics_eicas") == 0 then
			command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("NAV GND REC (BEACON)","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() > 0 end,
	function () sysLights.beaconSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL BOOST","BOTH NORM",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == -2 end,
	function () sysFuel.allFuelPumpGroup:actuate(2) end))


electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== APU ON"))
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# SYSTEM MASTER","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuMasterSwitch:getStatus() == 1 end,
	function () sysElectric.apuMasterSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# STARTER","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuStartSwitch:getStatus() == 1 end,
	function () command_begin("laminar/CitX/APU/starter_switch_up") end))
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
electricalPowerUpProc:addItem(ProcedureItem:new("#spell|APU# BLEED AIR","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/APU/bleed_air_switch") == 0.5 end,
	function () 
		command_once("laminar/CitX/APU/bleed_switch_dwn") 
		command_once("laminar/CitX/APU/bleed_switch_dwn") 
		command_once("laminar/CitX/APU/bleed_switch_up") 
	end))
	


-- ============ PRELIMINARY PREFLIGHT PROCEDURES =========
-- ELECTRICAL POWER UP......................COMPLETE (F/O)
-- STALL WARNING TEST........................PERFORM (F/O)
--   AC power must be available
-- XPDR.....................................SET 2000 (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS..........SET AS REQUIRED (F/O)
-- FUEL PUMPS................................ALL OFF (F/O)
-- POSITION LIGHTS................................ON (F/O)
-- MCP....................................INITIALIZE (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- Electric hydraulic pumps on for F/O walk-around
-- ELECTRIC HYDRAULIC PUMPS SWITCHES..............ON (F/O)
-- =======================================================

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight","I finished the preliminary preflight")
prelPreflightProc:setFlightPhase(2)
prelPreflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 1 or
		sysElectric.gpuOnBus:getStatus() == 1
	end))
prelPreflightProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",FlowItem.actorFO,0,"stall_warning_test1",
	function () return get("sim/cockpit2/annunciators/stall_warning") == 1 end,
	function () command_begin("sim/annunciator/test_stall") end))
prelPreflightProc:addItem(SimpleProcedureItem:new("  AC power must be available"))
prelPreflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () command_end("sim/annunciator/test_stall") sysRadios.xpdrCode:actuate(2000) end))
prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 1 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) sysFuel.fuelPumpLeftAft:actuate(modeOn) end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.fuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.fuelPumpGroup:actuate(modeOff) end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		sysMCP.fdirGroup:actuate(modeOff)
		sysMCP.athrSwitch:actuate(modeOff)
		sysMCP.crs1Selector:actuate(1)
		sysMCP.crs2Selector:actuate(1)
		sysMCP.iasSelector:actuate(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:actuate(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.altSelector:actuate(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:actuate(modeOff)
		sysMCP.discAPSwitch:actuate(modeOff)
	end))
prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(SimpleProcedureItem:new("Electric hydraulic pumps on for F/O walk-around"))
prelPreflightProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 1 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOn) end))

-- ================ Preflight Procedure ==================
-- ==== Flight control panel                            
-- YAW DAMPER SWITCH..............................ON (F/O)

-- ==== Fuel panel                                      
-- FUEL PUMP SWITCHES........................ALL OFF (F/O)
--   If APU running turn one of the left fuel pumps on
-- FUEL CROSS FEED...............................OFF (F/O)
-- CROSS FEED VALVE LIGHT...............EXTINGUISHED (F/O)

-- ==== Electrical panel                                
-- BATTERY SWITCH.......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH..........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH.....................ON (F/O)
-- STANDBY POWER SWITCH.................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES.......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH..................GUARD CLOSED (F/O)

-- ==== APU start if required
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH..................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT.......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH............TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 2 TO RIGHT (F/O)
-- APU PANEL
-- APU SWITCH..................................START (F/O)
--   Hold APU switch in START position for 3-4 seconds.
-- APU GEN OFF BUS LIGHT.................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES.....................ON (F/O)

-- ==== Overhead items
-- EQUIPMENT COOLING SWITCHES...................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH.........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH..............................ON (F/O)
-- FASTEN BELTS SWITCH............................ON (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)

-- ==== Anti-Ice
-- WINDOW HEAT SWITCHES...........................ON (F/O)
-- WINDOW HEAT ANNUNCIATORS............. ILLUMINATED (F/O)
-- PROBE HEAT SWITCHES...........................OFF (F/O)
-- WING ANTI-ICE SWITCH..........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES......................OFF (F/O)
-- =======================================================


-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
-- activeSOP:addProcedure(prelPreflightProc)

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


return SOP_C750
