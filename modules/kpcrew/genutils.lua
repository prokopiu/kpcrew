-- General utilities used in kpcrew and kphardware
-- some new features and ideas thanks to patrickl92

local socket = require "socket"

local drefTextout = "sim/operation/prefs/text_out"
local debugLoggingEnabled = false

-- color definitions
color_red 			= 0xFF0000FF
color_green 		= 0xFF558817
color_dark_green 	= 0xFF007f00
color_white 		= 0xFFFFFFFF
color_light_blue 	= 0xFFFFFF00
color_orange 		= 0xFF003FBF
color_grey 			= 0xFFC0C0C0
color_dark_grey 	= 0xFF606060
color_left_display 	= 0xFFA0AFFF
color_ocean_blue 	= 0xFFEC652B
color_checklist		= 0xFF2F4F4F
color_procedure		= 0xFF808000

-- speak text but don't show in sim, speakMode is used to prevent repetitive playing
-- speakmode 1 will talk and show, 0 will only speak
function speakNoText(speakMode, sText)
	if sText ~= "" and sText ~= nil then
		if speakMode == 0 then
			set(drefTextout,0)
			XPLMSpeakString(sText)
			set(drefTextout,1)
		else	
			set(drefTextout,1)
			XPLMSpeakString(sText)
		end
	end
end

------------- text conversion related functions ---------------

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

------------- file related functions ---------------

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

------------- coordinates related functions ---------------

-- convert a coordinate from x-plane to deg,min,sec format
function toDegreesMinutesAndSeconds(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return degrees .. "°" .. minutes .. "'" .. seconds .. "\"";
end

-- convert position to full coordinate string with N/S and E/W
function convert_DMS(lat, lng) 
    local latitude = toDegreesMinutesAndSeconds(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = toDegreesMinutesAndSeconds(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return latitude .. " " .. latitudeCardinal .. " - " .. longitude .. " " .. longitudeCardinal;
end

------------- time related functions ---------------

-- return a full time string from given time in seconds of day
function display_timefull(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	local lsec = math.floor(timeseconds - (lhours * 3600) - (lminutes * 60))
	return string.format("%2.2i:%2.2i:%2.2i",lhours,lminutes,lsec)
end

-- return a hh:mm string from given time in seconds of day
function display_timehhmm(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	return string.format("%2.2i:%2.2i",lhours,lminutes)
end

--- Gets the current time. (patrickl92)
-- The function uses the <code>gettime()</code> function of LuaSocket, which provides the current time with milliseconds resolution.
-- @treturn number The current time.
function getPCTime()
	return socket.gettime()
end

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

function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

-- input field dropdown
function gui_in_dropdown(lable, srcval, list, width)
	imgui.BeginChild(lable, width, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 1)
		imgui.SetColumnWidth(1, width)
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
	imgui.EndChild()
	return srcval
end

-- get daylight 0=dark 1=bright
function is_daylight()
	if get("sim/private/stats/skyc/sun_amb_b") < 0.02 then
		return false
	else
		return true
	end
end

-- split string function
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


-- imgui supplementary functions
function imgui_center(text) 
    local win_width = imgui.GetWindowWidth()
	local text_width, text_height = imgui.CalcTextSize(text)
	imgui.SetCursorPos(win_width / 2 - text_width / 2, imgui.GetCursorPosY())
	imgui.TextUnformatted(text)
end
