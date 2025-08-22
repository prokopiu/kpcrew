-- B742 airplane 
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

logMsg("B742 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new("fuelpumpleftaft","B742/FUEL/fuel_boost_pump_sw",-1)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","B742/FUEL/fuel_boost_pump_sw",1)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new("fuelpump3","B742/FUEL/fuel_boost_pump_sw",2)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new("fuelpump4","B742/FUEL/fuel_boost_pump_sw",3)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new("fuelpump5","B742/FUEL/fuel_boost_pump_sw",4)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new("fuelpump6","B742/FUEL/fuel_boost_pump_sw",5)
sysFuel.fuelPump7		 	= TwoStateDrefSwitch:new("fuelpump7","B742/FUEL/fuel_boost_pump_sw",6)
sysFuel.fuelPump8		 	= TwoStateDrefSwitch:new("fuelpump8","B742/FUEL/fuel_boost_pump_sw",7)
sysFuel.fuelPump9		 	= TwoStateDrefSwitch:new("fuelpump9","B742/FUEL/fuel_boost_pump_sw",8)
sysFuel.fuelPump10		 	= TwoStateDrefSwitch:new("fuelpump10","B742/FUEL/fuel_boost_pump_sw",9)
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

sysFuel.fuelCrossFeed = SwitchGroup:new("crossfeedgroup")
sysFuel.fuelCrossFeed1 = TwoStateDrefSwitch:new("xfeed1","B742/FUEL/fuel_crossfeed_valve_rot",-1)
sysFuel.fuelCrossFeed2 = TwoStateDrefSwitch:new("xfeed2","B742/FUEL/fuel_crossfeed_valve_rot",1)
sysFuel.fuelCrossFeed3 = TwoStateDrefSwitch:new("xfeed3","B742/FUEL/fuel_crossfeed_valve_rot",2)
sysFuel.fuelCrossFeed4 = TwoStateDrefSwitch:new("xfeed4","B742/FUEL/fuel_crossfeed_valve_rot",3)
sysFuel.fuelCrossFeed5 = TwoStateDrefSwitch:new("xfeed5","B742/FUEL/fuel_crossfeed_valve_rot",4)
sysFuel.fuelCrossFeed6 = TwoStateDrefSwitch:new("xfeed6","B742/FUEL/fuel_crossfeed_valve_rot",5)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed1)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed2)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed3)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed4)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed5)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed6)

return sysFuel