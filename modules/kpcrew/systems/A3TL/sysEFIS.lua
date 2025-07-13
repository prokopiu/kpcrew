-- ToLiss Airbusses
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

logMsg("A3TL sysEFIS")

-- MINS SET
sysEFIS.minsPilot 			= InopSwitch:new("minspilot")

-- MTRS
sysEFIS.mtrsPilot 			= TwoStateDrefSwitch:new("mtrspilot","AirbusFBW/MetricAlt",0)

-- FPV
sysEFIS.fpvPilot 			= TwoStateDrefSwitch:new("fpvpilot","AirbusFBW/HDGTRKmode",0)

-- WX 
sysEFIS.wxrPilot 			= TwoStateCustomSwitch:new("wxrpilot","AirbusFBW/WXPowerSwitch",0,
	function ()
		set("AirbusFBW/WXPowerSwitch",0)
		set("AirbusFBW/WXSwitchPWS",2)
	end,
	function ()
		set("AirbusFBW/WXPowerSwitch",1)
		set("AirbusFBW/WXSwitchPWS",0)
	end,
	function ()
	end,
	function ()
		if get("AirbusFBW/WXPowerSwitch") ~= 1 then
			return 1
		else
			return 0
		end
	end)
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")
	
return sysEFIS