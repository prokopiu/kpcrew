-- E1FF X-Crafts Freeware airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("E1FF sysLights")

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLandingLights,1)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright",drefLandingLights,2)
sysLights.ll3rdSwitch 		= TwoStateDrefSwitch:new("ll3rd",drefLandingLights,-1)
sysLights.ll4thSwitch 		= InopSwitch:new("ll4th")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get(drefLandingLights,0) > 0 or get(drefLandingLights,1) > 0  or get(drefLandingLights,2) > 0  then
		return 1
	else
		return 0
	end
end)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,12)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get(drefGenericLights,12) > 0  then
		return 1
	else
		return 0
	end
end)

return sysLights
