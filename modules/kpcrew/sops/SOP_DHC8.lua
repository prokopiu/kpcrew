-- SOP ZIBO MOD LEVELUP

-- @classmod SOP_B737
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

SOP_B737 = require("kpcrew.sops.SOP_DFLT")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

activeSOP:setName("RIVIERE DHC8 SOP")

-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))

-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
	
-- === Engine start
-- activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
	
-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))

-- === Before Takeoff
-- activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === Runway entry
-- activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))

-- === Gear up
-- activeSOP:getFlow(proc_ind_gearUp):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === After Takeoff
-- activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))	

-- === Climb Checks
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("","",FlowItem.actorCPT))

-- ==== Descend Checks
-- activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === Arrival
-- activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === landing Flow
-- activeSOP:getFlow(proc_ind_flapsland):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === landing checklist
-- activeSOP:getFlow(proc_ind_LandingCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === Shutdown
-- activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
return SOP_B737
