-- E55P airplane 
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

logMsg("E55P sysLights")

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCustomSwitch:new("taxi","aerobask/lights/sw_ldg_taxi",0,
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 0 then
		command_once("aerobask/lights/ldg_taxi_up")
	elseif get("aerobask/lights/sw_ldg_taxi") == 2 then
		command_once("aerobask/lights/ldg_taxi_dn")
	end
end,
function ()
	command_once("aerobask/lights/ldg_taxi_dn")
	command_once("aerobask/lights/ldg_taxi_dn")
end,
nil,
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 1 then
		return 1
	else
		return 0
	end
end)

-- Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 1 then
		return 1
	else
		return 0
	end
end)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft","aerobask/lights/sw_ldg_taxi",0,
function ()
	if get("aerobask/lights/sw_ldg_taxi") < 2 then
		command_once("aerobask/lights/ldg_taxi_up")
		command_once("aerobask/lights/ldg_taxi_up")
	end
end,
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 2 then
		command_once("aerobask/lights/ldg_taxi_dn")
	end
end,
nil,
function ()
	if get("aerobask/lights/sw_ldg_taxi") > 1 then
		return 1
	else
		return 0
	end
end)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 2 then
		return 1
	else
		return 0
	end
end)

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","sim/cockpit2/switches/generic_lights_switch",1)
sysLights.domeLightSwitch2 	= TwoStateDrefSwitch:new("dome2","sim/cockpit2/switches/generic_lights_switch",2)
sysLights.domeLightSwitch3 	= TwoStateDrefSwitch:new("dome3","sim/cockpit2/switches/generic_lights_switch",3)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch3)

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "sim/cockpit2/switches/generic_lights_switch",1) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","aerobask/lights/knob_panel",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)

-- panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","sim/cockpit2/switches/generic_lights_switch",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)

sysLights.emerLights		= TwoStateCmdSwitch:new("emerlights","aerobask/elt/elt_on",0,
	"aerobask/lights/emer_lt_up","aerobask/lights/emer_lt_dn","nocommand")

return sysLights
