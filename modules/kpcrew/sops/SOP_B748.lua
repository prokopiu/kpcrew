-- SOP SSG Boeing 747-8 XP12

-- @classmod SOP_B748
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

SOP_B742 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("SSG B747-8 SOP")

-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("RADIOS","ON",FlowItem.actorFO,0,
	-- function () return get("B742/OVHD/radio_master_bus_ESS_on") == 1 end,
	-- function () 
		-- set("B742/OVHD/radio_master_bus_ESS_on",1)
		-- set("B742/OVHD/radio_master_bus_NO2_on",1)
	-- end))
	
-- === before start

-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ANTI SKID","ON",FlowItem.actorFO,0,
	-- function () return get("B742/OVHD/anti_skid_on_off_sw") == 1 end,
	-- function () 
		-- set("B742/OVHD/anti_skid_on_off_sw",1)
		-- set("B742/OVHD/anti_skid_on_off_cap",0)
	-- end))
	
-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("YAW DAMPERS","ON",FlowItem.actorFO,0,
	-- function () return sysMCP.yawDamper:getStatus() > 0 end,
	-- function () sysMCP.yawDamper:actuate(1) end))

-- === Before Takeoff
-- activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("WX RADAR","WX",FlowItem.actorFO,0,
	-- function () return sysEFIS.wxrPilot:getStatus() == 3 end,
	-- function () sysEFIS.wxrPilot:setValue(3) end))
	
-- === Runway entry
-- activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("BODY GEAR STEERING","DISARM",FlowItem.actorFO,0,
	-- function () return get("B742/OVHD/body_gear_steer_sw") == 1 end,
	-- function () end))
	
-- === After Takeoff
-- activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ProcedureItem:new("FUEL HEAT","AUTO",FlowItem.actorFO,0,
	-- function () return get("B742/FUEL/fuel_heat_sw") == 1 end,
	-- function () 
		-- set_array("B742/FUEL/fuel_heat_sw",0,-1)
		-- set_array("B742/FUEL/fuel_heat_sw",1,-1)
		-- set_array("B742/FUEL/fuel_heat_sw",2,-1)
		-- set_array("B742/FUEL/fuel_heat_sw",3,-1)
	-- end))
	
-- === Climb Checks
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	-- function () return sysEngines.engStarterGroup:getStatus() == 0 end,
	-- function () sysEngines.engStarterGroup:setValue(0) end))
	
-- === landing
-- activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("ENGINE IGNITION","FLT START",FlowItem.actorFO,0,
	-- function () return sysEngines.engStarterGroup:getStatus() < 0 end,
	-- function () sysEngines.engStarterGroup:setValue(-1) end))
	
-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("WX RADAR","STBY",FlowItem.actorFO,0,
	-- function () return sysEFIS.wxrPilot:getStatus() == 1 end,
	-- function () sysEFIS.wxrPilot:setValue(1) end))

return SOP_B748