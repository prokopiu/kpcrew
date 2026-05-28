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

activeSOP:setName("ZIBO / LEVELUP SOP")

-- === Turnaround state
-- activeSOP:getFlow(proc_ind_turnAroundState):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))

-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("OTHER ITEMS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_custom_turnaround() end))
activeSOP:getFlow(proc_ind_electrical):addItem(HoldProcedureItem:new("LOAD & FLIGHTPLAN","SET",FlowItem.actorCPT))
	
-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("CHOCKS","REMOVED",FlowItem.actorFO,0,
	function () return get("laminar/B738/fms/chock_status") == 0 end,
	function () set("laminar/B738/fms/chock_status",0) end))
	
-- === pre push & start
-- activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("LDU","SET ENG",FlowItem.actorFO,0,
	function () return get("laminar/B738/systems/lowerDU_page") == 1 end,
	function () 
		if get("laminar/B738/systems/lowerDU_page") == 2 then command_once("laminar/B738/LDU_control/push_button/MFD_ENG") end
		if get("laminar/B738/systems/lowerDU_page") ~= 1 then command_once("laminar/B738/LDU_control/push_button/MFD_ENG") end
	end))

-- === Engine start
-- activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("LDU","SET SYS",FlowItem.actorFO,0,
	function () return get("laminar/B738/systems/lowerDU_page2") == 1 end,
	function () 
		if get("laminar/B738/systems/lowerDU_page2") == 0 then command_once("laminar/B738/LDU_control/push_button/MFD_SYS") end
	end))

-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("PRESSURE ALTITUDE","SET CRUISE ALT",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("LDU","OFF",FlowItem.actorFO,0,
	function () return get("laminar/B738/systems/lowerDU_page") == 0 end,
	function () 
		if get("laminar/B738/systems/lowerDU_page") == 1 then command_once("laminar/B738/LDU_control/push_button/MFD_ENG") end
		if get("laminar/B738/systems/lowerDU_page") == 2 then command_once("laminar/B738/LDU_control/push_button/MFD_ENG") end
		if get("laminar/B738/systems/lowerDU_page2") == 1 then command_once("laminar/B738/LDU_control/push_button/MFD_SYS") end
	end))
	
-- === Before Takeoff
-- activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("ENGINE STARTERS","CONT",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end))
	
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
activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ProcedureItem:new("GEAR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/B738/controls/gear_handle_down") == 0.5 end,
	function () command_once("laminar/B738/push_button/gear_off") end))	
activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ProcedureItem:new("ENGINE STARTERS","NORMAL",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end))
	
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
activeSOP:getFlow(proc_ind_flapsland):addItem(ProcedureItem:new("ENGINE STARTERS","CONT",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end))
	
-- === landing checklist
-- activeSOP:getFlow(proc_ind_LandingCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("ENGINE STARTERS","NORMAL",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end))
	
-- === Shutdown
-- activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("CHOCKS","SET",FlowItem.actorFO,0,
	function () return get("laminar/B738/fms/chock_status") == 1 end,
	function () set("laminar/B738/fms/chock_status",1) end))

-- === C&D
-- activeSOP:getFlow(proc_ind_coldAndDarkState):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_coldAndDarkState):setFlowItem(2,ProcedureItem:new("STAIRS","EXTEND IF NEEDED",FlowItem.actorFO,1,
		function () if activeBriefings:get("taxi:gateStand") > 1 then return sysGeneral.stairsL1:getStatus() == 1 else return sysGeneral.stairsL1:getStatus() == 0 end end,
		function () if activeBriefings:get("taxi:gateStand") > 1 then sysGeneral.stairsL1:actuate(1) else sysGeneral.stairsL1:actuate(0) end end))	
activeSOP:getFlow(proc_ind_coldAndDarkState):addItem(ProcedureItem:new("GPU DISCONNECT","SET","SYS",0,true,
	function () if kc_has_gpu then sysElectric.gpuConnect:actuate(0) end 
		getActiveSOP():reset() getActiveSOP():setActiveFlowIndex(1) -- reset to power up flow
		kc_procvar_set("callouts",false)	-- stop callouts
	end))
	
return SOP_B737
