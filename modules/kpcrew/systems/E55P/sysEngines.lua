-- E55P airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("E55P sysEngines")


-- ignition
sysEngines.engIgnition1	= TwoStateCustomSwitch:new("ignition1","aerobask/engines/sw_ignition_1",0,
function () 
	if get("aerobask/engines/sw_ignition_1") == 0 then
		command_once("aerobask/engines/ignition_1_up")
	end
end,
function () 
		command_once("aerobask/engines/ignition_1_dn")
		command_once("aerobask/engines/ignition_1_dn")
end,
function () 
end,
function () 
	if get("aerobask/engines/sw_ignition_1",0) > 0 then
		return 1
	else
		return 0
	end
end)
sysEngines.engIgnition2	= TwoStateCustomSwitch:new("ignition2","aerobask/engines/sw_ignition_2",0,
function () 
	if get("aerobask/engines/sw_ignition_2") == 0 then
		command_once("aerobask/engines/ignition_2_up")
	end
end,
function () 
		command_once("aerobask/engines/ignition_2_dn")
		command_once("aerobask/engines/ignition_2_dn")
end,
function () 
end,
function () 
	if get("aerobask/engines/sw_ignition_2",0) > 0 then
		return 1
	else
		return 0
	end
end)
sysEngines.engIgnitionGroup 	= SwitchGroup:new("ignitions")
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition2)

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateCustomSwitch:new("starter1","aerobask/engines/knob_start_stop_1",0,
function () 
	kc_procvar_set("engstart1",true)
end,
function () 
	kc_procvar_set("engstart1",false)
end,
function () 
end,
function () 
	return get("aerobask/engines/knob_start_stop_1",0)
end)
sysEngines.engStart2Switch	= TwoStateCustomSwitch:new("starter2","aerobask/engines/knob_start_stop_2",0,
function () 
	kc_procvar_set("engstart2",true)
end,
function () 
	kc_procvar_set("engstart2",false)
end,
function () 
end,
function () 
	return get("aerobask/engines/knob_start_stop_2",0)
end)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)


return sysEngines
