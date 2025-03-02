-- Laminar A330 variants airplane 
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

logMsg("A33L sysElectric")

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1)
sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1)
sysElectric.battery3Switch 	= TwoStateDrefSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",2)
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryGroup:addSwitch(battery2Switch)
sysElectric.batteryGroup:addSwitch(battery3Switch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateToggleSwitch:new("GPU","laminar/A333/status/GPU_avail",0,
	"sim/ground_ops/service_plane")
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit2/electrical/GPU_generator_on",0)
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateToggleSwitch:new("dcbustie","laminar/A333/buttons/bus_tie_pos",0,
	"sim/electrical/cross_tie_toggle")

return sysElectric
