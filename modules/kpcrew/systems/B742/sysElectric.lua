-- B742 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysElectric.batteryGroup 	
-- sysElectric.batterySwitch 
-- sysElectric.stbyPowerSwitch
-- sysElectric.gen1Switch
-- sysElectric.gen2Switch
-- sysElectric.gen3Switch
-- sysElectric.gen4Switch	
-- sysElectric.gpuGenBusGroup
-- sysElectric.gpuConnect
-- sysElectric.gpuGenBus1
-- sysElectric.gpuGenBus2
-- sysElectric.gpuOnBus
-- sysElectric.apuGenBusGroup
-- sysElectric.apuMaster	 
-- sysElectric.apuStartSwitch
-- sysElectric.apuGenBus1 	
-- sysElectric.apuGenBus2 	
-- sysElectric.apuGenBus3 + 	
-- sysElectric.apuGenBus4 +	
-- sysElectric.apuRunningAnc
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

logMsg("B742 sysElectric")

--------- Switch datarefs common
local drefBattery1			= "B742/ELEC/battery_sw"
local drefBattery1Cap		= "B742/ELEC/battery_cap"
local drefStbyPower			= "B742/ELEC/standby_power_sw"
local drefGenerator1		= "B742/ELEC/bus_gen_close_sw"
local drefGPUOn				= "B742/GHD/GPU"
local drefGPUGenerator1		= "B742/AUX_PWR/EXT_PWR_1_sw"
local drefGPUGenerator2		= "B742/AUX_PWR/EXT_PWR_2_sw"
local drefAPUStarter		= "B742/APU/APU_start_sw"
local drefAPUMaster			= "B742/APU/APU_start_sw"
local drefAPUGenerator1		= "B742/AUX_PWR/APU_GEN1_close_sw"
local drefAPUGenerator2		= "B742/AUX_PWR/APU_GEN2_close_sw"
local drefAPUGenerator3		= "B742/AUX_PWR/APU_GEN1_trip_sw"
local drefAPUGenerator4		= "B742/AUX_PWR/APU_GEN2_trip_sw"

--------- Annunciator datarefs common
local drefGPUPowerOnBus1	= "B742/FE_lamps/AUX_power_on_bus_1"
local drefGPUPowerOnBus2	= "B742/FE_lamps/AUX_power_on_bus_2"
local drefAPUN1				= "sim/cockpit/engine/APU_N1"

--------- Switch commands common

----------- Switches

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1",drefBattery1,0,
	function ()
		set(drefBattery1,1)
		set(drefBattery1Cap,0)
	end,
	function ()
		set(drefBattery1,0)
		set(drefBattery1Cap,1)
	end,
	function ()
		if get(drefBattery1) == 0 then
			set(drefBattery1,1)
			set(drefBattery1Cap,0)
		else
			set(drefBattery1,0)
			set(drefBattery1Cap,1)
		end
	end,
	function () return get(drefBattery1) end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- Standby power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbySwitch",drefStbyPower,0)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1",drefGenerator1,-1,
	function () set_array(drefGenerator1,0,1) end,
	function () set_array(drefGenerator1,0,-1) end,
	function () end,
	function () if get(drefGenerator1,0) == 1 then return 1 else return 0 end end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.gen2Switch 		= TwoStateCustomSwitch:new("gen2",drefGenerator1,1,
	function () set_array(drefGenerator1,1,1) end,
	function () set_array(drefGenerator1,1,-1) end,
	function () end,
	function () if get(drefGenerator1,1) == 1 then return 1 else return 0 end end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.gen3Switch 		= TwoStateCustomSwitch:new("gen3",drefGenerator1,2,
	function () set_array(drefGenerator1,2,1) end,
	function () set_array(drefGenerator1,2,-1) end,
	function () end,
	function () if get(drefGenerator1,2) == 1 then return 1 else return 0 end end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.gen4Switch 		= TwoStateCustomSwitch:new("gen4",drefGenerator1,3,
	function () set_array(drefGenerator1,3,1) end,
	function () set_array(drefGenerator1,3,-1) end,
	function () end,
	function () if get(drefGenerator1,3) == 1 then return 1 else return 0 end end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU",drefGPUOn,0,
	function () end,
	function () end,
	function () end,
	function () if get(drefGPUOn) == 0 then return 1 else return 0 end end)	

-- ----- GPU	
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuGenBus1 		= TwoStateDrefSwitch:new("gpubus1",drefGPUGenerator1,0)
sysElectric.gpuGenBus2 		= TwoStateDrefSwitch:new("gpubus2",drefGPUGenerator2,0)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus2)
sysElectric.gpuOnBus = CustomAnnunciator:new("GPUOnBus",
	function () 
		if get(drefGPUPowerOnBus1) > 0 or get(drefGPUPowerOnBus2) > 0 then
			return 1
		else
			return 0
		end
	end)

-- ----- APU
sysElectric.apuGenBusGroup	= SwitchGroup:new("apubussgroup")
sysElectric.apuMaster	 	= TwoStateDrefSwitch:new("apuswitch",drefAPUMaster,0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apuswitch",drefAPUStarter,0)
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1",drefAPUGenerator1,0)
sysElectric.apuGenBus2 		= TwoStateDrefSwitch:new("apubus2",drefAPUGenerator2,0)
sysElectric.apuGenBus3 		= TwoStateDrefSwitch:new("apubus1",drefAPUGenerator3,0)
sysElectric.apuGenBus4 		= TwoStateDrefSwitch:new("apubus2",drefAPUGenerator4,0)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus3)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus4)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus1)
sysElectric.apuGenBusGroup:addSwitch(sysElectric.apuGenBus2)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= CustomAnnunciator:new("apurunning",
	function () if get(drefAPUN1) > 98 then return 1 else return 0 end end)

--------- Macros

-- Macro Electric system flight phase 
function kc_macro_elec_system(flightphase)
	logMsg("Electric flight phase: " .. kcSopFlightPhase[flightphase])
	
	if flightphase == kc_phase_colddark then
		set_array("B742/FE/galley_pwr_sw",0,0)
		set_array("B742/FE/galley_pwr_sw",1,0)
		set_array("B742/FE/galley_pwr_sw",2,0)
		set_array("B742/FE/galley_pwr_sw",3,0)
		
		set_array("B742/FUEL/fuel_heat_sw",0,0)
		set_array("B742/FUEL/fuel_heat_sw",1,0)
		set_array("B742/FUEL/fuel_heat_sw",2,0)
		set_array("B742/FUEL/fuel_heat_sw",3,0)
		
		sysElectric.batterySwitch:actuate(0) 
		sysElectric.stbyPowerSwitch:actuate(0)
		sysElectric.genSwitchGroup:actuate(0)
		sysElectric.gpuGenBusGroup:actuate(0)
		sysElectric.apuGenBusGroup:actuate(0)
		sysElectric.apuStartSwitch:actuate(0)
		
		set("B742/FUEL/scavenge_pump_sw",0)
	elseif flightphase == kc_phase_turnaround then
		set_array("B742/FE/galley_pwr_sw",0,1)
		set_array("B742/FE/galley_pwr_sw",1,1)
		set_array("B742/FE/galley_pwr_sw",2,1)
		set_array("B742/FE/galley_pwr_sw",3,1)

		set_array("B742/FUEL/fuel_heat_sw",0,0)
		set_array("B742/FUEL/fuel_heat_sw",1,0)
		set_array("B742/FUEL/fuel_heat_sw",2,0)
		set_array("B742/FUEL/fuel_heat_sw",3,0)
		
		sysElectric.batterySwitch:actuate(1) 
		sysElectric.stbyPowerSwitch:actuate(1)
		
		set("B742/FUEL/scavenge_pump_sw",0)
	elseif flightphase == kc_phase_before_start then
		set_array("B742/FE/galley_pwr_sw",0,0)
		set_array("B742/FE/galley_pwr_sw",1,0)
		set_array("B742/FE/galley_pwr_sw",2,0)
		set_array("B742/FE/galley_pwr_sw",3,0)
	elseif flightphase == kc_phase_after_start then
		sysElectric.genSwitchGroup:actuate(1)
		set_array("B742/FE/galley_pwr_sw",0,1)
		set_array("B742/FE/galley_pwr_sw",1,1)
		set_array("B742/FE/galley_pwr_sw",2,1)
		set_array("B742/FE/galley_pwr_sw",3,1)
		set("B742/AUX_PWR/APU_split_sys_sw",1)
	elseif flightphase == kc_phase_shutdown then
		sysElectric.genSwitchGroup:actuate(0)
	else
		logMsg("Invalid flightphase")
	end	
end

-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		sysElectric.apuGenBus2:actuate(1)
		sysElectric.apuGenBus3:actuate(1)
		sysElectric.apuGenBus4:actuate(1)
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

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("sim/cockpit2/electrical/APU_N1_percent") == 100 then
		sysElectric.apuStartSwitch:setValue(1)
		sysElectric.apuGenBus2:actuate(0)
		sysElectric.apuGenBus3:actuate(0)
		sysElectric.apuGenBus4:actuate(0)
		sysElectric.apuGenBus1:actuate(1)
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
