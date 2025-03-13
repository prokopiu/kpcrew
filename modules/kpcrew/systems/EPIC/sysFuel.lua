-- EPIC airplane 
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

logMsg("EPIC sysFuel")

sysFuel.fuelSwitch1			= TwoStateCustomSwitch:new("fuelswitch1","aerobask/kn_fuel_sel",0,
function () 
	if get("aerobask/kn_fuel_sel") == 0 then
		command_once("aerobask/fuel_sel_right")
	end
end,
function () 
	command_once("aerobask/fuel_sel_off")
end,
function () 
end,
function () 
	if get("aerobask/kn_fuel_sel") == 0 then
		return 0
	else
		return 1
	end
end)
sysFuel.fuelSwitchGroup 		= SwitchGroup:new("fuelswitches")
sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch1)

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateToggleSwitch:new ("fuelpumpleftaft","aerobask/lt_pump_L",0,
	"aerobask/pump_L_toggle")
sysFuel.fuelPumpRightAft 	= TwoStateToggleSwitch:new("fuelpumprightaft","aerobask/lt_pump_R",0,
	"aerobask/pump_R_toggle")
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)

return sysFuel