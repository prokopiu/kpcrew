-- SF50 airplane 
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

logMsg("SF50 sysEngines")

-- ignition
sysEngines.engIgnition1	= TwoStateCmdSwitch:new("ignition1","laminar/SF50/ignition_position",0,
	"laminar/SF50/ignition_up","laminar/SF50/ignition_down","nocommand")
sysEngines.engIgnitionGroup 	= SwitchGroup:new("ignitions")
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)


-- laminar/SF50/eng_start_stop_toggle

return sysEngines



