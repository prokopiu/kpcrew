-- B737 airplane 
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

logMsg("B737 sysFuel")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

if kc_is_zibo then
	sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpumpleftaft","laminar/B738/fuel/fuel_tank_pos_lft1",0)
	sysFuel.fuelPumpLeftFwd 	= TwoStateDrefSwitch:new ("fuelpumpleftfwd","laminar/B738/fuel/fuel_tank_pos_lft2",0)
	sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","laminar/B738/fuel/fuel_tank_pos_rgt1",0)
	sysFuel.fuelPumpRightFwd 	= TwoStateDrefSwitch:new("fuelpumprightfwd","laminar/B738/fuel/fuel_tank_pos_rgt2",0)
	sysFuel.fuelPumpCtrLeft 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","laminar/B738/fuel/fuel_tank_pos_ctr1",0)
	sysFuel.fuelPumpCtrRight 	= TwoStateDrefSwitch:new("fuelpumpctrright","laminar/B738/fuel/fuel_tank_pos_ctr2",0)
else
	sysFuel.fuelPumpLeftAft 	= TwoStateDrefSwitch:new ("fuelpumpleftaft","sim/cockpit2/fuel/fuel_tank_pump_on",-1)
	sysFuel.fuelPumpLeftFwd 	= InopSwitch:new ("fuelpumpleftfwd")
	sysFuel.fuelPumpRightAft 	= TwoStateDrefSwitch:new("fuelpumprightaft","sim/cockpit2/fuel/fuel_tank_pump_on",2)
	sysFuel.fuelPumpRightFwd 	= InopSwitch:new("fuelpumprightfwd")
	sysFuel.fuelPumpCtrLeft 	= TwoStateDrefSwitch:new ("fuelpumpctrleft","sim/cockpit2/fuel/fuel_tank_pump_on",1)
	sysFuel.fuelPumpCtrRight 	= InopSwitch:new("fuelpumpctrright")
end
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.ctrFuelPumpGroup 	= SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrLeft)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPumpCtrRight)

sysFuel.wingFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpLeftFwd)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightAft)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPumpRightFwd)

if kc_is_zibo then
	sysFuel.crossFeed 			= TwoStateCmdSwitch:new("crossfeed","laminar/B738/knobs/cross_feed_pos",0,
		"laminar/B738/toggle_switch/crossfeed_valve_on","laminar/B738/toggle_switch/crossfeed_valve_off","nocommand")
else
	sysFuel.crossFeed 			= TwoStateCmdSwitch:new("crossfeed","laminar/B738/knobs/cross_feed",0,
		"laminar/B738/toggle_switch/crossfeed_valve_on","laminar/B738/toggle_switch/crossfeed_valve_off","nocommand")
end
	
return sysFuel