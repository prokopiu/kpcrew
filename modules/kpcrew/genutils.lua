-- General utilities used in kpcrew and kphardware
-- some new features and ideas thanks to patrickl92

local socket = require "socket"

local drefTextout = "sim/operation/prefs/text_out"

-- color definitions
color_red 			= 0xFF0000FF
color_green 		= 0xFF558817
color_bright_green 	= 0xFF00FF00
color_dark_green 	= 0xFF002f00
color_white 		= 0xFFFFFFFF
color_light_blue 	= 0xFFFFFF00
color_orange 		= 0xFF003FBF
color_grey 			= 0xFFC0C0C0
color_dark_grey 	= 0xFF606060
color_left_display 	= 0xFFA0AFFF
color_ocean_blue 	= 0xFFEC652B

color_checklist		= 0xFF0F0F0F
color_procedure		= 0xFF202000
color_state			= 0xFF4F0000

color_mcp_button	= 0xFF303030
color_mcp_active	= 0xFF606060
color_mcp_hover		= 0xFF606060
color_mcp_text		= 0xFFC0C0C0
color_mcp_on		= 0xFF00FF00
color_mcp_off		= 0xFFC0C0C0

color_ctrl_bckgr	= 0xFF101010
color_ctrl_selected = 0xFF303030
color_mstr_flow_open = 0xFF404040

WX_Cloudcover_list = {"","FEW","SCT","BKN","OVC",""}
WX_Precipitation_list = {"NONE","DRIZZLE","LIGHT RAIN","RAIN","HEAVY RAIN","SNOW"}
WX_Cloud_list = {"NO","FEW","SCATTERED","BROKEN","OVERCAST"}

-- speak text but don't show in sim, speakMode is used to prevent repetitive playing
-- speakmode 1 will talk and show, 0 will only speak
function kc_speakNoText(speakMode, sText)
	if sText ~= "" and sText ~= nil then
	
		if speakMode == 0 then
			set(drefTextout,0)
			XPLMSpeakString(sText)
			-- set(drefTextout,1)
		else	
			set(drefTextout,1)
			XPLMSpeakString(sText)
		end
	end
end

------------- text conversion related functions ---------------

-- split up text in single characters and separate by space
function kc_singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local c = intext:sub(i,i)
		outtext = outtext .. c .. " "
	end
	return outtext
end

function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-- convert text into NATO alphabet words
function kc_convertNato(intext)

	-- the NATO alphabet
	local nato = {["a"] = "Alpha", ["b"] = "Bravo", ["c"] = "Charlie", ["d"] = "Delta", ["e"] = "Echo", ["f"] = "Foxtrot",
		["g"] = "Golf", ["h"] = "Hotel", ["i"] = "India", ["j"] = "Juliet", ["k"] = "Kilo", ["l"] = "Lima", 
		["m"] = "Mike", ["n"] = "November", ["o"] = "Oscar", ["p"] = "Papa", ["q"] = "Quebec", ["r"] = "Romeo", 
		["s"] = "Sierra", ["t"] = "Tango", ["u"] = "Uniform", ["v"] = "Victor", ["w"] = "Whiskey", ["x"] = "X Ray",
		["y"] = "Yankee", ["z"] = "Zulu", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " ", ["."] = "Point", [","] = "Comma"
	}
	intext = string.lower(intext)
	intext = kc_singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

-- convert runway designators to spoken characters, translating L,C,R
function kc_convertRwy(intext)

	local nato = {["c"] = "Center", ["l"] = "Left", ["r"] = "Right", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " "
	}
	intext = string.lower(intext)
	intext = kc_singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

-- parse string for function macros and replace for spoken text
function kc_parse_string(instring)
	local outstring = ""
	local elements = kc_split(instring,"#")
	for _, item in ipairs(elements) do
		local pitem = ""
		if string.sub(item,1,6) == "spell|" then
			pitem = kc_singleLetters(kc_split(item,"|")[2])
		elseif string.sub(item,1,5) == "nato|" then
			pitem = kc_convertNato(kc_split(item,"|")[2])
		elseif string.sub(item,1,4) == "rwy|" then
			pitem = kc_convertRwy(kc_split(item,"|")[2])
		elseif string.sub(item,1,9) == "exchange|" then
			pitem = kc_split(item,"|")[3]
		else
			pitem = item
		end
		outstring = outstring .. pitem
	end
	return outstring
end

-- parse string for function macros and replace for spoken text
function kc_unparse_string(instring)
	local outstring = ""
	local elements = kc_split(instring,"#")
	for _, item in ipairs(elements) do
		local pitem = ""
		if string.sub(item,1,6) == "spell|" then
			pitem = kc_split(item,"|")[2]
		elseif string.sub(item,1,5) == "nato|" then
			pitem = kc_split(item,"|")[2]
		elseif string.sub(item,1,4) == "rwy|" then
			pitem = kc_split(item,"|")[2]
		elseif string.sub(item,1,9) == "exchange|" then
			pitem = kc_split(item,"|")[2]
		else
			pitem = item
		end
		outstring = outstring .. pitem
	end
	return outstring
end

-- return QNH string
function kc_getQNHString(metar_data)
	local QNHstring = ""
	if metar_data.pressure ~= nil then
		if metar_data.pressure < 200 then 
			QNHstring = QNHstring .. string.format("%4.2f",metar_data.pressure)
		else
			QNHstring = QNHstring .. string.format("%4.4i",metar_data.pressure)
		end
	end
	return QNHstring
end

-- individual metar functions to be used also in other areas
function kc_METAR_wind(metar_data)
	local windstring = ""
	if metar_data.wind ~= nil then
		if metar_data.wind.direction == "VRB" then
			windstring = string.format("VRB%2.2i", metar_data.wind.speed)
		else
			windstring = string.format("%3.3i%2.2i", metar_data.wind.direction, metar_data.wind.speed)
		end
		if metar_data.wind.gust ~= nil then
			windstring = windstring .. "G" .. metar_data.wind.gust .. "KT"
		else
			windstring = windstring .. "KT"
		end
	end
	return windstring
end

function kc_METAR_visibility(metar_data)
	local visiblestring = ""
	if metar_data.visibility ~= nil then
		for i = 1, table.getn(metar_data.visibility),1 do
			visiblestring = visiblestring .. metar_data.visibility[i].distance .. " "
		end
	end
	return visiblestring	
end

function kc_METAR_precip(metar_data)
	local precipitation = ""
    local PHENOMENA = { 'DZ', 'RA', 'SN', 'SG', 'IC', 'PL', 'GR', 'GS', 'UP', 'BR', 'FG', 'FU', 'VA', 'DU', 'SA', 'HZ', 'PY', 'PO', 'SQ', 'FC', 'SS', 'DS'}
	local INTENSITY = { '', '-', '+', 'VC' }
	local DESCRIPTOR = { 'MI', 'PR', 'BC', 'DR', 'BL', 'SH', 'TS', 'FZ' }
	
	print(tprint(metar_data))
	if metar_data.weather ~= nil and table.getn(metar_data.weather) > 0 then 
		for i = 1, table.getn(metar_data.weather),1 do
			local descr = ""
			if metar_data.weather[i].descriptor ~= nil then
				descr=DESCRIPTOR[metar_data.weather[i].descriptor]
			end
			precipitation = precipitation .. INTENSITY[metar_data.weather[i].intensity] .. descr .. PHENOMENA[metar_data.weather[i].phenomena] .. " "
		end
	end
	return precipitation
	
end

function kc_METAR_clouds(metar_data)
	local CLOUD_COVERAGE  = { [1] = "CLR", [2] = "FEW", [3] = "SCT", [4] = "BKN", [5] = "OVC" }
	local CLDstring = ""
	if metar_data.clouds ~= nil then
		for i = 1, table.getn(metar_data.clouds),1 do
			CLDstring = CLDstring .. CLOUD_COVERAGE[metar_data.clouds[i].coverage] .. string.format("%3.3i",metar_data.clouds[i].altitude) .. " "
		end
	end
	return CLDstring
end

function kc_METAR_temps(metar_data)
	local tempstring = ""
	if metar_data.temperature ~= nil and metar_data.dewpoint ~= nil then
		tempstring = tempstring .. metar_data.temperature .. "/" .. metar_data.dewpoint
	end
	return tempstring
end

function kc_METAR_trend(metar_data)
	local trendstring = ""
	if metar_data.trend ~= nil then
		trendstring = metar_data.trend
	end
	return trendstring
end

function kc_fill_to_metar()
	activeBriefings:set("departure:atisWind",kc_METAR_wind(kc_metardata_local))
	activeBriefings:set("departure:atisVisibility",kc_METAR_visibility(kc_metardata_local))
	activeBriefings:set("departure:atisClouds",kc_METAR_clouds(kc_metardata_local))
	activeBriefings:set("departure:atisPrecipit",kc_METAR_precip(kc_metardata_local))
	activeBriefings:set("departure:atisTemps",kc_METAR_temps(kc_metardata_local))
	activeBriefings:set("departure:atisQNH",kc_getQNHString(kc_metardata_local))
	activeBriefings:set("departure:atisVcond",kc_METAR_trend(kc_metardata_local))
end

function kc_fill_ldg_metar()
	activeBriefings:set("arrival:atisWind",kc_METAR_wind(kc_metardata_dest))
	activeBriefings:set("arrival:atisVisibility",kc_METAR_visibility(kc_metardata_dest))
	activeBriefings:set("arrival:atisClouds",kc_METAR_clouds(kc_metardata_dest))
	activeBriefings:set("arrival:atisPrecipit",kc_METAR_precip(kc_metardata_dest))
	activeBriefings:set("arrival:atisTemps",kc_METAR_temps(kc_metardata_dest))
	activeBriefings:set("arrival:atisQNH",kc_getQNHString(kc_metardata_dest))
	activeBriefings:set("arrival:atisVcond",kc_METAR_trend(kc_metardata_dest))
end

-- build a makeshift ATIS string from XP11 weather - very simplistic
function kc_buildAtisString(station)
	ATISstring = station .. " " .. string.format("%2.2i%2.2i%2.2iZ ", get("sim/cockpit2/clock_timer/current_day"),get("sim/cockpit2/clock_timer/zulu_time_hours"),get("sim/cockpit2/clock_timer/zulu_time_minutes"))

-- ==== WIND
	local windstring = ""

	if get("sim/weather/shear_direction_degt[0]") > 10 and get("sim/weather/wind_speed_kt[0]") < 6 then
		windstring = string.format("VRB%2.2iKT", get("sim/weather/wind_speed_kt[0]")) 
	else
		windstring = string.format("%3.3i%2.2i", get("sim/weather/wind_direction_degt[0]"),get("sim/weather/wind_speed_kt[0]"))
	end

	if get("sim/weather/shear_speed_kt[0]") > get("sim/weather/wind_speed_kt[0]")+10 then
		windstring = windstring .. "G" .. string.format("%2.2i", get("sim/weather/shear_speed_kt[0]")) .. "KT"
	else
		windstring = windstring .. "KT"
	end
	
	if get("sim/weather/shear_direction_degt[0]") > 30 and get("sim/weather/wind_speed_kt[0]") > 6 then
		windstring = windstring .. " " .. string.format("%2.2iV%2.2i", (get("sim/weather/wind_direction_degt[0]")-get("sim/weather/shear_direction_degt[0]")),(get("sim/weather/wind_direction_degt[0]")+get("sim/weather/shear_direction_degt[0]"))) 
	end
	if windstring ~= "" then
		windstring = windstring .. " "
	end

-- ==== Visibility
	local visiblestring = ""
	local visibility = get("sim/weather/visibility_reported_m")
	if (visibility >= 10000) then
		visiblestring = "9999"
	end
	if (visibility < 9999 and visibility >= 5000) then
		local fullhundred = math.floor(visibility/1000)*1000
		visiblestring = string.format("%4.4i",fullhundred)
	end
	if (visibility < 5000) then
		visiblestring = string.format("%4.4i",visibility)
	end
	if visiblestring ~= "" then
		visiblestring = visiblestring .. " "
	end

-- ==== PRECIPITATION
	local precipitation = ""
	local descr = ""
	if activeBckVars:get("general:simversion") < 12000 then
		if get("sim/weather/thunderstorm_percent") > 0 then
			descr = "TS"
		end
	end
	
	if get("sim/weather/precipitation_on_aircraft_ratio") > 0 then
		if get("sim/weather/precipitation_on_aircraft_ratio") < 0.01 then
			precipitation = descr .. "DZ"
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.01 then
			precipitation = "-" .. descr ..  "RA"
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.05 then
			precipitation = descr .. "RA"
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.1 then
			precipitation = "+" .. descr .. "RA"
		end
		if get("sim/weather/temperature_ambient_c") < 0 then
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.01 then
				precipitation = "-" .. descr .. "SN"
			end
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.05 then
				precipitation = descr .. "SN"
			end
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.1 then
				precipitation = "+" .. descr .. "SN"
			end
		end
	end
	if precipitation ~= "" then
		precipitation = precipitation .. " "
	end
	
-- ==== other phenomena
	local phenomena = ""
	local vis = ""
	if visibility < 800 then
		vis = "FG"
	elseif visibility < 1500 then
		vis = "BR"
	elseif visibility < 4500 then
		vis = "HZ"
	end
	if vis ~= "" then
		phenomena = phenomena .. vis
	end 
	if phenomena ~= "" then
		phenomena = phenomena .. " "
	end

-- ==== CLOUD
	local APTAltitude = get("sim/cockpit2/autopilot/altitude_readout_preselector")
	local CLDcoverage = get("sim/weather/cloud_coverage[0]")
	local CLDstring = ""
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[0]")*3.28-APTAltitude)/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[1]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format(" %s%3.3i",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[1]")*3.28-APTAltitude)/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[2]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format(" %s%3.3i",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[2]")*3.28-APTAltitude)/100)
	end
	if CLDstring ~= "" then
		CLDstring = CLDstring .. " "
	end
	
-- ==== CAVOK
	local CAVOKstring = ""
	local cavokcld1 = get("sim/weather/cloud_base_msl_m[0]") > 5000 or get("sim/weather/cloud_coverage[0]") == 0
	local cavokcld2 = get("sim/weather/cloud_base_msl_m[1]") > 5000 or get("sim/weather/cloud_coverage[1]") == 0
	local cavokcld3 = get("sim/weather/cloud_base_msl_m[2]") > 5000 or get("sim/weather/cloud_coverage[2]") == 0
	if visibility > 10000 and cavokcld1 and cavokcld2 and cavokcld3 and precipitation == "" then
		CAVOKstring = "CAVOK "
		visiblestring = ""
		precipitation = ""
		CLDstring = ""
	end

-- ==== Temperature
	local tempstring = ""
	local ambtemp = get("sim/weather/temperature_ambient_c")
	local duepoint = get("sim/weather/dewpoi_sealevel_c")
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

-- ==== Other conditions
	local trend = ""
	if get("sim/weather/has_real_weather_bool") == 0 then 
		trend = "NOSIG"
	end

-- === QNH
	local qnhstring = ""
	if activePrefSet:get("general:baro_mode_hpa") then
		qnhstring = string.format("Q%4.4i",get("sim/weather/barometer_sealevel_inhg") / 0.02952999)
	else
		qnhstring = string.format("A%4.4i",((get("sim/weather/barometer_sealevel_inhg") * 10^2)*10^-2)*100)
	end
	
	ATISstring = ATISstring .. windstring .. visiblestring .. precipitation .. phenomena .. CLDstring .. CAVOKstring .. tempstring .. " " .. qnhstring .. " " .. trend
	
	return ATISstring
	-- "KOKC 161452Z 01014KT 10SM BKN120 OVC200 +TSRA 17/10 Q999 TEMPO RMK AO2 SLP182 VIRGA E T01670100 51005"
end

------------- file related functions ---------------

-- check if external lua file exists
function kc_file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then 
		io.close(f) 
		return true 
	else 
		return false 
	end
end

------------- coordinates related functions ---------------

-- convert a coordinate from x-plane to deg,min,sec format
function kc_toDegMinSec(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return degrees .. "°" .. minutes .. "'" .. seconds .. "\"";
end

-- convert coordinates to CIVA INS format
function kc_toDMS1(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return string.format("%2.2i%2.2i%1.1i",degrees,minutes,seconds/10);
end

-- convert a coordinate from x-plane to INS [N/S|E/W]ddmms format
function kc_convertINS(lat, lng) 
    local latitude = kc_toDMS1(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = kc_toDMS1(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return string.format("%s%s %s%s",latitudeCardinal,latitude,longitudeCardinal,longitude);
end

-- convert position to full coordinate string with N/S and E/W
function kc_convertDMS(lat, lng) 
    local latitude = kc_toDegMinSec(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = kc_toDegMinSec(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return latitude .. " " .. latitudeCardinal .. " - " .. longitude .. " " .. longitudeCardinal;
end

------------- time related functions ---------------

-- return a full time string from given time in seconds of day
function kc_dispTimeFull(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	local lsec = math.floor(timeseconds - (lhours * 3600) - (lminutes * 60))
	return string.format("%2.2i:%2.2i:%2.2i",lhours,lminutes,lsec)
end

-- return a hh:mm string from given time in seconds of day
function kc_dispTimeHHMM(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	return string.format("%2.2i:%2.2i",lhours,lminutes)
end

--- Gets the current time. (patrickl92)
-- The function uses the <code>gettime()</code> function of LuaSocket, which provides the current time with seconds resolution.
-- @treturn number The current time.
function kc_getPcTime()
	return socket.gettime()
end

-- return index position of value in an array
function kc_indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

-- see if a value is found in given array
function kc_hasValue (array, value)
    for i, v in ipairs(array) do
        if v == value then
            return true
        end
    end
    return false
end
-- get length of array/table
function kc_getLength (array)
	local lnum = 0
    for i, v in ipairs(array) do
		lnum = lnum +1 
    end
    return lnum
end

-- get daylight 0=dark 1=bright
function kc_is_daylight()
	if get("sim/private/stats/skyc/sun_amb_b") < 0.1 then
		return false
	else
		return true
	end
end

-- split string function
function kc_split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function kc_pref_split(s)
	return kc_split(s,"|")
end

-- ===== imgui supplementary functions =====

-- center text based on imgui window size
function kc_imgui_center(text)
    local win_width = imgui.GetWindowWidth()
	local text_width, text_height = imgui.CalcTextSize(text)
	imgui.SetCursorPos(win_width / 2 - text_width / 2, imgui.GetCursorPosY())
	imgui.TextUnformatted(text)
end

-- render a toggle button with green/grey status (label) for MCP
function kc_imgui_toggle_button_mcp(label,system,ypos,width,height)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)
	if system:getStatus() ~= 0 then 
		imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_on)
	else
		imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_off)
	end
	if imgui.Button(label, width, height) then
		system:actuate(modeToggle)
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end

-- render a rotary with + and - clickspots and value display for mcp
function kc_imgui_rotary_mcp(label,system,ypos,id)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)

    imgui.PushID(id)
	imgui.Button("-", 15, 25)
	if imgui.IsItemActive() then
		system:step(slowDown)
	end
	imgui.PopID()
	
	imgui.SameLine()
	imgui.SetCursorPosY(ypos + 2)
	imgui.TextUnformatted(string.format(label,system:getStatus()))

	imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	
    imgui.PushID(id)
	imgui.Button("+", 15, 25)
	if imgui.IsItemActive() then
		system:step(slowUp)
	end
	imgui.PopID()

	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end

function kc_imgui_selector_mcp(label,system,ypos,sarray,id)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)

    imgui.PushID(id)
	imgui.Button("-", 15, 25)
	if imgui.IsItemActive() then
		system:step(slowDown)
	end
	imgui.PopID()
	
	imgui.SameLine()
	imgui.SetCursorPosY(ypos + 2)
	imgui.TextUnformatted(string.format(label,sarray[system:getStatus()]))

	imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	
    imgui.PushID(id)
	imgui.Button("+", 15, 25)
	if imgui.IsItemActive() then
		system:step(slowUp)
	end
	imgui.PopID()

	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end


-- enter any value
function kc_imgui_value(label,system,ypos)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)

	imgui.SetCursorPosY(ypos + 2)
	imgui.TextUnformatted(string.format(label,system:getStatus()))

	imgui.SetCursorPosY(ypos)
	
	imgui.PopStyleColor()
end

-- render a label /also used as separator stroke)
function kc_imgui_label_mcp(label,ypos)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos+2)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)
	imgui.TextUnformatted(label)
	imgui.PopStyleColor()
	imgui.SetCursorPosY(ypos)
end

-- render a simple button without status light
function kc_imgui_simple_button_mcp(label,system,ypos,width,height)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)
	if imgui.Button(label, width, height) then
		system:actuate(modeToggle)
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end

function kc_imgui_simple_actuator(label,system,action,ypos,width,height)
    imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)
	if imgui.Button(label, width, height) then
		system:step(action)
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end

-- render a radio 1=com, 2=nav, 3=adf
function kc_imgui_radio(radio,label,course,fine,standby,active,flip,ypos,id)

    -- imgui.SameLine()
	imgui.SetCursorPosY(ypos)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_mcp_button)
	imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_mcp_active)
	imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_mcp_hover)
	imgui.PushStyleColor(imgui.constant.Col.Text,color_mcp_text)

    imgui.PushID(id)
	imgui.Button("--", 20, 25)
	if imgui.IsItemActive() then
		course:step(slowDown)
	end
	imgui.PopID()
	
	imgui.SameLine()
    imgui.PushID(id)
	imgui.Button("-", 20, 25)
	if imgui.IsItemActive() then
		fine:step(slowDown)
	end
	imgui.PopID()
	
	if radio == 1 then
		imgui.SameLine()
		imgui.SetCursorPosY(ypos + 2)
		imgui.TextUnformatted(string.format(label .. "%06.3f",standby:getStatus()/1000))

		imgui.SameLine()
		imgui.SetCursorPosY(ypos)
		imgui.PushStyleColor(imgui.constant.Col.Text,color_bright_green)
		imgui.Button(string.format("%06.3f",active:getStatus()/1000), 55, 25)
		if imgui.IsItemActive() then
			flip:actuate(2)
		end
		imgui.PopStyleColor()
	end
	if radio == 2 then
		imgui.SameLine()
		imgui.SetCursorPosY(ypos + 2)
		imgui.TextUnformatted(string.format(label .. "%05.2f",standby:getStatus()/100))

		imgui.SameLine()
		imgui.SetCursorPosY(ypos)
		imgui.PushStyleColor(imgui.constant.Col.Text,color_bright_green)
		imgui.Button(string.format("%05.2f",active:getStatus()/100), 55, 25)
		if imgui.IsItemActive() then
			flip:actuate(2)
		end
		imgui.PopStyleColor()
	end
	if radio == 3 then
		imgui.SameLine()
		imgui.SetCursorPosY(ypos + 2)
		imgui.TextUnformatted(string.format(label .. "%03.0f",standby:getStatus()))

		imgui.SameLine()
		imgui.SetCursorPosY(ypos)
		imgui.PushStyleColor(imgui.constant.Col.Text,color_bright_green)
		imgui.Button(string.format("%03.0f",active:getStatus()), 55, 25)
		if imgui.IsItemActive() then
			flip:actuate(2)
		end
		imgui.PopStyleColor()
	end
	
	imgui.SameLine()
    imgui.PushID(id)
	imgui.Button("+", 20, 25)
	if imgui.IsItemActive() then
		fine:step(slowUp)
	end
	imgui.PopID()

	imgui.SameLine()
    imgui.PushID(id)
	imgui.Button("++", 20, 25)
	if imgui.IsItemActive() then
		course:step(slowUp)
	end
	imgui.PopID()

	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
end

function kc_imgui_com_radio(label,course,fine,standby,active,flip,ypos,id)
	kc_imgui_radio(1,label,course,fine,standby,active,flip,ypos,id)
end

function kc_imgui_nav_radio(label,course,fine,standby,active,flip,ypos,id)
	kc_imgui_radio(2,label,course,fine,standby,active,flip,ypos,id)
end

function kc_imgui_adf_radio(label,course,fine,standby,active,flip,ypos,id)
	kc_imgui_radio(3,label,course,fine,standby,active,flip,ypos,id)
end

-- round number on given step level
function kc_round_step(num,step)
	return math.floor(num/step)*step
end

-- format string to thousand with dot
function kc_format_thousand(value)
    local s = string.format("%d", math.floor(value))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
    .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

-- table print for debugging
function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

-- ====== =process variable related utilities
-- does procvar exist?
function kc_procvar_exists(procvarid)
	local procvar = getBckVars():find("procvars:" .. procvarid)
	if procvar == nil then 
		return false
	else
		return true
	end
end
	
-- toggle a boolean procvar
function kc_procvar_toggle(procvarid)
	local procvar = getBckVars():find("procvars:" .. procvarid)
	if procvar:getValue() == true then 
		procvar:setValue(false)
	else
		procvar:setValue(true)
	end
end

-- set a procvar
function kc_procvar_set(procvarid, value)
	local procvar = getBckVars():find("procvars:" .. procvarid)
	procvar:setValue(value)
end

-- initialize a boolean procvar
function kc_procvar_initialize_bool(procvarid, value)
	local procvar = getBckVars():find("procvars:" .. procvarid)
	if procvar == nil then 
		kc_global_procvars:add(kcPreference:new(procvarid,value,kcPreference.typeToggle,procvarid .. "|TRUE|FALSE"))
	else
		kc_procvar_set(procvarid,value)
	end
end

-- initialize a counter procvar
function kc_procvar_initialize_count(procvarid, value)
	local procvar = getBckVars():find("procvars:" .. procvarid)
	if procvar == nil then 
		kc_global_procvars:add(kcPreference:new(procvarid,value,kcPreference.typeInt,procvarid .. "|0"))
	else
		kc_procvar_set(procvarid,value)
	end
end

-- get boolean procvar
function kc_procvar_get(procvarid)
	local procvar = getBckVars():find("procvars:".. procvarid)
	return procvar:getValue()
end

-- BetterPushback integration
function kc_pushback_plan()
	if activePrefSet:get("general:betterPushback") == true then
		command_once("BetterPushback/start_planner")
	end
end

function kc_pushback_call()
	if activePrefSet:get("general:betterPushback") == true then
		command_once("BetterPushback/connect_first")
	end
end

function kc_pushback_end()
	if activePrefSet:get("general:betterPushback") == true then
		command_once("BetterPushback/disconnect")
	end
end

-- start SGES start sequence
function kc_macro_start_sges_sequence()
		-- show_windoz()
		show_Automatic_sequence_start = true
		SGES_Automatic_sequence_start_flight_time_sec = SGES_total_flight_time_sec
end

function kc_show_sges_window()
	show_windoz()
end