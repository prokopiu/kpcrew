-- B737 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements:
-- sysAir.trimAirSwitch
-- sysAir.recircFanLeft
-- sysAir.recircFanRight
-- sysAir.recircSwitchGroup
-- sysAir.packLeftSwitch 
-- sysAir.packRightSwitch
-- sysAir.packSwitchGroup
-- sysAir.isoValveSwitch
-- sysAir.bleedEng1Switch
-- sysAir.bleedEng2Switch
-- sysAir.bleedEng3Switch
-- sysAir.bleedEng4Switch
-- sysAir.engBleedGroup
-- sysAir.apuBleedSwitch
-- sysAir.oxygenMaster


local sysAir = {
}

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

logMsg("B737 sysAir")

--------- Macros

-- Macro: Air system flight phase 
function kc_macro_air(flightphase)
	logMsg("Air flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveGroup:actuate(0)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenSwitch:actuate(0)
		sysAir.recircSwitchGroup:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
		sysAir.apuBleedSwitch:actuate(0)
		sysAir.tempSelectGroup:actuate(0)
	elseif flightphase == kc_phase_turnaround then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveGroup:actuate(0)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenSwitch:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		sysAir.tempSelectGroup:setValue(0.5)
	elseif flightphase == kc_phase_before_start then
		sysAir.packSwitchGroup:actuate(0)
		sysAir.isoValveGroup:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenSwitch:actuate(0)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysAir.packSwitchGroup:actuate(1)
		sysAir.isoValveGroup:actuate(1)
		sysAir.engBleedGroup:actuate(1)
		sysAir.oxygenSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
	elseif flightphase == kc_phase_before_takeoff then
		if activeBriefings:get("takeoff:packs") < 2 then 
			sysAir.packSwitchGroup:setValue(1)
		else
			sysAir.packSwitchGroup:setValue(0)
		end
		sysAir.isoValveGroup:actuate(1)
		if activeBriefings:get("takeoff:bleeds") > 1 then 
			sysAir.engBleedGroup:actuate(1) 
		else
			sysAir.engBleedGroup:actuate(0) 
		end
		sysAir.oxygenSwitch:actuate(1)
		sysAir.recircSwitchGroup:actuate(1)
		sysAir.trimAirSwitch:actuate(1)
		sysAir.apuBleedSwitch:actuate(0)
		sysAir.tempSelectGroup:setValue(0.5)
	elseif flightphase == kc_phase_takeoff then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenSwitch:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenSwitch:actuate(1)
	elseif flightphase == kc_phase_approach then
		sysAir.engBleedGroup:actuate(1) 
		sysAir.oxygenSwitch:actuate(1)
		if activeBriefings:get("approach:packs") == 1 then
			sysAir.packSwitchGroup:actuate(0)
		else
			sysAir.packSwitchGroup:actuate(1)
		end
		sysAir.trimAirSwitch:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysAir.packSwitchGroup:setValue(1)
		sysAir.engBleedGroup:actuate(0)
		sysAir.oxygenSwitch:actuate(0)
		sysAir.trimAirSwitch:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysAir