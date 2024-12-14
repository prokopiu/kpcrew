--[[
	*** KPBRIEF 1.0
	Simbrief based briefing
	Kosta Prokopiu, December 2024
--]]

require "kpcrew.genutils"

kc_VERSION = "2.3-alpha10"
kc_simversion = get("sim/version/xplane_internal_version")

logMsg ( "FWL: ** Starting KPBrief version " .. kc_VERSION .. " on XP " .. kc_simversion .. " **" )

-- ====== Global variables =======
kc_acf_icao = "DFLT" -- active addon aircraft ICAO code (DFLT when nothing found)

-- ====== Select the addon modules based on ICAO code
if PLANE_ICAO == "B738" then
	if PLANE_TAILNUMBER ~= "ZB738" then
		kc_acf_icao = "DFLT" 
	else
		kc_acf_icao = "B738" -- Zibo Mod
	end
-- elseif PLANE_ICAO == "A359" then
	-- kc_acf_icao = "A359"
-- XP12 Citation X
elseif PLANE_ICAO == "C750" and PLANE_TAILNUMBER == "N750XP" then
	kc_acf_icao = "C750"
-- elseif PLANE_ICAO == "C172" and PLANE_TAILNUMBER ~= "OK-AFL" then
	-- kc_acf_icao = "C172"
-- XP12 A330-300 Laminar
-- elseif PLANE_ICAO == "A333" then
	-- kc_acf_icao = "A333"
-- elseif PLANE_ICAO == "C172" and PLANE_TAILNUMBER == "OK-AFL" then
	-- kc_acf_icao = "C17D"
-- elseif PLANE_ICAO == "A306" then
	-- kc_acf_icao = "A306"
-- elseif PLANE_ICAO == "B762" or PLANE_ICAO == "B763" or PLANE_ICAO == "B764" then
	-- kc_acf_icao = "B7x7"
-- elseif PLANE_ICAO == "MD11" then
	-- kc_acf_icao = "MD11"
-- elseif PLANE_ICAO == "B732" then
	-- kc_acf_icao = "B732"
-- elseif PLANE_ICAO == "B733" then
	-- kc_acf_icao = "B733"
elseif PLANE_ICAO == "A321" then
	kc_acf_icao = "A20N"
-- elseif PLANE_ICAO == "A319" and PLANE_TAILNUMBER == "C-GTLS" then
	-- kc_acf_icao = "A319"
-- elseif PLANE_ICAO == "A20N" and PLANE_TAILNUMBER == "C-GTLT" then
	-- kc_acf_icao = "A20N"
-- Laminar MD-82
-- elseif PLANE_ICAO == "MD82" and PLANE_TAILNUMBER == "N552AA" then
	-- kc_acf_icao = "MD82"
end

kb_font_scale = 1.4

-- initialize briefing window
function kb_init_brief_window()
    local wndWidth =  800 * kb_font_scale
    local wndHeight = 300 * kb_font_scale
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
    kc_show_brief = not kc_show_brief
    if kc_show_brief then
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
			-- latest OFP gets stored in kpcrew_prefs folder as simbrief.xml
			local xmlfile = xml2lua.loadFile(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\simbrief.xml")
			local parser = xml2lua.parser(handler)
			parser:parse(xmlfile)

			-- initialize OFP record and scan the downloaded XML file
			activeBriefings:set("flight:callsign",handler.root.OFP.atc.callsign)
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
			activeBriefings:set("flight:distance",handler.root.OFP.general.route_distance)
			activeBriefings:set("flight:cruiseLevel",handler.root.OFP.general.initial_altitude)
			activeBriefings:set("flight:averageWind",handler.root.OFP.general.avg_wind_dir .. "/" .. handler.root.OFP.general.avg_wind_spd)
			activeBriefings:set("flight:averageWC",handler.root.OFP.general.avg_wind_comp)
			activeBriefings:set("flight:averageISA",handler.root.OFP.general.avg_temp_dev)
			activeBriefings:set("flight:tripFuel",handler.root.OFP.fuel.enroute_burn)
			activeBriefings:set("flight:minimumTakeoff",handler.root.OFP.fuel.min_takeoff)
			activeBriefings:set("flight:reserve",handler.root.OFP.fuel.reserve)
			activeBriefings:set("flight:alternateBurn",handler.root.OFP.fuel.alternate_burn)
			activeBriefings:set("flight:takeoffFuel",handler.root.OFP.fuel.plan_ramp)
			activeBriefings:set("flight:averageFF",handler.root.OFP.fuel.avg_fuel_flow)
			activeBriefings:set("flight:cargoWeight",handler.root.OFP.weights.cargo)
			activeBriefings:set("flight:payload",handler.root.OFP.weights.payload)
			activeBriefings:set("flight:zfw",handler.root.OFP.weights.est_zfw)
			activeBriefings:set("flight:tow",handler.root.OFP.weights.est_tow)
			activeBriefings:set("flight:ldw",handler.root.OFP.weights.est_ldw)

			if (#handler.root.OFP.general.sid_ident > 0) then
				activeBriefings:set("departure:deproute",handler.root.OFP.general.sid_ident)
			else
				activeBriefings:set("departure:deproute","n.a.")
				activeBriefings:set("departure:deptype",2)
			end
			if (#handler.root.OFP.general.sid_trans > 0) then
				activeBriefings:set("departure:deptransition",handler.root.OFP.general.sid_trans)
			else
				activeBriefings:set("departure:deptransition","")
			end
			activeBriefings:set("departure:aptElevation",handler.root.OFP.origin.elevation)
			activeBriefings:set("departure:transalt",handler.root.OFP.origin.trans_alt)
			activeBriefings:set("departure:initAlt",handler.root.OFP.general.initial_altitude)
			activeBriefings:set("departure:initHeading",handler.root.OFP.navlog.fix[1].heading_mag)
			origtranslvl = handler.root.OFP.origin.trans_level

			if (#handler.root.OFP.general.star_ident > 0) then
				activeBriefings:set("arrival:arroute",handler.root.OFP.general.star_ident)
			else
				activeBriefings:set("arrival:arrroute","n.a.")
				activeBriefings:set("arrival:arrType",2)
			end
			if (#handler.root.OFP.general.star_trans > 0) then
				activeBriefings:set("arrival:arrtransition",handler.root.OFP.general.star_trans)
			else
				activeBriefings:set("arrival:arrtransition","")
			end
			activeBriefings:set("arrival:translvl",handler.root.OFP.destination.trans_level)
			activeBriefings:set("arrival:aptElevation",handler.root.OFP.destination.elevation)
			activeBriefings:set("arrival:alttranslvl",handler.root.OFP.alternate.trans_level)
			desttransalt = handler.root.OFP.destination.trans_alt
			altntransalt = handler.root.OFP.alternate.trans_alt
			
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
			origatis = handler.root.OFP.origin.atis[1].message
			logMsg(origatis)
			destatis = handler.root.OFP.destination.atis.message
			altnatis = handler.root.OFP.alternate.atis.message

			activeBriefings:set("flight:deptimezone",handler.root.OFP.times.orig_timezone)
			activeBriefings:set("flight:arrtimezone",handler.root.OFP.times.dest_timezone)


			activeBriefings:set("flight:depdate",os.date("%d %b %Y",handler.root.OFP.times.est_out - handler.root.OFP.times.orig_timezone*3600))
			activeBriefings:set("flight:deptime",os.date("%H:%MZ",handler.root.OFP.times.est_out - handler.root.OFP.times.orig_timezone*3600))
			activeBriefings:set("flight:arrtime",os.date("%H:%MZ",handler.root.OFP.times.est_in - handler.root.OFP.times.orig_timezone*3600))
			
			local airtimeh = math.floor(handler.root.OFP.times.est_time_enroute / 3600)
			local airtimem = math.floor((handler.root.OFP.times.est_time_enroute - airtimeh*3600) / 60)
			activeBriefings:set("flight:airtime",os.date(airtimeh .. ":" .. airtimem))
			local blockh = math.floor(handler.root.OFP.times.est_block / 3600)
			local blockm = math.floor((handler.root.OFP.times.est_block - blockh*3600) / 60)
			activeBriefings:set("flight:blocktime",blockh .. ":" .. blockm)
			
			activeBriefings:set("flight:cruiseprofile",handler.root.OFP.general.cruise_profile)
			activeBriefings:set("flight:cruisemach",handler.root.OFP.general.cruise_mach)
			activeBriefings:set("flight:cruisetas",handler.root.OFP.general.cruise_tas)
			activeBriefings:set("flight:climbprofile",handler.root.OFP.general.climb_profile)
			activeBriefings:set("flight:descentprofile",handler.root.OFP.general.descent_profile)
			activeBriefings:set("flight:stepclimb",handler.root.OFP.general.stepclimb_string)
			activeBriefings:set("flight:paxcount",handler.root.OFP.weights.pax_count)
			activeBriefings:set("flight:rampweight",handler.root.OFP.weights.est_ramp)
			
        elseif result ~= 200 then
            logMsg("Error: Simbrief download failed: " .. result)
            return false
        end
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
		return string.sub(wx,7,startindex-2)
    else
        return "-- NO ICAO --"
    end
end 

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
    end

-- Load/Save current briefing under filename in this field
    imgui.SameLine()
	imgui.PushItemWidth(100*kb_font_scale);
	imgui.PushID("SaveBriefing:")
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
	local changed, textin = imgui.InputText("", activeBriefings:getFilename(), 255)
	if changed then
		activeBriefings:setFilename(textin)
	end
    imgui.PopStyleColor()
    imgui.PopItemWidth()

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

    imgui.Separator()
    imgui.Separator()

-- XP: vvvvvv Flight State: State of SOP Aircraft Type: type [XP ICAO: XXXX]
-- ---------------------------------------------------------------------------------------

    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("XP:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
    imgui.TextUnformatted(activeBckVars:get("general:simversion"))
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("Flight State:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
    imgui.TextUnformatted(kcSopFlightPhase[activeBckVars:get("general:flight_state")])
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("Aircraft Type:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
    imgui.TextUnformatted(kc_acf_name .. " - " .. kc_acf_icao .. " [XP ICAO: " .. PLANE_ICAO .. "]")
    imgui.PopStyleColor()

    imgui.Separator()
    imgui.Separator()

-- Position: 99o41'14" N - 9o11'35" E/N99999 E99999 | Elevation 9999 ft | Time: 99:99:99 / 99:99:99Z
-- ---------------------------------------------------------------------------------------

    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("Position:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
    imgui.TextUnformatted(kc_convertDMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")) .. "/" ..
	kc_convertINS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")))
    imgui.PopStyleColor()
	
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("| Elevation:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
    imgui.TextUnformatted(string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector")))
    imgui.PopStyleColor()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("| Time:")
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
    imgui.TextUnformatted(kc_dispTimeFull(get("sim/time/local_time_sec")) .. " / " .. kc_dispTimeFull(get("sim/time/zulu_time_sec")) .. "Z")
    imgui.PopStyleColor()

    imgui.Separator()
    imgui.Separator()

-- Flight: XXX999 | Origin: XXXX | Destination: XXXX | Alternate: XXXX | First Flight of day
-- Route: XXXX/99 N9999F9999 ......
-- ---------------------------------------------------------------------------------------
-- Flight Times: Off Blocks: S ==:== C | Out: S ==:== C | In: S ==:== C | On Blocks: S ==:== C RST
-- ---------------------------------------------------------------------------------------
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("Flight:")
    imgui.SameLine()
	imgui.PushItemWidth(60*kb_font_scale);
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
    imgui.TextUnformatted(activeBriefings:get("flight:callsign"))
    imgui.PopStyleColor()
    imgui.PopItemWidth()

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("| Departure:")
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
	imgui.PushID("*Origin ICAO:")
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
	local changed, textin = imgui.InputText("", activeBriefings:get("flight:originIcao"), 255)
	if changed then
		activeBriefings:set("flight:originIcao",textin)
	end
    imgui.PopStyleColor()
    imgui.PopItemWidth()
	imgui.PopStyleVar();
   
    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("| Arrival:")
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
	imgui.PushID("*Destination ICAO:")
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
	local changed, textin = imgui.InputText("", activeBriefings:get("flight:destinationIcao"), 255)
	if changed then
		activeBriefings:set("flight:destinationIcao",textin)
	end
    imgui.PopStyleColor()
    imgui.PopItemWidth()
	imgui.PopStyleVar();

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("| Alternate:")
    imgui.SameLine()
	imgui.PushItemWidth(38*kb_font_scale);
	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
	imgui.PushID("Alternate ICAO:")
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
	local changed, textin = imgui.InputText("", activeBriefings:get("flight:alternateIcao"), 255)
	if changed then
		activeBriefings:set("flight:alternateIcao",textin)
	end
    imgui.PopStyleColor()
    imgui.PopItemWidth()
	imgui.PopStyleVar();

    imgui.SameLine()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
    imgui.TextUnformatted("|")
    imgui.SameLine()
	imgui.PushItemWidth(125*kb_font_scale);
	imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
	imgui.PushID("firstflight:")
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
	imgui.PopStyleVar();

    imgui.Separator()
    imgui.Separator()

-- Tabs
	if imgui.BeginTabBar("#briefings") then
	
		local index = 0
		local currentTab = 0
		
	-- FLIGHT tab 
		if imgui.BeginTabItem("FLIGHT") then
			
			imgui.BeginChild("flighttab")
			
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Route:")
			imgui.SameLine()
			imgui.PushItemWidth(700*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Route:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:planrwy") .. " " .. activeBriefings:get("flight:route") .. " " .. activeBriefings:get("flight:destinationIcao") ..  "/" .. activeBriefings:get("flight:destrwy"), 255)
			if changed then
				activeBriefings:set("flight:route",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Cruise Level:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Cruise Level:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("flight:cruiseLevel"), 0)
			if changed then
				activeBriefings:set("flight:cruiseLevel",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Cruise Profile:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:cruiseprofile"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Distance:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:distance") .. "nm")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Avg. Wind:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:averageWind"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Wind Component:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:averageWC"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Avg ISA:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:averageISA"))
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("CI:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:costIndex"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Cruise Mach:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:cruisemach"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Cruise TAS:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:cruisetas") .. " kts")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Climb Profile:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:climbprofile"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Descent Profile:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:descentprofile"))
			imgui.PopStyleColor()
			
			-- imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Step Climb:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:stepclimb"))
			imgui.PopStyleColor()

-- -------------------

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Departure Date:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:depdate"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Departure Time:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:deptime"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Arrival Time:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:arrtime"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Air Time:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:airtime"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Block Time:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(activeBriefings:get("flight:blocktime"))
			imgui.PopStyleColor()


			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Flight Times: Off Blocks:")
			imgui.SameLine()
			imgui.PushID("offtime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
			imgui.TextUnformatted(activeBckVars:get("general:timesOFF"))
			imgui.PopStyleColor()
			imgui.SameLine()
			imgui.PushID("offclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF","==:==") 
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Out:")
			imgui.SameLine()
			imgui.PushID("outtime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOUT",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
			imgui.TextUnformatted(activeBckVars:get("general:timesOUT"))
			imgui.PopStyleColor()
			imgui.SameLine()
			imgui.PushID("outclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOUT","==:==") 
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| In:")
			imgui.SameLine()
			imgui.PushID("intime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesIN",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
			imgui.TextUnformatted(activeBckVars:get("general:timesIN"))
			imgui.PopStyleColor()
			imgui.SameLine()
			imgui.PushID("inclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesIN","==:==") 
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| On Blocks:")
			imgui.SameLine()
			imgui.PushID("ontime:")
			if imgui.Button("S", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesON",kc_dispTimeHHMM(get("sim/time/zulu_time_sec"))) 
			end
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FFFF)
			imgui.TextUnformatted(activeBckVars:get("general:timesON"))
			imgui.PopStyleColor()
			imgui.SameLine()
			imgui.PushID("onclear:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesON","==:==") 
			end

			imgui.SameLine()
			imgui.PushID("allclear:")
			if imgui.Button("RST", 30*kb_font_scale, 20*kb_font_scale) then
				activeBckVars:set("general:timesOFF","==:==") 
				activeBckVars:set("general:timesOUT","==:==") 
				activeBckVars:set("general:timesIN","==:==") 
				activeBckVars:set("general:timesON","==:==") 
			end
			imgui.Separator()

			imgui.EndChild()
			
		imgui.EndTabItem()
		end

	-- WEIGHTS tab 
		if imgui.BeginTabItem("LOAD") then

			imgui.BeginChild("loadtab")

			local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Weights: Gross:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(string.format("%6.6i %s",kc_get_gross_weight(),wunit))
			imgui.PopStyleColor()
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| ZFW:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(string.format("%6.6i %s",kc_get_zfw(),wunit) .. " (MZFW: " .. string.format("%6.6i %s",kc_get_MZFW(),wunit) .. ")")
			imgui.PopStyleColor()
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| MTOW / MLW:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(string.format("%6.6i %s",kc_get_MTOW(),wunit) .. " / " .. string.format("%6.6i %s",kc_get_MLW(),wunit))
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Weights: Cargo:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:cargoWeight") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Payload:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:payload") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| EST ZFW:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:zfw") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| EST TOW:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:tow") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| EST LDW:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:ldw") .. " KGS")
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Weights: PAX:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:paxcount"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Ramp Weight:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:rampweight") .. " KGS")
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Fuel: Total:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			local wunit = activePrefSet:get("general:weight_kgs") == true and "KGS" or "LBS"
			imgui.TextUnformatted(string.format("%6.6i %s (MFUEL: %6.6i %s)",kc_get_total_fuel(),wunit,kc_get_MaxFuel(),wunit))
			imgui.PopStyleColor()
	
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Trip Fuel:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:tripFuel") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Avg FF:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:averageFF") .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Min TO Fuel:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:minimumTakeoff") .. " KGS")
			imgui.PopStyleColor()

			local finreserv = activeBriefings:get("flight:reserve") + activeBriefings:get("flight:alternateBurn")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| RESERVE:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(finreserv .. " KGS")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Block Fuel:")
			imgui.SameLine()
			imgui.PushItemWidth(50);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Block Fuel:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("flight:takeoffFuel"), 0)
			if changed then
				activeBriefings:set("flight:takeoffFuel",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(" KGS")
			imgui.PopStyleColor()

			imgui.Separator()

			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("AIRPORT " .. activeBriefings:get("flight:originIcao")) then

			imgui.BeginChild("airporttab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Airport:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:originIcao") .. "/" .. activeBriefings:get("flight:originIata") .. " " .. activeBriefings:get("flight:originName"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Elevation:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("departure:aptElevation") .. " ft")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Transition Alt / Level:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("departure:transalt") .. "/FL" .. origtranslvl/100)
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Parking:")
			imgui.SameLine()
			imgui.PushItemWidth(35*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Taxi: Parked:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("taxi:parkingStand"), 255)
			if changed then
				activeBriefings:set("taxi:parkingStand",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Stand/Gate:")
			imgui.SameLine()
			imgui.PushItemWidth(120*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Stand/Gate:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Push:")
			imgui.SameLine()
			imgui.PushItemWidth(110*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Push:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Start:")
			imgui.SameLine()
			imgui.PushItemWidth(80*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Start Sequence:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("SQWK:")
			imgui.SameLine()
			imgui.PushItemWidth(35*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("squawk:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("departure:squawk"), 255)
			if changed then
				activeBriefings:set("departure:squawk",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Runway:")
			imgui.SameLine()
			imgui.PushItemWidth(28*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("dep Runway:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("flight:planrwy"), 255)
			if changed then
				activeBriefings:set("flight:planrwy",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Taxi Route:")
			imgui.SameLine()
			imgui.PushItemWidth(670*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Taxi Route:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("taxi:taxiRoute"), 255)
			if changed then
				activeBriefings:set("taxi:taxiRoute",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushID("clrtaxi:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBriefings:set("taxi:taxiRoute","") 
			end

			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 2);
			if imgui.Button("METAR", 70*kb_font_scale, 20*kb_font_scale) then
				if activePrefSet:get("general:askyMetar") then
					origmetar = kb_get_asky_metar(activeBriefings:get("flight:originIcao"))
				else
					origmetar = kb_get_xp_metar(activeBriefings:get("flight:originIcao"))
				end
			end
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(origmetar)
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("ATIS:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(origatis)
			imgui.PopStyleColor()

			imgui.Separator()

			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("DEPARTURE " .. activeBriefings:get("flight:originIcao")) then

			imgui.BeginChild("departuretab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Runway:")
			imgui.SameLine()
			imgui.PushItemWidth(28*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("dep Runway:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("flight:planrwy"), 255)
			if changed then
				activeBriefings:set("flight:planrwy",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Condition:")
			imgui.SameLine()
			imgui.PushItemWidth(50*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Departure condition:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Type:")
			imgui.SameLine()
			imgui.PushItemWidth(73*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Departure Type:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			if activeBriefings:get("departure:deptype") == 1 then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Route:")
				imgui.SameLine()
				imgui.PushItemWidth(55*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("DepRoute:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("departure:deproute"), 255)
				if changed then
					activeBriefings:set("departure:deproute",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();

				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Transition:")
				imgui.SameLine()
				imgui.PushItemWidth(50*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("DepTransition:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("departure:deptransition"), 255)
				if changed then
					activeBriefings:set("departure:deptransition",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| QNH:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("depqnh:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:atisQNH"), 0)
			if changed then
				activeBriefings:set("departure:atisQNH",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("T/O: Thrust")
			imgui.SameLine()
			imgui.PushItemWidth(160*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff thrust:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| A-Ice:")
			imgui.SameLine()
			imgui.PushItemWidth(125*kb_font_scale);
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
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Packs")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff packs:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Bleeds")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff bleeds:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| MSA:")
			imgui.SameLine()
			imgui.PushItemWidth(42*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff msa:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:msa"), 0)
			if changed then
				activeBriefings:set("takeoff:msa",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("T/O: Trim: Pitch:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff elevator:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:elevatorTrim"), 0, 0.1, "%4.2f")
			if changed then
				activeBriefings:set("takeoff:elevatorTrim",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Rudder:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff rudder:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:rudderTrim"), 0, 0.1, "%4.2f")
			if changed then
				activeBriefings:set("takeoff:rudderTrim",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	
			
			if kc_type_airbus == false then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Aileron:")
				imgui.SameLine()
				imgui.PushItemWidth(40*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("takeoff aileronTrim:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputFloat("", activeBriefings:get("takeoff:aileronTrim"), 0, 0.1, "%4.2f")
				if changed then
					activeBriefings:set("takeoff:aileronTrim",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();	
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Flaps")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| DH:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("depdecisionheight:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:decision"), 0)
			if changed then
				activeBriefings:set("departure:decision",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("T/O: V1:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff v1:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v1"), 0)
			if changed then
				activeBriefings:set("takeoff:v1",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Vr:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff vr:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:vr"), 0)
			if changed then
				activeBriefings:set("takeoff:vr",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("V2:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff v2:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("takeoff:v2"), 0)
			if changed then
				activeBriefings:set("takeoff:v2",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| HDG:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff init hdg:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initHeading"), 0)
			if changed then
				activeBriefings:set("departure:initHeading",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
		

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Init Alt:")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff init alt:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:initAlt"), 0)
			if changed then
				activeBriefings:set("departure:initAlt",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| CRS1:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff crs1:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:nav1Course"), 0)
			if changed then
				activeBriefings:set("departure:nav1Course",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("CRS2:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("takeoff crs2:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("departure:nav2Course"), 0)
			if changed then
				activeBriefings:set("departure:nav2Course",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("T/O: Forced Return")
			imgui.SameLine()
			imgui.PushItemWidth(92*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("A/P Mode:")
			imgui.SameLine()
			imgui.PushItemWidth(85*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();



			imgui.Separator()
			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("ARRIVAL ".. activeBriefings:get("flight:destinationIcao")) then

			imgui.BeginChild("arrivaltab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Airport:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:destinationIcao") .. "/" .. activeBriefings:get("flight:destinationIata") .. " " .. activeBriefings:get("flight:destinationName"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Elevation:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("arrival:aptElevation") .. " ft")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Transition Alt / Level:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(desttransalt .. "/FL" .. activeBriefings:get("arrival:translvl")/100)
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Arrival: RWY:")
			imgui.SameLine()
			imgui.PushItemWidth(28*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("ArrivalRunway:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("flight:destrwy"), 255)
			if changed then
				activeBriefings:set("flight:destrwy",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Condition:")
			imgui.SameLine()
			imgui.PushItemWidth(50*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Arrival condition:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Type:")
			imgui.SameLine()
			imgui.PushItemWidth(73*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Arrival Type:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();

			if activeBriefings:get("arrival:arrType") == 1 then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Route:")
				imgui.SameLine()
				imgui.PushItemWidth(55*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("ArrRoute:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("arrival:arrroute"), 255)
				if changed then
					activeBriefings:set("arrival:arrroute",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();

				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Transition:")
				imgui.SameLine()
				imgui.PushItemWidth(50*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("ArrTransition:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("arrival:arrtransition"), 255)
				if changed then
					activeBriefings:set("arrival:arrtransition",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| QNH:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("arrqnh:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:atisQNH"), 0)
			if changed then
				activeBriefings:set("arrival:atisQNH",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 2);
			if imgui.Button(activeBriefings:get("flight:destinationIcao"), 80*kb_font_scale, 20*kb_font_scale) then
				if activePrefSet:get("general:askyMetar") then
					destmetar = kb_get_asky_metar(activeBriefings:get("flight:destinationIcao"))
				else
					destmetar = kb_get_xp_metar(activeBriefings:get("flight:destinationIcao"))
				end
			end
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(destmetar)
			imgui.PopStyleColor()


			imgui.Separator()

			imgui.EndChild()

		imgui.EndTabItem()
		end
		
		if imgui.BeginTabItem("APPROACH ".. activeBriefings:get("flight:destinationIcao")) then

			imgui.BeginChild("destapptab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Type:")
			imgui.SameLine()
			imgui.PushItemWidth(120*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| FAF Alt:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("FAFAlt:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:fafAltitude"), 0)
			if changed then
				activeBriefings:set("approach:fafAltitude",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| DH:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("decisionheight:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:decision"), 0)
			if changed then
				activeBriefings:set("approach:decision",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Vref:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("vref:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vref"), 0)
			if changed then
				activeBriefings:set("approach:vref",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Vapp:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("vapp:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vapp"), 0)
			if changed then
				activeBriefings:set("approach:vapp",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Flaps:")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| A/B:")
			imgui.SameLine()
			imgui.PushItemWidth(60*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Packs:")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| A-Ice:")
			imgui.SameLine()
			imgui.PushItemWidth(125*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| GA: Alt:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("gaalt:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaaltitude"), 0)
			if changed then
				activeBriefings:set("approach:gaaltitude",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Hdg:")
			imgui.SameLine()
			imgui.PushItemWidth(20*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("gahdh:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaheading"), 0)
			if changed then
				activeBriefings:set("approach:gaheading",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("CRS1:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("apprcrs1:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav1Course"), 0)
			if changed then
				activeBriefings:set("approach:nav1Course",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("CRS2:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("apprcrs2:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:nav2Course"), 0)
			if changed then
				activeBriefings:set("approach:nav2Course",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
	


			imgui.Separator()

			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("AIRPORT ".. activeBriefings:get("flight:destinationIcao")) then

			imgui.BeginChild("destapptab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Airport:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:destinationIcao") .. "/" .. activeBriefings:get("flight:destinationIata") .. " " .. activeBriefings:get("flight:destinationName"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Elevation:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("arrival:aptElevation") .. " ft")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Transition Alt / Level:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(desttransalt .. "/FL" .. activeBriefings:get("arrival:translvl")/100)
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Taxi: Stand/Gate:")
			imgui.SameLine()
			imgui.PushItemWidth(120*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Parking:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("land: Parked:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("approach:parkingPosition"), 255)
			if changed then
				activeBriefings:set("approach:parkingPosition",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Ext Pwr:")
			imgui.SameLine()
			imgui.PushItemWidth(80*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| APU:")
			imgui.SameLine()
			imgui.PushItemWidth(85*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Taxi Route:")
			imgui.SameLine()
			imgui.PushItemWidth(670*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("taxi in Route:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("approach:taxiIn"), 255)
			if changed then
				activeBriefings:set("approach:taxiIn",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushID("clrtaxi2:")
			if imgui.Button("C", 15*kb_font_scale, 20*kb_font_scale) then
				activeBriefings:set("approach:taxiIn","") 
			end
	
			imgui.Separator()

			imgui.EndChild()

		imgui.EndTabItem()
		end

		if imgui.BeginTabItem("ALTERNATE " .. activeBriefings:get("flight:alternateIcao")) then
			imgui.BeginChild("altntab")

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Airport:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("flight:alternateIcao") .. "/" .. activeBriefings:get("flight:alternateIata") .. " " .. activeBriefings:get("flight:alternateName"))
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Elevation:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(activeBriefings:get("arrival:altnElevation") .. " ft")
			imgui.PopStyleColor()

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Transition Alt / Level:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			imgui.TextUnformatted(altntransalt .. "/FL" .. activeBriefings:get("arrival:alttranslvl")/100)
			imgui.PopStyleColor()

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Arrival: RWY:")
			imgui.SameLine()
			imgui.PushItemWidth(28*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("alternateRunway:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputText("", activeBriefings:get("flight:altnrwy"), 255)
			if changed then
				activeBriefings:set("flight:altnrwy",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Condition:")
			imgui.SameLine()
			imgui.PushItemWidth(50*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Arrival condition:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
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
			imgui.PopStyleVar();


			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Type:")
			imgui.SameLine()
			imgui.PushItemWidth(73*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("Alternate Type:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			if imgui.BeginCombo("", kc_split(kc_APP_proctype_list,"|")[activeBriefings:get("arrival:altnarrType")]) then
				local options = kc_split(kc_APP_proctype_list,"|")
				for i = 1, #options do
					if imgui.Selectable(options[i], activeBriefings:get("altnarrival:arrType") == i) then
						activeBriefings:set("altnarrival:arrType",i)
					end
				end
			imgui.EndCombo()
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			if activeBriefings:get("arrival:altnarrType") == 1 then
				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Route:")
				imgui.SameLine()
				imgui.PushItemWidth(55*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("AltnArrRoute:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("arrival:altnarrroute"), 255)
				if changed then
					activeBriefings:set("arrival:altnarrroute",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();

				imgui.SameLine()
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
				imgui.TextUnformatted("Transition:")
				imgui.SameLine()
				imgui.PushItemWidth(50*kb_font_scale);
				imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
				imgui.PushID("altnArrTransition:")
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
				local changed, textin = imgui.InputText("", activeBriefings:get("arrival:altnarrtransition"), 255)
				if changed then
					activeBriefings:set("arrival:altnarrtransition",textin)
				end
				imgui.PopStyleColor()
				imgui.PopItemWidth()
				imgui.PopStyleVar();
			end

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| QNH:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altnarrqnh:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("arrival:altnatisQNH"), 0)
			if changed then
				activeBriefings:set("arrival:altnatisQNH",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Approach: Type:")
			imgui.SameLine()
			imgui.PushItemWidth(120*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altn takeoff forced:")
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| FAF Alt:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altnFAFAlt:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:fafAltitude"), 0)
			if changed then
				activeBriefings:set("approach:fafAltitude",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| DH:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altndecisionheight:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:decision"), 0)
			if changed then
				activeBriefings:set("approach:decision",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Vref:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altnvref:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vref"), 0)
			if changed then
				activeBriefings:set("approach:vref",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Vapp:")
			imgui.SameLine()
			imgui.PushItemWidth(30*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("altnvapp:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:vapp"), 0)
			if changed then
				activeBriefings:set("approach:vapp",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	

			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Flaps:")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| A/B:")
			imgui.SameLine()
			imgui.PushItemWidth(60*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| Packs:")
			imgui.SameLine()
			imgui.PushItemWidth(45*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| A-Ice:")
			imgui.SameLine()
			imgui.PushItemWidth(125*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
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
			imgui.PopStyleVar();

			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("| GA: Alt:")
			imgui.SameLine()
			imgui.PushItemWidth(40*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("gaalt:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaaltitude"), 0)
			if changed then
				activeBriefings:set("approach:gaaltitude",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();	
			
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFCCCCCC)
			imgui.TextUnformatted("Hdg:")
			imgui.SameLine()
			imgui.PushItemWidth(20*kb_font_scale);
			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 0);
			imgui.PushID("gahdh:")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF1b9af8)
			local changed, textin = imgui.InputInt("", activeBriefings:get("approach:gaheading"), 0)
			if changed then
				activeBriefings:set("approach:gaheading",textin)
			end
			imgui.PopStyleColor()
			imgui.PopItemWidth()
			imgui.PopStyleVar();

--

			imgui.PushStyleVar_2(imgui.constant.StyleVar.FramePadding, 3, 2);
			if imgui.Button(activeBriefings:get("flight:alternateIcao"), 80*kb_font_scale, 20*kb_font_scale) then
				if activePrefSet:get("general:askyMetar") then
					destmetar = kb_get_asky_metar(activeBriefings:get("flight:alternateIcao"))
				else
					destmetar = kb_get_xp_metar(activeBriefings:get("flight:alternateIcao"))
				end
			end
			imgui.PopStyleVar();
			imgui.SameLine()
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF95C857)
			imgui.TextUnformatted(altnmetar)
			imgui.PopStyleColor()

			imgui.Separator()

			imgui.EndChild()
		imgui.EndTabItem()
		end

	imgui.EndTabBar()
	end

end

if kc_file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_prefs\\" .. kc_acf_icao .. ".preferences") then
	getActivePrefs():load()
end
logMsg(activePrefSet:get("general:simbriefuser"))

-- command to toggle the brief window
create_command("kpbrief/window/open", "KPBrief: Open/Close", "kb_brief_toggle_wnd()", "", "")