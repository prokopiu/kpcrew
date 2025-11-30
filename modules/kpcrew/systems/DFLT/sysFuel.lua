-- DFLT airplane 
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

local sysFuel = {
}

logMsg("DFLT sysFuel")

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

--------- Switch datarefs common
local drefFuelPump1			= "sim/cockpit/engine/fuel_pump_on"
local drefFuelCrossfeed		= "sim/cockpit2/fuel/auto_crossfeed"

--------- Annunciator datarefs common
local drefFuelPressLow 		= "sim/cockpit2/annunciators/fuel_pressure_low"

--------- Switch commands common
local cmdFuelCrossfeedOn	= "sim/fuel/auto_crossfeed_on_open"
local cmdFuelCrossfeedOff	= "sim/fuel/auto_crossfeed_off"

---------- Switches

-- Fuel pumps
sysFuel.fuelPump1 		= TwoStateDrefSwitch:new ("fuelpump1",drefFuelPump1,-1)
sysFuel.fuelPump2 		= TwoStateDrefSwitch:new ("fuelpump2",drefFuelPump1,1)
sysFuel.fuelPump3	 	= TwoStateDrefSwitch:new ("fuelpump3",drefFuelPump1,2)
sysFuel.fuelPump4	 	= TwoStateDrefSwitch:new ("fuelpump4",drefFuelPump1,3)
sysFuel.allFuelPumpGroup= SwitchGroup:new("fuelpumpgroup")
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelpump1)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)

-- Fuel xfeed
sysFuel.fuelCrossFeed = TwoStateCmdSwitch:new("crossfeed",drefFuelCrossfeed,0,
	cmdFuelCrossfeedOn,cmdFuelCrossfeedOff,"nocommand")

-- Fuel Switches GA
sysFuel.fuelSwitch1			= InopSwitch:new("fuelswitch1")
sysFuel.fuelSwitchGroup 	= SwitchGroup:new("fuelswitches")
sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch1)

------------ Annunciators

-- Check if fuel is inbalanced
function sysFuel.fuel_balanced()
	local tank1 = get("sim/cockpit2/fuel/fuel_quantity",kc_FuelTankLeftInd) 
	local tank2 = get("sim/cockpit2/fuel/fuel_quantity",kc_FuelTankRghtInd) 
	return math.abs(tank1-tank2) < 100
end
	
-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = CustomAnnunciator:new("fuellow",
function ()
	if get(drefFuelPressLow,0) > 0 or get(drefFuelPressLow,1) > 0 or get(drefFuelPressLow,2) > 0 or get(drefFuelPressLow,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- AUX FUEL PUMP ANC
sysFuel.auxFuelPumpsAnc = CustomAnnunciator:new("auxfuel",
function ()
	if sysFuel.allFuelPumpGroup:getStatus() > 0 then 
		return 1
	else
		return 0
	end
end)

---------- Macros

-- ====================================== Fuel system flight phase 
function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(1)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_fuel_pumps then
			sysFuel.allFuelPumpGroup:actuate(0)
		end
		if kc_has_fuel_xfeed then
			sysFuel.fuelCrossFeed:actuate(0)
		end
		if kc_has_fuel_select then
			sysFuel.fuelSwitchGroup:actuate(0)
		end
	else
		logMsg("Invalid flightphase")
	end	
end

return sysFuel