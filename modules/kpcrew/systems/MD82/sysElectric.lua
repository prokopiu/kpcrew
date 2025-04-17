-- MD82 airplane 
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

logMsg("MD82 sysElectric")
-- ----- Batteries
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","sim/cockpit/electrical/battery_array_on",-1,
	function ()
		command_once("sim/electrical/battery_1_on")
		if get("laminar/md82/safeguard",3) == 0 then 
			command_once("laminar/md82cmd/safeguard03")
		end
	end,
	function ()
		command_once("sim/electrical/battery_1_off")
	end,
	function ()
		command_once("sim/electrical/battery_1_toggle")
	end,
	function ()
		if get("sim/cockpit/electrical/battery_array_on",0) > 0 then
			return 1
		else
			return 0
		end
	end)
sysElectric.batteryGroup:addSwitch(batterySwitch)


-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateToggleSwitch:new("apubus1","laminar/md82/electrical/cross_tie_APU_L",0,
	"laminar/md82cmd/electrical/cross_tie_APU_L")
sysElectric.apuGenBus2 		= TwoStateToggleSwitch:new("apubus2","laminar/md82/electrical/cross_tie_APU_R",0,
	"laminar/md82cmd/electrical/cross_tie_APU_R")
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- GPU Bus Switches
sysElectric.gpuGenBus1 		= TwoStateToggleSwitch:new("gpubus1","laminar/md82/electrical/cross_tie_GPU_L",0,
	"laminar/md82cmd/electrical/cross_tie_GPU_L")
sysElectric.gpuGenBus2 		= TwoStateToggleSwitch:new("gpubus2","laminar/md82/electrical/cross_tie_GPU_R",0,
	"laminar/md82cmd/electrical/cross_tie_GPU_R")
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

sysElectric.galleyPower = TwoStateDrefSwitch:new("galleypwr","sim/cockpit2/switches/generic_lights_switch",36)

sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbySwitch","sim/cockpit2/electrical/battery_on",1)

-- Voltmeter MD82
sysElectric.voltmeterSwitch = MultiStateCmdSwitch:new("voltmeter","laminar/md82/electrical/voltmeter_source",0,
	"laminar/md82cmd/electrical/voltmeter_source_dwn","laminar/md82cmd/electrical/voltmeter_source_up",0,5,true)

-- GPU on bus annunciator
sysElectric.gpuOnBus = CustomAnnunciator:new("gpuonbus",
function () 
	if get("sim/cockpit/electrical/gpu_on") == 1 and 
		get("laminar/md82/electrical/cross_tie_GPU_L") == 1 and
		get("laminar/md82/electrical/cross_tie_GPU_R") == 1 then
		return 1
	else
		return 0
	end
end)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get("sim/cockpit/engine/APU_N1") == 100 then
			return 1
		else
			return 0
		end
	end)
	
return sysElectric