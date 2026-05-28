-- DFLT airplane (X-Plane default)
-- aircraft lights specific functionality

-- @classmod sysLights
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
--[[
sysLights.beaconLightGroup
	sysLights.beaconSwitch1
	sysLights.beaconSwitch2
sysLights.beaconAnc

sysLights.navLightSwitch
sysLights.navLightAnc

sysLights.strobeLightSwitch 
sysLights.strobeLightAnc

sysLights.taxiLightGroup
	sysLights.taxiSwitch1
	sysLights.taxiSwitch2
sysLights.taxiLightAnc

sysLights.landLightGroup
	sysLights.landLightSwitch1
	sysLights.landLightSwitch2 
	sysLights.landLightSwitch3 	
	sysLights.landLightSwitch4 	
sysLights.landLightAnc

sysLights.wingLightSwitch
sysLights.wingLightAnc

sysLights.wheelLightSwitch
sysLights.wheelLightAnc

sysLights.logoLightSwitch
sysLights.logoLightAnc

sysLights.rwyLightGroup 
	sysLights.rwyLightSwitch1
	sysLights.rwyLightSwitch2
sysLights.runwayLightAnc

sysLights.domeLightGroup 
	sysLights.domeLightSwitch1
	sysLights.domeLightSwitch2

sysLights.instrLightGroup
	sysLights.instrLight1
	sysLights.instrLight2
	sysLights.instrLight3
	sysLights.instrLight4
	sysLights.instrLight5
	sysLights.instrLight6
sysLights.instrumentAnc

sysLights.panelLightGroup 
	sysLights.panelLight1
	sysLights.panelLight2
	sysLights.panelLight3
	sysLights.panelLight4

sysLights.emerLighs

Macro: kc_macro_lights
Macro: kc_macro_lights_climb_10k
Macro: kc_macro_lights_descend_10k
UI: panel_render
]]

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

logMsg("DFLT sysLights")

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysLightsDefinitions")

----------- Switches
-- **Beacons or Anticollision Lights (up to 2)
if kc_has_beacon then
	sysLights.beaconLightGroup 	= SwitchGroup:new("Beacon lights")
	sysLights.beaconSwitch1 	= kc_setup_element(def.beaconSwitch1)
	sysLights.beaconLightGroup:addSwitch(sysLights.beaconSwitch1)
	if kc_num_beacon > 1 then
		sysLights.beaconSwitch2	= kc_setup_element(def.beaconSwitch2)
		sysLights.beaconLightGroup:addSwitch(sysLights.beaconSwitch2)
	end
	sysLights.beaconAnc 		= kc_setup_element(def.beaconAnc)
else
	sysLights.beaconLightGroup 	= SwitchGroup:new("Beacon lights")
	sysLights.beaconSwitch1		= kc_setup_element({etype=kc_swtype_inop, name="Beacon 1"})
	sysLights.beaconLightGroup:addSwitch(sysLights.beaconSwitch1)
	sysLights.beaconAnc 		= kc_setup_element({etype=kc_swtype_inop, name="Beacon ann"})
end

-- **Position (or Nav) Lights, single onoff command driven
if kc_has_nav_lights then
	sysLights.navLightSwitch 	= kc_setup_element(def.navLightSwitch)
	sysLights.navLightAnc 		= kc_setup_element(def.navLightAnc)
else
	sysLights.navLightSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Nav lights"})
	sysLights.navLightAnc 		= kc_setup_element({etype=kc_swtype_inop, name="Nav ann"})
end

-- **Strobe Lights, single onoff command driven
if kc_has_strobe_lights then
	sysLights.strobesSwitch 	= kc_setup_element(def.strobesSwitch)
	sysLights.strobesAnc 		= kc_setup_element(def.strobesAnc)
else
	sysLights.strobesSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Strobe lights"})
	sysLights.strobesAnc 		= kc_setup_element({etype=kc_swtype_inop, name="Strobes ann"})
end

if kc_has_strobe_as_bcn then
	sysLights.beaconLightGroup 	= SwitchGroup:new("Beacon lights")
	sysLights.beaconSwitch1 	= kc_setup_element(def.strobesSwitch)
	sysLights.beaconLightGroup:addSwitch(sysLights.beaconSwitch1)
	sysLights.beaconAnc 		= kc_setup_element(def.strobesAnc)
end

-- **Taxi/Nose Lights, single onoff command driven
if kc_has_taxi_light then
	sysLights.taxiLightGroup 	= SwitchGroup:new("Taxi lights")
	sysLights.taxiLightSwitch1 		= kc_setup_element(def.taxiLightSwitch1)
	sysLights.taxiLightGroup:addSwitch(sysLights.taxiLightSwitch1)
	if kc_num_beacon > 1 then
		sysLights.taxiLightSwitch2	= kc_setup_element(def.taxiLightSwitch2)
		sysLights.taxiLightGroup:addSwitch(sysLights.taxiLightSwitch2)
	end
	sysLights.taxiAnc 			= kc_setup_element(def.taxiAnc)
else
	sysLights.taxiLightGroup 	= SwitchGroup:new("Taxi lights")
	sysLights.taxiLightSwitch1	= kc_setup_element({etype=kc_swtype_inop, name="Taxi 1"})
	sysLights.taxiLightGroup:addSwitch(sysLights.taxiLightSwitch1)
	sysLights.taxiAnc 			= kc_setup_element({etype=kc_swtype_inop, name="Taxi ann"})
end

-- **Landing Lights, single onoff command driven
if kc_has_landing_lights then
	sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
	sysLights.landLightSwitch1 	= kc_setup_element(def.landLightSwitch1)
	sysLights.landLightGroup:addSwitch(sysLights.landLightSwitch1)
	if kc_num_landing_lights > 1 then
		sysLights.landLightSwitch2 	= kc_setup_element(def.landLightSwitch2)
		sysLights.landLightGroup:addSwitch(sysLights.landLightSwitch2)
	end
	if kc_num_landing_lights > 2 then
		sysLights.landLightSwitch3 	= kc_setup_element(def.landLightSwitch3)
		sysLights.landLightGroup:addSwitch(sysLights.landLightSwitch3)
	end
	if kc_num_landing_lights > 3 then
		sysLights.landLightSwitch4 	= kc_setup_element(def.landLightSwitch4)
		sysLights.landLightGroup:addSwitch(sysLights.landLightSwitch4)
	end
	sysLights.landingAnc 		= kc_setup_element(def.landingAnc)
else
	sysLights.landLightGroup 	= SwitchGroup:new("landinglights")
	sysLights.landLightSwitch1	= kc_setup_element({etype=kc_swtype_inop, name="LL 1"})
	sysLights.landLightGroup:addSwitch(sysLights.landLightSwitch1)
	sysLights.landingAnc		= kc_setup_element({etype=kc_swtype_inop, name="Landing ann"})
end

if kc_has_ll_as_taxi then
	sysLights.taxiLightGroup 	= sysLights.landLightGroup
end
	
-- **Wing Lights
if kc_has_wing_lights then
	sysLights.wingLightSwitch 	= kc_setup_element(def.wingLightSwitch)
	sysLights.wingLightAnc 		= kc_setup_element(def.wingLightAnc)
else
	sysLights.wingLightSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Wing lights"})
	sysLights.wingLightAnc 		= kc_setup_element({etype=kc_swtype_inop, name="Wing Light ann"})
end

-- **Wheel well Lights
if kc_has_wheel_lights then
	sysLights.wheelLightSwitch 	= kc_setup_element(def.wheelLightSwitch)
	sysLights.wheelLightAnc 	= kc_setup_element(def.wheelLightAnc)
else
	sysLights.wheelLightSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Wing lights"})
	sysLights.wheelLightAnc		= kc_setup_element({etype=kc_swtype_inop, name="Wing Light ann"})
end

-- **Logo Light
if kc_has_logo_lights then
	sysLights.logoLightSwitch 	= kc_setup_element(def.logoLightSwitch)
	sysLights.logoLightAnc 		= kc_setup_element(def.logoLightAnc)
else
	sysLights.logoLightSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Logo lights"})
	sysLights.logoLightAnc		= kc_setup_element({etype=kc_swtype_inop, name="Logo Light ann"})
end

-- **RWY Turnoff Lights
if kc_has_rwy_lights then
	sysLights.rwyLightGroup 	= SwitchGroup:new("runway lights")
	sysLights.rwyLightSwitch1 	= kc_setup_element(def.rwyLightSwitch1)
	sysLights.rwyLightGroup:addSwitch(sysLights.rwyLightSwitch1)
	if kc_num_rwy_lights > 1 then
		sysLights.rwyLightSwitch2 	= kc_setup_element(def.rwyLightSwitch2)
		sysLights.rwyLightGroup:addSwitch(sysLights.rwyLightSwitch2)
	end
	sysLights.runwayLightAnc 		= kc_setup_element(def.runwayLightAnc)
else
	sysLights.rwyLightGroup 	= SwitchGroup:new("runway lights")
	sysLights.rwyLightSwitch1	= kc_setup_element({etype=kc_swtype_inop, name="rwy light 1"})
	sysLights.rwyLightGroup:addSwitch(sysLights.landLightSwitch1)
	sysLights.runwayLightAnc		= kc_setup_element({etype=kc_swtype_inop, name="rwy light ann"})
end

-- **Dome Light
if kc_has_dome_lights then
	sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
	sysLights.domeLightSwitch1 	= kc_setup_element(def.domeLightSwitch1)
	sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch1)
	if kc_num_dome_lights > 1 then
		sysLights.domeLightSwitch2 	= kc_setup_element(def.domeLightSwitch2)
		sysLights.domeLightGroup:addSwitch(sysLights.domeLightSwitch2)
	end
	sysLights.domeAnc 			= kc_setup_element(def.domeAnc)
else
	sysLights.domeLightGroup 	= SwitchGroup:new("dome lights")
	sysLights.domeLightSwitch1	= kc_setup_element({etype=kc_swtype_inop, name="dome light 1"})
	sysLights.rwyLightGroup:addSwitch(sysLights.domeLightSwitch1)
	sysLights.domeAnc			= kc_setup_element({etype=kc_swtype_inop, name="rwy light ann"})
end

-- **Instrument Lights
if kc_has_instr_lights then
	sysLights.instrLightGroup 	= SwitchGroup:new("instrument lights")
	sysLights.instrLight1		= kc_setup_element(def.instrLight1)
	sysLights.instrLightGroup:addSwitch(sysLights.instrLight1)
	if kc_num_instr_lights > 1 then
		sysLights.instrLight2	= kc_setup_element(def.instrLight2)
		sysLights.instrLightGroup:addSwitch(sysLights.instrLight2)
	end
	if kc_num_instr_lights > 2 then
		sysLights.instrLight3	= kc_setup_element(def.instrLight3)
		sysLights.instrLightGroup:addSwitch(sysLights.instrLight3)
	end
	if kc_num_instr_lights > 3 then
		sysLights.instrLight4	= kc_setup_element(def.instrLight4)
		sysLights.instrLightGroup:addSwitch(sysLights.instrLight4)
	end
	if kc_num_instr_lights > 4 then
		sysLights.instrLight5	= kc_setup_element(def.instrLight5)
		sysLights.instrLightGroup:addSwitch(sysLights.instrLight5)
	end
	if kc_num_instr_lights > 5 then
		sysLights.instrLight6	= kc_setup_element(def.instrLight6)
		sysLights.instrLightGroup:addSwitch(sysLights.instrLight6)
	end
	sysLights.instrumentAnc = kc_setup_element(def.instrumentAnc)
else
	sysLights.instrLightGroup 	= SwitchGroup:new("instrument lights")
	sysLights.instrLight1		= kc_setup_element({etype=kc_swtype_inop, name="instr light 1"})
	sysLights.instrLightGroup:addSwitch(sysLights.instrLight1)
	sysLights.instrumentAnc			= kc_setup_element({etype=kc_swtype_inop, name="instrument light ann"})
end

-- **Panel lights
if kc_has_panel_lights then
	sysLights.panelLightGroup 	= SwitchGroup:new("panel lights")
	sysLights.panelLight1		= kc_setup_element(def.panelLight1)
	sysLights.panelLightGroup:addSwitch(sysLights.panelLight1)
	if kc_num_panel_lights > 1 then
		sysLights.panelLight2	= kc_setup_element(def.panelLight2)
		sysLights.panelLightGroup:addSwitch(sysLights.panelLight2)
	end
	if kc_num_panel_lights > 2 then
		sysLights.panelLight3	= kc_setup_element(def.panelLight3)
		sysLights.panelLightGroup:addSwitch(sysLights.panelLight3)
	end
	if kc_num_panel_lights > 3 then
		sysLights.panelLight4	= kc_setup_element(def.panelLight4)
		sysLights.panelLightGroup:addSwitch(sysLights.panelLight4)
	end
	sysLights.panelLightAnc = kc_setup_element(def.panelLightAnc)
else
	sysLights.panelLightGroup 	= SwitchGroup:new("instrument lights")
	sysLights.panelLight1		= kc_setup_element({etype=kc_swtype_inop, name="panel light 1"})
	sysLights.panelLightGroup:addSwitch(sysLights.panelLight1)
	sysLights.panelLightAnc			= kc_setup_element({etype=kc_swtype_inop, name="panel light ann"})
end

-- Emergency Lights
if kc_has_emer_lights then
	sysLights.emerLights 	= kc_setup_element(def.emerLights)
else
	sysLights.emerLights 	= kc_setup_element({etype=kc_swtype_inop, name="Emergency lights"})
end

--------- Macros
function kc_macro_lights(flightphase)
	logMsg("Lights flight phase: " .. kcSopFlightPhase[flightphase])
	
	-- Cold & dark
	if flightphase == kc_phase_colddark then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(0) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(0) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(0) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(0) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(0) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(0) end
	elseif flightphase == kc_phase_turnaround then
		-- turnaround
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(0) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(0) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(0) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_dome_lights then sysLights.domeLightGroup:actuate(1) end
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(1) end
			if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
		end
	elseif flightphase == kc_phase_prel_preflight then
	elseif flightphase == kc_phase_preflight then
	elseif flightphase == kc_phase_before_start then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(0) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(0) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_dome_lights then sysLights.domeLightGroup:actuate(1) end
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(1) end
		end
	elseif flightphase == kc_phase_after_start then
	elseif flightphase == kc_phase_taxi_rwy then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(0) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(1) end
		if kc_has_ll_as_taxi then sysLights.landLightGroup:actuate(1) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(0) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
		end
	elseif flightphase == kc_phase_before_takeoff then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(1) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(1) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_ll_as_taxi then sysLights.landLightGroup:actuate(1) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(1) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
		end
	elseif flightphase == kc_phase_takeoff then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(1) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(1) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_ll_as_taxi then sysLights.landLightGroup:actuate(1) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(1) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
		end
	elseif flightphase == kc_phase_climb then
	elseif flightphase == kc_phase_descent then
	elseif flightphase == kc_phase_arrival then
	elseif flightphase == kc_phase_approach then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(1) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(1) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(0) end
		if kc_has_ll_as_taxi then sysLights.landLightGroup:actuate(0) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(1) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
		end
	elseif flightphase == kc_phase_landing then
	elseif flightphase == kc_phase_taxi_stand then
	elseif flightphase == kc_phase_afterland then
		if kc_has_landing_lights then sysLights.landLightGroup:actuate(0) end
		if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
		if kc_has_taxi_light then sysLights.taxiLightGroup:actuate(1) end
		if kc_has_ll_as_taxi then sysLights.landLightGroup:actuate(1) end
		if kc_has_pos_lights then sysLights.navLightSwitch:actuate(1) end
		if kc_has_beacon then sysLights.beaconLightGroup:actuate(1) end
		if kc_has_strobe_lights then sysLights.strobesSwitch:actuate(0) end
		if kc_has_instr_lights then sysLights.instrLightGroup:actuate(1) end
		if kc_has_dome_lights then sysLights.domeLightGroup:actuate(0) end
		if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(0) end
		if kc_has_wing_lights then sysLights.wingLightSwitch:actuate(0) end
		if kc_has_wheel_lights then sysLights.wheelLightSwitch:actuate(0) end
		if kc_has_panel_lights then sysLights.panelLightGroup:actuate(0) end	
		if kc_has_emer_lights then sysLights.emerLights:actuate(1) end
		if kc_is_daylight() == false then
			if kc_has_logo_lights then sysLights.logoLightSwitch:actuate(1) end
			if kc_has_panel_lights then sysLights.panelLightGroup:actuate(1) end
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
	if kc_has_rwy_lights then sysLights.rwyLightGroup:actuate(0) end
	if kc_has_logo_lights then sysLights.logoSwitch:actuate(0) end
end

-- background switch lights at reaching 10000 ft in descend
function kc_macro_lights_descend_10k()
	-- set the lights when sinking through 10.000 ft
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
			kc_imgui_toggle_button_mcp("LOG",sysLights.logoLightSwitch,10,36,25)
		end
		if kc_has_strobe_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("STR",sysLights.strobesSwitch,10,36,25)
		end
		if kc_has_pos_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("POS",sysLights.navLightSwitch,10,36,25)
		end
		if kc_has_beacon then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("BEA",sysLights.beaconLightGroup,10,36,25)
		end
		if kc_has_wing_lights then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("WNG",sysLights.wingLightSwitch,10,36,25)
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
		if kc_num_landing_lights > 0 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL1",sysLights.landLightSwitch1,10,36,25)
		end
		if kc_num_landing_lights > 1 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL2",sysLights.landLightSwitch2,10,36,25)
		end
		if kc_num_landing_lights > 2 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL3",sysLights.landLightSwitch3,10,36,25)
		end
		if kc_num_landing_lights > 3 then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("LL4",sysLights.landLightSwitch4,10,36,25)
		end
		imgui.SameLine()
		kc_imgui_simple_button_mcp("ALL",sysLights.landLightGroup,10,36,25)
		if kc_has_taxi_light then
			imgui.SameLine()
			kc_imgui_toggle_button_mcp("TAXI",sysLights.taxiLightGroup,10,36,25)
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