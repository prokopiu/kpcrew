-- E55P airplane 
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

logMsg("E55P sysElectric")

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","aerobask/electrical/gpu_avail",0,
function ()
	if get("aerobask/hide_gpu") == 1 then
		set_array("sim/cockpit2/switches/custom_slider_on",4,1)
		command_once("aerobask/electrical/gpu_connect_disconnect")
	end
end,
function ()
	if get("aerobask/hide_gpu") == 0 then
		command_once("aerobask/electrical/gpu_connect_disconnect")
		set_array("sim/cockpit2/switches/custom_slider_on",4,0)
	end
end,
function ()
	command_once("aerobask/electrical/gpu_connect_disconnect")
end,
function ()
	return 1-get("aerobask/hide_gpu")
end)
sysElectric.gpuGenBus1 		= TwoStateCustomSwitch:new("gpubus1","aerobask/electrical/gpu_inuse",0,
function ()
	if get("aerobask/electrical/gpu_inuse") == 0 then
		command_once("aerobask/electrical/gpu")
	end
end,
function ()
	if get("aerobask/electrical/gpu_inuse") > 0 then
		command_once("aerobask/electrical/gpu")
	end
end,
function ()
	command_once("aerobask/electrical/gpu")
end,
function ()
	return get("aerobask/electrical/gpu_inuse")
end)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCmdSwitch:new("gen1","aerobask/electrical/sw_gen1",0,
	"aerobask/electrical/gen1_auto","aerobask/electrical/gen1_off","nocommand")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 	= TwoStateCmdSwitch:new("gen2","aerobask/electrical/sw_gen2",0,
	"aerobask/electrical/gen2_auto","aerobask/electrical/gen2_off","nocommand")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- DC Bus tie
sysElectric.dcBusTie		= TwoStateCustomSwitch:new("dcbustie","aerobask/electrical/knob_bus_tie",0,
function () 
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_rt")
end,
function () 
	command_once("aerobask/electrical/bus_tie_lt")
	command_once("aerobask/electrical/bus_tie_lt")
end,
function () 
	command_once("aerobask/electrical/bus_tie_rt")
	command_once("aerobask/electrical/bus_tie_rt")
end,
function () 
	if get("aerobask/electrical/knob_bus_tie") == 1 then 
		return 1
	else
		return 0
	end
end)	

sysElectric.gpuOnBus = SimpleAnnunciator:new("","aerobask/electrical/gpu_inuse",0)

return sysElectric
