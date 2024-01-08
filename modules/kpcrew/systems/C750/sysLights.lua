-- C750 airplane 
-- aircraft lights specific functionality
-- ** default element for kphardware - must be in all classes of this system

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

local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","laminar/CitX/lights/gnd_rec_anti_coll",0,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") == 0 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
		end
	end,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") == 1 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_dwn")
		end
	end,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") == 1 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_dwn")
		elseif get("laminar/CitX/lights/gnd_rec_anti_coll") == 0 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
		end
	end	
)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights","sim/cockpit/electrical/beacon_lights_on",0)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateToggleSwitch:new("position","laminar/CitX/lights/navigation",0,
	"laminar/CitX/lights/cmd_navigation_toggle")

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights","laminar/CitX/lights/navigation",0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCustomSwitch:new("strobes","sim/cockpit2/switches/strobe_lights_on",0,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") ~= 2 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
		end
	end,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") == 2 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_dwn")
		end
	end,
	function () 
		if get("laminar/CitX/lights/gnd_rec_anti_coll") == 2 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_dwn")
		elseif get("laminar/CitX/lights/gnd_rec_anti_coll") ~= 2 then
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
			command_once("laminar/CitX/lights/cmd_gnd_rec_anti_coll_up")
		end
	end
)

-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/strobe_lights_on",0)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateToggleSwitch:new("taxi","laminar/CitX/lights/taxi",0,
	"laminar/CitX/lights/cmd_taxi_toggle")

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights","sim/cockpit2/switches/taxi_light_on",0)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateToggleSwitch:new("llleft","laminar/CitX/lights/landing_left",0,
	"laminar/CitX/lights/cmd_landing_left_toggle")
sysLights.llRightSwitch 	= TwoStateToggleSwitch:new("llright","laminar/CitX/lights/landing_right",0,
	"laminar/CitX/lights/cmd_landing_right_toggle")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get("laminar/CitX/lights/landing_left") > 0 or get("laminar/CitX/lights/landing_right") > 0 then
		return 1
	else
		return 0
	end
end)

-- Logo Light
sysLights.logoSwitch 		= TwoStateToggleSwitch:new("logo","laminar/CitX/lights/tail_flood",0,
	"laminar/CitX/lights/cmd_tail_flood_toggle")

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights","sim/cockpit2/switches/generic_lights_switch",0)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefGenericLights,1)
sysLights.rwyRightSwitch 	= TwoStateDrefSwitch:new("rwyright",drefGenericLights,2)
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- runway turnoff lights
sysLights.runwayAnc 		= CustomAnnunciator:new("runwaylights",
function () 
	if get(drefGenericLights,1) > 0 or get(drefGenericLights,2) > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Lights
sysLights.wingSwitch 		= InopSwitch:new("wing")

-- Wing Light(s) status
sysLights.wingAnc 			= InopSwitch:new("winglights")

-- Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")

-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome","sim/cockpit/electrical/cockpit_lights",0)
sysLights.panel1Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",-1)
sysLights.panel2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",1)
sysLights.panel3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",2)
sysLights.panel4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/panel_brightness_ratio",3)
sysLights.domeLightGroup 	= SwitchGroup:new("dome and panel")
sysLights.domeLightGroup:addSwitch(sysLights.panel1Light)
sysLights.domeLightGroup:addSwitch(sysLights.panel2Light)
sysLights.domeLightGroup:addSwitch(sysLights.panel3Light)
sysLights.domeLightGroup:addSwitch(sysLights.panel4Light)
sysLights.rwyLightGroup:addSwitch(sysLights.domeLightSwitch)

-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get( "sim/cockpit/electrical/cockpit_lights",0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",-1)
sysLights.instr2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",1)
sysLights.instr3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",2)
sysLights.instr4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",3)
sysLights.instr5Light		= TwoStateCustomSwitch:new("instr","laminar/CitX/lights/right_knob",0,
	function () 
		set("laminar/CitX/lights/right_knob",1)
		set("laminar/CitX/lights/left_knob",1)
		set("sim/cockpit2/switches/instrument_brightness_ratio",1)
	end,
	function () 
		set("laminar/CitX/lights/right_knob",0)
		set("laminar/CitX/lights/left_knob",0)
		set("sim/cockpit2/switches/instrument_brightness_ratio",0)
	end,
	function () 
		if get("laminar/CitX/lights/right_knob") == 1 then
			set("laminar/CitX/lights/right_knob",0)
			set("laminar/CitX/lights/left_knob",0)
			set("sim/cockpit2/switches/instrument_brightness_ratio",0)
		else
			set("laminar/CitX/lights/left_knob",1)
			set("laminar/CitX/lights/right_knob",1)
			set("sim/cockpit2/switches/instrument_brightness_ratio",1)
		end
	end
)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)

-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio",0)

-- Display Brightness
sysLights.disp1Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",7)
sysLights.disp2Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",8)
sysLights.disp3Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",9)
sysLights.disp4Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",10)
sysLights.disp5Light		= TwoStateDrefSwitch:new("","sim/cockpit2/switches/instrument_brightness_ratio",11)
sysLights.dispLightGroup 	= SwitchGroup:new("displaybrightness")
sysLights.dispLightGroup:addSwitch(sysLights.disp1Light)
sysLights.dispLightGroup:addSwitch(sysLights.disp2Light)
sysLights.dispLightGroup:addSwitch(sysLights.disp3Light)
sysLights.dispLightGroup:addSwitch(sysLights.disp4Light)
sysLights.dispLightGroup:addSwitch(sysLights.disp5Light)


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