-- E1FF X-Crafts Freeware airplane 
-- aircraft general systems

-- @classmod sysGeneral
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

logMsg("E1FF sysGeneral")

-- Optional Gound objects
sysGeneral.groundObjects = InopSwitch:new("ground objects")

sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","xcraft/doors/front_main",0)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","xcraft/doors/back_main",0)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","xcraft/doors/front_service",0)
sysGeneral.doorR2			= TwoStateDrefSwitch:new("doorr2","xcraft/doors/back_service",0)
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo","xcraft/doors/front_cargo",0)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","xcraft/doors/back_cargo",0)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/custom_slider_on",12)
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

sysGeneral.clock			= TwoStateDrefSwitch:new("clock","sim/cockpit2/clock_timer/chrono_running",-1)

return sysGeneral