-- DFLT airplane 
-- Fuel related functionality

local sysFuel = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"

local drefFuelPressLow = "sim/cockpit2/annunciators/fuel_pressure_low"

-- fuel pumps
sysFuel.fuelPumpLeftAft = TwoStateCmdSwitch:new ("fuelpumpleftaft","sim/cockpit2/fuel/fuel_tank_pump_on",0,"sim/fuel/fuel_pump_1_on","sim/fuel/fuel_pump_1_off","sim/fuel/fuel_pump_1_tog")
sysFuel.fuelPumpLeftFwd = TwoStateCmdSwitch:new ("fuelpumpleftfwd","sim/cockpit2/fuel/fuel_tank_pump_on",1,"sim/fuel/fuel_pump_2_on","sim/fuel/fuel_pump_2_off","sim/fuel/fuel_pump_2_tog")
sysFuel.fuelPumpRightAft = TwoStateCmdSwitch:new("fuelpumprightaft","sim/cockpit2/fuel/fuel_tank_pump_on",2,"sim/fuel/fuel_pump_3_on","sim/fuel/fuel_pump_3_off","sim/fuel/fuel_pump_3_tog")
sysFuel.fuelPumpRightFwd = TwoStateCmdSwitch:new("fuelpumprightfwd","sim/cockpit2/fuel/fuel_tank_pump_on",3,"sim/fuel/fuel_pump_4_on","sim/fuel/fuel_pump_4_off","sim/fuel/fuel_pump_4_tog")
sysFuel.fuelPumpCtrLeft = TwoStateCmdSwitch:new ("fuelpumpctrleft","sim/cockpit2/fuel/fuel_tank_pump_on",4,"sim/fuel/fuel_pump_5_on","sim/fuel/fuel_pump_5_off","sim/fuel/fuel_pump_5_tog")
sysFuel.fuelPumpCtrRight = TwoStateCmdSwitch:new("fuelpumpctrright","sim/cockpit2/fuel/fuel_tank_pump_on",5,"sim/fuel/fuel_pump_6_on","sim/fuel/fuel_pump_6_off","sim/fuel/fuel_pump_6_tog")

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

return sysFuel