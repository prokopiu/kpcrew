--[[
	*** KPCREW 2.1.0
	Kosta Prokopiu, July 2021
--]]

ZC_VERSION = "2.1.0.1.2

-- stop if pre-reqs are not met
if not SUPPORTS_FLOATING_WINDOWS then
	logMsg("Upgrade your FlyWithLua! to NG 2.7+, need Floating Windows")
	return
end

-- exclude all unsupported aircraft - stop here
if (PLANE_TAILNUMBER ~= "ZB738") and (PLANE_ICAO ~= "B732") and (PLANE_ICAO ~= "B722") then
    return
end

-- local vars for multiple purpose
gLeftText = ""
gRightText = ""
lProcIndex = 0 -- procedure index
lProcStatus = 1 -- -1=no execution allowed 0=no procedure running  1=procedure running
lProcStep = 0 -- current procedure step in array
lProcTimer = 0 -- timer value to determine wait for step
lActivityTimer = 0 -- activity timer
lChecklistMode = 0 -- 1 in checklist

local dest_rwy = "---"
local dest_rwy_crs = 0
local dest_rwy_elev = 0
local dest_rwy_length = 0

-- ---------------------------- auxiliary functions -----------------------------------

-- speak text but don't show in sim, speakMode is used to prevent repetitive playing
-- speakmode 1 will talk and show, 0 will only speak
dataref("TEXTOUT", "sim/operation/prefs/text_out", "writeable")
function speakNoText(speakMode, sText)
	if speakMode == 0 then
		TEXTOUT=false
		XPLMSpeakString(sText)
		TEXTOUT=true
	else	
		TEXTOUT=true
		XPLMSpeakString(sText)
	end
end

-- split up text in single characters and separate by space
function singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local c = intext:sub(i,i)
		outtext = outtext .. c .. " "
	end
	return outtext
end
	
-- convert text into NATO alphabet words
function convertNato(intext)

	-- the NATO alphabet
	local nato = {["a"] = "Alpha", ["b"] = "Bravo", ["c"] = "Charlie", ["d"] = "Delta", ["e"] = "Echo", ["f"] = "Foxtrot",
		["g"] = "Golf", ["h"] = "Hotel", ["i"] = "India", ["j"] = "Juliet", ["k"] = "Kilo", ["l"] = "Lima", 
		["m"] = "Mike", ["n"] = "November", ["o"] = "Oscar", ["p"] = "Papa", ["q"] = "Quebec", ["r"] = "Romeo", 
		["s"] = "Sierra", ["t"] = "Tango", ["u"] = "Uniform", ["v"] = "Victor", ["w"] = "Whiskey", ["x"] = "X Ray",
		["y"] = "Yankee", ["z"] = "Zulu", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " ", ["."] = "Point", [","] = "Comma"
	}
	intext = string.lower(intext)
	intext = singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

-- convert runway designators to spoken characters, translating L,C,R
function convertRwy(intext)

	local nato = {["c"] = "Center", ["l"] = "Left", ["r"] = "Right", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " "
	}
	intext = string.lower(intext)
	intext = singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

logMsg ( "FWL: ** Starting KPCREW version " .. ZC_VERSION .." **" )

-- get screen sizes and boundaries
scrWidth, scrHeight = XPLMGetScreenSize()
bLeft, bTop, bRight, bBottom = XPLMGetScreenBoundsGlobal()

-- ---------------------------------- local variables ------------------------------------

gProcIndex = 0 -- procedure index
gProcStatus = 1 -- -1=no execution allowed 0=no procedure running  1=procedure running
gProcStep = 0 -- current procedure step in array
gProcTimer = 0 -- timer value to determine wait for step

gNameActiveProc = "KPCREW ".. ZC_VERSION .. " STARTING"
gCmdCnt = 0

gAskSecond = 0

gPreflightCounter = 0
gPreflightText = ""

-- window handles
zc_primary_wnd = 0 -- primary control window
zc_depbrf_wnd = 0 -- departure briefing window
zc_appbrf_wnd = 0 -- approach briefing window
zc_flightinfo_wnd = 0 -- flight information window

-- general options for briefings and flight information
GEN_onoff_list = {"OFF","ON"}

-- Noise Abatement departure Procedure
DEP_nadp_list = {"NOT REQUIRED","1","2"}
-- parking positin options
DEP_gatestand_list = {"GATE (PUSH)","STAND (PUSH)", "STAND (NO PUSH)"}
-- departure procedure types
DEP_proctype_list = {"SID","VECTORS","TRACKING"}
-- runway states
DEP_rwystate_list = {"DRY","WET","CONTAMINATED"}
-- departure packs mode
DEP_packs_list = {"ON","ON APU","OFF"}
-- forced return overweight or underweight
DEP_forced_return = {"UNDERWEIGHT", "OVERWEIGHT"}

-- arrival procedure type list 
APP_proctype_list = {"STAR","VECTORS"}
-- full list of approach types can be overwritten by aircraft
APP_apptype_list = {"ILS CAT 1","VISUAL","ILS CAT 2 OR 3","VOR","NDB","RNAV","TOUCH AND GO","CIRCLING"}
-- runway state arrival
APP_rwystate_list = {"DRY","WET","CONTAMINATED"}
-- A/ICE settings
APP_aice_list = {"NOT REQUIRED","Engine Only","Engine and Wing"}
-- Arrival packs mode
APP_packs_list = {"ON","ON APU","OFF"}
-- APU/GPU startup after landing
APP_apu_list = {"APU delayed start","APU","GPU"}

WX_Cloudcover_list = {"","FEW","SCT","BKN","OVC",""}

-- generic aircraft class with aircraft specific options
-- gets instantiated in active aircraft module
Class_ACF = {}
function Class_ACF:Create()
	local this = 
	{
		DEP_Flaps = {}, -- aircraft specific departure flaps settings display
		DEP_Flaps_val = {}, -- aircraft internal flaps settings values
		DEP_AP_Mode = {}, -- autopilot modes on takeoff (LNAV, HDG, ...)
		DEP_AP_Mode_val = {},
		APP_Flaps = {}, -- aircraft specific arrival flaps settings display
		APP_Flaps_val = {}, -- aircraft internal flaps settings values
		AutoBrake = {}, -- autobrake settings display
		AutoBrake_val = {}, -- autobrake settings internal value
		TakeoffThrust = {}, -- takeoff thrust setting
		TakeoffThrust_val = {}, -- internal to thrust values
		Bleeds = {}, -- bleed settings
		Bleed_val = {}, -- bleed internal values
		AIce = {}, -- anti ice settings
		AIce_val = {} -- anti ice settings values
	}

-- setters		
	function this:setDEP_Flaps(list)
		self.DEP_Flaps = list
	end
	
	function this:setDEP_Flaps_val(list)
		self.DEP_Flaps_val = list
	end
	
	function this:setDepApMode(list)
		self.DEP_AP_Mode = list
	end
		
	function this:setDepApMode_val(list)
		self.DEP_AP_Mode_val = list
	end

	function this:setAPP_Flaps(list)
		self.APP_Flaps = list
	end
	
	function this:setAPP_Flaps_val(list)
		self.APP_Flaps_val = list
	end
	
	function this:setAutoBrake(list)
		self.AutoBrake = list
	end
	
	function this:setAutoBrake_val(list)
		self.AutoBrake_val = list
	end
		
	function this:setTakeoffThrust(list)
		self.TakeoffThrust = list
	end
		
	function this:setTakeoffThrust_Val(list)
		self.TakeoffThrust_val = list
	end
		
	function this:setBleeds(list)
		self.Bleeds = list
	end
		
	function this:setBleeds_val(list)
		self.Bleeds_val = list
	end

	function this:setAIce(list)
		self.AIce = list
	end
		
	function this:setAIce_val(list)
		self.AIce_val = list
	end
	
-- getters			
	function this:getDEP_Flaps()
		return self.DEP_Flaps
	end
	
	function this:getDEP_Flaps_val()
		return self.DEP_Flaps_val
	end
	
	function this:getDepApMode()
		return self.DEP_AP_Mode
	end
		
	function this:getDepApMode_val()
		return self.DEP_AP_Mode_val
	end
	
	function this:getAPP_Flaps()
		return self.APP_Flaps
	end
	
	function this:getAPP_Flaps_val()
		return self.APP_Flaps_val
	end
	
	function this:getAutobrake()
		return self.AutoBrake
	end
	
	function this:getAutobrake_val()
		return self.AutoBrake_val
	end
	
	function this:getTakeoffThrust()
		return self.TakeoffThrust
	end
	
	function this:getTakeoffThrust_val()
		return self.TakeoffThrust_val
	end

	function this:getBleeds()
		return self.Bleeds
	end
	
	function this:getBleeds_val()
		return self.Bleeds_val
	end
	
	function this:getAIce()
		return self.AIce
	end
	
	function this:getAIce_val()
		return self.AIce_val
	end

	return this
end

---- internal configs and translated settings for display

-- get last configuration
require "kpcrewconfig"

-- getter and setter for config blocks

-- ZC_CONFIG general configuration items
function get_zc_config(key)
	return ZC_CONFIG[key]
end
function set_zc_config(key, value)
	ZC_CONFIG[key] = value
end

-- ZC_BRIEF_GEN general briefing items
function get_zc_brief_gen(key)
	return ZC_BRIEF_GEN[key]
end
function set_zc_brief_gen(key, value)
	ZC_BRIEF_GEN[key] = value
end

-- ZC_BRIEF_DEP Departure briefing items
function get_zc_brief_dep(key)
	return ZC_BRIEF_DEP[key]
end
function set_zc_brief_dep(key, value)
	ZC_BRIEF_DEP[key] = value
end

-- ZC_BRIEF_APP Approach briefing items
function get_zc_brief_app(key)
	return ZC_BRIEF_APP[key]
end
function set_zc_brief_app(key, value)
	ZC_BRIEF_APP[key] = value
end

-- initialize a new flight
function initFlight()
	ZC_CONFIG["acficao"] = PLANE_ICAO
	
	-- Aircraft with no icao in aircraft.cfg need to be identfied individually
	if (PLANE_TAILNUMBER == "N956OV") then	
		ZC_CONFIG["acficao"] = "B146"
	end
	if (PLANE_TAILNUMBER == "PT-SSG") then	
		ZC_CONFIG["acficao"] = "E170"
	end
	if (PLANE_TAILNUMBER == "PP-SSG") then	
		ZC_CONFIG["acficao"] = "E195"
	end
	if (PLANE_TAILNUMBER == "E175") then	
		ZC_CONFIG["acficao"] = "E175"
	end
	
	-- B738 knows, otherwise "---"
	ZC_BRIEF_GEN["parkpos"] = zc_get_parking_stand() -- if available from aircraft module
	
	-- pull current airport from navaid index
	next_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
	_, _, _, _, _, _, ZC_BRIEF_GEN["origin"], _ = XPLMGetNavAidInfo( next_airport_index )	
end

-- reset saved state and empty all settings which need to be replaced
function newFlight()

	initFlight()
	
	ZC_BRIEF_GEN["callsign"] = "------"
	ZC_BRIEF_GEN["depatisinfo"] = ""
	ZC_BRIEF_GEN["dest"] = "----"
	ZC_BRIEF_GEN["cruisealt"] = ZC_CONFIG["apalt"]
	ZC_BRIEF_GEN["appatisinfo"] = ""
	ZC_BRIEF_GEN["freqatis"] = 118.000
	ZC_BRIEF_GEN["freqclr"] = 118.000
	ZC_BRIEF_GEN["freqdep"] = 118.000
	ZC_BRIEF_GEN["freqgnd"] = 118.000
	ZC_BRIEF_GEN["freqtwr"] = 118.000
	ZC_BRIEF_GEN["freqaatis"] = 118.000
	ZC_BRIEF_GEN["freqapp"]  = 118.000 
	ZC_BRIEF_GEN["freqatwr"] = 118.000
	ZC_BRIEF_GEN["freqagnd"] = 118.000
	ZC_BRIEF_GEN["rwycond"] = 1
	ZC_BRIEF_GEN["initialalt"] = ZC_CONFIG["apalt"]
	ZC_BRIEF_GEN["squawk"] = 2000
	ZC_BRIEF_GEN["qnh"] = getQNHString()

	ZC_BRIEF_DEP["depgatestand"] = 1
	ZC_BRIEF_DEP["tothrust"] = 1
	ZC_BRIEF_DEP["toflaps"] = 1
	ZC_BRIEF_DEP["depatisinfo"] = "-"
	ZC_BRIEF_DEP["deprwy"] = "---"
	ZC_BRIEF_DEP["sid"] = "------"
	ZC_BRIEF_DEP["sidtrans"] = "-----"
	ZC_BRIEF_DEP["depbleeds"] = 1
	ZC_BRIEF_DEP["depaice"] = 1
	ZC_BRIEF_DEP["forcedReturn"] = 1
	ZC_BRIEF_DEP["deptype"] = 1
	ZC_BRIEF_DEP["depnadp"] = 1
	ZC_BRIEF_DEP["mintofuel"] = 1000
	ZC_BRIEF_DEP["elevtrim"] = 0.0
	ZC_BRIEF_DEP["remarks"] = ""
	ZC_BRIEF_DEP["rwycond"] = 1
	ZC_BRIEF_DEP["lnavvnav"] = 1
	ZC_BRIEF_DEP["v1"] = 100
	ZC_BRIEF_DEP["vr"] = 100
	ZC_BRIEF_DEP["v2"] = 100
	ZC_BRIEF_DEP["transalt"] = get_zc_config("translvlalt")

	ZC_BRIEF_APP["appatisinfo"] = "-"
	ZC_BRIEF_APP["dh"] = 200
	ZC_BRIEF_APP["da"] = 320
	ZC_BRIEF_APP["arrtype"] = 1
	ZC_BRIEF_APP["star"] = "------"
	ZC_BRIEF_APP["startrans"] = "-----"
	ZC_BRIEF_APP["apprwy"] 		= "---"
	ZC_BRIEF_APP["apptype"] 	= 1
	ZC_BRIEF_APP["appbaro"] 	= 1013
	ZC_BRIEF_APP["ilsfrq"] 		= 100.0
	ZC_BRIEF_APP["ilscrs"] 		= 001
	ZC_BRIEF_APP["vorfrq"]		= 100.0
	ZC_BRIEF_APP["vorcrs"]		= 001
	ZC_BRIEF_APP["ndbfrq"] 		= 310
	ZC_BRIEF_APP["ldgflaps"] 	= 1
	ZC_BRIEF_APP["autobrake"] 	= 1
	ZC_BRIEF_APP["rwycond"] 	= 1
	ZC_BRIEF_APP["apppacks"] 	= 1
	ZC_BRIEF_APP["appaice"] 	= 1
	ZC_BRIEF_APP["apu"] 		= 1
	ZC_BRIEF_APP["vref"] 		= 100
	ZC_BRIEF_APP["vapp"] 		= 100
	ZC_BRIEF_APP["gahdg"] 		= 001
	ZC_BRIEF_APP["gaalt"] 		= 4900
	ZC_BRIEF_APP["remarks"] = ""
	ZC_BRIEF_APP["translvl"] = get_zc_config("translvlalt")
end

-- Load plane specific module from Modules folder

-- Zibo B738
if (PLANE_ICAO == "B738") then
require "B738_kpcrew"
end

-- FJS Boeing 737-200
if (PLANE_ICAO == "B732") then
-- require "B732_kpcrew"
end

-- Rotate MD80
if (PLANE_ICAO == "MD88") then
-- require "MD88_kpcrew"
end

-- IXEG Boeing 737-300
if (PLANE_ICAO == "B733") then
-- require "B733_kpcrew"
end

-- FJS Boeing 727-200
if (PLANE_ICAO == "B722") then
-- require "B722_kpcrew"
end

-- FlightFactor 757
if (PLANE_ICAO == "B752" or PLANE_ICAO == "B753") then
-- require "B757_kpcrew"
end

-- FlightFactor 767
if (PLANE_ICAO == "B762" or PLANE_ICAO == "B763") then
-- require "B767_kpcrew"
end

-- FlightFactor 767
if (PLANE_ICAO == "B772" or PLANE_ICAO == "B77W" or PLANE_ICAO == "B77L") then
-- require "B777_kpcrew"
end

-- Jardesign A330
if (PLANE_ICAO == "A330") then
-- require "A330_kpcrew"
end

-- FlightFactor A320
if (PLANE_ICAO == "A320") then
-- require "A320_kpcrew"
end

-- ToLISS A321
if (PLANE_ICAO == "A321") then
-- require "A321_kpcrew"
end

-- ToLISS A319
if (PLANE_ICAO == "A319") then
-- require "A319_kpcrew"
end

-- FlightFactor A350
if (PLANE_ICAO == "A359") then
-- require "A359_kpcrew"
end

-- iniBuilds A300
if (PLANE_ICAO == "A306") then
-- require "A306_kpcrew"
end

-- JustFlight BAe 146
if (PLANE_TAILNUMBER == "N956OV") then
-- require "B146_kpcrew"
--	ZC_CONFIG["acficao"] = "B146"
end

-- X-Crafts Embraer Family
if (PLANE_ICAO == "E135" or PLANE_ICAO == "E140" or PLANE_ICAO == "E145" or PLANE_ICAO == "E35L") then
-- require "E135_kpcrew"
end

-- SSG E170 & E195
if (PLANE_TAILNUMBER == "PT-SSG" or PLANE_TAILNUMBER == "PP-SSG") then
-- require "E170_kpcrew"
end

-- X-Crafts E175 & E195
if (PLANE_TAILNUMBER == "E175" or PLANE_ICAO == "E190") then
-- require "E190_kpcrew"
end

-- LES Saab 340 
if (PLANE_ICAO == "SF34") then
-- require "SF34_kpcrew"
end


lActiveProc = ZC_INIT_PROC -- procedure currently active
lNameActiveProc = "KPCREW ".. ZC_VERSION .. " STARTING"

-- available aircraft types
Your_Hangar_List = {
	 ["B738"] = B738
--	,["B732"] = B732
--	,["B733"] = B733
--	,["A330"] = A330
--	,["MD88"] = MD88
--	,["B733"] = B733
--	,["B722"] = B722
--	,["B757"] = B757
--	,["B767"] = B767
--	,["B777"] = B777
--	,["A320"] = A320
--	,["A321"] = A321
--	,["A319"] = A319
--	,["A306"] = A306
--	,["B146"] = B146 
--	,["E135"] = E135
--	,["E170"] = E170
--	,["E190"] = E190
--	,["SF34"] = SF34

}
GENERAL_Acf = Your_Hangar_List[ZC_CONFIG["acficao"]]

-- initialize a new flight
initFlight()

--- action buttons on main window

-- actions when pressing the master button
function zc_master_button()

	-- initialize procedure modes
	if lProcStatus < 0 then
		lProcStep = 0
		lProcTimer = 0 
		lActiveProc = ZC_INIT_PROC
		lActivityTimer = 0
		lProcStatus = 1
	end

	currStep = lActiveProc[lProcStep]
	-- set delay for special steps
	if lChecklistMode == 1 and currStep["timerincr"] == 999 then
		currStep["timerincr"] = 5
	end
	if lChecklistMode == 1 and currStep["timerincr"] == 997 then
		currStep["timerincr"] = 1
	end
	if lChecklistMode == 1 and currStep["timerincr"] == 998 then
		currStep["timerincr"] = 2
	end
	if lChecklistMode == 1 and currStep["timerincr"] == 996 then
		currStep["timerincr"] = 1
	end
	
	if lChecklistMode == 1 then
		clearchecklist()
	end
	
	if lProcStatus ~= 1 then
		lProcStep = 0
		lProcTimer = 0 
		zc_get_procedure()
		lActivityTimer = 0
		lProcStatus = 1
	end
end	

-- actions when pressing the secondary button
function zc_second_button()
	if gPreflightCounter > 0 then
		gPreflightCounter = (math.ceil(gPreflightCounter/6)-1)*6
	else
		if lProcStatus == 1 then
			lProcStatus = 0
			lProcStep = 0
			lProcTimer = 0
			lActivityTimer = 0
			lActiveProc = ZC_NO_PROC
			gLeftText = "PROCEDURE/CHECKLIST STOPPED"
		end
	end
end	

-- actions when pressing the next button
function zc_next_button()
	if lProcStatus ~= 1 then
		if (lProcIndex < lNoProcs) then
			lProcIndex = lProcIndex + 1
		end
		zc_get_procedure()
		gRightText = lNameActiveProc
	end
end

-- actions when pressing the previous button
function zc_prev_button()
	if lProcStatus ~= 1 then
		if (lProcIndex > 1) then
			lProcIndex = lProcIndex - 1
		end
		zc_get_procedure()
		gRightText = lNameActiveProc
	end
end

-- actions when pressing the C&D @ button
function zc_coldanddark_button()
	ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status = 1
end

---- window system and related functions

-- primary window, wndMode 1=float, 2=flat window
function zc_init_primary_window (wndMode)
	if (wndMode ~= 1 and wndMode ~= 2 and wndMode ~= 3) then	
		wndMode = 1
	end
	
	if (wndMode == 1) then
		zc_primary_wnd = float_wnd_create(1024, 30, wndMode, true)
		float_wnd_set_position(zc_primary_wnd, scrWidth/2-512+ZC_CONFIG["primary_x_pos"], scrHeight-ZC_CONFIG["primary_y_offset"]-50)
		float_wnd_set_title(zc_primary_wnd, "KPCrew " .. ZC_VERSION)
		float_wnd_set_imgui_builder(zc_primary_wnd, "zc_primary_build")
		float_wnd_set_onclose(zc_primary_wnd, "zc_close_primary_window")
	else
		zc_primary_wnd = float_wnd_create(1024, 30, wndMode, true)
		-- set position with config values, x relative, y relative bottom of screen as offsets
		float_wnd_set_position(zc_primary_wnd, scrWidth/2-512+ZC_CONFIG["primary_x_pos"], scrHeight-ZC_CONFIG["primary_y_offset"]-30)
		float_wnd_set_title(zc_primary_wnd, "KPCrew " .. ZC_VERSION)
		float_wnd_set_imgui_builder(zc_primary_wnd, "zc_primary_build")
		float_wnd_set_onclose(zc_primary_wnd, "zc_close_primary_window")
	end

end

-- flight information window
function zc_init_flightinfo_window ()
	if zc_flightinfo_wnd == 0 then
		zc_flightinfo_wnd = float_wnd_create(350, 800, 1, true)
		float_wnd_set_title(zc_flightinfo_wnd, "KPCrew Flight Information")
		float_wnd_set_position(zc_flightinfo_wnd, 10 , scrHeight-900 )
		float_wnd_set_imgui_builder(zc_flightinfo_wnd, "zc_flightinfo_build")
		float_wnd_set_onclose(zc_flightinfo_wnd, "zc_close_flightinfo_window")
	end
end

-- departure briefing window
function zc_init_depbrf_window ()
	if zc_depbrf_wnd == 0 then
		zc_depbrf_wnd = float_wnd_create(380, 800, 1, true)
		float_wnd_set_title(zc_depbrf_wnd, "KPCrew Departure Briefing")
		float_wnd_set_position(zc_depbrf_wnd, 460 , scrHeight-900 )
		float_wnd_set_imgui_builder(zc_depbrf_wnd, "zc_depbrf_build")
		float_wnd_set_onclose(zc_depbrf_wnd, "zc_close_depbrf_window")
	end
end

-- approach briefing window
function zc_init_appbrf_window ()
	if zc_appbrf_wnd == 0 then
		zc_appbrf_wnd = float_wnd_create(380, 800, 1, true)
		float_wnd_set_title(zc_appbrf_wnd, "KPCrew Approach Briefing") 
		float_wnd_set_position(zc_appbrf_wnd, 870 , scrHeight-900 ) 
		float_wnd_set_imgui_builder(zc_appbrf_wnd, "zc_appbrf_build")
		float_wnd_set_onclose(zc_appbrf_wnd, "zc_close_appbrf_window")
	end
end

-- auxiliary roundîng function
local function round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

---- custom window/menu items

-- input field text
function zc_gui_in_text(lable, srcval, length, width)
	imgui.SetColumnWidth(1, width)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	local changed, textin = imgui.InputText("                                " .. lable , srcval, length)
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		return textin
	end
	return srcval
end

-- input field multiline text
function zc_gui_in_multiline(lable, srcval, length)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	local changed, textin = imgui.InputTextMultiline("                       " .. lable , srcval, length,210,35)
	imgui.NextColumn()
	if changed then
		return textin
	end
	return srcval
end

-- input field integer
function zc_gui_in_int(lable, srcval, increment, width)
	imgui.SetColumnWidth(1, width)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	local changed, textin = imgui.InputInt("                       " .. lable , srcval, increment)
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		return textin
	end
	return srcval
end

-- input field float
function zc_gui_in_float(lable, srcval, increment, width)
	imgui.SetColumnWidth(1, width)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	local changed, textin = imgui.InputFloat("                       " .. lable , srcval, 0.1, 1.0,"%4.2f")
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		return textin
	end
	return srcval
end

-- input field checkbox
function zc_gui_in_cb(lable, srcval, value)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	if imgui.Checkbox("                                    " .. lable, srcval == value) then
		srcval = value
	end
	imgui.NextColumn()
	return srcval
end

-- input field radiobutton
function zc_gui_in_trb(lable, srcval, caption1, caption2)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	local retval = srcval
	if imgui.RadioButton(caption1, srcval == true) then
		retval = true
	end
	imgui.SameLine()
	if imgui.RadioButton(caption2, srcval ~= true) then
		retval = false
	end
	imgui.NextColumn()
	return retval
end

-- input field dropdown
function zc_gui_in_dropdown(lable, srcval, list)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	if imgui.BeginCombo("                                    " .. lable, list[srcval]) then
		for i = 1, #list do
			if imgui.Selectable(list[i], srcval == i) then
				srcval = i
			end
		end
		imgui.EndCombo()
	end
	imgui.NextColumn()
	return srcval
end

-- input field com frequency - set COM1 when pressing lable
function zc_gui_in_freq(lable, srcval)
	imgui.SetColumnWidth(1, 165)
	if imgui.Button(lable .. ":") then
		set("sim/cockpit/radios/com1_freq_hz",srcval*100)
	end
	imgui.SameLine()
	imgui.NextColumn()
	local changed, textin = imgui.InputFloat("                  " .. lable , srcval, 0.005, 1.00,"%4.3f")
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- input field nav frequency - set NAV1 when pressing lable
function zc_gui_nav_freq(lable, srcval)
	imgui.SetColumnWidth(1, 165)
	if imgui.Button(lable .. ":") then
		set("sim/cockpit/radios/nav1_freq_hz",srcval*100)
	end
	imgui.SameLine()
	imgui.NextColumn()
	local changed, textin = imgui.InputFloat("                  " .. lable , srcval, 0.05, 1.00,"%4.3f")
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- input field ndb frequency - set ADF1 when pressing lable
function zc_gui_ndb_freq(lable, srcval)
	imgui.SetColumnWidth(1, 165)
	if imgui.Button(lable .. ":") then
		set("sim/cockpit/radios/adf1_freq_hz",srcval)
	end
	imgui.SameLine()
	imgui.NextColumn()
	local changed, textin = imgui.InputFloat("                  " .. lable , srcval, 1, 1.00,"%4.0f")
	imgui.NextColumn()
	imgui.SetColumnWidth(1, 240)
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- output text lable
function zc_gui_out_text(lable, srcval, color)
	imgui.TextUnformatted(lable .. ":")
	imgui.NextColumn()
	imgui.PushStyleColor(imgui.constant.Col.Text, color)
	imgui.TextUnformatted(srcval)
	imgui.NextColumn()
	imgui.PopStyleColor()
end

---- ATIS related functions

-- return QNH string
function getQNHString()
	local QNHstring = ""
	if ZC_CONFIG["qnhhpa"] then
		QNHstring = string.format("Q%4.4i",round(get("sim/weather/barometer_sealevel_inhg") / 0.02952999))
	else
		QNHstring = string.format("A%4.4i",(round(get("sim/weather/barometer_sealevel_inhg") * 10^2)*10^-2)*100)
	end
	return QNHstring
end

-- build a makeshift ATIS string from XP11 weather - very simplistic
function zc_build_atis_string()
	
	local ATISstring = string.format("%s %2.2i%2.2i%2.2iZ %3.3i%2.2iKT", ZC_BRIEF_GEN["origin"], get("sim/cockpit2/clock_timer/current_day")+1,get("sim/cockpit2/clock_timer/zulu_time_hours"),get("sim/cockpit2/clock_timer/zulu_time_minutes"),get("sim/weather/wind_direction_degt",0),get("sim/weather/wind_speed_kt",0))
	
	local CLDcoverage = get("sim/weather/cloud_coverage[0]")
	local CLDstring = ""
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],get("sim/weather/cloud_base_msl_m[0]")/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[1]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],get("sim/weather/cloud_base_msl_m[1]")/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[2]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],get("sim/weather/cloud_base_msl_m[2]")/100)
	end
	
	local visiblestring = ""
	local visibility = get("sim/weather/visibility_reported_m")
	if (visibility < 4500) then
		visiblestring = "HZ "
	end
	if (visibility < 1500) then
		visiblestring = "BR "
	end
	if (visibility < 800) then
		visiblestring = "FG "
	end

	local ambtemp = get("sim/weather/temperature_ambient_c")
	local duepoint = get("sim/weather/dewpoi_sealevel_c")
	local tempstring = ""
	if (ambtemp<0) then
		tempstring=string.format("M%2.2i/", ambtemp*-1)
	else
		tempstring=string.format("%2.2i/", ambtemp)
	end
	if (duepoint<0) then
		tempstring=tempstring .. string.format("M%2.2i", duepoint*-1)
	else
		tempstring=tempstring .. string.format("%2.2i", duepoint)
	end
	ATISstring = ATISstring .. "\n" .. visiblestring .. CLDstring .. tempstring
	
	local vcond = ""
	if (visibility > 10000) then
		vcond = "CAVOK"
	end
	if (visibility < 10000) then
		vcond = "9999"
	end
	if (visibility < 9000) then
		vcond = string.format("%4.4i",visibility)
	end
	
	ATISstring = ATISstring .. "\n" .. getQNHString() .. " " .. vcond
	return ATISstring
end

-- flight information window
function zc_flightinfo_build()

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()

	-- button to open departure window
	if imgui.Button("DEPARTURE") then
		ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 1
	end
	imgui.SameLine()
	
	-- button to open arrival window
	if imgui.Button("ARRIVAL") then
		ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status = 1
	end
	
	imgui.Separator()
	
	-- Table
	imgui.Columns(2,"FlightInfo1",false)
	imgui.SetColumnWidth(0, 150)
	imgui.SetColumnWidth(1, 240)

	local weightunit = "KG"
	if (get_zc_config("kglbs")) then
		weightunit = "KG"
	else
		weightunit = "LBS"
	end
	
	-- Aircraft Type from ICAO field
	zc_gui_out_text("Aircraft Type",ZC_CONFIG["acfname"] .. " (" .. ZC_CONFIG["acficao"] .. ")\n",0xFFFFFF00)
	
	-- Fuel from aircraft specific function
	zc_gui_out_text("Total Fuel",string.format("%6.6i",zc_get_total_fuel()) .. " " .. weightunit .."\n",0xFF21FF00)

	-- display gross weight in matching unit
	zc_gui_out_text("Gross Weight/ZFW",string.format("%6.6i",zc_get_gross_weight()) .. " "..weightunit.." / " .. string.format("%6.6i",zc_get_zfw()) .. " " .. weightunit.."\n",0xFF21FF00)
	
	-- Call Sign of aircraft
	ZC_BRIEF_GEN["callsign"] = zc_gui_in_text("Callsign",ZC_BRIEF_GEN["callsign"],15,100)
	imgui.Separator()

	-- Origin airport icao
	ZC_BRIEF_GEN["origin"] = zc_gui_in_text("Origin",ZC_BRIEF_GEN["origin"],5,80)
	
	-- Determine airport information from XP11
	zc_gui_out_text("Airport Elevation",string.format("%6.0f",round(get("sim/cockpit2/autopilot/altitude_readout_preselector"))) .. " ft\n",0xFF21FF00)

	-- Parking Position
	ZC_BRIEF_GEN["parkpos"] = zc_gui_in_text("Parking Position",ZC_BRIEF_GEN["parkpos"],15,80)

	-- ATIS frequency
	ZC_BRIEF_GEN["freqatis"] = zc_gui_in_freq("ATIS",ZC_BRIEF_GEN["freqatis"])
	
	-- Clearance frequency
	ZC_BRIEF_GEN["freqclr"] = zc_gui_in_freq("Clearance Delivery",ZC_BRIEF_GEN["freqclr"])
	
	-- DEP frequency
	ZC_BRIEF_GEN["freqdep"] = zc_gui_in_freq("Departure",ZC_BRIEF_GEN["freqdep"])

	-- GND frequency
	ZC_BRIEF_GEN["freqgnd"] = zc_gui_in_freq("Ground",ZC_BRIEF_GEN["freqgnd"])

	-- TWR frequency
	ZC_BRIEF_GEN["freqtwr"] = zc_gui_in_freq("Tower",ZC_BRIEF_GEN["freqtwr"])

	-- Destination
	ZC_BRIEF_GEN["dest"] = zc_gui_in_text("Destination",ZC_BRIEF_GEN["dest"],5,80)

	-- ATIS
	ZC_BRIEF_GEN["freqaatis"] = zc_gui_in_freq("Arrival ATIS",ZC_BRIEF_GEN["freqaatis"])

	-- APP frequency
	ZC_BRIEF_GEN["freqapp"] = zc_gui_in_freq("Approach",ZC_BRIEF_GEN["freqapp"])

	-- TWR frequency
	ZC_BRIEF_GEN["freqatwr"] = zc_gui_in_freq("Destination Tower",ZC_BRIEF_GEN["freqatwr"])

	-- GND frequency
	ZC_BRIEF_GEN["freqagnd"] = zc_gui_in_freq("Destination Ground",ZC_BRIEF_GEN["freqagnd"])

	-- Cruising Altitude
	ZC_BRIEF_GEN["cruisealt"] = zc_gui_in_int("Cruising Altitude",ZC_BRIEF_GEN["cruisealt"],1000,165)

	imgui.Separator()

	-- Clear all Data entered --> New Flight
	if imgui.Button("NEW FLIGHT") then
		newFlight()
	end

	imgui.Separator()

	-- ATIS generated string
	zc_gui_out_text("ATIS",zc_build_atis_string(),0xFF21FF00)

	imgui.Separator()

-- general configuration sections

	zc_gui_out_text("Configuration","\n\n",0xFF21FF00)
	
	-- Barometer unit hpa/inhg
	set_zc_config("qnhhpa",zc_gui_in_trb("Barometer", ZC_CONFIG["qnhhpa"], "HPa", "inHG"))
	
	-- initial heading on the glareshield/autopilot
	set_zc_config("aphdg",zc_gui_in_int("A/P Initial Heading", ZC_CONFIG["aphdg"], 10,150))

	-- initial speed on the glareshield/autopilot
	set_zc_config("apspd",zc_gui_in_int("A/P Initial Speed", ZC_CONFIG["apspd"], 10,150))
	
	-- initial altitude on the glareshield/autopilot
	set_zc_config("apalt",zc_gui_in_int("A/P Initial Altitude", ZC_CONFIG["apalt"], 10,150))

	-- default transition altitude/level (e.g. 5000 Germanyy, 18000 US)
	set_zc_config("translvlalt",zc_gui_in_int("Default Transition", ZC_CONFIG["translvlalt"], 1000,170))

	-- powerup with APU or GPU
	set_zc_config("apuinit",zc_gui_in_trb("Power-Up", ZC_CONFIG["apuinit"], "APU", "GPU"))
	
	-- Decision height or altitude
	set_zc_config("dhda",zc_gui_in_trb("Minimums", ZC_CONFIG["dhda"], "RADIO", "BARO"))
	
	-- KG or lbs as units
	set_zc_config("kglbs",zc_gui_in_trb("Weight Units", ZC_CONFIG["kglbs"], "KG", "LBS"))
	
	-- Easy mode or manual (not muh support outside procedures)
	set_zc_config("easy",zc_gui_in_trb("Easy use", ZC_CONFIG["easy"], "EASY", "MANUAL"))

	imgui.Separator()

	-- Clear all Data entered --> New Flight
	if imgui.Button("SAVE") then
		WriteConfig()
	end
	
end

-- departure briefing window
function zc_depbrf_build ()

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	
	-- Table layout
	imgui.Columns(2,"DEP_Briefing1",false)
	imgui.SetColumnWidth(0, 150)
	imgui.SetColumnWidth(1, 250)
	
	-- departure clearance string build from individual items
	-- callsign
	zc_gui_out_text("Clearance",ZC_BRIEF_GEN["callsign"].." "..ZC_CONFIG["acfname"].."\n\n",0xFF21FF00)

	-- ATIS info enter ATIS letter as received
	ZC_BRIEF_DEP["depatisinfo"] = zc_gui_in_text("ATIS Information",ZC_BRIEF_DEP["depatisinfo"],2,30)

	-- Parking Position on airport (stand or gate)
	zc_gui_out_text("Stand",ZC_BRIEF_GEN["parkpos"].."\n",0xFF21FF00)

	-- Destination taken from info window
	zc_gui_out_text("Cleared to",ZC_BRIEF_GEN["dest"].."\n",0xFF21FF00)

	-- Flight level cruise altitude from ATC/flight planning
	zc_gui_out_text("FL",(ZC_BRIEF_GEN["cruisealt"]/100).."\n",0xFF21FF00)

	-- departure runway designation
	ZC_BRIEF_DEP["deprwy"] = zc_gui_in_text("Runway",ZC_BRIEF_DEP["deprwy"],6,60)

	-- departure procedure name, or "VECTORS"
	ZC_BRIEF_DEP["sid"] = zc_gui_in_text("Via",ZC_BRIEF_DEP["sid"],15,150)
	
	-- departure transition name
	ZC_BRIEF_DEP["sidtrans"] = zc_gui_in_text("Transition",ZC_BRIEF_DEP["sidtrans"],15,150)

	-- Squawk code as given from ATC
	ZC_BRIEF_GEN["squawk"] = zc_gui_in_text("XPDR",ZC_BRIEF_GEN["squawk"],5,200)

	-- transition altitude as published
	ZC_BRIEF_DEP["transalt"] =  zc_gui_in_int("Transition Altitude", ZC_BRIEF_DEP["transalt"] ,100,170)

	imgui.Separator()		

	-- type of stand
	ZC_BRIEF_DEP["depgatestand"] = zc_gui_in_dropdown("Gate/Stand",ZC_BRIEF_DEP["depgatestand"],DEP_gatestand_list,250)

	-- t/o thrust settings
	ZC_BRIEF_DEP["tothrust"] = zc_gui_in_dropdown("T/O Thrust",ZC_BRIEF_DEP["tothrust"],GENERAL_Acf:getTakeoffThrust(),250)

	-- T/O flaps
	ZC_BRIEF_DEP["toflaps"] = zc_gui_in_dropdown("T/O Flaps",ZC_BRIEF_DEP["toflaps"],GENERAL_Acf:getDEP_Flaps(),90)
	
	-- Bleeds
	ZC_BRIEF_DEP["depbleeds"] = zc_gui_in_dropdown("T/O Bleeds",ZC_BRIEF_DEP["depbleeds"],GENERAL_Acf:getBleeds(),90)
	
	-- Anti Ice
	ZC_BRIEF_DEP["depaice"] = zc_gui_in_dropdown("Anti Ice",ZC_BRIEF_DEP["depaice"],GENERAL_Acf:getAIce(),90)
	
	-- forced return
	ZC_BRIEF_DEP["forcedReturn"] = zc_gui_in_dropdown("Forced Return",ZC_BRIEF_DEP["forcedReturn"],DEP_forced_return,90)

	-- departure type
	ZC_BRIEF_DEP["deptype"] = zc_gui_in_dropdown("Departure Procedure",ZC_BRIEF_DEP["deptype"],DEP_proctype_list,90)

	-- Noise Abatement Departure Position
	ZC_BRIEF_DEP["depnadp"] = zc_gui_in_dropdown("NADP",ZC_BRIEF_DEP["depnadp"],DEP_nadp_list,90)

	-- Takeoff A/P modes (aircraft specific)
	ZC_BRIEF_DEP["lnavvnav"] = zc_gui_in_dropdown("Autopilot Mode",ZC_BRIEF_DEP["lnavvnav"],GENERAL_Acf:getDepApMode(),90)

	imgui.Separator()

	-- min t/o fuel in units (I put in the block fuel)
	ZC_BRIEF_DEP["mintofuel"] = zc_gui_in_int("T/O Fuel",ZC_BRIEF_DEP["mintofuel"],100,170)

	-- elevator trim setting
	ZC_BRIEF_DEP["elevtrim"] = zc_gui_in_float("Elevator Trim",ZC_BRIEF_DEP["elevtrim"],100,170)

	-- rwy condition
	ZC_BRIEF_DEP["rwycond"] = zc_gui_in_dropdown("Runway Condition",ZC_BRIEF_DEP["rwycond"],DEP_rwystate_list,90)

	-- Vspeeds either manual or by pressing aircraft data button
	ZC_BRIEF_DEP["v1"] = zc_gui_in_int("V1",ZC_BRIEF_DEP["v1"],1,170)
	ZC_BRIEF_DEP["vr"] = zc_gui_in_int("VR",ZC_BRIEF_DEP["vr"],1,170)
	ZC_BRIEF_DEP["v2"] = zc_gui_in_int("V2",ZC_BRIEF_DEP["v2"],1,170)

	zc_gui_out_text("\nGlareshield","\n",0xFF21FF00)

	-- Glareshield setup, can also come from aircraft data button
	ZC_BRIEF_GEN["glarecrs1"] = zc_gui_in_int("CRS1",ZC_BRIEF_GEN["glarecrs1"],10,170)
	ZC_BRIEF_GEN["glarespd"] =  zc_gui_in_int("SPD", ZC_BRIEF_GEN["glarespd"] ,1,170)
	ZC_BRIEF_GEN["glarehdg"] =  zc_gui_in_int("HDG", ZC_BRIEF_GEN["glarehdg"] ,10,170)
	ZC_BRIEF_GEN["glarealt"] =  zc_gui_in_int("ALT", ZC_BRIEF_GEN["glarealt"] ,100,170)
	ZC_BRIEF_GEN["glarecrs2"] = zc_gui_in_int("CRS2",ZC_BRIEF_GEN["glarecrs2"],10,170)

	-- button pulls information from aircraft where available
	imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF21FF00)
	imgui.PopStyleColor()
	imgui.NextColumn()
						
	if imgui.Button("Aircraft Data") then
		zc_menus_set_DEP_data()
	end
	imgui.NextColumn()
end

-- approach briefing window
function zc_appbrf_build()

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	local win_height_floating = 0
	
	-- Table layout
	imgui.Columns(2,"APP_Briefing1",false)
	imgui.SetColumnWidth(0, 150)
	imgui.SetColumnWidth(1, 240)
	
	-- Clearance text area
	zc_gui_out_text("Clearance",ZC_BRIEF_GEN["callsign"].." "..ZC_CONFIG["acfname"].."\n\n",0xFF21FF00)

	-- ATIS info field - enter ATIS letter
	ZC_BRIEF_APP["appatisinfo"] = zc_gui_in_text("ATIS Information",ZC_BRIEF_APP["appatisinfo"],2,30)

	-- aircraft specific sections, B738 can pull the information from the FMS, alternativ manual entry
	-- ICAO code of destination
	if (PLANE_ICAO == "B738") then
		ZC_BRIEF_GEN["dest"] = zc_gui_in_text("Cleared to",zc_get_dest_icao(),6,150)
	else
		ZC_BRIEF_GEN["dest"] = zc_gui_in_text("Cleared to",ZC_BRIEF_GEN["dest"],6,150)
	end
	
	-- departure runway designation
	if (PLANE_ICAO == "B738") then
		zc_gui_out_text("Runway",string.sub(zc_acf_get_ils_rwy(),1,3),0xFF21FF00)
	else
		dest_rwy = zc_gui_in_text("Runway Designation",dest_rwy,5,150)
	end
	
	-- departure runway elevation
	if (PLANE_ICAO == "B738") then
		zc_gui_out_text("Runway Elevation",string.format("%6.0f",round(zc_get_dest_runway_alt())) .. " ft\n",0xFF21FF00)
	else
		dest_rwy_elev = zc_gui_in_int("Runway Elevation",dest_rwy_elev,100,170)
	end
	
	-- departure runway course
	if (PLANE_ICAO == "B738") then
		zc_gui_out_text("Runway Course",string.format("%3.0f",round(zc_get_dest_runway_crs())) .. " deg\n",0xFF21FF00)
	else
		dest_rwy_crs = zc_gui_in_int("Runway Course",dest_rwy_crs,1,170)
	end
	
	-- departure runway length
	if (PLANE_ICAO == "B738") then
		zc_gui_out_text("Runway Length",string.format("%6.0f",round(zc_get_dest_runway_len())) .. " m\n",0xFF21FF00)
	else
		dest_rwy_length = zc_gui_in_int("Runway Length",dest_rwy_length,100,170)
	end
	
	imgui.Separator()		

	-- ATC provided QNH
	ZC_BRIEF_APP["appbaro"] = zc_gui_in_text("QNH",ZC_BRIEF_APP["appbaro"],10,150)
	
	-- Transition level at destination from ATC
	ZC_BRIEF_APP["translvl"] = zc_gui_in_int("Transition Level",ZC_BRIEF_APP["translvl"],100,170)
	
	-- Arrival procedure type (depends on aircraft)
	ZC_BRIEF_APP["arrtype"] = zc_gui_in_dropdown("Arrival Procedure",ZC_BRIEF_APP["arrtype"],APP_proctype_list,90)
	
	-- arrival procedure name
	ZC_BRIEF_APP["star"] = zc_gui_in_text("STAR",ZC_BRIEF_APP["star"],15,150)	
	
	-- arrival transition name
	ZC_BRIEF_APP["startrans"] = zc_gui_in_text("Transition",ZC_BRIEF_APP["startrans"],15,150)
	
	-- landing runway designation
	ZC_BRIEF_APP["apprwy"] = zc_gui_in_text("Runway",ZC_BRIEF_APP["apprwy"],6,60)

	-- approach procedure type (depends on aircraft)
	ZC_BRIEF_APP["apptype"] = zc_gui_in_dropdown("Approach Procedure",ZC_BRIEF_APP["apptype"],APP_apptype_list,90)

	-- for ILS approach add frequency fields
	if (get_zc_brief_app("apptype") == 1 or get_zc_brief_app("apptype") == 3) then
		ZC_BRIEF_APP["ilsfrq"] = zc_gui_nav_freq("ILS Frequeny",ZC_BRIEF_APP["ilsfrq"])
		ZC_BRIEF_APP["ilscrs"] = zc_gui_in_int("ILS Course",ZC_BRIEF_APP["ilscrs"],10,170)
	end

	-- for VOR approach add NAV1 frequency fields
	if (get_zc_brief_app("apptype") == 4) then
		ZC_BRIEF_APP["vorfrq"] = zc_gui_nav_freq("VOR Frequeny",ZC_BRIEF_APP["vorfrq"])
		ZC_BRIEF_APP["vorcrs"] = zc_gui_in_int("VOR Course",ZC_BRIEF_APP["vorcrs"],10,170)
	end

	-- for NDB approach add ADF frequency field
	if (get_zc_brief_app("apptype") == 5) then
		ZC_BRIEF_APP["ndbfrq"] = zc_gui_ndb_freq("NDB Frequeny",ZC_BRIEF_APP["ndbfrq"])
	end

	-- show decision altitude or height depending on configuration
	if (ZC_CONFIG["dhda"]) then
		ZC_BRIEF_APP["dh"] = zc_gui_in_int("DH",ZC_BRIEF_APP["dh"],1,170)
	else
		ZC_BRIEF_APP["da"] = zc_gui_in_int("DA",ZC_BRIEF_APP["da"],1,170)
	end

	-- Landing setting from aircraft: Flaps, A/BRK, RWY condition, Packs, A/ICE, APU
	ZC_BRIEF_APP["ldgflaps"] = zc_gui_in_dropdown("Landing Flaps",ZC_BRIEF_APP["ldgflaps"],GENERAL_Acf:getAPP_Flaps(),90)
	ZC_BRIEF_APP["autobrake"] = zc_gui_in_dropdown("Autobrake",ZC_BRIEF_APP["autobrake"],GENERAL_Acf:getAutobrake(),90)
	ZC_BRIEF_APP["rwycond"] = zc_gui_in_dropdown("Runway Condition",ZC_BRIEF_APP["rwycond"],APP_rwystate_list,90)
	ZC_BRIEF_APP["apppacks"] = zc_gui_in_dropdown("Packs",ZC_BRIEF_APP["apppacks"],GENERAL_Acf:getBleeds(),90)
	ZC_BRIEF_APP["appaice"] = zc_gui_in_dropdown("Anti Ice",ZC_BRIEF_APP["appaice"],GENERAL_Acf:getAIce(),90)
	ZC_BRIEF_APP["apu"] = zc_gui_in_dropdown("APU Start",ZC_BRIEF_APP["apu"],APP_apu_list,90)
	ZC_BRIEF_DEP["depgatestand"] = zc_gui_in_dropdown("Gate/Stand",ZC_BRIEF_DEP["depgatestand"],DEP_gatestand_list,250)

	imgui.Separator()		

	-- Approach and reference speed. Set from config or by pressing aircraft data button
	ZC_BRIEF_APP["vapp"] = zc_gui_in_int("Vapp",ZC_BRIEF_APP["vapp"],1,170)
	ZC_BRIEF_APP["vref"] = zc_gui_in_int("Vref",ZC_BRIEF_APP["vref"],1,170)

	imgui.Separator()

	ZC_BRIEF_APP["gahdg"] = zc_gui_in_int("Go Around HDG",ZC_BRIEF_APP["gahdg"],1,170)
	ZC_BRIEF_APP["gaalt"] = zc_gui_in_int("Go Around ALT",ZC_BRIEF_APP["gaalt"],1,170)

	if imgui.Button("Aircraft Data") then
		zc_menus_set_APP_data()
	end

end

-- primary kpcrew window
function zc_primary_build()

	-- MASTER Button
	imgui.SetCursorPosX(0)
	if imgui.Button("M", 20, 20) then
		zc_master_button()
	end

	-- CHECKLIST/ACTIVITY display
	imgui.SameLine()
	imgui.SetCursorPosX(30)
    imgui.TextUnformatted(string.format(gLeftText, zc_primary_wnd, x, y))
	
	-- SECONDARY Button
	imgui.SameLine()
	imgui.SetCursorPosX(500)
	if imgui.Button("S", 20, 20) then
		zc_second_button()
	end

	-- PREV Button
	imgui.SameLine()
	imgui.SetCursorPosX(520)
	if imgui.Button("<", 20, 20) then
		zc_prev_button()
	end
	
	-- NEXT Button
	imgui.SameLine()
	imgui.SetCursorPosX(540)
	if imgui.Button(">", 20, 20) then
		zc_next_button()
	end

	-- MODE/AUXILIARY display
	imgui.SameLine()
	imgui.SetCursorPosX(570)
	imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFA0AFFF)
    imgui.TextUnformatted(string.format(gRightText, zc_primary_wnd, x, y))
	imgui.PopStyleColor()
	
	-- START PREFLIGHT WITH COLD&DARK Button
	imgui.SameLine()
	imgui.SetCursorPosX(984)
	if imgui.Button("@", 20, 20) then
		zc_coldanddark_button()
	end

end

-- close windows
function zc_close_primary_window(wnd)
	zc_primary_wnd = 0
end

function zc_close_depbrf_window(wnd)
	zc_depbrf_wnd = 0
end

function zc_close_appbrf_window(wnd)
	zc_appbrf_wnd = 0
end

function zc_close_flightinfo_window(wnd)
	zc_flightinfo_wnd = 0
end

-- initialize kpcrew, can be called from FwL menu
function zc_init_zibocrew()
	lProcIndex = 0
	lProcStatus = 0
	lProcStep = 0
	lProcTimer = 0
	lActivityTimer = 0
	lChecklistMode = 0
	lActiveProc = ZC_INIT_PROC
	if zc_primary_wnd == 0 then
		zc_init_primary_window(ZC_CONFIG["wnd_primary_type"])
	end
	zc_next_button()
end

-- run active procedure's activities stepping through the individual items in the procedure array
function zc_proc_activities()

	-- procedure status 1 means running
	if lProcStatus == 1 then
		-- get active step
		currStep = lActiveProc[lProcStep]
		-- 999 = wait for action and then delay by 5 seconds until next step
		-- 998 = wait for action and then delay by 2 sceonds until next step
		-- 997 = wait for action and then delay by 1 sceonds until next step
		-- 996 = skip this step
		-- 0 < n < 996 execute the step and wait n seconds
		if currStep ~= nil and lProcTimer == lActivityTimer and currStep["timerincr"] ~= 999 and currStep["timerincr"] ~= 998 and currStep["timerincr"] ~= 997 then
			if currStep["timerincr"] ~= 996 then
				gLeftText = currStep["lefttext"]
				currStep["actions"]()
			end
			if currStep["timerincr"] > 0 then
				if currStep["timerincr"] ~= 999 and currStep["timerincr"] ~= 998 and currStep["timerincr"] ~= 997 and currStep["timerincr"] ~= 996 then
					lProcTimer = lProcTimer + currStep["timerincr"]
				end
			end
			if currStep["timerincr"] ~= 999 and currStep["timerincr"] ~= 998 and currStep["timerincr"] ~= 997 then
				lProcStep = lProcStep + 1
			end
		end
		if currStep["timerincr"] > 0 then
			if currStep["timerincr"] ~= 999 and currStep["timerincr"] ~= 998 and currStep["timerincr"] ~= 997 and currStep["timerincr"] ~= 996 then
				lActivityTimer = lActivityTimer + 1
			else
				gLeftText = "* " .. currStep["lefttext"]
			end
		else
			lProcStatus = 0
			lProcStep = 0
			lProcTimer = 0
			lActivityTimer = 0
			lActiveProc = ZC_NO_PROC
			zc_next_button()
		end
	end
end

-- scan through the background procedure array and execute the actions() 
-- function for each that has a 1 in the status field
function zc_proc_background()
	for step in pairs(ZC_BACKGROUND_PROCS) do 
		local stat = ZC_BACKGROUND_PROCS[step].status
		if (stat > 0) then
			ZC_BACKGROUND_PROCS[step].actions()
		end
	end
end

-- reduce the preflight countdown every 10 seconds
function zc_preflight_countdown()
	if (gPreflightCounter > 0) then
		gPreflightCounter = gPreflightCounter - 1
	end
end

-- Write all config items to the kpcrewconfig.lua file
function WriteConfig()
	fileConfig = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrewconfig.lua", "w+")

	fileConfig:write('-- KPCrew configuration\n')
	fileConfig:write('ZC_CONFIG = {\n')
	fileConfig:write('	["wnd_primary_type"] = ' .. ZC_CONFIG["wnd_primary_type"] .. ',\n')
	fileConfig:write('	["primary_x_pos"] = ' .. ZC_CONFIG["primary_x_pos"] .. ',\n')
	fileConfig:write('	["primary_y_offset"] = ' .. ZC_CONFIG["primary_y_offset"] .. ',\n')
	fileConfig:write('	["aphdg"] = ' .. ZC_CONFIG["aphdg"] .. ',\n')
	fileConfig:write('	["apspd"] = ' .. ZC_CONFIG["apspd"] .. ',\n')
	fileConfig:write('	["apalt"] = ' .. ZC_CONFIG["apalt"] .. ',\n')
	fileConfig:write('	["translvlalt"] = ' .. ZC_CONFIG["translvlalt"] .. ',\n')
	fileConfig:write('	["qnhhpa"] = ' .. tostring(ZC_CONFIG["qnhhpa"]) .. ',\n')
	fileConfig:write('	["apuinit"] = ' .. tostring(ZC_CONFIG["apuinit"]) .. ',\n')
	fileConfig:write('	["dhda"] = ' .. tostring(ZC_CONFIG["dhda"]) .. ',\n')
	fileConfig:write('	["easy"] = ' .. tostring(ZC_CONFIG["easy"]) .. ',\n')
	fileConfig:write('	["kglbs"] = ' .. tostring(ZC_CONFIG["kglbs"]) .. '\n')
	fileConfig:write('}\n')
	fileConfig:write('\n')
	
	fileConfig:write('ZC_BRIEF_GEN = {\n')
	fileConfig:write('	["callsign"] = "' .. ZC_BRIEF_GEN["callsign"] .. '",\n')
	fileConfig:write('	["parkpos"] = "' .. ZC_BRIEF_GEN["parkpos"] .. '",\n')
	fileConfig:write('	["origin"] = "' .. ZC_BRIEF_GEN["origin"] .. '",\n')
	fileConfig:write('	["dest"] = "' .. ZC_BRIEF_GEN["dest"] .. '",\n')
	fileConfig:write('	["cruisealt"] = ' .. ZC_BRIEF_GEN["cruisealt"] .. ',\n')
	fileConfig:write('	["rwycond"] = ' .. ZC_BRIEF_GEN["rwycond"] .. ',\n')
	fileConfig:write('	["initialalt"] = ' .. ZC_BRIEF_GEN["initialalt"] .. ',\n')
	fileConfig:write('	["squawk"] = ' .. ZC_BRIEF_GEN["squawk"] .. ',\n')
	fileConfig:write('	["qnh"] = ' .. ZC_BRIEF_GEN["qnh"] .. ',\n')
	fileConfig:write('	["glarecrs1"] = ' .. ZC_BRIEF_GEN["glarecrs1"] .. ',\n')
	fileConfig:write('	["glarespd"] = ' ..  ZC_BRIEF_GEN["glarespd"] .. ',\n')
	fileConfig:write('	["glarehdg"] = ' ..  ZC_BRIEF_GEN["glarehdg"] .. ',\n')
	fileConfig:write('	["glarealt"] = ' ..  ZC_BRIEF_GEN["glarealt"] .. ',\n')
	fileConfig:write('	["glarecrs2"] = ' .. ZC_BRIEF_GEN["glarecrs2"] .. ',\n')
	fileConfig:write('	["freqatis"] = ' .. ZC_BRIEF_GEN["freqatis"] .. ',\n')
	fileConfig:write('	["freqclr"] = ' .. ZC_BRIEF_GEN["freqclr"] .. ',\n')
	fileConfig:write('	["freqdep"] = ' .. ZC_BRIEF_GEN["freqdep"] .. ',\n')
	fileConfig:write('	["freqgnd"] = ' .. ZC_BRIEF_GEN["freqgnd"] .. ',\n')
	fileConfig:write('	["freqtwr"] = ' .. ZC_BRIEF_GEN["freqtwr"] .. ',\n')
	fileConfig:write('	["freqaatis"] = ' .. ZC_BRIEF_GEN["freqaatis"] .. ',\n')
	fileConfig:write('	["freqapp"] =  ' .. ZC_BRIEF_GEN["freqapp"] .. ',\n')
	fileConfig:write('	["freqatwr"] = ' .. ZC_BRIEF_GEN["freqatwr"] .. ',\n')
	fileConfig:write('	["freqagnd"] = ' .. ZC_BRIEF_GEN["freqagnd"] .. '\n')
	fileConfig:write('}\n')
	fileConfig:write('\n')
	
	fileConfig:write('ZC_BRIEF_DEP = {\n')
	fileConfig:write('	["depgatestand"] = ' .. ZC_BRIEF_DEP["depgatestand"] .. ',\n')
	fileConfig:write('	["tothrust"] = ' .. ZC_BRIEF_DEP["tothrust"] .. ',\n')
	fileConfig:write('	["toflaps"] = ' .. ZC_BRIEF_DEP["toflaps"] .. ',\n')
	fileConfig:write('	["depatisinfo"] = "' .. ZC_BRIEF_DEP["depatisinfo"] .. '",\n')
	fileConfig:write('	["deprwy"] = "' .. ZC_BRIEF_DEP["deprwy"] .. '",\n')
	fileConfig:write('	["sid"] = "' .. ZC_BRIEF_DEP["sid"] .. '",\n')
	fileConfig:write('	["sidtrans"] = "' .. ZC_BRIEF_DEP["sidtrans"] .. '",\n')
	fileConfig:write('	["depbleeds"] = ' .. ZC_BRIEF_DEP["depbleeds"] .. ',\n')
	fileConfig:write('	["depaice"] = ' .. ZC_BRIEF_DEP["depaice"] .. ',\n')
	fileConfig:write('	["forcedReturn"] = ' .. ZC_BRIEF_DEP["forcedReturn"] .. ',\n')
	fileConfig:write('	["deptype"] = ' .. ZC_BRIEF_DEP["deptype"] .. ',\n')
	fileConfig:write('	["depnadp"] = ' .. ZC_BRIEF_DEP["depnadp"] .. ',\n')
	fileConfig:write('	["mintofuel"] = ' .. ZC_BRIEF_DEP["mintofuel"] .. ',\n')
	fileConfig:write('	["elevtrim"] = ' .. ZC_BRIEF_DEP["elevtrim"] .. ',\n')
	fileConfig:write('	["rwycond"] = ' .. ZC_BRIEF_DEP["rwycond"] .. ',\n')
	fileConfig:write('	["lnavvnav"] = ' .. ZC_BRIEF_DEP["lnavvnav"] .. ',\n')
	fileConfig:write('	["v1"] = ' .. ZC_BRIEF_DEP["v1"] .. ',\n')
	fileConfig:write('	["vr"] = ' .. ZC_BRIEF_DEP["vr"] .. ',\n')
	fileConfig:write('	["v2"] = ' .. ZC_BRIEF_DEP["v2"] .. ',\n')
	fileConfig:write('	["transalt"] = ' .. ZC_BRIEF_DEP["transalt"] .. ',\n')
	fileConfig:write('	["remarks"] = "' .. ZC_BRIEF_DEP["remarks"] .. '"\n')
	fileConfig:write('}\n')
	fileConfig:write('\n')

	fileConfig:write('ZC_BRIEF_APP = {\n')
	fileConfig:write('	["appatisinfo"] = "' .. ZC_BRIEF_APP["appatisinfo"] .. '",\n')
	fileConfig:write('	["dh"] = ' .. ZC_BRIEF_APP["dh"] .. ',\n')
	fileConfig:write('	["da"] = ' .. ZC_BRIEF_APP["da"] .. ',\n')
	fileConfig:write('	["arrtype"] = ' .. ZC_BRIEF_APP["arrtype"] .. ',\n')
	fileConfig:write('	["star"] = "' .. ZC_BRIEF_APP["star"] .. '",\n')
	fileConfig:write('	["startrans"] = "' .. ZC_BRIEF_APP["startrans"] .. '",\n')
	fileConfig:write('	["apprwy"] 		= "' .. ZC_BRIEF_APP["apprwy"] .. '",\n')
	fileConfig:write('	["apptype"] 	= ' .. ZC_BRIEF_APP["apptype"] .. ',\n')
	fileConfig:write('	["appbaro"] 	= ' .. ZC_BRIEF_APP["appbaro"] .. ',\n')
	fileConfig:write('	["ilsfrq"] 		= ' .. ZC_BRIEF_APP["ilsfrq"] .. ',\n')
	fileConfig:write('	["ilscrs"] 		= ' .. ZC_BRIEF_APP["ilscrs"] .. ',\n')
	fileConfig:write('	["vorfrq"]		= ' .. ZC_BRIEF_APP["vorfrq"] .. ',\n')
	fileConfig:write('	["vorcrs"]		= ' .. ZC_BRIEF_APP["vorcrs"] .. ',\n')
	fileConfig:write('	["ndbfrq"] 		= ' .. ZC_BRIEF_APP["ndbfrq"] .. ',\n')
	fileConfig:write('	["ldgflaps"] 	= ' .. ZC_BRIEF_APP["ldgflaps"] .. ',\n')
	fileConfig:write('	["autobrake"] 	= ' .. ZC_BRIEF_APP["autobrake"] .. ',\n')
	fileConfig:write('	["rwycond"] 	= ' .. ZC_BRIEF_APP["rwycond"]  .. ',\n')
	fileConfig:write('	["apppacks"] 	= ' .. ZC_BRIEF_APP["apppacks"] .. ',\n')
	fileConfig:write('	["appaice"] 	= ' .. ZC_BRIEF_APP["appaice"]  .. ',\n')
	fileConfig:write('	["apu"] 		= ' .. ZC_BRIEF_APP["apu"] 	 .. ',\n')
	fileConfig:write('	["vref"] 		= ' .. ZC_BRIEF_APP["vref"] 	 .. ',\n')
	fileConfig:write('	["vapp"] 		= ' .. ZC_BRIEF_APP["vapp"] 	 .. ',\n')
	fileConfig:write('	["gahdg"] 		= ' .. ZC_BRIEF_APP["gahdg"] 	 .. ',\n')
	fileConfig:write('	["gaalt"] 		= ' .. ZC_BRIEF_APP["gaalt"] 	 .. ',\n')
	fileConfig:write('	["translvl"] = ' .. ZC_BRIEF_APP["translvl"] .. ',\n')
	fileConfig:write('	["remarks"] = "' .. ZC_BRIEF_APP["remarks"] .. '"\n')
	fileConfig:write('}\n')
	fileConfig:close()
end

-- display the preflight countdown bottom right of the screen for debug and testing
function draw_preflight_timer()
    if gPreflightCounter <= 0 then
        return
    end
    infostring = string.format("Preflight countdown: %02.2i: %s", math.ceil(gPreflightCounter/6), gPreflightText)
    draw_string(get("sim/graphics/view/window_width")-350, 20, infostring, "white")
end
	
-- in FlyWithLua menu
add_macro("KPCrew Re-Start", "zc_init_zibocrew()")
add_macro("KPCrew Open Master Window", "zc_init_primary_window()")
add_macro("KPCrew Open Flight Info", "zc_init_flightinfo_window()")
add_macro("KPCrew Open Departure Briefing", "zc_init_depbrf_window()")
add_macro("KPCrew Open Approach Briefing", "zc_init_appbrf_window()")

-- ---------------------------------- KPCrew commands ----------------------------------
create_command("kp/crew/master_button",		"KPCrew Master Button",		"zc_master_button()", "", "")
create_command("kp/crew/secondary_button",	"KPCrew Secondary Button",	"zc_second_button()", "", "")
create_command("kp/crew/next_button",		"KPCrew Next Button",		"zc_next_button()", "", "")
create_command("kp/crew/previous_button",	"KPCrew Previous Button",	"zc_prev_button()", "", "")
create_command("kp/crew/info_window",		"KPCrew Information Window","zc_prev_button()", "", "")
create_command("kp/crew/depbrf_window",		"KPCrew Departure Window",  "zc_init_depbrf_window()", "", "")
create_command("kp/crew/appbrf_window",		"KPCrew Approach Window",   "zc_init_appbrf_window()", "", "")

-- open the flight information window on start
zc_init_primary_window(ZC_CONFIG["wnd_primary_type"])

-- monitor button input and execute current procedure
do_often("zc_proc_activities()")
-- Loop through background procedures and execute the ones which get activated
do_often("zc_proc_background()")
-- Preflight automatic, timed events get executed when the time is reached
do_sometimes("zc_preflight_countdown()")
-- count time and check flight status
do_every_draw("draw_preflight_timer()")
