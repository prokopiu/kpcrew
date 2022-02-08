--[[
	*** KPHARDWARE
	Kosta Prokopiu, January 2022
--]]

local KPH_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPHARDWARE version " .. KPH_VERSION .." **" )

local acf_icao = "DFLT"

-- Laminar MD82 -> MD82
-- Laminar 747 -> B744, check Sparky 744

-- Load plane specific module from Modules folder

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		acf_icao = "DFLT" -- add L738 module later
	else
		acf_icao = "B738" -- Zibo Mod
	end
end

require "kpcrew.genutils"
require "kpcrew.systems.activities"
TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"

sysLights = require("kpcrew.systems." .. acf_icao .. ".sysLights")
sysGeneral = require("kpcrew.systems." .. acf_icao .. ".sysGeneral")	
sysControls = require("kpcrew.systems." .. acf_icao .. ".sysControls")	
sysEngines = require("kpcrew.systems." .. acf_icao .. ".sysEngines")	
sysElectric = require("kpcrew.systems." .. acf_icao .. ".sysElectric")	
sysHydraulic = require("kpcrew.systems." .. acf_icao .. ".sysHydraulic")	
sysFuel = require("kpcrew.systems." .. acf_icao .. ".sysFuel")	
sysAir = require("kpcrew.systems." .. acf_icao .. ".sysAir")	
sysAice = require("kpcrew.systems." .. acf_icao .. ".sysAice")	
sysMCP = require("kpcrew.systems." .. acf_icao .. ".sysMCP")	

-- ============ aircraft specific joystick/key commands (e.g. for Alpha Yoke)
-- ------------------ Lights
create_command("kp/xsp/lights/beacon_switch_on", "Beacon Lights On","sysLights.beaconSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.beaconSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.beaconSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/position_switch_on","Position Lights On","sysLights.positionSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/position_switch_off","Position Lights Off","sysLights.positionSwitch:actuate(modeOff)", "", "")
create_command("kp/xsp/lights/position_switch_tgl","Position Lights Toggle","sysLights.positionSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/strobe_switch_on","Strobe Lights On","sysLights.strobesSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/strobe_switch_off","Strobe Lights Off","sysLights.strobesSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/strobe_switch_tgl","Strobe Lights Toggle","sysLights.strobesSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/taxi_switch_on","Taxi Lights On","sysLights.taxiSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/taxi_switch_off","Taxi Lights Off","sysLights.taxiSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/taxi_switch_tgl","Taxi Lights Toggle","sysLights.taxiSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/landing_switch_on","Landing Lights On","sysLights.landLightGroup:actuate(modeOn)","","")
create_command("kp/xsp/lights/landing_switch_off","Landing Lights Off","sysLights.landLightGroup:actuate(modeOff)","","")
create_command("kp/xsp/lights/landing_switch_tgl","Landing Lights Toggle","sysLights.landLightGroup:actuate(modeToggle)","","")

create_command("kp/xsp/lights/wing_switch_on","Wing Lights On","sysLights.wingSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/wing_switch_off","Wing Lights Off","sysLights.wingSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/wing_switch_tgl","Wing Lights Toggle","sysLights.wingSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/wheel_switch_on","Wheel Lights On","sysLights.wheelSwitch:actuate(modeOn)", "", "")
create_command("kp/xsp/lights/wheel_switch_off","Wheel Lights Off","sysLights.wheelSwitch:actuate(modeOff)", "", "")
create_command("kp/xsp/lights/wheel_switch_tgl","Wheel Lights Toggle","sysLights.wheelSwitch:actuate(modeToggle)", "", "")

create_command("kp/xsp/lights/logo_switch_on","Logo Lights On","sysLights.logoSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/logo_switch_off","Logo Lights Off","sysLights.logoSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/logo_switch_tgl","Logo Lights Toggle","sysLights.logoSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/lights/rwyto_switch_on","Runway Lights On","sysLights.rwyLightGroup:actuate(modeOn)","","")
create_command("kp/xsp/lights/rwyto_switch_off","Runway Lights Off","sysLights.rwyLightGroup:actuate(modeOff)","","")
create_command("kp/xsp/lights/rwyto_switch_tgl","Runway Lights Toggle","sysLights.rwyLightGroup:actuate(modeToggle)","","")

create_command("kp/xsp/lights/instruments_on","Instrument Lights On","sysLights.instrLightGroup:actuate(modeOn)","","")
create_command("kp/xsp/lights/instruments_off","Instrument Lights Off","sysLights.instrLightGroup:actuate(modeOff)","","")
create_command("kp/xsp/lights/instruments_tgl","Instrument Lights Toggle","sysLights.instrLightGroup:actuate(modeToggle)","","")

create_command("kp/xsp/lights/dome_switch_on","Cockpit Lights On","sysLights.domeLightSwitch:actuate(modeOn)","","")
create_command("kp/xsp/lights/dome_switch_off","Cockpit Lights Off","sysLights.domeLightSwitch:actuate(modeOff)","","")
create_command("kp/xsp/lights/dome_switch_tgl","Cockpit Lights Toggle","sysLights.domeLightSwitch:actuate(modeToggle)","","")

---------------- General Systems ---------------------

create_command("kp/xsp/systems/parking_brake_on","Parking Brake On","sysGeneral.parkBrakeSwitch:actuate(modeOn)","","")
create_command("kp/xsp/systems/parking_brake_off","Parking Brake Off","sysGeneral.parkBrakeSwitch:actuate(modeOff)","","")
create_command("kp/xsp/systems/parking_brake_tgl","Parking Brake Toggle","sysGeneral.parkBrakeSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/systems/gears_up","Gears Up","sysGeneral.GearSwitch:actuate(modeOff)","","")
create_command("kp/xsp/systems/gears_down","Gears Down","sysGeneral.GearSwitch:actuate(modeOn)","","")
create_command("kp/xsp/systems/gears_off","Gears OFF","sysGeneral.GearSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/systems/all_alt_std","ALTS STD/QNH toggle","sysGeneral.barostdGroup:actuate(modeToggle)","","")

create_command("kp/xsp/systems/baro_mode_tgl","Baro inch/mb toggle","sysGeneral.baroModeGroup:actuate(modeToggle)","","")

create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.baroGroup:actuate(Switch.decrease)","","")
create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.baroGroup:actuate(Switch.increase)","","")

----------------- Flight Controls --------------------

create_command("kp/xsp/controls/flaps_up","Flaps 1 Up","sysControls.flapsSwitch:actuate(sysControls.flapsUp)","","")
create_command("kp/xsp/controls/flaps_down","Flaps 1 Down","sysControls.flapsSwitch:actuate(sysControls.flapsDown)","","")

create_command("kp/xsp/controls/pitch_trim_up","Pitch Trim Up","sysControls.pitchTrimSwitch:actuate(sysControls.trimUp)", "", "")
create_command("kp/xsp/controls/pitch_trim_down","Pitch Trim Down","sysControls.pitchTrimSwitch:actuate(sysControls.trimDown)", "", "")

create_command("kp/xsp/controls/rudder_trim_left","Rudder Trim Left","sysControls.rudderTrimSwitch:actuate(sysControls.trimLeft)", "", "")
create_command("kp/xsp/controls/rudder_trim_right","Rudder Trim Right","sysControls.rudderTrimSwitch:actuate(sysControls.trimRight)", "", "")
create_command("kp/xsp/controls/rudder_trim_center","Rudder Trim Center","sysControls.rudderReset:actuate(sysControls.trimCenter)", "", "")

create_command("kp/xsp/controls/aileron_trim_left","Aileron Trim Left","sysControls.aileronTrimSwitch:actuate(sysControls.trimLeft)", "", "")
create_command("kp/xsp/controls/aileron_trim_right","Aileron Trim Right","sysControls.aileronTrimSwitch:actuate(sysControls.trimRight)", "", "")
create_command("kp/xsp/controls/aileron_trim_center","Aileron Trim Center","sysControls.aileronReset:actuate(sysControls.trimCenter)", "", "")

-- --------------- Engines
create_command("kp/xsp/engines/reverse_tgl", "Reverse Thrust Toggle", "sysEngines.reverseToggle:actuate(modeToggle)", "", "")

-- --------------- Autopilot / MCP
-- ------------ A/P MCP functions
create_command("kp/xsp/autopilot/both_fd_tgl", "All FDs Toggle", "sysMCP.fdirGroup:actuate(modeToggle)", "", "")
create_command("kp/xsp/autopilot/bc_tgl", "Toggle Reverse Appr", "sysMCP.backcourse:actuate(modeToggle)", "", "")
create_command("kp/xsp/autopilot/ap_tgl", "Toggle A/P 1", "sysMCP.ap1Switch:actuate(modeToggle)", "", "")
create_command("kp/xsp/autopilot/alt_tgl", "Toggle Altitude Hold", "sysMCP.altholdSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/hdg_tgl", "Toggle Heading Select", "sysMCP.hdgselSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/nav_tgl", "Toggle Nav Mode", "sysMCP.vorlocSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/app_tgl", "Toggle Approach", "sysMCP.approachSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/vs_tgl", "Toggle Vertical Speed", "sysMCP.vsSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/ias_tgl", "Toggle IAS/Speed mode", "sysMCP.speedSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/toga_press", "Press Left TOGA", "sysMCP.togaPilotSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/at_tgl", "Toggle A/T", "sysMCP.athrSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/at_arm", "Arm A/T", "sysMCP.athrSwitch:actuate(modeOn)","","")
create_command("kp/xsp/autopilot/at_off", "A/T OFF", "sysMCP.athrSwitch:actuate(modeOff)","","")

-- Honeycomb special commands

-- create_command("kp/xsp/bravo_mode_alt",				"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")
-- create_command("kp/xsp/bravo_mode_vs",				"Bravo AP Mode VS",		"xsp_bravo_mode=2", "", "")
-- create_command("kp/xsp/bravo_mode_hdg",				"Bravo AP Mode HDG",	"xsp_bravo_mode=3", "", "")
-- create_command("kp/xsp/bravo_mode_crs",				"Bravo AP Mode CRS",	"xsp_bravo_mode=4", "", "")
-- create_command("kp/xsp/bravo_mode_ias",				"Bravo AP Mode IAS",	"xsp_bravo_mode=5", "", "")
-- create_command("kp/xsp/bravo_knob_up",				"Bravo AP Knob Up",		"xsp_bravo_knob_up()", "", "")
-- create_command("kp/xsp/bravo_knob_dn",				"Bravo AP Knob Down",	"xsp_bravo_knob_dn()", "", "")
-- create_command("kp/xsp/bravo_layer_multi",			"Bravo Layer MULTI",	"xsp_bravo_layer=1", "", "")
-- create_command("kp/xsp/bravo_layer_ap",				"Bravo Layer A/P",		"xsp_bravo_layer=0", "", "")
-- create_command("kp/xsp/bravo_fine",					"Bravo Fine",			"xsp_fine_coarse = 1", "", "")
-- create_command("kp/xsp/bravo_coarse",				"Bravo Coarse",			"xsp_fine_coarse = 0", "", "")
-- create_command("kp/xsp/bravo_button_hdg",			"Bravo HDG Button",		"xsp_bravo_button_hdg()", "", "")
-- create_command("kp/xsp/bravo_button_nav",			"Bravo NAV Button",		"xsp_bravo_button_nav()", "", "")
-- create_command("kp/xsp/bravo_button_apr",			"Bravo APR Button",		"xsp_bravo_button_apr()", "", "")
-- create_command("kp/xsp/bravo_button_rev",			"Bravo REV Button",		"xsp_bravo_button_rev()", "", "")
-- create_command("kp/xsp/bravo_button_alt",			"Bravo ALT Button",		"xsp_bravo_button_alt()", "", "")
-- create_command("kp/xsp/bravo_button_vsp",			"Bravo VSP Button",		"xsp_bravo_button_vsp()", "", "")
-- create_command("kp/xsp/bravo_button_ias",			"Bravo IAS Button",		"xsp_bravo_button_ias()", "", "")
-- create_command("kp/xsp/bravo_button_ap",			"Bravo Autopilot Button","xsp_bravo_button_autopilot()", "", "")


--------------- Instantiate Datarefs for hardware annunciators (e.g. honeycomb) ----------- 

xsp_parking_brake = create_dataref_table("kp/xsp/systems/parking_brake", "Int")
xsp_parking_brake[0] = 0

xsp_gear_status	= create_dataref_table("kp/xsp/systems/gear_status", "Int")
xsp_gear_status[0] = 0

xsp_gear_light_on_n	= create_dataref_table("kp/xsp/systems/gear_light_on_n", "Int")
xsp_gear_light_on_n[0] = 0
xsp_gear_light_on_l	= create_dataref_table("kp/xsp/systems/gear_light_on_l", "Int")
xsp_gear_light_on_l[0] = 0
xsp_gear_light_on_r	= create_dataref_table("kp/xsp/systems/gear_light_on_r", "Int")
xsp_gear_light_on_r[0] = 0
xsp_gear_light_trans_n = create_dataref_table("kp/xsp/systems/gear_light_trans_n", "Int")
xsp_gear_light_trans_n[0] = 0
xsp_gear_light_trans_l = create_dataref_table("kp/xsp/systems/gear_light_trans_l", "Int")
xsp_gear_light_trans_l[0] = 0
xsp_gear_light_trans_r = create_dataref_table("kp/xsp/systems/gear_light_trans_r", "Int")
xsp_gear_light_trans_r[0] = 0

xsp_engine_fire = create_dataref_table("kp/xsp/engines/engine_fire", "Int")
xsp_engine_fire[0] = 0

xsp_anc_starter = create_dataref_table("kp/xsp/engines/anc_starter", "Int")
xsp_anc_starter[0] = 0

xsp_anc_reverse = create_dataref_table("kp/xsp/engines/anc_reverse", "Int")
xsp_anc_reverse[0] = 0

xsp_anc_oil = create_dataref_table("kp/xsp/engines/anc_oil", "Int")
xsp_anc_oil[0] = 0

xsp_master_caution = create_dataref_table("kp/xsp/systems/master_caution", "Int")
xsp_master_caution[0] = 0

xsp_master_warning = create_dataref_table("kp/xsp/systems/master_warning", "Int")
xsp_master_warning[0] = 0

xsp_doors = create_dataref_table("kp/xsp/systems/doors", "Int")
xsp_doors[0] = 0

xsp_apu_running	= create_dataref_table("kp/xsp/electric/apu_running", "Int")
xsp_apu_running[0] = 0

xsp_low_volts = create_dataref_table("kp/xsp/electric/low_volts", "Int")
xsp_low_volts[0] = 0

xsp_anc_hyd = create_dataref_table("kp/xsp/hydraulic/anc_hyd", "Int")
xsp_anc_hyd[0] = 0

xsp_fuel_pumps = create_dataref_table("kp/xsp/fuel/fuel_pumps", "Int")
xsp_fuel_pumps[0] = 0

xsp_vacuum = create_dataref_table("kp/xsp/air/vacuum", "Int")
xsp_vacuum[0] = 0

xsp_anc_aice = create_dataref_table("kp/xsp/aice/anc_aice", "Int")
xsp_anc_aice[0] = 0

xsp_mcp_hdg = create_dataref_table("kp/xsp/autopilot/mcp_hdg", "Int")
xsp_mcp_hdg[0] = 0

xsp_mcp_nav = create_dataref_table("kp/xsp/autopilot/mcp_nav", "Int")
xsp_mcp_nav[0] = 0

xsp_mcp_app = create_dataref_table("kp/xsp/autopilot/mcp_app", "Int")
xsp_mcp_app[0] = 0

xsp_mcp_ias = create_dataref_table("kp/xsp/autopilot/mcp_ias", "Int")
xsp_mcp_ias[0] = 0

xsp_mcp_vsp = create_dataref_table("kp/xsp/autopilot/mcp_vsp", "Int")
xsp_mcp_vsp[0] = 0

xsp_mcp_alt = create_dataref_table("kp/xsp/autopilot/mcp_alt", "Int")
xsp_mcp_alt[0] = 0

xsp_mcp_ap1 = create_dataref_table("kp/xsp/autopilot/mcp_ap1", "Int")
xsp_mcp_ap1[0] = 0

xsp_mcp_rev = create_dataref_table("kp/xsp/autopilot/mcp_rev", "Int")
xsp_mcp_rev[0] = 0

xsp_mcp_fdir = create_dataref_table("kp/xsp/autopilot/flight_director", "Int")
xsp_mcp_fdir[0] = 0

-------- Lights Annunciators (e.g. for Go-Flight) ----------
xsp_lights_ll = create_dataref_table("kp/xsp/lights/landing_lights", "Int")
xsp_lights_ll[0] = 0

xsp_lights_beacon = create_dataref_table("kp/xsp/lights/beacon", "Int")
xsp_lights_beacon[0] = 0

xsp_lights_position = create_dataref_table("kp/xsp/lights/position_lights", "Int")
xsp_lights_position[0] = 0

xsp_lights_strobes = create_dataref_table("kp/xsp/lights/strobes", "Int")
xsp_lights_strobes[0] = 0

xsp_lights_taxi = create_dataref_table("kp/xsp/lights/taxi_lights", "Int")
xsp_lights_taxi[0] = 0

xsp_lights_logo = create_dataref_table("kp/xsp/lights/logo_lights", "Int")
xsp_lights_logo[0] = 0

xsp_lights_rwy = create_dataref_table("kp/xsp/lights/runway_lights", "Int")
xsp_lights_rwy[0] = 0

xsp_lights_wing = create_dataref_table("kp/xsp/lights/wing_lights", "Int")
xsp_lights_wing[0] = 0

xsp_lights_wheel = create_dataref_table("kp/xsp/lights/wheel_lights", "Int")
xsp_lights_wheel[0] = 0

xsp_lights_dome = create_dataref_table("kp/xsp/lights/dome_lights", "Int")
xsp_lights_dome[0] = 0

xsp_lights_instrument = create_dataref_table("kp/xsp/lights/instrument_lights", "Int")
xsp_lights_instrument[0] = 0

-- background function every 1 sec to set lights/annunciators for hardware (honeycomb)
function xsp_set_light_drefs()

	-- PARKING BRAKE 0=off 1=set
	xsp_parking_brake[0] = sysGeneral.parkbrakeAnc:getStatus()

	-- GEAR LIGHTS
	xsp_gear_light_on_l[0] 		= sysGeneral.gearLeftGreenAnc:getStatus()
	xsp_gear_light_on_r[0] 		= sysGeneral.gearRightGreenAnc:getStatus()
	xsp_gear_light_on_n[0] 		= sysGeneral.gearNodeGreenAnc:getStatus()
	xsp_gear_light_trans_l[0] 	= sysGeneral.gearLeftRedAnc:getStatus()
	xsp_gear_light_trans_r[0] 	= sysGeneral.gearRightRedAnc:getStatus()
	xsp_gear_light_trans_n[0] 	= sysGeneral.gearNodeRedAnc:getStatus()
	xsp_gear_status[0] 			= sysGeneral.gearLightsAnc:getStatus()
	
	-- STARTER annunciator
	xsp_anc_starter[0] = sysEngines.engineStarterAnc:getStatus()

	-- OIL PRESSURE annunciator
	xsp_anc_oil[0] = sysEngines.OilPressureAnc:getStatus()
	
	-- ENGINE FIRE annunciator
	xsp_engine_fire[0] = sysEngines.engineFireAnc:getStatus()
	
	-- ENGINE REVERSE on
	xsp_anc_reverse[0] = sysEngines.reverseAnc:getStatus()
	
	-- MASTER CAUTION annunciator
	xsp_master_caution[0] = sysGeneral.masterCautionAnc:getStatus()

	-- MASTER WARNING annunciator
	xsp_master_warning[0] = sysGeneral.masterWarningAnc:getStatus()

	-- DOORS annunciator
	xsp_doors[0] = sysGeneral.doorsAnc:getStatus()
	
	-- APU annunciator
	xsp_apu_running[0] = sysElectric.apuRunningAnc:getStatus()
	
	-- LOW VOLTAGE annunciator
	xsp_low_volts[0] = sysElectric.lowVoltageAnc:getStatus()
	
	-- LOW HYD PRESSURE annunciator
	xsp_anc_hyd[0] = sysHydraulic.hydraulicLowAnc:getStatus()
	
	-- LOW FUEL PRESSURE annunciator
	xsp_fuel_pumps[0] = sysFuel.fuelLowAnc:getStatus()
	
	-- VACUUM annunciator
	xsp_vacuum[0] = sysAir.vacuumAnc:getStatus()
	
	-- ANTI ICE annunciator
	xsp_anc_aice[0] = sysAice.antiiceAnc:getStatus()

	-- HDG annunciator
	xsp_mcp_hdg[0] = sysMCP.hdgAnc:getStatus()

	-- NAV annunciator
	xsp_mcp_nav[0] = sysMCP.navAnc:getStatus()

	-- APR annunciator
	xsp_mcp_app[0] = sysMCP.aprAnc:getStatus()

	-- ALT annunciator
	xsp_mcp_alt[0] = sysMCP.altAnc:getStatus()

	-- VS annunciator
	xsp_mcp_vsp[0] = sysMCP.vspAnc:getStatus()

	-- IAS annunciator
	xsp_mcp_ias[0] = sysMCP.spdAnc:getStatus()

	-- AUTO PILOT annunciator
	xsp_mcp_ap1[0] = sysMCP.apAnc:getStatus()

	-- REV annunciator
	xsp_mcp_rev[0] = sysMCP.bcAnc:getStatus()

	-- FLIGHT DIRECTOR annunciator
	xsp_mcp_fdir[0] = sysMCP.fdirAnc:getStatus()
	
	-- Landing Lights status
	xsp_lights_ll[0] = sysLights.landingAnc:getStatus()

	-- beacon light annunciator
	xsp_lights_beacon[0] = sysLights.beaconAnc:getStatus()

	-- position lights annunciator
	xsp_lights_position[0] = sysLights.positionAnc:getStatus()

	-- strobes 
	xsp_lights_strobes[0] = sysLights.strobesAnc:getStatus()

	-- taxi lights
	xsp_lights_taxi[0] = sysLights.taxiAnc:getStatus()

	-- logo lights
	xsp_lights_logo[0] = sysLights.logoAnc:getStatus()

	-- runway
	xsp_lights_rwy[0] = sysLights.runwayAnc:getStatus()

	-- wing
	xsp_lights_wing[0] = sysLights.wingAnc:getStatus()

	-- wheel
	xsp_lights_wheel[0] = sysLights.wheelAnc:getStatus()

	-- dome
	xsp_lights_dome[0] = sysLights.domeAnc:getStatus()

	-- instruments
	xsp_lights_instrument[0] = sysLights.instrumentAnc:getStatus()

end

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
