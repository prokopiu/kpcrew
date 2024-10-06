-- ToLiss A20n/A21N
-- aircraft lights specific functionality

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
sysLights.beaconSwitch 		= TwoStateCustomSwitch:new("beacon","AirbusFBW/OHPLightSwitches",0,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconOn")
	end,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconOff")
	end,
	function () 
		command_once("toliss_airbus/lightcommands/BeaconToggle")
	end,
	function () 
		return get("AirbusFBW/OHPLightSwitches",0)
	end
)

-- TwoStateDrefSwitch:new("beacon","AirbusFBW/OHPLightSwitches",-1)

-- Position Lights, single onoff command driven
sysLights.positionSwitch = TwoStateCmdSwitch:new("position","sim/cockpit2/switches/navigation_lights_on",0,"sim/lights/nav_lights_on","sim/lights/nav_lights_off","sim/lights/nav_lights_toggle")

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch = TwoStateDrefSwitch:new("strobes","AirbusFBW/OHPLightSwitches",7)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch = TwoStateDrefSwitch:new("taxi","AirbusFBW/OHPLightSwitches",3)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch = TwoStateDrefSwitch:new("llleft","AirbusFBW/OHPLightSwitches",4)
sysLights.llRightSwitch = TwoStateDrefSwitch:new("llright","AirbusFBW/OHPLightSwitches",5)

sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch = TwoStateDrefSwitch:new("logo","AirbusFBW/OHPLightSwitches",2)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch = TwoStateDrefSwitch:new("rwyleft","AirbusFBW/OHPLightSwitches",3)
sysLights.rwyRightSwitch = TwoStateDrefSwitch:new("rwyright","AirbusFBW/OHPLightSwitches",6)

sysLights.rwyLightGroup = SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch = InopSwitch:new("wing")

-- Wheel well Lights
sysLights.wheelSwitch = InopSwitch:new("wheel")

-- Dome Light
sysLights.domeLightSwitch = TwoStateDrefSwitch:new("wheel","ckpt/oh/domeLight/anim",0)

-- Instrument Lights
sysLights.instr1Light = TwoStateDrefSwitch:new("instr1","AirbusFBW/OHPBrightnessLevel",0)
sysLights.instr2Light = TwoStateDrefSwitch:new("","AirbusFBW/PanelFloodBrightnessLevel",0)
sysLights.instr3Light = TwoStateDrefSwitch:new("","AirbusFBW/PanelBrightnessLevel",0)
sysLights.instr4Light = TwoStateDrefSwitch:new("","AirbusFBW/PedestalFloodBrightnessLevel",0)
sysLights.instr5Light = TwoStateDrefSwitch:new("","AirbusFBW/DUBrightness",0)
sysLights.instr6Light = TwoStateDrefSwitch:new("","AirbusFBW/FCUIntegralBrightness",0)

sysLights.instrLightGroup = SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
-- sysLights.instrLightGroup:setValue(0)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc = CustomAnnunciator:new("landinglights",
function () 
	if get("AirbusFBW/OHPLightSwitches",3) > 0 or get("AirbusFBW/OHPLightSwitches",6) > 0 then
		return 1
	else
		return 0
	end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc = SimpleAnnunciator:new("beaconlights","AirbusFBW/OHPLightSwitches",0)

-- Position Light(s) status
sysLights.positionAnc = SimpleAnnunciator:new("positionlights","sim/cockpit2/switches/navigation_lights_on",0)

-- Strobe Light(s) status
sysLights.strobesAnc = SimpleAnnunciator:new("strobelights","AirbusFBW/OHPLightSwitches",7)

-- Taxi Light(s) status
sysLights.taxiAnc = SimpleAnnunciator:new("strobelights","AirbusFBW/OHPLightSwitches",3)

-- Logo Light(s) status
sysLights.logoAnc = SimpleAnnunciator:new("logolights","AirbusFBW/OHPLightSwitches",2)

-- runway turnoff lights
sysLights.runwayAnc = CustomAnnunciator:new("runwaylights",
function () 
	if get("AirbusFBW/OHPLightSwitches",4) > 0 or get("AirbusFBW/OHPLightSwitches",5) > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Light(s) status
sysLights.wingAnc = InopSwitch:new("winglights",drefGenericLights, 3)

-- Wheel well Light(s) status
sysLights.wheelAnc = InopSwitch:new("wheellights",drefGenericLights,5)

-- Dome Light(s) status
sysLights.domeAnc = CustomAnnunciator:new("domelights",
function () 
	if get("ckpt/oh/domeLight/anim") ~= 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Light(s) status
sysLights.instrumentAnc = InopSwitch:new("instrumentlights", "sim/cockpit2/switches/instrument_brightness_ratio")

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