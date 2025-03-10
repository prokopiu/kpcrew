-- EVIC airplane 
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

sysLights = require("kpcrew.systems.DFLT.sysLights")

logMsg("EVIC sysLights")

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft","sim/cockpit2/switches/landing_lights_on",0)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","sim/cockpit2/switches/generic_lights_switch",2)
sysLights.domeLightSwitch2 	= TwoStateDrefSwitch:new("dome2","sim/cockpit2/electrical/panel_brightness_ratio",3)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "sim/cockpit2/switches/generic_lights_switch",2) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","sim/cockpit/electrical/instrument_brightness",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",-1)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit/electrical/instrument_brightness",0)

-- panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","sim/cockpit2/switches/generic_lights_switch",7)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","sim/cockpit2/switches/panel_brightness_ratio",1)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)

return sysLights
