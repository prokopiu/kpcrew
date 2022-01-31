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
create_command("kp/xsp/lights/beacon_switch_on", "Beacon Lights On","sysLights.setSwitch(\"beacons\",0,modeOn)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.setSwitch(\"beacons\",0,modeOff)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.setSwitch(\"beacons\",0,modeToggle)","","")

create_command("kp/xsp/lights/nav_switch_on","Navigation Lights On","sysLights.setSwitch(\"position\",0,modeOn)","","")
create_command("kp/xsp/lights/nav_switch_off","Navigation Lights Off","sysLights.setSwitch(\"position\",0,modeOff)", "", "")
create_command("kp/xsp/lights/nav_switch_tgl","Navigation Lights Toggle","sysLights.setSwitch(\"position\",0,modeToggle)","","")

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

create_command("kp/xsp/systems/test","TEST","sysGeneral.setSwitch(\"doors\",-1,modeToggle)","","")


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

--------------- Instantiate Datarefs for hardware annunciators (e.g. honeycomb) ----------- 

xsp_parking_brake = create_dataref_table("kp/xsp/systems/parking_brake", "Int")
xsp_parking_brake[0] = 0

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

-- background function every 1 sec to set lights/annunciators for hardware (honeycomb)
function xsp_set_light_drefs()

	-- PARKING BRAKE 0=off 1=set
	xsp_parking_brake[0] = sysGeneral.getMode("parkbrake",0)

	-- GEAR LIGHTS
	xsp_gear_light_on_l[0] 		= sysGeneral.getMode("gearlights",0)
	xsp_gear_light_on_r[0] 		= sysGeneral.getMode("gearlights",1)
	xsp_gear_light_on_n[0] 		= sysGeneral.getMode("gearlights",2)
	xsp_gear_light_trans_l[0] 	= sysGeneral.getMode("gearlights",3)
	xsp_gear_light_trans_r[0] 	= sysGeneral.getMode("gearlights",4)
	xsp_gear_light_trans_n[0] 	= sysGeneral.getMode("gearlights",5)
	
	-- STARTER annunciator
	xsp_anc_starter[0] = sysEngines.getMode("starter",0)

	-- OIL PRESSURE annunciator
	xsp_anc_oil[0] = sysEngines.getMode("oilpressure",0)
	
	-- ENGINE FIRE annunciator
	xsp_engine_fire[0] = sysEngines.getMode("enginefire",0)
	
	-- MASTER CAUTION annunciator
	xsp_master_caution[0] = sysGeneral.getMode("mastercaution",0)

	-- MASTER WARNING annunciator
	xsp_master_warning[0] = sysGeneral.getMode("masterwarning",0)

	-- DOORS annunciator
	xsp_doors[0] = sysGeneral.getMode("doorstatus",0)
	
	-- APU annunciator
	xsp_apu_running[0] = sysElectric.getMode("apurunning",0)
	
	-- LOW VOLTAGE annunciator
	xsp_low_volts[0] = sysElectric.getMode("lowvoltage",0)
	
	-- LOW HYD PRESSURE annunciator
	xsp_anc_hyd[0] = sysHydraulic.getMode("lowhydraulic",0)
	
	-- LOW FUEL PRESSURE annunciator
	xsp_fuel_pumps[0] = sysFuel.getMode("fuelprslow",0)
	
	-- VACUUM annunciator
	xsp_vacuum[0] = sysAir.getMode("vacuum",0)
	
	-- ANTI ICE annunciator
	xsp_anc_aice[0] = sysAice.getMode("antiice",0)

	-- HDG annunciator
	-- xsp_mcp_hdg[0] = sysMCP.getHDGLight()

	-- NAV annunciator
	-- xsp_mcp_nav[0] = sysMCP.getNAVLight()

	-- APR annunciator
	-- xsp_mcp_app[0] = sysMCP.getAPRLight()

	-- ALT annunciator
	-- xsp_mcp_alt[0] = sysMCP.getALTLight()

	-- VS annunciator
	-- xsp_mcp_vsp[0] = sysMCP.getVSLight()

	-- IAS annunciator
	-- xsp_mcp_ias[0] = sysMCP.getSPDLight()

	-- AUTO PILOT annunciator
	-- xsp_mcp_ap1[0] = sysMCP.getAPLight()

	-- REV annunciator
	-- xsp_mcp_rev[0] = sysMCP.getBCLight()

end

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
