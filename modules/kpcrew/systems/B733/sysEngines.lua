-- B733 IXEG B737 PRO 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
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

local drefStartLever1		= "ixeg/733/fuel/fuel_start_lever1_act"
local drefStartLever2		= "ixeg/733/fuel/fuel_start_lever1_act"
local drefIgnitionSelector	= "ixeg/733/engine/ign_select_act"

--------- Annunciator datarefs common

local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefThrustLever1		= "ixeg/733/engine/eng1_thro_angle"
local drefThrustLever2		= "ixeg/733/engine/eng2_thro_angle"
local drefReverseLever1		= "laminar/B738/flt_ctrls/reverse_lever1"
local drefReverseLever2		= "laminar/B738/flt_ctrls/reverse_lever2"
local drefEngine1Starter 	= "ixeg/733/engine/eng1_start_act"
local drefEngine2Starter 	= "ixeg/733/engine/eng2_start_act"
local drefEngine1Oil 	 	= "ixeg/733/ecam/eng1_oilp_needle_ind"
local drefEngine2Oil 	 	= "ixeg/733/ecam/eng2_oilp_needle_ind"
local drefEngine1Fire 	 	= "ixeg/733/firewarning/fire_eng1_fire_ann"
local drefEngine2Fire 	 	= "ixeg/733/firewarning/fire_eng2_fire_ann"
local drefAPUFire 		 	= "ixeg/733/firewarning/fire_apu_fire_ann"

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

-- Reversers
sysEngines.reverser1 		= TwoStateCustomSwitch:new("reverse1",drefReverserState,-1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_1")
	end,
	function () 
	end	
)
sysEngines.reverser2 		= TwoStateCustomSwitch:new("reverse2",drefReverserState,1,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_2")
	end,
	function () 
	end	
)
sysEngines.reverser3 		= TwoStateCustomSwitch:new("reverse3",drefReverserState,2,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_3")
	end,
	function () 
	end	
)
sysEngines.reverser4 		= TwoStateCustomSwitch:new("reverse4",drefReverserState,3,
	function () 
		command_begin("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
		command_end("sim/engines/thrust_reverse_hold_4")
	end,
	function () 
	end	
)
sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser2)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser3)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser4)

-- engine start levers (fuel)
sysEngines.startLever1 		= TwoStateDrefSwitch:new("",drefStartLever1,0)
sysEngines.startLever2 		= TwoStateDrefSwitch:new("",drefStartLever2,0)
sysEngines.startLeverGroup 	= SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- IGN select
sysEngines.ignSelectSwitch 	= TwoStateDrefSwitch:new("",drefIgnitionSelector,0)

-- OVHT Test
sysEngines.ovhtFireTestSwitch = TwoStateDrefSwitch:new("OVHTtest","ixeg/733/firewarning/fire_ovht_test_act",0)

-- STARTER Switches
sysEngines.engStart1Switch 	= TwoStateDrefSwitch:new("",drefEngine1Starter,0)
sysEngines.engStart2Switch 	= TwoStateDrefSwitch:new("",drefEngine2Starter,0)
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

-- ** Magnetos
sysEngines.magnetoOff		= InopSwitch:new("magnetoOff")
sysEngines.magnetoL			= InopSwitch:new("magnetoL")
sysEngines.magnetoR			= InopSwitch:new("magnetoR")
sysEngines.magnetoBoth		= InopSwitch:new("magnetoBoth")
sysEngines.magnetoStart		= InopSwitch:new("magnetoStart")

----------- Annunciators

-- Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("reverserstate",
function ()
	if get(drefReverserState,-1) > 0 then
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