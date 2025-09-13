-- B748 airplane 
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

logMsg("B748 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","ssg/Elec/bat1_sw",0,
	function () 
		set("ssg/Elec/bat1_sw",1)
		set("ssg/Elec/cover_bat",0)
	end,
	function () 
		set("ssg/Elec/bat1_sw",0)
		set("ssg/Elec/cover_bat",1)
	end,
	function ()
		if get("ssg/Elec/bat1_sw") == 0 then
			set("ssg/Elec/bat1_sw",1)
			set("ssg/Elec/cover_bat",0)
		else
			set("ssg/Elec/bat1_sw",0)
			set("ssg/Elec/cover_bat",1)
		end
	end,
	function () 
		return get("ssg/Elec/bat1_sw")
	end)
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

-- standby power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbySwitch","ssg/Elec/bat2_sw",0)

-- DC Bus Tie
sysElectric.dcBusTie		= SwitchGroup:new("Bus Tie")
sysElectric.dcBusTie1		= TwoStateDrefSwitch:new("dcbustie1","ssg/Elec/bustie1_sw",0)
sysElectric.dcBusTie2		= TwoStateDrefSwitch:new("dcbustie2","ssg/Elec/bustie2_sw",0)
sysElectric.dcBusTie3		= TwoStateDrefSwitch:new("dcbustie3","ssg/Elec/bustie3_sw",0)
sysElectric.dcBusTie4		= TwoStateDrefSwitch:new("dcbustie4","ssg/Elec/bustie4_sw",0)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie1)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie2)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie3)
sysElectric.dcBusTie:addSwitch(sysElectric.dcBusTie4)

-- AC Bus Tie = Utility Bus
sysElectric.acBusTie		= SwitchGroup:new("Utility Bus")
sysElectric.acBusTie1		= TwoStateDrefSwitch:new("acbustie1","ssg/Elec/batut1_sw",0)
sysElectric.acBusTie2		= TwoStateDrefSwitch:new("acbustie2","ssg/Elec/batut2_sw",0)
sysElectric.acBusTie:addSwitch(sysElectric.acBusTie1)
sysElectric.acBusTie:addSwitch(sysElectric.acBusTie2)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1","ssg/Elec/gen1_sw",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 		= TwoStateDrefSwitch:new("gen2","ssg/Elec/gen2_sw",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.gen3Switch 		= TwoStateDrefSwitch:new("gen3","ssg/Elec/gen3_sw",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.gen4Switch 		= TwoStateDrefSwitch:new("gen4","ssg/Elec/gen4_sw",0)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","ssg/FB/gpu_connect",0)	
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","ssg/Elec/GPU1_on",0)
sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus1","ssg/Elec/GPU2_on",0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")

sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","ssg/Elec/APU1_sw",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","ssg/Elec/APU1_sw",0)
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","ssg/Elec/apugen1_sw",0)
sysElectric.apuGenBus2 		= TwoStateDrefSwitch:new("apubus2","ssg/Elec/apugen2_sw",0)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

return sysElectric
