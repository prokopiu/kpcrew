-- Laminar A330 variants airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

logMsg("A33L sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateToggleSwitch:new("winheat1","laminar/A333/annun/window_probe_on",0,
	"laminar/A333/buttons/probe_window_heat_toggle")
sysAice.windowHeat2 		= InopSwitch:new("winheat2")
sysAice.windowHeat3 		= InopSwitch:new("winheat3")
sysAice.windowHeat4 		= InopSwitch:new("winheat4")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateToggleSwitch:new("probeheat1","laminar/A333/buttons/window_probe_ice",0,
	"laminar/A333/buttons/probe_window_heat_toggle")
sysAice.probeHeatBSwitch 	= InopSwitch:new("probeheat2")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- ENG anti ice
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIce1 		= TwoStateToggleSwitch:new("eng1aice","laminar/A333/annun/engine1_anti_ice",0,
	"sim/ice/inlet_heat0_tog")
sysAice.engAntiIce2 		= TwoStateToggleSwitch:new("eng2aice","laminar/A333/annun/engine2_anti_ice",0,
	"sim/ice/inlet_heat1_tog")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateToggleSwitch:new("wingaice","laminar/A333/annun/wing_anti_ice",0,
	"sim/ice/wing_heat_tog")
sysAice.wingAntiIce2 		= InopSwitch:new("wingaice2")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

return sysAice