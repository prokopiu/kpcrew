-- C750 airplane 
-- Fuel related functionality

-- @classmod sysFuel
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
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

-- Check if fuel is inbalanced
function sysFuel.fuel_balanced()
	local tank1 = get("sim/cockpit2/fuel/fuel_quantity",1) 
	local tank2 = get("sim/cockpit2/fuel/fuel_quantity",2) 
	return math.abs(tank1-tank2) < 100
end
	
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

sysFuel.crossFeed = MultiStateCmdSwitch:new("crossfeed","laminar/CitX/fuel/crossfeed",0,
	"laminar/CitX/oxygen/cmd_pass_oxy_dwn","laminar/CitX/oxygen/cmd_pass_oxy_up",-1,1,false)

return sysFuel