-- Rotate MD-11 airplane 
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

local drefAiceWing 			= "sim/cockpit/switches/anti_ice_surf_heat"
local drefAiceEng 			= "sim/cockpit/switches/anti_ice_inlet_heat"

-- ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWing) > 0 or get(drefAiceEng) > 0  then
		return 1
	else
		return 0
	end
end)

return sysAice