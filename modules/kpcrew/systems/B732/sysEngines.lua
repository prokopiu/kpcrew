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

local drefEngine1Fire 	 = "FJS/732/FireProtect/Eng1FireLight"
local drefEngine2Fire 	 = "FJS/732/FireProtect/Eng2FireLight"
local drefAPUFire 		 = "FJS/732/FireProtect/APU_FireLight"
local drefEngine1Starter = "FJS/732/Eng/Engine1StartKnob"
local drefEngine2Starter = "FJS/732/Eng/Engine2StartKnob"
local drefEngine1Oil 	 = "FJS/732/Eng/OilPress1Needle"
local drefEngine2Oil 	 = "FJS/732/Eng/OilPress2Needle"

-- Reverse Toggle
sysEngines.reverseToggle = TwoStateToggleSwitch:new("reverse","sim/cockpit/warnings/annunciators/reverse",0,"sim/engines/thrust_reverse_toggle") 

-- engine start levers (fuel)
sysEngines.startLever1 = TwoStateDrefSwitch:new("","FJS/732/fuel/FuelMixtureLever1",0)
sysEngines.startLever2 = TwoStateDrefSwitch:new("","FJS/732/fuel/FuelMixtureLever2",0)

sysEngines.startLeverGroup = SwitchGroup:new("startLevers")
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever1)
sysEngines.startLeverGroup:addSwitch(sysEngines.startLever2)

-- OVHT Test
sysEngines.ovhtFireTestSwitch = TwoStateDrefSwitch:new("","FJS/732/FireProtect/FireTestSwitch",0)

-- IGN select
sysEngines.ignSelectSwitch = InopSwitch:new("ignSelect")

-- STARTER Switches
sysEngines.engStart1Switch = TwoStateDrefSwitch:new("","FJS/732/Eng/Engine1StartKnob",0)
sysEngines.engStart2Switch = TwoStateDrefSwitch:new("","FJS/732/Eng/Engine2StartKnob",0)

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

sysEngines.reverseLever1 = InopSwitch:new("") --,"laminar/B738/flt_ctrls/reverse_lever1",0)
sysEngines.reverseLever2 = InopSwitch:new("") --,"laminar/B738/flt_ctrls/reverse_lever2",0)

sysEngines.thrustLever1 = InopSwitch:new ("") --,"laminar/B738/engine/thrust1_leveler",0)
sysEngines.thrustLever2 = InopSwitch:new ("") --,"laminar/B738/engine/thrust2_leveler",0)

return sysEngines