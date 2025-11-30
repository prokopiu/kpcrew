-- Base SOP for FlightFactor B757 & B767

-- @classmod SOP_B7x7
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

SOP_B7x7 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("FlightFactor B757/B767")

-- === before start

-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("OTHER ITEMS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_custom_turnaround() end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("STATUS DISPLAY","ON",FlowItem.actorFO,0,
		function () return get("1-sim/eicas/StatusFlag") == 1 end,
		function () set("1-sim/eicas/StatusFlag",1) end))
	
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_electrical):addItem(HoldProcedureItem:new("== PREFLIGHT CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("PREFLIGHT CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("#spell|IRS#","#exchange|NAV|naff#",FlowItem.actorFO,1,
	function () return sysGeneral.irsUnitGroup:getStatus() > 0 end,
	function () sysGeneral.irsUnitGroup:setValue(kc_irs_nav) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("ANTI-ICE","OFF",FlowItem.actorFO,1,
		function () return sysAice.engAntiIceGroup:getStatus() == 0 and sysAice.wingAntiIce:getStatus() == 0  end,
		function () 
			sysAice.engAntiIceGroup:actuate(0) 
			sysAice.wingAntiIce:actuate(0)
		end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("PRESSURIZATION","SET & AUTO",FlowItem.actorFO,2,
	function () return get("1-sim/press/modeSelector") == 0 end,
	function () set("1-sim/press/modeSelector",0) set("1-sim/press/modeSelector/anim",0) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_pull_baro_from_metar(origmetar)",FlowItem.actorFO,2,
	function () return kc_macro_test_local_baro() end,
	function () end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("OXYGEN","TESTED 100%",FlowItem.actorFO,3,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("FUEL CONTROL SWITCHES","CUTOFF",FlowItem.actorFO,3,
	function () return get("1-sim/fuel/fuelCutOffLeft") == 0 and get("1-sim/fuel/fuelCutOffRight") == 0 end,
	function () 
		set("1-sim/fuel/fuelCutOffLeft",0) 
		set("1-sim/fuel/fuelCutOffRight",0)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("HYDRAULIC PANEL","SET",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("PASSENGER SIGNS","ON & ON",FlowItem.actorFO,2,
	function () return sysGeneral.noSmokingSwitch:getStatus() == 1 and sysGeneral.passSignsSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.noSmokingSwitch:actuate(1)
		sysGeneral.passSignsSwitch:actuate(1)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("PREFLIGHT CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end

-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("REMOVE EXTERNAL OBJECTS","DONE",FlowItem.actorFO,0,
	function () return get("params/stairs") == 0 end,
	function () 
		set("params/stairs",0)
		set("params/LSU",0)
		set("prep/loader",0)
		set("params/gpu",0)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("LANDING ALTITUDE","SET",FlowItem.actorFO,2,
	function () return true end,
	function () sysAir.landingAltitude:setValue(kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),10)) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("SECONDARY ENGINE DISPLAY","ON",FlowItem.actorFO,2,
		function () return get("1-sim/eicas/SecondaryEngFlag") == 1 end,
		function () set("1-sim/eicas/SecondaryEngFlag",1) end))	
		
-- === before push and Start
-- activeSOP:getFlow(proc_ind_prePushStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_prePushStart):addItem(HoldProcedureItem:new("== BEFORE START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("BEFORE START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("FUEL PANEL","SET",FlowItem.actorFO,3,
	function () return sysFuel.allFuelPumpGroup:getStatus() > 0 and sysFuel.fuelCrossFeed:getStatus() == 0 end,
	function () 
		sysFuel.fuelCrossFeed:actuate(0) 
		sysFuel.allFuelPumpGroup:actuate(1)
	end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("ANTI COLLISION LIGHT","ON",FlowItem.actorFO,3,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("PACKS","OFF",FlowItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () kc_macro_air(kc_phase_before_start) end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("TRANSPONDER","ALT OFF",FlowItem.actorFO,3,
	function () return get("1-sim/transponder/systemMode") == 2 end,
	function () set("1-sim/transponder/systemMode",2) end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,3,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
activeSOP:getFlow(proc_ind_prePushStart):addItem(ChecklistItem:new("BEFORE START CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end	

-- === Engine start
-- activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("STATUS DISPLAY","ON",FlowItem.actorFO,2,
		function () return get("1-sim/eicas/StatusFlag") == 1 end,
		function () set("1-sim/eicas/StatusFlag",1) end))
		
-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AUTO BRAKES","R T O",FlowItem.actorFO,0,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeRTO end,
		function () kc_macro_set_autobrake(kc_AutoBrakeRTO) end))
		
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("== AFTER START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("APU","OFF",FlowItem.actorFO,3,
			function () return sysElectric.apuMaster:getStatus() == 0 end,
			function () sysElectric.apuMaster:actuate(0) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ANTI-ICE SYSTEMS","AS REQUIRED",FlowItem.actorFO,2,
		function () return true end,
		function () kc_macro_aice(kc_phase_after_start) end))			
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ISOLATION SWITCH","ON",FlowItem.actorFO,2,
		function () return get("anim/59/button") == 1 end,
		function () set("anim/59/button",1) end))			
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("PACKS","ON",FlowItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() > 0 end,
	function () kc_macro_air(kc_phase_after_start) end))			
activeSOP:getFlow(proc_ind_afterStart):addItem(IndirectChecklistItem:new("RECALL","CHECK",FlowItem.actorFO,1,"recallcheck",
		function () return get("1-sim/gauges/caution_recall") == 1 end,
		function ()  end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AUTO BRAKES","R T O",FlowItem.actorFO,3,
		function () return sysControls.Autobrake:getStatus() == kc_AutoBrakeRTO end,
		function () kc_macro_set_autobrake(kc_AutoBrakeRTO) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("WINDOWS","CLOSED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end	
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("== TAXI CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("TAXI CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(IndirectChecklistItem:new("BRAKES","CHECKED",FlowItem.actorFO,3,"brakecheck",
			function () return get("sim/cockpit2/controls/left_brake_ratio") > 0 and
				get("sim/cockpit2/controls/right_brake_ratio") > 0 end,
			function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,3,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end)) 
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,2,"fccheck",
	function () 
		if kc_full_rgt_rudder > 0 then 
			return sysControls.rudderDeflection:getStatus() > kc_full_rgt_rudder
		else
			return sysControls.rudderDeflection:getStatus() < kc_full_rgt_rudder
		end
	 end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("SECONDARY ENGINE DISPLAY","ON",FlowItem.actorFO,2,
		function () return get("1-sim/eicas/SecondaryEngFlag") == 1 end,
		function () set("1-sim/eicas/SecondaryEngFlag",1) end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("TAXI CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end	

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

return SOP_B7x7
