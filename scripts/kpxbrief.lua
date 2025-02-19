--[[
	*** KPBRIEF 1.0
	Simbrief based briefing
	Kosta Prokopiu, December 2024
--]]

require "kpcrew.genutils"

kc_VERSION = "2.3-alpha10"
kc_simversion = get("sim/version/xplane_internal_version")

logMsg ( "FWL: ** Starting KPBrief version " .. kc_VERSION .. " on XP " .. kc_simversion .. " **" )

local color_white = 0xFFCCCCCC
local color_orange = 0xFF1b9af8
local color_yellow = 0xFF00FFFF
local color_green = 0xFF95C857

-- kc_show_brief = true

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kc_acf_icao = "DFLT" 
	else
		kc_acf_icao = "B738" -- Zibo Mod
	end

-- FF A350
-- elseif PLANE_ICAO == "A359" then
	-- kc_acf_icao = "A359"

-- XP12 Citation X
-- elseif PLANE_ICAO == "C750" and PLANE_TAILNUMBER == "N750XP" then
	-- kc_acf_icao = "C750"
	
-- XP12 A330-300 Laminar
elseif PLANE_ICAO == "A333" then
	kc_acf_icao = "A33L"
	
-- Inibuilds A300
-- elseif PLANE_ICAO == "A306" then
	-- kc_acf_icao = "A306"

-- FF 7x7
-- elseif PLANE_ICAO == "B762" or PLANE_ICAO == "B763" or PLANE_ICAO == "B764" then
	-- kc_acf_icao = "B7x7"
	
-- Rotate MD-11
-- elseif PLANE_ICAO == "MD11" then
	-- kc_acf_icao = "MD11"
	
-- FJsim 737	
-- elseif PLANE_ICAO == "B732" then
	-- kc_acf_icao = "B732"

-- IXEG 737
-- elseif PLANE_ICAO == "B733" then
	-- kc_acf_icao = "B733"
	
-- X-CRAFTS E-JET FAMILIY XP12 (E1XX)
-- E-JET FAM 170  170/170
-- E-JET FAM 175  175/175
-- E-JET FAM 190  190/190
-- E-JET FAM 195  195/195
-- elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E170" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E175" and PLANE_TAILNUMBER == "E175" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E190" then
	-- kc_acf_icao = "E1XX"
-- elseif PLANE_ICAO == "E195" and PLANE_TAILNUMBER == "E195" then
	-- kc_acf_icao = "E1XX"
	
-- X-CRAFTS FREE E-JETS XP12 (E1FF)
-- Free 175       170/175
-- Free 195       190/195
elseif PLANE_ICAO == "E170" and PLANE_TAILNUMBER == "E175" then
	kc_acf_icao = "E1FF"
elseif PLANE_ICAO == "E190" and PLANE_TAILNUMBER == "E195" then
	kc_acf_icao = "E1FF"
	
-- ToLiss Airbusses
-- elseif PLANE_ICAO == "A321" then
	-- kc_acf_icao = "A20N"
-- elseif PLANE_ICAO == "A339" then
	-- kc_acf_icao = "A20N"
elseif PLANE_ICAO == "A319" and PLANE_TAILNUMBER == "C-GTLS" then
	kc_acf_icao = "A3TL"
-- elseif PLANE_ICAO == "A20N" and PLANE_TAILNUMBER == "C-GTLT" then
	-- kc_acf_icao = "A20N"
-- elseif PLANE_ICAO == "A346" then
	-- kc_acf_icao = "A20N"
	
-- Laminar MD-82
-- elseif PLANE_ICAO == "MD82" and PLANE_TAILNUMBER == "N552AA" then
	-- kc_acf_icao = "MD82"
	
-- RotateSim MD-88
-- elseif PLANE_ICAO == "MD88" then
	-- kc_acf_icao = "MD88"
	
-- Aerobask Phenom 300
elseif PLANE_ICAO == "E55P" then
	kc_acf_icao = "E55P"
end

if kc_file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\" .. kc_acf_icao .. ".preferences") then
	getActivePrefs():load()
end

kb_font_scale = 1.4

-- initialize briefing window
function kb_init_brief_window()
    local wndWidth =  800 * kb_font_scale
    local wndHeight = 320 * kb_font_scale
    fontScale1 = 1
    angle=1
    fontScale = 1
	
    kb_brief_wnd = float_wnd_create(wndWidth, wndHeight, 1, true)
    float_wnd_set_title(kb_brief_wnd, "KPBrief " .. kc_VERSION)
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
origatis = ""

destmetar = ""
destatis = ""

altnmetar = ""
altnatis = ""

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

local wunit = "kgs"

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
	
	wunit = string.upper(handler.root.OFP.params.units)

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
	activeBriefings:set("departure:initHeading",handler.root.OFP.navlog.fix[1].heading_mag)
	origtranslvl = handler.root.OFP.origin.trans_level

-- arrival
	if (#handler.root.OFP.general.star_ident > 0) then
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
	-- origatis = handler.root.OFP.origin.atis[1].message
	-- destatis = handler.root.OFP.destination.atis.message
	-- altnatis = handler.root.OFP.alternate.atis.message
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
-- | SIMBRIEF | |briefings     | |   LOAD   | |   SAVE   | |  CLOSE   |
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
    imgui.Separator()

-- XP: vvvvvv Flight State: State of SOP Aircraft Type: type [XP ICAO: XXXX]
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
    imgui.Separator()

-- Position: 99o41'14" N - 9o11'35" E/N99999 E99999 | Elevation 9999 ft | Time: 99:99:99 / 99:99:99Z
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

    imgui.Separator()
    imgui.Separator()

-- Flight: XXX999 | Origin: XXXX | Destination: XXXX | Alternate: XXXX | First Flight of day
-- Route: XXXX/99 N9999F9999 ......
-- ---------------------------------------------------------------------------------------
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
    imgui.PopItemWidth()
	imgui.PopID()
   
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
    imgui.PopItemWidth()
	imgui.PopID()

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
    imgui.PopItemWidth()
	imgui.PopID()

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
    imgui.PopItemWidth()
	imgui.PopID()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
		imgui.TextUnformatted("|")
	imgui.PopStyleColor()
    imgui.SameLine()
	imgui.PushItemWidth(125*kb_font_scale);
	imgui.PushID("apupwrup:")
    imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
		if imgui.BeginCombo("", kc_split("Power up APU|Power Up GPU","|")[activeBriefings:get("departure:activateAPUPowerUp")]) then
			local options = kc_split("Power up APU|Power Up GPU","|")
			for i = 1, #options do
				if imgui.Selectable(options[i], activeBriefings:get("departure:activateAPUPowerUp") == i) then
					activeBriefings:set("departure:activateAPUPowerUp",i)
				end
			end
		imgui.EndCombo()
		end		
    imgui.PopStyleColor()
    imgui.PopItemWidth()
	imgui.PopID()

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

	imgui.PopStyleVar();

    imgui.Separator()
    imgui.Separator()

-- Tabs
	if imgui.BeginTabBar("#briefings") then

-- FLIGHT tab

-- ROUTE: ..........................................................................................
-- C/S : XXX999          TIMES     SCHD ESTD
-- DEP : ICAO            ICAO    : 1725 1726
-- DEST: ICAO            ICAO    : 1800 1800
-- ALTN: ICAO            BLOCK   : 0100 0102
-- CI  : 99              AIRTM   : 0040 0045
-- CALT: 99999 (FL999)
-- DATE: ddMMMyy         TAXI OUT: 0020
--                       TAXI IN : 0008

		if imgui.BeginTabItem("FLIGHT") then
			
			imgui.BeginChild("flighttab")
			
				imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
					imgui.TextUnformatted("Route:")
				imgui.PopStyleColor()
				imgui.SameLine()
				imgui.PushItemWidth(700*kb_font_scale);
				imgui.PushID("Route:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
					local changed, textin = imgui.InputText("", activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:planrwy") .. " " .. activeBriefings:get("flight:route") .. " " .. activeBriefings:get("flight:destinationIcao") ..  "/" .. activeBriefings:get("flight:destrwy"), 255)
					if changed then
						activeBriefings:set("flight:route",textin)
					end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopID()

				imgui.Columns(4,"flightcolumns",true)

					imgui.BeginChild("flighttabcol1")
		
						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("C/S :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(60*kb_font_scale);
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(activeBriefings:get("flight:callsign"))
						imgui.PopStyleColor()
						imgui.PopItemWidth()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DEP :")
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
						imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:originName"))
						imgui.PopStyleColor()
					   
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DEST:")
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
						imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:destinationName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ALTN:")
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
						imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:alternateName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CI  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:costIndex"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CALT:")
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("Cruise Level:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("flight:cruiseLevel"), 0)
							if changed then
								activeBriefings:set("flight:cruiseLevel",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("(FL" .. activeBriefings:get("flight:cruiseLevel")/100 .. ")" )
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DATE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:depdate"))
						imgui.PopStyleColor()
						
					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol2")

						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TIMES     SCHD ESTD")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(activeBriefings:get("flight:originIcao") .. "    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:deptime"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:estdeptime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted(activeBriefings:get("flight:destinationIcao") .. "    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:arrtime"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:estarrtime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BLOCK   :")
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
							imgui.TextUnformatted("AIRTM   :")
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
							imgui.TextUnformatted("")
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI OUT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:taxiouttime"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TAXI IN :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:taxiintime"))
						imgui.PopStyleColor()
						
					imgui.EndChild()

				imgui.NextColumn()
					imgui.BeginChild("flighttabcol3")

						imgui.SetWindowFontScale(kb_font_scale)
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AIR DIST  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:airdistance") .. " nm")
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RTE DIST  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:routedistance") .. " nm")
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG WINDS :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageWind"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("WIND COMP :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageWC"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG ISA   :")
						imgui.PopStyleColor()	
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageISA"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TROPOPAUSE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:tropopause"))
						imgui.PopStyleColor()
						
					imgui.EndChild()
				
				imgui.NextColumn()
					imgui.BeginChild("flighttabcol4")

						imgui.SetWindowFontScale(kb_font_scale)
						
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
			
					imgui.EndChild()

				imgui.Columns()
			
			imgui.EndChild()
		imgui.EndTabItem()
		end
		
	-- WEIGHTS tab 
		if imgui.BeginTabItem("WEIGHTS") then

			imgui.BeginChild("weightstab")

				imgui.Columns(4,"weightcolumns",true)

					imgui.BeginChild("weightcol1")
		
						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("EPAX       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:paxcount"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("EZFW  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:zfw"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ETOW  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:tow"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELDW  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:ldw"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("REMF  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:fuelplanldg"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CARGO (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:cargoWeight"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PAYLD (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:payload"))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
						imgui.PushID("ldpayload")
						if imgui.Button("LD", 20*kb_font_scale, 15*kb_font_scale) then
							kc_set_payload(activeBriefings:get("flight:payload"))
						end						
						imgui.PopID()
						imgui.Separator()
						imgui.PopStyleVar()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RAMP  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						if kc_get_gross_weight() > kc_get_MaxRampWeight() then
							imgui.PushStyleColor(imgui.constant.Col.Text, color_red)
						else
							imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
						end
						imgui.TextUnformatted(string.format("%6.0f",kc_get_gross_weight()))
						imgui.PopStyleColor()

					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("weightcol2")
		
						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PAX WEIGHT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:paxweight") .. " " .. wunit)
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MZFW (" .. wunit .. ")   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:maxzfw"))
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MTOW (" .. wunit .. ")   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:maxtow"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MLDW (" .. wunit .. ")   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:maxldw"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("MIN DIV (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:alternateBurn") + activeBriefings:get("flight:reserve"))
						imgui.PopStyleColor()

						imgui.TextUnformatted(" ")

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ACTZFW  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_zfw()))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ACTTOW  (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_gross_weight()))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ACTFUEL (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",kc_get_total_fuel()))
						imgui.PopStyleColor()
						
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("weightcol3")
		
						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("FUEL (".. wunit ..")    FUEL TIME")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRIP      :")
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
							imgui.TextUnformatted("ALTN      :")
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
							imgui.TextUnformatted("FINAL RES :")
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
							imgui.TextUnformatted("TAXI      :")
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
							imgui.TextUnformatted("MIN BLOCK :")
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
							imgui.TextUnformatted("EXTRA FUEL:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:extrafuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:extratime"))
						imgui.PopStyleColor()	
						
						imgui.Separator()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PLAN BLOCK:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:planblockfuel")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:planblocktime"))
						imgui.PopStyleColor()
						
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("weightcol4")
		
						imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PIC EXTRA (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("pilotextra:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("flight:pilotextra"), 0)
							if changed then
								activeBriefings:set("flight:pilotextra",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.Separator()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("BLOCK (" .. wunit .. ") :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							imgui.TextUnformatted(string.format("%6.0f",activeBriefings:get("flight:planblockfuel")+activeBriefings:get("flight:pilotextra")))
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushID("ldfuel")
						imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
						if imgui.Button("LD", 20*kb_font_scale, 15*kb_font_scale) then
							kc_set_fuel(activeBriefings:get("flight:planblockfuel")+activeBriefings:get("flight:pilotextra"))
						end						
						imgui.PopID()
						imgui.Separator()
						imgui.PopStyleVar()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("AVG FF (" .. wunit .. "/h):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("flight:averageFF"))
						imgui.PopStyleColor()
						
						imgui.Separator()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("FUEL PENALTIES:")
							imgui.TextUnformatted("+1000 (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(handler.root.OFP.impacts.zfw_plus_1000.burn_difference)
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("-1000 (" .. wunit .. "):")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(handler.root.OFP.impacts.zfw_minus_1000.burn_difference)
						imgui.PopStyleColor()
						
						-- imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							-- imgui.TextUnformatted("1FL BELOW  :")
						-- imgui.PopStyleColor()
						-- imgui.SameLine()
						-- imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							-- imgui.TextUnformatted(handler.root.OFP.impacts.minus_2000ft.burn_difference)
						-- imgui.PopStyleColor()
						
					imgui.EndChild()

				imgui.Columns()
				
			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("ORIGIN " .. activeBriefings:get("flight:originIcao")) then

			imgui.BeginChild("origintab")

				if imgui.Button("METAR", 70*kb_font_scale, 20*kb_font_scale) then
					if activePrefSet:get("general:askyMetar") then
						origmetar = kb_get_asky_metar(activeBriefings:get("flight:originIcao"))
					else
						origmetar = kb_get_xp_metar(activeBriefings:get("flight:originIcao"))
					end
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
					imgui.TextUnformatted(origmetar)
				imgui.PopStyleColor()

				imgui.Columns(4,"origincolumns",true)

					imgui.BeginChild("origincol1")
		
						-- imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
						imgui.TextUnformatted(activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:originIata") .. " " .. activeBriefings:get("flight:originName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("departure:aptElevation") .. " ft")
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS ALT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("departure:transalt"))
						imgui.PopStyleColor()
			
			
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS LVL:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. origtranslvl/100)
						imgui.PopStyleColor()
						activeBriefings:set("arrival:translvl",origtranslvl)
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PARKING  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("Taxi: Parked:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("taxi:parkingStand"), 255)
							if changed then
								activeBriefings:set("taxi:parkingStand",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("POS TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(90*kb_font_scale);
						imgui.PushID("Stand/Gate:")
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
							imgui.TextUnformatted("PUSH TYPE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(90*kb_font_scale);
						imgui.PushID("Push:")
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
							imgui.TextUnformatted("START SEQ:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(60*kb_font_scale);
						imgui.PushID("Start Sequence:")
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
							imgui.TextUnformatted("TAXI RTE :")
						imgui.PopStyleColor()
						imgui.PushItemWidth(670*kb_font_scale);
						imgui.PushID("Taxi Route:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("taxi:taxiRoute"), 255)
							if changed then
								activeBriefings:set("taxi:taxiRoute",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.SameLine()
						imgui.PushID("clrtaxi:")

						if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
							activeBriefings:set("taxi:taxiRoute","") 
						end
						imgui.PopID()
						
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("origincol2")
		
						-- imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RUNWAY    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(28*kb_font_scale);
						imgui.PushID("dep Runway:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("flight:planrwy"), 255)
							if changed then
								activeBriefings:set("flight:planrwy",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CONDITION :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(80*kb_font_scale);
						imgui.PushID("Departure condition:")
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
							imgui.TextUnformatted("BARO QNH  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("depqnh:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:atisQNH"), 0)
							if changed then
								activeBriefings:set("departure:atisQNH",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("ANTI ICE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(90*kb_font_scale);
						imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
						imgui.PushID("takeoff antiice:")
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
						imgui.PopStyleVar();
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("SQUAWK    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("squawk:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:squawk"), 0)
							if changed then
								activeBriefings:set("departure:squawk",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("DEP TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(60*kb_font_scale);
						imgui.PushID("Departure Type:")
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
						imgui.PushItemWidth(55*kb_font_scale);
						imgui.PushID("DepRoute:")
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
						imgui.PushItemWidth(50*kb_font_scale);
						imgui.PushID("DepTransition:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("departure:deptransition"), 255)
							if changed then
								activeBriefings:set("departure:deptransition",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("T/O THRUST:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(120*kb_font_scale);
						imgui.PushID("takeoff thrust:")
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
			
			imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("origincol3")
		
						-- imgui.SetWindowFontScale(kb_font_scale)

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("PACKS       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("takeoff packs:")
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
							imgui.TextUnformatted("BLEEDS      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("takeoff bleeds:")
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
							imgui.TextUnformatted("ELEV TRIM   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("takeoff elevator:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:elevatorTrim"), 0, 0.1, "%4.2f")
							if changed then
								activeBriefings:set("takeoff:elevatorTrim",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("RUDDER TRIM :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("takeoff rudder:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:rudderTrim"), 0, 0.1, "%4.2f")
							if changed then
								activeBriefings:set("takeoff:rudderTrim",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
			
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("AILERON TRIM:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("takeoff aileronTrim:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:aileronTrim"), 0, 0.1, "%4.2f")
							if changed then
								activeBriefings:set("takeoff:aileronTrim",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FLAPS       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(45*kb_font_scale);
						imgui.PushID("takeoff flaps:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("DH          :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("depdecisionheight:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:decision"), 0)
							if changed then
								activeBriefings:set("departure:decision",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()


						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("RETURN      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(92*kb_font_scale);
						imgui.PushID("takeoff forced:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_DEP_forced_return,"|")[activeBriefings:get("takeoff:forcedReturn")]) then
								local options = kc_split(kc_DEP_forced_return,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("takeoff:forcedReturn") == i) then
										activeBriefings:set("takeoff:forcedReturn",i)
									end
								end
							imgui.EndCombo()
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
			
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("origincol4")
		
						-- imgui.SetWindowFontScale(kb_font_scale)
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("V1      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff v1:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v1"), 0)
							if changed then
								activeBriefings:set("takeoff:v1",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VR      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff vr:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:vr"), 0)
							if changed then
								activeBriefings:set("takeoff:vr",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("V2      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff v2:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v2"), 0)
							if changed then
								activeBriefings:set("takeoff:v2",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("INIT HDG:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff init hdg:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initHeading"), 0)
							if changed then
								activeBriefings:set("departure:initHeading",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
					
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("INIT ALT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(45*kb_font_scale);
						imgui.PushID("takeoff init alt:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initAlt"), 0)
							if changed then
								activeBriefings:set("departure:initAlt",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 1   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff crs1:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:nav1Course"), 0)
							if changed then
								activeBriefings:set("departure:nav1Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 2   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("takeoff crs2:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("departure:nav2Course"), 0)
							if changed then
								activeBriefings:set("departure:nav2Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("A/P Mode:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(85*kb_font_scale);
						imgui.PushID("takeoff forced:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_TakeoffApModes,"|")[activeBriefings:get("takeoff:apMode")]) then
								local options = kc_split(kc_TakeoffApModes,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("takeoff:apMode") == i) then
										activeBriefings:set("takeoff:apMode",i)
									end
								end
							imgui.EndCombo()
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()


					imgui.EndChild()
				imgui.Columns()
				
			imgui.EndChild()

		imgui.EndTabItem()
		end

-- Destination
		if imgui.BeginTabItem("DESTINATION ".. activeBriefings:get("flight:destinationIcao")) then

			imgui.BeginChild("destinationtab")

				if imgui.Button("METAR", 70*kb_font_scale, 20*kb_font_scale) then
					if activePrefSet:get("general:askyMetar") then
						origmetar = kb_get_asky_metar(activeBriefings:get("flight:destinationIcao"))
					else
						origmetar = kb_get_xp_metar(activeBriefings:get("flight:destinationIcao"))
					end
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
					imgui.TextUnformatted(destmetar)
				imgui.PopStyleColor()

				imgui.Columns(4,"destcolumns",true)

					imgui.BeginChild("destcol1")

						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
							imgui.TextUnformatted(activeBriefings:get("flight:destinationIcao") .. "/" .. activeBriefings:get("flight:destinationIata") .. " " .. activeBriefings:get("flight:destinationName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("arrival:aptElevation") .. " ft")
						imgui.PopStyleColor()
			
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS LVL:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. activeBriefings:get("arrival:translvl")/100)
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS ALT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(desttransalt)
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(60*kb_font_scale);
						imgui.PushID("Arrival Type:")
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
						imgui.PushItemWidth(55*kb_font_scale);
						imgui.PushID("Arr Route:")
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
						imgui.PushItemWidth(55*kb_font_scale);
						imgui.PushID("ArrTransition:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("arrival:arrtransition"), 255)
							if changed then
								activeBriefings:set("arrival:arrtransition",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()


						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("RUNWAY    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(28*kb_font_scale);
						imgui.PushID("arr Runway:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputText("", activeBriefings:get("flight:destrwy"), 255)
							if changed then
								activeBriefings:set("flight:destrwy",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("CONDITION :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(80*kb_font_scale);
						imgui.PushID("Arrival condition:")
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
							imgui.TextUnformatted("BARO QNH  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("arrqnh:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNH"), 0)
							if changed then
								activeBriefings:set("arrival:atisQNH",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("destcol2")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APPR TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(100*kb_font_scale);
						imgui.PushID("takeoff forced:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FAF ALT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("FAFAlt:")
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
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("decisionheight:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:decision"), 0)
							if changed then
								activeBriefings:set("approach:decision",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VREF      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("vref:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vref"), 0)
							if changed then
								activeBriefings:set("approach:vref",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VAPP      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("vapp:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vapp"), 0)
							if changed then
								activeBriefings:set("approach:vapp",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("Flaps     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(45*kb_font_scale);
						imgui.PushID("takeoff flaps:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("AUTO BRAKE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("autobrake:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PACKS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("ldgpacks:")
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
						imgui.PushItemWidth(125*kb_font_scale);
						imgui.PushID("land antiice:")
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
		
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("destcol3")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA ALT    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("gaalt:")
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
						imgui.PushItemWidth(20*kb_font_scale);
						imgui.PushID("gahdh:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaheading"), 0)
							if changed then
								activeBriefings:set("approach:gaheading",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 1     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("apprcrs1:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav1Course"), 0)
							if changed then
								activeBriefings:set("approach:nav1Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 2     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("apprcrs2:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav2Course"), 0)
							if changed then
								activeBriefings:set("approach:nav2Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
			
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("destcol4")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("STAND/GATE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(120*kb_font_scale);
						imgui.PushID("land Stand/Gate:")
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
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("land: Parked:")
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
						imgui.PushItemWidth(80*kb_font_scale);
						imgui.PushID("land Stand/Gate:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APU       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(85*kb_font_scale);
						imgui.PushID("land apu:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("TAXI ROUTE:")
						imgui.PopStyleColor()
						imgui.PushItemWidth(670*kb_font_scale);
						imgui.PushID("taxi in Route:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputText("", activeBriefings:get("approach:taxiIn"), 255)
							if changed then
								activeBriefings:set("approach:taxiIn",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
						
					imgui.EndChild()
				imgui.Columns()
				
			imgui.EndChild()

		imgui.EndTabItem()
		end

-- Alternate
		if imgui.BeginTabItem("ALTERNATE ".. activeBriefings:get("flight:alternateIcao")) then

			imgui.BeginChild("altnapptab")

				if imgui.Button("METAR", 70*kb_font_scale, 20*kb_font_scale) then
					if activePrefSet:get("general:askyMetar") then
						origmetar = kb_get_asky_metar(activeBriefings:get("flight:alternateIcao"))
					else
						origmetar = kb_get_xp_metar(activeBriefings:get("flight:alternateIcao"))
					end
				end
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
					imgui.TextUnformatted(altnmetar)
				imgui.PopStyleColor()

				imgui.Columns(4,"altncolumns",true)

					imgui.BeginChild("altn1")

						imgui.PushStyleColor(imgui.constant.Col.Text, color_yellow)
							imgui.TextUnformatted(activeBriefings:get("flight:alternateIcao") .. "/" .. activeBriefings:get("flight:alternateIata") .. " " .. activeBriefings:get("flight:alternateName"))
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ELEV     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(activeBriefings:get("arrival:altnElevation") .. " ft")
						imgui.PopStyleColor()
			
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS LVL:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted("FL " .. activeBriefings:get("arrival:alttranslvl")/100)
						imgui.PopStyleColor()

						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("TRANS ALT:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							imgui.TextUnformatted(altntransalt)
						imgui.PopStyleColor()
						
						imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							imgui.TextUnformatted("ARR TYPE  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(60*kb_font_scale);
						imgui.PushID("Altn Arrival Type:")
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
						imgui.PushItemWidth(55*kb_font_scale);
						imgui.PushID("altn Arr Route:")
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
						imgui.PushItemWidth(55*kb_font_scale);
						imgui.PushID("AltnTransition:")
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
						imgui.PushItemWidth(28*kb_font_scale);
						imgui.PushID("altn Runway:")
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
						imgui.PushItemWidth(80*kb_font_scale);
						imgui.PushID("Alternate condition:")
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
							imgui.TextUnformatted("BARO QNH  :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("altnqnh:")
						imgui.PushStyleColor(imgui.constant.Col.Text, color_orange)
							local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:altnatisQNH"), 0)
							if changed then
								activeBriefings:set("arrival:altnatisQNH",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()


					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("altn2")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APPR TYPE :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(100*kb_font_scale);
						imgui.PushID("tapproch type altn:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("FAF ALT   :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("altnFAFAlt:")
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
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altndecisionheight:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altndecision"), 0)
							if changed then
								activeBriefings:set("approach:altndecision",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VREF      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altnvref:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnvref"), 0)
							if changed then
								activeBriefings:set("approach:altnvref",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("VAPP      :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altnvapp:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnvapp"), 0)
							if changed then
								activeBriefings:set("approach:altnvapp",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("Flaps     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(45*kb_font_scale);
						imgui.PushID("altntakeoff flaps:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_LandingFlaps,"|")[activeBriefings:get("approach:altnflaps")]) then
								local options = kc_split(kc_LandingFlaps,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("approach:altnflaps") == i) then
										activeBriefings:set("approach:altnflaps",i)
									end
								end
							imgui.EndCombo()
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("AUTO BRAKE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("altn autobrake:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_LandingAutoBrake,"|")[activeBriefings:get("approach:altnautobrake")]) then
								local options = kc_split(kc_LandingAutoBrake,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("approach:altnautobrake") == i) then
										activeBriefings:set("approach:altnautobrake",i)
									end
								end
							imgui.EndCombo()
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("PACKS     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(35*kb_font_scale);
						imgui.PushID("altnpacks:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_LandingPacks,"|")[activeBriefings:get("approach:altnpacks")]) then
								local options = kc_split(kc_LandingPacks,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("approach:altnpacks") == i) then
										activeBriefings:set("approach:altnpacks",i)
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
						imgui.PushItemWidth(125*kb_font_scale);
						imgui.PushID("altn land antiice:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							if imgui.BeginCombo("", kc_split(kc_LandingAntiice,"|")[activeBriefings:get("approach:altnantiice")]) then
								local options = kc_split(kc_LandingAntiice,"|")
								for i = 1, #options do
									if imgui.Selectable(options[i], activeBriefings:get("approach:altnantiice") == i) then
										activeBriefings:set("approach:altnantiice",i)
									end
								end
							imgui.EndCombo()
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()
		
					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("altn3")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA ALT    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(40*kb_font_scale);
						imgui.PushID("altngaalt:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altngaaltitude"), 0)
							if changed then
								activeBriefings:set("approach:altngaaltitude",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("GA HDG    :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(20*kb_font_scale);
						imgui.PushID("altngahdh:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altngaheading"), 0)
							if changed then
								activeBriefings:set("approach:altngaheading",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 1     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altncrs1:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnnav1Course"), 0)
							if changed then
								activeBriefings:set("approach:altnnav1Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("CRS 2     :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altncrs2:")
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
							local changed, textin = imgui.InputInt("", activeBriefings:get("approach:altnnav2Course"), 0)
							if changed then
								activeBriefings:set("approach:altnnav2Course",textin)
							end
						imgui.PopStyleColor()
						imgui.PopItemWidth()
						imgui.PopID()

					imgui.EndChild()
					
				imgui.NextColumn()
					imgui.BeginChild("altn4")

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("STAND/GATE:")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(120*kb_font_scale);
						imgui.PushID("altn Stand/Gate:")
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
						imgui.PushItemWidth(30*kb_font_scale);
						imgui.PushID("altn: Parked:")
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
						imgui.PushItemWidth(80*kb_font_scale);
						imgui.PushID("land Stand/Gate:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("APU       :")
						imgui.PopStyleColor()
						imgui.SameLine()
						imgui.PushItemWidth(85*kb_font_scale);
						imgui.PushID("land apu:")
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

						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
							imgui.TextUnformatted("TAXI ROUTE:")
						imgui.PopStyleColor()
						imgui.PushItemWidth(670*kb_font_scale);
						imgui.PushID("altn taxi in Route:")
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

-- Alternate
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

						-- imgui.PushStyleColor(imgui.constant.Col.Text, color_white)
							-- imgui.TextUnformatted("MZFW:")
						-- imgui.PopStyleColor()
						-- imgui.SameLine()
						-- imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
							-- imgui.TextUnformatted(kc_get_MZFW())
						-- imgui.PopStyleColor()

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