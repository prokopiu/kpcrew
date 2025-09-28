-- B46X airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

logMsg("B46X sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1","thranda/ice/WindshieldIceL",0)
sysAice.windowHeat2 		= TwoStateDrefSwitch:new("winheat2","thranda/ice/WindshieldIceR",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateDrefSwitch:new("probeheat1","thranda/ice/LeftPitot",0)
sysAice.probeHeatBSwitch 	= TwoStateDrefSwitch:new("probeheat2","thranda/ice/RightPitot",0)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","thranda/ice/iceBootInbBt",0)
sysAice.wingAntiIce2 		= TwoStateDrefSwitch:new("wingaice2","thranda/ice/iceBootOutbBt",0)
sysAice.wingAntiIceTail		= TwoStateDrefSwitch:new("wingaice2","thranda/ice/iceBootStabBt",0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIceTail)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","thranda/ice/EngineIce1",0)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","thranda/ice/EngineIce2",0)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice","thranda/ice/EngineIce3",0)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice","thranda/ice/EngineIce4",0)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

return sysAice