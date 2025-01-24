-- DFLT  airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

logMsg("DFLT sysElectric")

--------- Batteries

-- ** BATTERY Switches
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1)
sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1)
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryGroup:addSwitch(battery2Switch)

-- ** HARDWARE BATTERY Switch
sysElectric.battery1HwSwitch 	= TwoStateDrefSwitch:new("hwbattery1","sim/cockpit2/electrical/battery_on",-1)
sysElectric.battery2HwSwitch 	= TwoStateDrefSwitch:new("hwbattery2","sim/cockpit2/electrical/battery_on",1)
sysElectric.batteryHwGroup 	= SwitchGroup:new("battery hardware")
sysElectric.batteryHwGroup:addSwitch(battery1HwSwitch)
sysElectric.batteryHwGroup:addSwitch(battery2HwSwitch)

sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",-1)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("BATT2 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",1)

sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps","sim/cockpit2/electrical/battery_amps",-1)
sysElectric.batt2Amp 		= SimpleAnnunciator:new("BATT2 Amps","sim/cockpit2/electrical/battery_amps",1)

-- Ground Power
if PLANE_ICAO == "E190" or PLANE_ICAO == "E170" then
	sysElectric.gpuSwitch 		= TwoStateDrefSwitch:new("GPU",
		"xcraft/electric/GPU_sw",0)
else
	sysElectric.gpuSwitch 		= TwoStateDrefSwitch:new("GPU",
		"sim/cockpit/electrical/gpu_on",0)
end

sysElectric.apuStartSwitch 		= TwoStateDrefSwitch:new("apuswitch",
	"sim/cockpit/engine/APU_switch",0)

-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","sim/cockpit/electrical/generator_apu_on",0)
sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- GPU Bus Switches
sysElectric.gpuGenBus1 		= InopSwitch:new("gpubus1")
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1",
	"sim/cockpit/electrical/generator_on",-1)
sysElectric.gen2Switch 		= TwoStateDrefSwitch:new("gen2",
	"sim/cockpit/electrical/generator_on",1)
sysElectric.gen3Switch 		= TwoStateDrefSwitch:new("gen3",
	"sim/cockpit/electrical/generator_on",2)
sysElectric.gen4Switch 		= TwoStateDrefSwitch:new("gen4",
	"sim/cockpit/electrical/generator_on",3)
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1","sim/cockpit/electrical/generator_on",-1,
	"sim/electrical/generator_1_on","sim/electrical/generator_1_off","sim/electrical/generator_1_toggle")
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2","sim/cockpit/electrical/generator_on",1,
	"sim/electrical/generator_2_on","sim/electrical/generator_2_off","sim/electrical/generator_2_toggle")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1","sim/cockpit2/switches/avionics_power_on",0)
sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
-- sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

sysElectric.apuGenBusOff = SimpleAnnunciator:new("","sim/cockpit/electrical/generator_apu_on",0)
sysElectric.gpuOnBus = SimpleAnnunciator:new("","sim/cockpit/electrical/gpu_on",0)

-- Electric bus values


return sysElectric