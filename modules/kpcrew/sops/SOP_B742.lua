-- SOP Felis Boeing 747-200 XP12

-- @classmod SOP_B742
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

SOP_B742 = require("kpcrew.sops.SOP_DFLT")

activeSOP:setName("FELIS B747-200 SOP")

-- === power up
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("RADIOS","ON",FlowItem.actorFO,0,
	function () return get("B742/OVHD/radio_master_bus_ESS_on") == 1 end,
	function () 
		set("B742/OVHD/radio_master_bus_ESS_on",1)
		set("B742/OVHD/radio_master_bus_NO2_on",1)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("BODY GEAR STEERING","ARM",FlowItem.actorFO,0,
	function () return get("B742/OVHD/body_gear_steer_sw") == 0 end,
	function () 
		set("B742/OVHD/body_gear_steer_sw",0)
		set("B742/OVHD/body_gear_steer_cap",1)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ANTI-SKID","ON",FlowItem.actorFO,0,
	function () return get("B742/OVHD/anti_skid_on_off_sw") == 1 end,
	function () 
		set("B742/OVHD/anti_skid_on_off_sw",1)
		set("B742/OVHD/anti_skid_on_off_cap",0)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("TRIM AIR","OPEN",FlowItem.actorFO,0,
	function () return get("B742/AIR_COND/trim_air_sw") == 1 end,
	function () set("B742/AIR_COND/trim_air_sw",1) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GALLEY CHILLERS","ON",FlowItem.actorFO,0,
	function () return get("B742/FE/galley_chiller_sw",0) == 1 end,
	function () 
		set_array("B742/FE/galley_chiller_sw",0,1)
		set_array("B742/FE/galley_chiller_sw",1,1)
		set_array("B742/FE/galley_chiller_sw",2,1)	
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("WX RADAR","STBY",FlowItem.actorFO,0,
	function () return sysEFIS.wxrPilot:getStatus() == 1 end,
	function () sysEFIS.wxrPilot:setValue(1) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("DC BUS ISOLATION","ON",FlowItem.actorFO,0,
	function () return get("B742/FE/galley_chiller_sw",0) == 1 end,
	function () 
		set("B742/FE/DC_bus_isolation_2_sw",1)
		set("B742/FE/DC_bus_isolation_3_sw",1)
		set("B742/FE/DC_bus_isolation_4_sw",1)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 0 end,
	function () sysEngines.engStarterGroup:actuate(0) end))	
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ALT FLAPS LEADING EDGE","OFF",FlowItem.actorFO,0,
	function () return get("B742/FE/galley_chiller_sw",0) == 1 end,
	function () 
		set_array("B742/OVHD/alt_flaps_LE_sw",0,0)
		set_array("B742/OVHD/alt_flaps_LE_sw",1,0)
		set_array("B742/OVHD/alt_flaps_LE_sw",2,0)
		set_array("B742/OVHD/alt_flaps_LE_sw",3,0)	
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ALT FLAPS TRAILING EDGE","OFF",FlowItem.actorFO,0,
	function () return get("B742/FE/galley_chiller_sw",0) == 1 end,
	function () 
		set("B742/OVHD/alt_flaps_TE_sw_inbd",0)
		set("B742/OVHD/alt_flaps_TE_sw_outbd",0)
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("STANDBY IGNITION","NORM",FlowItem.actorFO,0,
	function () return get("B742/OVHD/stby_ignition_sel") == 0 end,
	function () set("B742/OVHD/stby_ignition_sel",0) end))	
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("ESS AC BUS","NORM",FlowItem.actorFO,0,
	function () return get("B742/ELEC/ESS_bus_sel") == 1 end,
	function () set("B742/ELEC/ESS_bus_sel",1) end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GPWS & INSTR","TEST",FlowItem.actorFO,1,
	function () return get("B742/misc_controls/instr_warn_test_button") == 1 end,
	function () 
		set("B742/misc_controls/gnd_prox_test_button",1) 
		set("B742/misc_controls/instr_warn_test_button",1) 
	end))
activeSOP:getFlow(proc_ind_electrical):addItem(ProcedureItem:new("GPWS & INSTR","TEST",FlowItem.actorFO,0,
	function () return get("B742/misc_controls/instr_warn_test_button") == 0 end,
	function () 
		set("B742/misc_controls/gnd_prox_test_button",0) 
		set("B742/misc_controls/instr_warn_test_button",0) 
	end))
	
-- === before start

activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ANTI SKID","ON",FlowItem.actorFO,0,
	function () return get("B742/OVHD/anti_skid_on_off_sw") == 1 end,
	function () 
		set("B742/OVHD/anti_skid_on_off_sw",1)
		set("B742/OVHD/anti_skid_on_off_cap",0)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("START VALVE","ON",FlowItem.actorFO,0,
	function () return get("B742/OVHD/start_valve_sw") == 1 end,
	function () 
		set("B742/OVHD/start_valve_sw",1)
		set("B742/OVHD/start_valve_cap",1)
	end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("ESS AC BUS","NORM",FlowItem.actorFO,0,
	function () return get("B742/ELEC/ESS_bus_sel") == 1 end,
	function () set("B742/ELEC/ESS_bus_sel",1) end))
activeSOP:getFlow(proc_ind_beforeStart):addItem(ProcedureItem:new("EPRL","GA & EPR MODE",FlowItem.actorFO,0,
	function () return get("B742/EPRL/eprl_mode_sel") == 5 end,
	function () 
		set("B742/EPRL/eprl_mode_sel",5)
		set("B742/EPRL/mode_epr_button",1)
	end))
	
-- === After Start
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("YAW DAMPERS","ON",FlowItem.actorFO,0,
	function () return sysMCP.yawDamper:getStatus() > 0 end,
	function () sysMCP.yawDamper:actuate(1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("AFT CARGO HEAT","NORMAL",FlowItem.actorFO,0,
	function () return get("B742/FE/AFT_cargo_heat_sw") > 0 end,
	function () set("B742/FE/AFT_cargo_heat_sw",1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("BODY GEAR STEERING","ARM",FlowItem.actorFO,0,
	function () return get("B742/OVHD/body_gear_steer_sw") == 0 end,
	function () 
		set("B742/OVHD/body_gear_steer_sw",0)
		set("B742/OVHD/body_gear_steer_cap",1)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("START VALVE","OFF",FlowItem.actorFO,0,
	function () return get("B742/OVHD/start_valve_sw") == 0 end,
	function () 
		set("B742/OVHD/start_valve_sw",0)
		set("B742/OVHD/start_valve_cap",0)
	end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("GASPER","ON",FlowItem.actorFO,0,
	function () return get("B742/AIR_COND/gasper_on_sw") == 1 end,
	function () set("B742/AIR_COND/gasper_on_sw",1) end))
activeSOP:getFlow(proc_ind_afterStart):addItem(ProcedureItem:new("SUPPLY VENT FANS","ON",FlowItem.actorFO,0,
	function () return get("B742/AIR_COND/suppl_vent_fans_sw") == 1 end,
	function () set("B742/AIR_COND/suppl_vent_fans_sw",1) end))
	
-- === Before Takeoff
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("WX RADAR","WX",FlowItem.actorFO,0,
	function () return sysEFIS.wxrPilot:getStatus() == 3 end,
	function () sysEFIS.wxrPilot:setValue(3) end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,
	function () return get("B742/controls/speedbrake_lever_detent") > 0.009 end,
	function () set("B742/controls/speedbrake_lever_detent",0.0095) end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("ENGINE IGNITION","FLT START",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() < 0 end,
	function () sysEngines.engStarterGroup:setValue(-1) end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("SPEEDBRAKE","ARM",FlowItem.actorFO,0,
	function () return get("B742/controls/speedbrake_lever_detent") > 0.009 end,
	function () set("B742/controls/speedbrake_lever_detent",0.0095) end))
activeSOP:getFlow(proc_ind_beforeTakeoff):addItem(ProcedureItem:new("EPRL","TOD & EPR MODE",FlowItem.actorFO,0,
	function () return get("B742/EPRL/eprl_mode_sel") == 1 end,
	function () 
		set("B742/EPRL/eprl_mode_sel",1)
		set("B742/EPRL/mode_epr_button",1)
	end))
	
-- === Runway entry
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("PACKS & BLEEDS","AS REQUIRED",FlowItem.actorFO,0,
	function () return true end,
	function () kc_macro_air(kc_phase_takeoff) end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("EPRL","TOD & EPR MODE",FlowItem.actorFO,0,
	function () return get("B742/EPRL/eprl_mode_sel") == 1 end,
	function () 
		set("B742/EPRL/eprl_mode_sel",1)
		set("B742/EPRL/mode_epr_button",1)
	end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(HoldProcedureItem:new("BODY GEAR STEERING","DISARM",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(ProcedureItem:new("BODY GEAR STEERING","DISARM",FlowItem.actorFO,0,
	function () return get("B742/OVHD/body_gear_steer_sw") == 1 end,
	function () 
		set("B742/OVHD/body_gear_steer_sw",1) 
		set("B742/OVHD/body_gear_steer_cap",0)
	end))
activeSOP:getFlow(proc_ind_runwayEntry):addItem(HoldProcedureItem:new("AUTO THRUST","SET CLB & SPD",FlowItem.actorCPT))


-- === Gear up
activeSOP:getFlow(proc_ind_gearUp):addItem(ProcedureItem:new("EPRL","CLB & SPD MODE",FlowItem.actorFO,0,
	function () return get("B742/EPRL/eprl_mode_sel") == 3 end,
	function () 
		set("B742/EPRL/eprl_mode_sel",3)
		set("B742/EPRL/mode_speed_button",1)
		sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:clmbspd"))
	end))

-- === After Takeoff

	
-- === Climb Checks
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 0 end,
	function () sysEngines.engStarterGroup:setValue(0) end))
activeSOP:getFlow(proc_ind_climbCheck):addItem(HoldProcedureItem:new("SET EPRL","CRZ & MACH MODE",FlowItem.actorCPT))
activeSOP:getFlow(proc_ind_climbCheck):addItem(ProcedureItem:new("EPRL","CRZ & MACH MODE",FlowItem.actorFO,0,
	function () return get("B742/EPRL/eprl_mode_sel") == 4 end,
	function () 
		set("B742/EPRL/eprl_mode_sel",4)
		set("B742/EPRL/mode_mach_button",1)
	end))
	
-- === landing
activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("ENGINE IGNITION","FLT START",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() < 0 end,
	function () sysEngines.engStarterGroup:setValue(-1) end))
-- activeSOP:getFlow(proc_ind_landing):addItem(ProcedureItem:new("EPRL","GA",FlowItem.actorFO,0,
	-- function () return get("B742/EPRL/eprl_mode_sel") == 5 end,
	-- function () 
		-- set("B742/EPRL/eprl_mode_sel",5)
		-- set("B742/EPRL/mode_epr_button",1)
	-- end))

-- === after landing
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("WX RADAR","STBY",FlowItem.actorFO,0,
	function () return sysEFIS.wxrPilot:getStatus() == 1 end,
	function () sysEFIS.wxrPilot:setValue(1) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("BODY GEAR STEERING","ARM",FlowItem.actorFO,0,
	function () return get("B742/OVHD/body_gear_steer_sw") == 0 end,
	function () 
		set("B742/OVHD/body_gear_steer_sw",0)
		set("B742/OVHD/body_gear_steer_cap",1)
	end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("ENGINE IGNITION","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 0 end,
	function () sysEngines.engStarterGroup:setValue(0) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
		function () return sysGeneral.Autobrake:getStatus() == kc_AutoBrakeOff end,
		function () kc_macro_set_autobrake(kc_AutoBrakeOff) end))
activeSOP:getFlow(proc_ind_afterLandingProc):addItem(ProcedureItem:new("PRESSURIZATION MODE SELECTOR","MAN",FlowItem.actorFO,0,
		function () return get("B742/AIR_COND/mode_sel_rotary") == 2 end,
		function () set("B742/AIR_COND/mode_sel_rotary",2) end))

-- === Shutdown
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("GASPER","OFF",FlowItem.actorFO,0,
	function () return get("B742/AIR_COND/gasper_on_sw") == 0 end,
	function () set("B742/AIR_COND/gasper_on_sw",0) end))
activeSOP:getFlow(proc_ind_shutdownProc):addItem(ProcedureItem:new("SUPPLY VENT FANS","OFF",FlowItem.actorFO,0,
	function () return get("B742/AIR_COND/suppl_vent_fans_sw") == 0 end,
	function () set("B742/AIR_COND/suppl_vent_fans_sw",0) end))
return SOP_B742