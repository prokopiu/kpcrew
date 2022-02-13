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

local drefFuelPressC1 = "laminar/B738/annunciator/low_fuel_press_c1"
local drefFuelPressC2 = "laminar/B738/annunciator/low_fuel_press_c2"
local drefFuelPressL1 = "laminar/B738/annunciator/low_fuel_press_l1"
local drefFuelPressL2 = "laminar/B738/annunciator/low_fuel_press_l2"
local drefFuelPressR1 = "laminar/B738/annunciator/low_fuel_press_r1"
local drefFuelPressR2 = "laminar/B738/annunciator/low_fuel_press_r2"

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