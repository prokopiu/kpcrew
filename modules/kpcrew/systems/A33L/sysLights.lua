-- Laminar A330 variants airplane 
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

logMsg("A33L sysLights")

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","laminar/a333/switches/nav_pos",0,
function () 
	if get("laminar/a333/switches/nav_pos") == 0 then
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	end
end,
function ()
	if get("laminar/a333/switches/nav_pos") > 0 then
		command_once("laminar/A333/toggle_switch/nav_light_pos_dn")
		command_once("laminar/A333/toggle_switch/nav_light_pos_dn")
	end
end,
function () 
	if get("laminar/a333/switches/nav_pos") == 0 then
		command_once("laminar/A333/toggle_switch/nav_light_pos_up")
	else
		command_once("laminar/A333/toggle_switch/nav_light_pos_dn")
		command_once("laminar/A333/toggle_switch/nav_light_pos_dn")
	end
end,
function ()
	return get("laminar/a333/switches/nav_pos")
end)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","sim/cockpit2/switches/landing_lights_switch",1)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("taxilights","sim/cockpit2/switches/landing_lights_switch",1)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCmdSwitch:new("strobes","laminar/a333/switches/strobe_pos",0,
	"laminar/A333/toggle_switch/strobe_pos_up","laminar/A333/toggle_switch/strobe_pos_dn","nocommand")

-- Strobe Light(s) status
sysLights.strobesAnc 		= CustomAnnunciator:new("strobelights",
function () 
	if get("laminar/a333/switches/strobe_pos") > 0 then 
		return 1
	else
		return 0
	end
end)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft","sim/cockpit2/switches/landing_lights_switch",-1)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefGenericLights,1)

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights,1)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,-1)
sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateCmdSwitch:new("dome","laminar/a333/switches/dome_1_pos",0,
	"laminar/A333/toggle_switch/dome_1_pos_up","laminar/A333/toggle_switch/dome_1_pos_dn","nocommand")
sysLights.domeLightSwitch2 	= TwoStateDrefSwitch:new("dome2","sim/cockpit2/switches/generic_lights_switch",10)
sysLights.domeLightSwitch3 	= TwoStateDrefSwitch:new("dome3","sim/cockpit2/switches/generic_lights_switch",11)
sysLights.domeLightSwitch4 	= TwoStateDrefSwitch:new("dome4","sim/cockpit2/switches/generic_lights_switch",9)
sysLights.domeLightSwitch5 	= TwoStateDrefSwitch:new("dome5","sim/cockpit2/switches/generic_lights_switch",12)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch3)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch4)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch5)

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "laminar/a333/switches/dome_1_pos",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",10)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",-1)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",1)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",2)
sysLights.instr5Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",3)
sysLights.instr6Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",4)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",0)

-- panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","laminar/a333/rheostats/flood_brightness",0)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","laminar/a333/rheostats/ped_flood_brightness",0)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3","laminar/a333/rheostats/integ_glare_brightness",0)
sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4","laminar/a333/rheostats/integ_light_brightness",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)

return sysLights
