-- SOP X-Crafts ERJs XP12

-- @classmod SOP_ER1X
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

SOP_ER1X = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("X-CRAFTS ERJ FAMILY SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("MASTER WARNING","CANCEL",FlowItem.actorFO,0,
		function () return true end,
		function () command_once("sim/annunciator/clear_master_warning") end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("SHED BUSES","AUTO",FlowItem.actorFO,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",28) == 1 end,
		function () set_array("sim/cockpit2/switches/generic_lights_switch",28,1) end))
		
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ENG PUMP SELECTOR","1A/2A",FlowItem.actorFO,0,
		function () return 
			get("sim/cockpit2/switches/generic_lights_switch",31) == 0 and
			get("sim/cockpit2/switches/generic_lights_switch",32) == 0 
		end,
		function () 
			set_array("sim/cockpit2/switches/generic_lights_switch",31,0) 
			set_array("sim/cockpit2/switches/generic_lights_switch",32,0) 
		end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("FUS TK XFER","OFF",FlowItem.actorFO,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",37) == 1 end,
		function () 
			set_array("sim/cockpit2/switches/generic_lights_switch",37,1) -- FUS TK XFER OFF
		end))
	
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("STAB ICE PROTECTION","AUTO",FlowItem.actorFO,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",12) == 1 end,
		function () 
			set_array("sim/cockpit2/switches/generic_lights_switch",12,1) 
		end))
	
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ICE DETECTION OVERRIDE","AUTO",FlowItem.actorFO,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",34) == 1 end,
		function () set_array("sim/cockpit2/switches/generic_lights_switch",34,1) end))
	
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GASPER","AUTO",FlowItem.actorFO,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",19) == 1 end,
		function () set_array("sim/cockpit2/switches/generic_lights_switch",19,1) end))

--		
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("STERILE LIGHT","ON",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",6) > 0 end,
		function () set_array("sim/cockpit2/switches/generic_lights_switch",6,1) end))

-- 
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("CABIN ALTITUDE","SET 7500",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft") == 7500 end,
		function () set("sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft",7500) end))
		
--
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("STERILE LIGHT","OFF",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/switches/generic_lights_switch",6) == 0 end,
		function () set_array("sim/cockpit2/switches/generic_lights_switch",6,0) end))

--
activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("CABIN ALTITUDE","SET FOR LANDING ",FlowItem.actorCPT,0,
		function () return true end,
		function () set("sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft",activeBriefings:get("arrival:aptElevation")) end))

return SOP_ER1X

