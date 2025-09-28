--[[
	*** KPxBRIEF 1.0
	Simbrief based briefing on steroids
	Kosta Prokopiu, July 2025
--]]

require "kpcrew.genutils"
require "kpcrew.basicmodules"
require "kpcrew.kxbutils"

kc_VERSION = "2.3-alpha11"
kc_simversion = get("sim/version/xplane_internal_version")

logMsg ( "FWL: ** Starting KPxBrief version " .. kc_VERSION .. " on XP " .. kc_simversion .. " **" )

local color_white = 0xFFCCCCCC
local color_orange = 0xFF1b9af8
local color_yellow = 0xFF00FFFF
local color_green = 0xFF95C857

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)
kc_acf_icao = kc_get_matching_icao_code()
logMsg("ICAO: "..kc_acf_icao)

if kc_file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\" .. kc_acf_icao .. ".preferences") then
	getActivePrefs():load()
end

kb_font_scale = 1.0

-- initialize briefing window
function kb_init_brief_window()
    local wndWidth =  970 * kb_font_scale
    local wndHeight = 860 * kb_font_scale
    fontScale1 = 1
    angle=1
    fontScale = 1
	
    kb_brief_wnd = float_wnd_create(wndWidth, wndHeight, 1, true)
    float_wnd_set_title(kb_brief_wnd, "KPxBrief " .. kc_VERSION)
    float_wnd_set_imgui_builder(kb_brief_wnd, "kb_brief_builder")
    float_wnd_set_onclose(kb_brief_wnd, "kb_hide_brief_wnd")
end

-- Hide the briefing window
function kb_hide_brief_wnd(wnd)
    if kb_brief_wnd then
        float_wnd_destroy(kb_brief_wnd)
    end
end

-- Toggle the briefing window
kb_show_only_once = 0
kb_hide_only_once = 0
function kb_brief_toggle_wnd()
    kb_show_brief = not kb_show_brief
    if kb_show_brief then
        if kb_show_only_once == 0 then
            kb_init_brief_window()
            kb_show_only_once = 1
            kb_show_only_once = 0
        end
    else
        if kb_hide_only_once == 0 then
            kb_hide_brief_wnd()
            kb_hide_only_once = 1
            kb_hide_only_once = 0
        end
    end
end

origmetar = ""
destmetar = ""
altnmetar = ""

origtranslvl = 0
desttransalt = 0
altntransalt = 0

local xml2lua = require("kpcrew/xml2lua")
local handler = require("kpcrew/xmlhandler.tree")

-- load the XML from the Simbrief API
function kb_load_simbrief_ofp()
    if activePrefSet:get("general:simbriefuser") then
        local xml = ""
        local http = require("socket.http")
        local xml, result = http.request("http://www.simbrief.com/api/xml.fetcher.php?username=" .. activePrefSet:get("general:simbriefuser"))
		-- 200 means success
        if result == 200 then
			local f = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\simbrief.xml", "w+")
			f:write(xml)
			f:close()
		end
	end
end

local wunit = "KG"

-- extract the data from the Simbrief XML
function kb_extract_simbrief_ofp()
	-- latest OFP gets stored in kpcrew_prefs folder as simbrief.xml
	local xmlfile = xml2lua.loadFile(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\simbrief.xml")
	local parser = xml2lua.parser(handler)
	parser:parse(xmlfile)

	-- initialize OFP record and scan the downloaded XML file
	activeBriefings:set("flight:callsign",handler.root.OFP.atc.callsign)
	activeBriefings:set("flight:flightnumber",handler.root.OFP.general.flight_number)
	if handler.root.OFP.general.icao_airline == nil then
		handler.root.OFP.general.icao_airline = ""
	end
	-- activeBriefings:set("flight:airline",handler.root.OFP.general.icao_airline)
	activeBriefings:set("flight:planrwy",handler.root.OFP.origin.plan_rwy)
	activeBriefings:set("flight:originIcao",handler.root.OFP.origin.icao_code)
	activeBriefings:set("flight:originIata",handler.root.OFP.origin.iata_code)
	activeBriefings:set("flight:originRegion",handler.root.OFP.origin.icao_region)
	activeBriefings:set("flight:originName",handler.root.OFP.origin.name)
	activeBriefings:set("flight:destinationIcao",handler.root.OFP.destination.icao_code)
	activeBriefings:set("flight:destinationIata",handler.root.OFP.destination.iata_code)
	activeBriefings:set("flight:destinationRegion",handler.root.OFP.destination.icao_region)
	activeBriefings:set("flight:destinationName",handler.root.OFP.destination.name)
	activeBriefings:set("flight:destrwy",handler.root.OFP.destination.plan_rwy)
	activeBriefings:set("flight:altnrwy",handler.root.OFP.alternate.plan_rwy)
	activeBriefings:set("flight:alternateIcao",handler.root.OFP.alternate.icao_code)
	activeBriefings:set("flight:alternateIata",handler.root.OFP.alternate.iata_code)
	activeBriefings:set("flight:alternateRegion",handler.root.OFP.alternate.icao_region)
	activeBriefings:set("flight:alternateName",handler.root.OFP.alternate.name)
	activeBriefings:set("flight:route",handler.root.OFP.atc.route)
	activeBriefings:set("flight:costIndex",handler.root.OFP.general.costindex)
	activeBriefings:set("flight:routedistance",handler.root.OFP.general.route_distance)
	activeBriefings:set("flight:airdistance",handler.root.OFP.general.air_distance)
	activeBriefings:set("flight:cruiseLevel",handler.root.OFP.general.initial_altitude)
	activeBriefings:set("flight:averageWind",handler.root.OFP.general.avg_wind_dir .. "/" .. handler.root.OFP.general.avg_wind_spd)
	activeBriefings:set("flight:averageWC",handler.root.OFP.general.avg_wind_comp)
	activeBriefings:set("flight:averageISA",handler.root.OFP.general.avg_temp_dev)
	activeBriefings:set("flight:tripFuel",handler.root.OFP.fuel.enroute_burn)
	activeBriefings:set("flight:minimumTakeoff",handler.root.OFP.fuel.min_takeoff)
	activeBriefings:set("flight:reserve",handler.root.OFP.fuel.reserve)
	activeBriefings:set("flight:reserveTime",os.date("!%H%M",handler.root.OFP.fuel.reserve))
	activeBriefings:set("flight:alternateBurn",handler.root.OFP.fuel.alternate_burn)
	activeBriefings:set("flight:takeoffFuel",handler.root.OFP.fuel.plan_ramp)
	activeBriefings:set("flight:averageFF",handler.root.OFP.fuel.avg_fuel_flow)
	activeBriefings:set("flight:cargoWeight",handler.root.OFP.weights.cargo)
	activeBriefings:set("flight:payload",handler.root.OFP.weights.payload)
	activeBriefings:set("flight:zfw",handler.root.OFP.weights.est_zfw)
	activeBriefings:set("flight:tow",handler.root.OFP.weights.est_tow)
	activeBriefings:set("flight:ldw",handler.root.OFP.weights.est_ldw)
	activeBriefings:set("flight:maxzfw",handler.root.OFP.weights.max_zfw)
	activeBriefings:set("flight:maxtow",handler.root.OFP.weights.max_tow)
	activeBriefings:set("flight:maxldw",handler.root.OFP.weights.max_ldw)
	activeBriefings:set("flight:tropopause",handler.root.OFP.general.avg_tropopause)
	activeBriefings:set("flight:deptimezone",handler.root.OFP.times.orig_timezone)
	activeBriefings:set("flight:arrtimezone",handler.root.OFP.times.dest_timezone)
	activeBriefings:set("flight:depdate",string.upper(os.date("!%d%b%y",handler.root.OFP.times.sched_out)))
	activeBriefings:set("flight:deptime",os.date("!%H%M",handler.root.OFP.times.sched_out))
	activeBriefings:set("flight:arrtime",os.date("!%H%M",handler.root.OFP.times.sched_in))
	activeBriefings:set("flight:estdeptime",os.date("!%H%M",handler.root.OFP.times.est_out))
	activeBriefings:set("flight:estarrtime",os.date("!%H%M",handler.root.OFP.times.est_in))
	activeBriefings:set("flight:estairtime",os.date("!%H%M",handler.root.OFP.times.est_time_enroute))
	activeBriefings:set("flight:airtime",os.date("!%H%M",handler.root.OFP.times.sched_time_enroute))
	activeBriefings:set("flight:estblocktime",os.date("!%H%M",handler.root.OFP.times.est_block))
	activeBriefings:set("flight:blocktime",os.date("!%H%M",handler.root.OFP.times.sched_block))
	activeBriefings:set("flight:taxiouttime",os.date("!%H%M",handler.root.OFP.times.taxi_out))
	activeBriefings:set("flight:taxiintime",os.date("!%H%M",handler.root.OFP.times.taxi_in))
	activeBriefings:set("flight:cruiseprofile",handler.root.OFP.general.cruise_profile)
	activeBriefings:set("flight:cruisemach",handler.root.OFP.general.cruise_mach)
	activeBriefings:set("flight:cruisetas",handler.root.OFP.general.cruise_tas)
	activeBriefings:set("flight:climbprofile",handler.root.OFP.general.climb_profile)
	activeBriefings:set("flight:descentprofile",handler.root.OFP.general.descent_profile)
	activeBriefings:set("flight:stepclimb",handler.root.OFP.general.stepclimb_string)
	activeBriefings:set("flight:paxcount",handler.root.OFP.weights.pax_count)
	activeBriefings:set("flight:paxweight",handler.root.OFP.weights.pax_weight)
	activeBriefings:set("flight:rampweight",handler.root.OFP.weights.est_ramp)
	activeBriefings:set("flight:fuelplanldg",handler.root.OFP.fuel.plan_landing)
	activeBriefings:set("flight:mindiversion",handler.root.OFP.fuel.plan_landing)
	activeBriefings:set("flight:conttime",handler.root.OFP.general.cont_rule)
	activeBriefings:set("flight:altnete",os.date("!%H%M",handler.root.OFP.alternate.ete))
	activeBriefings:set("flight:taxifuel",handler.root.OFP.fuel.taxi)
	activeBriefings:set("flight:endurance",os.date("!%H%M",handler.root.OFP.times.endurance))	
	activeBriefings:set("flight:extrafuel",handler.root.OFP.fuel.extra)
	activeBriefings:set("flight:extratime",os.date("!%H%M",handler.root.OFP.times.extrafuel_time))	

	activeBriefings:set("flight:planblockfuel",handler.root.OFP.fuel.plan_ramp + handler.root.OFP.fuel.extra_optional + handler.root.OFP.fuel.extra_required)
	activeBriefings:set("flight:planblocktime",os.date("!%H%M",handler.root.OFP.times.endurance + handler.root.OFP.times.extrafuel_time))	
	activeBriefings:set("flight:pilotextra",handler.root.OFP.fuel.extra_optional)
	
	wunit = string.sub(string.upper(handler.root.OFP.params.units),1,2)

-- departure 
	if (#handler.root.OFP.general.sid_ident > 0) then
		activeBriefings:set("departure:deproute",handler.root.OFP.general.sid_ident)
		activeBriefings:set("departure:deptype",1)
	else
		activeBriefings:set("departure:deproute","n.a.")
		activeBriefings:set("departure:deptype",2)
	end
	if (#handler.root.OFP.general.sid_trans > 0) then
		activeBriefings:set("departure:deptransition",handler.root.OFP.general.sid_trans)
	else
		activeBriefings:set("departure:deptransition","n.a.")
	end
	activeBriefings:set("departure:aptElevation",handler.root.OFP.origin.elevation)
	activeBriefings:set("departure:transalt",handler.root.OFP.origin.trans_alt)
	activeBriefings:set("departure:initAlt",handler.root.OFP.general.initial_altitude)
	
	if handler.root.OFP.tlr.takeoff ~= nil then
		local runways = handler.root.OFP.tlr.takeoff.runway
		for i=1,#runways do
			if runways[i].identifier == activeBriefings:get("flight:planrwy") then
				activeBriefings:set("departure:initHeading",runways[i].magnetic_course)
				activeBriefings:set("departure:nav1Course",runways[i].magnetic_course)
				activeBriefings:set("departure:nav2Course",runways[i].magnetic_course)
				activeBriefings:set("takeoff:v1",runways[i].speeds_v1)
				activeBriefings:set("takeoff:vr",runways[i].speeds_vr)
				activeBriefings:set("takeoff:v2",runways[i].speeds_v2)
				activeBriefings:set("takeoff:rwylength",runways[i].length)
				activeBriefings:set("takeoff:tora",runways[i].length_tora)
				
				if runways[i].bleed_setting ~= "OFF" then
					activeBriefings:set("takeoff:bleeds",2)
				else
					activeBriefings:set("takeoff:bleeds",1)
				end
				if runways[i].anti_ice_setting == "OFF" then
					activeBriefings:set("takeoff:antiice",1)
				end
				if runways[i].anti_ice_setting == "ENGINE" then
					activeBriefings:set("takeoff:antiice",2)
				end
				if runways[i].anti_ice_setting == "ENGINE & WING" then
					activeBriefings:set("takeoff:antiice",3)
				end

				if handler.root.OFP.tlr.takeoff.conditions.surface_condition == "dry" then
					activeBriefings:set("departure:rwyCond",1)
				else
					activeBriefings:set("departure:rwyCond",2)
				end

				if runways[i].thrust_setting == "FLEX" then
					activeBriefings:set("takeoff:thrust",2)
					if #runways[i].flex_temperature == 0 then
						activeBriefings:set("takeoff:flextemp",15)
					else
						activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
					end
				else
					activeBriefings:set("takeoff:thrust",3)
					if #runways[i].flex_temperature == 0 then
						activeBriefings:set("takeoff:flextemp",15)
					else
						activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
					end
				end

				activeBriefings:set("takeoff:hw",runways[i].headwind_component)
				activeBriefings:set("takeoff:cw",runways[i].crosswind_component)
			end
		end
	else
		activeBriefings:set("departure:initHeading",000)
		activeBriefings:set("departure:nav1Course",1)
		activeBriefings:set("departure:nav2Course",1)
		activeBriefings:set("takeoff:v1",100)
		activeBriefings:set("takeoff:vr",100)
		activeBriefings:set("takeoff:v2",100)
		activeBriefings:set("takeoff:rwylength",-1)
		activeBriefings:set("takeoff:tora",-1)
		activeBriefings:set("takeoff:bleeds",2)
		activeBriefings:set("takeoff:antiice",2)
		activeBriefings:set("departure:rwyCond",1)
		activeBriefings:set("takeoff:thrust",2)
		activeBriefings:set("takeoff:flextemp",15)
		activeBriefings:set("takeoff:hw",0)
		activeBriefings:set("takeoff:cw",0)		
	end
	
	origtranslvl = handler.root.OFP.origin.trans_level

-- arrival
	if (#handler.root.OFP.general.star_ident > 0) then
		activeBriefings:set("arrival:arrroute",handler.root.OFP.general.star_ident)
		activeBriefings:set("arrival:arrroute",handler.root.OFP.general.star_ident)
		activeBriefings:set("arrival:arrType",1)
	else
		activeBriefings:set("arrival:arrroute","n.a.")
		activeBriefings:set("arrival:arrType",2)
	end
	if (#handler.root.OFP.general.star_trans > 0) then
		activeBriefings:set("arrival:arrtransition",handler.root.OFP.general.star_trans)
	else
		activeBriefings:set("arrival:arrtransition","n.a.")
	end
	activeBriefings:set("arrival:translvl",handler.root.OFP.destination.trans_level)
	activeBriefings:set("arrival:aptElevation",handler.root.OFP.destination.elevation)
	activeBriefings:set("arrival:alttranslvl",handler.root.OFP.alternate.trans_level)
	desttransalt = handler.root.OFP.destination.trans_alt
	altntransalt = handler.root.OFP.alternate.trans_alt
	
	if handler.root.OFP.tlr.landing ~= nil then
		local runways2 = handler.root.OFP.tlr.landing.runway
		for i=1,#runways2 do
			if runways2[i].identifier == activeBriefings:get("flight:destrwy") then
				activeBriefings:set("approach:nav1Course",runways2[i].magnetic_course)
				activeBriefings:set("approach:nav2Course",runways2[i].magnetic_course)
				activeBriefings:set("approach:gaheading",runways2[i].magnetic_course)
				if #runways2[i].ils_frequency == 0 then
					activeBriefings:set("approach:nav1Freq","---.--")
				else
					activeBriefings:set("approach:nav1Freq",runways2[i].ils_frequency)
				end

				if handler.root.OFP.tlr.landing.conditions.surface_condition == "dry" then
					activeBriefings:set("arrival:rwyCond",1)
					activeBriefings:set("approach:vref",handler.root.OFP.tlr.landing.distance_dry.speeds_vref)
					activeBriefings:set("approach:vapp",activeBriefings:get("approach:vref")+5)
				else
					activeBriefings:set("arrival:rwyCond",2)
					activeBriefings:set("approach:vref",handler.root.OFP.tlr.landing.distance_wet.speeds_vref)
					activeBriefings:set("approach:vapp",activeBriefings:get("approach:vref")+5)
				end
				
				activeBriefings:set("approach:rwylength",runways2[i].length)
				activeBriefings:set("approach:lda",runways2[i].length_lda)
				activeBriefings:set("approach:hw",runways2[i].headwind_component)
				activeBriefings:set("approach:cw",runways2[i].crosswind_component)
			end
		end	
	else
		activeBriefings:set("approach:nav1Course",1)
		activeBriefings:set("approach:nav2Course",1)
		activeBriefings:set("approach:gaheading",1)
		activeBriefings:set("approach:nav1Freq","---.--")
		activeBriefings:set("arrival:rwyCond",1)
		activeBriefings:set("approach:vref",100)
		activeBriefings:set("approach:vapp",100)
		activeBriefings:set("approach:rwylength",-1)
		activeBriefings:set("approach:lda",-1)
		activeBriefings:set("approach:hw",0)
		activeBriefings:set("approach:cw",0)
	end
	
-- general
	activeBriefings:set("arrival:altnElevation",handler.root.OFP.alternate.elevation)
	
-- set the metars from x-plane as default
	if activePrefSet:get("general:askyMetar") then
		origmetar = kb_get_asky_metar(handler.root.OFP.origin.icao_code)
		destmetar = kb_get_asky_metar(handler.root.OFP.destination.icao_code)
		altnmetar = kb_get_asky_metar(handler.root.OFP.alternate.icao_code)
	else
		origmetar = kb_get_xp_metar(handler.root.OFP.origin.icao_code)
		destmetar = kb_get_xp_metar(handler.root.OFP.destination.icao_code)
		altnmetar = kb_get_xp_metar(handler.root.OFP.alternate.icao_code)
	end
end

-- pull the METAR from XP's METAR.wx when on real weather
-- sim/weather/use_real_weather_bool
function kb_get_xp_metar(icao)

    if not icao then 
		return ""-- NO ICAO --" 
	end
	
	metarpath = "no"
	
	if kc_simversion > 120000 then
		latestwxfile = kb_get_latest_filename(SYSTEM_DIRECTORY .. "Output\\real weather\\metar*")
		if latestwxfile == nil then 
			return "-- NO FILE --"
		end
		metarpath = SYSTEM_DIRECTORY .. "Output\\real weather\\" .. latestwxfile
	else
		metarpath = SYSTEM_DIRECTORY .. "METAR.rwx"
	end
	
	-- logMsg ("File: " .. metarpath)

    if not kc_file_exists(metarpath) then 
		return "-- NO FILE --" 
	end

    local words = {}
    --we read the lines
    if icao then
        for line in io.lines(metarpath) do
            if line then
                words[1] = line:match("(%w+)(.+)")
                if words[1] == icao then
                    wx = line
                    break
                end
            end 
        end 
        if wx == nil then 
			return "-- NO DATA -- "
		end
		return wx
    else
        return "-- NO ICAO --"
    end
end 

-- pull the METAR from Active Sky's file 
function kb_get_asky_metar(icao)

    if not icao then 
		return ""-- NO ICAO --" 
	end
	
	metarpath = "no"
	
	if kc_simversion > 120000 then
		metarpath = os.getenv("APPDATA") .. "\\HiFi\\AS_XPL12\\Weather\\current_wx_snapshot.txt"
	else
		metarpath = os.getenv("APPDATA") .. "\\HiFi\\AS_XPL\\Weather\\current_wx_snapshot.txt"
	end
	
	-- logMsg ("File: " .. metarpath)

    if not kc_file_exists(metarpath) then 
		return "-- NO DATA --" 
	end

    local words = {}
    --we read the lines
    if icao then
        for line in io.lines(metarpath) do
            if line then
                words[1] = line:match("(%w+)(.+)")
                if words[1] == icao then
                    wx = line
                    break
                end
            end 
        end 
        if wx == nil then 
			return "-- NO DATA -- "
		end
		startindex, endindex = string.find(wx, ":"..icao, 7)
		if startindex ~= nil then
			return string.sub(wx,7,startindex-2)
		else
			return "-- NO DATA --"
		end
    else
        return "-- NO ICAO --"
    end
end 

kb_extract_simbrief_ofp()

function kb_brief_builder(kb_brief_wnd, x, y)

    field_size = 130
    -- imgui.PushItemWidth(field_size)
		local win_width = imgui.GetWindowWidth()
		local win_height = imgui.GetWindowHeight()
		imgui.SetWindowFontScale(kb_font_scale)
	
-- +----------+ +--------------+ +----------+ +----------+ +----------+
-- | SIMBRIEF | |briefingname  | |   LOAD   | |   SAVE   | |  CLOSE   |
-- +----------+ +--------------+ +----------+ +----------+ +----------+
-- ---------------------------------------------------------------------------------------

-- Load latest simbrief flight plan
    -- imgui.PushItemWidth(field_size)
	kxb_scaled_button("simbriefbtn","SIMBRIEF",70,13,
		function () kb_load_simbrief_ofp() kb_extract_simbrief_ofp() end )

-- Load/Save current briefing under filename in this field
	imgui.SameLine()
	imgui.PushID("SaveBriefing:")
		imgui.PushItemWidth(100*kb_font_scale)
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				local changed, textin = imgui.InputText("", activeBriefings:getFilename(), 255)
				if changed then
					activeBriefings:setFilename(textin)
				end
			imgui.PopStyleColor()
		imgui.PopItemWidth()
	imgui.PopID()

	imgui.SameLine()
	kxb_scaled_button("loadbtn","LOAD",70,13,
		function () activeBriefings:load() end )
	imgui.SameLine()
	kxb_scaled_button("savebtn","SAVE",70,13,
		function () activeBriefings:save() end )

-- Close the briefing window
	imgui.SameLine()
	kxb_scaled_button("closebtn","CLOSE",70,13,
		function () kb_hide_brief_wnd() end )		

    -- imgui.PopItemWidth()

    imgui.Separator()
-- ---------------------------------------------------------------------------------------
-- XP: <vvvvvv> Flight State: <State of SOP> Aircraft Type: <type> [XP ICAO: <XXXX>]
	kxb_label_white("XP:")
    imgui.SameLine()
	kxb_label_yellow(activeBckVars:get("general:simversion"))
    imgui.SameLine()
	kxb_label_white("Flight State:")
    imgui.SameLine()
	kxb_label_yellow(kcSopFlightPhase[math.abs(activeBckVars:get("general:flight_state"))])
    imgui.SameLine()
	kxb_label_white("Aircraft Type:")
    imgui.SameLine()
	kxb_label_green(kc_acf_name .. " - " .. kc_acf_icao .. " [XP ICAO: " .. PLANE_ICAO .. "]")
    imgui.Separator()
-- ---------------------------------------------------------------------------------------
-- Position: <99o41'14" N - 9o11'35" E/N99999 E99999> | Elevation <9999 ft> | Time: <99:99:99> / <99:99:99Z>
	kxb_label_white("Position:")
    imgui.SameLine()
	kxb_label_green(kc_convertDMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")) .. "/" ..
		kc_convertINS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")))
    imgui.SameLine()
	kxb_label_white("| Elevation:")
    imgui.SameLine()
	kxb_label_green(string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector")))
    imgui.SameLine()
	kxb_label_white("| Time:")
    imgui.SameLine()
	kxb_label_green(kc_dispTimeFull(get("sim/time/zulu_time_sec")) .. "Z / " .. kc_dispTimeFull(get("sim/time/local_time_sec")))
    imgui.SameLine()
	kxb_label_white("DATE:")
	imgui.SameLine()
	kxb_label_green(activeBriefings:get("flight:depdate"))
    imgui.Separator()
-- ---------------------------------------------------------------------------------------
-- Flight: <XXX999> | Origin: XXXX | Destination: XXXX | Alternate: XXXX | First Flight of day... | Battery Only...
-- Flight Times: Off Blocks: S ==:== C | Out: S ==:== C | In: S ==:== C | On Blocks: S ==:== C RST

	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0)
	kxb_label_white("*Flight:")
    imgui.SameLine()
	kxb_orange_text_field_rw(60,"callsign","flight:callsign",10)
    imgui.SameLine()
	kxb_label_white("| *Departure:")
    imgui.SameLine()
	kxb_orange_text_field_rw(38,"originicao","flight:originIcao",6)
    imgui.SameLine()
	kxb_label_white("| *Arrival:")
    imgui.SameLine()
	kxb_orange_text_field_rw(38,"destinationicao","flight:destinationIcao",6)
    imgui.SameLine()
	kxb_label_white("| *Alternate:")
    imgui.SameLine()
	kxb_orange_text_field_rw(38,"altnicao","flight:alternateIcao",6)
    imgui.SameLine()
	kxb_label_white("|")
    imgui.SameLine()
	kxb_dropdown_orange(125,"firstflight",kc_split("First flight|Not first flight","|")[activeBriefings:get("flight:firstFlightDay")],kc_split("First flight|Not first flight","|"),"flight:firstFlightDay")
-- Flight timing
	kxb_label_white("Flight Times: Off:")
    imgui.SameLine()
	kxb_scaled_button("offtime","S",15,13,
		function () activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end )
	imgui.SameLine()
	kxb_label_yellow(activeBckVars:get("general:timesOFF"))
	imgui.SameLine()
	kxb_scaled_button("offtclr","C",15,13,
		function () activeBckVars:set("general:timesOFF","==:==") end )
	--
    imgui.SameLine()
	kxb_label_white("| Out:")
    imgui.SameLine()
	kxb_scaled_button("outtime","S",15,13,
		function () activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end )
	imgui.SameLine()
	kxb_label_yellow(activeBckVars:get("general:timesOUT"))
	imgui.SameLine()
	kxb_scaled_button("outtclr","C",15,13,
		function () activeBckVars:set("general:timesOUT","==:==") end )
	--
    imgui.SameLine()
	kxb_label_white("| In:")
    imgui.SameLine()
	kxb_scaled_button("intime","S",15,13,
		function () activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end )
	imgui.SameLine()
	kxb_label_yellow(activeBckVars:get("general:timesIN"))
	imgui.SameLine()
	kxb_scaled_button("intclr","C",15,13,
		function () activeBckVars:set("general:timesIN","==:==") end )
	--
    imgui.SameLine()
	kxb_label_white("| In:")
    imgui.SameLine()
	kxb_scaled_button("ontime","S",15,13,
		function () activeBckVars:set("general:timesON", kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) end )
	imgui.SameLine()
	kxb_label_yellow(activeBckVars:get("general:timesON"))
	imgui.SameLine()
	kxb_scaled_button("ontclr","C",15,13,
		function () activeBckVars:set("general:timesON","==:==") end )
	imgui.SameLine()
	kxb_scaled_button("allclr","RST",30,13,
		function () activeBckVars:set("general:timesOFF","==:==") activeBckVars:set("general:timesOUT","==:==") 
		activeBckVars:set("general:timesIN","==:==") activeBckVars:set("general:timesON","==:==") end )

    imgui.Separator()
-- ---------------------------------------------------------------------------------------
-- Route: <route from Simbrief>
	kxb_label_white("Route:")
	imgui.SameLine()
	kxb_orange_text_field_rwcode(860,"routetext","flight:route",512,
		function () return activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:planrwy") .. " " .. 
			activeBriefings:get("flight:route") .. " " .. activeBriefings:get("flight:destinationIcao") ..  "/" .. activeBriefings:get("flight:destrwy") end)
    imgui.Separator()
-- ---------------------------------------------------------------------------------------

-- [ICAO] Metar Origin
-- [ICAO] Metar Destination
-- [ICAO] Metar Alternate
-- ---------------------------------------------------------------------------------------

	kxb_scaled_button("metarorig","METAR ".. activeBriefings:get("flight:originIcao"),90,13,
		function () if activePrefSet:get("general:askyMetar") then
				origmetar = kb_get_asky_metar(activeBriefings:get("flight:originIcao"))
			else
				origmetar = kb_get_xp_metar(activeBriefings:get("flight:originIcao"))
			end 
		end)
	imgui.SameLine()
	kxb_label_green(origmetar)
	kxb_scaled_button("metardest","METAR ".. activeBriefings:get("flight:destinationIcao"),90,13,
		function () if activePrefSet:get("general:askyMetar") then
				destmetar = kb_get_asky_metar(activeBriefings:get("flight:destinationIcao"))
			else
				destmetar = kb_get_xp_metar(activeBriefings:get("flight:destinationIcao"))
			end 
		end)
	imgui.SameLine()
	kxb_label_green(destmetar)
	kxb_scaled_button("metaraltn","METAR ".. activeBriefings:get("flight:alternateIcao"),90,13,
		function () if activePrefSet:get("general:askyMetar") then
				altnmetar = kb_get_asky_metar(activeBriefings:get("flight:alternateIcao"))
			else
				altnmetar = kb_get_xp_metar(activeBriefings:get("flight:alternateIcao"))
			end 
		end)
	imgui.SameLine()
	kxb_label_green(altnmetar)	

-- [FLIGHT] [DEBUG]
-- Tabs
	if imgui.BeginTabBar("#briefings") then

-- FLIGHT tab

		if imgui.BeginTabItem("FLIGHT") then
			imgui.BeginChild("flighttab")
				imgui.Columns(4,"flightcolumns",true)
					imgui.BeginChild("flighttabcol1")
						-- imgui.SetWindowFontScale(kb_font_scale)
-- -----------------------------------------------------------------------------------------------------------------
-- CALT    : [99999] (FL999)
-- AIR DIST: 9999 nm
-- CI      : 99
						kxb_label_white("*CALT      :")
						imgui.SameLine()
						kxb_orange_text_field_rw(40,"cruisealt","flight:cruiseLevel",6)
						imgui.SameLine()
						kxb_label_green("(FL" .. activeBriefings:get("flight:cruiseLevel")/100 .. ")")

						kxb_label_white("AIR DIST   :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:airdistance"))

						kxb_label_white("CI         :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:costIndex"))

						imgui.Separator()
						imgui.Separator()					
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- TIMES    : SCHD ESTD
-- BLOCK    : hhmm hhmm
-- AIR      : hhmm hhmm
-- TAXI OUT : hhmm
-- TAXI IN  : hhmm
						kxb_label_white("TIMES        SCHD ESTD (hhmm)")
						kxb_label_white("BLOCK      :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:blocktime"))
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:estblocktime"))
						
						kxb_label_white("AIR        :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:airtime"))
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:estairtime"))

						kxb_label_white("TAXI OUT   :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:taxiouttime"))

						kxb_label_white("TAXI IN    :")
						imgui.SameLine()
						kxb_green_text_field_ro(40,activeBriefings:get("flight:taxiintime"))

						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- EPAX : 999
-- WEIGHT UNIT: KG
-- EZFW : 999999 MAX: 999999
-- ETOW : 999999 MAX: 999999
-- ELDW : 999999 MAX: 999999
-- REMF : 99999
-- CARGO: 99999
-- PAYLD: [999999] MAX: 999999 [LD]
-- AZFW : [999999] MAX: 999999
-- ATOW : [999999] MAX: 999999

-- MAC CG: 99.99
-- PAX WGT: 999999
-- MIN DIV: 9999
						kxb_label_white("APAX  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:paxcount"))

						kxb_label_white("WEIGHTS (" .. wunit .. ")")
						
						kxb_label_white("EZFW  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:zfw"))
						imgui.SameLine()
						kxb_label_white("MZFW:")
						imgui.SameLine()
						kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MZFW()))
						
						kxb_label_white("ETOW  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:tow"))
						imgui.SameLine()
						kxb_label_white("MTOW:")
						imgui.SameLine()
						kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MTOW()))
						
						kxb_label_white("ELDW  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:ldw"))
						imgui.SameLine()
						kxb_label_white("MLDW:")
						imgui.SameLine()
						kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MLW()))

						kxb_label_white("REMF  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:fuelplanldg")))
						
						kxb_label_white("CARGO :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:cargoWeight")))

						kxb_label_white("*PLD  :")
						imgui.SameLine()
						kxb_orange_int_field_rw(50,"payload","flight:payload",0)
						imgui.SameLine()
						kxb_label_white("MAX:")
						imgui.SameLine()
						if activeBriefings:get("flight:payload") > kc_get_MaxPayload() then
							kxb_red_text_field_ro(40,string.format("%06.0f",kc_get_MaxPayload()))
						else
							kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MaxPayload()))
						end
						if kc_pld_ld_button == true then
							imgui.SameLine()
							kxb_scaled_button("ldpayld","LD",20,13,
								function () kc_set_payload(activeBriefings:get("flight:payload")) end )
						end

						kxb_label_white("AZFW  :")
						imgui.SameLine()
						kxb_orange_text_field_ro(50,string.format("%06.0f",kc_get_zfw()))
						imgui.SameLine()
						kxb_label_white("MZFW:")
						imgui.SameLine()
						if kc_get_zfw() > kc_get_MZFW() then
							kxb_red_text_field_ro(40,string.format("%06.0f",kc_get_MZFW()))
						else
							kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MZFW()))
						end

						kxb_label_white("ATOW  :")
						imgui.SameLine()
						kxb_orange_text_field_ro(50,string.format("%06.0f",kc_get_gross_weight()))
						imgui.SameLine()
						kxb_label_white("MTOW:")
						imgui.SameLine()
						if kc_get_gross_weight() > kc_get_MTOW() then
							kxb_red_text_field_ro(40,string.format("%06.0f",kc_get_MTOW()))
						else
							kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MTOW()))
						end

						kxb_label_white("AFUEL :")
						imgui.SameLine()
						kxb_orange_text_field_ro(50,string.format("%06.0f",kc_get_total_fuel()))
						imgui.SameLine()
						kxb_label_white(" MAX:")
						imgui.SameLine()
						if kc_get_total_fuel() > kc_get_MaxFuel() then
							kxb_red_text_field_ro(40,string.format("%06.0f",kc_get_MaxFuel()))
						else
							kxb_green_text_field_ro(40,string.format("%06.0f",kc_get_MaxFuel()))
						end
						
						kxb_label_white("MAC CG:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.2f",kc_get_mac_cg()))

						kxb_label_white("PAXWGT:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:paxweight")))

						kxb_label_white("MINDIV:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:alternateBurn") + activeBriefings:get("flight:reserve")))
						
						imgui.Separator()
						
-- -----------------------------------------------------------------------------------------------------------------
-- FUEL           FUEL TIME
-- TRIP       : 999999 hhmm
-- ALTN       : 999999 hhmm
-- FINAL RES  : 999999 hhmm
-- TAXI       : 999999 hhmm
-- MIN BLOCK  : 999999 hhmm
-- EXTRA FUEL : 999999 hhmm
-- AVG FF KG/H: 999999
-- FUEL : [999999] MAX: 999999						

						kxb_label_white("FUEL " .. wunit .. "        FUEL TIME hhmm")

						kxb_label_white("TRIP       :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:tripFuel")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:airtime"))

						kxb_label_white("ALTN       :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:alternateBurn")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:altnete"))

						kxb_label_white("FINAL RES  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:reserve")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:reserveTime"))

						kxb_label_white("TAXI       :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:taxifuel")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:taxiouttime"))

						kxb_label_white("MIN BLOCK  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:takeoffFuel")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:endurance"))

						kxb_label_white("EXTRA FUEL :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:extrafuel")))
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:extratime"))

						kxb_label_white("AVG FF "..wunit.."/H:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:averageFF")))

						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- PLAN BLOCK : [99999] END: [hhmm]
-- BLOCK FUEL : [999999] [LD]

						
						kxb_label_white("PLAN BLOCK :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,string.format("%06.0f",activeBriefings:get("flight:planblockfuel")))
						imgui.SameLine()
						kxb_label_white("END:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:planblocktime"))

						kxb_label_white("*BLOCK FUEL:")
						imgui.SameLine()
						kxb_orange_int_field_rw(50,"blockfuel","flight:planblockfuel",0)
						imgui.SameLine()
						if kc_fuel_ld_button == true then
							imgui.SameLine()
							kxb_scaled_button("ldfuel","LD",20,13,
								function () kc_set_fuel(activeBriefings:get("flight:planblockfuel")) end )
						end
						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------
-- AVG WINDS  : 999/999
-- WIND COMP  : 9
-- AVG ISA    : 15
-- TROPOPAUSE : 99999
						kxb_label_white("AVG WINDS  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:averageWind"))

						kxb_label_white("WIND COMP  :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:averageWC"))

						kxb_label_white("AVG ISA    :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:averageISA"))

						kxb_label_white("TROPOPAUSE :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("flight:tropopause"))

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------	

					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol2")

-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
						kxb_label_yellow(activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:originIata") .. " " .. activeBriefings:get("flight:originName") .. " [" .. activeBriefings:get("flight:originRegion") .. "]")

						kxb_label_white("ELEV      :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("departure:aptElevation") .. " ft")

						kxb_label_white("TRANS A/LV:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("departure:transalt").." / FL " .. origtranslvl/100)

						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- PARKING   : [AAAA]
-- POS TYPE  : [parking v]
-- PUSH TYPE : [pushtype v]
-- START SEQ : [startseq v]
-- TAXI RTE:
-- [                      ] [C]
						kxb_label_white("PARKING   :")
						imgui.SameLine()
						kxb_orange_text_field_rw(140,"origparking","taxi:parkingStand",45)

						kxb_label_white("*POS TYPE :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"depstand",kc_split(kc_DEP_gatestand_list,"|")[activeBriefings:get("taxi:gateStand")],kc_split(kc_DEP_gatestand_list,"|"),"taxi:gateStand")
						
						kxb_label_white("*PUSH TYPE:")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"deppushtype",kc_split(kc_DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")],kc_split(kc_DEP_push_direction,"|"),"taxi:pushDirection")
						
						kxb_label_white("*START SEQ:")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"startseq",kc_split(kc_StartSequence,"|")[activeBriefings:get("taxi:startSequence")],kc_split(kc_StartSequence,"|"),"taxi:startSequence")
						
						kxb_label_white("TAXI RTE  :")
						kxb_orange_text_field_rw(190,"deptaxirte","taxi:taxiRoute",125)
						imgui.SameLine()
						kxb_scaled_button("ldpayld","CL",20,13,
							function () activeBriefings:set("taxi:taxiRoute","")  end )
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- RUNWAY    : [99x v]
-- LEN / TORA: 99999 / 99999 ft
-- HW / CW   : 99 / 99
-- CONDITION : [condition v]
-- DEP TYPE  : [type v]
-- DEP ROUTE : [xxxxxxx]
-- TRANSITION: [xxxxxxx]
-- BARO Q / A: [9999][<][9999]
-- SQUAWK    : [9999]
						if handler.root.OFP.tlr.takeoff ~= nil then
							kxb_label_white("*RUNWAY   :")
							imgui.SameLine()	
							local runways = handler.root.OFP.tlr.takeoff.runway							
							kxb_dropdown_runway(50,"deprwy1",activeBriefings:get("flight:planrwy"),runways,"flight:planrwy")
							-- if runway selected fill other fields

							for i=1,#runways do
								if runways[i].identifier == activeBriefings:get("flight:planrwy") then
									activeBriefings:set("departure:initHeading",runways[i].magnetic_course)
									activeBriefings:set("departure:nav1Course",runways[i].magnetic_course)
									activeBriefings:set("departure:nav2Course",runways[i].magnetic_course)
									activeBriefings:set("takeoff:v1",runways[i].speeds_v1)
									activeBriefings:set("takeoff:vr",runways[i].speeds_vr)
									activeBriefings:set("takeoff:v2",runways[i].speeds_v2)
									if runways[i].bleed_setting ~= "OFF" then
										activeBriefings:set("takeoff:bleeds",2)
									else
										activeBriefings:set("takeoff:bleeds",1)
									end
									if runways[i].anti_ice_setting == "OFF" then
										activeBriefings:set("takeoff:antiice",1)
									end
									if runways[i].anti_ice_setting == "ENGINE" then
										activeBriefings:set("takeoff:antiice",2)
									end
									if runways[i].anti_ice_setting == "ENGINE & WING" then
										activeBriefings:set("takeoff:antiice",3)
									end
									if handler.root.OFP.tlr.takeoff.conditions.surface_condition == "dry" then
										activeBriefings:set("departure:rwyCond",1)
									else
										activeBriefings:set("departure:rwyCond",2)
									end
									if runways[i].thrust_setting == "FLEX" then
										activeBriefings:set("takeoff:thrust",2)
										if #runways[i].flex_temperature == 0 then
											activeBriefings:set("takeoff:flextemp",15)
										else
											activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
										end
									else
										activeBriefings:set("takeoff:thrust",3)
										if #runways[i].flex_temperature == 0 then
											activeBriefings:set("takeoff:flextemp",15)
										else
											activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
										end
									end
									activeBriefings:set("takeoff:hw",runways[i].headwind_component)
									activeBriefings:set("takeoff:cw",runways[i].crosswind_component)
									activeBriefings:set("takeoff:rwylength",runways[i].length)
									activeBriefings:set("takeoff:tora",runways[i].length_tora)
								end
							end									
						else
							kxb_label_white("*RUNWAY   :")
							imgui.SameLine()						
							kxb_orange_text_field_rw(140,"deprwy2","flight:planrwy",10)
						end
						if handler.root.OFP.tlr.takeoff ~= nil then
							kxb_label_white("LEN / TORA:")
							imgui.SameLine()						
							kxb_green_text_field_ro(50,activeBriefings:get("takeoff:rwylength").." /" .. activeBriefings:get("takeoff:tora").." ft")

							kxb_label_white("HW / CW   :")
							imgui.SameLine()						
							kxb_green_text_field_ro(50,activeBriefings:get("takeoff:hw").." /" .. activeBriefings:get("takeoff:cw"))
						end
						
						kxb_label_white("CONDITION :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"depcondition",kc_split(kc_DEP_rwystate_list,"|")[activeBriefings:get("departure:rwyCond")],kc_split(kc_DEP_rwystate_list,"|"),"departure:rwyCond")

						kxb_label_white("DEP TYPE  :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"deptype",kc_split(kc_DEP_proctype_list,"|")[activeBriefings:get("departure:deptype")],kc_split(kc_DEP_proctype_list,"|"),"departure:deptype")

						kxb_label_white("DEP ROUTE :")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"deproute","departure:deproute",35)

						kxb_label_white("TRANSITION:")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"deptransition","departure:deptransition",35)

						kxb_label_white("*BARO Q/A :")
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"depqnh","departure:atisQNH",0)
						imgui.SameLine()
						kxb_scaled_button("baroswap1","<",10,13,
							function () activeBriefings:set("departure:atisQNH",activeBriefings:get("departure:atisQNHA") / 100 * 33.8639)  end )
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"depqnha","departure:atisQNHA",0)

						kxb_label_white("*SQUAWK   :")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"depsquawk","departure:squawk",35)

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- FLAPS     : [flap v]
-- ANTI ICE  : [antiice v]
-- PACKS     : [on/off v]
-- BLEEDS    : [on/off v]
-- ELEV TRIM : [999.99]
-- RUD TRIM  : [999.99]
						kxb_label_white("*FLAPS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"depflap",kc_split(kc_TakeoffFlaps,"|")[activeBriefings:get("takeoff:flaps")],kc_split(kc_TakeoffFlaps,"|"),"takeoff:flaps")

						kxb_label_white("*ANTI ICE :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"depaice",kc_split(kc_TakeoffAntiice,"|")[activeBriefings:get("takeoff:antiice")],kc_split(kc_TakeoffAntiice,"|"),"takeoff:antiice")

						kxb_label_white("*PACKS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"deppacks",kc_split(kc_TakeoffPacks,"|")[activeBriefings:get("takeoff:packs")],kc_split(kc_TakeoffPacks,"|"),"takeoff:packs")

						kxb_label_white("*BLEEDS   :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"depbleeds",kc_split(kc_TakeoffBleeds,"|")[activeBriefings:get("takeoff:bleeds")],kc_split(kc_TakeoffBleeds,"|"),"takeoff:bleeds")

						kxb_label_white("*ELEV TRIM:")
						imgui.SameLine()						
						kxb_orange_float_field_rw(138,"depelevtrim","takeoff:elevatorTrim","%4.2f")

						kxb_label_white("*RUD TRIM :")
						imgui.SameLine()						
						kxb_orange_float_field_rw(138,"deprudtrim","takeoff:rudderTrim","%4.2f")

						kxb_label_white("*AIL TRIM :")
						imgui.SameLine()						
						kxb_orange_float_field_rw(138,"depailtrim","takeoff:aileronTrim","%4.2f")

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- T/O MD/TMP: [mode v] [temp]
-- V1/Vr/V2  : [999][999][999]
-- IN HDG/ALT: [999][99999]

						if kc_has_rated_to then
							kxb_label_white("T/O MD/TMP:")
							imgui.SameLine()						
							kxb_dropdown_orange(90,"tothrust",kc_split(kc_TakeoffThrust,"|")[activeBriefings:get("takeoff:thrust")],kc_split(kc_TakeoffThrust,"|"),"takeoff:thrust")
							imgui.SameLine()
							kxb_orange_int_field_rw(40,"flextemp","takeoff:flextemp",0)
						end
						
						kxb_label_white("V1/VR/V2  :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(30,"v1","takeoff:v1",0)
						imgui.SameLine()						
						kxb_orange_int_field_rw(30,"vr","takeoff:vr",0)
						imgui.SameLine()						
						kxb_orange_int_field_rw(30,"v2","takeoff:v2",0)

						if kc_can_load_speeds == true then
							imgui.SameLine()
							kxb_scaled_button("ldpayld","LD",20,13,
								function () kc_set_takeoff_details() end )
						end

						if kc_sets_climb_speed then
							kxb_label_white("CLIMB SPD :")
							imgui.SameLine()						
							kxb_orange_int_field_rw(30,"clmbspd","takeoff:clmbspd",0)
						end

						kxb_label_white("IN HDG/ALT:")
						imgui.SameLine()						
						kxb_orange_int_field_rw(38,"inithdg","departure:initHeading",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"initalt","departure:initAlt",0)

						if kc_is_airbus == false then
							kxb_label_white("*CRS1/CRS2:")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs12","departure:nav1Course",0)
							imgui.SameLine()						
							kxb_label_white("/")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs22","departure:nav2Course",0)
						end 
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
						
					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol3")
						imgui.SetWindowFontScale(kb_font_scale)


-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
						kxb_label_yellow(activeBriefings:get("flight:destinationIcao") .. "/" .. activeBriefings:get("flight:destinationIata") .. " " .. activeBriefings:get("flight:destinationName") .. " [" .. activeBriefings:get("flight:destinationRegion") .. "]")

						kxb_label_white("ELEV      :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("arrival:aptElevation") .. " ft")

						kxb_label_white("TRANS A/LV:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,"FL " .. activeBriefings:get("arrival:translvl")/100 .. " / " .. desttransalt)

						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- ARR TYPE  : [type v]
-- ARR ROUTE : [xxxxxxx]
-- TRANSITION: [xxxxxxx]
-- RUNWAY    : [99x v]
-- CONDITION : [condition v]
-- BARO Q / A: [9999][<][9999]

						kxb_label_white("ARR TYPE  :")
						imgui.SameLine()
						kxb_dropdown_orange(138,"arrtype",kc_split(kc_APP_proctype_list,"|")[activeBriefings:get("arrival:arrType")],kc_split(kc_APP_proctype_list,"|"),"arrival:arrType")

						kxb_label_white("ARR ROUTE :")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"arrroute","arrival:arrroute",35)
						
						kxb_label_white("TRANSITION:")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"arrtransition","arrival:arrtransition",35)
						
						kxb_label_white("*BARO Q/A :")
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"arrqnh","arrival:atisQNH",0)
						imgui.SameLine()
						kxb_scaled_button("baroswap2","<",10,13,
							function () activeBriefings:set("arrival:atisQNH",activeBriefings:get("arrival:atisQNHA") / 100 * 33.8639)  end )
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"arrqnha","arrival:atisQNHA",0)

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
						if handler.root.OFP.tlr.landing ~= nil then
							kxb_label_white("*RUNWAY   :")
							imgui.SameLine()						
							kxb_dropdown_runway(50,"apprwy1",activeBriefings:get("flight:destrwy"),handler.root.OFP.tlr.landing.runway,"flight:destrwy")

							local runways2 = handler.root.OFP.tlr.landing.runway
							for i=1,#runways2 do
								if runways2[i].identifier == activeBriefings:get("flight:destrwy") then
									activeBriefings:set("approach:nav1Course",runways2[i].magnetic_course)
									activeBriefings:set("approach:nav2Course",runways2[i].magnetic_course)
									activeBriefings:set("approach:gaheading",runways2[i].magnetic_course)
									if #runways2[i].ils_frequency == 0 then
										activeBriefings:set("approach:nav1Freq","---.--")
									else
										activeBriefings:set("approach:nav1Freq",runways2[i].ils_frequency)
									end

									if handler.root.OFP.tlr.landing.conditions.surface_condition == "dry" then
										activeBriefings:set("arrival:rwyCond",1)
									else
										activeBriefings:set("arrival:rwyCond",2)
									end

									activeBriefings:set("approach:rwylength",runways2[i].length)
									activeBriefings:set("approach:lda",runways2[i].length_lda)
									activeBriefings:set("approach:hw",runways2[i].headwind_component)
									activeBriefings:set("approach:cw",runways2[i].crosswind_component)
								end
							end									
						else
							kxb_label_white("*RUNWAY   :")
							imgui.SameLine()						
							kxb_orange_text_field_rw(140,"apprwy2","flight:destrwy",10)
						end
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- LEN / LDA : 99999 / 99999 ft
-- HW / CW   : 99 / 99
-- APPR TYPE : [type v]
-- ILS FREQ  : [999.999]
-- CRS1/CRS2 : [999] [999]
-- GA ALT    : [999999]
-- GA HDG    : [999]
-- FAF ALT   : [99999]
-- DH        : [9999]
-- DA        : [9999]
-- VREF/VAPP : [999][999]
-- FLAPS     : [flap v]
-- AUTO BRAKE: [abrk v]
-- -----------------------------------------------------------------------------------------------------------------
						kxb_label_white("CONDITION :")
						imgui.SameLine()
						kxb_dropdown_orange(138,"arrcondition",kc_split(kc_APP_rwystate_list,"|")[activeBriefings:get("arrival:rwyCond")],kc_split(kc_APP_rwystate_list,"|"),"arrival:rwyCond")

						if handler.root.OFP.tlr.landing ~= nil then
							kxb_label_white("LEN / LDA :")
							imgui.SameLine()						
							kxb_green_text_field_ro(50,activeBriefings:get("approach:rwylength").." /" .. activeBriefings:get("approach:lda").." ft")

							kxb_label_white("HW / CW   :")
							imgui.SameLine()						
							kxb_green_text_field_ro(50,activeBriefings:get("approach:hw").." /" .. activeBriefings:get("approach:cw"))
						end 
						
						kxb_label_white("*APPR TYPE:")
						imgui.SameLine()
						kxb_dropdown_orange(138,"apprtype1",kc_split(kc_apptypes,"|")[activeBriefings:get("approach:appType")],kc_split(kc_apptypes,"|"),"approach:appType")

						if activeBriefings:get("approach:appType") < 3 then
							kxb_label_white("ILS FREQ  :")
							imgui.SameLine()						
							kxb_orange_text_field_rw(60,"arrilsfrq","approach:nav1Freq",35)
							if kc_show_ilsfrq_btn then
								imgui.SameLine()
								kxb_scaled_button("setils","SET",25,13,
								function () set("sim/cockpit/radios/nav1_freq_hz",activeBriefings:get("approach:nav1Freq")*100) end)
							end
						end

						if kc_is_airbus == false then
							kxb_label_white("*CRS1/CRS2:")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs11","approach:nav1Course",0)
							imgui.SameLine()						
							kxb_label_white("/")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs21","approach:nav2Course",0)
						end 

						kxb_label_white("*GA ALT/HD:")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"gaalt1","approach:gaaltitude",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"gahdg1","approach:gaheading",0)

						kxb_label_white("FAF ALT   :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"fafalt","approach:fafAltitude",0)

						kxb_label_white("*DH / DA  :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"dh1","approach:decision",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"da1","approach:minimums",0)
						-- activeBriefings:set("approach:minimums",activeBriefings:get("approach:decision") + activeBriefings:get("arrival:aptElevation"))
						
						kxb_label_white("VREF/VAPP :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(30,"vref1","approach:vref",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(30,"vref2","approach:vapp",0)

						if kc_can_load_speeds == true then
							imgui.SameLine()
							kxb_scaled_button("ldvspds2","LD",20,13,
								function () kc_set_landing_details() end )
						end			

						kxb_label_white("*FLAPS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"arrflap1",kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")],kc_split(kc_LandingFlaps,"|"),"approach:flaps")
						
						if kc_has_autobrake then
							kxb_label_white("*A-BRAKE  :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrbrkae",kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")],kc_split(kc_LandingAutoBrake,"|"),"approach:autobrake")
						end

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- PACKS     : [on/off v]
-- ANTI ICE  : [type v]

						kxb_label_white("*PACKS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"apppacks",kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")],kc_split(kc_LandingPacks,"|"),"approach:packs")

						kxb_label_white("*ANTI-ICE :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"dappaice",kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")],kc_split(kc_LandingAntiice,"|"),"approach:antiice")

						imgui:Separator()
-- -----------------------------------------------------------------------------------------------------------------

-- TAXI ROUTE:
-- [              ]
-- STAND/GATE: [type v]
-- PARKING   : [XXX]
-- EXT PWR   : [type v]
-- APU       : [type v]
	
						kxb_label_white("TAXI RTE  :")
						kxb_orange_text_field_rw(190,"arrtaxirte","approach:taxiIn",125)
						imgui.SameLine()
						kxb_scaled_button("ldpayld","CL",20,13,
							function () activeBriefings:set("approach:taxiIn","")  end )
							
						kxb_label_white("STAND/GATE:")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"arrstand",kc_split(kc_APP_gatestand_list,"|")[activeBriefings:get("approach:gateStand")],kc_split(kc_APP_gatestand_list,"|"),"approach:gateStand")

						kxb_label_white("PARKING   :")
						imgui.SameLine()
						kxb_orange_text_field_rw(140,"destpark","approach:parkingPosition",45)

						if kc_has_gpu then
							kxb_label_white("EXT PWR   :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrgpu",kc_split(kc_APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")],kc_split(kc_APP_power_at_stand,"|"),"approach:powerAtGate")
						end 
						
						if kc_has_apu then
							kxb_label_white("APU       :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrapu",kc_split("Start|Not needed","|")[activeBriefings:get("approach:activateAPUafterLand")],kc_split("Start|Not needed","|"),"approach:activateAPUafterLand")
						end 
						imgui:Separator()
-- -----------------------------------------------------------------------------------------------------------------

					imgui.EndChild()
				
				imgui.NextColumn()
					imgui.BeginChild("flighttabcol4")

-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
						kxb_label_yellow(activeBriefings:get("flight:alternateIcao") .. "/" .. activeBriefings:get("flight:alternateIata") .. " " .. activeBriefings:get("flight:alternateName") .. " [" .. activeBriefings:get("flight:alternateRegion") .. "]")

						kxb_label_white("ELEV      :")
						imgui.SameLine()
						kxb_green_text_field_ro(50,activeBriefings:get("arrival:altnElevation") .. " ft")

						kxb_label_white("TRANS A/LV:")
						imgui.SameLine()
						kxb_green_text_field_ro(50,"FL " .. activeBriefings:get("arrival:alttranslvl")/100 .. " / " .. altntransalt)

						imgui.Separator()
						imgui.Separator()
				
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- ARR TYPE  : [type v]
-- ARR ROUTE : [xxxxxxx]
-- TRANSITION: [xxxxxxx]
-- RUNWAY    : [xxx]
-- CONDITION : [condition v]
-- BARO Q / A: [9999][<][9999]
-- -----------------------------------------------------------------------------------------------------------------						

						kxb_label_white("ARR TYPE  :")
						imgui.SameLine()
						kxb_dropdown_orange(138,"arrtype2",kc_split(kc_APP_proctype_list,"|")[activeBriefings:get("arrival:altnarrType")],kc_split(kc_APP_proctype_list,"|"),"arrival:altnarrType")

						kxb_label_white("ARR ROUTE :")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"arrroute2","arrival:altnarrroute",35)
						
						kxb_label_white("TRANSITION:")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"arrtransition2","arrival:altnarrtransition",35)
						

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
						kxb_label_white("*RUNWAY   :")
						imgui.SameLine()						
						kxb_orange_text_field_rw(140,"altnrwy","flight:altnrwy",10)

						kxb_label_white("CONDITION :")
						imgui.SameLine()
						kxb_dropdown_orange(138,"altncondition",kc_split(kc_APP_rwystate_list,"|")[activeBriefings:get("arrival:altnrwyCond")],kc_split(kc_APP_rwystate_list,"|"),"arrival:altnrwyCond")

						kxb_label_white("*BARO Q/A :")
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"altnqnh","arrival:atisQNH",0)
						imgui.SameLine()
						kxb_scaled_button("baroswap3","<",10,13,
							function () activeBriefings:set("arrival:atisQNH",activeBriefings:get("arrival:atisQNHA") / 100 * 33.8639)  end )
						imgui.SameLine()
						kxb_orange_int_field_rw(38,"arrqnha","arrival:atisQNHA",0)

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- APPR TYPE : [type v]
-- ILS FREQ  : [999.999]
-- CRS1/CRS2 : [999] [999]
-- GA ALT    : [999999]
-- GA HDG    : [999]
-- FAF ALT   : [99999]
-- DH        : [9999]
-- DA        : [9999]
-- VREF/VAPP : [999][999]
-- FLAPS     : [flap v]
-- AUTO BRAKE: [abrk v]
-- -----------------------------------------------------------------------------------------------------------------	
						
						kxb_label_white("*APPR TYPE:")
						imgui.SameLine()
						kxb_dropdown_orange(138,"apprtype2",kc_split(kc_apptypes,"|")[activeBriefings:get("approach:altnappType")],kc_split(kc_apptypes,"|"),"approach:altnappType")

						if activeBriefings:get("approach:altnappType") < 3 then
							kxb_label_white("ILS FREQ  :")
							imgui.SameLine()						
							kxb_orange_text_field_rw(60,"altnilsfrq","approach:altnnav1Freq",35)
						end

						if kc_is_airbus == false then
							kxb_label_white("*CRS1/CRS2:")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs12","approach:altnnav1Course",0)
							imgui.SameLine()						
							kxb_label_white("/")
							imgui.SameLine()						
							kxb_orange_int_field_rw(60,"crs22","approach:nav2Course",0)
						end 

						kxb_label_white("*GA ALT/HD:")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"gaalt1","approach:gaaltitude",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"gahdg1","approach:gaheading",0)

						kxb_label_white("FAF ALT   :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"altnfafalt","approach:altnfafAltitude",0)

						kxb_label_white("*DH / DA  :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"dh1","approach:decision",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"da1","approach:minimums",0)
						-- activeBriefings:set("approach:minimums",activeBriefings:get("approach:decision") + activeBriefings:get("arrival:aptElevation"))
						
						kxb_label_white("VREF/VAPP :")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"vref1","approach:vref",0)
						imgui.SameLine()						
						kxb_label_white("/")
						imgui.SameLine()						
						kxb_orange_int_field_rw(60,"vref2","approach:vapp",0)

						if kc_can_load_speeds == true then
							imgui.SameLine()
							kxb_scaled_button("ldvspds2","LD",20,13,
								function () kc_set_landing_details() end )
						end			

						kxb_label_white("*FLAPS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"arrflap1",kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")],kc_split(kc_LandingFlaps,"|"),"approach:flaps")
						
						if kc_has_autobrake then
							kxb_label_white("*A-BRAKE  :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrbrkae",kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")],kc_split(kc_LandingAutoBrake,"|"),"approach:autobrake")
						end

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------				
-- PACKS     : [on/off v]
-- ANTI ICE  : [type v]

						kxb_label_white("*PACKS    :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"apppacks",kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")],kc_split(kc_LandingPacks,"|"),"approach:packs")

						kxb_label_white("*ANTI-ICE :")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"dappaice",kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")],kc_split(kc_LandingAntiice,"|"),"approach:antiice")

						imgui:Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- STAND/GATE: [type v]
-- PARKING   : [XXX]
-- EXT PWR   : [type v]
-- APU       : [type v]
-- TAXI ROUTE:
-- [              ]
-- -----------------------------------------------------------------------------------------------------------------						
						kxb_label_white("TAXI RTE  :")
						kxb_orange_text_field_rw(190,"altntaxirte","approach:altntaxiIn",125)
						imgui.SameLine()
						kxb_scaled_button("ldpayld","CL",20,13,
							function () activeBriefings:set("approach:altntaxiIn","")  end )
							
						kxb_label_white("STAND/GATE:")
						imgui.SameLine()						
						kxb_dropdown_orange(138,"altnstand",kc_split(kc_APP_gatestand_list,"|")[activeBriefings:get("approach:altngateStand")],kc_split(kc_APP_gatestand_list,"|"),"approach:altngateStand")

						kxb_label_white("PARKING   :")
						imgui.SameLine()
						kxb_orange_text_field_rw(140,"altnpark","approach:altnparkingPosition",45)

						if kc_has_gpu then
							kxb_label_white("EXT PWR   :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrgpu",kc_split(kc_APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")],kc_split(kc_APP_power_at_stand,"|"),"approach:powerAtGate")
						end 
						
						if kc_has_apu then
							kxb_label_white("APU       :")
							imgui.SameLine()						
							kxb_dropdown_orange(138,"arrapu",kc_split("Start|Not needed","|")[activeBriefings:get("approach:activateAPUafterLand")],kc_split("Start|Not needed","|"),"approach:activateAPUafterLand")
						end
						
						imgui:Separator()
-- -----------------------------------------------------------------------------------------------------------------

				
					imgui.EndChild()
				imgui.Columns() -- end columns
			imgui.EndChild() -- flighttab
		imgui.EndTabItem() -- Flight
		end
	end

end

logMsg(activePrefSet:get("general:simbriefuser"))

-- command to toggle the brief window
create_command("kpbrief/window/open", "KPBrief: Open/Close", "kb_brief_toggle_wnd()", "", "")