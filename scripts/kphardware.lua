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
create_command("kp/xsp/lights/beacon_switch_on", "Beacon Lights On","sysLights.setSwitch(\"beacon\",0,modeOn)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.setSwitch(\"beacon\",0,modeOff)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.setSwitch(\"beacon\",0,modeToggle)","","")

create_command("kp/xsp/lights/position_switch_on","Position Lights On","sysLights.setSwitch(\"position\",0,modeOn)","","")
create_command("kp/xsp/lights/position_switch_off","Position Lights Off","sysLights.setSwitch(\"position\",0,modeOff)", "", "")
create_command("kp/xsp/lights/position_switch_tgl","Position Lights Toggle","sysLights.setSwitch(\"position\",0,modeToggle)","","")

create_command("kp/xsp/lights/strobe_switch_on","Strobe Lights On","sysLights.setSwitch(\"strobes\",0,modeOn)","","")
create_command("kp/xsp/lights/strobe_switch_off","Strobe Lights Off","sysLights.setSwitch(\"strobes\",0,modeOff)","","")
create_command("kp/xsp/lights/strobe_switch_tgl","Strobe Lights Toggle","sysLights.setSwitch(\"strobes\",0,modeToggle)","","")

create_command("kp/xsp/lights/taxi_switch_on","Taxi Lights On","sysLights.setSwitch(\"taxi\",0,modeOn)","","")
create_command("kp/xsp/lights/taxi_switch_off","Taxi Lights Off","sysLights.setSwitch(\"taxi\",0,modeOff)","","")
create_command("kp/xsp/lights/taxi_switch_tgl","Taxi Lights Toggle","sysLights.setSwitch(\"taxi\",0,modeToggle)","","")

create_command("kp/xsp/lights/landing_switch_on","Landing Lights On","sysLights.setSwitch(\"landing\",-1,modeOn)","","")
create_command("kp/xsp/lights/landing_switch_off","Landing Lights Off","sysLights.setSwitch(\"landing\",-1,modeOff)","","")
create_command("kp/xsp/lights/landing_switch_tgl","Landing Lights Toggle","sysLights.setSwitch(\"landing\",-1,modeToggle)","","")

create_command("kp/xsp/lights/wing_switch_on","Wing Lights On","sysLights.setSwitch(\"wing\",0,modeOn)","","")
create_command("kp/xsp/lights/wing_switch_off","Wing Lights Off","sysLights.setSwitch(\"wing\",0,modeOff)","","")
create_command("kp/xsp/lights/wing_switch_tgl","Wing Lights Toggle","sysLights.setSwitch(\"wing\",0,modeToggle)","","")

create_command("kp/xsp/lights/wheel_switch_on","Wheel Lights On","sysLights.setSwitch(\"wheel\",0,modeOn)", "", "")
create_command("kp/xsp/lights/wheel_switch_off","Wheel Lights Off","sysLights.setSwitch(\"wheel\",0,modeOff)", "", "")
create_command("kp/xsp/lights/wheel_switch_tgl","Wheel Lights Toggle","sysLights.setSwitch(\"wheel\",0,modeToggle)", "", "")

create_command("kp/xsp/lights/logo_switch_on","Logo Lights On","sysLights.setSwitch(\"logo\",0,modeOn)","","")
create_command("kp/xsp/lights/logo_switch_off","Logo Lights Off","sysLights.setSwitch(\"logo\",0,modeOff)","","")
create_command("kp/xsp/lights/logo_switch_tgl","Logo Lights Toggle","sysLights.setSwitch(\"logo\",0,modeToggle)","","")

create_command("kp/xsp/lights/rwyto_switch_on","Runway Lights On","sysLights.setSwitch(\"runway\",-1,modeOn)","","")
create_command("kp/xsp/lights/rwyto_switch_off","Runway Lights Off","sysLights.setSwitch(\"runway\",-1,modeOff)","","")
create_command("kp/xsp/lights/rwyto_switch_tgl","Runway Lights Toggle","sysLights.setSwitch(\"runway\",-1,modeToggle)","","")

create_command("kp/xsp/lights/instruments_on","Instrument Lights On","sysLights.setSwitch(\"instruments\",-1,modeOn)","","")
create_command("kp/xsp/lights/instruments_off","Instrument Lights Off","sysLights.setSwitch(\"instruments\",-1,modeOff)","","")
create_command("kp/xsp/lights/instruments_tgl","Instrument Lights Toggle","sysLights.setSwitch(\"instruments\",-1,modeToggle)","","")

create_command("kp/xsp/lights/dome_switch_on","Cockpit Lights On","sysLights.setSwitch(\"dome\",0,modeOn)","","")
create_command("kp/xsp/lights/dome_switch_off","Cockpit Lights Off","sysLights.setSwitch(\"dome\",0,modeOff)","","")
create_command("kp/xsp/lights/dome_switch_tgl","Cockpit Lights Toggle","sysLights.setSwitch(\"dome\",0,modeToggle)","","")

---------------- General Systems ---------------------

create_command("kp/xsp/systems/parking_brake_on","Parking Brake On","sysGeneral.setSwitch(\"parkbrake\",0,modeOn)","","")
create_command("kp/xsp/systems/parking_brake_off","Parking Brake Off","sysGeneral.setSwitch(\"parkbrake\",0,modeOff)","","")
create_command("kp/xsp/systems/parking_brake_tgl","Parking Brake Toggle","sysGeneral.setSwitch(\"parkbrake\",0,modeToggle)","","")

create_command("kp/xsp/systems/gears_up","Gears Up","sysGeneral.setSwitch(\"landinggear\",0,sysGeneral.GearUp)","","")
create_command("kp/xsp/systems/gears_down","Gears Down","sysGeneral.setSwitch(\"landinggear\",0,sysGeneral.GearDown)","","")
create_command("kp/xsp/systems/gears_off","Gears OFF","sysGeneral.setSwitch(\"landinggear\",0,sysGeneral.GearOff)","","")


create_command("kp/xsp/systems/all_alt_std","ALTS STD/QNH toggle","sysGeneral.setSwitch(\"barostd\",-1,modeToggle)","","")
create_command("kp/xsp/systems/baro_mode_tgl","Baro inch/mb toggle","sysGeneral.setSwitch(\"baromode\",-1,modeToggle)","","")
create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.setSwitch(\"barovalue\",-1,cmdDown)","","")
create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.setSwitch(\"barovalue\",-1,cmdUp)","","")

create_command("kp/xsp/test","Test","sysGeneral.setSwitch(\"doors\",-1,modeToggle)","","")


----------------- Flight Controls --------------------
create_command("kp/xsp/controls/flaps_up","Flaps 1 Up","sysControls.setSwitch(\"flaps\",0,cmdUp)","","")
create_command("kp/xsp/controls/flaps_down","Flaps 1 Down","sysControls.setSwitch(\"flaps\",0,cmdDown)","","")

create_command("kp/xsp/controls/pitch_trim_up","Pitch Trim Up","sysControls.setSwitch(\"pitchtrim\",0,cmdUp)", "", "")
create_command("kp/xsp/controls/pitch_trim_down","Pitch Trim Down","sysControls.setSwitch(\"pitchtrim\",0,cmdDown)", "", "")

create_command("kp/xsp/controls/rudder_trim_left","Rudder Trim Left","sysControls.setSwitch(\"ailerontrim\",0,cmdLeft)", "", "")
create_command("kp/xsp/controls/rudder_trim_right","Rudder Trim Right","sysControls.setSwitch(\"ailerontrim\",0,cmdRight)", "", "")
create_command("kp/xsp/controls/rudder_trim_center","Rudder Trim Center","sysControls.setSwitch(\"ailerontrim\",0,sysControls.trimCenter)", "", "")

create_command("kp/xsp/controls/aileron_trim_left","Aileron Trim Left","sysControls.setSwitch(\"ruddertrim\",0,cmdLeft)", "", "")
create_command("kp/xsp/controls/aileron_trim_right","Aileron Trim Right","sysControls.setSwitch(\"ruddertrim\",0,cmdRight)", "", "")
create_command("kp/xsp/controls/aileron_trim_center","Aileron Trim Center","sysControls.setSwitch(\"ruddertrim\",0,sysControls.trimCenter)", "", "")

-- --------------- Engines
create_command("kp/xsp/engines/reverse_on", "Reverse Thrust Full", "sysEngines.setSwitch(\"reversethrust\",-1,modeOn)", "", "")
-- create_command("kp/xsp/engines/reverse_off", "Reverse Thrust Off", "sysEngines.setReverseThrust(modeOff)", "", "")

-- --------------- Autopilot / MCP
-- ------------ A/P MCP functions
-- create_command("kp/xsp/autopilot/both_fd_tgl",		"All FDs Toggle",		"kc_acf_mcp_fds_set(0,2)", "", "")
-- create_command("kp/xsp/autopilot/bc_tgl",			"Toggle Reverse Appr",	"xsp_toggle_rev_course()", "", "")
-- create_command("kp/xsp/autopilot/ap_tgl",			"Toggle A/P 1",			"kc_acf_mcp_ap_set(1,2)", "", "")
-- create_command("kp/xsp/autopilot/alt_tgl",			"Toggle Altitude",		"kc_acf_mcp_althld_onoff(2)","","")
-- create_command("kp/xsp/autopilot/hdg_tgl",			"Toggle Heading",		"kc_acf_mcp_hdgsel_onoff(2)","","")
-- create_command("kp/xsp/autopilot/nav_tgl",			"Toggle Nav",			"kc_acf_mcp_vorloc_onoff(2)","","")
-- create_command("kp/xsp/autopilot/app_tgl",			"Toggle Approach",		"kc_acf_mcp_app_onoff(2)","","")
-- create_command("kp/xsp/autopilot/vs_tgl",			"Toggle Vertical Speed","kc_acf_mcp_vs_onoff(2)","","")
-- create_command("kp/xsp/autopilot/ias_tgl",			"Toggle IAS",			"kc_acf_mcp_spd_onoff(2)","","")
-- create_command("kp/xsp/autopilot/toga_press",		"Press Left TOGA",		"kc_acf_mcp_toga()","","")
-- create_command("kp/xsp/autopilot/at_tgl",			"Toggle A/T",			"kc_acf_mcp_at_onoff(2)","","")
-- create_command("kp/xsp/autopilot/at_arm",			"Arm A/T",				"kc_acf_mcp_at_onoff(1)","","")
-- create_command("kp/xsp/autopilot/at_off",			"A/T OFF",				"kc_acf_mcp_at_onoff(0)","","")

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
	xsp_parking_brake[0] = sysGeneral.getAnnunciator("parkbrake",0)

	-- GEAR LIGHTS
	xsp_gear_light_on_l[0] 		= sysGeneral.getAnnunciator("gearlights",0)
	xsp_gear_light_on_r[0] 		= sysGeneral.getAnnunciator("gearlights",1)
	xsp_gear_light_on_n[0] 		= sysGeneral.getAnnunciator("gearlights",2)
	xsp_gear_light_trans_l[0] 	= sysGeneral.getAnnunciator("gearlights",3)
	xsp_gear_light_trans_r[0] 	= sysGeneral.getAnnunciator("gearlights",4)
	xsp_gear_light_trans_n[0] 	= sysGeneral.getAnnunciator("gearlights",5)
	xsp_gear_status[0] 			= sysGeneral.getAnnunciator("gearstatus",0)
	
	-- STARTER annunciator
	xsp_anc_starter[0] = sysEngines.getAnnunciator("starter",0)

	-- OIL PRESSURE annunciator
	xsp_anc_oil[0] = sysEngines.getAnnunciator("oilpressure",0)
	
	-- ENGINE FIRE annunciator
	xsp_engine_fire[0] = sysEngines.getAnnunciator("enginefire",0)
	
	-- ENGINE REVERSE on
	xsp_anc_reverse[0] = sysEngines.getAnnunciator("reversethrust",0)
	
	-- MASTER CAUTION annunciator
	xsp_master_caution[0] = sysGeneral.getAnnunciator("mastercaution",0)

	-- MASTER WARNING annunciator
	xsp_master_warning[0] = sysGeneral.getAnnunciator("masterwarning",0)

	-- DOORS annunciator
	xsp_doors[0] = sysGeneral.getAnnunciator("doorstatus",0)
	
	-- APU annunciator
	xsp_apu_running[0] = sysElectric.getAnnunciator("apurunning",0)
	
	-- LOW VOLTAGE annunciator
	xsp_low_volts[0] = sysElectric.getAnnunciator("lowvoltage",0)
	
	-- LOW HYD PRESSURE annunciator
	xsp_anc_hyd[0] = sysHydraulic.getAnnunciator("lowhydraulic",0)
	
	-- LOW FUEL PRESSURE annunciator
	xsp_fuel_pumps[0] = sysFuel.getAnnunciator("fuelprslow",0)
	
	-- VACUUM annunciator
	xsp_vacuum[0] = sysAir.getAnnunciator("vacuum",0)
	
	-- ANTI ICE annunciator
	xsp_anc_aice[0] = sysAice.getAnnunciator("antiice",0)

	-- HDG annunciator
	xsp_mcp_hdg[0] = sysMCP.getAnnunciator("hdganc",0)

	-- NAV annunciator
	xsp_mcp_nav[0] = sysMCP.getAnnunciator("navanc",0)

	-- APR annunciator
	xsp_mcp_app[0] = sysMCP.getAnnunciator("apranc",0)

	-- ALT annunciator
	xsp_mcp_alt[0] = sysMCP.getAnnunciator("altanc",0)

	-- VS annunciator
	xsp_mcp_vsp[0] = sysMCP.getAnnunciator("vspanc",0)

	-- IAS annunciator
	xsp_mcp_ias[0] = sysMCP.getAnnunciator("spdanc",0)

	-- AUTO PILOT annunciator
	xsp_mcp_ap1[0] = sysMCP.getAnnunciator("autopilotanc",0)

	-- REV annunciator
	xsp_mcp_rev[0] = sysMCP.getAnnunciator("bcanc",0)
	
	-- Landing Lights status
	xsp_lights_ll[0] = sysLights.getAnnunciator("landinglights",0)

	-- beacon light annunciator
	xsp_lights_beacon[0] = sysLights.getAnnunciator("beacon",0)

	-- position lights annunciator
	xsp_lights_position[0] = sysLights.getAnnunciator("position",0)

	-- strobes 
	xsp_lights_strobes[0] = sysLights.getAnnunciator("strobes",0)

	-- taxi lights
	xsp_lights_taxi[0] = sysLights.getAnnunciator("taxi",0)

	-- logo lights
	xsp_lights_logo[0] = sysLights.getAnnunciator("logo",0)

	-- runway
	xsp_lights_rwy[0] = sysLights.getAnnunciator("runway",0)

	-- wing
	xsp_lights_wing[0] = sysLights.getAnnunciator("wing",0)

	-- wheel
	xsp_lights_wheel[0] = sysLights.getAnnunciator("wheel",0)

	-- dome
	xsp_lights_dome[0] = sysLights.getAnnunciator("dome",0)

	-- instruments
	xsp_lights_instrument[0] = sysLights.getAnnunciator("instruments",0)

end

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
