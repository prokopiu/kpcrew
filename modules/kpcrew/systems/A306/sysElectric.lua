-- A306 airplane 
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

logMsg("A306 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1)
sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2","sim/cockpit/electrical/battery_array_on",1)
sysElectric.battery3Switch 	= TwoStateDrefSwitch:new("battery3","sim/cockpit/electrical/battery_array_on",2)
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.batteryGroup:addSwitch(battery2Switch)
sysElectric.batteryGroup:addSwitch(battery3Switch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateDrefSwitch:new("GPU","A300/GND/gpu_enabled",0)	
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit/electrical/gpu_on",0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuMaster	 	= TwoStateToggleSwitch:new("apuswitch","A300/APU/master_switch_button",0,
	"A300/apu_msw_switch")
sysElectric.apuStartSwitch 	= TwoStateToggleSwitch:new("apuswitch","A300/APU/start_button",0,
	"A300/apu_start_button")
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","sim/cockpit/electrical/generator_apu_on",0)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/cockpit/engine/APU_N1") > 98 then
			return 1
		else
			return 0
		end
	end)
	
-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateToggleSwitch:new("gen1","A300/elec/engine_gen_on",-1,
	"A300/eng1_gen_toggle")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 	= TwoStateToggleSwitch:new("gen2","A300/elec/engine_gen_on",1,
	"A300/eng2_gen_toggle")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)


return sysElectric
