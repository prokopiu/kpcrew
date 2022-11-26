-- Base SOP for Laminar and REP C-172

-- @classmod SOP_C172
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local SOP_C172 = {
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

activeSOP = SOP:new("Laminar Cessna 172SP Skyhawk (REP)")

-- OPERATION Data
-- Max Altitude..........14.000 ft
-- Max Speed (Vne)..........163 kt
-- Normal Speed (Vno) .......129 kt
-- Maneuvering Speed (Va) ...105 kt
-- Flaps Limit Speed (Vfe) ..110 kt
-- Best Climb Speed
-- Flaps Take-Off ..........60 kt
-- Flaps Up ................76 kt
-- Landing Speed..........65-75 kt

-- AIRSPEED REVIEW
-- Vy-73 KIAS (Sea Level) 68 KIAS (10,000')
-- Vx-59 KIAS (Sea Level) 61 KIAS (10,000')
-- Best Glide-65 KIAS Flaps Up


-- INTERIOR INSPECTION
-- HOBBS/TACH TIMES ................................... RECORD
-- Control Lock ................................................ REMOVE
-- A.R.0.W. Documents ..................................... VERIFY ENGi NE START
-- Fuel Selector ................... MOVE: LEFT/RIGHT/ BOTH
-- ALT/BAT MasterSwitch ......... BATTERY SIDE UP/ON
-- Fuel Quantity lndicators .. CHECK Working/ Quantity
-- Turn Coordinator ........................................ NO FLAG
-- Flaps ................. ................................ .............. DOWN 
-- Lights ................................ ALL ON, VERIFY Working,
-- THEN All SWITCHES OFF
-- {Check Instrument Panel Lights Before Night Flight)
-- Pitot Heat ... VERIFY WORKING PRIOR TO IFR FLIGHT
-- ALT/BAT Master Switch ...................................... OFF

-- EXTERIOR INSPECTION
-- Fuel {Pilot's Side; Left Wing) ........................... SUMP
-- Flap {lnboard) .............................................. INSPECT
-- Baggage Area .......................... ..................... lNSPECT
-- Fuselage ........... ............................................ lNSPECT
-- Empennage: Elevator, Rudder, Trim ........... lNSPECT
-- Tail Tie Down .................... ...... .................... REMOVE
-- Fuselage & Belly .......................................... l NSPECT
-- Fuel (Right Wing) ............................................. SUMP
-- Tire(29psi)Wheel/Brake ... lNSPECT / Remove Checks
-- Right Wing Flap, Aileron & Leading Edge .... lNSPECT
-- Tie Down ..................................................... REMOVE
-- Fuel Quantity (Right Wing) ............................ VERIFY
-- Oil (6qts max, 4qts min, 100w Plus) ............ INSPECT
-- Engine Fuel. ........ SUMP (pull from inside oil access) 
-- Prop & Engine .............................................. lNSPECT
-- Air Filter ....................................................... 1NSPECT 
-- Nose Wheel, Tire (31psi) & nose strut.. ...... lNSPECT
-- Static Source ................................................... CLEAR
-- Fuel Quantity (Left Wing) ............................... VERIFY
-- Pitot Cover ....................... REMOVE & VERIFY CLEAR
-- Fuel Vent & Stall Horn Vent.. .............. VERIFY CLEAR
-- Tie Down ..................................................... REMOVE 
-- Wing leading Edge, Aileron & Flap ............. lNSPECT 
-- Tire(29psi) Wheel/Brake lnspect & Remove Chocks

-- ====================== PREFLIGHT ======================
-- DOORS..............................................OPEN		:172/exterior/L_door:1.0
-- REFUEL AND INSPECT AIRCRAFT......................REFUEL		:(sim/cockpit2/fuel/fuel_quantity[0]:><0.01)||(sim/cockpit2/fuel/fuel_quantity[1]:><0.01)
-- ENTER COCKPIT & CLOSE DOORS.......................CLOSE		:(172/exterior/L_door:0.0)&&(172/exterior/R_door:0.0)
-- MASTER BATTERY SWITCH................................ON		:sim/cockpit/electrical/battery_on:1
-- AVIONICS MASTER SWITCH...............................ON		:sim/cockpit/electrical/avionics_on:1
-- GPS (FOR RADIOS & PLN)...............................ON		:sim/cockpit2/radios/actuators/gps_power:1
-- == FILE FLIGHT PLAN
-- GPS.................................................OFF		:sim/cockpit2/radios/actuators/gps_power:0
-- AVIONICS MASTER SWITCH..............................OFF		:sim/cockpit/electrical/avionics_on:0
-- MASTER BATTERY SWITCH...............................OFF		:sim/cockpit/electrical/battery_on:0

-- Parking brake...............SET
-- Ignition Switch.............OFF
-- Avionics....................OFF
-- Master Switch................ON
-- Fuel Level..............Checked
-- Avioncs......ON and fan audible
-- Avionics....................OFF
-- Fuel Selector..............BOTH
-- Flaps...........CKECK OPERATION
-- Annunciator Panel.......CHECKED
-- Master Switch...............OFF
-- Documents..............On Board
-- =======================================================

-- 1. Passenger Briefing & Safety Belts ........... COMPLETE
-- 2. Brakes ....................................................... SET HOLD
-- 3. Beacon Light .............. .................................... UP/ON
-- 4. Mixture .................... ........... RICH (Full Fwd Position)
-- 5. Carb Heat ............................. OFF (Full Fwd Position)
-- 6. Prime ..................................... 3x (Winter 4x) & LOCK
-- 7. Master Switch (ALT/BAT) ........ ....................... UP/ON
-- 8. "CLEAR" Area & Confirm Safe to Start.. ................... .
-- 9. Throttle ............................................. ADVANCE 1/4"
-- 10. lgnition/Mag Switch ............................. START/BOTH
-- 11. RPM ........................ ......................... .... SET l000rpm
-- 12. Oil Pres & Temp ... VERI FY RISING (30-60sec)-GREEN
-- 13. Avionics Master Switch ................................. UP/ON
-- 14. Lights: Nav, Taxi, & Landing (as required); UP/ON
-- (for night operations interior lights on) .................. ..
-- 15. Transponder ..... .......... ifURN to STBY {1200 for VFR)
-- 16. Radios; Audio Panel-lntercom- GPS-Comm Set
-- & Verify Correct Frequencies ......... ....... ................... .
-- 17. Flaps ........................................................... RETRACT
-- 18. Mixture ....... LEAN 1" (or as required for density alt)

-- ===================== ENGINE START ====================
-- == Before Engine Start
-- ALL SWITCHES AND SELECTORS..........................OFF		:find list
-- PARKING BRAKE...................................ENGAGED		:sim/flightmodel/controls/parkbrake:>0.4
-- FUEL SELECTOR......................................BOTH		:172/panel_actuators/fuel_tank_select:0
-- FUEL SHUTOFF.......................................PUSH		:172/panel_actuators/fuel_shut:1
-- STATIC AIR.........................................PUSH		:172/panel_actuators/static_air:1

-- Passenger Briefing.....COMPLETE
-- Seats and Belts........Adjusted
-- Circuit Breakers.............IN
-- Electrical Equipment........OFF
-- Avionics....................OFF
-- Master Switch................ON
-- Fuel Selector..............BOTH
-- Fuel Shutoff............FULL IN

-- == Engine Start
-- MASTER SWITCH........................................ON		:(sim/cockpit/electrical/battery_on:1)&&(sim/cockpit/electrical/generator_on[0]:1)
-- CHECK FUEL QUANTITY...............................CHECK		:(172/instruments/uni_fuel_L_x:>15.0)&&(172/instruments/uni_fuel_R_x:>15.0)
-- SEATBELTS / SHOULDER HARNESS...................FASTENED
-- BRAKES.......................................TEST & SET		:sim/flightmodel/controls/parkbrake:1
-- FUEL SELECTOR......................................BOTH		:laminar/c172/fuel/fuel_tank_selector:4
-- FUEL SHUTOFF VALVE..............................ON (IN)		:laminar/c172/fuel/fuel_cutoff_selector:0
-- BEACON LIGHT.........................................ON		:sim/cockpit2/switches/beacon_on:1
-- NAV LIGHT............................................ON		:sim/cockpit2/switches/nav_lights_on:1
-- THROTTLE...........................................IDLE		:sim/cockpit2/engine/actuators/throttle_ratio_all:0
-- MIXTURE.......................................FULL LEAN		:172/engine/mixture_ratio_0:<0.1
-- CIRCUIT BREAKERS..................................CHECK
-- AVIONICS SWITCH.....................................OFF		:simcoders/rep/cockpit2/switches/avionics_power_on:0
-- THROTTLE..................................OPEN 1/4 INCH		:sim/cockpit2/engine/actuators/throttle_ratio_all:0.08|0.26
-- If engine cold: (temperature?)
--   AUX. PUMP..........................................ON		:sim/cockpit/engine/fuel_pump_on[0]:1
--   MIXTURE...............RICH UNTIL 3-5 GPH THEN CUT OFF		:simcoders/rep/engine/fuelline/commanded_mixture_ratio_0:1
--   AUX. PUMP.........................................OFF		:sim/cockpit/engine/fuel_pump_on[0]:0
-- PROPELLER AREA....................................CLEAR
-- STARTER..........................................ENGAGE		:simcoders/rep/engine/starter/engaged:1
-- IGNITION...........................................BOTH
-- MIXTURE.....................................PUSH GENTLY		:172/engine/mixture_ratio_0:><0.01
-- THROTTLE.......................................1000 RPM		:sim/cockpit2/engine/indicators/engine_speed_rpm[0]:900|1100
-- MIXTURE....................................LEAN FOR GND		:172/engine/mixture_ratio_0:><0.01
-- MASTER ALTERNATOR....................................ON		:sim/cockpit/electrical/generator_on[0]:1
-- FUEL FLOW GAUGE..........................CHECK IN GREEN		:sim/cockpit2/engine/indicators/fuel_flow_kg_sec[0]:0.002700|0.003300
-- OIL PRESSURE............................CHECK 55-65 PSI		:172/instruments/oil_pressure_psi_x:56|66
-- OIL TEMPERATURE...........................WAIT INCREASE		:sim/cockpit2/engine/indicators/oil_temperature_deg_C[0]:><0.3

-- Throttle.............Open 1/4in
-- Mixture....................IDLE
-- Propeller Area............CLEAR
-- Master Switch................ON
-- Beacon Light.................ON
-- Cool Start
-- Auxiliary Fuel Pump..........ON
-- Mixture.........FULL 5 sec/IDLE
-- Auxiliary Fuel Pump.........OFF
-- Ignition Switch...........START
-- Mixture.................Advance
-- Oil Pressure..............CHECK
-- Nav Lights..........ON at night

-- =======================================================

-- PRE-TAXI CHECKS
-- 1. DG ............................ ........................... SET HEADING
-- 2. Radio ................... LISTEN & CALL (ATIS/AWOS/CTAF)
-- 3. Wind Direction/Speed & Runway in Use„CONFIRM
-- 4. Clear Behind You Prior to Throttling up for Taxi .....
-- 5. Brakes .......................... ................. VERIFY WORKING
-- 6. Controls ............ PREPAIRE TOSET FOR WIND IF REQ.

-- ===================== BEFORE TAXI =====================
-- AVIONICS MASTER SWITCH...............................ON		:sim/cockpit/electrical/avionics_on:1
-- GPS/COM-NAV/ADF/DME............................ON & SET		:(sim/cockpit2/radios/actuators/gps_power:1)&&(172/av_panel/nav2/nav2_on_off_v:1)&&(172/av_panel/adf/adf_on_off_v:1)&&(sim/cockpit2/radios/actuators/transponder_mode:>0)&&(172/av_panel/dme/dme_on_off_v:1)
-- TRANSPONDER................................SET and STBY		:(sim/cockpit/radios/transponder_mode:1)&&(sim/cockpit/radios/transponder_code:>0000)
-- AUTOPILOT...........................................OFF		:sim/cockpit/autopilot/autopilot_mode:0
-- ANNUNCIATORS SWITCH................................TEST		:172/annunciators/annun_switch:2
-- FLAPS...........................................FULL UP		:sim/flightmodel/controls/wing1l_fla1def:0
-- ELEVATOR TRIM...................................SET T/O		:172/control_surfaces/elevator_trim:><0.01
-- ALTIMETER.......................................SET QNH		:sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot:><0.01
-- CLOCK...............................................SET		:172/instruments/clock_mode_bottom:><0.1 

-- Avionics.....................ON
-- COM....................ON / Set
-- NAV....................ON / Set
-- Transponder.............STANDBY
-- Altimeter...................SET
-- Transponder.................SET
-- Horizon.....................SET

-- =======================================================



-- ======================== TAXI =========================
-- ## REQUEST TAXI
-- TAXI LIGHT SWITCH....................................ON		:sim/cockpit2/switches/taxi_light_on:1
-- PARKBRAKE.......................................RELEASE		:sim/flightmodel/controls/parkbrake:0
-- ## Brake Test
--   LEFT BRAKE.......................................TEST		:sim/cockpit2/controls/left_brake_ratio:>0.03
--   RIGHT BRAKES.....................................TEST		:sim/cockpit2/controls/right_brake_ratio:>0.03
--   TURN INDICATOR AND RMI...................CHECK MOVING		:(sim/flightmodel/misc/turnrate_noroll:<-8.0)||(sim/flightmodel/misc/turnrate_noroll:>8.0)
-- ## Go To Holding Point
-- PARKBRAKE...........................................SET		:sim/flightmodel/controls/parkbrake:1
-- ## Power Test
-- MIXTURE.......................................FULL RICH		:172/engine/mixture_ratio_0:1.0
-- THROTTLE.......................................1800 RPM		:sim/cockpit2/engine/indicators/engine_speed_rpm[0]:1750|1850
-- MAGNETO KEY........................................LEFT		:172/ip_base/b_ignition:1.7|2.2
-- id:    => Check Drop <150 RPM
-- MAGNETO KEY........................................BOTH		:172/ip_base/b_ignition:2.6|3.2
-- MAGNETO KEY.......................................RIGHT		:172/ip_base/b_ignition:0.8|1.2
-- id:    => Check Drop <150 RPM
-- MAGNETO KEY........................................BOTH		:172/ip_base/b_ignition:2.6|3.2
-- ENGINE INSTRUMENTS............................IN LIMITS
-- THROTTLE.......................................1000 RPM		:sim/cockpit2/engine/indicators/engine_speed_rpm[0]:950|1050
-- FLAPS............................................10 DEG		:sim/flightmodel/controls/wing1l_fla1def:10
-- MIXTURE....................................LEAN FOR GND		:172/engine/mixture_ratio_0:><0.01

-- Taxi Light...................ON
-- Parking Brake..........Unlocked
-- Brakes.....................Test
-- Instruments.............Checked

-- =======================================================

-- BEFORE TAKEOFF "RUN-UP" CHECKS
-- 1. Controls ............ ............... FREE & CORRECT
-- 2. Fl ight lnstruments .................. VERIFY & SET
-- 3. Radio Set FREQS/ VOR SET/ GPS SET or Fl T
-- PLAN SELECT .............................................. .
-- 4. Transponder; VERIFY ON & CORRECT
-- CODE (VFR or Desired) .............................. ..
-- 5. Gas Selector ........................................ BOTH
-- 6. Trim ................................ SET FORT AKEOFF
-- 7. Mixture .................................................... RICH
-- 8. Throttle ....................................... 1700 RPM
-- 9. Carb Heat.. .......... PULL ON; VERIFY OP; OFF
-- 10. Right MAG ... SELECT & VERIFY DROP; BOTH
-- 11. Left MAG ..... SELECT & VERIFY DROP; BOTH
-- (MAG DROP 5....125RPM or not more than
-- S0PRM Difference)
-- 12. Suction Gage ...................................... GREEN
-- 13. Oil Pres & Temp ............................... GREEN
-- 14. Amp Meter. .. ............................ ........ CHECK
-- 15. High Density Alt. ...... LEAN for MAX POWER
-- 16. Throttle; CHECK AT IDLE; Reset 900-1000
-- 17. Safety-Doors-Windows-Safety Belts
-- 18. Review ...... DEPARTURE PLAN & AIRSPEEDS
-- 19. Visually Clear .......... .................. BASE/FINAL
-- (360* Turn at Uncontrolled Airports)


-- HOLD LINE CHECKS
-- 1. Radio Select (if req)-Rescan lnst-Mixture-Flaps
-- 2. Lights .................................................................. ALL ON
-- 3. Trim .................................................. SET FOR TAKEOFF
-- 4. Mixture ................................................................... RICH
-- (Lean for Density Altitude if Appropriate)
-- 5. Transponder .............. SELECT ALT & CONFIRM CODE
-- 6. Flaps .................................................. SET (lf Required)
-- 7. Time ....................................................................... NOTE
-- 8. ANNOUNCE INTENTIONS or Read Back ATC lnstru c.
-- 9. Visually CLEAR BASE & FINAL. ....................................

-- =================== BEFORE TAKEOFF ====================
-- ALL WINDOWS......................................CLOSED		:(172/exterior/L_door_window:0.0)&&(172/exterior/R_door_window:0.0)
-- TRANSPONDER.........................................ALT		:sim/cockpit/radios/transponder_mode:2
-- LAND LIGHT SWITCH....................................ON		:sim/cockpit/electrical/landing_lights_on:1
-- TAXI LIGHT SWITCH...................................OFF		:sim/cockpit2/switches/taxi_light_on:0
-- STROBE LIGHTS SWITCH.................................ON		:sim/cockpit/electrical/strobe_lights_on:1
-- PARKBRAKE.......................................RELEASE		:sim/flightmodel/controls/parkbrake:0
-- ## Line Up
-- PARKBRAKE............................................GO		:sim/flightmodel/controls/parkbrake:1

-- Parking Brake...............SET
-- Seats and Belts........Adjusted
-- Cabin Doors..............Locked
-- Flight Controls.........Correct
-- Flight Intrumentes ......Checked
-- Fuel Level..............Checked
-- Mixture....................RICH
-- Fuel Selector Valve.....Recheck
-- Throttle...............1800 RPM
-- Magnetos..................CHECK
-- Annunciator Panel.........CHECK
-- Throttle...................IDLE
-- COM/NAV.....................SET
-- Transponder.................SET
-- Elevator Trim...........Takeoff
-- Flaps...................Takeoff
-- Exterior Lights..........ALL ON

-- =======================================================

-- AFTER TAKEOFF
-- Airspeed-Heading-Engine-Jnstruments
-- 1. Flaps ....................................................... UP lf Required
-- 2. Engine lnstruments ............................. SCAN & VERIFY
-- 3. Heading/ GPS .......................... CONFIRM ON COURSE
-- 4. Radio: ATC (Flight Following) and/or FSS Activate
-- Flight Plan ........................................... ..... As Oesired

-- ================== TAKEOFF & CLIMB ====================
-- ## Takeoff
-- *** VR 55 KIAS
-- CLOCK.......................................RESET-START		:172/ip_clock/cl_control:><0.1
-- MIXTURE.......................................FULL RICH		:172/engine/mixture_ratio_0:1.0
-- PARKING BRAKE...................................RELEASE		:sim/flightmodel/controls/parkbrake:0
-- THROTTLE...........................................FULL		:sim/cockpit2/engine/actuators/throttle_ratio[0]:>0.95
-- VR 55 KIAS.......................................ROTATE		:sim/cockpit2/gauges/indicators/airspeed_kts_pilot:>55

-- Flaps.........Take-off position
-- Throttle...................FULL
-- Mixture....................RICH
-- Lift-off Speed.............55kt
-- Initial Climb Speed.....70-80kt
-- Transponder.................ALT

-- ## CLIMB
-- *** ABOVE 70 KIAS
-- FLAPS................................................UP		:sim/flightmodel/controls/wing1l_fla1def:0
-- *** ABOVE 300 FEET
-- LAND LIGHT SWITCH...................................OFF		:sim/cockpit/electrical/landing_lights_on:0
-- *** CLIMB SPEED 70-85 KIAS
-- *** Mixture LEAN above 3000' (SET MAX EGT)
-- THROTTLE.....................................FULL POWER		:sim/cockpit2/engine/actuators/throttle_ratio[0]:>0.90
-- PITOT HEAT..................................AS REQUIRED		:sim/cockpit/switches/pitot_heat_on:><0.9
-- ALTIMETER QNH <TA (29.92 >TA).......................SET		:sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot:><0.01
-- ENGINE INSTRUMENTS............................IN LIMITS

-- Power......................FULL
-- Flaps...................RETRACT
-- Elevator Trim............ADJUST
-- Fuel Level/Temp.........Checked
-- Engine Instruments......Checked

-- =======================================================


-- TOP OF CLIMB
-- Pitch - Power-Trim - Time
-- 1. Pitch ......................................................... LEVEL FUG HT
-- 2. Power/ Throttle-SET RPM for Cruise
-- (Cruise Power Settings 2100-2500)
-- 3. Time ....................................................................... NOTE
-- 4. Heading ......................................... VERIFY ON COURSE
-- 5. Lights ........................................................ As Desired
-- 6. Mixture ............................................. LEAN as Required

-- ======================= CRUISE ========================
-- *** Mixture FULL RICH below 3000'
-- *** LEAN above (SET MAX EGT)
-- THROTTLE..................................2100-2400 RPM		:sim/cockpit2/engine/indicators/engine_speed_rpm[0]:2000|2600
-- MIXTURE.....................................SET MAX EGT		:172/engine/mixture_ratio_0:><0.01
-- PITOT HEAT..................................AS REQUIRED		:sim/cockpit/switches/pitot_heat_on:><0.9
-- ALTIMETER QNH <TA (29.92 >TA).......................SET		:sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot:><0.01
-- =======================================================

-- Power....................ADJUST
-- Recommended: 75%
-- Elevator Trim............ADJUST
-- Fuel Level..............Monitor
-- Annunciator Panel.......Monitor

-- ======================= DESCEND =======================
-- THROTTLE........................................ADAPTED		:sim/cockpit2/engine/actuators/throttle_ratio[0]:><0.01
-- MIXTURE.......................................FULL RICH		:172/engine/mixture_ratio_0:1.0
-- PITOT HEAT..................................AS REQUIRED		:sim/cockpit/switches/pitot_heat_on:><0.9
-- FUEL SELECTOR......................................BOTH		:172/panel_actuators/fuel_tank_select:0
-- ALTIMETER QNH <TA (29.92 >TA).......................SET		:sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot:><0.01
-- =======================================================

-- Power....................ADJUST
-- Mixture....................RICH
-- Fuel Selector..............BOTH
-- Landing/Taxi Lights..........ON
-- Approach
-- Altimeter...............Checked
-- Cabin...................Checked
-- Flaps..............1st at 110kt
-- Elevator Trim...............SET
-- Final
-- Flaps...............2nd at 85kt
-- Elevator Trim...............SET

-- ======================= LANDING =======================
-- *** APPROACH SPEED 90 KIAS
-- *** LANDING SPEED 60-70 KIAS
-- THROTTLE........................................ADAPTED		:sim/cockpit2/engine/actuators/throttle_ratio[0]:><0.01
-- MIXTURE.......................................FULL RICH		:172/engine/mixture_ratio_0:1.0
-- PITOT HEAT..................................AS REQUIRED		:sim/cockpit/switches/pitot_heat_on:><0.9
-- FUEL SELECTOR......................................BOTH		:172/panel_actuators/fuel_tank_select:0
-- LAND LIGHT SWITCH....................................ON		:sim/cockpit/electrical/landing_lights_on:1
-- FLAPS............................................10 DEG		:sim/flightmodel/controls/wing1l_fla1def:10
-- FLAPS..................................20 DEG < 80 KIAS		:sim/flightmodel/controls/wing1l_fla1def:20
-- FLAPS..................................30 DEG < 75 KIAS		:sim/flightmodel/controls/wing1l_fla1def:30
-- AUTOPILOT...........................................OFF		:sim/cockpit/autopilot/autopilot_mode:0
-- AFTER TOUCHDOWN............................APPLY BRAKES		:sim/flightmodel/controls/l_brake_add:>0.05
-- =======================================================

-- Flaps..........Landing Position
-- Speed...................65-75kt
-- Touch and go
-- Thrust Level...............FULL
-- Speed......................55kt
-- Flaps............Take-off (1st)

-- ==================== AFTER LANDING ====================
-- FLAPS...........................................FULL UP		:sim/flightmodel/controls/wing1l_fla1def:0
-- *** Clear Runway|GO
-- PARKBRAKE...........................................SET		:sim/flightmodel/controls/parkbrake:1
-- MIXTURE...................................LEAN FOR TAXI		:172/engine/mixture_ratio_0:><0.01
-- PITOT HEAT..........................................OFF		:sim/cockpit/switches/pitot_heat_on:0
-- LAND LIGHT SWITCH...................................OFF		:sim/cockpit/electrical/landing_lights_on:0
-- TAXI LIGHT SWITCH....................................ON		:sim/cockpit2/switches/taxi_light_on:1
-- STROBE LIGHTS SWITCH................................OFF		:sim/cockpit/electrical/strobe_lights_on:0
-- TRANSPONDER........................................STBY		:sim/cockpit/radios/transponder_mode:1
-- ELEVATOR TRIM...................................SET T/O		:172/control_surfaces/elevator_trim:><0.001
-- PARKBRAKE.......................................RELEASE		:sim/flightmodel/controls/parkbrake:0
-- *** Taxi to Go Parking Position
-- PARKBRAKE...........................................SET		:sim/flightmodel/controls/parkbrake:1
-- =======================================================

-- Flaps........................UP
-- Navigation Instruments ......OFF
-- Transponder.............STANDBY

-- ====================== SHUTDOWN =======================
-- THROTTLE.............................1000 RPM FOR 1 MIN		:sim/cockpit2/engine/indicators/engine_speed_rpm[0]:950|1050
-- THROTTLE.........................................CUTOFF		:sim/cockpit2/engine/actuators/throttle_ratio[0]:0
-- MIXTURE.....................................IDLE CUTOFF		:172/engine/mixture_ratio_0:<1.0
-- START KEY...........................................OFF		:172/ip_base/b_ignition:0
-- ALL RADIO & NAV.....................................OFF		:(sim/cockpit2/radios/actuators/gps_power:0)&&(172/av_panel/nav2/nav2_on_off_v:0)&&(172/av_panel/adf/adf_on_off_v:0)&&(sim/cockpit2/radios/actuators/transponder_mode:0)&&(172/av_panel/dme/dme_on_off_v:0)
-- STATIC AIR.........................................PULL		:172/panel_actuators/static_air:0
-- FUEL SHUTOFF.......................................PULL		:172/panel_actuators/fuel_shut:0
-- FUEL SELECTOR......................................LEFT		:172/panel_actuators/fuel_tank_select:-1
-- ALL SWITCHES........................................OFF		:sim/cockpit/electrical/battery_on:0
-- =======================================================

-- Parking Brake...............SET
-- Throttle...................IDLE
-- Avionics....................OFF
-- Transponder.................OFF
-- Lights..................ALL OFF
-- Mixture....................IDLE
-- Master Switch...............OFF
-- Chocks...................PLACED
-- Fuel Selector.....LEFT or RIGHT

-- sw_checklist: SECURE AIRCRAFT:Secure Aircraft
-- sw_item: Open doors and GO out|OPEN:172/anim/go_outside_hide:0
-- sw_item: Secure Aircraft|SECURE:172/panel_actuators/act_park_b:0.0
-- sw_itemvoid: 
-- sw_itemvoid: =================
-- sw_itemvoid: It's time for Coffee Cup, bye...
-- sw_itemvoid: =================






local engineStartProc = Procedure:new("ENGINE START","","")
engineStartProc:setFlightPhase(1)
-- engineStartProc:addItem(SimpleProcedureItem:new("All paper work on board and checked"))
-- engineStartProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF",FlowItem.actorFO,0,
	-- function () return sysFuel.fuelPumpGroup:getStatus() == 0 end,
	-- function () sysFuel.fuelPumpGroup:actuate(modeOff) end,
	-- function () return activePrefSet:get("aircraft:powerup_apu") end))


-- ============  =============
-- add the checklists and procedures to the active sop
local nopeProc = Procedure:new("NO PROCEDURES AVAILABLE")

activeSOP:addProcedure(nopeProc)
-- activeSOP:addProcedure(prelPreflightProc)

function getActiveSOP()
	return activeSOP
end

return SOP_DFLT