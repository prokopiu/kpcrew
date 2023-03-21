-- DFLT airplane 
-- Anti Ice functionality

local sysAice = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local drefAiceWing = "sim/cockpit/switches/anti_ice_surf_heat"
local drefAiceEng = "sim/cockpit/switches/anti_ice_inlet_heat"

-- Window Heat
sysAice.windowHeatLeftSide 	= TwoStateCmdSwitch:new("wheatleftside","sim/cockpit2/ice/ice_window_heat_on",0,
	"sim/ice/window_heat_on","sim/ice/window_heat_off","sim/ice/window_heat_tog")
sysAice.windowHeatLeftFwd 	= InopSwitch:new("wheatleftfwd")
sysAice.windowHeatRightSide = InopSwitch:new("wheatrightside")
sysAice.windowHeatRightFwd 	= InopSwitch:new("wheatrightfwd")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftFwd)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightFwd) 

-- ANTI ICE annunciator
sysAice.antiiceAnc = CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWing) > 0 or get(drefAiceEng) > 0  then
		return 1
	else
		return 0
	end
end)

return sysAice