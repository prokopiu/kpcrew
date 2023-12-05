-- B733 airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local sysElectric = {
	acPwrMin = 0,
	acPwrMax = 6,
	
	acPwrSTBY = 0,
	acPwrGRD = 1,
	acPwrGEN1 = 2,
	acPwrAPU = 3,
	acPwrGEN2 = 4,
	acPwrINV = 5,
	acPwrTEST = 6,
	
	dcPwrMin = 0,
	dcPwrMax = 6,
	
	dcPwrSTBY = 0,
	dcPwrBBUS = 1,
	dcPwrBAT = 2,
	dcPwrTR1 = 3,
	dcPwrTR2 = 4,
	dcPwrTR3 = 5,
	dcPwrTEST = 6
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

------------- Switches

-- DC and AC PWR knobs
sysElectric.dcPowerSwitch 	= TwoStateDrefSwitch:new("dcpower","ixeg/733/electrical/elec_dc_display_sel_act",0)
sysElectric.acPowerSwitch 	= TwoStateDrefSwitch:new("acpower","ixeg/733/electrical/elec_ac_display_sel_act",0)

-- BATTERY Switch
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("batter1","ixeg/733/electrical/elec_batt_on_act",0)
sysElectric.batteryCover 	= TwoStateDrefSwitch:new("batt1cvr","ixeg/733/electrical/batt_pwr_guard",0)

-- ** HARDWARE BATTERY Switch
sysElectric.battery1HwSwitch 	= InopSwitch:new("battery1")
sysElectric.battery2HwSwitch 	= InopSwitch:new("battery2")
sysElectric.batteryHwGroup 	= SwitchGroup:new("battery hardware")
sysElectric.batteryHwGroup:addSwitch(battery1HwSwitch)
sysElectric.batteryHwGroup:addSwitch(battery2HwSwitch)

-- Galley Power Boeing
sysElectric.galleyPwr 		= TwoStateDrefSwitch:new("galleyPwr","ixeg/733/electrical/elec_galley_on_act",0)

-- Standby Power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("stbypwr","ixeg/733/electrical/elec_stby_power_act",0)
sysElectric.stbyPowerCover 	= TwoStateDrefSwitch:new("stbypwrcvr","ixeg/733/electrical/stby_pwr_guard",0)

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateDrefSwitch:new("GPU","ixeg/733/electrical/elec_grd_pwr_on_act",0)

-- APU Bus Switches
sysElectric.apuGenBus1 		= TwoStateDrefSwitch:new("apubus1","ixeg/733/electrical/elec_apu_gen1_onoff_act",0)
sysElectric.apuGenBus2 		= TwoStateDrefSwitch:new("apubus2","ixeg/733/electrical/elec_apu_gen2_onoff_act",0)

-- GEN drive shaft
sysElectric.genDrive1Switch = TwoStateDrefSwitch:new("drive1","ixeg/733/electrical/elec_gen1_disc_act",0)
sysElectric.genDrive2Switch = TwoStateDrefSwitch:new("drive2","ixeg/733/electrical/elec_gen2_disc_act",0)
sysElectric.genDriveSwitches = SwitchGroup:new("genDriveSwitches")
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive1Switch)
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive2Switch)

-- ** ALTERNATOR Switches to help when aircraft do not work with the switches
sysElectric.alternator1Switch 		= InopSwitch:new("alt1")
sysElectric.alternator2Switch 		= InopSwitch:new("alt2")
sysElectric.alternatorSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator1Switch)
sysElectric.alternatorSwitchGroup:addSwitch(sysElectric.alternator2Switch)

sysElectric.genDrive1Cover 	= TwoStateDrefSwitch:new("drive1cvr","ixeg/733/electrical/gen1_disc_guard",0)
sysElectric.genDrive2Cover 	= TwoStateDrefSwitch:new("drive2cvr","ixeg/733/electrical/gen2_disc_guard",0)
sysElectric.genDriveCovers 	= SwitchGroup:new("genDriveCovers")
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive1Cover)
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive2Cover)

-- BUS TRANSFER
sysElectric.busTransSwitch 	= TwoStateDrefSwitch:new("bustrans","ixeg/733/electrical/elec_bus_transfer_act",0)
sysElectric.busTransCover 	= TwoStateDrefSwitch:new("bustranscvr","ixeg/733/electrical/bus_xfr_guard",0)

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1","ixeg/733/electrical/elec_gen1_onoff_act",0)
sysElectric.gen2Switch 		= TwoStateDrefSwitch:new("gen2","ixeg/733/electrical/elec_gen2_onoff_act",0)
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- APU Starter
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apu","ixeg/733/apu/apu_start_switch_act",0)

-- ** Avionics Buses
sysElectric.avionics1Bus		= InopSwitch:new("aviobus1")
sysElectric.avionics2Bus		= InopSwitch:new("aviobus2")
sysElectric.avionicsSwitchGroup 	= SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)

-- ======== Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU AVAILABLE annunciator
sysElectric.gpuAvailAnc 	= CustomAnnunciator:new("gpuavail",function (self) 
	if get("ixeg/733/electrical/gndpwr_ann") > 0 then return 1 else return 0 end 
end)
	
sysElectric.gpuOnBus = SimpleAnnunciator:new("gpubus","ixeg/733/electrical/gndpwr_ann",0)

-- APU GEN BUS OFF
sysElectric.apuGenBusOff 	= CustomAnnunciator:new("apubus",
function (self) 
	if get("ixeg/733/electrical/apu_off_ann") > 0 then return 1 else return 0 end 
end)

sysElectric.transferBus1 	= InopSwitch:new("trbus1","",0)
sysElectric.transferBus2 	= InopSwitch:new("trbus2","",0)

sysElectric.sourceOff1 		= InopSwitch:new("srcoff1","",0)
sysElectric.sourceOff2 		= InopSwitch:new("srcoff2","",0)

sysElectric.stbyPwrOff 		= SimpleAnnunciator:new("stbypwroff","ixeg/733/electrical/elec_stby_power_act",0)

sysElectric.gen1off 		= SimpleAnnunciator:new("gen1off","ixeg/733/electrical/elec_gen1_onoff_act",0)
sysElectric.gen2off 		= SimpleAnnunciator:new("gen2off","ixeg/733/electrical/elec_gen2_onoff_act",1)

sysElectric.batt1Volt 		= SimpleAnnunciator:new("bat1volt","sim/cockpit2/electrical/battery_voltage_actual_volts",0)
sysElectric.batt2Volt 		= SimpleAnnunciator:new("bat2volt","sim/cockpit2/electrical/battery_voltage_actual_volts",1)

return sysElectric