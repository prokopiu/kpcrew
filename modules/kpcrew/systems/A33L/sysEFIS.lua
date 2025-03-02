-- Laminar A330 variants airplane 
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

logMsg("A33L sysEFIS")

-- WX 
sysEFIS.wxrPilot 			= TwoStateCustomSwitch:new("wxrpilot","laminar/A333/switches/weather_radar_pos",0,
	function ()
		command_once("laminar/A333/switches/weather_radar_left")
		command_once("laminar/A333/switches/weather_radar_left")
	end,
	function ()
		command_once("laminar/A333/switches/weather_radar_left")
		command_once("laminar/A333/switches/weather_radar_left")
		command_once("laminar/A333/switches/weather_radar_right")
	end,
	function ()
	end,
	function ()
		if get("laminar/A333/switches/weather_radar_pos") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysEFIS.wxrCopilot 			= InopSwitch:new("wxrcopilot")

return sysEFIS