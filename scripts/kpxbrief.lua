--[[
	*** KPxBRIEF 1.0
	Simbrief based briefing on steroids
	Kosta Prokopiu, July 2025
--]]

require "kpcrew.genutils"
require "kpcrew.basicmodules"

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
    local wndWidth =  950 * kb_font_scale
    local wndHeight = 930 * kb_font_scale
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
	activeBriefings:set("flight:originName",handler.root.OFP.origin.name)
	activeBriefings:set("flight:destinationIcao",handler.root.OFP.destination.icao_code)
	activeBriefings:set("flight:destinationIata",handler.root.OFP.destination.iata_code)
	activeBriefings:set("flight:destinationName",handler.root.OFP.destination.name)
	activeBriefings:set("flight:destrwy",handler.root.OFP.destination.plan_rwy)
	activeBriefings:set("flight:altnrwy",handler.root.OFP.alternate.plan_rwy)
	activeBriefings:set("flight:alternateIcao",handler.root.OFP.alternate.icao_code)
	activeBriefings:set("flight:alternateIata",handler.root.OFP.alternate.iata_code)
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
	-- 
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
					activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
				else
					activeBriefings:set("takeoff:thrust",3)
					activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
				end

				activeBriefings:set("takeoff:hw",runways[i].headwind_component)
				activeBriefings:set("takeoff:cw",runways[i].crosswind_component)
			end
		end
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
	-- 
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
    imgui.PushItemWidth(field_size);
    local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	imgui.SetWindowFontScale(kb_font_scale)
	
-- +----------+ +--------------+ +----------+ +----------+ +----------+
-- | SIMBRIEF | |briefingname  | |   LOAD   | |   SAVE   | |  CLOSE   |
-- +----------+ +--------------+ +----------+ +----------+ +----------+
-- ---------------------------------------------------------------------------------------

-- Load latest simbrief flight plan
    imgui.PushItemWidth(field_size);
		if imgui.Button("SIMBRIEF", 70*kb_font_scale, 20*kb_font_scale) then
			kb_load_simbrief_ofp()
			kb_extract_simbrief_ofp()
		end

-- Load/Save current briefing under filename in this field
		imgui.SameLine()
		imgui.PushID("SaveBriefing:")
			imgui.PushItemWidth(100*kb_font_scale);
				imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
					local changed, textin = imgui.InputText("", activeBriefings:getFilename(), 255)
					if changed then
						activeBriefings:setFilename(textin)
					end
				imgui.PopStyleColor()
			imgui.PopItemWidth()
		imgui.PopID()

		imgui.SameLine()
		if imgui.Button("LOAD", 70*kb_font_scale, 20*kb_font_scale) then
			activeBriefings:load()
		end

		imgui.SameLine()
		if imgui.Button("SAVE", 70*kb_font_scale, 20*kb_font_scale) then
			activeBriefings:save()
		end

	-- Close the briefing window
		imgui.SameLine()
		if imgui.Button("CLOSE", 70*kb_font_scale, 20*kb_font_scale) then
			kb_hide_brief_wnd()
		end

    imgui.PopItemWidth()

    imgui.Separator()

-- XP: <vvvvvv> Flight State: <State of SOP> Aircraft Type: <type> [XP ICAO: <XXXX>]
-- ---------------------------------------------------------------------------------------

    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("XP:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
		imgui.TextUnformatted(activeBckVars:get("general:simversion"))
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("Flight State:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
		imgui.TextUnformatted(kcSopFlightPhase[math.abs(activeBckVars:get("general:flight_state"))])
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("Aircraft Type:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(kc_acf_name .. " - " .. kc_acf_icao .. " [XP ICAO: " .. PLANE_ICAO .. "]")
    imgui.PopStyleColor()

    imgui.Separator()

-- Position: <99o41'14" N - 9o11'35" E/N99999 E99999> | Elevation <9999 ft> | Time: <99:99:99> / <99:99:99Z>
-- ---------------------------------------------------------------------------------------

    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("Position:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(kc_convertDMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")) .. "/" ..
		kc_convertINS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")))
    imgui.PopStyleColor()
	
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("| Elevation:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector")))
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("| Time:")
	imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(kc_dispTimeFull(get("sim/time/zulu_time_sec")) .. "Z / " .. kc_dispTimeFull(get("sim/time/local_time_sec")))
    imgui.PopStyleColor()

    imgui.SameLine()
	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("DATE:")
	imgui.PopStyleColor()
	imgui.SameLine()
	imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(activeBriefings:get("flight:depdate"))
	imgui.PopStyleColor()

    imgui.Separator()

-- Flight: <XXX999> | Origin: XXXX | Destination: XXXX | Alternate: XXXX | First Flight of day... | Battery Only...
-- Flight Times: Off Blocks: S ==:== C | Out: S ==:== C | In: S ==:== C | On Blocks: S ==:== C RST
-- ---------------------------------------------------------------------------------------
	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);

    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("Flight:")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(60*kb_font_scale);
		imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
			imgui.TextUnformatted(activeBriefings:get("flight:callsign"))
		imgui.PopStyleColor()
    imgui.PopItemWidth()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("| Departure:")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
		imgui.PushID("*Origin ICAO:")
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				local changed, textin = imgui.InputText("", activeBriefings:get("flight:originIcao"), 255)
				if changed then
					activeBriefings:set("flight:originIcao",textin)
				end
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()

   
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("| Arrival:")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
		imgui.PushID("*Destination ICAO:")
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				local changed, textin = imgui.InputText("", activeBriefings:get("flight:destinationIcao"), 255)
				if changed then
					activeBriefings:set("flight:destinationIcao",textin)
				end
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("| Alternate:")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
		imgui.PushID("Alternate ICAO:")
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				local changed, textin = imgui.InputText("", activeBriefings:get("flight:alternateIcao"), 255)
				if changed then
					activeBriefings:set("flight:alternateIcao",textin)
				end
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("|")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(125*kb_font_scale);
		imgui.PushID("firstflight:")
			imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
				if imgui.BeginCombo("", kc_split("First flight|Not first flight","|")[activeBriefings:get("flight:firstFlightDay")]) then
					local options = kc_split("First flight|Not first flight","|")
					for i = 1, #options do
						if imgui.Selectable(options[i], activeBriefings:get("flight:firstFlightDay") == i) then
							activeBriefings:set("flight:firstFlightDay",i)
						end
					end
				imgui.EndCombo()
				end		
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()

-- Flight timing
		imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
			imgui.TextUnformatted("Flight Times: Off:")
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("offtime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
			imgui.TextUnformatted(activeBckVars:get("general:timesOFF"))
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("offclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF","==:==") 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
			imgui.TextUnformatted("| Out:")
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("outtime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
			imgui.TextUnformatted(activeBckVars:get("general:timesOUT"))
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("outclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOUT","==:==") 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
			imgui.TextUnformatted("| In:")
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("intime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
			imgui.TextUnformatted(activeBckVars:get("general:timesIN"))
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("inclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesIN","==:==") 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
			imgui.TextUnformatted("| On Blocks:")
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("ontime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
		imgui.PopID()
		imgui.SameLine()
		imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
			imgui.TextUnformatted(activeBckVars:get("general:timesON"))
		imgui.PopStyleColor()
		imgui.SameLine()
		imgui.PushID("onclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesON","==:==") 
			end
		imgui.PopID()

		imgui.SameLine()
		imgui.PushID("allclear:")
			if imgui.Button("RST", 30*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF","==:==") 
				activeBckVars:set("general:timesOUT","==:==") 
				activeBckVars:set("general:timesIN","==:==") 
				activeBckVars:set("general:timesON","==:==") 
			end
		imgui.PopID()

	imgui.PopStyleVar(); -- field size

    imgui.Separator()

-- Route: <route from Simbrief>
-- ---------------------------------------------------------------------------------------

	imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("Route:")
	imgui.PopStyleColor()
	imgui.SameLine()
	imgui.PushItemWidth(860*kb_font_scale);
		imgui.PushID("Route:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:planrwy") .. " " .. activeBriefings:get("flight:route") .. " " .. activeBriefings:get("flight:destinationIcao") ..  "/" .. activeBriefings:get("flight:destrwy"), 255)
				if changed then
					activeBriefings:set("flight:route",textin)
				end
			imgui.PopStyleColor()
		imgui.PopID()		
	imgui.PopItemWidth()

    imgui.Separator()

-- [ICAO] Metar Origin
-- [ICAO] Metar Destination
-- [ICAO] Metar Alternate
-- ---------------------------------------------------------------------------------------

	if imgui.Button("METAR ".. activeBriefings:get("flight:originIcao"), 90*kb_font_scale, 20*kb_font_scale) then
		if activePrefSet:get("general:askyMetar") then
			origmetar = kb_get_asky_metar(activeBriefings:get("flight:originIcao"))
		else
			origmetar = kb_get_xp_metar(activeBriefings:get("flight:originIcao"))
		end
	end
	imgui.SameLine()
	imgui.PushID("METAR ORIG")
		imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
			imgui.TextUnformatted(origmetar)
		imgui.PopStyleColor()
	imgui.PopID()
	
	if imgui.Button("METAR ".. activeBriefings:get("flight:destinationIcao"), 90*kb_font_scale, 20*kb_font_scale) then
		if activePrefSet:get("general:askyMetar") then
			destmetar = kb_get_asky_metar(activeBriefings:get("flight:destinationIcao"))
		else
			destmetar = kb_get_xp_metar(activeBriefings:get("flight:destinationIcao"))
		end
	end
	imgui.SameLine()
	imgui.PushID("METAR DEST")
		imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
			imgui.TextUnformatted(destmetar)
		imgui.PopStyleColor()
	imgui.PopID()
	
	if imgui.Button("METAR "..activeBriefings:get("flight:alternateIcao"), 90*kb_font_scale, 20*kb_font_scale) then
		if activePrefSet:get("general:askyMetar") then
			altnmetar = kb_get_asky_metar(activeBriefings:get("flight:alternateIcao"))
		else
			altnmetar = kb_get_xp_metar(activeBriefings:get("flight:alternateIcao"))
		end
	end
	imgui.SameLine()
	imgui.PushID("METAR ALTN")
		imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
			imgui.TextUnformatted(altnmetar)
		imgui.PopStyleColor()
	imgui.PopID()

-- [FLIGHT] [DEBUG]
-- Tabs
	if imgui.BeginTabBar("#briefings") then

-- FLIGHT tab

		if imgui.BeginTabItem("FLIGHT") then
			
			imgui.BeginChild("flighttab")
			
				imgui.Columns(4,"flightcolumns",true)

					imgui.BeginChild("flighttabcol1")
		
						imgui.SetWindowFontScale(kb_font_scale)

-- -----------------------------------------------------------------------------------------------------------------
-- CALT    : [99999] (FL999)
-- AIR DIST: 9999 nm
-- CI      : 99
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CALT       :")
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
							imgui.PushID("Cruise Level:")
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("flight:cruiseLevel"), 0)
									if changed then
										activeBriefings:set("flight:cruiseLevel",textin)
									end
								imgui.PopStyleColor()
							imgui.PopID()
						imgui.PopItemWidth()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("(FL" .. activeBriefings:get("flight:cruiseLevel")/100 .. ")" )
						imgui.PopStyleColor()
--
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AIR DIST   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:airdistance") .. " nm")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CI         :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:costIndex"))
						imgui.PopStyleColor()

						imgui.Separator()
						imgui.Separator()					
-- -----------------------------------------------------------------------------------------------------------------
-- TIMES    : SCHD ESTD
-- BLOCK    : hhmm hhmm
-- AIR      : hhmm hhmm
-- TAXI OUT : hhmm
-- TAXI IN  : hhmm
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TIMES        SCHD ESTD")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BLOCK      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:blocktime"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:estblocktime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AIR        :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:airtime"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:estairtime"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI OUT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:taxiouttime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI IN    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:taxiintime"))
						imgui.PopStyleColor()

						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- WEIGHT UNIT: KG
-- EPAX : 999
-- EZFW : 999999 MAX: 999999
-- ETOW : 999999 MAX: 999999
-- ELDW : 999999 MAX: 999999
-- REMF : 99999
-- CARGO: 99999
-- PAYLD: [999999] MAX: 999999 [LD]
-- AZFW : [999999] MAX: 999999
-- ATOW : [999999] MAX: 999999
-- FUEL : [999999] MAX: 999999
-- MAC CG: 99.99
-- -----------------------------------------------------------------------------------------------------------------

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("WEIGHT UNIT: " .. wunit)
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("EPAX :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:paxcount"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("EZFW :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:zfw"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MZFW()))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ETOW :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:tow"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MTOW()))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELDW :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:ldw"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MLW()))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("REMF :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:fuelplanldg"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CARGO:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:cargoWeight"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PAYLD:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(50*kb_font_scale);
							imgui.PushID("payloads:")
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("flight:payload"), 0)
									if changed then
										activeBriefings:set("flight:payload",textin)
									end
								imgui.PopStyleColor()
							imgui.PopID()
						imgui.PopItemWidth()

						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MaxPayload()))
						imgui.PopStyleColor()
					
						if kc_pld_ld_button == true then
							imgui.SameLine()
							imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
								imgui.PushID("ldpayload")
									if imgui.Button("LD", 20*kb_font_scale, 20*kb_font_scale) then
										kc_set_payload(activeBriefings:get("flight:payload"))
									end						
								imgui.PopID()
							imgui.PopStyleVar()
						end
									
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AZFW :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_zfw()))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MZFW()))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ATOW :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_gross_weight()))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MTOW()))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("FUEL :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_total_fuel()))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(" MAX:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",kc_get_MaxFuel()))
						imgui.PopStyleColor()


						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MAC CG:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.2f",kc_get_mac_cg()))
						imgui.PopStyleColor()
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- PAX WGT: 999999
-- MIN DIV: 9999
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
						imgui.TextUnformatted("PAX WGT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%06.0f",activeBriefings:get("flight:paxweight")))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MIN DIV:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:alternateBurn") + activeBriefings:get("flight:reserve"))
						imgui.PopStyleColor()

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- AVG WINDS  : 999/999
-- WIND COMP  : 9
-- AVG ISA    : 15
-- TROPOPAUSE : 99999
-- -----------------------------------------------------------------------------------------------------------------	
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG WINDS  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageWind"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("WIND COMP  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageWC"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG ISA    :")
						imgui.PopStyleColor()	
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageISA"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TROPOPAUSE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:tropopause"))
						imgui.PopStyleColor()

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
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("FUEL           FUEL TIME")
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRIP       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:tripFuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:airtime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ALTN       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:alternateBurn")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:altnete"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("FINAL RES  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:reserve")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:reserveTime"))
						imgui.PopStyleColor()	
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:taxifuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:taxiouttime"))
						imgui.PopStyleColor()	
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MIN BLOCK  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:takeoffFuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:endurance"))
						imgui.PopStyleColor()	

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("EXTRA FUEL :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:extrafuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:extratime"))
						imgui.PopStyleColor()	
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG FF "..wunit.."/H:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageFF"))
						imgui.PopStyleColor()
						
						imgui.Separator()
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
-- PLAN BLOCK : [99999] END: [hhmm]
-- BLOCK FUEL : [999999] [LD]
-- -----------------------------------------------------------------------------------------------------------------
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PLAN BLOCK :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:planblockfuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("END:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(activeBriefings:get("flight:planblocktime"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BLOCK FUEL :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(50*kb_font_scale);
							imgui.PushID("blockfuel:")
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("flight:planblockfuel"), 0)
									if changed then
										activeBriefings:set("flight:planblockfuel",textin)
									end
								imgui.PopStyleColor()
							imgui.PopID()
						imgui.PopItemWidth()

						if kc_fuel_ld_button == true then
							imgui.SameLine()
							imgui.PushID("ldfuel")
								imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
								if imgui.Button("LD", 20*kb_font_scale, 20*kb_font_scale) then
									kc_set_fuel(activeBriefings:get("flight:planblockfuel"))
								end						
								imgui.PopStyleVar()
							imgui.PopID()
						end
						
					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol2")

						imgui.SetWindowFontScale(kb_font_scale)
-- -----------------------------------------------------------------------------------------------------------------
-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
							imgui.TextUnformatted(activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:originIata") .. " " .. activeBriefings:get("flight:originName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("departure:aptElevation") .. " ft")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS A/LV:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("departure:transalt").." /")
						imgui.PopStyleColor()
			
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. origtranslvl/100)
						imgui.PopStyleColor()

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- PARKING   : [AAAA]
-- POS TYPE  : [parking v]
-- PUSH TYPE : [pushtype v]
-- START SEQ : [startseq v]
-- TAXI RTE:
-- [                      ] [C]
-- -----------------------------------------------------------------------------------------------------------------						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PARKING   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Taxi: Parked:")
							imgui.PushItemWidth(35*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("taxi:parkingStand"), 255)
									if changed then
										activeBriefings:set("taxi:parkingStand",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("POS TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Stand/Gate:")
							imgui.PushItemWidth(115*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_DEP_gatestand_list,"|")[activeBriefings:get("taxi:gateStand")]) then
										local options = kc_split(kc_DEP_gatestand_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("taxi:gateStand") == i) then
												activeBriefings:set("taxi:gateStand",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
			
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PUSH TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Push:")
							imgui.PushItemWidth(120*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_DEP_push_direction,"|")[activeBriefings:get("taxi:pushDirection")]) then
										local options = kc_split(kc_DEP_push_direction,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("taxi:pushDirection") == i) then
												activeBriefings:set("taxi:pushDirection",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("START SEQ :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Start Sequence:")
							imgui.PushItemWidth(120*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_StartSequence,"|")[activeBriefings:get("taxi:startSequence")]) then
										local options = kc_split(kc_StartSequence,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("taxi:startSequence") == i) then
												activeBriefings:set("taxi:startSequence",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI RTE  :")
						imgui.PopStyleColor()
						imgui.PushID("Taxi Route:")
							imgui.PushItemWidth(190*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("taxi:taxiRoute"), 255)
									if changed then
										activeBriefings:set("taxi:taxiRoute",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("clrtaxi:")
							if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
								activeBriefings:set("taxi:taxiRoute","") 
							end
						imgui.PopID()
						
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
-- -----------------------------------------------------------------------------------------------------------------
						if handler.root.OFP.tlr.takeoff ~= nil then
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("RUNWAY    :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("dep rwy2:")
								imgui.PushItemWidth(48*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local options = handler.root.OFP.tlr.takeoff.runway
										if imgui.BeginCombo("",activeBriefings:get("flight:planrwy")) then 
											for i = 1, #options do
												if imgui.Selectable(options[i].identifier, activeBriefings:get("flight:planrwy") == i) then
													activeBriefings:set("flight:planrwy",options[i].identifier)
												end
												local runways = handler.root.OFP.tlr.takeoff.runway
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
															activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
														else
															activeBriefings:set("takeoff:thrust",3)
															activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
														end
														
														activeBriefings:set("takeoff:hw",runways[i].headwind_component)
														activeBriefings:set("takeoff:cw",runways[i].crosswind_component)
														activeBriefings:set("takeoff:rwylength",runways[i].length)
														activeBriefings:set("takeoff:tora",runways[i].length_tora)
													end
												end									
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						else
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("RUNWAY    :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("dep Runway:")
								imgui.PushItemWidth(28*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local changed, textin = imgui.InputText("", activeBriefings:get("flight:planrwy"), 255)
										if changed then
											activeBriefings:set("flight:planrwy",textin)
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
													activeBriefings:set("takeoff:hw",runways[i].headwind_component)
													activeBriefings:set("takeoff:cw",runways[i].crosswind_component)											

													if handler.root.OFP.tlr.takeoff.conditions.surface_condition == "dry" then
														activeBriefings:set("departure:rwyCond",1)
													else
														activeBriefings:set("departure:rwyCond",2)
													end
													
													if runways[i].thrust_setting == "FLEX" then
														activeBriefings:set("takeoff:thrust",2)
														activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
													else
														activeBriefings:set("takeoff:thrust",3)
														activeBriefings:set("takeoff:flextemp",runways[i].flex_temperature)
													end
													
												end
											end
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("LEN / TORA:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("takeoff:rwylength").." /")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("takeoff:tora").." ft")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("HW / CW   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("takeoff:hw").." /")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("takeoff:cw"))
						imgui.PopStyleColor()						
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CONDITION :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Departure condition:")
							imgui.PushItemWidth(110*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_DEP_rwystate_list,"|")[activeBriefings:get("departure:rwyCond")]) then
										local options = kc_split(kc_DEP_rwystate_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("departure:rwyCond") == i) then
												activeBriefings:set("departure:rwyCond",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DEP TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Departure Type:")
							imgui.PushItemWidth(80*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_DEP_proctype_list,"|")[activeBriefings:get("departure:deptype")]) then
										local options = kc_split(kc_DEP_proctype_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("departure:deptype") == i) then
												activeBriefings:set("departure:deptype",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DEP ROUTE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("DepRoute:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("departure:deproute"), 255)
									if changed then
										activeBriefings:set("departure:deproute",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANSITION:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("DepTransition:")
							imgui.PushItemWidth(50*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("departure:deptransition"), 255)
									if changed then
										activeBriefings:set("departure:deptransition",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BARO Q / A:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("depqnh:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("departure:atisQNH"), 0)
									if changed then
										activeBriefings:set("departure:atisQNH",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.SameLine()
						imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
							imgui.PushID("baroswap")
								if imgui.Button("<", 10*kb_font_scale, 18*kb_font_scale) then
									activeBriefings:set("departure:atisQNH",activeBriefings:get("departure:atisQNHA") / 100 * 33.8639)
								end						
							imgui.PopID()
						imgui.PopStyleVar()
						
						imgui.SameLine()
						imgui.PushID("adepqnh:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("departure:atisQNHA"), 0)
									if changed then
										activeBriefings:set("departure:atisQNHA",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("SQUAWK    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("squawk:")
							imgui.PushItemWidth(35*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("departure:squawk"), 0)
									if changed then
										activeBriefings:set("departure:squawk",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- FLAPS     : [flap v]
-- ANTI ICE  : [antiice v]
-- PACKS     : [on/off v]
-- BLEEDS    : [on/off v]
-- ELEV TRIM : [999.99]
-- RUD TRIM  : [999.99]
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FLAPS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff flaps:")
							imgui.PushItemWidth(65*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_TakeoffFlaps,"|")[activeBriefings:get("takeoff:flaps")]) then
										local options = kc_split(kc_TakeoffFlaps,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("takeoff:flaps") == i) then
												activeBriefings:set("takeoff:flaps",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("ANTI ICE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff antiice:")
							imgui.PushItemWidth(110*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_TakeoffAntiice,"|")[activeBriefings:get("takeoff:antiice")]) then
										local options = kc_split(kc_TakeoffAntiice,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("takeoff:antiice") == i) then
												activeBriefings:set("takeoff:antiice",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PACKS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff packs:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_TakeoffPacks,"|")[activeBriefings:get("takeoff:packs")]) then
										local options = kc_split(kc_TakeoffPacks,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("takeoff:packs") == i) then
												activeBriefings:set("takeoff:packs",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BLEEDS    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff bleeds:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_TakeoffBleeds,"|")[activeBriefings:get("takeoff:bleeds")]) then
										local options = kc_split(kc_TakeoffBleeds,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("takeoff:bleeds") == i) then
												activeBriefings:set("takeoff:bleeds",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("ELEV TRIM :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff elevator:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:elevatorTrim"), 0, 0.1, "%4.2f")
									if changed then
										activeBriefings:set("takeoff:elevatorTrim",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("RUD TRIM  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff rudder:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:rudderTrim"), 0, 0.1, "%4.2f")
									if changed then
										activeBriefings:set("takeoff:rudderTrim",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
			
						if kc_is_airbus == false then
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("AIL TRIM  :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("takeoff aileronTrim:")
								imgui.PushItemWidth(40*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:aileronTrim"), 0, 0.1, "%4.2f")
										if changed then
											activeBriefings:set("takeoff:aileronTrim",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end 

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- T/O MD/TMP: [mode v] [temp]
-- V1/Vr/V2  : [999][999][999]
-- IN HDG/ALT: [999][99999]
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("T/O MD/TMP:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff thrust:")
							imgui.PushItemWidth(64*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_TakeoffThrust,"|")[activeBriefings:get("takeoff:thrust")]) then
										local options = kc_split(kc_TakeoffThrust,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("takeoff:thrust") == i) then
												activeBriefings:set("takeoff:thrust",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("flextemp:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:flextemp"), 0)
									if changed then
										activeBriefings:set("takeoff:flextemp",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("V1/VR/V2  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff v1:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v1"), 0)
									if changed then
										activeBriefings:set("takeoff:v1",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("takeoff vr:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:vr"), 0)
									if changed then
										activeBriefings:set("takeoff:vr",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("takeoff v2:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v2"), 0)
									if changed then
										activeBriefings:set("takeoff:v2",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						if kc_can_load_speeds == true then
							imgui.SameLine()
							imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
								imgui.PushID("ldvspeeds")
									if imgui.Button("LD", 20*kb_font_scale, 20*kb_font_scale) then
										kc_set_takeoff_details()
									end						
								imgui.PopID()
							imgui.PopStyleVar()
						end

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("IN HDG/ALT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff init hdg:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initHeading"), 0)
									if changed then
										activeBriefings:set("departure:initHeading",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
					
						imgui.SameLine()
						imgui.PushID("takeoff init alt:")
							imgui.PushItemWidth(45*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initAlt"), 0)
									if changed then
										activeBriefings:set("departure:initAlt",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol3")

						imgui.SetWindowFontScale(kb_font_scale)

-- -----------------------------------------------------------------------------------------------------------------
-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
							imgui.TextUnformatted(activeBriefings:get("flight:destinationIcao") .. "/" .. activeBriefings:get("flight:destinationIata") .. " " .. activeBriefings:get("flight:destinationName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("arrival:aptElevation") .. " ft")
						imgui.PopStyleColor()
			
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS A/LV:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. activeBriefings:get("arrival:translvl")/100 .. " /")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(desttransalt)
						imgui.PopStyleColor()						
-- -----------------------------------------------------------------------------------------------------------------
-- ARR TYPE  : [type v]
-- ARR ROUTE : [xxxxxxx]
-- TRANSITION: [xxxxxxx]
-- RUNWAY    : [99x v]
-- CONDITION : [condition v]
-- BARO Q / A: [9999][<][9999]
-- -----------------------------------------------------------------------------------------------------------------
						imgui.Separator()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Arrival Type:")
							imgui.PushItemWidth(80*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_APP_proctype_list,"|")[activeBriefings:get("arrival:arrType")]) then
										local options = kc_split(kc_APP_proctype_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("arrival:arrType") == i) then
												activeBriefings:set("arrival:arrType",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR ROUTE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Arr Route:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("arrival:arrroute"), 255)
									if changed then
										activeBriefings:set("arrival:arrroute",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANSITION:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("ArrTransition:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("arrival:arrtransition"), 255)
									if changed then
										activeBriefings:set("arrival:arrtransition",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if handler.root.OFP.tlr.landing ~= nil then
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("RUNWAY    :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("land rwy2:")
								imgui.PushItemWidth(48*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local options = handler.root.OFP.tlr.landing.runway
										if imgui.BeginCombo("",activeBriefings:get("flight:destrwy")) then 
											for i = 1, #options do
												if imgui.Selectable(options[i].identifier, activeBriefings:get("flight:destrwy") == i) then
													activeBriefings:set("flight:destrwy",options[i].identifier)
												end
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
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						else
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("RUNWAY    :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("land Runway:")
								imgui.PushItemWidth(28*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local changed, textin = imgui.InputText("", activeBriefings:get("flight:destrwy"), 255)
										if changed then
											activeBriefings:set("flight:destrwy",textin)
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

													activeBriefings:set("approach:rwylength",runways2[i].length)
													activeBriefings:set("approach:lda",runways2[i].length_tora)
													activeBriefings:set("approach:hw",runways2[i].headwind_component)
													activeBriefings:set("approach:cw",runways2[i].crosswind_component)
									
												end
											end
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CONDITION :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Arrival condition:")
							imgui.PushItemWidth(80*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_APP_rwystate_list,"|")[activeBriefings:get("arrival:rwyCond")]) then
										local options = kc_split(kc_APP_rwystate_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("arrival:rwyCond") == i) then
												activeBriefings:set("arrival:rwyCond",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BARO Q / A:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("arrqnh:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNH"), 0)
									if changed then
										activeBriefings:set("arrival:atisQNH",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
							imgui.PushID("baroswap2")
								if imgui.Button("<", 10*kb_font_scale, 18*kb_font_scale) then
									activeBriefings:set("arrival:atisQNH",activeBriefings:get("arrival:atisQNHA") / 100 * 33.8639)
								end						
							imgui.PopID()
						imgui.PopStyleVar()
						imgui.SameLine()
						imgui.PushID("arrqnha:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNHA"), 0)
									if changed then
										activeBriefings:set("arrival:atisQNHA",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
			
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
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("LEN / LDA :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("approach:rwylength").." /")
							imgui.SameLine()
							imgui.TextUnformatted(activeBriefings:get("approach:lda").." ft")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("HW / CW   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("approach:hw").." /")
							imgui.SameLine()
							imgui.TextUnformatted(activeBriefings:get("approach:cw"))
						imgui.PopStyleColor()		
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APPR TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff forced:")
							imgui.PushItemWidth(120*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_apptypes,"|")[activeBriefings:get("approach:appType")]) then
										local options = kc_split(kc_apptypes,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:appType") == i) then
												activeBriefings:set("approach:appType",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if activeBriefings:get("approach:appType") < 3 then
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("ILS FREQ  :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("ils:")
								imgui.PushItemWidth(60*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local changed, textin = imgui.InputText("", activeBriefings:get("approach:nav1Freq"), 255)
										if changed then
											activeBriefings:set("approach:nav1Freq",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end
						
						if kc_is_airbus == false then
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("CRS1/CRS2 :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("apprcrs1:")
								imgui.PushItemWidth(30*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav1Course"), 0)
										if changed then
											activeBriefings:set("approach:nav1Course",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
							
							imgui.SameLine()
							imgui.PushID("apprcrs2:")
								imgui.PushItemWidth(30*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav2Course"), 0)
										if changed then
											activeBriefings:set("approach:nav2Course",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end 

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA ALT    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("gaalt:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaaltitude"), 0)
									if changed then
										activeBriefings:set("approach:gaaltitude",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA HDG    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("gahdh:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaheading"), 0)
									if changed then
										activeBriefings:set("approach:gaheading",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FAF ALT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("FAFAlt:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:fafAltitude"), 0)
									if changed then
										activeBriefings:set("approach:fafAltitude",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("DH        :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("decisionheight:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:decision"), 0)
									if changed then
										activeBriefings:set("approach:decision",textin)
										activeBriefings:set("approach:minimums",activeBriefings:get("approach:decision") + activeBriefings:get("arrival:aptElevation"))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("DA        :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("decisionaltitude:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:minimums"), 0)
									if changed then
										activeBriefings:set("approach:minimums",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VREF/VAPP :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("vref:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vref"), 0)
									if changed then
										activeBriefings:set("approach:vref",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("vapp:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vapp"), 0)
									if changed then
										activeBriefings:set("approach:vapp",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						if kc_can_load_speeds == true then
							imgui.SameLine()
							imgui.PushID("ldlanding")
								imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
									if imgui.Button("LD", 20*kb_font_scale, 20*kb_font_scale) then
										kc_set_landing_details()
									end						
								imgui.PopStyleVar()
							imgui.PopID()
						end
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FLAPS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff flaps:")
							imgui.PushItemWidth(65*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")]) then
										local options = kc_split(kc_LandingFlaps,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:flaps") == i) then
												activeBriefings:set("approach:flaps",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if kc_has_autobrake then
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("AUTO BRAKE:")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("autobrake:")
								imgui.PushItemWidth(65*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										if imgui.BeginCombo("", kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")]) then
											local options = kc_split(kc_LandingAutoBrake,"|")
											for i = 1, #options do
												if imgui.Selectable(options[i], activeBriefings:get("approach:autobrake") == i) then
													activeBriefings:set("approach:autobrake",i)
												end
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- PACKS     : [on/off v]
-- ANTI ICE  : [type v]
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PACKS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("ldgpacks:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")]) then
										local options = kc_split(kc_LandingPacks,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:packs") == i) then
												activeBriefings:set("approach:packs",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("ANTI-ICE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land antiice:")
							imgui.PushItemWidth(135*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")]) then
										local options = kc_split(kc_LandingAntiice,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:antiice") == i) then
												activeBriefings:set("approach:antiice",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()						

						imgui:Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- STAND/GATE: [type v]
-- PARKING   : [XXX]
-- EXT PWR   : [type v]
-- APU       : [type v]
-- TAXI ROUTE:
-- [              ]
-- -----------------------------------------------------------------------------------------------------------------						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("STAND/GATE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land Stand/Gate:")
							imgui.PushItemWidth(115*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_APP_gatestand_list,"|")[activeBriefings:get("approach:gateStand")]) then
										local options = kc_split(kc_APP_gatestand_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:gateStand") == i) then
												activeBriefings:set("approach:gateStand",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PARKING   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land: Parked:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputText("", activeBriefings:get("approach:parkingPosition"), 255)
									if changed then
										activeBriefings:set("approach:parkingPosition",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("EXT PWR   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land Ext Pwr:")
							imgui.PushItemWidth(90*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")]) then
										local options = kc_split(kc_APP_power_at_stand,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:powerAtGate") == i) then
												activeBriefings:set("approach:powerAtGate",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if kc_has_apu then 
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("APU       :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("land apu:")
								imgui.PushItemWidth(100*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										if imgui.BeginCombo("", kc_split("Start|Not needed","|")[activeBriefings:get("approach:activateAPUafterLand")]) then
											local options = kc_split("Start|Not needed","|")
											for i = 1, #options do
												if imgui.Selectable(options[i], activeBriefings:get("approach:activateAPUafterLand") == i) then
													activeBriefings:set("approach:activateAPUafterLand",i)
												end
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end 
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("TAXI ROUTE:")
						imgui.PopStyleColor()
						imgui.PushID("taxi in Route:")
							imgui.PushItemWidth(190*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputText("", activeBriefings:get("approach:taxiIn"), 255)
									if changed then
										activeBriefings:set("approach:taxiIn",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

					imgui.EndChild()
				
				imgui.NextColumn()
					imgui.BeginChild("flighttabcol4")

						imgui.SetWindowFontScale(kb_font_scale)
-- -----------------------------------------------------------------------------------------------------------------
-- ICAO/AIRPORT name
-- ELEV      :  9999 ft
-- TRANS A/LV:  99999 / FL 999
-- -----------------------------------------------------------------------------------------------------------------	
						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
							imgui.TextUnformatted(activeBriefings:get("flight:alternateIcao") .. "/" .. activeBriefings:get("flight:alternateIata") .. " " .. activeBriefings:get("flight:alternateName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("arrival:altnElevation") .. " ft")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS A/LV:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. activeBriefings:get("arrival:alttranslvl")/100 .. " /")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(altntransalt)
						imgui.PopStyleColor()	
			
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- ARR TYPE  : [type v]
-- ARR ROUTE : [xxxxxxx]
-- TRANSITION: [xxxxxxx]
-- RUNWAY    : [xxx]
-- CONDITION : [condition v]
-- BARO Q / A: [9999][<][9999]
-- -----------------------------------------------------------------------------------------------------------------						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Altn Arrival Type:")
							imgui.PushItemWidth(80*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_APP_proctype_list,"|")[activeBriefings:get("arrival:altnarrType")]) then
										local options = kc_split(kc_APP_proctype_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("arrival:altnarrType") == i) then
												activeBriefings:set("arrival:altnarrType",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR ROUTE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altn Arr Route:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("arrival:altnarrroute"), 255)
									if changed then
										activeBriefings:set("arrival:altnarrroute",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANSITION:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("AltnTransition:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("arrival:altnarrtransition"), 255)
									if changed then
										activeBriefings:set("arrival:altnarrtransition",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RUNWAY    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altn Runway:")
							imgui.PushItemWidth(28*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputText("", activeBriefings:get("flight:altnrwy"), 255)
									if changed then
										activeBriefings:set("flight:altnrwy",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CONDITION :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("Alternate condition:")
							imgui.PushItemWidth(80*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									if imgui.BeginCombo("", kc_split(kc_APP_rwystate_list,"|")[activeBriefings:get("arrival:altnrwyCond")]) then
										local options = kc_split(kc_APP_rwystate_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("arrival:altnrwyCond") == i) then
												activeBriefings:set("arrival:altnrwyCond",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BARO Q / A:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("arrqnh:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNH"), 0)
									if changed then
										activeBriefings:set("arrival:atisQNH",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("baroswap2")
							imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
								if imgui.Button("<", 10*kb_font_scale, 18*kb_font_scale) then
									activeBriefings:set("arrival:atisQNH",activeBriefings:get("arrival:atisQNHA") / 100 * 33.8639)
								end						
							imgui.PopStyleVar()
						imgui.PopID()						
						imgui.SameLine()
						imgui.PushID("arrqnha:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
									local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNHA"), 0)
									if changed then
										activeBriefings:set("arrival:atisQNHA",string.format("%04.0f",textin))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
			
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
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APPR TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("tapproch type altn:")
							imgui.PushItemWidth(100*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_apptypes,"|")[activeBriefings:get("approach:altnappType")]) then
										local options = kc_split(kc_apptypes,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:altnappType") == i) then
												activeBriefings:set("approach:altnappType",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if activeBriefings:get("approach:altnappType") < 3 then
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("ILS FREQ  :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("altnils:")
								imgui.PushItemWidth(60*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
										local changed, textin = imgui.InputText("", activeBriefings:get("approach:altnnav1Freq"), 255)
										if changed then
											activeBriefings:set("approach:altnnav1Freq",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end
						
						if kc_is_airbus == false then
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("CRS1/CRS2 :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("apprcrs1:")
								imgui.PushItemWidth(30*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnnav1Course"), 0)
										if changed then
											activeBriefings:set("approach:altnnav1Course",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()

							imgui.SameLine()
							imgui.PushID("apprcrs2:")
								imgui.PushItemWidth(30*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav2Course"), 0)
										if changed then
											activeBriefings:set("approach:nav2Course",textin)
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end 

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA ALT    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("gaalt:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaaltitude"), 0)
									if changed then
										activeBriefings:set("approach:gaaltitude",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA HDG    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("gahdh:")
							imgui.PushItemWidth(3*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaheading"), 0)
									if changed then
										activeBriefings:set("approach:gaheading",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FAF ALT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altnFAFAlt:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnfafAltitude"), 0)
									if changed then
										activeBriefings:set("approach:altnfafAltitude",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("DH        :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("decisionheight:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:decision"), 0)
									if changed then
										activeBriefings:set("approach:decision",textin)
										activeBriefings:set("approach:altnminimums",activeBriefings:get("approach:decision") + activeBriefings:get("arrival:altnElevation"))
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("DA        :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("minimumsalt:")
							imgui.PushItemWidth(40*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnminimums"), 0)
									if changed then
										activeBriefings:set("approach:altnminimums",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VREF/VAPP :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altnvref:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnvref"), 0)
									if changed then
										activeBriefings:set("approach:altnvref",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushID("altnvapp:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnvapp"), 0)
									if changed then
										activeBriefings:set("approach:altnvapp",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if kc_can_load_speeds == true then
							imgui.SameLine()
							imgui.PushID("altnldlanding")
								imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
									if imgui.Button("LD", 20*kb_font_scale, 20*kb_font_scale) then
										kc_set_landing_details()
									end						
								imgui.PopStyleVar()
							imgui.PopID()
						end
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FLAPS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("takeoff flaps:")
							imgui.PushItemWidth(65*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:flaps")]) then
										local options = kc_split(kc_LandingFlaps,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:flaps") == i) then
												activeBriefings:set("approach:flaps",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if kc_has_autobrake then
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("AUTO BRAKE:")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("autobrake:")
								imgui.PushItemWidth(65*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										if imgui.BeginCombo("", kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:autobrake")]) then
											local options = kc_split(kc_LandingAutoBrake,"|")
											for i = 1, #options do
												if imgui.Selectable(options[i], activeBriefings:get("approach:autobrake") == i) then
													activeBriefings:set("approach:autobrake",i)
												end
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end
						
						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- PACKS     : [on/off v]
-- ANTI ICE  : [type v]
-- -----------------------------------------------------------------------------------------------------------------
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PACKS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("ldgpacks:")
							imgui.PushItemWidth(55*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:packs")]) then
										local options = kc_split(kc_LandingPacks,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:packs") == i) then
												activeBriefings:set("approach:packs",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("ANTI-ICE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land antiice:")
							imgui.PushItemWidth(125*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:antiice")]) then
										local options = kc_split(kc_LandingAntiice,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:antiice") == i) then
												activeBriefings:set("approach:antiice",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.Separator()
-- -----------------------------------------------------------------------------------------------------------------
-- STAND/GATE: [type v]
-- PARKING   : [XXX]
-- EXT PWR   : [type v]
-- APU       : [type v]
-- TAXI ROUTE:
-- [              ]
-- -----------------------------------------------------------------------------------------------------------------						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("STAND/GATE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altn Stand/Gate:")
							imgui.PushItemWidth(120*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_APP_gatestand_list,"|")[activeBriefings:get("approach:altngateStand")]) then
										local options = kc_split(kc_APP_gatestand_list,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:altngateStand") == i) then
												activeBriefings:set("approach:altngateStand",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PARKING   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("altn: Parked:")
							imgui.PushItemWidth(30*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputText("", activeBriefings:get("approach:altnparkingPosition"), 255)
									if changed then
										activeBriefings:set("approach:altnparkingPosition",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("EXT PWR   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("land Ext Pwr:")
							imgui.PushItemWidth(90*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									if imgui.BeginCombo("", kc_split(kc_APP_power_at_stand,"|")[activeBriefings:get("approach:powerAtGate")]) then
										local options = kc_split(kc_APP_power_at_stand,"|")
										for i = 1, #options do
											if imgui.Selectable(options[i], activeBriefings:get("approach:powerAtGate") == i) then
												activeBriefings:set("approach:powerAtGate",i)
											end
										end
									imgui.EndCombo()
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()

						if kc_has_apu then 
							imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
								imgui.TextUnformatted("APU       :")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushID("land apu:")
								imgui.PushItemWidth(100*kb_font_scale);
									imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
										if imgui.BeginCombo("", kc_split("Start|Not needed","|")[activeBriefings:get("approach:activateAPUafterLand")]) then
											local options = kc_split("Start|Not needed","|")
											for i = 1, #options do
												if imgui.Selectable(options[i], activeBriefings:get("approach:activateAPUafterLand") == i) then
													activeBriefings:set("approach:activateAPUafterLand",i)
												end
											end
										imgui.EndCombo()
										end
									imgui.PopStyleColor()
								imgui.PopItemWidth()
							imgui.PopID()
						end 
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("TAXI ROUTE:")
						imgui.PopStyleColor()
						imgui.PushID("altn taxi in Route:")
							imgui.PushItemWidth(190*kb_font_scale);
								imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
									local changed, textin = imgui.InputText("", activeBriefings:get("approach:altntaxiIn"), 255)
									if changed then
										activeBriefings:set("approach:altntaxiIn",textin)
									end
								imgui.PopStyleColor()
							imgui.PopItemWidth()
						imgui.PopID()
						
					imgui.EndChild()

				imgui.Columns()
			
			imgui.EndChild()
		imgui.EndTabItem()
		end
		
-- Debug TAB
		if imgui.BeginTabItem("DEBUG") then

			imgui.BeginChild("debugtab")
			
				imgui.Columns(4,"dbgcolumns",true)

					imgui.BeginChild("dbg1")

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Max Ramp Weight:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MaxRampWeight())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DOW:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_DOW())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MZFW:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MZFW())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ZFW:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_zfw())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MTOW:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MTOW())
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MLW:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MLW())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Max Payload:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MaxPayload())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Payload:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_Payload())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Gross Weight:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_gross_weight())
						imgui.PopStyleColor()

					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("dbg2")

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of fuel tanks:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_tanks())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Max Fuel:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_MaxFuel())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("Total Fuel loaded:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_total_fuel())
						imgui.PopStyleColor()

						for itank=0, kc_get_nr_tanks()-1, 1 do
 
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("MFL " .. itank+1 .. ":")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
								imgui.TextUnformatted(kc_get_MFL(itank))
							imgui.PopStyleColor()

						end
						
						for itank=0, kc_get_nr_tanks()-1, 1 do
 
							imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
								imgui.TextUnformatted("Fuel tank " .. itank+1 .. ":")
							imgui.PopStyleColor()
							imgui.SameLine()
							imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
								imgui.TextUnformatted(kc_get_tank_weight(itank))
							imgui.PopStyleColor()

						end

					imgui.EndChild()
				imgui.NextColumn()

					imgui.BeginChild("dbg3")
					
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of flap detents:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_flapdetents())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of engines:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_engines())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of batteries:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_batteries())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of generators:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_generators())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("# of inverters:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(kc_get_nr_inverters())
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has apu:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_apu))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has gpu:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_gpu))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has stairs:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_stairs))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has autobrake:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_autobrake))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has speedbrake:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_speedbrake))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("has reversers:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(tostring(kc_has_reversers))
						imgui.PopStyleColor()

					imgui.EndChild()
				imgui.NextColumn()

					imgui.BeginChild("dbg4")
	
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RTE DIST  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:routedistance") .. " nm")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MACH:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:cruisemach"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CTAS:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:cruisetas") .. " kts")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CLMB:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:climbprofile"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DESC:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:descentprofile"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("STEC:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:stepclimb"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("MSA         :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(42*kb_font_scale);
						imgui.PushID("takeoff msa:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:msa"), 0)
							if changed then
								activeBriefings:set("takeoff:msa",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
					imgui.EndChild()
				imgui.Columns()
			
			imgui.EndChild()

		imgui.EndTabItem()
		end

	end

end

logMsg(activePrefSet:get("general:simbriefuser"))

-- command to toggle the brief window
create_command("kpbrief/window/open", "KPBrief: Open/Close", "kb_brief_toggle_wnd()", "", "")