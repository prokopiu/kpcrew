-- Hardware specific modules - Honeycomb Alpha Yoke
local sysLights 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysLights")
local sysGeneral 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysGeneral")	
local sysControls 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysControls")	
local sysEngines 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysEngines")	
local sysElectric 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysElectric")	
local sysHydraulic 			= require("kpcrew.systems." .. kh_acf_icao .. ".sysHydraulic")	
local sysFuel 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysFuel")	
local sysAir 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysAir")	
local sysAice 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysAice")	
local sysMCP 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysMCP")	
local sysEFIS 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysEFIS")	
local sysFMC 				= require("kpcrew.systems." .. kh_acf_icao .. ".sysFMC")	
local sysRadios				= require("kpcrew.systems." .. kh_acf_icao .. ".sysRadios")	

-- ALT
create_command("kp/xsp/alpha/ALT_on",	"Alpha ALT On", "sysElectric.alt1Switch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/ALT_off",	"Alpha ALT Off", "sysElectric.alt1Switch:actuate(modeOff)", "", "")

-- BAT
create_command("kp/xsp/alpha/BAT_on",	"Alpha BAT On", "sysElectric.bat1Switch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/BAT_off",	"Alpha BAT Off", "sysElectric.bat1Switch:actuate(modeOff)", "", "")

-- AVIONICS BUS 1
create_command("kp/xsp/alpha/AVIONICS_BUS1_on",	"Alpha AVIONICS BUS1 On", "sysElectric.avionicsBus:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/AVIONICS_BUS1_off","Alpha AVIONICS BUS1 Off", "sysElectric.avionicsBus:actuate(modeOff)", "", "")

-- AVIONICS BUS 2
create_command("kp/xsp/alpha/AVIONICS_BUS2_on",	"Alpha AVIONICS BUS2 On", "", "", "")
create_command("kp/xsp/alpha/AVIONICS_BUS2_off","Alpha AVIONICS BUS2 Off", "", "", "")

-- BCN
create_command("kp/xsp/alpha/BCN_on",	"Alpha BCN On", "sysLights.beaconSwitch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/BCN_off",	"Alpha BCN Off", "sysLights.beaconSwitch:actuate(modeOff)", "", "")

-- LAND
create_command("kp/xsp/alpha/LAND_on",	"Alpha LAND on", "sysLights.landLightGroup:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/LAND_off",	"Alpha LAND off", "sysLights.landLightGroup:actuate(modeOff)", "", "")

-- TAXI
create_command("kp/xsp/alpha/TAXI_on",	"Alpha TAXI On", "sysLights.taxiSwitch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/TAXI_off",	"Alpha TAXI Off", "sysLights.taxiSwitch:actuate(modeOff)", "", "")

-- NAV
create_command("kp/xsp/alpha/NAV_on",	"Alpha NAV On", "sysLights.positionSwitch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/NAV_off",	"Alpha NAV Off", "sysLights.positionSwitch:actuate(modeOff)", "", "")

-- STROBE
create_command("kp/xsp/alpha/STROBE_on",	"Alpha STROBE On", "sysLights.strobesSwitch:actuate(modeOn)", "", "")
create_command("kp/xsp/alpha/STROBE_off",	"Alpha STROBE Off", "sysLights.strobesSwitch:actuate(modeOff)", "", "")

-- MAGNETO OFF
create_command("kp/xsp/alpha/MAGNETO_OFF",	"Alpha MAGNETO OFF", "sysEngines.magnetos:adjustValue(0,0,3)", "", "")
-- R
create_command("kp/xsp/alpha/MAGNETO_R",	"Alpha MAGNETO R", "sysEngines.magnetos:adjustValue(1,0,3)", "", "")
-- L
create_command("kp/xsp/alpha/MAGNETO_L",	"Alpha MAGNETO L", "sysEngines.magnetos:adjustValue(2,0,3)", "", "")
-- BOTH
create_command("kp/xsp/alpha/MAGNETO_BOTH",	"Alpha MAGNETO BOTH", "sysEngines.magnetos:adjustValue(3,0,3)", "", "")
-- START
create_command("kp/xsp/alpha/MAGNETO_START","Alpha MAGNETO START", "sysEngines.magStart:actuate(1)", "", "")

-- WHITE LEFT
create_command("kp/xsp/alpha/white_left",	"Alpha WHITE Left", "", "", "")
-- WHITE RIGHT
create_command("kp/xsp/alpha/white_right",	"Alpha WHIRE Right", "", "", "")

-- A/P DISC
create_command("kp/xsp/alpha/AP_DISC",	"Alpha Autopilot Disc", "sysMCP.apDiscYoke:actuate(2)", "", "")

-- PTT
create_command("kp/xsp/alpha/PTT",	"Alpha PTT", "", "", "")

-- LEFT Rocker
create_command("kp/xsp/alpha/LEFT_ROCK_forward",	"Alpha Left Rocker forward", "", "", "")
create_command("kp/xsp/alpha/LEFT_ROCK_backward",	"Alpha Left Rocker backward", "", "", "")

-- RIGHT Rocker
create_command("kp/xsp/alpha/RIGHT_ROCK_forward",	"Alpha Right Rocker forward", "", "", "")
create_command("kp/xsp/alpha/RIGHT_ROCK_backward",	"Alpha Right Rocker backward", "", "", "")

-- UPPER Rocker
create_command("kp/xsp/alpha/UPPER_ROCK_left",	"Alpha Upper Rocker Left", "", "", "")
create_command("kp/xsp/alpha/UPPER_ROCK_right",	"Alpha Upper Rocker Right", "", "", "")

-- LOWER Rocker
create_command("kp/xsp/alpha/LOWER_ROCK_left",	"Alpha Lower Rocker Left", "", "", "")
create_command("kp/xsp/alpha/LOWER_ROCK_right",	"Alpha Lower Rocker Right", "", "", "")
