-- E1XX airplane 
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("E1XX sysGeneral")

-- Windows
sysGeneral.window1			= TwoStateDrefSwitch:new("window1","sim/cockpit2/switches/custom_slider_on",6)
sysGeneral.window2			= TwoStateDrefSwitch:new("window2","sim/cockpit2/switches/custom_slider_on",7)
sysGeneral.windowGroup 		= SwitchGroup:new("doors")
sysGeneral.windowGroup:addSwitch(sysGeneral.window1)
sysGeneral.windowGroup:addSwitch(sysGeneral.window2)

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","XCrafts/doors/front_main",0)
sysGeneral.doorL2			= TwoStateDrefSwitch:new("doorl2","XCrafts/doors/back_main",0)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","XCrafts/doors/front_service",0)
sysGeneral.doorR2			= TwoStateDrefSwitch:new("doorr2","XCrafts/doors/back_service",0)
sysGeneral.doorFCargo 		= TwoStateDrefSwitch:new("doorfcargo","XCrafts/doors/front_cargo",0)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","XCrafts/doors/back_cargo",0)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/custom_slider_on",12)
sysGeneral.stairsL1 		= TwoStateDrefSwitch:new("stairs1","XCrafts/Lineage/animation/airstairs_target",0)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR2)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorFCargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)

return sysGeneral