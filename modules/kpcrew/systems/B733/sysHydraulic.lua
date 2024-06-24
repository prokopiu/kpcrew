-- B733 IXEG B737 PRO 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
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

local drefElHydPressure1 	= "ixeg/733/hydraulics/hyd_elec1_lowpress_ann"
local drefElHydPressure2 	= "ixeg/733/hydraulics/hyd_elec2_lowpress_ann"
local drefHydPressure1 		= "ixeg/733/hydraulics/hyd_eng1_lowpress_ann"
local drefHydPressure2 		= "ixeg/733/hydraulics/hyd_eng2_lowpress_ann"

-- ===== Switches

sysHydraulic.elecHydPump1 	= TwoStateDrefSwitch:new("","ixeg/733/hydraulics/hyd_elec1_act",0)
sysHydraulic.elecHydPump2 	= TwoStateDrefSwitch:new("","ixeg/733/hydraulics/hyd_elec2_act",0)
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

sysHydraulic.engHydPump1 	= TwoStateToggleSwitch:new("","ixeg/733/hydraulics/hyd_eng1_act",0)
sysHydraulic.engHydPump2 	= TwoStateToggleSwitch:new("","ixeg/733/hydraulics/hyd_eng2_act",0)
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

sysHydraulic.hydPumpGroup 	= SwitchGroup:new("hydpumps")
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

-- ===== Annunciators

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