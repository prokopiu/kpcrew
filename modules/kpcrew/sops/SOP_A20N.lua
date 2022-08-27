local SOP_A20N = {
}

-- SOP related imports
kcSOP = require "kpcrew.sops.SOP"

kcFlow = require "kpcrew.Flow"
kcFlowItem = require ("kpcrew.FlowItem")

kcChecklist = require "kpcrew.checklists.Checklist"
kcChecklistItem = require "kpcrew.checklists.ChecklistItem"
kcSimpleChecklistItem = require "kpcrew.checklists.SimpleChecklistItem"
kcIndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"
kcManualChecklistItem = require "kpcrew.checklists.ManualChecklistItem"

kcProcedure = require "kpcrew.procedures.Procedure"
kcProcedureItem = require "kpcrew.procedures.ProcedureItem"
kcSimpleProcedureItem = require "kpcrew.procedures.SimpleProcedureItem"
kcIndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

-- Systems related imports

-- classes for systems switches 
TwoStateDrefSwitch 		= require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch 		= require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
TwoStateToggleSwitch 	= require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch 				= require "kpcrew.systems.InopSwitch"

SwitchGroup  			= require "kpcrew.systems.SwitchGroup"

SimpleAnnunciator 		= require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator 		= require "kpcrew.systems.CustomAnnunciator"

sysLights 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysLights")
sysGeneral 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysGeneral")	
sysControls 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysControls")	
sysEngines 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEngines")	
sysElectric 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysElectric")	
sysHydraulic 			= require("kpcrew.systems." .. kc_acf_icao .. ".sysHydraulic")	
sysFuel 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysFuel")	
sysAir 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysAir")	
sysAice 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysAice")	
sysMCP 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysMCP")	
sysEFIS 				= require("kpcrew.systems." .. kc_acf_icao .. ".sysEFIS")	
sysFMC 					= require("kpcrew.systems." .. kc_acf_icao .. ".sysFMC")	

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

-- Set up SOP =========================================================================

activeSOP = kcSOP:new("JarDesign A20N SOP")

-- ============= PRELIMINARY COCKPIT PREP ===============
-- ==== AIRCRAFT SETUP
-- WEATHER RADAR................................OFF (F/O)
--   PWS........................................OFF (F/O)
--   GAIN KNOB.............................AUTO/CAL (F/O)
--   MODE SELECTOR......................AS REQUIRED (F/O)
-- ENGINE MASTERS 1 & 2.........................OFF (F/O)
-- ENGINE MODE SELECTOR........................NORM (F/O)
-- LANDING GEAR LEVER..........................DOWN (F/O)
-- BOTH WIPER SELECTORS.........................OFF (F/O)
-- ==== BATTERY CHECK & EXTERNAL POWER
-- BAT 1 / BAT 2............CHECK BOTH ABOVE 25.5 V (F/O)
-- BAT 1 / BAT 2.................................ON (F/O)
-- ==== Activate External Power
-- EXT POWER if available........................ON (F/O)
--   Use Ground Handling CDU menu to turn EXT Power on         
-- ==== Activate APU 
-- APU FIRE..........................IN and GUARDED (F/O)
-- APU FIRE TEST..............................PRESS (F/O)
-- APU MASTER PB..............................PRESS (F/O)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS (F/O)
-- APU BLEED.....................................ON (F/O)
-- ==== ADIRS
-- ADIRS L,R,C..................................NAV (F/O)
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.
-- ==== LIGHT UP
-- COCKPIT LIGHTS...........................AS RQRD (F/O) 
-- ==== AIRCRAFT ACCEPTANCE
-- ECAM RCL...............................PRESS 3 S (F/O)
--   Recalls warnings cleared during last flight
-- All paper work on board and checked
-- M E L and Technical Logbook checked
-- ==== ECAM SD PAGES
-- ENG SD PAGE.........................OIL QUANTITY (F/O)
--   NEO=10.6qt+0.45qt/h
-- HYD SD PAGE..........CHECK RESERVOIR FLUID LEVEL (F/O)
-- DOOR SD PAGE..................CHECK OXY PRESSURE (F/O)
-- ==== FCTL
-- FLAPS.............................CHECK POSITION (F/O)
--   ECAM flaps position agrees with handle position
-- SPEEDBRAKE LEVER......CHECK RETRACTED & DISARMED (F/O)
-- ==== BRAKES
-- PARKING BRAKE.................................ON (F/O)
-- ACCU PRESS INDICATOR............CHECK GREEN BAND (F/O)
--   (if not use Y elec pump)
-- PARKING BRAKE INDICATOR....................CHECK (F/O)
-- Alternate Brake – Check:
-- YELLOW ELEC PUMP.............................OFF (F/O) 
-- CHOCKS........................................ON (F/O)
-- PARKING BRAKES...............................OFF (F/O)
--   Brake Pedals – Press to Check Pressure on 
--   Brake Pressure Indicator
--   Brake Pedals Release – Parking Brakes ON
-- PARKING BRAKES................................ON (F/O)
-- EMERGENCY EQUIPMENT........................CHECK (F/O)
-- CB PANELS..................................CHECK (F/O)
-- RAIN REPELLENT.............................CHECK (F/O)
-- CIRCUIT BREAKERS..........................ALL IN (F/O)
-- GEAR PINS & COVERS............ONBOARD and STOWED (F/O)


local prelCockpitPrep = kcProcedure:new("PRELIMINARY COCKPIT PREP","performing Preliminary Cockpit Preparation")
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("All paper work on board and checked"))
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("M E L and Technical Logbook checked"))


-- ================ COCKPIT PREPARATION =================
-- CREW OXY SUPPLY...............................ON
-- RCRD GND CTL..................................ON
-- CVR TEST.....................PRESS & HOLD 3 SECS
-- EVAC SWITCH..........................CAPT & PURS
-- STROBE......................................AUTO
-- NAV & LOGO.....................................1
--   (NAV & LOGO LT 2 is used only when 
--    NAV & LOGO LT 1 fails)
-- SEAT BELTS...............................AS RQRD
--   ON if fuelling completed; OFF if still ongoing
-- NO SMOKING..................................AUTO
-- EMERGENCY EXIT...............................ARM
-- PROBE/WINDOW HEAT.....................CHECK AUTO
-- LDG ELEV KNOB...............................AUTO
-- PACK FLOW SELECTOR.......................AS RQRD
--   LO if pax < A319-138 / A320-141 / A321-168
-- ELEC PB....................................PRESS
--   (on the ECAM Control Panel)
-- BAT 1 PB & BAT 2 PB..................OFF then ON
--   This initiates a charging cycle of the batts.
--   10 s after setting all BAT PB ON, check on the
--   ELEC SD page that the current charge of the
--   battery is below 60 A, and is decreasing.
-- ENG 1 and 2 FIRE TEST.............PRESS and HOLD
--   (check for 7 items)
-- AUDIO SWITCHING SELECTOR....................NORM
-- VENT PANEL.............................NO WHITES
-- THIRD AUDIO CONTROL PANEL.......PA knob – Recept
--   - This allows cabin attendant announcements to
--     be recorded on the CVR.
--   - Set volume at or above medium range.
-- MAINTENANCE PANEL......................NO WHITES
-- STANDBY INSTR..............................CHECK
--   Indications normal – no flags / Set QNH
-- CLOCK..................................CHECK/SET
--   Check time is UTC, switch to GPS
-- A/SKID & N/W STRG SWITCH......................ON
-- VHF 1............................TRANS / RECEIVE
-- INT KNOB................PRESS OUT / VOLUME CHECK
-- MULTISCAN...................................AUTO
-- GCS.........................................AUTO
-- WXR......................................TILT +5
-- COCKPIT DOOR................................NORM
-- SWITCHING PANEL SELECTORS.............CHECK NORM
-- THRUST LEVER................................IDLE
-- ENG MASTER SWITCH............................OFF
-- ENG MODE SELECTOR...........................NORM
-- PARK BRK................ACCU PRESS IN GREEN BAND
--   BRAKE PRESS normal (around 2000psi)
-- PARK BRK HANDLE.........................CHECK ON
-- GRAVITY GEAR EXTN.........................STOWED
-- TRANSPONDER.................................STBY
-- ALT......................................RPTG ON
-- ATC SYS 1.................................SELECT
-- ATC TILT...................................ABOVE
-- RMP (Radio Management Panel)............ON & SET
-- AIRFIELD DATA.............................OBTAIN
-- ACARS....................................STARTED
-- FMGS Data, Init, F-pln, Sec f-pln, Rad nav, Prog
-- QNH ON EFIS..................................SET
--   Check altitude is same as airport elevation
-- FD......................................CHECK ON
-- LS.......................................AS RQRD
-- CSTR..........................................ON
-- ND MODE & RANGE..........................AS RQRD
-- ADF/VOR SWITCH...........................AS RQRD
-- SPD MACH WINDOW...........................DASHED
--   100 displayed until Perf page is completed
-- HDG WINDOW................................DASHED
-- ALT WINDOW...................INITIAL CLEARED ALT
-- OXYGEN MASK.................................TEST
-- LOUDSPEAKERS..................................ON
-- INT reception knob (on ACP)...PRESS OUT - ADJUST
-- INT/RAD SWITCH...............................INT
-- PFD & ND BRIGHTNESS......................AS RQRD
--   PFD / ND indications CHECK NORMAL
-- ECAM PRESS PB..............................PRESS
--   check LDG ELEV AUTO
-- ECAM STS PB................................PRESS
--   CHECK INOP SYS

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

local BeforeStartProc = kcProcedure:new("BEFORE START","before start procedure")

local BeforeStartChecklist = kcChecklist:new("BEFORE START CHECKLIST")

-- oxygen panel
-- crew supply in auto (light off)
-- vcr test on before engine start - not modelled
-- gpws fault lights (not modelled)
-- ADIRS to NAV and align lights on


-- BEFORE START CHECKLIST TO THE LINE
-- COCKPIT PREP..COMPLETED
-- SIGNS..ON
-- ADIRS .... .. ....... . .. ... . .. . ......... NAV
-- FUEL QUANTITY .. . ....... _KG./BALANCED
-- FMGS . .. . . . .. . . ....... . . . . ..... ... ... SET
-- ALTIMETERS . . . . . . . . . . SET/xxxFT(BOTH)

-- BEFORE START CHECKLIST BELOW THE LINE
-- WINDOWS/DOORS . .. CLOSED/ARMED (BOTH)
-- BEACON . .............. ... .. ... . ...... ON
-- MOBILE PHONE ......... . . . ..... OFF (BOTH)
-- PARKING BRAKE . ...... . . ............ . . ON 

-- AFTER START CHECKLIST
-- ANTI ICE .. . .. . ... . .. ... . .. . . ... .. AS RQRD
-- ECAM STATUS . . . ....... .... ... .. CHECKED
-- PITCH TRIM . . ..... . ... .. ..... . . _% SET
-- RUDDER TRIM .. . . . . . . .... . .. ........ ZERO

-- BEFORE TAKEOFF CHECKLIST TO THE LINE
-- FLT CTL. ... . ... .. ..... .... CHECKED (BOTH)
-- BRIEFING . .. ..... . .. . ....... .. CONFIRMED
-- FLAP SETTING ..... .. ..... . . CONF_(BOTH)
-- FMA & TAKE OFF DATA ... . . . . . .... READ (PF)
-- TRANSPONDER ... . . ...... . .. ~~~~~-~~ -~~
-- ECAM MEMO . ...... . .. ... TAKEOFF NO BLUE
-- EFB ..... .. .. .... ... .. .... AS RQRD (BOTH)

-- BEFORE TAKEOFF CHECKLIST BELOW THE LINE
-- CABIN . ... . .... . . . . SECURED FOR TAKEOFF
-- ENG MOOE SEL . . .... . .. . . .... . ... AS RQRD
-- TCAS . ... . ...... . . .... .. ... . ....... . TNRA
-- PACKS . ........ . ... . . .. ...... .... AS RQRD
-- ANTI ICE .......... . . . .. .... . .. . . . AS RQRD

-- APPROACH CHECKLIST
-- MINIMUM . . . . .... . . . ....... _ SET (BOTH)
-- ENG MODE SEL. . . .. ... .. .. . . ..... AS RQR0
-- EFB . .......... ..... .. . ... AS RQRD (BOTH)

-- LANDING CHECKLIST
-- CABIN . . . . . . ... ... . . SECURED FOR LANDING
-- AUTOTHRUST . .. . .. .. . .. . ... .. . SPEED/OFF
-- GO-AROUND ALT . . ... .. ....... __ FT SET
-- ECAM MEMO ... . ..... . .. . LANDING NO BLUE
-- . LOG DOWN
-- . SIGNS ON
-- .SPLRSARM
-- . FLAPS SET

-- PARKING FLOWS
-- APU BLEED ....... .. ....... . ..... AS RQRD
-- Y ELEC PUMP . .. . .. .. ........... . ..... OFF
-- ENGINES .. .... .. . ... . . ...... .. . ... ... OFF
-- SEAT BELTS . . ... ... ........... . . . . .. .. OFF
-- EXT LT ... . . . . .. .. . . . .. .... . . . ... AS RQRD
-- PARK BRK and CHOCKS ......... ... AS RQRD
-- MOBILE PHONE .. ........... . . . ....... . . ON
-- TRANSPONDER. .. . ... ... . . . . STANDBY 2000
-- RADAR/PWS . . . .. . . . . ... . ..... .. . . .. . . OFF
-- Consider HEAVY RAIN
-- EXTRACT .... . . . . . ... .... .. . .. . ..... OVRD

-- SECURING THE AIRCRAFT
-- EFB . . ....... .. . . ..... . . .. . .. ... BOTH OFF
-- FUEL PUMPS .. ....... ..... . ....... . ... OFF
-- ADIRS . . ............. .. . .. . . ... .. . . ... OFF
-- OX'f GEN .. . . . ... ... . . ... .. .. .... . . . .. . OFF
-- APU BLEED . .. .. .... ... .. ... . .. ..... . . OFF
-- EMER EXIT LT . . . ... . .. . ... .. . ..... ... . OFF
-- PARKING BRAKE . .. .. ... . .... . . ... . ..... ON
-- NO SMOKING ... . ... ..... .. . ..... ...... OFF
-- APUAND BAT .. . ...... . ... . . ..... .... . OFF




-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(prelCockpitPrep)
activeSOP:addProcedure(cockpitPrep)

function getActiveSOP()
	return activeSOP
end

return SOP_A20N