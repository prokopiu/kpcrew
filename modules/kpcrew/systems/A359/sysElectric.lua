-- A350  airplane 
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

--------- Switch datarefs common

local drefBatterySwitch		= "1-sim/86/button"

--------- Annunciator datarefs common


--------- Switch commands common

local cmdBatteryOff			= ""
local cmdBatteryOn			= ""
local cmdBatteryTgl			= ""

--------- Actuator definitions

-- ** BATTERY Switch
sysElectric.batterySwitch 	= TwoStateDrefSwitch:new("battery1",drefBatterySwitch,0)
sysElectric.battery2Switch 	= TwoStateDrefSwitch:new("battery2","1-sim/89/button",0)
sysElectric.batemerg1		= TwoStateDrefSwitch:new("battery2","1-sim/87/button",0)
sysElectric.batemerg2		= TwoStateDrefSwitch:new("battery2","1-sim/88/button",0)

-- Ground Power
sysElectric.gpuSwitch 		= TwoStateDrefSwitch:new("GPU1","1-sim/elec/gpu1ON",0)
sysElectric.gpu2Switch		= TwoStateDrefSwitch:new("GPU2","1-sim/elec/gpu2ON",0)
sysElectric.gpu1Connect		= TwoStateDrefSwitch:new("GPU1connect","1-sim/ext/gpu1",0)
sysElectric.gpu2Connect		= TwoStateDrefSwitch:new("GPU2connect","1-sim/ext/gpu2",0)

-- APU Bus Switches
sysElectric.apuGenBus 		= TwoStateDrefSwitch:new("apubus","1-sim/101/button",0)

-- GEN Switches
sysElectric.gen1Switch 		= TwoStateDrefSwitch:new("gen1","1-sim/96/button",0)
sysElectric.gen2Switch 		= TwoStateDrefSwitch:new("gen2","1-sim/99/button",0)
sysElectric.gen3Switch 		= TwoStateDrefSwitch:new("gen3","1-sim/103/button",0)
sysElectric.gen4Switch 		= TwoStateDrefSwitch:new("gen4","1-sim/106/button",0)
sysElectric.genSwitchGroup 	= SwitchGroup:new("genswitches")
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen3Switch)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen4Switch)

-- APU 
sysElectric.apuMasterSwitch	= TwoStateDrefSwitch:new("apumaster","1-sim/125/button",0)
sysElectric.apuStartSwitch 	= TwoStateDrefSwitch:new("apustart","1-sim/126/button",0)

-- Bus Tie
sysElectric.busTieSwitch	= TwoStateDrefSwitch:new("bustie","1-sim/100/button",0)

-- Appliances
sysElectric.ELMU			= TwoStateDrefSwitch:new("ELMU",	"1-sim/90/button",0)
sysElectric.PAXSYS			= TwoStateDrefSwitch:new("PAXSYS",	"1-sim/91/button",0)
sysElectric.GALLEY			= TwoStateDrefSwitch:new("GALLEY",	"1-sim/92/button",0)
sysElectric.COMM1			= TwoStateDrefSwitch:new("COMM1",	"1-sim/93/button",0)
sysElectric.COMM2			= TwoStateDrefSwitch:new("COMM2",	"1-sim/94/button",0)

--------- Annunciators

-- LOW VOLTAGE annunciator
sysElectric.lowVoltageAnc 	= SimpleAnnunciator:new("lowvoltage","sim/cockpit2/annunciators/low_voltage",0)

-- APU RUNNING annunciator
sysElectric.apuRunningAnc 	= SimpleAnnunciator:new("apurunning","1-sim/lamp/217",0)

sysElectric.apuGenBusOff 	= CustomAnnunciator:new("apubus",
	function (self) 
		if get("1-sim/lamp/155") > 0 then return 1 else return 0 end 
	end)

sysElectric.gpuOnBus 		= CustomAnnunciator:new("gpuonbus",
	function (self) 
		if get("1-sim/lamp/160") > 0 or get("1-sim/lamp/148") > 0 then return 1 else return 0 end 
	end)

return sysElectric