-- DFLT  airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysElectric.batteryGroup 	
-- sysElectric.batterySwitch 	
-- sysElectric.battery2Switch 	
-- sysElectric.batt1Volt 
-- sysElectric.batt2Volt 
-- sysElectric.batt1Amp 
-- sysElectric.batt2Amp 
-- sysElectric.gpuGenBusGroup
-- sysElectric.gpuConnect
-- sysElectric.gpuGenBus1
-- sysElectric.gpuGenBus2
-- sysElectric.apuGenBusGroup
-- sysElectric.apuMaster	 
-- sysElectric.apuStartSwitch
-- sysElectric.apuGenBus1 	
-- sysElectric.apuGenBus2 	
-- sysElectric.apuRunningAnc
-- sysElectric.genSwitchGroup
-- sysElectric.gen1Switch
-- sysElectric.gen2Switch
-- sysElectric.gen3Switch
-- sysElectric.gen4Switch
-- sysElectric.dcBusTie	
-- sysElectric.acBusTie	
-- sysElectric.alternator1Switch 	
-- sysElectric.alternator2Switch 	
-- sysElectric.alternatorSwitchGroup
-- sysElectric.inverter1Switch 		
-- sysElectric.inverter2Switch 		
-- sysElectric.inverterSwitchGroup 	
-- sysElectric.avionics1Bus	
-- sysElectric.avionics2Bus	
-- sysElectric.avionicsSwitchGroup 
-- sysElectric.stbyPowerSwitch
-- sysElectric.lowVoltageAnc
-- sysElectric.gpuOnBus
-- Macro: kc_macro_elec_system
-- Macro: kc_bck_apustart
-- Macro: kc_bck_apuonline
-- Macro: kc_macro_apustop

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

--------- Switch datarefs common
local drefBattery1			= "sim/cockpit/electrical/battery_array_on"
local drefGPUOn				= "sim/cockpit/electrical/gpu_on"
local drefGPUGenerator		= "sim/cockpit2/electrical/GPU_generator_on"
local drefAPUStarter		= "sim/cockpit2/electrical/APU_starter_switch"
local drefAPUMaster			= "sim/cockpit2/electrical/APU_starter_switch"
local drefAPUGenerator		= "sim/cockpit/electrical/generator_apu_on"
local drefGenerator1		= "sim/cockpit/electrical/generator_on"
local drefDCBusTie			= "sim/cockpit2/electrical/cross_tie"
local drefInverter1			= "sim/cockpit/engine/inverter_on"
local drefAvionics1			= "sim/cockpit2/switches/avionics_power_on"

--------- Annunciator datarefs common
local drefBattery1Volt		= "sim/cockpit2/electrical/battery_voltage_actual_volts"
local drefBattery1Amps		= "sim/cockpit2/electrical/battery_amps"
local drefAPUN1				= "sim/cockpit/engine/APU_N1"
local drefLowVoltage		= "sim/cockpit2/annunciators/low_voltage"

--------- Switch commands common
local cmdGenerator1On		= "sim/electrical/generator_1_on"
local cmdGenerator2On		= "sim/electrical/generator_2_on"
local cmdGenerator1Off		= "sim/electrical/generator_1_off"	
local cmdGenerator2Off		= "sim/electrical/generator_2_off"	
local cmdGenerator1Tgl		= "sim/electrical/generator_1_toggle"
local cmdGenerator2Tgl		= "sim/electrical/generator_2_toggle"

logMsg("DFLT sysElectric")

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

----------- Switches

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1",drefBattery1,-1)
sysElectric.batteryGroup:addSwitch(batterySwitch)
if kc_get_nr_batteries() > 1 then
	sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2",drefBattery1,1)
	sysElectric.batteryGroup:addSwitch(battery2Switch)
end
if kc_get_nr_batteries() > 2 then
	sysElectric.battery3Switch 	= TwoStateDrefSwitch:new("battery3",drefBattery1,2)
	sysElectric.batteryGroup:addSwitch(battery3Switch)
end

-- Battery voltage and amps
sysElectric.batt1Volt 		= SimpleAnnunciator:new("BATT1 Voltage",drefBattery1Volt,-1)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("BATT2 Voltage",drefBattery1Volt,1)
sysElectric.batt1Amp 		= SimpleAnnunciator:new("BATT1 Amps",drefBattery1Amps,-1)
sysElectric.batt2Amp 		= SimpleAnnunciator:new("BATT2 Amps",drefBattery1Amps,1)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
if kc_has_gpu then
	sysElectric.gpuConnect 	= TwoStateCustomSwitch:new("GPU",drefGPUOn,0,
	function ()
		set(drefGPUOn,1)
		command_once("sim/ground_ops/service_plane") -- default GPU needs services connected
	end,
	function () set(drefGPUOn,0) end,
	function () end,
	function () return get(drefGPUOn) end)	
	sysElectric.gpuGenBus1 	= TwoStateDrefSwitch:new("gpubus1",drefGPUGenerator,0)
	sysElectric.gpuGenBus2 	= InopSwitch:new("gpubus2")
else
	sysElectric.gpuConnect 	= InopSwitch:new("GPU")
	sysElectric.gpuGenBus1 	= InopSwitch:new("gpubus1")
	sysElectric.gpuGenBus2 	= InopSwitch:new("gpubus2")
end
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
if kc_has_apu then
	sysElectric.apuMaster	= TwoStateDrefSwitch:new("apuswitch",drefAPUStarter,0)
	sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch",drefAPUMaster,0)
	sysElectric.apuGenBus1 	= TwoStateDrefSwitch:new("apubus1",drefAPUGenerator,0)
	sysElectric.apuGenBus2 	= InopSwitch:new("apubus2")
else
	sysElectric.apuMaster	= InopSwitch:new("apuswitch")
	sysElectric.apuStartSwitch 	= InopSwitch:new("apuswitch")
	sysElectric.apuGenBus1 	= InopSwitch:new("apubus1")
	sysElectric.apuGenBus2 	= InopSwitch:new("apubus2")
end
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () 
		if get(drefAPUN1) > 98 then
			return 1
		else
			return 0
		end
	end)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1",drefGenerator1,-1)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
if kc_get_nr_generators() > 1 then
	sysElectric.gen2Switch 	= TwoStateDrefSwitch:new("gen2",drefGenerator1,1)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
end
if kc_get_nr_generators() > 2 then
	sysElectric.gen3Switch 	= TwoStateDrefSwitch:new("gen3",drefGenerator1,2)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
end
if kc_get_nr_generators() > 3 then
	sysElectric.gen4Switch 	= TwoStateDrefSwitch:new("gen4",drefGenerator1,3)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)
end

-- DC Bus Tie
sysElectric.dcBusTie		= TwoStateDrefSwitch:new("dcbustie",drefDCBusTie,0)
-- AC Bus Tie
sysElectric.acBusTie				= InopSwitch:new("acbustie")

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= TwoStateCmdSwitch:new("gen1",drefGenerator1,-1,
	cmdGenerator1On,cmdGenerator1Off,cmdGenerator1Tgl)
sysElectric.alternator2Switch 		= TwoStateCmdSwitch:new("gen2",drefGenerator1,1,
	cmdGenerator2On,cmdGenerator1Off,cmdGenerator2Tgl)
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateDrefSwitch:new("inverter1",drefInverter1,-1)
sysElectric.inverter2Switch 		= TwoStateDrefSwitch:new("inverter2",drefInverter1,1)
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter2Switch)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateDrefSwitch:new("aviobus1",drefAvionics1,0)
sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- standby power
sysElectric.stbyPowerSwitch = InopSwitch:new("stbySwitch")

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage",drefLowVoltage,0)

sysElectric.gpuOnBus = SimpleAnnunciator:new("gpuonbus",drefGPUOn,0)

--------- Macros

-- Macro Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		sysElectric.genSwitchGroup:actuate(0)
		if kc_has_avionics_sw then
			sysElectric.avionicsSwitchGroup:actuate(0)
		end
		if kc_has_inv_ess_bus then
			sysElectric.inverterSwitchGroup:actuate(0)
		end
		if kc_has_bus_ties then
			sysElectric.dcBusTie:actuate(0)
			sysElectric.acBusTie:actuate(0)
		end
		sysElectric.batterySwitch:actuate(0) 
		if kc_NumBatteries > 1 then
			sysElectric.battery2Switch:actuate(0) 
		end
		if kc_get_nr_batteries() > 2 then
			sysElectric.battery3Switch:actuate(0) 
		end
		if kc_has_standby_pwr then
			sysElectric.stbyPowerSwitch:actuate(0)
		end
		if kc_is_airbus then
			sysElectric.gen1Switch:actuate(1)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(1)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(1)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(1)
			end
		else
			sysElectric.gen1Switch:actuate(0)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(0)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(0)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(0)
			end
		end	
	elseif flightphase == kc_phase_turnaround then
		sysElectric.genSwitchGroup:actuate(0)
		if kc_has_avionics_sw then
			sysElectric.avionicsSwitchGroup:actuate(1)
		end
		if kc_has_inv_ess_bus then
			if kc_is_airbus then
				sysElectric.inverterSwitchGroup:actuate(0)
			else
				sysElectric.inverterSwitchGroup:actuate(1)
			end
		end
		if kc_has_bus_ties then
			sysElectric.dcBusTie:actuate(1)
			sysElectric.acBusTie:actuate(1)
		end
		sysElectric.batterySwitch:actuate(1) 
		if kc_NumBatteries > 1 then
			sysElectric.battery2Switch:actuate(1) 
		end
		if kc_get_nr_batteries() > 2 then
			sysElectric.battery3Switch:actuate(1) 
		end
		if kc_has_standby_pwr then
			sysElectric.stbyPowerSwitch:actuate(1)
		end
		if kc_is_airbus then
			sysElectric.gen1Switch:actuate(1)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(1)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(1)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(1)
			end
		else
			sysElectric.gen1Switch:actuate(0)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(0)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(0)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(0)
			end
		end	
	elseif flightphase == kc_phase_after_start then
		if kc_is_airbus then
			sysElectric.gen1Switch:actuate(1)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(1)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(1)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(1)
			end
		else
			sysElectric.gen1Switch:actuate(1)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(1)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(1)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(1)
			end	
		end
	elseif flightphase == kc_phase_shutdown then
		if kc_is_airbus then
			sysElectric.gen1Switch:actuate(1)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(1)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(1)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(1)
			end
		else
			sysElectric.gen1Switch:actuate(0)
			if kc_get_nr_generators() > 1 then
				sysElectric.gen2Switch:actuate(0)
			end
			if kc_get_nr_generators() > 2 then
				sysElectric.gen3Switch:actuate(0)
			end
			if kc_get_nr_generators() > 3 then
				sysElectric.gen4Switch:actuate(0)
			end	
		end
		if kc_has_avionics_sw then
			sysElectric.avionicsSwitchGroup:actuate(1)
		end
		if kc_has_standby_pwr then
			sysElectric.stbyPowerSwitch:actuate(0)
		end
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
		sysElectric.apuStartSwitch:setValue(2)
	else
		if kc_procvar_get(delayvar) <= 0 then
			sysElectric.apuStartSwitch:setValue(1)
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
	sysElectric.apuMaster:setValue(0)
end

return sysElectric