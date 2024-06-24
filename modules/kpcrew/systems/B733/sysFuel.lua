-- B733 IXEG B737 PRO 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
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

local drefFuelPressC1 		= "ixeg/733/fuel/fuel_ctr_left_lowp_ann"
local drefFuelPressC2 		= "ixeg/733/fuel/fuel_ctr_right_lowp_ann"
local drefFuelPressL1 		= "ixeg/733/fuel/fuel_1_aft_lowp_ann"
local drefFuelPressL2 		= "ixeg/733/fuel/fuel_1_fwd_lowp_ann"
local drefFuelPressR1 		= "ixeg/733/fuel/fuel_2_aft_lowp_ann"
local drefFuelPressR2 		= "ixeg/733/fuel/fuel_2_fwd_lowp_ann"

sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpumpleftaft","ixeg/733/fuel/fuel_1_aft_act",0)
sysFuel.fuelPumpLeftFwd 	= TwoStateDrefSwitch:new ("fuelpumpleftfwd","ixeg/733/fuel/fuel_1_fwd_act",0)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","ixeg/733/fuel/fuel_2_aft_act",0)
sysFuel.fuelPumpRightFwd 	= TwoStateDrefSwitch:new("fuelpumprightfwd","ixeg/733/fuel/fuel_2_fwd_act",0)
sysFuel.fuelPumpCtrLeft 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","ixeg/733/fuel/fuel_ctr_left_act",0)
sysFuel.fuelPumpCtrRight 	= TwoStateDrefSwitch:new("fuelpumpctrright","ixeg/733/fuel/fuel_ctr_right_act",0)
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.ctrFuelPumpGroup 	= SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.wingFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)

sysFuel.crossFeed 			= TwoStateDrefSwitch:new("crossfeed","ixeg/733/fuel/fuel_xfeed_act",0)

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc 			= CustomAnnunciator:new("fuellow",
function ()
	if get(drefFuelPressC1,0) > 0 or get(drefFuelPressC2,0) > 0 or get(drefFuelPressL1,0) > 0 or get(drefFuelPressL2,0) > 0 or get(drefFuelPressR1,0) > 0 or get(drefFuelPressR2,0) > 0 then
		return 1
	else
		return 0
	end
end)

sysFuel.allFuelPumpsOff 	= CustomAnnunciator:new("allfueloff",
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

sysFuel.centerTankLbs 		= SimpleAnnunciator:new("","laminar/B738/fuel/center_tank_lbs",0)
sysFuel.centerTankKgs 		= SimpleAnnunciator:new("","laminar/B738/fuel/center_tank_kgs",0)
sysFuel.allTanksLbs 		= SimpleAnnunciator:new("","laminar/B738/fuel/total_tank_lbs",0)
sysFuel.allTanksKgs 		= SimpleAnnunciator:new("","laminar/B738/fuel/total_tank_kgs",0)

sysFuel.valveAnns 			= CustomAnnunciator:new("",
function () 
	if get("ixeg/733/fuel/fuel_valve1_closed_ann") + 
		get("ixeg/733/fuel/fuel_valve2_closed_ann") > 0 then
		return 1
	else
		return 0
	end
end)

sysFuel.xfeedVlvAnn 		= SimpleAnnunciator:new("","ixeg/733/fuel/fuel_xfeed_open_ann",0)

-- AUX FUEL PUMP ANC (do not use)
sysFuel.auxFuelPumpsAnc = CustomAnnunciator:new("auxfuel",
function ()
	return 0
end)

return sysFuel