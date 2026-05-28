-- B46X airplane 
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

logMsg("B46X sysLights")

-- ** means it is needed for kphardware to work
-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","thranda/SwitchMonitor",83,
	function ()
		if math.floor(get("thranda/SwitchMonitor",83)) == 0 then
			command_once("thranda/switches/SwitchDn83")
		end
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",83)) > 0 then
			command_once("thranda/switches/SwitchDn83")
		end	
	end,
	function ()
		command_once("thranda/switches/SwitchDn83")
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",83)) > 0 then
			return 1
		else
			return 0
		end
	end)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= CustomAnnunciator:new("beaconlights",
	function ()
		if math.floor(get("thranda/SwitchMonitor",83)) > 0 then
			return 1
		else
			return 0
		end
	end)
	
-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateCustomSwitch:new("position","thranda/SwitchMonitor",85,
	function ()
		if get("thranda/SwitchMonitor",85) < 0.2 then
			command_once("thranda/switches/SwitchUp85")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",85) > 1.9 then
			command_once("thranda/switches/SwitchUp85")
		end
	end,
	function ()
		command_once("thranda/switches/SwitchUp85")
	end,
	function ()
		if get("thranda/SwitchMonitor",85) > 1.5 then
			return 1
		else
			return 0
		end
	end)
-- Position Light(s) status
sysLights.positionAnc 		= CustomAnnunciator:new("positionlights",
	function ()
		if get("thranda/SwitchMonitor",85) > 1.5 then
			return 1
		else
			return 0
		end
	end)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","thranda/SwitchMonitor",84,
	function ()
		if math.floor(get("thranda/SwitchMonitor",84)) == 0 then
			command_once("thranda/switches/SwitchUp84")
		end
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",84)) > 0 then
			command_once("thranda/switches/SwitchUp84")
		end
	end,
	function ()
		command_once("thranda/switches/SwitchUp84")
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",84)) > 0 then
			return 1
		else
			return 0
		end
	end)
-- Strobe Light(s) status
sysLights.strobesAnc 		= CustomAnnunciator:new("strobelights",
	function ()
		if get("thranda/SwitchMonitor",84) > 0 then
			return 1
		else
			return 0
		end
	end)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch		= TwoStateCustomSwitch:new("taxi1","thranda/SwitchMonitor",110,
	function ()
		if get("thranda/SwitchMonitor",110) == 1 then
			command_once("thranda/switches/SwitchDn109")
			command_once("thranda/switches/SwitchDn110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 0 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 0 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		end
		if get("thranda/SwitchMonitor",110) == 1 then
			command_once("thranda/switches/SwitchDn109")
			command_once("thranda/switches/SwitchDn110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 0 then
			return 1
		elseif get("thranda/SwitchMonitor",110) == 1 then
			return 0
		else
			return 0
		end
	end)

-- Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
	function ()
		if get("thranda/SwitchMonitor",110) == 0 then
			return 1
		elseif get("thranda/SwitchMonitor",110) == 1 then
			return 0
		else
			return 0
		end
	end)
	
-- **Landing Lights, single onoff command driven
sysLights.landLightGroup 		= TwoStateCustomSwitch:new("llleft","thranda/SwitchMonitor",110,
	function ()
		if get("thranda/SwitchMonitor",110) == 0 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		end
		if get("thranda/SwitchMonitor",110) == 1 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 2 then
			command_once("thranda/switches/SwitchDn109")
			command_once("thranda/switches/SwitchDn110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 1 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		elseif get("thranda/SwitchMonitor",110) == 0 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		elseif get("thranda/SwitchMonitor",110) == 2 then
			command_once("thranda/switches/SwitchUp109")
			command_once("thranda/switches/SwitchUp110")
		end
	end,
	function ()
		if get("thranda/SwitchMonitor",110) == 2 then
			return 1
		elseif get("thranda/SwitchMonitor",110) == 1 then
			return 0
		else
			return 0
		end
	end)
sysLights.llLeftSwitch = sysLights.landLightGroup
sysLights.llRightSwitch = sysLights.landLightGroup

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
	function ()
		if get("thranda/SwitchMonitor",110) == 2 then
			return 1
		elseif get("thranda/SwitchMonitor",110) == 1 then
			return 0
		else
			return 0
		end
	end)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateCustomSwitch:new("wing","thranda/SwitchMonitor",89,
	function ()
		if math.floor(get("thranda/SwitchMonitor",89)) == 0 then
			command_once("thranda/switches/SwitchUp89")
		end
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",89)) > 0 then
			command_once("thranda/switches/SwitchUp89")
		end
	end,
	function ()
		command_once("thranda/switches/SwitchUp89")
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",89)) > 0 then
			return 1
		else
			return 0
		end
	end)
-- Wing Light(s) status
sysLights.wingAnc 			= CustomAnnunciator:new("winglights",
	function ()
		if math.floor(get("thranda/SwitchMonitor",89)) > 0 then
			return 1
		else
			return 0
		end
	end)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateCustomSwitch:new("logo","thranda/SwitchMonitor",90,
	function ()
		if math.floor(get("thranda/SwitchMonitor",90)) == 0 then
			command_once("thranda/switches/SwitchUp90")
		end
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",90)) > 0 then
			command_once("thranda/switches/SwitchUp90")
		end
	end,
	function ()
		command_once("thranda/switches/SwitchUp90")
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",90)) > 0 then
			return 1
		else
			return 0
		end
	end)
-- Logo Light(s) status
sysLights.logoAnc 			= CustomAnnunciator:new("logolights",
	function ()
		if get("thranda/SwitchMonitor",90) > 0 then
			return 1
		else
			return 0
		end
	end)
	
-- **RWY Turnoff Lights
-- sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,1)
-- sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright",drefGenericLights,2)
sysLights.rwyLightGroup 	= TwoStateCustomSwitch:new("rwylights","thranda/SwitchMonitor",40,
	function ()
		if math.floor(get("thranda/SwitchMonitor",40)) == 0 then
			command_once("thranda/switches/SwitchUp40")
		end
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",40)) > 0 then
			command_once("thranda/switches/SwitchUp40")
		end
	end,
	function ()
		command_once("thranda/switches/SwitchUp40")
	end,
	function ()
		if math.floor(get("thranda/SwitchMonitor",40)) > 0 then
			return 1
		else
			return 0
		end
	end)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
	function ()
		if math.floor(get("thranda/SwitchMonitor",40)) > 0 then
			return 1
		else
			return 0
		end
	end)

-- ---- internal lights

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","sim/cockpit2/switches/generic_lights_switch",1)
sysLights.domeLightSwitch2 	= TwoStateDrefSwitch:new("dome2","sim/cockpit2/switches/generic_lights_switch",3)
sysLights.domeLightSwitch3 	= TwoStateDrefSwitch:new("dome3","sim/cockpit2/switches/generic_lights_switch",6)
sysLights.domeLightSwitch4 	= TwoStateDrefSwitch:new("dome4","sim/cockpit2/switches/generic_lights_switch",7)
sysLights.domeLightSwitch5 	= TwoStateDrefSwitch:new("dome5","sim/cockpit2/switches/generic_lights_switch",8)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch3)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch4)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch5)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "sim/cockpit2/switches/generic_lights_switch",1) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",2)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",3)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",7)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",8)
sysLights.instr5Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",9)
sysLights.instr6Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",10)
sysLights.instr7Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",13)
sysLights.instr8Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",14)

sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",2)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","sim/cockpit2/switches/generic_lights_switch",10)
-- sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","sim/cockpit2/switches/generic_lights_switch",12)
-- sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3","sim/cockpit2/switches/panel_brightness_ratio",2)
-- sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4","sim/cockpit2/switches/panel_brightness_ratio",3)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
-- sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
-- sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
-- sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)

sysLights.emerLights		= InopSwitch:new("emerlights")

return sysLights
