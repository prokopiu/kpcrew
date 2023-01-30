-- DFLT  airplane 
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

--------- Switches

-- ** BATTERY Switch
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1,
	"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1,
	"sim/electrical/battery_2_on","sim/electrical/battery_2_off","sim/electrical/battery_2_toggle")

-- ** HARDWARE BATTERY Switch
sysElectric.battery1HwSwitch 	= TwoStateCmdSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1,
	"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")
sysElectric.battery2HwSwitch 	= TwoStateCmdSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1,
	"sim/electrical/battery_2_on","sim/electrical/battery_2_off","sim/electrical/battery_2_toggle")
sysElectric.batteryHwGroup 	= SwitchGroup:new("battery hardware")
sysElectric.batteryHwGroup:addSwitch(battery1HwSwitch)
sysElectric.batteryHwGroup:addSwitch(battery2HwSwitch)

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateCmdSwitch:new("GPU","sim/cockpit/electrical/gpu_on",0,
	"sim/electrical/GPU_on","sim/electrical/GPU_off","sim/electrical/GPU_toggle")

-- APU Bus Switches
sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateCmdSwitch:new("gen1","sim/cockpit/electrical/generator_on",-1,
	"sim/electrical/generator_1_on","sim/electrical/generator_1_off","sim/electrical/generator_1_toggle")
sysElectric.gen2Switch 		= TwoStateCmdSwitch:new("gen2","sim/cockpit/electrical/generator_on",1,
	"sim/electrical/generator_2_on","sim/electrical/generator_2_off","sim/electrical/generator_2_toggle")
-- sysElectric.gen3Switch 		= InopSwitch:new("gen3")
-- sysElectric.gen4Switch 		= InopSwitch:new("gen4")
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
-- sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
-- sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1","sim/cockpit/electrical/generator_on",-1,
	"sim/electrical/generator_1_on","sim/electrical/generator_1_off","sim/electrical/generator_1_toggle")
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2","sim/cockpit/electrical/generator_on",1,
	"sim/electrical/generator_2_on","sim/electrical/generator_2_off","sim/electrical/generator_2_toggle")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateCmdSwitch:new("aviobus1","sim/cockpit2/switches/avionics_power_on",0,
	"sim/systems/avionics_on","sim/systems/avionics_off","sim/systems/avionics_toggle")
sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- APU Starter
sysElectric.apuStartSwitch 	= KeepPressedSwitchCmd:new("apu","sim/cockpit2/electrical/APU_running",0,"sim/electrical/APU_start")

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

sysElectric.apuGenBusOff = SimpleAnnunciator:new("","sim/cockpit/electrical/generator_apu_on",0)
sysElectric.gpuOnBus = SimpleAnnunciator:new("","sim/cockpit/electrical/gpu_on",0)

return sysElectric