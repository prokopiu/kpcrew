-- SOP LES Saab SF34

-- @classmod SOP_SF34
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

SOP_SF34 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("LES SAAB SF34 SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("WX RADAR","STBY",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/inst/anm/wrcp_mode_knob") == 1 end,
		function () 
			if get("les/sf34a/acft/inst/anm/wrcp_mode_knob") == 0 then
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_up")
			end
			if get("les/sf34a/acft/inst/anm/wrcp_mode_knob") > 1 then
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_dn")
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_dn")
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_dn")
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_dn")
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_dn")
				command_once("les/sf34a/acft/inst/mnp/wrcp_mode_knob_up")
			end
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("CABIN PRESSURE","AUTO",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/pres/anm/auto_man_switch") == 1 end,
		function () 
			if get("les/sf34a/acft/pres/anm/auto_man_switch") ~= 0 then
				command_once("les/sf34a/acft/pres/mnp/auto_man_mode_switch")
			end
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GUST LOCK","RELEASE",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/fltc/anm/gust_lock_release_switch") == 1 end,
		function () 
			if get("les/sf34a/acft/fltc/anm/gust_lock_release_switch") == 0 then
				command_once("les/sf34a/acft/fltc/mnp/gust_lock_release_switch")
			end
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GUST LOCK","LOCKED",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/fltc/anm/gust_lock_lever") == 1 end,
		function () 
			set("les/sf34a/acft/fltc/mnp/gust_lock_lever",1)
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("PROP SYNC","OFF",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/fltc/anm/gust_lock_lever") == 1 end,
		function () 
			if get("les/sf34a/acft/engn/anm/prop_sync_switch") == 1 then
				command_once("les/sf34a/acft/engn/mnp/prop_sync_switch")
			end
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("DOORS","OPEN",FlowItem.actorCPT,0,
		function () return true end,
		function () 
			if get("les/sf34a/acft/emrg/anm/cargo_door") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/cargo_door")
			end
			if get("les/sf34a/acft/emrg/anm/main_door") == 1 then
				command_once("les/sf34a/acft/emrg/mnp/main_door")
			end
		end))

-- before engine start
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("DOORS","CLOSE",FlowItem.actorCPT,2,
		function () return true end,
		function () 
			if get("les/sf34a/acft/emrg/anm/cargo_door") == 1 then
				command_once("les/sf34a/acft/emrg/mnp/cargo_door")
			end
			if get("les/sf34a/acft/emrg/anm/main_door") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/main_door")
			end
		end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("DOORS","LOCK",FlowItem.actorCPT,2,
		function () return true end,
		function () 
			if get("les/sf34a/acft/emrg/anm/cargo_door_handle") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/cargo_door_handle")
			end
			if get("les/sf34a/acft/emrg/anm/main_door_handle") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/main_door_handle")
			end
		end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("AUTO COARSEN","OFF",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/engn/anm/autocoarsen_switch") == 0 end,
		function () 
			if get("les/sf34a/acft/engn/anm/autocoarsen_switch") == 1 then
				command_once("les/sf34a/acft/engn/mnp/autocoarsen_switch")
			end
		end))
		
activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("CONDITON LEVER","MAX",FlowItem.actorCPT,0,
		function () return get("les/sf34a/acft/engn/anm/autocoarsen_switch") == 0 end,
		function () 
			set("les/sf34a/acft/engn/mnp/condition_lever_L",90)
			set("les/sf34a/acft/engn/mnp/condition_lever_R",90)
		end))

		
-- background door and stair procedures
kc_procvar_initialize_bool("door1open", false) 
kc_procvar_initialize_bool("door1close", false) 
kc_procvar_initialize_bool("cargoopen", false) 
kc_procvar_initialize_bool("cargoclose", false) 
kc_procvar_initialize_bool("stairsout", false) 
kc_procvar_initialize_bool("stairsin", false) 

return SOP_SF34

-- FD lässt sich nicht schalten