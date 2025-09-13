-- B748 airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("B748 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpump1","ssg/Fuel/fuelpp1_f_sw",0)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new ("fuelpump2","ssg/Fuel/fuelpp2_fr_sw",0)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new ("fuelpump3","ssg/Fuel/fuelpp3_fl_sw",0)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new ("fuelpump4","ssg/Fuel/fuelpp4_f_sw",0)
sysFuel.fuelPump5 			= TwoStateDrefSwitch:new ("fuelpump5","ssg/Fuel/fuelpp1_a_sw",0)
sysFuel.fuelPump6 			= TwoStateDrefSwitch:new ("fuelpump6","ssg/Fuel/fuelpp2_ar_sw",0)
sysFuel.fuelPump7		 	= TwoStateDrefSwitch:new ("fuelpump7","ssg/Fuel/fuelpp3_al_sw",0)
sysFuel.fuelPump8		 	= TwoStateDrefSwitch:new ("fuelpump8","ssg/Fuel/fuelpp4_a_sw",0)
sysFuel.fuelPump9 			= TwoStateDrefSwitch:new ("fuelpump9","ssg/Fuel/fuelpp2_fl_sw",0)
sysFuel.fuelPump10 			= TwoStateDrefSwitch:new ("fuelpump10","ssg/Fuel/fuelpp3_fl_sw",0)
sysFuel.fuelPump11		 	= TwoStateDrefSwitch:new ("fuelpump11","ssg/Fuel/fuelpp2_al_sw",0)
sysFuel.fuelPump12		 	= TwoStateDrefSwitch:new ("fuelpump12","ssg/Fuel/fuelpp3_al_sw",0)
sysFuel.fuelPump13		 	= TwoStateDrefSwitch:new ("fuelpump13","ssg/Fuel/fuelppctr_l_sw",0)
sysFuel.fuelPump14		 	= TwoStateDrefSwitch:new ("fuelpump14","ssg/Fuel/fuelppctr_r_sw",0)
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)

-- sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump9)
-- sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump10)
-- sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump11)
-- sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump12)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump13)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump14)

sysFuel.fuelCrossFeed		= SwitchGroup:new("fuelcrossfeed")
sysFuel.fuelCrossFeed1		= TwoStateDrefSwitch:new("crossfeed1","ssg/Fuel/fuel_ValveL_sw",0)
sysFuel.fuelCrossFeed2		= TwoStateDrefSwitch:new("crossfeed2","ssg/Fuel/fuel_ValveR_sw",0)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed1)	
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed2)	

return sysFuel