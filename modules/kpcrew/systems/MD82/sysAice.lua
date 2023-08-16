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
sysAice.windowHeatLeftSide 	= TwoStateCmdSwitch:new("wheatleftside","sim/cockpit/switches/anti_ice_window_heat",0,
	"sim/ice/window_heat_on","sim/ice/window_heat_off","sim/ice/window_heat_tog")
sysAice.windowHeatLeftFwd 	= InopSwitch:new("wheatleftfwd")
sysAice.windowHeatRightSide = InopSwitch:new("wheatrightside")
sysAice.windowHeatRightFwd 	= InopSwitch:new("wheatrightfwd")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftFwd)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightFwd) 

-- Pitot Heat
sysAice.pitotHeat = MultiStateCmdSwitch:new("pitoheat","laminar/md82/ice/heatknob",0,
	"laminar/md82cmd/ice/selheatknob_dwn","laminar/md82cmd/ice/selheatknob_up",0,0,true)

-- Wing / Surface Anti Ice
sysAice.antiIceWingLeft = TwoStateDrefSwitch:new("wingleft","sim/cockpit/switches/anti_ice_surf_heat_left",0)
sysAice.antiIceWingRight = TwoStateDrefSwitch:new("wingright","sim/cockpit/switches/anti_ice_surf_heat_right",0)
sysAice.antiIceWingGroup 	= SwitchGroup:new("wingantiice")
sysAice.antiIceWingGroup:addSwitch(antiIceWingLeft)
sysAice.antiIceWingGroup:addSwitch(antiIceWingRight)

-- Engine Anti Ice
sysAice.antiIceEngLeft = TwoStateDrefSwitch:new("engleft","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",-1)
sysAice.antiIceEngRight = TwoStateDrefSwitch:new("engright","sim/cockpit/switches/anti_ice_inlet_heat_per_engine",1)
sysAice.antiIceEngGroup 	= SwitchGroup:new("engantiice")
sysAice.antiIceEngGroup:addSwitch(antiIceEngLeft)
sysAice.antiIceEngGroup:addSwitch(antiIceEngRight)


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