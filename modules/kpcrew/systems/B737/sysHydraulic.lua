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

--------- Switch datarefs common
local drefElecHydPump1		= "laminar/B738/toggle_switch/electric_hydro_pumps1_pos"
local drefElecHydPump2		= "laminar/B738/toggle_switch/electric_hydro_pumps2_pos"
local drefEngHydPump1		= "laminar/B738/toggle_switch/hydro_pumps1_pos"
local drefEngHydPump2		= "laminar/B738/toggle_switch/hydro_pumps2_pos"

--------- Annunciator datarefs common
local drefHydPressure1 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

--------- Switch commands common
local cmdElecHydPmp1Tgl		= "laminar/B738/toggle_switch/electric_hydro_pumps1"
local cmdElecHydPmp2Tgl		= "laminar/B738/toggle_switch/electric_hydro_pumps2"
local cmdEngHydPmp1Tgl		= "laminar/B738/toggle_switch/hydro_pumps1"
local cmdEngHydPmp2Tgl		= "laminar/B738/toggle_switch/hydro_pumps2"

----------- Switches

sysHydraulic.elecHydPump1 	= TwoStateToggleSwitch:new("",drefElecHydPump1,0,cmdElecHydPmp1Tgl)
sysHydraulic.elecHydPump2 	= TwoStateToggleSwitch:new("",drefElecHydPump2,0,cmdElecHydPmp2Tgl)
sysHydraulic.elecHydPumpGroup = SwitchGroup:new("elechydpumps")
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

sysHydraulic.engHydPump1 	= TwoStateToggleSwitch:new("",drefEngHydPump1,0,cmdEngHydPmp1Tgl)
sysHydraulic.engHydPump2 	= TwoStateToggleSwitch:new("",drefEngHydPump2,0,cmdEngHydPmp2Tgl)
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)

sysHydraulic.hydPumpGroup 	= SwitchGroup:new("hydpumps")
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
sysHydraulic.hydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)

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