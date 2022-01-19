-- General utilities used in kpcrew and kphardware
-- some new features and ideas thanks to patrickl92
local genutils = {}

local socket = require "socket"

local drefTextout = "sim/operation/prefs/text_out"
local debugLoggingEnabled = false

------------- logging related functions ---------------

--- Writes a log message into the X-Plane log file. (patrickl92)
local function logMessage(source, severity, message)
    genutils.verifyType("source", source, "string")
    genutils.verifyType("severity", severity, "string")
    genutils.verifyType("message", message, "string")

    logMsg(tostring(genutils.getPCTime()) .. " kpcrew." .. source .. " [" .. severity .. "]: " .. message)
end

--- Verifies that a value is of the expected type. (patrickl92)
-- An error is thrown if the type of the value does not match the expected type.
function genutils.verifyType(valueName, value, expectedType)
    if type(valueName) ~= "string" then error("valueName must be a string") end
    if type(expectedType) ~= "string" then error("expectedType must be a string") end

    if type(value) ~= expectedType then
        error(valueName .. " must be a " .. expectedType)
    end
end

--- Writes an information log message into the X-Plane log file. (patrickl92)
function genutils.logInfo(source, message)
    logMessage(source, "INFO", message)
end

--- Enables the logging of debug messages. (patrickl92)
function genutils.enableDebugLogging()
    debugLoggingEnabled = true
end

--- Disables the logging of debug messages. (patrickl92)
function genutils.disableDebugLogging()
    debugLoggingEnabled = false
end

--- Writes a debug log message into the X-Plane log file. (patrickl92)
-- The message is only written if debug logging is enabled.
function genutils.logDebug(source, message)
    if debugLoggingEnabled then
        logMessage(source, "DEBUG", message)
    end
end

--- Writes an error log message into the X-Plane log file. (patrickl92)
function genutils.logError(source, message)
    logMessage(source, "ERROR", message)
end

-- speak text but don't show in sim, speakMode is used to prevent repetitive playing
-- speakmode 1 will talk and show, 0 will only speak
function genutils.speakNoText(speakMode, sText)
	if speakMode == 0 then
		set(drefTextout,0)
		XPLMSpeakString(sText)
		set(drefTextout,1)
	else	
		set(drefTextout,1)
		XPLMSpeakString(sText)
	end
end

------------- text conversion related functions ---------------

-- split up text in single characters and separate by space
function genutils.singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local c = intext:sub(i,i)
		outtext = outtext .. c .. " "
	end
	return outtext
end

-- convert text into NATO alphabet words
function genutils.convertNato(intext)

	-- the NATO alphabet
	local nato = {["a"] = "Alpha", ["b"] = "Bravo", ["c"] = "Charlie", ["d"] = "Delta", ["e"] = "Echo", ["f"] = "Foxtrot",
		["g"] = "Golf", ["h"] = "Hotel", ["i"] = "India", ["j"] = "Juliet", ["k"] = "Kilo", ["l"] = "Lima", 
		["m"] = "Mike", ["n"] = "November", ["o"] = "Oscar", ["p"] = "Papa", ["q"] = "Quebec", ["r"] = "Romeo", 
		["s"] = "Sierra", ["t"] = "Tango", ["u"] = "Uniform", ["v"] = "Victor", ["w"] = "Whiskey", ["x"] = "X Ray",
		["y"] = "Yankee", ["z"] = "Zulu", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " ", ["."] = "Point", [","] = "Comma"
	}
	intext = string.lower(intext)
	intext = genutils.singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

-- convert runway designators to spoken characters, translating L,C,R
function genutils.convertRwy(intext)

	local nato = {["c"] = "Center", ["l"] = "Left", ["r"] = "Right", ["0"] = "Zero", ["1"] = "One", ["2"] = "Two", ["3"] = "Tree", ["4"] = "Four", 
		["5"] = "Five", ["6"] = "Six", ["7"] = "Seven", ["8"] = "Eight", ["9"] = "Niner", ["-"] = "Dash", [" "] = " "
	}
	intext = string.lower(intext)
	intext = genutils.singleLetters(intext)
	local outtext = ""
	for i = 1, string.len(intext) do
		local natoword = nato[intext:sub(i,i)]
		outtext = outtext .. natoword .. " "
	end
	return outtext	
end

------------- file related functions ---------------

-- check if external lua file exists
function genutils.file_exists(name)
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
function genutils.toDegreesMinutesAndSeconds(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return degrees .. "°" .. minutes .. "'" .. seconds .. "\"";
end

-- convert position to full coordinate string with N/S and E/W
function genutils.convert_DMS(lat, lng) 
    local latitude = genutils.toDegreesMinutesAndSeconds(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = genutils.toDegreesMinutesAndSeconds(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return latitude .. " " .. latitudeCardinal .. " - " .. longitude .. " " .. longitudeCardinal;
end

------------- time related functions ---------------

-- return a full time string from given time in seconds of day
function genutils.display_timefull(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	local lsec = math.floor(timeseconds - (lhours * 3600) - (lminutes * 60))
	return string.format("%2.2i:%2.2i:%2.2i",lhours,lminutes,lsec)
end

-- return a hh:mm string from given time in seconds of day
function genutils.display_timehhmm(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	return string.format("%2.2i:%2.2i",lhours,lminutes)
end

--- Gets the current time. (patrickl92)
-- The function uses the <code>gettime()</code> function of LuaSocket, which provides the current time with milliseconds resolution.
-- @treturn number The current time.
function genutils.getPCTime()
	return socket.gettime()
end

return genutils