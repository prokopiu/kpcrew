-- A350 
-- aircraft lights specific functionality
-- ** default element for kphardware - must be in all classes of this system

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysLights = {
}

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

--------- Switch datarefs common

local drefBeaconLights		= "1-sim/3/switch"
local drefStrobeLights		= "1-sim/2/switch"
local drefNavLights			= "1-sim/4/switch"
local drefTaxiLights		= "1-sim/11/switch"
local drefRWYTurnoff		= "1-sim/8/switch"
local drefLandingLight1		= "1-sim/10/switch"

-- local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
-- local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
-- local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
-- local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

--------- Annunciator datarefs common


--------- Switch commands common


--------- Actuator definitions



----------- Switches

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon",drefBeaconLights,0)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position",drefNavLights,0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes",drefStrobeLights,0)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi",drefTaxiLights,0)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLandingLight1,0)
-- sysLights.llRightSwitch 	= InopSwitch:new("llright")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
-- sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch 		= InopSwitch:new("logo")

-- RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefStrobeLights,0)
-- sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
-- sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch 		= InopSwitch:new("wing")

-- Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")

-- Dome Light
sysLights.domeLightSwitch 	= InopSwitch:new("dome")

-- Instrument Lights
sysLights.instr1Light		= InopSwitch:new("Lights")
-- sysLights.instr2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",-1)
-- sysLights.instr3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",2)
-- sysLights.instr4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",-1)
-- sysLights.instr5Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",3)
-- sysLights.instr6Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",1)
-- sysLights.instr7Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",1)
-- sysLights.instr8Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",2)
-- sysLights.instr9Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",3)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
-- sysLights.instrLightGroup:addSwitch(sysLights.instr9Light)
-- sysLights.instrLightGroup:actuate(0)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	-- if get(drefLandingLights,0) > 0 or get(drefLandingLights,1) > 0  or get(drefLandingLights,2) > 0 or get(drefLandingLights,3) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","sim/cockpit/electrical/beacon_lights_on",0)

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","sim/cockpit2/switches/navigation_lights_on",0)

-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/strobe_lights_on",0)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/taxi_light_on",0)

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","sim/cockpit2/switches/generic_lights_switch",0)

-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	-- if get(drefGenericLights,1) > 0 or get(drefGenericLights,2) > 0 then
		-- return 1
	-- else
		return 0
	-- end
end)

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights, 3)

-- Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellights",drefGenericLights,5)

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "sim/cockpit/electrical/cockpit_lights",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",0)

-- ===== UI related functions =====

-- render the MCP part
function sysLights:render(ypos,height)

	-- reposition when screen size changes
	if kh_light_wnd_state < 0 then
		float_wnd_set_position(kh_light_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_light_wnd, 0, ypos, 25, ypos-height)
		kh_light_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_light_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_light_wnd_state = 0
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 25, ypos-height)
		end
	end

	if kh_light_wnd_state == 0 then
		imgui.Button("L", 17, 25)
		if imgui.IsItemActive() then 
			kh_light_wnd_state = 1
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 815, ypos-height)
		end
	end

	kc_imgui_label_mcp("LIGHTS:",10)
	kc_imgui_label_mcp("LAND:",10)
	kc_imgui_toggle_button_mcp("LEFT",sysLights.llLeftSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("RIGHT",sysLights.llRightSwitch,10,42,25)
	kc_imgui_simple_button_mcp("ALL",sysLights.landLightGroup,10,42,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("RWYs",sysLights.rwyLightGroup,10,42,25)
	kc_imgui_toggle_button_mcp("TAXI",sysLights.taxiSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("LOGO",sysLights.logoSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("STRB",sysLights.strobesSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("POS",sysLights.positionSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("BEAC",sysLights.beaconSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("WING",sysLights.wingSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("WHL",sysLights.wheelSwitch,10,42,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("DOME",sysLights.domeLightSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("INSTR",sysLights.instrLightGroup,10,45,25)

end

return sysLights