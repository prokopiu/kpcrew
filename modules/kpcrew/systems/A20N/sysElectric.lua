-- A20N JarDesign airplane 
-- Electric system functionality

-- @classmod sysElectric
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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


-- ** BATTERY Switches
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1","sim/custom/xap/elec/bat1_on",0)
sysElectric.battery2Switch 	= TwoStateCmdSwitch:new("battery2","sim/custom/xap/elec/bat2_on",0)

-- GPU
sysElectric.gpuConnect = TwoStateDrefSwitch:new("gpuconnect","sim/custom/xap/elec/gpu_here",0)
sysElectric.gpuSwitch = TwoStateDrefSwitch:new("gpuswitch","sim/custom/xap/elec/gpu_on",0)

-- APU
sysElectric.apuMaster = TwoStateDrefSwitch:new("apumstr","sim/cockpit/engine/APU_switch",0)
sysElectric.apuStarter = TwoStateDrefSwitch:new("apustarter","sim/custom/xap/apu/start_pb",0)

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc = SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc = SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

-- BAT Voltages
sysElectric.bat1Volt = SimpleAnnunciator:new("bat1volt","sim/custom/xap/elec/bat1_ind_volt",0)
sysElectric.bat2Volt = SimpleAnnunciator:new("bat2volt","sim/custom/xap/elec/bat2_ind_volt",0)

return sysElectric