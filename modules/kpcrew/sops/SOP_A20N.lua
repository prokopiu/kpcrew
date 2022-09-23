-- Standard Operating Procedure for JarDesign A20N

-- @classmod SOP_B738
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_A20N = {
}

-- SOP related imports
local SOP					= require "kpcrew.sops.SOP"

local Flow					= require "kpcrew.Flow"
local FlowItem 				= require "kpcrew.FlowItem"

local Checklist 			= require "kpcrew.checklists.Checklist"
local ChecklistItem 		= require "kpcrew.checklists.ChecklistItem"
local SimpleChecklistItem 	= require "kpcrew.checklists.SimpleChecklistItem"
local IndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"
local ManualChecklistItem 	= require "kpcrew.checklists.ManualChecklistItem"

local Procedure 			= require "kpcrew.procedures.Procedure"
local ProcedureItem 		= require "kpcrew.procedures.ProcedureItem"
local SimpleProcedureItem 	= require "kpcrew.procedures.SimpleProcedureItem"
local IndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

sysLights 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	
sysFMC 						= require("kpcrew.systems." .. kc_acf_icao .. ".sysFMC")	
sysRadios					= require("kpcrew.systems." .. kc_acf_icao .. ".sysRadios")	

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = kcSOP:new("JarDesign A20N SOP")

-- ============ PRELIMINARY COCKPIT PREP (PM) ============
-- ==== AIRCRAFT SETUP
-- ENGINE MASTERS 1 & 2.........................OFF   (PM)
-- ENGINE MODE SELECTOR........................NORM   (PM)
-- WEATHER RADAR................................OFF   (PM)
-- LANDING GEAR LEVER..........................DOWN   (PM)
-- BOTH WIPER SELECTORS.........................OFF   (PM)

-- ==== BATTERY CHECK & EXTERNAL POWER
-- BAT 1 / BAT 2............CHECK BOTH ABOVE 25.5 V   (PM)
-- BAT 1 / BAT 2.................................ON   (PM)

-- ==== Activate External Power
-- EXT POWER if available........................ON   (PM)
--   Use Ground Handling CDU menu to turn EXT Power on         

-- ==== Activate APU 
-- APU FIRE..........................IN and GUARDED   (PM)
-- APU FIRE TEST.........................CHECK/TEST   (PM)
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)

-- ==== LIGHT UP
-- COCKPIT LIGHTS...........................AS RQRD   (PM) 

-- ==== AIRCRAFT ACCEPTANCE
-- ECAM RCL...............................PRESS 3 S   (PM)
--   Recalls warnings cleared during last flight
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ==== ECAM SD PAGES
-- ENG SD PAGE.........................OIL QUANTITY   (PM)
--   NEO=10.6qt+0.45qt/h
-- HYD SD PAGE..........CHECK RESERVOIR FLUID LEVEL   (PM)
-- DOOR SD PAGE..................CHECK OXY PRESSURE   (PM)

-- ==== FCTL
-- FLAPS.............................CHECK POSITION   (PM)
--   ECAM flaps position agrees with handle position
-- SPEEDBRAKE LEVER......CHECK RETRACTED & DISARMED   (PM)

-- ==== BRAKES
-- PARKING BRAKE.................................ON   (PM)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND   (PM)
--   (if not use Y elec pump)
-- PARKING BRAKE INDICATOR....................CHECK   (PM)
-- Alternate Brake – Check:
--   YELLOW ELEC PUMP...........................OFF   (PM) 
--   CHOCKS......................................ON   (PM)
--   PARKING BRAKES.............................OFF   (PM)
--     Brake Pedals – Press to Check Pressure on 
--     Brake Pressure Indicator
--     Brake Pedals Release – Parking Brakes ON
--   PARKING BRAKES..............................ON   (PM)
  
-- ==== REST
-- EMERGENCY EQUIPMENT........................CHECK   (PM)
-- CB PANELS..................................CHECK   (PM)
-- RAIN REPELLENT.............................CHECK   (PM)
-- CIRCUIT BREAKERS..........................ALL IN   (PM)
-- GEAR PINS & COVERS............ONBOARD AND STOWED   (PM)
-- =======================================================

local prelCockpitPrep = kcProcedure:new("PRELIMINARY COCKPIT PREP","performing Preliminary Cockpit Preparation","I am going for the walk around")
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("All paper work on board and checked"))
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("M E L and Technical Logbook checked"))


-- ============== COCKPIT PREPARATION (PF) ===============
-- == Overhead Left Column
-- CREW OXY SUPPLY...............................ON  
-- RCRD GND CTL..................................ON  
-- CVR TEST.....................PRESS & HOLD 3 SECS  
-- GPWS.............................NO WHITE LIGHTS
-- EVAC SWITCH..........................CAPT & PURS  
-- ADIRS L,R,C..................................NAV
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.

-- == Overhead Center Column
-- ==== Lights panel
-- SEAT BELTS...................................OFF
-- NO SMOKING...............................ON/AUTO
-- EMERGENCY EXIT LIGHT.........................ARM
-- ANNUNCIATOR LIGHT...........................TEST

-- ==== ANTI-ICE & PRESSURIZATION
-- WING-ANTI-ICE................................OFF
-- ENGINE ANTI-ICE..............................OFF
-- PROBE/WINDOW HEAT.....................CHECK AUTO
-- CABIN PRESSURE LDG ELEV.....................AUTO
--   ECAM PRESS page check LDG ELEV being AUTO

-- ==== AIR COND Panel
-- APU BLEED............................AS REQUIRED
-- CROSSBLEED..................................AUTO
-- PACK FLOW SELECTOR.......................AS RQRD

-- ==== Electrical Panel
-- NO WHITE LIGHTS..........................CHECKED
-- BAT 1 PB & BAT 2 PB..................OFF then ON
--   This initiates a charging cycle of the batts.
--   10 s after setting all BAT PB ON, check on the
--   ECAM ELEC page that the current charge of the
--   battery is below 60 A, and is decreasing.
-- 
-- ==== FUEL Panel
-- FUEL PUMP SWITCHES........................ALL ON
-- FUEL MODE SELECTOR..........................AUTO
--
-- ==== FIRE Panel
-- ENG 1 and 2 FIRE TEST.............PRESS and HOLD
--   (check for 7 items)
-- APU FIRE..........................IN and GUARDED
-- APU FIRE TEST..............................PRESS
--
-- == Overhead Left Column
-- ==== CARGO Panel
-- AFT CARGO HEAT.........................MID RANGE
-- CARGO SMOKE TEST............................PUSH
-- ====
-- THIRD AUDIO CONTROL PANEL.......PA knob – Recept
--   - This allows cabin attendant announcements to
--     be recorded on the CVR.
--   - Set volume at or above medium range.

-- == Central Panel
-- STANDBY INSTR (ISIS).......................CHECK
--   Indications normal – no flags / Set QNH
-- CLOCK..................................CHECK/SET
--   Check time is UTC, switch to GPS
-- A/SKID & N/W STRG SWITCH......................ON

-- == Pedestal
-- RMP (Radio Management Panel)............ON & SET
-- ACP (Audio Control Panel)............AS REQUIRED
-- WEATHER RADAR................................OFF
-- PWS..........................................OFF
-- COCKPIT DOOR..............................NORMAL
-- SWITCHING PANEL...........................NORMAL
-- THRUST LEVERS.........................CHECK IDLE
-- SPEED BRAKE LEVER...............RETRACT & DISARM
-- PARK BRK HANDLE.........................CHECK ON
-- GRAVITY GEAR EXTN.........................STOWED
-- RMP2 (Radio Management Panel)...........ON & SET
-- ACP2 (Audio Control Panel)...........AS REQUIRED
-- ==== ATC / TCAS
--   XPDR CODE.................................2000
--   SYSTEM 1...................................SET
--   XPDR...................................STANDBY
--   ALT REPORTING...............................ON
-- =======================================================

-- FMGC SETUP PROCEDURE


-- =========== FINAL COCKPIT PREPARATION (F/O) ===========
-- ==== EFIS Panel
-- QNH ON EFIS..................................SET (BOTH)
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTORS..............................ON (BOTH)
-- ILS/LS.......................................OFF (BOTH)
-- NAVIGATION DISPLAY MODE & RANGE..............SET (BOTH)
-- ADF/VOR SWITCHES.............................VOR (BOTH)
-- CSTR..........................................ON (BOTH)

-- ==== FCU for Departure
-- FMGC.................................INITIALIZED   (PF)
-- SPD MACH WINDOW...........................DASHED   (PF)
--   100 displayed until Perf page is completed
-- HDG WINDOW................................DASHED   (PF)
-- ALT WINDOW...................INITIAL CLEARED ALT   (PF)
-- V/S WINDOW................................DASHED   (PF)

-- ==== Cockpit
-- OXYGEN MASK.................................TEST (BOTH)
-- LOUDSPEAKERS VOLUME...........................ON (BOTH)
-- SLIDING WINDOWS..................CLOSED & LOCKED (BOTH)
-- PFD & ND BRIGHTNESS......................AS RQRD (BOTH)
--   PFD / ND indications CHECK NORMAL

-- ==== Pedestal
-- RMP (Radio Management Panel)............ON & SET
-- ACP..................................AS REQUIRED
-- TRANSPONDER.................................STBY
-- =======================================================


-- FINAL COCKPI PREPARATION 20 min prior to pushback


-- ==== Overhead Left Column
-- ==== FCU Panel
-- QNH ON EFIS..................................SET
--   Check altitude is same as airport elevation
-- FLIGHT DIRECTOR...............................ON
-- ILS/LS...................................AS RQRD
-- EFIS CONTROL PANEL...............SET AS REQUIRED
-- ADF/VOR SWITCH...........................AS RQRD
-- OXYGEN MASK.................................TEST
--   LOUDSPEAKERS................................ON
--   INT reception knob (on ACP).PRESS OUT - ADJUST
--   INT/RAD SWITCH.............................INT
-- ==== Other
-- SLIDING WINDOWS..................CLOSED & LOCKED
-- PFD & ND BRIGHTNESS......................AS RQRD
--   PFD / ND indications CHECK NORMAL
-- EGPWS TERRAIN SWITCH..........................ON
-- ECAM................................PRESS RECALL
--   Check ECAM STATUS display
-- =======================================================




-- STROBE......................................AUTO
-- NAV & LOGO.....................................1
--   (NAV & LOGO LT 2 is used only when 
--    NAV & LOGO LT 1 fails)
--   ON if fuelling completed; OFF if still ongoing
-- LDG ELEV KNOB...............................AUTO
--   LO if pax < A319-138 / A320-141 / A321-168
-- ELEC PB....................................PRESS
--   (on the ECAM Control Panel)
-- VENT PANEL.............................NO WHITES
-- VHF 1............................TRANS / RECEIVE
-- INT KNOB................PRESS OUT / VOLUME CHECK
-- MULTISCAN...................................AUTO
-- GCS.........................................AUTO
-- WXR......................................TILT +5
-- COCKPIT DOOR................................NORM
-- SWITCHING PANEL SELECTORS.............CHECK NORM
-- ENG MASTER SWITCH............................OFF
-- ENG MODE SELECTOR...........................NORM
-- PARK BRK................ACCU PRESS IN GREEN BAND
--   BRAKE PRESS normal (around 2000psi)
-- ALT......................................RPTG ON
-- ATC SYS 1.................................SELECT
-- ATC TILT...................................ABOVE
-- AIRFIELD DATA.............................OBTAIN
-- ACARS....................................STARTED
-- FMGS Data, Init, F-pln, Sec f-pln, Rad nav, Prog


-- COCKPIT PREP – FINAL CHECKS
-- ATC CLEARANCE OBTAIN
-- ATC CODE SET
-- IRS ALIGNMENT CHECK
-- CHARTS PREPARATION COMPLETE
-- FMGS CRITICAL DATA ENTER
-- Init B – Perf
-- APU START (1 MINUTE LOADLESS)
-- DEPARTURE BRIEFING
-- Threats
-- MEL items
-- Notams
-- Weather
-- Dep alternate
-- Taxi - One engine taxi - Runway
-- DATA REF
-- INIT PAGE
-- INIT B
-- F-PLN ref (SID, charts,
-- initial turn, constraints,
-- stop altitude, MSA, trip length and time)
-- RAD NAV
-- PROG PAGE
-- PERF PAGE
-- Climb and cruise speeds
-- FUEL PRED
-- SEC F-PLAN
-- EMERGENCY BRIEFING
-- APU BLEED ON
-- EXT PWR OFF
-- EXT PWR DISCONNECT
-- FUEL PUMPS ON
-- PUSHBACK TUG CALL


-- COCKPIT PREPARATION CHECKLIST (new?)  (PNF)
-- GEAR PINS & COVERS..REMOVED (PF)
-- FUEL QUANTITY .. ___ KG (PF)
--  check FOB & distribution on FUEL SD page
-- SEAT BELT..ON (PF)
-- ADIRS..NAV (PF)
-- BARO REF..____ (BOTH)


-- DEPARTURE BRIEFING

-- MCDU SETUP

local CockpitPrep = kcProcedure:new("COCKPIT PREPARATION (BOTH)","starting cockpit preparation")

local CockpitPrepChkl = kcChecklist:new("COCKPIT PREPARATION CHECKLIST")




-- BEFORE START
-- FOB CHECK (ECAM vs OFP)
-- Check fuel balance
-- FMS PERF TO page PF SELECT
-- FMS F-PLN page PM SELECT

-- BEFORE START CHECKLIST DOWN TO THE LINE
-- PUSHBACK/START UP 
-- CLEARANCE OBTAIN
-- BEACON ON
-- SIGNS SET
-- WINDOWS & DOORS CHECK CLOSED
-- COCKPIT DOOR LOCK
-- THRUST LEVERS IDLE
-- TRANSPONDER XPDR / AUTO
-- BEFORE START CHECKLIST BELOW THE LINE
-- PUSHBACK INITIATE
-- CLOCK TIMER START
-- ENGINES
-- START
-- Eng master switch
-- Start valve opens
-- N2 increase
-- Oil press increase
-- Igniter on
-- Fuel flow
-- N1 & EGT increase
-- Start valve close
-- Idle parameters normal
-- oxygen panel
-- crew supply in auto (light off)
-- vcr test on before engine start - not modelled
-- gpws fault lights (not modelled)
-- ADIRS to NAV and align lights on


-- BEFORE START CHECKLIST TO THE LINE (old)
-- COCKPIT PREP..COMPLETED
-- SIGNS..ON
-- ADIRS .... .. ....... . .. ... . .. . ......... NAV
-- FUEL QUANTITY .. . ....... _KG./BALANCED
-- FMGS . .. . . . .. . . ....... . . . . ..... ... ... SET
-- ALTIMETERS . . . . . . . . . . SET/xxxFT(BOTH)

-- BEFORE START CHECKLIST BELOW THE LINE (old)
-- WINDOWS/DOORS . .. CLOSED/ARMED (BOTH)
-- BEACON . .............. ... .. ... . ...... ON
-- MOBILE PHONE ......... . . . ..... OFF (BOTH)
-- PARKING BRAKE . ...... . . ............ . . ON 

-- BEFORE START CHECKLIST (new?) (PNF)
--   when PB clearance or Start clrnc received and before start pattern finished
-- PARKING BRAKE..ON (PF)
-- T.O. SPEEDS & THRUST.._____ (BOTH)
--  PF V1,VR,V2 & thrust setting FMS PERF
-- BEACON..ON (PF)


-- AFTER START CHECKLIST (new) (PNF)
-- ANTI ICE .. . .. . ... . .. ... . .. . . ... .. AS RQRD
-- PITCH TRIM . . ..... . ... .. ..... . . _% SET
-- RUDDER TRIM .. . . . . . . .... . .. ........ ZERO


-- ECAM STATUS . . . ....... .... ... .. CHECKED (old)

-- TAXI CHECKLIST (new)
-- FLIGHT CONTROLS..CHECKED (BOTH)
-- FLAP SETTINGS..CONF ___ (BOTH)
-- RADAR & PRED W/S..ON & AUTO
-- ENG MODE..IGNITION|NORM (on A320)
-- START SEL..IGNITION|NORM (on A340)
-- ECAM MEMO..T.O NO BLUE
--  list modes

-- BEFORE TAKEOFF CHECKLIST TO THE LINE (old)
-- FLT CTL. ... . ... .. ..... .... CHECKED (BOTH)
-- BRIEFING . .. ..... . .. . ....... .. CONFIRMED
-- FLAP SETTING ..... .. ..... . . CONF_(BOTH)
-- FMA & TAKE OFF DATA ... . . . . . .... READ (PF)
-- TRANSPONDER ... . . ...... . .. ~~~~~-~~ -~~
-- ECAM MEMO . ...... . .. ... TAKEOFF NO BLUE
-- EFB ..... .. .. .... ... .. .... AS RQRD (BOTH)

-- BEFORE TAKEOFF CHECKLIST BELOW THE LINE (old)
-- CABIN . ... . .... . . . . SECURED FOR TAKEOFF
-- ENG MOOE SEL . . .... . .. . . .... . ... AS RQRD
-- TCAS . ... . ...... . . .... .. ... . ....... . TNRA
-- PACKS . ........ . ... . . .. ...... .... AS RQRD
-- ANTI ICE .......... . . . .. .... . .. . . . AS RQRD

-- LINE-UP CHECKLIST (new)
-- T.O RWY..___(BOTH)
-- TCAS..TA/RA
-- PACK 1&2..____ AS REQUIRED



-- APPROACH CHECKLIST (old)
-- MINIMUM . . . . .... . . . ....... _ SET (BOTH)
-- ENG MODE SEL. . . .. ... .. .. . . ..... AS RQR0
-- EFB . .......... ..... .. . ... AS RQRD (BOTH)
-- ENG MODE..IGNITION|NORM (on A320)
-- START SEL..IGNITION|NORM (on A340)

-- APPROACH CHECKLIST (new)
-- BARO REF..___ (BOTH)
-- SEAT BELT..ON
-- MINIMUM..____
-- AUTO BRAKE..____


-- LANDING CHECKLIST (old)
-- CABIN . . . . . . ... ... . . SECURED FOR LANDING
-- AUTOTHRUST . .. . .. .. . .. . ... .. . SPEED/OFF
-- GO-AROUND ALT . . ... .. ....... __ FT SET
-- ECAM MEMO ... . ..... . .. . LANDING NO BLUE
-- . LOG DOWN
-- . SIGNS ON
-- .SPLRSARM
-- . FLAPS SET

-- LANDING CHECKLIST (new)
-- ECAM MEMO..LDG NO BLUE
 -- list modes
-- CABIN..READY

-- AFTER LANDING CHECKLIST (new)
-- RADAR&PRED W/S..OFF


-- PARKING FLOWS
-- APU BLEED ....... .. ....... . ..... AS RQRD
-- Y ELEC PUMP . .. . .. .. ........... . ..... OFF
-- SEAT BELTS . . ... ... ........... . . . . .. .. OFF
-- EXT LT ... . . . . .. .. . . . .. .... . . . ... AS RQRD
-- PARK BRK and CHOCKS ......... ... AS RQRD
-- MOBILE PHONE .. ........... . . . ....... . . ON
-- TRANSPONDER. .. . ... ... . . . . STANDBY 2000
-- RADAR/PWS . . . .. . . . . ... . ..... .. . . .. . . OFF
-- Consider HEAVY RAIN
-- EXTRACT .... . . . . . ... .... .. . .. . ..... OVRD


-- PARKING CHECKLIST (new)
-- triggered by SEAT BELTS OFF
-- PARK BRK OR CHOCKS..SET
-- ENGINES .. .... .. . ... . . ...... .. . ... ... OFF
-- WING LIGHTS..OFF
-- FUEL PUMPS..OFF


-- SECURING THE AIRCRAFT CHECKLIST (old)
-- EFB . . ....... .. . . ..... . . .. . .. ... BOTH OFF
-- FUEL PUMPS .. ....... ..... . ....... . ... OFF
-- ADIRS . . ............. .. . .. . . ... .. . . ... OFF
-- OX'f GEN .. . . . ... ... . . ... .. .. .... . . . .. . OFF
-- APU BLEED . .. .. .... ... .. ... . .. ..... . . OFF
-- EMER EXIT LT . . . ... . .. . ... .. . ..... ... . OFF
-- PARKING BRAKE . .. .. ... . .... . . ... . ..... ON
-- NO SMOKING ... . ... ..... .. . ..... ...... OFF
-- APUAND BAT .. . ...... . ... . . ..... .... . OFF

-- SECURING THE AIRCRAFT CHECKLIST (new)
-- OXYGEN .. . . . ... ... . . ... .. .. .... . . . .. . OFF
-- EMER EXIT LIGHT . . . ... . .. . ... .. . ..... ... . OFF
-- EFB . . ....... .. . . ..... . . .. . .. ... OFF
-- BATTERIES..OFF



-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(prelCockpitPrep)
activeSOP:addProcedure(cockpitPrep)

function getActiveSOP()
	return activeSOP
end

return SOP_A20N
