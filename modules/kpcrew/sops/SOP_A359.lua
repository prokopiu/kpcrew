-- Standard Operating Procedure for FlightFactor A350

-- @classmod SOP_A359
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_A359 = {
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
local State		 			= require "kpcrew.procedures.State"
local Background 			= require "kpcrew.procedures.Background"
local ProcedureItem 		= require "kpcrew.procedures.ProcedureItem"
local SimpleProcedureItem 	= require "kpcrew.procedures.SimpleProcedureItem"
local IndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"
local BackgroundProcedureItem = require "kpcrew.procedures.BackgroundProcedureItem"
local HoldProcedureItem 	= require "kpcrew.procedures.HoldProcedureItem"

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
sysMacros					= require("kpcrew.systems." .. kc_acf_icao .. ".sysMacros")	

require("kpcrew.briefings.briefings_" .. kc_acf_icao)

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Preflight", [3] = "Preflight", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = SOP:new("FF A350 SOP")

local testProc = Checklist:new("TEST","","")
testProc:addItem(IndirectChecklistItem:new("FUEL","TESTED 100 #exchange|PERC|percent",FlowItem.actorFO,0,"oxygentestedcpt",
	function () return 1 == 1 end))

local testProc = Procedure:new("TEST","","")
testProc:addItem(ProcedureItem:new("STEP1","DO",FlowItem.actorFO,0,true,
	function () 
		kc_macro_state_turnaround()
	end))

-- =============== ECAM & CKPT PREPARATION ===============
-- === ECAM
-- ECAM...........................................ON		.1-sim/ind/ecamMode.>.0
--   Recommended to use ecam auto mode
-- ECAM AUTO MODE..............................CHECK
-- NSS DATA TO AVCS...............................ON		.1-sim/53/button.=.1
-- CAB DATA TO NSS................................ON		.1-sim/54/button.=.1
-- GATELINK.......................................ON		.1-sim/230/button.=.1
-- COOLING........................................ON		.1-sim/42/button.=.1
-- CABIN FANS.....................................ON		.1-sim/44/button.=.1.and.1-sim/45/button.=.1
-- === Radio Management Panel
-- RMP 1 & 2.................................CONFIRM
-- FREQUENCIES..................................TUNE
-- RAD NAV STBY OFF............................CHECK
-- COM1.......................................SELECT		.sim/cockpit2/radios/actuators/audio_com_selection.=.6
-- SOUND......................................SELECT		.1-sim/radio/lamp/1/1.>.0.or.1-sim/radio/lamp/2/1.>.0
-- VOLUME.......................................TUNE		.1-sim/radio/1/1/rotary.>.0.or.1-sim/radio/2/1/rotary.>.0
-- SQWK PAGE..................................SELECT		.1-sim/xxx/sqwkPageSelect.=.1
-- SQWK MASTER...................................SET		.1-sim/surv/MFDinControl.=.0
-- SQWK.......................................SELECT
-- === COCKPIT PREPARATION
-- ===== OVERHEAD PANEL
-- All white lights off
-- As a general rule all white lights should be off OH
-- scanning sequence is from left to right and from 
-- bottom to top
-- EMER CALLS....................................OFF		.1-sim/37/button.=.0
-- EVAC COMMAND..............................GUARDED		.1-sim/30/cover.=.0
-- CAPT & PURS.............................CAPT&PURS		.1-sim/1/switch.=.1
-- OXYGEN CREW....................................ON		.1-sim/38/button.=.1
-- PRIM & SEC 1 FLT COMPs.........................ON		.1-sim/29/button.=.0.and.1-sim/30/button.=.0
-- PRIM & SEC 3 FLT COMPs.........................ON		.1-sim/31/button.=.0.and.1-sim/32/button.=.0
-- ADIRS SELECTOR 1..............................NAV		.1-sim/adirs/1/switch.=.1
-- ADIRS SELECTOR 2..............................NAV		.1-sim/adirs/2/switch.=.1
-- ADIRS SELECTOR 3..............................NAV		.1-sim/adirs/3/switch.=.1
-- ADR 1..........................................ON		.1-sim/26/button.=.1
-- ADR 2..........................................ON		.1-sim/28/button.=.1
-- ADR 3..........................................ON		.1-sim/27/button.=.1
-- IR 1...........................................ON		.1-sim/23/button.=.1
-- IR 2...........................................ON		.1-sim/25/button.=.1
-- IR 3...........................................ON		.1-sim/24/button.=.1
-- STROBE LT SW..................................OFF		.1-sim/2/switch.=.0
-- BEACON LT SW..................................OFF		.1-sim/3/switch.=.0
-- NAV LT SW......................................ON		.1-sim/4/switch.=.1
-- REMAINING LIGHTS AS REQUIRED................CHECK
-- SEATBELTS......................................ON		.1-sim/12/switch.=.1
-- NO SMOKING.....................................ON		.1-sim/13/switch.=.1
-- XBLEED SELECTOR..............................AUTO		.1-sim/air/crossBeedSwitch.=.1
-- AIR FLOW SELECTOR............................NORM		.1-sim/air/airFlowSwitch.=.1
-- TEMP SELECTORS AS REQUIRED.................SELECT
--   Select comfortable temperature
-- ECAM ELEC DC PAGE............................CALL		.1-sim/ind/ecamMode.=.7
-- ALL BATTERIES CURRENT BELOW 60A.............CHECK
-- APU GEN PB.....................................ON		.1-sim/101/button.=.1
-- APU GEN FAULT LT OFF........................CHECK
-- GENs 1.........................................ON		.1-sim/96/button.=.1.and.1-sim/99/button.=.1
--   FAULT lights visible
-- GENs 2.........................................ON		.1-sim/103/button.=.1.and.1-sim/106/button.=.1
--   FAULT lights visible
-- BUS TIE......................................AUTO		.1-sim/100/button.=.1
-- MAIN FUEL PUMPS................................ON		.1-sim/68/button.=.1.and.1-sim/81/button.=.1
-- MAIN FUEL PUMPS................................ON		.1-sim/68/button.=.1.and.1-sim/81/button.=.1
-- STBY FUEL PUMPS..............................AUTO		.1-sim/69/button.=.1.and.1-sim/82/button.=.1
-- 1 & 2 FUEL PUMPS...............................ON		.1-sim/70/button.=.1.and.1-sim/80/button.=.1
-- CTR TK FEED PB...............................AUTO		.1-sim/84/button.=.1
-- MAINTENANCE PANEL ALL WHITE LTS OFF.........CHECK
-- CARGO AIR SEL AS REQUIRED..................SELECT
-- PRIM & SEC 2 FLT COMPs.........................ON		.1-sim/50/button.=.0.and.1-sim/51/button.=.0
-- HYD ELEC PMP GREEN.............................ON		.1-sim/47/button.=.0
-- HYD ELEC PMP YELLOW............................ON		.1-sim/49/button.=.0
-- ===== CENTRE INSTRUMENT PANEL
-- AIR DATA SELECTORS..........................CHECK
-- GEAR LEVER...................................DOWN		.sim/cockpit/switches/gear_handle_status.=.1
-- A-SKID.........................................ON		.1-sim/37/switch.=.1
-- STBY INSTRUMENTS ON.........................CHECK
-- ===== PEDESTAL
-- PARK BRK.......................................ON		.1-sim/parckBrake.=.0
-- L/G/GRAVITY EXTN..............................OFF		.1-sim/brg/emer.=.1
-- L/G/GRAVITY EXTN..........................GUARDED		.1-sim/36/cover.=.0
-- THRUST LEVERS................................IDLE		.1-sim/R/throttle.=.0.and.1-sim/L/throttle.=.0
-- REVERSE LEVERS.............................STOWED		.1-sim/L/reverser.=.0.and.1-sim/R/reverser.=.0
-- ENG MASTER SWITCHES...........................OFF		.1-sim/eng/cutoff/L/switch.=.1.and.1-sim/eng/cutoff/R/switch.=.1
-- CKPT DOOR PB..................................OFF		.1-sim/221/button.=.0
-- SURV SYS 1 PBs.................................ON		.1-sim/216/button.=.1.and.1-sim/217/button.=.1
-- SURV SYS 2 PBs.................................ON		.1-sim/218/button.=.1.and.1-sim/220/button.=.1
-- ===== MFD SURV
-- SURV PAGE..................................SELECT		.1-sim/mfd/guage.=.3
-- CONTROLS PAGE..............................SELECT		.1-sim/mfd/page.=.1
--   Press DEFAULT SETTINGS for quick setup
-- XPDR.........................................AUTO		.1-sim/surv/XPDRmode.=.3
-- TCAS MODE TA/RA & NORM.....................SELECT		.1-sim/surv/TCASmode.=.1.and.1-sim/surv/TCASdisplay.=.1
-- WXR AUTO...................................SELECT		.1-sim/surv/WXRelev.=.1
-- WXR WX AUTO................................SELECT		.1-sim/surv/WXRon.=.1
-- WXR PRED AUTO..............................SELECT		.1-sim/surv/WXRpred.=.1
-- WXR TURB AUTO..............................SELECT		.1-sim/surv/WXRturb.=.1
-- WXR GAIN AUTO..............................SELECT		.1-sim/surv/WXRgain.=.1
-- WXR MODE AUTO..............................SELECT		.1-sim/surv/WXRmode.=.1
-- WXR ON VD AUTO.............................SELECT		.1-sim/surv/WXRonvd.=.1
-- TAWS TERRAIN MODE..............................ON		.1-sim/surv/TAWSterr.=.1
-- TAWS GPWS......................................ON		.1-sim/surv/TAWSgpws.=.1
-- TAWS GS MODE...................................ON		.1-sim/surv/TAWSgs.=.1
-- TAWS FLAP MODE.................................ON		.1-sim/surv/TAWSflap.=.1
-- ===== MFD FMS INITIALIZATION
-- INIT PAGE....................................OPEN		.1-sim/mfd/page.=.24
-- FLIGHT NUMBER...............................ENTER		.1-sim/checklist/flightNumber.~.0
-- FROM FIELD...................................FILL		.1-sim/checklist/from.~.0
-- TO FIELD.....................................FILL		.1-sim/checklist/to.~.0
-- === GLARESHIELD BARO REF
-- BARO REF BOTH SET...........................CHECK
--   Set the QNH/QFE on the EFIS and on the ISIS
--   check barometer settings and altitude indications on 
--   PFD and ISIS
--   the maximum difference is: 20ft
--   check stby AH barometer setting and altitude
-- ===== GLARESHIELD
-- ND MODE & RANGE AS REQUIRED.................CHECK
--   set the minimum range to display the first waypoint
-- PFD ON......................................CHECK
-- NORTH REF...................................CHECK
-- SPD/MACH WINDOW DASHED......................CHECK
-- HDG/TRK WINDOW DASHED.......................CHECK
-- HDG V/S - TRK FPA HDG V/S...................CHECK
-- ALT WINDOW INITIAL CLEARANCE................CHECK
-- =======================================================

-- =============== BEFORE PUSHBACK & START ===============
-- === BEFORE PUSHBACK CLEARANCE
-- FUEL QUANTITY...............................CHECK
--   on the ECAM permanent data, check FOB corresponds
--   with the F-PLAN
-- FINAL LOADSHEET.............................CHECK
-- ZFW/ZFCG IN FMS.............................CHECK
--   compare the ZFW/ZFCG of the final loadsheet
--   with data entered into FMS
-- ECAM CWCG...................................CHECK
--   check within operating limits
-- SEATS, SEAT BELT, PEDALS...................ADJUST
-- EXT PWR.......................................OFF		.1-sim/97/button.=.0.and.1-sim/104/button.=.0
-- === AT START CLEARANCE
-- THRUST LEVERS................................IDLE		.1-sim/R/throttle.=.0.and.1-sim/L/throttle.=.0
-- PARK BRK......................................OFF		.1-sim/parckBrake.=.1
-- PUSHBACK TRUCK...............................CALL
--   use the menu to call for pushback truck
--   use the pedals and thrust levers to control the truck
-- =======================================================

-- ==================== ENGINE START =====================
-- === ENGINE START
-- HYD ENG 1 PUMPS................................ON		.1-sim/65/button.=.1.and.1-sim/67/button.=.1
-- HYD ENG 2 PUMPS................................ON		.1-sim/75/button.=.1.and.1-sim/77/button.=.1
-- BEACON LT......................................ON		.1-sim/3/switch.=.1
-- APU AVAIL.................................CONFIRM		.sim/cockpit/engine/APU_N1.>.97
-- APU BLEED......................................ON		.1-sim/111/button.=.1
-- ECAM AUTO MODE..............................CHECK
-- ENG START SELECTOR..........................START		.1-sim/eng/startSwitch.=.2
-- ENG MASTER 1...................................ON		.1-sim/eng/cutoff/L/switch.=.0
--   monitor engine parameters: EGT, N3, N1
-- ECAM ENG PAGE..................................ON		.1-sim/ind/ecamMode.=.1
-- ENG 1 AVAIL...............................CONFIRM		.sim/flightmodel/engine/ENGN_N1_[0].>.20
-- ENG MASTER 2...................................ON		.1-sim/eng/cutoff/R/switch.=.0
--   monitor engine parameters: EGT, N3, N1
-- ENG 2 AVAIL...............................CONFIRM		.sim/flightmodel/engine/ENGN_N1_[1].>.20
-- =======================================================

-- ===================== AFTER START =====================
-- === ENGINE & CONTROLS
-- PARK BRK.......................................ON		.1-sim/parckBrake.=.0
-- ENG START SELECTOR...........................NORM		.1-sim/eng/startSwitch.=.1
-- ENG 1 BLEED....................................ON		.1-sim/109/button.=.1
-- ENG 2 BLEED....................................ON		.1-sim/115/button.=.1
-- APU BLEED.....................................OFF		.1-sim/111/button.=.0
-- PACK 1 PB......................................ON		.1-sim/107/button.=.1
-- PACK 2 PB......................................ON		.1-sim/112/button.=.1
-- HOT AIR 1 PB...................................ON		.1-sim/110/button.=.1
-- HOT AIR 2 PB...................................ON		.1-sim/114/button.=.1
-- ANTI-ICE AS REQUIRED.......................SELECT
-- APU MASTER SW.................................OFF		.1-sim/125/button.=.0
-- APU GEN PB....................................OFF		.1-sim/101/button.=.0
-- GROUND SPOILERS...............................ARM		.sim/cockpit2/controls/speedbrake_ratio.<.0
-- RUDDER TRIM ZERO...........................SELECT		.sim/cockpit2/controls/rudder_trim.=.0
-- FLAP LEVER....................................SET
--   set flaps for takeoff and check
-- PITCH TRIM..................................CHECK
-- ECAM STATUS.................................CHECK
-- === ELECTRICAL SYSTEMS
-- ELMU...........................................ON		.1-sim/90/button.=.1
-- PAX SYS........................................ON		.1-sim/91/button.=.1
-- GALLEY.........................................ON		.1-sim/92/button.=.1
-- COMMERCIAL.....................................ON		.1-sim/93/button.=.1.and.1-sim/94/button.=.1
-- WIRELESS.......................................ON		.1-sim/15/button.=.1
-- PASSENGER DATA................................OFF		.1-sim/16/button.=.1
-- CABIN SATCOM...................................ON		.1-sim/17/button.=.1
-- LANDING CAMERA.................................ON		.1-sim/18/button.=.1
-- FAR 4..........................................ON		.1-sim/19/button.=.1.and.1-sim/20/button.=.1
-- AFEX...........................................ON		.1-sim/21/button.=.1
-- DER............................................ON		.1-sim/22/button.=.1
-- === PRESSURIZATION
-- CABIN ALT MODE...............................AUTO		.1-sim/122/button.=.1
-- CABIN V/S MODE...............................AUTO		.1-sim/123/button.=.1
-- =======================================================

-- ======================== TAXI =========================
-- NOSE LIGHTS..................................TAXI		.1-sim/11/switch.=.1
-- RWY TURN OFF LTS...............................ON		.1-sim/8/switch.=.1
-- PARK BRK......................................OFF		.1-sim/parckBrake.=.1
-- THRUST LEVERS AS REQUIRED...................CHECK
-- AUTOBRAKE RTO.................................SET		.1-sim/225/button.=.1
-- =======================================================

-- ===================== AFTER START =====================
-- PACKS PB.......................................ON		.1-sim/107/button.=.1.and.1-sim/112/button.=.1
-- TAXI PB.......................................OFF		.1-sim/132/button.=.0
-- ND RANGE AS REQUIRED........................CHECK
-- EFIS OPTIONS................................CHECK
-- STROBE LIGHTS SW...............................ON		.1-sim/2/switch.>.0
-- TABLE......................................STOWED		.1-sim/computer.=.0
-- TCAS MODE TA/RA...............................SET		.1-sim/surv/TCASmode.=.1
-- =======================================================

-- ======================= TAKEOFF =======================
-- CHRONO......................................START		.AirbusFBW/ChronoTimeND1.>.0.or.AirbusFBW/ChronoTimeND2.>.0
-- THRUST LEVER FLEX/TOGA........................SET		.1-sim/R/throttle.>.0.and.1-sim/L/throttle.>.0
-- TAKEOFF THRUST..............................CHECK
-- V1 MONITOR..................................CHECK
-- AT VR ROTATE..............................PERFORM
-- LANDING GEAR...................................UP		.sim/cockpit/switches/gear_handle_status.=.0
-- AP AS REQUIRED..............................CHECK
-- THRUST LEVER CL.............................CHECK
-- PACKS PB.......................................ON		.1-sim/107/button.=.1.and.1-sim/112/button.=.1
-- FLAPS ZERO.................................SELECT		.1-sim/flaphandle.=.1
-- RWY TURN OFF LTS..............................OFF		.1-sim/8/switch.=.0
-- GROUND SPOILERS............................DISARM		.sim/cockpit2/controls/speedbrake_ratio.=.0
-- =======================================================

-- ==================== AFTER TAKEOFF ====================
-- APU BLEED.....................................OFF		.1-sim/111/button.=.0
-- APU MASTER SW.................................OFF		.1-sim/125/button.=.0
-- ANTI-ICE AS REQUIRED........................CHECK
-- =======================================================

-- ======================== CLIMB ========================
-- BARO REF STD AS REQUIRED....................CHECK
-- CRZ FL SET AS REQUIRED......................CHECK
-- ANTI-ICE AS REQUIRED........................CHECK
-- SEATBELTS AS REQUIRED.......................CHECK
-- ECAM MEMO REVIEW............................CHECK
-- NAVAIDS.....................................CHECK
-- OPT/MAX ALT.................................CHECK
-- =======================================================

-- ======================== CRUISE =======================
-- ALT CRZ ON FMS..............................CHECK
-- ECAM MEMO...................................CHECK
-- ECAM SYS PAGES REVIEW.......................CHECK
-- =======================================================

-- ================= DESCENT PREPARATION =================
-- WEATHER OBTAINED............................CHECK
-- LDG ELEC....................................CHECK
-- BARO REF PRESET.............................CHECK
-- ECAM STATUS&MEMO............................CHECK
-- APPROACH DATA INSERT........................CHECK
-- POSITION/NAVAIDS PAGE.......................CHECK
-- SEC PAGES AS REQUIRED.......................CHECK
-- AUTOBRAKE AS REQUIRED.......................CHECK
--   on short runways use 3 or higher
-- ANTI-ICE AS REQUIRED........................CHECK
-- =======================================================

-- ======================= DESCENT =======================
-- === AT 10 000 FT
-- EXTERIOR LIGHTS SET.........................CHECK
-- SEATBELTS......................................ON		.1-sim/12/switch.=.1
-- FLS DATA....................................CHECK
-- BARO REF....................................CHECK
-- === DESCENT
-- DESCENT MONITOR.............................CHECK
-- RATE OF DESCENT AS REQUIRED.................CHECK
-- SPEED BRAKES AS REQUIRED....................CHECK
-- WXR ON EFIS AS REQUIRED.....................CHECK
-- HOLDING PATTERN AS REQUIRED.................CHECK
-- =======================================================

---PRECISION APPROACH
--INITIAL APPROACH
-- SEATBELTS.ON.1-sim/12/switch.=.1
-- APPROACH PHASE.CHECK
-- POSITIONING MONITOR.CHECK
-- MANAGED SPEED.CHECK
-- SPEED BRAKES AS REQUIRED.CHECK
--FINAL APPROACH
-- APP PB FCU.SELECT.AirbusFBW/APPRilluminated.=.1
-- AP.ON.1-sim/misc/AP1status.=.1.or.1-sim/misc/AP2status.=.1
-- FMA.CHECK
-- !!.check that FMS displays the approach capability
-- FLAPS 1.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.9
-- TCAS MODE TA/RA.SET.1-sim/surv/TCASmode.=.1
-- LOC CAPTURE.MONITOR
-- G/S CAPTURE.MONITOR
-- FLAPS 2.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.14
-- GEAR LEVER.DOWN.sim/cockpit/switches/gear_handle_status.=.1
-- AUTOBRAKE.CONFIRM
-- GROUND SPOILERS.ARM.sim/cockpit2/controls/speedbrake_ratio.<.0
-- LANDING LIGHTS.ON.1-sim/10/switch.=.1
-- FLAPS 3.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.19
-- ECAM WHEEL PAGE.SELECT.1-sim/ind/ecamMode.=.3
-- ECAM WHEEL PAGE.CHECK
-- FLAPS FULL.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.30
-- TABLE.STOWED.1-sim/computer.=.0
-- FLIGHT PARAMETERS.CHECK

---NON-PRECISION APPROACH WITH FLS
--INITIAL APPROACH
-- SEATBELTS.ON.1-sim/12/switch.=.1
-- APPROACH PHASE.CHECK
-- POSITIONING MONITOR.CHECK
-- MANAGED SPEED.CHECK
-- SPEED BRAKES AS REQUIRED.CHECK
-- RNP AS REQUIRED.CHECK
-- FLS CAPABILITY.CHECK
-- VOR(ADF) NEEDLES AS REQUIRED.CHECK
--FINAL APPROACH
-- ?.the preferred technique for flying an NPA approach with 
-- ?.the FLS function is to fly a decelerated approach by 
-- ?.using:
-- !!.the AP and FD
-- !!.F-LOC, LOC, or LOC B/C
-- !!.F-G/S
-- !!.the A/THR in SPEED mode
-- !!.the managed speed target
-- APP PB FCU.SELECT.SELECT.AirbusFBW/APPRilluminated.=.1
-- FLYING REFERENCE.TRK-FPA.CHECK
-- FLS CAPABILITY.CHECK
-- FLAPS 1.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.9
-- TCAS MODE TA/RA.SET.1-sim/surv/TCASmode.=.1
-- F-LOC, LOC, or LOC B/C.MONITOR
-- F-G/S CAPTURE.CHECK
-- FPA MODE AS REQUIRED.CHECK
-- F-G/S MODE ENGAGED.CHECK
-- FLAPS 2.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.14
-- GEAR LEVER.DOWN.sim/cockpit/switches/gear_handle_status.=.1
-- AUTOBRAKE.CONFIRM
-- GROUND SPOILERS.ARM.sim/cockpit2/controls/speedbrake_ratio.<.0
-- LANDING LIGHTS.ON.1-sim/10/switch.=.1
-- FLAPS 3.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.19
-- ECAM WHEEL PAGE.SELECT.1-sim/ind/ecamMode.=.3
-- ECAM WHEEL PAGE.CHECK
-- FLAPS FULL.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.30
-- TABLE.STOWED.1-sim/computer.=.0
-- FLIGHT PARAMETERS.CHECK

---NON-PRECISION APPROACH WITHOUT FLS
--INITIAL APPROACH
-- SEATBELTS.ON.1-sim/12/switch.=.1
-- APPROACH PHASE.CHECK
-- POSITIONING MONITOR.CHECK
-- MANAGED SPEED.CHECK
-- SPEED BRAKES AS REQUIRED.CHECK
--FINAL APPROACH
-- ?.the preferred technique for flying an NPA approach  
-- ?.without the FLS function is to fly a decelerated 
-- ?.approach by using:
-- !!.the AP and FD
-- !!.the A/THR in SPEED mode
-- !!.the managed speed target
-- GPS PRIMARY ON POSITION AVAIL.CHECK
-- RNMP FOR APPROACH.CHECK
-- LOC PB.SELECT.1-sim/146/button.=.1
-- FLAPS 1.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.9
-- TCAS MODE TA/RA.SET.1-sim/surv/TCASmode.=.1
-- FPA SET.CHECK
-- FLAPS 2.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.14
-- GEAR LEVER.DOWN.sim/cockpit/switches/gear_handle_status.=.1
-- AUTOBRAKE.CONFIRM
-- GROUND SPOILERS.ARM.sim/cockpit2/controls/speedbrake_ratio.<.0
-- LANDING LIGHTS.ON.1-sim/10/switch.=.1
-- FLAPS 3.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.19
-- ECAM WHEEL PAGE.SELECT.1-sim/ind/ecamMode.=.2
-- ECAM WHEEL PAGE.CHECK
-- FLAPS FULL.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.30
-- TABLE.STOWED.1-sim/computer.=.0
-- FLIGHT PARAMETERS.CHECK

---VISUAL APPROACH
--VISUAL APPROACH
-- ?.perform the approach on a nominal 3 deg glideslope 
-- ?.using visual references
-- ?.the approach should be stabilized by 500ft above airfield
-- ?.elevations on the correct approach path, in the landing 
-- ?.configuration at VAPP
-- ACTIVATE APPR ON FMS.CHECK
-- FD PB.OFF.sim/cockpit/autopilot/autopilot_mode.=.0
-- TRK-FPA PB SELECTED.CHECK
-- A/THR.ON.sim/cockpit2/autopilot/autothrottle_enabled.=.1
-- FLAPS 1.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.9
-- TCAS MODE TA/RA.SET.1-sim/surv/TCASmode.=.1
-- FPA SET.CHECK
-- FLAPS 2.SELECT.sim/flightmodel2/wing/flap2_deg[3].>.14
-- GEAR LEVER.DOWN.sim/cockpit/switches/gear_handle_status.=.1
-- AUTOBRAKE.CONFIRM
-- GROUND SPOILERS.ARM.sim/cockpit2/controls/speedbrake_ratio.<.0
-- LANDING LIGHTS.ON.1-sim/10/switch.=.1

-- ======================= LANDING =======================
-- === MANUAL
-- AP............................................OFF		.1-sim/misc/AP1status.=.1.or.1-sim/misc/AP2status.=.0
-- FLARE INITIATE..............................CHECK
-- ATTITUDE..................................MONITOR
-- THRUST LEVERS................................IDLE		.1-sim/R/throttle.=.0.and.1-sim/L/throttle.=.0
-- === AUTOMATIC
-- FMA.........................................CHECK
-- FLARE.....................................MONITOR
-- THRUST LEVERS................................IDLE		.1-sim/R/throttle.=.0.and.1-sim/L/throttle.=.0
-- LATERAL GUIDANCE..........................MONITOR
--   FOLLOW IN BOTH CASES
-- DEROTATION INITIATE.........................CHECK
-- REV..........................................PULL		.?.sim/flightmodel/failures/onground_all.=.1.1-sim/R/reverser.>.0.zero/zero.=.1
-- GROUND SPOILERS............................DEPLOY		.sim/cockpit2/controls/speedbrake_ratio.>.0
-- REVERSERS...................................CHECK
-- AUTOBRAKE.................................MONITOR
-- DECELERATION................................CHECK
-- REV..........................................IDLE		.sim/flightmodel/position/groundspeed.<.40.and.1-sim/ind/eng/curTHR/L.<.5
-- REV..........................................STOW		.sim/flightmodel/position/groundspeed.<.10.and.1-sim/R/reverser.=.0
-- AUTOBRAKE DISARMED..........................CHECK
-- AP.....................................DISCONNECT		.1-sim/misc/AP1status.=.0.or.1-sim/misc/AP2status.=.0

-- ====================== GO AROUND ======================
-- THRUST LEVER TOGA.............................SET		.1-sim/R/throttle.=.1.and.1-sim/L/throttle.=.1
-- ROTATION....................................CHECK
-- FMA MAN TOGO, SRS, GA, TRK..................CHECK
-- GEAR LEVER.....................................UP		.sim/cockpit/switches/gear_handle_status.=.0
-- NAV MODE...................................SELECT		.AirbusFBW/NDmodeCapt.=.2.or.AirbusFBW/NDmodeFO.=.2
-- THRUST LEVERS CL............................CHECK
-- FLAPS ON SCHEDULE...........................CHECK
-- == FROM AN INTERMEDIATE APPROACH ALTITUDE
--   apply the following steps in order to interrupt the
--   approach, or perform a go-around, when the aircraft
--   is at an intermediate altitude and if TOGA is not 
--   required
-- THRUST LEVERS TOGA, THEN RETARD.............CHECK
-- APPLICABLE AP/FD...........................SELECT
--   apply the following steps in order to interrupt an
--   ILS, GLS approach, or an approach using FLS, and 
--   perform a go-around when the aircraft is above the
--   missed approach altitude and TOGA is not required
-- LOC.........................................PRESS		.1-sim/146/button.=.1
-- ALT.......................................MONITOR
-- SPEED........................................PULL		.1-sim/fcu/spdPull.>.0
-- FLAPS RETRACT ONE STEP......................CHECK
-- HDG..........................................PULL		.1-sim/fcu/hdgPull.>.0
-- NAV MODE...................................SELECT		.AirbusFBW/NDmodeCapt.=.2.or.AirbusFBW/NDmodeFO.=.2
-- =======================================================

-- ==================== AFTER LANDING ====================
-- GROUND SPOILERS............................DISARM		.sim/cockpit2/controls/speedbrake_ratio.=.0
-- FLAPS ZERO.................................SELECT		.1-sim/flaphandle.=.1
-- APU MASTER SW..................................ON		.1-sim/125/button.=.1
-- APU PAGE ON SD..............................CHECK
-- APU START PB...................................ON		.1-sim/126/button.=.1
--   wait for APU AVAIL sign
-- APU AVAIL.................................CONFIRM		.sim/cockpit/engine/APU_N1.>.97
-- APU BLEED PB...................................ON		.1-sim/111/button.=.1
-- ENG START SELECTOR...........................NORM		.1-sim/eng/startSwitch.=.1
-- ANTI-ICE AS REQUIRED........................CHECK
-- LANDING LIGHTS................................OFF		.1-sim/10/switch.=.0
-- NOSE LIGHTS..................................TAXI		.1-sim/11/switch.=.1
-- RWY TURN OFF LIGHTS............................ON		.1-sim/8/switch.=.1
-- STROBE LIGHTS.................................OFF		.1-sim/2/switch.=.0
-- ND ZOOM AS REQUIRED.........................CHECK
-- WX ON EFIS CP OFF...........................CHECK
-- TERR ON EFIS CP OFF.........................CHECK
-- BRAKE TEMPERATURE.........................MONITOR
-- =======================================================

-- ======================= PARKING =======================
-- NOSE LIGHTS...................................OFF		.1-sim/11/switch.=.2
-- RWY TURN OFF LIGHTS...........................OFF		.1-sim/8/switch.=.0
-- ANTI-ICE WING.................................OFF		.1-sim/117/button.=.0
-- ANTI-ICE AUTO MODE............................OFF		.1-sim/118/button.=.0
-- ANTI-ICE ENG..................................OFF		.1-sim/119/button.=.0.and.1-sim/120/button.=.0
-- ANTI-ICE PROBE................................OFF		.1-sim/121/button.=.0
-- PARK BRK.......................................ON		.1-sim/parckBrake.=.0
-- ENG MASTER SWITCHES...........................OFF		.1-sim/eng/cutoff/L/switch.=.1.and.1-sim/eng/cutoff/R/switch.=.1
-- SEATBELTS SELECTOR............................OFF		.1-sim/12/switch.=.0
-- BEACON........................................OFF		.1-sim/3/switch.=.0
-- FUEL PUMP 1...................................OFF		.1-sim/68/button.=.0.and.1-sim/69/button.=.0
-- FUEL PUMP 2...................................OFF		.1-sim/81/button.=.0.and.1-sim/82/button.=.0
-- =======================================================

-- ================ SECURING THE AIRCRAFT ================
-- PARK BRK.......................................ON		.1-sim/parckBrake.=.0
-- OXYGEN CREW...................................OFF		.1-sim/38/button.=.0
-- ADIRS SELECTOR 1..............................OFF		.1-sim/adirs/1/switch.=.0
-- ADIRS SELECTOR 2..............................OFF		.1-sim/adirs/2/switch.=.0
-- ADIRS SELECTOR 3..............................OFF		.1-sim/adirs/3/switch.=.0
-- APU BLEED PB..................................OFF		.1-sim/111/button.=.0
--   if available
-- EXT PWR 1......................................ON		.?.1-sim/elec/gpu1ON.=.1.1-sim/97/button.=.1.zero/zero.=.0
--   if available
-- EXT PWR 2......................................ON		.?.1-sim/elec/gpu2ON.=.1.1-sim/104/button.=.1.zero/zero.=.0
-- APU MASTER SW PB-SW...........................OFF		.1-sim/125/button.=.0
-- NO SMOKING SELECTOR...........................OFF		.1-sim/13/switch.=.0
-- WIRELESS......................................OFF		.1-sim/15/button.=.0
-- CABIN SATCOM..................................OFF		.1-sim/17/button.=.0
-- LANDING CAMERA................................OFF		.1-sim/18/button.=.0
-- FAR 4.........................................OFF		.1-sim/19/button.=.0.and.1-sim/20/button.=.0
-- AFEX..........................................OFF		.1-sim/21/button.=.0
-- DER...........................................OFF		.1-sim/22/button.=.0
-- CROSS FEED....................................OFF		.1-sim/78/button.=.0.and.1-sim/79/button.=.0
-- MAIN FUEL PUMPS...............................OFF		.1-sim/68/button.=.0.and.1-sim/81/button.=.0
-- STBY FUEL PUMPS...............................OFF		.1-sim/69/button.=.0.and.1-sim/82/button.=.0
-- 1 & 2 FUEL PUMPS..............................OFF		.1-sim/70/button.=.0.and.1-sim/80/button.=.0
-- CTR TK FEED PB................................OFF		.1-sim/84/button.=.0
-- TRANSFER FEEDs................................OFF		.1-sim/83/button.=.0.and.1-sim/85/button.=.0
-- MAINTENANCE PANEL ALL WHITE LTS OFF.........CHECK
-- BAT 1.........................................OFF		.1-sim/86/button.=.0
-- BAT EMER 1....................................OFF		.1-sim/87/button.=.0
-- BAT EMER 2....................................OFF		.1-sim/88/button.=.0
-- BAT 2.........................................OFF		.1-sim/89/button.=.0
-- =======================================================


-- ======================================================================================

-- ================= ELECTRICAL POWER-UP =================
-- All paper work on board and checked
-- M E L and Technical Logbook checked
-- 
-- === Initial checks
-- CIRCUIT BREAKERS.....................CHECK ALL IN (F/O)
-- AIRCRAFT ON BAT PWR.........................CHECK (F/O) 
--   Check that no AC/DC power source is active
-- ENG MASTER SWITCHES...........................OFF (F/O) .1-sim/eng/cutoff/L/switch.=.1.and.1-sim/eng/cutoff/R/switch.=.1
-- ENG START SELECTOR...........................NORM (F/O) .1-sim/eng/startSwitch.=.1)
-- WIPERS SELECTORS..............................OFF (F/O) .1-sim/misc/wiper/L/switch.=.2  1-sim/misc/wiper/R/switch)
-- GEAR LEVER...................................DOWN (F/O) .sim/cockpit/switches/gear_handle_status.=.1
-- FLAP LEVER...................................ZERO (F/O) .1-sim/flaphandle.=.1

-- === Batteries on
-- BAT 1..........................................ON (F/O) 
-- BAT EMER 1.....................................ON (F/O) 
-- BAT EMER 2.....................................ON (F/O) 
-- BAT 2..........................................ON (F/O) 

-- ==== Activate External Power
--   Activate external power in Ground Services menu
--   EXT PWR 1....................................ON (F/O) .?.1-sim/elec/gpu1ON.=.1.1-sim/97/button.=.1.zero/zero.=.0
--   EXT PWR 2....................................ON (F/O) .?.1-sim/elec/gpu2ON.=.1.1-sim/104/button.=.1.zero/zero.=.0

-- ==== Activate APU 
--   APU FIRE PB-SW..........................GUARDED (F/O)	.1-sim/38/cover.=.0
--   APU AGENT LIGHT OFF.......................CHECK (F/O)	. light dataref when activated
--   ENG 1 FIRE PB-SW........................GUARDED (F/O)	.1-sim/37/cover.=.0
--   ENG 2 FIRE PB-SW........................GUARDED (F/O)	.1-sim/39/cover.=.0
--   ALL ENG AGENT LIGHTS OFF..................CHECK (F/O)	light datarefs
--   TEST PB....................................PUSH (F/O)	.1-sim/fire/test.=.1
--   RESULT....................................CHECK (F/O)
--     - continuous repetitive chime sounds
--     - master warning light flash
--     - ECAM red alert ENG 1(2) FIRE, APU FIRE
--     - all ENG and APU PB-SW red
--     - all DISCH lights on
--     - ALL FIRE lights on ENG MASTER on
--   APU MASTER SW..................................ON       .1-sim/125/button.=.1
--   APU PAGE ON SD..............................CHECK
--   APU START PB...................................ON       .1-sim/126/button.=.1
--     wait for APU AVAIL sign
--   APU AVAIL.................................CONFIRM       .sim/cockpit/engine/APU_N1.>.97
--   ELECTRICAL POWER UP.......................CONFIRM
-- =======================================================


local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP","performing ELECTRICAL POWER UP","Power up finished")
electricalPowerUpProc:setFlightPhase(1)
electricalPowerUpProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("== Initial Checks"))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",FlowItem.actorFO,0,true))
electricalPowerUpProc:addItem(ProcedureItem:new("DC POWER SWITCH","BAT",FlowItem.actorFO,0,
	function () return sysElectric.dcPowerSwitch:getStatus() == sysElectric.dcPwrBAT end,
	function () sysElectric.dcPowerSwitch:actuate(sysElectric.dcPwrBAT) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("BATTERY VOLTAGE","CHECK MIN 24V",FlowItem.actorFO,0,"bat24v",
	function () return get("laminar/B738/dc_volt_value") > 23 end))
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.batteryCover:getStatus() == 0 end,
	function () 
		kc_macro_ext_lights_off()
		sysElectric.batteryCover:actuate(0) 
		kc_macro_int_lights_on()
	end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPowerCover:getStatus() == 1 end,
	function () sysElectric.stbyPowerCover:actuate(1) end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Hydraulic System"))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () kc_macro_hydraulic_initial() end))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("FLAP LEVER","UP",FlowItem.actorFO,0,"initial_flap_lever",
	function () return sysControls.flapsSwitch:getStatus() == 0 end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Ensure flap lever agrees with indicated flap position."))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  In Cold&Dark in SIM this is the UP position."))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Other"))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(modeOff) end))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GREEN LANDING GEAR LIGHT","CHECK ILLUMINATED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsAnc:getStatus() == modeOn end))
electricalPowerUpProc:addItem(ProcedureItem:new("  RED LANDING GEAR LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysGeneral.gearLightsRed:getStatus() == modeOff end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",FlowItem.actorFO,3,"takeoff_config_warn",
	function () return get("laminar/B738/system/takeoff_config_warn") > 0 end,
	function () 
		kc_procvar_set("toctest",true) -- background test
	end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Use Zibo EFB to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,
	function () 
		kc_macro_gpu_connect()
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GROUND POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:step(cmdDown) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  OVHT DET SWITCH","NORMAL",FlowItem.actorFO,0,true,
	function () sysElectric.gpuSwitch:step(cmdUp) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,0,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () 
		kc_procvar_set("ovhttest",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,0,true,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",FlowItem.actorFO,0,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,
	function () 
		kc_procvar_set("ext1test",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",FlowItem.actorFO,0,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,
	function () 
		kc_procvar_set("ext2test",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_procvar_set("apustart",true) -- background start
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  #spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

electricalPowerUpProc:addItem(SimpleProcedureItem:new("==== "))
electricalPowerUpProc:addItem(ProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(ProcedureItem:new("SOURCE OFF LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.sourceOff1:getStatus() == modeOff and sysElectric.sourceOff2:getStatus() == modeOff end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",FlowItem.actorFO,0,
	function () return get("laminar/B738/electric/standby_bat_pos") > 0 end))
electricalPowerUpProc:addItem(ProcedureItem:new("   STANDBY #exchange|PWR|POWER# LIGHT","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPwrOff:getStatus() == modeOff end))

-- ============ PRELIMINARY PREFLIGHT PROCEDURES =========
-- EMERGENCY EXIT LIGHT..........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON...........................PRESS (F/O)
-- ELECTRICAL POWER UP......................COMPLETE (F/O)
-- FLIGHT DATA RECORDER SWITCH..................AUTO (F/O)
-- MACH OVERSPEED TEST.......................PERFORM (F/O)
-- VOICE RECORDER SWITCH........................AUTO (F/O)

-- ==== Engine Panel
-- EEC SWITCHES...................................ON (F/O)
-- EEC GUARDS.................................CLOSED (F/O)
-- EEC FAIL LIGHTS......................EXTINGUISHED (F/O)
-- REVERSER FAIL LIGHTS.................EXTINGUISHED (F/O)

-- ==== IRS Alignment
-- IRS MODE SELECTORS............................OFF (F/O)
-- IRS MODE SELECTORS.......................THEN NAV (F/O)
--   Verify ON DC lights illuminate then extinguish
--   Verify ALIGN lights are illuminated     
      
-- ==== Other
-- XPDR.....................................SET 2000 (F/O)
-- COCKPIT LIGHTS......................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS..........SET AS REQUIRED (F/O)
-- FUEL PUMPS................................ALL OFF (F/O)
-- FUEL CROSS FEED...............................OFF (F/O)
-- POSITION LIGHTS................................ON (F/O)
-- MCP....................................INITIALIZE (F/O)
-- PARKING BRAKE.................................SET (F/O)
-- GPWS SYSTEM TEST..........................PERFORM (F/O)
-- IFE & GALLEY POWER.............................ON (F/O)

-- Electric hydraulic pumps on for F/O walk-around
-- ELECTRIC HYDRAULIC PUMPS SWITCHES..............ON (F/O)
-- =======================================================

-- Check fluids
-- OIL QUANTITY
-- HYDRAULIC QUANTITY
-- OXYGEN BOTTLE

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight","I finished the preliminary preflight")
prelPreflightProc:setFlightPhase(2)
prelPreflightProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM #exchange|/ON GUARD CLOSED| #",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0  end,
	function () sysGeneral.emerExitLightsCover:actuate(0) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",FlowItem.actorFO,0,"attendence_button",
	function () return sysGeneral.attendanceButton:getStatus() > modeOff end,
	function () sysGeneral.attendanceButton:repeatOn() end))
prelPreflightProc:addItem(ProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",FlowItem.actorFO,0,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 0 or
		sysElectric.gpuOnBus:getStatus() == 1
	end,
	function () sysGeneral.attendanceButton:repeatOff() end))
prelPreflightProc:addItem(ProcedureItem:new("FLIGHT DATA RECORDER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return  sysGeneral.fdrSwitch:getStatus() == modeOff and sysGeneral.fdrCover:getStatus() == modeOff end,
	function () sysGeneral.fdrSwitch:actuate(modeOn) sysGeneral.fdrCover:actuate(modeOff) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST 1","PERFORM",FlowItem.actorFO,0,"mach_ovspd_test1",
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 end,
	function () 
		kc_procvar_set("mach1test",true) -- background test
	end))
prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST 2","PERFORM",FlowItem.actorFO,0,"mach_ovspd_test2",
	function () return get("laminar/B738/push_button/mach_warn2_pos") == 1 end,
	function () 
		kc_procvar_set("mach2test",true) -- background test
	end))
prelPreflightProc:addItem(ProcedureItem:new("VOICE RECORDER SWITCH","AUTO",FlowItem.actorFO,0,
	function () return  sysGeneral.vcrSwitch:getStatus() == 0 end,
	function () sysGeneral.vcrSwitch:actuate(modeOn) end))

prelPreflightProc:addItem(SimpleProcedureItem:new("==== Engine Panel"))
prelPreflightProc:addItem(ProcedureItem:new("EEC SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysEngines.eecSwitchGroup:getStatus() == 0 end,
	function () sysEngines.eecSwitchGroup:actuate(1) end))
prelPreflightProc:addItem(ProcedureItem:new("EEC GUARDS","CLOSED",FlowItem.actorFO,0,
	function () return sysEngines.eecGuardGroup:getStatus() == 0 end,
	function () sysEngines.eecGuardGroup:actuate(0) end))
prelPreflightProc:addItem(ProcedureItem:new("EEC FAIL LIGHTS","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysEngines.fadecFail:getStatus() == 0 end))
prelPreflightProc:addItem(ProcedureItem:new("REVERSER FAIL LIGHTS","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysEngines.reversersFail:getStatus() == 0 end))

prelPreflightProc:addItem(SimpleProcedureItem:new("==== IRS Alignment"))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","OFF",FlowItem.actorFO,0,"irs_mode_initial_off",
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitOFF) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","ALIGN",FlowItem.actorFO,0,"irs_mode_align",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitALIGN*2 end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitALIGN) end))
prelPreflightProc:addItem(SimpleProcedureItem:new("  Verify ON DC lights illuminate then extinguish"))
prelPreflightProc:addItem(IndirectProcedureItem:new("  IRS LEFT ALIGN LIGHT","ILLUMINATES",FlowItem.actorFO,0,"irs_left_align",
	function () return sysGeneral.irs1Align:getStatus() == modeOn end))
prelPreflightProc:addItem(IndirectProcedureItem:new("  IRS RIGHT ALIGN LIGHT","ILLUMINATES",FlowItem.actorFO,0,"irs_right_align",
	function () return sysGeneral.irs2Align:getStatus() == modeOn end))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",FlowItem.actorFO,0,"irs_mode_nav_again",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitNAV*2 end,
	function () sysGeneral.irsUnitGroup:actuate(sysGeneral.irsUnitNAV) end))
	
prelPreflightProc:addItem(SimpleProcedureItem:new("==== Other"))

prelPreflightProc:addItem(ProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",FlowItem.actorFO,0,
	function () return sysRadios.xpdrCode:getStatus() == 2000 end,
	function () sysRadios.xpdrCode:actuate(2000) end))
prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or -1) end))
prelPreflightProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () 
		sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) 
		sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) 
	end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))
prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON",FlowItem.actorFO,0,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(ProcedureItem:new("#spell|MCP#","INITIALIZE",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		kc_macro_glareshield_initial()
		sysEFIS.mtrsPilot:actuate(modeOff)
		sysEFIS.fpvPilot:actuate(modeOff)
	end))
prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(IndirectProcedureItem:new("GPWS SYSTEM TEST","PERFORM",FlowItem.actorFO,0,"gpws_test",
	function () return get("laminar/B738/system/gpws_test_running") > 0 end,
	function () 
		kc_procvar_set("gpwstest",true) -- background test
	end))
prelPreflightProc:addItem(ProcedureItem:new("#spell|IFE# & GALLEY POWER","ON",FlowItem.actorFO,0,
	function () return sysElectric.ifePwr:getStatus() == modeOn and sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () 
		sysElectric.ifePwr:actuate(modeOn) 
		sysElectric.cabUtilPwr:actuate(modeOn) 
	end))
prelPreflightProc:addItem(SimpleProcedureItem:new("Electric hydraulic pumps on for F/O walk-around"))
prelPreflightProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () 
		sysHydraulic.elecHydPumpGroup:actuate(modeOn) 
		kc_wnd_brief_action=1
	end))

-- ==================== CDU Preflight ====================
-- ==== INITIAL DATA (CPT)                              
--   IDENT page:................................OPEN (CPT)
--     Verify Model and ENG RATING                 
--     Verify navigation database ACTIVE date      
--   POS INIT page:.............................OPEN (CPT)
--     Verify time                                 
--     REF AIRPORT...............................SET (CPT)
-- ==== NAVIGATION DATA (CPT)                           
--   RTE page:..................................OPEN (CPT)
--     ORIGIN....................................SET (CPT)
--     DEST......................................SET (CPT)
--     FLT NO....................................SET (CPT)
--     ROUTE...................................ENTER (CPT)
--     ROUTE................................ACTIVATE (CPT)
--     ROUTE.................................EXECUTE (CPT)
--   DEPARTURES page:...........................OPEN (CPT)
--     Select runway and departure routing         
--     ROUTE:................................EXECUTE (CPT)
--   LEGS page:.................................OPEN (CPT)
--     Verify or enter correct RNP for departure   
-- ==== PERFORMANCE DATA (CPT)                          
--   PERF INIT page:............................OPEN (CPT)
--     ZFW.....................................ENTER (CPT)
--     GW...............................ENTER/VERIFY (CPT)
--     RESERVES.........................ENTER/VERIFY (CPT)
--     COST INDEX..............................ENTER (CPT)
--     CRZ ALT.................................ENTER (CPT)
--   N1 LIMIT page:.............................OPEN (CPT)
--     Select assumed temp and/or fixed t/o rating 
--     Select full or derated climb thrust         
--   TAKEOFF REF page:..........................OPEN (CPT)
--     FLAPS...................................ENTER (CPT)
--     CG......................................ENTER (CPT)
--     V SPEEDS................................ENTER (CPT)
-- PREFLIGHT COMPLETE?........................VERIFY (CPT)
-- PREPARE KPCREW DEPARTURE BRIEFING
-- =======================================================


local cduPreflightProc = Procedure:new("CDU PREFLIGHT (OPTIONAL)")
cduPreflightProc:setFlightPhase(2)
cduPreflightProc:addItem(SimpleProcedureItem:new("OBTAIN CLERANCE FROM ATC"))
cduPreflightProc:addItem(SimpleProcedureItem:new("==== INITIAL DATA (CPT)"))
cduPreflightProc:addItem(IndirectProcedureItem:new("  IDENT page:","OPEN",FlowItem.actorCPT,0,"ident_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"IDENT") end,
	function () kc_wnd_brief_action=1 end))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify Model and ENG RATING"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(IndirectProcedureItem:new("  POS INIT page:","OPEN",FlowItem.actorCPT,0,"pos_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"POS INIT") end))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(IndirectProcedureItem:new("    REF AIRPORT","SET",FlowItem.actorCPT,0,"ref_airport_set",
	function () return sysFMC.fmcRefAirportSet:getStatus() end))
cduPreflightProc:addItem(SimpleProcedureItem:new("==== NAVIGATION DATA (CPT)"))
cduPreflightProc:addItem(IndirectProcedureItem:new("  RTE page:","OPEN",FlowItem.actorCPT,0,"rte_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"RTE ") end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    ORIGIN","SET",FlowItem.actorCPT,0,"origin_set",
	function () return sysFMC.fmcOrigin:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    DEST","SET",FlowItem.actorCPT,0,"dest_set",
	function () return sysFMC.fmcDestination:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    FLT NO","SET",FlowItem.actorCPT,0,"flt_no_entered",
	function () return sysFMC.fmcFltNo:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    ROUTE","ENTER",FlowItem.actorCPT,0,"route_entered",
	function () return sysFMC.fmcRouteEntered:getStatus() == true end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    ROUTE","ACTIVATE",FlowItem.actorCPT,0,"route_activated",
	function () return sysFMC.fmcRouteActivated:getStatus() == true end))
cduPreflightProc:addItem(ProcedureItem:new("    ROUTE","EXECUTE",FlowItem.actorCPT,0,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("  DEPARTURES page:","OPEN",FlowItem.actorCPT,0,"departures_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"DEPARTURES") end))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(ProcedureItem:new("    ROUTE:","EXECUTE",FlowItem.actorCPT,0,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("  LEGS page:","OPEN",FlowItem.actorCPT,0,"legs_page_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"LEGS") end))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(SimpleProcedureItem:new("==== PERFORMANCE DATA (CPT)"))
cduPreflightProc:addItem(IndirectProcedureItem:new("  PERF INIT page:","OPEN",FlowItem.actorCPT,0,"perf_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"PERF INIT") end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    ZFW","ENTER",FlowItem.actorCPT,0,"zfw_entered",
	function () return sysFMC.fmcZFWEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    GW","ENTER/VERIFY",FlowItem.actorCPT,0,"gw_entered",
	function () return sysFMC.fmcGWEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    RESERVES","ENTER/VERIFY",FlowItem.actorCPT,0,"reserves_entered",
	function () return sysFMC.fmcReservesEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    COST INDEX","ENTER",FlowItem.actorCPT,0,"cost_index_entered",
	function () return sysFMC.fmcCIEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    CRZ ALT","ENTER",FlowItem.actorCPT,0,"crz_alt_entered",
	function () return sysFMC.fmcCrzAltEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("  N1 LIMIT page:","OPEN",FlowItem.actorCPT,0,"n1_limit_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"N1 LIMIT") end))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(IndirectProcedureItem:new("  TAKEOFF REF page:","OPEN",FlowItem.actorCPT,0,"takeoff_ref_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"TAKEOFF REF") end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    FLAPS","ENTER",FlowItem.actorCPT,0,"flaps_entered",
	function () return sysFMC.fmcFlapsEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    CG","ENTER",FlowItem.actorCPT,0,"cg_entered",
	function () return sysFMC.fmcCGEntered:getStatus() end))
cduPreflightProc:addItem(IndirectProcedureItem:new("    V SPEEDS","ENTER",FlowItem.actorCPT,0,"vspeeds_entered",
	function () return sysFMC.fmcVspeedsEntered:getStatus() == true end))
cduPreflightProc:addItem(SimpleProcedureItem:new("FILL OUT KPCREW DEPARTURE BRIEFING!!"))

-- ================ Preflight Procedure ==================
-- STALL WARNING TEST........................PERFORM (F/O)
--   Wait for 4 minutes AC power if not functioning
-- ELECTRIC HYDRAULIC PUMP SWITCHES..............OFF (F/O)
-- ==== Flight control panel                            
-- FLIGHT CONTROL SWITCHES.............GUARDS CLOSED (F/O)
-- FLIGHT SPOILER SWITCHES.............GUARDS CLOSED (F/O)
-- ALTERNATE FLAPS MASTER SWITCH........GUARD CLOSED (F/O)
-- ALTERNATE FLAPS CONTROL SWITCH................OFF (F/O)
-- FLAPS PANEL ANNUNCIATORS.............EXTINGUISHED (F/O)
-- YAW DAMPER SWITCH..............................ON (F/O)

-- ==== NAVIGATION & DISPLAYS panel                     
-- VHF NAV TRANSFER SWITCH....................NORMAL (F/O)
-- IRS TRANSFER SWITCH........................NORMAL (F/O)
-- FMC TRANSFER SWITCH........................NORMAL (F/O)
-- SOURCE SELECTOR..............................AUTO (F/O)
-- CONTROL PANEL SELECT SWITCH................NORMAL (F/O)

-- ==== Fuel panel                                      
-- FUEL PUMP SWITCHES........................ALL OFF (F/O)
--   If APU running turn one of the left fuel pumps on
-- FUEL VALVE ANNUNCIATORS.................CHECK DIM (F/O)
-- FUEL CROSS FEED.......................ON FOR TEST (F/O)
-- CROSS FEED VALVE LIGHT..................CHECK DIM (F/O)
-- FUEL CROSS FEED...............................OFF (F/O)
-- CROSS FEED VALVE LIGHT...............EXTINGUISHED (F/O)

-- ==== Electrical panel                                
-- BATTERY SWITCH.......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH..........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH.....................ON (F/O)
-- STANDBY POWER SWITCH.................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES.......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH..................GUARD CLOSED (F/O)

-- ==== APU start if required
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH..................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT.......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH............TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 2 TO RIGHT (F/O)
-- APU PANEL
-- APU SWITCH..................................START (F/O)
--   Hold APU switch in START position for 3-4 seconds.
-- APU GEN OFF BUS LIGHT.................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES.....................ON (F/O)

-- ==== Overhead items
-- EQUIPMENT COOLING SWITCHES...................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH.........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH..............................ON (F/O)
-- FASTEN BELTS SWITCH............................ON (F/O)
-- WINDSHIELD WIPER SELECTORS...................PARK (F/O)

-- ==== Anti-Ice
-- WINDOW HEAT SWITCHES...........................ON (F/O)
-- WINDOW HEAT ANNUNCIATORS............. ILLUMINATED (F/O)
-- PROBE HEAT SWITCHES...........................OFF (F/O)
-- WING ANTI-ICE SWITCH..........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES......................OFF (F/O)
-- =======================================================

local preflightFOProc = Procedure:new("PREFLIGHT PROCEDURE","running preflight procedure","preflight setup finished")
preflightFOProc:setResize(false)
preflightFOProc:setFlightPhase(3)
preflightFOProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",FlowItem.actorFO,0,"stall_warning_test1",
	function () return get("laminar/B738/push_button/stall_test1") == 1 end,
	function () 
		kc_procvar_set("stall1test",true) -- background test
	end))
preflightFOProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST 2","PERFORM",FlowItem.actorFO,0,"stall_warning_test",
	function () return get("laminar/B738/push_button/stall_test2") == 1 end,
	function () 
		kc_procvar_set("stall2test",true) -- background test
	end))
preflightFOProc:addItem(SimpleProcedureItem:new("  Wait for 4 minutes AC power if not functioning"))
preflightFOProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Flight control panel"))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysControls.fltCtrlCovers:getStatus() == 0 end,
	function () sysControls.fltCtrlCovers:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysControls.spoilerCovers:getStatus() == 0  end,
	function () sysControls.spoilerCovers:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ALTERNATE FLAPS CONTROL SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysControls.altFlapsCtrl:getStatus() == 0 end,
	function () sysControls.altFlapsCtrl:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("FLAPS PANEL ANNUNCIATORS","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysControls.flapsPanelStatus:getStatus() == 0 end))
preflightFOProc:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysControls.yawDamper:getStatus() == modeOn end,
	function () sysControls.yawDamper:actuate(modeOn) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== NAVIGATION & DISPLAYS panel"))
preflightFOProc:addItem(ProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.vhfNavSwitch:getStatus() == 0 end,
	function () sysMCP.vhfNavSwitch:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.irsNavSwitch:getStatus() == 0 end,
	function () sysMCP.irsNavSwitch:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.fmcNavSwitch:getStatus() == 0 end,
	function () sysMCP.fmcNavSwitch:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("SOURCE SELECTOR","AUTO",FlowItem.actorFO,0,
	function() return sysMCP.displaySourceSwitch:getStatus() == 0 end,
	function () sysMCP.displaySourceSwitch:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",FlowItem.actorFO,0,
	function() return sysMCP.displayControlSwitch:getStatus() == 0 end,
	function () sysMCP.displayControlSwitch:setValue(0) end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== Fuel panel"))
preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(ProcedureItem:new("FUEL VALVE ANNUNCIATORS","DIM",FlowItem.actorFO,0,
	function () return sysFuel.valveAnns:getStatus() == 1 end))
preflightFOProc:addItem(IndirectProcedureItem:new("FUEL CROSS FEED","ON FOR TEST",FlowItem.actorFO,0,"xfeedtest",
	function () return sysFuel.crossFeed:getStatus() == modeOn end,
	function () sysFuel.crossFeed:actuate(modeOn) end))
preflightFOProc:addItem(IndirectProcedureItem:new("CROSS FEED VALVE","CHECK DIM",FlowItem.actorFO,0,"xfeeddim",
	function () return sysFuel.xfeedVlvAnn:getStatus() > 0 end))
preflightFOProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF",FlowItem.actorFO,0,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))
preflightFOProc:addItem(ProcedureItem:new("CROSS FEED VALVE","EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysFuel.xfeedVlvAnn:getStatus() == 0 end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Electrical panel"))
preflightFOProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
preflightFOProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("#spell|IFE# POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.ifePwr:getStatus() == modeOn end,
	function () sysElectric.ifePwr:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.stbyPowerCover:getStatus() == modeOff end,
	function () sysElectric.stbyPowerCover:actuate(modeOff) end))
preflightFOProc:addItem(ProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.genDriveCovers:getStatus() == 0 end))
preflightFOProc:addItem(ProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysElectric.busTransCover:getStatus() == 0 end,
	function () sysElectric.busTransCover:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== APU start if required",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("OVHT DET SWITCH","NORMAL",FlowItem.actorFO,0,true,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(IndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",FlowItem.actorFO,0,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () 
		kc_procvar_set("ovhttest",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",FlowItem.actorFO,0,true,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",FlowItem.actorFO,0,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,
	function () 
		kc_procvar_set("ext1test",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",FlowItem.actorFO,0,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,
	function () 
		kc_procvar_set("ext2test",true) -- background test 
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("#spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_procvar_set("apustart",true) -- background start
	end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(SimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(IndirectProcedureItem:new("#spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_off",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("#spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",FlowItem.actorFO,0,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Overhead items"))
preflightFOProc:addItem(ProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",FlowItem.actorFO,0,
	function () return sysGeneral.equipCoolExhaust:getStatus() == modeOff and sysGeneral.equipCoolSupply:getStatus() == 0 end,
	function () sysGeneral.equipCoolExhaust:actuate(modeOff) sysGeneral.equipCoolSupply:actuate(modeOff) end))
preflightFOProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsCover:getStatus() == 0 end,
	function () sysGeneral.emerExitLightsCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("NO SMOKING SWITCH","ON OR AUTO",FlowItem.actorFO,0,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:setValue(1) end))
preflightFOProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON OR AUTO",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
	end))
preflightFOProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",FlowItem.actorFO,0,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Anti-Ice"))
preflightFOProc:addItem(ProcedureItem:new("WINDOW HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightFOProc:addItem(IndirectProcedureItem:new("WINDOW HEAT ANNUNCIATORS","ILLUMINATED",FlowItem.actorFO,0,"towindowheat",
		function () return sysAice.windowHeatAnns:getStatus() == 4 end))
preflightFOProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))

-- ========== PREFLIGHT PROCEDURE PART 2 (F/O) ===========
-- ==== Hydraulic panel                                 
-- ENGINE HYDRAULIC PUMPS SWITCHES................ON (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES.............OFF (F/O)

-- ==== Air conditioning panel                          
-- AIR TEMPERATURE SOURCE SELECTOR...........FWD CAB (F/O)
-- CABIN TEMPERATURE SELECTORS.....AUTO OR AS NEEDED (F/O)
-- TRIM AIR SWITCH................................ON (F/O)
-- RECIRCULATION FAN SWITCHES...................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES.......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH...............AUTO OR OPEN (F/O)
-- ENGINE BLEED AIR SWITCHES......................ON (F/O)
-- APU BLEED AIR SWITCH..................AS REQUIRED (F/O)
--  If APU running turn it ON

-- ==== Cabin pressurization panel                      
-- FLIGHT ALTITUDE INDICATOR.........CRUISE ALTITUDE (F/O)
-- LANDING ALTITUDE INDICATOR........FIELD ELEVATION (F/O)
-- PRESSURIZATION MODE SELECTOR.................AUTO (F/O)

-- ==== Lighting panel                                  
-- LANDING LIGHT SWITCHES............RETRACT AND OFF (F/O)
-- RUNWAY TURNOFF LIGHT SWITCHES.................OFF (F/O)
-- TAXI LIGHT SWITCH.............................OFF (F/O)
-- LOGO LIGHT SWITCH.......................AS NEEDED (F/O)
-- POSITION LIGHT SWITCH...................AS NEEDED (F/O)
-- ANTI-COLLISION LIGHT SWITCH...................OFF (F/O)
-- WING ILLUMINATION SWITCH................AS NEEDED (F/O)
-- WHEEL WELL LIGHT SWITCH.................AS NEEDED (F/O)

-- ==== Engine Starters
-- IGNITION SELECT SWITCH.................IGN L OR R (F/O)
-- ENGINE START SWITCHES.........................OFF (F/O)
-- =======================================================

preflightFOProc:addItem(SimpleProcedureItem:new("==== Hydraulic panel"))
preflightFOProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () kc_macro_hydraulic_on() end))
preflightFOProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () kc_macro_hydraulic_on() end))
	
-- differential pressure 0 on th eground
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== Air conditioning panel"))
preflightFOProc:addItem(ProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","FWD CAB",FlowItem.actorFO,0,
	function () return get("laminar/B738/toggle_switch/air_temp_source") == 3 end,
	function () set("laminar/B738/toggle_switch/air_temp_source",3) end))
preflightFOProc:addItem(ProcedureItem:new("CABIN TEMPERATURE SELECTORS","AUTO OR AS NEEDED",FlowItem.actorFO,0,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end,
	function () sysAir.contCabTemp:setValue(0.5) sysAir.fwdCabTemp:setValue(0.5) sysAir.aftCabTemp:setValue(0.5) end))
preflightFOProc:addItem(ProcedureItem:new("TRIM AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() > 0 end,
	function () 
		kc_macro_packs_on() 
	end))
preflightFOProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() > sysAir.isoVlvClosed end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () 
		kc_macro_bleeds_on()
	end))
preflightFOProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end, nil, 
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOff end, nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Cabin pressurization panel"))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT ALTITUDE INDICATOR","%i FT|activeBriefings:get(\"flight:cruiseLevel\")*100",FlowItem.actorFO,0,
	function () return sysAir.maxCruiseAltitude:getStatus() == activeBriefings:get("flight:cruiseLevel")*100 end,
	function () sysAir.maxCruiseAltitude:setValue(activeBriefings:get("flight:cruiseLevel")*100) end))
preflightFOProc:addItem(ProcedureItem:new("LANDING ALTITUDE INDICATOR","%i FT|kc_round_step(get(\"sim/cockpit2/autopilot/altitude_readout_preselector\"),50)",FlowItem.actorFO,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50)) end))
preflightFOProc:addItem(ProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Lighting panel"))
preflightFOProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () kc_macro_ext_lights_stand() end))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Engine Starters"))
preflightFOProc:addItem(ProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",FlowItem.actorFO,0,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFOProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end)) 

-- ========== PREFLIGHT PROCEDURE PART 3 (F/O) ===========
-- ==== Mode control panel right
-- COURSE NAV2...................................SET (F/O)
-- FLIGHT DIRECTOR SWITCHES..........ON, LEFT MASTER (F/O)

-- ==== EFIS control panel right                            
-- MINIMUMS REFERENCE SELECTOR.........RADIO OR BARO (F/O)
-- MINIMUMS SELECTOR..........SET DH OR DA REFERENCE (F/O)
-- FLIGHT PATH VECTOR SWITCH.....................OFF (F/O)
-- METERS SWITCH.................................OFF (F/O)
-- BAROMETRIC REFERENCE SELECTOR...........IN OR HPA (F/O)
-- BAROMETRIC SELECTOR...SET LOCAL ALTIMETER SETTING (F/O)
-- VOR/ADF SWITCHES..............................VOR (F/O)
-- MODE SELECTOR.................................MAP (F/O)
-- CENTER SWITCH.................................OFF (F/O)
-- RANGE SELECTOR..............................10 NM (F/O)
-- TRAFFIC SWITCH.................................ON (F/O)
-- WEATHER RADAR.................................OFF (F/O)
-- MAP SWITCHES............................AS NEEDED (F/O)

-- ==== Forward panel right
-- CLOCK..............................SET LOCAL TIME (F/O)
-- MAIN PANEL DISPLAY UNITS SELECTOR............NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR..................NORM (F/O)
-- OXYGEN...............................TEST AND SET (F/O)

-- ==== GROUND PROXIMITY panel
-- FLAP INHIBIT SWITCH..................GUARD CLOSED (F/O)
-- GEAR INHIBIT SWITCH..................GUARD CLOSED (F/O)
-- TERRAIN INHIBIT SWITCH...............GUARD CLOSED (F/O)

-- ==== Landing gear panel                              
-- LANDING GEAR LEVER.............................DN (F/O)
-- AUTO BRAKE SELECT SWITCH......................RTO (F/O)
-- ANTISKID INOP LIGHT...........VERIFY EXTINGUISHED (F/O)
-- =======================================================


preflightFOProc:addItem(SimpleProcedureItem:new("==== Mode control panel right"))
preflightFOProc:addItem(ProcedureItem:new("COURSE NAV2","SET %s|activeBriefings:get(\"departure:crs2\")",FlowItem.actorFO,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("departure:crs2") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("departure:crs2")) end))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON, LEFT MASTER",FlowItem.actorFO,0,
	function () return sysMCP.fdirGroup:getStatus() == 2 and get("laminar/B738/autopilot/master_capt_status") == 1 end,
	function () sysMCP.fdirGroup:actuate(1) end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== EFIS control panel right"))
preflightFOProc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",FlowItem.actorFO,0,
	function () return ((sysEFIS.minsTypeCopilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
		sysEFIS.minsTypeCopilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"departure:decision\")",FlowItem.actorFO,0,
	function () return sysEFIS.minsResetCopilot:getStatus() == 1 and 
		math.floor(sysEFIS.minsCopilot:getStatus()) == activeBriefings:get("departure:decision") end,
	function () sysEFIS.minsCopilot:setValue(activeBriefings:get("departure:decision")) 
				sysEFIS.minsResetCopilot:actuate(1) end))

preflightFOProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR SWITCH","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",FlowItem.actorFO,0,
	function () 
		return (sysEFIS.fpvCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
		or (sysEFIS.fpvCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvCopilot:actuate(flag) 
	end))
preflightFOProc:addItem(ProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",FlowItem.actorFO,0,
	function () 
		return (sysEFIS.mtrsCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
		or (sysEFIS.mtrsCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsCopilot:actuate(flag) 
	end))

preflightFOProc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",FlowItem.actorFO,0,
	function () return sysGeneral.baroModeGroup:getStatus() == (activePrefSet:get("general:baro_mode_hpa") == true and 3 or 0) end,
	function () if activePrefSet:get("general:baro_mode_hpa") then sysGeneral.baroModeGroup:actuate(1) else sysGeneral.baroModeGroup:actuate(0) end end))
preflightFOProc:addItem(ProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString(kc_metar_local)",FlowItem.actorFO,0,
	function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))

preflightFOProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",FlowItem.actorFO,0,
	function () return sysEFIS.voradf1Copilot:getStatus() == 1 and sysEFIS.voradf2Copilot:getStatus() == 1 end,
	function () sysEFIS.voradf1Copilot:actuate(1) sysEFIS.voradf2Copilot:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorFO,0,
	function () return sysEFIS.mapModeCopilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModeCopilot:actuate(sysEFIS.mapModeMAP) end))
preflightFOProc:addItem(ProcedureItem:new("CENTER SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysEFIS.ctrCopilot:getStatus() == 1 end))
preflightFOProc:addItem(ProcedureItem:new("RANGE SELECTOR","10 NM",FlowItem.actorFO,0,
	function () return sysEFIS.mapZoomCopilot:getStatus() == sysEFIS.mapRange10 end,
	function () sysEFIS.mapZoomCopilot:setValue(sysEFIS.mapRange10) end))
preflightFOProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","ON",FlowItem.actorFO,0,
	function () return sysEFIS.tfcCopilot:getStatus() == modeOn end,
	function () sysEFIS.tfcCopilot:actuate(modeOn) end))
preflightFOProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorFO,0,
	function () return sysEFIS.wxrCopilot:getStatus() == 0 end,
	function () sysEFIS.wxrCopilot:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",FlowItem.actorFO,1))

preflightFOProc:addItem(SimpleProcedureItem:new("==== Forward panel right"))
preflightFOProc:addItem(ProcedureItem:new("CLOCK","SET LOCAL TIME",FlowItem.actorFO,0,
	function() return sysGeneral.clockDispModeFO:getStatus() == 3 end,
	function () sysGeneral.clockDispModeFO:actuate(3) end))
preflightFOProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorFO,0,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:setValue(0) end))
preflightFOProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorFO,0,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:setValue(0) end))
preflightFOProc:addItem(IndirectProcedureItem:new("OXYGEN","TEST AND SET",FlowItem.actorFO,0,"oxygentestedfo",
	function () return get("laminar/B738/push_button/oxy_test_fo_pos") == 1 end,
	function () 
		kc_procvar_set("oxyfotest",true) -- background test
	end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== GROUND PROXIMITY panel"))
preflightFOProc:addItem(ProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	function () sysGeneral.flapInhibitCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	function () sysGeneral.gearInhibitCover:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",FlowItem.actorFO,0,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	function () sysGeneral.terrainInhibitCover:actuate(0) end))
	
preflightFOProc:addItem(SimpleProcedureItem:new("==== Landing gear panel"))
preflightFOProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DN",FlowItem.actorFO,0,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
preflightFOProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == 0 end,
	function () sysGeneral.autobrake:actuate(0) end))
preflightFOProc:addItem(ProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",FlowItem.actorFO,0,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))

-- ============== PREFLIGHT PROCEDURE (CAPT) ============
-- LIGHTS TEST...................................ON (CPT)
-- LIGHTS TEST..................................OFF (CPT)
-- OXYGEN RESET/TEST SWITCH...........PUSH AND HOLD (CPT)

-- ==== EFIS control panel left
-- MINIMUMS REFERENCE SELECTOR...........RADIO/BARO (CPT)
-- DECISION HEIGHT OR ALTITUDE REFERENCE........SET (CPT)
-- METERS SWITCH..........................MTRS/FEET (CPT)
-- FLIGHT PATH VECTOR........................ON/OFF (CPT)
-- BAROMETRIC REFERENCE SELECTOR.............HPA/IN (CPT)
-- BAROMETRIC SELECTOR..SET LOCAL ALTIMETER SETTING (CPT)
-- VOR/ADF SWITCHES.............................VOR (CPT)
-- MODE SELECTOR................................MAP (CPT)
-- CENTER SWITCH................................OFF (CPT)
-- RANGE SELECTOR.............................10 NM (CPT)
-- TRAFFIC SWITCH................................ON (CPT)
-- WEATHER RADAR................................OFF (CPT)
-- Set MAP SWITCHES AS NEEDED

-- ==== Mode control panel left
-- COURSE NAV1..................................SET (CPT)
-- FLIGHT DIRECTOR SWITCHES.........ON, LEFT MASTER (CPT)
-- Set BANK ANGLE SELECTOR AS NEEDED
-- AUTOPILOT DISENGAGE BAR.......................UP (CPT)

-- ==== Main panel
-- CLOCK....................................SET UTC (CPT)
-- NOSE WHEEL STEERING SWITCH..........GUARD CLOSED (CPT)

-- ==== Display select panel
-- MAIN PANEL DISPLAY UNITS SELECTOR...........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR.................NORM (F/O)
-- Set INTEGRATED STANDBY FLIGHT DISPLAY

-- ==== Pedestal
-- SPEED BRAKE LEVER....................DOWN DETENT (CPT)
-- REVERSE THRUST LEVERS.......................DOWN (CPT)
-- FORWARD THRUST LEVERS.....................CLOSED (CPT)
-- FLAP LEVER...................................SET (CPT)
--   Set the flap lever to agree with the flap position.
-- PARKING BRAKE................................SET (CPT)
-- ENGINE START LEVERS.......................CUTOFF (CPT)
-- STABILIZER TRIM CUTOUT SWITCHES...........NORMAL (CPT)
-- CARGO FIRE TEST
-- WEATHER RADAR PANEL...........................SET (F/O)
-- TRANSPONDER PANEL.............................SET (F/O)

-- ==== Radio tuning panel                              
-- VHF COMMUNICATIONS RADIOS.....................SET (F/O)
-- VHF NAVIGATION RADIOS...........SET FOR DEPARTURE (F/O)
-- AUDIO CONTROL PANEL...........................SET (F/O)
-- ADF RADIOS....................................SET (F/O)
-- =======================================================

local preflightCPTProc = Procedure:new("PREFLIGHT PROCEDURE (CPT)","","Ready for preflight checklist")
preflightCPTProc:setResize(false)
preflightCPTProc:setFlightPhase(3)
preflightCPTProc:addItem(IndirectProcedureItem:new("LIGHTS TEST","ON",FlowItem.actorCPT,0,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end,
	function () command_once("laminar/B738/toggle_switch/bright_test_up") end))
preflightCPTProc:addItem(ProcedureItem:new("LIGHTS TEST","OFF",FlowItem.actorCPT,0,
	function () return sysGeneral.lightTest:getStatus() == 0 end,
	function () kc_speakNoText(0,"test all lights then turn test off") end))
preflightCPTProc:addItem(IndirectProcedureItem:new("OXYGEN","TEST AND SET",FlowItem.actorCPT,0,"oxygentestedcpt",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end,
	function () 
		kc_procvar_set("oxycpttest",true) -- background test
	end))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== EFIS control panel"))
preflightCPTProc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",FlowItem.actorCPT,0,
	function () return ((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
		sysEFIS.minsTypePilot:actuate(flag) 
	end))
preflightCPTProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"departure:decision\")",FlowItem.actorFO,0,
	function () return sysEFIS.minsResetPilot:getStatus() == 1 and 
		math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("departure:decision") end,
	function () sysEFIS.minsPilot:setValue(activeBriefings:get("departure:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
preflightCPTProc:addItem(ProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",FlowItem.actorCPT,0,
	function () 
		return (sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
		or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",FlowItem.actorCPT,0,
	function () 
		return (sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
		or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",FlowItem.actorCPT,0,
	function () return sysGeneral.baroModeGroup:getStatus() == (activePrefSet:get("general:baro_mode_hpa") == true and 3 or 0) end,
	function () if activePrefSet:get("general:baro_mode_hpa") then sysGeneral.baroModeGroup:actuate(1) else sysGeneral.baroModeGroup:actuate(0) end end))
preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString(kc_metar_local)",FlowItem.actorFO,0,
	function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))
				
preflightCPTProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","VOR",FlowItem.actorCPT,0,
	function () return sysEFIS.voradf1Pilot:getStatus() == 1 and sysEFIS.voradf2Pilot:getStatus() == 1 end,
	function () sysEFIS.voradf1Pilot:actuate(1) sysEFIS.voradf2Pilot:actuate(1) end))
preflightCPTProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",FlowItem.actorCPT,0,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModePilot:actuate(sysEFIS.mapModeMAP) end))
preflightCPTProc:addItem(ProcedureItem:new("CENTER SWITCH","OFF",FlowItem.actorCPT,0,
	function () return sysEFIS.ctrPilot:getStatus() == 1 end))
preflightCPTProc:addItem(ProcedureItem:new("RANGE SELECTOR","10 MILES",FlowItem.actorCPT,0,
	function () return sysEFIS.mapZoomPilot:getStatus() == sysEFIS.mapRange10 end,
	function () sysEFIS.mapZoomPilot:setValue(sysEFIS.mapRange10) end))
preflightCPTProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysEFIS.tfcPilot:getStatus() == 1 end,
	function () sysEFIS.tfcPilot:actuate(1) end))
preflightCPTProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",FlowItem.actorCPT,0,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
preflightCPTProc:addItem(SimpleProcedureItem:new("Set MAP SWITCHES as needed"))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== Mode control panel"))
preflightCPTProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"departure:crs1\")",FlowItem.actorCPT,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("departure:crs1") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("departure:crs1")) end))
preflightCPTProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON, LEFT MASTER",FlowItem.actorCPT,0,
	function () return sysMCP.fdirGroup:getStatus() == 2 and get("laminar/B738/autopilot/master_capt_status") == 1 end,
	function () sysMCP.fdirGroup:actuate(1) end))
preflightCPTProc:addItem(SimpleProcedureItem:new("Set BANK ANGLE SELECTOR as needed"))
preflightCPTProc:addItem(ProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",FlowItem.actorCPT,0,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end,
	function () sysMCP.discAPSwitch:actuate(0) end))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== Main panel"))
preflightCPTProc:addItem(ProcedureItem:new("CLOCK","SET UTC",FlowItem.actorCPT,0,
	function() return sysGeneral.clockDispModeGrp:getStatus() == 4 end,
	function () sysGeneral.clockDispModeCPT:actuate(1) sysGeneral.clockDispModeFO:actuate(3) end))
preflightCPTProc:addItem(ProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",FlowItem.actorCPT,0,
	function () return get("laminar/B738/switches/nose_steer_pos") == 1 end,
	function () command_once("laminar/B738/switch/nose_steer_norm")  end))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== Display select panel"))
preflightCPTProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",FlowItem.actorCPT,0,
	function () return sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsCPT:setValue(0) end))
preflightCPTProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",FlowItem.actorCPT,0,
	function () return sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuCPT:setValue(0) end))
preflightCPTProc:addItem(SimpleProcedureItem:new("Set INTEGRATED STANDBY FLIGHT DISPLAY"))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== Pedestal"))
preflightCPTProc:addItem(ProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",FlowItem.actorCPT,0,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) end))
preflightCPTProc:addItem(ProcedureItem:new("REVERSE THRUST LEVERS","DOWN",FlowItem.actorCPT,0,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/reverse_lever1",0) set("laminar/B738/flt_ctrls/reverse_lever2",0) end))
preflightCPTProc:addItem(ProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",FlowItem.actorCPT,0,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end,
	function () set("laminar/B738/engine/thrust1_leveler",0) set("laminar/B738/engine/thrust2_leveler",0) end))
preflightCPTProc:addItem(ProcedureItem:new("FLAP LEVER","SET",FlowItem.actorCPT,1))
preflightCPTProc:addItem(SimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightCPTProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () sysEngines.startLever1:actuate(0) sysEngines.startLever2:actuate(0) end))
preflightCPTProc:addItem(ProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",FlowItem.actorCPT,0,
	function () return get("laminar/B738/toggle_switch/ap_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/ap_trim_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_pos") == 0 
	end,
	function () set("laminar/B738/toggle_switch/ap_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/el_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/ap_trim_pos",0)
		set("laminar/B738/toggle_switch/el_trim_pos",0) 
	end))
preflightCPTProc:addItem(IndirectProcedureItem:new("CARGO FIRE TEST","PERFORM",FlowItem.actorCPT,3,"cargo_fire_test",
	function () return get("laminar/B738/push_botton/cargo_fire_test") == 1 end,
	function () 
		kc_procvar_set("cargofiretest",true) -- background test
	end))
preflightCPTProc:addItem(ProcedureItem:new("WEATHER RADAR PANEL","SET",FlowItem.actorCPT,0,true,nil))
preflightCPTProc:addItem(ProcedureItem:new("TRANSPONDER PANEL","SET",FlowItem.actorCPT,0,true,
	function ()
		sysRadios.xpdrCode:actuate(2000)
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby)
	end))

preflightCPTProc:addItem(SimpleProcedureItem:new("==== Radio tuning panel"))
preflightCPTProc:addItem(ProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",FlowItem.actorCPT,1))
preflightCPTProc:addItem(ProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",FlowItem.actorCPT,1))
preflightCPTProc:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","SET",FlowItem.actorCPT,1))
preflightCPTProc:addItem(ProcedureItem:new("ADF RADIOS","SET",FlowItem.actorCPT,1))
preflightCPTProc:addItem(SimpleProcedureItem:new("==== Briefing"))
preflightCPTProc:addItem(ProcedureItem:new("DEPARTURE BRIEFING","PERFORM",FlowItem.actorCPT,1))

-- ================= PREFLIGHT CHECKLIST ================= 
-- OXYGEN..............................TESTED, 100% (BOTH)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO  (F/O)
-- WINDOW HEAT...................................ON  (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO  (F/O)
-- FLIGHT INSTRUMENTS.........HEADING__ ALTIMETER__ (BOTH)
-- PARKING BRAKE................................SET  (CPT)
-- ENGINE START LEVERS.......................CUTOFF  (CPT)
-- =======================================================

local preflightChkl = Checklist:new("PREFLIGHT CHECKLIST","","preflight checklist completed")
preflightChkl:setFlightPhase(3)
preflightChkl:addItem(IndirectChecklistItem:new("#exchange|OXYGEN|pre flight checklist. oxygen","TESTED 100 #exchange|PERC|percent",FlowItem.actorBOTH,0,"oxygentestedcpt",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(ChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",FlowItem.actorFO,0,
	function () 
		return sysMCP.vhfNavSwitch:getStatus() == 0 and 
			sysMCP.irsNavSwitch:getStatus() == 0 and 
			sysMCP.fmcNavSwitch:getStatus() == 0 and 
			sysMCP.displaySourceSwitch:getStatus() == 0 and 
			sysMCP.displayControlSwitch:getStatus() == 0 
	end,
	function () 
		kc_macro_b738_navswitches_init()
	end))
preflightChkl:addItem(ChecklistItem:new("WINDOW HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",FlowItem.actorFO,0,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))
preflightChkl:addItem(ChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",FlowItem.actorBOTH,0,true,nil,nil))
preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(0) end))

-- === end of preflight phase

-- =============== BEFORE START PROCEDURE ================
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED  (F/O)
-- CDU DISPLAY..................................SET (BOTH)
-- N1 BUGS....................................CHECK (BOTH)
-- IAS BUGS.....................................SET (BOTH)
-- ==== Set MCP
--   AUTOTHROTTLE ARM SWITCH....................ARM  (CPT)
--   IAS/MACH SELECTOR.......................SET V2  (CPT)
--   LNAV.............................ARM AS NEEDED  (CPT)
--   VNAV.............................ARM AS NEEDED  (CPT)
--   INITIAL HEADING............................SET  (CPT)
--   INITIAL ALTITUDE...........................SET  (CPT)
-- TAXI AND TAKEOFF BRIEFINGS..............COMPLETE (BOTH)
-- EXTERIOR DOORS.....................VERIFY CLOSED  (F/O)
-- ==== START CLEARANCE
--   Obtain a clearance to pressurize hydraulic systems.
--   Obtain a clearance to start engines.
-- ==== Set Fuel panel
--   CENTER FUEL PUMPS SWITCHES..................ON  (F/O)
--     If center tank quantity exceeds 1,000 lbs/460 kgs
--   AFT AND FORWARD FUEL PUMPS SWITCHES.........ON  (F/O)
-- ==== Set Hydraulic panel
--   ENGINE HYDRAULIC PUMP SWITCHES.............OFF  (F/O)
--   ELECTRIC HYDRAULIC PUMP SWITCHES............ON  (F/O)
-- ==== Set Trim
--   STABILIZER TRIM......................___ UNITS  (CPT)
--   AILERON TRIM...........................0 UNITS  (CPT)
--   RUDDER TRIM............................0 UNITS  (CPT)
-- ANTI COLLISION LIGHT SWITCH...................ON  (F/O)
-- WING & WHEEL WELL LIGHTS.....................OFF  (F/O)
-- =======================================================

local beforeStartProc = Procedure:new("BEFORE START PROCEDURE","Before start items","ready for before start checklist")
beforeStartProc:setFlightPhase(4)
beforeStartProc:addItem(ProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",FlowItem.actorFO,0,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartProc:addItem(SimpleProcedureItem:new("Set required CDU DISPLAY"))
beforeStartProc:addItem(SimpleProcedureItem:new("Check N1 BUGS"))
beforeStartProc:addItem(ProcedureItem:new("IAS BUGS","SET",FlowItem.actorBOTH,0,
	function () return sysFMC.noVSpeeds:getStatus() == 0 end,
	function () kc_macro_glareshield_takeoff() end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set MCP"))
beforeStartProc:addItem(ProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.athrSwitch:getStatus() == 1 end))
beforeStartProc:addItem(ProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorCPT,0,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end))
beforeStartProc:addItem(ProcedureItem:new("  LNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.lnavSwitch:getStatus() == 1 end,nil,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(ProcedureItem:new("  VNAV","ARM",FlowItem.actorCPT,0,
	function () return sysMCP.vnavSwitch:getStatus() == 1 end,nil,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(ProcedureItem:new("  INITIAL HEADING","SET %03d|activeBriefings:get(\"departure:initHeading\")",FlowItem.actorCPT,0,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end))
beforeStartProc:addItem(ProcedureItem:new("  INITIAL ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end))
beforeStartProc:addItem(SimpleProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS - COMPLETE?"))
beforeStartProc:addItem(ProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",FlowItem.actorFO,0,true,
	function () 
		if get("laminar/B738/airstairs_hide") == 0  then
			command_once("laminar/B738/airstairs_toggle")
		end
		kc_macro_ext_doors_closed()
	end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== START CLEARANCE"))
beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to pressurize hydraulic systems."))
beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to start engines."))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Fuel panel"))
beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() > 1000 end))
beforeStartProc:addItem(SimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(ProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () kc_macro_fuelpumps_on() end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Hydraulic panel"))
beforeStartProc:addItem(ProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end))
beforeStartProc:addItem(ProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
beforeStartProc:addItem(SimpleProcedureItem:new("==== Set Trim"))
beforeStartProc:addItem(ProcedureItem:new("  STABILIZER TRIM","%4.2f UNITS (%4.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*10000,100)/10000|activeBriefings:get(\"takeoff:elevatorTrim\")",FlowItem.actorCPT,0,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*10000,100)/10000) == activeBriefings:get("takeoff:elevatorTrim") end))
beforeStartProc:addItem(SimpleProcedureItem:new("  Use trim wheel and bring values to match."))
beforeStartProc:addItem(ProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",FlowItem.actorCPT,0,
	function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartProc:addItem(ProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",FlowItem.actorCPT,0,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))
beforeStartProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
beforeStartProc:addItem(ProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","OFF",FlowItem.actorFO,0,
	function () return sysLights.wingSwitch:getStatus() == 0 and sysLights.wheelSwitch:getStatus() == 0 end,
	function () 
		sysLights.wingSwitch:actuate(0) 
		sysLights.wheelSwitch:actuate(0) 
		-- also turn off DH display in PFDs
		sysEFIS.minsResetPilot:actuate(0)
		sysEFIS.minsResetCopilot:actuate(0)
	end))

-- ============= BEFORE START CHECKLIST (F/O) ============
-- FLIGHT DECK DOOR...............CLOSED AND LOCKED  (F/O)
-- FUEL..........................9999 KGS, PUMPS ON  (F/O)
-- PASSENGER SIGNS..............................SET  (F/O)
-- WINDOWS...................................LOCKED (BOTH)
-- MCP...................V2 999, HDG 999, ALT 99999  (CPT)
-- TAKEOFF SPEEDS............V1 999, VR 999, V2 999   (PF)
-- CDU PREFLIGHT..........................COMPLETED   (PF)
-- RUDDER & AILERON TRIM.................FREE AND 0  (CPT)
-- TAXI AND TAKEOFF BRIEFING..            COMPLETED   (PF)
-- ANTI COLLISION LIGHT..........................ON  (F/O)
-- =======================================================

local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST","","before start checklist completed")
beforeStartChkl:setFlightPhase(4)
beforeStartChkl:addItem(ChecklistItem:new("#exchange|FLIGHT DECK DOOR|before start checklist. FLIGHT DECK DOOR","CLOSED AND LOCKED",FlowItem.actorFO,0,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s , PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KG\" or \"LB\"",FlowItem.actorFO,0,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartChkl:addItem(ChecklistItem:new("FUEL","%i %s , PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KG\" or \"LB\"",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	function () kc_macro_fuelpumps_on() end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartChkl:addItem(ChecklistItem:new("PASSENGER SIGNS","SET",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () 
		sysGeneral.seatBeltSwitch:actuate(1)
		sysGeneral.noSmokingSwitch:actuate(1) 
	end))
beforeStartChkl:addItem(ChecklistItem:new("WINDOWS","LOCKED",FlowItem.actorBOTH,0,true))
beforeStartChkl:addItem(ChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|activeBriefings:get(\"takeoff:v2\")|activeBriefings:get(\"departure:initHeading\")|activeBriefings:get(\"departure:initAlt\")",FlowItem.actorCPT,0,
	function () 
		return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") and 
			sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") and 
			sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") 
	end,
	function () 
		kc_macro_glareshield_takeoff()
	end))
beforeStartChkl:addItem(ChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|activeBriefings:get(\"takeoff:v1\")|activeBriefings:get(\"takeoff:vr\")|activeBriefings:get(\"takeoff:v2\")",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("CDU PREFLIGHT","COMPLETED",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",FlowItem.actorCPT,0,
	function () 
		return sysControls.rudderTrimSwitch:getStatus() == 0 and 
			sysControls.aileronTrimSwitch:getStatus() == 0 
	end,
	function () 
		sysControls.rudderTrimSwitch:setValue(0) 
		sysControls.aileronTrimSwitch:setValue(0) 
	end))
beforeStartChkl:addItem(ChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",FlowItem.actorPF,0,true))
beforeStartChkl:addItem(ChecklistItem:new("ANTI-COLLISION LIGHT SWITCH","ON",FlowItem.actorFO,0,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))

-- =========== PUSHBACK & ENGINE START (BOTH) ============
-- PARKING BRAKE................................SET  (CPT)
-- PUSHBACK SERVICE..........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND..............ESTABLISH  (CPT)
-- PARKING BRAKE...........................RELEASED  (CPT)
-- PACKS................................AUTO OR OFF  (F/O)
-- SYSTEM A HYDRAULIC PUMPS......................ON  (F/O)
-- START FIRST ENGINE.............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH........START SWITCH _ TO GRD  (CPT)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER................LEVER _ IDLE  (CPT)
--   When starter switch jumps back call STARTER CUTOUT
-- START SECOND ENGINE............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH........START SWITCH _ TO GRD  (CPT)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER................LEVER _ IDLE  (CPT)
--   When starter switch jumps back call STARTER CUTOUT
-- PARKING BRAKE................................SET  (F/O)
--   When instructed by ground crew after pushback/towing
-- When pushback/towing complete
--   TOW BAR DISCONNECTED....................VERIFY  (CPT)
--   LOCKOUT PIN REMOVED.....................VERIFY  (CPT)
-- =======================================================

-- XPDR TO ALT OFF?

local pushstartProc = Procedure:new("PUSHBACK & ENGINE START","let's get ready for push and start")
pushstartProc:setFlightPhase(4)
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		sysGeneral.parkBrakeSwitch:actuate(1) 
		-- also trigger timers and turn dome light off
		activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
		sysLights.domeLightSwitch:actuate(0)
		kc_macro_b738_lowerdu_eng()
		kc_pushback_plan()
	end))
pushstartProc:addItem(HoldProcedureItem:new("PUSHBACK SERVICE","ENGAGE",FlowItem.actorCPT,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(SimpleProcedureItem:new("Engine Start may be done during pushback or towing",
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(ProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",FlowItem.actorCPT,2,true,
	function () kc_pushback_call() end,
	function () return activeBriefings:get("taxi:gateStand") > 2 end))
pushstartProc:addItem(IndirectProcedureItem:new("PARKING BRAKE","RELEASED",FlowItem.actorFO,0,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
pushstartProc:addItem(ProcedureItem:new("PACKS","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == sysAir.packModeOff end,
	function () 
		kc_macro_packs_start()
	end))
pushstartProc:addItem(ProcedureItem:new("SYSTEM A HYDRAULIC PUMP","ON",FlowItem.actorFO,0,
	function () 
		return sysHydraulic.engHydPump1:getStatus() == 1 and 
			sysHydraulic.elecHydPump1:getStatus() == 1 
	end,
	function () 
		kc_macro_hydraulic_on()
	end))
pushstartProc:addItem(SimpleChecklistItem:new("Wait for start clearance from ground crew"))
pushstartProc:addItem(ProcedureItem:new("START SEQUENCE","%s then %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,1,true,
	function () 
		local stext = string.format("Start sequence is %s then %s",activeBriefings:get("taxi:startSequence") == 1 and "2" or "1",activeBriefings:get("taxi:startSequence") == 1 and "1" or "2")
		kc_speakNoText(0,stext)
	end))
pushstartProc:addItem(HoldProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorFO,0,"eng_start_1_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() == 0 
		else 
			return sysEngines.engStart1Switch:getStatus() == 0 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart2Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 2")
		else 
			sysEngines.engStart1Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 1")
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(ProcedureItem:new("  N2 ROTATION","AT 25%",FlowItem.actorCPT,0,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 else 
		return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 end end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",FlowItem.actorCPT,3,"eng_start_1_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.startLever2:getStatus() == 1 
		else 
			return sysEngines.startLever1:getStatus() == 1 
		end
	end,
	function () 
		kc_speakNoText(0,"N1 at 25 percent") 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.startLever2:actuate(1) 
		else 
			sysEngines.startLever1:actuate(1) 
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(ProcedureItem:new("STARTER CUTOUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart2Switch:getStatus() == 1 
		else 
			return sysEngines.engStart1Switch:getStatus() == 1 
		end 
	end))
pushstartProc:addItem(HoldProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,
	function () kc_speakNoText(0,"starter cutout") end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorFO,3,"eng_start_2_grd",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 0 
		else 
			return sysEngines.engStart2Switch:getStatus() == 0 
		end 
	end,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.engStart1Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 1")
		else 
			sysEngines.engStart2Switch:actuate(0) 
			kc_speakNoText(0,"starting engine 2")
		end 
	end))
pushstartProc:addItem(ProcedureItem:new("N2 ROTATION","AT 25%",FlowItem.actorCPT,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 
		else 
			return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 
		end 
	end))
pushstartProc:addItem(IndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",FlowItem.actorCPT,3,"eng_start_2_lever",
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.startLever1:getStatus() == 1 
		else 
			return sysEngines.startLever2:getStatus() == 1 
		end 
	end,
	function () 
		kc_speakNoText(0,"N1 at 25 percent") 
		if activeBriefings:get("taxi:startSequence") == 1 then
			sysEngines.startLever1:actuate(1) 
		else 
			sysEngines.startLever2:actuate(1) 
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(ProcedureItem:new("STARTER CUTOUT","ANNOUNCE",FlowItem.actorFO,0,
	function () 
		if activeBriefings:get("taxi:startSequence") == 1 then
			return sysEngines.engStart1Switch:getStatus() == 1 
		else 
			return sysEngines.engStart2Switch:getStatus() == 1 
		end 
	end))
pushstartProc:addItem(SimpleProcedureItem:new("When pushback/towing complete"))
pushstartProc:addItem(HoldProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",FlowItem.actorCPT,
	function () 
		kc_speakNoText(0,"starter cutout") 
	end))
pushstartProc:addItem(ProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",FlowItem.actorCPT,0,true,
	function () 
		kc_pushback_end()
	end))

pushstartProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorFO,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () 
		if sysGeneral.parkBrakeSwitch:getStatus() ~= 1 then
			kc_speakNoText(0,"Set parking brake when push finished")
		end
	end))

-- ============= BEFORE TAXI PROCEDURE (F/O) =============
-- HYDRAULIC PUMP SWITCHES...................ALL ON  (F/O)
-- GENERATOR 1 AND 2 SWITCHES....................ON  (F/O)
-- PROBE HEAT SWITCHES...........................ON  (F/O)
-- WING ANTI-ICE SWITCH...................AS NEEDED  (F/O)
-- ENGINE ANTI-ICE SWITCHES...............AS NEEDED  (F/O)
-- PACK SWITCHES...............................AUTO  (F/O)
-- ISOLATION VALVE SWITCH......................AUTO  (F/O)
-- APU BLEED AIR SWITCH.........................OFF  (F/O)
-- APU SWITCH...................................OFF  (F/O)
-- ENGINE START SWITCHES.......................CONT  (F/O)
-- ENGINE START LEVERS..................IDLE DETENT  (CPT)
-- Verify that the ground equipment is clear.
-- Call 'FLAPS ___' as needed for takeoff.           
-- FLAP LEVER.....................SET TAKEOFF FLAPS  (F/O)
-- LE FLAPS EXT GREEN LIGHT.............ILLUMINATED  (F/O)
-- FLIGHT CONTROLS............................CHECK (BOTH)
-- TRANSPONDER............................AS NEEDED  (F/O)
-- RECALL.....................................CHECK (BOTH)
--   Verify annunciators illuminate and then extinguish.
-- =======================================================

local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE","","ready for before taxi checklist")
beforeTaxiProc:setFlightPhase(5)
beforeTaxiProc:addItem(ProcedureItem:new("HYDRAULIC PUMP SWITCHES","ALL ON",FlowItem.actorFO,0,
	function () return sysHydraulic.hydPumpGroup:getStatus() == 4 end,
	function () 
		kc_macro_hydraulic_on() 
	end))
beforeTaxiProc:addItem(ProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () 
		kc_procvar_set("gen1down",true)
		kc_procvar_set("gen2down",true)
	end))
beforeTaxiProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTaxiProc:addItem(SimpleProcedureItem:new("  When temperature <10 C & visible moisture"))
beforeTaxiProc:addItem(ProcedureItem:new("PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () 
		kc_macro_packs_on()
	end))
beforeTaxiProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == sysAir.isoVlvAuto end))
beforeTaxiProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () kc_macro_bleeds_on() end))
beforeTaxiProc:addItem(ProcedureItem:new("APU SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up") end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:step(cmdUp) end))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiProc:addItem(HoldProcedureItem:new("GROUND EQUIPMENT","CLEAR",FlowItem.actorCPT))
beforeTaxiProc:addItem(SimpleProcedureItem:new("Call FLAPS as needed for takeoff."))
beforeTaxiProc:addItem(ProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
beforeTaxiProc:addItem(ProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return get("laminar/B738/annunciator/slats_extend") == 1 end))

beforeTaxiProc:addItem(IndirectProcedureItem:new("FLIGHT CONTROLS","CHECK",FlowItem.actorBOTH,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end,
	function () 
		kc_macro_b738_lowerdu_sys()
	end))
beforeTaxiProc:addItem(ProcedureItem:new("RECALL","CHECK",FlowItem.actorBOTH,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","TARA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA) 
		sysRadios.xpdrCode:actuate(activeBriefings:get("departure:squawk"))
	end,
	function () return activePrefSet:get("general:xpdrusa") == false end))
beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) 
		local xpdrcode = activeBriefings:get("departure:squawk")
		if xpdrCode == nil or xpdrCode == "" then
			sysRadios.xpdrCode:actuate("2000")
		else
			sysRadios.xpdrCode:actuate(xpdrCode)
		end
	end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
beforeTaxiProc:addItem(ProcedureItem:new("LOWER DU","OFF",FlowItem.actorFO,0,
	function () return get("laminar/B738/systems/lowerDU_page2") == 0 end,
	function () 
		kc_macro_b738_lowerdu_off()
	end))

-- chrono
	
-- ============= BEFORE TAXI CHECKLIST (F/O) =============
-- GENERATORS....................................ON  (F/O)
-- PROBE HEAT....................................ON  (F/O)
-- ANTI-ICE.............................AS REQUIRED  (F/O)
-- ISOLATION VALVE.............................AUTO  (F/O)
-- ENGINE START SWITCHES.......................CONT  (F/O)
-- RECALL...................................CHECKED (BOTH)
-- AUTOBRAKE....................................RTO  (F/O)
-- ENGINE START LEVERS..................IDLE DETENT  (CPT)
-- FLIGHT CONTROLS..........................CHECKED  (CPT)
-- GROUND EQUIPMENT...........................CLEAR (BOTH)
-- =======================================================

local beforeTaxiChkl = Checklist:new("BEFORE TAXI CHECKLIST","","before taxi checklist completed")
beforeTaxiChkl:setFlightPhase(5)
beforeTaxiChkl:addItem(ChecklistItem:new("#exchange|GENERATORS|before taxi checklist. generators","ON",FlowItem.actorFO,0,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end))
beforeTaxiChkl:addItem(ChecklistItem:new("PROBE HEAT","ON",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 1 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","ENGINE ANTI-ICE",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 2 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","ENGINE & WING ANTI-ICE",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 3 end))
beforeTaxiChkl:addItem(ChecklistItem:new("ISOLATION VALVE","AUTO",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.isoValveSwitch:setValue(sysAir.isoVlvAuto) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorCPT,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
beforeTaxiChkl:addItem(ChecklistItem:new("RECALL","CHECKED",FlowItem.actorCPT,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
beforeTaxiChkl:addItem(ChecklistItem:new("AUTOBRAKE","RTO",FlowItem.actorCPT,0,
	function () return sysGeneral.autobrake:getStatus() == 0 end,
	function () sysGeneral.autobrake:actuate(0) end))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiChkl:addItem(IndirectChecklistItem:new("FLIGHT CONTROLS","CHECK",FlowItem.actorCPT,0,"fccheck",
	function () return get("sim/flightmodel2/wing/rudder1_deg") > 18 end,
	function () 
		kc_macro_b738_lowerdu_sys() 
	end))
beforeTaxiChkl:addItem(ChecklistItem:new("GROUND EQUIPMENT","CLEAR",FlowItem.actorBOTH,0,true,
	function () 
		kc_macro_b738_lowerdu_off()
		sysLights.taxiSwitch:actuate(1) 
	end))

-- =========== BEFORE TAKEOFF CHECKLIST (F/O) ============
-- FLAPS............................__, GREEN LIGHT  (CPT)
-- STABILIZER TRIM....................... ___ UNITS  (CPT)
-- =======================================================

local beforeTakeoffChkl = Checklist:new("BEFORE TAKEOFF CHECKLIST","","before takeoff checklist completed")
beforeTakeoffChkl:setFlightPhase(7)
beforeTakeoffChkl:addItem(ChecklistItem:new("#exchange|FLAPS|before takeoff checklist. Flaps","%s, GREEN LIGHT|kc_pref_split(kc_TakeoffFlaps)[activeBriefings:get(\"takeoff:flaps\")]",FlowItem.actorCPT,0,
	function () 
		return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] and 
			get("laminar/B738/annunciator/slats_extend") == 1 end,
	function () 
		sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) 
	end)) 
beforeTakeoffChkl:addItem(ChecklistItem:new("STABILIZER TRIM","%3.2f UNITS (%3.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*1000,10)/1000|activeBriefings:get(\"takeoff:elevatorTrim\")",FlowItem.actorCPT,0,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*1000,10)/1000 == activeBriefings:get("takeoff:elevatorTrim")*100/100) end))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)
-- ======================================================

local runwayEntryProc = Procedure:new("RUNWAY ENTRY PROCEDURE","runway entry","aircraft ready for takeoff")
runwayEntryProc:setFlightPhase(7)
runwayEntryProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () 
		kc_macro_ext_lights_rwyentry() 
		kc_macro_b738_lowerdu_off()
	end))
runwayEntryProc:addItem(ProcedureItem:new("TRANSPONDER","ON",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () 
		sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA)
		sysRadios.xpdrCode:actuate(activeBriefings:get("departure:squawk"))
	end))		
runwayEntryProc:addItem(ProcedureItem:new("PACKS & BLEEDS","SET",FlowItem.actorFO,0,true,
	function ()
		kc_macro_packs_takeoff() 
		kc_macro_bleeds_takeoff()
	end))

--	center pumps off

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- AUTOTHROTTLE................................ARM   (PF)
-- A/P MODES...........................AS REQUIRED   (PF)
-- THRUST SETTING...........................40% N1   (PF)
-- SET TAKEOFF THRUST.....................T/O MODE   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PF)
-- GEAR.........................................UP   (PM)
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)   
-- FLAPS 10.........................SET (OPTIONAL)   (PM)
-- FLAPS 10 SPEED...............REACHED (OPTIONAL)   
-- FLAPS 5..........................SET (OPTIONAL)   (PM)
-- FLAPS 5 SPEED...........................REACHED   
-- FLAPS 1.....................................SET   (PM)
-- FLAPS 1 SPEED...........................REACHED   
-- FLAPS UP....................................SET   (PM)
-- ACCELERATION ALTITUDE.............GT 300 FT AGL   
-- CMD-A........................................ON   (PM)
-- AUTO BRAKE SELECT SWITCH....................OFF   (PM)
-- GEAR........................................OFF   (PM)
-- ENGINE START SWITCHES.......................OFF   (PM)
-- Whatever comes first
-- TRANSITION ALTITUDE............ANNOUNCE REACHED   (PM)
-- ALTIMETERS..................................STD (BOTH)
-- =====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS..............................OFF   (PM)
-- RUNWAY TURNOFF LIGHT SWITCHES...............OFF   (PM)
-- FASTEN BELTS SWITCH.........................OFF   (PM)
-- ======================================================

--chrono
local takeoffClimbProc = Procedure:new("TAKEOFF & INITIAL CLIMB","takeoff")
takeoffClimbProc:setFlightPhase(8)
takeoffClimbProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () kc_macro_ext_lights_takeoff() end))
takeoffClimbProc:addItem(ProcedureItem:new("AUTOTHROTTLE","ARM",FlowItem.actorPF,0,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
takeoffClimbProc:addItem(ProcedureItem:new("A/P MODES","%s|kc_pref_split(kc_TakeoffApModes)[activeBriefings:get(\"takeoff:apMode\")]",FlowItem.actorPF,0,
	function () 
		if activeBriefings:get("takeoff:apMode") == 1 then
			return sysMCP.lnavSwitch:getStatus() == 1 and sysMCP.vnavSwitch:getStatus() == 1 
		elseif activeBriefings:get("takeoff:apMode") == 2 then
			return sysMCP.hdgselSwitch:getStatus() == 1 and sysMCP.lvlchgSwitch:getStatus() == 1 
		else
			return true
		end
	end, 
	function () 
		if activeBriefings:get("takeoff:apMode") == 1 then
			sysMCP.lnavSwitch:actuate(1) 
			sysMCP.vnavSwitch:actuate(1) 
		elseif activeBriefings:get("takeoff:apMode") == 2 then
			sysMCP.hdgselSwitch:actuate(1)
			sysMCP.lvlchgSwitch:actuate(1)
		else
		end
		kc_macro_ext_doors_closed()
	end))
takeoffClimbProc:addItem(HoldProcedureItem:new("TAKEOFF","ANNOUNCE",FlowItem.actorPF))
takeoffClimbProc:addItem(IndirectProcedureItem:new("THRUST SETTING","40% N1",FlowItem.actorPNF,0,"to40percent",
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 40 end))
takeoffClimbProc:addItem(ProcedureItem:new("SET TAKEOFF THRUST","T/O MODE",FlowItem.actorPF,0,
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 70 end,
	function () command_once("laminar/B738/autopilot/left_toga_press") kc_speakNoText(0,"takeoff thrust set") end))
takeoffClimbProc:addItem(IndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",FlowItem.actorPNF,0,"toposrate",
	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 100 and get("sim/flightmodel/position/y_agl") > 40 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("GEAR","COMMAND UP",FlowItem.actorPF))
takeoffClimbProc:addItem(IndirectProcedureItem:new("GEAR","UP",FlowItem.actorPF,0,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () sysGeneral.GearSwitch:actuate(0) kc_speakNoText(0,"gear up") end))
-- takeoffClimbProc:addItem(IndirectProcedureItem:new("FLAPS 15 SPEED","REACHED",FlowItem.actorPNF,0,"toflap15spd",
	-- function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_15")-5 end,nil,
	-- function () return sysControls.flapsSwitch:getStatus() < 0.625 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS 10","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.625 end))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS 10","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/flaps_10") kc_speakNoText(0,"speed check flaps 10") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
-- takeoffClimbProc:addItem(IndirectProcedureItem:new("FLAPS 10 SPEED","REACHED",FlowItem.actorPNF,0,"toflap10spd",
	-- function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_10")-5 end,nil,
	-- function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS 5","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == 0.375 end,
	function () command_once("laminar/B738/push_button/flaps_5") kc_speakNoText(0,"speed check flaps 5") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
-- takeoffClimbProc:addItem(IndirectProcedureItem:new("FLAPS 5 SPEED","REACHED",FlowItem.actorPNF,0,"toflap5spd",
	-- function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_5")-5 end,nil,
	-- function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS 1","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == 0.125 end,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
-- takeoffClimbProc:addItem(IndirectProcedureItem:new("FLAPS 1 SPEED","REACHED",FlowItem.actorPNF,0,"toflap1spd",
	-- function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_1")-5 end))
takeoffClimbProc:addItem(HoldProcedureItem:new("FLAPS UP","COMMAND",FlowItem.actorPF,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
takeoffClimbProc:addItem(ProcedureItem:new("FLAPS UP","SET",FlowItem.actorPNF,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/push_button/flaps_0") kc_speakNoText(0,"speed check flaps up") end))
takeoffClimbProc:addItem(IndirectProcedureItem:new("ACCELERATION ALTITUDE","GT 300 FT AGL",FlowItem.actorPNF,0,"toaccalt",
	function () return get("sim/flightmodel/position/y_agl") > 300 end))
takeoffClimbProc:addItem(ProcedureItem:new("CMD-A","ON",FlowItem.actorPF,0,
	function () return sysMCP.ap1Switch:getStatus() == 1 end,
	function () if activePrefSet:get("takeoff_cmda") == true then sysMCP.ap1Switch:actuate(1) end kc_speakNoText(0,"command a") end))
takeoffClimbProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == 1 end,
	function () command_once("laminar/B738/knob/autobrake_off") end))
takeoffClimbProc:addItem(ProcedureItem:new("GEAR","OFF",FlowItem.actorPF,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/gear_off") end))
	
takeoffClimbProc:addItem(IndirectProcedureItem:new("TRANSITION ALTITUDE","REACHED",FlowItem.actorPF,0,"to_trans_alt",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > activeBriefings:get("departure:transalt") end,nil,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(IndirectProcedureItem:new("ALTIMETERS","STD",FlowItem.actorPF,0,"to_altimeters",
	function () return get("laminar/B738/EFIS/baro_set_std_pilot") == 1 and get("laminar/B738/EFIS/baro_set_std_copilot") == 1 end,
	function () 
	    kc_speakNoText(0,"transition altitude")
		if get("laminar/B738/EFIS/baro_set_std_pilot") == 0 then 
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if get("laminar/B738/EFIS/baro_set_std_copilot") == 0 then 
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
	end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))

takeoffClimbProc:addItem(IndirectProcedureItem:new("10.000 FT","REACHED",FlowItem.actorPF,0,"to_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 end,nil,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorPM,0,true,
	function () kc_macro_ext_lights_above10()  kc_speakNoText(0,"ten thousand") end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))

takeoffClimbProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","OFF",FlowItem.actorPM,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))

takeoffClimbProc:addItem(IndirectProcedureItem:new("10.000 FT","REACHED",FlowItem.actorPF,0,"to_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 end,nil,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorPM,0,true,
	function () kc_macro_ext_lights_above10()  kc_speakNoText(0,"ten thousand") end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","OFF",FlowItem.actorPM,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
	end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))

takeoffClimbProc:addItem(IndirectProcedureItem:new("TRANSITION ALTITUDE","REACHED",FlowItem.actorPF,0,"to_trans_alt",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > activeBriefings:get("departure:transalt") end,nil,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(IndirectProcedureItem:new("ALTIMETERS","STD",FlowItem.actorPF,0,"to_altimeters",
	function () return get("laminar/B738/EFIS/baro_set_std_pilot") == 1 and get("laminar/B738/EFIS/baro_set_std_copilot") == 1 end,
	function () 
	    kc_speakNoText(0,"transition altitude")
		if get("laminar/B738/EFIS/baro_set_std_pilot") == 0 then 
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if get("laminar/B738/EFIS/baro_set_std_copilot") == 0 then 
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
	end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorPM,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end))

-- center pumps on if >xxx
	
-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- ENGINE BLEEDS................................ON   (PM)
-- PACKS......................................AUTO   (PM)
-- LANDING GEAR.........................UP AND OFF   (PM)
-- FLAPS.............................UP, NO LIGHTS   (PM)
-- ======================================================

local afterTakeoffChkl = Checklist:new("AFTER TAKEOFF CHECKLIST","","after takeoff checklist completed")
afterTakeoffChkl:setFlightPhase(9)
afterTakeoffChkl:addItem(ChecklistItem:new("#exchange|ENGINE BLEEDS|after takeoff checklist. engine bleeds","ON",FlowItem.actorPM,0,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () kc_macro_bleeds_on() end))
afterTakeoffChkl:addItem(ChecklistItem:new("PACKS","AUTO",FlowItem.actorPM,0,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () kc_macro_packs_on() end))
afterTakeoffChkl:addItem(ChecklistItem:new("LANDING GEAR","UP AND OFF",FlowItem.actorPM,0,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () sysGeneral.GearSwitch:actuate(2) end))
afterTakeoffChkl:addItem(ChecklistItem:new("FLAPS","UP, NO LIGHTS",FlowItem.actorPM,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/flap_lever",0) end))

-- ================= DESCENT PROCEDURE ==================
-- AUTOTHROTTLE................................ARM   (PF)
-- LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES...OFF   (PM)
--   If center tank quantity below 3,000 lbs/1400 kgs
-- PRESSURIZATION...................LAND ALT __ FT   (PM)
-- RECALL..........................CHECKED ALL OFF   (PM)
-- VREF..............................SELECT IN FMC   (PF)
-- LANDING DATA...............VREF __, MINIMUMS __   (PM)
-- Set/verify navigation radios & course for the approach.
-- AUTO BRAKE SELECT SWITCH..............AS NEEDED   (PM)
-- ======================================================

local descentProc = Procedure:new("DESCENT PROCEDURE","performing descent items","ready for descent checklist")
descentProc:setFlightPhase(11)
descentProc:addItem(ProcedureItem:new("LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",FlowItem.actorPM,0,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(0) end,
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(SimpleProcedureItem:new("  If center tank quantity at or below 3,000 lbs/1400 kgs",
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(ProcedureItem:new("PRESSURIZATION","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentProc:addItem(ProcedureItem:new("RECALL","CHECKED ALL OFF",FlowItem.actorPM,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentProc:addItem(ProcedureItem:new("VREF","SELECT IN FMC",FlowItem.actorPF,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 end))
descentProc:addItem(ProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|get(\"laminar/B738/FMS/vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorPM,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 and 
				sysEFIS.minsResetPilot:getStatus() == 1 and 
				math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("approach:decision") end,
	function ()
				local flag = 0 
				if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
				sysEFIS.minsTypePilot:actuate(flag) 
				sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
descentProc:addItem(SimpleProcedureItem:new("Set or verify the navigation radios and course for the approach."))
descentProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,0,
	function () return sysGeneral.autobrake:getStatus() == activeBriefings:get("approach:autobrake") end,
	function () 
		if activeBriefings:get("approach:autobrake") == 2 then
			command_once("laminar/B738/knob/autobrake_1")
		elseif activeBriefings:get("approach:autobrake") == 3 then
			command_once("laminar/B738/knob/autobrake_2")
		elseif activeBriefings:get("approach:autobrake") == 4 then
			command_once("laminar/B738/knob/autobrake_3")
		elseif activeBriefings:get("approach:autobrake") == 5 then
			command_once("laminar/B738/knob/autobrake_max")
		end
	end))

-- =============== DESCENT CHECKLIST (PM) ===============
-- PRESSURIZATION...................LAND ALT _____   (PM)
-- RECALL..................................CHECKED (BOTH)
-- AUTOBRAKE...................................___   (PM)
-- LANDING DATA...............VREF___, MINIMUMS___ (BOTH)
-- APPROACH BRIEFING.....................COMPLETED   (PF)
-- ======================================================

local descentChkl = Checklist:new("DESCENT CHECKLIST","","descent checklist completed")
descentChkl:setFlightPhase(11)
descentChkl:addItem(ChecklistItem:new("#exchange|PRESSURIZATION|descent checklist. pressurization","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",FlowItem.actorPM,0,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentChkl:addItem(ChecklistItem:new("RECALL","CHECKED",FlowItem.actorBOTH,0,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentChkl:addItem(ChecklistItem:new("AUTOBRAKE","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorPM,1))
descentChkl:addItem(ChecklistItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"approach:decision\")",FlowItem.actorBOTH,0,
	function () return get("laminar/B738/FMS/vref") ~= 0 and math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("approach:decision") end,
	function () 
				local flag = 0 
				if activePrefSet:get("aircraft:efis_mins_dh") then flag=0 else flag=1 end
				sysEFIS.minsTypePilot:actuate(flag) 
				sysEFIS.minsPilot:setValue(activeBriefings:get("approach:decision")) 
				sysEFIS.minsResetPilot:actuate(1) end))
descentChkl:addItem(ChecklistItem:new("APPROACH BRIEFING","COMPLETED",FlowItem.actorPF,1))

-- ================= ARRIVAL PROCEDURE ==================
-- Whatever comes first
-- TRANSITION LEVEL...............ANNOUNCE REACHED   (PM)
-- ALTIMETERS............................LOCAL QNH (BOTH)
-- ====
-- 10.000 FT......................ANNOUNCE REACHED   (PM)
-- LANDING LIGHTS...............................ON   (PM)
-- FASTEN BELTS SWITCH..........................ON   (PM)
-- AUTO BRAKE SELECT SWITCH..............AS NEEDED   (PM)
-- LOGO LIGHT SWITCH.....................AS NEEDED   (PM)
-- ======================================================

local arrivalProc = Procedure:new("ARRIVAL PROCEDURE","","ready for approach checklist")
arrivalProc:setFlightPhase(12)

arrivalProc:addItem(IndirectProcedureItem:new("10.000 FT","ANNOUNCE REACHED",FlowItem.actorPM,0,"ldg_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") <= 10000 end,nil,
	function () return activeBriefings:get("arrival:translvl") > 100 end))
arrivalProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorPM,0,true,
	function () kc_macro_ext_lights_below10() kc_speakNoText(0,"ten thousand") end,
	function () return activeBriefings:get("arrival:translvl") > 100 end))
arrivalProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON",FlowItem.actorPM,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
	end,
	function () return activeBriefings:get("arrival:translvl") > 100 end))

arrivalProc:addItem(IndirectProcedureItem:new("TRANSITION LEVEL","ANNOUNCE REACHED",FlowItem.actorPM,0,"ldg_trans_lvl",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < activeBriefings:get("arrival:translvl")*100 end,nil,
	function () return activeBriefings:get("arrival:translvl") <= 100 end))
arrivalProc:addItem(IndirectProcedureItem:new("ALTIMETERS","QNH %s |activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH,0,"ldg_altimeters",
	function () 
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
			else
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
			end
		end
	end,
	function () 
	    kc_speakNoText(0,"transition level")
		if get("laminar/B738/EFIS/baro_set_std_pilot") == 1 then 
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if get("laminar/B738/EFIS/baro_set_std_copilot") == 1 then 
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
			else
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			end
		end
	end,
	function () return activeBriefings:get("arrival:translvl") <= 100 end))

arrivalProc:addItem(IndirectProcedureItem:new("TRANSITION LEVEL","ANNOUNCE REACHED",FlowItem.actorPM,0,"ldg_trans_lvl",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < activeBriefings:get("arrival:translvl")*100 end,nil,
	function () return activeBriefings:get("arrival:translvl") > 100 end))
arrivalProc:addItem(IndirectProcedureItem:new("ALTIMETERS","QNH %s |activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH,0,"ldg_altimeters",
	function () 
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
			else
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
			end
		end
	end,
	function () 
	    kc_speakNoText(0,"transition level")
		if get("laminar/B738/EFIS/baro_set_std_pilot") == 1 then 
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if get("laminar/B738/EFIS/baro_set_std_copilot") == 1 then 
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
			else
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			end
		end
	end,
	function () return activeBriefings:get("arrival:translvl") > 100 end))

arrivalProc:addItem(IndirectProcedureItem:new("10.000 FT","ANNOUNCE REACHED",FlowItem.actorPM,0,"ldg_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") <= 10000 end,nil,
	function () return activeBriefings:get("arrival:translvl") <= 100 end))
arrivalProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorPM,0,true,
	function () kc_macro_ext_lights_below10() kc_speakNoText(0,"ten thousand") end,
	function () return activeBriefings:get("arrival:translvl") > 100 end))
arrivalProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON",FlowItem.actorPM,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up") 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") 
	end,
	function () return activeBriefings:get("arrival:translvl") <= 100 end))

arrivalProc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == activeBriefings:get("approach:autobrake") end,
	function () 
		if activeBriefings:get("approach:autobrake") == 2 then
			command_once("laminar/B738/knob/autobrake_1")
		elseif activeBriefings:get("approach:autobrake") == 3 then
			command_once("laminar/B738/knob/autobrake_2")
		elseif activeBriefings:get("approach:autobrake") == 4 then
			command_once("laminar/B738/knob/autobrake_3")
		elseif activeBriefings:get("approach:autobrake") == 5 then
			command_once("laminar/B738/knob/autobrake_max")
		end
	end))
arrivalProc:addItem(ProcedureItem:new("LOGO LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",FlowItem.actorFO,0,
	function () return sysLights.logoSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.logoSwitch:actuate( kc_is_daylight() and 0 or 1) end ))

-- =============== APPROACH CHECKLIST (PM) ==============
-- ALTIMETERS............................QNH _____ (BOTH)
-- NAV AIDS..........................SET & CHECKED   (PM)
-- ======================================================

local approachChkl = Checklist:new("APPROACH CHECKLIST","","approach checklist completed")
approachChkl:setFlightPhase(13)
approachChkl:addItem(ChecklistItem:new("#exchange|ALTIMETERS|approach checklist. altimeters","QNH %s |activeBriefings:get(\"arrival:atisQNH\")",FlowItem.actorBOTH,0,true,
	function () 
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999 and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999
			else
				return 	get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == tonumber(activeBriefings:get("arrival:atisQNH")) and 
						get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == tonumber(activeBriefings:get("arrival:atisQNH"))
			end
		end
	end,
	function () 
		if activeBriefings:get("arrival:atisQNH") ~= "" then
			if activePrefSet:get("general:baro_mode_hpa") then
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
			else
				set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			end
		end
	end))
approachChkl:addItem(ChecklistItem:new("NAVIGATION AIDS","SET AND CHECKED",FlowItem.actorBOTH,0,true,nil,nil))

-- =============== LANDING PROCEDURE (PM) ===============
-- LANDING LIGHTS,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ON  (CPT)
-- RWY TURNOFF LIGHTS...........................ON  (CPT)
-- ENGINE START SWITCHES......................CONT   (PM)
-- SPEED BRAKE...............................ARMED   (PF)
-- COURSE NAV 1................................SET  (CPT)
-- COURSE NAV2.................................SET   (FO)
-- ==== Flaps & Gear Schedule
-- FLAPS 1 SPEED...........................REACHED   (PM)
-- FLAPS 1.....................................SET   (PM)
-- FLAPS 5 SPEED...........................REACHED   (PM)
-- FLAPS 5.....................................SET   (PM)
-- FLAPS 10 SPEED..........................REACHED   (PM)
-- FLAPS 10....................................SET   (PM)
-- LANDING GEAR...............................DOWN   (PM)
-- FLAPS 15 SPEED..........................REACHED   (PM)
-- FLAPS 15....................................SET   (PM)
-- FLAPS 25 SPEED..........................REACHED   (PM)
-- FLAPS 25....................................SET   (PM)
-- FLAPS 30........................SET IF REQUIRED   (PM)
-- FLAPS 40........................SET IF REQUIRED   (PM)
-- SPEED BRAKE...............................ARMED   (PM)
-- GO AROUND ALTITUDE......................... SET   (PM)
-- GO AROUND HEADING...........................SET   (PM)
-- ======================================================

local landingProc = Procedure:new("LANDING PROCEDURE","","ready for landing checklist")
landingProc:setFlightPhase(13)
landingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorCPT,0,true,
	function () kc_macro_ext_lights_land() end))
-- landingProc:addItem(ProcedureItem:new("RWY TURNOFF LIGHTS","ON",FlowItem.actorCPT,0,
	-- function () return sysLights.rwyLightGroup:getStatus() > 0 end,
	-- function () sysLights.rwyLightGroup:actuate(1) end))
landingProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",FlowItem.actorPM,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
landingProc:addItem(ProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"approach:nav1Course\")",FlowItem.actorCPT,0,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("approach:nav1Course") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("approach:nav1Course")) end))
landingProc:addItem(ProcedureItem:new("COURSE NAV2","SET %s|activeBriefings:get(\"approach:nav2Course\")",FlowItem.actorFO,0,
	function() return math.ceil(sysMCP.crs2Selector:getStatus()) == activeBriefings:get("approach:nav2Course") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("approach:nav2Course")) end))

landingProc:addItem(SimpleProcedureItem:new("==== Flaps & Gear Schedule"))	
landingProc:addItem(IndirectProcedureItem:new("FLAPS 1 SPEED","REACHED",FlowItem.actorPNF,0,"ldgflap1spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") < get("laminar/B738/pfd/flaps_1") end))
landingProc:addItem(ProcedureItem:new("FLAPS 1","SET",FlowItem.actorPNF,0,"ldgflap1set",
	function () return sysControls.flapsSwitch:getStatus() == 0.125 end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 5 SPEED","REACHED",FlowItem.actorPNF,0,"ldgflap5spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") < get("laminar/B738/pfd/flaps_5") end,
	function () kc_speakNoText("speed check flaps 1") end))
landingProc:addItem(ProcedureItem:new("FLAPS 5","SET",FlowItem.actorPNF,0,"ldgflap5set",
	function () return sysControls.flapsSwitch:getStatus() == 0.375 end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 10 SPEED","REACHED",FlowItem.actorPNF,0,"ldgflap10spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") < get("laminar/B738/pfd/flaps_10") end,
	function () kc_speakNoText("speed check flaps 5") end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 10","SET",FlowItem.actorPNF,0,"ldgflap10set",
	function () return sysControls.flapsSwitch:getStatus() == 0.500 end))
landingProc:addItem(IndirectProcedureItem:new("LANDING GEAR","DOWN",FlowItem.actorPNF,0,"ldggeardown",
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () kc_speakNoText("speed check flaps 10") end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 15 SPEED","REACHED",FlowItem.actorPNF,0,"ldgflap15spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") < get("laminar/B738/pfd/flaps_15") end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 15","SET",FlowItem.actorPNF,0,"ldgflap15set",
	function () return sysControls.flapsSwitch:getStatus() == 0.625 end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 25 SPEED","REACHED",FlowItem.actorPNF,0,"ldgflap25spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") < get("laminar/B738/pfd/flaps_25") end,
	function () kc_speakNoText("speed check flaps 15") end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 25","SET",FlowItem.actorPNF,0,"ldgflap25set",
	function () return sysControls.flapsSwitch:getStatus() == 0.75 end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 30","SET",FlowItem.actorPNF,0,"ldgflap30set",
	function () return sysControls.flapsSwitch:getStatus() == 0.875 end,
	function () kc_speakNoText("speed check flaps 25") end,
	function () return activeBriefings:get("approach:flaps") < 2 end))
landingProc:addItem(IndirectProcedureItem:new("FLAPS 40","SET",FlowItem.actorPNF,0,"ldgflap40set",
	function () return sysControls.flapsSwitch:getStatus() == 0.875 end,
	function () kc_speakNoText("speed check flaps 30") end,
	function () return activeBriefings:get("approach:flaps") < 3 end))
landingProc:addItem(ProcedureItem:new("SPEED BRAKE","ARMED",FlowItem.actorPF,0,
	function () return get("laminar/B738/annunciator/speedbrake_armed") == 1 end,
	function () kc_speakNoText(0,"Speed brake armed?") end))
landingProc:addItem(ProcedureItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
landingProc:addItem(ProcedureItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))

-- =============== LANDING CHECKLIST (PM) ===============
-- ENGINE START SWITCHES......................CONT   (PF)
-- SPEEDBRAKE................................ARMED   (PF)
-- LANDING GEAR...............................DOWN   (PF)
-- FLAPS..........................___, GREEN LIGHT   (PF)
-- GO AROUND ALTITUDE......................... SET   (PM)
-- GO AROUND HEADING...........................SET   (PM)
-- ======================================================

local landingChkl = Checklist:new("LANDING CHECKLIST","","landing checklist completed")
landingChkl:setFlightPhase(13)
landingChkl:addItem(ChecklistItem:new("#exchange|ENGINE START SWITCHES|landing checklist. ENGINE START SWITCHES","CONT",FlowItem.actorPF,0,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:actuate(2) end)) 
landingChkl:addItem(ChecklistItem:new("SPEED BRAKE","ARMED",FlowItem.actorPF,0,
	function () return get("laminar/B738/annunciator/speedbrake_armed") == 1 end))
landingChkl:addItem(ChecklistItem:new("LANDING GEAR","DOWN",FlowItem.actorPF,0,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
landingChkl:addItem(ChecklistItem:new("FLAPS","%s, GREEN LIGHT|kc_pref_split(kc_LandingFlaps)[activeBriefings:get(\"approach:flaps\")]",FlowItem.actorPF,0,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("approach:flaps")+5] 
	and get("laminar/B738/annunciator/slats_extend") == 1 end,
	function () sysControls.flapsSwitch:setValue(sysControls.flaps_pos[activeBriefings:get("approach:flaps")+5]) end))
landingChkl:addItem(ChecklistItem:new("GO AROUND ALTITUDE","SET %s|activeBriefings:get(\"approach:gaaltitude\")",FlowItem.actorPM,0,
	function() return sysMCP.altSelector:getStatus()  == activeBriefings:get("approach:gaaltitude") end,
	function() sysMCP.altSelector:setValue(activeBriefings:get("approach:gaaltitude")) end))
landingChkl:addItem(ChecklistItem:new("GO AROUND HEADING","SET %s|activeBriefings:get(\"approach:gaheading\")",FlowItem.actorPM,0,
	function() return sysMCP.hdgSelector:getStatus() == activeBriefings:get("approach:gaheading") end,
	function() sysMCP.hdgSelector:setValue(activeBriefings:get("approach:gaheading")) end))

-- ============== AFTER LANDING PROCEDURE ===============
-- SPEED BRAKE................................DOWN   (PF)
-- CHRONO & ET................................STOP  (CPT)
-- WX RADAR....................................OFF  (CPT)
-- APU.......................................START   (FO)
--   Hold APU switch in START position for 3-4 seconds
--   APU GEN OFF BUS LIGHT.............ILLUMINATED   (FO)
-- PROBE HEAT..................................OFF   (FO)
-- STROBES.....................................OFF   (FO)
-- LANDING LIGHTS..............................OFF   (FO)
-- TAXI LIGHTS..................................ON  (CPT)
-- ENGINE START SWITCHES.......................OFF   (FO)
-- TRAFFIC SWITCH..............................OFF   (FO)
-- AUTOBRAKE...................................OFF   (FO)
-- FLAPS........................................UP   (FO)
-- APU...........................START IF REQUIRED   (FO)
-- ======================================================

local afterLandingProc = Procedure:new("AFTER LANDING PROCEDURE","cleaning up")
afterLandingProc:setFlightPhase(15)
afterLandingProc:addItem(ProcedureItem:new("SPEED BRAKE","DOWN",FlowItem.actorPF,0,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
afterLandingProc:addItem(ProcedureItem:new("CHRONO & ET","STOP",FlowItem.actorCPT,2))
afterLandingProc:addItem(ProcedureItem:new("WX RADAR","OFF",FlowItem.actorCPT,0,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorFO,0,true,
	function () kc_macro_ext_lights_rwyvacate() end))
afterLandingProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:actuate(1) end))
afterLandingProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysEFIS.tfcPilot:getStatus() == 0 end,
	function () sysEFIS.tfcPilot:actuate(0) end))
afterLandingProc:addItem(ProcedureItem:new("AUTOBRAKE","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.autobrake:getStatus() == 1 end,
	function () sysGeneral.autobrake:actuate(1) end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","TARA",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrTARA end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrTARA) end,
	function () return activePrefSet:get("general:xpdrusa") == false end))
afterLandingProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) end,
	function () return activePrefSet:get("general:xpdrusa") == true end))
afterLandingProc:addItem(ProcedureItem:new("FLAPS","UP",FlowItem.actorFO,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end))
afterLandingProc:addItem(ProcedureItem:new("#spell|APU#","START",FlowItem.actorFO,0,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () 
		kc_macro_b738_lowerdu_sys()
		kc_procvar_set("apustart")
	end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
afterLandingProc:addItem(SimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds.",
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
afterLandingProc:addItem(IndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",FlowItem.actorFO,0,"apu_gen_bus_end",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,nil,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))

-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- TAXI LIGHT SWITCH...........................OFF  (CPT) 
-- PARKING BRAKE...............................SET  (CPT)
-- ==== Electrical power
-- APU GENERATOR BUS SWITCHES.........ON IF NEEDED   (FO)
-- GRD POWER AVAILABLE LIGHT...........ILLUMINATED   (FO)
-- GROUND POWER SWITCH................ON IF NEEDED   (FO)
-- ENGINE START LEVERS......................CUTOFF  (CPT)
-- FASTEN BELTS SWITCH.........................OFF   (FO)
-- ANTI COLLISION LIGHT SWITCH.................OFF   (FO)
-- FUEL PUMPS..............APU 1 PUMP ON, REST OFF  (CPT)
-- FUEL PUMPS............ALL OFF IF APU NOT RUNNIG  (CPT)
-- CAB/UTIL POWER SWITCH........................ON  (CPT)
-- IFE/PASS SEAT POWER SWITCH..................OFF  (CPT)
-- PROBE HEAT..................................OFF   (FO)
-- WING ANTI-ICE SWITCH........................OFF   (FO)
-- ENGINE ANTI-ICE SWITCHES....................OFF   (FO)
-- ENGINE HYDRAULIC PUMPS SWITCHES..............ON   (FO)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES...........OFF   (FO)
-- RECIRCULATION FAN SWITCHES.................AUTO   (FO)
-- AIR CONDITIONING PACK SWITCHES.............AUTO   (FO)
-- ISOLATION VALVE SWITCH.....................OPEN   (FO)
-- ENGINE BLEED AIR SWITCHES....................ON   (FO)
-- APU BLEED AIR SWITCH...............ON IF NEEDED   (FO)
-- FLIGHT DIRECTOR SWITCHES....................OFF   (FO)
-- TRANSPONDER................................STBY   (FO)
-- MCP.......................................RESET   (FO)
-- ======================================================

local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE","shutting down","ready for shutdown checklist")
shutdownProc:setFlightPhase(17)
-- shutdownProc:addItem(ProcedureItem:new("TAXI LIGHT SWITCH","OFF",FlowItem.actorCPT,0,
	-- function () return sysLights.taxiSwitch:getStatus() == 0 end,
	-- function () sysLights.taxiSwitch:actuate(0) activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
shutdownProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownProc:addItem(SimpleChecklistItem:new("==== Electrical power"))
shutdownProc:addItem(ProcedureItem:new("#spell|APU# GENERATOR BUS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:actuate(1) sysElectric.apuGenBus2:actuate(1) end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("  #exchange|GRD|GROUND# POWER AVAILABLE LIGHT","ILLUMINATED",FlowItem.actorFO,0,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,
	function () 
		kc_macro_gpu_connect()
	end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("GROUND POWER SWITCH","ON",FlowItem.actorFO,0,
	function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	function () sysElectric.gpuSwitch:actuate(cmdDown) end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () kc_speakNoText(0,"ready to cut engines") end))
shutdownProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("EXTERNAL LIGHTS","SET",FlowItem.actorCPT,0,true,
	function () kc_macro_ext_lights_stand() activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end))
shutdownProc:addItem(ProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",FlowItem.actorCPT,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () kc_macro_fuelpumps_stand() end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",FlowItem.actorCPT,0,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))
shutdownProc:addItem(ProcedureItem:new("IFE/PASS SEAT POWER SWITCH","OFF",FlowItem.actorCPT,0,
	function () return sysElectric.ifePwr:getStatus() == modeOff end,
	function () sysElectric.ifePwr:actuate(modeOff) end))
shutdownProc:addItem(ProcedureItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",FlowItem.actorFO,0,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () kc_macro_hydraulic_initial() end))
shutdownProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () kc_macro_hydraulic_initial() end))
shutdownProc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
shutdownProc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() > 1 end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeAuto) end))
shutdownProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",FlowItem.actorFO,0,
	function () return sysAir.isoValveSwitch:getStatus() == sysAir.isoVlvOpen end,
	function () sysAir.isoValveSwitch:setValue(sysAir.isoVlvOpen) end))
shutdownProc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",FlowItem.actorFO,0,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () kc_macro_bleeds_on() end))
shutdownProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",FlowItem.actorFO,0,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,nil,
	function () return not activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","OFF",FlowItem.actorFO,0,
	function () return sysMCP.fdirGroup:getStatus() == 0 end,
	function () sysMCP.fdirGroup:actuate(0) end))
shutdownProc:addItem(ProcedureItem:new("TRANSPONDER","STBY",FlowItem.actorFO,0,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrStby end,
	function () sysRadios.xpdrSwitch:actuate(sysRadios.xpdrStby) end))
shutdownProc:addItem(ProcedureItem:new("DOORS","OPEN",FlowItem.actorFO,0,true,
	function () kc_macro_ext_doors_stand() end))
shutdownProc:addItem(ProcedureItem:new("MCP","RESET",FlowItem.actorFO,0,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		kc_macro_b738_lowerdu_off()
		kc_macro_glareshield_initial()
		-- stairs need a delay to be extended
		if activeBriefings:get("taxi:gateStand") > 1 then
			if get("laminar/B738/airstairs_hide") == 1  then
				command_once("laminar/B738/airstairs_toggle")
			end
		end
	end))

 -- ============== SHUTDOWN CHECKLIST (F/O) ==============
 -- FUEL PUMPS..................................OFF  (F/O)
 -- PROBE HEAT.............................AUTO/OFF  (F/O)
 -- HYDRAULIC PANEL.............................SET  (F/O)
 -- FLAPS........................................UP  (CPT)
 -- PARKING BRAKE.......................AS REQUIRED  (CPT)
 -- ENGINE START LEVERS......................CUTOFF  (CPT)
 -- WEATHER RADAR...............................OFF (BOTH)
 -- ======================================================

local shutdownChkl = Checklist:new("SHUTDOWN CHECKLIST","","shutdown checklist completed")
shutdownChkl:setFlightPhase(17)
shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","ONE PUMP ON FOR APU, REST OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 1 end,
	function () sysFuel.allFuelPumpGroup:actuate(modeOff) sysFuel.fuelPumpLeftAft:actuate(modeOn) end,
	function () return activeBriefings:get("approach:powerAtGate") == 1 end))
shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","OFF",FlowItem.actorFO,0,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.allFuelPumpGroup:actuate(modeOff) end,
	function () return activeBriefings:get("approach:powerAtGate") == 2 end))
shutdownChkl:addItem(ChecklistItem:new("PROBE HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownChkl:addItem(ChecklistItem:new("HYDRAULIC PANEL","SET",FlowItem.actorFO,2))
shutdownChkl:addItem(ChecklistItem:new("FLAPS","UP",FlowItem.actorCPT,0,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () sysControls.flapsSwitch:setValue(0) end)) 
shutdownChkl:addItem(ChecklistItem:new("PARKING BRAKE","ON",FlowItem.actorCPT,0,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",FlowItem.actorCPT,0,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(cmdDown) end))
shutdownChkl:addItem(ChecklistItem:new("WEATHER RADAR","OFF",FlowItem.actorBOTH,0,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) sysEFIS.wxrCopilot:actuate(0) end))

-- =============== SECURE CHECKLIST (F/O) ===============
-- IRSs........................................OFF  (F/O)
-- EMERGENCY EXIT LIGHTS.......................OFF  (F/O)
-- WINDOW HEAT.................................OFF  (F/O)
-- PACKS.......................................OFF  (F/O)
-- ======================================================

local secureChkl = Checklist:new("SECURE CHECKLIST","","secure checklist completed")
secureChkl:setFlightPhase(1)
secureChkl:addItem(ChecklistItem:new("#exchange|IRS MODE SELECTORS|SECURE CHECKLIST. I R S MODE SELECTORS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitOFF) end))
secureChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",FlowItem.actorFO,0,
	function () return sysGeneral.emerExitLightsSwitch:getStatus() == 0  end,
	function () sysGeneral.emerExitLightsCover:actuate(1) sysGeneral.emerExitLightsSwitch:actuate(0) end))
secureChkl:addItem(ChecklistItem:new("WINDOW HEAT","OFF",FlowItem.actorFO,0,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
secureChkl:addItem(ChecklistItem:new("PACKS","OFF",FlowItem.actorFO,0,
	function () return sysAir.packSwitchGroup:getStatus() == sysAir.packModeOff end,
	function () sysAir.packSwitchGroup:setValue(sysAir.packModeOff) end))

-- ======== STATES =============

-- ================= Cold & Dark State ==================
local coldAndDarkProc = State:new("COLD AND DARK","securing the aircraft","ready for secure checklist")
coldAndDarkProc:setFlightPhase(1)
coldAndDarkProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_cold_and_dark()
	end))
	
-- ================= Turn Around State ==================
local turnAroundProc = State:new("AIRCRAFT TURN AROUND","setting up the aircraft","aircraft configured for turn around")
turnAroundProc:setFlightPhase(18)
turnAroundProc:addItem(ProcedureItem:new("OVERHEAD TOP","SET","SYS",0,true,
	function () 
		kc_macro_state_turnaround()
	end))
turnAroundProc:addItem(ProcedureItem:new("GPU","ON BUS","SYS",0,true,
	function () 
		command_once("laminar/B738/toggle_switch/gpu_dn")
	end))

-- ============= Background Flow ==============
local backgroundFlow = Background:new("","","")

kc_procvar_initialize_bool("toctest", false) -- B738 takeoff config test
kc_procvar_initialize_bool("ovhttest", false) -- B738  OVHT fire test
kc_procvar_initialize_bool("ext1test", false) -- B738  EXT1 fire test
kc_procvar_initialize_bool("ext2test", false) -- B738  EXT2 fire test
kc_procvar_initialize_bool("mach1test", false) -- B738 MACH OVSPD L test
kc_procvar_initialize_bool("mach2test", false) -- B738 MACH OVSPD R test
kc_procvar_initialize_bool("stall1test", false) -- B738 STALL L test
kc_procvar_initialize_bool("stall2test", false) -- B738 STALL R test
kc_procvar_initialize_bool("gpwstest", false) -- B738 GPWS test
kc_procvar_initialize_bool("oxyfotest", false) -- B738 OXY FO test
kc_procvar_initialize_bool("oxycpttest", false) -- B738 OXY CPT test
kc_procvar_initialize_bool("cargofiretest", false) -- B738 CARGO FIRE test
kc_procvar_initialize_bool("apustart", false) -- B738 start apu
kc_procvar_initialize_bool("gen1down", false) -- B738 hold GEN1 switch down
kc_procvar_initialize_bool("gen2down", false) -- B738 hold GEN2 switch down

backgroundFlow:addItem(BackgroundProcedureItem:new("","","SYS",0,
	function () 
		if kc_procvar_get("toctest") == true then 
			kc_bck_b738_toc_test("toctest")
		end
		if kc_procvar_get("ovhttest") == true then 
			kc_bck_b738_ovht_test("ovhttest")
		end
		if kc_procvar_get("ext1test") == true then 
			kc_bck_b738_ext1_test("ext1test")
		end
		if kc_procvar_get("ext2test") == true then 
			kc_bck_b738_ext2_test("ext2test")
		end
		if kc_procvar_get("mach1test") == true then 
			kc_bck_b738_mach1_test("mach1test")
		end
		if kc_procvar_get("mach2test") == true then 
			kc_bck_b738_mach2_test("mach2test")
		end
		if kc_procvar_get("stall1test") == true then 
			kc_bck_b738_stall1_test("stall1test")
		end
		if kc_procvar_get("stall2test") == true then 
			kc_bck_b738_stall2_test("stall2test")
		end
		if kc_procvar_get("gpwstest") == true then 
			kc_bck_b738_gpws_test("gpwstest")
		end
		if kc_procvar_get("oxyfotest") == true then 
			kc_bck_b738_oxyfo_test("oxyfotest")
		end
		if kc_procvar_get("oxycpttest") == true then 
			kc_bck_b738_oxycpt_test("oxycpttest")
		end
		if kc_procvar_get("cargofiretest") == true then 
			kc_bck_b738_cargofire_test("cargofiretest")
		end
		if kc_procvar_get("apustart") == true then 
			kc_bck_b738_apustart("apustart")
		end
		if kc_procvar_get("gen1down") == true then 
			kc_bck_b738_gen1down("gen1down")
		end
		if kc_procvar_get("gen2down") == true then 
			kc_bck_b738_gen2down("gen2down")
		end
	end))
	

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(testProc)
-- activeSOP:addProcedure(electricalPowerUpProc)
-- activeSOP:addProcedure(prelPreflightProc)
-- activeSOP:addProcedure(cduPreflightProc)
-- activeSOP:addProcedure(preflightFOProc)
-- activeSOP:addProcedure(preflightFO2Proc)
-- activeSOP:addProcedure(preflightFO3Proc)
-- activeSOP:addProcedure(preflightCPTProc)
-- activeSOP:addChecklist(preflightChkl)
-- activeSOP:addProcedure(beforeStartProc)
-- activeSOP:addChecklist(beforeStartChkl)
-- activeSOP:addProcedure(pushstartProc)
-- activeSOP:addProcedure(beforeTaxiProc)
-- activeSOP:addChecklist(beforeTaxiChkl)
-- activeSOP:addChecklist(beforeTakeoffChkl)
-- activeSOP:addProcedure(runwayEntryProc)
-- activeSOP:addProcedure(takeoffClimbProc)
-- activeSOP:addChecklist(afterTakeoffChkl)
-- activeSOP:addProcedure(descentProc)
-- activeSOP:addChecklist(descentChkl)
-- activeSOP:addProcedure(arrivalProc)
-- activeSOP:addChecklist(approachChkl)
-- activeSOP:addProcedure(landingProc)
-- activeSOP:addChecklist(landingChkl)
-- activeSOP:addProcedure(afterLandingProc)
-- activeSOP:addProcedure(shutdownProc)
-- activeSOP:addChecklist(shutdownChkl)
-- activeSOP:addChecklist(secureChkl)

-- =========== States ===========
-- activeSOP:addState(turnAroundProc)
-- activeSOP:addState(coldAndDarkProc)

-- ==== Background Flow ====
activeSOP:addBackground(backgroundFlow)

function getActiveSOP()
	return activeSOP
end

return SOP_A359
