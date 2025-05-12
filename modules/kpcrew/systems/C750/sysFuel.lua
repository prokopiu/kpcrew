-- C750 airplane 
-- Fuel related functionality

-- @classmod sysFuel
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

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("C750 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCustomSwitch:new ("fuelpumpleftaft","laminar/CitX/fuel/boost_left",0,
	function () 
		command_once("laminar/CitX/fuel/cmd_boost_left_up")
		command_once("laminar/CitX/fuel/cmd_boost_left_up")
	end,
	function () 
		if get("laminar/CitX/fuel/boost_left") > 0 then 
			command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		elseif get("laminar/CitX/fuel/boost_left") < 0 then 
			command_once("laminar/CitX/fuel/cmd_boost_left_up")
		end
	end,
	function () 
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_left_dwn")
	end	
)
sysFuel.fuelPumpRightAft 	= TwoStateCustomSwitch:new("fuelpumprightaft","laminar/CitX/fuel/boost_right",0,
	function () 
		command_once("laminar/CitX/fuel/cmd_boost_right_up")
		command_once("laminar/CitX/fuel/cmd_boost_right_up")
	end,
	function () 
		if get("laminar/CitX/fuel/boost_right") > 0 then 
			command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
		elseif get("laminar/CitX/fuel/boost_right") < 0 then 
			command_once("laminar/CitX/fuel/cmd_boost_right_up")
		end
	end,
	function () 
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
		command_once("laminar/CitX/fuel/cmd_boost_right_dwn")
	end	
)
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)

sysFuel.crossFeed 	= TwoStateCustomSwitch:new("crossfeed","laminar/CitX/fuel/crossfeed",0,
	function () 
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_right")
		command_once("laminar/CitX/fuel/cmd_crossfeed_right")
	end,
	function () 
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_left")
		command_once("laminar/CitX/fuel/cmd_crossfeed_right")
		command_once("laminar/CitX/fuel/cmd_crossfeed_right")
	end,
	function () 
	end
)

return sysFuel