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


-- ============== COCKPIT PREPARATION (PF) ===============
-- == Overhead Left Column
-- CREW OXY SUPPLY...............................ON   (PF)  
-- RCRD GND CTL..................................ON   (PF)  
-- CVR TEST.....................PRESS & HOLD 3 SECS   (PF)  
-- GPWS.............................NO WHITE LIGHTS   (PF)
-- EVAC SWITCH..........................CAPT & PURS   (PF)  
-- ADIRS L,R,C..................................NAV   (PF)
--   Switch one at a time waiting for the BAT light
--   to go off before switching the next one on.

-- == Overhead Center Column
-- ==== Lights panel
-- SEAT BELTS...................................OFF   (PF)
-- NO SMOKING...............................ON/AUTO   (PF)
-- EMERGENCY EXIT LIGHT.........................ARM   (PF)
-- ANNUNCIATOR LIGHT...........................TEST   (PF)

-- ==== ANTI-ICE & PRESSURIZATION
-- WING-ANTI-ICE................................OFF   (PF)
-- ENGINE ANTI-ICE..............................OFF   (PF)
-- PROBE/WINDOW HEAT.....................CHECK AUTO   (PF)
-- CABIN PRESSURE LDG ELEV.....................AUTO   (PF)
--   ECAM PRESS page check LDG ELEV being AUTO

-- ==== AIR COND Panel
-- APU BLEED............................AS REQUIRED   (PF)
-- CROSSBLEED..................................AUTO   (PF)
-- PACK FLOW SELECTOR.......................AS RQRD   (PF)

-- ==== Electrical Panel
-- NO WHITE LIGHTS..........................CHECKED   (PF)
-- BAT 1 PB & BAT 2 PB..................OFF then ON   (PF)
--   This initiates a charging cycle of the batts.
--   10 s after setting all BAT PB ON, check on the
--   ECAM ELEC page that the current charge of the
--   battery is below 60 A, and is decreasing.
-- 
-- ==== FUEL Panel
-- FUEL PUMP SWITCHES........................ALL ON   (PF)
-- FUEL MODE SELECTOR..........................AUTO   (PF)
--
-- ==== FIRE Panel
-- ENG 1 and 2 FIRE TEST.............PRESS and HOLD   (PF)
--   (check for 7 items)
-- APU FIRE..........................IN and GUARDED   (PF)
-- APU FIRE TEST..............................PRESS   (PF)
--
-- == Overhead Left Column
-- ==== CARGO Panel
-- AFT CARGO HEAT.........................MID RANGE   (PF)
-- CARGO SMOKE TEST............................PUSH   (PF)
-- ====
-- THIRD AUDIO CONTROL PANEL.......PA knob – Recept   (PF)
--   - This allows cabin attendant announcements to
--     be recorded on the CVR.
--   - Set volume at or above medium range.

-- == Central Panel
-- STANDBY INSTR (ISIS).......................CHECK   (PF)
--   Indications normal – no flags / Set QNH
-- CLOCK..................................CHECK/SET   (PF)
--   Check time is UTC, switch to GPS
-- A/SKID & N/W STRG SWITCH......................ON   (PF)

-- == Pedestal
-- RMP (Radio Management Panel)............ON & SET   (PF)
-- ACP (Audio Control Panel)............AS REQUIRED   (PF)
-- WEATHER RADAR................................OFF   (PF)
-- PWS..........................................OFF   (PF)
-- COCKPIT DOOR..............................NORMAL   (PF)
-- SWITCHING PANEL...........................NORMAL   (PF)
-- THRUST LEVERS.........................CHECK IDLE   (PF)
-- SPEED BRAKE LEVER...............RETRACT & DISARM   (PF)
-- PARK BRK HANDLE.........................CHECK ON   (PF)
-- GRAVITY GEAR EXTN.........................STOWED   (PF)
-- RMP2 (Radio Management Panel)...........ON & SET   (PF)
-- ACP2 (Audio Control Panel)...........AS REQUIRED   (PF)
-- ==== ATC / TCAS
--   XPDR CODE.................................2000   (PF)
--   SYSTEM 1...................................SET   (PF)
--   XPDR...................................STANDBY   (PF)
--   ALT REPORTING...............................ON   (PF)
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
-- RMP (Radio Management Panel)............ON & SET (BOTH)
-- ACP..................................AS REQUIRED (BOTH)
-- TRANSPONDER.................................STBY (BOTH)
-- =======================================================

-- =========== DEPARTURE BRIEFING ========
-- == AIRCRAFT
	-- FMS
	-- ➢ DATA Page
		-- ▪ Type and Model
		-- ▪ APD & Nav Database Date
	-- ➢ FMS INIT- B Pag
		-- ▪ Block Fuel (FOB on EWD)
		-- ▪ Estimated TOW
		-- ▪ Extra Time / Fuel at Destination
	-- ➢ PERF TAKEOFF Pag
		-- ▪ TO RWY
		-- ▪ TO CONF
		-- ▪ Flex / TOGA
		-- ▪ V1, VR, V2
		-- ▪ Transition Altitude
		-- ▪ Thrust Reduction / ACC Altitude
	-- ➢ F-PLN & PROG Page
		-- ▪ Route Waypoints
		-- ▪ Time, Distance and Fuel
		-- ▪ Strategy in secondary flight plan
-- == WEATHER
	-- • Weather reports and applicable procedures
	-- • Applicable NOTAMS and procedures
-- == STARTUP & TAXI
	-- • ATC Procedures (push and start procedures)
	-- • A/C Procedures (engine start etc.)
	-- • Routing to the anticipated runway
-- == RUNWAY
	-- • Dimensions (Length, Width, Stopway)
	-- • Surface Condition
	-- • Lighting
	-- • Packs / Anti ice – On/Off Takeoff
-- == DEPARTURE
	-- • Normal SID – Routing and Constraints
	-- • Engine Out SID – Routing and Constraint
	-- • Navigation Frequencies to be used (RAD NAV)
	-- • MSA
-- == SPECIAL PROCEDURES
	-- • NADP
	-- • Weather
	-- • Terrain
	-- • Failures (Communication etc.)

-- == Emergency Briefing
-- This will be a left hand seat takeoff.
-- Failure Before 100 Knots or V1
	-- • For any failure before 100 knots or V1, clearly CALL OUT THE MALFUNCTION and I will call STOP or GO.
	-- • If the call is STOP, I will apply the REJECTED TAKEOFF PROCEDURE and bring the aeroplane to a complete stop.
	-- • I will set the PARKING BRAKE and call “ATTENTION CREW AT STATION”.
	-- • You will monitor REV GREEN and DECEL and silence any AURAL WARNING and inform ATC.
	-- • Thereafter you will carry out ECAM actions on my command.
	-- • IF EVACUATION is required, we will carry out the “Emergency Evacuation Checklist”.
	
-- Failure After V1
	-- • For any failure after V1, takeoff will be continued and NO ACTION BEFORE 400 feet AGL EXCEPT silencing of any AURAL WARNING and GEAR UP.
	-- • Reaching 400 feet AGL, ECAM actions on my command.
	-- • For engine failure / damage / fire, when ENGINE IS SECURED: Stop ECAM, level off, accelerate and cleanup.
	-- • If ENGINE IS NOT SECURED: Continue climbing until engine is secured, but not above EO maximum acceleration altitude.
	-- • At GREEN DOT OPEN CLB, select MCT.
	-- • Resume ECAM, complete AFTER T/O C/L and check the STATUS.
	-- • FLY (a) EO Routing (b) SID (c) Radar Vectors (c) Immediate Turn Back.

-- REJECTED TAKEOFF: 
	-- Before 100 knots (Less serious. Abort is at Captain’s discretion depending on the circumstances)
	-- Any ECAM Warning / Caution. 
	-- Between 100 knots & V1 (More Serious. Be go minded except for a few situations, as mentioned below)
	-- Failures with ECAM
		-- Left Hand Items
			-- Side Stick Fault
		-- Right Hand Items
			-- Thrust Lever Fault
		-- Engine Items
			-- Fire
			-- Failure
			-- Reverser Unlocked or Fault.
	-- Failures without ECAM
		-- Sudden loss of thrust.
		-- Any major failure.
		-- If aeroplane is unsafe to fly due any reason.
		-- Tire failure within 20 knots of V1: Unless debris from tire causes noticeable engine parameter fluctuation, takeoff, reduce fuel load & land with full RWY length available.
	-- Weather
		-- Windshear.
	-- Note: Exceeding EGT red line or nose gear vibration should not result in an abort above 100 knots *

-- ============ COCKPIT PREPARATION CHECKLIST ============
-- GEAR PINS & COVERS.......................REMOVED   (PF)
-- FUEL QUANTITY............................ ___ KG   (PF)
--   check FOB & distribution on FUEL SD page
-- SEAT BELT.....................................ON   (PF)
-- ADIRS........................................NAV   (PF)
-- BARO REF....................................____ (BOTH)
-- =======================================================

-- ========= BEFORE PUSHBACK AND START CLEARANCE =========
-- SEAT POSITION.............................ADJUST (BOTH)
-- FUEL......CROSS CHECK (ECAM FOB & FPL/LOADSHEET)   (PF)
-- LOAD SHEET........................CHECK / REVISE (BOTH)
-- FMS T/O DATA..............................REVISE (BOTH)
-- MCDU............................FMS PERF TO PAGE   (PF)
-- MCDU..............................FMS F-PLN PAGE   (PM)
-- EXTERNAL POWER........................DISCONNECT   (PM)
-- PUSH / START CLEARANCE....................OBTAIN   (PM)
-- BEACON........................................ON   (PF)
-- ATC TRANSPONDER..................SET AS REQUIRED   (PM)
-- WINDOWS / DOORS...................CHECKED CLOSED (BOTH)
-- THRUST LEVERS...............................IDLE   (PF)
-- ACCU PRESSURE INDICATOR....................CHECK   (PF)
-- TAKEOFF CG/TRIM POS..check and set (BOTH)

-- APU START NOW and GPU disconnected
-- =======================================================


-- =============== BEFORE START CHECKLIST ================
-- PARKING BRAKE.................................ON   (PF)
-- T.O. SPEEDS & THRUST......................._____ (BOTH)
--   PF V1,VR,V2 & thrust setting FMS PERF
-- WINDOWS...................................CLOSED (BOTH)
-- BEACON........................................ON   (PF)
-- =======================================================


-- =============== PUSHBACK & ENGINE START ===============
-- PARKING BRAKE................................SET   (PF)
-- PUSHBACK SERVICE..........................ENGAGE   (PF)
--   Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH   (PF)
-- == AUTOMATIC START
-- THRUST LEVERS...............................IDLE   (PF)
-- ENGINE MODE SELECTOR.................IGN / START   (PF)
-- PARKING BRAKE...........................RELEASED   (PF)
-- START FIRST ENGINE.............STARTING ENGINE _   (PF)
--   ENGINE MASTER SWITCH........................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- START SECOND ENGINE............STARTING ENGINE _   (PF)
--   ENGINE MASTER SWITCH........................ON   (PF)
--     N2 Increases – Start Valve Inline, 
--     Bleed Pressure Green, Oil Pressure Rises.
--     N2 16% – Indication of Active Ignitor A or B.
--     N2 22% – FF Increases (may cross approx. 200 Kg/h).
--     EGT & N1 – Increases within 15s (max) after fuel is ON.
--     N2 50% – Start valve closure starts & Igniter indication Off.
--   IDLE PARAMETERS
--	   N1 – 20%.
--     N2 – 60%.
--     EGT – 400oC.
--     FF – 300 Kg/h.
-- PARKING BRAKE................................SET   (PM)
--   When instructed by ground crew after pushback/towing
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY   (PF)
--   LOCKOUT PIN REMOVED.....................VERIFY   (PF)
-- =======================================================

-- ===================== AFTER START =====================
-- ENGINE MODE SELECTOR......................NORMAL   (PF)
-- APU BLEED....................................OFF   (PF)
-- ENGINE ANTI-ICE......................AS REQUIRED   (PF)
-- WING ANTI-ICE........................AS REQUIRED   (PF)
-- APU MASTER SWITCH............................OFF   (PF)
-- GROUND SPOILERS..............................ARM   (PM)
-- RUDDER TRIM.................................ZERO   (PM)
-- FLAPS...........................TAKEOFF POSITION   (PM)
-- PITCH TRIM HANDWHEEL.........................SET   (PM)
-- STATUS REMINDER..............CHECK NOT DISPLAYED   (PF)
-- N/W STEER DISC MEMO..........CHECK NOT DISPLAYED   (PF)
-- GROUND CREW.........ANNOUNCE CLEAR TO DISCONNECT   (PF)
-- GROUND CREW.....ANNOUNCE HAND SIGNAL ON LEFT/RGT   (PF)
-- =======================================================


-- ================= AFTER START CHECKLIST ===============
-- ANTI ICE.............................AS REQUIRED   (PF)
-- ECAM STATUS..............................CHECKED   (PF)
-- PITCH TRIM................................_% SET   (PF)
-- RUDDER TRIM..............................NEUTRAL   (PF)
-- =======================================================


-- ================= BEFORE TAXI PROCEDURE ===============
-- == PRE-REQ
-- FLIGHT CONTROLS............................CHECK (BOTH)
--   Flight Controls Before or During Taxi 
-- TAXI CLEARANCE............................OBTAIN   (PM)
-- TAXI / TURN OFF LIGHT.........................ON   (PF)
-- AREA CLEARANCE...........“CLEAR LEFT/RIGHT SIDE” (BOTH)
-- PARKING BRAKE..........OFF – BRAKE PRESSURE ZERO   (PF)
-- BRAKE PEDALS.........PRESS & CALL: “BRAKE CHECK”   (PF)
-- == CLEARANCE
-- ATC CLEARANCE............................CONFIRM   (PM)
-- FLIGHT DIRECTORS.........................BOTH ON   (PM)
-- == DO ITEMS
-- AUTO BRAKES......................AUTO BRK MAX ON   (PM) 
-- ATC CODE/MODE........................CONFIRM/SET   (PM) 
-- ENGINE MODE SELECTOR.................AS REQUIRED   (PM) 
-- WEATHER RADAR.............................ON/ALL   (PF)
-- PREDICTIVE WINDSHEAR.....................AUTO/ON   (PM) 
-- TERRAIN ON ND........................AS REQUIRED   (PM) 
-- FINAL CHECK TO CONFIG.......................TEST   (PM) 
-- FINAL CHECK TO MEMO................CHECK NO BLUE   (PM)
-- “CABIN SECURED FOR TAKEOFF”
-- =======================================================


-- ==================== TAXI CHECKLIST ===================
-- FLIGHT CONTROLS..........................CHECKED (BOTH)
-- FLAP SETTINGS...........................CONF ___ (BOTH)
-- RADAR & PRED W/S.......................ON & AUTO   (PF)
-- ENG MODE.................IGNITION|NORM (on A320)   (PF)
-- START SEL................IGNITION|NORM (on A340)   (PF)
-- ECAM MEMO.............................TO NO BLUE   (PF)
--   - AUTO BRK MAX
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS TO
--   - TO CONFIG NORM
-- =======================================================

-- =============== BEFORE TAKEOFF PROCEDURE ==============
-- BRAKE FANS.................................CHECK   (PM)
-- LINEUP CLEARANCE..........................OBTAIN   (PM)
-- TCAS.................................TA OR TA/RA   (PM)
-- TAKEOFF RUNWAY...........................CONFIRM (BOTH)
-- APPROACH PATH...................CLEAR OF TRAFFIC (BOTH)
-- EXTERIOR LIGHTS......................STROBE – ON   (PF)
-- PACKS................................AS REQUIRED   (PM)
-- SLIDING TABLE.............................STOWED (BOTH)
-- CABIN CREW................................ADVISE   (PM)
-- =======================================================

-- =================== LINE-UP CHECKLIST =================
-- T.O RWY......................................___ (BOTH)
-- TCAS.......................................TA/RA   (PM)
-- PACK 1 & 2......................____ AS REQUIRED   (PM)
-- =======================================================


-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ============
-- TAKEOFF CLEARANCE........................OBTAIN   (PM)
--   Weather around departure path
--   Terrain around departure path
--   Fuel check before takeoff
-- FCU.................................AS REQUIRED   (PF)
-- == Exterior Lights
-- NOSE LIGHT...................................ON   (PF)
-- TURN OFF LIGHTS..............................ON   (PF)
-- LAND LIGHTS..................................ON   (PF)
-- == Thrust Setting
-- ANNOUNCE..............................“TAKEOFF”   (PF)
--   STANDARD TAKEOFF
--     • Thrust – N1 50% (1.05 EPR)
--     • Brakes – Release
--     • Thrust – FLX / TOGA
--     • Sidestick – ½ FWD up to 80, Neutral by 100
-- CHRONO.....................................START   (PM)
-- == Below 80 Knots
-- TAKEOFF N1(EPR)............................CHECK   (PM)
-- ANNOUNCE............................“THRUST SET”   (PM)
-- ANNOUNCE...............................100 KNOTS   (PM)
-- AT V1 & VR..............ANNOUNCE “V1” & “ROTATE”   (PM)
-- POSITIVE CLIMB......................GT 40 FT AGL   (PM)
-- LANDING GEAR..................................UP   (PM)
-- == Thrust Reduction Altitude (>xxxft)
-- THRUST LEVERS..........................CL DETENT   (PF)
-- PACKS.........................................ON   (PM)
-- == Acceleration Altitude (> xxxxft)
--   Check Target Speed – Monitor FMA
-- AP1...........................................ON   (PF)
-- F SPEED..................................REACHED
-- FLAPS 1......................................SET   (PM)
-- S SPEED..................................REACHED
-- FLAPS 0......................................SET   (PM)
-- SPOILERS..................................DISARM   (PM)
-- EXT LIGHTS...................................SET   (PM)
-- TCAS.....................................TA / RA   (PM)
-- ENGINE MODE..........................AS REQUIRED   (PM)
-- == APU 
--   BLEED SWITCH.......................AS REQUIRED   (PM)
--   MASTER SWITCH......................AS REQUIRED   (PM)
-- == Anti-Ice 
--   ENGINE ANTI-ICE....................AS REQUIRED   (PM)
--   WING ANTI-ICE......................AS REQUIRED   (PM)
-- MCDU.......................PF=PERF CLB, PM=F-PLN (BOTH)
-- Whatever comes first
-- TRANSITION ALTITUDE.............ANNOUNCE REACHED   (PM)
-- ALTIMETERS...................................STD (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...........................RETRACT   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF   (PM)
-- BELTS SWITCH.................................OFF   (PM)
-- EFIS.......................PF=CSTR/ARPT, PM=ARPT (BOTH)
-- TILT/TERRAIN........PF=WX ON, PF=TERR OFF, WX=ON (BOTH)
-- =======================================================

-- ================== DESCENT PREPARATION ================
-- == Planning
--   Weather & Landing Info 1 – Check pm
--   ECAM Status – Check pm 
--   Nav Charts – Prepare both
--   Landing Conditions – Confirm 2 both
--   Landing Performance – Compute & Cross Check 3 both
--   AUTO BRK – AS REQ 4 pf
--   No Full Flaps – Select GPWS LDG FLAP 3 pm
-- == Preparation (PF)
--   • F-PLN A (DES WINDS / ARRIVAL) 5
--   • RAD NAV
--   • PROG (BRG / DIST TO RWY)
--   • PERF:
--     o CRUISE (cabin descent rate)
--     o DES (Mach / Speed)
--     o APPR:
--       ▪ QNH
--       ▪ Temperature
--       ▪ Destination Wind 6
--       ▪ Minimum
--       ▪ Landing CONF
--     o GO-AROUND:
--       ▪ Thrust reduction
--       ▪ Acceleration altitude
--   • FUEL PREDICTION
--   • SEC F-PLN (Alternate Runway etc.)
--   • Landing Elevation – Mode & Value
-- == Arrival Briefing (PF)
-- == Descent Clearance Obtained by PM
--   ALTITUDE WINDOW..SET CLEARED ALTITUDE pf
--   TCAS..SET PM
-- =======================================================

-- =================== ARRIVAL BRIEFING ==================
-- == AIRCRAFT 
--   Technical Status
-- == AIRFIELD (DEST & ALT)
--   Weather
--   Terminal information – NOTAMS etc.
--   Fuel – Extra Holding
-- == STAR
--   • NAV Frequencies
--   • Routing and Constraints
--   • Transition Level
--   • MSA
-- == APPRPOACH
--   • NAV Frequencies
--   • Approach and Minima
--   • Transition Level
--   • MSA
--   • Obstacles
--   • Restricted / Prohibited areas
-- == GOAROUND
--   • ATC Procedure
--   • Aircraft Procedure
-- == RUNWAY
--   Dimensions (Length, Width, Distance beyond G/S)
--   Surface Condition
--   Lighting
-- ==TAXI
--   Routing and Parking
-- == SPECIAL PROCEDURES
--   Weather (Circumnavigation etc.)
--   Terrain
--   Failures (Communication, MEL etc.)
-- =======================================================

-- ================= DESCENT PROCEDURE ==================
-- MCDU..PF=PROG / PERF DES, PM=F-PLN (BOTH)
-- == Speeds
--   Managed – If Not then:
--     o 0.78 / 300 till FL100
--     o 250 below FL100
-- == Tilt / Terrain
--   Tilt – Adjust WX Radar PF
--   Terrain ON ND 3 PM
-- Whatever comes first
-- TRANSITION LEVEL................ANNOUNCE REACHED   (PM)
-- ALTIMETERS...............................QNH SET (BOTH)
-- =====
-- 10.000 FT.......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................SET   (PM)
-- SEAT BELTS............................ON   (PM)
-- EFIS.......................CSTR (BOTH)
-- LS...AS REQUIRED (BOTH)
-- RAD / NAV..SELECTED & IDENTIFIED PM
-- ENG MODE.. AS REQUIRED (PM)
-- =======================================================


-- ================== APPROACH CHECKLIST =================
-- BARO REF....................................____ (BOTH)
-- SEAT BELTS....................................ON   (PM)
-- MINIMUM.....................................____   (PF)
-- AUTO BRAKE..................................____   (PF)
-- ENG MODE SEL................................____   (PF)
-- =======================================================


-- =============== LANDING PROCEDURE (PM) ================
-- LANDING LIGHTS................................ON   (PF)
-- APPROACH PHASE..........................ACTIVATE   (PF)
-- 3NM FROM FDP OR S-SPEED..................REACHED
-- FLAPS 1......................................SET   (PM)
-- 2000 FT AGL..............................REACHED
-- FLAPS 2......................................SET   (PM)
-- LANDING GEAR................................DOWN   (PM)
-- AUTO BRAKE...........................SET/CONFIRM   (PM)
-- RWY TURNOFF LIGHTS............................ON   (PM)
-- NODE LIGHTS...................................ON   (PM)
-- GROUND SPOILERS..............................ARM   (PM)
-- FLAPS 3......................................SET   (PM)
-- ECAM WHEEL PAGE............................CHECK   (PM)
-- GO AROUND ALTITUDE.......................... SET   (PM)
-- FLAPS FULL...................................SET   (PM)
-- LANDING MEMO.......................CHECK NO BLUE
-- CABIN REPORT.............................RECEIVE
-- A/THR..........................SPEED MODE OR OFF
-- WING ANTI-ICE................................OFF
-- =======================================================

-- ================== LANDING CHECKLIST ==================
-- ECAM MEMO................................NO BLUE   (PM)
--   - LDG GEAR DN
--   - SIGNS ON
--   - CABIN READY
--   - SPLRS ARM
--   - FLAPS SET
-- =======================================================



-- ============== AFTER LANDING PROCEDURE ================
-- GROUND SPOILERS...........................DISARM   (PF)
-- STROBES......................................OFF   (PF)
-- LANDING LIGHTS...............................OFF   (PF)
-- TAXI LIGHTS...................................ON   (PF)
-- CHRONO & ET.................................STOP  (CPT)
-- RADAR........................................OFF
-- PWS..........................................OFF
-- ENGINE MODE SELECTOR........................NORM
-- FLAPS....................................RETRACT
-- TCAS.....................................STANDBY
-- ATC..................................AS REQUIRED
-- APU MASTER PB..............................PRESS   (PM)
--   After master switch, wait 3s 
-- APU START PB...............................PRESS   (PM)
-- ENGINE ANTI-ICE......................AS REQUIRED
-- WING ANTI-ICE........................AS REQUIRED
-- BRAKE TEMPERATURE..........................CHECK
-- =======================================================

-- =============== AFTER LANDING CHECKLIST ===============
-- RADAR & PRED W/S.............................OFF   (PM)
-- =======================================================


-- ================== PARKING PROCEDURE ==================
-- TAXI LIGHT SWITCH............................OFF   (PF) 
-- == Parked at Gate
--   ACCU PRESSURE............................CHECK   (PF)
--   PARKING BRAKES..............................ON   (PF)
--   BRAKE PRESSURE INDICATOR.................CHECK   (PF)
--   ENGINE ANTI-ICE............................OFF   (PM)
--   WING ANTI-ICE..............................OFF   (PM)
--   ELECTRIC POWER:
--     IF APU AVAILABLE – APU BLEED..............ON   (PM)
--     IF EXT PWR AVAIL – EXT PWR................ON   (PM)
-- ENGINE MASTER SWITCHES.......................OFF   (PF) 
-- == MISC. Do Items
--   WING LIGHTS................................OFF   (PF)
--   BEACON.....................................OFF   (PF)
--   SEAT BELTS.................................OFF   (PF)
--   FUEL PUMPS.................................OFF   (PM)
--   ATC....................................STANDBY   (PM)
--   BRAKE FAN..................................OFF   (PM)
-- == Ground Contact
--   PARKING BRAKE......................AS REQUIRED   (PF)
--   CHOCKS................................IN PLACE   (PF)
-- =======================================================


-- ================== PARKING CHECKLIST ==================
-- PARK BRK OR CHOCKS...........................SET   (PF)
-- ENGINES......................................OFF   (PF)
-- WING LIGHTS..................................OFF   (PF)
-- FUEL PUMPS...................................OFF   (PF)
-- =======================================================


-- =========== SECURING THE AIRCRAFT PROCEDURE ===========
-- PARKING BRAKE...........................CHECK ON   (PF)
-- ADIRS..................ALL IR MODE SELECTORS OFF   (PF)
-- OXYGEN CREW SUPPLY...........................OFF   (PM)
-- EXTERIOR LIGHTS..............................OFF   (PM)
-- MAINTENANCE BUS......................AS REQUIRED   (PM)
-- APU..................BLEED AND MASTER SWITCH OFF   (PM)
-- EMERGENCY EXIT LIGHTS AND SIGNS..............OFF   (PM)
-- EXTERNAL POWER.......................AS REQUIRED   (PM)
-- BATTERY................................1 & 2 OFF   (PM)
-- =======================================================



-- =========== SECURING THE AIRCRAFT CHECKLIST ===========
-- OXYGEN.......................................OFF   (PM)
-- EMER EXIT LIGHT..............................OFF   (PM)
-- EFB..........................................OFF   (PM)
-- BATTERIES....................................OFF   (PM)
-- =======================================================



-- ============  =============
-- add the checklists and procedures to the active sop
-- activeSOP:addProcedure(prelCockpitPrep)
-- activeSOP:addProcedure(cockpitPrep)

function getActiveSOP()
	return activeSOP
end

return SOP_A20N

