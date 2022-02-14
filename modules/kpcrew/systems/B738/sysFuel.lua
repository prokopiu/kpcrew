-- B738 airplane 
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
InopSwitch = require "kpcrew.systems.InopSwitch"

local drefFuelPressC1 = "laminar/B738/annunciator/low_fuel_press_c1"
local drefFuelPressC2 = "laminar/B738/annunciator/low_fuel_press_c2"
local drefFuelPressL1 = "laminar/B738/annunciator/low_fuel_press_l1"
local drefFuelPressL2 = "laminar/B738/annunciator/low_fuel_press_l2"
local drefFuelPressR1 = "laminar/B738/annunciator/low_fuel_press_r1"
local drefFuelPressR2 = "laminar/B738/annunciator/low_fuel_press_r2"

sysFuel.fuelPumpLeftAft = TwoStateDrefSwitch:new ("fuelpumpleftaft","laminar/B738/fuel/fuel_tank_pos_lft1",0)
sysFuel.fuelPumpLeftFwd = TwoStateDrefSwitch:new ("fuelpumpleftfwd","laminar/B738/fuel/fuel_tank_pos_lft2",0)
sysFuel.fuelPumpRightAft = TwoStateDrefSwitch:new("fuelpumprightaft","laminar/B738/fuel/fuel_tank_pos_rgt1",0)
sysFuel.fuelPumpRightFwd = TwoStateDrefSwitch:new("fuelpumprightfwd","laminar/B738/fuel/fuel_tank_pos_rgt2",0)
sysFuel.fuelPumpCtrLeft = TwoStateDrefSwitch:new ("fuelpumpctrleft","laminar/B738/fuel/fuel_tank_pos_ctr1",0)
sysFuel.fuelPumpCtrRight = TwoStateDrefSwitch:new("fuelpumpctrright","laminar/B738/fuel/fuel_tank_pos_ctr2",0)

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

sysFuel.crossFeed = TwoStateCmdSwitch:new("crossfeed","laminar/B738/knobs/cross_feed_pos",0,"laminar/B738/toggle_switch/crossfeed_valve_on","laminar/B738/toggle_switch/crossfeed_valve_off")

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
	if get(drefFuelPressC1,0) > 0 or get(drefFuelPressC2,0) > 0 or get(drefFuelPressL1,0) > 0 or get(drefFuelPressL2,0) > 0 or get(drefFuelPressR1,0) > 0 or get(drefFuelPressR2,0) > 0 then
		return 1
	else
		return 0
	end
end)

return sysFuel