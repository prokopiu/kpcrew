-- Based on the Get METAR for Airport from sparker

-- True if VR is enabled, false if it is disabled
dataref("vr_enabled","sim/graphics/VR/enabled","readonly")
-- What system is currently controlling the weather. 0 = Preset, 1 = Real Weather, 2 = Controlpad, 3 = Plugin.
dataref("weather_source","sim/weather/region/weather_source","readonly")

-- degrees	[0 - 360] The direction the wind is blowing from in degrees from true north clockwise.
wind_direction_degt = dataref_table("sim/weather/aircraft/wind_direction_degt")
-- >=	0. The wind speed in knots.
wind_speed_kts = dataref_table("sim/weather/aircraft/wind_speed_kts")
-- Gust speed in knots	
dataref("wind_gust_kts","sim/weather/view/wind_gust_kts","readonly")
-- >= 0. The reported visibility (e.g. what the METAR/weather window says).
dataref("visibility_reported_sm","sim/weather/aircraft/visibility_reported_sm","readonly")
dataref("visibility_reported_m","sim/weather/visibility_reported_m","readonly")

-- CLR = 0  FEW = 0.125  SCT = 0.375  BKN = 0.75  OVC = 1
-- These numbers are only correct if "Manually Enter Weather" is selected.
-- If "Download Real Weather" is selected they are very different.
-- Not sure if at this time it is a bug or just the way it is.    
cloud_coverage = dataref_table("sim/weather/aircraft/cloud_coverage_percent")
-- meters	MSL >= 0. The base altitude for this cloud layer.
cloud_base_msl_m = dataref_table("sim/weather/aircraft/cloud_base_msl_m")
-- degreesC Temperature	and ISA temperature at pressure altitudes given in C
dataref("temperatures_aloft_deg_c","sim/weather/aircraft/temperatures_aloft_deg_c","readonly")
-- degreesC	The dew point at specified levels in the atmosphere.
dataref("dewpoint_deg_c","sim/weather/aircraft/dewpoint_deg_c","readonly")
-- pascals	Pressure at sea level, current planet
dataref("sealevel_pressure_pas","sim/weather/region/sealevel_pressure_pas","readonly")

local d = ""
local dd = ""
local _year = ""
local _month = ""
local _day = ""
local _hour = ""
local _minute = ""

local airport_icao = ""
local zulu_date_time = ""
local metar_file_name = ""
local text_minute = ""
local text_hour = ""

local metar_file_found_text = ""
local metar_file_path = ""
local number_of_lines_string = ""
local airport_metar = ""
local reduce_current_zulu_time_string = ""
local manual_airport_metar_path_name = ""

local line = 0
local line_number = 0
local reduce_current_zulu_minute = 15
local reduce_current_zulu_hour = 0
local real_weather_metar_file = 0
local found_match = 0

-- get the METAR for given airport icao from XP metar file when real weather is activated
function kp_get_airport_metar(airport_icao)
	-- if weather_source ~= 0 then
	
		_year = os.date("!%Y")
		_month = os.date("!%m")
		_day = os.date("!%d")
		_hour = os.date("!%H")
		_minute = os.date("!%M")
	
		local int_hour = tonumber(_hour)
		local int_minute = tonumber(_minute)
		if reduce_current_zulu_hour == 1 then
			if int_hour == 0 then
				int_hour = 23
			else
				int_hour = int_hour - 1
				text_hour = string.format("%02d", int_hour)
			end	
			
		else
			text_hour = string.format("%02d", int_hour)
		end	
		
		int_minute = int_minute - reduce_current_zulu_minute
		if int_minute < 15 then
			text_minute = "00"
		elseif int_minute >= 15 and int_minute < 30 then
			text_minute = "15"
		elseif int_minute >= 30 and int_minute < 45 then
			text_minute = "30"
		elseif int_minute >= 45 then
			text_minute = "45"
		end
		-- if reduce_current_zulu_hour == 1 then
			-- text_minute = "30"
		-- end	
		-- build filename in 30 minute intervalls (:00 and :30)
		metar_file_name = "metar-" .. _year .. "-" .. _month .. "-" .. _day .. "-" .. text_hour .. "." .. text_minute .. ".txt"
		metar_file_path = ("./Output/real weather/" .. metar_file_name)
-- logMsg(metar_file_path)
		-- open the calculated file 
		real_weather_metar_file = io.open("./Output/real weather/" .. metar_file_name, "r")
		if real_weather_metar_file == nil then
			metar_file_found_text = "Did Not Find Real Weather Metar File"
			reduce_current_zulu_hour = 1 -- We back up the time by 30 minutes on next click of Get Airport Metar
		else
			metar_file_found_text = "Found Real Weather Metar File"
			reduce_current_zulu_hour = 0
			io.input(real_weather_metar_file) -- open the file
			metar_table = {} -- create a table called metar_table
			for line in real_weather_metar_file:lines() do -- insert each line into a table's position
				table.insert (metar_table, line)
				line_number = line_number + 1
			end
			line_number = 0
			io.close(real_weather_metar_file)
			airport_icao = airport_icao:upper()
			found_match = 0	
			for i = 1, #metar_table do	-- loop for record count of metar_table
				if string.match(metar_table[i], airport_icao) then -- if the line has the entered airport in it
					airport_metar = metar_table[i]	-- This is the entered airport metar
					found_match = 1
				end	
			end
			for k in pairs(metar_table) do -- trying to clean out the table
				metar_table[k] = nil
			end
			return airport_metar	
		end
	-- end
end

-- build metar from current x-plane weather
function kp_create_airport_metar(airport_icao)
	-- if weather_source == 0 then
		-- if SYSTEM == "IBM" then
--			os.execute('del /F /Q ".\\Output\\real weather\\*.txt"')
--			os.execute('del /F /Q ".\\Output\\real weather\\*.grib"')
		-- elseif SYSTEM == "LIN" then
--			os.execute('rm -rd ./Output/real weather/')
		-- elseif SYSTEM == "APL" then
	
		-- end

		dd = os.date("!%d%H%M")	

		if _minute > "30" then
			text_minute = "30"
		elseif _minute < "30" then
			text_minute = "00"
		end
		-- os.remove("./Output/real weather/metar-" .. _year .. "-" .. _month .. "-" .. _day .. "-" .. _hour .. "-" .. text_minute .. ".txt")	
		-- os.remove("./Output/real weather/metar-" .. airport_icao .. ".txt")	
		-- io.output(io.open("./Output/real weather/metar-" .. _year .. "-" .. _month .. "-" .. _day .. "-" .. _hour .. "-" .. text_minute .. ".txt", "a"))
		-- manual_airport_metar_path_name = ("./Output/real weather/metar-" .. _year .. "-" .. _month .. "-" .. _day .. "-" .. _hour .. "-" .. text_minute .. ".txt")
		-- manual_airport_metar_path_name = ("./Output/real weather/metar-" .. airport_icao .. ".txt")
		-- io.write(d, "\n")
--	find_nearest_airport()
		next_airport_index = XPLMFindNavAid( nil, nil, LATITUDE, LONGITUDE, nil, xplm_Nav_Airport)
		_, _, _, _, _, _, outID, outName = XPLMGetNavAidInfo( next_airport_index )

		airport_metar = outID .. " " .. dd .. "Z " .. string.format("%03.0f", wind_direction_degt[0]) .. string.format("%02.0f", wind_speed_kts[0]) .. "KT "
		-- io.write(airport_icao, " ", dd, "Z ", string.format("%03.0f", wind_direction_degt[0]), string.format("%02.0f", wind_speed_kts[0]), "KT ")

		if visibility_reported_m > 10000 then
			visibility_reported_sm = 9999
		end	
		airport_metar = airport_metar .. visibility_reported_sm .. " "
		-- io.write(visibility_reported_sm, "SM ")
		if cloud_coverage[0] < 0.05 then
			airport_metar = airport_metar .. "CLR "
 			-- io.write("CLR ")
		elseif (cloud_coverage[0] > 0.05) and  (cloud_coverage[0] < 0.25) then
			airport_metar = airport_metar .. "FEW"
			-- io.write("FEW")
			local cloud_base_msl_f0 = cloud_base_msl_m[0] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f0)
			-- io.write(string.format("%03.0f", cloud_base_msl_f0))
		elseif (cloud_coverage[0] > 0.25) and (cloud_coverage[0] < 0.50) then
			airport_metar = airport_metar .. "SCT"
			-- io.write("SCT")
			local cloud_base_msl_f0 = cloud_base_msl_m[0] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f0)
			-- io.write(string.format("%03.0f", cloud_base_msl_f0))		
		elseif (cloud_coverage[0] > 0.50) and (cloud_coverage[0] < 0.90) then	
			airport_metar = airport_metar .. "BKN"
			-- io.write("BKN")
			local cloud_base_msl_f0 = cloud_base_msl_m[0] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f0)
			-- io.write(string.format("%03.0f", cloud_base_msl_f0))		
		elseif cloud_coverage[0] > 0.90 then
			airport_metar = airport_metar .. "OVC"
			-- io.write("OVC")
			local cloud_base_msl_f0 = cloud_base_msl_m[0] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f0)
			-- io.write(string.format("%03.0f", cloud_base_msl_f0))		
		end
	
		if (cloud_coverage[1] > 0.05) and  (cloud_coverage[1] < 0.25) then
			airport_metar = airport_metar .. " FEW"
			-- io.write(" FEW")
			local cloud_base_msl_f1 = cloud_base_msl_m[1] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f1)
			-- io.write(string.format("%03.0f", cloud_base_msl_f1))
		elseif (cloud_coverage[1] > 0.25) and (cloud_coverage[1] < 0.50) then
			airport_metar = airport_metar .. " SCT"
			-- io.write(" SCT")
			local cloud_base_msl_f1 = cloud_base_msl_m[1] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f1)
			-- io.write(string.format("%03.0f", cloud_base_msl_f1))		
		elseif (cloud_coverage[1] > 0.50) and (cloud_coverage[1] < 0.90) then	
			airport_metar = airport_metar .. " BKN"
			-- io.write(" BKN")
			local cloud_base_msl_f1 = cloud_base_msl_m[1] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f1)
			-- io.write(string.format("%03.0f", cloud_base_msl_f1))	
		elseif cloud_coverage[1] > 0.90 then
			airport_metar = airport_metar .. " OVC"
			-- io.write(" OVC")
			local cloud_base_msl_f1 = cloud_base_msl_m[1] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f1)
			-- io.write(string.format("%03.0f", cloud_base_msl_f1))		
		end
	
		if (cloud_coverage[2] > 0.05) and  (cloud_coverage[2] < 0.25) then
			airport_metar = airport_metar .. " FEW"
			-- io.write(" FEW")
			local cloud_base_msl_f2 = cloud_base_msl_m[2] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f2)
			-- io.write(string.format("%03.0f", cloud_base_msl_f2))
		elseif (cloud_coverage[2] > 0.25) and (cloud_coverage[2] < 0.50) then
			airport_metar = airport_metar .. " SCT"
			-- io.write(" SCT")
			local cloud_base_msl_f2 = cloud_base_msl_m[2] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f2)
			-- io.write(string.format("%03.0f", cloud_base_msl_f2))		
		elseif (cloud_coverage[2] > 0.50) and (cloud_coverage[2] < 0.90) then	
			airport_metar = airport_metar .. " BKN"
			-- io.write(" BKN")
			local cloud_base_msl_f2 = cloud_base_msl_m[2] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f2)
			-- io.write(string.format("%03.0f", cloud_base_msl_f2))		
		elseif cloud_coverage[2] > 0.90 then
			airport_metar = airport_metar .. " OVC"
			-- io.write(" OVC")
			local cloud_base_msl_f2 = cloud_base_msl_m[2] * .03281
			airport_metar = airport_metar .. string.format("%03.0f", cloud_base_msl_f2)
			-- io.write(string.format("%03.0f", cloud_base_msl_f2))		
		end	
	
		airport_metar = airport_metar .. " "
		-- io.write(" ")
		if tonumber(temperatures_aloft_deg_c) < 0 then
			airport_metar = airport_metar .. "M"
			-- io.write("M")
			temperatures_aloft_deg_c = temperatures_aloft_deg_c * -1
		end
		temperatures_aloft_deg_c = string.format("%02.0f", temperatures_aloft_deg_c)
			airport_metar = airport_metar .. temperatures_aloft_deg_c
		-- io.write(temperatures_aloft_deg_c)
		airport_metar = airport_metar .. "/"
		-- io.write("/")
		if tonumber(dewpoint_deg_c) < 0 then
			airport_metar = airport_metar .. "M"
			-- io.write("M")
			dewpoint_deg_c = dewpoint_deg_c * -1
		end
		dewpoint_deg_c = string.format("%02.0f", dewpoint_deg_c)
		airport_metar = airport_metar .. dewpoint_deg_c
		-- io.write(dewpoint_deg_c)
		airport_metar = airport_metar .. " Q"
		-- io.write(" A")
		airport_metar = airport_metar .. string.format("%04.0f", sealevel_pressure_pas/100)
		-- airport_metar = airport_metar .. "/A"
		-- io.write(" A")
		-- local sealevel_pressure_inhg = sealevel_pressure_pas / 33.86
		-- airport_metar = airport_metar .. string.format("%04.0f", sealevel_pressure_inhg)
		-- io.write(string.format("%04.0f", sealevel_pressure_inhg))
		-- airport_metar = airport_metar .. " \n"
		-- io.write(" \n")
		-- airport_metar = airport_metar .. "\n"
		-- io.write("\n")
		-- io.close()
		
		-- local manual_metar = io.open(manual_airport_metar_path_name, "r")
		
		-- if manual_metar == nil then
			-- metar_file_found_text = "Did Not Find Manual File"
		-- else
			-- metar_file_found_text = "Found Manual File"
			-- io.input(manual_metar) -- open the file
			-- manual_metar_table = {} -- create a table called metar_table
			-- for line in manual_metar:lines() do -- insert each line into a table's position
				-- table.insert (manual_metar_table, line)
				-- line_number = line_number + 1
			-- end
			-- number_of_lines_string = string.format("%d", line_number)
			-- line_number = 0
			-- io.close(manual_metar)
			-- airport_icao = airport_icao:upper()
			-- found_match = 0
			-- for i = 1, #manual_metar_table do	-- loop for record count of metar_table
				-- if string.match(manual_metar_table[i], airport_icao) then -- if the line has the entered airport in it
					-- airport_metar = manual_metar_table[i]	-- This is the entered airport metar
					-- found_match = 1
					-- logMsg(">> " .. airport_metar)
					-- return airport_metar
				-- end	
			-- end
			-- for k in pairs(manual_metar_table) do -- trying to clean out the table
				-- manual_metar_table[k] = nil
			-- end
		-- end
	-- end
	return airport_metar
end

