-- A333 airplane 
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

sysLights = require("kpcrew.systems.DFLT.sysLights")

local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCmdSwitch:new("position","laminar/a333/switches/nav_pos",0,
	"laminar/A333/toggle_switch/nav_light_pos_up","laminar/A333/toggle_switch/nav_light_pos_dn")

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","laminar/a333/switches/nav_pos",0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCmdSwitch:new("strobes","laminar/a333/switches/strobe_pos",0,
	"laminar/A333/toggle_switch/strobe_pos_up","laminar/A333/toggle_switch/strobe_pos_dn")

-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/strobe_lights_on",0)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCmdSwitch:new("taxi","sim/cockpit2/switches/landing_lights_switch",1,
	"laminar/A333/switch/lighting/taxi_light_up","laminar/A333/switch/lighting/taxi_light_dn")

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/taxi_light_on",0)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft","sim/cockpit2/switches/landing_lights_on",0)
sysLights.llRightSwitch 	= InopSwitch:new("llright")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get(drefLandingLights,0) > 0 or get(drefLandingLights,1) > 0  or get(drefLandingLights,2) > 0 or get(drefLandingLights,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- Logo Light
sysLights.logoSwitch 		= TwoStateCmdSwitch:new("logonav","laminar/a333/switches/nav_pos",0,
	"laminar/A333/toggle_switch/nav_light_pos_up","laminar/A333/toggle_switch/nav_light_pos_dn")

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","sim/cockpit2/switches/generic_lights_switch",2)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","sim/cockpit2/switches/generic_lights_switch",-1)
sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get("sim/cockpit2/switches/generic_lights_switch",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateCmdSwitch:new("dome","laminar/a333/switches/dome_brightness",0,
	"laminar/A333/toggle_switch/dome_bright_up","laminar/A333/toggle_switch/dome_bright_dn")
sysLights.domeLight2Switch 	= TwoStateCmdSwitch:new("dome","laminar/a333/switches/dome_1_pos",0,
	"laminar/A333/toggle_switch/dome_1_pos_up","laminar/A333/toggle_switch/dome_1_pos_dn")
sysLights.domeLight3Switch 	= TwoStateCmdSwitch:new("dome","laminar/a333/switches/dome_2_pos",0,
	"laminar/A333/toggle_switch/dome_2_pos_up","laminar/A333/toggle_switch/dome_2_pos_dn")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.rwyLightGroup:addSwitch(sysLights.domeLightSwitch)
	
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if sysLights.domeLightSwitch:getStatus() ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","laminar/a333/rheostats/flood_brightness",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","laminar/a333/rheostats/integ_light_brightness",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","laminar/a333/rheostats/ped_flood_brightness",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","laminar/a333/rheostats/integ_glare_brightness",0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",3)
sysLights.instr6Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",1)
sysLights.instr7Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",1)
sysLights.instr8Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",2)
sysLights.instr9Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",3)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr9Light)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",0)

return sysLights