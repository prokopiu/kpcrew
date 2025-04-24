-- SOP Aerobask Epic E1000

-- @classmod SOP_EPIC
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

SOP_EVIC = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("AEROBASK EPIC E1000 SOP")

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AUTO FUEL SELECT","ON",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_fuel_auto") == 1 end,
		function () 
			if get("aerobask/lt_fuel_auto") == 0 then
				command_once("aerobask/fuel_auto_toggle")
			end
		end))
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("AIRCONDITIONING","SET",FlowItem.actorCPT))

activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("AUTOPILOT SYSTEM","ON",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_otto") == 1 end,
		function () 
			if get("aerobask/lt_otto") == 0 then
				command_once("aerobask/otto_pwr_toggle")
			end
		end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("TRIM","ON",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_trim") == 1 end,
		function () 
			if get("aerobask/lt_trim") == 0 then
				command_once("aerobask/trim_toggle")
			end
		end))

activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("AUTOPILOT SYSTEM","OFF",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_otto") == 0 end,
		function () 
			if get("aerobask/lt_otto") == 1 then
				command_once("aerobask/otto_pwr_toggle")
			end
		end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("TRIM","OFF",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_trim") == 0 end,
		function () 
			if get("aerobask/lt_trim") == 1 then
				command_once("aerobask/trim_toggle")
			end
		end))
		

activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("AUTO FUEL SELECT","OFF",FlowItem.actorCPT,0,
		function () return get("aerobask/lt_fuel_auto") == 0 end,
		function () 
			if get("aerobask/lt_fuel_auto") == 1 then
				command_once("aerobask/fuel_auto_toggle")
			end
		end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(HoldProcedureItem:new("AIRCONDITIONING","OFF",FlowItem.actorCPT))

return SOP_EPIC

-- doors do not close