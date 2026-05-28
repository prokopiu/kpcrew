-- B744 airplane 
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

logMsg("B744 sysLights")

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","sim/cockpit/electrical/beacon_lights_on",0,
function ()
	command_once("laminar/B747/toggle_switch/beacon_light_down")
	command_once("laminar/B747/toggle_switch/beacon_light_down")
end,
function () 
	command_once("laminar/B747/toggle_switch/beacon_light_up")
end,
function ()
	if get("sim/cockpit/electrical/beacon_lights_on") == 0 then
		command_once("laminar/B747/toggle_switch/beacon_light_down")
		command_once("laminar/B747/toggle_switch/beacon_light_down")
	else
		command_once("laminar/B747/toggle_switch/beacon_light_up")
	end
end)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateToggleSwitch:new("position","sim/cockpit2/switches/navigation_lights_on",0,
	"laminar/B747/toggle_switch/nav_light")

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","sim/cockpit2/switches/navigation_lights_on",0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateToggleSwitch:new("strobes","sim/cockpit2/switches/strobe_lights_on",0,
	"laminar/B747/toggle_switch/strobe_light")

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateToggleSwitch:new("taxi","sim/cockpit2/switches/taxi_light_on",0,
	"laminar/B747/toggle_switch/taxi_light")

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft",drefLandingLights,-1,
	function ()
		if get(drefLandingLights,0) == 0 then
			command_once("laminar/B747/toggle_switch/landing_light_OBL")
		end
	end,
	function ()
		if get(drefLandingLights,0) ~= 0 then
			command_once("laminar/B747/toggle_switch/landing_light_OBL")
		end
	end,
	function ()
	end,
	function ()
		if get(drefLandingLights,0) == 0 then
			return 0
		else
			return 1
		end
	end)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llright",drefLandingLights,1,
	function ()
		if get(drefLandingLights,1) == 0 then
			command_once("laminar/B747/toggle_switch/landing_light_IBL")
		end
	end,
	function ()
		if get(drefLandingLights,1) ~= 0 then
			command_once("laminar/B747/toggle_switch/landing_light_IBL")
		end
	end,
	function ()
	end,
	function ()
		if get(drefLandingLights,1) == 0 then
			return 0
		else
			return 1
		end
	end)
sysLights.ll3rdSwitch 		= TwoStateCustomSwitch:new("ll3rd",drefLandingLights,2,
	function ()
		if get(drefLandingLights,2) == 0 then
			command_once("laminar/B747/toggle_switch/landing_light_IBR")
		end
	end,
	function ()
		if get(drefLandingLights,2) ~= 0 then
			command_once("laminar/B747/toggle_switch/landing_light_IBR")
		end
	end,
	function ()
	end,
	function ()
		if get(drefLandingLights,2) == 0 then
			return 0
		else
			return 1
		end
	end)
sysLights.ll4thSwitch 		= TwoStateCustomSwitch:new("ll4th",drefLandingLights,3,
	function ()
		if get(drefLandingLights,3) == 0 then
			command_once("laminar/B747/toggle_switch/landing_light_OBR")
		end
	end,
	function ()
		if get(drefLandingLights,3) ~= 0 then
			command_once("laminar/B747/toggle_switch/landing_light_OBR")
		end
	end,
	function ()
	end,
	function ()
		if get(drefLandingLights,3) == 0 then
			return 0
		else
			return 1
		end
	end)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)

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
sysLights.logoSwitch 		= TwoStateToggleSwitch:new("logo",drefGenericLights,3,
	"laminar/B747/toggle_switch/logo_light")

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","sim/cockpit2/switches/generic_lights_switch",10)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateToggleSwitch:new("rwyleft",drefGenericLights,-1,
	"laminar/B747/toggle_switch/rwy_tunoff_L")
sysLights.rwyRightSwitch 	= TwoStateToggleSwitch:new("rwyright",drefGenericLights,1,
	"laminar/B747/toggle_switch/rwy_tunoff_R")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get(drefGenericLights,-1) > 0 or get(drefGenericLights,1) > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateToggleSwitch:new("wing",drefGenericLights,2,
	"laminar/B747/toggle_switch/wing_light")

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights, 2)

-- Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")

-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")


return sysLights