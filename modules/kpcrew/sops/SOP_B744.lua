-- SOP MSparks Boeing 747-400 XP12

-- @classmod SOP_B744
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

SOP_B744 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("MSPARKS B747-400 SOP")

activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("UTILITY BUS","ON",FlowItem.actorFO,0,
	function () return
		get("laminar/B747/button_switch/position",11) + get("laminar/B747/button_switch/position",12) > 1
	end,
	function () 
		if get("laminar/B747/button_switch/position",11) == 0 then
			command_once("laminar/B747/button_switch/elec_util_L")
		end
		if get("laminar/B747/button_switch/position",12) == 0 then
			command_once("laminar/B747/button_switch/elec_util_R")
		end
	end))

activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("AUTOSTART","ON",FlowItem.actorFO,0,
	function () return
		get("laminar/B747/button_switch/position",45) == 1
	end,
	function () 
		if get("laminar/B747/button_switch/position",45) == 0 then
			command_once("laminar/B747/button_switch/start_autostart")
		end
	end))	

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("TRIM AIR","ON",FlowItem.actorFO,0,
	function () return
		get("laminar/B747/button_switch/position",37) == 1
	end,
	function () 
		if get("laminar/B747/button_switch/position",37) == 0 then
			command_once("laminar/B747/button_switch/temp_trim_air")
		end
	end))	

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("RECIRC UPR & LWR","ON",FlowItem.actorFO,0,
	function () return
		get("laminar/B747/button_switch/position",38) > 0 and 
		get("laminar/B747/button_switch/position",39) > 0
	end,
	function () 
		if get("laminar/B747/button_switch/position",38) == 0 then
			command_once("laminar/B747/button_switch/temp_recirc_upr")
		end
		if get("laminar/B747/button_switch/position",39) == 0 then
			command_once("laminar/B747/button_switch/temp_recirc_lwr")
		end
	end))	

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AFT CARGO HT AIR","ON",FlowItem.actorFO,0,
	function () return
		get("laminar/B747/button_switch/position",40) == 1
	end,
	function () 
		if get("laminar/B747/button_switch/position",40) == 0 then
			command_once("laminar/B747/button_switch/temp_aft_cargo_ht")
		end
	end))	

activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("EQUIP COOLING","NORM",FlowItem.actorFO,0,
	function () return true end,
	function () 
		command_once("laminar/B747/air/equip_cooling/sel_dial_dn")
		command_once("laminar/B747/air/equip_cooling/sel_dial_dn")
		command_once("laminar/B747/air/equip_cooling/sel_dial_up")
	end))	

return SOP_B744
-- 			elseif PLANE_ICAO == "B74F" then ULDLoaderFwdPositionFactor = -1.3 
-- line 3084