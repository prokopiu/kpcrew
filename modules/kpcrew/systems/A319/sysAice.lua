-- DFLT airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

local drefAiceWing 			= "sim/cockpit/switches/anti_ice_surf_heat"
local drefAiceEng 			= "sim/cockpit/switches/anti_ice_inlet_heat"

-- Window Heat
sysAice.windowHeat1 		= TwoStateCmdSwitch:new("winheat1","sim/cockpit2/ice/ice_window_heat_on_window",-1,
	"sim/ice/window_heat_on","sim/ice/window_heat_off","sim/ice/window_heat_tog")
sysAice.windowHeat2 		= TwoStateCmdSwitch:new("winheat2","sim/cockpit2/ice/ice_window_heat_on_window",1,
	"sim/ice/window2_heat_on","sim/ice/window2_heat_off","sim/ice/window2_heat_tog")
sysAice.windowHeat3 		= TwoStateCmdSwitch:new("winheat3","sim/cockpit2/ice/ice_window_heat_on_window",2,
	"sim/ice/window3_heat_on","sim/ice/window3_heat_off","sim/ice/window3_heat_tog")
sysAice.windowHeat4 		= TwoStateCmdSwitch:new("winheat4","sim/cockpit2/ice/ice_window_heat_on_window",3,
	"sim/ice/window4_heat_on","sim/ice/window4_heat_off","sim/ice/window4_heat_tog")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateCmdSwitch:new("probeheat1","sim/cockpit/switches/pitot_heat_on",0,
	"sim/ice/pitot_heat0_on","sim/ice/pitot_heat0_off","sim/ice/pitot_heat0_tog")
sysAice.probeHeatBSwitch 	= TwoStateCmdSwitch:new("probeheat2","sim/cockpit/switches/pitot_heat_on2",0,
	"sim/ice/pitot_heat1_on","sim/ice/pitot_heat1_off","sim/ice/pitot_heat1_tog")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= InopSwitch:new("wingaice")
-- sysAice.wingAntiIce2 		= InopSwitch:new("wingaice2")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
-- sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= InopSwitch:new("eng1aice")
-- sysAice.engAntiIce2 		= InopSwitch:new("eng2aice")
-- sysAice.engAntiIce3 		= InopSwitch:new("eng3aice")
-- sysAice.engAntiIce4 		= InopSwitch:new("eng4aice")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
-- sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
-- sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
-- sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

-- ==== Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWing) > 0 or get(drefAiceEng) > 0  then
		return 1
	else
		return 0
	end
end)

return sysAice