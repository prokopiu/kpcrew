require "kpcrew.genutils"

local SOP_B738 = {
}

-- SOP related imports
SOP = require "kpcrew.sops.SOP"

Checklist = require "kpcrew.checklists.Checklist"
ChecklistItem = require "kpcrew.checklists.ChecklistItem"
SimpleChecklistItem = require "kpcrew.checklists.SimpleChecklistItem"
IndirectChecklistItem = require "kpcrew.checklists.IndirectChecklistItem"

Procedure = require "kpcrew.procedures.Procedure"
ProcedureItem = require "kpcrew.procedures.ProcedureItem"
SimpleProcedureItem = require "kpcrew.procedures.SimpleProcedureItem"
IndirectProcedureItem = require "kpcrew.procedures.IndirectProcedureItem"

PreferenceSet = require "kpcrew.preferences.PreferenceSet"

local acf_icao = "B738"

-- Systems related imports
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
sysEFIS = require("kpcrew.systems." .. acf_icao .. ".sysEFIS")	


-- Set up SOP =========================================================================

activeSOP = SOP:new("Zibo Mod SOP")

-- ======= Checklist definitions =======

-- ======= Preflight checklist =======

local preflightChkl = Checklist:new("PREFLIGHT CHECKLIST (PM)")

preflightChkl:addItem(IndirectChecklistItem:new("OXYGEN","Tested, 100%",ChecklistItem.actorALL,1,function (self) return get("laminar/B738/push_button/oxy_test_cpt_pos") == 1 end,nil))
preflightChkl:addItem(ChecklistItem:new("NAVIGATION & DISPLAY SWITCHES","NORMAL,AUTO",ChecklistItem.actorPF,1,function (self) return sysMCP.vhfNavSwitch:getStatus() == 0 and sysMCP.irsNavSwitch:getStatus() == 0 and sysMCP.fmcNavSwitch:getStatus() == 0 and sysMCP.displaySourceSwitch:getStatus() == 0 and sysMCP.displayControlSwitch:getStatus() == 0 end,nil ))
preflightChkl:addItem(ChecklistItem:new("WINDOW HEAT","ON",ChecklistItem.actorPF,1,function (self) return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end,nil ))
preflightChkl:addItem(ChecklistItem:new("PRESSURIZATION MODE SELECTOR","AUTO",ChecklistItem.actorPF,1,function (self) return sysAir.pressModeSelector:getStatus() == 0 end,nil ))
preflightChkl:addItem(ChecklistItem:new("FLIGHT INSTRUMENTS","Heading___,Altimeter____",ChecklistItem.actorBOTH,1,nil,function (self) return string.format("HEADING %i, ALTIMETER %i",math.floor(get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot")),math.floor(get("laminar/B738/autopilot/altitude"))) end ))
preflightChkl:addItem(ChecklistItem:new("PARKING BRAKE","SET",ChecklistItem.actorPF,1,function (self) return sysGeneral.parkBrakeSwitch:getStatus() == 1 end,nil ))
preflightChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",ChecklistItem.actorPF,1,function (self) return sysEngines.startLever1:getStatus() == 0 and sysEngines.startLever2:getStatus() == 0 end,nil ))
preflightChkl:addItem(ChecklistItem:new("GEAR PINS","REMOVED",ChecklistItem.actorPF,1,nil,nil))

-- ======= Before Start Checklist

local beforeStartChkl = Checklist:new("BEFORE START CHECKLIST (F/O)")
beforeStartChkl:addItem(ChecklistItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",ChecklistItem.actorCPT,function (self) return sysGeneral.cockpitDoor:getStatus() == 0 end ))
beforeStartChkl:addItem(ChecklistItem:new("FUEL","___ LBS/KGS, PUMPS ON",ChecklistItem.actorCPT,nil ))
beforeStartChkl:addItem(ChecklistItem:new("PASSENGER SIGNS","SET",ChecklistItem.actorCPT,function (self) return sysGeneral.seatBeltSwitch:getStatus() > 0 and sysGeneral.noSmokingSwitch:getStatus() > 0 end ))
beforeStartChkl:addItem(ChecklistItem:new("WINDOWS","LOCKED",ChecklistItem.actorBOTH,nil))
beforeStartChkl:addItem(ChecklistItem:new("MCP","V2___, HDG___, ALT___",ChecklistItem.actorCPT,nil))
beforeStartChkl:addItem(ChecklistItem:new("TAKEOFF SPEEDS","V1___, VR___, V2___",ChecklistItem.actorBOTH,nil))
beforeStartChkl:addItem(ChecklistItem:new("CDU PREFLIGHT","COMPLETED",ChecklistItem.actorCPT,nil))
beforeStartChkl:addItem(ChecklistItem:new("RUDDER & AILERON TRIM","FREE AND 0",ChecklistItem.actorCPT,function (self) return sysControls.rudderTrimSwitch:getStatus() == 0 and sysControls.aileronTrimSwitch:getStatus() == 0 end ))
beforeStartChkl:addItem(ChecklistItem:new("TAXI AND TAKEOFF BRIEFING","Completed",ChecklistItem.actorCPT,nil))
beforeStartChkl:addItem(ChecklistItem:new("ANTI COLLISION LIGHT","ON",ChecklistItem.actorCPT,function (self) return sysLights.beaconSwitch:getStatus() == 1 end ))

-- ======= Before Taxi checklist =======

local beforeTaxiChkl = Checklist:new("BEFORE TAXI CHECKLIST (F/O)")
beforeTaxiChkl:addItem(ChecklistItem:new("GENERATORS","ON",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("PROBE HEAT","ON",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("ANTI-ICE","AS REQUIRED",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("ISOLATION VALVE","AUTO",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("RECALL","CHECKED",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("AUTOBRAKE","RTO",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","IDLE DETENT",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("FLIGHT CONTROLS","CHECKED",ChecklistItem.actorCPT,nil))
beforeTaxiChkl:addItem(ChecklistItem:new("GROUND EQUIPMENT","CLEAR",ChecklistItem.actorBOTH,nil))

-- ======= Before Takeoff checklist =======

local beforeTakeoffChkl = Checklist:new("BEFORE TAKEOFF CHECKLIST (F/O)")
beforeTakeoffChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(ChecklistItem:new("FLAPS","Green light",ChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(ChecklistItem:new("STABILIZER TRIM","___ Units",ChecklistItem.actorCPT,nil))
beforeTakeoffChkl:addItem(ChecklistItem:new("CABIN","Secure",ChecklistItem.actorCPT,nil))

-- ======= After Takeoff checklist =======

local afterTakeoffChkl = Checklist:new("AFTER TAKEOFF CHECKLIST (PM)")
afterTakeoffChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(ChecklistItem:new("ENGINE BLEEDS","ON",ChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(ChecklistItem:new("PACKS","AUTO",ChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(ChecklistItem:new("LANDING GEAR","UP AND OFF",ChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(ChecklistItem:new("FLAPS","UP, NO LIGHTS",ChecklistItem.actorPM,nil))
afterTakeoffChkl:addItem(ChecklistItem:new("ALTIMETERS","SET",ChecklistItem.actorBOTH,nil))

-- ======= Descent checklist =======

local descentChkl = Checklist:new("DESCENT CHECKLIST (PM)")
descentChkl:addItem(ChecklistItem:new("TAKEOFF BRIEFING","REVIEWED",ChecklistItem.actorPM,nil))
descentChkl:addItem(ChecklistItem:new("PRESSURISATION","LAND ALT___",ChecklistItem.actorPM,nil))
descentChkl:addItem(ChecklistItem:new("RECALL","CHECKED",ChecklistItem.actorPM,nil))
descentChkl:addItem(ChecklistItem:new("AUTOBRAKE","___",ChecklistItem.actorPM,nil))
descentChkl:addItem(ChecklistItem:new("LANDING DATA","VREF___, MINIMUMS___",ChecklistItem.actorBOTH,nil))
descentChkl:addItem(ChecklistItem:new("APPROACH BRIEFING","COMPLETED",ChecklistItem.actorPM,nil))

-- ======= Approach checklist =======

local approachChkl = Checklist:new("APPROACH CHECKLIST (PM)")
approachChkl:addItem(ChecklistItem:new("ALTIMETERS","QNH ___",ChecklistItem.actorBOTH,nil))
approachChkl:addItem(ChecklistItem:new("NAV AIDS","SET",ChecklistItem.actorPM,nil))

-- ======= Landing checklist =======

local landingChkl = Checklist:new("LANDING CHECKLIST (PM)")
landingChkl:addItem(ChecklistItem:new("CABIN","SECURE",ChecklistItem.actorPF,nil))
landingChkl:addItem(ChecklistItem:new("ENGINE START SWITCHES","CONT",ChecklistItem.actorPF,nil))
landingChkl:addItem(ChecklistItem:new("SPEEDBRAKE","ARMED",ChecklistItem.actorPF,nil))
landingChkl:addItem(ChecklistItem:new("LANDING GEAR","DOWN",ChecklistItem.actorPF,nil))
landingChkl:addItem(ChecklistItem:new("FLAPS","___, GREEN LIGHT",ChecklistItem.actorPF,nil))

-- ======= Shutdown checklist =======

local shutdownChkl = Checklist:new("SHUTDOWN CHECKLIST (F/O)")
shutdownChkl:addItem(ChecklistItem:new("HYDRAULIC PANEL","SET",ChecklistItem.actorCPT,nil))
shutdownChkl:addItem(ChecklistItem:new("PROBE HEAT","AUTO/OFF",ChecklistItem.actorCPT,nil))
shutdownChkl:addItem(ChecklistItem:new("FUEL PUMPS","OFF",ChecklistItem.actorCPT,nil))
shutdownChkl:addItem(ChecklistItem:new("FLAPS","UP",ChecklistItem.actorCPT,nil))
shutdownChkl:addItem(ChecklistItem:new("ENGINE START LEVERS","CUTOFF",ChecklistItem.actorCPT,nil))
shutdownChkl:addItem(ChecklistItem:new("WEATHER RADAR","OFF",ChecklistItem.actorBOTH,nil))
shutdownChkl:addItem(ChecklistItem:new("PARKING BRAKE","___",ChecklistItem.actorCPT,nil))


-- ======= Secure checklist =======

local secureChkl = Checklist:new("SECURE CHECKLIST (F/O)")
secureChkl:addItem(ChecklistItem:new("EFBs (if installed)","SHUT DOWN",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("IRSs","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("EMERGENCY EXIT LIGHTS","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("WINDOW HEAT","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("PACKS","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(SimpleChecklistItem:new(	"If the aircraft is not handed over to succeeding flight"))
secureChkl:addItem(SimpleChecklistItem:new(	"crew or maintenance personnel:"))
secureChkl:addItem(ChecklistItem:new("  EFB switches (if installed)","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("  APU/GRD PWR","OFF",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("  GROUND SERVICE SWITCH","ON",ChecklistItem.actorCPT))
secureChkl:addItem(ChecklistItem:new("  BAT SWITCH","OFF",ChecklistItem.actorCPT))

-- ============ Procedures =============

-- ============ Electrical Power Up Procedures =============

local electricalPowerUpProc = Procedure:new("ELECTRICAL POWER UP (F/O)")
electricalPowerUpProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/electric/battery_pos") == 1 end,nil,nil))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,
function (self) return sysElectric.stbyPowerCover:getStatus() == 0 end,nil,nil))
electricalPowerUpProc:addItem(ProcedureItem:new("ALTERNATE FLAPS MASTER SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,
function (self) return sysControls.altFlapsCover:getStatus() == 0 end,nil,nil))
electricalPowerUpProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",ChecklistItem.actorFO,1,function (self) return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end,nil,nil))
electricalPowerUpProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end,nil,nil))
electricalPowerUpProc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DOWN",ChecklistItem.actorFO,1,
function (self) return sysGeneral.GearSwitch:getStatus() == 1 end,nil,nil))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Verify green landing gear lights are illuminated."))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Verify red landing gear lights are extinguished."))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("TAKEOFF CONFIG WARNING","TEST",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/system/takeoff_config_warn") > 0 end,nil,nil))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Move thrust levers full forward and back to idle."))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("If external power is needed:",function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("  Use Zibo EFB to turn Ground Power on.",function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GRD POWER AVAILABLE LIGHT","ILLUMINATED",ChecklistItem.actorFO,1,function (self) return sysElectric.gpuAvailAnc:getStatus() == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(ProcedureItem:new("  GROUND POWER SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysElectric.gpuSwitch:getStatus() == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    Verify that SOURCE OFF, TRANSFER BUS OFF, ",function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    and STANDBY PWR OFF lights are extinguished",function () return get_kpcrew_config("config_apuinit") == true end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("If APU power is needed:",function () return get_kpcrew_config("config_apuinit") == false end))
-- electricalPowerUpProc:addItem(ProcedureItem:new("  OVHT DET SWITCHES","NORMAL",ChecklistItem.actorFO,1,function (self) return true end,nil,nil))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  OVHT FIRE TEST SWITCH","HOLD RIGHT",ChecklistItem.actorFO,1,function (self) return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  MASTER FIRE WARN LIGHT","PUSH",ChecklistItem.actorFO,1,function (self) return sysGeneral.fireWarningAnc:getStatus() > 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(IndirectProcedureItem:new("  ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  APU","START",ChecklistItem.actorFO,1,function (self) return sysElectric.apuRunningAnc:getStatus() == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("    Hold APU switch in START position for 3-4 seconds.",function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  APU GEN OFF BUS LIGHT","ILLUMINATED",ChecklistItem.actorFO,1,function (self) return sysElectric.apuGenBusOff:getStatus() == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("  APU GENERATOR BUS SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
electricalPowerUpProc:addItem(ProcedureItem:new("STANDBY POWER","ON",ChecklistItem.actorFO,1,
function (state) return get("laminar/B738/electric/standby_bat_pos") > 0 end,nil,nil))
-- electricalPowerUpProc:addItem(ProcedureItem:new("WHEEL WELL FIRE WARNING SYSTEM","TEST",ChecklistItem.actorFO,1,nil,nil,nil))
electricalPowerUpProc:addItem(SimpleProcedureItem:new("Next: Preliminary Preflight Procedure"))

-- ============ Preliminary Preflight Procedures =============

local prelPreflightProc = Procedure:new("PREL PREFLIGHT PROCEDURE (F/O)")

prelPreflightProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS (P6 PANEL)","CHECK",ChecklistItem.actorFO,1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("CIRCUIT BREAKERS (CONTROL STAND,P18 PANEL)","CHECK",ChecklistItem.actorFO,1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHT","ARM/ON GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysGeneral.emerExitLightsCover:getStatus() == 0  end,nil,nil))
prelPreflightProc:addItem(IndirectProcedureItem:new("ATTENDENCE BUTTON","PRESS",ChecklistItem.actorFO,1,function (self) return sysGeneral.attendanceButton:getStatus() > 0
 end,nil,nil))
prelPreflightProc:addItem(SimpleProcedureItem:new("Electrical Power Up supplementary procedure is complete."))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","OFF",ChecklistItem.actorFO,1,function (self) return sysGeneral.irsUnit1Switch:getStatus() == 0 and sysGeneral.irsUnit2Switch:getStatus() == 0 end,nil,nil))
prelPreflightProc:addItem(IndirectProcedureItem:new("IRS MODE SELECTORS","THEN NAV",ChecklistItem.actorFO,1,function (self) return sysGeneral.irsUnit1Switch:getStatus() == 2 and sysGeneral.irsUnit2Switch:getStatus() == 2 end,nil,nil))
prelPreflightProc:addItem(SimpleProcedureItem:new("  Verify ON DC lights illuminate then extinguish"))
prelPreflightProc:addItem(SimpleProcedureItem:new("  Verify ALIGN lights are illuminated"))
prelPreflightProc:addItem(ProcedureItem:new("VOICE RECORDER SWITCH","AUTO",ChecklistItem.actorFO,1,function (self) return  sysGeneral.voiceRecSwitch:getStatus() == 0 end,nil,nil))
prelPreflightProc:addItem(IndirectProcedureItem:new("MACH OVERSPEED TEST","PERFORM",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/push_button/mach_warn1_pos") == 1 or get("laminar/B738/push_button/mach_warn2_pos") == 1 end,nil,nil))
prelPreflightProc:addItem(IndirectProcedureItem:new("STALL WARNING TEST","PERFORM",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/push_button/stall_test1") == 1 or get("laminar/B738/push_button/stall_test2") == 1 end,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("XPDR","SET 2000",ChecklistItem.actorFO,1,function (self) return get("sim/cockpit/radios/transponder_code") == 2000 end,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("COCKPIT LIGHTS","SET AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("WING & WHEEL WELL LIGHTS","AS REQUIRED","F/O",1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF","F/O",1,function (self) return get("laminar/B738/fuel/fuel_tank_pos_lft1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_lft2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr2") == 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == true end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMPS","ALL OFF","F/O",1,function (self) return get("laminar/B738/fuel/fuel_tank_pos_lft2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr2") == 0 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL PUMP FOR APU","AS REQUIRED","F/O",1,function () return get("laminar/B738/fuel/fuel_tank_pos_lft1") == 1 end,nil,nil,function () return get_kpcrew_config("config_apuinit") == false end))
prelPreflightProc:addItem(ProcedureItem:new("FUEL CROSS FEED","OFF","F/O",1,function (self) return get("laminar/B738/knobs/cross_feed_pos") == 0 end,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("POSITION LIGHTS","ON","F/O",1,function (self) return get("laminar/B738/toggle_switch/position_light_pos") ~= 0 end,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("MCP","INITIALIZE","F/O",1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("PARKING BRAKE","SET","F/O",1,nil,nil,nil))
prelPreflightProc:addItem(ProcedureItem:new("IFE & GALLEY POWER","ON","F/O",1,nil,nil,nil))

-- ============ CDU Preflight =============
local cduPreflightProc = Procedure:new("CDU PREFLIGHT PROCEDURE (CPT)")
cduPreflightProc:addItem(ProcedureItem:new("INITIAL DATA","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(SimpleProcedureItem:new("  IDENT page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify Model"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify ENG RATING"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify navigation database ACTIVE date"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  POS INIT page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify time"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Set present position"))
cduPreflightProc:addItem(ProcedureItem:new("NAVIGATION DATA","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(SimpleProcedureItem:new("  ROUTE page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Enter ORIGIN, route, flight number, activate and execute"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  DEPARTURES page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select runway and departure routing"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Execute"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  LEGS page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify or enter correct RNP for departure"))
cduPreflightProc:addItem(ProcedureItem:new("PERFORMANCE DATA","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
cduPreflightProc:addItem(SimpleProcedureItem:new("  PERF INIT page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Enter ZFW or let it be calculated"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify fuel on CDU"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify gross weight and cruise CG"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  Thrust mode display:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify that TO and dashes show"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  N1 LIMIT page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select assumed temp and/or fixed t/o rating"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select full or derated climb thrust"))
cduPreflightProc:addItem(SimpleProcedureItem:new("  TAKEOFF REF page:"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Enter CG"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Verify trim value"))
cduPreflightProc:addItem(SimpleProcedureItem:new("    Select or enter takeoff V speeds"))
cduPreflightProc:addItem(ProcedureItem:new("PREFLIGHT COMPLETE?","VERIFY",ChecklistItem.actorCPT,1,nil,nil,nil))

-- ============ External Walkaround =============
local exteriorInspectionProc = Procedure:new("EXTERIOR INSPECTION")
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Forward Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Nose Wheel Well"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Exterior light","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Gear strut and doors","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Nose wheel steering assembly","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Forward Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Wing Root, Pack, and Lower Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Exterior lights","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Leading edge flaps","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Number 2 Engine"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Fan blades, probes, and spinner","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Thrust reverser","Stowed"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Exhaust area and tailcone","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Wing and Leading Edge"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Leading edge flaps and slats","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Wing Surfaces","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Wing Tip and Trailing Edge"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Position and strobe lights","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Aileron and trailing edge flaps","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Main Gear"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Tires, brakes and wheels","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Gear strut, actuators, and doors","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Main Wheel Well"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Wheel well","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Right Aft Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Outflow valve","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  APU air inlet","Open"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Tail"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Vertical stabilizer and rudder","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Horizontal stabilizer and elevator","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Strobe light","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Aft Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Main Gear"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Tires, brakes and wheels","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Gear strut, actuators, and doors","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Main Wheel Well"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Wheel well","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Wing Tip and Trailing Edge"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Aileron and trailing edge flaps","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Position and strobe lights","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Wing and Leading Edge"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Wing Surfaces","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Leading edge flaps and slats","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Number 1 Engine"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Exhaust area and tailcone","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Thrust reverser","Stowed"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Fan blades, probes, and spinner","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(SimpleProcedureItem:new("Left Wing Root, Pack, and Lower Fuselage"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Leading edge flaps","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Probes, sensors, ports, vents, drains","Check"))
exteriorInspectionProc:addItem(ProcedureItem:new("  Exterior lights","Check"))


-- ============ Preflight Procedure =============
local preflightFOProc = Procedure:new("PREFLIGHT PROCEDURE (F/O)")
preflightFOProc:addItem(SimpleProcedureItem:new("Flight control panel"))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT CONTROL SWITCHES","GUARDS CLOSED",ChecklistItem.actorFO,1,function (self) return sysControls.fltCtrlACover:getStatus() == 0 and sysControls.fltCtrlBCover:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("FLIGHT SPOILER SWITCHES","GUARDS CLOSED",ChecklistItem.actorFO,1,function (self) return sysControls.spoilerACover:getStatus() == 0 and sysControls.spoilerBCover:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("YAW DAMPER SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysControls.yawDamper:getStatus() == 1 end,nil,nil))

preflightFOProc:addItem(SimpleProcedureItem:new("NAVIGATION & DISPLAYS panel"))
preflightFOProc:addItem(ProcedureItem:new("VHF NAV TRANSFER SWITCH","NORMAL",ChecklistItem.actorFO,1,function(self) return sysMCP.vhfNavSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("IRS TRANSFER SWITCH","NORMAL",ChecklistItem.actorFO,1,function(self) return sysMCP.irsNavSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("FMC TRANSFER SWITCH","NORMAL",ChecklistItem.actorFO,1,function(self) return sysMCP.fmcNavSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("SOURCE SELECTOR","AUTO",ChecklistItem.actorFO,1,function(self) return sysMCP.displaySourceSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("CONTROL PANEL SELECT SWITCH","NORMAL",ChecklistItem.actorFO,1,function(self) return sysMCP.displayControlSwitch:getStatus() == 0 end,nil,nil))

preflightFOProc:addItem(SimpleProcedureItem:new("Fuel panel"))
preflightFOProc:addItem(ProcedureItem:new("CROSSFEED SELECTOR","CLOSED",ChecklistItem.actorFO,1,function (self) return sysFuel.crossFeed:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("FUEL PUMP SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysFuel.fuelPumpLeftAft:getStatus() == 0 and sysFuel.fuelPumpLeftFwd:getStatus() == 0 and sysFuel.fuelPumpRightAft:getStatus() == 0 and sysFuel.fuelPumpRightFwd:getStatus() == 0 and sysFuel.fuelPumpCtrLeft:getStatus() == 0 and sysFuel.fuelPumpCtrRight:getStatus() == 0 end,nil,nil))

preflightFOProc:addItem(SimpleProcedureItem:new("Electrical panel"))
preflightFOProc:addItem(ProcedureItem:new("BATTERY SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysElectric.batterySwitch:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("CAB/UTIL POWER SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysElectric.cabUtilPwr:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("IFE/PASS SEAT POWER SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysElectric.ifePwr:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("STANDBY POWER SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysElectric.stbyPowerCover:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("GEN DRIVE DISCONNECT SWITCHES","GUARDS CLOSED",ChecklistItem.actorFO,1,function (self) return sysElectric.genDrive1Cover:getStatus() == 0 and sysElectric.genDrive2Cover:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("BUS TRANSFER SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysElectric.busTransCover:getStatus() == 0 end,nil,nil))

preflightFOProc:addItem(SimpleProcedureItem:new("Overheat and fire protection panel"))
-- preflightFOProc:addItem(ProcedureItem:new("OVHT DET SWITCHES","NORMAL",ChecklistItem.actorFO,1,function (self) return true end,nil,nil))
preflightFOProc:addItem(IndirectProcedureItem:new("OVHT FIRE TEST SWITCH","HOLD RIGHT",ChecklistItem.actorFO,1,function (self) return  sysEngines.ovhtFireTestSwitch:getStatus() > 0 end,nil,nil,function () return true end))
preflightFOProc:addItem(IndirectProcedureItem:new("MASTER FIRE WARN LIGHT","PUSH",ChecklistItem.actorFO,1,function (self) return sysGeneral.fireWarningAnc:getStatus() > 0 end,nil,nil))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 1 TO LEFT",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/toggle_switch/extinguisher_circuit_test") < 0 end,nil,nil))
preflightFOProc:addItem(IndirectProcedureItem:new("ENGINES EXT TEST SWITCH","TEST 2 TO RIGHT",ChecklistItem.actorFO,1,function (self) return get("laminar/B738/toggle_switch/extinguisher_circuit_test") > 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("APU SWITCH","START",ChecklistItem.actorFO,1,function (self) return sysElectric.apuRunningAnc:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("APU GEN OFF BUS LIGHT","ILLUMINATED",ChecklistItem.actorFO,1,function (self) return sysElectric.apuGenBusOff:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("APU GENERATOR BUS SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysElectric.apuGenBus1:getStatus() == 1 and sysElectric.apuGenBus2:getStatus() == 1 end,nil,nil))

preflightFOProc:addItem(ProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",ChecklistItem.actorFO,1,function (self) return sysGeneral.equipCoolExhaust:getStatus() == 0 and sysGeneral.equipCoolSupply:getStatus() == 0 end ,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysGeneral.emerExitLightsCover:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("NO SMOKING SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysGeneral.noSmokingSwitch:getStatus() > 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysGeneral.seatBeltSwitch:getStatus() > 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",ChecklistItem.actorFO,1,function (self) return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("WINDOW HEAT SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end,nil ))
preflightFOProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.probeHeatASwitch:getStatus() == 0 and sysAice.probeHeatBSwitch:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.wingAntiIce:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.engAntiIce1:getStatus() == 0 and sysAice.engAntiIce2:getStatus() == 0 end,nil,nil))
preflightFOProc:addItem(SimpleProcedureItem:new("Hydraulic panel"))
preflightFOProc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.engHydPump2:getStatus() == 1 end,nil,nil))
preflightFOProc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end,nil,nil))



local preflightFO2Proc = Procedure:new("PREFLIGHT PROCEDURE PAGE 2 (F/O)")
preflightFO2Proc:addItem(ProcedureItem:new("EQUIPMENT COOLING SWITCHES","NORM",ChecklistItem.actorFO,1,function (self) return sysGeneral.equipCoolExhaust:getStatus() == 0 and sysGeneral.equipCoolSupply:getStatus() == 0 end ,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("EMERGENCY EXIT LIGHTS SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function (self) return sysGeneral.emerExitLightsCover:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("NO SMOKING SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysGeneral.noSmokingSwitch:getStatus() > 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("FASTEN BELTS SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysGeneral.seatBeltSwitch:getStatus() > 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("WINDSHIELD WIPER SELECTORS","PARK",ChecklistItem.actorFO,1,function (self) return sysGeneral.wiperLeftSwitch:getStatus() == 0 and sysGeneral.wiperRightSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("WINDOW HEAT SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysAice.windowHeatLeftSide:getStatus() == 1 and sysAice.windowHeatLeftFwd:getStatus() == 1 and sysAice.windowHeatRightSide:getStatus() == 1 and sysAice.windowHeatRightFwd:getStatus() == 1 end,nil ))
preflightFO2Proc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.probeHeatASwitch:getStatus() == 0 and sysAice.probeHeatBSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("WING ANTI-ICE SWITCH","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.wingAntiIce:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ENGINE ANTI-ICE SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysAice.engAntiIce1:getStatus() == 0 and sysAice.engAntiIce2:getStatus() == 0 end,nil,nil))

preflightFO2Proc:addItem(SimpleProcedureItem:new("Hydraulic panel"))
preflightFO2Proc:addItem(ProcedureItem:new("ENGINE HYDRAULIC PUMPS SWITCHES","ON",ChecklistItem.actorFO,1,function (self) return sysHydraulic.engHydPump1:getStatus() == 1 and sysHydraulic.engHydPump2:getStatus() == 1 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ELECTRIC HYDRAULIC PUMPS SWITCHES","OFF",ChecklistItem.actorFO,1,function (self) return sysHydraulic.elecHydPump1:getStatus() == 0 and sysHydraulic.elecHydPump2:getStatus() == 0 end,nil,nil))

preflightFO2Proc:addItem(SimpleProcedureItem:new("Air conditioning panel"))
preflightFO2Proc:addItem(ProcedureItem:new("AIR TEMPERATURE SOURCE SELECTOR","AS NEEDED",ChecklistItem.actorFO,1,function (self) return sysAir.contCabTemp:getStatus() > 0 and sysAir.fwdCabTemp:getStatus() > 0 and sysAir.aftCabTemp:getStatus() > 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("TRIM AIR SWITCH","ON",ChecklistItem.actorFO,1,function (self) return sysAir.trimAirSwitch:getStatus() == 1 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("RECIRCULATION FAN SWITCHES","AUTO",ChecklistItem.actorFO,1,function (self) return sysAir.recircFanLeft:getStatus() == 1 and sysAir.recircFanRight:getStatus() == 1 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("AIR CONDITIONING PACK SWITCHES","AUTO OR HIGH",ChecklistItem.actorFO,1,function (self) return sysAir.packLeftSwitch:getStatus() > 0 and sysAir.packRightSwitch:getStatus() > 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","OPEN",ChecklistItem.actorFO,1,function (self) return sysAir.isoValveSwitch:getStatus() > 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ENGINE BLEED AIR SWITCHES","ON",ChecklistItem.actorFO,1,function () return sysAir.bleedEng1Switch:getStatus() == 1 and sysAir.bleedEng2Switch:getStatus() == 1 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","ON",ChecklistItem.actorFO,1,function () return sysAir.apuBleedSwitch:getStatus() == 1 end,nil,nil))

preflightFO2Proc:addItem(SimpleProcedureItem:new("Cabin pressurization panel"))
preflightFO2Proc:addItem(ProcedureItem:new("FLIGHT ALTITUDE INDICATOR","CRUISE ALTITUDE",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("LANDING ALTITUDE INDICATOR","DEST FIELD ELEVATION",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("PRESSURIZATION MODE SELECTOR","AUTO",ChecklistItem.actorFO,1,function () return sysAir.pressModeSelector:getStatus() == 0 end,nil,nil))

preflightFO2Proc:addItem(SimpleProcedureItem:new("Lighting panel"))
preflightFO2Proc:addItem(ProcedureItem:new("LANDING LIGHT SWITCHES","RETRACT AND OFF",ChecklistItem.actorFO,1,function () return sysLights.llRetLeftSwitch:getStatus() == 0 and sysLights.llRetRightSwitch:getStatus() == 0 and sysLights.llLeftSwitch:getStatus() == 0 and sysLights.llRightSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("RUNWAY TURNOFF LIGHT SWITCHES","OFF",ChecklistItem.actorFO,1,function () return sysLights.rwyLeftSwitch:getStatus() == 0 and sysLights.rwyRightSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("TAXI LIGHT SWITCH","OFF",ChecklistItem.actorFO,1,function () return sysLights.taxiSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("LOGO LIGHT SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("POSITION LIGHT SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ANTI-COLLISION LIGHT SWITCH","OFF",ChecklistItem.actorFO,1,function () return sysLights.beaconSwitch:getStatus() == 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("WING ILLUMINATION SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("WHEEL WELL LIGHT SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("IGNITION SELECT SWITCH","IGN L OR R",ChecklistItem.actorFO,1,function () return sysEngines.ignSelectSwitch:getStatus() ~= 0 end,nil,nil))
preflightFO2Proc:addItem(ProcedureItem:new("ENGINE START SWITCHES","OFF",ChecklistItem.actorFO,1,function () return sysEngines.engStart1Switch:getStatus() == 1 and sysEngines.engStart2Switch:getStatus() == 1 end,nil,nil))


local preflightFO3Proc = Procedure:new("PREFLIGHT PROCEDURE PART3 (F/O)")
preflightFO3Proc:addItem(SimpleProcedureItem:new("Mode control panel"))
preflightFO3Proc:addItem(ProcedureItem:new("COURSE(S)","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCHES","ON",ChecklistItem.actorFO,1,function () return sysMCP.fdirPilotSwitch:getStatus() == 1 and sysMCP.fdirCoPilotSwitch:getStatus() == 1 end,nil,nil))
preflightFO3Proc:addItem(SimpleProcedureItem:new("EFIS control panel"))
preflightFO3Proc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BARO",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("MINIMUMS SELECTOR","SET DH OR DA REFERENCE",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR SWITCH","OFF",ChecklistItem.actorFO,1,function () return sysMCP.fpvSwitch:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("METERS SWITCH","OFF",ChecklistItem.actorFO,1,function () return sysMCP.mtrsSwitch:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("CENTER SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("RANGE SELECTOR","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("OXYGEN","TEST AND SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("CLOCK","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",ChecklistItem.actorFO,1,function () return sysGeneral.displayUnitsFO:getStatus() == 0 and sysGeneral.displayUnitsCPT:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",ChecklistItem.actorFO,1,function () return sysGeneral.lowerDuFO:getStatus() == 0 and sysGeneral.lowerDuCPT:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(SimpleProcedureItem:new("GROUND PROXIMITY panel"))
preflightFO3Proc:addItem(ProcedureItem:new("FLAP INHIBIT SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function () return sysGeneral.flapInhibitCover:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("GEAR INHIBIT SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function () return sysGeneral.gearInhibitCover:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("TERRAIN INHIBIT SWITCH","GUARD CLOSED",ChecklistItem.actorFO,1,function () return sysGeneral.terrainInhibitCover:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(SimpleProcedureItem:new("Landing gear panel"))
preflightFO3Proc:addItem(ProcedureItem:new("LANDING GEAR LEVER","DN",ChecklistItem.actorFO,1,function () return sysGeneral.GearSwitch:getStatus() == 1 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("AUTO BRAKE SELECT SWITCH","RTO",ChecklistItem.actorFO,1,function () return sysGeneral.autobreak:getStatus() == 0 end,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("ANTISKID INOP LIGHT","VERIFY EXTINGUISHED",ChecklistItem.actorFO,1,function () return get("laminar/B738/annunciator/anti_skid_inop") == 0 end,nil,nil))
preflightFO3Proc:addItem(SimpleProcedureItem:new("Radio tuning panel"))
preflightFO3Proc:addItem(ProcedureItem:new("VHF COMMUNICATIONS RADIOS","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("VHF NAVIGATION RADIOS","SET FOR DEPARTURE",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("AUDIO CONTROL PANEL","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("ADF RADIOS","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("WEATHER RADAR PANEL","SET",ChecklistItem.actorFO,1,nil,nil,nil))
preflightFO3Proc:addItem(ProcedureItem:new("TRANSPONDER PANEL","SET",ChecklistItem.actorFO,1,nil,nil,nil))


local preflightCPTProc = Procedure:new("PREFLIGHT PROCEDURE (CAPT)")
preflightCPTProc:addItem(ProcedureItem:new("LIGHTS","TEST",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(SimpleProcedureItem:new("EFIS control panel"))
preflightCPTProc:addItem(ProcedureItem:new("MINIMUMS REFERENCE SELECTOR","RADIO OR BAROMINIMUMS SELECTOR",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("DECISION HEIGHT OR ALTITUDE REFERENCE","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("FLIGHT PATH VECTOR","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("METERS SWITCH","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC REFERENCE SELECTOR","IN OR HPA",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("BAROMETRIC SELECTOR","SET LOCAL ALTIMETER SETTING",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("VOR/ADF SWITCHES","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("MODE SELECTOR","MAP",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("CENTER SWITCH","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("RANGE SELECTOR","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("TRAFFIC SWITCH","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("WEATHER RADAR","OFF",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("MAP SWITCHES","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(SimpleProcedureItem:new("Mode control panel"))
preflightCPTProc:addItem(ProcedureItem:new("COURSE(S)","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("FLIGHT DIRECTOR SWITCH","ON",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("BANK ANGLE SELECTOR","AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("AUTOPILOT DISENGAGE BAR","UP",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("OXYGEN RESET/TEST SWITCH","PUSH AND HOLD",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("CLOCK","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("NOSE WHEEL STEERING SWITCH","GUARD CLOSED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(SimpleProcedureItem:new("Display select panel"))
preflightCPTProc:addItem(ProcedureItem:new("MAIN PANEL DISPLAY UNITS SELECTOR","NORM",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("LOWER DISPLAY UNIT SELECTOR","NORM",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("INTEGRATED STANDBY FLIGHT DISPLAY","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("SPEED BRAKE LEVER","DOWN DETENT",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("REVERSE THRUST LEVERS","DOWN",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("FORWARD THRUST LEVERS","CLOSED",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("FLAP LEVER","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(SimpleProcedureItem:new("  Set the flap lever to agree with the flap position."))
preflightCPTProc:addItem(ProcedureItem:new("PARKING BRAKE","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("ENGINE START LEVERS","CUTOFF",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("STABILIZER TRIM CUTOUT SWITCHES","NORMAL",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(ProcedureItem:new("RADIO TUNING PANEL","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
preflightCPTProc:addItem(SimpleProcedureItem:new("CALL PREFLIGHT CHECKLIST"))

-- ============ before start Procedure =============
local beforeStartProc = Procedure:new("BEFORE START PROCEDURE (BOTH)")
beforeStartProc:addItem(ProcedureItem:new("FLIGHT DECK DOOR","CLOSED AND LOCKED",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("CDU DISPLAY","SET",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("N1 BUGS","CHECK",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("IAS BUGS","SET",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("Set MCP"))
beforeStartProc:addItem(ProcedureItem:new("  AUTOTHROTTLE ARM SWITCH","ARM",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  IAS/MACH SELECTOR","SET V2",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  LNAV","ARM AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  VNAV","ARM AS NEEDED",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  INITIAL HEADING","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  INITIAL ALTITUDE","SET",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("TAXI AND TAKEOFF BRIEFINGS","COMPLETE",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("EXTERIOR DOORS","VERIFY CLOSED",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("START CLEARANCE","OBTAIN",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to pressurize the hydraulic systems."))
beforeStartProc:addItem(SimpleProcedureItem:new("  Obtain a clearance to start the engines."))
beforeStartProc:addItem(SimpleProcedureItem:new("Set Fuel panel"))
beforeStartProc:addItem(ProcedureItem:new("  LEFT AND RIGHT CENTER FUEL PUMPS SWITCHES","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("    If the center tank fuel quantity exceeds 1,000 pounds/460 kilograms"))
beforeStartProc:addItem(ProcedureItem:new("  AFT AND FORWARD FUEL PUMPS SWITCHES","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("Set Hydraulic panel"))
beforeStartProc:addItem(ProcedureItem:new("  ENGINE HYDRAULIC PUMP SWITCHES","OFF",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  ELECTRIC HYDRAULIC PUMP SWITCHES","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("ANTI COLLISION LIGHT SWITCH","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("Set Trim"))
beforeStartProc:addItem(ProcedureItem:new("  STABILIZER TRIM","___ UNITS",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  AILERON TRIM","0 UNITS",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(ProcedureItem:new("  RUDDER TRIM","0 UNITS",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeStartProc:addItem(SimpleProcedureItem:new("Call for Before Start Checklist"))

-- ============ Pushback Towing Procedure =============
local pushstartProc = Procedure:new("PUSHBACK & ENGINE START (BOTH)")

-- ============ Before Taxi =============
local beforeTaxiProc = Procedure:new("BEFORE TAXI PROCEDURE (F/O)")
beforeTaxiProc:addItem(ProcedureItem:new("GENERATOR 1 AND 2 SWITCHES","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("PROBE HEAT SWITCHES","ON",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("WING ANTI–ICE SWITCH","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE ANTI–ICE SWITCHES","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("PACK SWITCHES","AUTO",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("ISOLATION VALVE SWITCH","AUTO",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("APU BLEED AIR SWITCH","OFF",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("APU SWITCH","OFF",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START SWITCHES","CONT",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("ENGINE START LEVERS","IDLE DETENT",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeTaxiProc:addItem(SimpleProcedureItem:new("Verify that the ground equipment is clear."))
beforeTaxiProc:addItem(SimpleProcedureItem:new("Call 'FLAPS ___' as needed for takeoff."))
beforeTaxiProc:addItem(ProcedureItem:new("FLAP LEVER","SET TAKEOFF FLAPS",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("LE FLAPS EXT GREEN LIGHT","ILLUMINATED",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("FLIGHT CONTROLS","CHECK",ChecklistItem.actorCPT,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("TRANSPONDER","AS NEEDED",ChecklistItem.actorFO,1,nil,nil,nil))
beforeTaxiProc:addItem(ProcedureItem:new("Recall","CHECK",ChecklistItem.actorBOTH,1,nil,nil,nil))
beforeTaxiProc:addItem(SimpleProcedureItem:new("  Verify all annunciators illuminate and then extinguish."))
beforeTaxiProc:addItem(SimpleProcedureItem:new("Call BEFORE TAXI CHECKLIST"))

-- ============ Before Takeoff =============
local beforeTakeoffProc = Procedure:new("BEFORE TAKEOFF PROCEDURE (F/O)")

-- ============ Runway entry =============
local runwayEntryProc = Procedure:new("RUNWAY ENTRY PROCEDURE (F/O)")

-- ============ start and initial climb =============
local takeoffClimbProc = Procedure:new("TAKEOFF & INITIAL CLIMB")

-- ============ climb & cuise =============
local climbCruiseProc = Procedure:new("CLIMB & CRUISE")

-- ============ descent =============
local descentProc = Procedure:new("DESCENT PROCEDURE")

-- ============ approach =============
local approachProc = Procedure:new("APPROACH PROCEDURE")

-- ============ landing =============
local landingProc = Procedure:new("LANDING PROCEDURE")

-- ============ after landing =============
local afterLandingProc = Procedure:new("AFTER LANDING PROCEDURE")

-- ============ shutdown =============
local shutdownProc = Procedure:new("SHUTDOWN PROCEDURE")

-- ============ secure =============
local secureProc = Procedure:new("SECURE PROCEDURE")

-- ============ Cold & Dark =============

local coldAndDarkProc = Procedure:new("SET AIRCRAFT TO COLD & DARK")
-- coldAndDarkProc:addItem(ProcedureItem:new("XPDR","SET 2000","F/O",1,

-- ============  =============
-- add the checklists and procedures to the active sop
activeSOP:addProcedure(electricalPowerUpProc)
activeSOP:addProcedure(prelPreflightProc)
-- activeSOP:addProcedure(cduPreflightProc)
-- activeSOP:addProcedure(exteriorInspectionProc)
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
-- activeSOP:addProcedure(beforeTakeoffProc)
-- activeSOP:addChecklist(beforeTakeoffChkl)
-- activeSOP:addProcedure(runwayEntryProc)
-- activeSOP:addProcedure(takeoffClimbProc)
-- activeSOP:addChecklist(afterTakeoffChkl)
-- activeSOP:addProcedure(climbCruiseProc)
-- activeSOP:addProcedure(descentProc)
-- activeSOP:addChecklist(descentChkl)
-- activeSOP:addProcedure(approachProc)
-- activeSOP:addChecklist(approachChkl)
-- activeSOP:addProcedure(landingProc)
-- activeSOP:addChecklist(landingChkl)
-- activeSOP:addProcedure(afterLandingProc)
-- activeSOP:addProcedure(shutdownProc)
-- activeSOP:addChecklist(shutdownChkl)
-- activeSOP:addProcedure(secureProc)
-- activeSOP:addChecklist(secureChkl)

function getActiveSOP()
	return activeSOP
end

return SOP_B738