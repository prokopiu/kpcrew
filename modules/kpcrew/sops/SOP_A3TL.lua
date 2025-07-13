-- Generic SOP for ToLiss Airbusses

-- @classmod SOP_A3TL
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

SOP_A3TL = require("kpcrew.sops.SOP_DFLT")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

activeSOP:setName("ToLiss Airbuses SOP")

-- Power up addons
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("APU BATT","ON",FlowItem.actorFO,0,
		function () return sysElectric.battery3Switch:getStatus() > 0 end,
		function () sysElectric.battery3Switch:actuate(1) end))
end 	
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GALLEY POWER","AUTO",FlowItem.actorFO,0,
		function () return get("AirbusFBW/ElecOHPArray",9) > 0 end,
		function () set_array("AirbusFBW/ElecOHPArray",9,1) end))
end 
if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("COMMERCIAL","ON",FlowItem.actorFO,0,
		function () return get("AirbusFBW/ElecOHPArray",8) > 0 end,
		function () set_array("AirbusFBW/ElecOHPArray",8,1) end))
end 
if PLANE_ICAO == "A346" then
	activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ELMU","ON",FlowItem.actorFO,0,
		function () return get("AirbusFBW/ElecOHPArray",18) > 0 end,
		function () set_array("AirbusFBW/ElecOHPArray",18,1) end))
end 
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("EMER LTS","ARM",FlowItem.actorFO,0,
	function () return get("AirbusFBW/OHPLightSwitches",10) == 1 end,
	function () set_array("AirbusFBW/OHPLightSwitches",10,1) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("CREW SUPPLY","AUTO",FlowItem.actorFO,0,
	function () return get("AirbusFBW/CrewOxySwitch") == 1 end,
	function () set("AirbusFBW/CrewOxySwitch",1) end))
if PLANE_ICAO ~= "A339" and PLANE_ICAO ~= "A346" then
	activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("PACK FLOW","NORMAL",FlowItem.actorFO,0,
		function () return get("ckpt/oh/packFlow") == 1 end,
		function () set("ckpt/oh/packFlow",1) end))
end 
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("RMPS","ON",FlowItem.actorFO,0,
	function () return 
		get("AirbusFBW/RMP1Switch") +
		get("AirbusFBW/RMP2Switch") + 
		get("AirbusFBW/RMP3Switch") == 3
	end,
	function () 
		set("AirbusFBW/RMP1Switch",1) 
		set("AirbusFBW/RMP2Switch",1) 
		set("AirbusFBW/RMP3Switch",1) 
	end))	


-- before start
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ELEC HYD PUMP","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))

-- landing Procedure
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("LS","ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ILSonCapt") == 1 end,
	function () set("AirbusFBW/ILSonCapt",1) end))
	
-- Shutdown addons
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("EMER LTS","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/OHPLightSwitches",10) == 0 end,
	function () set_array("AirbusFBW/OHPLightSwitches",10,0) end))
	
return SOP_A3TL

-- A339 A/Brk MAX not set
-- A339 T/O spoilers not armed
