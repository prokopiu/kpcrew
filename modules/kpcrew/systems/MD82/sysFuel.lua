-- MD81 airplane 
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

-- fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new("fuelpumpleftaft","sim/cockpit2/fuel/fuel_tank_pump_on",1)
sysFuel.fuelPumpLeftFwd 	= TwoStateDrefSwitch:new("fuelpumpleftfwd","sim/cockpit2/fuel/fuel_tank_pump_on",1)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","sim/cockpit2/fuel/fuel_tank_pump_on",2)
sysFuel.fuelPumpRightFwd 	= TwoStateDrefSwitch:new("fuelpumprightfwd","sim/cockpit2/fuel/fuel_tank_pump_on",2)
sysFuel.fuelPumpCtrLeft 	= TwoStateDrefSwitch:new("fuelpumpctrleft","sim/cockpit2/fuel/fuel_tank_pump_on",-1)
sysFuel.fuelPumpCtrRight 	= TwoStateDrefSwitch:new("fuelpumpctrright","sim/cockpit2/fuel/fuel_tank_pump_on",-1)

sysFuel.fuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.ctrFuelPumpGroup = SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.crossFeed = TwoStateCmdSwitch:new("crossfeed","sim/cockpit2/fuel/auto_crossfeed",0,"sim/fuel/auto_crossfeed_on_open","sim/fuel/auto_crossfeed_off")

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
	if get(drefFuelPressLow,0) > 0 or get(drefFuelPressLow,1) > 0 or get(drefFuelPressLow,2) > 0 or get(drefFuelPressLow,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- AUX FUEL PUMP ANC (do not use)
sysFuel.auxFuelPumpsAnc = CustomAnnunciator:new("auxfuel",
function ()
	return 0
end)

return sysFuel