-- B744 MSPARKS Rotate airplane 
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

logMsg("B744 sysFuel")

-- fuel pumps
sysFuel.fuelPumpLeftAft = TwoStateToggleSwitch:new ("fuelpumpleftaft","laminar/B747/fuel/main1_tank/main_pump_aft_on",0,
	"laminar/B747/button_switch/fuel_main_pump_aft_1")
sysFuel.fuelPumpLeftFwd = TwoStateToggleSwitch:new ("fuelpumpleftfwd","laminar/B747/fuel/main1_tank/main_pump_fwd_on",0,
	"laminar/B747/button_switch/fuel_main_pump_fwd_1")
sysFuel.fuelPumpRightAft = TwoStateToggleSwitch:new("fuelpumprightaft","laminar/B747/fuel/main4_tank/main_pump_aft_on",0,
	"laminar/B747/button_switch/fuel_main_pump_aft_4")
sysFuel.fuelPumpRightFwd = TwoStateToggleSwitch:new("fuelpumprightfwd","laminar/B747/fuel/main4_tank/main_pump_fwd_on",0,
	"laminar/B747/button_switch/fuel_main_pump_fwd_4")
sysFuel.fuelPumpCtrLeft = TwoStateToggleSwitch:new ("fuelpumpctrleft","laminar/B747/fuel/center_tank/ovrd_jett_pump_L_on",0,
	"laminar/B747/button_switch/fuel_ctr_wing_tnk_pump_L")
sysFuel.fuelPumpCtrRight = TwoStateToggleSwitch:new("fuelpumpctrright","laminar/B747/fuel/center_tank/ovrd_jett_pump_R_on",0,
	"laminar/B747/button_switch/fuel_ctr_wing_tnk_pump_R")
sysFuel.fuelPump2Aft = TwoStateToggleSwitch:new("fuelpump2aft","laminar/B747/button_switch/position",61,
	"laminar/B747/button_switch/fuel_main_pump_aft_2")
sysFuel.fuelPump2Fwd = TwoStateToggleSwitch:new("fuelpump2fwd","laminar/B747/fuel/main2_tank/main_pump_fwd_on",0,
	"laminar/B747/button_switch/fuel_main_pump_fwd_2")
sysFuel.fuelPump3Aft = TwoStateToggleSwitch:new("fuelpump3aft","laminar/B747/button_switch/position",62,
	"laminar/B747/button_switch/fuel_main_pump_aft_3")
sysFuel.fuelPump3Fwd = TwoStateToggleSwitch:new("fuelpump3fwd","laminar/B747/fuel/main3_tank/main_pump_fwd_on",0,
	"laminar/B747/button_switch/fuel_main_pump_fwd_3")
sysFuel.fuelPumpStabLeft = TwoStateToggleSwitch:new("fuelpumpstableft","laminar/B747/button_switch/position",54,
	"laminar/B747/button_switch/fuel_stab_tnk_pump_L")
sysFuel.fuelPumpStabRight = TwoStateToggleSwitch:new("fuelpumpstabright","laminar/B747/button_switch/position",55,
	"laminar/B747/button_switch/fuel_stab_tnk_pump_R")
	
sysFuel.allFuelPumpGroup = SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2Aft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2Fwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3Aft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3Fwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpStabLeft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpStabRight)

sysFuel.ctrFuelPumpGroup = SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.fuelCrossFeed			= SwitchGroup:new("fuelcrossfeeds")
sysFuel.crossFdLeft			= TwoStateToggleSwitch:new("fuelcrossleft","laminar/B747/button_switch/position",48,
	"laminar/B747/button_switch/fuel_xfeed_vlv_1")
sysFuel.crossFdRight		= TwoStateToggleSwitch:new("fuelcrosslright","laminar/B747/button_switch/position",51,
	"laminar/B747/button_switch/fuel_xfeed_vlv_4")
sysFuel.fuelCrossFeed:addSwitch(sysFuel.crossFdLeft)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.crossFdRight)

return sysFuel