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
local drefWingLights		= "1-sim/9/switch"
local drefLogoLights		= "1-sim/5/switch"
local drefDomeLight			= "1-sim/lights/integ/Rotery"
local drefInstrLight1		= "1-sim/lights/pedestal/Rotery"
local drefInstrLight2		= "1-sim/lights/mainPnl/Rotery"
local drefInstrLight3		= "1-sim/lights/side/Rotery"
local drefInstrLight4		= "1-sim/lights/conLightRotery"
local drefInstrLight5		= "1-sim/lights/map/Rotery"


--------- Annunciator datarefs common


--------- Switch commands common


--------- Actuator definitions

-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateDrefSwitch:new("beacon",drefBeaconLights,0)

-- Position Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position",drefNavLights,0)

-- Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateDrefSwitch:new("strobes",drefStrobeLights,0)

-- Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCustomSwitch:new("taxi",drefTaxiLights,0,
	function () 
		set(drefTaxiLights,1)
	end,
	function () 
		set(drefTaxiLights,2)
	end,
	function () 
		if get(drefTaxiLights) == 2 then
			set(drefTaxiLights,1)
		else
			set(drefTaxiLights,2)
		end
	end,
	function () 
		if get(drefTaxiLights) == 2 then
			return 0
		else
			return 1
		end
	end
)

-- Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLandingLight1,0)
-- sysLights.llRightSwitch 	= InopSwitch:new("llright")
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
-- sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)

-- Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo",drefLogoLights,0)

-- RWY Turnoff Lights
sysLights.rwyLeftSwitch 	= TwoStateDrefSwitch:new("rwyleft",drefRWYTurnoff,0)
-- sysLights.rwyRightSwitch 	= InopSwitch:new("rwyright")
sysLights.rwyLightGroup 	= SwitchGroup:new("runwaylights")
sysLights.rwyLightGroup:addSwitch(sysLights.rwyLeftSwitch)
-- sysLights.rwyLightGroup:addSwitch(sysLights.rwyRightSwitch)

-- Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefWingLights,0)

-- Wheel well Lights
sysLights.wheelSwitch 		= InopSwitch:new("wheel")

-- Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome",drefDomeLight,0)

-- Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("Lights",drefInstrLight1,0)
sysLights.instr2Light		= TwoStateDrefSwitch:new("",drefInstrLight2,0)
sysLights.instr3Light		= TwoStateDrefSwitch:new("",drefInstrLight3,0)
sysLights.instr4Light		= TwoStateDrefSwitch:new("",drefInstrLight4,0)
sysLights.instr5Light		= TwoStateDrefSwitch:new("",drefInstrLight5,0)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)

--------- Annunciators
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= SimpleAnnunciator:new("landinglights",drefLandingLight1,0)

-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights",drefBeaconLights,0)

-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights",drefNavLights,0)

-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights",drefStrobeLights,0)

-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("taxilights",drefTaxiLights,0)

-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights",drefLogoLights,0)

-- runway turnoff lights
sysLights.runwayAnc 		= SimpleAnnunciator:new("runwaylights",drefRWYTurnoff,0)

-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefWingLights,0)

-- Wheel well Light(s) status
sysLights.wheelAnc 			= InopSwitch:new("wheellights")

-- Dome Light(s) status
sysLights.domeAnc 			= SimpleAnnunciator:new("domelights",drefDomeLight,0)

-- Instrument Light(s) status
sysLights.instrumentAnc 	= InopSwitch:new("instrumentlights")

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
	kc_imgui_toggle_button_mcp("LAND",sysLights.llLeftSwitch,10,42,25)
	kc_imgui_toggle_button_mcp("RWYs",sysLights.rwyLeftSwitch,10,42,25)
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