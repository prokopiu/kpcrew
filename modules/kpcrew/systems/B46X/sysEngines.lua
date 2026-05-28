-- B462 airplane 
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

logMsg("B462 sysEngines")

-- Starter Switches
sysEngines.engStart1Switch	= TwoStateCustomSwitch:new("starter1","",0,
function () 
	kc_procvar_set("engstart1",true)
end,
function () 
	kc_procvar_set("engstart1",false)
end,
function () 
end,
function () 
	return get("thranda/TCAS/AnnLtA",74)
end)
sysEngines.engStart2Switch	= TwoStateCustomSwitch:new("starter2","",0,
function () 
	kc_procvar_set("engstart2",true)
end,
function () 
	kc_procvar_set("engstart2",false)
end,
function () 
end,
function () 
	return get("thranda/TCAS/AnnLtA",74)
end)
sysEngines.engStart3Switch	= TwoStateCustomSwitch:new("starter3","",0,
function () 
	kc_procvar_set("engstart3",true)
end,
function () 
	kc_procvar_set("engstart3",false)
end,
function () 
end,
function () 
	return get("thranda/TCAS/AnnLtA",74)
end)
sysEngines.engStart4Switch	= TwoStateCustomSwitch:new("starter4","",0,
function () 
	kc_procvar_set("engstart4",true)
end,
function () 
	kc_procvar_set("engstart4",false)
end,
function () 
end,
function () 
	return get("thranda/TCAS/AnnLtA",74)
end)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

sysEngines.throttlePos			= TwoStateDrefSwitch:new("throttlepos","sim/cockpit2/engine/actuators/throttle_ratio_all",0)

return sysEngines
