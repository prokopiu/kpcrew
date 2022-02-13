-- B738 airplane 
-- Hydraulic system functionality

local sysHydraulic = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

local drefElHydPressure1 = "laminar/B738/annunciator/hyd_el_press_a"
local drefElHydPressure2 = "laminar/B738/annunciator/hyd_el_press_b"
local drefHydPressure1 = "laminar/B738/annunciator/hyd_press_a"
local drefHydPressure2 = "laminar/B738/annunciator/hyd_press_b"

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 or get(drefElHydPressure1,0) == 1 or get(drefElHydPressure2,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic