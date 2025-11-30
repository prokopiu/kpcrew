-- B737 airplane 
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
-- sysAice.wingAiceGroup
-- sysAice.engAntiIce1 
-- sysAice.engAntiIce2 
-- sysAice.engAntiIceGroup

local sysAice = {
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

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("B737 sysAice")

--------- Switch datarefs common
local drefWindowHeat1		= "laminar/B738/ice/window_heat_l_side_pos"
local drefWindowHeat2		= "laminar/B738/ice/window_heat_l_fwd_pos"
local drefWindowHeat3		= "laminar/B738/ice/window_heat_r_side_pos"
local drefWindowHeat4		= "laminar/B738/ice/window_heat_r_fwd_pos"
local drefProbeHeat1		= "laminar/B738/toggle_switch/capt_probes_pos"
local drefProbeHeat2		= "laminar/B738/toggle_switch/fo_probes_pos"
local drefWingAice1			= "laminar/B738/ice/wing_heat_pos"
local drefEngineAiceL		= "laminar/B738/ice/eng1_heat_pos"
local drefEngineAiceR		= "laminar/B738/ice/eng2_heat_pos"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdWindowHeat1Tgl		= "laminar/B738/toggle_switch/window_heat_l_side"
local cmdWindowHeat2Tgl		= "laminar/B738/toggle_switch/window_heat_l_fwd"
local cmdWindowHeat3Tgl		= "laminar/B738/toggle_switch/window_heat_r_side"
local cmdWindowHeat4Tgl		= "laminar/B738/toggle_switch/window_heat_r_fwd"
local cmdProbeHeat1Tgl		= "laminar/B738/toggle_switch/capt_probes_pos"
local cmdProbeHeat2Tgl		= "laminar/B738/toggle_switch/fo_probes_pos"
local cmdWingAntiIceTgl		= "laminar/B738/toggle_switch/wing_heat"
local cmdEngineAiceLTgl		= "laminar/B738/toggle_switch/eng1_heat"
local cmdEngineAiceRTgl		= "laminar/B738/toggle_switch/eng2_heat"

----------- Switches

-- Window Heat
sysAice.windowHeat1 		= TwoStateToggleSwitch:new("winheat1",drefWindowHeat1,0,cmdWindowHeat1Tgl)
sysAice.windowHeat2 		= TwoStateToggleSwitch:new("winheat2",drefWindowHeat2,0,cmdWindowHeat2Tgl)
sysAice.windowHeat3 		= TwoStateToggleSwitch:new("winheat3",drefWindowHeat3,0,cmdWindowHeat3Tgl)
sysAice.windowHeat4 		= TwoStateToggleSwitch:new("winheat4",drefWindowHeat4,0,cmdWindowHeat4Tgl)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe/Pitot heat
sysAice.probeHeatASwitch 	= TwoStateToggleSwitch:new("probeheat1",drefProbeHeat1,0,cmdProbeHeat1Tgl)
sysAice.probeHeatBSwitch 	= TwoStateToggleSwitch:new("probeheat2",drefProbeHeat2,0,cmdProbeHeat2Tgl)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateToggleSwitch:new("wingaice",drefWingAice1,0,cmdWingAntiIceTgl)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateToggleSwitch:new("eng1aice",drefEngineAiceL,0,cmdEngineAiceLTgl)
sysAice.engAntiIce2 		= TwoStateToggleSwitch:new("eng2aice",drefEngineAiceR,0,cmdEngineAiceRTgl)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

return sysAice