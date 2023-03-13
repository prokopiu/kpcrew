-- A350 airplane 
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

--------- Switch datarefs common

-- local drefMainFuelPump1		= "1-sim/68/button"						.=.1.and.1-sim/81/button.=.1
-- local dref	MAIN FUEL PUMPS................................ON		.1-sim/68/button.=.1.and.1-sim/81/button.=.1
-- local dref	STBY FUEL PUMPS..............................AUTO		.1-sim/69/button.=.1.and.1-sim/82/button.=.1
-- local dref	1 & 2 FUEL PUMPS...............................ON		.1-sim/70/button.=.1.and.1-sim/80/button.=.1
-- local dref	FUEL PUMP 1...................................OFF		.1-sim/68/button.=.0.and.1-sim/69/button.=.0
-- local dref	FUEL PUMP 2...................................OFF		.1-sim/81/button.=.0.and.1-sim/82/button.=.0
-- local dref	MAIN FUEL PUMPS...............................OFF		.1-sim/68/button.=.0.and.1-sim/81/button.=.0
-- local dref	STBY FUEL PUMPS...............................OFF		.1-sim/69/button.=.0.and.1-sim/82/button.=.0
-- local dref	1 & 2 FUEL PUMPS..............................OFF		.1-sim/70/button.=.0.and.1-sim/80/button.=.0
-- local dref	CTR TK FEED PB................................OFF		.1-sim/84/button.=.0
-- local dref	TRANSFER FEEDs................................OFF		.1-sim/83/button.=.0.and.1-sim/85/button.=.0

--------- Annunciator datarefs common

local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

--------- Switch commands common


--------- Actuator definitions

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCmdSwitch:new ("fuelpumpleftaft","sim/cockpit2/fuel/fuel_tank_pump_on",1,
	"sim/fuel/fuel_pump_1_on","sim/fuel/fuel_pump_1_off","sim/fuel/fuel_pump_1_tog")
sysFuel.fuelPumpRightAft 	= TwoStateCmdSwitch:new("fuelpumprightaft","sim/cockpit2/fuel/fuel_tank_pump_on",2,
	"sim/fuel/fuel_pump_3_on","sim/fuel/fuel_pump_3_off","sim/fuel/fuel_pump_3_tog")
sysFuel.fuelPumpCtrLeft 	= TwoStateCmdSwitch:new ("fuelpumpctrleft","sim/cockpit2/fuel/fuel_tank_pump_on",0,
	"sim/fuel/fuel_pump_5_on","sim/fuel/fuel_pump_5_off","sim/fuel/fuel_pump_5_tog")
sysFuel.fuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.fuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)

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

return sysFuel