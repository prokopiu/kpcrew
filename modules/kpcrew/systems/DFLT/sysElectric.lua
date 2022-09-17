-- DFLT  airplane 
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

--------- Switches

-- ** BATTERY Switch
sysElectric.batterySwitch 	= InopSwitch:new("battery1")

-- Ground Power
sysElectric.gpuSwitch 		= InopSwitch:new("GPU")

-- APU Bus Switches
sysElectric.apuGenBus1 		= InopSwitch:new("apubus1")

-- GEN Switches
sysElectric.gen1Switch 		= InopSwitch:new("gen1")
sysElectric.gen2Switch 		= InopSwitch:new("gen2")
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- APU Starter
sysElectric.apuStartSwitch 	= InopSwitch:new("apu")

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","sim/cockpit2/electrical/APU_running",0)

return sysElectric