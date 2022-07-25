-- B732 airplane 
-- Electric system functionality

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

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

------------- Switches

-- DC and AC PWR knobs
sysElectric.dcPowerSwitch = TwoStateDrefSwitch:new("dcpower","FJS/732/Elec/DCmeterKnob",0)
sysElectric.acPowerSwitch = TwoStateDrefSwitch:new("acpower","FJS/732/Elec/ACmeterKnob",0)

-- BATTERY Switch
sysElectric.batterySwitch = TwoStateDrefSwitch:new("","sim/cockpit/electrical/battery_on",0)
sysElectric.batteryCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_01",0)

-- Cabin Util Power Boeing
sysElectric.cabUtilPwr = TwoStateDrefSwitch:new("cabutil","FJS/732/Elec/GalleySwitch",0)
-- sysElectric.ifePwr = InopSwitch:new("ifepwr","laminar/B738/toggle_switch/ife_pass_seat_pos",0,"laminar/B738/autopilot/ife_pass_seat_toggle")

-- Standby Power
sysElectric.stbyPowerSwitch = TwoStateDrefSwitch:new("","FJS/732/Elec/StbyPowerSwitch",0)
sysElectric.stbyPowerCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_07",0)

-- Ground Power
sysElectric.connectGPU = TwoStateDrefSwitch:new("gpu","FJS/732/Elec/GndPowerAvailable",0)
sysElectric.gpuSwitch = TwoStateDrefSwitch:new("","FJS/732/Elec/GndPwrSwitch",0)

-- APU Bus Switches
sysElectric.apuGenBus1 = TwoStateDrefSwitch:new("","FJS/732/Elec/APUgen1Switch",0)
sysElectric.apuGenBus2 = TwoStateDrefSwitch:new("","FJS/732/Elec/APUgen2Switch",0)

-- GEN drive shaft
sysElectric.genDrive1Switch = TwoStateCmdSwitch:new("","FJS/732/Fail/GenDrive1Disconed",0)
sysElectric.genDrive2Switch = TwoStateCmdSwitch:new("","FJS/732/Fail/GenDrive2Disconed",0)
sysElectric.genDriveSwitches = SwitchGroup:new("genDriveSwitches")
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive1Switch)
sysElectric.genDriveSwitches:addSwitch(sysElectric.genDrive2Switch)

sysElectric.genDrive1Cover = TwoStateDrefSwitch:new("","FJS/732/num/FlipMo_08",0)
sysElectric.genDrive2Cover = TwoStateDrefSwitch:new("","FJS/732/num/FlipMo_09",0)
sysElectric.genDriveCovers = SwitchGroup:new("genDriveCovers")
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive1Cover)
sysElectric.genDriveCovers:addSwitch(sysElectric.genDrive2Cover)

-- BUS TRANSFER
sysElectric.busTransSwitch = TwoStateDrefSwitch:new("","FJS/732/Elec/BusTransSwitch",0)
sysElectric.busTransCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipMo_11",0)

-- GEN Switches
sysElectric.gen1Switch = TwoStateDrefSwitch:new("","FJS/732/Elec/Gen1Switch",0)
sysElectric.gen2Switch = TwoStateDrefSwitch:new("","FJS/732/Elec/Gen2Switch",0)

sysElectric.genSwitchGroup = SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

sysElectric.apuStartSwitch = TwoStateDrefSwitch:new("","FJS/732/Elec/APUStartSwitch",0)

-- ======== Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- GPU AVAILABLE annunciator
sysElectric.gpuAvailAnc = CustomAnnunciator:new("gpuavail",
function () 
	if sysElectric.connectGPU:getStatus() == 1 then 
		return 1 
	else 
		return 0 
	end 
end)
sysElectric.gpuOnBus = CustomAnnunciator:new("gpubus",
function () 
	if get("FJS/732/Elec/GndPowerStable") > 0 then 
		return 1 
	else 
		return 0 
	end 
end)

-- APU GEN BUS OFF
sysElectric.apuGenBusOff = CustomAnnunciator:new("apubus",
function () 
	if get("FJS/732/Annun/SysAnnunBUT_13") > 0 then
		return 1 
	else 
		return 0 
	end 
end)

sysElectric.transferBus1 = SimpleAnnunciator:new("trbus1","FJS/732/Annun/SysAnnunBUT_7",0)
sysElectric.transferBus2 = SimpleAnnunciator:new("trbus2","FJS/732/Annun/SysAnnunBUT_10",0)

sysElectric.sourceOff1 = SimpleAnnunciator:new("srcoff1","FJS/732/Annun/SysAnnunBUT_8",0)
sysElectric.sourceOff2 = SimpleAnnunciator:new("srcoff2","FJS/732/Annun/SysAnnunBUT_11",0)

sysElectric.stbyPwrOff = SimpleAnnunciator:new("","FJS/732/Annun/SysAnnunLIT_3",0)

sysElectric.gen1off = SimpleAnnunciator:new("","FJS/732/Annun/SysAnnunLIT_9",0)
sysElectric.gen2off = SimpleAnnunciator:new("","FJS/732/Annun/SysAnnunLIT_12",0)

sysElectric.batt1Volt = SimpleAnnunciator:new("bat1volt","sim/cockpit2/electrical/battery_voltage_actual_volts",0)
sysElectric.batt2Volt = SimpleAnnunciator:new("bat2volt","sim/cockpit2/electrical/battery_voltage_actual_volts",1)

return sysElectric