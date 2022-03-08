-- DFLT airplane 
-- Hydraulic system functionality

local sysHydraulic = {
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

local drefHydPressure1 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 = "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic