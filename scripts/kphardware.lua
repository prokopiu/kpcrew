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
	
-- Laminar MD82 -> MD82
-- Laminar 747 -> B744

-- Load plane specific module from Modules folder

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		acf_icao = "DFLT" -- add L738 module later
	else
		acf_icao = "B738" -- Zibo Mod
	end
end

sysLights = require("kpcrew.systems." .. acf_icao .. ".sysLights")
sysGeneral = require("kpcrew.systems." .. acf_icao .. ".sysGeneral")	
sysControls = require("kpcrew.systems." .. acf_icao .. ".sysControls")	
sysEngines = require("kpcrew.systems." .. acf_icao .. ".sysEngines")	
sysElectric = require("kpcrew.systems." .. acf_icao .. ".sysElectric")	
sysHydraulic = require("kpcrew.systems." .. acf_icao .. ".sysHydraulic")	
sysFuel = require("kpcrew.systems." .. acf_icao .. ".sysFuel")	

-- ============ aircraft specific joystick/key commands (e.g. for Alpha Yoke)
-- ------------------ Lights
create_command("kp/xsp/lights/beacon_switch_on","Beacon Lights On","sysLights.setBeaconMode(sysLights.On)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.setBeaconMode(sysLights.Off)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.setBeaconMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/nav_switch_on","Navigation Lights On","sysLights.setNavLightMode(sysLights.On)","","")
create_command("kp/xsp/lights/nav_switch_off","Navigation Lights Off","sysLights.setNavLightMode(sysLights.Off)", "", "")
create_command("kp/xsp/lights/nav_switch_tgl","Navigation Lights Toggle","sysLights.setNavLightMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/strobe_switch_on","Strobe Lights On","sysLights.setStrobeLightMode(sysLights.On)","","")
create_command("kp/xsp/lights/strobe_switch_off","Strobe Lights Off","sysLights.setStrobeLightMode(sysLights.Off)","","")
create_command("kp/xsp/lights/strobe_switch_tgl","Strobe Lights Toggle","sysLights.setStrobeLightMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/taxi_switch_on","Taxi Lights On","sysLights.setTaxiLightMode(sysLights.On)","","")
create_command("kp/xsp/lights/taxi_switch_off","Taxi Lights Off","sysLights.setTaxiLightMode(sysLights.Off)","","")
create_command("kp/xsp/lights/taxi_switch_tgl","Taxi Lights Toggle","sysLights.setTaxiLightMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/landing_switch_on","Landing Lights On","sysLights.setLandingLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/landing_switch_off","Landing Lights Off","sysLights.setLandingLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/landing_switch_tgl","Landing Lights Toggle","sysLights.setLandingLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/wing_switch_on","Wing Lights On","sysLights.setWingLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/wing_switch_off","Wing Lights Off","sysLights.setWingLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/wing_switch_tgl","Wing Lights Toggle","sysLights.setWingLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/logo_switch_on","Logo Lights On","sysLights.setLogoLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/logo_switch_off","Logo Lights Off","sysLights.setLogoLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/logo_switch_tgl","Logo Lights Toggle","sysLights.setLogoLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/rwyto_switch_on","Runway Lights On","sysLights.setRwyLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/rwyto_switch_off","Runway Lights Off","sysLights.setRwyLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/rwyto_switch_tgl","Runway Lights Toggle","sysLights.setRwyLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/instruments_on","Instrument Lights On","sysLights.setInstrumentLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/instruments_off","Instrument Lights Off","sysLights.setInstrumentLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/instruments_tgl","Instrument Lights Toggle","sysLights.setInstrumentLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/dome_switch_on","Cockpit Lights On","sysLights.setCockpitLightsMode(sysLights.On)","","")
create_command("kp/xsp/lights/dome_switch_off","Cockpit Lights Off","sysLights.setCockpitLightsMode(sysLights.Off)","","")
create_command("kp/xsp/lights/dome_switch_tgl","Cockpit Lights Toggle","sysLights.setCockpitLightsMode(sysLights.Toggle)","","")

create_command("kp/xsp/lights/wheel_switch_on","Wheel Lights On","sysLights.setWheelLightsMode(sysLights.On)", "", "")
create_command("kp/xsp/lights/wheel_switch_off","Wheel Lights Off","sysLights.setWheelLightsMode(sysLights.Off)", "", "")
create_command("kp/xsp/lights/wheel_switch_tgl","Wheel Lights Toggle","sysLights.setWheelLightsMode(sysLights.Toggle)", "", "")

---------------- General Systems ---------------------

create_command("kp/xsp/systems/parking_brake_on","Parking Brake On","sysGeneral.setParkBrakeMode(sysGeneral.On)","","")
create_command("kp/xsp/systems/parking_brake_off","Parking Brake Off","sysGeneral.setParkBrakeMode(sysGeneral.Off)","","")
create_command("kp/xsp/systems/parking_brake_tgl","Parking Brake Toggle","sysGeneral.setParkBrakeMode(sysGeneral.Toggle)","","")

create_command("kp/xsp/systems/gears_up","Gears Up","sysGeneral.setGearMode(sysGeneral.Up)","","")
create_command("kp/xsp/systems/gears_down","Gears Down","sysGeneral.setGearMode(sysGeneral.Down)","","")
create_command("kp/xsp/systems/gears_off","Gears OFF","sysGeneral.setGearMode(sysGeneral.GearOff)","","")


create_command("kp/xsp/systems/all_alt_std","ALTS STD/QNH toggle","sysGeneral.actBaroStd(sysGeneral.BaroAll,sysGeneral.Toggle)","","")
create_command("kp/xsp/systems/baro_mode_tgl","Baro inch/mb toggle","sysGeneral.setBaroMode(sysGeneral.BaroAll,sysGeneral.Toggle)","","")
create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,sysGeneral.Down)","","")
create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,sysGeneral.Up)","","")

----------------- Flight Controls --------------------
create_command("kp/xsp/controls/flaps_up","Flaps 1 Up","sysControls.actFlapLever(sysControls.Up)","","")
create_command("kp/xsp/controls/flaps_down","Flaps 1 Down","sysControls.actFlapLever(sysControls.Down)","","")

create_command("kp/xsp/controls/pitch_trim_up","Pitch Trim Up",	"sysControls.actElevatorTrim(sysControls.Up)", "", "")
create_command("kp/xsp/controls/pitch_trim_down","Pitch Trim Down",	"sysControls.actElevatorTrim(sysControls.Down)", "", "")

create_command("kp/xsp/controls/rudder_trim_left","Rudder Trim Left",	"sysControls.actRudderTrim(sysControls.Left)", "", "")
create_command("kp/xsp/controls/rudder_trim_right","Rudder Trim Right",	"sysControls.actRudderTrim(sysControls.Right)", "", "")
create_command("kp/xsp/controls/rudder_trim_center","Rudder Trim Center",	"sysControls.actRudderTrim(sysControls.Center)", "", "")

create_command("kp/xsp/controls/aileron_trim_left","Aileron Trim Left",	"sysControls.actAileronTrim(sysControls.Left)", "", "")
create_command("kp/xsp/controls/aileron_trim_right","Aileron Trim Right",	"sysControls.actAileronTrim(sysControls.Right)", "", "")
create_command("kp/xsp/controls/aileron_trim_center","Aileron Trim Center",	"sysControls.actAileronTrim(sysControls.Center)", "", "")

-- --------------- Engines
create_command("kp/xsp/engines/reverse_on", "Reverse Thrust Full", "sysEngines.setReverseThrust(sysEngines.On)", "", "")
create_command("kp/xsp/engines/reverse_off", "Reverse Thrust Off", "sysEngines.setReverseThrust(sysEngines.Off)", "", "")

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
	
	-- STARTER annunciator
	xsp_anc_starter[0] = sysEngines.getStarterLight()

	-- OIL PRESSURE annunciator
	xsp_anc_oil[0] = sysEngines.getOilLight()
	
	-- ENGINE FIRE annunciator
	xsp_engine_fire[0] = sysEngines.getFireLight()
	
	-- MASTER CAUTION annunciator
	xsp_master_caution[0] = sysGeneral.getMasterCautionLight()

	-- MASTER WARNING annunciator
	xsp_master_warning[0] = sysGeneral.getMasterWarningLight()

	-- DOORS annunciator
	xsp_doors[0] = sysGeneral.getDoorsLight()
	
	-- APU annunciator
	xsp_apu_running[0] = sysElectric.getAPULight()
	
	-- LOW VOLTAGE annunciator
	xsp_low_volts[0] = sysElectric.getLowVoltageLight()
	
	-- LOW HYD PRESSURE annunciator
	xsp_anc_hyd[0] = sysHydraulic.getLowHydPressLight()
	
	-- LOW FUEL PRESSURE annunciator
	xsp_fuel_pumps[0] = sysFuel.getFuelPressLowLight()
end

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
