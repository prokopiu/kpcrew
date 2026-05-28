-- B742 airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysFuel.fuelPump1
-- sysFuel.fuelPump2
-- sysFuel.fuelPump3
-- sysFuel.fuelPump4
-- sysFuel.fuelPump5 +
-- sysFuel.fuelPump6 +
-- sysFuel.fuelPump7 +
-- sysFuel.fuelPump8 +
-- sysFuel.fuelPump9 +
-- sysFuel.fuelPump10 +
-- sysFuel.fuelCrossFeed
-- sysFuel.fuelCrossFeed1 +
-- sysFuel.fuelCrossFeed2 +
-- sysFuel.fuelCrossFeed3 +
-- sysFuel.fuelCrossFeed4 +
-- sysFuel.fuelCrossFeed5 +
-- sysFuel.fuelCrossFeed6 +
-- sysFuel.allFuelPumpGroup
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

sysFuel = require("kpcrew.systems.DFLT.sysFuel")

logMsg("B742 sysFuel")

--------- Switch datarefs common
local drefFuelPump1			= "B742/FUEL/fuel_boost_pump_sw"
local drefFuelCrossfeed		= "B742/FUEL/fuel_crossfeed_valve_rot"

--------- Annunciator datarefs common

--------- Switch commands common

---------- Switches

-- Fuel pumps
sysFuel.fuelPump1		 	= TwoStateDrefSwitch:new("fuelpump1",drefFuelPump1,-1)
sysFuel.fuelPump2			= TwoStateDrefSwitch:new("fuelpump2",drefFuelPump1,1)
sysFuel.fuelPump3		 	= TwoStateDrefSwitch:new("fuelpump3",drefFuelPump1,2)
sysFuel.fuelPump4		 	= TwoStateDrefSwitch:new("fuelpump4",drefFuelPump1,3)
sysFuel.fuelPump5		 	= TwoStateDrefSwitch:new("fuelpump5",drefFuelPump1,4)
sysFuel.fuelPump6		 	= TwoStateDrefSwitch:new("fuelpump6",drefFuelPump1,5)
sysFuel.fuelPump7		 	= TwoStateDrefSwitch:new("fuelpump7",drefFuelPump1,6)
sysFuel.fuelPump8		 	= TwoStateDrefSwitch:new("fuelpump8",drefFuelPump1,7)
sysFuel.fuelPump9		 	= TwoStateDrefSwitch:new("fuelpump9",drefFuelPump1,8)
sysFuel.fuelPump10		 	= TwoStateDrefSwitch:new("fuelpump10",drefFuelPump1,9)
sysFuel.allFuelPumpGroup 		= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump5)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump6)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump7)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump8)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump9)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump10)

-- Fuel xfeed
sysFuel.fuelCrossFeed = SwitchGroup:new("crossfeedgroup")
sysFuel.fuelCrossFeed1 = TwoStateDrefSwitch:new("xfeed1",drefFuelCrossfeed,-1)
sysFuel.fuelCrossFeed2 = TwoStateDrefSwitch:new("xfeed2",drefFuelCrossfeed,1)
sysFuel.fuelCrossFeed3 = TwoStateDrefSwitch:new("xfeed3",drefFuelCrossfeed,2)
sysFuel.fuelCrossFeed4 = TwoStateDrefSwitch:new("xfeed4",drefFuelCrossfeed,3)
sysFuel.fuelCrossFeed5 = TwoStateDrefSwitch:new("xfeed5",drefFuelCrossfeed,4)
sysFuel.fuelCrossFeed6 = TwoStateDrefSwitch:new("xfeed6",drefFuelCrossfeed,5)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed1)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed2)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed3)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed4)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed5)
sysFuel.fuelCrossFeed:addSwitch(sysFuel.fuelCrossFeed6)

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
		sysFuel.fuelCrossFeed1:actuate(1)
		sysFuel.fuelCrossFeed4:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysFuel.allFuelPumpGroup:actuate(1)
		if get("sim/flightmodel/weight/m_fuel") > 4500 then
			sysFuel.fuelPump5:actuate(1)
			sysFuel.fuelPump6:actuate(1)
		else
			sysFuel.fuelPump5:actuate(0)
			sysFuel.fuelPump6:actuate(0)
		end
		sysFuel.fuelCrossFeed:actuate(0)
		sysFuel.fuelCrossFeed1:actuate(1)
		sysFuel.fuelCrossFeed4:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysFuel.allFuelPumpGroup:actuate(0)
		sysFuel.fuelCrossFeed:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysFuel