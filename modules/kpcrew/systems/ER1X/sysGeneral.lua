-- ER1X airplane 
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

logMsg("ER1X sysGeneral")

-- Optional Gound objects
sysGeneral.groundObjects = InopSwitch:new("ground objects")

-- Doors
sysGeneral.doorL1			= TwoStateDrefSwitch:new("doorl1","XCrafts/doors/front_main",0)
sysGeneral.doorR1			= TwoStateDrefSwitch:new("doorr1","XCrafts/doors/front_service",0)
sysGeneral.doorACargo 		= TwoStateDrefSwitch:new("dooracargo","XCrafts/doors/back_cargo",0)
sysGeneral.cockpitDoor 		= TwoStateDrefSwitch:new("cockpitdoor","sim/cockpit2/switches/custom_slider_on",12)

sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorR1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)

return sysGeneral