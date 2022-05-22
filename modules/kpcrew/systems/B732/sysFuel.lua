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

local drefFuelPressC1 = "FJS/732/Annun/SysAnnunBUT_25"
local drefFuelPressC2 = "FJS/732/Annun/SysAnnunBUT_26"
local drefFuelPressL1 = "FJS/732/Annun/SysAnnunBUT_27"
local drefFuelPressL2 = "FJS/732/Annun/SysAnnunBUT_28"
local drefFuelPressR1 = "FJS/732/Annun/SysAnnunBUT_29"
local drefFuelPressR2 = "FJS/732/Annun/SysAnnunBUT_30"

sysFuel.fuelPumpLeftAft = TwoStateDrefSwitch:new ("fuelpumpleftaft", "FJS/732/Fuel/FuelPumpL1Switch",0)
sysFuel.fuelPumpLeftFwd = TwoStateDrefSwitch:new ("fuelpumpleftfwd", "FJS/732/Fuel/FuelPumpL2Switch",0)
sysFuel.fuelPumpRightAft = TwoStateDrefSwitch:new("fuelpumprightaft","FJS/732/Fuel/FuelPumpR1Switch",0)
sysFuel.fuelPumpRightFwd = TwoStateDrefSwitch:new("fuelpumprightfwd","FJS/732/Fuel/FuelPumpR1Switch",0)
sysFuel.fuelPumpCtrLeft = TwoStateDrefSwitch:new ("fuelpumpctrleft", "FJS/732/Fuel/FuelPumpC1Switch",0)
sysFuel.fuelPumpCtrRight = TwoStateDrefSwitch:new("fuelpumpctrright","FJS/732/Fuel/FuelPumpC2Switch",0)

sysFuel.allFuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.ctrFuelPumpGroup = SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.wingFuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)

sysFuel.crossFeed = TwoStateDrefSwitch:new("crossfeed","FJS/732/Fuel/FuelCrossFeedSelector",0)

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
--	if get(drefFuelPressC1,0) > 0 or get(drefFuelPressC2,0) > 0 or get(drefFuelPressL1,0) > 0 or get(drefFuelPressL2,0) > 0 or get(drefFuelPressR1,0) > 0 or get(drefFuelPressR2,0) > 0 then
--		return 1
--	else
		return 0
--	end
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

sysFuel.centerTankLbs = SimpleAnnunciator:new("","FJS/732/Fuel/FuelQtyCNeedle",0)
sysFuel.centerTankKgs = SimpleAnnunciator:new("","sim/cockpit2/fuel/fuel_quantity",1)
sysFuel.allTanksLbs = SimpleAnnunciator:new("","sim/aircraft/weight/acf_m_fuel_tot",0)
sysFuel.allTanksKgs = SimpleAnnunciator:new("","sim/cockpit2/fuel/fuel_totalizer_init_kg",0)

return sysFuel