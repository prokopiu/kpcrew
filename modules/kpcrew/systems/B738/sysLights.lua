-- B738 airplane (X-Plane 11 default)
-- aircraft lights specific functionality

local sysLights = {
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch = require "kpcrew.systems.InopSwitch"

local drefLLRetLeft = "laminar/B738/lights/land_ret_left_pos"
local drefLLRetRight = "laminar/B738/lights/land_ret_right_pos"
local drefLLLeft = "laminar/B738/switch/land_lights_left_pos"
local drefLLRight = "laminar/B738/switch/land_lights_right_pos"
local drefRWYLeft = "laminar/B738/toggle_switch/rwy_light_left"
local drefRWYRight = "laminar/B738/toggle_switch/rwy_light_right"
local drefPanelBright = "laminar/B738/electric/panel_brightness"
local drefGenericLights = "sim/cockpit2/switches/generic_lights_switch"

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch = TwoStateCmdSwitch:new("beacon","sim/cockpit/electrical/beacon_lights_on",0,"sim/lights/beacon_lights_on","sim/lights/beacon_lights_off","sim/lights/beacon_lights_toggle")

-- Position Lights, single onoff command driven
sysLights.positionSwitch = TwoStateCmdSwitch:new("position","sim/cockpit2/switches/navigation_lights_on",0,"laminar/B738/toggle_switch/position_light_steady","laminar/B738/toggle_switch/position_light_off","nocommand")

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch = TwoStateCmdSwitch:new("strobes","sim/cockpit2/switches/navigation_lights_on",0,"laminar/B738/toggle_switch/position_light_strobe","laminar/B738/toggle_switch/position_light_off","nocommand")

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch = TwoStateCmdSwitch:new("taxi","laminar/B738/toggle_switch/taxi_light_brightness_pos",0,"laminar/B738/toggle_switch/taxi_light_brightness_on","laminar/B738/toggle_switch/taxi_light_brightness_off","laminar/B738/toggle_switch/taxi_light_brigh_toggle")

-- Landing Lights, single onoff command driven
sysLights.llRetLeftSwitch = TwoStateCmdSwitch:new("llretleft",drefLLRetLeft,0,"laminar/B738/switch/land_lights_ret_left_on","laminar/B738/switch/land_lights_ret_left_off","nocommand")
sysLights.llRetRightSwitch = TwoStateCmdSwitch:new("llretright",drefLLRetRight,0,"laminar/B738/switch/land_lights_ret_right_on","laminar/B738/switch/land_lights_ret_right_off","nocommand")
sysLights.llLeftSwitch = TwoStateCmdSwitch:new("llleft",drefLLLeft,0,"laminar/B738/switch/land_lights_left_on","laminar/B738/switch/land_lights_left_off","nocommand")
sysLights.llRightSwitch = TwoStateCmdSwitch:new("llright",drefLLRight,0,"laminar/B738/switch/land_lights_right_on","laminar/B738/switch/land_lights_right_off","nocommand")

sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llRetLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRetRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch = TwoStateCmdSwitch:new("logo","laminar/B738/toggle_switch/logo_light",0,"laminar/B738/switch/logo_light_on","laminar/B738/switch/logo_light_off","laminar/B738/switch/logo_light_toggle")

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch = TwoStateCmdSwitch:new("rwyleft",drefRWYLeft,0,"laminar/B738/switch/rwy_light_left_on","laminar/B738/switch/rwy_light_left_off","laminar/B738/switch/rwy_light_left_toggle")
sysLights.rwyRightSwitch = TwoStateCmdSwitch:new("rwyright",drefRWYRight,0,"laminar/B738/switch/rwy_light_right_on","laminar/B738/switch/rwy_light_right_off","laminar/B738/switch/rwy_light_right_toggle")

sysLights.rwyLightGroup = SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch = TwoStateCmdSwitch:new("wing",drefGenericLights,0,"laminar/B738/switch/wing_light_on","laminar/B738/switch/wing_light_off","laminar/B738/switch/wing_light_toggle")

-- Wheel well Lights
sysLights.wheelSwitch = TwoStateDrefSwitch:new("wheel",drefGenericLights,5)

-- Dome Light
sysLights.domeLightSwitch = TwoStateCustomSwitch:new("dome","laminar/B738/toggle_switch/cockpit_dome_pos",0,
function ()
	command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
end,
function ()
	command_once("laminar/B738/toggle_switch/cockpit_dome_up")
	command_once("laminar/B738/toggle_switch/cockpit_dome_up")
	command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
end,
nil)

-- Instrument Lights
sysLights.instr1Light = TwoStateDrefSwitch:new("instr1",drefPanelBright,0)
sysLights.instr2Light = TwoStateDrefSwitch:new("instr2",drefPanelBright,1)
sysLights.instr3Light = TwoStateDrefSwitch:new("instr3",drefPanelBright,2)
sysLights.instr4Light = TwoStateDrefSwitch:new("instr4",drefPanelBright,3)
sysLights.instr5Light = TwoStateDrefSwitch:new("instr5",drefGenericLights,6)
sysLights.instr6Light = TwoStateDrefSwitch:new("instr6",drefGenericLights,7)
sysLights.instr7Light = TwoStateDrefSwitch:new("instr7",drefGenericLights,8)

sysLights.instrLightGroup = SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc = CustomAnnunciator:new("landinglights",
function () 
	if get(drefLLLeft) > 0 or get(drefLLRight) > 0  or get(drefLLRetRight) > 0 or get(drefLLRetRight) > 0 then
		return 1
	else
		return 0
	end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc = SimpleAnnunciator:new("beaconlights","sim/cockpit/electrical/beacon_lights_on",0)

-- Position Light(s) status
sysLights.positionAnc = SimpleAnnunciator:new("positionlights","sim/cockpit2/switches/navigation_lights_on",0)

-- Strobe Light(s) status
sysLights.strobesAnc = SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/navigation_lights_on",0)

-- Taxi Light(s) status
sysLights.taxiAnc = CustomAnnunciator:new("taxilights",
function () 
	if get("laminar/B738/toggle_switch/taxi_light_brightness_pos") > 0 then
		return 1
	else
		return 0
	end
end)

-- Logo Light(s) status
sysLights.logoAnc = SimpleAnnunciator:new("logolights","laminar/B738/toggle_switch/logo_light",0)

-- runway turnoff lights
sysLights.runwayAnc = CustomAnnunciator:new("runwaylights",
function () 
	if get(drefRWYLeft) > 0 or get(drefRWYRight) > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Light(s) status
sysLights.wingAnc = SimpleAnnunciator:new("winglights",drefGenericLights,0)

-- Wheel well Light(s) status
sysLights.wheelAnc = SimpleAnnunciator:new("wheellights",drefGenericLights,5)

-- Dome Light(s) status
sysLights.domeAnc = CustomAnnunciator:new("domelights",
function () 
	if get( "laminar/B738/toggle_switch/cockpit_dome_pos",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Light(s) status
sysLights.instrumentAnc = CustomAnnunciator:new("instrumentlights",
function () 
	if get(drefPanelBright,0) > 0 or get(drefPanelBright,1) > 0  or get(drefPanelBright,2) > 0  or get(drefPanelBright,3) > 0 or get(drefGenericLights,6) > 0  or get(drefGenericLights,7) > 0  or get(drefGenericLights,8) > 0 then
		return 1
	else
		return 0
	end
end)

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
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 930, ypos-height)
		end
	end

	kc_imgui_label_mcp("LIGHTS:",10)
	kc_imgui_label_mcp("LAND:",10)
	kc_imgui_toggle_button_mcp("LEFT R",sysLights.llRetLeftSwitch,10,53,25)
	kc_imgui_toggle_button_mcp("RIGHT R",sysLights.llRetRightSwitch,10,53,25)
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