-- Rotate MD88 airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpumpleftaft","Rotate/md80/fuel/left_aft_pump",0)
sysFuel.fuelPumpLeftFwd 	= TwoStateDrefSwitch:new ("fuelpumpleftfwd","Rotate/md80/fuel/left_fwd_pump",0)
sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new ("fuelpumprightaft","Rotate/md80/fuel/right_aft_pump",0)
sysFuel.fuelPumpRightFwd	= TwoStateDrefSwitch:new ("fuelpumprightfwd","Rotate/md80/fuel/right_fwd_pump",0)
sysFuel.fuelPumpCtrAft 		= TwoStateDrefSwitch:new ("fuelpumpctraft","Rotate/md80/fuel/center_aft_pump",0)
sysFuel.fuelPumpCtrFwd	 	= TwoStateDrefSwitch:new ("fuelpumpctrfwd","Rotate/md80/fuel/center_fwd_pump",0)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrFwd)

return sysFuel