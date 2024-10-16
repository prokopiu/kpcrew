-- Standard Operating Procedure for Felis B747-200

-- @classmod SOP_B742
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local SOP_B742 = {
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

kcSopFlightPhase = { [1] = "Cold & Dark", 	[2] = "Prel Cockpit Prep", [3] = "Cockpit Prep", 		[4] = "Before Start", 
					 [5] = "After Start", 	[6] = "Taxi to Runway", [7] = "Before Takeoff", [8] = "Takeoff",
					 [9] = "Climb", 		[10] = "Enroute", 		[11] = "Descent", 		[12] = "Arrival", 
					 [13] = "Approach", 	[14] = "Landing", 		[15] = "Turnoff", 		[16] = "Taxi to Stand", 
					 [17] = "Shutdown", 	[18] = "Turnaround",	[19] = "Flightplanning", [0] = "" }

-- Set up SOP =========================================================================

activeSOP = kcSOP:new("Felis B747-200 SOP")



-- =============== POWER UP / SAFETY CHECK ==============
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ===== Cockpit Safety Check
-- ALTERNATE FLAPS SWITCHES (OVHD).....GUARD CLOSED (F/O)
-- STANDBY POWER SWITCH (ENG)...................OFF (ENG)
-- ENGINE IGNITION SWITCHES (OVHD)..............OFF (F/O) 
-- WINDSHIELD WIPER SELECTORS...................OFF (F/O)
-- LANDING GEAR LEVER.................DOWN & LOCKED (F/O)
-- FUEL CONTROL SWITCHES........................OFF (F/O)
-- WX RADAR.....................................OFF (F/O)
--   (Standby on turn-around flights)
-- ELECTRIC HYDRAULIC PUMP......................OFF (F/O)
-- AIR-DRIVEN HYDRAULIC PUMPS...................OFF (F/O)
-- FUEL JETTISON PANEL...SWITCHES OFF, GUARD CLOSED (ENG)
-- ===== Establishing Power to the Aircraft 
-- BATTERY SWITCH...............ON AND GUARD CLOSED (F/O)
--   Press BATT on the DC meters sw
-- ==== Activate External Power
--   Call for the GPU in ground service tab on the EFB. 
-- Press APU BATT on the DC meters switch and check APU battery voltage. 
-- Press EXT PWR 1 and EXT PWR 2 on the AC meters switch and check volts and freq. 
-- Confirm EXT PWR 1 and EXT PWR 2 lights illuminate on the APU panel. 
-- Close the EXT PWR 1 and EXT PWR 2 generator relay switches. 
-- Confirm PWR ON BUS lights illuminate and SPLIT SYSTEM BREAKER light illuminates. 
--   EXT POWER AVAILABLE LIGHTS.........ILLUMINATED (F/O)
--   EXT PWR 1 SWITCH............................ON (F/O)
-- ==== Activate APU 
-- Press APU BATT on the DC meters switch and check APU battery voltage. 
-- Check the APU Fire Detection. 
-- Place the loop selector switch to both. 
-- Hold switch A to fire test. Confirm the fire bell sounds. Note the APU fire pull, 
--   overhead panel APU light and both master fire warning lights illuminate. 
-- Perform the same test for switch B. 
-- Hold both A and B switches to fault test (hint – click in between the switches to move both simultaneously), and note fault detector lights illuminate. 
-- Check bottle discharge light is extinguished. 
-- Check APU fire pull pushed in and dimmed. 
-- Select APU squib test switch to test, and observe SQUIB ON light illuminates. 
-- Check APU oil quantity is at least 2 ½ quarts. 
-- Check the APU bleed air switch is closed. 
--  Place APU master switch to on and check: 
-- o DC pump light illuminates. 
-- o Fuel valve opens – monitor in-transit light. Check it extinguishes. 
-- o APU door opens – monitor in-transit light. Check it extinguishes. 
-- After the APU door reaches full open, momentarily click the APU master switch to start and check: 
-- o RPM and EGT increases. 
-- o APU battery voltage returns to near normal when the start disengages (approximately 50% RPM). 
--  Press APU GEN 1 and APU GEN 2 on the AC meters switch and check you have positive freq but no volts. 
--  When RPM and EGT stabilize, close the APU generators and confirm you have positive volts. Then close the GRD SERV bus. Check all lights extinguish. 
--  Allow one minute warmup before using bleed air. 
-- After establishing electrical power, but before turning on bleed air, confirm that the leading edge and trailing edge flaps agree with the flaps lever. 

-- Establishing Air Conditioning 
-- If using ground power, do not establish AC until the APU is started. 
-- Place zone 1 recirc fan to on to provide cockpit airflow until packs are operating. 
-- To start air conditioning, perform the following: 
--  Check master trim air switch is in open, zone temperature selectors in auto and pack 
-- control switches in auto. 
--  Close all three pack valves. 
--  Open the APU bleed. 
--  Close 1 and 3 isolation valves. Check both left and right duct pressure drops to zero. 
-- Opening a pack valve will accelerate the pressure loss. 
--  Open the isolation valves and check both left and right duct pressure increases. 
--  Open one pack valve, check the left pack duct pressure increases and temperature 
-- stabilizes in the normal range. 
-- Turn off zone 1 recirc fan if not required. 

-- DC and Standby Power Check 
-- Place DC bus isolation switches to open. Note the isolation relay OPEN lights illuminate. 
-- Check all TR positions for normal volts and positive amperes. Leave ESS TR selected. 
-- Place Essential AC bus selector to off. 
--  Check ESS BUS OFF light illuminates. 
--  Check ESS TR for zero volts and amps. Note the N1 and EGT fail flags on the centre 
-- engine instruments. 
--  Place Standby Power switch to on. Check MANUAL ON light illuminates and N1 
-- and EGT fail flags retract. 
--  Return Standby Power to off. Check N1 and EGT fail flags return, 
-- Close DC isolation switches and check ESS TR now indicating normal volts and amps. Place 
-- Standby Power to normal. 
-- Return Essential AC bus selector to normal. Check ESS TR now indicates normal volts and 
-- amps and ESS BUS OFF light extinguishes. Check N1 and EGT fail flags out of view. 
-- Check APU and main batteries for normal indications. Monitor DC meters in BATT position. 

--   APU......................................START (F/O)
--     Hold APU switch in START position for 3-4 seconds.
--   APU GEN OFF BUS LIGHT..............ILLUMINATED (F/O)
--   APU GENERATOR BUS 1 SWITCH..................ON (F/O)
--   APU BLEED AIR...............................ON (F/O)
-- ISOLATION VALVES............................OPEN (F/O)
-- PACK SWITCHES.............................NORMAL (F/O)
-- NAV LIGHTS....................................ON (F/O)

local electricalPowerUpProc = kcProcedure:new("POWER UP / SAFETY CHECK","powering up the aircraft")
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("All paper work on board and checked"))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("M E L and Technical Logbook checked"))

electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("== Initial Checks"))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== DC Electric Power"))
electricalPowerUpProc:addItem(kcProcedureItem:new("CIRCUIT BREAKERS","CHECK ALL IN",kcFlowItem.actorFO,3,true))
electricalPowerUpProc:addItem(kcProcedureItem:new("BATTERY SWITCH","ON AND GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == 0 and sysElectric.batterySwitch:getStatus() == 1 end,
	function () sysElectric.batterySwitch:actuate(1) sysElectric.batteryCover:actuate(0) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","AUTO",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPowerSwitch:getStatus() == 1 end,
	function () sysElectric.stbyPowerSwitch:setValue(1) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("HYDRAULIC DEMAND PUMP SWITCHES","OFF",kcFlowItem.actorFO,3,
	function () return sysHydraulic.demandPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.demandPumpGroup:adjustValue(0,0,2) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("WINDSHIELD WIPERS","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:adjustValue(0,0,2) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","OFF",kcFlowItem.actorFO,3,
	function () return sysControls.altFlapsCtrl:getStatus() == 0 end,
	function () sysControls.altFlapsCtrl:setValue(0) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DOWN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
electricalPowerUpProc:addItem(kcIndirectProcedureItem:new("FLAP LEVER","SET CORRECTLY",kcFlowItem.actorFO,1,"initial_flap_lever",
	function () return get("laminar/B747/cablecontrols/flap_ratio") == 0 end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))

electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate External Power",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("  Use Ground Handling CDU menu to turn Ground Power on.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #exchange|EXT|EXTERNAL# POWER AVAILABLE LIGHT","ILLUMINATED",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuAvailAnc:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  EXTERNAL POWER 1 SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.gpuOnBus:getStatus() == 1 end,
	function () sysElectric.extGen1Switch:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))

electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("==== Activate APU",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == 1 end,
	function () sysElectric.apuStartSwitch:setValue(2) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcSimpleProcedureItem:new("    Hold APU switch in START position for 2 seconds",
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# GENERATOR BUS 1 SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.apuOnBus:getStatus() == modeOn end,
	function () sysElectric.apuBus1:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))
electricalPowerUpProc:addItem(kcProcedureItem:new("  #spell|APU# BLEED AIR","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

electricalPowerUpProc:addItem(kcProcedureItem:new("ISOLATION VALVES","OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveGroup:getStatus() == 2 end,
	function () sysAir.isoValveGroup:actuate(modeOn) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("PACK SWITCHES","NORMAL",kcFlowItem.actorFO,2,
	function () return sysAir.packSwitchGroup:getStatus() == 3 end,
	function () sysAir.packSwitchGroup:setValue(1) end))
electricalPowerUpProc:addItem(kcProcedureItem:new("NAV LIGHTS","ON",kcFlowItem.actorFO,2,
	function () return sysLights.positionSwitch:getStatus() == modeOn end,
	function () sysLights.positionSwitch:actuate(1) end))


-- Pilot’s Station Checks
-- Do this for both the Captain and First Officer displays. 
-- Place the indicator lights switch to TEST and observe all annunciator lights on the overhead 
-- panel, forward panels and pedestal illuminates. Return the switch to either BRIGHT or DIM. 
-- Overhead Panel 
-- Turn on the NAV and NO SMOKING lights. NO SMOKING must always be on when 
-- refuelling. 
-- Place both radio master switches to on. Align the INS (check the standalone manual for 
-- further instructions). 
-- Check window heat power lights switch is on. 
-- If POWER L1 and POWER R1 lights are not on, press the POWER TEST switch. Check the 
-- L1 and R1 lights illuminate. 
-- Place left and right probe heat switches to on and note all amber lights extinguish. Hold 
-- switches to TAT TEST and note TAT probe lights extinguish. Place both switches to off. 
-- Check both nacelle and wing anti-ice is off. 
-- Place both MACH/AIRSPEED warning and OVER ROTATION warning to test and check 
-- for aural alarm. 
-- Place the stall warning to TEST. Observe stick shaker sounds and the spin dial rotates. Return 
-- to normal and observe that the PWR OFF light is extinguished. 
-- Check no flags on the fire panel and all discharge lights extinguished. 
-- Place the emergency light switch to armed and close the guard. Check the UNARMED light 
-- extinguishes. Emergency lights will not illuminate when essential DC power is available. 
-- If refuelling is completed, turn on the SEATBELT signs. 
-- Hold the cockpit voice recorder TEST switch and observe the test needle stays in green for at 
-- least five seconds. 
-- Press the wheel well test switch. Observe WHEEL WELL and master fire warning lights 
-- illuminate and warning bell sound. Release the switch and observe the lights extinguish and 
-- bell silences. 
-- Check all flight controls hydraulic power switches are on the guards closed. 
-- Check all alternate gear extension switches are off and guards closed. 
-- Check the yaw damper switches are engaged and the guards closed. 
-- With brake pressure available and the parking brake engaged, rotate the autobrake to one of 
-- the landing modes (MIN, MED, MAX). Check the autobrake automatically switches to 
-- DISARM. Return to OFF. The autobrake on the 747-200 is not used for takeoff, only landing. 
-- Arm the body gear-steering. 
-- Place the anti-skid to OFF. Check all anti-skid lights on both the pilots and engineer panels 
-- illuminate. Return the switch to ON, close the guard and observe all lights extinguish.

-- Instrument Panel 
-- Press and test each marker beacon light. 
-- Press the MAX IND RESET switch if any maximum indicator lights are on. 
-- Place the altitude bug on the MCP to the field elevation + 600 feet and press the ALTITUDE 
-- ALERT TEST. Check the C-Chord aural alarm sounds. 
-- Press the GROUND PROXIMITY TEST and observe that the pull up and ground proximity 
-- lights illuminate and aural alarm sounds. 
-- Press the RUDDER RATIO TEST and observe the light illuminates. 
-- Check the gear lever is down and locked, the GEAR DOWN light illuminated and the GEAR 
-- and DOOR OPEN lights extinguished. 
-- Check the PARK BRAKE light on the pedestal and the ANTI SKID HYD light on the centre 
-- instrument warning panel are illuminated. If the parking brake is engaged but neither light 
-- illuminated, disengage the brake, depress both brake pedals than reengage the brake. 
-- Check the start levers are off. 
-- Set the radios to the desired frequency. Collect the ATIS and call for clearance (if required). 
-- On the instrument panel: 
--  Check the airspeed needle is set to zero and the mach flag is out of view. Set the 
-- desired speed bugs for takeoff. 
--  Check the Attitude Indicator is neutral, no flight director bars and flags. 
--  Check the RMI heading indicator matches the HSI, no flags. 
--  Check the desired heading and course bugs on the HSI and no flags. Check the MAG 
-- indicator at the top of the HIS. 
--  Check the vertical speed indicator is at zero. 
--  Check the radio altimeter fail flag is out of view. 
--  Check the standby attitude indicator is erect and the off flag out of view. 
--  Set the altimeters to the field QNH. Cross check the altimeter with the field elevation. 
-- Set the weather radar to STBY. 
--  When flying westbound, select SYS 1. When flying eastbound, select SYS 2. 
--  Set gain control to AUTO. 
--  When flying in mountainous terrain, use an initial tilt of 5 degrees up. 
-- Set the transponder to STBY. 
--  If the Captain is flying, set to ALT 1. If the First Officer is flying, set to ALT 2. 
--  Set the required squawk. 
--  Set XPDR to 1. 
--  Press the TEST switch and observe the following: 
-- o Red RA arcs appear on the VSI from -6000 to O FPM and from 0 to +1500 
-- FPM. Green RA arc appears from +1500 to +3000 FPM. 
-- o Four intruders, one of each type, appears on the VSI in a square pattern, the 
-- number 6 appears as a range annunciation, and TCAS test is displayed. 
-- o At the conclusion, TCAS SYSTEM TEST OK will annunciate. 
-- Ensure the Captain’s FLT DIR CMPTR is set to A and the First Officer’s to B. 
--  Place flight director 1 and 2 on and engage either autopilot to CMD, then select HDG 
-- mode and place ALT HOLD on. 
--  Rotate the heading knob to the left of your current heading and then to the right. 
-- Check the flight director bars follow. Set the bug to runway heading. 
--  Rotate the manual turn knob and check that the autopilot trips to MAN. Be sure to 
-- centre the knob or else the autopilot will not engage. (Hint – you can do this by 
-- clicking just above the knob). 
--  Press the autopilot disconnect switch and ensure the autopilot turns OFF and the 
-- autopilot disconnect wailer sounds. Repeat this test for the first officer’s disconnect 
-- switch. 
--  Turn off the flight directors. 
-- Advance the throttles full forward and check that the takeoff warning horn sounds. Retard the 
-- throttles to idle. 
-- Test both PTT 1 and 2 on the automatic flight annunciator panel. Check all flags display and 
-- the autopilot and autothrottle flags flash. 
-- Press the instrument warning test switch and check the red and yellow flags illuminate. Press 
-- the instrument warning panel to extinguish any lights. 
-- Check the Captain’s INS and compass switches are in No. 1 position and the First Officer’s 
-- in No .2 Check both pilot’s attitude switches are set to NORM. 
-- Check the reserve brake valve is closed and the lights extinguished. 
-- Check the spoilers are down.

-- Engineer’s Station 
-- Place the Indicator Lights switch to TEST and observe all indicator and annunciator lights 
-- illuminate. 
-- Electrical Panel
-- o Check ESS AC BUS in NORM and ESS BUSS OFF light extinguished. 
-- o Place all Galley Power switches to ON and check TRIP OFF lights are extinguished. 
-- o Check that the BUS TIE OPEN and FIELD OFF lights are extinguished. 
-- o Check that the GEN OPEN lights are illuminated. 
-- o Check the GEN BRG FAILURE lights are extinguished. 
-- o Check that the CSD PRESS lights are illuminated. 
-- Engine Instruments 
-- o Check and note the oil quantity. 
-- Fuel Panel 
-- o When refuelling is finished, set the gross weight gauge to the current aircraft’s 
-- weight.
-- o Cycle each crossfeed valve (including reserve valves) and observe CROSSFEED 
-- VALVE lights illuminate. Leave No. 1 and No. 4 crossfeed valves open and No. 2 
-- and No. 3 closed. 
-- o Check No. 1 and No. 2 reserve valves are closed. 
-- o Turn on all forward boost pumps and, if fuel in the centre tank, the left 
-- override/jettison pump. Check the LOW PRESS lights extinguish. Turn them back 
-- off. Repeat for the aft boost pumps and the right override/jettison pump. 
-- o Check each shutoff valve switch is in open and the guard closed and that the ENG 
-- VALVE light is extinguished. 
-- o Check all fuel heat switches are off and the ICING OPEN lights extinguished. 
-- o Check the fuel scavange pump switch is off. 
-- o Check the fuel temperature on each engine. Leave the switch in ENG 1. 
-- o Press and hold the fuel gauges test switch. Observe each fuel tank reads ERR 0 and 
-- ERR 4. Check each fuel tank reads 88,888 tons. Release the switch then check each 
-- tank returns to normal reading. Do not perform this test when refuelling. 
-- o Press fuel used reset switch until all fuel used gauges read 0000. 
-- Pressurization Panel 
-- o Set the baro window and cabin altimeter to the field QNH. With mode selector in 
-- AUTO, press the rate limit test switch. Observe outflow valves drive toward closed 
-- and the RATE LIMIT light extinguishes. 
-- o Select MAN and operate both manual control switches in both directions. Return to 
-- AUTO and check both outflow valves fully open. 
-- o Set the flight level scale altitude to your cruising level + 1000 feet. (In black). 
-- Bleed Air and Air Conditioning Panel 
-- o Check both isolation switches are open.
-- o Check pack operation and zone temperature control.
-- Lower Cargo Fire Protection
-- o Check the compartment selector switch is off and both BTL 1 PUSH and BTL 2 
-- PUSH lights are extinguished.
-- o Press each compartment switch to A and press the A test button. Observe that:
-- o FWD, AFT and BULK fire lights illuminate.
-- o DETECTOR A lights illuminate. 
-- o Pilot’s Master Fire warning illuminates.
-- o Fire bell sounds.
-- o Repeat the same test for B.
-- o Return each compartment switch to both. 
-- o Place the Squib detector switch to FWD and hold the Squib test to BTL 1. Observe 
-- FWD and AFT/BLK lights illuminate. Place the squib test to BTL 2 and observe the 
-- same. Repeat for AFT BLK.
-- Engine Fire Detection Panel 
-- o Check all loop selector switches are in BOTH. 
-- o Hold both A and B test switches to FIRE TEST (hint – click on FIRE TEST to do 
-- this) and observe that: 
-- o Nacelle temperature indicators rise to near the top of the scale. 
-- o Fire bell sounds. 
-- o Engine fire pull lights illuminate. 
-- o Pilot’s Master Fire warning illuminates.
-- o Hold A test switch to FAULT TEST and observe that the A nacelle temperature 
-- indicators rise, the B remain in place and the FAULT light illuminates. Repeat this 
-- test for B test switch and observe the A nacelle temperatures remain and the B nacelle 
-- temperatures rise.
-- Wing Le Overheat 
-- o Hold the test switch to SYS 1 and observe left and right WING OVHT lights 
-- illuminate. Repeat the test for SYS 2. 
-- Oxygen 
-- o Check the oxygen switch is in NORM and guarded, the ON light is extinguished and 
-- oxygen pressure is above minimums. Minimum oxygen levels is 1500 PSI. 
-- AFT Cargo Heat 
-- o Place the switch to TEST and observe that ON CONTAINER and ON BULK lights 
-- illuminate. 
-- Equipment Cooling 
-- o Hold the smoke detector switch to TEST and observe the SMOKE light illuminates. 
-- o Check valve control is in NORM and guard closed. 
-- o Check blower selector switch is in NORM. 
-- o Check the NO AIR FLOW light is extinguished. 
-- Engine Bottle Squib Test 
-- o Place the squib test to LEFT BOTTLE and check all engine SQUIB OK lights 
-- illuminate. Repeat for RIGHT BOTTLE. 
-- Hydraulic Panel 
-- o Check all engine-driven pump switches are in NORMAL. 
-- o Check reservoir LOW QTY lights are extinguished and oil quantity is at normal 
-- levels. 
-- o Press the quantity test switch. Note all oil quantity gauges indicate zero and LOW 
-- QTY lights illuminate. Release switch and observe all indications return to normal 
-- and LOW QTY lights extinguish. 
-- o Check normal brake source select switch is set to NORM and guard, SEC SYS 1 light 
-- is extinguished and LOW PRESS light illuminates. 
-- Brake Temp Monitor 
-- o Select LF selector switch and press the TEST switch. Observe all temperature 
-- indicators are in the red and the OVER-HEAT light illuminates. Repeat the test for 
-- RF, RR and RL. Return the selector switches to OFF. (Note: You have to hold down 
-- the switch to get the lights).
-- Landing Gear 
-- o Press the Gear and Tilt PRIM switches and observe the DOWN and TILT lights 
-- illuminate. 
-- o Repeat for the Gear and Tilt ALT switches 
-- Fuel Jettison Panel 
-- o Open the fuel jettison panel. Observe all switches are OFF/CLOSED and all VALVE 
-- lights extinguished. Close the fuel jettison panel. 

	
-- ============ PRELIMINARY PREFLIGHT PROCEDURES ========
-- EMERGENCY EXIT LIGHT.........ARM/ON GUARD CLOSED (F/O)
-- ATTENDENCE BUTTON..........................PRESS (F/O)
-- ELECTRICAL POWER UP.....................COMPLETE (F/O)
-- VOICE RECORDER SWITCH.......................AUTO (F/O)
-- MACH OVERSPEED TEST......................PERFORM (F/O)
-- STALL WARNING TEST.......................PERFORM (F/O)
--   Wait for 4 minutes AC power if not functioning

-- IRS Alignment
-- IRS MODE SELECTORS...........................OFF (F/O)
-- IRS MODE SELECTORS......................THEN NAV (F/O)
--   Verify ON DC lights illuminate then extinguish
--   Verify ALIGN lights are illuminated     
      
-- XPDR....................................SET 2000 (F/O)
-- COCKPIT LIGHTS.....................SET AS NEEDED (F/O)
-- WING & WHEEL WELL LIGHTS.........SET AS REQUIRED (F/O)
-- FUEL PUMPS...............................ALL OFF (F/O)
-- FUEL CROSS FEED..............................OFF (F/O)
-- POSITION LIGHTS...............................ON (F/O)
-- MCP...................................INITIALIZE (F/O)
-- PARKING BRAKE................................SET (F/O)
-- IFE & GALLEY POWER............................ON (F/O)

-- Electric hydraulic pumps on for F/O walk-around
-- ELECTRIC HYDRAULIC PUMPS SWITCHES.............ON (F/O)
-- Next: CDU Preflight                             

local prelPreflightProc = kcProcedure:new("PREL PREFLIGHT PROCEDURE","preliminary pre flight")
-- Check fluids
-- OIL QUANTITY
-- HYDRAULIC QUANTITY
-- OXYGEN BOTTLE

prelPreflightProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHT","ARM #exchange|/ON GUARD CLOSED| #",kcFlowItem.actorFO,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff  end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",kcFlowItem.actorFO,2,"attendence_button",
	function () return sysGeneral.attendanceButton:getStatus() > modeOff end,
	function () sysGeneral.attendanceButton:repeatOn(1) end))
prelPreflightProc:addItem(kcProcedureItem:new("ELECTRICAL POWER UP","COMPLETE",kcFlowItem.actorFO,1,
	function () return 
		sysElectric.apuGenBusOff:getStatus() == 0 or
		sysElectric.gpuOnBus:getStatus() == 1
	end,
	function () sysGeneral.attendanceButton:repeatOff(1) end))
prelPreflightProc:addItem(kcProcedureItem:new("VOICE RECORDER SWITCH","AUTO",kcFlowItem.actorFO,2,
	function () return  sysGeneral.voiceRecSwitch:getStatus() == modeOff and sysGeneral.vcrCover:getStatus() == modeOff end,
	function () sysGeneral.voiceRecSwitch:actuate(modeOn) sysGeneral.vcrCover:actuate(modeOff) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST 1","PERFORM",kcFlowItem.actorFO,2,"mach_ovspd_test1",
	function () return get("laminar/B738/push_button/mach_warn1_pos") == 1 end,
	function () command_begin("laminar/B738/push_button/mach_warn1_test") end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("MACH OVERSPEED TEST 2","PERFORM",kcFlowItem.actorFO,2,"mach_ovspd_test2",
	function () return get("laminar/B738/push_button/mach_warn2_pos") == 1 end,
	function () command_end("laminar/B738/push_button/mach_warn1_test") command_begin("laminar/B738/push_button/mach_warn2_test") end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST 1","PERFORM",kcFlowItem.actorFO,2,"stall_warning_test1",
	function () return get("laminar/B738/push_button/stall_test1") == 1 end,
	function () command_end("laminar/B738/push_button/mach_warn2_test") command_begin("laminar/B738/push_button/stall_test1_press") end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("STALL WARNING TEST 2","PERFORM",kcFlowItem.actorFO,2,"stall_warning_test",
	function () return get("laminar/B738/push_button/stall_test2") == 1 end,
	function () command_end("laminar/B738/push_button/stall_test1_press") command_begin("laminar/B738/push_button/stall_test2_press") end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Wait for 4 minutes AC power if not functioning"))

prelPreflightProc:addItem(kcSimpleProcedureItem:new("==== Engine Panel"))
prelPreflightProc:addItem(kcProcedureItem:new("EEC SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysEngines.eecSwitchGroup:getStatus() == 0 end,
	function () command_end("laminar/B738/push_button/stall_test2_press") sysEngines.eecSwitchGroup:actuate(1) end))
prelPreflightProc:addItem(kcProcedureItem:new("EEC GUARDS","CLOSED",kcFlowItem.actorFO,2,
	function () return sysEngines.eecGuardGroup:getStatus() == 0 end,
	function () sysEngines.eecGuardGroup:actuate(0) end))
prelPreflightProc:addItem(kcProcedureItem:new("EEC FAIL LIGHTS","EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysEngines.fadecFail:getStatus() == 0 end))
prelPreflightProc:addItem(kcProcedureItem:new("REVERSER FAIL LIGHTS","EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysEngines.reversersFail:getStatus() == 0 end))

prelPreflightProc:addItem(kcSimpleProcedureItem:new("==== IRS Alignment"))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","OFF",kcFlowItem.actorFO,2,"irs_mode_initial_off",
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () command_end("laminar/B738/push_button/stall_test2_press") sysGeneral.irsUnitGroup:adjustValue(sysGeneral.irsUnitOFF,0,2) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","ALIGN",kcFlowItem.actorFO,2,"irs_mode_align",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitALIGN*2 end,
	function () sysGeneral.irsUnitGroup:adjustValue(sysGeneral.irsUnitALIGN,0,2) end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("  Verify ON DC lights illuminate then extinguish"))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS LEFT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,2,"irs_left_align",
	function () return sysGeneral.irs1Align:getStatus() == modeOn end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("  IRS RIGHT ALIGN LIGHT","ILLUMINATES",kcFlowItem.actorFO,2,"irs_right_align",
	function () return sysGeneral.irs2Align:getStatus() == modeOn end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",kcFlowItem.actorFO,2,"irs_mode_nav_again",
	function () return sysGeneral.irsUnitGroup:getStatus() == sysGeneral.irsUnitNAV*2 end,
	function () sysGeneral.irsUnitGroup:adjustValue(sysGeneral.irsUnitNAV,0,2) end))
	
prelPreflightProc:addItem(kcSimpleProcedureItem:new("==== Other"))

prelPreflightProc:addItem(kcProcedureItem:new("#exchange|XPDR|transponder#","SET 2000",kcFlowItem.actorFO,2,
	function () return get("sim/cockpit/radios/transponder_code") == 2000 end))
prelPreflightProc:addItem(kcProcedureItem:new("COCKPIT LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.domeAnc:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.domeLightSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("WING #exchange|&|and# WHEEL WELL LIGHTS","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == (kc_is_daylight() and 0 or 1) and sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wingSwitch:actuate(kc_is_daylight() and 0 or 1) sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
prelPreflightProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))
prelPreflightProc:addItem(kcProcedureItem:new("POSITION LIGHTS","ON",kcFlowItem.actorFO,2,
	function () return sysLights.positionSwitch:getStatus() ~= 0 end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(kcProcedureItem:new("#spell|MCP#","INITIALIZE",kcFlowItem.actorFO,2,
	function () return sysMCP.altSelector:getStatus() == activePrefSet:get("aircraft:mcp_def_alt") end,
	function () 
		sysMCP.fdirGroup:actuate(modeOff)
		sysMCP.athrSwitch:actuate(modeOff)
		sysMCP.crs1Selector:setValue(1)
		sysMCP.crs2Selector:setValue(1)
		sysMCP.iasSelector:setValue(activePrefSet:get("aircraft:mcp_def_spd"))
		sysMCP.hdgSelector:setValue(activePrefSet:get("aircraft:mcp_def_hdg"))
		sysMCP.turnRateSelector:adjustValue(3,0,4)
		sysMCP.altSelector:setValue(activePrefSet:get("aircraft:mcp_def_alt"))
		sysMCP.vspSelector:setValue(modeOff)
		sysMCP.discAPSwitch:actuate(modeOff)
		sysEFIS.mtrsPilot:actuate(modeOff)
		sysEFIS.fpvPilot:actuate(modeOff)
	end))
prelPreflightProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
prelPreflightProc:addItem(kcIndirectProcedureItem:new("GPWS SYSTEM TEST","PERFORM",kcFlowItem.actorFO,2,"gpwstest",
	function () return get("laminar/B738/system/gpws_test_running") > 0 end,
	function () command_begin("laminar/B738/push_button/gpws_test") end))
prelPreflightProc:addItem(kcProcedureItem:new("#spell|IFE# & GALLEY POWER","ON",kcFlowItem.actorFO,3,
	function () return sysElectric.ifePwr:getStatus() == modeOn and sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () command_end("laminar/B738/push_button/gpws_test") sysElectric.ifePwr:actuate(modeOn) sysElectric.cabUtilPwr:actuate(modeOn) end))
prelPreflightProc:addItem(kcSimpleProcedureItem:new("Electric hydraulic pumps on for F/O walk-around"))
prelPreflightProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,3,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOn) end))
-- check lights go off


-- !!! Make aircraft independent or aircraft specific
-- ================== CDU Preflight ==================
-- INITIAL DATA (CPT)                              
--   IDENT page:...............................OPEN (CPT)
--     Verify Model and ENG RATING                 
--     Verify navigation database ACTIVE date      
--   POS INIT page:............................OPEN (CPT)
--     Verify time                                 
--     REF AIRPORT..............................SET (CPT)
-- NAVIGATION DATA (CPT)                           
--   RTE page:.................................OPEN (CPT)
--     ORIGIN...................................SET (CPT)
--     DEST.....................................SET (CPT)
--     FLT NO...................................SET (CPT)
--     ROUTE..................................ENTER (CPT)
--     ROUTE...............................ACTIVATE (CPT)
--     ROUTE................................EXECUTE (CPT)
--   DEPARTURES page:..........................OPEN (CPT)
--     Select runway and departure routing         
--     ROUTE:...............................EXECUTE (CPT)
--   LEGS page:................................OPEN (CPT)
--     Verify or enter correct RNP for departure   
-- PERFORMANCE DATA (CPT)                          
--   PERF INIT page:...........................OPEN (CPT)
--     ZFW....................................ENTER (CPT)
--     GW..............................ENTER/VERIFY (CPT)
--     RESERVES........................ENTER/VERIFY (CPT)
--     COST INDEX.............................ENTER (CPT)
--     CRZ ALT................................ENTER (CPT)
--   N1 LIMIT page:............................OPEN (CPT)
--     Select assumed temp and/or fixed t/o rating 
--     Select full or derated climb thrust         
--   TAKEOFF REF page:.........................OPEN (CPT)
--     FLAPS..................................ENTER (CPT)
--     CG.....................................ENTER (CPT)
--     V SPEEDS...............................ENTER (CPT)
-- PREFLIGHT COMPLETE?.......................VERIFY (CPT)
-- PREPARE KPCREW DEPARTURE BRIEFING


local cduPreflightProc = kcProcedure:new("CDU PREFLIGHT PROCEDURE")
cduPreflightProc:addItem(kcSimpleProcedureItem:new("OBTAIN CLERANCE FROM ATC"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("INITIAL DATA (CPT)"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  IDENT page:","OPEN",kcFlowItem.actorCPT,1,"ident_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"IDENT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify Model and ENG RATING"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  POS INIT page:","OPEN",kcFlowItem.actorCPT,1,"pos_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"POS INIT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    REF AIRPORT","SET",kcFlowItem.actorCPT,1,"ref_airport_set",
	function () return sysFMC.fmcRefAirportSet:getStatus() end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("NAVIGATION DATA (CPT)"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  RTE page:","OPEN",kcFlowItem.actorCPT,1,"rte_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"RTE ") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ORIGIN","SET",kcFlowItem.actorCPT,1,"origin_set",
	function () return sysFMC.fmcOrigin:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    DEST","SET",kcFlowItem.actorCPT,1,"dest_set",
	function () return sysFMC.fmcDestination:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    FLT NO","SET",kcFlowItem.actorCPT,1,"flt_no_entered",
	function () return sysFMC.fmcFltNo:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ROUTE","ENTER",kcFlowItem.actorCPT,1,"route_entered",
	function () return sysFMC.fmcRouteEntered:getStatus() == true end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ROUTE","ACTIVATE",kcFlowItem.actorCPT,1,"route_activated",
	function () return sysFMC.fmcRouteActivated:getStatus() == true end))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE","EXECUTE",kcFlowItem.actorCPT,1,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  DEPARTURES page:","OPEN",kcFlowItem.actorCPT,1,"departures_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"DEPARTURES") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(kcProcedureItem:new("    ROUTE:","EXECUTE",kcFlowItem.actorCPT,1,
	function () return sysFMC.fmcRouteExecuted:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  LEGS page:","OPEN",kcFlowItem.actorCPT,1,"legs_page_open",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"LEGS") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("PERFORMANCE DATA (CPT)"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  PERF INIT page:","OPEN",kcFlowItem.actorCPT,1,"perf_init_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"PERF INIT") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    ZFW","ENTER",kcFlowItem.actorCPT,1,"zfw_entered",
	function () return sysFMC.fmcZFWEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    GW","ENTER/VERIFY",kcFlowItem.actorCPT,1,"gw_entered",
	function () return sysFMC.fmcGWEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    RESERVES","ENTER/VERIFY",kcFlowItem.actorCPT,1,"reserves_entered",
	function () return sysFMC.fmcReservesEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    COST INDEX","ENTER",kcFlowItem.actorCPT,1,"cost_index_entered",
	function () return sysFMC.fmcCIEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    CRZ ALT","ENTER",kcFlowItem.actorCPT,1,"crz_alt_entered",
	function () return sysFMC.fmcCrzAltEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  N1 LIMIT page:","OPEN",kcFlowItem.actorCPT,1,"n1_limit_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"N1 LIMIT") end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("  TAKEOFF REF page:","OPEN",kcFlowItem.actorCPT,1,"takeoff_ref_page",
	function () return string.find(sysFMC.fmcPageTitle:getStatus(),"TAKEOFF REF") end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    FLAPS","ENTER",kcFlowItem.actorCPT,1,"flaps_entered",
	function () return sysFMC.fmcFlapsEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    CG","ENTER",kcFlowItem.actorCPT,1,"cg_entered",
	function () return sysFMC.fmcCGEntered:getStatus() end))
cduPreflightProc:addItem(kcIndirectProcedureItem:new("    V SPEEDS","ENTER",kcFlowItem.actorCPT,1,"vspeeds_entered",
	function () return sysFMC.fmcVspeedsEntered:getStatus() == true end))
cduPreflightProc:addItem(kcSimpleProcedureItem:new("FILL OUT KPCREW DEPARTURE BRIEFING!!"))

-- ================ Preflight Procedure =================
-- ==== Flight control panel                            
-- FLIGHT CONTROL SWITCHES............GUARDS CLOSED (F/O)
-- FLIGHT SPOILER SWITCHES............GUARDS CLOSED (F/O)
-- ALTERNATE FLAPS MASTER SWITCH.......GUARD CLOSED (F/O)
-- ALTERNATE FLAPS CONTROL SWITCH...............OFF (F/O)
-- FLAPS PANEL ANNUNCIATORS............EXTINGUISHED (F/O)
-- ==== NAVIGATION & DISPLAYS panel                     
-- VHF NAV TRANSFER SWITCH...................NORMAL (F/O)
-- IRS TRANSFER SWITCH.......................NORMAL (F/O)
-- FMC TRANSFER SWITCH.......................NORMAL (F/O)
-- SOURCE SELECTOR.............................AUTO (F/O)
-- CONTROL PANEL SELECT SWITCH...............NORMAL (F/O)
-- ==== Fuel panel                                      
-- CROSSFEED SELECTOR........................CLOSED (F/O)
-- FUEL PUMP SWITCHES...........................OFF (F/O)
-- ==== Electrical panel                                
-- BATTERY SWITCH......................GUARD CLOSED (F/O)
-- CAB/UTIL POWER SWITCH.........................ON (F/O)
-- IFE/PASS SEAT POWER SWITCH....................ON (F/O)
-- STANDBY POWER SWITCH................GUARD CLOSED (F/O)
-- GEN DRIVE DISCONNECT SWITCHES......GUARDS CLOSED (F/O)
-- BUS TRANSFER SWITCH.................GUARD CLOSED (F/O)
-- ==== APU start if required
-- Overheat and fire protection panel              
-- OVHT FIRE TEST SWITCH.................HOLD RIGHT (F/O)
-- MASTER FIRE WARN LIGHT......................PUSH (F/O)
-- ENGINES EXT TEST SWITCH...........TEST 1 TO LEFT (F/O)
-- ENGINES EXT TEST SWITCH..........TEST 2 TO RIGHT (F/O)
-- APU SWITCH.................................START (F/O)
-- APU GEN OFF BUS LIGHT................ILLUMINATED (F/O)
-- APU GENERATOR BUS SWITCHES....................ON (F/O)
-- ==== Overhead items
-- EQUIPMENT COOLING SWITCHES..................NORM (F/O)
-- EMERGENCY EXIT LIGHTS SWITCH........GUARD CLOSED (F/O)
-- NO SMOKING SWITCH.............................ON (F/O)
-- FASTEN BELTS SWITCH...........................ON (F/O)
-- WINDSHIELD WIPER SELECTORS..................PARK (F/O)
-- ==== Anti-Ice
-- WINDOW HEAT SWITCHES..........................ON (F/O)
-- PROBE HEAT SWITCHES..........................OFF (F/O)
-- WING ANTI-ICE SWITCH.........................OFF (F/O)
-- ENGINE ANTI-ICE SWITCHES.....................OFF (F/O)

local preflightFOProc = kcProcedure:new("PREFLIGHT PROCEDURE","running preflight procedure")
preflightFOProc:setResize(false)

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Flight control panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysControls.fltCtrlCovers:getStatus() == 0 end,
	function () sysControls.fltCtrlCovers:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysControls.spoilerCovers:getStatus() == 0  end,
	function () sysControls.spoilerCovers:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,3,
	function () return sysControls.altFlapsCover:getStatus() == 0 end,
	function () sysControls.altFlapsCover:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ALTERNATE FLAPS CONTROL SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysControls.altFlapsCtrl:getStatus() == 0 end,
	function () sysControls.altFlapsCtrl:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("FLAPS PANEL ANNUNCIATORS","EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysControls.flapsPanelStatus:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("YAW DAMPER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysControls.yawDamper:getStatus() == modeOn end,
	function () sysControls.yawDamper:actuate(modeOn) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== NAVIGATION & DISPLAYS panel"))
preflightFOProc:addItem(kcProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.vhfNavSwitch:getStatus() == 0 end,
	function () sysMCP.vhfNavSwitch:adjustValue(0,-1,1) end))
preflightFOProc:addItem(kcProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.irsNavSwitch:getStatus() == 0 end,
	function () sysMCP.irsNavSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.fmcNavSwitch:getStatus() == 0 end,
	function () sysMCP.fmcNavSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("SOURCE SELECTOR","AUTO",kcFlowItem.actorFO,2,
	function() return sysMCP.displaySourceSwitch:getStatus() == 0 end,
	function () sysMCP.displaySourceSwitch:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",kcFlowItem.actorFO,2,
	function() return sysMCP.displayControlSwitch:getStatus() == 0 end,
	function () sysMCP.displayControlSwitch:setValue(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Fuel panel"))
preflightFOProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == 1 end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == 1 end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL VALVE ANNUNCIATORS","DIM",kcFlowItem.actorFO,2,
	function () return sysFuel.valveAnns:getStatus() == 1 end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("FUEL CROSS FEED","ON FOR TEST",kcFlowItem.actorFO,2,"xfeedtest",
	function () return sysFuel.crossFeed:getStatus() == modeOn end,
	function () sysFuel.crossFeed:actuate(modeOn) end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("CROSS FEED VALVE","DIM",kcFlowItem.actorFO,2,"xfeeddim",
	function () return sysFuel.xfeedVlvAnn:getStatus() == 0.5 end))
preflightFOProc:addItem(kcProcedureItem:new("FUEL CROSS FEED","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.crossFeed:getStatus() == modeOff end,
	function () sysFuel.crossFeed:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("CROSS FEED VALVE","EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysFuel.xfeedVlvAnn:getStatus() == 0 end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Electrical panel"))
preflightFOProc:addItem(kcProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.batteryCover:getStatus() == modeOff end,
	function () sysElectric.batteryCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("CAB/UTIL POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.cabUtilPwr:getStatus() == modeOn end,
	function () sysElectric.cabUtilPwr:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("#spell|IFE# POWER SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.ifePwr:getStatus() == modeOn end,
	function () sysElectric.ifePwr:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.stbyPowerCover:getStatus() == modeOff end,
	function () sysElectric.stbyPowerCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.genDriveCovers:getStatus() == 0 end))
preflightFOProc:addItem(kcProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysElectric.busTransCover:getStatus() == 0 end,
	function () sysElectric.busTransCover:actuate(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== APU start if required",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("OVHT DET SWITCHES","NORMAL",kcFlowItem.actorFO,1,true,
	function () set_array("sim/cockpit2/engine/actuators/throttle_ratio",0,0) 
				set_array("sim/cockpit2/engine/actuators/throttle_ratio",1,0) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("  #exchange|OVHT|Overheat# FIRE TEST SWITCH","HOLD RIGHT",kcFlowItem.actorFO,2,"ovht_fire_test",
	function () return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,
	function () sysEngines.ovhtFireTestSwitch:repeatOn(1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",kcFlowItem.actorFO,1,true,
	function () sysEngines.ovhtFireTestSwitch:repeatOff(0) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 1 TO LEFT",kcFlowItem.actorFO,2,"eng_ext_test_1",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,
	function () command_begin("laminar/B738/toggle_switch/exting_test_lft") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("ENGINES #exchange|EXT|Extinguischer# TEST SWITCH","TEST 2 TO RIGHT",kcFlowItem.actorFO,2,"eng_ext_test_2",
	function () return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,
	function () command_end("laminar/B738/toggle_switch/exting_test_lft") 
				command_begin("laminar/B738/toggle_switch/exting_test_rgt") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("#spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () command_end("laminar/B738/toggle_switch/exting_test_rgt") 
				command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcSimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds.",
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("#spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,"apu_gen_bus_off",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,
	function () command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn") end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("#spell|APU# GENERATOR BUS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysElectric.apuGenBusOff:getStatus() == 0 end,
	function () sysElectric.apuGenBus1:adjustValue(1,-1,1) sysElectric.apuGenBus2:adjustValue(1,-1,1) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("TRANSFER BUS LIGHTS","CHECK EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return sysElectric.transferBus1:getStatus() == modeOff and sysElectric.transferBus2:getStatus() == modeOff end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Overhead items"))
preflightFOProc:addItem(kcProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.equipCoolExhaust:getStatus() == modeOff and sysGeneral.equipCoolSupply:getStatus() == 0 end,
	function () sysGeneral.equipCoolExhaust:actuate(modeOff) sysGeneral.equipCoolSupply:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
preflightFOProc:addItem(kcProcedureItem:new("NO SMOKING SWITCH","ON OR AUTO",kcFlowItem.actorFO,2,
	function () return sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.noSmokingSwitch:setValue(1) end))
preflightFOProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","ON OR AUTO",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 end,
	function () command_once("laminar/B738/toggle_switch/seatbelt_sign_dn") end))
preflightFOProc:addItem(kcProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",kcFlowItem.actorFO,2,
	function () return sysGeneral.wiperGroup:getStatus() == 0 end,
	function () sysGeneral.wiperGroup:actuate(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Anti-Ice"))
preflightFOProc:addItem(kcProcedureItem:new("WINDOW HEAT SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("WINDOW HEAT ANNUNCIATORS","ILLUMINATED",kcFlowItem.actorFO,2,
		function () return sysAice.windowHeatAnns:getStatus() == 4 end))
preflightFOProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))

-- ========== PREFLIGHT PROCEDURE PART 2 (F/O) ==========
-- ==== Hydraulic panel                                 
-- ENGINE HYDRAULIC PUMPS SWITCHES...............ON (F/O)
-- ELECTRIC HYDRAULIC PUMPS SWITCHES............OFF (F/O)
-- ==== Air conditioning panel                          
-- AIR TEMPERATURE SOURCE SELECTOR..........FWD CAB (F/O)
-- TRIM AIR SWITCH...............................ON (F/O)
-- RECIRCULATION FAN SWITCHES..................AUTO (F/O)
-- AIR CONDITIONING PACK SWITCHES......AUTO OR HIGH (F/O)
-- ISOLATION VALVE SWITCH..............AUTO OR OPEN (F/O)
-- ENGINE BLEED AIR SWITCHES.....................ON (F/O)
-- APU BLEED AIR SWITCH..........................ON (F/O)
-- ==== Cabin pressurization panel                      
-- FLIGHT ALTITUDE INDICATOR........CRUISE ALTITUDE (F/O)
-- LANDING ALTITUDE INDICATOR..DEST FIELD ELEVATION (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO (F/O)
-- ==== Lighting panel                                  
-- LANDING LIGHT SWITCHES...........RETRACT AND OFF (F/O)
-- RUNWAY TURNOFF LIGHT SWITCHES................OFF (F/O)
-- TAXI LIGHT SWITCH............................OFF (F/O)
-- LOGO LIGHT SWITCH......................AS NEEDED (F/O)
-- POSITION LIGHT SWITCH..................AS NEEDED (F/O)
-- ANTI-COLLISION LIGHT SWITCH..................OFF (F/O)
-- WING ILLUMINATION SWITCH...............AS NEEDED (F/O)
-- WHEEL WELL LIGHT SWITCH................AS NEEDED (F/O)
-- IGNITION SELECT SWITCH................IGN L OR R (F/O)
-- ENGINE START SWITCHES........................OFF (F/O)

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Hydraulic panel"))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOn) end))
	
-- differential pressure 0 on th eground
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Air conditioning panel"))
preflightFOProc:addItem(kcProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","FWD CAB",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/toggle_switch/air_temp_source") == 3 end,
	function () set("laminar/B738/toggle_switch/air_temp_source",3) end))
preflightFOProc:addItem(kcProcedureItem:new("CABIN TEMPERATURE SELECTORS","AUTO OR AS NEEDED",kcFlowItem.actorFO,2,
	function () return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end,
	function () sysAir.contCabTemp:setValue(0.5) sysAir.fwdCabTemp:setValue(0.5) sysAir.aftCabTemp:setValue(0.5) end))
preflightFOProc:addItem(kcProcedureItem:new("TRIM AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.trimAirSwitch:getStatus() == modeOn end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",kcFlowItem.actorFO,2,
	function () return sysAir.packLeftSwitch:getStatus() > sysAir.packModeOff and sysAir.packRightSwitch:getStatus() > sysAir.packModeOff end,
	function () sysAir.packLeftSwitch:setValue(sysAir.packModeAuto) sysAir.packRightSwitch:setValue(sysAir.packModeAuto) end))
preflightFOProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO OR OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() > sysAir.isoVlvClosed end,
	function () sysAir.isoValveSwitch:setValue(sysAir.isoVlvOpen) end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == true end))
preflightFOProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOff end,
	function () sysAir.apuBleedSwitch:actuate(modeOff) end,
	function () return activePrefSet:get("aircraft:powerup_apu") == false end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Cabin pressurization panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT ALTITUDE INDICATOR","%i FT|activeBriefings:get(\"flight:cruiseLevel\")*100",kcFlowItem.actorFO,2,
	function () return sysAir.maxCruiseAltitude:getStatus() == activeBriefings:get("flight:cruiseLevel")*100 end,
	function () sysAir.maxCruiseAltitude:setValue(activeBriefings:get("flight:cruiseLevel")*100) end))
preflightFOProc:addItem(kcProcedureItem:new("LANDING ALTITUDE INDICATOR","%i FT|kc_round_step(get(\"sim/cockpit2/autopilot/altitude_readout_preselector\"),50)",kcFlowItem.actorFO,2,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(get("sim/cockpit2/autopilot/altitude_readout_preselector"),50)) end))
preflightFOProc:addItem(kcProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Lighting panel"))
preflightFOProc:addItem(kcProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("LOGO LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.logoSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.logoSwitch:actuate( kc_is_daylight() and 0 or 1) end ))
preflightFOProc:addItem(kcProcedureItem:new("POSITION LIGHT SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysLights.positionSwitch:getStatus() == modeOn end,
	function () sysLights.positionSwitch:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WING ILLUMINATION SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.wingSwitch:getStatus() == 0 end,
	function () sysLights.wingSwitch:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("WHEEL WELL LIGHT SWITCH","%s|(kc_is_daylight()) and \"OFF\" or \"ON\"",kcFlowItem.actorFO,2,
	function () return sysLights.wheelSwitch:getStatus() == (kc_is_daylight() and 0 or 1) end,
	function () sysLights.wheelSwitch:actuate(kc_is_daylight() and 0 or 1) end))

preflightFOProc:addItem(kcSimpleProcedureItem:new("===="))
preflightFOProc:addItem(kcProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",kcFlowItem.actorFO,2,
	function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end))
preflightFOProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:adjustValue(1,0,3) end)) 

-- ========== PREFLIGHT PROCEDURE PART 3 (F/O) ==========
-- ==== Mode control panel                              
-- COURSE NAV2..................................SET (F/O)
-- FLIGHT DIRECTOR SWITCHES......................ON (F/O)
-- ==== EFIS control panel                              
-- MINIMUMS REFERENCE SELECTOR........RADIO OR BARO (F/O)
-- MINIMUMS SELECTOR.........SET DH OR DA REFERENCE (F/O)
-- FLIGHT PATH VECTOR SWITCH....................OFF (F/O)
-- METERS SWITCH................................OFF (F/O)
-- BAROMETRIC REFERENCE SELECTOR..........IN OR HPA (F/O)
-- BAROMETRIC SELECTOR..SET LOCAL ALTIMETER SETTING (F/O)
-- VOR/ADF SWITCHES.............................VOR (F/O)
-- MODE SELECTOR................................MAP (F/O)
-- CENTER SWITCH................................OFF (F/O)
-- RANGE SELECTOR.............................10 NM (F/O)
-- TRAFFIC SWITCH................................ON (F/O)
-- WEATHER RADAR................................OFF (F/O)
-- MAP SWITCHES...........................AS NEEDED (F/O)
-- ==== Forward panel
-- CLOCK.............................SET LOCAL TIME (F/O)
-- MAIN PANEL DISPLAY UNITS SELECTOR...........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR.................NORM (F/O)
-- OXYGEN..............................TEST AND SET (F/O)
-- ==== GROUND PROXIMITY panel                          
-- FLAP INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- GEAR INHIBIT SWITCH.................GUARD CLOSED (F/O)
-- TERRAIN INHIBIT SWITCH..............GUARD CLOSED (F/O)
-- ==== Landing gear panel                              
-- LANDING GEAR LEVER............................DN (F/O)
-- AUTO BRAKE SELECT SWITCH.....................RTO (F/O)
-- ANTISKID INOP LIGHT..........VERIFY EXTINGUISHED (F/O)
-- CARGO FIRE TEST

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Mode control panel"))
preflightFOProc:addItem(kcProcedureItem:new("COURSE NAV2","SET %s|activeBriefings:get(\"takeoff:crs2\")",kcFlowItem.actorFO,2,
	function() return sysMCP.crs2Selector:getStatus() == activeBriefings:get("takeoff:crs2") end,
	function() sysMCP.crs2Selector:setValue(activeBriefings:get("takeoff:crs2")) end))
preflightFOProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON, LEFT MASTER",kcFlowItem.actorFO,2,
	function () return sysMCP.fdirGroup:getStatus() == 2 and get("laminar/B738/autopilot/master_capt_status") == 1 end,
	function () sysMCP.fdirGroup:actuate(1) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("==== EFIS control panel"))
preflightFOProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",kcFlowItem.actorFO,1,
	function () return ((sysEFIS.minsTypeCopilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=1 else flag=0 end
		sysEFIS.minsTypeCopilot:actuate(flag) sysEFIS.minsTypePilot:actuate(flag) 
	end))
preflightFOProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"arrival:decision\")",kcFlowItem.actorFO,1,
	function () return sysEFIS.minsResetCopilot:getStatus() == 1 and 
		(math.floor(sysEFIS.minsCopilot:getStatus()) == activeBriefings:get("arrival:decision") or
		math.ceil(sysEFIS.minsCopilot:getStatus()) == activeBriefings:get("arrival:decision")) end,
	function () sysEFIS.minsCopilot:adjustValue(activeBriefings:get("arrival:decision"),0,9000) sysEFIS.minsPilot:adjustValue(activeBriefings:get("arrival:decision"),0,9000) end))

preflightFOProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR SWITCH","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",kcFlowItem.actorFO,1,
	function () 
		return (sysEFIS.fpvCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
		or (sysEFIS.fpvCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvCopilot:actuate(flag) 
	end))
preflightFOProc:addItem(kcProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",kcFlowItem.actorFO,1,
	function () 
		return (sysEFIS.mtrsCopilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
		or (sysEFIS.mtrsCopilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsCopilot:actuate(flag) 
	end))

preflightFOProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",kcFlowItem.actorFO,1,
	function () return sysGeneral.baroModeGroup:getStatus() == (activePrefSet:get("general:baro_mode_hpa") == true and 3 or 0) end,
	function () if activePrefSet:get("general:baro_mode_hpa") then sysGeneral.baroModeGroup:actuate(1) else sysGeneral.baroModeGroup:actuate(0) end end))
preflightFOProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString()",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))

preflightFOProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",kcFlowItem.actorFO,1,
	function () return sysEFIS.voradf1Copilot:getStatus() == 1 and sysEFIS.voradf2Copilot:getStatus() == 1 end,
	function () sysEFIS.voradf1Copilot:actuate(1) sysEFIS.voradf2Copilot:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorFO,2,
	function () return sysEFIS.mapModeCopilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModeCopilot:adjustValue(sysEFIS.mapModeMAP,0,3) end))
preflightFOProc:addItem(kcProcedureItem:new("CENTER SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysEFIS.ctrCopilot:getStatus() == 1 end))
preflightFOProc:addItem(kcProcedureItem:new("RANGE SELECTOR","10 NM",kcFlowItem.actorFO,1,
	function () return sysEFIS.mapZoomCopilot:getStatus() == sysEFIS.mapRange10 end,
	function () sysEFIS.mapZoomCopilot:setValue(sysEFIS.mapRange10) end))
preflightFOProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysEFIS.tfcCopilot:getStatus() == modeOn end,
	function () sysEFIS.tfcCopilot:actuate(modeOn) end))
preflightFOProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorFO,2,
	function () return sysEFIS.wxrCopilot:getStatus() == 0 end,
	function () sysEFIS.wxrCopilot:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("MAP SWITCHES","AS NEEDED",kcFlowItem.actorFO,1))

preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Forward panel"))
preflightFOProc:addItem(kcProcedureItem:new("CLOCK","SET LOCAL TIME",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/clock/clock_display_mode_fo") == 3 end,
	function () command_end("laminar/B738/push_button/oxy_test_fo") end))
preflightFOProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.displayUnitsFO:getStatus() == 0 end,
	function () sysGeneral.displayUnitsFO:setValue(0) end))
preflightFOProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorFO,2,
	function () return sysGeneral.lowerDuFO:getStatus() == 0 end,
	function () sysGeneral.lowerDuFO:setValue(0) end))
preflightFOProc:addItem(kcIndirectProcedureItem:new("OXYGEN","TEST AND SET",kcFlowItem.actorFO,2,"oxygentestedfo",
	function () return get("laminar/B738/push_button/oxy_test_fo_pos") == 1 end,
	function () command_begin("laminar/B738/push_button/oxy_test_fo")  end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("==== GROUND PROXIMITY panel"))
preflightFOProc:addItem(kcProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,
	function () sysGeneral.flapInhibitCover:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,
	function () sysGeneral.gearInhibitCover:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",kcFlowItem.actorFO,2,
	function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,
	function () sysGeneral.terrainInhibitCover:actuate(0) end))
	
preflightFOProc:addItem(kcSimpleProcedureItem:new("==== Landing gear panel"))
preflightFOProc:addItem(kcProcedureItem:new("LANDING GEAR LEVER","DN",kcFlowItem.actorFO,2,
	function () return sysGeneral.GearSwitch:getStatus() == 1 end,
	function () sysGeneral.GearSwitch:actuate(1) end))
preflightFOProc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","#spell|RTO#",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 0 end,
	function () sysGeneral.autobreak:actuate(0) end))
preflightFOProc:addItem(kcProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",kcFlowItem.actorFO,2,
	function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end))

-- ============= PREFLIGHT PROCEDURE (CAPT) ============
-- LIGHTS.....................................TEST (CPT)
-- LIGHTS TEST.................................OFF (CPT)
-- OXYGEN RESET/TEST SWITCH..........PUSH AND HOLD (CPT)
-- ==== EFIS control panel
-- MINIMUMS REFERENCE SELECTOR..........RADIO/BARO (CPT)
-- DECISION HEIGHT OR ALTITUDE REFERENCE.......SET (CPT)
-- METERS SWITCH.........................MTRS/FEET (CPT)
-- FLIGHT PATH VECTOR.......................ON/OFF (CPT)
-- BAROMETRIC REFERENCE SELECTOR............HPA/IN (CPT)
-- BAROMETRIC SELECTOR.SET LOCAL ALTIMETER SETTING (CPT)
-- VOR/ADF SWITCHES............................VOR (CPT)
-- MODE SELECTOR...............................MAP (CPT)
-- CENTER SWITCH...............................OFF (CPT)
-- RANGE SELECTOR............................10 NM (CPT)
-- TRAFFIC SWITCH...............................ON (CPT)
-- WEATHER RADAR...............................OFF (CPT)
-- Set MAP SWITCHES AS NEEDED
-- ==== Mode control panel
-- COURSE NAV1.................................SET (CPT)
-- FLIGHT DIRECTOR SWITCHES........ON, LEFT MASTER (CPT)
-- Set BANK ANGLE SELECTOR AS NEEDED
-- AUTOPILOT DISENGAGE BAR......................UP (CPT)
-- ==== Main panel
-- CLOCK...................................SET UTC (CPT)
-- NOSE WHEEL STEERING SWITCH.........GUARD CLOSED (CPT)
-- ==== Display select panel
-- MAIN PANEL DISPLAY UNITS SELECTOR..........NORM (F/O)
-- LOWER DISPLAY UNIT SELECTOR................NORM (F/O)
-- Set INTEGRATED STANDBY FLIGHT DISPLAY
-- ==== Pedestal
-- SPEED BRAKE LEVER...................DOWN DETENT (CPT)
-- REVERSE THRUST LEVERS......................DOWN (CPT)
-- FORWARD THRUST LEVERS....................CLOSED (CPT)
-- FLAP LEVER..................................SET (CPT)
--   Set the flap lever to agree with the flap position.
-- PARKING BRAKE...............................SET (CPT)
-- ENGINE START LEVERS......................CUTOFF (CPT)
-- STABILIZER TRIM CUTOUT SWITCHES..........NORMAL (CPT)
-- CARGO FIRE TEST
-- WEATHER RADAR PANEL..........................SET (F/O)
-- TRANSPONDER PANEL............................SET (F/O)
-- YAW DAMPER SWITCH.............................ON (F/O)
-- ==== Radio tuning panel                              
-- VHF COMMUNICATIONS RADIOS....................SET (F/O)
-- VHF NAVIGATION RADIOS..........SET FOR DEPARTURE (F/O)
-- AUDIO CONTROL PANEL..........................SET (F/O)
-- ADF RADIOS...................................SET (F/O)

local preflightCPTProc = kcProcedure:new("PREFLIGHT PROCEDURE")
preflightCPTProc:setResize(false)
preflightCPTProc:addItem(kcIndirectProcedureItem:new("LIGHTS","TEST",kcFlowItem.actorCPT,1,"internal_lights_test",
	function () return sysGeneral.lightTest:getStatus() == 1 end,
	function () command_once("laminar/B738/toggle_switch/bright_test_up") end))
preflightCPTProc:addItem(kcProcedureItem:new("LIGHTS TEST","OFF",kcFlowItem.actorCPT,1,
	function () return sysGeneral.lightTest:getStatus() == 0 end))
preflightCPTProc:addItem(kcIndirectProcedureItem:new("OXYGEN","TEST AND SET",kcFlowItem.actorCPT,2,"oxygentestedcpt",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end,
	function () command_begin("laminar/B738/push_button/oxy_test_cpt") end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== EFIS control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MINIMUMS REFERENCE SELECTOR","%s|(activePrefSet:get(\"aircraft:efis_mins_dh\")) and \"RADIO\" or \"BARO\"",kcFlowItem.actorCPT,1,
	function () return ((sysEFIS.minsTypePilot:getStatus() == 0) == activePrefSet:get("aircraft:efis_mins_dh")) end,
	function () 
		command_end("laminar/B738/push_button/oxy_test_cpt") 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mins_dh") then flag=1 else flag=0 end
		sysEFIS.minsTypePilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","%s FT|activeBriefings:get(\"arrival:decision\")",kcFlowItem.actorFO,1,
	function () return sysEFIS.minsResetPilot:getStatus() == 1 and 
		(math.floor(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("arrival:decision") or
		math.ceil(sysEFIS.minsPilot:getStatus()) == activeBriefings:get("arrival:decision")) end,
	function () sysEFIS.minsPilot:adjustValue(activeBriefings:get("arrival:decision"),0,9000) end))
preflightCPTProc:addItem(kcProcedureItem:new("METERS SWITCH","%s|(activePrefSet:get(\"aircraft:efis_mtr\")) and \"MTRS\" or \"FEET\"",kcFlowItem.actorCPT,1,
	function () 
		return (sysEFIS.mtrsPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_mtr") == false) 
		or (sysEFIS.mtrsPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_mtr") == true) 
	end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_mtr") then flag=1 else flag=0 end
		sysEFIS.mtrsPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT PATH VECTOR","%s|(activePrefSet:get(\"aircraft:efis_fpv\")) and \"ON\" or \"OFF\"",kcFlowItem.actorCPT,1,
	function () 
		return (sysEFIS.fpvPilot:getStatus() == 0 and activePrefSet:get("aircraft:efis_fpv") == false) 
		or (sysEFIS.fpvPilot:getStatus() == 1 and activePrefSet:get("aircraft:efis_fpv") == true) end,
	function () 
		local flag = 0 
		if activePrefSet:get("aircraft:efis_fpv") then flag=1 else flag=0 end
		sysEFIS.fpvPilot:actuate(flag) 
	end))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","%s|(activePrefSet:get(\"general:baro_mode_hpa\")) and \"HPA\" or \"IN\"",kcFlowItem.actorCPT,1,
	function () return sysGeneral.baroModeGroup:getStatus() == (activePrefSet:get("general:baro_mode_hpa") == true and 3 or 0) end,
	function () if activePrefSet:get("general:baro_mode_hpa") then sysGeneral.baroModeGroup:actuate(1) else sysGeneral.baroModeGroup:actuate(0) end end))
preflightCPTProc:addItem(kcProcedureItem:new("BAROMETRIC SELECTORS TO LOCAL","%s|kc_getQNHString()",kcFlowItem.actorFO,1,
	function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100)
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot",math.ceil(get("sim/weather/barometer_sealevel_inhg")*100)/100) end))
				
preflightCPTProc:addItem(kcProcedureItem:new("VOR/ADF SWITCHES","VOR",kcFlowItem.actorCPT,1,
	function () return sysEFIS.voradf1Pilot:getStatus() == 1 and sysEFIS.voradf2Pilot:getStatus() == 1 end,
	function () sysEFIS.voradf1Pilot:actuate(1) sysEFIS.voradf2Pilot:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("MODE SELECTOR","MAP",kcFlowItem.actorCPT,1,
	function () return sysEFIS.mapModePilot:getStatus() == sysEFIS.mapModeMAP end,
	function () sysEFIS.mapModePilot:adjustValue(sysEFIS.mapModeMAP,0,3) end))
preflightCPTProc:addItem(kcProcedureItem:new("CENTER SWITCH","OFF",kcFlowItem.actorCPT,1,
	function () return sysEFIS.ctrPilot:getStatus() == 1 end))
preflightCPTProc:addItem(kcProcedureItem:new("RANGE SELECTOR","10 MILES",kcFlowItem.actorCPT,1,
	function () return sysEFIS.mapZoomPilot:getStatus() == sysEFIS.mapRange10 end,
	function () sysEFIS.ctrPilot:setValue(sysEFIS.mapRange10) end))
preflightCPTProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","ON",kcFlowItem.actorCPT,1,
	function () return sysEFIS.tfcPilot:getStatus() == 1 end,
	function () sysEFIS.tfcPilot:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR","OFF",kcFlowItem.actorCPT,1,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set MAP SWITCHES as needed"))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Mode control panel"))
preflightCPTProc:addItem(kcProcedureItem:new("COURSE NAV 1","SET %s|activeBriefings:get(\"takeoff:crs1\")",kcFlowItem.actorCPT,1,
	function() return math.ceil(sysMCP.crs1Selector:getStatus()) == activeBriefings:get("takeoff:crs1") end,
	function() sysMCP.crs1Selector:setValue(activeBriefings:get("takeoff:crs1")) end))
preflightCPTProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON, LEFT MASTER",kcFlowItem.actorCPT,2,
	function () return sysMCP.fdirGroup:getStatus() == 2 and get("laminar/B738/autopilot/master_capt_status") == 1 end,
	function () sysMCP.fdirGroup:actuate(1) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set BANK ANGLE SELECTOR as needed"))
preflightCPTProc:addItem(kcProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",kcFlowItem.actorCPT,1,
	function () return sysMCP.discAPSwitch:getStatus() == 0 end,
	function () sysMCP.discAPSwitch:actuate(0) end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Main panel"))
preflightCPTProc:addItem(kcProcedureItem:new("CLOCK","SET UTC",kcFlowItem.actorCPT,1,
	function() return get("laminar/B738/clock/clock_display_mode_capt") == 1 and 
		get("laminar/B738/clock/clock_display_mode_fo") == 3 end))
preflightCPTProc:addItem(kcProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",kcFlowItem.actorCPT,1,
	function () return get("laminar/B738/switches/nose_steer_pos") == 1 end,
	function () set("laminar/B738/switches/nose_steer_pos",1) end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Display select panel"))
preflightCPTProc:addItem(kcProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",kcFlowItem.actorCPT,2,
	function () return sysGeneral.displayUnitsCPT:getStatus() == 0 end,
	function () sysGeneral.displayUnitsCPT:setValue(0) end))
preflightCPTProc:addItem(kcProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",kcFlowItem.actorCPT,2,
	function () return sysGeneral.lowerDuCPT:getStatus() == 0 end,
	function () sysGeneral.lowerDuCPT:setValue(0) end))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("Set INTEGRATED STANDBY FLIGHT DISPLAY"))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Pedestal"))
preflightCPTProc:addItem(kcProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",kcFlowItem.actorCPT,1,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("REVERSE THRUST LEVERS","DOWN",kcFlowItem.actorCPT,1,
	function () return sysEngines.reverseLever1:getStatus() == 0 and sysEngines.reverseLever2:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/reverse_lever1",0) set("laminar/B738/flt_ctrls/reverse_lever2",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",kcFlowItem.actorCPT,1,
	function () return sysEngines.thrustLever1:getStatus() == 0 and sysEngines.thrustLever2:getStatus() == 0 end,
	function () set("laminar/B738/engine/thrust1_leveler",0) set("laminar/B738/engine/thrust2_leveler",0) end))
preflightCPTProc:addItem(kcProcedureItem:new("FLAP LEVER","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorCPT,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightCPTProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,
	function () sysEngines.startLever1:actuate(0) sysEngines.startLever2:actuate(0) end))
preflightCPTProc:addItem(kcProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",kcFlowItem.actorCPT,1,
	function () return get("laminar/B738/toggle_switch/ap_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_lock_pos") == 0 and
		get("laminar/B738/toggle_switch/ap_trim_pos") == 0 and
		get("laminar/B738/toggle_switch/el_trim_pos") == 0 end,
	function () set("laminar/B738/toggle_switch/ap_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/el_trim_lock_pos",0)
		set("laminar/B738/toggle_switch/ap_trim_pos",0)
		set("laminar/B738/toggle_switch/el_trim_pos",0) end))
preflightCPTProc:addItem(kcIndirectProcedureItem:new("CARGO FIRE TEST","PERFORM",kcFlowItem.actorCPT,1,"cargofiretest",
	function () return get("laminar/B738/push_botton/cargo_fire_test") == 1 end,
	function () command_begin("laminar/B738/push_button/cargo_fire_test_push") end))
preflightCPTProc:addItem(kcProcedureItem:new("WEATHER RADAR PANEL","SET",kcFlowItem.actorCPT,1,true,
	function () command_end("laminar/B738/push_button/cargo_fire_test_push") end))
preflightCPTProc:addItem(kcProcedureItem:new("TRANSPONDER PANEL","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("YAW DAMPER SWITCH","ON",kcFlowItem.actorCPT,2,
	function () return sysControls.yawDamper:getStatus() == modeOn end,
	function () sysControls.yawDamper:actuate(modeOn) end))

preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Radio tuning panel"))
preflightCPTProc:addItem(kcProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("AUDIO CONTROL PANEL","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcProcedureItem:new("ADF RADIOS","SET",kcFlowItem.actorCPT,1))
preflightCPTProc:addItem(kcSimpleProcedureItem:new("==== Briefing"))
preflightCPTProc:addItem(kcProcedureItem:new("DEPARTURE BRIEFING","PERFORM",kcFlowItem.actorCPT,1))

-- ==== Departure Briefing
-- Threats
-- MCP#
-- Takeoff briefing 

-- ================= PREFLIGHT CHECKLIST ================= 
-- OXYGEN..............................TESTED, 100% (BOTH)
-- NAVIGATION & DISPLAY SWITCHES........NORMAL,AUTO  (F/O)
-- WINDOW HEAT...................................ON  (F/O)
-- PRESSURIZATION MODE SELECTOR................AUTO  (F/O)
-- FLIGHT INSTRUMENTS.........HEADING__ ALTIMETER__ (BOTH)
-- PARKING BRAKE................................SET  (CPT)
-- ENGINE START LEVERS.......................CUTOFF  (CPT)
-- =======================================================

local preflightChkl = kcChecklist:new("PREFLIGHT CHECKLIST")
preflightChkl:addItem(kcIndirectChecklistItem:new("#exchange|OXYGEN|pre flight checklist. oxygen","TESTED #exchange|100 PERC|one hundred percent#",kcFlowItem.actorBOTH,2,"oxygentestedcpt",
	function () return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end))
preflightChkl:addItem(kcChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",kcFlowItem.actorFO,1,
	function () return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end,
	function () sysMCP.vhfNavSwitch:adjustValue(0,-1,1) 
				sysMCP.irsNavSwitch:setValue(0)
				sysMCP.fmcNavSwitch:setValue(0)
				sysMCP.displaySourceSwitch:setValue(0)
				sysMCP.displayControlSwitch:setValue(0) 
	end))
preflightChkl:addItem(kcChecklistItem:new("WINDOW HEAT","ON",kcFlowItem.actorFO,1,
	function () return sysAice.windowHeatGroup:getStatus() == 4 end,
	function () sysAice.windowHeatGroup:actuate(1) end))
preflightChkl:addItem(kcChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.pressModeSelector:getStatus() == 0 end,
	function () sysAir.pressModeSelector:actuate(0) end))
preflightChkl:addItem(kcChecklistItem:new("FLIGHT INSTRUMENTS","HEADING %i, ALTIMETER %i|math.floor(get(\"sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot\"))|math.floor(get(\"laminar/B738/autopilot/altitude\"))",kcFlowItem.actorBOTH,6,true,nil,nil))
preflightChkl:addItem(kcChecklistItem:new("PARKING BRAKE","SET",kcFlowItem.actorCPT,1,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end))
preflightChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(0) end))

-- =============== BEFORE START PROCEDURE ===============

-- Before Start 
-- Pilots 
-- o Check all three INS switches are in nav and all three INS computers have been 
-- programmed (see separate tutorial for INS procedures). 
-- o Set and cross-check speed bugs. 
-- o Check the flight directors, autopilot and autothrottle are disengaged. 
-- o On the MCP, set the speed bug to V2 + 10 , the heading bug to the runway heading, 
-- the navigation mode selector to HDG, the altitude window to the initial cleared 
-- altitude and arm ALT SEL. Turn the navigation radios and course as required. Check 
-- RADIO/INS switches are set to RADIO. 
-- o If the SEATBELT and NO SMOKING signs are not yet on, turn them on now. 
-- o Arm EPR on the thrust computer. Check the thrust knob is in TOD. Derate if desired. 
-- Engineer 
-- o Place all main boost pumps to on. Check all PRESS lights extinguish. Check No. 1 
-- and No. 4 crossfeeds are on and No 2 and No. 3 crossfeeds are off. 
-- o If more than 4500kgs/9920lbs of fuel is in the centre tank, turn on the 
-- override/jettison pumps. 
-- o Open all four bleed valves and . Check that you have sufficient PSI for start. 38 to 42
-- PSI is the normal range.
-- o Close No. 1 and No. 3 pack valves. Leave No. 2 open for start unless an ADP is 
-- required for start. 
-- o Turn on ELEC PUMP HYD SYS 4 for start. 
-- o Turn off galley power. 
-- Call the BEFORE START checklist: 



-- FLIGHT DECK DOOR..............CLOSED AND LOCKED (F/O)
-- CDU DISPLAY.................................SET (BOTH)
-- N1 BUGS...................................CHECK (BOTH)
-- IAS BUGS....................................SET (BOTH)
-- Set MCP
--   AUTOTHROTTLE ARM SWITCH...................ARM (CPT)
--   IAS/MACH SELECTOR......................SET V2 (CPT)
--   LNAV............................ARM AS NEEDED (CPT)
--   VNAV............................ARM AS NEEDED (CPT)
--   INITIAL HEADING...........................SET (CPT)
--   INITIAL ALTITUDE..........................SET (CPT)
-- TAXI AND TAKEOFF BRIEFINGS.............COMPLETE (BOTH)
-- EXTERIOR DOORS....................VERIFY CLOSED (F/O)
-- START CLEARANCE..........................OBTAIN (BOTH)
--   Obtain a clearance to pressurize hydraulic systems.
--   Obtain a clearance to start engines.
-- Set Fuel panel
--   CENTER FUEL PUMPS SWITCHES.................ON (F/O)
--     If center tank quantity exceeds 1,000 lbs/460 kgs
--   AFT AND FORWARD FUEL PUMPS SWITCHES........ON (F/O)
-- Set Hydraulic panel
--   ENGINE HYDRAULIC PUMP SWITCHES............OFF (F/O)
--   ELECTRIC HYDRAULIC PUMP SWITCHES...........ON (F/O)
-- ANTI COLLISION LIGHT SWITCH..................ON (F/O)
-- Set Trim
--   STABILIZER TRIM.....................___ UNITS (CPT)
--   AILERON TRIM..........................0 UNITS (CPT)
--   RUDDER TRIM...........................0 UNITS (CPT)
-- Call for Before Start Checklist


-- XPDR TO ALT OFF?


local beforeStartProc = kcProcedure:new("BEFORE START PROCEDURE","Before start items")
beforeStartProc:addItem(kcProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorFO,2,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set required CDU DISPLAY"))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Check N1 BUGS"))
beforeStartProc:addItem(kcProcedureItem:new("IAS BUGS","SET",kcFlowItem.actorBOTH,2,
	function () return sysFMC.noVSpeeds:getStatus() == 0 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(kcProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))
beforeStartProc:addItem(kcProcedureItem:new("  IAS/MACH SELECTOR","SET V2 %03d|activeBriefings:get(\"takeoff:v2\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") end,
	function () sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2")) end))
beforeStartProc:addItem(kcProcedureItem:new("  LNAV","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.lnavSwitch:getStatus() == 1 end, 
	function () sysMCP.lnavSwitch:actuate(modeOn) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(kcProcedureItem:new("  VNAV","ARM",kcFlowItem.actorCPT,2,
	function () return sysMCP.vnavSwitch:getStatus() == 1 end, 
	function () sysMCP.vnavSwitch:actuate(modeOn) end,
	function () return activeBriefings:get("takeoff:apMode") ~= 1 end))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL HEADING","SET %03d|activeBriefings:get(\"departure:initHeading\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") end,
	function () sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading")) end ))
beforeStartProc:addItem(kcProcedureItem:new("  INITIAL ALTITUDE","SET %05d|activeBriefings:get(\"departure:initAlt\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt")) end ))
beforeStartProc:addItem(kcSimpleProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS - COMPLETE?"))
beforeStartProc:addItem(kcProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",kcFlowItem.actorFO,1,
	function () return sysGeneral.doorGroup:getStatus() == 0 end,
	function () sysGeneral.doorGroup:actuate(0) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Obtain START CLEARANCE"))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to pressurize hydraulic systems."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Obtain a clearance to start engines."))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 2 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(0) end,
	function () return sysFuel.centerTankLbs:getStatus() > 1000 end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("    If center tank quantity exceeds 1,000 lbs/460 kgs",
	function () return sysFuel.centerTankLbs:getStatus() <= 1000 end))
beforeStartProc:addItem(kcProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () sysFuel.wingFuelPumpGroup:actuate(1) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Hydraulic panel"))
beforeStartProc:addItem(kcProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.engHydPumpGroup:actuate(0) end))
beforeStartProc:addItem(kcProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(1) end))
beforeStartProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("Set Trim"))
beforeStartProc:addItem(kcProcedureItem:new("  STABILIZER TRIM","%4.2f UNITS (%4.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*10000,100)/10000|activeBriefings:get(\"takeoff:elevatorTrim\")",kcFlowItem.actorCPT,1,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*10000,100)/10000) == activeBriefings:get("takeoff:elevatorTrim") end))
beforeStartProc:addItem(kcSimpleProcedureItem:new("  Use trim wheel and bring values to match."))
beforeStartProc:addItem(kcProcedureItem:new("  AILERON TRIM","0 UNITS (%3.2f)|sysControls.aileronTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartProc:addItem(kcProcedureItem:new("  RUDDER TRIM","0 UNITS (%3.2f)|sysControls.rudderTrimSwitch:getStatus()",kcFlowItem.actorCPT,2,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) end))

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

local beforeStartChkl = kcChecklist:new("BEFORE START CHECKLIST")
beforeStartChkl:addItem(kcChecklistItem:new("#exchange|FLIGHT DECK DOOR|before start checklist. FLIGHT DECK DOOR","CLOSED AND LOCKED",kcFlowItem.actorFO,2,
	function () return sysGeneral.cockpitDoor:getStatus() == 0 end,
	function () sysGeneral.cockpitDoor:actuate(0) end))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorFO,1,
	function () return sysFuel.wingFuelPumpGroup:getStatus() == 4 end,
	function () sysFuel.wingFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() > 999 end))
beforeStartChkl:addItem(kcChecklistItem:new("FUEL","%i %s, PUMPS ON|activePrefSet:get(\"general:weight_kgs\") and sysFuel.allTanksKgs:getStatus() or sysFuel.allTanksLbs:getStatus()|activePrefSet:get(\"general:weight_kgs\") and \"KGS\" or \"LBS\"",kcFlowItem.actorFO,1,
	function () return sysFuel.allFuelPumpGroup:getStatus() == 6 end,
	function () sysFuel.allFuelPumpGroup:actuate(1) end,
	function () return sysFuel.centerTankLbs:getStatus() < 1000 end))
beforeStartChkl:addItem(kcChecklistItem:new("PASSENGER SIGNS","SET",kcFlowItem.actorCPT,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end,
	function () sysGeneral.seatBeltSwitch:adjustValue(1,0,2)  sysGeneral.noSmokingSwitch:adjustValue(1,0,2) end))
beforeStartChkl:addItem(kcChecklistItem:new("WINDOWS","LOCKED",kcFlowItem.actorBOTH,2,true))
beforeStartChkl:addItem(kcChecklistItem:new("MCP","V2 %i, HDG %i, ALT %i|activeBriefings:get(\"takeoff:v2\")|activeBriefings:get(\"departure:initHeading\")|activeBriefings:get(\"departure:initAlt\")",kcFlowItem.actorCPT,2,
	function () return sysMCP.iasSelector:getStatus() == activeBriefings:get("takeoff:v2") and sysMCP.hdgSelector:getStatus() == activeBriefings:get("departure:initHeading") and sysMCP.altSelector:getStatus() == activeBriefings:get("departure:initAlt") end,
	function () sysMCP.iasSelector:setValue(activeBriefings:get("takeoff:v2"))
				sysMCP.hdgSelector:setValue(activeBriefings:get("departure:initHeading"))
				sysMCP.altSelector:setValue(activeBriefings:get("departure:initAlt"))
	 end))
beforeStartChkl:addItem(kcChecklistItem:new("TAKEOFF SPEEDS","V1 %i, VR %i, V2 %i|activeBriefings:get(\"takeoff:v1\")|activeBriefings:get(\"takeoff:vr\")|activeBriefings:get(\"takeoff:v2\")",kcFlowItem.actorPF,2))
beforeStartChkl:addItem(kcChecklistItem:new("CDU PREFLIGHT","COMPLETED",kcFlowItem.actorPF,1))
beforeStartChkl:addItem(kcChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",kcFlowItem.actorCPT,1,
	function () return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end,
	function () sysControls.rudderTrimSwitch:setValue(0) sysControls.aileronTrimSwitch:setValue(0) end))
beforeStartChkl:addItem(kcChecklistItem:new("TAXI AND TAKEOFF BRIEFING","COMPLETED",kcFlowItem.actorPF,1))
beforeStartChkl:addItem(kcChecklistItem:new("ANTI-COLLISION LIGHT SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 1 end,
	function () sysLights.beaconSwitch:actuate(1) end))

-- =========== PUSHBACK & ENGINE START (BOTH) ===========
-- PARKING BRAKE...............................SET  (F/O)
-- PUSHBACK SERVICE.........................ENGAGE  (CPT)
-- Engine Start may be done during pushback or towing
-- COMMUNICATION WITH GROUND.............ESTABLISH  (CPT)
-- PARKING BRAKE..........................RELEASED  (F/O)
-- PACKS...............................AUTO OR OFF  (F/O)
-- When pushback/towing complete
--   TOW BAR DISCONNECTED...................VERIFY  (CPT)
--   LOCKOUT PIN REMOVED....................VERIFY  (CPT)
--   SYSTEM A HYDRAULIC PUMPS...................ON  (F/O)
-- START FIRST ENGINE............STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......START SWITCH _ TO GRD  (F/O)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER...............LEVER _ IDLE  (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- START SECOND ENGINE...........STARTING ENGINE _  (CPT)
-- ENGINE START SWITCH.......START SWITCH _ TO GRD  (F/O)
--   Verify that the N2 RPM increases.
--   When N1 rotation is seen and N2 is at 25%,
--   ENGINE START LEVER...............LEVER _ IDLE  (F/O)
--   When starter switch jumps back call STARTER CUTOUT
-- PARKING BRAKE...............................SET  (F/O)
--   When instructed by ground crew after pushback/towing
-- Next BEFORE TAXI PROCEDURE

local pushstartProc = kcProcedure:new("PUSHBACK & ENGINE START","let's get ready for push and start")
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,"pb_parkbrk_initial_set",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,
	function () sysGeneral.parkBrakeSwitch:actuate(1) end ))
pushstartProc:addItem(kcProcedureItem:new("PUSHBACK SERVICE","ENGAGE",kcFlowItem.actorCPT,2))
pushstartProc:addItem(kcSimpleProcedureItem:new("Engine Start may be done during pushback or towing"))
pushstartProc:addItem(kcProcedureItem:new("COMMUNICATION WITH GROUND","ESTABLISH",kcFlowItem.actorCPT,2))
pushstartProc:addItem(kcIndirectProcedureItem:new("PARKING BRAKE","RELEASED",kcFlowItem.actorFO,2,"pb_parkbrk_release",
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 0 end))
pushstartProc:addItem(kcProcedureItem:new("PACKS","AUTO or OFF",kcFlowItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:setValue(0) end))
pushstartProc:addItem(kcProcedureItem:new("SYSTEM A HYDRAULIC PUMPS","ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.elecHydPump1:getStatus() == 1 end,
	function () sysHydraulic.engHydPump1:actuate(1) sysHydraulic.elecHydPump1:actuate(1) end))
pushstartProc:addItem(kcSimpleChecklistItem:new("Wait for start clearance from ground crew"))
pushstartProc:addItem(kcProcedureItem:new("START FIRST ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorFO,2,"eng_start_1_grd",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart2Switch:getStatus() == 0 else 
		return sysEngines.engStart1Switch:getStatus() == 0 end end))
	-- function () if activeBriefings:get("taxi:startSequence") == 1 then
		-- sysEngines.engStart2Switch:actuate(0) else
		-- sysEngines.engStart1Switch:actuate(0) end 
		-- end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  Verify that the N2 RPM increases."))
pushstartProc:addItem(kcProcedureItem:new("  N2 ROTATION","AT 25%",kcFlowItem.actorCPT,1,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 else 
		return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 end end))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"2\" or \"1\"",kcFlowItem.actorFO,2,"eng_start_1_lever",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.startLever2:getStatus() == 1 else 
		return sysEngines.startLever1:getStatus() == 1 end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcProcedureItem:new("STARTER CUTOUT","ANNOUNCE",kcFlowItem.actorFO,1,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart2Switch:getStatus() == 1 else 
		return sysEngines.engStart1Switch:getStatus() == 1 end end))
pushstartProc:addItem(kcProcedureItem:new("START SECOND ENGINE","START ENGINE %s|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorCPT,1, true,
	function () kc_speakNoText(0,"starter cutout") end))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START SWITCH","START SWITCH %s TO GRD|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorFO,2,"eng_start_2_grd",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart1Switch:getStatus() == 0 else 
		return sysEngines.engStart2Switch:getStatus() == 0 end end))
	-- function () if activeBriefings:get("taxi:startSequence") == 1 then
		-- sysEngines.engStart1Switch:actuate(0) else
		-- sysEngines.engStart2Switch:actuate(0) end end))
pushstartProc:addItem(kcProcedureItem:new("N2 ROTATION","AT 25%",kcFlowItem.actorCPT,1,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return get("laminar/B738/engine/indicators/N2_percent_1") > 24.9 else 
		return get("laminar/B738/engine/indicators/N2_percent_2") > 24.9 end end))
pushstartProc:addItem(kcIndirectProcedureItem:new("  ENGINE START LEVER","LEVER %s IDLE|activeBriefings:get(\"taxi:startSequence\") == 1 and \"1\" or \"2\"",kcFlowItem.actorFO,2,"eng_start_2_lever",
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.startLever1:getStatus() == 1 else 
		return sysEngines.startLever2:getStatus() == 1 end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("  When starter switch jumps back call STARTER CUTOUT"))
pushstartProc:addItem(kcProcedureItem:new("STARTER CUTOUT","ANNOUNCE",kcFlowItem.actorFO,1,
	function () if activeBriefings:get("taxi:startSequence") == 1 then
		return sysEngines.engStart1Switch:getStatus() == 1 else 
		return sysEngines.engStart2Switch:getStatus() == 1 end end))
pushstartProc:addItem(kcSimpleProcedureItem:new("When pushback/towing complete"))
pushstartProc:addItem(kcProcedureItem:new("  TOW BAR DISCONNECTED","VERIFY",kcFlowItem.actorCPT,1,true,
	function () kc_speakNoText(0,"starter cutout") end))
pushstartProc:addItem(kcProcedureItem:new("  LOCKOUT PIN REMOVED","VERIFY",kcFlowItem.actorCPT,1))
pushstartProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorFO,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == 1 end))


-- ============ BEFORE TAXI PROCEDURE (F/O) ============
-- HYDRAULIC PUMP SWITCHES..................ALL ON (F/O)
-- GENERATOR 1 AND 2 SWITCHES...................ON (F/O)
-- PROBE HEAT SWITCHES..........................ON (F/O)
-- WING ANTI-ICE SWITCH..................AS NEEDED (F/O)
-- ENGINE ANTI-ICE SWITCHES..............AS NEEDED (F/O)
-- PACK SWITCHES..............................AUTO (F/O)
-- ISOLATION VALVE SWITCH.....................AUTO (F/O)
-- APU BLEED AIR SWITCH........................OFF (F/O)
-- APU SWITCH..................................OFF (F/O)
-- ENGINE START SWITCHES......................CONT (F/O)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- Verify that the ground equipment is clear.
-- Call 'FLAPS ___' as needed for takeoff.         (CPT)
-- FLAP LEVER....................SET TAKEOFF FLAPS (F/O)
-- LE FLAPS EXT GREEN LIGHT............ILLUMINATED (BOTH)
-- FLIGHT CONTROLS...........................CHECK (CPT)
-- TRANSPONDER...........................AS NEEDED (F/O)
-- RECALL....................................CHECK (BOTH)
--   Verify annunciators illuminate and then extinguish.
-- Call BEFORE TAXI CHECKLIST

local beforeTaxiProc = kcProcedure:new("BEFORE TAXI PROCEDURE","before taxi procedure")
beforeTaxiProc:addItem(kcProcedureItem:new("HYDRAULIC PUMP SWITCHES","ALL ON",kcFlowItem.actorFO,1,
	function () return sysHydraulic.hydPumpGroup:getStatus() == 4 end,
	function () sysHydraulic.hydPumpGroup:actuate(modeOn) end))
beforeTaxiProc:addItem(kcProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end,
	function () command_begin("laminar/B738/toggle_switch/gen1_dn") command_begin("laminar/B738/toggle_switch/gen2_dn") end))
beforeTaxiProc:addItem(kcProcedureItem:new("PROBE HEAT SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) command_end("laminar/B738/toggle_switch/gen1_dn") command_end("laminar/B738/toggle_switch/gen2_dn") end))
beforeTaxiProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") == 3 end))
beforeTaxiProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","ON",kcFlowItem.actorFO,1,
	function () return sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") < 3 end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") > 1 end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","ON",kcFlowItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 end,
	function () sysAice.engAntiIceGroup:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") == 1 end))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("  When temperature <10 C & visible moisture"))
beforeTaxiProc:addItem(kcProcedureItem:new("PACK SWITCHES","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () sysAir.packSwitchGroup:setValue(1) end))
beforeTaxiProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",kcFlowItem.actorFO,1,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function () sysAir.isoValveSwitch:setValue(1) end))
beforeTaxiProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysAir.apuBleedSwitch:getStatus() == 0 end,
	function () sysAir.apuBleedSwitch:actuate(modeOff) end))
beforeTaxiProc:addItem(kcProcedureItem:new("APU SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysElectric.apuStartSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up") end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","CONT",kcFlowItem.actorFO,1,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:adjustValue(2,0,3) end))
beforeTaxiProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",kcFlowItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(kcSimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(kcProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS %s|activeBriefings:get(\"takeoff:flaps\")",kcFlowItem.actorFO,1,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] end,
	function () set("laminar/B738/flt_ctrls/flap_lever",sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
beforeTaxiProc:addItem(kcProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",kcFlowItem.actorBOTH,1,
	function () return get("laminar/B738/annunciator/slats_extend") == 1 end))
beforeTaxiProc:addItem(kcProcedureItem:new("FLIGHT CONTROLS","CHECK",kcFlowItem.actorCPT,1))
beforeTaxiProc:addItem(kcProcedureItem:new("TRANSPONDER","AS NEEDED",kcFlowItem.actorFO,1))
beforeTaxiProc:addItem(kcProcedureItem:new("RECALL","CHECK",kcFlowItem.actorBOTH,1,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))

-- chrono
	
-- ============ BEFORE TAXI CHECKLIST (F/O) ============
-- GENERATORS...................................ON (F/O)
-- PROBE HEAT...................................ON (F/O)
-- ANTI-ICE............................AS REQUIRED (F/O)
-- ISOLATION VALVE............................AUTO (F/O)
-- ENGINE START SWITCHES......................CONT (F/O)
-- RECALL..................................CHECKED (F/O)
-- AUTOBRAKE...................................RTO (F/O)
-- ENGINE START LEVERS.................IDLE DETENT (CPT)
-- FLIGHT CONTROLS.........................CHECKED (CPT)
-- GROUND EQUIPMENT..........................CLEAR (F/O)
-- =====================================================

local beforeTaxiChkl = kcChecklist:new("BEFORE TAXI CHECKLIST")
beforeTaxiChkl:addItem(kcChecklistItem:new("#exchange|GENERATORS|before taxi checklist. generators","ON",kcChecklistItem.actorFO,1,
	function () return sysElectric.gen1off:getStatus() == 0 and sysElectric.gen2off:getStatus() == 0 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("PROBE HEAT","ON",kcChecklistItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() == 2 end,
	function () sysAice.probeHeatGroup:actuate(1) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","OFF",kcChecklistItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 1 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","ENGINE ANTI-ICE",kcChecklistItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(0) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 2 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ANTI-ICE","ENGINE & WING ANTI-ICE",kcChecklistItem.actorFO,1,
	function () return sysAice.engAntiIceGroup:getStatus() == 2 and sysAice.wingAntiIce:getStatus() == 1 end,
	function () sysAice.engAntiIceGroup:actuate(1) sysAice.wingAntiIce:actuate(1) end,
	function () return activeBriefings:get("takeoff:antiice") ~= 3 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ISOLATION VALVE","AUTO",kcChecklistItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() > 0 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START SWITCHES","CONT",kcChecklistItem.actorCPT,2,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:adjustValue(2,0,3) end)) 
beforeTaxiChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorCPT,1,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
beforeTaxiChkl:addItem(kcChecklistItem:new("AUTOBRAKE","RTO",kcChecklistItem.actorCPT,2,
	function () return sysGeneral.autobreak:getStatus() == 0 end,
	function () sysGeneral.autobreak:actuate(0) end))
beforeTaxiChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",kcChecklistItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 2 end))
beforeTaxiChkl:addItem(kcChecklistItem:new("FLIGHT CONTROLS","CHECKED",kcChecklistItem.actorCPT,1))
beforeTaxiChkl:addItem(kcChecklistItem:new("GROUND EQUIPMENT","CLEAR",kcChecklistItem.actorFO,1,true,
	function () sysLights.taxiSwitch:actuate(1) end))

-- ========== BEFORE TAKEOFF CHECKLIST (F/O) ===========
-- FLAPS...........................__, GREEN LIGHT (CPT)
-- STABILIZER TRIM...................... ___ UNITS (CPT)
-- =====================================================

local beforeTakeoffChkl = kcChecklist:new("BEFORE TAKEOFF CHECKLIST")
beforeTakeoffChkl:addItem(kcChecklistItem:new("#exchange|FLAPS|before takeoff checklist. Flaps","%s, GREEN LIGHT|activeBriefings:get(\"takeoff:flaps\")",kcChecklistItem.actorCPT,1,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")] and get("laminar/B738/annunciator/slats_extend") == 1 end,
	function () set("laminar/B738/flt_ctrls/flap_lever",sysControls.flaps_pos[activeBriefings:get("takeoff:flaps")]) end)) 
beforeTakeoffChkl:addItem(kcChecklistItem:new("STABILIZER TRIM","%3.2f UNITS (%3.2f)|kc_round_step((8.2-(get(\"sim/flightmodel2/controls/elevator_trim\")/-0.119)+0.4)*1000,10)/1000|activeBriefings:get(\"takeoff:elevatorTrim\")",kcFlowItem.actorCPT,1,
	function () return (kc_round_step((8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)+0.4)*1000,10)/1000 == activeBriefings:get("takeoff:elevatorTrim")*100/100) end))

-- ============ RUNWAY ENTRY PROCEDURE (F/O) ============
-- STROBES.......................................ON (F/O)
-- TRANSPONDER...................................ON (F/O)
-- FIXED LANDING LIGHTS..........................ON (CPT)
-- RWY TURNOFF LIGHTS............................ON (CPT)
-- TAXI LIGHTS..................................OFF (CPT)
-- ======================================================

local runwayEntryProc = kcProcedure:new("RUNWAY ENTRY PROCEDURE","runway entry")
runwayEntryProc:addItem(kcProcedureItem:new("STROBES","ON",kcFlowItem.actorFO,2,
	function () return sysLights.strobesSwitch:getStatus() == 1 end,
	function () sysLights.strobesSwitch:actuate(1) end))
runwayEntryProc:addItem(kcProcedureItem:new("TRANSPONDER","ON",kcFlowItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == 5 end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrTARA,0,5) end))
runwayEntryProc:addItem(kcProcedureItem:new("LANDING LIGHTS","ON",kcFlowItem.actorCPT,2,
	function () return sysLights.landLightGroup:getStatus() > 1 end,
	function () sysLights.landLightGroup:actuate(1) end))
runwayEntryProc:addItem(kcProcedureItem:new("RWY TURNOFF LIGHTS","ON",kcFlowItem.actorCPT,2,
	function () return sysLights.rwyLightGroup:getStatus() > 0 end,
	function () sysLights.rwyLightGroup:actuate(1) end))
runwayEntryProc:addItem(kcProcedureItem:new("TAXI LIGHTS","OFF",kcFlowItem.actorCPT,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
	
--	center pumps off

-- =========== TAKEOFF & INITIAL CLIMB (BOTH) ===========
-- AUTOTHROTTLE................................ARM   (PF)
-- A/P MODES...........................AS REQUIRED   (PF)
-- THRUST SETTING...........................40% N1  (PNF)
-- SET TAKEOFF THRUST.....................T/O MODE   (PF)
-- POSITIVE RATE......................GT 40 FT AGL   (PF)
-- GEAR.........................................UP	(PNF)
-- FLAPS 15 SPEED...............REACHED (OPTIONAL)
-- FLAPS 10.........................SET (OPTIONAL)	(PNF)
-- FLAPS 10 SPEED...............REACHED (OPTIONAL)
-- FLAPS 5..........................SET (OPTIONAL)	(PNF)
-- FLAPS 5 SPEED...........................REACHED
-- FLAPS 1.....................................SET 	(PNF)
-- FLAPS 1 SPEED...........................REACHED 
-- FLAPS UP....................................SET 	(PNF)
-- ACCELERATION ALTITUDE.............GT 300 FT AGL
-- CMD-A........................................ON	(PNF)
-- AUTO BRAKE SELECT SWITCH....................OFF	(PNF)
-- GEAR........................................OFF	(PNF)
-- Next AFTER TAKEOFF CHECKLIST

--chrono
local takeoffClimbProc = kcProcedure:new("TAKEOFF & INITIAL CLIMB","takeoff")
takeoffClimbProc:addItem(kcProcedureItem:new("AUTOTHROTTLE","ARM",kcFlowItem.actorPF,2,
	function () return sysMCP.athrSwitch:getStatus() == 1 end,
	function () sysMCP.athrSwitch:actuate(modeOn) end))
takeoffClimbProc:addItem(kcProcedureItem:new("A/P MODES","%s|kc_pref_split(kc_TakeoffApModes)[activeBriefings:get(\"takeoff:apMode\")]",kcFlowItem.actorPF,2,
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
	end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("THRUST SETTING","40% N1",kcFlowItem.actorPNF,1,"to40percent",
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 40 end))
takeoffClimbProc:addItem(kcProcedureItem:new("SET TAKEOFF THRUST","T/O MODE",kcFlowItem.actorPF,2,
	function () return get("laminar/B738/engine/indicators/N1_percent_1") > 70 end,
	function () command_once("laminar/B738/autopilot/left_toga_press") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("POSITIVE RATE","GT 40 FT AGL",kcFlowItem.actorPNF,2,"toposrate",
	function () return get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 150 and get("sim/flightmodel/position/y_agl") > 40 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("GEAR","UP",kcFlowItem.actorPF,2,"gear_up_to",
	function () return sysGeneral.GearSwitch:getStatus() == 0 end,
	function () sysGeneral.GearSwitch:actuate(0) kc_speakNoText(0,"gear up") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 15 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap15spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_15") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.625 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 10","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/flaps_10") kc_speakNoText(0,"speed check flaps 10") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 10 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap10spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_10") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.5 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 5","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.375 end,
	function () command_once("laminar/B738/push_button/flaps_5") kc_speakNoText(0,"speed check flaps 5") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 5 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap5spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_5") end,nil,
	function () return sysControls.flapsSwitch:getStatus() < 0.375 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS 1","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0.125 end,
	function () command_once("laminar/B738/push_button/flaps_1") kc_speakNoText(0,"speed check flaps 1") end,
	function () return sysControls.flapsSwitch:getStatus() < 0.125 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("FLAPS 1 SPEED","REACHED",kcFlowItem.actorPNF,2,"toflap1spd",
	function () return get("sim/cockpit2/gauges/indicators/airspeed_kts_pilot") > get("laminar/B738/pfd/flaps_1") end))
takeoffClimbProc:addItem(kcProcedureItem:new("FLAPS UP","SET",kcFlowItem.actorPNF,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/push_button/flaps_0") kc_speakNoText(0,"speed check flaps up") end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("ACCELERATION ALTITUDE","GT 300 FT AGL",kcFlowItem.actorPNF,2,"toaccalt",
	function () return get("sim/flightmodel/position/y_agl") > 300 end))
takeoffClimbProc:addItem(kcProcedureItem:new("CMD-A","ON",kcFlowItem.actorPF,2,
	function () return sysMCP.ap1Switch:getStatus() == 1 end,
	function () if activePrefSet:get("takeoff_cmda") == true then sysMCP.ap1Switch:actuate(1) end kc_speakNoText(0,"command a") end))
takeoffClimbProc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 1 end,
	function () sysGeneral.autobreak:actuate(1) end))
takeoffClimbProc:addItem(kcProcedureItem:new("GEAR","OFF",kcFlowItem.actorPF,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () command_once("laminar/B738/push_button/gear_off") end))
	
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("TRANSITION ALTITUDE","REACHED",kcFlowItem.actorPF,2,"to_trans_alt",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > activeBriefings:get("departure:transalt") end,nil,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("ALTIMETERS","STD",kcFlowItem.actorPF,2,"to_altimeters",
	function () return get("laminar/B738/EFIS/baro_set_std_pilot") == 1 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",29.92) set("laminar/B738/EFIS/baro_sel_in_hg_copilot",29.92) end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))

takeoffClimbProc:addItem(kcIndirectProcedureItem:new("10.000 FT","REACHED",kcFlowItem.actorPF,2,"to_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 end,nil,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("LANDING LIGHTS","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(0) end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/toggle_switch/seatbelt_sign_up") command_once("laminar/B738/toggle_switch/seatbelt_sign_up") end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))

takeoffClimbProc:addItem(kcIndirectProcedureItem:new("10.000 FT","REACHED",kcFlowItem.actorPF,2,"to_10000",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000 end,nil,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("LANDING LIGHTS","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.rwyLightGroup:getStatus() == 0 end,
	function () sysLights.rwyLightGroup:actuate(0) end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))
takeoffClimbProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () command_once("laminar/B738/toggle_switch/seatbelt_sign_up") command_once("laminar/B738/toggle_switch/seatbelt_sign_up") end,
	function () return activeBriefings:get("departure:transalt") > 10000 end))

takeoffClimbProc:addItem(kcIndirectProcedureItem:new("TRANSITION ALTITUDE","REACHED",kcFlowItem.actorPF,2,"to_trans_alt",
	function () return get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > activeBriefings:get("departure:transalt") end,nil,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))
takeoffClimbProc:addItem(kcIndirectProcedureItem:new("ALTIMETERS","STD",kcFlowItem.actorPF,2,"to_altimeters",
	function () return get("laminar/B738/EFIS/baro_set_std_pilot") == 1 end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot",29.92) set("laminar/B738/EFIS/baro_sel_in_hg_copilot",29.92) end,
	function () return activeBriefings:get("departure:transalt") <= 10000 end))

-- center pumps on if >xxx
	
-- ============ AFTER TAKEOFF CHECKLIST (PM) ============
-- ENGINE BLEEDS................................ON   (PM)
-- PACKS......................................AUTO   (PM)
-- LANDING GEAR.........................UP AND OFF   (PM)
-- FLAPS.............................UP, NO LIGHTS   (PM)
-- ======================================================

local afterTakeoffChkl = kcChecklist:new("AFTER TAKEOFF CHECKLIST")
afterTakeoffChkl:addItem(kcChecklistItem:new("#exchange|ENGINE BLEEDS|after takeoff checklist. engine bleeds","ON",kcChecklistItem.actorPM,2,
	function () return sysAir.engBleedGroup:getStatus() == 2 end,
	function () sysAir.engBleedGroup:actuate(1) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("PACKS","AUTO",kcChecklistItem.actorPM,2,
	function () return sysAir.packSwitchGroup:getStatus() == 2 end,
	function () sysAir.packSwitchGroup:setValue(1) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("LANDING GEAR","UP AND OFF",kcChecklistItem.actorPM,2,
	function () return sysGeneral.GearSwitch:getStatus() == 0.5 end,
	function () sysGeneral.GearSwitch:setValue(0.5) end))
afterTakeoffChkl:addItem(kcChecklistItem:new("FLAPS","UP, NO LIGHTS",kcChecklistItem.actorPM,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () sysControls.flapsSwitch:adjustValue(0) end))

-- ============ descent =============
local descentProc = kcProcedure:new("DESCENT PROCEDURE","performing descent items")
descentProc:addItem(kcProcedureItem:new("LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.ctrFuelPumpGroup:getStatus() == 0 end,
	function () sysFuel.ctrFuelPumpGroup:actuate(0) end,
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(kcSimpleProcedureItem:new("  If center tank quantity at or below 3,000 lbs/1400 kgs",
	function () return sysFuel.centerTankLbs:getStatus() > 3000 end))
descentProc:addItem(kcProcedureItem:new("PRESSURIZATION","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",kcChecklistItem.actorPM,1,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentProc:addItem(kcProcedureItem:new("RECALL","CHECKED ALL OFF",kcChecklistItem.actorPM,1,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentProc:addItem(kcProcedureItem:new("VREF","SELECT IN FMC",kcProcedureItem.actorCPT,1,
	function () return get("laminar/B738/FMS/vref") ~= 0 end))
descentProc:addItem(kcProcedureItem:new("LANDING DATA","VREF %i, MINIMUMS %i|get(\"laminar/B738/FMS/vref\")|activeBriefings:get(\"arrival:decision\")",kcChecklistItem.actorBOTH,1,
	function () return get("laminar/B738/FMS/vref") ~= 0 and 
				sysEFIS.minsResetCopilot:getStatus() == 1 and 
				kc_round_step(sysEFIS.minsPilot:getStatus()*1000,10)/1000 == activeBriefings:get("arrival:decision") end))
descentProc:addItem(kcSimpleProcedureItem:new("Set or verify the navigation radios and course for the approach."))
descentProc:addItem(kcProcedureItem:new("AUTO BRAKE SELECT SWITCH","%s|kc_pref_split(kc_LandingAutoBrake)[activeBriefings:get(\"approach:autobrake\")]",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == activeBriefings:get("approach:autobrake") end,
	function () sysGeneral.autobreak:adjustValue(activeBriefings:get("approach:autobrake"),1,5) end))
descentProc:addItem(kcSimpleChecklistItem:new("Do the approach briefing."))

-- =============== DESCENT CHECKLIST (PM) ===============
-- PRESSURIZATION...................LAND ALT _____   (PM)
-- RECALL..................................CHECKED (BOTH)
-- AUTOBRAKE...................................___   (PM)
-- LANDING DATA...............VREF___, MINIMUMS___ (BOTH)
-- APPROACH BRIEFING.....................COMPLETED   (PF)
-- ======================================================

local descentChkl = kcChecklist:new("DESCENT CHECKLIST")
descentChkl:addItem(kcChecklistItem:new("#exchange|PRESSURIZATION|descent checklist. pressurization","LAND ALT %i FT|activeBriefings:get(\"arrival:aptElevation\")",kcChecklistItem.actorPM,1,
	function () return sysAir.landingAltitude:getStatus() == kc_round_step(activeBriefings:get("arrival:aptElevation"),50) end,
	function () sysAir.landingAltitude:setValue(kc_round_step(activeBriefings:get("arrival:aptElevation"),50)) end))
descentChkl:addItem(kcChecklistItem:new("RECALL","CHECKED",kcChecklistItem.actorBOTH,1,
	function() return sysGeneral.annunciators:getStatus() == 0 end,
	function() command_once("laminar/B738/push_button/capt_six_pack") end))
descentChkl:addItem(kcChecklistItem:new("AUTOBRAKE","%s|kc_LandingAutoBrake[activeBriefings:get(\"approach:autobrake\")]",kcChecklistItem.actorPM,1))
descentChkl:addItem(kcChecklistItem:new("LANDING DATA","VREF %i, MINIMUMS %i|activeBriefings:get(\"approach:vref\")|activeBriefings:get(\"arrival:decision\")",kcChecklistItem.actorBOTH,1))
descentChkl:addItem(kcChecklistItem:new("APPROACH BRIEFING","COMPLETED",kcChecklistItem.actorPF,1))

 -- =============== APPROACH CHECKLIST (PM) ==============
 -- ALTIMETERS............................QNH _____ (BOTH)
 -- ======================================================

local approachChkl = kcChecklist:new("APPROACH CHECKLIST")
approachChkl:addItem(kcChecklistItem:new("#exchange|ALTIMETERS|approach checklist. altimeters","QNH %s|activeBriefings:get(\"arrival:atisQNH\")",kcChecklistItem.actorBOTH,1,
	function () return get("laminar/B738/EFIS/baro_sel_in_hg_pilot") == activeBriefings:get("arrival:atisQNH") and 
		get("laminar/B738/EFIS/baro_sel_in_hg_copilot") == activeBriefings:get("arrival:atisQNH") end,
	function () set("laminar/B738/EFIS/baro_sel_in_hg_pilot", activeBriefings:get("arrival:atisQNH"))
				set("laminar/B738/EFIS/baro_sel_in_hg_copilot", activeBriefings:get("arrival:atisQNH")) end))

 -- =============== LANDING PROCEDURE (PM) ===============
local landingProc = kcProcedure:new("LANDING PROCEDURE")

 -- =============== LANDING CHECKLIST (PM) ===============
 -- ENGINE START SWITCHES......................CONT   (PF)
 -- SPEEDBRAKE................................ARMED   (PF)
 -- LANDING GEAR...............................DOWN   (PF)
 -- FLAPS..........................___, GREEN LIGHT   (PF)
 -- ======================================================

local landingChkl = kcChecklist:new("LANDING CHECKLIST")
landingChkl:addItem(kcChecklistItem:new("#exchange|ENGINE START SWITCHES|landing checklist. ENGINE START SWITCHES","CONT",kcChecklistItem.actorPF,2,
	function () return sysEngines.engStarterGroup:getStatus() == 4 end,
	function () sysEngines.engStarterGroup:adjustValue(2,0,3) end)) 
landingChkl:addItem(kcChecklistItem:new("SPEED BRAKE","ARMED",kcChecklistItem.actorPF,1,
	function () return get("laminar/B738/annunciator/speedbrake_armed") == 1 end))
landingChkl:addItem(kcChecklistItem:new("LANDING GEAR","DOWN",kcChecklistItem.actorPF,2,
	function () return sysGeneral.GearSwitch:getStatus() == modeOn end,
	function () sysGeneral.GearSwitch:actuate(modeOn) end))
landingChkl:addItem(kcChecklistItem:new("FLAPS","%s, GREEN LIGHT|activeBriefings:get(\"approach:flaps\")",kcChecklistItem.actorPF,2,
	function () return sysControls.flapsSwitch:getStatus() == sysControls.flaps_pos[activeBriefings:get("approach:flaps")] 
	and get("laminar/B738/annunciator/slats_extend") == 1 end)) 

-- =========== AFTER LANDING PROCEDURE ============
-- SPEED BRAKE................................DOWN   (PF)
-- CHRONO & ET................................STOP  (CPT)
-- WX RADAR....................................OFF  (CPT)
-- APU.......................................START   (FO)
--   Hold APU switch in START position for 3-4 seconds
--   APU GEN OFF BUS LIGHT.............ILLUMINATED   (FO)
-- FLAPS........................................UP   (FO)
-- PROBE HEAT..................................OFF   (FO)
-- STROBES.....................................OFF   (FO)
-- LANDING LIGHTS..............................OFF   (FO)
-- TAXI LIGHTS..................................ON  (CPT)
-- ENGINE START SWITCHES.......................OFF   (FO)
-- TRAFFIC SWITCH..............................OFF   (FO)
-- AUTOBRAKE...................................OFF   (FO)

local afterLandingProc = kcProcedure:new("AFTER LANDING PROCEDURE","cleaning up")
afterLandingProc:addItem(kcChecklistItem:new("SPEED BRAKE","DOWN",kcChecklistItem.actorPF,2,
	function () return sysControls.spoilerLever:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/speedbrake_lever",0) end))
afterLandingProc:addItem(kcChecklistItem:new("CHRONO & ET","STOP",kcChecklistItem.actorCPT,2))
afterLandingProc:addItem(kcChecklistItem:new("WX RADAR","OFF",kcChecklistItem.actorCPT,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("#spell|APU#","START",kcFlowItem.actorFO,2,
	function () return sysElectric.apuRunningAnc:getStatus() == modeOn end,
	function () command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn") end))
afterLandingProc:addItem(kcSimpleProcedureItem:new("  Hold APU switch in START position for 3-4 seconds."))
afterLandingProc:addItem(kcIndirectProcedureItem:new("  #spell|APU# GEN OFF BUS LIGHT","ILLUMINATED",kcFlowItem.actorFO,1,"apu_gen_bus_end",
	function () return sysElectric.apuGenBusOff:getStatus() == modeOn end,
	function () command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn") end))
afterLandingProc:addItem(kcProcedureItem:new("FLAPS","UP",kcFlowItem.actorFO,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 and sysControls.slatsExtended:getStatus() == 0 end,
	function () sysControls.flapsSwitch:adjustValue(0) end))
afterLandingProc:addItem(kcProcedureItem:new("PROBE HEAT","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() == 0 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("STROBES","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.strobesSwitch:getStatus() == 0 end,
	function () sysLights.strobesSwitch:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("LANDING LIGHTS","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.landLightGroup:getStatus() == 0 end,
	function () sysLights.landLightGroup:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("TAXI LIGHTS","ON",kcFlowItem.actorCPT,2,
	function () return sysLights.taxiSwitch:getStatus() > 0 end,
	function () sysLights.taxiSwitch:actuate(1) end))
afterLandingProc:addItem(kcProcedureItem:new("ENGINE START SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysEngines.engStarterGroup:getStatus() == 2 end,
	function () sysEngines.engStarterGroup:adjustValue(1,0,3) end))
afterLandingProc:addItem(kcProcedureItem:new("TRAFFIC SWITCH","OFF",kcFlowItem.actorFO,1,
	function () return sysEFIS.tfcPilot:getStatus() == 0 end,
	function () sysEFIS.tfcPilot:actuate(0) end))
afterLandingProc:addItem(kcProcedureItem:new("AUTOBRAKE","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.autobreak:getStatus() == 1 end,
	function () sysGeneral.autobreak:actuate(1) end))
afterLandingProc:addItem(kcProcedureItem:new("TRANSPONDER","STBY",kcFlowItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrSTBY end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrSTBY,0,5) end))

-- ============= SHUTDOWN PROCEDURE (BOTH) ==============
-- TAXI LIGHT SWITCH...........................OFF   (FO) 
-- PARKING BRAKE...............................SET  (CPT)

local shutdownProc = kcProcedure:new("SHUTDOWN PROCEDURE")
shutdownProc:addItem(kcProcedureItem:new("TAXI LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.taxiSwitch:getStatus() == 0 end,
	function () sysLights.taxiSwitch:actuate(0) end))
shutdownProc:addItem(kcProcedureItem:new("PARKING BRAKE","SET",kcFlowItem.actorCPT,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownProc:addItem(kcSimpleChecklistItem:new("Electrical power...Set"))
--   If APU power is needed: F/O
-- 	   Verify that the APU GENERATOR OFF BUS light is illuminated.
--     APU GENERATOR bus switches – ON
--     Verify that the SOURCE OFF lights are extinguished.
--   If external power is needed:
--     Verify that the GRD POWER AVAILABLE light is illuminated.
--     GRD POWER switch – ON
--     Verify that the SOURCE OFF lights are extinguished.
shutdownProc:addItem(kcProcedureItem:new("ENGINE START LEVERS","CUTOFF",kcFlowItem.actorCPT,1,
	function () return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end))
shutdownProc:addItem(kcProcedureItem:new("FASTEN BELTS SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysGeneral.seatBeltSwitch:getStatus() == 0 end,
	function () sysGeneral.seatBeltSwitch:adjustValue(0,0,2) end))
shutdownProc:addItem(kcProcedureItem:new("ANTI COLLISION LIGHT SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysLights.beaconSwitch:getStatus() == 0 end,
	function () sysLights.beaconSwitch:actuate(0) end))
shutdownProc:addItem(kcProcedureItem:new("FUEL PUMPS","APU 1 PUMP ON, REST OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
shutdownProc:addItem(kcProcedureItem:new("FUEL PUMPS","ALL OFF",kcFlowItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
shutdownProc:addItem(kcProcedureItem:new("CAB/UTIL POWER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
shutdownProc:addItem(kcProcedureItem:new("IFE/PASS SEAT POWER SWITCH","AS NEEDED",kcFlowItem.actorCPT,1))
shutdownProc:addItem(kcProcedureItem:new("WING ANTI-ICE SWITCH","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.wingAntiIce:getStatus() == 0 end,
	function () sysAice.wingAntiIce:actuate(0) end))
shutdownProc:addItem(kcProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysAice.engAntiIceGroup:getStatus() == 0 end,
	function () sysAice.engAntiIceGroup:actuate(0) end))
-- Hydraulic panel....Set F/O
shutdownProc:addItem(kcProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysHydraulic.engHydPumpGroup:getStatus() == 2 end,
	function () sysHydraulic.engHydPumpGroup:actuate(1) end))
shutdownProc:addItem(kcProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysHydraulic.elecHydPumpGroup:getStatus() == 0 end,
	function () sysHydraulic.elecHydPumpGroup:actuate(modeOff) end))
shutdownProc:addItem(kcProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.recircFanLeft:getStatus() == modeOn and sysAir.recircFanRight:getStatus() == modeOn end,
	function () sysAir.recircFanLeft:actuate(modeOn) sysAir.recircFanRight:actuate(modeOn) end))
shutdownProc:addItem(kcProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO",kcFlowItem.actorFO,2,
	function () return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,
	function () sysAir.packLeftSwitch:setValue(1) sysAir.packRightSwitch:setValue(1) end))
shutdownProc:addItem(kcProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",kcFlowItem.actorFO,2,
	function () return sysAir.isoValveSwitch:getStatus() == 1 end,
	function () sysAir.trimAirSwitch:actuate(modeOn) end))
shutdownProc:addItem(kcProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",kcFlowItem.actorFO,2,
	function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,
	function () sysAir.bleedEng1Switch:actuate(1) sysAir.bleedEng2Switch:actuate(1) end))
shutdownProc:addItem(kcProcedureItem:new("APU BLEED AIR SWITCH","ON",kcFlowItem.actorFO,2,
	function () return sysAir.apuBleedSwitch:getStatus() == modeOn end,
	function () sysAir.apuBleedSwitch:actuate(modeOn) end))
-- Exterior lights switches....As needed F/O
shutdownProc:addItem(kcProcedureItem:new("FLIGHT DIRECTOR SWITCHES","OFF",kcFlowItem.actorFO,2,
	function () return sysMCP.fdirGroup:getStatus() == 0 end,
	function () sysMCP.fdirGroup:actuate(0) end))
shutdownProc:addItem(kcChecklistItem:new("TRANSPONDER","STBY",kcChecklistItem.actorFO,2,
	function () return sysRadios.xpdrSwitch:getStatus() == sysRadios.xpdrSTBY end,
	function () sysRadios.xpdrSwitch:adjustValue(sysRadios.xpdrSTBY,0,5) end))
-- shutdownProc:addItem(kcSimpleChecklistItem:new("Next SHUTDOWN CHECKLIST"))
-- Reset MCP
-- [15] = {["activity"] = "DOORS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
-- [16] = {["activity"] = "RESET ELAPSED TIME", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
-- After the wheel chocks are in place: Parking brake – Release C or F/O
-- APU switch....As needed F/O
-- Call “SHUTDOWN CHECKLIST.

 -- ============== SHUTDOWN CHECKLIST (F/O) ==============
 -- FUEL PUMPS..................................OFF  (F/O)
 -- PROBE HEAT.............................AUTO/OFF  (F/O)
 -- HYDRAULIC PANEL.............................SET  (F/O)
 -- FLAPS........................................UP  (CPT)
 -- PARKING BRAKE.......................AS REQUIRED  (CPT)
 -- ENGINE START LEVERS......................CUTOFF  (CPT)
 -- WEATHER RADAR...............................OFF (BOTH)
 -- ======================================================

local shutdownChkl = kcChecklist:new("SHUTDOWN CHECKLIST")
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","ONE PUMP ON FOR APU, REST OFF",kcChecklistItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOff end,nil,
	function () return not activePrefSet:get("aircraft:powerup_apu") end))
shutdownChkl:addItem(kcChecklistItem:new("FUEL PUMPS","OFF",kcChecklistItem.actorFO,2,
	function () return sysFuel.allFuelPumpsOff:getStatus() == modeOn end,nil,
	function () return activePrefSet:get("aircraft:powerup_apu") end))
shutdownChkl:addItem(kcChecklistItem:new("PROBE HEAT","AUTO/OFF",kcChecklistItem.actorFO,2,
	function () return sysAice.probeHeatGroup:getStatus() < 3 end,
	function () sysAice.probeHeatGroup:actuate(0) end))
shutdownChkl:addItem(kcChecklistItem:new("HYDRAULIC PANEL","SET",kcChecklistItem.actorFO,2))
shutdownChkl:addItem(kcChecklistItem:new("FLAPS","UP",kcChecklistItem.actorCPT,2,
	function () return sysControls.flapsSwitch:getStatus() == 0 end,
	function () set("laminar/B738/flt_ctrls/flap_lever",0) end)) 
shutdownChkl:addItem(kcChecklistItem:new("PARKING BRAKE","ON",kcChecklistItem.actorCPT,2,
	function () return sysGeneral.parkBrakeSwitch:getStatus() == modeOn end,
	function () sysGeneral.parkBrakeSwitch:actuate(modeOn) end))
shutdownChkl:addItem(kcChecklistItem:new("ENGINE START LEVERS","CUTOFF",kcChecklistItem.actorCPT,2,
	function () return sysEngines.startLeverGroup:getStatus() == 0 end,
	function () sysEngines.startLeverGroup:actuate(cmdDown) end))
shutdownChkl:addItem(kcChecklistItem:new("WEATHER RADAR","OFF",kcChecklistItem.actorBOTH,2,
	function () return sysEFIS.wxrPilot:getStatus() == 0 end,
	function () sysEFIS.wxrPilot:actuate(0) end))

-- ============ secure =============
local secureProc = kcProcedure:new("SECURE PROCEDURE")

-- IRS mode selectors....OFF F/O
-- EMERGENCY EXIT LIGHTS switch....OFF F/O
-- WINDOW HEAT switches....OFF F/O
-- Air conditioning PACK switches....OFF F/O


-- =============== SECURE CHECKLIST (F/O) ===============
-- IRSs........................................OFF  (F/O)
-- EMERGENCY EXIT LIGHTS.......................OFF  (F/O)
-- WINDOW HEAT.................................OFF  (F/O)
-- PACKS.......................................OFF  (F/O)
-- ======================================================

local secureChkl = kcChecklist:new("SECURE CHECKLIST")
secureChkl:addItem(kcChecklistItem:new("#exchange|IRS MODE SELECTORS|SECURE CHECKLIST. I R S MODE SELECTORS","OFF",kcChecklistItem.actorFO,1,
	function () return sysGeneral.irsUnitGroup:getStatus() == modeOff end,
	function () sysGeneral.irsUnitGroup:setValue(sysGeneral.irsUnitOFF) end))
secureChkl:addItem(kcChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",kcChecklistItem.actorFO,2,
	function () return sysGeneral.emerExitLightsCover:getStatus() == modeOff  end,
	function () sysGeneral.emerExitLightsCover:actuate(modeOff) end))
secureChkl:addItem(kcChecklistItem:new("WINDOW HEAT","OFF",kcChecklistItem.actorFO,2,
	function () return sysAice.windowHeatGroup:getStatus() == 0 end,
	function () sysAice.windowHeatGroup:actuate(0) end))
secureChkl:addItem(kcChecklistItem:new("PACKS","OFF",kcChecklistItem.actorFO,2,
	function () return sysAir.packSwitchGroup:getStatus() == 0 end,
	function () sysAir.packSwitchGroup:setValue(0) end))

-- ============ Cold & Dark =============
local coldAndDarkProc = kcProcedure:new("SET AIRCRAFT TO COLD & DARK")

-- coldAndDarkProc:addItem(kcProcedureItem:new("XPDR","SET 2000","F/O",1,

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
activeSOP:addProcedure(cduPreflightProc)
activeSOP:addProcedure(preflightFOProc)
activeSOP:addProcedure(preflightFO2Proc)
activeSOP:addProcedure(preflightFO3Proc)
activeSOP:addProcedure(preflightCPTProc)
activeSOP:addChecklist(preflightChkl)
activeSOP:addProcedure(beforeStartProc)
activeSOP:addChecklist(beforeStartChkl)
activeSOP:addProcedure(pushstartProc)
activeSOP:addProcedure(beforeTaxiProc)
activeSOP:addChecklist(beforeTaxiChkl)
activeSOP:addChecklist(beforeTakeoffChkl)
activeSOP:addProcedure(runwayEntryProc)
activeSOP:addProcedure(takeoffClimbProc)
activeSOP:addChecklist(afterTakeoffChkl)
activeSOP:addProcedure(descentProc)
activeSOP:addChecklist(descentChkl)
activeSOP:addChecklist(approachChkl)
activeSOP:addProcedure(landingProc)
activeSOP:addChecklist(landingChkl)
activeSOP:addProcedure(afterLandingProc)
activeSOP:addProcedure(shutdownProc)
activeSOP:addChecklist(shutdownChkl)
activeSOP:addProcedure(secureProc)
activeSOP:addChecklist(secureChkl)

function getActiveSOP()
	return activeSOP
end

return SOP_B738