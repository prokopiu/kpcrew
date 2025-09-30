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

-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
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
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_electrical):addItem(HoldProcedureItem:new("== COCKPIT PREPARATION CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("COCKPIT PREPARATION CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("GEAR PINS & COVERS","REMOVED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("FUEL QUANTITY","CHECKED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("SEAT BELTS","ON",FlowItem.actorFO,1,
	function () return sysGeneral.passSignsSwitch:getStatus() == 1 end,
	function () sysGeneral.passSignsSwitch:actuate(1) end))	
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("ADIRS","NAV",FlowItem.actorFO,1,
	function () return sysGeneral.irsUnitGroup:getStatus() > 1 end,
	function () 
		if kc_is_airbus == true then 
			kc_macro_set_irs(1)
		else
			kc_macro_set_irs(2)
		end
	end))	
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("BARO REF","ALL SET TO QNH",FlowItem.actorBOTH,1,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_electrical):addItem(ChecklistItem:new("COCKPIT PREPARATION CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end

-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ELEC HYD PUMP","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
	
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_beforeStart):addItem(HoldProcedureItem:new("== BEFORE START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("BEFORE START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|activeBriefings:get(\"takeoff:v1\")|activeBriefings:get(\"takeoff:vr\")|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorFO,7,true))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("WINDOWS","CLOSED",FlowItem.actorBOTH,1,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("BEACON","ON",FlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))	
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("BEFORE START CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end

-- === Engine start
-- activeSOP:getFlow(proc_ind_engStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
	
-- === After Start
-- activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("== AFTER START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ANTI-ICE SYSTEMS","AS REQUIRED",FlowItem.actorFO,2,
		function () return true end,
		function () kc_macro_aice(kc_phase_after_start) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("#exchange|ECAM STATUS|e cam status","CHECKED",FlowItem.actorBOTH,1,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("PITCH TRIM","(%3.2f)|activeBriefings:get(\"takeoff:elevatorTrim\")",FlowItem.actorCPT,1,
	function () return (kc_round_step(get("AirbusFBW/PitchTrimPosition")*1000,10)/1000 == activeBriefings:get("takeoff:elevatorTrim")) end))	
	-- function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*1000,10)/1000 == activeBriefings:get("takeoff:elevatorTrim")*100/100) end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("RUDDER TRIM","NEUTRAL",FlowItem.actorCPT,1,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))	
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end	
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("== TAXI CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("TAXI CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorFO,1,"fccheck",
	function() 
		if kc_full_rgt_rudder > 0 then 
			return sysControls.rudderDeflection:getStatus() > kc_full_rgt_rudder
		else
			return sysControls.rudderDeflection:getStatus() < kc_full_rgt_rudder
		end
	end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("FLAPS SETTING","CONFIG %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPM,2,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])] end,
	function () kc_macro_set_flap(tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("RADAR & #spell|PWS#","ON & AUTO",FlowItem.actorCPT,1,
	function () return sysEFIS.wxrPilot:getStatus() == 1 end,
	function () sysEFIS.wxrPilot:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ENGINE MODE SELECTOR","NORMAL",FlowItem.actorFO,1,
	function () return sysEngines.engIgnitionGroup:getStatus() == 1 end,
	function () sysEngines.engIgnitionGroup:setValue(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("#exchange|ECAM MEMO|e cam memo. Flaps","TAKEOFF NO BLUE",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))	
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
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_runwayEntry):addItem(HoldProcedureItem:new("== LINEUP CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ChecklistItem:new("LINEUP CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ChecklistItem:new("TAKEOFF RUNWAY","%s|activeBriefings:get(\"flight:planrwy\")",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ChecklistItem:new("TCAS","ON",FlowItem.actorFO,1,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
	function () 
		kc_macro_set_xpdrmode(sysRadios.tara)
		local xpdrcode = activeBriefings:get("departure:squawk")
		sysRadios.xpdrCode:setValue(xpdrcode)
	end))	
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ChecklistItem:new("PACKS","%s|activeBriefings:get(\"takeoff:packs\")<2 and \"AUTO\" or \"OFF\"",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ChecklistItem:new("LINEUP CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end	
	
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
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("LS","ON",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ILSonCapt") == 1 end,
	function () set("AirbusFBW/ILSonCapt",1) end))
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_landing):addItem(HoldProcedureItem:new("== APPROACH CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("APPROACH CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("BARO REFERENCE","%s SET|activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorFO,3,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("SEAT BELTS","ON",FlowItem.actorFO,1,
	function () return sysGeneral.passSignsSwitch:getStatus() == 1 end,
	function () sysGeneral.passSignsSwitch:actuate(1) end))		
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("MINIMUM","%s feet|activeBriefings:get(\"approach:decision\")",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorFO,2,
		function () return sysControls.Autobrake:getStatus() == tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")]) end,
		function () kc_macro_set_autobrake(tonumber(kc_pref_split(kc_LandingAutoBrInd)[activeBriefings:get("approach:autobrake")])) 
		end))	
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("ENGINE MODE SELECTOR","NORM",FlowItem.actorCPT,2,
	function () return sysEngines.engIgnitionGroup:getStatus() == 1 end,
	function () sysEngines.engIgnitionGroup:actuate(0) end))
activeSOP:getFlow(proc_ind_landing):addItem(ChecklistItem:new("APPROACH CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end

-- === landing Flow
-- activeSOP:getFlow(proc_ind_flapsland):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

-- === landing checklist
-- activeSOP:getFlow(proc_ind_LandingCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_LandingCheck):addItem(ChecklistItem:new("GO AROUND ALTITUDE","%s FT|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_LandingCheck):addItem(ChecklistItem:new("CABIN CREW","ADVISED",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_LandingCheck):addItem(ChecklistItem:new("ECAM MEMO","LANDING NO BLUE",FlowItem.actorFO,1,
	function () return true end,
	function ()  end))	

-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("LS","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/ILSonCapt") == 0 end,
	function () set("AirbusFBW/ILSonCapt",0) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("RADAR & #spell|PWS#","OFF",FlowItem.actorCPT,1,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:setValue(0) end))
	
-- === Shutdown
-- activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("EMER LTS","OFF",FlowItem.actorFO,0,
	function () return get("AirbusFBW/OHPLightSwitches",10) == 0 end,
	function () set_array("AirbusFBW/OHPLightSwitches",10,0) end))
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_shutdownProc):addItem(HoldProcedureItem:new("== PARKING CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("PARKING CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(IndirectChecklistItem:new("ENGINES","OFF",FlowItem.actorCPT,1,"throttlescutland",
		function () return sysEngines.engStarterGroup:getStatus() == 0 end,
		function () sysEngines.engStarterGroup:actuate(0) end))	
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("WING LIGHTS","OFF",FlowItem.actorFO,1,
	function () return sysLights.wingSwitch:getStatus() == 0 end,
	function () sysLights.wingSwitch:actuate(0) end))	
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("FUEL PUMPS","OFF",FlowItem.actorFO,1,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(0) end))	
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("PARKING CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end
	
return SOP_A3TL