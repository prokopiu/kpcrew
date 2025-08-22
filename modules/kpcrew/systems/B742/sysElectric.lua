-- B742 airplane 
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

logMsg("B742 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","B742/ELEC/battery_sw",0,
	function ()
		set("B742/ELEC/battery_sw",1)
		set("B742/ELEC/battery_cap",0)
	end,
	function ()
		set("B742/ELEC/battery_sw",0)
		set("B742/ELEC/battery_cap",1)
	end,
	function ()
		if get("B742/ELEC/battery_sw") == 0 then
			set("B742/ELEC/battery_sw",1)
			set("B742/ELEC/battery_cap",0)
		else
			set("B742/ELEC/battery_sw",0)
			set("B742/ELEC/battery_cap",1)
		end
	end,
	function ()
		return get("B742/ELEC/battery_sw")
	end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage","sim/cockpit2/electrical/battery_voltage_actual_volts",-1)
sysElectric.batt2Volt 		= InopSwitch:new("BATT2 Voltage")
sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps","sim/cockpit2/electrical/battery_amps",-1)
sysElectric.batt2Amp 		= InopSwitch:new("BATT2 Amps")

-- standby power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbySwitch","B742/ELEC/standby_power_sw",0)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1","B742/ELEC/bus_gen_close_sw",-1,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",0,1)
	end,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",0,-1)
	end,
	function ()
	end,
	function ()
		if get("B742/ELEC/bus_gen_close_sw",0) == 1 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 		= TwoStateCustomSwitch:new("gen2","B742/ELEC/bus_gen_close_sw",1,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",1,1)
	end,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",1,-1)
	end,
	function ()
	end,
	function ()
		if get("B742/ELEC/bus_gen_close_sw",1) == 1 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.gen3Switch 		= TwoStateCustomSwitch:new("gen3","B742/ELEC/bus_gen_close_sw",2,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",2,1)
	end,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",2,-1)
	end,
	function ()
	end,
	function ()
		if get("B742/ELEC/bus_gen_close_sw",2) == 1 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.gen4Switch 		= TwoStateCustomSwitch:new("gen4","B742/ELEC/bus_gen_close_sw",3,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",3,1)
	end,
	function ()
		set_array("B742/ELEC/bus_gen_close_sw",3,-1)
	end,
	function ()
	end,
	function ()
		if get("B742/ELEC/bus_gen_close_sw",3) == 1 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","B742/GHD/GPU",0,
	function ()
	end,
	function ()
	end,
	function ()
	end,
	function ()
		if get("B742/GHD/GPU") == 0 then
			return 1
		else
			return 0
		end
	end)	
	
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","B742/AUX_PWR/EXT_PWR_1_sw",0)
sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus2","B742/AUX_PWR/EXT_PWR_2_sw",0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = CustomAnnunciator:new("GPUOnBus",
	function () 
		if get("B742/FE_lamps/AUX_power_on_bus_1") > 0 or get("B742/FE_lamps/AUX_power_on_bus_2") > 0 then
			return 1
		else
			return 0
		end
	end)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")

sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch","B742/APU/APU_start_sw",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch","B742/APU/APU_start_sw",0)
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","B742/AUX_PWR/APU_GEN1_close_sw",0)
sysElectric.apuGenBus2 		= TwoStateDrefSwitch:new("apubus2","B742/AUX_PWR/APU_GEN2_close_sw",0)
sysElectric.apuGenBus3 		= TwoStateDrefSwitch:new("apubus1","B742/AUX_PWR/APU_GEN1_trip_sw",0)
sysElectric.apuGenBus4 		= TwoStateDrefSwitch:new("apubus2","B742/AUX_PWR/APU_GEN2_trip_sw",0)

sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus3)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus4)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)


-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/cockpit/engine/APU_N1") > 98 then
			return 1
		else
			return 0
		end
	end)
	
return sysElectric
