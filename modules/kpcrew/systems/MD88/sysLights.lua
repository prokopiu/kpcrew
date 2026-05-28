-- MD88 Rotate airplane 
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

logMsg("MD88 sysLights")

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","Rotate/md80/lights/anticollision_light_switch",0)
	
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","Rotate/md80/lights/anticollision_light_switch",0)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","Rotate/md80/lights/pos_strobe_light_switch",0,
	function () 
		if get("Rotate/md80/lights/pos_strobe_light_switch") == 0 then
			command_once("Rotate/md80/lights/pos_strobe_light_switch_down")
		end
	end,
	function () 
		if get("Rotate/md80/lights/pos_strobe_light_switch") == 1 then
			command_once("Rotate/md80/lights/pos_strobe_light_switch_up")
		end
	end,
	function () 
	end,
	function () 
		if get("Rotate/md80/lights/pos_strobe_light_switch") > 0 then
			return 1
		else
			return 0
		end

	end)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","Rotate/md80/lights/pos_strobe_light_switch",0,
	function () 
		command_once("Rotate/md80/lights/pos_strobe_light_switch_down")
		command_once("Rotate/md80/lights/pos_strobe_light_switch_down")
	end,
	function () 
		if get("Rotate/md80/lights/pos_strobe_light_switch") == 2 then
			command_once("Rotate/md80/lights/pos_strobe_light_switch_up")
		end
	end,
	function () 
	end,
	function () 
		if get("Rotate/md80/lights/pos_strobe_light_switch") > 1 then
			return 1
		else
			return 0
		end

	end)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","Rotate/md80/lights/nose_light_switch",0)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch = TwoStateCustomSwitch:new("llleft","Rotate/md80/lights/wing_ldg_light_switch_r",0,
function () 
	set("Rotate/md80/lights/wing_ldg_light_switch_r",2)
end,
function () 
	set("Rotate/md80/lights/wing_ldg_light_switch_r",0)
end,
function () 
	if get("Rotate/md80/lights/wing_ldg_light_switch_r") >= 0 then
		set("Rotate/md80/lights/wing_ldg_light_switch_r",0)
	else
		set("Rotate/md80/lights/wing_ldg_light_switch_r",0)
	end
end,
function () 
	if get("Rotate/md80/lights/wing_ldg_light_switch_r") == 2 then
		return 1
	else
		return 0
	end
end)

sysLights.llRightSwitch = TwoStateCustomSwitch:new("llright","Rotate/md80/lights/wing_ldg_light_switch_l",0,
function () 
	set("Rotate/md80/lights/wing_ldg_light_switch_l",2)
end,
function () 
	set("Rotate/md80/lights/wing_ldg_light_switch_l",0)
end,
function () 
	if get("Rotate/md80/lights/wing_ldg_light_switch_l") >= 0 then
		set("Rotate/md80/lights/wing_ldg_light_switch_l",0)
	else
		set("Rotate/md80/lights/wing_ldg_light_switch_l",2)
	end
end,
function () 
	if get("Rotate/md80/lights/wing_ldg_light_switch_l") == 2 then
		return 1
	else
		return 0
	end
end)

sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)

-- Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo","Rotate/md80/lights/logo_light_switch",0)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","Rotate/md80/lights/flood_light_switch_l",0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright","Rotate/md80/lights/flood_light_switch_r",0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","Rotate/md80/lights/wing_light_switch",0)



return sysLights
