-- DFLT airplane 
-- Hydraulic system functionality

-- @classmod sysHydraulic
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements
sysHydraulic.elecHydPumpGroup
		sysHydraulic.elecHydPump1
		sysHydraulic.elecHydPump2
sysHydraulic.engHydPumpGroup
		sysHydraulic.engHydPump1
		sysHydraulic.engHydPump2
		sysHydraulic.engHydPump3
		sysHydraulic.engHydPump4
sysHydraulic.PTU
sysHydraulic.RAT
sysHydraulic.hydPressureGroup
	sysHydraulic.hydPressure1
	sysHydraulic.hydPressure2
sysHydraulic.hydraulicLowAnc
sysHydraulic.hydPressureLow
]]

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

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysHydraulicDefinitions")

----------- Switches

-- === HYD Electric Pumps
if kc_has_hyd_elec_pmps then
	sysHydraulic.elecHydPumpGroup 	= SwitchGroup:new("Elec Hyd Pumps")
	sysHydraulic.elecHydPump1 		= kc_setup_element(def.elecHydPump1)
	sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
	if kc_num_hyd_elec_pmps > 1 then
		sysHydraulic.elecHydPump2 	= kc_setup_element(def.elecHydPump2)
		sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump2)
	end
	if kc_num_hyd_elec_pmps > 2 then
		sysHydraulic.elecHydPump3 	= kc_setup_element(def.elecHydPump3)
		sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump3)
	end
else
	sysHydraulic.elecHydPumpGroup 	= SwitchGroup:new("Elec Hyd Pumps")
	sysHydraulic.elecHydPump1 		= kc_setup_element({etype=kc_swtype_inop, name="Elec Hyd Pump 1"})
	sysHydraulic.elecHydPumpGroup:addSwitch(sysHydraulic.elecHydPump1)
end

-- === HYD Engine Pumps
if kc_has_hyd_eng_pmps then
	sysHydraulic.engHydPumpGroup = SwitchGroup:new("Eng Hyd Pumps")
	sysHydraulic.engHydPump1	 = kc_setup_element(def.engHydPump1)
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
	if kc_num_hyd_eng_pmps > 1 then
		sysHydraulic.engHydPump2 = kc_setup_element(def.engHydPump2)
		sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump2)
	end
	if kc_num_hyd_eng_pmps > 2 then
		sysHydraulic.engHydPump3 = kc_setup_element(def.engHydPump3)
		sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump3)
	end
	if kc_num_hyd_eng_pmps > 3 then
		sysHydraulic.engHydPump4 = kc_setup_element(def.engHydPump4)
		sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump4)
	end
else
	sysHydraulic.engHydPumpGroup = SwitchGroup:new("Eng Hyd Pumps")
	sysHydraulic.engHydPump1 	 = kc_setup_element({etype=kc_swtype_inop, name="Eng Hyd Pump 1"})
	sysHydraulic.engHydPumpGroup:addSwitch(sysHydraulic.engHydPump1)
end

-- === PTU
if kc_has_PTU then
	sysHydraulic.PTU			 = kc_setup_element(def.PTU)
else
	sysHydraulic.PTU			 = kc_setup_element({etype=kc_swtype_inop, name="PTU"})
end

-- === RAT
if kc_has_RAT then
	sysHydraulic.RAT			 = kc_setup_element(def.RAT)
else
	sysHydraulic.RAT			 = kc_setup_element({etype=kc_swtype_inop, name="RAT"})
end

-- -------- Annunciators

-- === Hydraulic pressures
if kc_has_hyd_eng_pmps then
	sysHydraulic.hydPressureGroup		= SwitchGroup:new("Hydraulic Pressure")
	sysHydraulic.hydPressure1	 		= kc_setup_element(def.hydPressure1)
	sysHydraulic.hydPressureGroup:addSwitch(sysHydraulic.hydPressure1)
	if kc_num_hyd_eng_pmps > 1 then
		sysHydraulic.hydPressure2 = kc_setup_element(def.hydPressure2)
		sysHydraulic.hydPressureGroup:addSwitch(sysHydraulic.hydPressure2)
	end
	if kc_num_hyd_eng_pmps > 2 then
		sysHydraulic.hydPressure3 = kc_setup_element(def.hydPressure3)
		sysHydraulic.hydPressureGroup:addSwitch(sysHydraulic.hydPressure3)
	end
else
	sysHydraulic.hydPressureGroup		= SwitchGroup:new("Hydraulic Pressure")
	sysHydraulic.hydPressure1	 		= kc_setup_element({etype=kc_swtype_inop, name="Hyd Pressure 1"})
	sysHydraulic.hydPressureGroup:addSwitch(sysHydraulic.hydPressure1)
end	

-- === LOW HYDRAULIC annunciator
sysHydraulic.hydraulicLowAnc = kc_setup_element(def.hydraulicLowAnc)

--------- Macros

-- ====================================== Hydraulic system flight phase 
function kc_macro_hyd(flightphase)
	logMsg("Hydraulic flight phase: " .. kcSopFlightPhase[flightphase])

	if flightphase == kc_phase_colddark then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(0) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(0) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(0) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(1) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(0) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(0) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_before_start then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(1) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(1) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(1) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_after_start then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(0) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(1) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(1) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_climb then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(0) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(1) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(1) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_landing then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(0) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(1) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(1) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	elseif flightphase == kc_phase_shutdown then
		if kc_has_hyd_elec_pmps == true then sysHydraulic.elecHydPumpGroup:actuate(1) end 
		if kc_has_hyd_eng_pmps == true then sysHydraulic.engHydPumpGroup:actuate(0 ) end
		if kc_has_ptu == true then sysHydraulic.PTU:actuate(1) end
		if kc_has_rat == true then sysHydraulic.RTA:actuate(0) end
	else
		logMsg("Invalid flightphase")
	end	
end

return sysHydraulic