4--[[
	*** KPCREW for Zibo Mod 2.1.0.1.1
	Kosta Prokopiu, July 2021
--]]

-- Briefing / Aircraft specific details
B738 = Class_ACF:Create()
B738:setDEP_Flaps({"0","1","5","10","15","",""})
B738:setDEP_Flaps_val({0,1,5,10,15,15,15})
B738:setAPP_Flaps({"15","30","40"})
B738:setAPP_Flaps_val({15,30,40})
B738:setAutoBrake({"OFF","1","2","3","MAX"})
B738:setAutoBrake_val({1,2,3,4,5})
B738:setTakeoffThrust({"Rated","De-Rated","Assumed Temperature","Rated and Assumed","De-Rated and Assumed"})
B738:setTakeoffThrust_Val({0,1,2,3,4})
B738:setBleeds({"OFF","ON","UNDER PRESSURIZED"})
B738:setBleeds_val({0,1,2})
B738:setAIce({"Not Required","Engine Only","Engine and Wing"})
B738:setAIce_val({0,1,2})
B738:setDepApMode({"LNAV/VNAV","HDG/FLCH"})
B738:setDepApMode_val({0,1})

set_zc_config("acfname","Boeing 737-800")
set_zc_config("acficao","B738")

DEP_takeofthrust_list = B738:getTakeoffThrust()
DEP_aice_list = B738:getAIce()
DEP_bleeds_list = B738:getBleeds()

-- overwrite approach types if necessary - "---" for unsupported
APP_apptype_list = {"ILS CAT 1","VISUAL","ILS CAT 2 OR 3","VOR","NDB","RNAV","TOUCH AND GO","CIRCLING"}

zibo_save_counter = 30
xsp_bravo_mode = 1
xsp_bravo_layer = 0
xsp_fine_coarse = 1

-- Procedure definitions
ZC_INIT_PROC = {
	[0] = {["lefttext"] = "ZIBOCREW ".. ZC_VERSION .. " STARTED",["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "KPCREW ".. ZC_VERSION .. " Zibo B737-800"
			command_once("bgood/xchecklist/reload_checklist")
		end
	}
}

ZC_PREFLIGHT_START = {
	[0] = {["lefttext"] = "START PREFLIGHT EVENTS",["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "STARTING PREFLIGHT EVENTS"
			gPreflightCounter = 25*6
			ZC_BACKGROUND_PROCS["PREFLIGHT25"].status = 1
		end
	}
}

ZC_COLD_AND_DARK = {
	[0] = {["lefttext"] = "OVERHEAD TOP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(0,0)
			zc_acf_external_doors(0,0)
			zc_acf_cockpit_light_mode(0)
		end
	}, 
	[1] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_yaw_damper_onoff(0)
			set("laminar/B738/toggle_switch/alt_flaps_ctrl",0)
		end
	},
	[2] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/vhf_nav_source") == -1 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")
			end
			if get("laminar/B738/toggle_switch/vhf_nav_source") == 1 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
			end
			if get("laminar/B738/toggle_switch/irs_source") == -1 then
				command_once("laminar/B738/toggle_switch/irs_source_right")
			end
			if get("laminar/B738/toggle_switch/irs_source") == 1 then
				command_once("laminar/B738/toggle_switch/irs_source_left")
			end
			if get("laminar/B738/toggle_switch/fmc_source") == -1 then
				command_once("laminar/B738/toggle_switch/fmc_source_right")
			end
			if get("laminar/B738/toggle_switch/fmc_source") == 1 then
				command_once("laminar/B738/toggle_switch/fmc_source_left")
			end
			if get("laminar/B738/toggle_switch/dspl_source") == -1 then
				command_once("laminar/B738/toggle_switch/dspl_source_right")
			end
			if get("laminar/B738/toggle_switch/dspl_source") == 1 then
				command_once("laminar/B738/toggle_switch/dspl_source_left")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == -1 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == 1 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
			end
		end
	}, 
	[3] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(0,0)
			zc_acf_fuel_xfeed_mode(0)
		end
	}, 		
	[4] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/electrical/APU_off")
			command_once("sim/electrical/GPU_off")
			zc_acf_batteries_onoff(0)
		end
	},     
	[5] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/cab_util_pos",0)
			set("laminar/B738/toggle_switch/ife_pass_seat_pos",0)
			zc_acf_external_doors(1,1)
		end
	}, 
	[6] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
		end
	},                                                  
	[7] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
		end
	},                                                  
	[8] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_gpu_stop()
		end
	},                                                  
	[9] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/button_switch/cover_position",3) == 0 then
				command_once("laminar/B738/button_switch_cover03")
				command_once("laminar/B738/switch/standby_bat_off")
			end
		end
	},                                                  
	[10] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_wipers_mode(0,0)
			zc_acf_gen_on_bus(0,0)
			if ZC_BRIEF_DEP["depgatestand"] > 1 then
				zc_acf_airstair_onoff(1)
			end
		end
	},                                                  
	[11] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_panel_brightness(2,0)
			set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
			set("laminar/B738/toggle_switch/eq_cool_supply",0)
			zc_acf_emer_lights_mode(0)
		end
	},                                                  
	[12] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_seatbelt_onoff(0)
			zc_acf_no_smoking_onoff(0)
		end
	},                                                  
	[13] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(0,0)
			zc_acf_probe_heat_onoff(0,0)
		end
	},                                                  
	[14] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_wing_aice_onoff(0)
			zc_acf_eng_aice_onoff(0,0)
		end
	},                                                  
	[15] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(0,0)
		end
	},                                                  	
	[16] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_temp_control(0,0.5)
			set("laminar/B738/air/trim_air_pos",1)
		end
	},                     
	[17] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_recirc_fans_onoff(1,0)
			zc_acf_packs_set(0,0)
		end
	},                     
	[18] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(2)
			zc_acf_eng_bleeds_onoff(0,0)
			zc_acf_apu_bleed_onoff(0)
			zc_acf_set_flight_altitude(0)
			zc_acf_set_landing_altitude(0)
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
		end
	},     
	[19] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_taxi_mode(0)
			zc_acf_light_landing_mode(0,0)
			zc_acf_light_rwyto_onoff(0)
		end
	},                     
	[20] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/switches/generic_lights_switch",2,0)
			set("sim/cockpit2/switches/generic_lights_switch",3,0)
			set("sim/cockpit2/switches/generic_lights_switch",5,0)
			set("sim/cockpit2/switches/generic_lights_switch",0,0)
			set("sim/cockpit2/switches/generic_lights_switch",1,0)
			set("sim/cockpit2/switches/generic_lights_switch",9,0)
			set("sim/cockpit2/switches/generic_lights_switch",6,0)
			set("sim/cockpit2/switches/generic_lights_switch",7,0)
		end
	},                     
	[21] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_panel_brightness(0,0)
			zc_acf_panel_brightness(1,0)
			zc_acf_panel_brightness(2,0)
			zc_acf_panel_brightness(3,0)
		end
	},                     
	[22] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_rwyto_onoff(0)
			zc_acf_light_nav_onoff(0)
			zc_acf_light_beacon_onoff(0)
			zc_acf_light_logo_onoff(0)
		end
	},
	[23] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_apu_stop()
			zc_acf_flap_set(0)
			zc_acf_speed_break_set(0)
			zc_acf_parking_break_onoff(1)
			set("laminar/B738/fms/chock_status",0)
			zc_acf_fuel_lever_set(0,0)
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6")
			command_once("laminar/B738/tab/menu2")
			zc_acf_eng_starter_mode(0,1)
			zc_acf_xpdr_mode(1)
			zc_acf_abrk_mode(0)
			zc_acf_mcp_fds_set(0,0)
		end
	},
	[24] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
		end
	},
	[25] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gRightText = "TURN AROUND STATE SET"
			command_once("bgood/xchecklist/check_item")
		end
	}
}

ZC_POWER_UP_PROC = {
	[0] = {["lefttext"] = "POWER UP",["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"POWERING UP THE AIRCRAFT")
		end
	},
	-- Prepare aircraft
	[1] = {["lefttext"] = "FO: PARKING BRAKE -- SET",["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_parking_break_onoff(1)
		end
	},
	[2] = {["lefttext"] = "CAPT: FUEL CONTROLS -- CUTOFF",["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_lever_set(0,0)
		end
	},
	-- BATTERY ON
	[3] = {["lefttext"] = "CAPT: BATTERY -- ON",["timerincr"] = 2,
		["actions"] = function ()
			zc_acf_batteries_onoff(1)
		end
	},
	-- GROUND POWER ON
	[4] = {["lefttext"] = "FO: GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/home")
			end
		end
	},
	[5] = {["lefttext"] = "FO: GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/menu6")
			end
		end
	},
	[6] = {["lefttext"] = "FO: GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/menu1")
			end
		end
	},
	[7] = {["lefttext"] = "FO: GROUND POWER -- ON - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				command_once("sim/electrical/GPU_on")
			end
		end
	},
	[8] = {["lefttext"] = "FO: STANDBY POWER -- ON",["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/switch/standby_bat_on")
			command_once("laminar/B738/button_switch_cover03")
		end
	},
	-- APU ON
	[9] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 5,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				zc_acf_apu_activate()
			end
		end
	}, 
	[10] = {["lefttext"] = "FO: APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "----------- OBSOLETE REMOVE"
		end
	},
	-- FIRE TESTS
	[11] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_begin("laminar/B738/toggle_switch/fire_test_lft")
			zc_acf_light_wing_onoff(1)
		end
	},
	[12] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/fire_test_lft")
			command_begin("laminar/B738/toggle_switch/fire_test_rgt")
		end
	},
	[13] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/fire_test_rgt")
			command_begin("laminar/B738/toggle_switch/exting_test_lft")
		end
	},
	[14] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/exting_test_lft")
			command_begin("laminar/B738/toggle_switch/exting_test_rgt")
		end
	},
	[15] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/exting_test_rgt")
			command_begin("laminar/B738/push_button/cargo_fire_test_push")
		end
	},
	-- CONFIGURE FUEL PUMPS
	[16] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			command_end("laminar/B738/push_button/cargo_fire_test_push")
			zc_acf_fuel_pumps_onoff(5,0)
		end
	}, 
	[17] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(6,0)
		end
	}, 
	[18] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(1,0)
		end
	}, 
	[19] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(2,0)
		end
	}, 
	[20] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(3,0)
		end
	}, 
	[21] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(4,0)
		end
	}, 
	[22] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_xfeed_mode(0)
		end
	}, 
	-- OTHER SETTINGS
	[23] = {["lefttext"] = "FO: CONFIGURE ELEC HYD PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(1,1)
			zc_acf_hyd_pumps_onoff(2,1)
		end
	}, 
	[24] = {["lefttext"] = "FO: POSITION & WING LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_nav_onoff(1)
			if get("sim/private/stats/skyc/sun_amb_b") == 0 then
				zc_acf_light_wing_onoff(1)
			end
		end
	}, 
	[25] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(1,0)
		end
	}, 
	[26] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 4,
		["actions"] = function ()
			zc_acf_irs_mode(2,0)
		end
	}, 
	[27] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(1,1)
		end
	}, 
	[28] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(1,2)
		end
	}, 
	[29] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(2,1)
		end
	}, 
	[30] = {["lefttext"] = "CAPT: IRSs OFF, WAIT, THEN ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(2,2)
		end
	}, 
	[31] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_spd_set(get_zc_config("apspd"))
			zc_acf_mcp_hdg_set(get_zc_config("aphdg"))
			zc_acf_mcp_alt_set(get_zc_config("apalt"))
			if get("laminar/B738/systems/lowerDU_page2") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
			end
			-- open flight information window
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status=1
			zc_acf_xpdr_code_set(2000)
		end
	}, 
	[32] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "POWER UP FINISHED"
			speakNoText(0,"POWER UP FINISHED")
			gPreflightText = ""
		end
	}
}

ZC_TURN_AROUND_STATE = {
	[0] = {["lefttext"] = "OVERHEAD TOP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(0,0)
			zc_acf_external_doors(0,0)
			zc_acf_cockpit_light_mode(1)
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/right")				
			command_once("laminar/B738/tab/menu2")				
			command_once("laminar/B738/tab/line1")
		end
	}, 
	[1] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_yaw_damper_onoff(0)
			set("laminar/B738/toggle_switch/alt_flaps_ctrl",0)
		end
	}, 
	[2] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/vhf_nav_source") == -1 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")
			end
			if get("laminar/B738/toggle_switch/vhf_nav_source") == 1 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
			end
			if get("laminar/B738/toggle_switch/irs_source") == -1 then
				command_once("laminar/B738/toggle_switch/irs_source_right")
			end
			if get("laminar/B738/toggle_switch/irs_source") == 1 then
				command_once("laminar/B738/toggle_switch/irs_source_left")
			end
			if get("laminar/B738/toggle_switch/fmc_source") == -1 then
				command_once("laminar/B738/toggle_switch/fmc_source_right")
			end
			if get("laminar/B738/toggle_switch/fmc_source") == 1 then
				command_once("laminar/B738/toggle_switch/fmc_source_left")
			end
			if get("laminar/B738/toggle_switch/dspl_source") == -1 then
				command_once("laminar/B738/toggle_switch/dspl_source_right")
			end
			if get("laminar/B738/toggle_switch/dspl_source") == 1 then
				command_once("laminar/B738/toggle_switch/dspl_source_left")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == -1 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == 1 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
			end
		end
	}, 
	[3] = {["lefttext"] = "OVERHEAD COLUMN 1", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(0,0)
			zc_acf_fuel_xfeed_mode(0)
		end
	}, 		
	-- GROUND POWER ON
	[4] = {["lefttext"] = "GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_batteries_onoff(1)
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/home")
			end
		end
	},
	[5] = {["lefttext"] = "GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/menu6")
			end
		end
	},
	[6] = {["lefttext"] = "GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/gpu_available") == 0 then
				command_once("laminar/B738/tab/menu1")
			end
			zc_acf_external_doors(1,1)
		end
	},
	[7] = {["lefttext"] = "GROUND POWER -- ON - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false then
				command_once("sim/electrical/GPU_on")
			end
			if get_zc_config("apuinit") == false and get("laminar/B738/button_switch/cover_position",3) == 1 then
				command_once("laminar/B738/button_switch_cover03")
			end
		end
	},
	[8] = {["lefttext"] = "GROUND POWER -- ON - OPTIONAL",["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("apuinit") == false and get("laminar/B738/button_switch/cover_position",3) == 1 then
				command_once("laminar/B738/switch/standby_bat_on")
			end
		end
	},
	-- APU ON
	[9] = {["lefttext"] = "APU START - OPTIONAL", ["timerincr"] = 4,
		["actions"] = function ()
			if get_zc_config("apuinit") then
				zc_acf_apu_activate()
			end
			if ZC_BRIEF_DEP["depgatestand"] > 1 then
				zc_acf_airstair_onoff(1)
			end
			zc_acf_external_doors(2,1)
			zc_acf_external_doors(3,1)
		end
	}, 
	[10] = {["lefttext"] = "APU START - OPTIONAL", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "------- OBSOLETE REMOVE"
		end
	},
	[11] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/button_switch/cover_position", 3) == 1 then
				command_once("laminar/B738/button_switch_cover03")
			end
		end
	},     
	[12] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/cab_util_pos",1)
			set("laminar/B738/toggle_switch/ife_pass_seat_pos",1)
		end
	}, 
	[13] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
		end
	},                                                  
	[14] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
		end
	},                                                  
	[15] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/button_switch/cover_position", 3) == 1 then
				command_once("laminar/B738/button_switch_cover03")
				command_once("laminar/B738/switch/standby_bat_on")
			end
		end
	},                                                  
	[16] = {["lefttext"] = "OVERHEAD COLUMN 2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_wipers_mode(0,0)
			zc_acf_gen_on_bus(0,1)
		end
	},                                                  
	[17] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_panel_brightness(2,0)
			set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
			set("laminar/B738/toggle_switch/eq_cool_supply",0)
			zc_acf_emer_lights_mode(1)
		end
	},                                                  
	[18] = {["lefttext"] = "OVERHEAD COLUMN 3", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_seatbelt_onoff(1)
			zc_acf_no_smoking_onoff(1)
		end
	},                                                  
	[19] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(0,0)
			zc_acf_probe_heat_onoff(0,0)
		end
	},                                                  
	[20] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_wing_aice_onoff(0)
			zc_acf_eng_aice_onoff(0,0)
		end
	},                                                  
	[21] = {["lefttext"] = "OVERHEAD COLUMN 4", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(1,1)
			zc_acf_hyd_pumps_onoff(2,1)
			zc_acf_hyd_pumps_onoff(3,0)
			zc_acf_hyd_pumps_onoff(4,0)
		end
	},                                                  	
	[22] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_temp_control(0,0.5)
			set("laminar/B738/air/trim_air_pos",1)
		end
	},                     
	[23] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_recirc_fans_onoff(1,1)
			zc_acf_packs_set(1,0)
			zc_acf_packs_set(2,1)
		end
	},                     
	[24] = {["lefttext"] = "OVERHEAD COLUMN 5", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(1)
			zc_acf_eng_bleeds_onoff(0,0)
			zc_acf_apu_bleed_onoff(0)
			zc_acf_set_flight_altitude(0)
			zc_acf_set_landing_altitude(0)
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
		end
	},     
	[25] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_taxi_mode(0)
			zc_acf_light_landing_mode(0,0)
			zc_acf_light_rwyto_onoff(0)
		end
	},                     
	[26] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit2/switches/generic_lights_switch",2,0)
			set("sim/cockpit2/switches/generic_lights_switch",3,0)
			set("sim/cockpit2/switches/generic_lights_switch",5,0)
			set("sim/cockpit2/switches/generic_lights_switch",0,0)
			set("sim/cockpit2/switches/generic_lights_switch",1,0)
			set("sim/cockpit2/switches/generic_lights_switch",9,0)
			set("sim/cockpit2/switches/generic_lights_switch",6,0)
			set("sim/cockpit2/switches/generic_lights_switch",7,0)
		end
	},                     
	[27] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_panel_brightness(0,0)
			zc_acf_panel_brightness(1,0)
			zc_acf_panel_brightness(2,0)
			zc_acf_panel_brightness(3,0)
		end
	},                     
	[28] = {["lefttext"] = "LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_nav_onoff(1)
			zc_acf_light_beacon_onoff(0)
			zc_acf_light_logo_onoff(0)
		end
	},
	[29] = {["lefttext"] = "OTHER", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_flap_set(0)
			zc_acf_speed_break_set(0)
			zc_acf_parking_break_onoff(1)
			set("laminar/B738/fms/chock_status",1)
			zc_acf_fuel_lever_set(0,0)
			command_once("laminar/B738/tab/home")
			command_once("laminar/B738/tab/menu6")
			command_once("laminar/B738/tab/menu2")
			zc_acf_eng_starter_mode(0,1)
			zc_acf_xpdr_mode(1)
			zc_acf_abrk_mode(0)
		end
	},
	[30] = {["lefttext"] = "IRSs ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(0,1)
		end
	}, 
	[31] = {["lefttext"] = "IRSs ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(0,2)
		end
	}, 
	[32] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_spd_set(get_zc_config("apspd"))
			zc_acf_mcp_hdg_set(get_zc_config("aphdg"))
			zc_acf_mcp_alt_set(get_zc_config("apalt"))
			if get("laminar/B738/systems/lowerDU_page2") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
			end
			zc_acf_mcp_fds_set(0,0)
			zc_acf_xpdr_code_set(2000)
		end
	}, 
	[33] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gRightText = "TURN AROUND STATE SET"
		end
	}
}

ZC_PRE_FLIGHT_PROC = {
	[0] = {["lefttext"] = "PRE FLIGHT PROCEDURE",["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PRE FLIGHT PROCEDURE")
		end
	},
	[1] = {["lefttext"] = "CAPT: SET UP COCKPIT LIGHTING AS REQD", ["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/private/stats/skyc/sun_amb_b") == 0 then
				zc_acf_cockpit_light_mode(1)
			end
		end
	}, 
	[2] = {["lefttext"] = "CAPT: STALL WARNING TEST", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/push_button/mach_warn2_test")
			command_begin("laminar/B738/push_button/stall_test1_press")
		end
	}, 
	[3] = {["lefttext"] = "CAPT: STALL WARNING TEST", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/push_button/stall_test1_press")
			command_begin("laminar/B738/push_button/stall_test2_press")
		end
	}, 
	[4] = {["lefttext"] = "CAPT: STALL WARNING TEST", ["timerincr"] = 1,
		["actions"] = function ()
			command_end("laminar/B738/push_button/stall_test2_press")
		end
	}, 
	[5] = {["lefttext"] = "CAPT: SET PARKING BRAKE", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_parking_break_onoff(1)
		end
	}, 
	[6] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "CAPT: CDU PREFLIGHT PROCEDURE"
			command_once("FlyWithLua/AceLM/ShowHideMainWindow")
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status=1
			-- setchecklist(91)
		end
	}, 
	[7] = {["lefttext"] = "CAPT: CDU PREFLIGHT PROCEDURE", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "CDU PREFLIGHT PROCEDURE DONE"
		end
	}, 
	[8] = {["lefttext"] = "CAPT: MASTER LIGHTS TEST", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/bright_test_up")
		end
	}, 
	[9] = {["lefttext"] = "CAPT: MASTER LIGHTS TEST", ["timerincr"] = 997,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/bright_test_dn")
		end
	}, 
	[10] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1, 
		["actions"] = function ()
			zc_acf_set_dhda_mode(0,0)
		end
	}, 
	[11] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_set_minimum(0, get("sim/cockpit/pressure/cabin_altitude_actual_m_msl") + 200)
		end
	}, 
	[12] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,  
		["actions"] = function ()
			if get("laminar/B738/PFD/capt/fpv_on") ~= 0 then
				command_once("laminar/B738/EFIS_control/capt/push_button/fpv_press")
			end
		end
	}, 
	[13] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,
		["actions"] = function ()
			if get_zc_config("qnhhpa") then
				command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_up")
			end
			if get_zc_config("qnhhpa") == false then
				command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_dn")
			end
		end
	}, 
	[14] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,  
		["actions"] = function ()
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot",get("sim/weather/barometer_sealevel_inhg"))
		end
	}, 
	[15] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/EFIS_control/capt/vor1_off_up")
			command_once("laminar/B738/EFIS_control/capt/vor1_off_up")
			command_once("laminar/B738/EFIS_control/capt/vor2_off_up")
			command_once("laminar/B738/EFIS_control/capt/vor2_off_up")
			command_once("laminar/B738/EFIS_control/fo/vor1_off_up")
			command_once("laminar/B738/EFIS_control/fo/vor1_off_up")
			command_once("laminar/B738/EFIS_control/fo/vor2_off_up")
			command_once("laminar/B738/EFIS_control/fo/vor2_off_up")
		end
	}, 
	[16] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/EFIS_control/fo/map_mode_pos",2)
			set("laminar/B738/EFIS_control/capt/map_mode_pos",2)
		end
	}, 
	[17] = {["lefttext"] = "CAPT: EFIS CONTROL PANEL SETUP", ["timerincr"] = 5,  
		["actions"] = function ()
			if get("laminar/B738/EFIS/EFIS_wx_on") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
		end
	}, 
	[18] = {["lefttext"] = "CAPT: MCP - FLIGHT DIRECTORS ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_fds_set(0,1)
		end
	}, 
	[19] = {["lefttext"] = "CAPT: OXYGEN TEST AND SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/push_button/oxy_test_cpt")
		end
	}, 
	[20] = {["lefttext"] = "CAPT: SET CLOCK", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_et_timer_reset(1)
		end
	}, 
	[21] = {["lefttext"] = "CAPT: DISPLAY SELECT PANEL", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/lower_du_capt",0)
			set("laminar/B738/toggle_switch/lower_du_fo",0)
		end
	}, 
	[22] = {["lefttext"] = "CAPT: DISPLAY SELECT PANEL", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/main_pnl_du_capt",0)
			set("laminar/B738/toggle_switch/main_pnl_du_fo",0)
		end
	}, 
	[23] = {["lefttext"] = "CAPT: MCP - IAS TO V2", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_spd_set(get("laminar/B738/FMS/v2_set"))
			zc_acf_mcp_hdg_set(get("laminar/B738/fms/ref_runway_crs"))
			zc_acf_mcp_crs_set(0,get("laminar/B738/fms/ref_runway_crs"))
		end
	}, 
	[24] = {["lefttext"] = "CAPT: MCP - ALTITUDE TO 4900 UNTIL CLEARANCE", ["timerincr"] = 3,
		["actions"] = function ()
			zc_acf_mcp_alt_set(get_zc_config("apalt"))
		end
	}, 
	[25] = {["lefttext"] = "CAPT: SET STANDBY RMI", ["timerincr"] = 1,
		["actions"] = function ()
			set("sim/cockpit/switches/RMI_l_vor_adf_selector",0)
			set("sim/cockpit/switches/RMI_r_vor_adf_selector",0)
		end
	}, 
	[26] = {["lefttext"] = "CAPT: SPD BRAKE LEVER DOWN DETENT", ["timerincr"] = 3,
		["actions"] = function ()
			zc_acf_speed_break_set(0)
		end
	}, 
	[27] = {["lefttext"] = "CAPT: RADIO TUNING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET RADIOS"
		end
	}, 
	[28] = {["lefttext"] = "CAPT: RADIO TUNING PANEL SET", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "RADIOS CHECKED AND SET"
		end
	}, 
	[29] = {["lefttext"] = "FO: YAW DAMPER ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_yaw_damper_onoff(1)
		end
	}, 
	[30] = {["lefttext"] = "FO: IFE & GALLEY POWER", ["timerincr"] = 3,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/ife_pass_seat_pos",1)
			set("laminar/B738/toggle_switch/cab_util_pos",1)
		end
	},
	[31] = {["lefttext"] = "FO: APU ON", ["timerincr"] = 3,
		["actions"] = function ()
			zc_acf_apu_activate()
		end
	}, 
	[32] = {["lefttext"] = "FO: EMERGENCY EXIT LIGHTS ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			zc_acf_emer_lights_mode(1)
		end
	}, 
	[33] = {["lefttext"] = "FO: CABIN SIGNS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_seatbelt_onoff(1)
			zc_acf_no_smoking_onoff(1)
		end
	},                                                  
	[34] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(1,1)
		end
	}, 
	[35] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(2,1)
		end
	}, 
	[36] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(3,1)
		end
	}, 
	[37] = {["lefttext"] = "FO: WINDOW HEAT ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(4,1)
		end
	}, 
	[38] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(1,1)
		end
	}, 
	[39] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(2,1)
		end
	}, 
	[40] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(3,0)
		end
	}, 
	[41] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(4,0)
		end
	}, 
	[42] = {["lefttext"] = "FO: TRIM AIR & RECIRC FANS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_recirc_fans_onoff(1,1)
			set("laminar/B738/air/trim_air_pos",1)
		end
	}, 
	[43] = {["lefttext"] = "FO: PACKS AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_packs_set(0,1)
		end
	}, 
	[44] = {["lefttext"] = "FO: ISOLATION VLV OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(2)
		end
	}, 
	[45] = {["lefttext"] = "FO: BLEEDS ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_eng_bleeds_onoff(0,1)
			zc_acf_apu_bleed_onoff(1)
		end
	}, 
	[46] = {["lefttext"] = "FO: FLT ALT & LAND ALT SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_set_flight_altitude(get("laminar/B738/autopilot/fmc_cruise_alt"))
			zc_acf_set_landing_altitude(get("laminar/B738/autopilot/altitude"))
		end
	}, 
	[47] = {["lefttext"] = "FO: IGNITION SWITCH RIGHT", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/eng_start_source_right")
			command_once("laminar/B738/toggle_switch/eng_start_source_right")
		end
	}, 
	[48] = {["lefttext"] = "FO: WHEEL & LOGO LIGHTS", ["timerincr"] = 1,
		["actions"] = function ()
			if get("sim/private/stats/skyc/sun_amb_b") == 0 then
				zc_acf_light_wing_onoff(1)
				zc_acf_light_logo_onoff(1)
			end
		end
	}, 
	[49] = {["lefttext"] = "FO: OXYGEN TEST AND SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/push_button/oxy_test_fo")
		end
	}, 
	[50] = {["lefttext"] = "FO: WEATHER RADAR AND TERRAIN SET", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/EFIS/EFIS_wx_on") == 0 then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
			if get("laminar/B738/EFIS/fo/EFIS_wx_on") == 1 then
				command_once("laminar/B738/EFIS_control/fo/push_button/wxr_press")
			end
			if get("laminar/B738/EFIS_control/fo/terr_on") == 0 then
				command_once("laminar/B738/EFIS_control/fo/push_button/terr_press")
			end
			if get("laminar/B738/EFIS_control/capt/terr_on") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/terr_press")
			end
		end
	}, 
	[51] = {["lefttext"] = "FO: TRANSPONDER CONTROL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_xpdr_mode(1)
			command_begin("laminar/B738/knob/transponder_mode_dn")
			command_once("laminar/B738/push_button/gpws_test")
		end
	}, 
	[52] = {["lefttext"] = "CAPT: NAVIGATION AND DISPLAYS PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_end("laminar/B738/knob/transponder_mode_dn")
			if get("laminar/B738/toggle_switch/vhf_nav_source") > 0 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
			end
			if get("laminar/B738/toggle_switch/vhf_nav_source") < 0 then
				command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")
			end
		end
	}, 
	[53] = {["lefttext"] = "CAPT: NAVIGATION AND DISPLAYS PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/irs_source") > 0 then
				command_once("laminar/B738/toggle_switch/irs_source_left")
			end
			if get("laminar/B738/toggle_switch/irs_source") < 0 then
				command_once("laminar/B738/toggle_switch/irs_source_right")
			end
		end
	}, 
	[54] = {["lefttext"] = "CAPT: NAVIGATION AND DISPLAYS PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/fmc_source") > 0 then
				command_once("laminar/B738/toggle_switch/fmc_source_left")
			end
			if get("laminar/B738/toggle_switch/fmc_source") < 0 then
				command_once("laminar/B738/toggle_switch/irs_source_right")
			end
		end
	}, 
	[55] = {["lefttext"] = "CAPT: NAVIGATION AND DISPLAYS PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/dspl_source",0)
		end
	}, 
	[56] = {["lefttext"] = "CAPT: NAVIGATION AND DISPLAYS PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") > 0 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") < 0 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
			end
		end
	}, 		
	[57] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(5,0)
		end
	}, 
	[58] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(6,0)
		end
	}, 
	[59] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(1,0)
		end
	}, 
	[60] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(2,0)
		end
	}, 
	[61] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(3,0)
		end
	}, 
	[62] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(4,0)
		end
	}, 
	[63] = {["lefttext"] = "CAPT: FUEL PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_xfeed_mode(0)
		end
	}, 
	[64] = {["lefttext"] = "FO: AUTOBRAKE RTO", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_abrk_mode(-1)
		end
	}, 
	[65] = {["lefttext"] = "FO: FUEL FLOW RESET", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/fuel_flow_pos") == 0 then
				command_once("laminar/B738/toggle_switch/fuel_flow_up")
			end
		end
	}, 		
	[66] = {["lefttext"] = "FO: LOWER DU SYS", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/systems/lowerDU_page2") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
			end
		end
	}, 		
	[67] = {["lefttext"] = "FO: PROBE HEAT OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_probe_heat_onoff(0,0)
		end
	}, 
	[68] = {["lefttext"] = "FO: AIR CONDITIONING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_temp_control(0,0.5)
		end
	}, 
	[69] = {["lefttext"] = "FO: CABIN PRESSURIZATION PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
			command_once("laminar/B738/toggle_switch/air_valve_ctrl_left")
		end
	}, 
	[70] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_landing_mode(0,0)
		end
	}, 
	[71] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_nav_onoff(1)
		end
	}, 
	[72] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_beacon_onoff(0)
		end
	}, 
	[73] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_begin("laminar/B738/toggle_switch/fire_test_lft")
			zc_acf_light_wing_onoff(1)
		end
	},
	[74] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/fire_test_lft")
			command_begin("laminar/B738/toggle_switch/fire_test_rgt")
		end
	},
	[75] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/fire_test_rgt")
			command_begin("laminar/B738/toggle_switch/exting_test_lft")
		end
	},
	[76] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/exting_test_lft")
			command_begin("laminar/B738/toggle_switch/exting_test_rgt")
		end
	},
	[77] = {["lefttext"] = "FO: FIRE TESTS", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/toggle_switch/exting_test_rgt")
			command_begin("laminar/B738/push_button/cargo_fire_test_push")
		end
	},
	[78] = {["lefttext"] = "FO: MACH OVERSPEED TEST", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/push_button/cargo_fire_test_push")
			command_begin("laminar/B738/push_button/mach_warn1_test")
		end
	}, 
	[79] = {["lefttext"] = "FO: MACH OVERSPEED TEST", ["timerincr"] = 3,
		["actions"] = function ()
			command_end("laminar/B738/push_button/mach_warn1_test")
			command_begin("laminar/B738/push_button/mach_warn2_test")
		end
	}, 
	[80] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_end("laminar/B738/push_button/mach_warn2_test")
			zc_acf_light_taxi_mode(0)
		end
	}, 
	[81] = {["lefttext"] = "CAPT: LIGHTING PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_landing_mode(0,0)
		end
	}, 
	[82] = {["lefttext"] = "CAPT: APU SET", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PREFLIGHT PROCEDURE FINISHED"
			speakNoText(0,"READY FOR PREFLIGHT CHECKLIST")
		end
	}
}

-- PREFLIGHT
-- Oxygen . . . . . . . . . . . . . . . . . . . 	Tested, 100%
-- NAVIGATION transfer and DISPLAY switches . .		NORMAL, AUTO
-- Window heat  . . . . . . . . . . . . . . . .		On
-- Pressurization mode selector . . . . . . . .		AUTO
-- Flight instruments . . . . . . . . . . . . . 	Heading___, Altimeter___
-- Parking brake  . . . . . . . . . . . . . . . 	Set
-- Engine start levers  . . . . . . . . . . . . 	CUTOFF
-- Gear Pins  . . . . . . . . . . . . . . . . .		REMOVED

ZC_PREFLIGHT_CHECKLIST = {
	[0] = {["lefttext"] = "PREFLIGHT CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"PREFLIGHT CHECKLIST")
			-- concentrate easy items in initial item
			if get_zc_config("easy") then
				setchecklist(2)
				-- Navigation switches
				if get("laminar/B738/toggle_switch/vhf_nav_source") > 0 then
					command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
				end
				if get("laminar/B738/toggle_switch/vhf_nav_source") < 0 then
					command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")
				end
				if get("laminar/B738/toggle_switch/irs_source") > 0 then
					command_once("laminar/B738/toggle_switch/irs_source_left")
				end
				if get("laminar/B738/toggle_switch/irs_source") < 0 then
					command_once("laminar/B738/toggle_switch/irs_source_right")
				end
				if get("laminar/B738/toggle_switch/fmc_source") > 0 then
					command_once("laminar/B738/toggle_switch/fmc_source_left")
				end
				if get("laminar/B738/toggle_switch/fmc_source") < 0 then
					command_once("laminar/B738/toggle_switch/irs_source_right")
				end
				set("laminar/B738/toggle_switch/dspl_source",0)
				if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") > 0 then
					command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
				end
				if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") < 0 then
					command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
				end
				-- Window heat
				zc_acf_window_heat_onoff(0,1)
				-- Pressurization
				set("laminar/B738/annunciator/altn_press",0)
				-- Parking Brake
				zc_acf_parking_break_onoff(1)
				-- fuel cutoff switches
				zc_acf_fuel_lever_set(0,0)
			end
		end
	},
	[1] = {["lefttext"] = "OXYGEN -- TESTED, 100 %%", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"OXYGEN")
		end
	},
	[2] = {["lefttext"] = "OXYGEN -- TESTED, 100 %%", ["timerincr"] = 999,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"TESTED ONE HUNDRED PERCENT")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "NAVIGATION TRANSFER AND DISPLAY SWITCHES -- NORMAL, AUTO", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"NAVIGATION TRANSFER AND DISPLAY SWITCHES")
		end
	},
	[4] = {["lefttext"] = "NAVIGATION TRANSFER AND DISPLAY SWITCHES -- NORMAL, AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"NORMAL AND AUTO")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"WINDOW HEAT")
		end
	},
	[6] = {["lefttext"] = "WINDOW HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "PRESSURIZATION MODE SELECTOR -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PRESSURIZATION MODE SELECTOR")
		end
	},
	[8] = {["lefttext"] = "PRESSURIZATION MODE SELECTOR -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"AUTO")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "FLIGHT INSTRUMENTS -- HEADING _, ALTIMETER _", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT INSTRUMENTS")
			gLeftText = string.format("FLIGHT INSTRUMENTS -- HEADING %i, ALTIMETER %i",get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot"),get("laminar/B738/autopilot/altitude"))
		end
	},
	[10] = {["lefttext"] = "FLIGHT INSTRUMENTS -- HEADING _, ALTIMETER _", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("FLIGHT INSTRUMENTS -- HEADING %i, ALTIMETER %i",get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot"),get("laminar/B738/autopilot/altitude"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("HEADING %i, ALTIMETER %i",get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot"),get("laminar/B738/autopilot/altitude")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKE")
		end
	},
	[12] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SET")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[13] = {["lefttext"] = "ENGINE START LEVERS -- CUTOFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ENGINE START LEVERS")
		end
	},
	[14] = {["lefttext"] = "ENGINE START LEVERS -- CUTOFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CUT OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[15] = {["lefttext"] = "GEAR PINS -- REMOVED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"GEAR PINS")
		end
	},
	[16] = {["lefttext"] = "GEAR PINS -- REMOVED", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"REMOVED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[17] = {["lefttext"] = "PREFLIGHT CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PREFLIGHT CHECKLIST COMPLETED")
		end
	},
	[18] = {["lefttext"] = "PREFLIGHT CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PREFLIGHT CHECKLIST COMPLETED"
		end
	}
}

ZC_DEPARTURE_BRIEFING = {
	[0] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARE YOU READY FOR THE TAKEOFF BRIEF?"
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status=1
			setchecklist(91)
		end
	},
	[1] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ARE YOU READY FOR THE TAKEOFF BRIEF ?")
		end
	},
	[2] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 998,
		["actions"] = function ()
			speakNoText(0,"YES")
		end
	},
	[3] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"OK, I will be the pilot flying")
		end
	},
	[4] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"We have no M E L issues today")
		end
	},
	[5] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"This will be a standard takeoff, noise abatement departure procedure "..DEP_nadp_list[get_zc_brief_dep("depnadp")])
		end
	},
	[6] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"The departure will be via ".. DEP_proctype_list[get_zc_brief_dep("deptype")].." "..convertNato(get_zc_brief_dep("sid")))
		end
	},
	[7] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Our take off thrust is "..DEP_takeofthrust_list[get_zc_brief_dep("tothrust")])
		end
	},
	[8] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"We will use Flaps "..B738:getDEP_Flaps()[get_zc_brief_dep("toflaps")].." for takeoff")
		end
	},
	[9] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Runway condition is "..DEP_rwystate_list[get_zc_brief_dep("rwycond")])
		end
	},
	[10] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Anti Ice is "..DEP_aice_list[get_zc_brief_dep("depaice")])
		end
	},
	[11] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Bleeds will be "..DEP_bleeds_list[get_zc_brief_dep("depbleeds")])
		end
	},
	[12] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"In case of forced return we are "..DEP_forced_return[get_zc_brief_dep("forcedReturn")])
		end
	},
	[13] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"For the takeoff safety brief")
		end
	},
	[14] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"From 0 to 100 knots for any malfunction I will call reject and we will confirm the autobrakes are operating")
		end
	},
	[15] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"If not operating I will apply maximum manual breaking and maximum symmetric reverse thrust and come to a full stop on the runway")
		end
	},
	[16] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"After full stop on the runway we decide on course of further actions")
		end
	},
	[17] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 10,
		["actions"] = function ()
			speakNoText(0,"From 100 knots to V 1 I will reject only for one of the following reasons,   engine fire, engine failure or takeoff configuration warning horn")
		end
	},
	[18] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 10,
		["actions"] = function ()
			speakNoText(0,"At and above V 1 we will continue into the air and the only actions for you below 400 feet are to silence any alarm bells and confirm any failures")
		end
	},
	[19] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"Above 400 feet I will call for failure action drills as required and you'll perform memory items")
		end
	},
	[20] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"at 800 feet above field elevation I will call for altitude hold and we will retract the flaps on schedule")
		end
	},
	[21] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"At 1500 feet I will call for the checklist")
		end
	},
	[22] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 7,
		["actions"] = function ()
			speakNoText(0,"If we are above maximum landing weight we will make decision on whether to perform an overweight landing if the situation requires")
		end
	},
	[23] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 9,
		["actions"] = function ()
			speakNoText(0,"If we have a wheel well,   engine or wing fire,   I will turn the aircraft in such a way the flames will be downwind and we will evacuate through the upwind side")
		end
	},
	[24] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 9,
		["actions"] = function ()
			speakNoText(0,"If we have a cargo fire you need to ensure emergency services do not open the cargo doors until evac is completed")
		end
	},
	[25] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"Any questions or concerns?")
		end
	},
	[26] = {["lefttext"] = "DEPARTURE BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"no")
		end
	},	
	[27] = {["lefttext"] = "DEPARTURE BRIEFING COMPLETED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText="DEPARTURE BRIEFING COMPLETED"	
		end
	},
	[28] = {["lefttext"] = "DEPARTURE BRIEFING COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			speakNoText(0,"DEPARTURE BRIEFING COMPLETED")
		end
	}
}

ZC_BEFORE_START_PROC = {
	[0] = {["lefttext"] = "BEFORE START PROCEDURE",["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PERFORMING BEFORE START ITEMS")
			gRightText = "BEFORE START PROCEDURE"
		end
	},  
	[1] = {["lefttext"] = "CAPT: ARM AUTOTHROTTLE",["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/autopilot/autothrottle_status") == 0 then
				command_once("laminar/B738/autopilot/autothrottle_arm_toggle")
			end
		end
	},
	[2] = {["lefttext"] = "CLOSE EXTERNAL DOORS",["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_airstair_onoff(0)
			zc_acf_external_doors(0,0)
		end
	},
	[3] = {["lefttext"] = "CAPT: SET STAB TRIM ", ["timerincr"] = 5,
		["actions"] = function ()
			zc_acf_elev_trim_set(get_zc_brief_dep("elevtrim"))
		end
	}, 
	[4] = {["lefttext"] = "CAPT: RUDDER & AILERON TRIM SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_aileron_trim_set(0)
			zc_acf_rudder_trim_set(0)
		end
	},
	[5] = {["lefttext"] = "FO: SET FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(0,1)
			if get("laminar/B738/fuel/center_tank_kgs") <  100 then
				zc_acf_fuel_pumps_onoff(5,0)
				zc_acf_fuel_pumps_onoff(6,0)
			end
		end
	},
	[6] = {["lefttext"] = "FO: CABIN SIGNS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_seatbelt_onoff(1)
		end
	},                                                  
	[7] = {["lefttext"] = "FO: ISOLATION VLV OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(2)
		end
	}, 
	[8] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(1,0)
		end
	}, 
	[9] = {["lefttext"] = "FO: HYDRAULIC PANEL SET", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(2,0)
		end
	},
	[10] = {["lefttext"] = "FO: BEACON ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_beacon_onoff(1)
		end
	}, 
	[11] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"VERIFY TAKEOFF SPEEDS")
			command_once("laminar/B738/button/fmc1_init_ref")
			command_once("laminar/B738/button/fmc1_6L")
			command_once("laminar/B738/button/fmc1_4L")		
		end
	}, 
	[12] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V 1 %i",get("laminar/B738/FMS/v1")))
			gLeftText = string.format("V 1 %i",get("laminar/B738/FMS/v1"))
		end
	}, 
	[13] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V Rotate %i",get("laminar/B738/FMS/vr")))
			gLeftText = string.format("V Rotate %i",get("laminar/B738/FMS/vr"))
		end
	}, 
	[14] = {["lefttext"] = "VERIFY TAKEOFF SPEEDS", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,string.format("V 2 %i",get("laminar/B738/FMS/v2")))
			gLeftText = string.format("V 2 %i",get("laminar/B738/FMS/v2"))
		end
	}, 
	[15] = {["lefttext"] = "BEFORE START PROCEDURE COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE START PROCEDURE COMPLETED")
			if get("laminar/B738/systems/lowerDU_page2") ~= 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
			end
			if get("laminar/B738/systems/lowerDU_page") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
			end
		end
	},
	[16] = {["lefttext"] = "BEFORE START PROCEDURE COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE START PROCEDURE COMPLETED"
			speakNoText(0,"BEFORE START CHECKLIST")
			ZC_BACKGROUND_PROCS["APUBUSON"].status = 0
		end
	}
}
 
-- BEFORE START
-- Flight deck door . . . . . . . . . . . . . . 	Closed and locked
-- Fuel . . . . . . . . . . . . . . . . . . . . 	___ LBS/KGS, PUMPS ON
-- Passenger signs. . . . . . . . . . . . . . . 	SET
-- Windows. . . . . . . . . . . . . . . . . . .		Locked
-- MCP  . . . . . . . . . . . . . . . . . . . . 	V2___, HDG___, ALT___
-- Takeoff speeds . . . . . . . . . . . . . . .		V1___, VR___, V2___
-- CDU preflight. . . . . . . . . . . . . . . .		Completed
-- Rudder and aileron trim  . . . . . . . . . . 	Free and 0
-- Taxi and takeoff briefing. . . . . . . . . .		Completed
-- ANTI COLLISION light . . . . . . . . . . . . 	ON

ZC_BEFORE_START_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE START CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(3)
				-- flight deck door
				if get("laminar/B738/door/flt_dk_door_ratio") == 1 then
					command_once("laminar/B738/toggle_switch/flt_dk_door_open")
				end
				-- fuel tanks
				zc_acf_fuel_pumps_onoff(0,1)
				if get("laminar/B738/fuel/center_tank_kgs") <  100 then
					zc_acf_fuel_pumps_onoff(5,0)
					zc_acf_fuel_pumps_onoff(6,0)
				end
				-- seat belts
				zc_acf_seatbelt_onoff(1)
				-- Beacon
				zc_acf_light_beacon_onoff(1)
			end
		end
	},
	[1] = {["lefttext"] = "FUEL -- ___ KGS PUMPS ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FUEL")
			gLeftText = string.format("FUEL -- %i KGS PUMPS ON",get("laminar/B738/fuel/total_tank_kgs"))
		end
	},
	[2] = {["lefttext"] = "FUEL -- ____ KGS PUMPS ON", ["timerincr"] = 4,
		["actions"] = function ()
			gLeftText = string.format("FUEL -- %i KGS PUMPS ON",get("laminar/B738/fuel/total_tank_kgs"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("%i kilograms and pumps are on",get("laminar/B738/fuel/total_tank_kgs")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "PASSENGER SIGNS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PASSENGER SIGNS")
		end
	},
	[4] = {["lefttext"] = "PASSENGER SIGNS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "WINDOWS -- LOCKED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"WINDOWS")
		end
	},
	[6] = {["lefttext"] = "WINDOWS -- LOCKED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"LOCKED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "MCP -- V2____, HEADING____, ALTITUDE___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"M C P")
			gLeftText = string.format("MCP -- V2 %i, HEADING %i, ALTITUDE %i",get("laminar/B738/autopilot/mcp_speed_dial_kts2_fo"),get("laminar/B738/autopilot/mcp_hdg_dial"),get("laminar/B738/autopilot/mcp_alt_dial"))
		end
	},
	[8] = {["lefttext"] = "MCP -- V2____, HEADING____, ALTITUDE___", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("MCP -- V2 %i, HEADING %i, ALTITUDE %i",get("laminar/B738/autopilot/mcp_speed_dial_kts2_fo"),get("laminar/B738/autopilot/mcp_hdg_dial"),get("laminar/B738/autopilot/mcp_alt_dial"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("V 2 %i heading %i altitude %i",get("laminar/B738/autopilot/mcp_speed_dial_kts2_fo"),get("laminar/B738/autopilot/mcp_hdg_dial"),get("laminar/B738/autopilot/mcp_alt_dial")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "TAKEOFF SPEEDS -- V1____, VR____, V2___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"TAKEOFF SPEEDS")
			gLeftText = string.format("TAKEOFF SPEEDS -- V1 %i, VR %i, V2 %i",get("laminar/B738/FMS/v1"),get("laminar/B738/FMS/vr"),get("laminar/B738/FMS/v2"))
		end
	},
	[10] = {["lefttext"] = "TAKEOFF SPEEDS -- V1____, VR____, V2___", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("TAKEOFF SPEEDS -- V1 %i, VR %i, V2 %i",get("laminar/B738/FMS/v1"),get("laminar/B738/FMS/vr"),get("laminar/B738/FMS/v2"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("V 1 %i V R %i V 2 %i",get("laminar/B738/FMS/v1"),get("laminar/B738/FMS/vr"),get("laminar/B738/FMS/v2")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "CDU PREFLIGHT -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CDU PREFLIGHT")
		end
	},
	[12] = {["lefttext"] = "CDU PREFLIGHT -- COMPLETED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"COMPLETED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[13] = {["lefttext"] = "RUDDER AND AILERON TRIM -- FREE AND ZERO", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"RUDDER AND AILERON TRIM")
			if get_zc_config("easy") then
				zc_acf_rudder_trim_set(0)
				zc_acf_aileron_trim_set(0)
			end
		end
	},
	[14] = {["lefttext"] = "RUDDER AND AILERON TRIM -- FREE AND ZERO", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"FREE AND ZERO")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[15] = {["lefttext"] = "TAXI AND TAKEOFF BRIEFING -- COMPLETED", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"TAXI AND TAKEOFF BRIEFING")
		end
	},
	[16] = {["lefttext"] = "TAXI AND TAKEOFF BRIEFING -- COMPLETED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"COMPLETED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[17] = {["lefttext"] = "FLIGHT DECK DOOR -- CLOSED AND LOCKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT DECK DOOR")
		end
	},
	[18] = {["lefttext"] = "FLIGHT DECK DOOR -- CLOSED AND LOCKED", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CLOSED AND LOCKED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[19] = {["lefttext"] = "ANTI COLLISION LIGHT -- ON", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"ANTI COLLISION LIGHT")
		end
	},
	[20] = {["lefttext"] = "ANTI COLLISION LIGHT -- ON", ["timerincr"] = 2	,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[21] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE START CHECKLIST COMPLETED")	
		end
	},
	[22] = {["lefttext"] = "BEFORE START CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE START CHECKLIST COMPLETED"
		end
	}
}

ZC_PREPARE_PUSH = {
	[0] = {["lefttext"] = "PUSHBACK",["timerincr"] = 1,
		["actions"] = function ()
			gRightText = "PREPARE PUSHBACK"
		end
	},  
	[1] = {["lefttext"] = "CALL PUSHBACK TRUCK",["timerincr"] = 1,
		["actions"] = function ()
		gLeftText = "CALL PUSHBACK TRUCK"
		end
	},
	[2] = {["lefttext"] = "CALL PUSHBACK TRUCK",["timerincr"] = 998,
		["actions"] = function ()
			command_once("BetterPushback/start")
		end
	},
	[3] = {["lefttext"] = "PROCEDURE ONGOING", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "PUSHBACK ONGOING"
		end
	} 
}

ZC_STARTENGINE_PROC = {
	[0] = {["lefttext"] = "START SEQUENCE IS TWO THEN ONE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"START SEQUENCE IS TWO THEN ONE")
			if get("laminar/B738/systems/lowerDU_page") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
			end
		end
	},
	[1] = {["lefttext"] = "AIR - BLEEDS - PACKS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_packs_set(0,0)
		end
	},
	[2] = {["lefttext"] = "START ENGINE TWO", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "START ENGINE TWO"
		end
	},
	[3] = {["lefttext"] = "START ENGINE TWO", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"starting engine 2")
			command_once("laminar/B738/knob/eng2_start_left")
		end
	},
	[4] = {["lefttext"] = "WAIT FOR N2 25", ["timerincr"] = 1,
		["actions"] = function ()
			ZC_BACKGROUND_PROCS["FUEL2IDLE"].status=1
			ZC_BACKGROUND_PROCS["N1ROTATION2"].status=1
			ZC_BACKGROUND_PROCS["N2ROTATION2"].status=1
			ZC_BACKGROUND_PROCS["OILPRESSURE2"].status=1
			ZC_BACKGROUND_PROCS["N1INCREASE2"].status=1
			ZC_BACKGROUND_PROCS["EGTINCREASE2"].status=1
			ZC_BACKGROUND_PROCS["N2INCREASE2"].status=1
			ZC_BACKGROUND_PROCS["STARTERCUT2"].status=1
		end
	},
	[5] = {["lefttext"] = "START ENGINE ONE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText="START ENGINE ONE"
		end
	},
	[6] = {["lefttext"] = "START ENGINE ONE", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"starting engine 1")
			command_once("laminar/B738/knob/eng1_start_left")
		end
	},
	[7] = {["lefttext"] = "WAIT FOR N2 25", ["timerincr"] = 1,
		["actions"] = function ()
			ZC_BACKGROUND_PROCS["FUEL1IDLE"].status=1
			ZC_BACKGROUND_PROCS["N1ROTATION1"].status=1
			ZC_BACKGROUND_PROCS["N2ROTATION1"].status=1
			ZC_BACKGROUND_PROCS["OILPRESSURE1"].status=1
			ZC_BACKGROUND_PROCS["N1INCREASE1"].status=1
			ZC_BACKGROUND_PROCS["EGTINCREASE1"].status=1
			ZC_BACKGROUND_PROCS["N2INCREASE1"].status=1
			ZC_BACKGROUND_PROCS["STARTERCUT1"].status=1
		end
	},
	[8] = {["lefttext"] = "TWO GOOD STARTS", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "we have two good starts"
		end
	},
	[9] = {["lefttext"] = "TWO GOOD STARTS", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"TWO GOOD STARTS")
		end
	},
	[10] = {["lefttext"] = "TWO GOOD STARTS", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "WE HAVE TWO GOOD STARTS"
			ZC_BACKGROUND_PROCS["FUEL1IDLE"].status=0
			ZC_BACKGROUND_PROCS["N1ROTATION1"].status=0
			ZC_BACKGROUND_PROCS["N2ROTATION1"].status=0
			ZC_BACKGROUND_PROCS["OILPRESSURE1"].status=0
			ZC_BACKGROUND_PROCS["N1INCREASE1"].status=0
			ZC_BACKGROUND_PROCS["EGTINCREASE1"].status=0
			ZC_BACKGROUND_PROCS["N2INCREASE1"].status=0
			ZC_BACKGROUND_PROCS["STARTERCUT1"].status=0
			ZC_BACKGROUND_PROCS["FUEL2IDLE"].status=0
			ZC_BACKGROUND_PROCS["N1ROTATION2"].status=0
			ZC_BACKGROUND_PROCS["N2ROTATION2"].status=0
			ZC_BACKGROUND_PROCS["OILPRESSURE2"].status=0
			ZC_BACKGROUND_PROCS["N1INCREASE2"].status=0
			ZC_BACKGROUND_PROCS["EGTINCREASE2"].status=0
			ZC_BACKGROUND_PROCS["N2INCREASE2"].status=0
			ZC_BACKGROUND_PROCS["STARTERCUT2"].status=0
		end
	}
}

ZC_FLIGHT_CONTROLS_CHECK = {
	[0] = {["lefttext"] = "FLIGHT CONTROLS CHECK", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"FLIGHT CONTROLS CHECK")
		end
	},
	[1] = {["lefttext"] = "AILERON FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 997,
		["actions"] = function ()
			if get("laminar/B738/systems/lowerDU_page2") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
			end
		end
	},
	[2] = {["lefttext"] = "AILERON FULL LEFT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL LEFT")
		end
	},
	[3] = {["lefttext"] = "AILERON CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[4] = {["lefttext"] = "AILERON FULL RIGHT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL RIGHT")
		end
	},
	[5] = {["lefttext"] = "AILERON CENTER", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[6] = {["lefttext"] = "ELEVATOR FULL UP - FULL DOWN - CENTER", ["timerincr"] = 997,
		["actions"] = function ()
		end
	},
	[7] = {["lefttext"] = "ELEVATOR FULL UP", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL UP")
		end
	},
	[8] = {["lefttext"] = "ELEVATOR FULL DOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL DOWN")
		end
	},
	[9] = {["lefttext"] = "ELEVATOR CENTER", ["timerincr"] = 4,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[10] = {["lefttext"] = "RUDDER FULL LEFT - CENTER - FULL RIGHT - CENTER", ["timerincr"] = 997,
		["actions"] = function ()
		end
	},
	[11] = {["lefttext"] = "RUDDER FULL LEFT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL LEFT")
		end
	},
	[12] = {["lefttext"] = "RUDDER CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[13] = {["lefttext"] = "RUDDER FULL RIGHT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FULL RIGHT")
		end
	},
	[14] = {["lefttext"] = "RUDDER CENTER", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"CENTER")
		end
	},
	[15] = {["lefttext"] = "FLIGHT CONTROLS CHECKED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText="FLIGHT CONTROLS CHECKED"
			speakNoText(0,"before taxi checklist please")
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		end
	}
}

ZC_BEFORE_TAXI_PROC = {
	[0] = {["lefttext"] = "BEFORE TAXI PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAXI PROCEDURE")
			ZC_BACKGROUND_PROCS["FUEL1IDLE"].status = 0
			ZC_BACKGROUND_PROCS["FUEL2IDLE"].status = 0
		end
	},
	[1] = {["lefttext"] = "FO: GENERATORS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_gen_on_bus(0,1)
		end
	},
	[2] = {["lefttext"] = "FO: PROBE HEAT -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_probe_heat_onoff(0,1)
		end
	},
	[3] = {["lefttext"] = "FO: ISOLATION VALVES/PACKS -- AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(1)
			zc_acf_eng_bleeds_onoff(0,1)
			zc_acf_apu_bleed_onoff(0)
			zc_acf_packs_set(0,1)
		end
	},
	[4] = {["lefttext"] = "FO: HYDRAULICS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(0,1)
		end
	},
	[5] = {["lefttext"] = "FO: ENGINE START SWITCHES -- CONT", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_eng_starter_mode(0,2)
		end
	},
	[6] = {["lefttext"] = "FO: APU -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
			zc_acf_light_taxi_mode(2)
		end
	},
	[7] = {["lefttext"] = "FO: TAKEOFF FLAPS -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"SET TAKEOFF FLAPS")
			zc_acf_flap_set(zc_acf_getToFlap())
		end
	},
	[8] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE TAXI PROCEDURE FINISHED"
			speakNoText(0,"BEFORE TAXI CHECKLIST")
		end
	} 	
}

-- BEFORE TAXI
-- Generators . . . . . . . . . . . . . . . . .		On
-- Probe heat . . . . . . . . . . . . . . . . . 	On
-- Anti-ice . . . . . . . . . . . . . . . . . .		AS REQUIRED
-- Isolation valve  . . . . . . . . . . . . . . 	AUTO
-- ENGINE START switches  . . . . . . . . . . .		CONT
-- Recall . . . . . . . . . . . . . . . . . . . 	Checked
-- Autobrake. . . . . . . . . . . . . . . . . .		RTO
-- Engine start levers  . . . . . . . . . . . . 	IDLE detent
-- Flight controls. . . . . . . . . . . . . . .		Checked
-- Ground equipment . . . . . . . . . . . . . . 	Clear

ZC_BEFORE_TAXI_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE TAXI CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAXI CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(4)
				-- generator
				zc_acf_gen_on_bus(0,1)
				-- Probe heat
				zc_acf_probe_heat_onoff(0,1)
				-- isolation valve
				zc_acf_crossbleed_isol_mode(1)
				-- engine starters
				zc_acf_eng_starter_mode(0,2)
				-- autobrake
				zc_acf_abrk_mode(-1)
			end
		end
	},
	[1] = {["lefttext"] = "GENERATORS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"GENERATORS")
		end
	},
	[2] = {["lefttext"] = "GENERATORS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "PROBE HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PROBE HEAT")
		end
	},
	[4] = {["lefttext"] = "PROBE HEAT -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "ANTI-ICE -- AS REQUIRED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ANTI-ICE")
		end
	},
	[6] = {["lefttext"] = "ANTI-ICE -- AS REQUIRED", ["timerincr"] = 3,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"AS REQUIRED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "ISOLATION VALVE -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ISOLATION VALVE")
		end
	},
	[8] = {["lefttext"] = "ISOLATION VALVE -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"AUTO")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "ENGINE START LEVERS -- IDLE DETENT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ENGINE START LEVERS")
		end
	},
	[10] = {["lefttext"] = "ENGINE START LEVERS -- IDLE DETENT", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"IDLE DETENT")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},	
	[11] = {["lefttext"] = "FLIGHT CONTROLS -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLIGHT CONTROLS")
		end
	},
	[12] = {["lefttext"] = "FLIGHT CONTROLS -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CHECKED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[13] = {["lefttext"] = "AUTOBRAKE -- RTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AUTOBRAKE")
		end
	},
	[14] = {["lefttext"] = "AUTOBRAKE -- RTO", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"R T O")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[15] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"RECALL")
		end
	},
	[16] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CHECKED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[17] = {["lefttext"] = "ENGINE START SWITCHES -- CONT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ENGINE START SWITCHES")
		end
	},
	[18] = {["lefttext"] = "ENGINE START SWITCHES -- CONT", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CONTINOUS")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[19] = {["lefttext"] = "GROUND EQUIPMENT -- CLEAR", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"GROUND EQUIPMENT")
		end
	},
	[20] = {["lefttext"] = "GROUND EQUIPMENT -- CLEAR", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CLEAR")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[21] = {["lefttext"] = "CLEAR RIGHT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CLEAR RIGHT")
		end
	},
	[22] = {["lefttext"] = "CLEAR LEFT", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CLEAR LEFT")
			end
		end
	},
	[23] = {["lefttext"] = "BEFORE TAXI CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAXI CHECKLIST COMPLETED")	
		end
	},
	[24] = {["lefttext"] = "BEFORE TAXI CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE TAXI CHECKLIST COMPLETED"
		end
	}
}

-- BEFORE TAKEOFF
-- Takeoff Briefing . . . . . . . . . . . . . 		REVIEWED
-- Flaps. . . . . . . . . . . . . . . . . . .		___, Green light
-- Stabilizer trim. . . . . . . . . . . . . . 		___ Units
-- Cabin. . . . . . . . . . . . . . . . . . .		Secure

ZC_BEFORE_TAKEOFF_CHECKLIST = {
	[0] = {["lefttext"] = "BEFORE TAKEOFF CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKE OFF CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(5)
				zc_acf_elev_trim_set(get_zc_brief_dep("elevtrim"))
			end
		end
	},
	[1] = {["lefttext"] = "FLAPS -- FLAPS __ GREEN LIGHT", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
			gLeftText = string.format("FLAPS %i GREEN LIGHT",zc_acf_getToFlap())
		end
	},
	[2] = {["lefttext"] = "FLAPS -- FLAPS __ GREEN LIGHT", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("FLAPS %i GREEN LIGHT",zc_acf_getToFlap())
			if get_zc_config("easy") then
				speakNoText(0,string.format("FLAPS %i GREEN LIGHT",zc_acf_getToFlap()))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "STABILIZER TRIM -- __ UNITS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"STABILIZER TRIM")
			gLeftText = string.format("STABILIZER TRIM -- %.2f UNITS",get_zc_brief_dep("elevtrim"))
		end
	},
	[4] = {["lefttext"] = "STABILIZER TRIM -- __ UNITS", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("STABILIZER TRIM -- %.2f UNITS",get_zc_brief_dep("elevtrim"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("%.2f units",get_zc_brief_dep("elevtrim")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "TAKEOFF BRIEFING -- REVIEWED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"TAKE OFF BRIEFING")
		end
	},
	[6] = {["lefttext"] = "TAKEOFF BRIEFING -- REVIEWED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"REVIEWED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CABIN")
		end
	},
	[8] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SECURE")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "BEFORE TAKE OFF CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKE OFF CHECKLIST COMPLETED")		
		end
	},
	[10] = {["lefttext"] = "BEFORE TAKE OFF CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "BEFORE TAKE OFF CHECKLIST COMPLETED"
		end
	}
}

ZC_BEFORE_TAKEOFF_PROC = {
	[0] = {["lefttext"] = "BEFORE TAKEOFF PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"BEFORE TAKEOFF PROCEDURE")
		end
	},
	[1] = {["lefttext"] = "LANDING LIGHTS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/spring_switch/landing_lights_all")
		end
	},
	[2] = {["lefttext"] = "STROBES -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_strobe_mode(1)
		end
	},
	[3] = {["lefttext"] = "TAXI LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_taxi_mode(0)
			if get("sim/private/stats/skyc/sun_amb_b") == 0 then
				zc_acf_light_rwyto_onoff(1)
			end
			zc_acf_seatbelt_onoff(0)
		end
	},
	[4] = {["lefttext"] = "TRANSPONDER -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_xpdr_code_set(get_zc_brief_gen("squawk"))
			zc_acf_xpdr_mode(5)
			if get("laminar/B738/EFIS/EFIS_wx_on") == 0 then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
			zc_acf_seatbelt_onoff(1)
			zc_acf_et_timer_startstop(1)
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
			zc_acf_eng_starter_mode(0,2)
			if get("laminar/B738/systems/lowerDU_page") == 0 then
				command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
			end
			if get("laminar/B738/systems/lowerDU_page") == 1 then
				command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
			end
		end
	},
	[5] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
		gLeftText = "BEFORE TAKEOFF PROCEDURE FINISHED"
		end
	}
}

ZC_CLIMB_PROC = {
	[0] = {["lefttext"] = "TAKEOFF AND CLIMB PROCEDURE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET TAKEOFF THRUST"
			if get("laminar/B738/autopilot/autothrottle_arm_pos") == 0 then
				command_once("laminar/B738/autopilot/autothrottle_arm_toggle")
			end
			if get("laminar/B738/autopilot/pfd_hdg_mode") == 0 then
				command_once("laminar/B738/autopilot/hdg_sel_press")
			end
			if get("laminar/B738/EFIS/EFIS_wx_on") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
			if get_zc_brief_dep("lnavvnav") and get("laminar/B738/autopilot/lnav_pos") == 0 then
				command_once("laminar/B738/autopilot/lnav_press")
			end
			if get_zc_brief_dep("lnavvnav") == false and get("laminar/B738/autopilot/hdg_sel_status") == 0 then
				command_once("laminar/B738/autopilot/hdg_sel_press")
			end
			if get_zc_brief_dep("lnavvnav") and get("laminar/B738/autopilot/vnav_pos") == 0 then
				command_once("laminar/B738/autopilot/vnav_press")
			end
			if get_zc_brief_dep("lnavvnav") == false and get("laminar/B738/autopilot/lvl_chg_status") == 0 then
				command_once("laminar/B738/autopilot/lvl_chg_press")
			end
			if get_zc_config("easy") then
				ZC_BACKGROUND_PROCS["80KTS"].status = 1
				ZC_BACKGROUND_PROCS["V1"].status = 1
				ZC_BACKGROUND_PROCS["ROTATE"].status = 1
			end
		end
	},
	[1] = {["lefttext"] = "SET TAKEOFF THRUST", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"TAKEOFF thrust set")
			command_once("laminar/B738/autopilot/n1_press")
			command_once("laminar/B738/autopilot/left_toga_press")
			if get_zc_config("easy") then
				ZC_BACKGROUND_PROCS["FLAPSUPSCHED"].status = 1
				ZC_BACKGROUND_PROCS["GEARUP"].status = 1
			end
		end
	},
	[2] = {["lefttext"] = "GEAR UP", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "GEAR UP"
		end
	},
	[3] = {["lefttext"] = "GEAR UP", ["timerincr"] = get_zc_config("easy") and 1 or 997,
		["actions"] = function ()
			if get_zc_config("easy") == false then
				speakNoText(0,"POSITIV RATE    GEAR UP")
				command_once("laminar/B738/push_button/gear_up")
			end
		end
	},
	[4] = {["lefttext"] = "SET CMD A",["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET CMD A"
		end
	},
	[5] = {["lefttext"] = "SET CMD A",["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"COMMAND A")
			zc_acf_mcp_ap_set(1,1)
		end
	},
	[6] = {["lefttext"] = "FLAPS 10",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 15) and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 10"
		end
	},
	[7] = {["lefttext"] = "FLAPS 10",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 15) and 997 or 996,
		["actions"] = function ()
			if get_zc_config("easy") == false then
				speakNoText(0,"SPEED CHECK   FLAPS 10")
				zc_acf_flap_set(10)
			end
		end
	},
	[8] = {["lefttext"] = "FLAPS 5",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 10) and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 5"
		end
	},
	[9] = {["lefttext"] = "FLAPS 5",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 10) and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 5")
			zc_acf_flap_set(5)
		end
	},
	[10] = {["lefttext"] = "FLAPS 1",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 5) and 1 or 996,
		["actions"] = function ()
			gLeftText = "FLAPS 1"
		end
	},
	[11] = {["lefttext"] = "FLAPS 1",["timerincr"] = (get_zc_config("easy") == false and zc_get_flap_position() == 5) and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 1")
			zc_acf_flap_set(1)
		end
	},
	[12] = {["lefttext"] = "FLAPS UP",["timerincr"] = get_zc_config("easy") == false and 1 or 996,
		["actions"] = function ()
			speakNoText(0,"FLAPS UP")
		end
	},
	[13] = {["lefttext"] = "FLAPS UP",["timerincr"] = get_zc_config("easy") == false and 997 or 996,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS UP")
			zc_acf_flap_set(0)
		end
	},
	[14] = {["lefttext"] = "GEAR OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("laminar/B738/push_button/gear_off")
		end
	}, 
	[15] = {["lefttext"] = "AFTER TAKEOFF ITEMS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_eng_starter_mode(0,1)
			zc_acf_light_rwyto_onoff(0)
			zc_acf_light_landing_mode(2,0)
			zc_acf_abrk_mode(0)
			command_once("laminar/B738/knob/autobrake_up")
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
		end
	},
	[16] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 1
			ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 1
			gLeftText = "CLIMB PROCEDURE FINISHED"
		end
	} 	
}

-- AFTER TAKEOFF
-- Engine bleeds. . . . . . . . . . . . . . . 		On
-- Packs. . . . . . . . . . . . . . . . . . . 		AUTO
-- Landing gear . . . . . . . . . . . . . . . 		UP and OFF
-- Flaps . . . . . . . . . . . . . . . . . . . 		UP, no lights
-- Altimeters . . . . . . . . . . . . . . . . 		SET

ZC_AFTER_TAKEOFF_CHECKLIST = {
	[0] = {["lefttext"] = "AFTER TAKEOFF PROCEDURE & CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"AFTER TAKE OFF CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(6)
				-- Bleeds
				zc_acf_eng_bleeds_onoff(0,1)
				-- Packs
				zc_acf_packs_set(0,1)
				-- Landing gear
				command_once("sim/flight_controls/landing_gear_up")
				-- Flaps
				zc_acf_flap_set(0)
				zc_acf_abrk_mode(0)
			end
			ZC_BACKGROUND_PROCS["80KTS"].status = 0
			ZC_BACKGROUND_PROCS["GEARUP"].status = 0
		end
	},
	[1] = {["lefttext"] = "ENGINE BLEEDS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ENGINE BLEEDS")
		end
	},
	[2] = {["lefttext"] = "ENGINE BLEEDS -- ON", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ON")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "PACKS -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"PACKS")
		end
	},
	[4] = {["lefttext"] = "PACKS -- AUTO", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"AUTO")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "LANDING GEAR -- UP AND OFF", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING GEAR")
		end
	},
	[6] = {["lefttext"] = "LANDING GEAR -- UP AND OFF", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"UP AND OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "FLAPS -- UP NO LIGHTS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[8] = {["lefttext"] = "FLAPS -- UP NO LIGHTS", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"UP NO LIGHTS")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "ALTIMETERS -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ALTIMETERS")
		end
	},
	[10] = {["lefttext"] = "ALTIMETERS -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SET")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "AFTER TAKEOFF CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"AFTER TAKEOFF CHECKLIST COMPLETED")
		end
	},
	[12] = {["lefttext"] = "AFTER TAKEOFF CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "AFTER TAKEOFF CHECKLIST COMPLETED"
		end
	}
}

ZC_APPROACH_BRIEFING = {
	[0] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARE YOU READY FOR THE APPROACH BRIEF?"
			ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status=1
			-- setchecklist(92)
		end
	},
	[1] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ARE YOU READY FOR THE APPROACH BRIEF ?")
		end
	},
	[2] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"YES")
		end
	},
	[3] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"ok, we will be arriving via "..APP_proctype_list[get_zc_brief_app("arrtype")].." "..convertNato(get_zc_brief_app("star")))
		end
	},
	[4] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 6,
		["actions"] = function ()
			speakNoText(0,"after the arrival we can expect an "..APP_apptype_list[get_zc_brief_app("apptype")].." approach into our destination")
		end
	},
	[5] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"Runway assigned is "..convertRwy(get_zc_brief_app("apprwy")).."    and the condition is "..APP_rwystate_list[get_zc_brief_app("rwycond")])
		end
	},	
	[6] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Anti Ice is "..APP_aice_list[get_zc_brief_app("appaice")])
		end
	},
	[7] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Landing flaps will be "..GENERAL_Acf:getAPP_Flaps()[get_zc_brief_app("ldgflaps")])
		end
	},
	[8] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"for auto brake we will use level "..GENERAL_Acf:getAutobrake()[get_zc_brief_app("autobrake")])
		end
	},
	[9] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Packs will be "..GENERAL_Acf:getBleeds()[get_zc_brief_app("apppacks")])
		end
	},
	[10] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Decision "..(get_zc_config("dhda")==true and "height" or "altitude").." will be "..(get_zc_config("dhda")==true and get_zc_brief_app("dh") or get_zc_brief_app("da")))
		end
	},
	[11] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Anti ice is "..GENERAL_Acf:getAIce()[get_zc_brief_app("appaice")])
		end
	},
	[12] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Approach speed "..get_zc_brief_app("vapp"))
		end
	},
	[13] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Reference speed "..get_zc_brief_app("vref"))
		end
	},
	[14] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"Missed approach altitude "..get_zc_brief_app("gaalt"))
		end
	},
	[15] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"Any questions or concerns?")
		end
	},
	[16] = {["lefttext"] = "APPROACH BRIEFING", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"no")
		end
	},	
	[17] = {["lefttext"] = "APPROACH BRIEFING COMPLETED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"APPROACH BRIEFING COMPLETED")		
		end
	},
	[18] = {["lefttext"] = "APPROACH BRIEFING COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "APPROACH BRIEFING COMPLETED"	
		end
	}
}

-- DESCENT
-- Pressurisation . . . . . . . . . . . . . . 		LAND ALT___
-- Recall . . . . . . . . . . . . . . . . . . 		Checked
-- Autobrake . . . . . . . . . . . . . . . . 		___
-- Landing data . . . . . . . . . . . . . . . 		VREF___, Minimums___
-- Approach briefing . . . . . . . . . . . .		Completed

ZC_DESCENT_CHECKLIST = {
	[0] = {["lefttext"] = "DESCENT CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"DESCENT CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(7)
				-- autobrake
				zc_acf_abrk_mode(get_zc_brief_app("autobrake")-1)
				-- Switch MFD to ENG
				if get("laminar/B738/systems/lowerDU_page2") == 0 then
					command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
				end
			end
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 0
			ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 0
			ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 1
			ZC_BACKGROUND_PROCS["TRANSLVL"].status = 1
		end
	},
	[1] = {["lefttext"] = "PRESSURIZATION -- LAND ALT___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PRESSURIZATION")
		end
	},
	[2] = {["lefttext"] = "PRESSURIZATION -- LAND ALT___", ["timerincr"] = 3,
		["actions"] = function ()
			gLeftText = string.format("landing altitude %i",get("laminar/B738/pressurization/knobs/landing_alt"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("landing altitude %i",get("laminar/B738/pressurization/knobs/landing_alt")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"RECALL")
		end
	},
	[4] = {["lefttext"] = "RECALL -- CHECKED", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CHECKED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "AUTOBRAKE -- ___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"AUTOBRAKE")
			gLeftText = string.format("AUTOBRAKE %i",get("laminar/B738/autobrake/autobrake_pos"))
		end
	},
	[6] = {["lefttext"] = "AUTOBRAKE -- ___", ["timerincr"] = 3,
		["actions"] = function ()
			gLeftText = string.format("AUTOBRAKE %i",get("laminar/B738/autobrake/autobrake_pos"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("AUTOBRAKE %i",get("laminar/B738/autobrake/autobrake_pos")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "LANDING DATA -- VREF__, MINIMUMS__FEET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"LANDING DATA")
			gLeftText = string.format("V REFERENCE %i  MINIMUMS %i FEET",get("laminar/B738/FMS/vref"),get("laminar/B738/pfd/dh_pilot"))
		end
	},
	[8] = {["lefttext"] = "LANDING DATA -- VREF__, MINIMUMS__FEET", ["timerincr"] = 999,
		["actions"] = function ()
			gLeftText = string.format("V REFERENCE %i  MINIMUMS %i FEET",get("laminar/B738/FMS/vref"),get("laminar/B738/pfd/dh_pilot"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("V REFERENCE %i  MINIMUMS %i FEET",get("laminar/B738/FMS/vref"),get("laminar/B738/pfd/dh_pilot")))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"APPROACH BRIEFING")
		end
	},
	[10] = {["lefttext"] = "APPROACH BRIEFING -- COMPLETED", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"COMPLETED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "THROTTLE -- IDLE", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"THROTTLE TO IDLE FOR Zee BO")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[12] = {["lefttext"] = "DESCENT CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"DESCENT CHECKLIST COMPLETED")		
		end
	},
	[13] = {["lefttext"] = "DESCENT CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "DESCENT CHECKLIST COMPLETED"
		end
	}
}

-- APPROACH
-- Altimeters . . . . . . . . . . . . . . . 		QNH ___
-- NAV AIDS . . . . . . . . . . . . . . . . 		SET

ZC_APPROACH_CHECKLIST = {
	[0] = {["lefttext"] = "APPROACH CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"APRPOACH CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(8)
			end
			ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status=1
		end
	},
	[1] = {["lefttext"] = "ALTIMETERS -- QNH ___", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ALTIMETERS")
		end
	},
	[2] = {["lefttext"] = "ALTIMETERS -- QNH___", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,string.format("QNH %i",get("laminar/B738/EFIS/baro_sel_in_hg_pilot"),"*","33.86389"))
			gLeftText = string.format("QNH %i",get("laminar/B738/EFIS/baro_sel_in_hg_pilot"),"*","33.86389")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[3] = {["lefttext"] = "NAV AIDS -- SET AND CHECKED", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"NAVIGATION AIDS")
		end
	},
	[4] = {["lefttext"] = "NAV AIDS -- SET AND CHECKED", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"SET AND CHECKED")
			command_once("bgood/xchecklist/check_item")
		end
	},
	[5] = {["lefttext"] = "APPROACH CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"APPROACH CHECKLIST COMPLETED")
		end
	},
	[6] = {["lefttext"] = "APPROACH CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			command_once("bgood/xchecklist/check_item")
		end
	}
}

ZC_LANDING_PROC = {
	[0] = {["lefttext"] = "LANDING PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			zc_acf_light_taxi_mode(0)
			zc_acf_light_rwyto_onoff(1)
			zc_acf_seatbelt_onoff(1)
			command_once("sim/lights/landing_lights_on")
			zc_acf_eng_starter_mode(0,2)
			ZC_BACKGROUND_PROCS["TRANSALT"].status = 0
			ZC_BACKGROUND_PROCS["TRANSLVL"].status = 0
			ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 0
			setchecklist(92)
			if (ZC_CONFIG["dhda"]) then
				zc_acf_set_dhda_mode(0,0)
				zc_acf_set_minimum(0, get_zc_brief_app("dh"))
			else
				zc_acf_set_dhda_mode(0,1)
				zc_acf_set_minimum(0, get_zc_brief_app("da"))
			end
			zc_acf_speed_break_set(1)
			zc_acf_abrk_mode(get_zc_brief_app("autobrake")-1)
		end
	},
	[1] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 210 KTS - FLAPS 1"
		end
	},
	[2] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 1")
		end
	},
	[3] = {["lefttext"] = "AT 210 KTS - FLAPS 1", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK FLAPS 1")
			zc_acf_flap_set(1)
		end
	},
	[4] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 180 KTS - FLAPS 5"
		end
	},
	[5] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 5")
		end
	},
	[6] = {["lefttext"] = "AT 180 KTS - FLAPS 5", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK FLAPS 5")
			zc_acf_flap_set(5)
		end
	},
	[7] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AT 160 KTS -- FLAPS 15 GEAR DOWN"
		end
	},
	[8] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 15  GEAR DOWN")
		end
	},
	[9] = {["lefttext"] = "AT 160 KTS -- FLAPS 15 GEAR DOWN", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 15")
			zc_acf_flap_set(15)
			command_once("sim/flight_controls/landing_gear_down")
		end
	},
	[10] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ARM SPEEDBRAKE"
		end
	},
	[11] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 997,
		["actions"] = function ()
			zc_acf_speed_break_set(1)
		end
	},
	[12] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "FLAPS 30"
		end
	},
	[13] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 997,
		["actions"] = function ()
			speakNoText(0,"FLAPS 30")
		end
	},
	[14] = {["lefttext"] = "AT 155 KTS - FLAPS 30", ["timerincr"] = 5,
		["actions"] = function ()
			speakNoText(0,"SPEED CHECK   FLAPS 30")
			zc_acf_flap_set(30)
		end
	},
	[15] = {["lefttext"] = "SET MISSED APPROACH ALTITUDE", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "SET MISSED APPROACH ALTITUDE"
		end
	},
	[16] = {["lefttext"] = "SET MISSED APPROACH ALTITUDE", ["timerincr"] = 997,
		["actions"] = function ()
			zc_acf_mcp_alt_set(get("laminar/B738/fms/missed_app_alt"))
		end
	},
	[17] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "LANDING PROCEDURE FINISHED"
		end
	}, 	
	[18] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "LANDING PROCEDURE FINISHED"
		end
	}
}

-- LANDING
-- Cabin . . . . . . . . . . . . . . . . . .		Secure
-- ENGINE START switches . . . . . . . . . .		CONT
-- Speedbrake  . . . . . . . . . . . . . . . 		Armed
-- Landing gear. . . . . . . . . . . . . . . 		Down
-- Flaps . . . . . . . . . . . . . . . . . .		___, green light

ZC_LANDING_CHECKLIST = {
	[0] = {["lefttext"] = "LANDING CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"LANDING CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(9)
				-- starter cont
				zc_acf_eng_starter_mode(0,2)
				-- Gear
				command_once("laminar/B738/push_button/gear_down")
				zc_acf_speed_break_set(1)
			end
		end
	},
	[1] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"CABIN")
		end
	},
	[2] = {["lefttext"] = "CABIN -- SECURE", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SECURE")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "ENGINE START SWITCHES -- CONTINUOUS", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"ENGINE START SWITCHES")
		end
	},
	[4] = {["lefttext"] = "ENGINE START SWITCHES -- CONTINUOUS", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CONTINUOUS")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SPEEDBRAKE")
		end
	},
	[6] = {["lefttext"] = "SPEEDBRAKE -- ARMED", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"ARMED")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "LANDING GEAR -- DOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING GEAR")
		end
	},
	[8] = {["lefttext"] = "LANDING GEAR -- DOWN", ["timerincr"] = 2,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"DOWN")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "FLAPS -- FLAPS 15/30/40 GREEN LIGHT", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[10] = {["lefttext"] = "FLAPS -- FLAPS 15/30/40 GREEN LIGHT", ["timerincr"] = 3,
		["actions"] = function ()
			gLeftText = string.format("FLAPS %i GREEN LIGHT",get("laminar/B738/FMS/approach_flaps"))
			if get_zc_config("easy") then
				speakNoText(0,string.format("FLAPS %i GREEN LIGHT",zc_get_flap_position()))
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "LANDING CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"LANDING CHECKLIST COMPLETED")		
		end
	},
	[12] = {["lefttext"] = "LANDING CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "LANDING CHECKLIST COMPLETED"
		end
	}
}

ZC_FINAL_PROC = {
	[0] = {["lefttext"] = "ON FINAL", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "ON FINAL"
		end
	},
	[1] = {["lefttext"] = "CLEARED FOR LANDING?", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "CLEARED FOR LANDING?"
		end
	},
	[2] = {["lefttext"] = "CLEARED FOR LANDING?", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "CLEARED"
		end
	},
	[3] = {["lefttext"] = "AUTOPILOT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AUTOPILOT OFF"
		end
	},
	[4] = {["lefttext"] = "AUTOPILOT -- OFF", ["timerincr"] = 998,
		["actions"] = function ()
			gLeftText = "SET OFF"
			command_once("laminar/B738/autopilot/capt_disco_press")
		end
	},
	[5] = {["lefttext"] = "AUTOTHROTTLE -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "AUTOTHROTTLE OFF"
			command_begin("laminar/B738/autopilot/capt_disco_press")
		end
	},
	[6] = {["lefttext"] = "AUTOTHROTTLE -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			gLeftText = "SET OFF"
			command_once("laminar/B738/autopilot/left_at_dis_press")
			command_end("laminar/B738/autopilot/capt_disco_press")
		end
	},
	[7] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = 1,
		["actions"] = function ()
			gLeftText = "HAPPY LANDING"
		end
	}, 	
	[8] = {["lefttext"] = "PROCEDURE FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "HAPPY LANDING"
		end
	}
}

ZC_AFTER_LANDING_PROC = {
	[0] = {["lefttext"] = "CLEANUP", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"it is OK TO CLEAN UP")
		end
	},
	[1] = {["lefttext"] = "CAPT: SPEED BRAKES -- UP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_speed_break_set(0)
		end
	},
	[2] = {["lefttext"] = "CAPT: CHRONO -- STOP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_et_timer_startstop(1)
			command_once("laminar/B738/push_button/chrono_capt_et_mode")
		end
	},
	[3] = {["lefttext"] = "CAPT: WX RADAR -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/EFIS/EFIS_wx_on") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
		end
	},
	[4] = {["lefttext"] = "FO: APU -- ON", ["timerincr"] = 5,
		["actions"] = function ()
			command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
		end
	}, 
	[5] = {["lefttext"] = "FO: APU -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
		end
	}, 
	[6] = {["lefttext"] = "FO: FLAPS -- UP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_flap_set(0)
		end
	},
	[7] = {["lefttext"] = "FO: PROBE HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_probe_heat_onoff(0,0)
		end
	},
	[8] = {["lefttext"] = "FO: STROBES -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_nav_onoff(1)
		end
	},
	[9] = {["lefttext"] = "FO: LANDING LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/lights/landing_lights_off")
		end
	},
	[10] = {["lefttext"] = "FO: TAXI LIGHTS -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_taxi_mode(1)
		end
	},
	[11] = {["lefttext"] = "FO: RWY TURNOFF LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_rwyto_onoff(0)
		end
	},
	[12] = {["lefttext"] = "FO: ENGINE START SWITCHES -- AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_eng_starter_mode(0,1)
		end
	},
	[13] = {["lefttext"] = "FO: TRAFFIC -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			if get("laminar/B738/EFIS/tfc_show") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/tfc_press")
			end
		end
	},
	[14] = {["lefttext"] = "FO: AUTOBRAKE -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_abrk_mode(0)
		end
	},
	[15] = {["lefttext"] = "FO: TRANSPONDER -- STBY", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_xpdr_mode(1)
		end
	},
	[16] = {["lefttext"] = "CLEANUP FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "CLEANUP FINISHED"
		end
	}
}

ZC_SHUTDOWN_PROC = {
	[0] = {["lefttext"] = "SHUTDOWN PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"CABIN CREW DISARM SLIDES")
		end
	},
	[1] = {["lefttext"] = "CAPT: TAXI LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_taxi_mode(0)
		end
	},
	[2] = {["lefttext"] = "FO: READY FOR SHUTDOWN", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"READY FOR SHUTDOWN")
		end
	},
	[3] = {["lefttext"] = "CAPT: SHUTDOWN ENGINES!", ["timerincr"] = 997,
		["actions"] = function ()
			zc_acf_fuel_lever_set(0,0)
		end
	},
	[4] = {["lefttext"] = "FO: SEATBELT SIGNS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_seatbelt_onoff(0)
		end
	},
	[5] = {["lefttext"] = "FO: BEACON -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_beacon_onoff(0)
		end
	},
	[6] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(5,0)
		end
	}, 
	[7] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(1,1)
		end
	}, 
	[8] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(2,0)
		end
	}, 
	[9] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(3,0)
		end
	}, 
	[10] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_pumps_onoff(4,0)
		end
	}, 
	[11] = {["lefttext"] = "FO: CONFIGURE FUEL PUMPS", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_fuel_xfeed_mode(0)
		end
	}, 
	[12] = {["lefttext"] = "FO: WING & ENGINE ANTIICE -- OFF", ["timerincr"] = 2,
		["actions"] = function ()
			zc_acf_wing_aice_onoff(0)
			zc_acf_eng_aice_onoff(0,0)
		end
	}, 
	[13] = {["lefttext"] = "FO: ELECTRICAL HYDRAULIC PUMPS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_hyd_pumps_onoff(1,0)
			zc_acf_hyd_pumps_onoff(2,0)
		end
	}, 
	[14] = {["lefttext"] = "FO: ISOLATION VALVE -- OPEN", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_crossbleed_isol_mode(2)
		end
	},
	[15] = {["lefttext"] = "FO: APU BLEED -- ON", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_apu_bleed_onoff(1)
		end
	},
	[16] = {["lefttext"] = "FO: FLIGHT DIRECTORS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_fds_set(0,0)
		end
	},
	[17] = {["lefttext"] = "FO: RESET MCP", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_mcp_alt_set(get_zc_config("apalt"))
			zc_acf_mcp_hdg_set(get_zc_config("aphdg"))
			zc_acf_mcp_spd_set(get_zc_config("apspd"))
		end
	},
	[18] = {["lefttext"] = "FO: RESET TRANSPONDER", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_xpdr_code_set(2000)
		end
	},
	[19] = {["lefttext"] = "DOORS", ["timerincr"] = 1,
		["actions"] = function ()
			if ZC_BRIEF_DEP["depgatestand"] > 1 then
				zc_acf_airstair_onoff(1)
			end
			zc_acf_external_doors(3,1)
			zc_acf_external_doors(2,1)
			zc_acf_external_doors(1,1)
		end
	},
	[20] = {["lefttext"] = "FO: RESET ELAPSED TIME", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_et_timer_reset(0)
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		end
	},
	[21] = {["lefttext"] = "SHUTDOWN FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SHUTDOWN FINISHED"
			speakNoText(0,"SHUTDOWN CHECKLIST")
		end
	}
}

-- SHUTDOWN
-- Fuel pumps. . . . . . . . . . . . . . . 			Off
-- Probe heat. . . . . . . . . . . . . . . 			Auto/Off
-- Hydraulic panel . . . . . . . . . . . . 			Set
-- Flaps . . . . . . . . . . . . . . . . . 			Up
-- Parking brake . . . . . . . . . . . . .			___
-- Engine start levers . . . . . . . . . .			CUTOFF
-- Weather radar . . . . . . . . . . . . . 			Off

ZC_SHUTDOWN_CHECKLIST = {
	[0] = {["lefttext"] = "SHUTDOWN CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SHUTDOWN CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(10)
			end
		end
	},
	[1] = {["lefttext"] = "FUEL PUMPS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FUEL PUMPS")
		end
	},
	[2] = {["lefttext"] = "FUEL PUMPS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "PROBE HEAT -- OFF/AUTO", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PROBE HEAT")
		end
	},
	[4] = {["lefttext"] = "PROBE HEAT -- OFF/AUTO", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF OR AUTOMATIC")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "HYDRAULIC PANEL -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"HYDRAULIC PANEL")
		end
	},
	[6] = {["lefttext"] = "HYDRAULIC PANEL -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SET")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "FLAPS -- UP", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"FLAPS")
		end
	},
	[8] = {["lefttext"] = "FLAPS -- UP", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"UP")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[9] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PARKING BRAKE")
		end
	},
	[10] = {["lefttext"] = "PARKING BRAKE -- SET", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"SET")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[11] = {["lefttext"] = "ENGINE START LEVERS -- CUTOFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"ENGINE START LEVERS")
		end
	},
	[12] = {["lefttext"] = "ENGINE START LEVERS -- CUTOFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"CUTOFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[13] = {["lefttext"] = "WEATHER RADAR -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"WEATHER RADAR")
		end
	},
	[14] = {["lefttext"] = "WEATHER RADAR -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[15] = {["lefttext"] = "SHUTDOWN CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SHUTDOWN CHECKLIST COMPLETED")	
		end
	},
	[16] = {["lefttext"] = "SHUTDOWN CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SHUTDOWN CHECKLIST COMPLETED"
		end
	}
}

ZC_SECURING_AIRCRAFT_PROC = {
	[0] = {["lefttext"] = "SECURING AIRCRAFT PROCEDURE", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SECURE THE AIRCRAFT PLEASE")
		end
	},
	[1] = {["lefttext"] = "CAPT: CAB/UTIL & IFE GALLEY POWER -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/ife_pass_seat_pos",0)
			set("laminar/B738/toggle_switch/cab_util_pos",0)
		end
	},
	[2] = {["lefttext"] = "CAPT: TRIM AIR SWITCH -- OFF", ["timerincr"] = 2,
		["actions"] = function ()
			set("laminar/B738/air/trim_air_pos",0)
		end
	},
	[3] = {["lefttext"] = "FO: IRS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_irs_mode(0,0)
		end
	},
	[4] = {["lefttext"] = "FO: EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_emer_lights_mode(0)
		end
	},
	[5] = {["lefttext"] = "FO: WINDOW HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_window_heat_onoff(0,0)
		end
	},
	[6] = {["lefttext"] = "FO: PACKS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_packs_set(0,0)
		end
	}, 
	[7] = {["lefttext"] = "CAPT: APU -- OFF", ["timerincr"] = 15,
		["actions"] = function ()
			zc_acf_apu_bleed_onoff(0)
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
		end
	}, 
	[8] = {["lefttext"] = "CAPT: BATTERY -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			command_once("sim/electrical/APU_off")
			command_once("sim/electrical/GPU_off")
			zc_acf_batteries_onoff(0)
		end
	}, 
	[9] = {["lefttext"] = "CAPT: POSITION LIGHT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			zc_acf_light_nav_onoff(0)
		end
	}, 
	[10] = {["lefttext"] = "SECURING FINISHED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SECURING FINISHED"
			speakNoText(0,"SECURE THE AIRCRAFT CHECKLIST")
		end
	}
}

-- SECURE
-- IRSs . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off
-- Emergency exit lights . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- Window heat . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off
-- Packs . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off

ZC_SECURE_CHECKLIST = {
	[0] = {["lefttext"] = "SECURE CHECKLIST", ["timerincr"] = 3,
		["actions"] = function ()
			speakNoText(0,"SECURE CHECKLIST")
			if get_zc_config("easy") then
				setchecklist(11)
			end
		end
	},
	[1] = {["lefttext"] = "IRSs -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"I R S")
		end
	},
	[2] = {["lefttext"] = "IRSs -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[3] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"EMERGENCY EXIT LIGHTS")
		end
	},
	[4] = {["lefttext"] = "EMERGENCY EXIT LIGHTS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[5] = {["lefttext"] = "WINDOW HEAT -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"WINDOW HEAT")
		end
	},
	[6] = {["lefttext"] = "WINDOW HEAT -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},
	[7] = {["lefttext"] = "PACKS -- OFF", ["timerincr"] = 1,
		["actions"] = function ()
			speakNoText(0,"PACKS")
		end
	},
	[8] = {["lefttext"] = "PACKS -- OFF", ["timerincr"] = 997,
		["actions"] = function ()
			if get_zc_config("easy") then
				speakNoText(0,"OFF")
				command_once("bgood/xchecklist/check_item")
			end
		end
	},	
	[9] = {["lefttext"] = "SECURE CHECKLIST COMPLETED", ["timerincr"] = 2,
		["actions"] = function ()
			speakNoText(0,"SECURE CHECKLIST COMPLETED")	
		end
	},
	[10] = {["lefttext"] = "SECURE CHECKLIST COMPLETED", ["timerincr"] = -1,
		["actions"] = function ()
			gLeftText = "SECURE CHECKLIST COMPLETED"
		end
	}
}

-- Background procedures
ZC_BACKGROUND_PROCS = {
	-- hold down APU start switch for 5 seconds
	["APUSTART"] = {["status"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			if (get("sim/cockpit2/clock_timer/hobbs_time_seconds") % 7 == 0) then
				command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				ZC_BACKGROUND_PROCS["APUSTART"].status = 0
			end
		end
	},
	-- Switches generators to APU when the blue APU light comes on
	["APUBUSON"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/electrical/apu_bus_enable") == 1.0 then
				zc_acf_apu_on_bus(0,1)
				zc_acf_apu_bleed_onoff(1)
				ZC_BACKGROUND_PROCS["APUBUSON"].status = 0
			end
		end
	},
	-- During startup wait for N2 to reach 25 and turn on fuel
	["FUEL1IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 25.0 then
				zc_acf_fuel_lever_set(1,1)
				ZC_BACKGROUND_PROCS["FUEL1IDLE"].status = 0
			end
		end
	},
	["STARTERCUT1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/starter1_pos") == 1 then
				speakNoText(0,"Starter cutout")
				ZC_BACKGROUND_PROCS["STARTERCUT1"].status = 0
			end
		end
	},
	["N1ROTATION1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_1") > 0.5 then
				speakNoText(0,"N 1 rotation")
				ZC_BACKGROUND_PROCS["N1ROTATION1"].status = 0
			end
		end
	},
	["N1INCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_1") > 9 then
				speakNoText(0,"N 1 increase")
				ZC_BACKGROUND_PROCS["N1INCREASE1"].status = 0
			end
		end
	},
	["EGTINCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng1_egt") > 200 then
				speakNoText(0,"e g t steadily increasing")
				ZC_BACKGROUND_PROCS["EGTINCREASE1"].status = 0
			end
		end
	},
	["N2INCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 30 then
				speakNoText(0,"N 2 increase")
				ZC_BACKGROUND_PROCS["N2INCREASE1"].status = 0
			end
		end
	},
	["N2ROTATION1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 5 then
				speakNoText(0,"N 2 rotation")
				ZC_BACKGROUND_PROCS["N2ROTATION1"].status = 0
			end
		end
	},
	["OILPRESSURE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng1_oil_press") > 3 then
				speakNoText(0,"oil pressure")
				ZC_BACKGROUND_PROCS["OILPRESSURE1"].status = 0
			end
		end
	},
	["FUEL2IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 25.0 then
				zc_acf_fuel_lever_set(2,1)
				ZC_BACKGROUND_PROCS["FUEL2IDLE"].status = 0
			end
		end
	},
	["N1ROTATION2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_2") > 0.5 then
				speakNoText(0,"N 1 rotation")
				ZC_BACKGROUND_PROCS["N1ROTATION2"].status = 0
			end
		end
	},
	["N1INCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_2") > 9 then
				speakNoText(0,"N 1 increase")
				ZC_BACKGROUND_PROCS["N1INCREASE2"].status = 0
			end
		end
	},
	["N2INCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 30 then
				speakNoText(0,"N 2 increase")
				ZC_BACKGROUND_PROCS["N2INCREASE2"].status = 0
			end
		end
	},
	["EGTINCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng2_egt") > 200 then
				speakNoText(0,"e g t steadily increasing")
				ZC_BACKGROUND_PROCS["EGTINCREASE2"].status = 0
			end
		end
	},
	["N2ROTATION2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 5 then
				speakNoText(0,"N 2 rotation")
				ZC_BACKGROUND_PROCS["N2ROTATION2"].status = 0
			end
		end
	},
	["OILPRESSURE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng2_oil_press") > 3 then
				speakNoText(0,"oil pressure")
				ZC_BACKGROUND_PROCS["OILPRESSURE2"].status = 0
			end
		end
	},
	["STARTERCUT2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/starter2_pos") == 1 then
				speakNoText(0,"Starter cutout")
				ZC_BACKGROUND_PROCS["STARTERCUT2"].status = 0
			end
		end
	},	-- during takeoff run call out 80 kts
	["80KTS"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > 80.0 then
				speakNoText(0,"80 knots")
				ZC_BACKGROUND_PROCS["80KTS"].status = 0
			end
		end
	},
	-- during takeoff run call V speeds
	["V1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > zc_acf_getV1() then
				speakNoText(0,"V one")
				ZC_BACKGROUND_PROCS["V1"].status = 0
			end
		end
	},
	["ROTATE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > zc_acf_getVr() then
				speakNoText(0,"rotate")
				ZC_BACKGROUND_PROCS["ROTATE"].status = 0
			end
		end
	},
	-- On reaching Transition altitude switch to STD
	["TRANSALT"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > get("laminar/B738/FMS/fmc_trans_alt") then
				speakNoText(0,"Transition altitude")
				command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
				command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
				ZC_BACKGROUND_PROCS["TRANSALT"].status = 0
			end
		end
	},
	-- On reaching transition level during descend switch away from STD
	["TRANSLVL"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > get("laminar/B738/FMS/fmc_trans_lvl") then
				speakNoText(0,"Transition level")
				command_once("laminar/B738/EFIS_control/capt/push_button/std_press") 
				command_once("laminar/B738/EFIS_control/fo/push_button/std_press") 
				ZC_BACKGROUND_PROCS["TRANSLVL"].status = 0
			end
		end
	},
	-- during climb reach 10.000 ft
	["TENTHOUSANDUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000.0 then
				speakNoText(0,"ten thousand")
				zc_acf_light_landing_mode(1,0)
				ZC_BACKGROUND_PROCS["TENTHOUSANDUP"].status = 0
			end
		end
	},
	-- during climb reach 10.000 ft
	["TENTHOUSANDDN"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") <= 10000.0 then
				speakNoText(0,"ten thousand")
				zc_acf_light_landing_mode(1,1)
				ZC_BACKGROUND_PROCS["TENTHOUSANDDN"].status = 0
			end
		end
	},
	-- easy mode call for gear up at 200ft AGL
	["GEARUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 50 then
				speakNoText(0,"POSITIV RATE    GEAR UP")
				command_once("laminar/B738/push_button/gear_up")
				ZC_BACKGROUND_PROCS["GEARUP"].status = 0
			end
		end
	},
	-- Flapsup schedule
	["FLAPSUPSCHED"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 50 then
				if get("laminar/B738/autopilot/airspeed") > 140.0 and 
					zc_get_flap_position() == 15 then
					speakNoText(0,"SPEED CHECK   FLAPS 10")
					zc_acf_flap_set(10)
				end
				if get("laminar/B738/autopilot/airspeed") > 160.0 and 
					zc_get_flap_position() == 10 then
					speakNoText(0,"SPEED CHECK   FLAPS 5")
					zc_acf_flap_set(5)
				end
				if get("laminar/B738/autopilot/airspeed") > 170.0 and 
					zc_get_flap_position() == 5 then
					speakNoText(0,"SPEED CHECK   FLAPS 1")
					zc_acf_flap_set(1)
				end
				if get("laminar/B738/autopilot/airspeed") > 180.0 and 
					zc_get_flap_position() == 1 then
					speakNoText(0,"SPEED CHECK   FLAPS UP")
					zc_acf_flap_set(0)
					ZC_BACKGROUND_PROCS["FLAPSUPSCHED"].status = 0
				end
			end
		end
	},
	
	-- Open Briefing Windows & not aircraft specific functions
	["OPENINFOWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_flightinfo_window()
			ZC_BACKGROUND_PROCS["OPENINFOWINDOW"].status = 0
		end
	},
	["OPENDEPWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_depbrf_window()
			ZC_BACKGROUND_PROCS["OPENDEPWINDOW"].status = 0
		end
	},
	["OPENAPPWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			zc_init_appbrf_window()
			ZC_BACKGROUND_PROCS["OPENAPPWINDOW"].status = 0
		end
	},
	-- start of preflight events at +25 minutes with powerup
	["PREFLIGHT25"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 25*6) then
				gPreflightText="Powering up"
				lProcIndex = 4
				lProcStep = 0
				lProcTimer = 0 
				zc_get_procedure()
				lActivityTimer = 0
				lProcStatus = 1
				ZC_BACKGROUND_PROCS["PREFLIGHT25"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT24"].status = 1
			end
		end
	},
	-- ANNOUNCE WALKAROUND
	["PREFLIGHT24"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 24*6) then
				gPreflightText="Walk around"
				speakNoText(0,"I am going for the walk around")
				ZC_BACKGROUND_PROCS["PREFLIGHT24"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT23"].status = 1
			end
		end
	},
	-- START PREFLIGHT PROCEDURE
	["PREFLIGHT23"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 23*6) then
				gPreflightText="Pre-flight flow"
				lProcIndex = 5
				lProcStep = 0
				lProcTimer = 0 
				zc_get_procedure()
				lActivityTimer = 0
				lProcStatus = 1
				ZC_BACKGROUND_PROCS["PREFLIGHT23"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT21"].status = 1
			end
		end
	},
	["PREFLIGHT21"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 21*6) then
				gPreflightText = ""
				speakNoText(0,"I am back from the walk around")
				ZC_BACKGROUND_PROCS["PREFLIGHT21"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT20"].status = 1
			end
		end
	},
	["PREFLIGHT20"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 20*6) then
				gPreflightText = "PAX Boarding"
-- set boarding				
				ZC_BACKGROUND_PROCS["PREFLIGHT20"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT18"].status = 1
			end
		end
	},
	["PREFLIGHT18"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 18*6) then
				gPreflightText = "Preflight Checklist"
				lProcIndex = 6
				speakNoText(0,"Ready for the pre flight checklist?")
				ZC_BACKGROUND_PROCS["PREFLIGHT18"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT9"].status = 1
			end
		end
	},
	["PREFLIGHT9"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 9*6) then
				gPreflightText = "Departure Briefing"
				lProcIndex = 7
				speakNoText(0,"Ready for the departure briefing?")
				ZC_BACKGROUND_PROCS["PREFLIGHT9"].status = 0
				ZC_BACKGROUND_PROCS["PREFLIGHT2"].status = 1
			end
		end
	},
	["PREFLIGHT2"] = {["status"] = 0,
		["actions"] = function ()
			if (gPreflightCounter < 2*6) then
				gPreflightText = "Before Start Items"
				speakNoText(0,"Ready for the before start items?")
				lProcIndex = 8
				ZC_BACKGROUND_PROCS["PREFLIGHT2"].status = 0
			end
		end
	}
}

-- defines the available procedures/checklists and in which sequence they appear in the menu
lNoProcs = 28
function zc_get_procedure()

	incnt=1
	if lProcIndex == incnt then
		lActiveProc = ZC_COLD_AND_DARK
		lNameActiveProc = incnt.." COLD & DARK - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_TURN_AROUND_STATE
		lNameActiveProc = incnt.." TURN AROUND STATE - OPTIONAL"
		lChecklistMode = 0
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PREFLIGHT_START
		lNameActiveProc = incnt.." START PREFLIGHT EVENTS - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_POWER_UP_PROC
		lNameActiveProc = incnt.." POWER UP PROCEDURE"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PRE_FLIGHT_PROC
		lNameActiveProc = incnt.." PREFLIGHT PROCEDURE"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PREFLIGHT_CHECKLIST
		lNameActiveProc = incnt.." PREFLIGHT CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_DEPARTURE_BRIEFING
		lNameActiveProc = incnt.." DEPARTURE BRIEFING - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_START_PROC
		lNameActiveProc = incnt.." BEFORE START PROCEDURE"
		lChecklistMode = 0
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_START_CHECKLIST
		lNameActiveProc = incnt.." BEFORE START CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_PREPARE_PUSH
		lNameActiveProc = incnt.." PUSHBACK - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_STARTENGINE_PROC
		lNameActiveProc = incnt.." START ENGINES"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_FLIGHT_CONTROLS_CHECK
		lNameActiveProc = incnt.." FLIGHT CONTROLS CHECK"
		lChecklistMode = 1
	end	
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAXI_PROC
		lNameActiveProc = incnt.." BEFORE TAXI PROCEDURE"
		lChecklistMode = 0
	end	
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAXI_CHECKLIST
		lNameActiveProc = incnt.." BEFORE TAXI CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAKEOFF_CHECKLIST
		lNameActiveProc = incnt.." BEFORE TAKEOFF CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_BEFORE_TAKEOFF_PROC
		lNameActiveProc = incnt.." BEFORE TAKEOFF PROCEDURE"
		lChecklistMode = 0
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_CLIMB_PROC
		lNameActiveProc = incnt.." TAKEOFF AND CLIMB PROCEDURE"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_AFTER_TAKEOFF_CHECKLIST
		lNameActiveProc = incnt.." AFTER TAKEOFF PROCEDURE & CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_APPROACH_BRIEFING
		lNameActiveProc = incnt.." APPROACH BRIEFING - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_DESCENT_CHECKLIST
		lNameActiveProc = incnt.." DESCENT CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_APPROACH_CHECKLIST
		lNameActiveProc = incnt.." APPROACH CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_LANDING_PROC
		lNameActiveProc = incnt.." LANDING PROCEDURE"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_LANDING_CHECKLIST
		lNameActiveProc = incnt.." LANDING CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_FINAL_PROC
		lNameActiveProc = incnt.." ON FINAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_AFTER_LANDING_PROC
		lNameActiveProc = incnt.." AFTER LANDING - CLEANUP"
		lChecklistMode = 0
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SHUTDOWN_PROC
		lNameActiveProc = incnt.." SHUTDOWN PROCEDURE"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SHUTDOWN_CHECKLIST
		lNameActiveProc = incnt.." SHUTDOWN CHECKLIST"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SECURING_AIRCRAFT_PROC
		lNameActiveProc = incnt.." SECURING AIRCRAFT PROCEDURE - OPTIONAL"
		lChecklistMode = 1
	end
	incnt=incnt+1
	if lProcIndex == incnt then
		lActiveProc = ZC_SECURE_CHECKLIST
		lNameActiveProc = incnt.." SECURE CHECKLIST - OPTIONAL"
		lChecklistMode = 1
	end
	lNoProcs=incnt
end

-- aircraft specific status functions 

-- V1 - FMC must have been programmed
function zc_acf_getV1()
	return get("laminar/B738/FMS/v1")
end

-- VR - FMC must have been programmed
function zc_acf_getVr()
	return get("laminar/B738/FMS/vr")
end

-- V2 - FMC must have been programmed
function zc_acf_getV2()
	return get("laminar/B738/FMS/v2")
end

-- get takeoff trim value from FMC
function zc_acf_getTrim()
	return get("laminar/B738/FMS/trim_calc")
end

-- get takeoff flap from FMC
function zc_acf_getToFlap()
	return get("laminar/B738/FMS/takeoff_flaps")
end

-- get landing flap from FMC
function zc_acf_getLdgFlap()
	return get("laminar/B738/FMS/approach_flaps")
end

-- get Vref from FMC
function zc_acf_getVref()
	return get("laminar/B738/FMS/vref")
end

-- get Vapp
function zc_acf_getVapp()
	return zc_acf_getVref() + get("laminar/B738/FMS/approach_wind_corr")
end

-- get parking stand
function zc_get_parking_stand()
	return get("laminar/B738/autogate_nearest_name")
end

-- return total fuel loaded
function zc_get_total_fuel()
	if get_zc_config("kglbs") then
		return get("laminar/B738/fuel/total_tank_kgs")
	else
		return get("laminar/B738/fuel/total_tank_lbs")
	end
end

-- return gross weight
function zc_get_gross_weight()
	if get_zc_config("kglbs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.20462262
	end	
end

-- return zero fuel weight
function zc_get_zfw()
	return zc_get_gross_weight()-zc_get_total_fuel()
end

-- get runway course from FMC
function zc_acf_getrwycrs()
	return get("laminar/B738/fms/ref_runway_crs")
end

-- get approach runway ILS
function zc_acf_getilsrwy()
	return get("laminar/B738/pfd/ils_runway")
end

-- get destination icao
function zc_get_dest_icao()
	return get("laminar/B738/fms/dest_icao")
end

-- get destination runway altitude
function zc_get_dest_runway_alt()
	return get("laminar/B738/fms/dest_runway_alt")
end

-- get destination runway course
function zc_get_dest_runway_crs()
	return get("laminar/B738/fms/dest_runway_crs")
end

-- get destination runway length
function zc_get_dest_runway_len()
	return get("laminar/B738/fms/dest_runway_len")
end

-- get flaps position
-- 0=UP,0.125=1,0.250=2,0.375=5,0.5=10,0.625=15,0.750=25,0.875=30,1=40
function zc_get_flap_position()
	if get("laminar/B738/flt_ctrls/flap_lever") == 1 then
		return 40
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.875 then
		return 30
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.75 then
		return 25
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.625 then
		return 15
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.5 then
		return 10
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.375 then
		return 5
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.25 then
		return 2
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0.125 then
		return 1
	end
	if get("laminar/B738/flt_ctrls/flap_lever") == 0 then
		return 0
	end
	return 0
end

-- function_get_abrk_setting()

--------------------------------- aircraft specific action functions
----------------- Electric system
-- Start APU flows full

-- Bring APU completely online
function zc_acf_apu_activate()
	if get("sim/cockpit/engine/APU_N1") < 0.1 then
		zc_acf_apu_start()
		ZC_BACKGROUND_PROCS["APUBUSON"].status = 1
	end
end

function zc_acf_apu_start()
	zc_acf_apu_stop()
	ZC_BACKGROUND_PROCS["APUSTART"].status = 1
end

-- stop APU
function zc_acf_apu_stop()
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")	
end

-- APU on bus; bus 0=all, 1=left 2=right
function zc_acf_apu_on_bus(bus, onoff)
	if bus == 0 or bus == 1 then
		if onoff == 1 then
			command_once("laminar/B738/toggle_switch/apu_gen1_dn")
		else
			command_once("laminar/B738/toggle_switch/apu_gen1_up")
		end
	end
	if bus == 0 or bus == 2 then
		if onoff == 1 then
			command_once("laminar/B738/toggle_switch/apu_gen2_dn")
		else
			command_once("laminar/B738/toggle_switch/apu_gen2_up")
		end
	end
end

-- start the GPU full automatic and set gen/air
function zc_acf_gpu_start()
	if get("laminar/B738/gpu_available") == 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
		command_once("sim/electrical/GPU_on")
	end
end

-- stop APU 
function zc_acf_gpu_stop()
	if get("laminar/B738/gpu_available") > 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
		command_once("laminar/B738/annunciator/ground_power_avail")
	end
end

-- GENerators 0=ALL,1=GEN1,2=GEN2; 0=OFF,1=ON Bus
function zc_acf_gen_on_bus(gen,mode)
	if gen == 0 or gen == 1 then
		if mode == 1 then
			command_once("laminar/B738/toggle_switch/gen1_dn")
		else
			command_once("laminar/B738/toggle_switch/gen1_up")
		end
	end
	if gen == 0 or gen == 2 then
		if mode == 1 then
			command_once("laminar/B738/toggle_switch/gen2_dn")
		else
			command_once("laminar/B738/toggle_switch/gen2_up")
		end
	end
end

-- Battery 0=OFF 1=ON	
function zc_acf_batteries_onoff(mode)
	if mode == 1 then
		if get("laminar/B738/button_switch/cover_position",2) == 1 then
			command_once("laminar/B738/button_switch_cover02")
		end
		command_once("sim/electrical/battery_1_on")
		command_once("laminar/B738/switch/battery_dn")
	else
		if get("laminar/B738/button_switch/cover_position",2) == 0 then
			command_once("laminar/B738/button_switch_cover02")
		end
		command_once("sim/electrical/battery_1_off")
		command_once("laminar/B738/push_button/batt_full_off")
	end
end

--- Fuel system

-- Fuel pumps 0=all, 1=lft1, 2=lft2, 3=rgt1, 4=rgt2, 5=ctr1, 6=ctr2
function zc_acf_fuel_pumps_onoff(pump,mode)
	if (pump == 0 or pump == 1) then
		set("laminar/B738/fuel/fuel_tank_pos_lft1",mode)
	end
	if (pump == 0 or pump == 2) then
		set("laminar/B738/fuel/fuel_tank_pos_lft2",mode)
	end
	if (pump == 0 or pump == 3) then
		set("laminar/B738/fuel/fuel_tank_pos_rgt1",mode)
	end
	if (pump == 0 or pump == 4) then
		set("laminar/B738/fuel/fuel_tank_pos_rgt2",mode)
	end
	if (pump == 0 or pump == 5) then
		set("laminar/B738/fuel/fuel_tank_pos_ctr1",mode)
	end
	if (pump == 0 or pump == 6) then
		set("laminar/B738/fuel/fuel_tank_pos_ctr2",mode)
	end
end

-- fuel cross feed 0=OFF 1=ON
function zc_acf_fuel_xfeed_mode(mode)
	if mode == 0 then
		command_once("laminar/B738/toggle_switch/crossfeed_valve_off")
	else
		command_once("laminar/B738/toggle_switch/crossfeed_valve_on")
	end
end

--- Hydraulic system

-- Set hydraulic pumps, pump 0=ALL, 1=ENG1, 2=ENG2, 3=ELEC1, 4=ELEC2
function zc_acf_hyd_pumps_onoff(pump,mode)
	if pump == 0 or pump == 1 then
		set("laminar/B738/toggle_switch/hydro_pumps1_pos",mode)
	end
	if pump == 0 or pump == 2 then
		set("laminar/B738/toggle_switch/hydro_pumps2_pos",mode)
	end
	if pump == 0 or pump == 3 then
		set("laminar/B738/toggle_switch/electric_hydro_pumps1_pos",mode)
	end
	if pump == 0 or pump == 4 then
		set("laminar/B738/toggle_switch/electric_hydro_pumps2_pos",mode)
	end
end

--- Engines
-- Set fuel levers 1,2 0=CUTOFF,1=IDLE
function zc_acf_fuel_lever_set(lever,mode)
	if lever == 0 or lever == 1 then
		set("laminar/B738/engine/mixture_ratio1",mode)
	end
	if lever == 0 or lever == 2 then
		set("laminar/B738/engine/mixture_ratio2",mode)
	end
end

-- Engine starter knobs 0=ALL,1,2 0=START GRD,1=AUTO,2=CONT,3=FLT
function zc_acf_eng_starter_mode(starter,mode)
	if starter == 0 or starter == 1 then
		if get("laminar/B738/engine/starter1_pos") > mode then
			command_once("laminar/B738/knob/eng1_start_left")
		end
		if get("laminar/B738/engine/starter1_pos") < mode then
			command_once("laminar/B738/knob/eng1_start_right")
		end
	end
	if starter == 0 or starter == 2 then
		if get("laminar/B738/engine/starter2_pos") > mode then
			command_once("laminar/B738/knob/eng2_start_left")
		end
		if get("laminar/B738/engine/starter2_pos") < mode then
			command_once("laminar/B738/knob/eng2_start_right")
		end
	end
end

--- Pressurisation & AIR

-- Packs 0=all,1,2 mode 0=OFF, 1=AUTO, 2=OPEN
function zc_acf_packs_set(pack, mode)
	if pack == 0 or pack == 1 then
		set("laminar/B738/air/l_pack_pos",mode)
	end
	if pack == 0 or pack == 2 then
		set("laminar/B738/air/r_pack_pos",mode)
	end
end

-- Bleeds bleed 0=ALL,1=LEFT,2=RIGHT  0=OFF, 1=ON
function zc_acf_eng_bleeds_onoff(bleed,mode)
	if bleed == 0 or bleed == 1 then
		set("laminar/B738/toggle_switch/bleed_air_1_pos",mode)
	end
	if bleed == 0 or bleed == 2 then
		set("laminar/B738/toggle_switch/bleed_air_2_pos",mode)
	end
end

-- cross bleed isolation 0=CLOSE,1=AUTO,2=OPEN		
function zc_acf_crossbleed_isol_mode(mode)
	set("laminar/B738/air/isolation_valve_pos",mode)
end

-- APU Bleed air 0=OFF 1=ON
function zc_acf_apu_bleed_onoff(mode)
	set("laminar/B738/toggle_switch/bleed_air_apu_pos",mode)
end

-- Temperature control area 0=ALL,1=CONT,2=FWD CAB,3=AFT CAB level 0..1
function zc_acf_temp_control(area,level)
	if area == 0 or area == 1 then
		set("laminar/B738/air/cont_cab_temp/rheostat",level)
	end
	if area == 0 or area == 2 then
		set("laminar/B738/air/fwd_cab_temp/rheostat",0.5)
	end
	if area == 0 or area == 3 then
		set("laminar/B738/air/aft_cab_temp/rheostat",0.5)
	end
end

-- Recirc Fans 0=ALL,1=Left,2=Right mode 0=OFF,1=ON
function zc_acf_recirc_fans_onoff(fan,mode)
	if fan == 0 or fan == 1 then
		set("laminar/B738/air/l_recirc_fan_pos",mode)
	end
	if fan == 0 or fan == 2 then
		set("laminar/B738/air/r_recirc_fan_pos",mode)
	end
end

-- Landing altitude in ft 
function zc_acf_set_landing_altitude(altitude)
	set("laminar/B738/pressurization/knobs/landing_alt",altitude)
end

-- set flight altitude (B737)
function zc_acf_set_flight_altitude(altitude)
	set("sim/cockpit/pressure/max_allowable_altitude",altitude)
end

--- A/ICE
-- Window heat Heater 0=All, 1-4, 0=OFF 1=ON
function zc_acf_window_heat_onoff(heater,mode)
	if heater == 0 or heater == 1 then
		set("laminar/B738/ice/window_heat_l_side_pos",mode)
	end
	if heater == 0 or heater == 2 then
		set("laminar/B738/ice/window_heat_l_fwd_pos",mode)
	end
	if heater == 0 or heater == 3 then
		set("laminar/B738/ice/window_heat_r_fwd_pos",mode)
	end
	if heater == 0 or heater == 4 then
		set("laminar/B738/ice/window_heat_r_side_pos",mode)
	end
end

-- wing anti ice 0=OFF 1=ON
function zc_acf_wing_aice_onoff(mode)
	set("laminar/B738/ice/wing_heat_pos",mode)
end

-- engine anti-ice 0=OFF 1=ON
function zc_acf_eng_aice_onoff(eng,mode)
	if eng == 0 or eng == 1 then
		set("laminar/B738/ice/eng1_heat_pos",mode)
	end
	if eng == 0 or eng == 2 then
		set("laminar/B738/ice/eng2_heat_pos",mode)
	end
end


-- probe heat heater 0=ALL 1=left 2=right; mode 0=OFF, 1=ON
function zc_acf_probe_heat_onoff(heater,mode)
	if heater == 0 or heater == 1 then
		set("laminar/B738/toggle_switch/capt_probes_pos",mode)
	end
	if heater == 0 or heater == 2 then
		set("laminar/B738/toggle_switch/fo_probes_pos",mode)
	end
end

--- Flight controls

-- position=0,1,2,5,10,15,25,30,40
function zc_acf_flap_set(position)
	if position == 0 then
		command_once("laminar/B738/push_button/flaps_up")
	end
	if position == 1 then
		command_once("laminar/B738/push_button/flaps_1")
	end
	if position == 2 then
		command_once("laminar/B738/push_button/flaps_2")
	end
	if position == 5 then
		command_once("laminar/B738/push_button/flaps_5")
	end
	if position == 10 then
		command_once("laminar/B738/push_button/flaps_10")
	end
	if position == 15 then
		command_once("laminar/B738/push_button/flaps_15")
	end
	if position == 25 then
		command_once("laminar/B738/push_button/flaps_25")
	end
	if position == 30 then
		command_once("laminar/B738/push_button/flaps_30")
	end
	if position == 40 then
		command_once("laminar/B738/push_button/flaps_40")
	end
end

-- Speedbrake 0=UP, 1=ARMED, 2=FULL
function zc_acf_speed_break_set(position)
	if position == 0 then
		set("laminar/B738/flt_ctrls/speedbrake_lever",0)
		set("laminar/B738/flt_ctrls/speedbrake_lever_stop",0)
	end
	if position == 1 then
		set("laminar/B738/flt_ctrls/speedbrake_lever",0.0889)
		set("laminar/B738/flt_ctrls/speedbrake_lever_stop",1)
	end
	if position == 2 then
		set("laminar/B738/flt_ctrls/speedbrake_lever",1)
		set("laminar/B738/flt_ctrls/speedbrake_lever_stop",1)
	end
end

--- Parking brake 0=OFF 1=ON
function zc_acf_parking_break_onoff(mode)
	set("sim/cockpit2/controls/parking_brake_ratio",mode)
end

-- Auto Brake -1=RTO, 0=OFF, 1=1, 2=2, 3=3 4=MAX
function zc_acf_abrk_mode(mode)
	while get("laminar/B738/autobrake/autobrake_pos") > mode+1 do
		command_once("laminar/B738/knob/autobrake_dn")
	end
	while get("laminar/B738/autobrake/autobrake_pos") < mode+1 do
		command_once("laminar/B738/knob/autobrake_up")
	end
end

-- Set elevator trim to value
function zc_acf_elev_trim_set(value)
	set("sim/flightmodel2/controls/elevator_trim",(8.2 - value) * -0.117)
end

-- set aileron trim
function zc_acf_aileron_trim_set(value)
	set("sim/cockpit2/controls/aileron_trim",value)
end

-- set rudder trim
function zc_acf_rudder_trim_set(value)
	set("sim/cockpit2/controls/rudder_trim",value)
end

-- Set Yaw Damper
function zc_acf_yaw_damper_onoff(mode)
	set("laminar/B738/toggle_switch/yaw_dumper_pos",mode)
end

--- LIGHTS

-- dome lights 0=off, 1=on
function zc_acf_cockpit_light_mode(mode)
	set("laminar/B738/toggle_switch/cockpit_dome_pos",mode)
end

-- Strobe lighs 0=off 1=on with poslight 2=position light only
function zc_acf_light_strobe_mode(mode)
	if mode == 0 then
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_down")
	end
	if mode == 1 then
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_up")
	end
	if mode == 2 then
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
	end
end

-- poslights combined with strobes 0=off, 1=on only, 2=+strobes
function zc_acf_light_nav_onoff(mode)
	if mode == 0 then
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_up")
	end
	if mode == 1 then
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
	end
	if mode == 2 then
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_down")
		command_once("laminar/B738/toggle_switch/position_light_up")
		command_once("laminar/B738/toggle_switch/position_light_up")
	end
end

-- Beacon lights 0=off 1=on
function zc_acf_light_beacon_onoff(mode)
	if mode == 1 then
		command_once("sim/lights/beacon_lights_on")
	else
		command_once("sim/lights/beacon_lights_off")
	end
end

-- Wing Light 0=OFF 1=ON
function zc_acf_light_wing_onoff(mode)
	if mode == 1 then
		command_once("laminar/B738/switch/wing_light_on")
	else
		command_once("laminar/B738/switch/wing_light_off")
	end
end

-- Logo lights 0=OFF 1=ON
function zc_acf_light_logo_onoff(mode)
	if mode == 1 then
		command_once("laminar/B738/switch/logo_light_on")
	else
		command_once("laminar/B738/switch/logo_light_off")
	end
end

-- RWY turnoff lights both 0=OFF 1=ON
function zc_acf_light_rwyto_onoff(mode)
	if mode == 0 then 
		command_once("laminar/B738/switch/rwy_light_left_off")
		command_once("laminar/B738/switch/rwy_light_right_off")
	else
		command_once("laminar/B738/switch/rwy_light_left_on")
		command_once("laminar/B738/switch/rwy_light_right_on")
	end
end

-- taxi lights 0=OFF 1=LOW 2=HIGH
function zc_acf_light_taxi_mode(mode)
	if mode == 0 then
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
	end
	if mode == 1 then
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
	end
	if mode == 2 then
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
		command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
	end
	
end

-- Landing Lights 0=ALL,1=FIXED,2=RET, 3=RETLEFT, 4=RETRIGHT, 5=LEFT, 6=RIGHT
-- Mode 0=OFF, 1=ON, 2=EXTEND RETs
function zc_acf_light_landing_mode(light,mode)
	if light == 0 or light == 1 or light == 5 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_left_off")
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_left_on")
		end
	end
	if light == 0 or light == 1 or light == 6 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_right_off")
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_right_on")
		end
	end
	if light == 0 or light == 2 or light == 3 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_ret_left_up")
			command_once("laminar/B738/switch/land_lights_ret_left_up")
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_ret_left_dn")
			command_once("laminar/B738/switch/land_lights_ret_left_dn")
		end
		if mode == 2 then
			command_once("laminar/B738/switch/land_lights_ret_left_up")
			command_once("laminar/B738/switch/land_lights_ret_left_up")
			command_once("laminar/B738/switch/land_lights_ret_left_dn")
		end
	end
	if light == 0 or light == 2 or light == 4 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_ret_right_up")
			command_once("laminar/B738/switch/land_lights_ret_right_up")
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_ret_right_dn")
			command_once("laminar/B738/switch/land_lights_ret_right_dn")
		end
		if mode == 2 then
			command_once("laminar/B738/switch/land_lights_ret_right_up")
			command_once("laminar/B738/switch/land_lights_ret_right_up")
			command_once("laminar/B738/switch/land_lights_ret_right_dn")
		end
	end
end

function zc_acf_panel_brightness(light,value)
	set("laminar/B738/electric/panel_brightness",light,value)
end

-- emergency lights 0=OFF,1=ARMED,2=ON
function zc_acf_emer_lights_mode(mode)
	if mode == 0 then 
		command_once("laminar/B738/push_button/emer_exit_full_off")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		if get("laminar/B738/button_switch/cover_position",9) == 0 then
			command_once("laminar/B738/button_switch_cover09")
		end
	end
	if mode == 1 then 
		command_once("laminar/B738/push_button/emer_exit_full_off")
		if get("laminar/B738/toggle_switch/emer_exit_lights") == 0 then
			command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		end
		if get("laminar/B738/toggle_switch/emer_exit_lights") == 2 then
			command_once("laminar/B738/toggle_switch/emer_exit_lights_up")
		end
		if get("laminar/B738/button_switch/cover_position", 9) == 1 then
			command_once("laminar/B738/button_switch_cover09")
		end
	end
	if mode == 2 then 
		if get("laminar/B738/button_switch/cover_position",9) == 0 then
			command_once("laminar/B738/button_switch_cover09")
		end
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
	end
end

-- Seatbelts 0=OFF 1=ON 2=AUTO
function zc_acf_seatbelt_onoff(mode)
	if mode == 0 then 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	end
	if mode == 1 then 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
	end
	if mode == 2 then 
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")
		command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	end
end

-- No Smoking 0=OFF 1=ON 2=AMRED
function zc_acf_no_smoking_onoff(mode)
	if mode == 0 then 
		command_once("laminar/B738/toggle_switch/no_smoking_up")
		command_once("laminar/B738/toggle_switch/no_smoking_up")
	end
	if mode == 1 then 
		command_once("laminar/B738/toggle_switch/no_smoking_dn")
		command_once("laminar/B738/toggle_switch/no_smoking_dn")
	end
	if mode == 2 then 
		command_once("laminar/B738/toggle_switch/no_smoking_dn")
		command_once("laminar/B738/toggle_switch/no_smoking_dn")
		command_once("laminar/B738/toggle_switch/no_smoking_up")
	end
end

--- Navigation & A/P & A/T & Radios
-- FD 0=BOTH, 1=LEFT, 2=RIGHT
function zc_acf_mcp_fds_set(fd, mode)
	if mode == 0 then
		if fd == 0 or fd == 1 then
			if get("laminar/B738/autopilot/flight_director_pos") == 1 then
				command_once("laminar/B738/autopilot/flight_director_toggle")
			end
		end
		if fd == 0 or fd == 2 then
			if get("laminar/B738/autopilot/flight_director_fo_pos") == 1 then
				command_once("laminar/B738/autopilot/flight_director_fo_toggle")
			end
		end
	else
		if fd == 0 or fd == 1 then
			if get("laminar/B738/autopilot/flight_director_pos") == 0 then
				command_once("laminar/B738/autopilot/flight_director_toggle")
			end
		end
		if fd == 0 or fd == 2 then
			if get("laminar/B738/autopilot/flight_director_fo_pos") == 0 then
				command_once("laminar/B738/autopilot/flight_director_fo_toggle")
			end
		end
	end
end
			

-- MCP set speed
function zc_acf_mcp_spd_set(value)
	set("laminar/B738/autopilot/mcp_speed_dial_kts_mach",value)
end

-- MCP set altitude
function zc_acf_mcp_alt_set(value)
	set("laminar/B738/autopilot/mcp_alt_dial",value)
end

-- MCP set heading
function zc_acf_mcp_hdg_set(value)
	set("laminar/B738/autopilot/mcp_hdg_dial",value)
end

-- MCP course 0=all 1=CRS1, 2=CRS2, value
function zc_acf_mcp_crs_set(nav,value)
	if nav == 0 or nav == 1 then
		set("laminar/B738/autopilot/course_pilot",value)
	end
	if nav == 0 or nav == 2 then
		set("laminar/B738/autopilot/course_copilot",value)
	end
end

-- MCP vertical Speed value
function zc_acf_mcp_vs_set(value)
	set("sim/cockpit2/autopilot/vvi_dial_fpm",value)
end

-- Set CMD A or B ap 0=ALL 1=CMDA 2=CMDB, mode 0=OFF 1=ON
function zc_acf_mcp_ap_set(ap, mode)
	if ap == 0 or ap == 1 then
		if get("laminar/B738/autopilot/cmd_a_status") ~= mode then
			command_once("laminar/B738/autopilot/cmd_a_press")
		end
	end
	if ap == 0 or ap == 2 then
		if get("laminar/B738/autopilot/cmd_b_status") ~= mode then
			command_once("laminar/B738/autopilot/cmd_b_press")
		end
	end
end

-- Set IRS switches 0=OFF, 1=ALIGN, 2=NAV, 3=ATT
function zc_acf_irs_mode(unit,mode)
	if (unit == 0 or unit == 1) then
		set("laminar/B738/toggle_switch/irs_left",mode)
	end
	if (unit == 0 or unit == 2) then
		set("laminar/B738/toggle_switch/irs_right",mode)
	end
end

-- Transponder mode 0=TEST, 1=STBY, 2=ALT OFF, 3=ALT ON, 4=TA, 5=TARA
function zc_acf_xpdr_mode(mode)
	while get("laminar/B738/knob/transponder_pos") > 1 do
		command_once("laminar/B738/knob/transponder_mode_dn")
	end
	while get("laminar/B738/knob/transponder_pos") < mode do
		command_once("laminar/B738/knob/transponder_mode_up")	
	end
end

-- set transponder code
function zc_acf_xpdr_code_set(code)
	set("sim/cockpit/radios/transponder_code",code)
end

-- Reset elapsed timer 0=ALL, 1=CAPT, 2=FO
function zc_acf_et_timer_reset(timer)
	if timer == 0 or timer == 1 then
		command_once("laminar/B738/push_button/et_reset_capt")
	end
	if timer == 0 or timer == 2 then
		command_once("laminar/B738/push_button/et_reset_fo")
	end
end

-- Start/Stop ET timer
function zc_acf_et_timer_startstop(timer)
	if timer == 0 or timer == 1 then
		command_once("laminar/B738/push_button/chrono_capt_et_mode")
	end
	if timer == 0 or timer == 2 then
		command_once("laminar/B738/push_button/chrono_fo_et_mode")
	end
end

-- function zc_acf_ap_dis_bar_onoff(onoff)
-- function zc_acf_mcp_alt_intv()
-- function zc_acf_mcp_vsm_onoff(onoff)
-- function zc_acf_mcp_althld_onoff(onoff)
-- function zc_acf_mcp_lnav_onoff(onoff)
-- function zc_acf_mcp_vnav_onoff(onoff)
-- function zc_acf_mcp_vorloc_onoff(onoff)
-- function zc_acf_mcp_hdgsel_onoff(onoff)
-- function zc_acf_mcp_lvlchg_onoff(onoff)
-- function zc_acf_mcp_spd_intv()
-- function zc_acf_mcp_turnrate_set(value)
-- function zc_acf_mcp_at_onoff(onoff)
-- function zc_acf_mcp_n1_onoff(onoff)
-- function zc_acf_mcp_spd_onoff(onoff)
-- function zc_acf_mcp_ias_mach(mode)
-- function zc_acf_mcp_ls_onoff(onoff)
-- function zc_acf_mcp_100_1000(mode)
-- function zc_acf_mcp_start_et()
-- function zc_acf_mcp_stop_et()

--- Tests
-- function zc_acf_apu_firetest()
-- function zc_acf_eng_firetests()
-- function zc_acf_stall_warnings()
-- function zc_acf_overspeed()


--- Doors and external items 0=UP, 1=DOWN, 2=OFF
function zc_acf_gears(mode)
	if mode == 0 then
		command_once("sim/flight_controls/landing_gear_up")
	end
	if mode == 1 then
		command_once("sim/flight_controls/landing_gear_down")
	end
	if mode == 2 then
		command_once("sim/flight_controls/landing_gear_off")
	end
end

-- door 0=ALL, 1=main, 2=cargof, 3=cargor 
function zc_acf_external_doors(door,openclose)
	if door == 0 or door == 1 then
		if (openclose == 1) then
			if get("737u/doors/L1") ~= 1 then
				command_once("laminar/B738/door/fwd_L_toggle")
			end
		else
			if get("737u/doors/L1") == 1 then
				command_once("laminar/B738/door/fwd_L_toggle")
			end
		end
	end
	if door == 0 or door == 2 then
		if (openclose == 1) then
			if get("737u/doors/Fwd_Cargo") == 0 then
				command_once("laminar/B738/door/fwd_cargo_toggle")
			end			
		else
			if get("737u/doors/Fwd_Cargo") == 1 then
				command_once("laminar/B738/door/fwd_cargo_toggle")
			end			
		end
	end
	if door == 0 or door == 3 then
		if (openclose == 1) then
			if get("737u/doors/aft_Cargo") == 0 then
				command_once("laminar/B738/door/aft_cargo_toggle")
			end
		else
			if get("737u/doors/aft_Cargo") == 1 then
				command_once("laminar/B738/door/aft_cargo_toggle")
			end
		end
	end

end

-- Airstair left forward
function zc_acf_airstair_onoff(onoff)
	if onoff == 1 then
		if get("laminar/B738/airstairs_hide") == 1  then
			command_once("laminar/B738/airstairs_toggle")
		end
	else
		if get("laminar/B738/airstairs_hide") == 0  then
			command_once("laminar/B738/airstairs_toggle")
		end
	end
end	

-- function zc_acf_cockpit_door(openclose)
-- Wipers 0=ALL;1=left,2=right; 0=park,1=int,2=low,3=high
function zc_acf_wipers_mode(wiper,mode)
	if wiper == 0 or wiper == 1 then
		command_once("laminar/B738/knob/left_wiper_dn")
		command_once("laminar/B738/knob/left_wiper_dn")
		command_once("laminar/B738/knob/left_wiper_dn")
		if mode == 1 then
			command_once("laminar/B738/knob/left_wiper_up")
		end
		if mode > 1 then
			command_once("laminar/B738/knob/left_wiper_up")
		end
		if mode > 2 then
			command_once("laminar/B738/knob/left_wiper_up")
		end
	end
	if wiper == 0 or wiper == 1 then
		command_once("laminar/B738/knob/right_wiper_dn")
		command_once("laminar/B738/knob/right_wiper_dn")
		command_once("laminar/B738/knob/right_wiper_dn")
		if mode == 1 then
			command_once("laminar/B738/knob/right_wiper_up")
		end
		if mode > 1 then
			command_once("laminar/B738/knob/right_wiper_up")
		end
		if mode > 2 then
			command_once("laminar/B738/knob/right_wiper_up")
		end
	end
end

--- EFIS
-- function zc_acf_upper_efis_mode(mode)
-- function zc_acf_lower_efis_mode(mode)
-- function zc_acf_fpvfpa_onoff(onoff)
-- function zc_acf_ft_meter(mode)
-- function zc_acf_baro_std_set()
-- function zc_acf_baro_set(value)
-- function zc_acf_baro_sync()
-- function zc_acf_baro_in_mb(mode)

-- EFIS: Set mode of minimums side 0=ALL,1=CAPT,2=FO mode 0=RADIO,1=BARO
function zc_acf_set_dhda_mode(side,mode)
	if side == 0 or side == 1 then
		if mode == 0 then
			command_once("laminar/B738/EFIS_control/cpt/minimums_dn")
		else
			command_once("laminar/B738/EFIS_control/cpt/minimums_up")
		end
	end
	if side == 0 or side == 2 then
		if mode == 0 then
			command_once("laminar/B738/EFIS_control/fo/minimums_dn")
		else
			command_once("laminar/B738/EFIS_control/fo/minimums_up")
		end
	end
end

-- set minimums side 0=ALL,1=LEFT,2=RGT altitude in feet
function zc_acf_set_minimum(side, altitude)
	if side == 0 or side == 1 then
		while get("laminar/B738/pfd/dh_pilot") < altitude do 
			command_once("laminar/B738/pfd/dh_pilot_up")
		end
		while get("laminar/B738/pfd/dh_pilot") > altitude do 
			command_once("laminar/B738/pfd/dh_pilot_dn")
		end
	end
	if side == 0 or side == 2 then
		while get("laminar/B738/pfd/dh_copilot") < altitude do 
			command_once("laminar/B738/pfd/dh_copilot_up")
		end
		while get("laminar/B738/pfd/dh_copilot") > altitude do 
			command_once("laminar/B738/pfd/dh_copilot_dn")
		end
	end
end

-- function zc_acf_pfd_navselect1(mode)
-- function zc_acf_pfd_navselect2(mode)
-- function zc_acf_nd_map_mode(mode)
-- function zc_acf_nd_map_rng(mode)
-- function zc_acf_nd_wxr_onoff(onoff)
-- function zc_acf_nd_sta_cstr_onoff(onoff)
-- function zc_acf_nd_wpt_onoff(onoff)
-- function zc_acf_nd_arpt_onoff(onoff)
-- function zc_acf_nd_vord_onoff(onoff)
-- function zc_acf_nd_ndb_onoff(onoff)
-- function zc_acf_nd_data_onoff(onoff)
-- function zc_acf_nd_pos_onoff(onoff)
-- function zc_acf_nd_terr_onoff(onoff)
-- function zc_acf_nd_trfc_onoff(onoff)
-- function zc_acf_nd_ctr_onoff(onoff)

-- set checklist
function setchecklist(number)
		set("sim/operation/failures/rel_fadec_7",number)
		command_once("bgood/xchecklist/toggle_checklist")
end

-- clear checklist
function clearchecklist()
	varlandalt = get("sim/operation/failures/rel_fadec_7")
	if (varlandalt > 1) then
	   set("sim/operation/failures/rel_fadec_7",0)
	end
end

-- Aircraft specific Joystick functions
function xsp_flaps_dec()
	command_once("sim/flight_controls/flaps_up")
end
function xsp_flaps_inc()
	command_once("sim/flight_controls/flaps_down")
end
function xsp_toggle_fd_both()
	command_once("laminar/B738/autopilot/flight_director_fo_toggle")
	command_once("laminar/B738/autopilot/flight_director_toggle")
end
function xsp_toggle_std_both()
	command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
	command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
end
function xsp_toggle_autopilot()
	command_once("laminar/B738/autopilot/cmd_a_press")
end
function xsp_toggle_alt()
	command_once("laminar/B738/autopilot/alt_hld_press")
end
function xsp_toggle_hdg()
	command_once("laminar/B738/autopilot/hdg_sel_press")
end
function xsp_toggle_nav()
	command_once("laminar/B738/autopilot/vorloc_press")
end
function xsp_toggle_app()
	command_once("laminar/B738/autopilot/app_press")
end
function xsp_toggle_vs()
	command_once("laminar/B738/autopilot/vs_press")
end
function xsp_toggle_ias()
	command_once("laminar/B738/autopilot/speed_press")
end

function xsp_toggle_rev_course()
	if xsp_bravo_layer == 0 then
		command_once("sim/autopilot/back_course")
	end
	if xsp_bravo_layer == 1 and xsp_bravo_mode == 1 then
		command_once("laminar/B738/rtp_L/freq_txfr/sel_switch")
	end
	if xsp_bravo_layer == 1 and xsp_bravo_mode == 2 then
		command_once("laminar/B738/rtp_R/freq_txfr/sel_switch")
	end
end

function xsp_bravo_knob_up()
	if xsp_bravo_layer == 0 then
		if xsp_bravo_mode == 1 then
			command_once("laminar/B738/autopilot/altitude_up")
		end
		if xsp_bravo_mode == 2 then
			command_once("sim/autopilot/vertical_speed_up")
		end
		if xsp_bravo_mode == 3 then
			command_once("laminar/B738/autopilot/heading_up")
		end
		if xsp_bravo_mode == 4 then
			command_once("laminar/B738/autopilot/course_pilot_up")
		end
		if xsp_bravo_mode == 5 then
			command_once("sim/autopilot/airspeed_up")
		end
	end
	if xsp_bravo_layer == 1 then
		if xsp_bravo_mode == 1 then
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com1_coarse_up")
			else
				command_once("sim/radios/stby_com1_fine_up_833")
			end
		end
		if xsp_bravo_mode == 2 then
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com2_coarse_up")
			else
				command_once("sim/radios/stby_com2_fine_up_833")
			end
		end
	end
end
function xsp_bravo_knob_dn()
	if xsp_bravo_layer == 0 then
		if xsp_bravo_mode == 1 then
			command_once("laminar/B738/autopilot/altitude_dn")
		end
		if xsp_bravo_mode == 2 then
			command_once("sim/autopilot/vertical_speed_down")
		end
		if xsp_bravo_mode == 3 then
			command_once("laminar/B738/autopilot/heading_dn")
		end
		if xsp_bravo_mode == 4 then
			command_once("laminar/B738/autopilot/course_pilot_dn")
		end
		if xsp_bravo_mode == 5 then
			command_once("sim/autopilot/airspeed_down")
		end
	end
	if xsp_bravo_layer == 1 then
		if xsp_bravo_mode == 1 then
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com1_coarse_down")
			else
				command_once("sim/radios/stby_com1_fine_down_833")
			end
		end
	end
	if xsp_bravo_layer == 1 then
		if xsp_bravo_mode == 2 then
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com2_coarse_down")
			else
				command_once("sim/radios/stby_com2_fine_down_833")
			end
		end
	end
end

-- ZIBO special regular save situation #8
function zc_zibo_save()
	zibo_save_counter = zibo_save_counter - 1
	if zibo_save_counter <= 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu8")
		command_once("laminar/B738/tab/menu8")
		command_once("laminar/B738/tab/right")
		command_once("laminar/B738/tab/menu8")
		command_once("laminar/B738/tab/home")
		zibo_save_counter = 30
	end
end

xsp_parking_brake = create_dataref_table("kp/xsp/parking_brake", "Int")
xsp_master_caution = create_dataref_table("kp/xsp/master_caution", "Int")
xsp_mcp_hdg = create_dataref_table("kp/xsp/mcp_hdg", "Int")
xsp_mcp_nav = create_dataref_table("kp/xsp/mcp_nav", "Int")
xsp_mcp_app = create_dataref_table("kp/xsp/mcp_app", "Int")
xsp_mcp_ias = create_dataref_table("kp/xsp/mcp_ias", "Int")
xsp_mcp_vsp = create_dataref_table("kp/xsp/mcp_vsp", "Int")
xsp_mcp_alt = create_dataref_table("kp/xsp/mcp_alt", "Int")
xsp_mcp_ap1 = create_dataref_table("kp/xsp/mcp_ap1", "Int")
xsp_doors = create_dataref_table("kp/xsp/doors", "Int")
xsp_anc_hyd = create_dataref_table("kp/xsp/anc_hyd", "Int")
xsp_anc_fuel = create_dataref_table("kp/xsp/anc_fuel", "Int")
xsp_anc_oil = create_dataref_table("kp/xsp/anc_oil", "Int")
xsp_anc_aice = create_dataref_table("kp/xsp/anc_aice", "Int")
xsp_anc_starter = create_dataref_table("kp/xsp/anc_starter", "Int")

function xsp_set_lightvars()
	xsp_parking_brake[0] = get("sim/cockpit2/controls/parking_brake_ratio")

	-- Master Caution light
	xsp_master_caution[0] = get("laminar/B738/annunciator/master_caution_light")

	xsp_mcp_hdg[0] = get("laminar/B738/autopilot/hdg_sel_status")

	if get("laminar/B738/autopilot/vorloc_status") == 0 and get("laminar/B738/autopilot/lnav_status") == 0 then
		xsp_mcp_nav[0] = 0
	else
		xsp_mcp_nav[0] = 1
	end

	xsp_mcp_app[0] = get("laminar/B738/autopilot/app_status")

	if get("laminar/B738/autopilot/n1_status") == 0 and get("laminar/B738/autopilot/speed_mode") == 0 then
		xsp_mcp_ias[0] = 0
	else
		xsp_mcp_ias[0] = 1
	end

	if get("laminar/B738/autopilot/lvl_chg_status") == 0 and get("laminar/B738/autopilot/vs_status") == 0 and get("laminar/B738/autopilot/vnav_status1") == 0 then
		xsp_mcp_vsp[0] = 0
	else
		xsp_mcp_vsp[0] = 1
	end

	xsp_mcp_alt[0] = get("laminar/B738/autopilot/alt_hld_status")

	xsp_mcp_ap1[0] = get("laminar/B738/autopilot/cmd_a_status")

	if get("737u/doors/aft1") == 0 and get("737u/doors/aft1") == 0 and get("737u/doors/aft_Cargo") == 0 and get(		"737u/doors/Fwd_Cargo")  == 0 and get("737u/doors/L1") == 0 and get("737u/doors/L2") == 0 and get(			"737u/doors/R1") == 0 and get("737u/doors/R2") then
		xsp_doors[0] = 0
	else
		xsp_doors[0] = 1
	end

	if get("laminar/B738/annunciator/hyd_el_press_a") == 0 and get("laminar/B738/annunciator/hyd_el_press_b") == 0 then
		xsp_anc_hyd[0] = 0
	else
		xsp_anc_hyd[0] = 1
	end
	
	if get("laminar/B738/annunciator/low_fuel_press_c1") == 0 and get("laminar/B738/annunciator/low_fuel_press_c2") == 0 and get("laminar/B738/annunciator/low_fuel_press_l1") == 0 and get("laminar/B738/annunciator/low_fuel_press_l2") == 0 and get("laminar/B738/annunciator/low_fuel_press_r1") == 0 and get("laminar/B738/annunciator/low_fuel_press_r2") == 0 then
		xsp_anc_fuel[0] = 0
	else
		xsp_anc_fuel[0] = 1
	end

	if get("laminar/B738/engine/eicas_oil_press1") == 0 and get("laminar/B738/engine/eicas_oil_press2") == 0 then
		xsp_anc_oil[0] = 0
	else
		xsp_anc_oil[0] = 1
	end

	if get("laminar/B738/air/engine1/starter_valve") == 0 and get("laminar/B738/air/engine2/starter_valve") == 0 then
		xsp_anc_starter[0] = 0
	else
		xsp_anc_starter[0] = 1
	end

	if get("laminar/B738/annunciator/wing_ice_on_L") == 0 and get("laminar/B738/annunciator/wing_ice_on_R") == 0 and get("laminar/B738/annunciator/cowl_ice_on_0") == 0 and get("laminar/B738/annunciator/cowl_ice_on_1") == 0  then
		xsp_anc_aice[0] = 0
	else
		xsp_anc_aice[0] = 1
	end

end

-- aircraft specific joystick/key commands (e.g. for Alpha Yoke)
create_command("kp/xsp/beacon_lights_switch_on",	"Beacon Lights On",		"zc_acf_light_beacon_onoff(1)", "", "")
create_command("kp/xsp/beacon_lights_switch_off",	"Beacon Lights Off",	"zc_acf_light_beacon_onoff(0)", "", "")
create_command("kp/xsp/dome_lights_switch_on",		"Dome Lights On",		"zc_acf_cockpit_light_mode(1)", "", "")
create_command("kp/xsp/dome_lights_switch_off",		"Dome Lights Off",		"zc_acf_cockpit_light_mode(0)", "", "")
create_command("kp/xsp/nav_lights_switch_on",		"Position Lights On",	"zc_acf_light_nav_onoff(1)", "", "")
create_command("kp/xsp/nav_lights_switch_off",		"Position Lights Off",	"zc_acf_light_nav_onoff(0)", "", "")
create_command("kp/xsp/strobe_lights_switch_on",	"Strobe Lights On",		"zc_acf_light_strobe_mode(1)", "", "")
create_command("kp/xsp/strobe_lights_switch_off",	"Strobe Lights Off",	"zc_acf_light_strobe_mode(0)", "", "")
create_command("kp/xsp/taxi_lights_switch_on",		"Taxi Lights On",		"zc_acf_light_taxi_mode(1)", "", "")
create_command("kp/xsp/taxi_lights_switch_off",		"Taxi Lights Off",		"zc_acf_light_taxi_mode(0)", "", "")
create_command("kp/xsp/landing_lights_switch_on",	"Landing Lights On",	"zc_acf_light_landing_mode(0,1)", "", "")
create_command("kp/xsp/landing_lights_switch_off",	"Landing Lights Off",	"zc_acf_light_landing_mode(0,0)", "", "")
create_command("kp/xsp/wing_lights_switch_on",		"Wing Lights On",		"zc_acf_light_wing_onoff(1)", "", "")
create_command("kp/xsp/wing_lights_switch_off",		"Wing Lights Off",		"zc_acf_light_wing_onoff(0)", "", "")
create_command("kp/xsp/logo_lights_switch_on",		"Logo Lights On",		"zc_acf_light_logo_onoff(1)", "", "")
create_command("kp/xsp/logo_lights_switch_off",		"Logo Lights Off",		"zc_acf_light_logo_onoff(0)", "", "")
-- General commands
create_command("kp/xsp/parking_brake_on",			"Parking Brake On",		"zc_acf_parking_break_onoff(1)", "", "")
create_command("kp/xsp/parking_brake_off",			"Parking Brake Off",	"zc_acf_parking_break_onoff(0)", "", "")
create_command("kp/xsp/gears_up",					"Gear Up",				"zc_acf_gears(0)", "", "")
create_command("kp/xsp/gears_down",					"Gear Down",			"zc_acf_gears(1)", "", "")
create_command("kp/xsp/flaps_up",					"Flaps 1 Up",			"xsp_flaps_dec()", "", "")
create_command("kp/xsp/flaps_down",					"Flaps 1 Down",			"xsp_flaps_inc()", "", "")
-- A/P and NAV related commands
create_command("kp/xsp/toggle_both_fd",				"Toggle Both FD",		"xsp_toggle_fd_both()", "", "")
create_command("kp/xsp/toggle_both_std",			"Toggle Both STD",		"xsp_toggle_std_both()", "", "")
create_command("kp/xsp/toggle_rev_appr",			"Toggle Reverse Appr",	"xsp_toggle_rev_course()", "", "")
create_command("kp/xsp/toggle_ap",					"Toggle A/P 1",			"xsp_toggle_autopilot()", "", "")
create_command("kp/xsp/toggle_alt",					"Toggle Altitude",		"xsp_toggle_alt()","","")
create_command("kp/xsp/toggle_hdg",					"Toggle Heading",		"xsp_toggle_hdg()","","")
create_command("kp/xsp/toggle_nav",					"Toggle Nav",			"xsp_toggle_nav()","","")
create_command("kp/xsp/toggle_app",					"Toggle Approach",		"xsp_toggle_app()","","")
create_command("kp/xsp/toggle_vs",					"Toggle vertical speed","xsp_toggle_vs()","","")
create_command("kp/xsp/toggle_ias",					"Toggle ias",			"xsp_toggle_ias()","","")

-- Bravo specific commands
create_command("kp/xsp/bravo_mode_alt",				"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")
create_command("kp/xsp/bravo_mode_vs",				"Bravo AP Mode VS",		"xsp_bravo_mode=2", "", "")
create_command("kp/xsp/bravo_mode_hdg",				"Bravo AP Mode HDG",	"xsp_bravo_mode=3", "", "")
create_command("kp/xsp/bravo_mode_crs",				"Bravo AP Mode CRS",	"xsp_bravo_mode=4", "", "")
create_command("kp/xsp/bravo_mode_ias",				"Bravo AP Mode IAS",	"xsp_bravo_mode=5", "", "")
create_command("kp/xsp/bravo_knob_up",				"Bravo AP Knob Up",		"xsp_bravo_knob_up()", "", "")
create_command("kp/xsp/bravo_knob_dn",				"Bravo AP Knob Down",	"xsp_bravo_knob_dn()", "", "")
create_command("kp/xsp/bravo_layer_com",			"Bravo Layer COM",		"xsp_bravo_layer=1", "", "")
create_command("kp/xsp/bravo_layer_ap",				"Bravo Layer A/P",		"xsp_bravo_layer=0", "", "")
create_command("kp/xsp/bravo_fine",					"Bravo Fine",			"xsp_fine_coarse = 1", "", "")
create_command("kp/xsp/bravo_coarse",				"Bravo Coarse",			"xsp_fine_coarse = 0", "", "")

do_sometimes("zc_zibo_save()")
do_often("xsp_set_lightvars()")
