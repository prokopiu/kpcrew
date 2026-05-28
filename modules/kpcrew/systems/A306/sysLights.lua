-- A306 airplane 
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

logMsg("A306 sysLights")

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","A300/lights/beacon_light_switch",0)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","A300/lights/beacon_light_switch",0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position","A300/lights/nav_logo_light_switch",0)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","A300/lights/nav_logo_light_switch",0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes","A300/lights/strobe_light_on",0)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","A300/lights/strobe_light_on",0)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","A300/lights/nose_light_switch",0)
-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/taxi_light_on",0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft","A300/lights/landing_light_left_switch",0,
	function () 
		set("A300/lights/landing_light_left_switch",2)
	end,
	function () 
		set("A300/lights/landing_light_left_switch",0)
	end,
	function () 
		if get("A300/lights/landing_light_left_switch") == 0 then
			set("A300/lights/landing_light_left_switch",2)
		else
			set("A300/lights/landing_light_left_switch",0)
		end
	end,
	function () 
		if get("A300/lights/landing_light_left_switch") > 0 then
			return 1
		else
			return 0
		end
	end)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llright","A300/lights/landing_light_right_switch",0,
	function () 
		set("A300/lights/landing_light_right_switch",2)
	end,
	function () 
		set("A300/lights/landing_light_right_switch",0)
	end,
	function () 
		if get("A300/lights/landing_light_right_switch") == 0 then
			set("A300/lights/landing_light_right_switch",2)
		else
			set("A300/lights/landing_light_right_switch",0)
		end
	end,
	function () 
		if get("A300/lights/landing_light_right_switch") > 0 then
			return 1
		else
			return 0
		end
	end)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get("A300/lights/landing_light_left_switch") > 1 or get("A300/lights/landing_light_right_switch") > 1 then
		return 1
	else
		return 0
	end
end)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","A300/lights/wing_light_switch",0)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights","A300/lights/wing_light_switch",0)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateCustomSwitch:new("logo","A300/lights/nav_logo_light_switch",0,
	function () 
		set("A300/lights/nav_logo_light_switch",2)
	end,
	function ()
		set("A300/lights/nav_logo_light_switch",1)
	end,
	function () 
		if get("A300/lights/nav_logo_light_switch") == 2 then
			set("A300/lights/nav_logo_light_switch",1)
		else
			set("A300/lights/nav_logo_light_switch",2)
		end
	end,
	function () 
		if get("A300/lights/nav_logo_light_switch") == 2 then
			return 1
		else
			return 0
		end
	end)
	
-- Logo Light(s) status
sysLights.logoAnc 			= CustomAnnunciator:new("logolights",
	function () 
		if get("A300/lights/nav_logo_light_switch") == 2 then
			return 1
		else
			return 0
		end
	end)

-- **RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft","A300/lights/rwy_turnoff_left_switch",0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright","A300/lights/rwy_turnoff_right_switch",0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)
-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get("A300/lights/rwy_turnoff_left_switch",0) > 0 or get("A300/lights/rwy_turnoff_right_switch",0) > 0 then
		return 1
	else
		return 0
	end
end)	

-- ---- internal lights

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","A300/brightness/dome_light_switch",0)
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
-- Dome Light(s) status
sysLights.domeAnc 			= SimpleAnnunciator:new("domelights","A300/brightness/dome_light_switch",0)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","A300/brightness/capt_ctr_instrument_light_knob",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","A300/brightness/pfd_brightness",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","A300/brightness/nd_brightness",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","A300/brightness/nd_wxr_brightness",0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("","A300/brightness/mcu_brightness",0)
sysLights.instr6Light		= TwoStateDrefSwitch:new("","A300/brightness/pfd2_brightness",0)
sysLights.instr7Light		= TwoStateDrefSwitch:new("","A300/brightness/nd2_wxr_brightness",0)
sysLights.instr8Light		= TwoStateDrefSwitch:new("","A300/brightness/nd2_brightness",0)
sysLights.instr9Light		= TwoStateDrefSwitch:new("","A300/brightness/pedestal_light_knob",0)
sysLights.instr10Light		= TwoStateDrefSwitch:new("","A300/brightness/overhead_int_light_switch",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr9Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr10Light)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights","A300/brightness/capt_ctr_instrument_light_knob",0)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1","A300/brightness/main_instrument_light_knob",0)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)

sysLights.emerLights		= TwoStateDrefSwitch:new("emerlights","A300/brightness/emergency_exit_light",0)

return sysLights
