-- MD11 airplane 
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

local drefFuelPressLow = "sim/cockpit2/annunciators/fuel_pressure_low"

-- Fuel switches 
sysFuel.fuelLever1 = TwoStateDrefSwitch:new("","Rotate/aircraft/controls/eng_fuel_1",0)
sysFuel.fuelLever2 = TwoStateDrefSwitch:new("","Rotate/aircraft/controls/eng_fuel_2",0)
sysFuel.fuelLever3 = TwoStateDrefSwitch:new("","Rotate/aircraft/controls/eng_fuel_3",0)
sysFuel.fuelLeverGroup = SwitchGroup:new("fuelLevers")
sysFuel.fuelLeverGroup:addSwitch(sysFuel.fuelLever1)
sysFuel.fuelLeverGroup:addSwitch(sysFuel.fuelLever2)
sysFuel.fuelLeverGroup:addSwitch(sysFuel.fuelLever3)
-- Rotate/aircraft/controls_c/eng_fuel_x_dn
-- Rotate/aircraft/controls_c/eng_fuel_x_up

-- fuel pumps
sysFuel.fuelPump1 = TwoStateToggleSwitch:new ("","Rotate/aircraft/systems/fuel_tank_1_off_lt",0,"Rotate/aircraft/controls_c/tank_1_pumps")
sysFuel.fuelPump2 = TwoStateToggleSwitch:new ("","Rotate/aircraft/systems/fuel_tank_2_off_lt",0,"Rotate/aircraft/controls_c/tank_1_pumps")
sysFuel.fuelPump3 = TwoStateToggleSwitch:new ("","Rotate/aircraft/systems/fuel_tank_3_off_lt",0,"Rotate/aircraft/controls_c/tank_1_pumps")

sysFuel.fuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPump1)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPump3)

sysFuel.crossFeed = TwoStateCmdSwitch:new("crossfeed","sim/cockpit2/fuel/auto_crossfeed",0,"sim/fuel/auto_crossfeed_on_open","sim/fuel/auto_crossfeed_off")

sysFuel.fuelDumpGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/fuel_dump_grd",0,"Rotate/aircraft/controls_c/fuel_dump_grd")

sysFuel.manifoldDrainGuard = TwoStateToggleSwitch:new("","Rotate/aircraft/controls/fuel_manif_drain_grd",0,"Rotate/aircraft/controls_c/fuel_manif_drain_grd")

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