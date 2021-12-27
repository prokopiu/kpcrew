--[[
	*** KPCREW 2.2
	Kosta Prokopiu, October 2021
	IMGUI related functionality
--]]


-- primary window, wndMode 1=float, 2=flat window
function kc_init_primary_window (wndMode)
	if (wndMode ~= 1 and wndMode ~= 2 and wndMode ~= 3) then	
		wndMode = 1
	end
	
	kc_primary_wnd = float_wnd_create(1046, 39, wndMode, true)
	if (wndMode == 1) then
		float_wnd_set_position(kc_primary_wnd, gScreenWidth/2 - 512 + get_kpcrew_config("wnd_primary_x_pos"), gScreenHeight - get_kpcrew_config("wnd_primary_y_offset") - 50)
	else
		float_wnd_set_position(kc_primary_wnd, gScreenWidth/2 - 512 + get_kpcrew_config("wnd_primary_x_pos"), gScreenHeight - get_kpcrew_config("wnd_primary_y_offset") - 30)
	end
	float_wnd_set_title(kc_primary_wnd, "KPCREW " .. ZC_VERSION)
	float_wnd_set_imgui_builder(kc_primary_wnd, "kc_primary_build")
	float_wnd_set_onclose(kc_primary_wnd, "kc_close_primary_window")
	gLeftText = "Welcome to KPCREW - Use [M] button to start procedure"
end

-- flight information window
function kc_init_flightinfo_window ()
	if kc_flightinfo_wnd == 0 then
		kc_flightinfo_wnd = float_wnd_create(400, 800, 1, true)
		float_wnd_set_title(kc_flightinfo_wnd, "KPCREW Flight Information")
		float_wnd_set_position(kc_flightinfo_wnd, 10 , gScreenHeight-900 )
		float_wnd_set_imgui_builder(kc_flightinfo_wnd, "kc_flightinfo_build")
		float_wnd_set_onclose(kc_flightinfo_wnd, "kc_close_flightinfo_window")
	end
end

---- custom window/menu items

-- input field text
function kc_gui_in_text(lable, srcval, length, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		imgui.TextUnformatted(lable .. ":")
		imgui.NextColumn()
		local changed, textin = imgui.InputText("                                " .. lable , srcval, length)
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		return textin
	end
	return srcval
end

-- input field multiline text
function kc_gui_in_multiline(lable, srcval, length, width, height)
	imgui.BeginChild(lable, width, height)
		imgui.TextUnformatted(lable .. ":")
		local changed, textin = imgui.InputTextMultiline("                       " .. lable , srcval, length, width, 20)
		imgui.PushTextWrapPos(width)
		imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(textin)
		imgui.PopTextWrapPos()
		imgui.PopStyleColor()
	imgui.EndChild()
	if changed then
		return textin
	end
	return srcval
end

-- input field integer
function kc_gui_in_int(lable, srcval, increment, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		imgui.TextUnformatted(lable .. ":")
		imgui.NextColumn()
		local changed, textin = imgui.InputInt("                       " .. lable , srcval, increment)
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		return textin
	end
	return srcval
end

-- input field integer
function kc_gui_in_alt_fl(lable, srcval, transition, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		if srcval > transition then
			lable = lable .. " FL"
			increment = 10
			value = srcval / 100
		else
			lable = lable .. " ft"
			increment = 1000
			value = srcval			
		end
		imgui.TextUnformatted(lable .. ":")
		imgui.NextColumn()
		local changed, textin = imgui.InputInt("                       " .. lable , value, increment)
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		if srcval > transition then
			return textin * 100
		else
			return textin
		end
	end
	return srcval
end

-- input field float
function kc_gui_in_float(lable, srcval, increment, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		imgui.TextUnformatted(lable .. ":")
		imgui.NextColumn()
		local changed, textin = imgui.InputFloat("                       " .. lable , srcval, 0.1, 1.0,"%4.2f")
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		return textin
	end
	return srcval
end

-- input field checkbox
function kc_gui_in_cb(lable, srcval, value, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		imgui.TextUnformatted(lable .. ":")
		imgui.NextColumn()
		if imgui.Checkbox("                                    " .. lable, srcval == value) then
			srcval = value
		end
		imgui.NextColumn()
	imgui.EndChild()
	return srcval
end

-- input field radiobutton
function kc_gui_in_trb(lable, srcval, caption1, caption2, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
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
	imgui.EndChild()
	return retval
end

-- input field dropdown
function kc_gui_in_dropdown(lable, srcval, list, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
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

-- input field com frequency - set COM1 when pressing lable
function kc_gui_in_freq(lable, srcval, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		if imgui.Button(lable .. ":") then
			set("sim/cockpit2/radios/actuators/com1_frequency_hz_833",(srcval+0.0001)*10000/10)
		end
		imgui.NextColumn()
		local changed, textin = imgui.InputFloat("                  " .. lable , srcval, 0.005, 1.00,"%4.3f")
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- input field nav 1 frequency
function kc_gui_nav_freq(lable, srcval, radio, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		if imgui.Button(lable .. ":") then
			kc_radio_nav_set(radio,srcval)
		end
		imgui.SameLine()
		imgui.NextColumn()
		local changed, textin = imgui.InputFloat("                  " .. lable , srcval, 0.05, 1.00,"%4.2f")
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- input field ndb frequency - set ADF1 when pressing lable
function kc_gui_ndb_freq(lable, srcval, width)
	imgui.BeginChild(lable, 340, 20)
		imgui.Columns(2,lable,false)
		imgui.SetColumnWidth(0, 150)
		imgui.SetColumnWidth(1, width)
		if imgui.Button(lable .. ":") then
			set("sim/cockpit/radios/adf1_freq_hz",srcval)
		end
		imgui.SameLine()
		imgui.NextColumn()
		local changed, textin = imgui.InputFloat("                      " .. lable , srcval, 1, 1.00,"%4.0f")
		imgui.NextColumn()
	imgui.EndChild()
	if changed then
		srcval = textin
		return textin
	end
	return srcval
end

-- output text lable
function kc_gui_out_text(lable, srcval, color, sameline)
	imgui.TextUnformatted(lable .. ":")
	if sameline then
		imgui.SameLine()
	end
	imgui.PushStyleColor(imgui.constant.Col.Text, color)
	imgui.PushTextWrapPos(390)
	imgui.TextUnformatted(srcval)
	imgui.PopTextWrapPos()
	imgui.PopStyleColor()
end

-- output text lable
function kc_gui_out_multiline_text(lable, srcval, color, width, height)
	imgui.BeginChild(lable, width, height)
		imgui.PushStyleColor(imgui.constant.Col.Text, color_green)
		imgui.TextUnformatted(lable .. ":")
		imgui.PopStyleColor()
		imgui.PushStyleColor(imgui.constant.Col.Text, color)
		imgui.PushTextWrapPos(width-10)
		imgui.TextUnformatted(srcval)
		imgui.PopTextWrapPos()
		imgui.PopStyleColor()
	imgui.EndChild()
end

---- ATIS related functions

-- return QNH string
function getQNHString()
	local QNHstring = ""
	if get_kpcrew_config("config_qnhhpa") then
		QNHstring = string.format("Q%4.4i",get("sim/weather/barometer_sealevel_inhg") / 0.02952999)
	else
		QNHstring = string.format("A%4.4i",((get("sim/weather/barometer_sealevel_inhg") * 10^2)*10^-2)*100)
	end
	return QNHstring
end

-- build a makeshift ATIS string from XP11 weather - very simplistic
function kc_build_atis_string()
	
	local ATISstring = string.format("%2.2i%2.2i%2.2iZ ", get("sim/cockpit2/clock_timer/current_day"),get("sim/cockpit2/clock_timer/zulu_time_hours"),get("sim/cockpit2/clock_timer/zulu_time_minutes"))
	
	local windstring = string.format("%3.3i%2.2i", get("sim/weather/wind_direction_degt[0]"),get("sim/weather/wind_speed_kt[0]"))
	if get("sim/weather/shear_speed_kt[0]") > 0 then
		windstring = windstring .. "G" .. string.format("%2.2i", get("sim/weather/shear_speed_kt[0]")) .. "KT"
	else
		windstring = windstring .. "KT"
	end
	
	if get("sim/weather/shear_direction_degt[0]") > 30 and get("sim/weather/wind_speed_kt[0]") > 6 then
		windstring = windstring .. " " .. string.format("%2.2iV%2.2i", (get("sim/weather/wind_direction_degt[0]")-get("sim/weather/shear_direction_degt[0]")),(get("sim/weather/wind_direction_degt[0]")+get("sim/weather/shear_direction_degt[0]"))) 
	end

	if get("sim/weather/shear_direction_degt[0]") > 90 and get("sim/weather/wind_speed_kt[0]") < 6 then
		windstring = string.format("VRB%2.2iKT", get("sim/weather/wind_speed_kt[0]")) 
	end

	ATISstring = ATISstring .. windstring
	
	local APTAltitude = get("sim/cockpit2/autopilot/altitude_readout_preselector")
	local CLDcoverage = get("sim/weather/cloud_coverage[0]")
	local CLDstring = ""
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[0]")*3.28-APTAltitude)/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[1]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[1]")*3.28-APTAltitude)/100)
	end
	local CLDcoverage = get("sim/weather/cloud_coverage[2]")
	if (CLDcoverage > 1 and CLDcoverage < 6) then
		CLDstring = CLDstring .. string.format("%s%3.3i ",WX_Cloudcover_list[CLDcoverage],(get("sim/weather/cloud_base_msl_m[2]")*3.28-APTAltitude)/100)
	end
	
	local visiblestring = ""
	local visibility = get("sim/weather/visibility_reported_m")
	if (visibility >= 10000) then
		visiblestring = "9999 "
	end
	if (visibility < 9000) then
		visiblestring = string.format("%4.4i",visibility) .. " "
	end
	if (visibility < 4500) then
		visiblestring = "HZ "
	end
	if (visibility < 1500) then
		visiblestring = "BR "
	end
	if (visibility < 800) then
		visiblestring = "FG "
	end

-- sim/weather/thunderstorm_percent
	
	local precipitation = ""
	if get("sim/weather/precipitation_on_aircraft_ratio") > 0 then
		if get("sim/weather/precipitation_on_aircraft_ratio") < 0.01 then
			precipitation = "DZ "
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.01 then
			precipitation = "-RN "
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.05 then
			precipitation = "RN "
		end
		if get("sim/weather/precipitation_on_aircraft_ratio") > 0.1 then
			precipitation = "+RN "
		end
		if get("sim/weather/temperature_ambient_c") < 0 then
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.01 then
				precipitation = "-SN "
			end
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.05 then
				precipitation = "SN "
			end
			if get("sim/weather/precipitation_on_aircraft_ratio") > 0.1 then
				precipitation = "+SN "
			end
		end
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
	ATISstring = ATISstring .. " " .. visiblestring .. precipitation .. "" .. CLDstring .. tempstring
	
	local cavokcld1 = get("sim/weather/cloud_base_msl_m[0]") > 5000 or get("sim/weather/cloud_coverage[0]") == 0
	local cavokcld2 = get("sim/weather/cloud_base_msl_m[1]") > 5000 or get("sim/weather/cloud_coverage[1]") == 0
	local cavokcld3 = get("sim/weather/cloud_base_msl_m[2]") > 5000 or get("sim/weather/cloud_coverage[2]") == 0
	local vcond = ""
	if visibility > 10000 and cavokcld1 and cavokcld2 and cavokcld3 then
		vcond = "CAVOK"
	end

	ATISstring = ATISstring .. " " .. getQNHString() .. " " .. vcond
	return ATISstring
end

-- WINDOW flight information window
function kc_flightinfo_build()
	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	imgui.SetWindowFontScale(1.1);

	local weightunit = "KG"
	if (get_kpcrew_config("config_kglbs")) then
		weightunit = "KG"
	else
		weightunit = "LBS"
	end
	
	if imgui.Button("SET AIRCRAFT COLD & DARK") then
		gActiveProc = #KC_PROCEDURES_DEFS
		if KC_PROCEDURES_DEFS[gActiveProc] ~= nil then
			--gProcStatus = 1
			gProcStep = 1	
		end
	end 		
	imgui.SameLine()
	if imgui.Button("SET AIRCRAFT TURNAROUND") then
		gActiveProc = #KC_PROCEDURES_DEFS - 1
		if KC_PROCEDURES_DEFS[gActiveProc] ~= nil then
			--gProcStatus = 1
			gProcStep = 1	
		end		
	end 		

	imgui.Separator()
	imgui.Separator()
	
	-- Aircraft Type from ICAO field
	kc_gui_out_text("Aircraft Type",get_kpcrew_config("acf_name") .. " (" .. get_kpcrew_config("acf_icao") .. ")\n",color_light_blue,true)
	
	-- Fuel from aircraft specific 
	kc_gui_out_text("Total Fuel",string.format("%6.6i",kc_get_total_fuel()) .. " " .. weightunit .."\n",color_green,true)

	-- display gross weight in matching unit
	kc_gui_out_text("Gross Weight / ZFW",string.format("%6.6i",kc_get_gross_weight()) .. " "..weightunit.." / " .. string.format("%6.6i",kc_get_zfw()) .. " " .. weightunit.."\n",color_green, true)

	-- Position
	kc_gui_out_text("Current Position",kc_convert_DMS(get("sim/flightmodel/position/latitude"),get("sim/flightmodel/position/longitude")) .."\n",color_green, true)

	-- Determine airport information from XP11
	kc_gui_out_text("Current Elevation",string.gsub(string.format("%6.0f ft\n",get("sim/cockpit2/autopilot/altitude_readout_preselector")),"%s+",""),color_green, true)

	kc_gui_out_text("Local/Zulu Time",kc_display_timefull(get("sim/time/local_time_sec")) .. " / " .. kc_display_timefull(get("sim/time/zulu_time_sec")),color_green,true)
	
	-- ATIS generated string
	kc_gui_out_text("Local METAR",kc_build_atis_string(),color_green)


	imgui.Separator()
	imgui.Separator()
	
    if imgui.TreeNode("FLIGHT") then
		imgui.Separator()
		-- call sign
		set_kpcrew_config("flight_callsign",string.upper(kc_gui_in_text("Callsign",get_kpcrew_config("flight_callsign"),15,100)))

		-- Origin airport icao
		set_kpcrew_config("flight_origin",string.upper(kc_gui_in_text("Origin",get_kpcrew_config("flight_origin"),5,100)))
		
		-- Destination
		set_kpcrew_config("flight_destination",string.upper(kc_gui_in_text("Destination",get_kpcrew_config("flight_destination"),5,100)))

		-- Cruising Altitude
		set_kpcrew_config("flight_cruisealt",kc_gui_in_alt_fl("Cruise Altitude",get_kpcrew_config("flight_cruisealt"),0,170)) 

		-- min t/o fuel in units (I put in the block fuel)
		set_kpcrew_config("flight_takeoff_fuel",kc_gui_in_int("T/O Fuel",get_kpcrew_config("flight_takeoff_fuel"),100,170))

		if imgui.Button("P") then
			set_kpcrew_config("flight_off_block",get("sim/time/zulu_time_sec"))
		end
		imgui.SameLine()
		local lcolor = color_white
		if get_kpcrew_config("flight_off_block") > 0 then
			lcolor = color_green
		end
		kc_gui_out_text("OFF BLOCK",kc_display_timehhmm(get_kpcrew_config("flight_off_block")),lcolor,true)
	
		imgui.SameLine()
		if imgui.Button("O") then
			set_kpcrew_config("flight_on_block",get("sim/time/zulu_time_sec"))			
		end
		imgui.SameLine()
		local lcolor = color_white
		if get_kpcrew_config("flight_on_block") > 0 then
			lcolor = color_green
		end
		kc_gui_out_text("ON BLOCK",kc_display_timehhmm(get_kpcrew_config("flight_on_block")),lcolor,true)
		
		if imgui.Button("T") then
			set_kpcrew_config("flight_time_to",get("sim/time/zulu_time_sec"))			
		end
		imgui.SameLine()
		local lcolor = color_white
		if get_kpcrew_config("flight_time_to") > 0 then
			lcolor = color_green
		end
		kc_gui_out_text("TAKEOFF  ",kc_display_timehhmm(get_kpcrew_config("flight_time_to")),lcolor,true)
	
		imgui.SameLine()
		if imgui.Button("L") then
			set_kpcrew_config("flight_time_ldg",get("sim/time/zulu_time_sec"))			
		end
		imgui.SameLine()
		local lcolor = color_white
		if get_kpcrew_config("flight_time_ldg") > 0 then
			lcolor = color_green
		end
		kc_gui_out_text("LANDED  ",kc_display_timehhmm(get_kpcrew_config("flight_time_ldg")),lcolor,true)

		if imgui.Button("ET START/STOP") then
			kc_acf_et_timer_startstop(1)
		end
		imgui.SameLine()
		local lcolor = color_white
		if get("sim/cockpit2/clock_timer/timer_running") == 1 then
			lcolor = color_green
		end
		kc_gui_out_text("ELAPSED",kc_display_timehhmmss(kc_acf_get_elapsed_seconds()),lcolor,true)
		imgui.SameLine()
		if imgui.Button("ET RESET") then
			kc_acf_et_timer_reset(1)
		end

		imgui.Separator()

		-- Clear all Data entered --> New Flight
		if imgui.Button("NEW FLIGHT") then
			newFlight()
		end

		imgui.Separator()
		imgui.TreePop()
	end

	if imgui.TreeNode("DEPARTURE ATC CLEARANCE") then
		imgui.Separator()

		-- callsign
		kc_gui_out_text("Flight",get_kpcrew_config("flight_callsign").." "..get_kpcrew_config("acf_name").."\n",color_green,true)

		-- Origin taken from info window
		kc_gui_out_text("Airport",get_kpcrew_config("flight_origin") .."\n",color_green, true)

		-- ATIS frequency
		set_kpcrew_config("dep_freq_atis",kc_gui_in_freq("DEPARTURE ATIS",get_kpcrew_config("dep_freq_atis"),200))

		-- ATIS info enter ATIS letter as received
		set_kpcrew_config("dep_atisinfo",string.upper(kc_gui_in_text("ATIS Information",get_kpcrew_config("dep_atisinfo"),2,30)))

		-- Clearance frequency
		set_kpcrew_config("dep_freq_clr",kc_gui_in_freq("Delivery",get_kpcrew_config("dep_freq_clr"),200))
		
		-- Destination taken from info window
		kc_gui_out_text("Cleared to",get_kpcrew_config("flight_destination") .."\n",color_green, true)

		-- departure type
		set_kpcrew_config("dep_type",kc_gui_in_dropdown("Departure Type",get_kpcrew_config("dep_type"),DEP_proctype_list,200))

		-- departure procedure name, or "VECTORS"
		set_kpcrew_config("dep_procedure",kc_gui_in_text("Via",get_kpcrew_config("dep_procedure"),15,150))
		
		-- departure transition name
		set_kpcrew_config("dep_transition",kc_gui_in_text("Transition",get_kpcrew_config("dep_transition"),15,150))

		-- Noise Abatement Departure Position
		set_kpcrew_config("dep_nadp",kc_gui_in_dropdown("NADP",get_kpcrew_config("dep_nadp"),DEP_nadp_list,200))

		-- Initial Altitude
		set_kpcrew_config("flight_initial_alt",kc_gui_in_alt_fl("First Altitude",get_kpcrew_config("flight_initial_alt"),40000,170))

		-- Cruising Altitude
		set_kpcrew_config("flight_cruisealt",kc_gui_in_alt_fl("Cruise Altitude",get_kpcrew_config("flight_cruisealt"),0,170)) 

		-- departure runway designation
		set_kpcrew_config("dep_rwy",kc_gui_in_text("Runway",get_kpcrew_config("dep_rwy"),6,60))

		-- rwy condition
		set_kpcrew_config("dep_rwy_condition",kc_gui_in_dropdown("Runway Condition",get_kpcrew_config("dep_rwy_condition"),DEP_rwystate_list,200))

		-- Squawk code as given from ATC
		set_kpcrew_config("flight_squawk",kc_gui_in_text("XPDR",get_kpcrew_config("flight_squawk"),5,200))

		-- DEP frequency
		set_kpcrew_config("dep_freq_dep",kc_gui_in_freq("Departure",get_kpcrew_config("dep_freq_dep"),200))

		-- transition altitude as published
		set_kpcrew_config("dep_transalt",kc_gui_in_int("Transition Altitude",get_kpcrew_config("dep_transalt") ,100,170))

		set_kpcrew_config("dep_glare_hdg", kc_gui_in_int("Initial Heading", math.ceil(get_kpcrew_config("dep_glare_hdg")) ,10,170))

		imgui.Separator()
		
		set_kpcrew_config("dep_remarks",kc_gui_in_multiline("Departure Notes",get_kpcrew_config("dep_remarks"),400,360,100))

		imgui.Separator()
		imgui.Separator()
        imgui.TreePop()
    end

    if imgui.TreeNode("TAXI BRIEFING") then
		imgui.Separator()

		-- Origin taken from info window
		kc_gui_out_text("Flight",get_kpcrew_config("flight_callsign").." "..get_kpcrew_config("acf_name").."\n",color_green,true)

		-- Origin taken from info window
		kc_gui_out_text("Airport",get_kpcrew_config("flight_origin") .."\n",color_green, true)
		
		imgui.Separator()

		-- GND frequency
		set_kpcrew_config("dep_freq_gnd",kc_gui_in_freq("Ground",get_kpcrew_config("dep_freq_gnd"),200))

		-- TWR frequency
		set_kpcrew_config("dep_freq_twr",kc_gui_in_freq("Tower",get_kpcrew_config("dep_freq_twr"),200))

		-- Parking Position
		set_kpcrew_config("flight_parkpos",string.upper(kc_gui_in_text("Parking Stand",get_kpcrew_config("flight_parkpos"),15,100)))

		local taxiroute = "We are located at "..get_kpcrew_config("flight_origin") .. " parking stand " .. get_kpcrew_config("flight_parkpos") .. "\n\n"

		-- type of stand
		set_kpcrew_config("dep_stand",kc_gui_in_dropdown("Gate/Stand",get_kpcrew_config("dep_stand"),DEP_gatestand_list,250))

		-- Push direction
		set_kpcrew_config("dep_push_direction",kc_gui_in_dropdown("Push Direction",get_kpcrew_config("dep_push_direction"),DEP_push_direction,250))

		if get_kpcrew_config("dep_stand") == 1 then
			xtaxiroute = "This is a gate position, pushback required " .. DEP_push_direction[get_kpcrew_config("dep_push_direction")] .. "\n\n"
		end
		if get_kpcrew_config("dep_stand") == 2 then
			xtaxiroute = "This is an outer position, pushback required " .. DEP_push_direction[get_kpcrew_config("dep_push_direction")] .. "\n\n"
		end
		if get_kpcrew_config("dep_stand") == 3 or get_kpcrew_config("dep_push_direction") == 1 then
			xtaxiroute = "We require no pushback at this position, start clearance only\n\n"
		end
		taxiroute = taxiroute .. xtaxiroute
		taxiroute = taxiroute .. "We will be taxiing to holding point runway " .. get_kpcrew_config("dep_rwy") .. " via\n\n"
		taxiroute = taxiroute .. get_kpcrew_config("dep_taxi_route") .. "\n\n"

		-- departure runway designation
		set_kpcrew_config("dep_rwy",kc_gui_in_text("Runway",get_kpcrew_config("dep_rwy"),6,60))

		imgui.Separator()
		
		set_kpcrew_config("dep_taxi_route",kc_gui_in_multiline("Taxi Route",get_kpcrew_config("dep_taxi_route"),500,350,100))

		imgui.Separator()

		kc_gui_out_multiline_text("Taxi briefing",taxiroute,color_white,360,150)

		imgui.Separator()
		imgui.TreePop()
	end

	if imgui.TreeNode("DEPARTURE BRIEFING") then
		imgui.Separator()

		local briefing = "OK, I will be the pilot flying\n\n"

		briefing = briefing .. "We have no M E L issues today" .. "\n\n"

		briefing = briefing .. "This will be a standard takeoff, noise abatement departure procedure " .. DEP_nadp_list[get_kpcrew_config("dep_nadp")] .. "\n\n"

		if get_kpcrew_config("dep_type") == 1 then
			xdep = "This will be a standard instrument departure via " .. get_kpcrew_config("dep_procedure") .. " transition " .. get_kpcrew_config("dep_transition") .. "\n\n"
		end
		if get_kpcrew_config("dep_type") == 2 then
			xdep = "The departure will be ATC vectors\n\n"
		end
		if get_kpcrew_config("dep_type") == 3 then
			xdep = "The departure will be via tracking\n\n"
		end

		briefing = briefing .. xdep 

		briefing = briefing .. "We will take off from runway " .. get_kpcrew_config("dep_rwy")  .. ". Runway conditions are " .. DEP_rwystate_list[get_kpcrew_config("dep_rwy_condition")] .. "\n\n"

		briefing = briefing .. "Initial altitude will be " .. get_kpcrew_config("flight_initial_alt") .. " ft. Today's cruise altitude will be FL " .. get_kpcrew_config("flight_cruisealt")/100 .. "\n\n" 

		briefing = briefing .. "Transition altitude is " .. get_kpcrew_config("dep_transalt") .. "\n\n" 
		
		briefing = briefing .. "Initial heading is " .. math.ceil(get_kpcrew_config("dep_glare_hdg")) .. "\n\n" 

		briefing = briefing .. "Departure route: " .. get_kpcrew_config("dep_remarks") .. "\n\n" 
		
		kc_gui_out_multiline_text("Ready for the departure briefing?",briefing,color_white,360,350)
		
		imgui.Separator()
        imgui.TreePop()
    end

	if imgui.TreeNode("TAKEOFF") then
		imgui.Separator()

		-- Origin taken from info window
		kc_gui_out_text("Flight",get_kpcrew_config("flight_callsign").." "..get_kpcrew_config("acf_name").."\n",color_green,true)

		-- Origin taken from info window
		kc_gui_out_text("Airport",get_kpcrew_config("flight_origin") .."\n",color_green, true)

		-- departure runway designation
		set_kpcrew_config("dep_rwy",kc_gui_in_text("Runway",get_kpcrew_config("dep_rwy"),6,60))

		-- rwy condition
		set_kpcrew_config("dep_rwy_condition",kc_gui_in_dropdown("Runway Condition",get_kpcrew_config("dep_rwy_condition"),DEP_rwystate_list,200))

		-- t/o thrust settings
		set_kpcrew_config("dep_to_thrust",kc_gui_in_dropdown("T/O Thrust",get_kpcrew_config("dep_to_thrust"),GENERAL_Acf:getTakeoffThrust(),250))

		-- T/O flaps
		set_kpcrew_config("dep_to_flaps",kc_gui_in_dropdown("T/O Flaps",get_kpcrew_config("dep_to_flaps"),GENERAL_Acf:getDEP_Flaps(),200))

		-- Manual T/O Flaps
		set_kpcrew_config("dep_manual_flaps",kc_gui_in_trb("Manual Flaps", get_kpcrew_config("dep_manual_flaps"), "MANUAL", "AUTO",150))
		
		-- Anti Ice
		set_kpcrew_config("dep_anti_ice",kc_gui_in_dropdown("Anti Ice",get_kpcrew_config("dep_anti_ice"),GENERAL_Acf:getAIce(),200))
		
		-- PACKS
		set_kpcrew_config("dep_packs",kc_gui_in_dropdown("T/O Packs",get_kpcrew_config("dep_packs"),DEP_packs_list,200))

		-- Bleeds
		set_kpcrew_config("dep_bleeds",kc_gui_in_dropdown("T/O Bleeds",get_kpcrew_config("dep_bleeds"),GENERAL_Acf:getBleeds(),200))
		
		-- Initial Altitude
		set_kpcrew_config("flight_initial_alt",kc_gui_in_alt_fl("First Altitude",get_kpcrew_config("flight_initial_alt"),40000,170))

		-- MSA
		set_kpcrew_config("dep_msa",kc_gui_in_int("Departure MSA",get_kpcrew_config("dep_msa"),7,200))
		
		-- forced return
		set_kpcrew_config("dep_forced_return",kc_gui_in_dropdown("Forced Return",get_kpcrew_config("dep_forced_return"),DEP_forced_return,200))

		-- elevator trim setting
		set_kpcrew_config("dep_elevator_trim",kc_gui_in_float("Elevator Trim",get_kpcrew_config("dep_elevator_trim"),100,170))

 		-- rudder trim setting
		set_kpcrew_config("dep_rudder_trim",kc_gui_in_float("Rudder Trim",get_kpcrew_config("dep_rudder_trim"),100,170))

 		-- aileron trim setting
		set_kpcrew_config("dep_aileron_trim",kc_gui_in_float("Aileron Trim",get_kpcrew_config("dep_aileron_trim"),100,170))

		-- Vspeeds either manual or by pressing aircraft data button
		set_kpcrew_config("dep_v1",kc_gui_in_int("V1",get_kpcrew_config("dep_v1"),1,170))
		set_kpcrew_config("dep_vr",kc_gui_in_int("VR",get_kpcrew_config("dep_vr"),1,170))
		set_kpcrew_config("dep_v2",kc_gui_in_int("V2",get_kpcrew_config("dep_v2"),1,170))

		-- Glareshield setup, can also come from aircraft data button
		set_kpcrew_config("dep_glare_crs1",kc_gui_in_int("Glareshield CRS1",get_kpcrew_config("dep_glare_crs1"),10,170))
		set_kpcrew_config("dep_glare_spd", kc_gui_in_int("Glareshield SPD", get_kpcrew_config("dep_glare_spd") ,1,170))
		set_kpcrew_config("dep_glare_hdg", kc_gui_in_int("Glareshield HDG", get_kpcrew_config("dep_glare_hdg") ,10,170))
		set_kpcrew_config("dep_glare_alt", kc_gui_in_int("Glareshield ALT", get_kpcrew_config("dep_glare_alt") ,100,170))
		set_kpcrew_config("dep_glare_crs2",kc_gui_in_int("Glareshield CRS2",get_kpcrew_config("dep_glare_crs2"),10,170))
		
		-- Takeoff A/P modes (aircraft specific)
		set_kpcrew_config("dep_ap_modes",kc_gui_in_dropdown("Autopilot Mode",get_kpcrew_config("dep_ap_modes"),GENERAL_Acf:getDepApMode(),200))

		-- pull data from aircraft
		if imgui.Button("Aircraft Data") then
			kc_menus_set_DEP_data()
		end 		

		imgui.Separator()
        imgui.TreePop()

    end

	if imgui.TreeNode("TAKEOFF BRIEFING") then
		imgui.Separator()

		local briefing = "OK, I will be the pilot flying\n\n"

		briefing = briefing .. "We will take off from runway "..get_kpcrew_config("dep_rwy") .. ",runway condition is "..DEP_rwystate_list[get_kpcrew_config("dep_rwy_condition")].."\n\n"
		briefing = briefing .. "Our take off thrust is "..DEP_takeofthrust_list[get_kpcrew_config("dep_to_thrust")] .. "\n\n"
		briefing = briefing .. "We will use Flaps "..GENERAL_Acf:getDEP_Flaps()[get_kpcrew_config("dep_to_flaps")] .. " for takeoff\n\n"
		briefing = briefing .. "Anti Ice is " .. DEP_aice_list[get_kpcrew_config("dep_anti_ice")] .. ",bleeds will be "..DEP_bleeds_list[get_kpcrew_config("dep_bleeds")] .. "\n\n"
		briefing = briefing .. "Minimum Safe Altitude along our initial route is ".. get_kpcrew_config("dep_msa") .. "ft\n\n"
		briefing = briefing .. "In case of forced return we are ".. DEP_forced_return[get_kpcrew_config("dep_forced_return")] .. "\n\n"
		briefing = briefing .. "The takeoff speeds are set. V1 is ".. get_kpcrew_config("dep_v1") .. ", Vr is " .. get_kpcrew_config("dep_vr") .. " and V2 today " .. get_kpcrew_config("dep_v2") .. "\n"
		
		kc_gui_out_multiline_text("Let's talk about the takeoff",briefing,color_white,360,300)
		imgui.Separator()
		
		local sbriefing = "From 0 to 100 knots for any malfunction I will call reject and we will confirm the autobrakes are operating\n\n"
		sbriefing = sbriefing .. "If not operating I will apply maximum manual breaking and maximum symmetric reverse thrust and come to a full stop on the runway\n\n"
		sbriefing = sbriefing .. "After full stop on the runway we decide on course of further actions\n\n"
		sbriefing = sbriefing .. "From 100 knots to V1 I will reject only for one of the following reasons, engine fire, engine failure or takeoff configuration warning horn\n\n"
		sbriefing = sbriefing .. "At and above V1 we will continue into the air and the only actions for you below 400 feet are to silence any alarm bells and confirm any failures\n\n"
		sbriefing = sbriefing .. "Above 400 feet I will call for failure action drills as required and you'll perform memory items\n\n"
		sbriefing = sbriefing .. "At 800 feet above field elevation I will call for altitude hold and we will retract the flaps on schedule\n\n"
		sbriefing = sbriefing .. "At 1500 feet I will call for the checklist\n\n"
		sbriefing = sbriefing .. "If we are above maximum landing weight we will make decision on whether to perform an overweight landing if the situation requires\n\n"
		sbriefing = sbriefing .. "If we have a wheel well, engine or wing fire, I will turn the aircraft in such a way the flames will be downwind and we will evacuate through the upwind side\n\n"
		sbriefing = sbriefing .. "If we have a cargo fire you need to ensure emergency services do not open the cargo doors until evac is completed\n\n"
		sbriefing = sbriefing .. "Any questions or concerns?\n\n"

		kc_gui_out_multiline_text("For the takeoff safety brief",sbriefing,color_white,360,200)
		
		imgui.Separator()
        imgui.TreePop()

    end

	if imgui.TreeNode("ARRIVAL & APPROACH") then
		imgui.Separator()

		-- callsign
		kc_gui_out_text("Flight",get_kpcrew_config("flight_callsign").." "..get_kpcrew_config("acf_name").."\n",color_green,true)

		-- Destination taken from info window
		kc_gui_out_text("Cleared to",get_kpcrew_config("flight_destination") .."\n",color_green, true)

		imgui.Separator()
		-- ATIS frequency
		set_kpcrew_config("arr_freq_atis",kc_gui_in_freq("ARRIVAL ATIS",get_kpcrew_config("arr_freq_atis"),200))

		-- ATIS info enter ATIS letter as received
		set_kpcrew_config("arr_atisinfo",string.upper(kc_gui_in_text("ARRIVAL ATIS Info",get_kpcrew_config("arr_atisinfo"),2,30)))

		-- approach procedure type (depends on aircraft)
		set_kpcrew_config("arr_approach_type",kc_gui_in_dropdown("Expect Approach",get_kpcrew_config("arr_approach_type"),APP_apptype_list,200))

		-- landing runway designation
		set_kpcrew_config("arr_rwy",kc_gui_in_text("Approach RWY",get_kpcrew_config("arr_rwy"),5,150))
		set_kpcrew_config("arr_rwy_condition",kc_gui_in_dropdown("RWY Condition",get_kpcrew_config("arr_rwy_condition"),APP_rwystate_list,200))

		-- Transition level at destination from ATC
		set_kpcrew_config("arr_translevel",kc_gui_in_int("Transition Level",get_kpcrew_config("arr_translevel"),10,170))
		
		-- Approach  frequency
		set_kpcrew_config("arr_freq_app",kc_gui_in_freq("Approach",get_kpcrew_config("arr_freq_app"),200))
		
		-- Wind at arrival airport
		set_kpcrew_config("arr_atis_wind",kc_gui_in_text("Wind HDG/SPD",get_kpcrew_config("arr_atis_wind"),8,170))
		
		-- Visibility
		set_kpcrew_config("arr_atis_visibility",kc_gui_in_text("Visibility km",get_kpcrew_config("arr_atis_visibility"),8,170))

		set_kpcrew_config("arr_atis_precipit",kc_gui_in_dropdown("Precipitation",get_kpcrew_config("arr_atis_precipit"),WX_Precipitation_list,200))

		set_kpcrew_config("arr_atis_clouds",kc_gui_in_dropdown("Cloud Coverage",get_kpcrew_config("arr_atis_clouds"),WX_Cloud_list,200))

		-- Wind at arrival airport
		set_kpcrew_config("arr_atis_temps",kc_gui_in_text("Temp/Dewpoint",get_kpcrew_config("arr_atis_temps"),8,170))
	
		-- ATC provided QNH
		set_kpcrew_config("arr_qnh",kc_gui_in_text("QNH",get_kpcrew_config("arr_qnh"),10,150))
		
		imgui.Separator()

		-- Arrival procedure type (depends on aircraft)
		set_kpcrew_config("arr_type",kc_gui_in_dropdown("Arrival Type",get_kpcrew_config("arr_type"),APP_proctype_list,200))
		
		-- arrival procedure name
		set_kpcrew_config("arr_procedure",kc_gui_in_text("Arrival Procedure",get_kpcrew_config("arr_procedure"),15,150))
		
		-- arrival transition name
		set_kpcrew_config("arr_transition",kc_gui_in_text("Transition",get_kpcrew_config("arr_transition"),15,150))

		-- MSA
		set_kpcrew_config("arr_msa",kc_gui_in_int("Arrival MSA",get_kpcrew_config("arr_msa"),7,200))

		set_kpcrew_config("arr_faf_altitude",kc_gui_in_int("FAF Altitude",get_kpcrew_config("arr_faf_altitude"),100,170))

		-- show decision altitude or height depending on configuration
		if (get_kpcrew_config("config_dhda")) then
			set_kpcrew_config("arr_dh",kc_gui_in_int("DH",get_kpcrew_config("arr_dh"),1,170))
		else
			set_kpcrew_config("arr_da",kc_gui_in_int("DA",get_kpcrew_config("arr_da"),1,170))
		end
		set_kpcrew_config("arr_apt_elevation",kc_gui_in_int("Airport Elevation",get_kpcrew_config("arr_apt_elevation"),100,170))

		set_kpcrew_config("arr_ga_hdg",kc_gui_in_int("Go Around HDG",get_kpcrew_config("arr_ga_hdg"),1,170))
		set_kpcrew_config("arr_ga_alt",kc_gui_in_int("Go Around ALT",get_kpcrew_config("arr_ga_alt"),1,170))

		imgui.Separator()

		-- TWR frequency
		set_kpcrew_config("arr_freq_twr",kc_gui_in_freq("Tower ",get_kpcrew_config("arr_freq_twr"),200))

		-- GND frequency
		set_kpcrew_config("arr_freq_gnd",kc_gui_in_freq("Ground ",get_kpcrew_config("arr_freq_gnd"),200))

		-- for NAV based approaches get frquency
		if get_kpcrew_config("arr_approach_type") < 4 then
			set_kpcrew_config("arr_nav1_frq",kc_gui_nav_freq("NAV1 Frequency",get_kpcrew_config("arr_nav1_frq"),1,200))
			set_kpcrew_config("arr_nav1_crs",kc_gui_in_int("NAV1 Course",get_kpcrew_config("arr_nav1_crs"),10,170))
			set_kpcrew_config("arr_nav2_frq",kc_gui_nav_freq("NAV2 Frequency",get_kpcrew_config("arr_nav2_frq"),2,200))
			set_kpcrew_config("arr_nav2_crs",kc_gui_in_int("NAV2 Course",get_kpcrew_config("arr_nav2_crs"),10,170))
		end
		if get_kpcrew_config("arr_approach_type") == 4 then
			set_kpcrew_config("arr_ndb_frq",kc_gui_ndb_freq("NDB Frequency",get_kpcrew_config("arr_ndb_frq"),200))
		end

		imgui.Separator()
		
		set_kpcrew_config("arr_remarks",kc_gui_in_multiline("Approach Notes",get_kpcrew_config("arr_remarks"),400,360,100))

		imgui.Separator()
		-- Landing setting from aircraft: Flaps, A/BRK, RWY condition, Packs, A/ICE, APU
		set_kpcrew_config("arr_ldg_flaps",kc_gui_in_dropdown("Landing Flaps",get_kpcrew_config("arr_ldg_flaps"),GENERAL_Acf:getAPP_Flaps(),200))
		-- Approach and reference speed. Set from config or by pressing aircraft data button
		set_kpcrew_config("arr_vapp",kc_gui_in_int("Vapp",get_kpcrew_config("arr_vapp"),1,170))
		set_kpcrew_config("arr_vref",kc_gui_in_int("Vref",get_kpcrew_config("arr_vref"),1,170))

		set_kpcrew_config("arr_autobrake",kc_gui_in_dropdown("Autobrake",get_kpcrew_config("arr_autobrake"),GENERAL_Acf:getAutobrake(),200))
		set_kpcrew_config("arr_packs",kc_gui_in_dropdown("Packs",get_kpcrew_config("arr_packs"),GENERAL_Acf:getBleeds(),200))
		set_kpcrew_config("arr_anti_ice",kc_gui_in_dropdown("Anti Ice",get_kpcrew_config("arr_anti_ice"),GENERAL_Acf:getAIce(),200))
		set_kpcrew_config("arr_rev_thrust",kc_gui_in_dropdown("Reverse Thrust",get_kpcrew_config("arr_rev_thrust"),APP_rev_thrust_list,250))
		set_kpcrew_config("arr_apu",kc_gui_in_dropdown("APU Start",get_kpcrew_config("arr_apu"),APP_apu_list,200))
		set_kpcrew_config("arr_stand",kc_gui_in_dropdown("Gate/Stand",get_kpcrew_config("arr_stand"),DEP_gatestand_list,250))
		set_kpcrew_config("arr_gate",string.upper(kc_gui_in_text("Parking Position",get_kpcrew_config("arr_gate"),15,100)))

		imgui.Separator()

		if imgui.Button("Aircraft Data") then
			kc_menus_set_APP_data()
		end

		imgui.Separator()
        imgui.TreePop()
    end

 	if imgui.TreeNode("APPROACH BRIEFING") then
		imgui.Separator()

		local briefing = "Our destination today is "..get_kpcrew_config("flight_destination").."\n\n"
		briefing = briefing .. "we will arrive at " .. get_kpcrew_config("flight_destination") .. " via "
			if get_kpcrew_config("arr_type") == 1 then
				briefing = briefing .. "STAR " .. get_kpcrew_config("arr_procedure") .. " with transition " .. get_kpcrew_config("arr_transition").."\n\n"
			else
				briefing = briefing .. "ATC vectors".."\n\n"
			end
		briefing = briefing .. "The weather report is winds " .. get_kpcrew_config("arr_atis_wind") .. "; visibility " .. get_kpcrew_config("arr_atis_visibility") .. " km; precipitation " .. WX_Precipitation_list[get_kpcrew_config("arr_atis_precipit")] .. "; clouds " .. WX_Cloudcover_list[get_kpcrew_config("arr_atis_clouds")] .. "; the temperatures are " .. get_kpcrew_config("arr_atis_temps") .. "; QNH " .. get_kpcrew_config("arr_qnh").."\n\n" 

		briefing = briefing .. "The MSA in our arrival sector is " .. get_kpcrew_config("arr_msa") .. " and the transition level today FL " .. get_kpcrew_config("arr_translevel").."\n\n"
		briefing = briefing .. "After the arrival we can expect an " .. APP_apptype_list[get_kpcrew_config("arr_approach_type")] .. " approach".."\n\n"
		briefing = briefing .. "Runway assigned is " .. get_kpcrew_config("arr_rwy") .. " and the condition is " ..APP_rwystate_list[get_kpcrew_config("arr_rwy_condition")].."\n\n"
		briefing = briefing .. "Altitude at the FAF is " .. get_kpcrew_config("arr_faf_altitude") .. ", " .. (get_kpcrew_config("config_dhda")==true and "DH" or "DA") .." will be " .. (get_kpcrew_config("config_dhda")==true and get_kpcrew_config("arr_dh") or get_kpcrew_config("arr_da")).."\n\n"
		briefing = briefing .. "Airport elevation is " .. get_kpcrew_config("arr_apt_elevation").."ft \n\n"
		briefing = briefing .. "We are going to use landing flaps " .. GENERAL_Acf:getAPP_Flaps()[get_kpcrew_config("arr_ldg_flaps")] .. " and Autobrake " .. GENERAL_Acf:getAutobrake()[get_kpcrew_config("arr_autobrake")].."\n\n"
		briefing = briefing .. "Packs are set " .. GENERAL_Acf:getBleeds()[get_kpcrew_config("arr_packs")] .. " and Anti Ice " .. APP_aice_list[get_kpcrew_config("arr_anti_ice")].."\n\n"
		
		kc_gui_out_multiline_text("For the approach brief",briefing,color_white,360,400)
		
		imgui.Separator()
        imgui.TreePop()

    end

   if imgui.TreeNode("CONFIGURATION") then
		imgui.Separator()

		-- initial heading on the glareshield/autopilot
		set_kpcrew_config("default_ap_hdg",kc_gui_in_int("A/P Initial Heading", get_kpcrew_config("default_ap_hdg"), 10,150))

		-- initial speed on the glareshield/autopilot
		set_kpcrew_config("default_ap_spd",kc_gui_in_int("A/P Initial Speed", get_kpcrew_config("default_ap_spd"), 10,150))
		
		-- initial altitude on the glareshield/autopilot
		set_kpcrew_config("default_ap_alt",kc_gui_in_int("A/P Initial Altitude", get_kpcrew_config("default_ap_alt"), 10,150))

		-- default transition altitude/level (e.g. 5000 Germanyy, 18000 US)
		set_kpcrew_config("default_transition",kc_gui_in_int("Default Transition", get_kpcrew_config("default_transition"), 1000,170))

		-- Barometer unit hpa/inhg
		set_kpcrew_config("config_qnhhpa",kc_gui_in_trb("Barometer Setting", get_kpcrew_config("config_qnhhpa"), "HPa", "inHG",150))
		
		-- powerup with APU or GPU
		set_kpcrew_config("config_apuinit",kc_gui_in_trb("Initial Power-Up", get_kpcrew_config("config_apuinit"), "APU", "GPU",150))
		
		-- Decision height or altitude
		set_kpcrew_config("config_dhda",kc_gui_in_trb("Minimums", get_kpcrew_config("config_dhda"), "RADIO", "BARO",150))
		
		-- KG or lbs as units
		set_kpcrew_config("config_kglbs",kc_gui_in_trb("Weight Units", get_kpcrew_config("config_kglbs"), "KG", "LBS",150))

		-- Easy mode or manual (not muh support outside procedures)
		set_kpcrew_config("config_complexity",kc_gui_in_trb("Easy use", get_kpcrew_config("config_complexity"), "EASY", "MANUAL",150))

		imgui.Separator()
        imgui.TreePop()
    end

	-- Save and load configuration data
	imgui.Separator()
	gConfigName = kc_gui_in_text("Config name",gConfigName,30,200)
	if imgui.Button("SAVE DATA") then
		-- save in last
		kc_write_config("last")
		-- save with given name
		kc_write_config(gConfigName)
	end
	imgui.SameLine()
	if imgui.Button("LOAD DATA") then
		if file_exists(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_config_" .. gConfigName .. ".lua") then 
			dofile(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_config_" .. gConfigName .. ".lua")
		end
	end

	imgui.Separator()	
	imgui.Separator()
end

-- primary kpcrew window
function kc_primary_build()
	imgui.SetWindowFontScale(1.1);

	-- MASTER Button
	if gProcStatus > 0 then 
		imgui.PushStyleColor(imgui.constant.Col.Button, color_orange)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_orange)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_orange)
	else
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_green)
	end
	imgui.SetCursorPosX(0)
	if imgui.Button("M", 20, 20) then
		kc_master_button()
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()

	-- CHECKLIST/ACTIVITY display
	imgui.SameLine()
	imgui.SetCursorPosX(30)
    imgui.TextUnformatted(gLeftText, kc_primary_wnd, x, y)
	
	-- PAUSE Button
	imgui.SameLine()
	imgui.SetCursorPosX(500)
	if gProcStatus == 2 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_red)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_red)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_red)
	end
	if gProcStatus == 0 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_grey)
	end
	if gProcStatus ~= 2 and gProcStatus ~= 0 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_green)
	end
	if imgui.Button("P", 20, 20) then
		kc_pause_button()
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	
	-- STOP Button
	imgui.SameLine()
	imgui.SetCursorPosX(520)
	if gProcStatus == 3 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_red)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_red)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_red)
	end
	if gProcStatus == 0 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_grey)
	end
	if gProcStatus ~= 3 and gProcStatus ~= 0 then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_green)
	end
	if imgui.Button("S", 20, 20) then
		kc_stop_button()
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()

	-- PREV Button
	imgui.SameLine()
	imgui.SetCursorPosX(540)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_ocean_blue)
	if imgui.Button("<", 20, 20) then
		kc_prev_button()
	end
	imgui.PopStyleColor()
	
	-- NEXT Button
	imgui.SameLine()
	imgui.SetCursorPosX(560)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_ocean_blue)
	if imgui.Button(">", 20, 20) then
		kc_next_button()
	end
	imgui.PopStyleColor()

	-- MODE/AUXILIARY display
	imgui.SameLine()
	imgui.SetCursorPosX(590)
	imgui.PushStyleColor(imgui.constant.Col.Text, color_left_display)
    imgui.TextUnformatted(string.format(gRightText, kc_primary_wnd, x, y))
	imgui.PopStyleColor()
	
	-- START OPEN INFO WINDOW Button
	imgui.SameLine()
	imgui.SetCursorPosX(1000)
	imgui.PushStyleColor(imgui.constant.Col.Button, color_ocean_blue)
	if imgui.Button("@", 20, 20) then
		kc_info_button()
	end
	imgui.PopStyleColor()

	-- OPEN CHKL/PROC WINDOW
	imgui.SameLine()
	imgui.SetCursorPosX(1022)
	if gShowProcList then
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_green)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_green)
	else
		imgui.PushStyleColor(imgui.constant.Col.Button, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, color_dark_grey)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, color_dark_grey)
	end
	if imgui.Button("L", 20, 20) then
		if gShowProcList then
			gShowProcList = false
		else
			gShowProcList = true
		end
	end
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	imgui.PopStyleColor()
	
end

-- close windows
function kc_close_primary_window(wnd)
	kc_primary_wnd = 0
end

function kc_close_flightinfo_window(wnd)
	kc_flightinfo_wnd = 0
end

function toDegreesMinutesAndSeconds(coordinate) 
    local absolute = math.abs(coordinate);
    local degrees  = math.floor(absolute);
    local minutesNotTruncated = (absolute - degrees) * 60;
    local minutes  = math.floor(minutesNotTruncated);
    local seconds  = math.floor((minutesNotTruncated - minutes) * 60);

    return degrees .. "°" .. minutes .. "'" .. seconds .. "\"";
end

function kc_convert_DMS(lat, lng) 
    local latitude = toDegreesMinutesAndSeconds(lat);
    local latitudeCardinal = (lat >= 0) and "N" or "S";

    local longitude = toDegreesMinutesAndSeconds(lng);
    local longitudeCardinal = (lng >= 0) and "E" or "W";

    return latitude .. " " .. latitudeCardinal .. " - " .. longitude .. " " .. longitudeCardinal;
end

function kc_display_timefull(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	local lsec = math.floor(timeseconds - (lhours * 3600) - (lminutes * 60))
	return string.format("%2.2i:%2.2i:%2.2i",lhours,lminutes,lsec)
end

function kc_display_timehhmm(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	return string.format("%2.2i:%2.2i",lhours,lminutes)
end

function kc_display_timehhmmss(timeseconds)
	local lhours = math.floor(timeseconds/3600)
	local lminutes = math.floor((timeseconds - lhours * 3600)/60)
	local lseconds = math.floor((timeseconds - (lhours * 3600 + lminutes * 60)))
	return string.format("%2.2i:%2.2i:%2.2i",lhours,lminutes,lseconds)
end
