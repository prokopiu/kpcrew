-- B738 airplane 
-- Engine related functionality

local sysEngines = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

--------- Switches

local drefEngine1Fire 	 = "laminar/B738/annunciator/engine1_fire"
local drefEngine2Fire 	 = "laminar/B738/annunciator/engine2_fire"
local drefAPUFire 		 = "laminar/B738/annunciator/apu_fire"
local drefEngine1Starter = "laminar/B738/air/engine1/starter_valve"
local drefEngine2Starter = "laminar/B738/air/engine2/starter_valve"
local drefEngine1Oil 	 = "laminar/B738/engine/eng1_oil_press"
local drefEngine2Oil 	 = "laminar/B738/engine/eng2_oil_press"

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

-- engine start levers (fuel)
sysEngines.startLever1 = TwoStateCmdSwitch:new("","laminar/B738/engine/mixture_ratio1",0,"laminar/B738/engine/mixture1_idle","laminar/B738/engine/mixture1_cutoff","laminar/B738/engine/mixture1_toggle")
sysEngines.startLever2 = TwoStateCmdSwitch:new("","laminar/B738/engine/mixture_ratio2",0,"laminar/B738/engine/mixture2_idle","laminar/B738/engine/mixture2_cutoff","laminar/B738/engine/mixture2_toggle")

sysEngines.startLeverGroup = SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- OVHT Test
sysEngines.ovhtFireTestSwitch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/fire_test",0,"laminar/B738/toggle_switch/fire_test_rgt")

-- IGN select
sysEngines.ignSelectSwitch = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/eng_start_source",0,"laminar/B738/toggle_switch/eng_start_source_left","laminar/B738/toggle_switch/eng_start_source_right")

-- STARTER Switches
sysEngines.engStart1Switch = MultiStateCmdSwitch:new("","laminar/B738/engine/starter1_pos",0,"laminar/B738/knob/eng1_start_left","laminar/B738/knob/eng1_start_right")
sysEngines.engStart2Switch = MultiStateCmdSwitch:new("","laminar/B738/engine/starter2_pos",0,"laminar/B738/knob/eng2_start_left","laminar/B738/knob/eng2_start_right")

sysEngines.engStarterGroup = SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

----------- Annunciators

-- ENGINE FIRE annunciator
sysEngines.engineFireAnc = CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngine1Fire) == 1 or get(drefEngine2Fire) == 1 or get(drefAPUFire) == 1 then
		return 1
	else
		return 0
	end
end)

-- OIL PRESSURE annunciator
sysEngines.OilPressureAnc = CustomAnnunciator:new("oilpressure",
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

-- Reverse Thrust
sysEngines.reverseAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get("sim/cockpit/warnings/annunciators/reverse",0) > 0 then
		return 1
	else
		return 0
	end
end)

sysEngines.reverseLever1 = SimpleAnnunciator:new("","laminar/B738/flt_ctrls/reverse_lever1",0)
sysEngines.reverseLever2 = SimpleAnnunciator:new("","laminar/B738/flt_ctrls/reverse_lever2",0)

sysEngines.thrustLever1 = SimpleAnnunciator:new ("","laminar/B738/engine/thrust1_leveler",0)
sysEngines.thrustLever2 = SimpleAnnunciator:new ("","laminar/B738/engine/thrust2_leveler",0)

return sysEngines