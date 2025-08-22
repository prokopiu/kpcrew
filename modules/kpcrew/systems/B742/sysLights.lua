-- B742 airplane 
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

logMsg("B742 sysLights")

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","B742/ext_light/beacon_sw",0)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","B742/ext_light/beacon_sw",0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes","B742/ext_light/strobe_sw",0)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","B742/ext_light/strobe_sw",0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position","B742/ext_light/NAV_sw",0)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","B742/ext_light/NAV_sw",0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft","B742/ext_light/landing_outbd_L_sw",0)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright","B742/ext_light/landing_outbd_R_sw",0)
sysLights.ll3rdSwitch 		= TwoStateDrefSwitch:new("ll3rd","B742/ext_light/landing_inbd_L_sw",0)
sysLights.ll4thSwitch 		= TwoStateDrefSwitch:new("ll4th","B742/ext_light/landing_inbd_R_sw",0)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","B742/ext_light/runway_turnoff_L_sw",0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright","B742/ext_light/runway_turnoff_R_sw",0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get("B742/ext_light/runway_turnoff_R_sw") > 0 or get("B742/ext_light/runway_turnoff_L_sw") > 0 then
		return 1
	else
		return 0
	end
end)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 	= SwitchGroup:new("taxilights")
sysLights.taxiSwitch:addSwitch(sysLights.rwyLeftSwitch)
sysLights.taxiSwitch:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.taxiAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	return sysLights.runwayAnc:getStatus()
end)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo","B742/ext_light/logo_sw",0)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","B742/ext_light/logo_sw",0)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","B742/ext_light/wing_sw",0)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","B742/ext_light/wing_sw", 0)

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","B742/cockpit_light/dome",0)
sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get("B742/cockpit_light/dome") ~= 0 then
		return 1
	else
		return 0
	end
end)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","B742/cockpit_light/main_panel_bkgr",0)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2","B742/cockpit_light/map_left_panel",0)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3","B742/cockpit_light/map_right_panel",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("instrlite1","B742/cockpit_light/center_fwd_panel",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("instrlite2","B742/cockpit_light/control_stand_panel",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("instrlite3","B742/cockpit_light/front_left_big_panel",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("instrlite4","B742/cockpit_light/front_panel",0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("instrlite5","B742/cockpit_light/front_right_big_panel",0)
sysLights.instr6Light		= TwoStateDrefSwitch:new("instrlite6","B742/cockpit_light/FE_panel",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)

sysLights.emerLights		= TwoStateCustomSwitch:new("emerlights","B742/OVHD/emerg_lights_sw",0,
	function() 
		set("B742/OVHD/emerg_lights_sw",1)
		set("B742/OVHD/emerg_lights_cap",0)
	end,
	function() 
		set("B742/OVHD/emerg_lights_sw",0)
		set("B742/OVHD/emerg_lights_cap",1)
	end,
	function() 
		if get("B742/OVHD/emerg_lights_sw") == 0 then
			set("B742/OVHD/emerg_lights_sw",1)
			set("B742/OVHD/emerg_lights_cap",0)
		else
			set("B742/OVHD/emerg_lights_sw",0)
			set("B742/OVHD/emerg_lights_cap",1)
		end
	end,
	function() 
		return get("B742/OVHD/emerg_lights_sw")
	end)

return sysLights
