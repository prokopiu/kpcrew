-- C750  airplane 
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

logMsg("C750 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateToggleSwitch:new("battery1","laminar/CitX/electrical/battery_left",0,
	"laminar/CitX/electrical/cmd_battery_left_toggle")
sysElectric.batteryGroup:addSwitch(batterySwitch)
sysElectric.battery2Switch 	= TwoStateToggleSwitch:new("battery2","laminar/CitX/electrical/battery_right",0,
	"laminar/CitX/electrical/cmd_battery_right_toggle")
sysElectric.batteryGroup:addSwitch(battery2Switch)

-- ----- GPU
	
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
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
sysElectric.gpuGenBus1 		= TwoStateToggleSwitch:new("gpubus1","laminar/CitX/electrical/ext_pwr",0,
"laminar/CitX/electrical/cmd_ext_pwr_toggle")
sysElectric.gpuGenBus2 		= InopSwitch:new("gpubus2")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.gpuOnBus = SimpleAnnunciator:new("","laminar/CitX/electrical/ext_pwr",0)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")

sysElectric.apuMaster	 	= TwoStateToggleSwitch:new("apumaster","laminar/CitX/APU/master_switch",0,
	"laminar/CitX/APU/master_switch_toggle")
sysElectric.apuStartSwitch 	= TwoStateCmdSwitch:new("apu","laminar/CitX/APU/starter_switch",0,
	"laminar/CitX/APU/starter_switch_up","laminar/CitX/APU/starter_switch_dwn","nocommand")
sysElectric.apuGenBus1 		= TwoStateCmdSwitch:new("apubus1","laminar/CitX/APU/gen_switch",0,
	"laminar/CitX/APU/gen_switch_up","laminar/CitX/APU/gen_switch_dwn","nocommand")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
function ()
	if get("laminar/CitX/APU/annunc_ready_load") > 0 then
		return 1
	else
		return 0
	end
end)

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateCmdSwitch:new("gen1","laminar/CitX/electrical/generator_left",0,
	"laminar/CitX/electrical/cmd_generator_left_up","laminar/CitX/electrical/cmd_generator_left_dwn","nocommand")
sysElectric.gen2Switch 		= TwoStateCmdSwitch:new("gen2","laminar/CitX/electrical/generator_right",1,
	"laminar/CitX/electrical/cmd_generator_right_up","laminar/CitX/electrical/cmd_generator_right_dwn","nocommand")
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1","laminar/CitX/electrical/generator_left",0,
	"laminar/CitX/electrical/cmd_generator_left_up","laminar/CitX/electrical/cmd_generator_left_dwn","nocommand")
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2","laminar/CitX/electrical/generator_right",1,
	"laminar/CitX/electrical/cmd_generator_right_up","laminar/CitX/electrical/cmd_generator_right_dwn","nocommand")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- DC Bus Tie
sysElectric.dcBusTie				= TwoStateDrefSwitch:new("dcbustie","sim/cockpit2/electrical/cross_tie",0)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateToggleSwitch:new("aviobus1","laminar/CitX/electrical/avionics",0,
	"laminar/CitX/electrical/cmd_avionics_toggle")
sysElectric.avionicsSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)

-- standby power
sysElectric.stbyPowerSwitch = TwoStateCustomSwitch:new("stbySwitch","laminar/CitX/electrical/battery_stby_pwr",0,
	function ()
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
	end,
	function ()
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_once("laminar/CitX/electrical/cmd_stby_pwr_up")
		command_end("laminar/CitX/electrical/cmd_stby_pwr_dwn")
	end,
	function ()
	end,
	function ()
		return get("laminar/CitX/electrical/battery_stby_pwr")
	end)

-- sysElectric.apuGenBusOff = SimpleAnnunciator:new("","laminar/CitX/APU/gen_switch",0)

return sysElectric