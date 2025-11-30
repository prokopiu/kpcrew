-- B737 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysEngines.engStart1Switch - Starter Switches
-- sysEngines.engStart2Switch
-- sysEngines.engStart3Switch	
-- sysEngines.engStart4Switch
-- sysEngines.engStarterGroup
-- sysEngines.engineStarterAnc - 1 if a starter is running
-- sysEngines.engIgnition1	- Ignition Switches
-- sysEngines.engIgnition2
-- sysEngines.engIgnition3
-- sysEngines.engIgnition4
-- sysEngines.engIgnitionGroup
-- sysEngines.reverser1 - activate reversers for engines
-- sysEngines.reverser2
-- sysEngines.reverser3
-- sysEngines.reverser4
-- sysEngines.reverserGroup
-- sysEngines.magnetoOff - Magneto positions
-- sysEngines.magnetoL
-- sysEngines.magnetoR
-- sysEngines.magnetoBoth
-- sysEngines.magnetoStartOn
-- sysEngines.magnetoStartStop
-- sysEngines.throttlePos
-- sysEngines.mixtureLever
-- sysEngines.propLever
-- sysEngines.engineFireAnc
-- sysEngines.OilPressureAnc
-- sysEngines.oilqty1
-- sysEngines.oilqty2
-- sysEngines.oilqty3
-- sysEngines.oilqty4
-- sysEngines.reverseAnc
-- Macro: kc_bck_start_engine 
-- Macro: kc_macro_stop_engine 
-- Macro: kc_macro_set_eng_mode

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("B737 sysEngines")

--------- Switch datarefs common
local drefStarter1			= "laminar/B738/engine/starter1_pos"
local drefStarter2			= "laminar/B738/engine/starter2_pos"
local drefStartLever1		= "laminar/B738/engine/mixture_ratio1"
local drefStartLever2		= "laminar/B738/engine/mixture_ratio2"
local drefIgnitionSelector	= "laminar/B738/toggle_switch/eng_start_source"

local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefEngineStarter 	= "sim/flightmodel2/engines/starter_is_running"
local drefIgnition			= "sim/cockpit2/engine/actuators/auto_ignite_on"
local drefEngineOil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngineFire 		= "sim/cockpit2/annunciators/engine_fires"

--------- Annunciator datarefs common
local drefEngine1Oil 	 	= "laminar/B738/engine/eng1_oil_press"
local drefEngine2Oil 	 	= "laminar/B738/engine/eng2_oil_press"
local drefReverserAnn		= "sim/cockpit/warnings/annunciators/reverse"
local drefThrustLever1		= "laminar/B738/engine/thrust1_leveler"
local drefThrustLever2		= "laminar/B738/engine/thrust2_leveler"
local drefReverseLever1		= "laminar/B738/flt_ctrls/reverse_lever1"
local drefReverseLever2		= "laminar/B738/flt_ctrls/reverse_lever2"
local drefEngine1Fire 	 	= "laminar/B738/annunciator/engine1_fire"
local drefEngine2Fire 	 	= "laminar/B738/annunciator/engine2_fire"
local drefAPUFire 		 	= "laminar/B738/annunciator/apu_fire"

--------- Switch commands common
local cmdStarter1Left		= "laminar/B738/knob/eng1_start_left"
local cmdStarter1Right		= "laminar/B738/knob/eng1_start_right"
local cmdStarter2Left		= "laminar/B738/knob/eng2_start_left"
local cmdStarter2Right		= "laminar/B738/knob/eng2_start_right"
local cmdStartLever1Off		= "laminar/B738/engine/mixture1_cutoff"
local cmdStartLever1On		= "laminar/B738/engine/mixture1_idle"
local cmdStartLever1Tgl		= "laminar/B738/engine/mixture1_toggle"
local cmdStartLever2Off		= "laminar/B738/engine/mixture2_cutoff"
local cmdStartLever2On		= "laminar/B738/engine/mixture2_idle"
local cmdStartLever2Tgl		= "laminar/B738/engine/mixture2_toggle"
local cmdIgnSelectorDown	= "laminar/B738/toggle_switch/eng_start_source_left"
local cmdIgnSelectorUp		= "laminar/B738/toggle_switch/eng_start_source_right"

local cmdReverser1			= "sim/engines/thrust_reverse_hold_1"
local cmdReverser2			= "sim/engines/thrust_reverse_hold_2"
local cmdReverser3			= "sim/engines/thrust_reverse_hold_3"
local cmdReverser4			= "sim/engines/thrust_reverse_hold_4"
local cmdMagneto1Off		= "sim/magnetos/magnetos_off_1"
local cmdMagneto1Left		= "sim/magnetos/magnetos_left_1"
local cmdMagneto1Right		= "sim/magnetos/magnetos_right_1"
local cmdMagneto1Both		= "sim/magnetos/magnetos_both_1"
local cmdMagneto1Start		= "sim/starters/engage_start_run_1"
local cmdMagneto1Stop		= "sim/starters/engage_start_run_1"
local cmdEgine1Starter		= "sim/starters/engage_start_run_1"
local cmdEgine2Starter		= "sim/starters/engage_start_run_2"
local cmdEgine3Starter		= "sim/starters/engage_start_run_3"
local cmdEgine4Starter		= "sim/starters/engage_start_run_4"

----------- Switches

-- STARTER Switches
sysEngines.engStart1Switch 	= MultiStateCmdSwitch:new("",drefStarter1,0,cmdStarter1Left,cmdStarter1Right,0,3,true)
sysEngines.engStart2Switch 	= MultiStateCmdSwitch:new("",drefStarter2,0,cmdStarter2Left,cmdStarter2Right,0,3,true)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
	function () if get(drefStarter1,0) == 0 or get(drefStarter2,0) == 0 then return 1 else return 0 end end)

-- engine start levers (fuel)
sysEngines.startLever1 		= TwoStateCmdSwitch:new("",drefStartLever1,0,
	cmdStartLever1On,cmdStartLever1Off,cmdStartLever1Tgl)
sysEngines.startLever2 		= TwoStateCmdSwitch:new("",drefStartLever2,0,
	cmdStartLever2On,cmdStartLever2Off,cmdStartLever2Tgl)
sysEngines.startLeverGroup 	= SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- IGN select
sysEngines.ignSelectSwitch 	= MultiStateCmdSwitch:new("",drefIgnitionSelector,0,
	cmdIgnSelectorUp,cmdIgnSelectorDown,-1,1,false)

----------- Annunciators

-- Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("reverserstate",
	function () if get(drefReverserAnn,-1) > 0 then return 1 else return 0 end end)

-- Thrust lever state
sysEngines.thrustLever1 	= SimpleAnnunciator:new ("",drefThrustLever1,0)
sysEngines.thrustLever2 	= SimpleAnnunciator:new ("",drefThrustLever2,0)

-- Reverser lever state
sysEngines.reverseLever1 	= SimpleAnnunciator:new("",drefReverseLever1,0)
sysEngines.reverseLever2 	= SimpleAnnunciator:new("",drefReverseLever2,0)

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
	function ()	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then return 1 else return 0 end end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
	function () if get(drefEngine1Oil) == 0 or get(drefEngine2Oil) == 0 then return 1 else return 0 end end)

---------- Macros

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			sysEngines.engStart1Switch:actuate(0)
		end
		if trigger == "engstart2" then
			sysEngines.engStart2Switch:actuate(0)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				set("laminar/B738/engine/mixture_ratio1",1)
			end
			if trigger == "engstart2" then
				set("laminar/B738/engine/mixture_ratio2",1)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Macro: Stop engines 
function kc_macro_stop_engine()
	set("laminar/B738/engine/mixture_ratio1",0)
	set("laminar/B738/engine/mixture_ratio2",0)
end

return sysEngines
