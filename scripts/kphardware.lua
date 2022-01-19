--[[
	*** KPHARDWARE
	Kosta Prokopiu, January 2022
--]]

local genutils = require "kpcrew.genutils"

local ZC_VERSION = "2.3"

logMsg ( "FWL: ** Starting KPHARDWARE version " .. ZC_VERSION .." **" )

local acf_icao = "DFLT"

-- Aircraft with no icao in aircraft.cfg need to be identfied individually
if (PLANE_TAILNUMBER == "N956OV") then	
	acf_icao="B146"
end
if (PLANE_TAILNUMBER == "PT-SSG") then	
	acf_icao="E170"
end
if (PLANE_TAILNUMBER == "PP-SSG") then	
	acf_icao="E195"
end
if (PLANE_TAILNUMBER == "E175") then	
	acf_icao="E175"
end
if (PLANE_TAILNUMBER == "C-GTLX") then	
	acf_icao = "A346"
end
if (PLANE_TAILNUMBER == "A345") then	
	acf_icao="A345"
end
	
-- Load plane specific module from Modules folder

-- Zibo B738
if (PLANE_ICAO == "B738") then
  acf_icao="B738"
end

local syslights = nil
if (acf_icao == "DFLT") then
	sysLights = require "kpcrew.systems.DFLT.sysLights"	
end

genutils.logInfo("TEST",acf_icao)


genutils.speakNoText(1,"TEST")
genutils.logInfo("TEST Single",genutils.singleLetters("test"))
genutils.logInfo("TEST Nato",genutils.convertNato("test"))
genutils.logInfo("TEST RWY",genutils.convertRwy("08C"))
genutils.logInfo("TEST time",genutils.display_timefull(10))

sysLights.setBeaconMode(1)


-- in FlyWithLua menu
--add_macro("KPCrew Re-Start", "kc_init_kpcrew()")

-- ---------------------------------- KPCrew commands ----------------------------------
--create_command("kp/crew/master_button",		"KPCrew Master Button",		"kc_master_button()", "", "")

--do_often("kc_proc_activities()")
