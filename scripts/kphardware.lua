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
create_command("kp/xsp/lights/beacon_switch_on", "Beacon Lights On","sysLights.setSwitchBeacon(modeOn)","","")
create_command("kp/xsp/lights/beacon_switch_off","Beacon Lights Off","sysLights.setSwitchBeacon(modeOff)","","")
create_command("kp/xsp/lights/beacon_switch_tgl","Beacon Lights Toggle","sysLights.setSwitchBeacon(modeToggle)","","")

create_command("kp/xsp/lights/nav_switch_on","Navigation Lights On","sysLights.setSwitchPosition(modeOn)","","")
create_command("kp/xsp/lights/nav_switch_off","Navigation Lights Off","sysLights.setSwitchPosition(modeOff)", "", "")
create_command("kp/xsp/lights/nav_switch_tgl","Navigation Lights Toggle","sysLights.setSwitchPosition(modeToggle)","","")

create_command("kp/xsp/lights/strobe_switch_on","Strobe Lights On","sysLights.setSwitchStrobes(modeOn)","","")
create_command("kp/xsp/lights/strobe_switch_off","Strobe Lights Off","sysLights.setSwitchStrobes(modeOff)","","")
create_command("kp/xsp/lights/strobe_switch_tgl","Strobe Lights Toggle","sysLights.setSwitchStrobes(modeToggle)","","")

create_command("kp/xsp/lights/taxi_switch_on","Taxi Lights On","sysLights.setSwitchTaxi(modeOn)","","")
create_command("kp/xsp/lights/taxi_switch_off","Taxi Lights Off","sysLights.setSwitchTaxi(modeOff)","","")
create_command("kp/xsp/lights/taxi_switch_tgl","Taxi Lights Toggle","sysLights.setSwitchTaxi(modeToggle)","","")

create_command("kp/xsp/lights/landing_switch_on","Landing Lights On","sysLights.setSwitchLandingAll(modeOn)","","")
create_command("kp/xsp/lights/landing_switch_off","Landing Lights Off","sysLights.setSwitchLandingAll(modeOff)","","")
create_command("kp/xsp/lights/landing_switch_tgl","Landing Lights Toggle","sysLights.setSwitchLandingAll(modeToggle)","","")

create_command("kp/xsp/lights/wing_switch_on","Wing Lights On","sysLights.setSwitchWing(modeOn)","","")
create_command("kp/xsp/lights/wing_switch_off","Wing Lights Off","sysLights.setSwitchWing(modeOff)","","")
create_command("kp/xsp/lights/wing_switch_tgl","Wing Lights Toggle","sysLights.setSwitchWing(modeToggle)","","")

create_command("kp/xsp/lights/wheel_switch_on","Wheel Lights On","sysLights.setSwitchWheel(modeOn)", "", "")
create_command("kp/xsp/lights/wheel_switch_off","Wheel Lights Off","sysLights.setSwitchWheel(modeOff)", "", "")
create_command("kp/xsp/lights/wheel_switch_tgl","Wheel Lights Toggle","sysLights.setSwitchWheel(modeToggle)", "", "")

create_command("kp/xsp/lights/logo_switch_on","Logo Lights On","sysLights.setSwitchLogo(modeOn)","","")
create_command("kp/xsp/lights/logo_switch_off","Logo Lights Off","sysLights.setSwitchLogo(modeOff)","","")
create_command("kp/xsp/lights/logo_switch_tgl","Logo Lights Toggle","sysLights.setSwitchLogo(modeToggle)","","")

create_command("kp/xsp/lights/rwyto_switch_on","Runway Lights On","sysLights.setSwitchRunway(modeOn)","","")
create_command("kp/xsp/lights/rwyto_switch_off","Runway Lights Off","sysLights.setSwitchRunway(modeOff)","","")
create_command("kp/xsp/lights/rwyto_switch_tgl","Runway Lights Toggle","sysLights.setSwitchRunway(modeToggle)","","")

-- create_command("kp/xsp/lights/instruments_on","Instrument Lights On","sysLights.setInstrumentLightsMode(modeOn)","","")
-- create_command("kp/xsp/lights/instruments_off","Instrument Lights Off","sysLights.setInstrumentLightsMode(modeOff)","","")
-- create_command("kp/xsp/lights/instruments_tgl","Instrument Lights Toggle","sysLights.setInstrumentLightsMode(modeToggle)","","")

create_command("kp/xsp/lights/dome_switch_on","Cockpit Lights On","sysLights.setSwitchDome(modeOn)","","")
create_command("kp/xsp/lights/dome_switch_off","Cockpit Lights Off","sysLights.setSwitchDome(modeOff)","","")
create_command("kp/xsp/lights/dome_switch_tgl","Cockpit Lights Toggle","sysLights.setSwitchDome(modeToggle)","","")

---------------- General Systems ---------------------

-- create_command("kp/xsp/systems/parking_brake_on","Parking Brake On","sysGeneral.setParkBrakeMode(modeOn)","","")
-- create_command("kp/xsp/systems/parking_brake_off","Parking Brake Off","sysGeneral.setParkBrakeMode(modeOff)","","")
-- create_command("kp/xsp/systems/parking_brake_tgl","Parking Brake Toggle","sysGeneral.setParkBrakeMode(modeToggle)","","")

-- create_command("kp/xsp/systems/gears_up","Gears Up","sysGeneral.setGearMode(actUp)","","")
-- create_command("kp/xsp/systems/gears_down","Gears Down","sysGeneral.setGearMode(actDown)","","")
-- create_command("kp/xsp/systems/gears_off","Gears OFF","sysGeneral.setGearMode(sysGeneral.GearOff)","","")


-- create_command("kp/xsp/systems/all_alt_std","ALTS STD/QNH toggle","sysGeneral.actBaroStd(sysGeneral.BaroAll,modeToggle)","","")
-- create_command("kp/xsp/systems/baro_mode_tgl","Baro inch/mb toggle","sysGeneral.setBaroMode(sysGeneral.BaroAll,modeToggle)","","")
-- create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,actDown)","","")
-- create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.actBaroUpDown(sysGeneral.BaroAll,actUp)","","")

----------------- Flight Controls --------------------
-- create_command("kp/xsp/controls/flaps_up","Flaps 1 Up","sysControls.actFlapLever(actUp)","","")
-- create_command("kp/xsp/controls/flaps_down","Flaps 1 Down","sysControls.actFlapLever(actDown)","","")

-- create_command("kp/xsp/controls/pitch_trim_up","Pitch Trim Up",	"sysControls.actElevatorTrim(actUp)", "", "")
-- create_command("kp/xsp/controls/pitch_trim_down","Pitch Trim Down",	"sysControls.actElevatorTrim(actDown)", "", "")

-- create_command("kp/xsp/controls/rudder_trim_left","Rudder Trim Left",	"sysControls.actRudderTrim(actLeft)", "", "")
-- create_command("kp/xsp/controls/rudder_trim_right","Rudder Trim Right",	"sysControls.actRudderTrim(actRight)", "", "")
-- create_command("kp/xsp/controls/rudder_trim_center","Rudder Trim Center",	"sysControls.actRudderTrim(sysControls.Center)", "", "")

-- create_command("kp/xsp/controls/aileron_trim_left","Aileron Trim Left",	"sysControls.actAileronTrim(actLeft)", "", "")
-- create_command("kp/xsp/controls/aileron_trim_right","Aileron Trim Right",	"sysControls.actAileronTrim(actRight)", "", "")
-- create_command("kp/xsp/controls/aileron_trim_center","Aileron Trim Center",	"sysControls.actAileronTrim(sysControls.Center)", "", "")

-- --------------- Engines
-- create_command("kp/xsp/engines/reverse_on", "Reverse Thrust Full", "sysEngines.setReverseThrust(modeOn)", "", "")
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
	-- xsp_parking_brake[0] = sysGeneral.getParkBrakeMode()

	-- GEAR LIGHTS
	-- xsp_gear_light_on_l[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenLeft)
	-- xsp_gear_light_on_r[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenRight)
	-- xsp_gear_light_on_n[0] = sysGeneral.getGearLight(sysGeneral.GearLightGreenNose)
	-- xsp_gear_light_trans_l[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedLeft)
	-- xsp_gear_light_trans_r[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedRight)
	-- xsp_gear_light_trans_n[0] =  sysGeneral.getGearLight(sysGeneral.GearLightRedNose)
	
	-- STARTER annunciator
	-- xsp_anc_starter[0] = sysEngines.getStarterLight()

	-- OIL PRESSURE annunciator
	-- xsp_anc_oil[0] = sysEngines.getOilLight()
	
	-- ENGINE FIRE annunciator
	-- xsp_engine_fire[0] = sysEngines.getFireLight()
	
	-- MASTER CAUTION annunciator
	-- xsp_master_caution[0] = sysGeneral.getMasterCautionLight()

	-- MASTER WARNING annunciator
	-- xsp_master_warning[0] = sysGeneral.getMasterWarningLight()

	-- DOORS annunciator
	-- xsp_doors[0] = sysGeneral.getDoorsLight()
	
	-- APU annunciator
	-- xsp_apu_running[0] = sysElectric.getAPULight()
	
	-- LOW VOLTAGE annunciator
	-- xsp_low_volts[0] = sysElectric.getLowVoltageLight()
	
	-- LOW HYD PRESSURE annunciator
	-- xsp_anc_hyd[0] = sysHydraulic.getLowHydPressLight()
	
	-- LOW FUEL PRESSURE annunciator
	-- xsp_fuel_pumps[0] = sysFuel.getFuelPressLowLight()
	
	-- VACUUM annunciator
	-- xsp_vacuum[0] = sysAir.getVacuumLight()
	
	-- ANTI ICE annunciator
	-- xsp_anc_aice[0] = sysAice.getAntiIceLight()

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
