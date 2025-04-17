-- Generic  SOP for Laminar MD-82

-- @classmod SOP_MD82
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

SOP_MD82 = require("kpcrew.sops.SOP_DFLT")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

activeSOP:setName("Laminar MD-82 SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))

-- ===========

activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ENG IGN SELECTOR","SYS A OR SYS B",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") ~= 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_dwn")
	end))

-- ===========

activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("ENG IGN SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 0 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_dwn")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("START PUMP SW (DC)","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit/engine/fuel_pump_on",0) == 0 end,
	function () 
		set_array("sim/cockpit/engine/fuel_pump_on",0,0)
	end))

-- ===========

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("APU BUS","OFF",FlowItem.actorCPT,0,
	function () return
		sysElectric.apuGenBusGroup:getStatus() == 0 
	end,
	function () 
		sysElectric.apuGenBusGroup:actuate(0)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("BUS TIES","AUTO / OPEN",FlowItem.actorCPT,0,
	function () return
		get("laminar/md82/electrical/cross_tie_AC") == 1 and 
		get("laminar/md82/electrical/cross_tie_DC") == 0
	end,
	function () 
		set_array("sim/cockpit/electrical/generator_on",0,1)
		set_array("sim/cockpit/electrical/generator_on",1,1)
		if get("laminar/md82/electrical/cross_tie_DC") == 1 then 
			command_once("laminar/md82cmd/electrical/cross_tie_DC")
		end
		if get("laminar/md82/electrical/cross_tie_AC") == 0 then 
			command_once("laminar/md82cmd/electrical/cross_tie_AC")
		end
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AIR COND SHUTOFF SWITCH","AUTO",FlowItem.actorFO,0,
	function () return 
		get("laminar/md82/bleedair/bleedair_HVAC_L") == 2 and 
		get("laminar/md82/bleedair/bleedair_HVAC_R") == 2  
	end,
	function () 
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
		command_once("laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn")
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("ANTI SKID","ARM",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/generic_lights_switch",35) == 1 end,
	function () 
		set_array("sim/cockpit2/switches/generic_lights_switch",35,1)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("PITOT AND STATIC HEATERS","CAPT",FlowItem.actorFO,0,
	function () return get("laminar/md82/ice/heatknob") == 1 end,
	function () 
		while get("laminar/md82/ice/heatknob") ~= 1 do
			command_once("laminar/md82cmd/ice/selheatknob_up")
		end
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))
		
-- ===========
	
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("SPEED BUGS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () 
		kc_macro_md82_set_to_speedbugs()
	end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("ENG IGN SELECTOR","OVRD",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 4 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_up")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("GALLEY POWER","OFF",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 0 end,
	function () sysElectric.galleyPower:actuate(0) end))


-- ==========
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.galleyPower:getStatus() == 1 end,
	function () sysElectric.galleyPower:actuate(1) end))
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("ENG IGN SELECTOR","OFF",FlowItem.actorFO,0,
	function () return get("laminar/md82/ignition_sys") == 4 end,
	function () 
		command_once("laminar/md82cmd/ignition_sys_dn")
		command_once("laminar/md82cmd/ignition_sys_dn")
		command_once("laminar/md82cmd/ignition_sys_dn")
		command_once("laminar/md82cmd/ignition_sys_dn")
		command_once("laminar/md82cmd/ignition_sys_dn")
		command_once("laminar/md82cmd/ignition_sys_up")
	end))	
	
-- =========
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("SPEED BUGS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () 
		kc_macro_md82_set_ldg_speedbugs()
	end))
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))
	
return SOP_MD82
