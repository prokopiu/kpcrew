-- A306 airplane 
-- Engine related functionality

-- @classmod sysEngines
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

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("A306 sysEngines")

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateCustomSwitch:new("starter1","A300/engine/starter1",0,
function () 
	kc_procvar_set("engstart1",true)
end,
function () 
	kc_procvar_set("engstart1",false)
end,
function () 
end,
function () 
	return get("A300/engine/starter1",0)
end)
sysEngines.engStart2Switch	= TwoStateCustomSwitch:new("starter2","A300/engine/starter2",0,
function () 
	kc_procvar_set("engstart2",true)
end,
function () 
	kc_procvar_set("engstart2",false)
end,
function () 
end,
function () 
	return get("A300/engine/starter2",1)
end)

sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)

-- ignition
sysEngines.engIgnition1	= TwoStateCustomSwitch:new("ignition1","A300/engine_ignition_switch",0,
	function ()
		set("A300/engine_ignition_switch",0)
	end,
	function ()
		set("A300/engine_ignition_switch",3)
	end,
	function ()
	end,
	function ()
		if get("A300/engine_ignition_switch") == 3 then
			return 0
		else
			return 1
		end
	end)
sysEngines.engIgnitionGroup 	= SwitchGroup:new("ignitions")
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)

return sysEngines
