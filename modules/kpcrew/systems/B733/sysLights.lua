-- B733 IXEG B737 Plus
-- aircraft lights specific functionality
-- ** default element for kphardware - must be in all classes of this system

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
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

local drefLLRetLeft 		= "ixeg/733/lighting/r_inboard_ll_act"
local drefLLRetRight 		= "ixeg/733/lighting/l_inboard_ll_act"
local drefLLLeft 			= "ixeg/733/lighting/r_outboard_ll_act"
local drefLLRight 			= "ixeg/733/lighting/l_outboard_ll_act"
local drefRWYLeft 			= "ixeg/733/lighting/l_rwy_turnoff_act"
local drefRWYRight 			= "ixeg/733/lighting/r_rwy_turnoff_act"
local drefPanelBright 		= "sim/cockpit2/electrical/instrument_brightness_ratio"
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"

-- ** Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon","ixeg/733/lighting/anti_col_lt_act",0)

-- ** Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position","ixeg/733/lighting/position_lt_act",0)

-- ** Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes","ixeg/733/lighting/strobe_lt_act",0)

-- ** Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateDrefSwitch:new("taxi","ixeg/733/lighting/taxi_lt_act",0)

-- ** Landing Lights, single onoff command driven
sysLights.llRetLeftSwitch 	= TwoStateDrefSwitch:new("llretleft",drefLLRetLeft,0)
sysLights.llRetRightSwitch 	= TwoStateDrefSwitch:new("llretright",drefLLRetRight,0)
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLLLeft,0)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright",drefLLRight,0)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llRetLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRetRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- ** Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo","ixeg/733/lighting/logo_lt_act",0)

-- ** RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefRWYLeft,0)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright",drefRWYRight,0)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- ** Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing","ixeg/733/lighting/wing_lt_act",0)

-- ** Wheel well Lights
sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel","ixeg/733/lighting/wheel_well_lt_act",0)

-- ** Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","ixeg/733/misc/dome_light_act",0)

-- ** Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("instr1","ixeg/733/rheostats/light_afds_act",0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("instr2","ixeg/733/rheostats/light_breakers_act",0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("instr3","ixeg/733/rheostats/light_overhead_act",0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("instr4","ixeg/733/rheostats/light_pedpanel_act",0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("instr5","ixeg/733/rheostats/light_pedflood_act",0)
sysLights.instr6Light		= TwoStateDrefSwitch:new("instr6",drefGenericLights,-1)
sysLights.instr7Light		= TwoStateDrefSwitch:new("instr7",drefGenericLights,1)
sysLights.instr8Light		= TwoStateDrefSwitch:new("instr8",drefGenericLights,2)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)
-- sysLights.instrLightGroup:actuate(modeOff)

--------- Annunciators
-- ** annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get(drefLLLeft) > 0 or get(drefLLRight) > 0  or get(drefLLRetRight) > 0 or get(drefLLRetRight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","sim/cockpit/electrical/beacon_lights_on",0)

-- ** Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","ixeg/733/lighting/position_lt_act",0)

-- ** Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/navigation_lights_on",0)

-- ** Taxi Light(s) status
sysLights.taxiAnc 			= CustomAnnunciator:new("taxilights",
function () 
	if get("ixeg/733/lighting/taxi_lt_act") > 0 then
		return 1
	else
		return 0
	end
end)

-- ** Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","ixeg/733/lighting/logo_lt_act",0)

-- ** Runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get(drefRWYLeft) > 0 or get(drefRWYRight) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights,0)

-- ** Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellights",drefGenericLights,5)

-- ** Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "ixeg/733/misc/dome_light_act",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- ** Instrument Light(s) status
sysLights.instrumentAnc 	= CustomAnnunciator:new("instrumentlights",
function () 
	if get(drefPanelBright,0) > 0 or get(drefPanelBright,1) > 0  or get(drefPanelBright,2) > 0  or get("ixeg/733/rheostats/light_afds_act",0) > 0 or get("ixeg/733/rheostats/light_breakers_act",0) > 0  or get("ixeg/733/rheostats/light_overhead_act",0) > 0 or get("ixeg/733/rheostats/light_pedpanel_act",0) > 0  or get("ixeg/733/rheostats/light_pedflood_act",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- ===== UI related functions =====

-- render the MCP part
function sysLights:render(ypos, height)

	-- reposition when screen size changes
	if kh_light_wnd_state < 0 then
		float_wnd_set_position(kh_light_wnd, 0, kh_scrn_height - ypos)
		float_wnd_set_geometry(kh_light_wnd, 0, ypos, 25, ypos - height)
		kh_light_wnd_state = 0
	end
	
	imgui.SetCursorPosY(10)
	imgui.SetCursorPosX(2)
	
	if kh_light_wnd_state == 1 then
		imgui.Button("<", 17, 25)
		if imgui.IsItemActive() then 
			kh_light_wnd_state = 0
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 25, ypos - height)
		end
	end

	local xsize = 935

	if kh_light_wnd_state == 0 then
		imgui.Button("L", 17, 25)
		if imgui.IsItemActive() then 
			kh_light_wnd_state = 1
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, xsize, ypos - height)
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