-- E1FF X-Crafts Freeware airplane 
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

sysFuel.fuelCrossFeed = TwoStateCustomSwitch:new("crossfeed","sim/cockpit2/fuel/fuel_tank_transfer_to",0,
	function () 
		set("sim/cockpit2/fuel/fuel_tank_transfer_to",1)
	end,
	function () 
		set("sim/cockpit2/fuel/fuel_tank_transfer_to",0)
	end,
	function () 
		set("sim/cockpit2/fuel/fuel_tank_transfer_to",3)
	end,
	function () 
		if get("sim/cockpit2/fuel/fuel_tank_transfer_to") ~= 0 then
			return 1
		else
			return 0
		end
	end)

return sysFuel