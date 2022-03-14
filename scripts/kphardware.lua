--[[
	*** KPHARDWARE
	Kosta Prokopiu, January 2022
--]]

require "kpcrew.genutils"
require "kpcrew.systems.activities"

local KPH_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPHARDWARE version " .. KPH_VERSION .." **" )

-- ====== Global variables =======
kh_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- Laminar MD82 -> MD82
-- Laminar 747 -> B744, check Sparky 744

-- Load plane specific module from Modules folder

-- Zibo B738 - use different module for default Laminar B738
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kh_acf_icao = "DFLT" 
	else
		kh_acf_icao = "B738" -- Zibo Mod
	end
end

sysLights = require("kpcrew.systems." .. kh_acf_icao .. ".sysLights")
sysGeneral = require("kpcrew.systems." .. kh_acf_icao .. ".sysGeneral")	
sysControls = require("kpcrew.systems." .. kh_acf_icao .. ".sysControls")	
sysEngines = require("kpcrew.systems." .. kh_acf_icao .. ".sysEngines")	
sysElectric = require("kpcrew.systems." .. kh_acf_icao .. ".sysElectric")	
sysHydraulic = require("kpcrew.systems." .. kh_acf_icao .. ".sysHydraulic")	
sysFuel = require("kpcrew.systems." .. kh_acf_icao .. ".sysFuel")	
sysAir = require("kpcrew.systems." .. kh_acf_icao .. ".sysAir")	
sysAice = require("kpcrew.systems." .. kh_acf_icao .. ".sysAice")	
sysMCP = require("kpcrew.systems." .. kh_acf_icao .. ".sysMCP")	
sysEFIS = require("kpcrew.systems." .. kh_acf_icao .. ".sysEFIS")	
sysRadios = require("kpcrew.systems." .. kh_acf_icao .. ".sysRadios")	


-- ============ aircraft generic joystick/key commands

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

create_command("kp/xsp/systems/all_baro_down","All baro down","sysGeneral.baroGroup:actuate(cmdDown)","","")
create_command("kp/xsp/systems/all_baro_up","All baro up","sysGeneral.baroGroup:actuate(cmdUp)","","")

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
create_command("kp/xsp/engines/reverse_on", "Reverse Thrust Toggle", "sysEngines.reverseToggle:actuate(modeOn)", "", "")
create_command("kp/xsp/engines/reverse_off", "Reverse Thrust Toggle", "sysEngines.reverseToggle:actuate(modeOff)", "", "")
create_command("kp/xsp/engines/reverse_tgl", "Reverse Thrust Toggle", "sysEngines.reverseToggle:actuate(modeToggle)", "", "")

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

-- N1 Boeing
create_command("kp/xsp/autopilot/n1_tgl", "Toggle N1", "sysMCP.n1Switch:actuate(modeToggle)","","")

-- LVL CHG Boeing
create_command("kp/xsp/autopilot/lvlchg_tgl", "Toggle Level Change", "sysMCP.lvlchgSwitch:actuate(modeToggle)","","")

-- LNAV VNAV Boeing
create_command("kp/xsp/autopilot/vnav_tgl", "Toggle VNAV", "sysMCP.vnavSwitch:actuate(modeToggle)","","")
create_command("kp/xsp/autopilot/lnav_tgl", "Toggle LNAV", "sysMCP.lnavSwitch:actuate(modeToggle)","","")

create_command("kp/xsp/autopilot/crs1_dn", "CRS 1 decrease", "sysMCP.crs1Selector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/crs1_up", "CRS 1 increase", "sysMCP.crs1Selector:actuate(cmdUp)","","")
create_command("kp/xsp/autopilot/crs2_dn", "CRS 2 decrease", "sysMCP.crs2Selector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/crs2_up", "CRS 2 increase", "sysMCP.crs2Selector:actuate(cmdUp)","","")

create_command("kp/xsp/autopilot/spd_dn", "Speed decrease", "sysMCP.iasSelector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/spd_up", "Speed increase", "sysMCP.iasSelector:actuate(cmdUp)","","")

create_command("kp/xsp/autopilot/hdg_dn", "Heading decrease", "sysMCP.hdgSelector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/hdg_up", "Heading increase", "sysMCP.hdgSelector:actuate(cmdUp)","","")

create_command("kp/xsp/autopilot/alt_dn", "Altitude decrease", "sysMCP.altSelector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/alt_up", "Altitude increase", "sysMCP.altSelector:actuate(cmdUp)","","")

create_command("kp/xsp/autopilot/vsp_dn", "Vertical Speed decrease", "sysMCP.vspSelector:actuate(cmdDown)","","")
create_command("kp/xsp/autopilot/vsp_up", "Vertical Speed increase", "sysMCP.vspSelector:actuate(cmdUp)","","")

-- --------------- EFIS all captain side

create_command("kp/xsp/efis/map_zoom_dn", "EFIS Map Zoom In", "sysEFIS.mapZoomPilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/map_zoom_up", "EFIS Map Zoom Out", "sysEFIS.mapZoomPilot:actuate(cmdUp)","","")

create_command("kp/xsp/efis/map_mode_dn", "EFIS Map Mode Left", "sysEFIS.mapModePilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/map_mode_up", "EFIS Map Mode Right", "sysEFIS.mapModePilot:actuate(cmdUp)","","")

-- CTR Boeing
create_command("kp/xsp/efis/ctr_toggle", "EFIS CTR Toggle", "sysEFIS.ctrPilot:actuate(modeToggle)","","")

create_command("kp/xsp/efis/tfc_toggle", "EFIS TFC Toggle", "sysEFIS.tfcPilot:actuate(modeToggle)","","")

create_command("kp/xsp/efis/wxr_toggle", "EFIS Weather Toggle", "sysEFIS.wxrPilot:actuate(modeToggle)","","")
-- STA Boeing / VOR DFLT
create_command("kp/xsp/efis/sta_toggle", "EFIS STA Toggle", "sysEFIS.staPilot:actuate(modeToggle)","","")
-- WPT / FIX
create_command("kp/xsp/efis/wpt_toggle", "EFIS WPT Toggle", "sysEFIS.wptPilot:actuate(modeToggle)","","")

create_command("kp/xsp/efis/apt_toggle", "EFIS Airport Toggle", "sysEFIS.arptPilot:actuate(modeToggle)","","")
-- DATA Boeing
create_command("kp/xsp/efis/dat_toggle", "EFIS DATA Toggle", "sysEFIS.dataPilot:actuate(modeToggle)","","")
-- POS Boeing / NAV DFLT
create_command("kp/xsp/efis/pos_toggle", "EFIS POS Toggle", "sysEFIS.posPilot:actuate(modeToggle)","","")

create_command("kp/xsp/efis/ter_toggle", "EFIS Terrain Toggle", "sysEFIS.terrPilot:actuate(modeToggle)","","")
-- FPV Boeing
create_command("kp/xsp/efis/fpv_toggle", "EFIS FPV Toggle", "sysEFIS.fpvPilot:actuate(modeToggle)","","")
-- MTRS Boeing
create_command("kp/xsp/efis/mtr_toggle", "EFIS FPV Toggle", "sysEFIS.mtrsPilot:actuate(modeToggle)","","")

-- MINS type Boeing RADIO/BARO
create_command("kp/xsp/efis/mins_type_dn", "EFIS Mins Type Knob Left", "sysEFIS.minsTypePilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/mins_type_up", "EFIS Mins Type Knob Right", "sysEFIS.minsTypePilot:actuate(cmdUp)","","")
-- MINS RESET/ON OFF Boeing
create_command("kp/xsp/efis/mins_toggle", "EFIS Minimums Reset", "sysEFIS.minsResetPilot:actuate(modeToggle)","","")
-- MINS SET or DH/DA
create_command("kp/xsp/efis/mins_dn", "EFIS Minimums Down", "sysEFIS.minsPilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/mins_up", "EFIS Minimums Up", "sysEFIS.minsPilot:actuate(cmdUp)","","")

-- VOR/ADF 1
create_command("kp/xsp/efis/voradf_1_dn", "EFIS VORADF1 Down/Left", "sysEFIS.voradf1Pilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/voradf_1_up", "EFIS VORADF1 Up/Right", "sysEFIS.voradf1Pilot:actuate(cmdUp)","","")
-- VOR/ADF 2
create_command("kp/xsp/efis/voradf_2_dn", "EFIS VORADF2 Down/Left", "sysEFIS.voradf2Pilot:actuate(cmdDown)","","")
create_command("kp/xsp/efis/voradf_2_up", "EFIS VORADF2 Up/Right", "sysEFIS.voradf2Pilot:actuate(cmdUp)","","")

-- comment out if you do not need this
require("kpcrew.hardware.honeycombBravo")
require("kpcrew.hardware.honeycombAlpha")

--------------- Instantiate Datarefs for general annunciators ----------- 

xsp_gear_status	= create_dataref_table("kp/xsp/systems/gear_status", "Int")
xsp_gear_status[0] = 0

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

	-- General Gear Status In=0 Out=1
	xsp_gear_status[0] = sysGeneral.gearLightsAnc:getStatus()

	-- FLIGHT DIRECTOR annunciator
	xsp_mcp_fdir[0] = sysMCP.fdirAnc:getStatus()
	
	---------- Lights -----------
	
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

kh_scrn_width = get("sim/graphics/view/window_width")
kh_scrn_height = get("sim/graphics/view/window_height")

-- ===== Aircraft specific MCP Window
kh_mcp_wnd = nil
function kh_init_mcp_window()
	if kh_mcp_wnd == 0 or kh_mcp_wnd == nil then	
		kh_mcp_wnd = float_wnd_create(25, 46, 2, true)
		float_wnd_set_title(kh_mcp_wnd, "")
		float_wnd_set_position(kh_mcp_wnd, 0, kh_scrn_height - 46)
		float_wnd_set_imgui_builder(kh_mcp_wnd, "kh_mcp_builder")
		float_wnd_set_onclose(kh_mcp_wnd, "kh_close_mcp_window")
	end
end

kh_mcp_wnd_state = 0

function kh_mcp_builder()
	if get("sim/graphics/view/window_width") ~= kh_scrn_width or get("sim/graphics/view/window_height") ~= kh_scrn_height then
		kh_mcp_wnd_state = -1
		kh_light_wnd_state = -1
		kh_radio_wnd_state = -1
		kh_efis_wnd_state = -1
		kh_scrn_width = get("sim/graphics/view/window_width")
		kh_scrn_height = get("sim/graphics/view/window_height")
	end
	sysMCP:render(46,46)
end

function kh_close_mcp_window()
	kh_mcp_wnd = nil
end

kh_init_mcp_window() -- always show this window

-- ===== Aircraft specific Light Window
kh_light_wnd = nil
function kh_init_light_window()
	if kh_light_wnd == 0 or kh_light_wnd == nil then	
		kh_light_wnd = float_wnd_create(25, 46, 2, true)
		float_wnd_set_title(kh_light_wnd, "")
		float_wnd_set_position(kh_light_wnd, 0, kh_scrn_height - 92)
		float_wnd_set_imgui_builder(kh_light_wnd, "kh_light_builder")
		float_wnd_set_onclose(kh_light_wnd, "kh_close_light_window")
	end
end

kh_light_wnd_state = 0

function kh_light_builder()
	if get("sim/graphics/view/window_width") ~= kh_scrn_width or get("sim/graphics/view/window_height") ~= kh_scrn_height then
		kh_mcp_wnd_state = -1
		kh_light_wnd_state = -1
		kh_radio_wnd_state = -1
		kh_efis_wnd_state = -1
		kh_scrn_width = get("sim/graphics/view/window_width")
		kh_scrn_height = get("sim/graphics/view/window_height")
	end
	sysLights:render(92,46)
end

function kh_close_light_window()
	kh_light_wnd = nil
end

kh_init_light_window() -- always show this window

-- ===== Aircraft specific Radio Window
kh_radio_wnd = nil
function kh_init_radio_window()
	if kh_radio_wnd == 0 or kh_radio_wnd == nil then	
		kh_radio_wnd = float_wnd_create(25, 80, 2, true)
		float_wnd_set_title(kh_radio_wnd, "")
		float_wnd_set_position(kh_radio_wnd, 0, kh_scrn_height - 170)
		float_wnd_set_imgui_builder(kh_radio_wnd, "kh_radio_builder")
		float_wnd_set_onclose(kh_radio_wnd, "kh_close_radio_window")
	end
end

kh_radio_wnd_state = 0

function kh_radio_builder()
	if get("sim/graphics/view/window_width") ~= kh_scrn_width or get("sim/graphics/view/window_height") ~= kh_scrn_height then
		kh_mcp_wnd_state = -1
		kh_light_wnd_state = -1
		kh_radio_wnd_state = -1
		kh_efis_wnd_state = -1
		kh_scrn_width = get("sim/graphics/view/window_width")
		kh_scrn_height = get("sim/graphics/view/window_height")
	end
	sysRadios:render(170,80)
end

function kh_close_radio_window()
	kh_radio_wnd = nil
end

kh_init_radio_window() -- always show this window

-- ===== Aircraft specific EFIS Window
kh_efis_wnd = nil
function kh_init_efis_window()
	if kh_efis_wnd == 0 or kh_efis_wnd == nil then	
		kh_efis_wnd = float_wnd_create(25, 46, 2, true)
		float_wnd_set_title(kh_efis_wnd, "")
		float_wnd_set_position(kh_efis_wnd, 0, kh_scrn_height - 212)
		float_wnd_set_imgui_builder(kh_efis_wnd, "kh_efis_builder")
		float_wnd_set_onclose(kh_efis_wnd, "kh_close_efis_window")
	end
end

kh_efis_wnd_state = 0

function kh_efis_builder()
	if get("sim/graphics/view/window_width") ~= kh_scrn_width or get("sim/graphics/view/window_height") ~= kh_scrn_height then
		kh_mcp_wnd_state = -1
		kh_light_wnd_state = -1
		kh_radio_wnd_state = -1
		kh_efis_wnd_state = -1
		kh_scrn_width = get("sim/graphics/view/window_width")
		kh_scrn_height = get("sim/graphics/view/window_height")
	end
	sysEFIS:render(212,46)
end

function kh_close_efis_window()
	kh_efis_wnd = nil
end

kh_init_efis_window() -- always show this window

-- regularly update the drefs for annunciators and lights 
do_often("xsp_set_light_drefs()")
