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
sysAice.windowHeatLeftSide 	= InopSwitch:new("wheatleftside")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)

-- Probe heat
sysAice.probeHeatASwitch 	= InopSwitch:new("probeheat1")
sysAice.probeHeatBSwitch 	= InopSwitch:new("probeheat2")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= InopSwitch:new("wingaice")

-- ENG anti ice
sysAice.engAntiIce1 		= InopSwitch:new("eng1aice")
sysAice.engAntiIce2 		= InopSwitch:new("eng2aice")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)


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