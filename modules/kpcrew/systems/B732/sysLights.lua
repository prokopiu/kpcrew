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

local drefGenericLights = "sim/cockpit2/switches/instrument_brightness_ratio"

-- Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch = TwoStateDrefSwitch:new("beacon","FJS/732/lights/AntiColLightSwitch",0)

-- Position Lights, single onoff command driven
sysLights.positionSwitch = TwoStateDrefSwitch:new("position","FJS/732/lights/PositionLightSwitch",0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch = TwoStateDrefSwitch:new("strobes","FJS/732/lights/StrobeLightSwitch",0)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch = TwoStateDrefSwitch:new("taxi","FJS/732/lights/TaxiLightSwitch",0)

-- Landing Lights, single onoff command driven
sysLights.llRetLeftSwitch = TwoStateCustomSwitch:new("llretleft","FJS/732/lights/OutBoundLLightSwitch1",0,
function ()
	set("FJS/732/lights/OutBoundLLightSwitch1",2)
end,
function ()
	set("FJS/732/lights/OutBoundLLightSwitch1",0)
end,
function ()
	if get("FJS/732/lights/OutBoundLLightSwitch1") == 0 then
		set("FJS/732/lights/OutBoundLLightSwitch1",2)
	else
		set("FJS/732/lights/OutBoundLLightSwitch1",0)
	end
end)
sysLights.llRetRightSwitch = TwoStateCustomSwitch:new("llretright","FJS/732/lights/OutBoundLLightSwitch2",0,
function ()
	set("FJS/732/lights/OutBoundLLightSwitch2",2)
end,
function ()
	set("FJS/732/lights/OutBoundLLightSwitch2",0)
end,
function ()
	if get("FJS/732/lights/OutBoundLLightSwitch2") == 0 then
		set("FJS/732/lights/OutBoundLLightSwitch2",2)
	else
		set("FJS/732/lights/OutBoundLLightSwitch2",0)
	end
end)
sysLights.llLeftSwitch = TwoStateDrefSwitch:new("llleft","FJS/732/lights/InBoundLLightSwitch1",0)
sysLights.llRightSwitch = TwoStateDrefSwitch:new("llright","FJS/732/lights/InBoundLLightSwitch2",0)

sysLights.landLightGroup = SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llRetLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRetRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch = TwoStateDrefSwitch:new("logo","FJS/732/lights/LogoLightSwitch",0)

-- RWY Turnoff Lights (2)
sysLights.rwyLeftSwitch = TwoStateDrefSwitch:new("rwyleft","FJS/732/lights/RunwayTurnoffSwitch1",0)
sysLights.rwyRightSwitch = TwoStateDrefSwitch:new("rwyright","FJS/732/lights/RunwayTurnoffSwitch2",0)

sysLights.rwyLightGroup = SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch = TwoStateDrefSwitch:new("wing","FJS/732/lights/WingLightSwitch",0)

-- Wheel well Lights
sysLights.wheelSwitch = InopSwitch:new("wheel")

-- Dome Light
sysLights.domeLightSwitch = TwoStateCustomSwitch:new("dome","FJS/732/lights/DomeWhiteSwitch",0,
function () 
	set("FJS/732/lights/DomeWhiteSwitch",1)
end,
function ()
	set("FJS/732/lights/DomeWhiteSwitch",0)
end, nil)

-- Instrument Lights
sysLights.instr1Light = TwoStateDrefSwitch:new("instr1",drefGenericLights,1)
sysLights.instr2Light = TwoStateDrefSwitch:new("instr2",drefGenericLights,2)
sysLights.instr3Light = TwoStateDrefSwitch:new("instr3",drefGenericLights,3)
sysLights.instr4Light = TwoStateDrefSwitch:new("instr4",drefGenericLights,4)
sysLights.instr5Light = TwoStateDrefSwitch:new("instr5",drefGenericLights,5)
sysLights.instr6Light = TwoStateDrefSwitch:new("instr6",drefGenericLights,6)
sysLights.instr7Light = TwoStateDrefSwitch:new("instr7",drefGenericLights,7)
sysLights.instr8Light = TwoStateDrefSwitch:new("instr8",drefGenericLights,8)


sysLights.instrLightGroup = SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr6Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr7Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr8Light)

sysLights.instrLightGroup:actuate(modeOff)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc = CustomAnnunciator:new("landinglights",
function () 
	if sysLights.landLightGroup:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc = SimpleAnnunciator:new("beaconlights","FJS/732/lights/AntiColLightSwitch",0)

-- Position Light(s) status
sysLights.positionAnc = SimpleAnnunciator:new("positionlights","FJS/732/lights/PositionLightSwitch",0)

-- Strobe Light(s) status
sysLights.strobesAnc = SimpleAnnunciator:new("strobelights","FJS/732/lights/StrobeLightSwitch",0)

-- Taxi Light(s) status
sysLights.taxiAnc = SimpleAnnunciator:new("taxilights","FJS/732/lights/TaxiLightSwitch",0)

-- Logo Light(s) status
sysLights.logoAnc = SimpleAnnunciator:new("logolights","FJS/732/lights/LogoLightSwitch",0)

-- runway turnoff lights
sysLights.runwayAnc = CustomAnnunciator:new("runwaylights",
function () 
	if sysLights.rwyLightGroup:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

-- Wing Light(s) status
sysLights.wingAnc = SimpleAnnunciator:new("winglights","FJS/732/lights/WingLightSwitch",0)

-- Wheel well Light(s) status
sysLights.wheelAnc = CustomAnnunciator:new("wheellights", function () return 0 end )

-- Dome Light(s) status
sysLights.domeAnc = CustomAnnunciator:new("domelights",
function () 
	if get("FJS/732/lights/DomeWhiteSwitch") > 0 then
		return 1
	else
		return 0
	end
end)

-- Instrument Light(s) status
sysLights.instrumentAnc = CustomAnnunciator:new("instrumentlights",
function () 
	if sysLights.instrLightGroup:getStatus() > 0 then 
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

	if kh_light_wnd_state == 0 then
		imgui.Button("L", 17, 25)
		if imgui.IsItemActive() then 
			kh_light_wnd_state = 1
			float_wnd_set_geometry(kh_light_wnd, 0, ypos, 900, ypos - height)
		end
	end

	kc_imgui_label_mcp("LIGHTS:",10)
	kc_imgui_label_mcp("LAND:",10)
	kc_imgui_toggle_button_mcp("LEFT",sysLights.llLeftSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("RIGHT",sysLights.llRightSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("RLEFT",sysLights.llRetLeftSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("RRIGHT",sysLights.llRetRightSwitch,10,42,25)
	kc_imgui_simple_button_mcp("ALL",sysLights.landLightGroup,10,42,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("RWYs",sysLights.rwyLightGroup,10,42,25)
	kc_imgui_toggle_button_mcp("TAXI",sysLights.taxiSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("LOGO",sysLights.logoSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("STRB",sysLights.strobesSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("POS",sysLights.positionSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("BEAC",sysLights.beaconSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("WING",sysLights.wingSwitch,10,42,25)
	kc_imgui_label_mcp("|",10)
	kc_imgui_toggle_button_mcp("DOME",sysLights.domeLightSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("INSTR",sysLights.instrLightGroup,10,45,25)

end

return sysLights