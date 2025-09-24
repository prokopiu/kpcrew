-- A306 airplane 
-- EFIS functionality

-- @classmod sysEFIS
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

sysEFIS = require("kpcrew.systems.DFLT.sysEFIS")

logMsg("A306 sysEFIS")

-- WX 
sysEFIS.wxrPilot 			= TwoStateDrefSwitch:new("wxrpilot","A300/WXR/system",0,
	"sim/instruments/EFIS_wxr")
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")
	
return sysEFIS