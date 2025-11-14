-- DFLT airplane (X-Plane default)
-- aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysLights.beaconSwitch
-- sysLights.beaconAnc
-- sysLights.positionSwitch
-- sysLights.positionAnc
-- sysLights.strobesSwitch 
-- sysLights.strobesAnc
-- sysLights.taxiSwitch 	
-- sysLights.taxiAnc
-- sysLights.llLeftSwitch 	
-- sysLights.llRightSwitch 
-- sysLights.ll3rdSwitch 	
-- sysLights.ll4thSwitch 	
-- sysLights.landLightGroup
-- sysLights.landingAnc
-- sysLights.wingSwitch
-- sysLights.wingAnc
-- sysLights.wheelSwitch
-- sysLights.wheelAnc
-- sysLights.logoSwitch
-- sysLights.logoAnc
-- sysLights.rwyLeftSwitch 	
-- sysLights.rwyRightSwitch
-- sysLights.rwyLightGroup 
-- sysLights.runwayAnc
-- sysLights.domeLightSwitch 
-- sysLights.domeLightSwitch2
-- sysLights.domeLightGroup 
-- sysLights.instr1Light
-- sysLights.instr2Light
-- sysLights.instr3Light
-- sysLights.instr4Light
-- sysLights.instr5Light
-- sysLights.instr6Light
-- sysLights.instrLightGroup
-- sysLights.instrumentAnc
-- sysLights.panel1Light
-- sysLights.panel2Light
-- sysLights.panel3Light
-- sysLights.panel4Light
-- sysLights.panelLightGroup 
-- sysLights.emerLights
-- Macro: kc_macro_lights
-- Macro: kc_macro_lights_climb_10k
-- Macro: kc_macro_lights_descend_10k
-- UI: panel_render

local sysLights = {
}

logMsg("DFLT sysLights")

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
local drefBeaconLight		= "sim/cockpit/electrical/beacon_lights_on"
local drefPositionLights	= "sim/cockpit2/switches/navigation_lights_on"
local drefStrobeLights		= "sim/cockpit2/switches/strobe_lights_on"
local drefTaxiLights		= "sim/cockpit2/switches/taxi_light_on"
local drefLandingLights 	= "sim/cockpit2/switches/landing_lights_switch"	
local drefGenericLights 	= "sim/cockpit2/switches/generic_lights_switch"
local drefInstrLights 		= "sim/cockpit2/switches/instrument_brightness_ratio"
local drefPanelLights 		= "sim/cockpit2/switches/panel_brightness_ratio"
local drefCockpitLights		= "sim/cockpit/electrical/cockpit_lights"

--------- Annunciator datarefs common

--------- Switch commands common
local cmdBeaconOn			= "sim/lights/beacon_lights_on"
local cmdBeaconOff			= "sim/lights/beacon_lights_off"
local cmdBeaconTgl			= "sim/lights/beacon_lights_toggle"
local cmdStrobesOn			= "sim/lights/strobe_lights_on"
local cmdStrobesOff			= "sim/lights/strobe_lights_off"
local cmdStrobesTgl			= "sim/lights/strobe_lights_toggle"
local cmdTaxiOn				= "sim/lights/taxi_lights_on"
local cmdTaxiOff			= "sim/lights/taxi_lights_off"
local cmdTaxiTgl			= "sim/lights/taxi_lights_toggle"

----------- Switches

-- ** means it is needed for kphardware to work
-- **Beacons or Anticollision Lights, single, onoff, command driven
sysLights.beaconSwitch 		= TwoStateCmdSwitch:new("beacon",drefBeaconLight,0,
	cmdBeaconOn,cmdBeaconOff,cmdBeaconTgl)
-- Beacons or Anticollision Light(s) status
sysLights.beaconAnc 		= SimpleAnnunciator:new("beaconlights",drefBeaconLight,0)

-- **Position (or Nav) Lights, single onoff command driven
sysLights.positionSwitch 	= TwoStateDrefSwitch:new("position",drefPositionLights,0)
-- Position Light(s) status
sysLights.positionAnc 		= SimpleAnnunciator:new("positionlights",drefPositionLights,0)

-- **Strobe Lights, single onoff command driven
sysLights.strobesSwitch 	= TwoStateCmdSwitch:new("strobes",drefStrobeLights,0,
	cmdStrobesOn,cmdStrobesOff,cmdStrobesTgl)
-- Strobe Light(s) status
sysLights.strobesAnc 		= SimpleAnnunciator:new("strobelights",drefStrobeLights,0)

-- **Taxi/Nose Lights, single onoff command driven
sysLights.taxiSwitch 		= TwoStateCmdSwitch:new("taxi",drefTaxiLights,0,
	cmdTaxiOn,cmdTaxiOff,cmdTaxiTgl)
-- Taxi Light(s) status
sysLights.taxiAnc 			= SimpleAnnunciator:new("strobelights",drefTaxiLights,0)

-- **Landing Lights, single onoff command driven
sysLights.llLeftSwitch 		= TwoStateDrefSwitch:new("llleft",drefLandingLights,-1)
sysLights.llRightSwitch 	= TwoStateDrefSwitch:new("llright",drefLandingLights,1)
sysLights.ll3rdSwitch 		= TwoStateDrefSwitch:new("ll3rd",drefLandingLights,2)
sysLights.ll4thSwitch 		= TwoStateDrefSwitch:new("ll4th",drefLandingLights,3)
sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
sysLights.landLightGroup:addSwitch(sysLights.llLeftSwitch)
sysLights.landLightGroup:addSwitch(sysLights.llRightSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll3rdSwitch)
sysLights.landLightGroup:addSwitch(sysLights.ll4thSwitch)
-- annunciator to mark any landing lights on
sysLights.landingAnc 		= CustomAnnunciator:new("landinglights",
function () 
	if get(drefLandingLights,0) > 0 or get(drefLandingLights,1) > 0  or get(drefLandingLights,2) > 0 or get(drefLandingLights,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- **Wing Lights
sysLights.wingSwitch 		= TwoStateDrefSwitch:new("wing",drefGenericLights,3)
-- Wing Light(s) status
sysLights.wingAnc 			= SimpleAnnunciator:new("winglights",drefGenericLights, 3)

-- **Wheel well Lights
sysLights.wheelSwitch 		= TwoStateDrefSwitch:new("wheel",drefGenericLights,11)
-- Wheel well Light(s) status
sysLights.wheelAnc 			= SimpleAnnunciator:new("wheellights",drefGenericLights,11)

-- **Logo Light
sysLights.logoSwitch 		= TwoStateDrefSwitch:new("logo",drefGenericLights,10)
-- Logo Light(s) status
sysLights.logoAnc 			= SimpleAnnunciator:new("logolights",drefGenericLights,10)

-- **RWY Turnoff Lights
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

-- ---- internal lights

-- **Dome Light
sysLights.domeLightSwitch 	= TwoStateDrefSwitch:new("dome",drefCockpitLights,-1)
sysLights.domeLightSwitch2 	= InopSwitch:new("dome2")
sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch)
sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
-- Dome Light(s) status
sysLights.domeAnc 			= CustomAnnunciator:new("domelights",
function () 
	if get(drefCockpitLights,0) ~= 0 then
		return 1
	else
		return 0
	end
end)

-- **Instrument Lights
sysLights.instr1Light		= TwoStateDrefSwitch:new("","sim/cockpit/electrical/instrument_brightness",-1)
sysLights.instr2Light		= TwoStateDrefSwitch:new("",drefInstrLights,-1)
sysLights.instr3Light		= TwoStateDrefSwitch:new("",drefInstrLights,1)
sysLights.instr4Light		= TwoStateDrefSwitch:new("",drefInstrLights,2)
sysLights.instr5Light		= TwoStateDrefSwitch:new("",drefInstrLights,3)
sysLights.instr6Light		= TwoStateDrefSwitch:new("",drefInstrLights,4)
sysLights.instrLightGroup 	= SwitchGroup:new("instrumentlights")
sysLights.instrLightGroup:addSwitch(sysLights.instr1Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr2Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr3Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr4Light)
sysLights.instrLightGroup:addSwitch(sysLights.instr5Light)
-- Instrument Light(s) status
sysLights.instrumentAnc = SimpleAnnunciator:new("instrumentlights", drefInstrLights,-1)

-- **Panel lights
sysLights.panel1Light		= TwoStateDrefSwitch:new("panellight1",drefPanelLights,-1)
sysLights.panel2Light		= TwoStateDrefSwitch:new("panellight2",drefPanelLights,1)
sysLights.panel3Light		= TwoStateDrefSwitch:new("panellight3",drefPanelLights,2)
sysLights.panel4Light		= TwoStateDrefSwitch:new("panellight4",drefPanelLights,3)
sysLights.panelLightGroup 	= SwitchGroup:new("panellights")
sysLights.panelLightGroup:addSwitch(sysLights.panel1Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel2Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel3Light)
sysLights.panelLightGroup:addSwitch(sysLights.panel4Light)

sysLights.emerLights		= InopSwitch:new("emerlights")

--------- Macros
function kc_macro_lights(flightphase)
	logMsg("Lights flight phase: " .. kcSopFlightPhase[flightphase])

	-- Cold & dark
	if flightphase == kc_phase_colddark then
		sysLights.landLightGroup:actuate(0)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(0)
		end
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(0)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(0)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(0)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(0)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(0)
		end
		if kc_has_dome_lights then
			sysLights.domeLightGroup:actuate(0)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_has_panel_lights then
			sysLights.panelLightGroup:actuate(0)
		end	
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(0)
		end
	elseif flightphase == kc_phase_turnaround then
		-- turnaround
		sysLights.landLightGroup:actuate(0)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(0)
		end
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(0)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(0)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(0)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_has_dome_lights then
			sysLights.domeLightGroup:actuate(0)
		end
		if kc_is_daylight() == false then
			if kc_has_dome_lights then
				sysLights.domeLightGroup:actuate(1)
			end
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
			if kc_has_wing_lights then
				sysLights.wingSwitch:actuate(1)
			end
			if kc_has_wheel_lights then
				sysLights.wheelSwitch:actuate(1)
			end
			if kc_has_panel_lights then
				sysLights.panelLightGroup:actuate(1)
			end
		end
	elseif flightphase == kc_phase_before_start then
		sysLights.landLightGroup:actuate(0)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(0)
		end
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(0)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(1)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(0)
		end
		if kc_has_strb_as_bcn then
			sysLights.strobesSwitch:actuate(1)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_is_daylight() == false then
			if kc_has_dome_lights then
				sysLights.domeLightGroup:actuate(1)
			end
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
			if kc_has_panel_lights then
				sysLights.panelLightGroup:actuate(1)
			end
		end
	elseif flightphase == kc_phase_taxi_rwy then
		sysLights.landLightGroup:actuate(0)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(0)
		end
		if kc_has_ll_as_taxi then
			sysLights.landLightGroup:actuate(1)
		end
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(1)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(1)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(0)
		end
		if kc_has_strb_as_bcn then
			sysLights.strobesSwitch:actuate(1)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
			if kc_has_panel_lights then
				sysLights.panelLightGroup:actuate(1)
			end
		end	
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(0)
		end
		sysLights.landLightGroup:actuate(1)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(1)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(1)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(1)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
			if kc_has_panel_lights then
				sysLights.panelLightGroup:actuate(1)
			end
		end	
	elseif flightphase == kc_phase_approach then
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(0)
		end
		sysLights.landLightGroup:actuate(1)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(1)
		end

		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(1)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(1)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end

		kc_macro_lights_descend_10k()

		if kc_is_daylight() == false then		
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
		end
	elseif flightphase == kc_phase_afterland then
		sysLights.landLightGroup:actuate(0)
		if kc_has_rwy_lights then
			sysLights.rwyLightGroup:actuate(0)
		end
		if kc_has_taxi_light then
			sysLights.taxiSwitch:actuate(1)
		end
		if kc_has_ll_as_taxi then
			sysLights.landLightGroup:actuate(1)
		end
		if kc_has_pos_lights then
			sysLights.positionSwitch:actuate(1)
		end
		if kc_has_beacon then
			sysLights.beaconSwitch:actuate(1)
		end
		if kc_has_strobe_lights then
			sysLights.strobesSwitch:actuate(0)
		end
		if kc_has_instr_lights then
			sysLights.instrLightGroup:actuate(1)
		end
		if kc_has_emer_lights then
			sysLights.emerLights:actuate(1)
		end
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(0)
		end
		if kc_has_wing_lights then
			sysLights.wingSwitch:actuate(0)
		end
		if kc_has_wheel_lights then
			sysLights.wheelSwitch:actuate(0)
		end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then
				sysLights.logoSwitch:actuate(1)
			end
			if kc_has_panel_lights then
				sysLights.panelLightGroup:actuate(1)
			end
			if kc_has_dome_lights then
				sysLights.domeLightGroup:actuate(1)
			end
		end	
	else
		logMsg("Invalid flightphase")
	end	

end

-- background switch lights at reaching 10000 ft in climb
function kc_macro_lights_climb_10k()
	-- set the lights when reaching 10.000 ft
	kc_macro_lights(kc_phase_before_takeoff)
	sysLights.landLightGroup:actuate(0)
	if kc_has_rwy_lights then
		sysLights.rwyLightGroup:actuate(0)
	end
	if kc_has_logo_lights then
		sysLights.logoSwitch:actuate(0)
	end
end

-- background switch lights at reaching 10000 ft in descend
function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
	-- kc_macro_lights_climb_10k()
	sysLights.landLightGroup:actuate(1)
	if kc_is_daylight() == false then		
		if kc_has_logo_lights then
			sysLights.logoSwitch:actuate(1)
		end
	end
end

-- ===== UI related functions =====

-- new kppanels light panel render funtion
function sysLights:panel_render()
	imgui.BeginGroup()

		imgui.TextUnformatted("  LIGHTS ")
		kc_imgui_label_mcp(" ",10)
		if kc_has_logo_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LOG",sysLights.logoSwitch,10,36,25)
		end
		if kc_has_strobe_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("STR",sysLights.strobesSwitch,10,36,25)
		end
		if kc_has_pos_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("POS",sysLights.positionSwitch,10,36,25)
		end
		if kc_has_beacon then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("BEA",sysLights.beaconSwitch,10,36,25)
		end
		if kc_has_wing_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("WNG",sysLights.wingSwitch,10,36,25)
		end
		imgui.SameLine()
		kc_imgui_label_mcp("|",10)
		if kc_has_dome_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("DOM",sysLights.domeLightGroup,10,36,25)
		end
		if kc_has_instr_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("INS",sysLights.instrLightGroup,10,36,25)
		end
		if kc_has_panel_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("PNL",sysLights.panelLightGroup,10,36,25)
		end
		kc_imgui_label_mcp(" ",10)
		if kc_has_rwy_lights then
			imgui.SameLine()		
			kc_imgui_toggle_button_mcp("RWY",sysLights.rwyLightGroup,10,36,25)
		end
		if kc_NumLandingLts > 0 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL1",sysLights.llLeftSwitch,10,36,25)
		end
		if kc_NumLandingLts > 1 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL2",sysLights.llRightSwitch,10,36,25)
		end
		if kc_NumLandingLts > 2 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL3",sysLights.ll3rdSwitch,10,36,25)
		end
		if kc_NumLandingLts > 3 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL4",sysLights.ll4thSwitch,10,36,25)
		end
		imgui.SameLine()
		kc_imgui_simple_button_mcp("ALL",sysLights.landLightGroup,10,36,25)
		if kc_has_taxi_light then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("TAXI",sysLights.taxiSwitch,10,36,25)
		end
		imgui.SameLine()
		kc_imgui_label_mcp("|",10)
		if kc_has_seatbelt_sgn then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("SIT",sysGeneral.passSignsSwitch,10,36,25)
		end
		imgui.SameLine()
		if kc_has_nosmoke_sgn then
			kc_imgui_toggle_button_mcp("SMK",sysGeneral.noSmokingSwitch,10,36,25)
			imgui.Separator()
		end

	imgui.EndGroup()
end

return sysLights