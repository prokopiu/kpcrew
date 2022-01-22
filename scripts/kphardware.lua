--[[
	*** KPHARDWARE
	Kosta Prokopiu, January 2022
--]]

local KPH_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPHARDWARE version " .. KPH_VERSION .." **" )

local acf_icao = "DFLT"

-- Aircraft with no ICAO in aircraft.cfg need to be identified individually
-- if (PLANE_TAILNUMBER == "N956OV") then	
	-- acf_icao="B146"
-- end
-- if (PLANE_TAILNUMBER == "PT-SSG") then	
	-- acf_icao="E170"
-- end
-- if (PLANE_TAILNUMBER == "PP-SSG") then	
	-- acf_icao="E195"
-- end
-- if (PLANE_TAILNUMBER == "E175") then	
	-- acf_icao="E175"
-- end
-- if (PLANE_TAILNUMBER == "C-GTLX") then	
	-- acf_icao = "A346"
-- end
-- if (PLANE_TAILNUMBER == "A345") then	
	-- acf_icao="A345"
-- end
	
-- Load plane specific module from Modules folder

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		acf_icao = "DFLT" -- add L738 module later
	else
		acf_icao="B738" -- Zibo Mod
	end
end

sysLights = require("kpcrew.systems." .. acf_icao .. ".sysLights")
sysGeneral = require("kpcrew.systems." .. acf_icao .. ".sysGeneral")	
sysControls = require("kpcrew.systems." .. acf_icao .. ".sysControls")	

-- ============ aircraft specific joystick/key commands (e.g. for Alpha Yoke)
-- ------------------ Lights
create_command("kp/xsp/lights/beacon_switch_on","Beacon Lights On","sysLights.setBeaconMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.setBeaconMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.setBeaconMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/nav_switch_on","Navigation Lights On","sysLights.setNavLightMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/nav_switch_off","Navigation Lights Off","sysLights.setNavLightMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/nav_switch_tgl","Navigation Lights Toggle","sysLights.setNavLightMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/strobe_switch_on","Strobe Lights On","sysLights.setStrobeLightMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/strobe_switch_off","Strobe Lights Off","sysLights.setStrobeLightMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/strobe_switch_tgl","Strobe Lights Toggle","sysLights.setStrobeLightMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/taxi_switch_on","Taxi Lights On","sysLights.setTaxiLightMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/taxi_switch_off","Taxi Lights Off","sysLights.setTaxiLightMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/taxi_switch_tgl","Taxi Lights Toggle","sysLights.setTaxiLightMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/landing_switch_on","Landing Lights On","sysLights.setLandingLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/landing_switch_off","Landing Lights Off","sysLights.setLandingLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/landing_switch_tgl","Landing Lights Toggle","sysLights.setLandingLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/wing_switch_on","Wing Lights On","sysLights.setWingLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/wing_switch_off","Wing Lights Off","sysLights.setWingLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/wing_switch_tgl","Wing Lights Toggle","sysLights.setWingLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/logo_switch_on","Logo Lights On","sysLights.setLogoLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/logo_switch_off","Logo Lights Off","sysLights.setLogoLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/logo_switch_tgl","Logo Lights Toggle","sysLights.setLogoLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/rwyto_switch_on","Runway Lights On","sysLights.setRwyLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/rwyto_switch_off","Runway Lights Off","sysLights.setRwyLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/rwyto_switch_tgl","Runway Lights Toggle","sysLights.setRwyLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/instruments_on","Instrument Lights On","sysLights.setInstrumentLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/instruments_off","Instrument Lights Off","sysLights.setInstrumentLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/instruments_tgl","Instrument Lights Toggle","sysLights.setInstrumentLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/dome_switch_on","Cockpit Lights On","sysLights.setCockpitLightsMode(sysLights.modeOn)","","")
create_command("kp/xsp/lights/dome_switch_off","Cockpit Lights Off","sysLights.setCockpitLightsMode(sysLights.modeOff)","","")
create_command("kp/xsp/lights/dome_switch_tgl","Cockpit Lights Toggle","sysLights.setCockpitLightsMode(sysLights.modeToggle)","","")

create_command("kp/xsp/lights/wheel_switch_on","Wheel Lights On","sysLights.setWheelLightsMode(sysLights.modeOn)", "", "")
create_command("kp/xsp/lights/wheel_switch_off","Wheel Lights Off","sysLights.setWheelLightsMode(sysLights.modeOff)", "", "")
create_command("kp/xsp/lights/wheel_switch_tgl","Wheel Lights Toggle","sysLights.setWheelLightsMode(sysLights.modeToggle)", "", "")

---------------- General Systems ---------------------

create_command("kp/xsp/systems/parking_brake_on","Parking Brake On","sysGeneral.setParkBrakeMode(sysGeneral.modeOn)","","")
create_command("kp/xsp/systems/parking_brake_off","Parking Brake Off","sysGeneral.setParkBrakeMode(sysGeneral.modeOff)","","")
create_command("kp/xsp/systems/parking_brake_tgl","Parking Brake Toggle","sysGeneral.setParkBrakeMode(sysGeneral.modeToggle)","","")

create_command("kp/xsp/systems/gears_up","Gears Up","sysGeneral.setGearMode(sysGeneral.modeGearUp)","","")
create_command("kp/xsp/systems/gears_down","Gears Down","sysGeneral.setGearMode(sysGeneral.modeGearDown)","","")
create_command("kp/xsp/systems/gears_off","Gears OFF","sysGeneral.setGearMode(sysGeneral.modeGearOff)","","")

create_command("kp/xsp/systems/all_alt_std","ALTS STD/QNH toggle","sysGeneral.actBaroStd(sysGeneral.BaroAll,sysGeneral.modeToggle)","","")
create_command("kp/xsp/systems/baro_mode_tgl","Baro inch/mb toggle","sysGeneral.setBaroMode(sysGeneral.BaroAll,sysGeneral.modeToggle)","","")
create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,sysGeneral.BaroDown)","","")
create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,sysGeneral.BaroUp)","","")

----------------- Flight Controls --------------------
create_command("kp/xsp/controls/flaps_up","Flaps 1 Up","sysGeneral.actFlapLever(sysGeneral.actFlapsUp)","","")
create_command("kp/xsp/controls/flaps_down","Flaps 1 Down","sysGeneral.actFlapLever(sysGeneral.actFlapsDown)","","")


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

-- background function every 1 sec to set lights/annunciators for hardware (honeycomb)
function xsp_set_light_drefs()

	-- PARKING BRAKE 0=off 1=set
	xsp_parking_brake[0] = sysGeneral.getParkBrakeMode()

	-- GEAR LIGHTS
	xsp_gear_light_on_l[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenLeft)
	xsp_gear_light_on_r[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenRight)
	xsp_gear_light_on_n[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenNose)
	xsp_gear_light_trans_l[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedLeft)
	xsp_gear_light_trans_r[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedRight)
	xsp_gear_light_trans_n[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedNose)

end

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
