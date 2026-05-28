-- ADC3 airplane 
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

logMsg("ADC3 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","awx/c47/cockpit/power_sw",0,
	function ()
		if get("awx/c47/cockpit/power_sw") == 1 then
			command_once("awx/c47/powersw_dwn")
		end
	end,
	function ()
		if get("awx/c47/cockpit/power_sw") == 0 then
			command_once("awx/c47/powersw_up")
		end
	end,
	function ()
	end,
	function ()
		if get("awx/c47/cockpit/power_sw") == 0 or get("awx/c47/cockpit/power_sw") == 2 then
			return 1
		else
			return 0
		end
	end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU

sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","awx/c47/cockpit/power_sw",0,
function ()
	command_once("awx/c47/powersw_up")
	command_once("awx/c47/powersw_up")
end,
function ()
	command_once("awx/c47/powersw_dwn")
	command_once("awx/c47/powersw_dwn")
	set("sim/cockpit/electrical/gpu_on",0)
end,
function ()
end,
function ()
	return get("sim/cockpit/electrical/gpu_on")
end)	
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1","sim/cockpit2/electrical/GPU_generator_on",0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)

return sysElectric
