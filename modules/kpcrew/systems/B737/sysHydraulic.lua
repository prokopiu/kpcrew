-- B737 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysHydraulic.elecHydPumpGroup
-- sysHydraulic.engHydPumpGroup
-- sysHydraulic.engHydPump1
-- sysHydraulic.engHydPump2
-- sysHydraulic.engHydPump3
-- sysHydraulic.engHydPump4
-- sysHydraulic.hydraulicLowAnc
-- sysHydraulic.hydPressureLow
-- sysHydraulic.PTU
-- Macro: kc_macro_hyd

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

sysHydraulic = require("kpcrew.systems.DFLT.sysHydraulic")

logMsg("B737 sysHydraulic")

--------- Macros

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.engHydPumpGroup:actuate(1)
		sysHydraulic.elecHydPumpGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysHydraulic