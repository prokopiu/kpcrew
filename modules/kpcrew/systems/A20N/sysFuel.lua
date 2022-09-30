-- A20N JarDesign airplane 
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

-- Fuel Panel
sysFuel.fuelPumpT11	= TwoStateDrefSwitch:new ("fuelpumpt11","sim/custom/xap/fuel/t1_pump1",0)
sysFuel.fuelPumpT12	= TwoStateDrefSwitch:new ("fuelpumpt12","sim/custom/xap/fuel/t1_pump2",0)
sysFuel.fuelPumpT21	= TwoStateDrefSwitch:new ("fuelpumpt21","sim/custom/xap/fuel/t2_pump1",0)
sysFuel.fuelPumpT22	= TwoStateDrefSwitch:new ("fuelpumpt22","sim/custom/xap/fuel/t2_pump2",0)
sysFuel.fuelPumpT31	= TwoStateDrefSwitch:new ("fuelpumpt31","sim/custom/xap/fuel/t3_pump1",0)
sysFuel.fuelPumpT32	= TwoStateDrefSwitch:new ("fuelpumpt32","sim/custom/xap/fuel/t3_pump2",0)
sysFuel.fuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT11)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT12)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT21)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT22)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT31)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpT32)
-- XFEED
sysFuel.crossFeed = TwoStateDrefSwitch:new("crossfeed","sim/custom/xap/fuel/xfeed",0)
-- MODE select
sysFuel.fuelMode = TwoStateDrefSwitch:new("fuelmode","sim/custom/xap/fuel/cent_mode",0)

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