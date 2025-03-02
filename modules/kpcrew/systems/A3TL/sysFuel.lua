-- ToLiss Airbusses 
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

logMsg("A3TL sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpmp1","AirbusFBW/FuelOHPArray",-1)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new ("fuelpmp2","AirbusFBW/FuelOHPArray",1)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new ("fuelpmp3","AirbusFBW/FuelOHPArray",2)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new ("fuelpmp4","AirbusFBW/FuelOHPArray",3)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new ("fuelpmp5","AirbusFBW/FuelOHPArray",4)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new ("fuelpmp6","AirbusFBW/FuelOHPArray",5)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

sysFuel.crossFeed = TwoStateDrefSwitch:new("crossfeed","AirbusFBW/FuelOHPArray",7)

return sysFuel