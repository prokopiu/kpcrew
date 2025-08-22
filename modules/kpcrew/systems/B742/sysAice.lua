-- B742 airplane 
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

logMsg("B742 sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1","B742/OVHD/window_heat_sw_1L",0)
sysAice.windowHeat2 		= TwoStateDrefSwitch:new("winheat2","B742/OVHD/window_heat_sw_1R",0)
sysAice.windowHeat3 		= TwoStateDrefSwitch:new("winheat3","B742/OVHD/window_heat_sw_2L",0)
sysAice.windowHeat4 		= TwoStateDrefSwitch:new("winheat4","B742/OVHD/window_heat_sw_2R",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateDrefSwitch:new("probeheat1","B742/OVHD/probe_heater_L",0)
sysAice.probeHeatBSwitch 	= TwoStateDrefSwitch:new("probeheat2","B742/OVHD/probe_heater_R",0)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","B742/OVHD/wing_antiice_sw",0)
sysAice.wingAntiIce2 		= InopSwitch:new("wingaice2")
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","B742/OVHD/nacelle_antiice_sw",-1)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","B742/OVHD/nacelle_antiice_sw",1)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice","B742/OVHD/nacelle_antiice_sw",2)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice","B742/OVHD/nacelle_antiice_sw",3)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if sysAice.wingAiceGroup:getStatus() > 0 or sysAice.engAntiIceGroup:getStatus() > 0  then
		return 1
	else
		return 0
	end
end)

return sysAice