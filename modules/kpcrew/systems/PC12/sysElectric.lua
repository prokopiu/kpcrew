-- PC12 airplane 
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

logMsg("PC12 sysElectric")

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1","thranda/Switch",7,
	"thranda/switches/SwitchUp07","thranda/switches/SwitchDn07","nocommand")
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","thranda/Switch",11,
	"thranda/switches/SwitchUp11","thranda/switches/SwitchDn11","nocommand")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryGroup:addSwitch(battery2Switch)

sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",-1)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("BATT2 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",1)
sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps","sim/cockpit2/electrical/battery_amps",-1)
sysElectric.batt2Amp 		= SimpleAnnunciator:new("BATT2 Amps","sim/cockpit2/electrical/battery_amps",1)

return sysElectric
