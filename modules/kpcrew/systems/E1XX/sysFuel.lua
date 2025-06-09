-- E1FF airplane 
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

logMsg("E1FF sysFuel")

sysFuel.fuelCrossFeed = TwoStateCustomSwitch:new("crossfeed","XCrafts/fuel/xfeed_sw",0,
	function () 
		command_once("XCrafts/fuel/xfeed_switch_ccw_cmnd")
		command_once("XCrafts/fuel/xfeed_switch_ccw_cmnd")
	end,
	function () 
		command_once("XCrafts/fuel/xfeed_switch_ccw_cmnd")
		command_once("XCrafts/fuel/xfeed_switch_ccw_cmnd")
		command_once("XCrafts/fuel/xfeed_switch_cw_cmnd")
	end,
	function () 
		command_once("XCrafts/fuel/xfeed_switch_cw_cmnd")
		command_once("XCrafts/fuel/xfeed_switch_cw_cmnd")
	end,
	function () 
		if get("XCrafts/fuel/xfeed_sw") ~= 1 then
			return 1
		else
			return 0
		end
	end)

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateCustomSwitch:new ("fuelpumpleftaft","XCrafts/fuel/ac_pump_left_sw",0,
	function () 
		command_once("XCrafts/fuel/ac_pump_left_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_left_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_left_switch_cw_cmnd")
	end,
	function () 
		command_once("XCrafts/fuel/ac_pump_left_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_left_switch_ccw_cmnd")
	end,
	function () 
	end,
	function () 
		if get("XCrafts/fuel/ac_pump_left_sw") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysFuel.fuelPumpRightAft 	= TwoStateCustomSwitch:new("fuelpumprightaft","XCrafts/fuel/ac_pump_right_sw",0,
	function () 
		command_once("XCrafts/fuel/ac_pump_right_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_right_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_right_switch_cw_cmnd")
	end,
	function () 
		command_once("XCrafts/fuel/ac_pump_right_switch_ccw_cmnd")
		command_once("XCrafts/fuel/ac_pump_right_switch_ccw_cmnd")
	end,
	function () 
	end,
	function () 
		if get("XCrafts/fuel/ac_pump_right_sw") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)

return sysFuel