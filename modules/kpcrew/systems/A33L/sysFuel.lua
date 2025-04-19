-- Laminar A330 variants airplane 
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

logMsg("A33L sysFuel")

-- Fuel pumps
sysFuel.fuelPumpLeftAft 	= TwoStateToggleSwitch:new ("fuelpmp1","laminar/A333/fuel/buttons/left1_pump_pos",0,
	"laminar/A333/switches/left1_pump_toggle")
sysFuel.fuelPumpRightAft 	= TwoStateToggleSwitch:new ("fuelpmp2","laminar/A333/fuel/buttons/right1_pump_pos",0,
	"laminar/A333/switches/right1_pump_toggle")
sysFuel.fuelPump3		 	= TwoStateToggleSwitch:new ("fuelpmp3","laminar/A333/fuel/buttons/left2_pump_pos",0,
	"laminar/A333/switches/left2_pump_toggle")
sysFuel.fuelPump4		 	= TwoStateToggleSwitch:new ("fuelpmp4","laminar/A333/fuel/buttons/right2_pump_pos",0,
	"laminar/A333/switches/right2_pump_toggle")
sysFuel.fuelPump5		 	= TwoStateToggleSwitch:new ("fuelpmp5","laminar/A333/fuel/buttons/left_stby_pump_pos",0,
	"laminar/A333/switches/left_stby_pump_toggle")
sysFuel.fuelPump6		 	= TwoStateToggleSwitch:new ("fuelpmp6","laminar/A333/fuel/buttons/right_stby_pump_pos",0,
	"laminar/A333/switches/right_stby_pump_toggle")
sysFuel.fuelPump7		 	= TwoStateToggleSwitch:new ("fuelpmp6","laminar/A333/fuel/buttons/center_left_pump_pos",0,
	"laminar/A333/switches/center_left_pump_toggle")
sysFuel.fuelPump8		 	= TwoStateToggleSwitch:new ("fuelpmp6","laminar/A333/fuel/buttons/center_right_pump_pos",0,
	"laminar/A333/switches/center_right_pump_toggle")
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)

sysFuel.crossFeed1		 	= TwoStateToggleSwitch:new ("fuelxfr1","laminar/A333/annun/fuel/ctr_tank_xfr_man",0,
	"laminar/A333/switches/center_xfr_toggle")
sysFuel.crossFeed2		 	= TwoStateToggleSwitch:new ("fuelxfr2","laminar/A333/fuel/buttons/wing_x_feed_pos",0,
	"laminar/A333/switches/wing_x_feed_toggle")
sysFuel.crossFeed3		 	= TwoStateToggleSwitch:new ("fuelxfr3","laminar/A333/fuel/buttons/trim_xfr_pos",0,
	"laminar/A333/switches/trim_xfr_toggle")
sysFuel.crossFeed = SwitchGroup:new("crossfeed")
sysFuel.crossFeed:addSwitch(sysFuel.crossFeed1)
sysFuel.crossFeed:addSwitch(sysFuel.crossFeed2)
sysFuel.crossFeed:addSwitch(sysFuel.crossFeed3)

return sysFuel