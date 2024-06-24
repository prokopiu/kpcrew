-- A333 airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
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

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","sim/cockpit/switches/anti_ice_surf_heat_left",0)
sysAice.wingAntiIce2 		= TwoStateDrefSwitch:new("wingaice2","sim/cockpit/switches/anti_ice_surf_heat_right",0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce2)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",-1)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",1)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",2)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",3)
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