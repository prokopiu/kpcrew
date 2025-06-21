-- ER1X airplane 
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

logMsg("ER1X sysAice")

-- Window Heat
sysAice.windowHeatGroup 		= TwoStateDrefSwitch:new("winheat1","sim/cockpit/switches/anti_ice_window_heat",0)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateCmdSwitch:new("probeheat1","sim/cockpit/switches/pitot_heat_on",0,
	"sim/ice/pitot_heat0_on","sim/ice/pitot_heat0_off","sim/ice/pitot_heat0_tog")
sysAice.probeHeatBSwitch 	= TwoStateCmdSwitch:new("probeheat2","sim/cockpit/switches/pitot_heat_on2",0,
	"sim/ice/pitot_heat1_on","sim/ice/pitot_heat1_off","sim/ice/pitot_heat1_tog")
sysAice.aoaHeatSwitch 	= TwoStateCmdSwitch:new("aoaheat","sim/cockpit2/ice/ice_AOA_heat_on",0,
	"sim/ice/pitot_heat1_on","sim/ice/pitot_heat1_off","sim/ice/pitot_heat1_tog")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.aoaHeatSwitch)

return sysAice