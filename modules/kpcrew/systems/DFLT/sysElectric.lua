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
sysElectric.batterySwitch 	= TwoStateCmdSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1,"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1,"sim/electrical/battery_2_on","sim/electrical/battery_2_off","sim/electrical/battery_2_toggle")

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateCmdSwitch:new("GPU","sim/cockpit/electrical/gpu_on",0,"sim/electrical/GPU_on","sim/electrical/GPU_off","sim/electrical/GPU_toggle")

-- APU Bus Switches
sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")

-- GEN Switches
sysElectric.gen1Switch 		= InopSwitch:new("gen1")
sysElectric.gen2Switch 		= InopSwitch:new("gen2")
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- Avionics Bus
sysElectric.avionicsBus		= InopSwitch:new("aviobus")

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