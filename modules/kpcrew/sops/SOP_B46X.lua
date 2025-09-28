-- Generic SOP for JustFlight BAE146

-- @classmod SOP_B46X
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

SOP_B46X = require("kpcrew.sops.SOP_DFLT")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

activeSOP:setName("JustFlight BAE 146 SOP")
			
-- === power up
-- activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("OTHER ITEMS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_custom_turnaround() end))

	
-- === before start
-- activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return  end,
	-- function () end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("OTHER ITEMS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set("thranda/views/chocks",0) 
		sysAice.engAntiIceGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(0)
		set("thranda/electrical/StarterSw",1)
		set("thranda/electrical/StartPWR",1)
		sysAir.apuBleedSwitch:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
		sysHydraulic.PTU:actuate(0)
	end))
	
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_beforeStart):addItem(HoldProcedureItem:new("== BEFORE START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("BEFORE START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("BEACON","ON",FlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("PACKS & #spell|APU# AIR","OFF",FlowItem.actorFO,1,
	function () return sysAir.packSwitchGroup:getStatus() == 0 and sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () 
		sysAir.packSwitchGroup:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("ENGINE ANTI ICE","ON",FlowItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("HYDRAULIC PUMPS","OFF",FlowItem.actorFO,1,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(0) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("START POWER","NORMAL",FlowItem.actorFO,1,
	function () return get("thranda/electrical/StartPWR") == 1 end,
	function () set("thranda/electrical/StartPWR",1) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ChecklistItem:new("START MASTER","ON",FlowItem.actorFO,1,
	function () return get("thranda/electrical/StarterSw") == 1 end,
	function () set("thranda/electrical/StarterSw",1) end))
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
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("OTHER ITEMS","SET",FlowItem.actorFO,0,
	function () return true end,
	function () 
		set("thranda/gear/AntiSkid",2)
		set("thranda/electrical/StarterSel",2)
		set("thranda/electrical/StarterSw",0)
		sysAice.engAntiIceGroup:actuate(0)
		if get("thranda/brakes/brakeFanOn") == 0 then
			command_once("thranda/switches/SwitchUp08")
		end
		sysElectric.genSwitchGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysAice.windowHeatGroup:actuate(1)
		set("thranda/ice/LeftPitot",1)
		set("thranda/ice/RightPitot",1)
		set("thranda/ice/StbyPitot",1)
		sysAir.engBleedGroup:actuate(1)

	end))

if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterStart):addItem(HoldProcedureItem:new("== AFTER START CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("START POWER","NORMAL",FlowItem.actorFO,1,
	function () return get("thranda/electrical/StartPWR") == 1 end,
	function () set("thranda/electrical/StartPWR",1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("START SELECT & MASTER","OFF",FlowItem.actorFO,2,
	function () return get("thranda/electrical/StarterSw") == 0 and get("thranda/electrical/StarterSel") == 2 end,
	function () 
		set("thranda/electrical/StarterSw",0) 
		set("thranda/electrical/StarterSel",2)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ENGINE ANTI ICE","OFF",FlowItem.actorFO,2,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("GENERATORS","ON",FlowItem.actorFO,1,
	function () return sysElectric.genSwitchGroup:getStatus() > 1 end,
	function () sysElectric.genSwitchGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("BRAKE FANS","AUTO",FlowItem.actorFO,1,
	function () return get("thranda/brakes/brakeFanOn") == 1 end,
	function () 
		if get("thranda/brakes/brakeFanOn") == 0 then
			command_once("thranda/switches/SwitchUp08")
		end
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("HYDRAULICS","ON",FlowItem.actorFO,1,
	function () return sysHydraulic.engHydPumpGroup:getStatus() > 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("HEATERS","ON",FlowItem.actorFO,1,
	function () return 
		sysAice.windowHeatGroup:getStatus() > 0 and 
		get("thranda/ice/LeftPitot") == 1 and 
		get("thranda/ice/RightPitot") == 1 and 
		get("thranda/ice/StbyPitot") == 1 
	end,
	function () 
		sysAice.windowHeatGroup:actuate(1) 
		set("thranda/ice/LeftPitot",1)
		set("thranda/ice/RightPitot",1)
		set("thranda/ice/StbyPitot",1)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("ENGINE AIR","ON",FlowItem.actorFO,1,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("PACKS","ON",FlowItem.actorFO,1,
	function () return sysAir.packSwitchGroup:getStatus() > 0 end,
	function () sysAir.packSwitchGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("DOORS & WINDOWS","CLOSED",FlowItem.actorFO,2,
	function () return true end,
	function () end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("CHOCKS & GROUND EQUIPMENT","CLEAR",FlowItem.actorFO,2,
	function () return get("thranda/views/chocks")  == 0 end,
	function () set("thranda/views/chocks",0)  end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ChecklistItem:new("AFTER START CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end


-- set cabin altitude for cruise FL280+ 8000
-- === Before Takeoff
-- activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))

if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(HoldProcedureItem:new("== BEFORE TAKEOFF CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ChecklistItem:new("BEFORE TAKEOFF CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ChecklistItem:new("FLAPS","SET %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPM,2,
	function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])] end,
	function () kc_macro_set_flap(tonumber(kc_pref_split(kc_TakeoffFlapsInd)[activeBriefings:get("takeoff:flaps")])) end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(IndirectChecklistItem:new("TAKEOFF CONFIG","CHECKED",FlowItem.actorFO,1,"toconfigchk",
	function() return get("thranda/control/TOconfigBt") == 1 end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ChecklistItem:new("TRIMS","SET FOR TAKEOFF",FlowItem.actorCPT,1,
	function() return 
		get("sim/cockpit2/controls/elevator_trim") > -0.75 and 
		get("sim/cockpit2/controls/elevator_trim") < -0.33
	end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorFO,1,"fccheck",
	function() 
		if kc_full_rgt_rudder > 0 then 
			return sysControls.rudderDeflection:getStatus() > kc_full_rgt_rudder
		else
			return sysControls.rudderDeflection:getStatus() < kc_full_rgt_rudder
		end
	end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(IndirectChecklistItem:new("MWS","CHECKED",FlowItem.actorFO,1,"mwscheck",
	function() return true end,
	function ()  end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ChecklistItem:new("TRANSPONDER","ON",FlowItem.actorFO,1,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.tara end,
	function () 
		kc_macro_set_xpdrmode(sysRadios.tara)
		local xpdrcode = activeBriefings:get("departure:squawk")
		sysRadios.xpdrCode:setValue(xpdrcode)
	end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ChecklistItem:new("BEFORE TAKEOFF CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))
end
	
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
activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ChecklistItem:new("ENGINE AIR","ON",FlowItem.actorFO,1,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterTakeoff):addItem(ChecklistItem:new("#spell|APU# AIR","ON",FlowItem.actorFO,1,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
	
-- === Climb Checks
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
-- activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("","",FlowItem.actorCPT))

-- ==== Descend Checks
-- activeSOP:getFlow(proc_ind_descent):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === landing
-- activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
	
-- === landing checklist
-- activeSOP:getFlow(proc_ind_LandingCheck):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_LandingCheck):addItem(ChecklistItem:new("ENGINE AIR","OFF",FlowItem.actorFO,1,
	function () return sysAir.engBleedGroup:getStatus() == 0 end,
	function () sysAir.engBleedGroup:actuate(0) end))

-- === after landing
-- activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(HoldProcedureItem:new("== AFTER LANDING CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("AFTER LANDING CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("AIR BRAKE","CLOSED",FlowItem.actorFO,1,
		function () return sysControls.Speedbrake:getStatus() == 0 end,
		function () sysControls.Speedbrake:setValue(0) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorPM,1,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[0]) end))	
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("#spell|APU'","STARTED",FlowItem.actorFO,1,
		function () return sysElectric.apuRunningAnc:getStatus() > 0 end,
		function () end,
		function () return activeBriefings:get("approach:activateAPUafterLand") == 2 end))	
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("#spell|APU# AIR","ON",FlowItem.actorFO,1,
	function () return sysAir.engBleedGroup:getStatus() > 0 end,
	function () sysAir.engBleedGroup:actuate(1) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("ANTI ICE SETTINGS","AS REQUIRED",FlowItem.actorFO,1,
	function () return true end,
	function () end))	
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ChecklistItem:new("AFTER LANDING CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end
	
-- === Shutdown
-- activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("","",FlowItem.actorFO,0,
	-- function () return end,
	-- function () end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("CHOCKS","ON",FlowItem.actorFO,0,
	function () return get("thranda/views/chocks") == 1 end,
	function () set("thranda/views/chocks",1) end))	

if activePrefSet:get("general:checklists") == true then
activeSOP:getFlow(proc_ind_shutdownProc):addItem(HoldProcedureItem:new("== SHUTDOWN CHECKLIST ==","== CALL ==",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("SHUTDOWN CHECKLIST","",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("BRAKE OR CHOCKS","SET",FlowItem.actorFO,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 or get("thranda/views/chocks") == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1)
		set("thranda/views/chocks",1)
	end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("HYDRAULICS","ALL OFF",FlowItem.actorFO,1,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () 
		sysHydraulic.engHydPumpGroup:actuate(0)
		sysHydraulic.elecHydPumpGroup:actuate (0)
		sysHydraulic.PTU:actuate(0)
	end))		
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("GENERATOR 1 & 4","OFF",FlowItem.actorFO,1,
	function () return sysElectric.genSwitchGroup:getStatus() == 0 end,
	function () 
		sysElectric.genSwitchGroup:actuate(0)
	end))		
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("THRUST LEVERS","CUT OFF",FlowItem.actorFO,1,
	function () return get("thranda/cockpit/ThrottleLocked",0) == 1 end,
	function () end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("SEAT BELT SIGNS","OFF",FlowItem.actorFO,1,
	function () return sysGeneral.passSignsSwitch:getStatus() == 0 end,
	function () sysGeneral.passSignsSwitch:actuate(0) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("TAXI LIGHTS","OFF",FlowItem.actorFO,1,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("BRAKE FANS","ON",FlowItem.actorFO,1,
	function () return get("thranda/brakes/brakeSelector") == 2 end,
	function () set("thranda/brakes/brakeSelector",2) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("FUEL PUMPS","OFF",FlowItem.actorFO,1,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(0) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("ANTI ICE & HEATERS","OFF",FlowItem.actorFO,1,
	function () return true end,
	function () kc_macro_aice(kc_phase_afterland) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("BEACON","OFF",FlowItem.actorFO,1,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))		
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ChecklistItem:new("SHUTDOWN CHECKLIST","COMPLETED",FlowItem.actorFO,2,
	function () return true end,
	function ()  end))	
end
return SOP_B46X