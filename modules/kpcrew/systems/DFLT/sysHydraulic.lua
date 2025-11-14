-- DFLT airplane 
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

local sysHydraulic = {
}

logMsg("DFLT sysHydraulic")

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
local drefElecHydPump		= "sim/cockpit2/switches/electric_hydraulic_pump_on"
local drefEngHydPump1		= "sim/cockpit2/hydraulics/actuators/engine_pump"

--------- Annunciator datarefs common
local drefHydPressure1 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1"
local drefHydPressure2 		= "sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2"

--------- Switch commands common


----------- Switches

-- --- HYD Electric Pump
sysHydraulic.elecHydPumpGroup = TwoStateDrefSwitch:new("elechydpump",drefElecHydPump,0)

-- ----- HYD Engine Pumps
sysHydraulic.engHydPumpGroup = SwitchGroup:new("enghydpumps")
sysHydraulic.engHydPump1	= TwoStateDrefSwitch:new("enghydpump1",drefEngHydPump1,-1)
sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
if kc_get_nr_engines() > 1 then
	sysHydraulic.engHydPump2 = TwoStateDrefSwitch:new("enghydpump2",drefEngHydPump1,1)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
end
if kc_get_nr_engines() > 2 then
	sysHydraulic.engHydPump3	= TwoStateDrefSwitch:new("enghydpump3",drefEngHydPump1,2)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
end
if kc_get_nr_engines() > 3 then
	sysHydraulic.engHydPump4	= TwoStateDrefSwitch:new("enghydpump4",drefEngHydPump1,3)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)
end

-- LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = CustomAnnunciator:new("hydrauliclow",
function ()
	if get(drefHydPressure1,0) == 1 or get(drefHydPressure2,0) == 1 then
		return 1
	else
		return 0
	end
end)

-- PTU / Transfer Pump
sysHydraulic.PTU			= InopSwitch:new("ptu")

-- hydraulic pressure
sysHydraulic.hydPressureLow	= CustomAnnunciator:new("hydpressurelow",
function ()  
	if get(drefHydPressure1) < 2800 then 
		return 1
	else
		return 0
	end
end)

--------- Macros

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(0)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(0)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(1)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(0)
		end
	elseif flightphase == kc_phase_before_start then
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(1)
		end 
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(1)
		end
	elseif flightphase == kc_phase_after_start then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(0)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(1)
		end
	elseif flightphase == kc_phase_climb then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(0)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(0)
		end
	elseif flightphase == kc_phase_landing then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(0)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(1)
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_hyd_elec_pmps == true then
			sysHydraulic.elecHydPumpGroup:actuate(0)
		end 
		if kc_has_hyd_eng_pmps == true then
			sysHydraulic.engHydPumpGroup:actuate(1)
		end
		if kc_has_ptu == true then
			sysHydraulic.PTU:actuate(0)
		end
	else
		logMsg("Invalid flightphase")
	end	
end

return sysHydraulic