-- E55P airplane 
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
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("E55P sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCustomSwitch:new ("fuelpumpleftaft","aerobask/fuel/sw_pump1",0,
function ()
	command_once("aerobask/fuel/pump1_up")
	command_once("aerobask/fuel/pump1_up")
end,
function ()
	command_once("aerobask/fuel/pump1_dn")
	command_once("aerobask/fuel/pump1_dn")
end,
function ()
	command_once("aerobask/fuel/pump1_up")
	command_once("aerobask/fuel/pump1_up")
	command_once("aerobask/fuel/pump1_dn")
end,
function ()
	if get("aerobask/fuel/sw_pump1") > 0 then 
		return 1
	else
		return 0
	end
end)
sysFuel.fuelPumpRightAft 	= TwoStateCustomSwitch:new("fuelpumprightaft","aerobask/fuel/sw_pump2",0,
function ()
	command_once("aerobask/fuel/pump2_up")
	command_once("aerobask/fuel/pump2_up")
end,
function ()
	command_once("aerobask/fuel/pump2_dn")
	command_once("aerobask/fuel/pump2_dn")
end,
function ()
	command_once("aerobask/fuel/pump2_up")
	command_once("aerobask/fuel/pump2_up")
	command_once("aerobask/fuel/pump2_dn")
end,
function ()
	if get("aerobask/fuel/sw_pump2") > 0 then 
		return 1
	else
		return 0
	end
end)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)

sysFuel.crossFeed = TwoStateCustomSwitch:new("crossfeed","aerobask/fuel/knob_xfeed",0,
function ()
	command_once("aerobask/fuel/xfeed_lt")
end,
function ()
	command_once("aerobask/fuel/xfeed_lt")
	command_once("aerobask/fuel/xfeed_lt")
	command_once("aerobask/fuel/xfeed_rt")
end,
function ()
end,
function ()
	if get("aerobask/fuel/knob_xfeed") == 1 then
		return 0
	else
		return 1
	end
end)	

return sysFuel