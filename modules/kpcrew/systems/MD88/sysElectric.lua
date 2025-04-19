-- Rotate MD88 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

-- GPU Bus Switches
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","Rotate/md80/electrical/GPU_l_bus_switch",0)
sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus2","Rotate/md80/electrical/GPU_r_bus_switch",0)
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","Rotate/md80/electrical/APU_l_bus_switch",0)
sysElectric.apuGenBus2 		= TwoStateDrefSwitch:new("apubus2","Rotate/md80/electrical/APU_r_bus_switch",0)
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

return sysElectric