-- B748 airplane 
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

logMsg("B748 sysHydraulic")

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup 	= SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPump1		= TwoStateDrefSwitch:new("elechydpump1","ssg/HYD/hyd_pump1_swb",0)
sysHydraulic.elecHydPump2		= TwoStateDrefSwitch:new("elechydpump2","ssg/HYD/hyd_pump2_swb",0)
sysHydraulic.elecHydPump3		= TwoStateDrefSwitch:new("elechydpump3","ssg/HYD/hyd_pump3_swb",0)
sysHydraulic.elecHydPump4		= TwoStateDrefSwitch:new("elechydpump4","ssg/HYD/hyd_pump4_swb",0)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump3)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump4)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1","ssg/HYD/hyd1_demd",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2","ssg/HYD/hyd2_demd",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3","ssg/HYD/hyd3_demd",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4","ssg/HYD/hyd4_demd",0)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)

return sysHydraulic