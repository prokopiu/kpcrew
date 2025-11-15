-- B742 airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwritten
-- sysAice.windowHeat1
-- sysAice.windowHeat2
-- sysAice.windowHeat3
-- sysAice.windowHeat4
-- sysAice.windowHeatGroup 
-- sysAice.probeHeatASwitch
-- sysAice.probeHeatBSwitch
-- sysAice.probeHeatGroup 	
-- sysAice.wingAntiIce 	
-- sysAice.wingAntiIce2 
-- sysAice.wingAiceGroup
-- sysAice.engAntiIce1 
-- sysAice.engAntiIce2 
-- sysAice.engAntiIce3 
-- sysAice.engAntiIce4 
-- sysAice.engAntiIceGroup

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

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("B742 sysAice")

--------- Switch datarefs common
local drefWindowHeat1		= "B742/OVHD/window_heat_sw_1L"
local drefWindowHeat2		= "B742/OVHD/window_heat_sw_1R"
local drefWindowHeat3		= "B742/OVHD/window_heat_sw_2L"
local drefWindowHeat4		= "B742/OVHD/window_heat_sw_2R"
local drefProbeHeat1		= "B742/OVHD/probe_heater_L"
local drefProbeHeat2		= "B742/OVHD/probe_heater_R"
local drefWingAice1			= "B742/OVHD/wing_antiice_sw"
local drefEngineAice		= "B742/OVHD/nacelle_antiice_sw"

--------- Annunciator datarefs common

--------- Switch commands common

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1",drefWindowHeat1,0)
sysAice.windowHeat2 		= TwoStateDrefSwitch:new("winheat2",drefWindowHeat2,0)
sysAice.windowHeat3 		= TwoStateDrefSwitch:new("winheat3",drefWindowHeat3,0)
sysAice.windowHeat4 		= TwoStateDrefSwitch:new("winheat4",drefWindowHeat4,0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateDrefSwitch:new("probeheat1",drefProbeHeat1,0)
sysAice.probeHeatBSwitch 	= TwoStateDrefSwitch:new("probeheat2",drefProbeHeat2,0)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice",drefWingAice1,0)
sysAice.wingAntiIce2 		= InopSwitch:new("wingaice2")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice",drefEngineAice,-1)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice",drefEngineAice,1)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice",drefEngineAice,2)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice",drefEngineAice,3)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

return sysAice