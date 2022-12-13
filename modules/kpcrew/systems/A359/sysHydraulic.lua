-- A350 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysHydraulic = {
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

-- HYD Electric Pump
sysHydraulic.pump1			= TwoStateDrefSwitch:new("hydpump1","1-sim/65/button",0)
sysHydraulic.pump2			= TwoStateDrefSwitch:new("hydpump1","1-sim/67/button",0)
sysHydraulic.pump3			= TwoStateDrefSwitch:new("hydpump1","1-sim/75/button",0)
sysHydraulic.pump4			= TwoStateDrefSwitch:new("hydpump1","1-sim/77/button",0)
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("hydraulicpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.pump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.pump2)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.pump3)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.pump4)

-- Elec hyd pump1
sysHydraulic.elecpump1		= TwoStateDrefSwitch:new("elechyd1","1-sim/47/button",0)
sysHydraulic.elecpump2		= TwoStateDrefSwitch:new("elechyd1","1-sim/49/button",0)

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get("1-sim/hyd/systemG",0) == 0 or get("1-sim/hyd/systemY",0) == 0 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic