-- DFLT airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysFuel = {
}

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

---------- Switches

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCmdSwitch:new ("fuelpumpleftaft","sim/cockpit/engine/fuel_pump_on",-1,
	"sim/fuel/fuel_pump_1_on","sim/fuel/fuel_pump_1_off","sim/fuel/fuel_pump_1_tog")
sysFuel.fuelPumpRightAft 	= TwoStateCmdSwitch:new("fuelpumprightaft","sim/cockpit/engine/fuel_pump_on",1,
	"sim/fuel/fuel_pump_2_on","sim/fuel/fuel_pump_2_off","sim/fuel/fuel_pump_2_tog")
sysFuel.fuelPumpCtrLeft 	= InopSwitch:new ("fuelpumpctrleft","sim/cockpit/engine/fuel_pump_on",2,
	"sim/fuel/fuel_pump_3_on","sim/fuel/fuel_pump_3_off","sim/fuel/fuel_pump_3_tog")
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)

sysFuel.crossFeed = TwoStateCmdSwitch:new("crossfeed","sim/cockpit2/fuel/auto_crossfeed",0,
	"sim/fuel/auto_crossfeed_on_open","sim/fuel/auto_crossfeed_off")

------------ Annunciators

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
	if get(drefFuelPressLow,0) > 0 or get(drefFuelPressLow,1) > 0 or get(drefFuelPressLow,2) > 0 or get(drefFuelPressLow,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- AUX FUEL PUMP ANC
sysFuel.auxFuelPumpsAnc = CustomAnnunciator:new("auxfuel",
function ()
	if sysFuel.allFuelPumpGroup:getStatus() > 0 then 
		return 1
	else
		return 0
	end
end)

return sysFuel