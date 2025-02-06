-- Laminar A330 variants airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysGeneral = {
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("A33L sysGeneral")

sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","sim/cockpit2/switches/door_open",-1)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","sim/cockpit2/switches/door_open",6)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","sim/cockpit2/switches/door_open",1)
sysGeneral.doorR2			= TwoStateDrefSwitch:new("doorr2","sim/cockpit2/switches/door_open",7)
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo","sim/cockpit2/switches/door_open",8)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","sim/cockpit2/switches/door_open",9)
sysGeneral.doorex1	 		= TwoStateDrefSwitch:new("doorex1","sim/cockpit2/switches/door_open",2)
sysGeneral.doorex2	 		= TwoStateDrefSwitch:new("doorex2","sim/cockpit2/switches/door_open",3)
sysGeneral.doorex3	 		= TwoStateDrefSwitch:new("doorex3","sim/cockpit2/switches/door_open",4)
sysGeneral.doorex4	 		= TwoStateDrefSwitch:new("doorex4","sim/cockpit2/switches/door_open",5)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/door_open",11)
sysGeneral.stairsL1 		= InopSwitch:new("stairs1")

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorex1)	 
sysGeneral.doorGroup:addSwitch(sysGeneral.doorex2)	 
sysGeneral.doorGroup:addSwitch(sysGeneral.doorex3)	 
sysGeneral.doorGroup:addSwitch(sysGeneral.doorex4)	 


return sysGeneral