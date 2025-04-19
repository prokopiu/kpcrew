-- MD82 airplane 
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

logMsg("MD82 sysLights")

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","laminar/md82/switches/navstrobe_lights_switch",0,
	function () 
		if get("laminar/md82/switches/navstrobe_lights_switch") == 0 then
			command_once("laminar/md82cmd/switches/navstrobe_lights_switch_dwn")
		end
	end,
	function () 
		if get("laminar/md82/switches/navstrobe_lights_switch") == 1 then
			command_once("laminar/md82cmd/switches/navstrobe_lights_switch_up")
		end
	end,
	function () 
	end,
	function () 
		if get("laminar/md82/switches/navstrobe_lights_switch") > 0 then
			return 1
		else
			return 0
		end

	end)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","laminar/md82/switches/navstrobe_lights_switch",0,
	function () 
		command_once("laminar/md82cmd/switches/navstrobe_lights_switch_dwn")
		command_once("laminar/md82cmd/switches/navstrobe_lights_switch_dwn")
	end,
	function () 
		if get("laminar/md82/switches/navstrobe_lights_switch") == 2 then
			command_once("laminar/md82cmd/switches/navstrobe_lights_switch_up")
		end
	end,
	function () 
	end,
	function () 
		if get("laminar/md82/switches/navstrobe_lights_switch") > 1 then
			return 1
		else
			return 0
		end

	end)

	
-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch = TwoStateCustomSwitch:new("llleft",drefLandingLights,1,
function () 
	set_array(drefLandingLights,1,1)
end,
function () 
	set_array(drefLandingLights,1,-1)
end,
function () 
	if get(drefLandingLights,1) >= 0 then
		set_array(drefLandingLights,1,-1)
	else
		set_array(drefLandingLights,1,1)
	end
end,
function () 
	if get(drefLandingLights,1) == 1 then
		return 1
	else
		return 0
	end
end)

sysLights.llRightSwitch = TwoStateCustomSwitch:new("llright",drefLandingLights,2,
function () 
	set_array(drefLandingLights,2,1)
end,
function () 
	set_array(drefLandingLights,2,-1)
end,
function () 
	if get(drefLandingLights,2) >= 0 then
		set_array(drefLandingLights,2,-1)
	else
		set_array(drefLandingLights,2,1)
	end
end,
function () 
	if get(drefLandingLights,2) == 1 then
		return 1
	else
		return 0
	end
end)

sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)

-- Logo Light
sysLights.logoSwitch 	= TwoStateToggleSwitch:new("logo",drefGenericLights,-1,
	"sim/lights/generic_01_light_tog")
	
-- Instrument Lights
sysLights.instr1Light = TwoStateDrefSwitch:new("",drefInstrLights,-1)
sysLights.instr2Light = TwoStateDrefSwitch:new("",drefInstrLights,2)
sysLights.instr3Light = TwoStateDrefSwitch:new("",drefPanelLights,1)
sysLights.instr4Light = TwoStateDrefSwitch:new("",drefPanelLights,2)
sysLights.instr5Light = TwoStateDrefSwitch:new("",drefPanelLights,3)
sysLights.instr6Light = TwoStateDrefSwitch:new("",drefInstrLights,3)
sysLights.instr7Light = TwoStateDrefSwitch:new("",drefInstrLights,4)

sysLights.instrLightGroup = SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)

return sysLights
