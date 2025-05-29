-- SOP Aeroworx C47/DC3

-- @classmod SOP_ADC3
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

SOP_ADC3 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("AEROWORX DC-3 SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("COWL FLAPS","OPEN",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 0 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 0
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,0)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,0)
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("TAIL HOOK","LOCK",FlowItem.actorCPT,0,
		function () return get("sim/cockpit/engine/idle_speed",0) == 0 end,
		function () 
			if get("sim/cockpit/engine/idle_speed",0) == 1 then
				command_once("sim/engines/idle_hi_lo_toggle")
			end
		end))
		
-- background door and stair procedures
-- kc_procvar_initialize_bool("door1open", false) 

return SOP_ADC3