-- B742 airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysHydraulic.elecHydPumpGroup
-- sysHydraulic.engHydPumpGroup
-- sysHydraulic.engHydPump1
-- sysHydraulic.engHydPump2
-- sysHydraulic.engHydPump3
-- sysHydraulic.engHydPump4
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

logMsg("B742 sysHydraulic")

--------- Switch datarefs common
local drefElecHydPump		= "B742/HYD/elec_pump_sys4_sw"
local drefElecHydPumpCap	= "B742/HYD/elec_pump_sys4_cap"
local drefEngHydPump1		= "B742/HYD/eng_pump_sw"

----------- Switches

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = TwoStateCustomSwitch:new("elechydpump",drefElecHydPump,0,
	function ()
		set(drefElecHydPump,1)
		set(drefElecHydPumpCap,1)
	end,
	function ()
		set(drefElecHydPump,0)
		set(drefElecHydPumpCap,0)
	end,
	function ()
		if get(drefElecHydPump) == 0 then
			set(drefElecHydPump,1)
			set(drefElecHydPumpCap,1)
		else
			set(drefElecHydPump,0)
			set(drefElecHydPumpCap,0)
		end
	end,
	function () return get(drefElecHydPump) end)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1",drefEngHydPump1,-1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
sysHydraulic.engHydPump2	= TwoStateDrefSwitch:new("enghydpump2",drefEngHydPump1,1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3",drefEngHydPump1,2)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4",drefEngHydPump1,3)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)

--------- Macros

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(0)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_turnaround then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_before_start then
		sysHydraulic.elecHydPumpGroup:actuate(1)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	elseif flightphase == kc_phase_after_start then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_climb then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_landing then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,1)
		set_array("B742/HYD/air_pump_sw",1,1)
		set_array("B742/HYD/air_pump_sw",2,1)
		set_array("B742/HYD/air_pump_sw",3,1)
	elseif flightphase == kc_phase_shutdown then
		sysHydraulic.elecHydPumpGroup:actuate(0)
		sysHydraulic.engHydPumpGroup:actuate(1)
		set_array("B742/HYD/air_pump_sw",0,0)
		set_array("B742/HYD/air_pump_sw",1,0)
		set_array("B742/HYD/air_pump_sw",2,0)
		set_array("B742/HYD/air_pump_sw",3,0)
	else
		logMsg("Invalid flightphase")
	end	
end

return sysHydraulic