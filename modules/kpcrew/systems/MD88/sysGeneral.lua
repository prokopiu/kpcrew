-- Rotate MD88 airplane 
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

-- Wiper Switches
sysGeneral.wiperLeft = TwoStateDrefSwitch:new("wiperleft","Rotate/md80/misc/wiper_left_switch",0)
sysGeneral.wiperRight = TwoStateDrefSwitch:new("wiperleft","Rotate/md80/misc/wiper_right_switch",0)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

-- Doors
sysGeneral.doorL1			= TwoStateCmdSwitch:new("doorl1","Rotate/md80/doors/main_cabin_door_ratio",0,
	"Rotate/md80/doors/main_cabin_door_open", "Rotate/md80/doors/main_cabin_door_close", "nocommand")
sysGeneral.doorL2			= TwoStateCmdSwitch:new("doorl2","Rotate/md80/doors/back_cabin_door_ratio",0,
	"Rotate/md80/doors/back_cabin_door_open", "Rotate/md80/doors/back_cabin_door_close", "nocommand")

sysGeneral.doorR1			= InopSwitch:new("doorr1")
sysGeneral.doorR2			= InopSwitch:new("doorr2")

sysGeneral.doorFCargo 		= TwoStateCmdSwitch:new("doorfcargo","Rotate/md80/doors/load_door_ratio",0,
	"Rotate/md80/doors/load_door_open", "Rotate/md80/doors/load_door_close", "nocommand")
sysGeneral.doorACargo 		= TwoStateCmdSwitch:new("dooracargo","Rotate/md80/doors/load_door_ratio",0,
	"Rotate/md80/doors/load_door_open", "Rotate/md80/doors/load_door_close", "nocommand")

sysGeneral.cockpitDoor 		= TwoStateCmdSwitch:new("cockpitdoor", "Rotate/md80/doors/cockpit_door_ratio", 0,
	"Rotate/md80/doors/cockpit_door_open", "Rotate/md80/doors/cockpit_door_close", "nocommand")

sysGeneral.stairs			= TwoStateCmdSwitch:new("stairs", "Rotate/md80/doors/main_stair_ratio", 0,
	"Rotate/md80/doors/main_stair_open", "Rotate/md80/doors/main_stair_close", "nocommand")
	
return sysGeneral