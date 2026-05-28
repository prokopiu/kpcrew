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
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 1 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 1
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,1)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,1)
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("TAIL WHEEL","LOCK",FlowItem.actorCPT,0,
		function () return get("sim/cockpit/engine/idle_speed",0) == 0 end,
		function () 
			if get("sim/cockpit/engine/idle_speed",0) == 1 then
				command_once("sim/engines/idle_hi_lo_toggle")
			end
		end))

--
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("PROP LEVERS","FULL FORWARD",FlowItem.actorCPT,0,
		function () return get("sim/flightmodel/engine/ENGN_prop",0) > 157 and get("sim/flightmodel/engine/ENGN_prop",1) > 157 end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("MIXTURE LEVERS","AUTO RICH DETENT",FlowItem.actorCPT,0,
		function () return get("awx/c47/Cockpit/mixture_lever_L") == 2 and get("awx/c47/Cockpit/mixture_lever_R") == 2 end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("THROTTLE LEVERS","CRACKED 1 INCH",FlowItem.actorCPT,0,
		function () return get("sim/cockpit2/engine/actuators/hardware_throttle_ratio",0) > 0.1 and get("sim/cockpit2/engine/actuators/hardware_throttle_ratio",1) > 0.1 end))

-- 
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("INVERTER","ON",FlowItem.actorCPT,0,
		function () return get("sim/cockpit/engine/inverter_on",0) == 1 end,
		function () 
			set_array("sim/cockpit/engine/inverter_on",0,1)
		end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("COWL FLAPS","OPEN",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 1 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 1
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,1)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,1)
		end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("TAIL WHEEL","UNLOCK",FlowItem.actorCPT,0,
		function () return get("sim/cockpit/engine/idle_speed",0) == 1 end,
		function () 
			if get("sim/cockpit/engine/idle_speed",0) == 0 then
				command_once("sim/engines/idle_hi_lo_toggle")
			end
		end))

-- background door and stair procedures
-- kc_procvar_initialize_bool("door1open", false) 
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("COWL FLAPS","TRAIL",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 0.5 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 0.5
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,0.5)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,0.5)
		end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("FUEL PUMPS","ON",FlowItem.actorCPT,0,
		function () return sysFuel.allFuelPumpGroup:getStatus() > 0 end,
		function () 
			sysFuel.allFuelPumpGroup:actuate(1)
		end))		

--
-- activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("TAIL WHEEL","LOCKED",FlowItem.actorCPT,0,
		-- function () return get("sim/cockpit/engine/idle_speed",0) == 0 end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(HoldProcedureItem:new("T/O POWER 42-48 INHG, 2700 RPM, ROTATE 85 KTS","OK",FlowItem.actorCPT))

--
activeSOP:getFlow(proc_ind_flapsUp):addItem(HoldProcedureItem:new("INITIAL CLIMB POWER 42 INHG, 2550 RPM","OK",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_flapsUp):addItem(ProcedureItem:new("FUEL PUMPS","OFF",FlowItem.actorCPT,0,
		function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
		function () 
			sysFuel.allFuelPumpGroup:actuate(0)
		end))		
activeSOP:getFlow(proc_ind_flapsUp):addItem(ProcedureItem:new("COWL FLAPS","TRAIL",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 0.5 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 0.5
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,0.5)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,0.5)
		end))

--
activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("CLIMB 36 INHG, 2350 RPM, SPEED 110-120 KTS","OK",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("CRUISE 25-34 INHG, 1700-2250 RPM, LEAN MANUAL","OK",FlowItem.actorCPT))

--
-- activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("TAIL WHEEL","LOCKED",FlowItem.actorCPT,0,
		-- function () return get("sim/cockpit/engine/idle_speed",0) == 0 end,
		-- function () 
			-- if get("sim/cockpit/engine/idle_speed",0) == 1 then
				-- command_once("sim/engines/idle_hi_lo_toggle")
			-- end
		-- end))
activeSOP:getFlow(proc_ind_descent):addItem(HoldProcedureItem:new("PROP 1800-2700 RPM, CHECK CYL TEMP","OK",FlowItem.actorCPT))

--
activeSOP:getFlow(proc_ind_landing):addItem(HoldProcedureItem:new("APPROACH 20-25 INHG, 2000 RPM, AUTO RICH","OK",FlowItem.actorCPT))

--
activeSOP:getFlow(proc_ind_flapsland):addItem(ProcedureItem:new("FUEL PUMPS","ON",FlowItem.actorCPT,0,
		function () return sysFuel.allFuelPumpGroup:getStatus() > 0 end,
		function () 
			sysFuel.allFuelPumpGroup:actuate(1)
		end))
activeSOP:getFlow(proc_ind_flapsland):addItem(ProcedureItem:new("PROP LEVERS","FULL FORWARD",FlowItem.actorCPT,0,
		function () return get("sim/flightmodel/engine/ENGN_prop",0) > 157 and get("sim/flightmodel/engine/ENGN_prop",1) > 157 end))
activeSOP:getFlow(proc_ind_flapsland):addItem(HoldProcedureItem:new("VREF 85 KTS","OK",FlowItem.actorCPT))

--
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("COWL FLAPS","OPEN",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/cowl_flap_ratio",0) == 1 and
			get("sim/cockpit2/engine/actuators/cowl_flap_ratio",1) == 1
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",0,1)
			set_array("sim/cockpit2/engine/actuators/cowl_flap_ratio",1,1)
		end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("TAIL WHEEL","UNLOCK",FlowItem.actorCPT,0,
		function () return get("sim/cockpit/engine/idle_speed",0) == 1 end,
		function () 
			if get("sim/cockpit/engine/idle_speed",0) == 0 then
				command_once("sim/engines/idle_hi_lo_toggle")
			end
		end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("FUEL PUMPS","OFF",FlowItem.actorCPT,0,
		function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
		function () 
			sysFuel.allFuelPumpGroup:actuate(0)
		end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("CARBURATOR HEAT","COLD",FlowItem.actorCPT,0,
		function () 
			return get("sim/cockpit2/engine/actuators/carb_heat_ratio",0) == 0 and
			get("sim/cockpit2/engine/actuators/carb_heat_ratio",1) == 0
		end,
		function () 
			set_array("sim/cockpit2/engine/actuators/carb_heat_ratio",0,0)
			set_array("sim/cockpit2/engine/actuators/carb_heat_ratio",1,0)
		end))
		
return SOP_ADC3