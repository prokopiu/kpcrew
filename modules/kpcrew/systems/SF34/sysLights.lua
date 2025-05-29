-- SF34 airplane 
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

logMsg("SF34 sysLights")

-- ** means it is needed for kphardware to work
-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateToggleSwitch:new("beacon","les/sf34a/acft/ltng/anm/beacon_lights_switch",0,
	"les/sf34a/acft/ltng/mnp/beacon_lights_switch")
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","les/sf34a/acft/ltng/anm/beacon_lights_switch",0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateToggleSwitch:new("position","les/sf34a/acft/ltng/anm/navigation_lights_switch",0,
	"les/sf34a/acft/ltng/mnp/navigation_lights_switch")
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","les/sf34a/acft/ltng/anm/navigation_lights_switch",0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateToggleSwitch:new("strobes","les/sf34a/acft/ltng/anm/strobe_lights_switch",0,
	"les/sf34a/acft/ltng/mnp/strobe_lights_switch")
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","les/sf34a/acft/ltng/anm/strobe_lights_switch",0)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateToggleSwitch:new("taxi","les/sf34a/acft/ltng/anm/taxi_lights_switch",0,
	"les/sf34a/acft/ltng/mnp/taxi_lights_switch")
-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","les/sf34a/acft/ltng/anm/taxi_lights_switch",0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateToggleSwitch:new("llleft","les/sf34a/acft/ltng/anm/landing_lights_switch_L",0,
	"les/sf34a/acft/ltng/mnp/landing_lights_switch_L")
sysLights.llRightSwitch 	= TwoStateToggleSwitch:new("llright","les/sf34a/acft/ltng/anm/landing_lights_switch_R",0,
	"les/sf34a/acft/ltng/mnp/landing_lights_switch_R")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get("les/sf34a/acft/ltng/anm/landing_lights_switch_L") > 0 or get("les/sf34a/acft/ltng/anm/landing_lights_switch_R") > 0 then
		return 1
	else
		return 0
	end
end)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateToggleSwitch:new("wing","les/sf34a/acft/ltng/anm/wing_lights_switch",0,
	"les/sf34a/acft/ltng/mnp/wing_lights_switch")
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","les/sf34a/acft/ltng/anm/wing_lights_switch",0)

-- **Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")
-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")

-- **Logo Light
sysLights.logoSwitch 		= InopSwitch:new("logo")
-- Logo Light(s) status
sysLights.logoAnc 			= InopSwitch:new("logolights")

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= InopSwitch:new("rwyleft")
sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= InopSwitch:new("runwaylights")

sysLights.emerLights		= TwoStateCustomSwitch:new("emerlights","les/sf34a/acft/emrg/anm/emergency_lights_switch",0,
	function ()
		if get("les/sf34a/acft/emrg/anm/emergency_lights_switch") == 0 then
			command_once("les/sf34a/acft/emrg/mnp/emergency_lights_switch_up")
		end
	end,
	function ()
		if get("les/sf34a/acft/emrg/anm/emergency_lights_switch") ~= 0 then
			command_once("les/sf34a/acft/emrg/mnp/emergency_lights_switch_dn")
			command_once("les/sf34a/acft/emrg/mnp/emergency_lights_switch_dn")
		end
	end,
	function ()
	end,
	function ()
		if get("les/sf34a/acft/emrg/anm/emergency_lights_switch") ~= 0 then
			return 1
		else
			return 0
		end
	end)
	
-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateToggleSwitch:new("dome","les/sf34a/acft/ltng/anm/int_dome_switch",0,
	"les/sf34a/acft/ltng/mnp/int_dome_switch")
sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get("les/sf34a/acft/ltng/anm/int_dome_switch") ~= 0 then
		return 1
	else
		return 0
	end
end)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","les/sf34a/acft/ltng/mnp/int_lights/panel_knob",0)
sysLights.panel2Light		= TwoStateCustomSwitch:new("panellight2","les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_pilot",0,
	function ()
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_pilot")
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_pilot")
	end,
	function ()
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_pilot")
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_pilot")
	end,
	function ()
		if get("les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_pilot") == 0 then
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_pilot")
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_pilot")
		else
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_pilot")
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_pilot")
		end
	end,
	function ()
		if get("les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_pilot") > 0 then 
			return 1
		else
			return 0
		end
	end)
sysLights.panel3Light		= TwoStateCustomSwitch:new("panellight3","les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_copilot",0,
	function ()
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_copilot")
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_copilot")
	end,
	function ()
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_copilot")
		command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_copilot")
	end,
	function ()
		if get("les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_copilot") == 0 then
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_copilot")
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_up_copilot")
		else
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_copilot")
			command_once("les/sf34a/acft/ltng/mnp/mcp_flood_lights_switch_dn_copilot")
		end
	end,
	function ()
		if get("les/sf34a/acft/ltng/anm/mcp_flood_lights_switch_copilot") > 0 then 
			return 1
		else
			return 0
		end
	end)
sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4","les/sf34a/acft/ltng/mnp/mcp_flood_lights_knob_L",0)
sysLights.panel5Light		= TwoStateDrefSwitch:new("panellight5","les/sf34a/acft/ltng/mnp/mcp_flood_lights_knob_C",0)
sysLights.panel6Light		= TwoStateDrefSwitch:new("panellight6","les/sf34a/acft/ltng/mnp/mcp_flood_lights_knob_R",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel5Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel6Light)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","les/sf34a/acft/ltng/mnp/mcp_inst_lights_knob_L",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","les/sf34a/acft/ltng/mnp/mcp_inst_lights_knob_R",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","les/sf34a/acft/ltng/mnp/int_lights/ctr_pnls_knob",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","les/sf34a/acft/ltng/mnp/int_lights/digits_knob",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)

return sysLights
