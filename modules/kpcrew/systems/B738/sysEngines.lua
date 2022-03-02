-- B738 airplane 
-- Engine related functionality

local sysEngines = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

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
sysEngines.engStart1Switch = MultiStateCmdSwitch:new("","laminar/B738/engine/starter1_pos","laminar/B738/knob/eng1_start_left","laminar/B738/knob/eng1_start_right")
sysEngines.engStart2Switch = MultiStateCmdSwitch:new("","laminar/B738/engine/starter2_pos","laminar/B738/knob/eng2_start_left","laminar/B738/knob/eng2_start_right")

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

return sysEngines