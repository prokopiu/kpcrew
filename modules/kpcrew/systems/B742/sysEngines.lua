-- B742 airplane 
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

logMsg("B742 sysEngines")

-- ignition
sysEngines.engStart1Switch	= TwoStateDrefSwitch:new("ignition1","B742/OVHD/engine_ignition_sys_1",-1)
sysEngines.engStart2Switch	= TwoStateDrefSwitch:new("ignition2","B742/OVHD/engine_ignition_sys_1",1)
sysEngines.engStart3Switch	= TwoStateDrefSwitch:new("ignition3","B742/OVHD/engine_ignition_sys_1",2)
sysEngines.engStart4Switch	= TwoStateDrefSwitch:new("ignition4","B742/OVHD/engine_ignition_sys_1",3)
sysEngines.engStart5Switch	= TwoStateDrefSwitch:new("ignition1","B742/OVHD/engine_ignition_sys_2",-1)
sysEngines.engStart6Switch	= TwoStateDrefSwitch:new("ignition2","B742/OVHD/engine_ignition_sys_2",1)
sysEngines.engStart7Switch	= TwoStateDrefSwitch:new("ignition3","B742/OVHD/engine_ignition_sys_2",2)
sysEngines.engStart8Switch	= TwoStateDrefSwitch:new("ignition4","B742/OVHD/engine_ignition_sys_2",3)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart5Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart6Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart7Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart8Switch)

return sysEngines
