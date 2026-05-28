-- DFLT airplane 
-- Fuel related functionality

-- @classmod sysFuel
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements:
sysFuel.allFuelPumpGroup
	sysFuel.fuelPump1
	sysFuel.fuelPump2
	sysFuel.fuelPump3
	sysFuel.fuelPump4
	sysFuel.fuelPump5
	sysFuel.fuelPump6
	sysFuel.fuelPump7
	sysFuel.fuelPump8
	sysFuel.fuelPump9
	sysFuel.fuelPump10
	sysFuel.fuelPump11
	sysFuel.fuelPump12
	sysFuel.fuelPump13
	sysFuel.fuelPump14
	sysFuel.fuelPump15
	sysFuel.fuelPump16
	sysFuel.fuelPump17
	sysFuel.fuelPump18
	sysFuel.fuelPump19
	sysFuel.fuelPump20
sysFuel.fuelXFeedGroup
	sysFuel.xfeedSwitch1
	sysFuel.xfeedSwitch2
	sysFuel.xfeedSwitch3
sysFuel.fuelSwitchGroup
	sysFuel.fuelSwitch1
	sysFuel.fuelSwitch2
	sysFuel.fuelSwitch3
	sysFuel.fuelSwitch4

sysFuel.centerTankLbs
sysFuel.centerTankKgs
sysFuel.allTanksLbs 
sysFuel.allTanksKgs 
	
sysFuel.fuel_balanced()
sysFuel.fuelLowAnc
sysFuel.auxFuelPumpsAnc

Macro: kc_macro_fuel
]]

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

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysFuelDefinitions")

-- **Fuel pumps
if kc_has_fuel_pumps then
	sysFuel.allFuelPumpGroup= SwitchGroup:new("All fuelpumps group")
	sysFuel.fuelPump1 		= kc_setup_element(def.fuelPump1)
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelpump1)
	if kc_num_fuel_pumps > 1 then
		sysFuel.fuelPump2 	= kc_setup_element(def.fuelPump2)
		sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump2)
		-- sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelpump1)
	end
	if kc_num_fuel_pumps > 2 then
		sysFuel.fuelPump3	= kc_setup_element(def.fuelPump3)
		sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump3)
	end
	if kc_num_fuel_pumps > 3 then
		sysFuel.fuelPump4	= kc_setup_element(def.fuelPump4)
		sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelPump4)
	end
else
	sysFuel.allFuelPumpGroup= SwitchGroup:new("All fuelpumps group")
	sysFuel.fuelPump1 		= kc_setup_element({etype=kc_swtype_inop, name="Fuel pump 1"})
	sysFuel.allFuelPumpGroup:addSwitch(sysFuel.fuelpump1)
end

-- Fuel xfeed
if kc_has_fuel_xfeed then
	sysFuel.fuelCrossfeedGroup= SwitchGroup:new("Fuel xfeed group")
	sysFuel.xfeedSwitch1 	= kc_setup_element(def.xfeedSwitch1)
	sysFuel.fuelCrossfeedGroup:addSwitch(sysFuel.xfeedSwitch1)
	if kc_num_fuel_xfeed > 1 then
		sysFuel.xfeedSwitch2 	= kc_setup_element(def.xfeedSwitch2)
		sysFuel.fuelCrossfeedGroup:addSwitch(sysFuel.xfeedSwitch2)
	end
	if kc_num_fuel_xfeed > 2 then
		sysFuel.xfeedSwitch3 	= kc_setup_element(def.xfeedSwitch3)
		sysFuel.fuelCrossfeedGroup:addSwitch(sysFuel.xfeedSwitch3)
	end
else
	sysFuel.fuelCrossfeedGroup= SwitchGroup:new("Fuel xfeed group")
	sysFuel.xfeedSwitch1 	= kc_setup_element({etype=kc_swtype_inop, name="Fuel xfeed 1"})
	sysFuel.fuelCrossfeedGroup:addSwitch(sysFuel.xfeedSwitch1)
end

-- Fuel cutoff switches
if kc_has_fuel_cutoff then 
	sysFuel.fuelSwitchGroup 	= SwitchGroup:new("fuel switch group")
	sysFuel.fuelSwitch1			= kc_setup_element(def.fuelSwitch1)
	sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch1)
	if kc_num_fuel_cutoff > 1 then
		sysFuel.fuelSwitch2 	= kc_setup_element(def.fuelSwitch2)
		sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch2)
	end
	if kc_num_fuel_cutoff > 2 then
		sysFuel.fuelSwitch3	= kc_setup_element(def.fuelSwitch3)
		sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch3)
	end
	if kc_num_fuel_cutoff > 3 then
		sysFuel.fuelSwitch4	= kc_setup_element(def.fuelSwitch4)
		sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch4)
	end
else
	sysFuel.fuelSwitchGroup 	= SwitchGroup:new("fuel switch group")
	sysFuel.fuelSwitch1			= kc_setup_element({etype=kc_swtype_inop, name="Fuel cutoff 1"})
	sysFuel.fuelSwitchGroup:addSwitch(sysFuel.fuelSwitch1)
end

-- get number of tanks
function kc_get_nr_tanks()
	if kc_NumTanks == -1 then kc_NumTanks = get("sim/aircraft/overflow/acf_num_tanks") end
	return kc_NumTanks
end

-- FUEL PRESSURE LOW annunciator
sysFuel.fuelLowAnc = kc_setup_element(def.fuelLowAnc)

-- AUX FUEL PUMP ANC
sysFuel.auxFuelPumpsAnc = kc_setup_element(def.auxFuelPumpsAnc)

-- Check if fuel is inbalanced
function sysFuel.fuel_balanced()
	local tank1 = get("sim/cockpit2/fuel/fuel_quantity",kc_FuelTankLeftInd) 
	local tank2 = get("sim/cockpit2/fuel/fuel_quantity",kc_FuelTankRghtInd) 
	return math.abs(tank1-tank2) < 100
end

---------- Macros

function kc_macro_fuel(flightphase)
	logMsg("Fuel flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_fuel_pumps then sysFuel.allFuelPumpGroup:actuate(0) end
		if kc_has_fuel_xfeed then sysFuel.fuelCrossfeedGroup:actuate(0) end
		if kc_has_fuel_select then sysFuel.fuelSwitchGroup:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_fuel_pumps then sysFuel.allFuelPumpGroup:actuate(0) end
		if kc_has_fuel_xfeed then sysFuel.fuelCrossfeedGroup:actuate(0) end
		if kc_has_fuel_select then sysFuel.fuelSwitchGroup:actuate(0) end
	elseif flightphase == kc_phase_before_start then
		if kc_has_fuel_pumps then sysFuel.allFuelPumpGroup:actuate(1) end
		if kc_has_fuel_xfeed then sysFuel.fuelCrossfeedGroup:actuate(0) end
		if kc_has_fuel_select then sysFuel.fuelSwitchGroup:actuate(1) end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_fuel_pumps then sysFuel.allFuelPumpGroup:actuate(0) end
		if kc_has_fuel_xfeed then sysFuel.fuelCrossfeedGroup:actuate(0) end
		if kc_has_fuel_select then sysFuel.fuelSwitchGroup:actuate(0) end
	else
		logMsg("Invalid flightphase")
	end	
end

return sysFuel