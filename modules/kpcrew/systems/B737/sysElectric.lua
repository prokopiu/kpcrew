-- B737 airplane 
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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

logMsg("B737 sysElectric")

--------- Macros

function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,6)
		sysElectric.gpuConnect:actuate(1)
		sysElectric.gpuGenBusGroup:actuate(1)
		command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
		command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	command_once("laminar/B738/toggle_switch/apu_gen1_dn")
	command_once("laminar/B738/toggle_switch/apu_gen1_dn")
	command_once("laminar/B738/toggle_switch/apu_gen2_dn")
	command_once("laminar/B738/toggle_switch/apu_gen2_dn")
	sysAir.apuBleedSwitch:actuate(1)
	kc_procvar_set(trigger,false)
end

-- APU start background
function kc_macro_apustop()
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	sysAir.apuBleedSwitch:actuate(0)
end

return sysElectric
