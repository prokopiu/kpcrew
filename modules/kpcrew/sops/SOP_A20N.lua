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

-- ============ Preliminary Cockpit Preparation ===========
-- All paper work on board and checked
-- M E L and Technical Logbook checked

-- ENG MASTERS ...... . ............... OFF
-- ENG MODE SEL. ... . . ... . ....... . ... NORM
-- • WEATHER RADAR ... . ..... ... ... ... . . OFF
-- UG lever . ......... .. . . . ........... DOWN
-- Both WIPER selectors ... ..... .. . ...... OFF
-- BAT . .......... . . . .. ........ CHECK/AUTO
-- EXT POWER .......... .... ..... .. .... ON
-- APU FIRE ....... ..... . .... . .. CHECKITEST
-- APU ... . . ......... . ........ ~ .. AS RQRD
-- When APU AVAIL:
-- AIR COND panel ........ . ..... ... . . . . . SET
-- EXT POWER ......... . . ........ AS RQRD
-- • COCKPIT LIGHTS ... .. .. ..... .. .. AS RQRD
-- • ECAM RCL Ii> ... .................. PRESS
-- • ECAM OXY PRES/HYO QTY/ENG
-- OIL QTY .... .... .. .. ...... .. . .... . CHECK
-- FLAPS ........ . ...... . ... CHECK POSITION
-- • SPD BRK LEVER CHECK RET AND DISARMED
-- • PARKING BRAKE . . .. . .. .......... . .... ON
-- • ACCU/BRAKES PRESS . .. . ..... .. ... CHECK
-- • OEB IN QRH . ... . ...... .. .......... CHECK
-- EMER EQPT . .... ... .. .. .......... . CHECK
-- RAIN REPELLENT ... . .. .. . . . ..... . . CHECK
-- C/8 panels . .. . . .... ...... ....... .. CHECK
-- * GEAR PINS/FAN COWL FLAGS ....... CHECK
-- AIRCRAFT LIBRARY . ....... ........ CHECK
-- Oriy asterisks r) items req.iired on transit stop.


local prelCockpitPrep = kcProcedure:new("PRELIMINARY COCKPIT PREP (PNF)","performing Preliminary Cockpit Preparation")
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("All paper work on board and checked"))
prelCockpitPrep:addItem(kcSimpleProcedureItem:new("M E L and Technical Logbook checked"))

-- pb on
-- flaps up
-- thrist lever idle detent
-- eng masters off
-- eng mode sel norm
-- wx radar all off
-- pws off
-- lg lever down
-- wipers off
-- battery check > 25 Volts
-- bats auto position no lights
-- ext pwr on
-- displays on bright
-- lights as needed
-- mcdus on
-- radios on
-- fcu brightness on
-- wait for tripple click
-- apu firetest
-- ext pwer or apu startup 
-- a/c panel
-- temp select 3 zones 22-23 deg slightly left
-- pack flow norm or when less 120 pax then low
-- Cockpit lights
-- ecam recall pb press 3sec and check faults from last flight
-- ecam page door page oxygen >1500 psi
-- page hyd check fluid levels in range green arrows
-- eng page check oil qty 9.2qt min
-- flaps positopn check against display
-- speed brk lever retracted and disarmed
-- park brake on
-- check brk press indicator & accumulator 
-- emegrncy equipment checked
-- rain repellent
-- gear pins fan cwol flags
-- aircraft library


local CockpitPrep = kcProcedure:new("COCKPIT PREPARATION (BOTH)","starting cockpit preparation")


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