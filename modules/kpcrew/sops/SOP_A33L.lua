-- SOP Laminar A330 & Variants XP12

-- @classmod SOP_A33L
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

SOP_A33L = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("LAMINAR A330 & VARIANTS SOP")

-- Power up addons
activeSOP:getFlow(1):addItem(ProcedureItem:new("EMER LTS","ARM",FlowItem.actorFO,0,
	function () return get("laminar/a333/switches/emer_exit_lt_pos") == 1 end,
	function () 
		if get("laminar/a333/switches/emer_exit_lt_pos") == 0 then
			command_once("laminar/A333/toggle_switch/emer_exit_lt_up")
		end
	end))
activeSOP:getFlow(1):addItem(ProcedureItem:new("CREW SUPPLY","AUTO",FlowItem.actorFO,0,
	function () return get("laminar/A333/buttons/oxy/crew_valve_pos") == 1 end,
	function () 
		if get("laminar/A333/buttons/oxy/crew_valve_pos") == 0 then
			command_once("sim/oxy/crew_valve_toggle")
		end 
	end))
activeSOP:getFlow(1):addItem(ProcedureItem:new("PACK FLOW","AUTO",FlowItem.actorFO,0,
	function () return get("laminar/A333/pressurization/knobs/pack_flow_pos") == 0 end,
	function () 
		if get("laminar/A333/pressurization/knobs/pack_flow_pos") == -1 then
			command_once("laminar/A333/knobs/press_press_flow_right")
		elseif get("laminar/A333/pressurization/knobs/pack_flow_pos") == 1 then
			command_once("laminar/A333/knobs/press_press_flow_left")
		end
	end))	
activeSOP:getFlow(1):addItem(ProcedureItem:new("RMPS","ON",FlowItem.actorFO,0,
	function () return 
		get("laminar/A333/comm/rtp_L/off_status") +
		get("laminar/A333/comm/rtp_R/off_status") + 
		get("laminar/A333/comm/rtp_C/off_status") == 0
	end,
	function () 
		if get("laminar/A333/comm/rtp_L/off_status") == 1 then
			command_once("laminar/A333/rtp_L/off_switch")
		end
		if get("laminar/A333/comm/rtp_R/off_status") == 1 then
			command_once("laminar/A333/rtp_R/off_switch")
		end
		if get("laminar/A333/comm/rtp_C/off_status") == 1 then
			command_once("laminar/A333/rtp_C/off_switch")
		end
	end))	
	
-- flapsup
activeSOP:getFlow(14):addItem(HoldProcedureItem:new("A/P 1","DISCONNECT",FlowItem.actorCPT))
activeSOP:getFlow(14):addItem(ProcedureItem:new("A/P","DISCONNECT",FlowItem.actorFO,0,
	function () return get("laminar/A333/annun/autopilot/ap1_mode") == 0 end,
	function () 
			command_once("sim/autopilot/priority_pb_left")
	end))
activeSOP:getFlow(14):addItem(ProcedureItem:new("A/P","DISCONNECTED",FlowItem.actorFO,0,
	function () return true end,
	function () 
			command_once("sim/annunciator/clear_master_warning")
	end))

return SOP_A33L
