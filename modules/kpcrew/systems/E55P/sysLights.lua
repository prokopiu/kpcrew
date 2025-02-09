-- E55P airplane 
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

logMsg("E55P sysLights")

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCustomSwitch:new("taxi","aerobask/lights/sw_ldg_taxi",0,
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 0 then
		command_once("aerobask/lights/ldg_taxi_up")
	end
end,
function ()
	if get("aerobask/lights/sw_ldg_taxi") == 1 then
		command_once("aerobask/lights/ldg_taxi_dn")
	end
end,
nil,
function ()
	if get("aerobask/lights/sw_ldg_taxi") > 0 then
		return 1
	else
		return 0
	end
end)

-- Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
function ()
	if get("aerobask/lights/sw_ldg_taxi") > 0 then
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

return sysLights
