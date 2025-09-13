-- B748 airplane 
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

logMsg("B748 sysEngines")

-- ignition
sysEngines.engStart1Switch	= TwoStateDrefSwitch:new("ignition1","ssg/ENG/eng1_st_sw",0)
sysEngines.engStart2Switch	= TwoStateDrefSwitch:new("ignition2","ssg/ENG/eng2_st_sw",0)
sysEngines.engStart3Switch	= TwoStateDrefSwitch:new("ignition3","ssg/ENG/eng3_st_sw",0)
sysEngines.engStart4Switch	= TwoStateDrefSwitch:new("ignition4","ssg/ENG/eng4_st_sw",0)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)


return sysEngines
