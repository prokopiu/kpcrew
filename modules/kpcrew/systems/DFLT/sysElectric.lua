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
require("kpcrew.briefings.briefings_" .. kc_acf_icao)

-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1)
sysElectric.battery2Switch 	= InopSwitch:new("battery2")
sysElectric.batteryGroup:addSwitch(batterySwitch)
if kc_get_nr_batteries() > 1 then
	sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1)
	sysElectric.batteryGroup:addSwitch(battery2Switch)
end

sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",-1)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("BATT2 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",1)
sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps","sim/cockpit2/electrical/battery_amps",-1)
sysElectric.batt2Amp 		= SimpleAnnunciator:new("BATT2 Amps","sim/cockpit2/electrical/battery_amps",1)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
if kc_has_gpu then
	sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","sim/cockpit/electrical/gpu_on",0,
	function ()
		set("sim/cockpit/electrical/gpu_on",1)
		command_once("sim/ground_ops/service_plane")
	end,
	function ()
		set("sim/cockpit/electrical/gpu_on",0)
	end,
	function ()
	end,
	function ()
		return get("sim/cockpit/electrical/gpu_on")
	end)	
	sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit2/electrical/GPU_generator_on",0)
	sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
else
	sysElectric.gpuConnect 		= InopSwitch:new("GPU")
	sysElectric.gpuGenBus1 		= InopSwitch:new("gpubus1")
	sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
end
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
if kc_has_apu then
	sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","sim/cockpit2/electrical/APU_starter_switch",0)
	sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","sim/cockpit2/electrical/APU_starter_switch",0)
	sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","sim/cockpit/electrical/generator_apu_on",0)
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
else
	sysElectric.apuMaster	 	= InopSwitch:new("apuswitch")
	sysElectric.apuStartSwitch 	= InopSwitch:new("apuswitch")
	sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")
	sysElectric.apuGenBus2 		= InopSwitch:new("apubus2")
end
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/aircraft/electrical/bus_apu_is_on") == 1 then
			return 1
		else
			return 0
		end
	end)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1",
	"sim/cockpit/electrical/generator_on",-1)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
if kc_get_nr_generators() > 1 then
	sysElectric.gen2Switch 	= TwoStateDrefSwitch:new("gen2",
		"sim/cockpit/electrical/generator_on",1)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
end
if kc_get_nr_generators() > 2 then
	sysElectric.gen3Switch 		= TwoStateDrefSwitch:new("gen3",
		"sim/cockpit/electrical/generator_on",2)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
end
if kc_get_nr_generators() > 3 then
	sysElectric.gen4Switch 		= TwoStateDrefSwitch:new("gen4",
		"sim/cockpit/electrical/generator_on",3)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)
end

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie","sim/cockpit2/electrical/cross_tie",0)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1","sim/cockpit/electrical/generator_on",-1,
	"sim/electrical/generator_1_on","sim/electrical/generator_1_off","sim/electrical/generator_1_toggle")
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2","sim/cockpit/electrical/generator_on",1,
	"sim/electrical/generator_2_on","sim/electrical/generator_2_off","sim/electrical/generator_2_toggle")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateDrefSwitch:new("inverter1","sim/cockpit/engine/inverter_on",-1)
sysElectric.inverter2Switch 		= TwoStateDrefSwitch:new("inverter2","sim/cockpit/engine/inverter_on",1)
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1",
"sim/cockpit2/switches/avionics_power_on",0)
sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- standby power
sysElectric.stbyPowerSwitch = InopSwitch:new("stbySwitch")

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","sim/cockpit/electrical/gpu_on",0)

return sysElectric