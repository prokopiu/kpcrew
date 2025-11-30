-- B737 airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu


-- System Elements
-- sysFuel.fuelPump1
-- sysFuel.fuelPump2
-- sysFuel.fuelPump3
-- sysFuel.fuelPump4
-- sysFuel.allFuelPumpGroup
-- sysFuel.fuelCrossFeed
-- sysFuel.fuelSwitch1
-- sysFuel.fuelSwitchGroup
-- sysFuel.fuel_balanced()
-- sysFuel.fuelLowAnc
-- sysFuel.auxFuelPumpsAnc
-- Macro: kc_macro_fuel

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

--------- Switch datarefs common
local drefFuelPump1			= "laminar/B738/fuel/fuel_tank_pos_lft1"
local drefFuelPump2			= "laminar/B738/fuel/fuel_tank_pos_lft2"
local drefFuelPump3			= "laminar/B738/fuel/fuel_tank_pos_rgt1"
local drefFuelPump4			= "laminar/B738/fuel/fuel_tank_pos_rgt2"
local drefFuelPump5			= "laminar/B738/fuel/fuel_tank_pos_ctr1"
local drefFuelPump6			= "laminar/B738/fuel/fuel_tank_pos_ctr2"
local drefFuelCrossfeed		= "laminar/B738/knobs/cross_feed_pos"

--------- Annunciator datarefs common
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

--------- Switch commands common
local cmdFuelCrossfeedOn	= "laminar/B738/toggle_switch/crossfeed_valve_on"
local cmdFuelCrossfeedOff	= "laminar/B738/toggle_switch/crossfeed_valve_off"

---------- Switches

-- Fuel pumps
sysFuel.fuelPump1	 		= TwoStateDrefSwitch:new("fuelpump1",drefFuelPump1,0)
sysFuel.fuelPump2 			= TwoStateDrefSwitch:new("fuelpump2",drefFuelPump2,0)
sysFuel.fuelPump3 			= TwoStateDrefSwitch:new("fuelpump3",drefFuelPump3,0)
sysFuel.fuelPump4 			= TwoStateDrefSwitch:new("fuelpump4",drefFuelPump4,0)
sysFuel.fuelPump5 			= TwoStateDrefSwitch:new("fuelpump5",drefFuelPump5,0)
sysFuel.fuelPump6 			= TwoStateDrefSwitch:new("fuelpump6",drefFuelPump6,0)
sysFuel.allFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

sysFuel.ctrFuelPumpGroup 	= SwitchGroup:new("ctrfuelpumpgroup")
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.ctrFuelPumpGroup:addSwitch(sysFuel.fuelPump6)

sysFuel.wingFuelPumpGroup 	= SwitchGroup:new("fuelpumpgroup")
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPump1)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.wingFuelPumpGroup:addSwitch(sysFuel.fuelPump4)

-- Fuel xfeed
sysFuel.fuelCrossFeed 			= TwoStateCmdSwitch:new("crossfeed",drefFuelCrossfeed,0,cmdFuelCrossfeedOn,cmdFuelCrossfeedOff,"nocommand")

---------- Macros

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_before_start then
		sysFuel.allFuelPumpGroup:actuate(1)
		if get("laminar/B738/fuel/center_tank_kgs") < 200 then
			sysFuel.fuelPump5:actuate(0)
			sysFuel.fuelPump6:actuate(0)
		end
		sysFuel.fuelCrossFeed:actuate(0)
	elseif flightphase == kc_phase_shutdown then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysFuel