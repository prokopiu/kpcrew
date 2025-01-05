-- ToLiss A20N Airbusses
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

return sysElectric

--------- Batteries

-- ** BATTERY Switches
-- sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1","AirbusFBW/BatOHPArray",0,
	-- "toliss_airbus/eleccommands/Bat1On","toliss_airbus/eleccommands/Bat1Off","toliss_airbus/eleccommands/Bat1Toggle")
-- sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","AirbusFBW/BatOHPArray",1,
	-- "toliss_airbus/eleccommands/Bat2On","toliss_airbus/eleccommands/Bat2Off","toliss_airbus/eleccommands/Bat2Toggle")
-- sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
-- sysElectric.batteryGroup:addSwitch(sysElectric.batterySwitch)
-- sysElectric.batteryGroup:addSwitch(sysElectric.battery2Switch)

-- ** HARDWARE BATTERY Switch
-- sysElectric.battery1HwSwitch 	= TwoStateCmdSwitch:new("battery1","AirbusFBW/BatOHPArray",0,
	-- "toliss_airbus/eleccommands/Bat1On","toliss_airbus/eleccommands/Bat1Off","toliss_airbus/eleccommands/Bat1Toggle")
-- sysElectric.battery2HwSwitch 	= TwoStateCmdSwitch:new("battery2","AirbusFBW/BatOHPArray",1,
	-- "toliss_airbus/eleccommands/Bat2On","toliss_airbus/eleccommands/Bat2Off","toliss_airbus/eleccommands/Bat2Toggle")
-- sysElectric.batteryHwGroup 	= SwitchGroup:new("battery hardware")
-- sysElectric.batteryHwGroup:addSwitch(sysElectric.battery1HwSwitch)
-- sysElectric.batteryHwGroup:addSwitch(sysElectric.battery2HwSwitch)

-- sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage","AirbusFBW/BatVolts",-1)
-- sysElectric.batt2Volt 		= SimpleAnnunciator:new("BATT2 Voltage","AirbusFBW/BatVolts",1)
-- sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps","sim/cockpit2/electrical/battery_amps",-1)
-- sysElectric.batt2Amp 		= SimpleAnnunciator:new("BATT2 Amps","sim/cockpit2/electrical/battery_amps",1)

-- Ground Power
-- sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","AirbusFBW/EnableExternalPower",0)
-- sysElectric.gpuSwitch 		= TwoStateCmdSwitch:new("GPU","AirbusFBW/ExtPowOHPArray",0)

-- sysElectric.gpuOnBus = SimpleAnnunciator:new("","AirbusFBW/ExtPowOHPArray",0)
