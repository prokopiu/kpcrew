--[[
	*** KPCREW 2.2
	Kosta Prokopiu, October 2021
--]]

ZC_VERSION = "2.2"

-- stop if pre-reqs are not met
if not SUPPORTS_FLOATING_WINDOWS then
	logMsg("Upgrade your FlyWithLua! to NG 2.7.30+, need Floating Windows")
	return
end

-- exclude all unsupported aircraft - stop here
if (PLANE_TAILNUMBER ~= "ZB738") and (PLANE_ICAO ~= "B732") and (PLANE_ICAO ~= "B722") then
    return
end

-- local vars for multiple purpose
gLeftText = ""
gRightText = ""
gActiveProc = 1 -- index of active procedure see KC_PROCEDURES_DEFS
gProcStatus = 0 -- 0=STOP, 1=PAUSE, 3=STOP/RESET
gProcStep = 0 -- index of activity/checklist item in current procedure
gStepTimer = -1 -- gets set to seconds to wait when a delay comes with a step
gInteract = 0 -- 0 just run to next, 1=display * message and wait for master key
gActiveChecklist = nil
gShowProcList = false -- true will open window for every procedure

color_red = 0xFF0000FF
color_green = 0xFF00FF00
color_dark_green = 0xFF007f00
color_white = 0xFFFFFFFF
color_light_blue = 0xFFFFFF00
color_orange = 0xFF004FCF
color_dark_grey = 0xFF101010
color_left_display = 0xFFA0AFFF
color_ocean_blue = 0xFFEC652B

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

-- check if external lua file exists
function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then 
		io.close(f) 
		return true 
	else 
		return false 
	end
end

logMsg ( "FWL: ** Starting KPCREW version " .. ZC_VERSION .." **" )

-- get screen sizes and boundaries
gScreenWidth, gScreenHeight = XPLMGetScreenSize()
gBoundsLeft, gBoundsTop, gBoundsRight, gBoundsBottom = XPLMGetScreenBoundsGlobal()

-- ---------------------------------- local variables ------------------------------------
gConfigName = "last" -- default config name

gProcIndex = 0 -- procedure index
gProcStatus = 0 -- -1=no execution allowed 0=no procedure running  1=procedure running
gProcStep = 0 -- current procedure step in array
gProcTimer = 0 -- timer value to determine wait for step

gNameActiveProc = "KPCREW ".. ZC_VERSION .. " STARTING"
gCmdCnt = 0

gAskSecond = 0

gPreflightCounter = 0
gPreflightText = ""

-- window handles
kc_primary_wnd = 0 -- primary control window
kc_flightinfo_wnd = 0 -- flight information window
kc_checklist_wnd = 0 -- handle for checklist window

-- general options for briefings and flight information
GEN_onoff_list = {"OFF","ON"}

-- Noise Abatement departure Procedure
DEP_nadp_list = {"NOT REQUIRED","SEE SID"}
-- parking positin options
DEP_gatestand_list = {"GATE (PUSH)","STAND (PUSH)", "STAND (NO PUSH)"}
-- departure procedure types
DEP_proctype_list = {"SID","VECTORS","TRACKING"}
-- runway states
DEP_rwystate_list = {"DRY","WET","CONTAMINATED"}
-- departure packs mode
DEP_packs_list = {"ON","AUTO","OFF"}
-- forced return overweight or underweight
DEP_forced_return = {"UNDERWEIGHT", "OVERWEIGHT"}
-- push direction
DEP_push_direction = {"NO PUSH", "NOSE LEFT", "NOSE RIGHT", "NOSE STRAIGHT", "FACING NORTH", "FACING SOUTH", "FACING EAST", "FACING WEST"}

-- arrival procedure type list 
APP_proctype_list = {"STAR","VECTORS"}
-- full list of approach types can be overwritten by aircraft
APP_apptype_list = {"ILS CAT 1","ILS CAT 2 OR 3","VOR","NDB","RNAV","VISUAL","TOUCH AND GO","CIRCLING"}
-- runway state arrival
APP_rwystate_list = {"DRY","WET","CONTAMINATED"}
-- A/ICE settings
APP_aice_list = {"NOT REQUIRED","ENGINE ONLY","ENGINE AND WING"}
-- Arrival packs mode
APP_packs_list = {"ON","ON APU","OFF"}
-- APU/GPU startup after landing
APP_apu_list = {"APU delayed start","APU","GPU"}
-- Reverse Thrust
APP_rev_thrust_list = {"NONE","MINIMUM","FULL"}

WX_Cloudcover_list = {"","FEW","SCT","BKN","OVC",""}
WX_Precipitation_list = {"NONE","DRIZZLE","LIGHT RAIN","RAIN","HEAVY RAIN","SNOW"}
WX_Cloud_list = {"NO","FEW","SCATTERED","BROKEN","OVERCAST"}

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

-- load data and config related functions
require "kpcrew_data"
-- get last configuration
require "kpcrew_config"

-- check for saved last settings
if file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_config_last.lua") then 
	dofile(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_config_last.lua")
end

-- initialize a new flight
function initFlight()
	set_kpcrew_config("acf_icao",PLANE_ICAO)
	
	-- Aircraft with no icao in aircraft.cfg need to be identfied individually
	if (PLANE_TAILNUMBER == "N956OV") then	
		set_kpcrew_config("acf_icao","B146")
	end
	if (PLANE_TAILNUMBER == "PT-SSG") then	
		set_kpcrew_config("acf_icao","E170")
	end
	if (PLANE_TAILNUMBER == "PP-SSG") then	
		set_kpcrew_config("acf_icao","E195")
	end
	if (PLANE_TAILNUMBER == "E175") then	
		set_kpcrew_config("acf_icao","E175")
	end
	if (PLANE_TAILNUMBER == "C-GTLX") then	
		set_kpcrew_config("acf_icao","A346")
	end
	if (PLANE_TAILNUMBER == "A345") then	
		set_kpcrew_config("acf_icao","A345")
	end
	
	-- B738 knows, otherwise "---"
	set_kpcrew_config("flight_parkpos",kc_get_parking_position())
	
	-- pull current airport from navaid index
	next_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
--	_, _, _, _, _, _, get_kpcrew_config("flight_origin"), _ = XPLMGetNavAidInfo( next_airport_index )	
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

-- FJS Dash8
if (PLANE_ICAO == "DH8D") then
-- require "DH8D_kpcrew"
end

-- JD A340-500
if (PLANE_TAILNUMBER == "A345") then	
-- require "A345_kpcrew"
end

-- ToLiss A340-600
if (PLANE_TAILNUMBER == "C-GTLX") then
-- require "A346_kpcrew"
end

-- Felis B747-200
if (PLANE_ICAO == "B742") then
-- require "B742_kpcrew"
end

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
--	,["DH8D"] = DH8D
--	,["A345"] = A345
--	,["DH8D"] = A346
--	,["B742"] = B742

}
GENERAL_Acf = Your_Hangar_List[get_kpcrew_config("acf_icao")]

-- checklist functionality
require "kpcrew_checklists"

-- initialize a new flight
initFlight()

--- action buttons on main window

-- actions when pressing the master button
function kc_master_button()

	-- if gProcStatus 0 then initiate the current procedure 
	if gProcStatus == 0 then
		if KC_PROCEDURES_DEFS[gActiveProc]["mode"] == "p" or KC_PROCEDURES_DEFS[gActiveProc]["mode"] == "b" then
			kc_procedure_reset(KC_PROCEDURES_DEFS[gActiveProc])
		end
		gProcStatus = 1
		gProcStep = 1
	else
		if gProcStatus == 1 then
			local lCurr_proc = KC_PROCEDURES_DEFS[gActiveProc]
			local lCurr_step = lCurr_proc[gProcStep]
			if lCurr_step["ask"] == 1 then
				lCurr_step["ask"] = 0
			end
		end
	end
end

function kc_pause_button()
	if gProcStatus == 1 then
		gProcStatus = 2
	else
		if gProcStatus == 2 then
			gProcStatus = 1
		end
	end
end

-- actions when pressing the secondary button
function kc_stop_button()

	if gProcStatus > 0 then
		gProcStatus = 3
	end

end	

-- actions when pressing the next button
function kc_next_button()
	if gProcStatus == 0 then
		if gActiveProc < #KC_PROCEDURES_DEFS then
			gActiveProc = gActiveProc + 1
		end
	end
	if gProcStatus > 0 then
		if gProcStep < #KC_PROCEDURES_DEFS[gActiveProc] then
			gProcStep = gProcStep + 1
		end
	end	
end

-- actions when pressing the previous button
function kc_prev_button()
	if gProcStatus == 0 and gActiveProc > 1 then
		gActiveProc = gActiveProc - 1
	end
	if gProcStatus > 0 then
		if gProcStep > 1 then
			gProcStep = gProcStep - 1
		end
	end	
end

-- actions when pressing the @ button
function kc_info_button()
	kc_set_background_proc_status("OPENINFOWINDOW",1)
end

---- window system and related functions
require "kpcrew_imgui"

-- initialize kpcrew, can be called from FwL menu
function kc_init_kpcrew()

	-- new proc stuff
	gActiveProc = 1
	gProcStatus = 0
	gProcStep = 0

end

-- reset a checklist
function kc_checklist_reset(checklist)
	for loopitem=1,#checklist do
		curritem = checklist[loopitem]
		if curritem ~= nil then
			curritem["chkl_state"] = false
			if curritem["interactive"] == 1 then
				curritem["ask"] = 1
				curritem["spoken2"] = false
			else
				curritem["ask"] = 0
				curritem["spoken2"] = true
			end
			curritem["spoken"] = false
		end
		loopitem = loopitem + 1
	end
end

-- reset a checklist
function kc_procedure_reset(checklist)
	for loopitem=1,#checklist do
		curritem = checklist[loopitem]
		if curritem ~= nil then
 		    curritem["chkl_color"] = color_white
			if curritem["interactive"] == 1 then
				curritem["ask"] = 1
			else
				curritem["ask"] = 0
			end
			curritem["spoken"] = false
			curritem["validated"] = 0
		end
		loopitem = loopitem + 1
	end
end

-- new procedure and checklist handling
-- gActiveProc contains the index of the selected KC_xxx procedure
-- information about the procedure all in the data structure
function kc_proc_activities()

	local lCurr_proc = KC_PROCEDURES_DEFS[gActiveProc]
	-- get active step from active procedure
	local lCurr_step = lCurr_proc[gProcStep]

	gRightText = string.format("%02d: %s", gActiveProc, lCurr_proc["name"])
	
	-- lProcStatus is the external trigger that a procedure should run 0=stop, no procedure
	if gProcStatus == 1 and lCurr_proc ~= nil and lCurr_step ~= nil then

		-- always open checklist window and keep opening it if closed
		if lCurr_proc["mode"] == "c" and kc_checklist_wnd == 0 then
			gActiveChecklist = lCurr_proc
			kc_open_checklist(lCurr_proc,gProcStep==1)
		end

		-- open procedure window only when turned on
		if lCurr_proc["mode"] == "p" and kc_checklist_wnd == 0 and gShowProcList then
			gActiveChecklist = lCurr_proc
			kc_open_procedure(lCurr_proc,gProcStep==1)
		end

		if lCurr_proc["mode"] == "b" and kc_checklist_wnd == 0 then
			gActiveChecklist = lCurr_proc
			kc_open_procedure(lCurr_proc,gProcStep==1)
		end

		-- logic which makes the step being skipped without further activity
		if lCurr_step["skip"] ~= nil and lCurr_step["skip"]() then
			gProcStep = gProcStep + 1
			lCurr_step["chkl_color"] = color_green
			return
		end
		
		-- when an interactive step display * and blink orange white
		local lStar = ""
		if lCurr_step["interactive"] == 1 then
			lStar = "* "
			lCurr_step["chkl_color"] = color_orange
		end
		
		-- in checklist mode build checklist line from item and response or display function with dynamic values
		if lCurr_proc["mode"] == "c" then
			if lCurr_step["display"] ~= nil and lCurr_step["display"]() ~= "" then
				gLeftText = lStar .. lCurr_step["actor"] .. " " .. lCurr_step["chkl_item"] .. " | " .. lCurr_step["display"]()
			else
				gLeftText = lStar .. lCurr_step["actor"] .. " " .. lCurr_step["chkl_item"] .. " | " .. lCurr_step["chkl_response"]
			end
		else
			if lCurr_step["display"] ~= nil and lCurr_step["display"]() ~= "" then
				gLeftText = lStar .. lCurr_step["display"]()
			else
				gLeftText = lStar .. lCurr_step["activity"]
			end
		end

		-- continue with steps
		-- type activity (switch things in the cockpit)
		if lCurr_step["actions"] ~= nil then
			-- if lCurr_proc["mode"] == "c" then
				-- if get_kpcrew_config("config_complexity") and lCurr_step["validated"] == 0 then
					-- lCurr_step["actions"]()
					-- lCurr_step["validated"] = 1
				-- end
			-- end
--			if lCurr_proc["mode"] == "p" then
				if get_kpcrew_config("config_complexity") and lCurr_step["validated"] == 0 then
					lCurr_step["actions"]()
					lCurr_step["validated"] = 1
				end
--			end
		end -- execute actions
		
		-- speak text if function added and returning a string
		if lCurr_step["speak"] ~= nil and lCurr_step["speak"]() ~= "" and lCurr_step["spoken"] == false then
			speakNoText(0,lCurr_step["speak"]())
			lCurr_step["spoken"] = true
		end

		if lCurr_step["speak"] == nil and lCurr_step["spoken"] == false then
			speakNoText(0,lCurr_step["chkl_item"])
			lCurr_step["spoken"] = true
		end

		-- optionally speak the answer - can be prevented by returning an empty " " string
		if lCurr_step["answer"] ~= nil and lCurr_step["answer"]() ~= "" and lCurr_step["spoken2"] == false and lCurr_step["ask"] == 0 then
			speakNoText(0,lCurr_step["answer"]())
			lCurr_step["spoken2"] = true
		end

		if lCurr_step["answer"] == nil and lCurr_step["spoken2"] == false and lCurr_step["ask"] == 0 then
			speakNoText(0,lCurr_step["chkl_response"])
			lCurr_step["spoken2"] = true
		end

		if lCurr_step["ask"] ~= nil and lCurr_step["ask"] ~= 0 then
			return
		end

		-- if step has a wait set the gStepTimer otherwise clear it.
		if lCurr_step["wait"] ~= nil and lCurr_step["wait"] > 0 and gStepTimer == -1 then
			gStepTimer = 0
			if lCurr_step["interactive"] ~= 1 then
				lCurr_step["spoken2"] = false
			end
		end

		-- all next steps have to wait until we are through the timer
		if lCurr_step["wait"] ~= nil and lCurr_step["wait"] > 0 and gStepTimer > -1 and gStepTimer < lCurr_step["wait"] then
			gStepTimer = gStepTimer + 1
--			return
		else
			gStepTimer = -1
			lCurr_step["chkl_color"] = color_green
			gProcStep = gProcStep + 1
			if lCurr_step["chkl_state"] ~= nil then 
				lCurr_step["chkl_state"] = true
			end
		end

		-- when not last step next step
		if lCurr_step["end"] == 0 then 
			if gStepTimer > -1 and gStepTimer < lCurr_step["wait"] then
				--
			else
				gStepTimer = -1
				if lCurr_step["chkl_state"] ~= nil then 
					lCurr_step["chkl_state"] = true
				end
				lCurr_step["chkl_color"] = color_green
				gProcStep = gProcStep + 1
			end
		else
			-- end procedure activities
			kc_set_background_proc_status("CLOSECHKLWINDOW",1)
			gStepTimer = -1
			gProcStep = 0
			gProcStatus = 0
			if gActiveProc < #KC_PROCEDURES_DEFS - 2 then
				gActiveProc = gActiveProc + 1
			else
				gActiveProc = 1
			end
		end -- end==1

	end -- procstatus 1

	-- if lProcStatus == 2 then pause the active procedure/checklist to be continued later.
	if gProcStatus == 2 and lCurr_proc ~= nil then
		-- 
	end
	
	-- if lProcStatus == 3 then stop the current procedure/checklist and reset completely
	if gProcStatus == 3 then
			-- end procedure activities
			if lCurr_proc["mode"] == "c" then
				kc_set_background_proc_status("CLOSECHKLWINDOW",1)
			end
			gStepTimer = -1
			gProcStep = 0
			gProcStatus = 0
			if gActiveProc < #KC_PROCEDURES_DEFS - 2 then
				gActiveProc = gActiveProc + 1
			else
				gActiveProc = 1
			end
			gLeftText = "CHECKLIST/PROCEDURE STOPPED"
			
	end

	-- if lProcStatus == 4 then skip one step and PAUSE
	if gProcStatus == 4 and lCurr_proc ~= nil then
		-- forward
		gProcStep = gProcStep + 1
		-- set procedure on pause
		gProcStatus = 2
		gStepTimer = -1
	end
	
	-- if lProcStatus == 5 then move one step back (in interactive or during pause)
	if gProcStatus == 4 and lCurr_proc ~= nil and gProcStep > 1 then
		-- back
		gProcStep = gProcStep - 1
		-- set procedure on pause
		gProcStatus = 2
		gStepTimer = -1
	end
	
end

-- set the statis of a procedure
function kc_set_background_proc_status(procedure, status)
	KC_BACKGROUND_PROCS[procedure].status=status
end

function kc_get_background_proc_status(procedure)
	return KC_BACKGROUND_PROCS[procedure].status
end

-- scan through the background procedure array and execute the actions() 
function kc_proc_background()
	for step in pairs(KC_BACKGROUND_PROCS) do 
		currStep = KC_BACKGROUND_PROCS[step]
		if (currStep["status"] > 0) then
			currStep["actions"]()
		end
	end
end

-- in FlyWithLua menu
add_macro("KPCrew Re-Start", "kc_init_kpcrew()")
add_macro("KPCrew Open Master Window", "kc_init_primary_window()")
add_macro("KPCrew Open Flight Info", "kc_init_flightinfo_window()")

-- ---------------------------------- KPCrew commands ----------------------------------
create_command("kp/crew/master_button",		"KPCrew Master Button",		"kc_master_button()", "", "")
create_command("kp/crew/secondary_button",	"KPCrew Secondary Button",	"kc_pause_button()", "", "")
create_command("kp/crew/next_button",		"KPCrew Next Button",		"kc_next_button()", "", "")
create_command("kp/crew/previous_button",	"KPCrew Previous Button",	"kc_prev_button()", "", "")
create_command("kp/crew/info_window",		"KPCrew Information Window","kc_init_flightinfo_window()", "", "")

-- open the flight information window on start
kc_init_primary_window(get_kpcrew_config("wnd_primary_type"))
-- kc_init_flightinfo_window()

-- monitor button input and execute current procedure
do_often("kc_proc_activities()")
-- Loop through background procedures and execute the ones which get activated
do_often("kc_proc_background()")
