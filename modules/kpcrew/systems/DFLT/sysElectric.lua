-- DFLT  airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements:
sysElectric.btGroup 	
	sysElectric.btSwitch1 	
	sysElectric.btSwitch2 
	sysElectric.btSwitch3 	
sysElectric.genSwitchGroup
	sysElectric.genSwitch1
	sysElectric.genSwitch2
	sysElectric.genSwitch3
	sysElectric.genSwitch4
sysElectric.inverterSwitchGroup
	sysElectric.inverterSwitch1 		
	sysElectric.inverterSwitch2 		
sysElectric.gpuConnect
sysElectric.gpuGenBusGroup
	sysElectric.gpuGenBus1
	sysElectric.gpuGenBus2	
sysElectric.apuStart
sysElectric.apuMaster	 
sysElectric.apuGenBusGroup
	sysElectric.apuGenBus1 	
	sysElectric.apuGenBus2 	
sysElectric.stbyPowerGroup
	sysElectric.stbyPowerSwitch1
	sysElectric.stbyPowerSwitch2
sysElectric.avionicsSwitchGroup
	sysElectric.avionicsBus1
	sysElectric.avionicsBus2
sysElectric.dcBusTie
sysElectric.acBusTie
]]

local sysElectric = {
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

logMsg("DFLT sysElectric")

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysElectricDefinitions")

----------- Switches

-- === ** BATTERY Switches
if kc_has_batteries then
	sysElectric.btGroup 	= SwitchGroup:new("Battery switches")
	sysElectric.btSwitch1 	= kc_setup_element(def.btSwitch1)
	sysElectric.btGroup:addSwitch(sysElectric.btSwitch1)
	if kc_num_batteries > 1 then
		sysElectric.btSwitch2 	= kc_setup_element(def.btSwitch2)
		sysElectric.btGroup:addSwitch(sysElectric.btSwitch2)
	end
	if kc_num_batteries > 2 then
		sysElectric.btSwitch3 	= kc_setup_element(def.btSwitch3)
		sysElectric.btGroup:addSwitch(sysElectric.btSwitch3)
	end
else
	sysElectric.btGroup 	= SwitchGroup:new("Battery switches")
	sysElectric.btSwitch1 	= kc_setup_element({etype=kc_swtype_inop, name="battery1"})
	sysElectric.btGroup:addSwitch(sysElectric.btSwitch1)	
end

-- === Engine Generators
if kc_has_generators then
	sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
	sysElectric.genSwitch1 		= kc_setup_element(def.genSwitch1)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.genSwitch1)
	if kc_num_generators > 1 then
		sysElectric.genSwitch2 	= kc_setup_element(def.genSwitch2)
		sysElectric.genSwitchGroup:addSwitch(sysElectric.genSwitch2)
	end
	if kc_num_generators > 2 then
		sysElectric.genSwitch3 	= kc_setup_element(def.genSwitch3)
		sysElectric.genSwitchGroup:addSwitch(sysElectric.genSwitch3)
	end
	if kc_num_generators > 3 then
		sysElectric.genSwitch4 	= kc_setup_element(def.genSwitch4)
		sysElectric.genSwitchGroup:addSwitch(sysElectric.genSwitch4)
	end
else
	sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
	sysElectric.genSwitch1 		= kc_setup_element({etype=kc_swtype_inop, name="gen1"})
	sysElectric.genSwitchGroup:addSwitch(sysElectric.genSwitch1)
end

-- === Inverters
if kc_has_inverters then
	sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
	sysElectric.inverterSwitch1 		= kc_setup_element(def.inverterSwitch1)
	sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverterSwitch1)
	if kc_num_inverters > 1 then
		sysElectric.inverterSwitch2 		= kc_setup_element(def.inverterSwitch2)
		sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverterSwitch2)
	end
else
	sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
	sysElectric.inverterSwitch1 		= kc_setup_element({etype=kc_swtype_inop, name="Inverter 1"})
	sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverterSwitch1)
end

-- === GPU 
if kc_has_gpu then
	sysElectric.gpuConnect 	= kc_setup_element(def.gpuConnect)
	if kc_has_gpu_gens then
		sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
		sysElectric.gpuGenBus1 	= kc_setup_element(def.gpuGenBus1)
		sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
		if kc_num_gpu_gens > 1 then
			sysElectric.gpuGenBus2 	= kc_setup_element(def.gpuGenBus2)
			sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)
		end
	end
	sysElectric.gpuOnBus = kc_setup_element(def.gpuOnBus)
else
	sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
	sysElectric.gpuConnect 	= kc_setup_element({etype=kc_swtype_inop, name="gpuconnect"})
	sysElectric.gpuGenBus1 	= kc_setup_element({etype=kc_swtype_inop, name="gpubus1"})
	sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
	sysElectric.gpuOnBus	= kc_setup_element({etype=kc_swtype_inop, name="gpuonbus"})
end

-- === APU
if kc_has_apu then
	sysElectric.apuStart 	= kc_setup_element(def.apuStart)
	if kc_has_apu_master then 
		sysElectric.apuMaster	= kc_setup_element(def.apuMaster)
	end
	if kc_has_apu_gens then
		sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
		sysElectric.apuGenBus1 	= kc_setup_element(def.apuGenBus1)
		sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
		if kc_num_apu_gens > 1 then
			sysElectric.apuGenBus2 	= kc_setup_element(def.apuGenBus2)
			sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)
		end
	end
else
	sysElectric.apuStart	= kc_setup_element({etype=kc_swtype_inop, name="apustart"})
	sysElectric.apuMaster	= kc_setup_element({etype=kc_swtype_inop, name="apumaster"})
	sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
	sysElectric.apuGenBus1 	= kc_setup_element({etype=kc_swtype_inop, name="apu gen bus 1"})
	sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
end

-- === Standby power
if kc_has_standby_pwr then
	sysElectric.stbyPowerGroup = SwitchGroup:new("Standby Power Group")
	sysElectric.stbyPowerSwitch1 = kc_setup_element(def.stbyPowerSwitch1)
	sysElectric.stbyPowerGroup:addSwitch(sysElectric.stbyPowerSwitch1)
	if kc_num_standby_pwr > 1 then
		sysElectric.stbyPowerSwitch2 = kc_setup_element(def.stbyPowerSwitch2)
		sysElectric.stbyPowerGroup:addSwitch(sysElectric.stbyPowerSwitch2)
	end
else
	sysElectric.stbyPowerGroup = SwitchGroup:new("Standby Power Group")
	sysElectric.stbyPowerSwitch1 = kc_setup_element({etype=kc_swtype_inop, name="stby switch 1"})
	sysElectric.stbyPowerGroup:addSwitch(sysElectric.stbyPowerSwitch1)
end

-- === ** Avionics Buses
if kc_has_avionics_sw then
	sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
	sysElectric.avionicsBus1		= kc_setup_element(def.avionicsBus1)
	sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionicsBus1)
	if kc_num_avionics_sw > 1 then
		sysElectric.avionicsBus2		= kc_setup_element(def.avionicsBus2)
		sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionicsBus2)
	end
else
	sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
	sysElectric.avionicsBus1		= kc_setup_element({etype=kc_swtype_inop, name="avio bus 1"})
	sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionicsBus1)
end

-- === DC/AC Bus Tie
if kc_has_bus_ties then
	sysElectric.dcBusTie		= kc_setup_element(def.dcBusTie)
	sysElectric.acBusTie		= kc_setup_element(def.acBusTie)
else
	sysElectric.dcBusTie		= kc_setup_element({etype=kc_swtype_inop, name="dc bus tie"})
	sysElectric.acBusTie		= kc_setup_element({etype=kc_swtype_inop, name="ac bus tie"})
end

--------- Annunciators

-- === APU RUNNING annunciator
sysElectric.apuRunningAnc 	= kc_setup_element(def.apuRunningAnc)

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= kc_setup_element(def.lowVoltageAnc)

--------- Macros

-- Macro Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		if kc_is_airbus then sysElectric.genSwitchGroup:actuate(1) else sysElectric.genSwitchGroup:actuate(0) end
		if kc_has_avionics_sw then sysElectric.avionicsSwitchGroup:actuate(0) end
		if kc_has_inverters then sysElectric.inverterSwitchGroup:actuate(0) end
		if kc_has_bus_ties then sysElectric.dcBusTie:actuate(0) sysElectric.acBusTie:actuate(0) end
		if kc_has_batteries then sysElectric.btGroup:actuate(0) end
		if kc_has_standby_pwr then sysElectric.stbyPowerGroup:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		if kc_has_avionics_sw then sysElectric.avionicsSwitchGroup:actuate(1) end
		if kc_has_inverters then
			if kc_is_airbus then sysElectric.inverterSwitchGroup:actuate(0) else sysElectric.inverterSwitchGroup:actuate(1) end
		end
		if kc_has_bus_ties then sysElectric.dcBusTie:actuate(1) sysElectric.acBusTie:actuate(1) end
		if kc_has_batteries then sysElectric.btGroup:actuate(1) end
		if kc_is_airbus then sysElectric.genSwitchGroup:actuate(1) else sysElectric.genSwitchGroup:actuate(0) end
		if kc_has_standby_pwr then sysElectric.stbyPowerGroup:actuate(1) end
	elseif flightphase == kc_phase_before_start then
		if kc_has_avionics_sw then sysElectric.avionicsSwitchGroup:actuate(1) end
		if kc_has_inverters then
			if kc_is_airbus then sysElectric.inverterSwitchGroup:actuate(0) else sysElectric.inverterSwitchGroup:actuate(1) end
		end
		if kc_has_bus_ties then sysElectric.dcBusTie:actuate(1) sysElectric.acBusTie:actuate(1) end
		if kc_has_batteries then sysElectric.btGroup:actuate(1) end
		if kc_is_airbus then sysElectric.genSwitchGroup:actuate(1) else sysElectric.genSwitchGroup:actuate(0) end
		if kc_has_standby_pwr then sysElectric.stbyPowerGroup:actuate(1) end
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
	elseif flightphase == kc_phase_shutdown then
		if kc_is_airbus then sysElectric.genSwitchGroup:actuate(1) else sysElectric.genSwitchGroup:actuate(0) end
		if kc_has_avionics_sw then sysElectric.avionicsSwitchGroup:actuate(1) end
		if kc_has_standby_pwr then sysElectric.stbyPowerGroup:actuate(1) end
	else
		logMsg("Invalid flightphase")
	end	
end

-- Macro: APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		sysElectric.apuStart:setValue(2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStart:setValue(1)
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Macro: bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get(drefAPUN1) == 100 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- APU start background
function kc_macro_apustop()
	sysElectric.apuGenBusGroup:actuate(0)
	sysAir.apuBleedSwitch:actuate(0)
	sysElectric.apuStart:setValue(0)
end

return sysElectric