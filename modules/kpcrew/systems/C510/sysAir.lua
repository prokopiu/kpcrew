-- C510 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("C510 sysAir")

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysAirDefinitions")

sysAir.airCondSwitch 			= kc_setup_element(def.airCondSwitch)

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Air flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.engBleedGroup:actuate(0) 
		sysAir.recircSwitchGroup:actuate(0) 
		sysAir.tempSelectGroup:actuate(0) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_prel_preflight then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_preflight then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_taxi_rwy then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_before_takeoff then
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:setValue(2) 
		else
			sysAir.engBleedGroup:setValue(0) 
		end		
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_takeoff then
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:setValue(2) 
		else
			sysAir.engBleedGroup:setValue(0) 
		end		
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysAir.engBleedGroup:setValue(2) 
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_descent then
	elseif flightphase == kc_phase_arrival then
	elseif flightphase == kc_phase_approach then
		if activeBriefings:get("approach:bleeds") > 1 then 
			sysAir.engBleedGroup:setValue(2) 
		else
			sysAir.engBleedGroup:setValue(0) 
		end		
		sysAir.recircSwitchGroup:setValue(3) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(1)
		sysAir.airCondSwitch:actuate(1)
	elseif flightphase == kc_phase_landing then
	elseif flightphase == kc_phase_taxi_stand then
	elseif flightphase == kc_phase_afterland then
	elseif flightphase == kc_phase_shutdown then
		sysAir.engBleedGroup:setValue(0) 
		sysAir.recircSwitchGroup:setValue(0) 
		sysAir.tempSelectGroup:setValue(0.5) 
		sysAir.oxygenSwitch:actuate(0)
		sysAir.airCondSwitch:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end


return sysAir