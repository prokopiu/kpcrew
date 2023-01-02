-- C750  airplane 
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
sysElectric.batterySwitch 	= TwoStateToggleSwitch:new("battery1","laminar/CitX/electrical/battery_left",0,
	"laminar/CitX/electrical/cmd_battery_left_toggle")
sysElectric.battery2Switch 	= TwoStateToggleSwitch:new("battery2","laminar/CitX/electrical/battery_right",0,
	"laminar/CitX/electrical/cmd_battery_right_toggle")

-- ** HARDWARE BATTERY Switch
sysElectric.battery1HwSwitch 	= TwoStateCmdSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1,
	"sim/electrical/battery_1_on","sim/electrical/battery_1_off","sim/electrical/battery_1_toggle")
sysElectric.battery2HwSwitch 	= TwoStateCmdSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1,
	"sim/electrical/battery_2_on","sim/electrical/battery_2_off","sim/electrical/battery_2_toggle")
sysElectric.batteryHwGroup 	= SwitchGroup:new("battery hardware")
sysElectric.batteryHwGroup:addSwitch(battery1HwSwitch)
sysElectric.batteryHwGroup:addSwitch(battery2HwSwitch)

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateToggleSwitch:new("GPU","laminar/CitX/electrical/ext_pwr",0,
	"laminar/CitX/electrical/cmd_ext_pwr_toggle")

-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateCmdSwitch:new("apubus1","laminar/CitX/APU/gen_switch",0,
	"laminar/CitX/APU/gen_switch_up","laminar/CitX/APU/gen_switch_dwn","nocommand")

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateCmdSwitch:new("gen1","laminar/CitX/electrical/generator_left",0,
	"laminar/CitX/electrical/cmd_generator_left_up","laminar/CitX/electrical/cmd_generator_left_dwn","nocommand")
sysElectric.gen2Switch 		= TwoStateCmdSwitch:new("gen2","laminar/CitX/electrical/generator_right",1,
	"laminar/CitX/electrical/cmd_generator_right_up","laminar/CitX/electrical/cmd_generator_right_dwn","nocommand")
-- sysElectric.gen3Switch 		= InopSwitch:new("gen3")
-- sysElectric.gen4Switch 		= InopSwitch:new("gen4")
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
-- sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
-- sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1","laminar/CitX/electrical/generator_left",0,
	"laminar/CitX/electrical/cmd_generator_left_up","laminar/CitX/electrical/cmd_generator_left_dwn","nocommand")
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2","laminar/CitX/electrical/generator_right",1,
	"laminar/CitX/electrical/cmd_generator_right_up","laminar/CitX/electrical/cmd_generator_right_dwn","nocommand")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateToggleSwitch:new("aviobus1","laminar/CitX/electrical/avionics",0,
	"laminar/CitX/electrical/cmd_avionics_toggle")
-- sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
-- sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- APU Starter
sysElectric.apuStartSwitch 	= TwoStateCmdSwitch:new("apu","laminar/CitX/APU/starter_switch",0,
	"laminar/CitX/APU/starter_switch_up","laminar/CitX/APU/starter_switch_dwn","nocommand")

sysElectric.apuMasterSwitch	= TwoStateToggleSwitch:new("apumaster","laminar/CitX/APU/master_switch",0,
	"laminar/CitX/APU/master_switch_toggle")
	
--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
function ()
	if get("laminar/CitX/APU/annunc_ready_load") > 0 then
		return 1
	else
		return 0
	end
end)

sysElectric.apuGenBusOff = SimpleAnnunciator:new("","laminar/CitX/APU/gen_switch",0)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","laminar/CitX/electrical/ext_pwr",0)

return sysElectric