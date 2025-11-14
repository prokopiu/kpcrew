-- ToLiss Airbusses 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysFuel.fuelPump1
-- sysFuel.fuelPump2
-- sysFuel.fuelPump3
-- sysFuel.fuelPump4
-- sysFuel.allFuelPumpGroup
-- sysFuel.fuelCrossFeed

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
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPump1 			= TwoStateDrefSwitch:new ("fuelpmp1","AirbusFBW/FuelOHPArray",-1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump1)
sysFuel.fuelPump2 			= TwoStateDrefSwitch:new ("fuelpmp2","AirbusFBW/FuelOHPArray",1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new ("fuelpmp3","AirbusFBW/FuelOHPArray",2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new ("fuelpmp4","AirbusFBW/FuelOHPArray",3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new ("fuelpmp5","AirbusFBW/FuelOHPArray",4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new ("fuelpmp6","AirbusFBW/FuelOHPArray",5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

if PLANE_ICAO == "A339" or PLANE_ICAO == "A346" then
	sysFuel.fuelPump7		= TwoStateDrefSwitch:new ("fuelpmp7","AirbusFBW/FuelOHPArray",8)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
	sysFuel.fuelPump8		= TwoStateDrefSwitch:new ("fuelpmp8","AirbusFBW/FuelOHPArray",9)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)
end

if PLANE_ICAO == "A346" then
	sysFuel.fuelPump9		= TwoStateDrefSwitch:new ("fuelpmp9","AirbusFBW/FuelOHPArray",10)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump9)
	sysFuel.fuelPump10		= TwoStateDrefSwitch:new ("fuelpmp10","AirbusFBW/FuelOHPArray",11)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump10)
	sysFuel.fuelPump11		= TwoStateDrefSwitch:new ("fuelpmp11","AirbusFBW/FuelOHPArray",17)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump11)
	sysFuel.fuelPump12		= TwoStateDrefSwitch:new ("fuelpmp12","AirbusFBW/FuelOHPArray",18)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump12)
	sysFuel.fuelPump13		= TwoStateDrefSwitch:new ("fuelpmp13","AirbusFBW/FuelOHPArray",19)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump13)
	sysFuel.fuelPump14		= TwoStateDrefSwitch:new ("fuelpmp14","AirbusFBW/FuelOHPArray",20)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump14)
	sysFuel.fuelPump15		= TwoStateDrefSwitch:new ("fuelpmp15","AirbusFBW/FuelOHPArray",21)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump15)
	sysFuel.fuelPump16		= TwoStateDrefSwitch:new ("fuelpmp16","AirbusFBW/FuelOHPArray",23)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump16)
	sysFuel.fuelPump17		= TwoStateDrefSwitch:new ("fuelpmp17","AirbusFBW/FuelOHPArray",15)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump17)
	sysFuel.fuelPump18		= TwoStateDrefSwitch:new ("fuelpmp18","AirbusFBW/FuelOHPArray",16)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump18)	
end

sysFuel.crossFeed 			= TwoStateDrefSwitch:new("crossfeed","AirbusFBW/FuelOHPArray",7)

return sysFuel