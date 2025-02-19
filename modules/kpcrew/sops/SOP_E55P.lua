-- SOP Aerobask Phenom 300 XP12

-- @classmod SOP_E55P
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

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [20] = "Go Around", [0] = "" }
					 
activeSOP = SOP:new("AEROBASK PHENOM 300 SOP")

-- =====================================================================================================================

local electricalPowerUpProc = Procedure:new("COCKPIT SAFETY & POWER UP","","")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(ProcedureItem:new("STATIC ELEMENTS","IN PLACE",FlowItem.actorFO,0,
	function () return get("aerobask/hide_static") == 0 end,
	function () 
		if get("aerobask/hide_static") == 1 then
			command_once("aerobask/options/toggle_static_elements")
		end
		kc_macro_doors_preflight()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("OXYGEN BOTTLE VALVE HANDLE","PUSH TO RESTORE",FlowItem.actorFO,0,
	function () return get("aerobask/oxygen/sw_cut_out") == 1 end,
	function () 
		if get("aerobask/oxygen/sw_cut_out") == 0 then
			command_once("aerobask/oxygen/cut_out")
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("NAV LIGHT","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() == 1 end,
	function () kc_macro_lights_preflight()	end))	

electricalPowerUpProc:addItem(ProcedureItem:new("SUPPLY CONTROL KNOB","PAX AUTO",FlowItem.actorFO,0,
	function () return get("aerobask/oxygen/knob_oxy_mode") == 1 end,
	function () 
		command_once("aerobask/oxygen/supply_lt")
		command_once("aerobask/oxygen/supply_lt")
		command_once("aerobask/oxygen/supply_rt")
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("ELECTRICAL PANEL","CHECK",FlowItem.actorFO,0,"checkelecpre",
	function () return 
		get("sim/cockpit/electrical/battery_array_on",0) == 0 and 
		get("sim/cockpit/electrical/battery_array_on",1) == 0 and 
		get("aerobask/electrical/sw_gen1") == 0 and 
		get("aerobask/electrical/sw_gen2") == 0 and 
		get("aerobask/electrical/knob_bus_tie") == 1
	end,
	function () 
		command_once("sim/electrical/battery_1_off")
		command_once("sim/electrical/battery_2_off")
		command_once("aerobask/electrical/gen1_off")
		command_once("aerobask/electrical/gen2_off")
		command_once("aerobask/electrical/bus_tie_lt")
		command_once("aerobask/electrical/bus_tie_lt")
		command_once("aerobask/electrical/bus_tie_rt")

	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","CONNECT",FlowItem.actorFO,1,
	function () return 
		sysElectric.gpuConnect:getStatus() > 0
	end,
	function () 
		sysElectric.gpuConnect:actuate(1)
	end,
	function () return activeBriefings:get("departure:activateAPUPowerUp") == 1 end))	
electricalPowerUpProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuOnBus:getStatus() > 0
	end,
	function () 
		sysElectric.gpuGenBusGroup:actuate(1)
	end,
	function () return activeBriefings:get("departure:activateAPUPowerUp") == 1 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.batterySwitch:getStatus() > 0 end,
	function () 
		sysElectric.batterySwitch:actuate(1) 
		if kc_get_nr_batteries() > 1 then
			sysElectric.battery2Switch:actuate(1) 
		end
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("BLEED 1 & 2 SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return 
		get("aerobask/bleed/sw_bleed1") == 1 and 
		get("aerobask/bleed/sw_bleed2") == 1
	end,
	function () 
		command_once("aerobask/bleed/bleed1_auto")
		command_once("aerobask/bleed/bleed2_auto")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("XBLEED KNOB","AUTO",FlowItem.actorFO,0,
	function () return 
		get("aerobask/bleed/sw_xbleed") == 1
	end,
	function () 
		command_once("aerobask/bleed/xbleed_auto")
	end))	
electricalPowerUpProc:addItem(ProcedureItem:new("TEST PANEL","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/test/knob_test") == 3
	end,
	function () 
		command_once("aerobask/test/test_rt")
		command_once("aerobask/test/test_rt")
		command_once("aerobask/test/test_rt")
		command_once("aerobask/test/test_rt")
		command_once("aerobask/test/test_rt")
		command_once("aerobask/test/test_lt")
		command_once("aerobask/test/test_lt")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("FUEL PUMP 1 & 2 SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return 
		get("aerobask/fuel/sw_pump1") == 1 and 
		get("aerobask/fuel/sw_pump2") == 1
	end,
	function () 
		command_once("aerobask/fuel/pump1_dn")
		command_once("aerobask/fuel/pump1_dn")
		command_once("aerobask/fuel/pump1_up")
		command_once("aerobask/fuel/pump2_dn")
		command_once("aerobask/fuel/pump2_dn")
		command_once("aerobask/fuel/pump2_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("XFEED KNOB","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/fuel/knob_xfeed") == 1
	end,
	function () 
		command_once("aerobask/fuel/xfeed_lt")
		command_once("aerobask/fuel/xfeed_lt")
		command_once("aerobask/fuel/xfeed_rt")
	end))	
electricalPowerUpProc:addItem(ProcedureItem:new("HYD PUMP SOV 1 & 2 SWITCHES","OPEN",FlowItem.actorFO,0,
	function () return 
		get("aerobask/hyd/sw_pump1") == 1 and 
		get("aerobask/hyd/sw_pump2") == 1
	end,
	function () 
		command_once("aerobask/hyd/pump1_up")
		command_once("aerobask/hyd/pump2_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ELT SWITCH","ARMED",FlowItem.actorFO,0,
	function () return 
		get("aerobask/elt/sw_elt") == 1
	end,
	function () 
		command_once("aerobask/elt/elt_dn")
		command_once("aerobask/elt/elt_dn")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("EMER LTS SWITCH","ARMED",FlowItem.actorFO,0,
	function () return 
		get("aerobask/lights/sw_emer_lt") == 1
	end,
	function () 
		command_once("aerobask/lights/emer_lt_dn")
		command_once("aerobask/lights/emer_lt_dn")
		command_once("aerobask/lights/emer_lt_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("HEATING PANEL","CHECKED",FlowItem.actorFO,0,
	function () return 
		get("aerobask/iceprot/sw_wshld1") == 0 and 
		get("aerobask/iceprot/sw_wshld2") == 0 and 
		get("aerobask/iceprot/knob_ads_probes") == 1
	end,
	function () 
		command_once("aerobask/iceprot/wshld1_off")
		command_once("aerobask/iceprot/wshld2_off")
		command_once("aerobask/iceprot/ads_probes_lt")
		command_once("aerobask/iceprot/ads_probes_lt")
		command_once("aerobask/iceprot/ads_probes_rt")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ICE PROTECTION PANEL","ALL OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/iceprot/sw_eng1") == 0 and 
		get("aerobask/iceprot/sw_eng2") == 0 and 
		get("aerobask/iceprot/sw_wingstab") == 1 and 
		get("aerobask/iceprot/sw_insp_light") == 0
	end,
	function () 
		command_once("aerobask/iceprot/eng1_off")
		command_once("aerobask/iceprot/eng2_off")
		command_once("aerobask/iceprot/wingstab_dn")
		command_once("aerobask/iceprot/wingstab_dn")
		command_once("aerobask/iceprot/insp_light_off")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("PRESSURIZATION & AIRCOND PANEL","CHECK",FlowItem.actorFO,0,
	function () return 
		get("aerobask/press/sw_mode") == 1 and 
		get("aerobask/press/knob_ecs") == 2 and 
		get("aerobask/airco/sw_ckpt_fan") == 0 and 
		get("aerobask/airco/sw_cabin_fan") == 0 and 
		get("aerobask/airco/sw_mode") == 0
	end,
	function () 
		command_once("aerobask/press/mode_up")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_lt")
		set("aerobask/airco/knob_ckpt_temp",0)
		set("aerobask/airco/knob_cabin_temp",0)
		command_once("aerobask/airco/cabin_fan_dn")
		command_once("aerobask/airco/cabin_fan_dn")
		command_once("aerobask/airco/ckpt_fan_dn")
		command_once("aerobask/airco/ckpt_fan_dn")
		command_once("aerobask/airco/mode_dn")
		command_once("aerobask/airco/mode_dn")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENG FIRE EXTINGUISHER PANEL","CHECK",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/sw_bottle") == 0 and 
		get("aerobask/engines/shutoff_cover_1") == 0 and 
		get("aerobask/engines/shutoff_cover_2") == 0 
	end,
	function () 
		command_once("aerobask/engines/bottle_off")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("START/STOP KNOBS","STOP",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/knob_start_stop_1") == 0 and 
		get("aerobask/engines/knob_start_stop_2") == 0 
	end,
	function () 
		command_once("aerobask/engines/knob_1_lt")
		command_once("aerobask/engines/knob_1_lt")
		command_once("aerobask/engines/knob_2_lt")
		command_once("aerobask/engines/knob_2_lt")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENG IGNITION SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/sw_ignition_1") == 0 and 
		get("aerobask/engines/sw_ignition_1") == 0 
	end,
	function () 
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_dn")
	end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","ZERO",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () 
		kc_macro_set_flap(0)
	end))	
electricalPowerUpProc:addItem(ProcedureItem:new(" SPEED BRAKE SWITCH","CLOSE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/controls/speedbrake_ratio") == 0 end,
	function () command_once("aerobask/speedbrakes_close") end))
electricalPowerUpProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER CODE","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () sysRadios.xpdrCode:actuate(2000) end))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSPONDER MODE","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
	end))

-- =====================================================================================================================

local beforeStart = Procedure:new("BEFORE START","","")
beforeStart:setFlightPhase(4)

beforeStart:addItem(HoldProcedureItem:new("TEST PANEL","TEST FIRE, SMOKE & ANN",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("SIGNS/OUTLET SWITCH","BELTS/ON",FlowItem.actorFO,0,
	function () return get("aerobask/lights/sw_signs") == 1 end,
	function () 
		command_once("aerobask/lights/switch_dn")
		command_once("aerobask/lights/switch_dn")
		command_once("aerobask/lights/switch_up")
	end))
beforeStart:addItem(ProcedureItem:new("LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () 
		kc_macro_lights_before_start() 
	end))
beforeStart:addItem(ProcedureItem:new("EMERG LT","ARM",FlowItem.actorFO,0,
	function () return get("aerobask/lights/sw_emer_lt") == 1 end,
	function () 
		command_once("aerobask/lights/emer_lt_dn")
		command_once("aerobask/lights/emer_lt_dn")
		command_once("aerobask/lights/emer_lt_up")
	end))
beforeStart:addItem(HoldProcedureItem:new("FUEL QTY AND BALANCE","CHECK",FlowItem.actorCPT))
beforeStart:addItem(ProcedureItem:new("OXYGEN PRESSURE","CHECK >1700 PSI",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/oxygen/indicators/o2_bottle_pressure_psi") > 1700 end))
beforeStart:addItem(ProcedureItem:new("ENG IGNITION SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/sw_ignition_1") == 1 and 
		get("aerobask/engines/sw_ignition_1") == 1 
	end,
	function () 
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_up")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_up")
	end))
beforeStart:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
beforeStart:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
beforeStart:addItem(ProcedureItem:new("DOORS","CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.doorsAnc:getStatus() == 0 end,
	function () kc_macro_doors_before_start() end))
beforeStart:addItem(ProcedureItem:new("STATIC ELEMENTS","REMOVE",FlowItem.actorFO,0,
	function () return get("aerobask/hide_static") == 1 end,
	function () 
		if get("aerobask/hide_static") == 0 then
			command_once("aerobask/options/toggle_static_elements")
		end
	end))
-- =====================================================================================================================

local prePushStartProc = Procedure:new("PRE PUSH & ENGINE START","","")
prePushStartProc:setFlightPhase(4)

prePushStartProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		local xpdrcode = activeBriefings:get("departure:squawk")
		set("sim/cockpit2/radios/actuators/transponder_code",xpdrcode)
	end))
prePushStartProc:addItem(ProcedureItem:new("THRUST LEVERS","IDLE",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/engine/actuators/throttle_ratio_all") == 0 end,
	function () set("sim/cockpit2/engine/actuators/throttle_ratio_all",0) end))
prePushStartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE IF NEEDED",FlowItem.actorCPT))
prePushStartProc:addItem(HoldProcedureItem:new("COMMUNICATION WITH GROUND CREW","ESTABLISH",FlowItem.actorCPT))
prePushStartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end,
	function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end,
	function () return activeBriefings:get("taxi:pushDirection") == 1 end))
prePushStartProc:addItem(HoldProcedureItem:new("START CLEARANCE FROM GROUND CREW","RECEIVED",FlowItem.actorCPT))

-- =====================================================================================================================

local engStartProc = Procedure:new("ENGINE START","")
engStartProc:setFlightPhase(-4)
engStartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
engStartProc:addItem(IndirectProcedureItem:new("IGNITION","BOTH AUTO",FlowItem.actorFO,0,"ignitionstart",
	function () return 
		get("aerobask/engines/sw_ignition_1") == 1 and 
		get("aerobask/engines/sw_ignition_1") == 1 
	end,
	function () 
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_up")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_up")
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("ENGINE GENERATORS","AUTO",FlowItem.actorFO,0,
	function () return 
		get("aerobask/electrical/sw_gen1") == 1 and 
		get("aerobask/electrical/sw_gen2") == 1 
	end,
	function () 
		command_once("aerobask/electrical/gen1_auto")
		command_once("aerobask/electrical/gen2_auto")

	end))
engStartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () return sysEngines.throttlePos:getStatus() == 0	end,
	function () 
		command_once("sim/engines/throttle_idle")
	end))
engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorFO,20,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() > 0
		else 
			return sysEngines.engStart1Switch:getStatus() > 0
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_procvar_set("engstart2",true)
			kc_speakNoText(0,"starting right hand engine")
		else 
			kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting left hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("1ST ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 end 
	end,
	function () 
	end))

engStartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT))
engStartProc:addItem(ProcedureItem:new("EXTERNAL POWER","OFF",FlowItem.actorFO,2,
	function () return 
		sysElectric.gpuGenBusGroup:getStatus() == 0
	end,
	function () 
		sysElectric.gpuGenBusGroup:actuate(0)
	end))
engStartProc:addItem(ProcedureItem:new("EXTERNAL POWER","DISCONNECT",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuConnect:getStatus() == 0 
	end,
	function () 
		sysElectric.gpuConnect:actuate(0)
	end))
engStartProc:addItem(IndirectProcedureItem:new("POWER LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"RH\" or \"LH\"",FlowItem.actorCPT,3,"eng_start_2_lever",
	function () return sysEngines.throttlePos:getStatus() == 0	end,
	function () 
		command_once("sim/engines/throttle_idle")
	end))
engStartProc:addItem(IndirectProcedureItem:new("ENGINE START SWITCH","PRESS  %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"LH\" or \"RH\"",FlowItem.actorCPT,20,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 1
		else 
			return sysEngines.engStart2Switch:getStatus() == 1
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			kc_procvar_set("engstart1",true)
			kc_speakNoText(0,"starting left hand engine")
		else 
			kc_procvar_set("engstart2",true)
			kc_speakNoText(0,"starting right hand engine")
		end 
	end))
engStartProc:addItem(ProcedureItem:new("2ND ENGINE N2","INCREASING",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("sim/cockpit2/engine/indicators/N2_percent",0) > 8 else 
		return get("sim/cockpit2/engine/indicators/N2_percent",1) > 8 end 
	end,
	function () 
	end))

engStartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,nil,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
	end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
engStartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))

-- =====================================================================================================================

local afterStartProc = Procedure:new("AFTER START","","")
afterStartProc:setFlightPhase(5)
afterStartProc:addItem(ProcedureItem:new("EXTERNAL POWER","OFF",FlowItem.actorFO,2,
	function () return 
		sysElectric.gpuGenBusGroup:getStatus() == 0
	end,
	function () 
		sysElectric.gpuGenBusGroup:actuate(0)
	end))
afterStartProc:addItem(ProcedureItem:new("EXTERNAL POWER","DISCONNECT",FlowItem.actorFO,0,
	function () return 
		sysElectric.gpuConnect:getStatus() == 0 
	end,
	function () 
		sysElectric.gpuConnect:actuate(0)
	end))	
afterStartProc:addItem(HoldProcedureItem:new("STALL PROTECTION SYSTEM","TEST",FlowItem.actorCPT))	
afterStartProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () 
		kc_macro_mcp_preflight()
	end))
afterStartProc:addItem(HoldProcedureItem:new("TAKEOFF SPEEDS","SET",FlowItem.actorCPT))	
afterStartProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == 3 end,
	function () 
		sysRadios.xpdrSwitch:setValue(3)
		local xpdrcode = activeBriefings:get("departure:squawk")
		set("sim/cockpit2/radios/actuators/transponder_code",xpdrcode)
	end))
afterStartProc:addItem(ProcedureItem:new("ALTIMETERS","ALL SET QNH",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_set_local_baro() end))	
afterStartProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECKED",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg",10) > 30.9 end))
afterStartProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/aileron_trim") == 0 and
		get("sim/cockpit2/controls/rudder_trim") == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
afterStartProc:addItem(ProcedureItem:new("ELEVATOR TRIM","IN GREEN ZONE",FlowItem.actorFO,0,
	function () return  
		get("sim/flightmodel/controls/elv_trim") > -0.6 and 
		get("sim/flightmodel/controls/elv_trim") < 0.17
	end))
afterStartProc:addItem(ProcedureItem:new("FLAPS","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorPF,0,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
afterStartProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
afterStartProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
afterStartProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","AS REQUIRED",FlowItem.actorBOTH,0,
	function () return true end,
	function () kc_macro_lights_before_taxi() end))	
afterStartProc:addItem(ProcedureItem:new("AIRCOND PANEL","SET",FlowItem.actorFO,0,
	function () return 
		get("aerobask/airco/sw_ckpt_fan") == 0 and 
		get("aerobask/airco/sw_cabin_fan") == 0 and 
		get("aerobask/airco/sw_mode") == 0
	end,
	function () 
		set("aerobask/airco/knob_ckpt_temp",0.5)
		set("aerobask/airco/knob_cabin_temp",0.5)
		command_once("aerobask/airco/cabin_fan_up")
		command_once("aerobask/airco/ckpt_fan_up")
		command_once("aerobask/airco/mode_up")
	end))
-- =====================================================================================================================

local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE","","")
beforeTakeoffProc:setFlightPhase(7)

beforeTakeoffProc:addItem(ProcedureItem:new("FLAPS","CHECK T/O FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () return true end,
	function () kc_macro_set_flap(activeBriefings:get("takeoff:flaps")-1) end)) 
beforeTakeoffProc:addItem(HoldProcedureItem:new("TAKEOFF CONFIG","CHECK",FlowItem.actorCPT))
beforeTakeoffProc:addItem(ProcedureItem:new("AP ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("AP HEADING BUG","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
beforeTakeoffProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))	
beforeTakeoffProc:addItem(ProcedureItem:new("MCP","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () 
		kc_macro_mcp_takeoff()
	end))	
beforeTakeoffProc:addItem(HoldProcedureItem:new("CAS MESSAGES","CHECK",FlowItem.actorCPT))	
beforeTakeoffProc:addItem(ProcedureItem:new("SIGNS/OUTLET SWITCH","PED-BELTS/OFF",FlowItem.actorFO,0,
	function () return get("aerobask/lights/sw_signs") == 2 end,
	function () 
		command_once("aerobask/lights/switch_up")
		command_once("aerobask/lights/switch_up")
	end))
beforeTakeoffProc:addItem(ProcedureItem:new("YAW DAMPER","OFF",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/yaw_damper_on") == 0 end,
	function () 
		set("sim/cockpit2/switches/yaw_damper_on",0)
	end))	

-- =====================================================================================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY","","")
runwayEntryProc:setFlightPhase(-7)
runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,
	function () return sysLights.strobesSwitch:getStatus() == 1 end,
	function () kc_macro_lights_for_takeoff() end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON/TA RA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == 3 end,
	function () 
		sysRadios.xpdrSwitch:actuate(3)
		activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		kc_procvar_set("above10k",true) -- background 10.000 ft activities
		kc_procvar_set("attransalt",true) -- background transition altitude activities
	end))
runwayEntryProc:addItem(ProcedureItem:new("TAKEOFF POWER","SET",FlowItem.actorFO,0,
	function () return 
		get("sim/flightmodel/engine/ENGN_thro",0) > 0.81 and 
		get("sim/flightmodel/engine/ENGN_thro",0) < 0.87 and 
		get("sim/flightmodel/engine/ENGN_thro",1) > 0.81 and 
		get("sim/flightmodel/engine/ENGN_thro",1) < 0.87  
	end))

-- =====================================================================================================================

local gearUpProc = Procedure:new("COMMAND GEAR UP","Gear up")
gearUpProc:setFlightPhase(-8)

gearUpProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPM,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		kc_speakNoText(0,"gear coming up") 
	end))
gearUpProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/switches/yaw_damper_on") == 1 end,
	function () set("sim/cockpit2/switches/yaw_damper_on",1) end))

-- =====================================================================================================================

local flapsUpProc = Procedure:new("RETRACT FLAPS","")
flapsUpProc:setFlightPhase(-8)

flapsUpProc:addItem(ProcedureItem:new("YAW DAMPER","ON",FlowItem.actorPF,0,
	function () return sysControls.yawDamper:getStatus() == 1 end,
	function () sysControls.yawDamper:actuate(1) end))
	
for toflapidx=kc_NumFlapsTO-1, 2, -1 do
	flapsUpProc:addItem(HoldProcedureItem:new("FLAPS " .. kc_pref_split(kc_TakeoffFlaps)[toflapidx],"RETRACT AT " .. sysControls.flaps_spd[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[toflapidx])] .. " KTS",FlowItem.actorPF,nil,
		function () return sysControls.flapsSwitch:getStatus() < sysControls.flaps_pos[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[toflapidx+1])]-0.01 end))
	
	flapsUpProc:addItem(ProcedureItem:new("FLAPS ".. kc_pref_split(kc_TakeoffFlaps)[toflapidx],"SET",FlowItem.actorPF,0,true,
		function () 
			kc_macro_set_flap(toflapidx-1) 
			kc_speakNoText(0,"speed check flaps " .. kc_pref_split(kc_TakeoffFlaps)[toflapidx]) 
		end,
		function () return sysControls.flapsSwitch:getStatus() < sysControls.flaps_pos[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[toflapidx+1])]-0.01 end))
end
flapsUpProc:addItem(HoldProcedureItem:new("FLAPS " .. kc_pref_split(kc_TakeoffFlaps)[1],"RETRACT AT " .. sysControls.flaps_spd[tonumber(kc_pref_split(kc_TakeoffFlapsInd)[1])] .. " KTS",FlowItem.actorPF))
flapsUpProc:addItem(ProcedureItem:new("FLAPS ".. kc_pref_split(kc_TakeoffFlaps)[1],"SET",FlowItem.actorPF,0,true,
	function () 
		kc_macro_set_flap(0)
		kc_speakNoText(0,"speed check flaps " .. kc_pref_split(kc_TakeoffFlaps)[1]) 
	end))
flapsUpProc:addItem(HoldProcedureItem:new("A/P","ON",FlowItem.actorPF,
	function () 
		sysMCP.ap1Switch:actuate(1) 
	end))

-- =====================================================================================================================

local afterTakeoffCheck = Checklist:new("AFTER TAKEOFF CHECK","after takeoff check","")
afterTakeoffCheck:setFlightPhase(8)

afterTakeoffCheck:addItem(ChecklistItem:new("LANDING GEAR","UP",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () 
		sysGeneral.GearSwitch:actuate(0) 
		command_once("aerobask/lights/ldg_taxi_dn")
		command_once("aerobask/lights/ldg_taxi_dn")
	end))
afterTakeoffCheck:addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () kc_macro_set_flap(0) end))
afterTakeoffCheck:addItem(ChecklistItem:new("YAW DAMPER","ON",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/switches/yaw_damper_on") == 1 end,
	function () set("sim/cockpit2/switches/yaw_damper_on",1) end))
afterTakeoffCheck:addItem(ChecklistItem:new("CLIMB POWER","CON/CLB",FlowItem.actorFO,0,
	function () return 
		get("sim/flightmodel/engine/ENGN_thro",0) > 0.67 and 
		get("sim/flightmodel/engine/ENGN_thro",0) < 0.73 and 
		get("sim/flightmodel/engine/ENGN_thro",1) > 0.67 and 
		get("sim/flightmodel/engine/ENGN_thro",1) < 0.73  
	end))

-- =====================================================================================================================

local climbCheck = Procedure:new("CLIMB CHECKS","","")
climbCheck:setFlightPhase(9)

climbCheck:addItem(ProcedureItem:new("CLIMB POWER","CON/CLB",FlowItem.actorFO,0,
	function () return 
		get("sim/flightmodel/engine/ENGN_thro",0) > 0.67 and 
		get("sim/flightmodel/engine/ENGN_thro",0) < 0.73 and 
		get("sim/flightmodel/engine/ENGN_thro",1) > 0.67 and 
		get("sim/flightmodel/engine/ENGN_thro",1) < 0.73  
	end))
climbCheck:addItem(HoldProcedureItem:new("ANTI-ICE","OFF",FlowItem.actorCPT))
climbCheck:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
climbCheck:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end))
climbCheck:addItem(ProcedureItem:new("SIGNS/OUTLET SWITCH","OFF/ON",FlowItem.actorFO,0,
	function () return get("aerobask/lights/sw_signs") == 0 end,
	function () 
		command_once("aerobask/lights/switch_dn")
		command_once("aerobask/lights/switch_dn")
	end))

-- =====================================================================================================================

local cruiseCheck = Procedure:new("CRUISE","","")
cruiseCheck:setFlightPhase(10)

cruiseCheck:addItem(ProcedureItem:new("CRUISE POWER","MAX/CRZ OR LESS",FlowItem.actorFO,0,
	function () return 
		get("sim/flightmodel/engine/ENGN_thro",0) > 0.555637 and 
		get("sim/flightmodel/engine/ENGN_thro",1) > 0.555637
	end))
cruiseCheck:addItem(HoldProcedureItem:new("PRESSURIZATION & AIR CONDITIONING","CHECK",FlowItem.actorCPT))

-- =====================================================================================================================

local descentProc = Procedure:new("DESCENT CHECK","","")
descentProc:setFlightPhase(11)


descentProc:addItem(HoldProcedureItem:new("VREF","CHECK IN FMC",FlowItem.actorPF,nil))
descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () 
		return get("sim/cockpit/misc/radio_altimeter_minimum") == activeBriefings:get("approach:decision") end,
	function ()
		sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
		kc_procvar_set("below10k",true) -- background 10.000 ft activities
		kc_procvar_set("attranslvl",true) -- background transition level activities
	end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") > 1 end))
descentProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.engAntiIceGroup:getStatus() > 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") == 1 end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorPM,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end,
	function () return activeBriefings:get("approach:antiice") == 3 end))
descentProc:addItem(ProcedureItem:new("WING ANTI-ICE","ON",FlowItem.actorPM,0,
	function () return sysAice.wingAiceGroup:getStatus() == 1 end,
	function () sysAice.wingAiceGroup:actuate(1) end,
	function () return activeBriefings:get("approach:antiice") < 3 end))
descentProc:addItem(ProcedureItem:new("WINDSHIELD HEAT","ALL ON",FlowItem.actorPM,0,
	function () return sysAice.windowHeatGroup:getStatus() > 0 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
descentProc:addItem(ProcedureItem:new("SEAT BELT LIGHTS","PED-BELTS/OFF",FlowItem.actorPM,0,
	function () return get("aerobask/lights/sw_signs") == 2 end,
	function () 
		command_once("aerobask/lights/switch_up")
		command_once("aerobask/lights/switch_up")
	end))

-- =====================================================================================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","")
landingProc:setFlightPhase(13)

landingProc:addItem(HoldProcedureItem:new("ALTIMETERS","QNH %s|activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH))
landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorPF,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
landingProc:addItem(ProcedureItem:new("COURSE NAV 2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorPM,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))
landingProc:addItem(ProcedureItem:new("LANDING LIGHTS","ON",FlowItem.actorPF,0,
	function () return sysLights.landLightGroup:getStatus() > 0 end,
	function () kc_macro_lights_approach() end))	

-- =====================================================================================================================

local flapsProc = Procedure:new("EXTEND FLAPS","","")
flapsProc:setFlightPhase(-13)

for ldgflapidx=1,kc_Numflap_detents,1 do
	flapsProc:addItem(HoldProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"EXTEND AT " .. sysControls.flaps_spd[ldgflapidx] .. " KTS",FlowItem.actorPF,nil,
		function () return tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")]) < ldgflapidx end))
	flapsProc:addItem(ProcedureItem:new("FLAPS " .. sysControls.flaps_name[ldgflapidx],"SET",FlowItem.actorPNF,0,
		function () return true end,
		-- function () return sysControls.flapsSwitch:getStatus() >= sysControls.flaps_pos[ldgflapidx] end,
		function () kc_macro_set_flap(ldgflapidx) end,
		function () return tonumber(kc_pref_split(kc_LandingFlapsInd)[activeBriefings:get("approach:flaps")]) < ldgflapidx end))
	if ldgflapidx == 2 then
		if kc_has_retractgear == true then
			flapsProc:addItem(HoldProcedureItem:new("LANDING GEAR DOWN","COMMAND",FlowItem.actorPF))
			flapsProc:addItem(ProcedureItem:new("GEAR ","DOWN",FlowItem.actorPNF,0,true,
				function () sysGeneral.GearSwitch:actuate(1) end))
			flapsProc:addItem(ProcedureItem:new("GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorPM,0,
			function () return sysGeneral.gearLightsAnc:getStatus() == 1 end))
		end
	end
end
flapsProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
flapsProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))	
flapsProc:addItem(ProcedureItem:new("YAW DAMPER","OFF",FlowItem.actorPM,0,
	function () return get("sim/cockpit2/switches/yaw_damper_on") == 0 end,
	function () set("sim/cockpit2/switches/yaw_damper_on",0) end))
-- =====================================================================================================================

local afterLandingProc = Procedure:new("AFTER LANDING","")
afterLandingProc:setFlightPhase(15)
afterLandingProc:addItem(ProcedureItem:new("AILERON & RUDDER TRIM","RESET",FlowItem.actorFO,0,
	function () return 
		get("sim/cockpit2/controls/aileron_trim") == 0 and
		get("sim/cockpit2/controls/rudder_trim") == 0
	end,
	function () 
		sysControls.aileronReset:actuate(1)
		sysControls.rudderReset:actuate(1)
	end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","AS REQUIRED",FlowItem.actorFO,0,
	function () 
		if activePrefSet:get("general:xpdrusa") == true then
			return get("sim/cockpit2/radios/actuators/transponder_mode") == 3 
		else
			return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 
		end
	end,
	function () 
		if activePrefSet:get("general:xpdrusa") == true then
			set("sim/cockpit2/radios/actuators/transponder_mode",3)	
		else
			set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		end
	end))
afterLandingProc:addItem(ProcedureItem:new("GROUND SPOILERS","RETRACT",FlowItem.actorFO,0,
	function () return sysControls.Speedbrake:getStatus() == 0 end,
	function () sysControls.Speedbrake:setValue(0) end))
afterLandingProc:addItem(ProcedureItem:new("CHRONO & ET","STOP",FlowItem.actorFO,0,
	function () return true end,
	function () activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorFO,0,true,
	function () kc_macro_set_flap(0) end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","AS REQUIRED",FlowItem.actorFO,0,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () kc_macro_lights_cleanup() end))
afterLandingProc:addItem(ProcedureItem:new("WING ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAiceGroup:getStatus() == 0 end,
	function () sysAice.wingAiceGroup:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
	
-- =====================================================================================================================

local taxiLightOff = Procedure:new("TAXI LIGHT OFF","")
taxiLightOff:setFlightPhase(-15)
taxiLightOff:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () 
		command_once("aerobask/lights/ldg_taxi_dn")
		command_once("aerobask/lights/ldg_taxi_dn")
	end))
	
-- =====================================================================================================================

local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE","","")
shutdownProc:setFlightPhase(17)

shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","IDLE",FlowItem.actorFO,0,"throttleidleend",
	function ()
		return get("sim/cockpit2/engine/actuators/throttle_ratio_all") < 0.3
	end))
shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
shutdownProc:addItem(ProcedureItem:new("EXTERNAL POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuConnect:getStatus() == 1 end,
	function () sysElectric.gpuConnect:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_ext") == false end))
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return get("sim/cockpit2/radios/actuators/transponder_mode") == 1 end,
	function () 
		set("sim/cockpit2/radios/actuators/transponder_mode",1)	
		kc_macro_lights_after_shutdown() 
		activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec")))
	end))
shutdownProc:addItem(ProcedureItem:new("TAXI LIGHT","OFF",FlowItem.actorFO,0,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () kc_macro_lights_after_shutdown() end))
shutdownProc:addItem(ProcedureItem:new("HEATING PANEL","CHECKED",FlowItem.actorFO,0,
	function () return 
		get("aerobask/iceprot/sw_wshld1") == 0 and 
		get("aerobask/iceprot/sw_wshld2") == 0 and 
		get("aerobask/iceprot/knob_ads_probes") == 1
	end,
	function () 
		command_once("aerobask/iceprot/wshld1_off")
		command_once("aerobask/iceprot/wshld2_off")
		command_once("aerobask/iceprot/ads_probes_lt")
		command_once("aerobask/iceprot/ads_probes_lt")
		command_once("aerobask/iceprot/ads_probes_rt")
	end))
shutdownProc:addItem(ProcedureItem:new("ICE PROTECTION PANEL","ALL OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/iceprot/sw_eng1") == 0 and 
		get("aerobask/iceprot/sw_eng2") == 0 and 
		get("aerobask/iceprot/sw_wingstab") == 1 and 
		get("aerobask/iceprot/sw_insp_light") == 0
	end,
	function () 
		command_once("aerobask/iceprot/eng1_off")
		command_once("aerobask/iceprot/eng2_off")
		command_once("aerobask/iceprot/wingstab_dn")
		command_once("aerobask/iceprot/wingstab_dn")
		command_once("aerobask/iceprot/insp_light_off")
	end))
-- shutdownProc:addItem(IndirectProcedureItem:new("THROTTLES","CUT",FlowItem.actorCAPT,0,"throttlescutland",
	-- function () return get("sim/cockpit2/engine/actuators/mixture_ratio_all") <= 0 end,
	-- function () set("sim/cockpit2/engine/actuators/mixture_ratio_all",0) end))
shutdownProc:addItem(ProcedureItem:new("START/STOP KNOBS","STOP",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/knob_start_stop_1") == 0 and 
		get("aerobask/engines/knob_start_stop_2") == 0 
	end,
	function () 
		command_once("aerobask/engines/knob_1_lt")
		command_once("aerobask/engines/knob_1_lt")
		command_once("aerobask/engines/knob_2_lt")
		command_once("aerobask/engines/knob_2_lt")
	end))
shutdownProc:addItem(ProcedureItem:new("ENG IGNITION SWITCHES","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/engines/sw_ignition_1") == 0 and 
		get("aerobask/engines/sw_ignition_1") == 0 
	end,
	function () 
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_dn")
	end))
shutdownProc:addItem(ProcedureItem:new("SEAT BELT SIGNS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("GENERATORS","OFF",FlowItem.actorFO,0,
	function () 
		return sysElectric.gen1Switch:getStatus() == 0 and 
			sysElectric.gen2Switch:getStatus() == 0
	end,
	function ()
		sysElectric.gen1Switch:actuate(0)
		sysElectric.gen2Switch:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("L & R ENG BLD AIR","OFF",FlowItem.actorFO,0,
	function () 
		return sysAir.engBleedGroup:getStatus() == 0
	end,
	function () 
		sysAir.engBleedGroup:actuate(0)
	end))
shutdownProc:addItem(ProcedureItem:new("FUEL PUMP 1 & 2","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/fuel/sw_pump1") == 0 and 
		get("aerobask/fuel/sw_pump2") == 0
	end,
	function () 
		command_once("aerobask/fuel/pump1_dn")
		command_once("aerobask/fuel/pump1_dn")
		command_once("aerobask/fuel/pump2_dn")
		command_once("aerobask/fuel/pump2_dn")
	end))
shutdownProc:addItem(ProcedureItem:new("PRESSURIZATION & AIRCOND PANEL","CHECK",FlowItem.actorFO,0,
	function () return 
		get("aerobask/press/sw_mode") == 1 and 
		get("aerobask/press/knob_ecs") == 2 and 
		get("aerobask/airco/sw_ckpt_fan") == 0 and 
		get("aerobask/airco/sw_cabin_fan") == 0 and 
		get("aerobask/airco/sw_mode") == 0
	end,
	function () 
		command_once("aerobask/press/mode_up")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_rt")
		command_once("aerobask/press/ecs_lt")
		set("aerobask/airco/knob_ckpt_temp",0)
		set("aerobask/airco/knob_cabin_temp",0)
		command_once("aerobask/airco/cabin_fan_dn")
		command_once("aerobask/airco/cabin_fan_dn")
		command_once("aerobask/airco/ckpt_fan_dn")
		command_once("aerobask/airco/ckpt_fan_dn")
		command_once("aerobask/airco/mode_dn")
		command_once("aerobask/airco/mode_dn")
	end))
shutdownProc:addItem(ProcedureItem:new("ELT SWITCH","OFF",FlowItem.actorFO,0,
	function () return 
		get("aerobask/elt/sw_elt") == 0
	end,
	function () 
		command_once("aerobask/elt/elt_dn")
		command_once("aerobask/elt/elt_dn")
	end))
shutdownProc:addItem(ProcedureItem:new("DOOR","OPEN",FlowItem.actorFO,0,
	function () return sysGeneral.doorGroup:getStatus() > 0 end,
	function () sysGeneral.doorL1:actuate(1) end))	

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("COLD & DARK","SET","SYS",1,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))
coldAndDarkProc:addItem(ProcedureItem:new("GPU DISCONNECT","SET","SYS",0,true,
	function ()
		if kc_has_gpu == true then
			sysElectric.gpuConnect:actuate(0)
		end
		getActiveSOP():setActiveFlowIndex(1)
	end))
		
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("TURNAROUND","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
		getActiveSOP():setActiveFlowIndex(2)
	end))

-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

-- activeSOP:addProcedure(testProc)
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(beforeStart)
activeSOP:addProcedure(prePushStartProc)
activeSOP:addProcedure(engStartProc)
activeSOP:addProcedure(afterStartProc)
activeSOP:addProcedure(beforeTakeoffProc)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(gearUpProc)
activeSOP:addProcedure(flapsUpProc)
activeSOP:addProcedure(afterTakeoffCheck)
activeSOP:addProcedure(climbCheck)
activeSOP:addProcedure(cruiseCheck)
activeSOP:addProcedure(descentProc)
activeSOP:addProcedure(landingProc)
activeSOP:addProcedure(flapsProc)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(taxiLightOff)
activeSOP:addProcedure(shutdownProc)


-- =========== States ===========
activeSOP:addState(turnAroundProc)
activeSOP:addState(coldAndDarkProc)

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("above10k", false) -- aircraft climbs through 10.000 ft
kc_procvar_initialize_bool("below10k", false) -- aircraft descends through 10.000 ft
kc_procvar_initialize_bool("attransalt", false) -- aircraft climbs through transition altitude
kc_procvar_initialize_bool("attranslvl", false) -- aircraft descends through transition level
kc_procvar_initialize_bool("apustart", false) -- Start apu
kc_procvar_initialize_bool("apuonline", false) -- APU Gen & Bleed online
kc_procvar_initialize_bool("engstart1", false) 
kc_procvar_initialize_bool("engstart2", false) 
kc_procvar_initialize_bool("engstart3", false) 
kc_procvar_initialize_bool("engstart4", false) 

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		if kc_procvar_get("above10k") == true then 
			kc_bck_climb_through_10k("above10k")
		end
		if kc_procvar_get("below10k") == true then 
			kc_bck_descend_through_10k("below10k")
		end
		if kc_procvar_get("attransalt") == true then 
			kc_bck_transition_altitude("attransalt")
		end
		if kc_procvar_get("attranslvl") == true then 
			kc_bck_transition_level("attranslvl")
		end
		if kc_procvar_get("apustart") == true then 
			kc_bck_apustart("apustart")
		end
		if kc_procvar_get("apuonline") == true then 
			kc_bck_apuonline("apuonline")
		end
		if kc_procvar_get("engstart1") == true then 
			kc_bck_start_engine("engstart1")
		end
		if kc_procvar_get("engstart2") == true then 
			kc_bck_start_engine("engstart2")
		end
		if kc_procvar_get("engstart3") == true then 
			kc_bck_start_engine("engstart3")
		end
		if kc_procvar_get("engstart4") == true then 
			kc_bck_start_engine("engstart4")
		end
	end))

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

kc_procvar_initialize_bool("waitformaster", false) 

function getActiveSOP()
	return activeSOP
end


return SOP_E55P
