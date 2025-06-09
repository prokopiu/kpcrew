-- SOP X-Crafts E-Jet XP12

-- @classmod SOP_E1XX
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

SOP_E1FF = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("X-CRAFTS E-JET FAMILY SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("FUEL PUMPS","AUTO",FlowItem.actorCPT,0,
		function () return get("XCrafts/fuel/ac_pump_left_sw") == 1 end,
		function () 
			sysFuel.allFuelPumpGroup:actuate(1)
			command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
			command_once("XCrafts/fuel/fuel_DC_pump_switch_ccw_cmnd")
			command_once("XCrafts/fuel/fuel_DC_pump_switch_cw_cmnd")
			command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
			command_once("XCrafts/fuel/fuel_transfer_sw_ccw_cmnd")
			command_once("XCrafts/fuel/fuel_transfer_sw_cw_cmnd")
		end))

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("IDG","AUTO",FlowItem.actorCPT,0,
		function () return sysElectric.genSwitchGroup:getStatus() > 0 end,
		function () 
			sysElectric.genSwitchGroup:actuate(1)
		end))
--
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("STERILE SWITCH","ON",FlowItem.actorCPT,0,
		function () return get("XCrafts/light/sterile_switch") > 0 end,
		function () 
			set("XCrafts/light/sterile_switch",1)
		end))

activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("HYDRAULIC PUMP 3A","ON",FlowItem.actorCPT,0,
		function () return get("XCrafts/hydraulic/sys3_elec_pump_a_switch") > 0 end,
		function () 
			set("XCrafts/hydraulic/sys3_elec_pump_a_switch",1)
		end))


return SOP_E1XX

