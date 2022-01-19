--[[
	*** KPHARDWARE
	Kosta Prokopiu, January 2022
--]]

local genutils = require "kpcrew.genutils"

local ZC_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPHARDWARE version " .. ZC_VERSION .." **" )

local acf_icao = "DFLT"

-- Aircraft with no icao in aircraft.cfg need to be identfied individually
if (PLANE_TAILNUMBER == "N956OV") then	
	acf_icao="B146"
end
if (PLANE_TAILNUMBER == "PT-SSG") then	
	acf_icao="E170"
end
if (PLANE_TAILNUMBER == "PP-SSG") then	
	acf_icao="E195"
end
if (PLANE_TAILNUMBER == "E175") then	
	acf_icao="E175"
end
if (PLANE_TAILNUMBER == "C-GTLX") then	
	acf_icao = "A346"
end
if (PLANE_TAILNUMBER == "A345") then	
	acf_icao="A345"
end
	
-- Load plane specific module from Modules folder

-- Zibo B738
if (PLANE_ICAO == "B738") then
  acf_icao="B738"
end

local syslights = nil
if (acf_icao == "DFLT") then
	sysLights = require "kpcrew.systems.DFLT.sysLights"	
end

sysLights.setRwyLightsMode(sysLights.modeToggle)

-- ============ aircraft specific joystick/key commands (e.g. for Alpha Yoke)
-- ------------------ Lights
create_command("kp/xsp/lights/beacon_switch_on",	"Beacon Lights On",		"sysLights.setBeaconMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/beacon_switch_off",	"Beacon Lights Off",	"sysLights.setBeaconMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/beacon_switch_tgl",	"Beacon Lights Toggle",	"sysLights.setBeaconMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/nav_switch_on",		"Navigation Lights On",		"sysLights.setNavLightMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/nav_switch_off",		"Navigation Lights Off",	"sysLights.setNavLightMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/nav_switch_tgl",		"Navigation Lights Toggle",	"sysLights.setNavLightMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/strobe_switch_on",	"Strobe Lights On",		"sysLights.setStrobeLightMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/strobe_switch_off",	"Strobe Lights Off",	"sysLights.setStrobeLightMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/strobe_switch_tgl",	"Strobe Lights Toggle",	"sysLights.setStrobeLightMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/taxi_switch_on",		"Taxi Lights On",		"sysLights.setTaxiLightMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/taxi_switch_off",		"Taxi Lights Off",		"sysLights.setTaxiLightMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/taxi_switch_tgl",		"Taxi Lights Toggle",	"sysLights.setTaxiLightMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/landing_switch_on",	"Landing Lights On",	"sysLights.setLandingLightsMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/landing_switch_off",	"Landing Lights Off",	"sysLights.setLandingLightsMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/landing_switch_tgl",	"Landing Lights Toggle","sysLights.setLandingLightsMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/wing_switch_on",		"Wing Lights On",		"sysLights.setWingLightsMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/wing_switch_off",		"Wing Lights Off",		"sysLights.setWingLightsMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/wing_switch_tgl",		"Wing Lights Toggle",	"sysLights.setWingLightsMode(sysLights.modeToggle)", "", "")

create_command("kp/xsp/lights/logo_switch_on",		"Logo Lights On",		"sysLights.setLogoLightsMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/logo_switch_off",		"Logo Lights Off",		"sysLights.setLogoLightsMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/logo_switch_tgl",		"Logo Lights Toggle",	"sysLights.setLogoLightsMode(sysLights.modeToggle)", "", "")

-- in FlyWithLua menu
--add_macro("KPCrew Re-Start", "kc_init_kpcrew()")

-- ---------------------------------- KPCrew commands ----------------------------------
--create_command("kp/crew/master_button",		"KPCrew Master Button",		"kc_master_button()", "", "")

--do_often("kc_proc_activities()")
