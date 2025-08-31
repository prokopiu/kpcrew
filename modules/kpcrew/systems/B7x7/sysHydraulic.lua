-- B7x7 FF B767 B757 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

sysHydraulic = require("kpcrew.systems.DFLT.sysHydraulic")

logMsg("B7x7 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup 	= SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPump1		= TwoStateDrefSwitch:new("elechydpump1","anim/9/button",0)
sysHydraulic.elecHydPump2		= TwoStateDrefSwitch:new("elechydpump2","anim/10/button",0)
sysHydraulic.elecHydPump3		= TwoStateDrefSwitch:new("elechydpump3","anim/12/button",0)
sysHydraulic.elecHydPump4		= TwoStateDrefSwitch:new("elechydpump4","anim/13/button",0)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump2)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump3)
sysHydraulic.elecHydPumpGroup:addSwitch(elecHydPump4)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","anim/8/button",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","anim/11/button",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

return sysHydraulic