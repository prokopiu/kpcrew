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


--------- Switch datarefs common
local drefBattery1			= "laminar/B738/electric/battery_pos"
local drefBattery1Cap		= "laminar/B738/button_switch/cover_position"
local drefGPUOn				= "laminar/B738/gpu_available"
local drefGPUGenerator		= "sim/cockpit2/electrical/GPU_generator_on"
local drefAPUStarter		= "laminar/B738/spring_toggle_switch/APU_start_pos"
local drefAPUGenerator1		= "laminar/B738/electrical/apu_gen1_pos"
local drefAPUGenerator2		= "laminar/B738/electrical/apu_gen2_pos"
local drefGenerator1		= "laminar/B738/electrical/gen1_pos"
local drefGenerator2		= "laminar/B738/electrical/gen2_pos"
local drefStbyPower			= "laminar/B738/electric/standby_bat_pos"
local drefStbyPowerCap		= "laminar/B738/button_switch/cover_position"

local drefDCBusTie			= "sim/cockpit2/electrical/cross_tie"
local drefInverter1			= "sim/cockpit/engine/inverter_on"
local drefAvionics1			= "sim/cockpit2/switches/avionics_power_on"

--------- Annunciator datarefs common
local drefBattery1On		= "sim/cockpit/electrical/battery_on"
local drefAPUN1				= "laminar/B738/annunciator/apu_gen_off_bus"

local drefBattery1Volt		= "sim/cockpit2/electrical/battery_voltage_actual_volts"
local drefBattery1Amps		= "sim/cockpit2/electrical/battery_amps"

local drefLowVoltage		= "sim/cockpit2/annunciators/low_voltage"

--------- Switch commands common
local cmdBattery1Dn			= "laminar/B738/switch/battery_dn"
local cmdBattery1Up			= "laminar/B738/switch/battery_up"
local cmdBattery1Off		= "laminar/B738/push_button/batt_full_off"
local cmdBattery1CapTgl		= "laminar/B738/button_switch_cover02"
local cmdGPUTgl				= "laminar/B738/gpu_toggle"
local cmdGPUGen1Up			= "laminar/B738/toggle_switch/gpu_up"
local cmdGPUGen1Dn			= "laminar/B738/toggle_switch/gpu_dn"
local cmdAPUStartDn			= "laminar/B738/spring_toggle_switch/APU_start_pos_dn"
local cmdAPUStartUp			= "laminar/B738/spring_toggle_switch/APU_start_pos_up"
local cmdAPUGen1Dn			= "laminar/B738/toggle_switch/apu_gen1_dn"
local cmdAPUGen1Up			= "laminar/B738/toggle_switch/apu_gen1_up"
local cmdAPUGen2Dn			= "laminar/B738/toggle_switch/apu_gen2_dn"
local cmdAPUGen2Up			= "laminar/B738/toggle_switch/apu_gen2_up"
local cmdGenerator1Dn		= "laminar/B738/toggle_switch/gen1_dn"
local cmdGenerator2Dn		= "laminar/B738/toggle_switch/gen2_dn"
local cmdGenerator1Up		= "laminar/B738/toggle_switch/gen1_up"	
local cmdGenerator2Up		= "laminar/B738/toggle_switch/gen2_up"
local cmdStbySwRight		= "laminar/B738/switch/standby_bat_right"	
local cmdStbySwLeft			= "laminar/B738/switch/standby_bat_left"
local cmdStbyCapTgl			= "laminar/B738/button_switch_cover03"


----------- Switches

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1",drefBattery1,0,
	function () 
		command_once(cmdBattery1Dn)
		if get(drefBattery1Cap,2) ~= 0 then command_once(cmdBattery1CapTgl) end
	end,
	function ()
		if get(drefBattery1Cap,2) == 0 then command_once(cmdBattery1CapTgl) end
		command_once(cmdBattery1Off)
	end,
	function ()
		if get(drefBattery1On,0) == 0 then
			command_once(cmdBattery1Dn)
			if get(drefBattery1Cap,2) ~= 0 then command_once(cmdBattery1CapTgl) end
		else
			command_once(cmdBattery1Off)
			if get(drefBattery1Cap,2) == 0 then command_once(cmdBattery1CapTgl) end
		end
	end,
	function () if get(drefBattery1,0) == 1 then return 1 else return 0 end end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
-- de-/activate GPU
sysElectric.gpuConnect 	= TwoStateCustomSwitch:new("GPU",drefGPUOn,0,
	function () if get(drefGPUOn) == 0 then command_once(cmdGPUTgl) end end,
	function () if get(drefGPUOn) == 1 then command_once(cmdGPUTgl) end end,
	function () command_once(cmdGPUTgl) end,
	function () return get(drefGPUOn) end)	
sysElectric.gpuGenBus1 	= TwoStateCmdSwitch:new("gpubus1",drefGPUGenerator,0,cmdGPUGen1Dn, cmdGPUGen1Up, "nocommand")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuOnBus = SimpleAnnunciator:new("gpuonbus",drefGPUOn,0)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuMaster 	= MultiStateCmdSwitch:new("apustart",drefAPUStarter,0,cmdAPUStartDn,cmdAPUStartUp,-1,1,true)
sysElectric.apuStartSwitch 	= MultiStateCmdSwitch:new("apustart",drefAPUStarter,0,cmdAPUStartDn,cmdAPUStartUp,-1,1,true)
sysElectric.apuGenBus1 		= MultiStateCmdSwitch:new("apubus1",drefAPUGenerator1,0,cmdAPUGen1Up,cmdAPUGen1Dn,-1,1,true)
sysElectric.apuGenBus2 		= MultiStateCmdSwitch:new("apubus2",drefAPUGenerator2,0,cmdAPUGen2Up,cmdAPUGen2Dn,-1,1,true)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () if get(drefAPUN1) > 0 then return 1 else return 0 end end)
	
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

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1",drefGenerator1,0,
	function () command_once(cmdGenerator1Dn) command_once(cmdGenerator1Dn) end,
	function () command_once(cmdGenerator1Up) command_once(cmdGenerator1Up) end,
	function () end,
	function () return get("sim/cockpit/electrical/generator_on",0) end)
sysElectric.gen2Switch 		= TwoStateCustomSwitch:new("gen2",drefGenerator1,0,
	function () command_once(cmdGenerator2Dn) command_once(cmdGenerator2Dn) end,
	function () command_once(cmdGenerator2Up) command_once(cmdGenerator2Up) end,
	function () end,
	function () return get("sim/cockpit/electrical/generator_on",1) end)
-- sysElectric.gen1Switch 		= MultiStateCmdSwitch:new("gen1",drefGenerator1,0,cmdGenerator1Dn,cmdGenerator1Up,-1,1,true)
-- sysElectric.gen2Switch 		= MultiStateCmdSwitch:new("gen2",drefGenerator2,0,cmdGenerator2Dn,cmdGenerator2Up,-1,1,true)
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- Standby Power
sysElectric.stbyPowerSwitch	= TwoStateCustomSwitch:new("stbypwr",drefStbyPower,0,
	function ()
		command_once("laminar/B738/switch/standby_bat_on")
		if get(drefStbyPowerCap,3) ~= 0 then command_once(cmdStbyCapTgl) end
	end,
	function ()
		if get(drefStbyPowerCap,3) == 0 then command_once(cmdStbyCapTgl) end
		command_once("laminar/B738/switch/standby_bat_off")
	end,
	function ()
		if get(drefStbyPower) == 0 then 
			command_once(cmdStbySwRight)
			if get(drefStbyPowerCap,3) ~= 0 then command_once(cmdStbyCapTgl) end
		else
			command_once(cmdStbySwLeft)
			if get(drefStbyPowerCap,3) == 0 then command_once(cmdStbyCapTgl) end
		end
	end,
	function () if get(drefStbyPower) == 1 then return 1 else return 0 end end)

-- BUS TRANSFER
sysElectric.acBusTie	 	= TwoStateCustomSwitch:new("crosstie","sim/cockpit2/electrical/cross_tie",0,
	function ()
		command_once("sim/electrical/cross_tie_on")
		if get(drefStbyPowerCap,6) ~= 0 then command_once("laminar/B738/button_switch_cover06") end
	end,
	function ()
		if get(drefStbyPowerCap,6) == 0 then command_once("laminar/B738/button_switch_cover06") end
		command_once("sim/electrical/cross_tie_off")
	end,
	function ()
		if get("sim/cockpit2/electrical/cross_tie") == 0 then 
			command_once("sim/electrical/cross_tie_on")
			if get(drefStbyPowerCap,6) ~= 0 then command_once("laminar/B738/button_switch_cover06") end
		else
			command_once("sim/electrical/cross_tie_off")
			if get(drefStbyPowerCap,6) == 0 then command_once("laminar/B738/button_switch_cover06") end
		end
	end,
	function () if get("sim/cockpit2/electrical/cross_tie") == 1 then return 1 else return 0 end end)
	
-- TwoStateCmdSwitch:new("bustrans","sim/cockpit2/electrical/cross_tie",0,
	-- "sim/electrical/cross_tie_on","sim/electrical/cross_tie_off")
-- sysElectric.busTransCover 	= TwoStateToggleSwitch:new("bustranscvr","laminar/B738/button_switch/cover_position",6,
	-- "laminar/B738/button_switch_cover06")
	
-- Cabin Util Power Boeing
sysElectric.cabUtilPwr 		= TwoStateToggleSwitch:new("cabutil","laminar/B738/toggle_switch/cab_util_pos",0,
	"laminar/B738/autopilot/cab_util_toggle")
sysElectric.ifePwr 			= TwoStateToggleSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,
	"laminar/B738/autopilot/ife_pass_seat_toggle")

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
