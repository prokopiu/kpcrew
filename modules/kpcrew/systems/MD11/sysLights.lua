-- Rotate MD-11
-- aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
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

----------- Switches

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateToggleSwitch:new("beacon","Rotate/aircraft/controls/beacon_lts",0,
	"Rotate/aircraft/controls_c/beacon_lts")

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateToggleSwitch:new("position","sim/cockpit/electrical/nav_lights_on",0,
	"Rotate/aircraft/controls_c/nav_lts")

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateToggleSwitch:new("strobes","Rotate/aircraft/controls/strobe_lts",0,
	"Rotate/aircraft/controls_c/strobe_lts")

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCustomSwitch:new("llleft","Rotate/aircraft/controls/nose_lts",0,
function () 
	set("Rotate/aircraft/controls/nose_lts",2)
end,
function () 
	set("Rotate/aircraft/controls/nose_lts",0)
end,
function () 
	if get("Rotate/aircraft/controls/nose_lts") ~= 0 then
		set("Rotate/aircraft/controls/nose_lts",0)
	else
		set("Rotate/aircraft/controls/nose_lts",2)
	end
end
)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateCustomSwitch:new("llleft","Rotate/aircraft/controls/ldg_l_lts",0,
function () 
	set("Rotate/aircraft/controls/ldg_l_lts",2)
end,
function () 
	set("Rotate/aircraft/controls/ldg_l_lts",0)
end,
function () 
	if get("Rotate/aircraft/controls/ldg_l_lts") ~= 0 then
		set("Rotate/aircraft/controls/ldg_l_lts",0)
	else
		set("Rotate/aircraft/controls/ldg_l_lts",2)
	end
end
)
sysLights.llRightSwitch 	= TwoStateCustomSwitch:new("llleft","Rotate/aircraft/controls/ldg_r_lts",0,
function () 
	set("Rotate/aircraft/controls/ldg_r_lts",2)
end,
function () 
	set("Rotate/aircraft/controls/ldg_r_lts",0)
end,
function () 
	if get("Rotate/aircraft/controls/ldg_r_lts") ~= 0 then
		set("Rotate/aircraft/controls/ldg_r_lts",0)
	else
		set("Rotate/aircraft/controls/ldg_r_lts",2)
	end
end
)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch 		= TwoStateToggleSwitch:new("logo","Rotate/aircraft/controls/logo_lts",0,
	"Rotate/aircraft/controls_c/logo_lts")

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateToggleSwitch:new("rwyleft","Rotate/aircraft/controls/wing_l_lts",0,
	"Rotate/aircraft/controls_c/wing_l_lts")
sysLights.rwyRightSwitch 	= TwoStateToggleSwitch:new("rwyright","Rotate/aircraft/controls/wing_r_lts",0,
	"Rotate/aircraft/controls_c/wing_r_lts")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch 		= InopSwitch:new("wing")

-- Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateToggleSwitch:new("dome","sim/cockpit2/switches/generic_lights_switch",25,
	"Rotate/aircraft/controls_c/dome_lts")

-- Instrument Lights
sysLights.instr1Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/fgs_flood_lts",0)
sysLights.instr2Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/fgs_panel_lts",0)
sysLights.instr3Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/ovhd_panel_lts",0)
sysLights.instr4Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/instr_panel_lts",0)
sysLights.instr5Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/avncs_panel_lts",0)
sysLights.instr6Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/ovhd_flood_lts",0)
sysLights.instr7Light 		= TwoStateDrefSwitch:new("","Rotate/aircraft/controls/instr_flood_lts",0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)

--------- Annunciators

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if sysLights.landLightGroup:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","Rotate/aircraft/controls/beacon_lts",0)

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","sim/cockpit/electrical/nav_lights_on",0)

-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","Rotate/aircraft/controls/strobe_lts",0)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","Rotate/aircraft/controls/nose_lts",0)

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","Rotate/aircraft/controls/logo_lts",0)

-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if sysLights.rwyLightGroup:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Light(s) status
sysLights.wingAnc 			= InopSwitch:new("wingLights")

-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if sysLights.domeLightSwitch:getStatus() ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Light(s) status
sysLights.instrumentAnc 	= SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",0)

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
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 735, ypos-height)
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
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("DOME",sysLights.domeLightSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("INSTR",sysLights.instrLightGroup,10,45,25)

end

return sysLights