-- DFLT airplane 
-- Lights functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
	template = {
		etype = type_...,
		name = "name",
		drefName = "name of dref",
		drefIndex = 0,
		cmd1 = "on, tgl or dn",
		cmd2 = "off or up",
		cmd3 = "tgl",
		msMin = minimum,
		msMax = maximum,
		msRead = true/false,
		msDiff = difference,
		funcOn = function...,
		funcOff = function ...,
		funcTgl = function ...,
		funcStat = function ...,
		funcStep = function...,
		funcSet = function
	}
]]

kc_has_beacon		= true		-- Aircraft has beacon lights
kc_num_beacon		= 1
kc_has_nav_lights	= true		-- Aircraft has switchable position/nav Lights
kc_has_strobe_lights= true		-- Aircraft has strobe lights
kc_has_strobe_as_bcn= false		-- Aircraft uses strobe lights for beacon 
kc_has_taxi_light	= true		-- Aircraft has taxi light
kc_num_taxi_light	= 1			-- Aircraft has taxi light
kc_has_ll_as_taxi	= false		-- Aircraft uses landing lights to taxi
-- kc_NumLandingLts	= 2			-- Number of landing light switches
kc_has_landing_lights = true	-- Aircraft has landing lights
kc_num_landing_lights = 2		-- Aircraft has landing lights
kc_has_wing_lights	= false		-- Aircraft has wing Lights
kc_has_wheel_lights	= false		-- Aircraft has wheel Lights
kc_has_logo_lights	= true		-- Aircraft has logo lights
kc_has_rwy_lights	= true		-- Aircraft has rwy turnoff lights
kc_num_rwy_lights	= 2		
kc_has_dome_lights	= true		-- Aircraft has dome/cockpit lights
kc_num_dome_lights	= 1			-- Aircraft has dome/cockpit lights
kc_has_instr_lights	= true		-- Aircraft has instrument Lights
kc_num_instr_lights	= 6
kc_has_panel_lights = true		-- Aircraft has panel lights
kc_num_panel_lights = 4			-- Aircraft has panel lights
kc_has_emer_lights	= false		-- Aircraft has emergency lights

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
	sysLights.taxiLightSwitch1
	sysLights.taxiLightSwitch2
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
sysLights.domeAnc

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

sysLights.emerLights
]]

sysLightsDefinitions = {

	beaconSwitch1 = {
		etype = kc_swtype_2StateCmd,
		name = "Beacon 1",
		drefName = "sim/cockpit/electrical/beacon_lights_on",
		drefIndex = 0,
		cmd1 = "sim/lights/beacon_lights_on",
		cmd2 = "sim/lights/beacon_lights_off",
		cmd3 = "sim/lights/beacon_lights_toggle"
	},
	beaconSwitch2 = {
		etype = kc_swtype_inop,
		name = "Beacon 2"
	},
	beaconAnc = {
		etype = kc_swtype_annunciator,
		name = "Beacon ann",
		drefName = "sim/cockpit/electrical/beacon_lights_on",
		drefIndex = 0
	},
	navLightSwitch = {
		etype = kc_swtype_dref,
		name = "Nav Lights",
		drefName = "sim/cockpit2/switches/navigation_lights_on",
		drefIndex = 0
	},
	navLightAnc = {
		etype = kc_swtype_annunciator,
		name = "Nav light ann",
		drefName = "sim/cockpit2/switches/navigation_lights_on",
		drefIndex = 0
	},
	strobesSwitch = {
		etype = kc_swtype_2StateCmd,
		name = "Strobes",
		drefName = "sim/cockpit2/switches/strobe_lights_on",
		drefIndex = 0,
		cmd1 = "sim/lights/strobe_lights_on",
		cmd2 = "sim/lights/strobe_lights_off",
		cmd3 = "sim/lights/strobe_lights_toggle"
	},
	strobesAnc = {
		etype = kc_swtype_annunciator,
		name = "Strobes ann",
		drefName = "sim/cockpit2/switches/strobe_lights_on",
		drefIndex = 0
	},
	taxiLightSwitch1 = {
		etype = kc_swtype_2StateCmd,
		name = "Taxi 1",
		drefName = "sim/cockpit2/switches/taxi_light_on",
		drefIndex = 0,
		cmd1 = "sim/lights/taxi_lights_on",
		cmd2 = "sim/lights/taxi_lights_off",
		cmd3 = "sim/lights/taxi_lights_toggle"
	},
	taxiLightSwitch2 = {
		etype = kc_swtype_inop,
		name = "Taxi 2"
	},
	taxiAnc = {
		etype = kc_swtype_annunciator,
		name = "Taxi ann",
		drefName = "sim/cockpit2/switches/taxi_light_on",
		drefIndex = 0
	},
	landLightSwitch1 = {
		etype = kc_swtype_dref,
		name = "Landing Light 1",
		drefName = "sim/cockpit2/switches/landing_lights_switch",
		drefIndex = -1
	},
	landLightSwitch2 = {
		etype = kc_swtype_dref,
		name = "Landing Light 2",
		drefName = "sim/cockpit2/switches/landing_lights_switch",
		drefIndex = 1
	},
	landLightSwitch3 = {
		etype = kc_swtype_inop,
		name = "Landing Light 3"
	},
	landLightSwitch4 = {
		etype = kc_swtype_inop,
		name = "Landing Light 4"
	},
	landingAnc = {
		etype = kc_swtype_customAnn,
		name = "Landing ann",
		funcOn = function () 
			if get("sim/cockpit2/switches/landing_lights_switch",0) > 0 or 
			   get("sim/cockpit2/switches/landing_lights_switch",1) > 0 then
				return 1 else return 0 end end
	},
	wingLightSwitch = {
		etype = kc_swtype_dref,
		name = "Wing lights",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 3
	},
	wingLightAnc = {
		etype = kc_swtype_annunciator,
		name = "Wing light ann",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 3
	},
	wheelLightSwitch = {
		etype = kc_swtype_dref,
		name = "Wheel lights",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 11
	},
	wheelLightAnc = {
		etype = kc_swtype_annunciator,
		name = "Wheel light ann",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 11
	},
	logoLightSwitch = {
		etype = kc_swtype_dref,
		name = "Logo lights",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 10
	},
	logoLightAnc = {
		etype = kc_swtype_annunciator,
		name = "Logo light ann",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 10
	},
	rwyLightSwitch1 = {
		etype = kc_swtype_dref,
		name = "Landing Light 1",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 1
	},
	rwyLightSwitch2 = {
		etype = kc_swtype_dref,
		name = "Landing Light 2",
		drefName = "sim/cockpit2/switches/generic_lights_switch",
		drefIndex = 2
	},
	runwayLightAnc = {
		etype = kc_swtype_customAnn,
		name = "Landing ann",
		funcOn = function () 
			if get("sim/cockpit2/switches/generic_lights_switch",0) > 0 or 
			   get("sim/cockpit2/switches/generic_lights_switch",1) > 0 then
				return 1 else return 0 end end
	},
	domeLightSwitch1 = {
		etype = kc_swtype_dref,
		name = "Dome light 1",
		drefName = "sim/cockpit/electrical/cockpit_lights",
		drefIndex = -1
	},
	domeLightSwitch2 = {
		etype = kc_swtype_inop,
		name = "Dome Light 2"
	},
	domeAnc = {
		etype = kc_swtype_customAnn,
		name = "Dome ann",
		funcOn = function () if get("sim/cockpit/electrical/cockpit_lights",0) ~= 0 then return 1 else return 0 end end
	},
	instrLight1 = {
		etype = kc_swtype_dref,
		name = "Instr light 1",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = -1
	},
	instrLight2 = {
		etype = kc_swtype_inop,
		name = "Instr Light 2",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = 1
	},
	instrLight3 = {
		etype = kc_swtype_dref,
		name = "Instr light 3",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = 2
	},
	instrLight4 = {
		etype = kc_swtype_inop,
		name = "Instr Light 4",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = 3
	},
	instrLight5 = {
		etype = kc_swtype_dref,
		name = "Instr light 5",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = 4
	},
	instrLight6 = {
		etype = kc_swtype_inop,
		name = "Instr Light 6",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = 5
	},
	instrumentAnc = {
		etype = kc_swtype_annunciator,
		name = "instrument light ann",
		drefName = "sim/cockpit2/switches/instrument_brightness_ratio",
		drefIndex = -1
	},
	panelLight1 = {
		etype = kc_swtype_dref,
		name = "Panel light 1",
		drefName = "sim/cockpit2/switches/panel_brightness_ratio",
		drefIndex = -1
	},
	panelLight2 = {
		etype = kc_swtype_inop,
		name = "Panel Light 2",
		drefName = "sim/cockpit2/switches/panel_brightness_ratio",
		drefIndex = 1
	},
	panelLight3	= {
		etype = kc_swtype_dref,
		name = "Panel light 3",
		drefName = "sim/cockpit2/switches/panel_brightness_ratio",
		drefIndex = 2
	},
	panelLight4 = {
		etype = kc_swtype_inop,
		name = "Panel Light 4",
		drefName = "sim/cockpit2/switches/panel_brightness_ratio",
		drefIndex = 3
	},
	panelLightAnc = {
		etype = kc_swtype_annunciator,
		name = "Panel light ann",
		drefName = "sim/cockpit2/switches/panel_brightness_ratio",
		drefIndex = -1
	},
	emerLights = {
		etype = kc_swtype_inop,
		name = "Emergency light"
	}	
}

return sysLightsDefinitions