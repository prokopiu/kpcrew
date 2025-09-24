-- A306 airplane 
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

logMsg("A306 sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1","A300/ICE/window_heat1",0)
sysAice.windowHeat2 		= TwoStateDrefSwitch:new("winheat2","A300/ICE/window_heat2",0)
sysAice.windowHeat3 		= TwoStateDrefSwitch:new("winheat3","A300/ICE/window_heat3",0)
sysAice.windowHeat4 		= TwoStateDrefSwitch:new("winheat4","A300/ICE/window_heat4",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateToggleSwitch:new("probeheat1","A300/WIND/probe_heat_button_pilot",0,
	"A300/COND/probe_heat_left_toggle")
sysAice.probeHeatBSwitch 	= TwoStateToggleSwitch:new("probeheat2","A300/WIND/probe_heat_button_copilot",0,
	"A300/COND/probe_heat_right_toggle")
sysAice.probeHeatCSwitch 	= TwoStateToggleSwitch:new("probeheat2","A300/WIND/probe_heat_button_standby",0,
	"A300/COND/probe_heat_standby_toggle")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatCSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","A300/ICE/wing_supply",0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateToggleSwitch:new("eng1aice","A300/animations/buttons/target",49,
	"A300/ICE/eng1_toggle")
sysAice.engAntiIce2 		= TwoStateToggleSwitch:new("eng2aice","A300/animations/buttons/target",50,
	"A300/ICE/eng2_toggle")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

return sysAice