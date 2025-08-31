-- B7x7 FF 767 & 757 airplane 
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

logMsg("B7x7 sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpumpleftaft","anim/32/button",0)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new ("fuelpumprightaft","anim/35/button",0)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","anim/34/button",0)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","anim/37/button",0)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","anim/38/button",0)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","anim/39/button",0)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

sysFuel.fuelCrossFeed 		= SwitchGroup:new("crossfeedgroup")
sysFuel.fuelCrossFeed1		= TwoStateDrefSwitch:new("crossfeed","anim/33/button",0)
sysFuel.fuelCrossFeed2		= TwoStateDrefSwitch:new("crossfeed","anim/36/button",0)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed1)	
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed2)	

return sysFuel