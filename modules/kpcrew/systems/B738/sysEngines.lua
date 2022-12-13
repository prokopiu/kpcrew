-- B738 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysEngines = {
}

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

--------- Switch datarefs common

local drefStartLever1		= "laminar/B738/engine/mixture_ratio1"
local drefStartLever2		= "laminar/B738/engine/mixture_ratio2"
local drefIgnitionSelector	= "laminar/B738/toggle_switch/eng_start_source"

--------- Annunciator datarefs common

local drefReverserState		= "sim/cockpit/warnings/annunciators/reverse"
local drefThrustLever1		= "laminar/B738/engine/thrust1_leveler"
local drefThrustLever2		= "laminar/B738/engine/thrust2_leveler"
local drefReverseLever1		= "laminar/B738/flt_ctrls/reverse_lever1"
local drefReverseLever2		= "laminar/B738/flt_ctrls/reverse_lever2"
local drefEngine1Starter 	= "laminar/B738/air/engine1/starter_valve"
local drefEngine2Starter 	= "laminar/B738/air/engine2/starter_valve"
local drefEngine1Oil 	 	= "laminar/B738/engine/eng1_oil_press"
local drefEngine2Oil 	 	= "laminar/B738/engine/eng2_oil_press"
local drefEngine1Fire 	 	= "laminar/B738/annunciator/engine1_fire"
local drefEngine2Fire 	 	= "laminar/B738/annunciator/engine2_fire"
local drefAPUFire 		 	= "laminar/B738/annunciator/apu_fire"

--------- Switch commands common

local cmdReverserToggle		= "sim/engines/thrust_reverse_toggle"
local cmdStartLever1Off		= "laminar/B738/engine/mixture1_cutoff"
local cmdStartLever1On		= "laminar/B738/engine/mixture1_idle"
local cmdStartLever1Tgl		= "laminar/B738/engine/mixture1_toggle"
local cmdStartLever2Off		= "laminar/B738/engine/mixture2_cutoff"
local cmdStartLever2On		= "laminar/B738/engine/mixture2_idle"
local cmdStartLever2Tgl		= "laminar/B738/engine/mixture2_toggle"
local cmdIgnSelectorDown	= "laminar/B738/toggle_switch/eng_start_source_left"
local cmdIgnSelectorUp		= "laminar/B738/toggle_switch/eng_start_source_right"

--------- Actuator definitions

-- Reverse Toggle
sysEngines.reverseToggle 	= TwoStateToggleSwitch:new("reverse",drefReverserState,0,cmdReverserToggle) 

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

-- OVHT Test
sysEngines.ovhtFireTestSwitch = KeepPressedSwitchCmd:new("OVHTtest","laminar/B738/toggle_switch/fire_test",0,
	"laminar/B738/toggle_switch/fire_test_rgt")

-- STARTER Switches
sysEngines.engStart1Switch 	= MultiStateCmdSwitch:new("","laminar/B738/engine/starter1_pos",0,
	"laminar/B738/knob/eng1_start_left","laminar/B738/knob/eng1_start_right",0,3,true)
sysEngines.engStart2Switch 	= MultiStateCmdSwitch:new("","laminar/B738/engine/starter2_pos",0,
	"laminar/B738/knob/eng2_start_left","laminar/B738/knob/eng2_start_right",0,3,true)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

sysEngines.eecGuard1 		= TwoStateToggleSwitch:new("eec1","laminar/B738/cover",0,
	"laminar/B738/button_switch_cover00")
sysEngines.eecGuard2 		= TwoStateToggleSwitch:new("eec2","laminar/B738/cover",1,
	"laminar/B738/button_switch_cover01")
sysEngines.eecGuardGroup 	= SwitchGroup:new("eecguards")
sysEngines.eecGuardGroup:addSwitch(sysEngines.eecGuard1)
sysEngines.eecGuardGroup:addSwitch(sysEngines.eecGuard2)

sysEngines.eecSwitch1 		= TwoStateCmdSwitch:new("eecsw1","laminar/B738/annunciator/fadec1_off",0,
	"sim/fadec/fadec_1_on","sim/fadec/fadec_1_off")
sysEngines.eecSwitch2 		= TwoStateCmdSwitch:new("eecsw2","laminar/B738/annunciator/fadec2_off",0,
	"sim/fadec/fadec_2_on","sim/fadec/fadec_2_off")
sysEngines.eecSwitchGroup 	= SwitchGroup:new("eecswitches")
sysEngines.eecSwitchGroup:addSwitch(sysEngines.eecSwitch1)
sysEngines.eecSwitchGroup:addSwitch(sysEngines.eecSwitch2)

----------- Annunciators

-- Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("reverserstate",
function ()
	if get(drefReverserState,0) > 0 then
		return 1
	else
		return 0
	end
end)

-- Thrust lever state
sysEngines.thrustLever1 	= SimpleAnnunciator:new ("",drefThrustLever1,0)
sysEngines.thrustLever2 	= SimpleAnnunciator:new ("",drefThrustLever2,0)

-- Reverser lever state
sysEngines.reverseLever1 	= SimpleAnnunciator:new("",drefReverseLever1,0)
sysEngines.reverseLever2 	= SimpleAnnunciator:new("",drefReverseLever2,0)

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then
		return 1
	else
		return 0
	end
end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngine1Oil) == 0 or get(drefEngine2Oil) == 0 then
		return 1
	else
		return 0
	end
end)

-- ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngine1Starter) == 0 and get(drefEngine2Starter) == 0 then
		return 0
	else
		return 1
	end
end)

sysEngines.fadecFail 		= CustomAnnunciator:new("fadecfail",
function () 
	return (get("laminar/B738/annunciator/fadec_fail_0") + get("laminar/B738/annunciator/fadec_fail_1"))
end)

sysEngines.reversersFail 	= CustomAnnunciator:new("reversefail",
function () 
	return (get("laminar/B738/annunciator/reverser_fail_0") + get("laminar/B738/annunciator/reverser_fail_1"))
end)

return sysEngines