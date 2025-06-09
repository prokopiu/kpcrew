-- E1XX airplane 
-- Aircraft lights specific functionality

-- @classmod sysLights
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

local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("E1XX sysLights")

-- **Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo","XCrafts/light/logo_switch",0)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","XCrafts/light/logo_switch",0)

-- **Wheel well Lights
sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel","XCrafts/light/inspection_switch",0)
-- Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellights","XCrafts/light/inspection_switch",0)

-- **RWY Turnoff Lights
-- sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,12)
-- sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
-- sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
-- runway turnoff lights
-- sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
-- function () 
	-- if get(drefGenericLights,12) > 0  then
		-- return 1
	-- else
		-- return 0
	-- end
-- end)

-- Emergency lighting
sysLights.emerLights		= TwoStateDrefSwitch:new("emerlights","XCrafts/light/emerg_switch",0)

return sysLights
