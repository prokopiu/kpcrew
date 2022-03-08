-- B738 airplane 
-- Fuel related functionality

local sysFuel = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

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

sysFuel.allFuelPumpsOff = CustomAnnunciator:new("allfueloff",
function ()
	local leftAftpmp = (activePrefSet:get("aircraft:powerup_apu") == false and sysFuel.fuelPumpLeftAft:getStatus() == 0) or (activePrefSet:get("aircraft:powerup_apu") == true and sysFuel.fuelPumpLeftAft:getStatus() == 1)
	if leftAftpmp == true
	and sysFuel.fuelPumpLeftFwd:getStatus() == 0 
	and sysFuel.fuelPumpRightAft:getStatus() == 0 
	and sysFuel.fuelPumpRightFwd:getStatus() == 0 
	and sysFuel.fuelPumpCtrLeft:getStatus() == 0 
	and sysFuel.fuelPumpCtrRight:getStatus() == 0 then
		return 1
	else
		return 0
	end
end)

return sysFuel