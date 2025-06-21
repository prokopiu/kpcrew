-- ER1X airplane 
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

logMsg("ER1X sysLights")

sysLights.emerLights		= TwoStateDrefSwitch:new("emerlights","sim/cockpit2/switches/generic_lights_switch",23)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefGenericLights,11)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights, 11)

-- **Dome Light
sysLights.domeLightGroup 	= TwoStateCustomSwitch:new("dome","XCrafts/cockpit_light",0,
	function () 
		command_once("XCrafts/Lights/cockpit_dome_on")
		set("XCrafts/cockpit_light",2.5)
	end,
	function () 
		command_once("XCrafts/Lights/cockpit_dome_off")
	end,
	function () 
		set("XCrafts/cockpit_light",2.5)
		command_once("XCrafts/Lights/cockpit_dome_toggle")
	end,
	function () 
		if get( "XCrafts/cockpit_light") > 0 then
			return 1
		else
			return 0
		end
	end)	

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "XCrafts/cockpit_light") > 0 then
		return 1
	else
		return 0
	end
end)

return sysLights
