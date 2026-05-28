-- A306 airplane 
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
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("A306 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new("fuelpumpleftaft",	"A300/FUEL/outer_tank_pump1_left",	0)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","A300/FUEL/outer_tank_pump2_right",	0)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new("fuelpump3",		"A300/FUEL/outer_tank_pump2_left",	0)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new("fuelpump4",		"A300/FUEL/outer_tank_pump1_right",	0)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new("fuelpump5",		"A300/FUEL/inner_tank_pump1_left",	0)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new("fuelpump6",		"A300/FUEL/inner_tank_pump2_left",	0)
sysFuel.fuelPump7		 	= TwoStateDrefSwitch:new("fuelpump7",		"A300/FUEL/inner_tank_pump1_right",	0)
sysFuel.fuelPump8		 	= TwoStateDrefSwitch:new("fuelpump8",		"A300/FUEL/inner_tank_pump2_right",	0)
sysFuel.fuelPump9		 	= TwoStateDrefSwitch:new("fuelpumpc1",		"A300/FUEL/center_tank_pump1",		0)
sysFuel.fuelPump10		 	= TwoStateDrefSwitch:new("fuelpumpc2",		"A300/FUEL/center_tank_pump2",		0)
sysFuel.fuelPump11		 	= TwoStateDrefSwitch:new("fuelpump11",		"A300/FUEL/trim_tank_pump1",		0)
sysFuel.fuelPump12		 	= TwoStateDrefSwitch:new("fuelpump12",		"A300/FUEL/trim_tank_pump2",		0)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump9)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump10)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump11)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump12)

sysFuel.fuelCrossFeed = TwoStateDrefSwitch:new("crossfeed","A300/FUEL/xfeed_on",0)
	
return sysFuel