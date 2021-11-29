--[[
	*** KPCREW 2.2
	Kosta Prokopiu, October 2021
	data and config related functionality
	support old and new config structure
--]]

-- Base Config old

-- KPCrew configuration
KPCREW_CONFIG = {
	["wnd_primary_type"] = 1, -- 1 = window; 2 = fixed display
	["wnd_primary_x_pos"] = 500, -- initial position from left border
	["wnd_primary_y_offset"] = 30, -- initial position offset from bottom
	["wnd_checklist_x_pos"] = -10, -- initial position from left border
	["wnd_checklist_y_pos"] = 80, -- initial position from top
	["default_ap_hdg"] = 0, -- initial setting on glareshield heading ...
	["default_ap_spd"] = 101, -- speed
	["default_ap_alt"] = 4900, -- altitude
	["default_transition"] = 5000, -- default transition altitude
	["config_qnhhpa"] = true, -- true=HPA(mb); false=INHG
	["config_apuinit"] = false, -- power up true=APU; false=GPU
	["config_dhda"] = true, -- minimums true=DH; false=DA
	["config_complexity"] = false, -- 0=EASY, 1=MANUAL
	["config_kglbs"] = true, -- true=KG; false=LBS
	["acf_icao"] = "", -- aircraft type icao
	["acf_name"] = "", -- aircraft name
	["flight_callsign"] = "",
	["flight_parkpos"] = "",
	["flight_origin"] = "",
	["flight_destination"] = "",
	["flight_cruisealt"] = 4900,
	["flight_initial_alt"] = 4900,
	["flight_takeoff_fuel"] = 0,
	["flight_squawk"] = 2000,
	["flight_off_block"] = 0,
	["flight_on_block"] = 0,
	["flight_time_to"] = 0,
	["flight_time_ldg"] = 0,	
	["dep_freq_atis"] = 122.8,
	["dep_freq_clr"] = 122.8,
	["dep_freq_dep"] = 122.8,
	["dep_freq_gnd"] = 122.8,
	["dep_freq_twr"] = 122.8,
	["dep_glare_crs1"] = 0,
	["dep_glare_spd"] = 101,
	["dep_glare_hdg"] = 0,
	["dep_glare_alt"] = 4900,
	["dep_glare_crs2"] = 0,
	["dep_taxi_route"] = "",
	["dep_qnh"] = 1013,
	["dep_rwy"] = "",
	["dep_rwy_condition"] = 1, -- 1="DRY", 2="WET", 3="CONTAMINATED"
	["dep_stand"] = 1, -- 1="GATE (PUSH)", 2="STAND (PUSH)", 3="STAND (NO PUSH)"
	["dep_push_direction"] = 1, -- "NOSE LEFT", "NOSE RIGHT", "NOSE STRAIGHT", "FACING NORTH", "FACING SOUTH", "FACING EAST", "FACING WEST"
	["dep_to_thrust"] = 1, -- aircraft specific T/O thrust setting
	["dep_to_flaps"] = 3, -- aircraft specific T/O flaps
	["dep_atisinfo"] = "", -- ATIS information letter
	["dep_type"] = 1, -- 1="SID", 2="VECTORS", 3="TRACKING"
	["dep_procedure"] = "", -- procedure name
	["dep_transition"] = "", -- transition name
	["dep_bleeds"] = 2, -- aircraft specific BLEED settings for T/O
	["dep_packs"] = 1, -- 1="ON", 2="ON APU", 3="OFF"
	["dep_anti_ice"] = 1, -- aircraft specific anti-ice settings
	["dep_forced_return"] = 1, -- 1="UNDERWEIGHT", 2="OVERWEIGHT"
	["dep_nadp"] = 1, -- 1="NOT REQUIRED", 2="1", 3="2"
	["dep_elevator_trim"] = 4.5,
	["dep_aileron_trim"] = 0,
	["dep_rudder_trim"] = 0,
	["dep_ap_modes"] = 1, -- aircraft specific A/P modes for takeoff
	["dep_v1"] = 101,
	["dep_vr"] = 101,
	["dep_v2"] = 101,
	["dep_transalt"] = 5000,
	["dep_n1"] = 99.9,
	["dep_msa"] = 1000,
	["dep_remarks"] = "New",
	["arr_freq_atis"] = 122.8,
	["arr_freq_app"] =  122.8,
	["arr_freq_twr"] = 122.8,
	["arr_freq_gnd"] = 122.8,
	["arr_atisinfo"] = "",
	["arr_atis_wind"] = "",
	["arr_atis_visibility"] = "",
	["arr_atis_precipit"] = 1,
	["arr_atis_clouds"] = 1,
	["arr_atis_temps"] = "",
	["arr_atis_notes"] = "",
	["arr_faf_altitude"] = 1000,
	["arr_dh"] = 200,
	["arr_da"] = 320,
	["arr_type"] = 1, -- 1="STAR", 2="VECTORS"
	["arr_procedure"] = "", -- procedure name
	["arr_transition"] = "", -- arrival transition name
	["arr_rwy"] = "",
	["arr_rwy_condition"] = 1, -- 1="DRY", 2="WET", 3="CONTAMINATED"
	["arr_approach_type"] = 1, -- 1="ILS CAT 1", 2="VISUAL", 3="ILS CAT 2 OR 3", 4="VOR", 5="NDB", 6="RNAV", 7="TOUCH AND GO", 8="CIRCLING"
	["arr_qnh"] = 1013,
	["arr_nav1_frq"] = 109.5,
	["arr_nav1_crs"]	= 80,
	["arr_nav2_frq"] = 109.5,
	["arr_nav2_crs"]	= 80,
	["arr_ndb_frq"] = 312.0,
	["arr_ldg_flaps"] = 2, -- aircraft specific landing flaps
	["arr_autobrake"] = 2, -- aircraft specific autobrake setting
	["arr_packs"] = 2, -- 1="ON", 2="ON APU", 3="OFF"
	["arr_anti_ice"] = 1, -- 1="NOT REQUIRED", 2="Engine Only", 3="Engine and Wing"
	["arr_apu"] = 2, -- 1="APU delayed start", 2="APU", 3="GPU"
	["arr_vref"] = 132,
	["arr_vapp"] = 145,
	["arr_ga_hdg"] = 80,
	["arr_ga_alt"] = 5000,
	["arr_translevel"] = 5000,
	["arr_msa"] = 5000,
	["arr_apt_elevation"] = 0;
	["arr_stand"] = 1, -- 1="GATE (PUSH)", 2="STAND (PUSH)", 3="STAND (NO PUSH)"
	["arr_gate"] = "",
	["arr_rev_thrust"] = 1,
	["arr_taxi_route"] = "",
	["arr_rwy_exit"] = "",
	["arr_remarks"] = "New"
}

function get_kpcrew_config(key)
	return KPCREW_CONFIG[key]
end

function set_kpcrew_config(key, value)
	KPCREW_CONFIG[key] = value
end

-- reset saved state and empty all settings which need to be replaced
function newFlight()

	initFlight()
	
	set_kpcrew_config("flight_callsign","")
	set_kpcrew_config("flight_parkpos","")
	set_kpcrew_config("flight_origin","")
	set_kpcrew_config("flight_destination","")
	set_kpcrew_config("flight_cruisealt",4900)
	set_kpcrew_config("flight_initial_alt",4900)
	set_kpcrew_config("flight_takeoff_fuel",7000)
	set_kpcrew_config("flight_squawk",2000)
	set_kpcrew_config("flight_off_block",0)
	set_kpcrew_config("flight_on_block",0)
	set_kpcrew_config("flight_time_to",0)
	set_kpcrew_config("flight_time_ldg",0)	
	set_kpcrew_config("dep_freq_atis",122.8)
	set_kpcrew_config("dep_freq_clr",122.8)
	set_kpcrew_config("dep_freq_dep",122.8)
	set_kpcrew_config("dep_freq_gnd",122.8)
	set_kpcrew_config("dep_freq_twr",122.8)
	set_kpcrew_config("dep_glare_crs1",80)
	set_kpcrew_config("dep_glare_spd",129)
	set_kpcrew_config("dep_glare_hdg",80)
	set_kpcrew_config("dep_glare_alt",7000)
	set_kpcrew_config("dep_glare_crs2",80)
	set_kpcrew_config("dep_qnh",1013)
	set_kpcrew_config("dep_rwy","")
	set_kpcrew_config("dep_rwy_condition",1)
	set_kpcrew_config("dep_stand",1)
	set_kpcrew_config("dep_push_direction",1)
	set_kpcrew_config("dep_taxi_route","")
	set_kpcrew_config("dep_to_thrust",1)
	set_kpcrew_config("dep_to_flaps",3)
	set_kpcrew_config("dep_atisinfo","")
	set_kpcrew_config("dep_type",1)
	set_kpcrew_config("dep_procedure","")
	set_kpcrew_config("dep_transition","")
	set_kpcrew_config("dep_bleeds",2)
	set_kpcrew_config("dep_packs",2)
	set_kpcrew_config("dep_anti_ice",1)
	set_kpcrew_config("dep_forced_return",1)
	set_kpcrew_config("dep_nadp",1)
	set_kpcrew_config("dep_elevator_trim",4.5)
	set_kpcrew_config("dep_rudder_trim",0)
	set_kpcrew_config("dep_aileron_trim",0)
	set_kpcrew_config("dep_ap_modes",1)
	set_kpcrew_config("dep_v1",138)
	set_kpcrew_config("dep_vr",139)
	set_kpcrew_config("dep_v2",146)
	set_kpcrew_config("dep_transalt",5000)
	set_kpcrew_config("dep_n1",99.9)
	set_kpcrew_config("dep_msa",1000)
	set_kpcrew_config("dep_remarks","New")
	set_kpcrew_config("arr_freq_atis",122.8)
	set_kpcrew_config("arr_freq_app", 122.8)
	set_kpcrew_config("arr_freq_twr",122.8)
	set_kpcrew_config("arr_freq_gnd",122.8)
	set_kpcrew_config("arr_atisinfo","")
	set_kpcrew_config("arr_atis_wind","")
	set_kpcrew_config("arr_atis_visibility","")
	set_kpcrew_config("arr_atis_precipit",1)
	set_kpcrew_config("arr_atis_clouds",1)
	set_kpcrew_config("arr_atis_temps","")
	set_kpcrew_config("arr_atis_notes","")
	set_kpcrew_config("arr_faf_altitude",100)
	set_kpcrew_config("arr_dh",200)
	set_kpcrew_config("arr_da",320)
	set_kpcrew_config("arr_type",1)
	set_kpcrew_config("arr_procedure","")
	set_kpcrew_config("arr_transition","")
	set_kpcrew_config("arr_rwy","")
	set_kpcrew_config("arr_rwy_condition",1)
	set_kpcrew_config("arr_approach_type",1)
	set_kpcrew_config("arr_qnh",1013)
	set_kpcrew_config("arr_nav1_frq",109.5)
	set_kpcrew_config("arr_nav1_crs",80)
	set_kpcrew_config("arr_nav2_frq",109.5)
	set_kpcrew_config("arr_nav2_crs",80)
	set_kpcrew_config("arr_ndb_frq",312.0)
	set_kpcrew_config("arr_ldg_flaps",2)
	set_kpcrew_config("arr_autobrake",2)
	set_kpcrew_config("arr_packs",2)
	set_kpcrew_config("arr_anti_ice",1)
	set_kpcrew_config("arr_apu",2)
	set_kpcrew_config("arr_vref",132)
	set_kpcrew_config("arr_vapp",145)
	set_kpcrew_config("arr_ga_hdg",80)
	set_kpcrew_config("arr_ga_alt",5000)
	set_kpcrew_config("arr_translevel",5000)
	set_kpcrew_config("arr_msa",5000)
	set_kpcrew_config("arr_apt_elevation",0)
	set_kpcrew_config("arr_stand",1)
	set_kpcrew_config("arr_gate","")
	set_kpcrew_config("arr_rev_thrust",1)
	set_kpcrew_config("arr_remarks","New")
	kc_acf_et_timer_reset(0)
end

-- Write all config items to the kpcrew_config_xxx.lua files
function kc_write_config(module)
	fileConfig = io.open(SCRIPT_DIRECTORY .. "..\\Modules\\kpcrew_config_" .. module .. ".lua", "w+")

	fileConfig:write('-- KPCREW configuration " .. module",' .. '\n')
	fileConfig:write('set_kpcrew_config("wnd_primary_type",' ..				get_kpcrew_config("wnd_primary_type") .. ')\n')
	fileConfig:write('set_kpcrew_config("wnd_primary_x_pos",' ..			get_kpcrew_config("wnd_primary_x_pos") .. ')\n')
	fileConfig:write('set_kpcrew_config("wnd_primary_y_offset",' ..			get_kpcrew_config("wnd_primary_y_offset") .. ')\n')
	fileConfig:write('set_kpcrew_config("wnd_checklist_x_pos",' ..			get_kpcrew_config("wnd_checklist_x_pos") .. ')\n')
	fileConfig:write('set_kpcrew_config("wnd_checklist_y_pos",' ..			get_kpcrew_config("wnd_checklist_y_pos") .. ')\n')
	fileConfig:write('set_kpcrew_config("default_ap_hdg",' ..				get_kpcrew_config("default_ap_hdg") .. ')\n')
	fileConfig:write('set_kpcrew_config("default_ap_spd",' ..				get_kpcrew_config("default_ap_spd") .. ')\n')
	fileConfig:write('set_kpcrew_config("default_ap_alt",' ..				get_kpcrew_config("default_ap_alt") .. ')\n')
	fileConfig:write('set_kpcrew_config("default_transition",' ..			get_kpcrew_config("default_transition") .. ')\n')
	fileConfig:write('set_kpcrew_config("config_qnhhpa",' .. 		   		tostring(get_kpcrew_config("config_qnhhpa")) .. ')\n')
	fileConfig:write('set_kpcrew_config("config_apuinit",' ..				tostring(get_kpcrew_config("config_apuinit")) .. ')\n')
	fileConfig:write('set_kpcrew_config("config_dhda",' ..					tostring(get_kpcrew_config("config_dhda")) .. ')\n')
	fileConfig:write('set_kpcrew_config("config_complexity",' .. 			tostring(get_kpcrew_config("config_complexity")) .. ')\n')
	fileConfig:write('set_kpcrew_config("config_kglbs",' ..					tostring(get_kpcrew_config("config_kglbs")) .. ')\n')
	fileConfig:write('set_kpcrew_config("acf_icao","' ..					get_kpcrew_config("acf_icao") .. '")\n')
	fileConfig:write('set_kpcrew_config("acf_name","' ..					get_kpcrew_config("acf_name") .. '")\n')
	fileConfig:write('set_kpcrew_config("flight_callsign","' ..				get_kpcrew_config("flight_callsign") .. '")\n')
	fileConfig:write('set_kpcrew_config("flight_parkpos","' ..				get_kpcrew_config("flight_parkpos") .. '")\n')
	fileConfig:write('set_kpcrew_config("flight_origin","' ..				get_kpcrew_config("flight_origin") .. '")\n')
	fileConfig:write('set_kpcrew_config("flight_destination","' ..			get_kpcrew_config("flight_destination") .. '")\n')
	if get_kpcrew_config("flight_cruisealt") < 1000 then
		fileConfig:write('set_kpcrew_config("flight_cruisealt",' ..				get_kpcrew_config("flight_cruisealt")*100 .. ')\n')
	else
		fileConfig:write('set_kpcrew_config("flight_cruisealt",' ..				get_kpcrew_config("flight_cruisealt") .. ')\n')
	end
	fileConfig:write('set_kpcrew_config("flight_initial_alt",' ..			get_kpcrew_config("flight_initial_alt") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_takeoff_fuel",' .. 		    get_kpcrew_config("flight_takeoff_fuel") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_squawk",' ..				get_kpcrew_config("flight_squawk") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_off_block",' ..				get_kpcrew_config("flight_off_block") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_on_block",' ..				get_kpcrew_config("flight_on_block") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_time_to",' ..				get_kpcrew_config("flight_time_to") .. ')\n')
	fileConfig:write('set_kpcrew_config("flight_time_ldg",' ..				get_kpcrew_config("flight_time_ldg") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_freq_atis",' ..				get_kpcrew_config("dep_freq_atis") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_freq_clr",' ..					get_kpcrew_config("dep_freq_clr") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_freq_dep",' ..					get_kpcrew_config("dep_freq_dep") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_freq_gnd",' .. 		        get_kpcrew_config("dep_freq_gnd") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_freq_twr",' .. 		        get_kpcrew_config("dep_freq_twr") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_glare_crs1",' ..       		get_kpcrew_config("dep_glare_crs1") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_glare_spd",' ..        		get_kpcrew_config("dep_glare_spd") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_glare_hdg",' ..        		get_kpcrew_config("dep_glare_hdg") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_glare_alt",' ..     	   		get_kpcrew_config("dep_glare_alt") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_glare_crs2",' ..				get_kpcrew_config("dep_glare_crs2") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_qnh",' ..						get_kpcrew_config("dep_qnh") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_rwy","' .. 	                get_kpcrew_config("dep_rwy") .. '")\n')
	fileConfig:write('set_kpcrew_config("dep_rwy_condition",' .. 	    	get_kpcrew_config("dep_rwy_condition") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_stand",' .. 	            	get_kpcrew_config("dep_stand") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_push_direction",' .. 	        get_kpcrew_config("dep_push_direction") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_taxi_route","' .. 	        	string.gsub(get_kpcrew_config("dep_taxi_route"),'\n','\\n') .. '")\n')
	fileConfig:write('set_kpcrew_config("dep_to_thrust",' .. 	        	get_kpcrew_config("dep_to_thrust") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_to_flaps",' .. 		        get_kpcrew_config("dep_to_flaps") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_atisinfo","' .. 		        get_kpcrew_config("dep_atisinfo") .. '")\n')
	fileConfig:write('set_kpcrew_config("dep_type",' .. 	                get_kpcrew_config("dep_type") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_procedure","' .. 	        	get_kpcrew_config("dep_procedure") .. '")\n')
	fileConfig:write('set_kpcrew_config("dep_transition","' ..				get_kpcrew_config("dep_transition") .. '")\n')
	fileConfig:write('set_kpcrew_config("dep_bleeds",' ..					get_kpcrew_config("dep_bleeds") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_packs",' .. 	            	get_kpcrew_config("dep_packs") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_anti_ice",' .. 	            get_kpcrew_config("dep_anti_ice") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_forced_return",' .. 	    	get_kpcrew_config("dep_forced_return") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_nadp",' .. 	                get_kpcrew_config("dep_nadp") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_elevator_trim",' .. 	    	get_kpcrew_config("dep_elevator_trim") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_rudder_trim",' .. 	  	  		get_kpcrew_config("dep_rudder_trim") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_aileron_trim",' .. 	    	get_kpcrew_config("dep_aileron_trim") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_ap_modes",' .. 	            get_kpcrew_config("dep_ap_modes") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_v1",' ..						get_kpcrew_config("dep_v1") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_vr",' ..						get_kpcrew_config("dep_vr") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_v2",' ..						get_kpcrew_config("dep_v2") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_transalt",' .. 		        get_kpcrew_config("dep_transalt") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_n1",' .. 		       			get_kpcrew_config("dep_n1") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_msa",' .. 		       			get_kpcrew_config("dep_msa") .. ')\n')
	fileConfig:write('set_kpcrew_config("dep_remarks","' ..					string.gsub(get_kpcrew_config("dep_remarks"),'\n','\\n') .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_freq_atis",' .. 		    	get_kpcrew_config("arr_freq_atis") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_freq_app",' .. 		        get_kpcrew_config("arr_freq_app") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_freq_twr",' .. 		        get_kpcrew_config("arr_freq_twr") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_freq_gnd",' .. 		        get_kpcrew_config("arr_freq_gnd") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_atisinfo","' .. 		        get_kpcrew_config("arr_atisinfo") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_atis_wind","' .. 		        get_kpcrew_config("arr_atis_wind") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_atis_visibility","' .. 	    get_kpcrew_config("arr_atis_visibility") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_atis_precipit",' .. 		    get_kpcrew_config("arr_atis_precipit") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_atis_clouds",' .. 		        get_kpcrew_config("arr_atis_clouds") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_atis_temps","' .. 		        get_kpcrew_config("arr_atis_temps") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_atis_notes","' .. 		        get_kpcrew_config("arr_atis_notes") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_faf_altitude",' ..				get_kpcrew_config("arr_faf_altitude") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_dh",' ..						get_kpcrew_config("arr_dh") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_da",' ..						get_kpcrew_config("arr_da") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_type",' .. 	                get_kpcrew_config("arr_type") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_procedure","' .. 	        	get_kpcrew_config("arr_procedure") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_transition","' ..				get_kpcrew_config("arr_transition") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_rwy","' .. 	                get_kpcrew_config("arr_rwy") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_rwy_condition",' .. 	    	get_kpcrew_config("arr_rwy_condition") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_approach_type",' .. 	    	get_kpcrew_config("arr_approach_type") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_qnh",' ..						get_kpcrew_config("arr_qnh") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_nav1_frq",' .. 		        get_kpcrew_config("arr_nav1_frq") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_nav1_crs",' .. 		        get_kpcrew_config("arr_nav1_crs") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_nav2_frq",' .. 		        get_kpcrew_config("arr_nav2_frq") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_nav2_crs",' .. 		        get_kpcrew_config("arr_nav2_crs") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_ndb_frq",' ..					get_kpcrew_config("arr_ndb_frq") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_ldg_flaps",' .. 	        	get_kpcrew_config("arr_ldg_flaps") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_autobrake",' .. 	        	get_kpcrew_config("arr_autobrake") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_packs",' .. 	            	get_kpcrew_config("arr_packs") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_anti_ice",' .. 	            get_kpcrew_config("arr_anti_ice") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_apu",' ..						get_kpcrew_config("arr_apu") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_vref",' .. 		            get_kpcrew_config("arr_vref") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_vapp",' .. 		            get_kpcrew_config("arr_vapp") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_ga_hdg",' ..					get_kpcrew_config("arr_ga_hdg") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_ga_alt",' ..					get_kpcrew_config("arr_ga_alt") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_translevel",' ..				get_kpcrew_config("arr_translevel") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_msa",' ..						get_kpcrew_config("arr_msa") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_apt_elevation",' ..				get_kpcrew_config("arr_apt_elevation") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_stand",' .. 	            	get_kpcrew_config("arr_stand") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_gate","' .. 	            	get_kpcrew_config("arr_gate") .. '")\n')
	fileConfig:write('set_kpcrew_config("arr_rev_thrust",' .. 	            get_kpcrew_config("arr_rev_thrust") .. ')\n')
	fileConfig:write('set_kpcrew_config("arr_remarks","' .. 		        get_kpcrew_config("arr_remarks") .. '")\n')

	fileConfig:close()
end
