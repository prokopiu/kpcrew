-- A333 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysElectric = {
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

logMsg ("Electric A333")
require "kpcrew.systems.DFLT.sysElectric"

--------- Batteries

-- ** BATTERY Switches
sysElectric.batterySwitch 	= TwoStateToggleSwitch:new("battery1","laminar/A333/buttons/battery1_pos",0,
	"sim/electrical/battery_1_toggle")
sysElectric.battery2Switch 	= TwoStateToggleSwitch:new("battery2","laminar/A333/buttons/battery2_pos",0,
	"sim/electrical/battery_2_toggle")
sysElectric.battery3Switch 	= TwoStateToggleSwitch:new("battery3","laminar/A333/buttons/APU_batt_pos",0,
	"laminar/A333/buttons/APU_batt_toggle")
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryGroup:addSwitch(battery2Switch)
sysElectric.batteryGroup:addSwitch(battery3Switch)

-- BAT Voltages
sysElectric.bat1Volt 		= SimpleAnnunciator:new("bat1volt","sim/cockpit2/electrical/battery_voltage_actual_volts",-1)
sysElectric.bat2Volt 		= SimpleAnnunciator:new("bat2volt","sim/cockpit2/electrical/battery_voltage_actual_volts",1)
sysElectric.batapuVolt 		= SimpleAnnunciator:new("apuvolt","sim/cockpit2/electrical/battery_voltage_actual_volts",2)

-- GPU
sysElectric.gpuConnect 		= InopSwitch:new("gpuconnect")
sysElectric.gpuSwitch 		= TwoStateToggleSwitch:new("gpuswitch","laminar/A333/annun/elec/ext_a_on",0,
	"laminar/A333/buttons/external_powerA_toggle")
sysElectric.gpuAvailAnc 	= SimpleAnnunciator:new("gpuavail","laminar/A333/status/GPU_avail",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","laminar/A333/annun/apu_avail",0)

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

return sysElectric