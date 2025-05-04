-- MD88 Rotate airplane 
-- Electric system functionality

-- @classmod sysElectric
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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

logMsg("MD88 sysElectric")

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","Rotate/md80/electrical/battery_on",0)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateToggleSwitch:new("GPU","Rotate/md80/electrical/GPU_power_available",0,
	"Rotate/md80/electrical/GPU_power_request_toggle")
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","Rotate/md80/electrical/GPU_l_bus_switch",0)
sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus2","Rotate/md80/electrical/GPU_r_bus_switch",0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","Rotate/md80/electrical/GPU_power_available",0)

return sysElectric
