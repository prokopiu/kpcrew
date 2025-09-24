-- Generic SOP for iniBuilds A300-600

-- @classmod SOP_A306
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

SOP_A306 = require("kpcrew.sops.SOP_DFLT")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

activeSOP:setName("iniBuilds A300-600 SOP")

-- set("A300/mixture_ratio2_target",1)
			
-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("RADIOS","ON",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("BRAKE/ASKID","NORM/ON",FlowItem.actorFO,0,
	function () return get("A300/brakes/brake_system") == 0 end,
	function () set("A300/brakes/brake_system",0) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("YAW DAMPER 1&2","ON",FlowItem.actorFO,0,
	function () return sysMCP.yawDamper:getStatus() > 0 end,
	function () sysMCP.yawDamper:setValue(1) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ATS 1&2","ON",FlowItem.actorFO,0,
	function () return get("A300/fctl/autothrottle_master_switch") == 1 and get("A300/fctl/autothrottle_master_switch2") == 1 end,
	function () 
		set("A300/fctl/autothrottle_master_switch",1) 
		set("A300/fctl/autothrottle_master_switch2",1) 
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("SMOKE DETECTION","ON",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set("A300/SMOKEDET/main1",1)
		set("A300/SMOKEDET/main2",1)
		set("A300/SMOKEDET/main_mid1",1)
		set("A300/SMOKEDET/main_mid2",1)
		set("A300/SMOKEDET/main_aft1",1)
		set("A300/SMOKEDET/main_aft2",1)
		set("A300/SMOKEDET/cargo_after1",1)
		set("A300/SMOKEDET/cargo_after2",1)
		set("A300/SMOKEDET/cargo_after_bulk1",1)
		set("A300/SMOKEDET/cargo_after_bulk2",1)
		set("A300/SMOKEDET/cargo_forward1",1)
		set("A300/SMOKEDET/cargo_forward2",1)
	end))

-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ANTI SKID","ON",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("CARGO","HIDE",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set_array("A300/GND/cargo_boxes_show",0,0)
		set_array("A300/GND/cargo_boxes_show",1,0)
		set_array("A300/GND/cargo_boxes_show",2,0)
		set_array("A300/GND/cargo_boxes_show",3,0)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("OXYGEN SUPPLY","SET",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set("A300/OXYGEN/low_pressure_supply",1)
		set("A300/OXYGEN/low_press_current2",1)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("APU GEN","ON",FlowItem.actorFO,0,
	function () return true end,
	function () sysElectric.apuGenBus1:setValue(1) end))
	
-- === Engine start
activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("CARGO","HIDE",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set_array("A300/GND/cargo_boxes_show",0,0)
		set_array("A300/GND/cargo_boxes_show",1,0)
		set_array("A300/GND/cargo_boxes_show",2,0)
		set_array("A300/GND/cargo_boxes_show",3,0)
	end))

-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("YAW DAMPERS","ON",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("IGNITION","OFF",FlowItem.actorFO,0,
	function () return get("A300/engine_ignition_switch") == 3 end,
	function () set("A300/engine_ignition_switch",3) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("PITCH TRIM 1&2","ON",FlowItem.actorFO,0,
	function () return get("A300/fctl/pitch_trim1") == 1 and get("A300/fctl/pitch_trim2") == 1 end,
	function () 
		set("A300/fctl/pitch_trim1",1) 
		set("A300/fctl/pitch_trim2",1) 
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("CARGO","HIDE",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set_array("A300/GND/cargo_boxes_show",0,0)
		set_array("A300/GND/cargo_boxes_show",1,0)
		set_array("A300/GND/cargo_boxes_show",2,0)
		set_array("A300/GND/cargo_boxes_show",3,0)
	end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("ENGINE MODE","SET AS REQD",FlowItem.actorCPT))
	
-- === Before Takeoff
-- activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("WX RADAR","WX",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === Runway entry
-- activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("PACKS & BLEEDS","AS REQUIRED",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("TAXI LIGHTS","TO",FlowItem.actorFO,0,
	function () return true end,
	function () set("A300/lights/nose_light_switch",2) end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("IGNITION","CONT RELIGHT",FlowItem.actorFO,0,
	function () return get("A300/engine_ignition_switch") == 4 end,
	function () set("A300/engine_ignition_switch",4) end))
	
-- === Gear up
-- activeSOP:getFlow(proc_ind_gearUp):addItem(ProcedureItem:new("EPRL","CLB & SPD MODE",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_gearUp):addItem(ProcedureItem:new("TAXI LIGHTS","OFF",FlowItem.actorFO,0,
	function () return true end,
	function () set("A300/lights/nose_light_switch",0) end))
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("ABRK/ASKID","OFF",FlowItem.actorFO,0,
	function () return true end,
	function () set("A300/brakes/brake_system",3) end))
	
-- === After Takeoff
	
-- === Climb Checks
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("SET EPRL","CRZ & MACH MODE",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("IGNITION","OFF",FlowItem.actorFO,0,
	function () return get("A300/engine_ignition_switch") == 3 end,
	function () set("A300/engine_ignition_switch",3) end))

-- ==== Descend Checks
-- activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("ABRK/ASKID","ON",FlowItem.actorFO,0,
	function () return true end,
	function () set("A300/brakes/brake_system",0) end))
	
-- === landing
-- activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("ENGINE IGNITION","FLT START",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("IGNITION","CONT RELIGHT",FlowItem.actorFO,0,
	function () return get("A300/engine_ignition_switch") == 4 end,
	function () set("A300/engine_ignition_switch",4) end))
	
-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("WX RADAR","STBY",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("IGNITION","OFF",FlowItem.actorFO,0,
	function () return get("A300/engine_ignition_switch") == 3 end,
	function () set("A300/engine_ignition_switch",3) end))
	
-- === Shutdown
-- activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("GASPER","OFF",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

	
return SOP_A306