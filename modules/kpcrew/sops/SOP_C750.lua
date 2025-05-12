-- Base SOP Laminar Citation X 750 for XP12

-- @classmod SOP_C750
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

SOP_C750 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("LAMINAR CITATION X SOP")

-- Electrical Power Up
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("POWER LEVERS","CUT OFF",FlowItem.actorPF,0,
	function () return 
		sysEngines.mixtureLever:getStatus() == 0 
	end,
	function () 
		sysEngines.mixtureLever:actuate(0)
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("EICAS SWITCH","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/avionics_eicas") == 1 end,
	function () 
		if get("laminar/CitX/electrical/avionics_eicas") == 0 then
			command_once("laminar/CitX/electrical/cmd_avionics_eicas_toggle")
		end
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/battery_stby_pwr") == 1 end,
	function () 
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("DC LOAD SHED/EMER PWR","NORM/CHECKED",FlowItem.actorFO,0,
	function () return get("laminar/CitX/electrical/load_shed") == 0 end,
	function ()  
		command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
		command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
		command_once("laminar/CitX/electrical/cmd_load_shed_up")
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ISO VLV CLOSE","OFF / GUARDED",FlowItem.actorFO,0,
	function () return get("laminar/CitX/pressurization/iso_vlv") == 0 and get("laminar/CitX/pressurization/safeguard_iso_vlv") == 0 end,
	function ()
		if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
		end
		if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
			command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
		end
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("BLEED ISOL VALVE","OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == 0 end,
	function ()
		sysAir.isoValveSwitch:actuate(0)
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(IndirectProcedureItem:new("PRESSURIZATION ALT","(%i) %i FT|get(\"laminar/CitX/pressurization/altitude\")|activeBriefings:get(\"departure:aptElevation\")",FlowItem.actorCPT,0,"pressalt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 
			activeBriefings:get("departure:aptElevation")) < 100 
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(IndirectProcedureItem:new("ROTARY TEST","CHECK",FlowItem.actorCPT,0,"rotarytest",
	function () return get("sim/cockpit/warnings/autopilot_test_ap_lit") == 1 end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GRAVITY XFLOW","OFF",FlowItem.actorFO,0,
	function () return get("laminar/CitX/fuel/gravity_flow") == 0 end,
	function ()
		if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
			command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
		end
	end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("CTR WING XFER LH & RH","BOTH NORMAL",FlowItem.actorFO,0,
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
	
-- Before Start
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("STANDBY ATTITUDE ADI","UNCAGED",FlowItem.actorCPT,0,
	function () return get("sim/cockpit/gyros/gyr_cage_ratio",2) < 1 end))

activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("PRESSURIZATION SOURCES","ALL NORM",FlowItem.actorFO,0,
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

activeSOP:getFlow(proc_ind_beforeStart):addItem(IndirectProcedureItem:new("PRESSURIZATION","CRUISE ALT (%i) 7500 FT|get(\"laminar/CitX/pressurization/altitude\")",FlowItem.actorPM,0,"cruisealt",
	function () 
		return math.abs(get("laminar/CitX/pressurization/altitude") - 7500) < 100 
	end,
	function ()
		set("laminar/CitX/pressurization/altitude",kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50)) 
	end))

activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("IGNITION SWITCHES","NORMAL",FlowItem.actorFO,0,
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

-- After Start

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AUX PUMP A","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("PRESSURIZATION SOURCES","ALL NORM",FlowItem.actorFO,0,
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

-- BEFORE TAKEOFF
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("ANTISKID","NORM",FlowItem.actorFO,0,
	function () return sysGeneral.antiSkid:getStatus() == 0 end,
	function () 
		sysGeneral.antiSkid:actuate(0)
	end))
	
-- RUNWAY ENTRY
activeSOP:getFlow(proc_ind_runwayEntry):addItem(IndirectProcedureItem:new("THRUST SETTING","FAN% ~80",FlowItem.actorPF,0,"tomode",
	function () return get("laminar/CitX/throttle/ratio_ALL") > 0.70 end,
	function () 
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
	end))

-- AP1 OFF
activeSOP:getFlow(proc_ind_ap1off):addItem(ProcedureItem:new("FD","TURN ON AGAIN",FlowItem.actorPF,0,
	function () return sysMCP.fdirPilotSwitch:getStatus() > 0 end,
	function () 
		sysMCP.fdirPilotSwitch:actuate(1)
	end))

activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("AVIONICS","KEEP ON",FlowItem.actorFO,0,
	function () return true end,
	function () sysElectric.avionicsSwitchGroup:actuate(1) end))


return SOP_C750