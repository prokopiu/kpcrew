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
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpmp1","AirbusFBW/FuelOHPArray",-1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new ("fuelpmp2","AirbusFBW/FuelOHPArray",1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new ("fuelpmp3","AirbusFBW/FuelOHPArray",2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new ("fuelpmp4","AirbusFBW/FuelOHPArray",3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new ("fuelpmp5","AirbusFBW/FuelOHPArray",4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new ("fuelpmp6","AirbusFBW/FuelOHPArray",5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)
if PLANE_ICAO == "A339" then
	sysFuel.fuelPump7		 	= TwoStateDrefSwitch:new ("fuelpmp7","AirbusFBW/FuelOHPArray",8)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
	sysFuel.fuelPump8		 	= TwoStateDrefSwitch:new ("fuelpmp8","AirbusFBW/FuelOHPArray",9)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)
end

sysFuel.crossFeed = TwoStateDrefSwitch:new("crossfeed","AirbusFBW/FuelOHPArray",7)

return sysFuel