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

--------- Switch datarefs common

local drefHydPump1			= "1-sim/65/button"
local drefHydPump2			= "1-sim/67/button"
local drefElecPump1			= "1-sim/47/button"
local drefElecPump2			= "1-sim/49/button"

--------- Annunciator datarefs common

local drefHydraulic1Anc		= "1-sim/hyd/systemG"
local drefHydraulic2Anc		= "1-sim/hyd/systemY"

--------- Switch commands common


--------- Actuator definitions

-- HYD Engine Pumps
sysHydraulic.hydPump1		= TwoStateDrefSwitch:new("hydpump1",drefHydPump1,0)
sysHydraulic.hydPump2		= TwoStateDrefSwitch:new("hydpump1",drefHydPump2,0)
sysHydraulic.hydPump3		= TwoStateDrefSwitch:new("hydpump1","1-sim/75/button",0)
sysHydraulic.hydPump4		= TwoStateDrefSwitch:new("hydpump1","1-sim/77/button",0)
sysHydraulic.hydPumpGroup 	= SwitchGroup:new("hydraulicpumps")
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.hydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.hydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.hydPump3)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.hydPump4)

-- Elec hyd pump1
sysHydraulic.elecpump1		= TwoStateDrefSwitch:new("elechyd1",drefElecPump1,0)
sysHydraulic.elecpump2		= TwoStateDrefSwitch:new("elechyd1",drefElecPump2,0)

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydraulic1Anc,0) == 0 or get(drefHydraulic2Anc,0) == 0 then
		return 1
	else
		return 0
	end
end)

return sysHydraulic