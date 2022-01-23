--[[
	*** KPCREW for Zibo Mod 2.2
	Kosta Prokopiu, October 2021
--]]

-- =========== Aircraft specific details
B738 = Class_ACF:Create()
B738:setDEP_Flaps({"1","2","5","10","15","25","",""})
B738:setDEP_Flaps_val({1,2,5,10,15,25,25,25})
B738:setAPP_Flaps({"15","30","40","",""})
B738:setAPP_Flaps_val({15,30,40,40,40})
B738:setAutoBrake({"OFF","1","2","3","MAX"})
B738:setAutoBrake_val({1,2,3,4,5})
B738:setTakeoffThrust({"RATED","DE-RATED","ASSUMED TEMPERATURE","RATED AND ASSUMED","DE-RATED AND ASSUMED"})
B738:setTakeoffThrust_Val({0,1,2,3,4})
B738:setBleeds({"OFF","ON","UNDER PRESSURIZED"})
B738:setBleeds_val({0,1,2})
B738:setAIce({"NOT REQUIRED","ENGINE ONLY","ENGINE AND WING"})
B738:setAIce_val({0,1,2})
B738:setDepApMode({"LNAV/VNAV","HDG/FLCH"})
B738:setDepApMode_val({1,2})

set_kpcrew_config("acf_name","Boeing 737-800")
set_kpcrew_config("acf_icao","B738")

DEP_takeofthrust_list = B738:getTakeoffThrust()
DEP_aice_list = B738:getAIce()
DEP_bleeds_list = B738:getBleeds()

-- flaps handling
kc_flaps_position_aircraft = {[0] = 0,[0.125] = 1,[0.25] = 2,[0.375] = 5,[0.5] = 10,[0.625] = 15,[0.75] = 25,[0.875] = 30,[1] = 40}
kc_flaps_position_dataref = "laminar/B738/flt_ctrls/flap_lever"
kc_flaps_set_commands = {
[0] = "laminar/B738/push_button/flaps_0",
[1] = "laminar/B738/push_button/flaps_1",
[2] = "laminar/B738/push_button/flaps_2",
[5] = "laminar/B738/push_button/flaps_5",
[10] = "laminar/B738/push_button/flaps_10",
[15] = "laminar/B738/push_button/flaps_15",
[25] = "laminar/B738/push_button/flaps_25",
[30] = "laminar/B738/push_button/flaps_30",
[40] = "laminar/B738/push_button/flaps_40"}
kc_flaps_display = {[0]="UP",[1]="1",[2]="2",[5]="5",[10]="10",[15]="15",[25]="25",[30]="30",[40]="40"}

-- autobrake handling
kc_autobrake_setting_aircraft = {[0]=0,[1]=1,[2]=2,[3]=3,[4]=4,[5]=5}
kc_autobrake_position_dataref = "laminar/B738/autobrake/autobrake_pos"
kc_autobrake_set_commands = {
[0] = "laminar/B738/knob/autobrake_rto",
[1] = "laminar/B738/knob/autobrake_off",
[2] = "laminar/B738/knob/autobrake_1",
[3] = "laminar/B738/knob/autobrake_2",
[4] = "laminar/B738/knob/autobrake_3",
[5] = "laminar/B738/knob/autobrake_max"}
kc_autobrake_display = {[0]="RTO",[1]="OFF",[2]="1",[3]="2",[4]="3",[5]="MAX"}

-- transponder handling
kc_transponder_setting_aircraft = {[0]=0,[1]=1,[2]=2,[3]=3,[4]=4,[5]=5}
kc_transponder_position_dataref = "laminar/B738/knob/transponder_pos"
kc_transponder_set_commands = {
[0] = "laminar/B738/knob/transponder_test",
[1] = "laminar/B738/knob/transponder_stby",
[2] = "laminar/B738/knob/transponder_altoff",
[3] = "laminar/B738/knob/transponder_alton",
[4] = "laminar/B738/knob/transponder_ta",
[5] = "laminar/B738/knob/transponder_tara"}
kc_transponder_display = {[0]="TEST",[1]="STBY",[2]="ALT OFF",[3]="ALT ON",[4]="TA",[5]="TA RA"}

-- fuel datarefs
kc_total_fuel_kgs_dataref = "laminar/B738/fuel/total_tank_kgs"
kc_total_fuel_lbs_dataref = "laminar/B738/fuel/total_tank_lbs"

-- overwrite approach types if necessary - "---" for unsupported
APP_apptype_list = {"ILS CAT 1","ILS CAT 2 OR 3","VOR","NDB","RNAV","VISUAL","TOUCH AND GO","CIRCLING"}

zibo_save_counter = 30
xsp_bravo_mode = 1
xsp_bravo_layer = 0
xsp_fine_coarse = 1

-- =========== Procedure definitions

-- set aircraft into cold and dark mode
-- function KC_COLD_AND_DARK() end
KC_COLD_AND_DARK = { ["name"] = "SET AIRCRAFT TO COLD & DARK", ["mode"]="s", ["wnd_width"] = 350, ["wnd_height"] = 31*9,   
	[1] = {["activity"] = "OVERHEAD TOP", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_irs_mode(0,0)
			kc_acf_external_doors(0,0)
			kc_acf_light_cockpit_mode(0)
			-- increase shadow resolution to prevent ugly steps
			set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
		end
	},
	[2] = {["activity"] = "OVERHEAD COLUMN 1", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_yaw_damper_onoff(0)
			set("laminar/B738/toggle_switch/alt_flaps_ctrl",0)
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
			kc_acf_fuel_pumps_onoff(0,0)
			kc_acf_fuel_xfeed_mode(0)
		end
	},
	[3] = {["activity"] = "OVERHEAD COLUMN 2", ["wait"] = 3, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("sim/electrical/APU_off")
			command_once("sim/electrical/GPU_off")
			kc_acf_elec_battery_onoff(0)
			kc_acf_elec_cabin_power(0)
			kc_acf_elec_ife_power(0)
			kc_acf_external_doors(1,1)
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			kc_acf_elec_gpu_stop()
			kc_acf_elec_stby_power(0)
			kc_acf_wipers_mode(0,0)
			kc_acf_elec_gen_on_bus(0,0)
			if get_kpcrew_config("dep_stand") > 1 then
				kc_acf_airstair_onoff(1)
			end
		end
	},
	[4] = {["activity"] = "OVERHEAD COLUMN 3", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_panel(2,0)
			set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
			set("laminar/B738/toggle_switch/eq_cool_supply",0)
			kc_acf_light_emer_mode(0)
			kc_acf_seatbelt_onoff(0)
			kc_acf_no_smoking_onoff(0)
		end
	},
	[5] = {["activity"] = "OVERHEAD COLUMN 4", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_window_heat_onoff(0,0)
			kc_acf_aice_probe_heat_onoff(0,0)
			kc_acf_aice_wing_onoff(0)
			kc_acf_aice_eng_onoff(0,0)
			kc_acf_hyd_pumps_onoff(0,0)
		end
	},
	[6] = {["activity"] = "OVERHEAD COLUMN 5", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_temp_control(0,0.5)
			set("laminar/B738/air/trim_air_pos",1)
			kc_acf_air_recirc_fans_onoff(1,0)
			kc_acf_air_packs_set(0,0)
			kc_acf_air_xbleed_isol_mode(2)
			kc_acf_air_bleeds_onoff(0,0)
			kc_acf_air_apu_bleed_onoff(0)
			kc_acf_set_flight_altitude(0)
			kc_acf_set_landing_altitude(0)
			kc_acf_air_valve(0)
		end
	},
	[7] = {["activity"] = "LIGHTS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_taxi_mode(0)
			kc_acf_light_landing_mode(0,0)
			kc_acf_light_rwyto_mode(0)
			set_array("sim/cockpit2/switches/generic_lights_switch",0,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",1,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",2,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",3,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",4,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",5,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",6,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",7,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",8,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",9,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",10,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",11,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",12,0)
			set_array("sim/cockpit2/switches/generic_lights_switch",13,1)
			kc_acf_light_panel(0,0)
			kc_acf_light_panel(1,0)
			kc_acf_light_panel(2,0)
			kc_acf_light_panel(3,0)
			kc_acf_light_rwyto_mode(0)
			kc_acf_light_nav_mode(0)
			kc_acf_light_beacon_mode(0)
			kc_acf_light_logo_mode(0)
		end
	},
	[8] = {["activity"] = "OTHER", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_apu_stop()
			kc_acf_controls_flaps_set(0)
			kc_acf_speed_break_set(0)
			kc_acf_parking_break_mode(1)
			kc_acf_fuel_lever_set(0,0)
			kc_acf_chocks_mode(1)
			kc_acf_eng_starter_mode(0,1)
			kc_acf_xpdr_mode(1)
			kc_acf_abrk_mode(1)
			kc_acf_mcp_fds_set(0,0)
			kc_acf_elec_gpu_stop()
			set_kpcrew_config("flight_off_block",0)
			set_kpcrew_config("flight_on_block",0)
			set_kpcrew_config("flight_time_to",0)
			set_kpcrew_config("flight_time_ldg",0)
			kc_acf_et_timer_reset(0)
		end
	},
	[9] = {["activity"] = "AIRCRAFT COLD & DARK", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1,
		["answer"] = function () return "Aircraft is cold and dark" end
	}
}

-- Set aircraft in mode for turn around between flights
-- function KC_TURN_AROUND_STATE() end
KC_TURN_AROUND_STATE = { ["name"] = "SET TURN AROUND STATE", ["mode"]="s", ["wnd_width"] = 350, ["wnd_height"] = 31*16, 
	[1] = {["activity"] = "CONFIGURING AIRCRAFT FOR TURNAOUND", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
		end,
		["speak"] = function () return "setting up the aircraft" end
	},
	[2] = {["activity"] = "DOORS -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_external_doors(0,1)
			set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
			if get_kpcrew_config("dep_stand") > 1 then
				kc_acf_airstair_onoff(1)
			end
		end
	},
	[3] = {["activity"] = "OVERHEAD TOP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_irs_mode(0,0)
			kc_acf_light_cockpit_mode(1)
		end
	},
	[4] = {["activity"] = "BATTERY -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_battery_onoff(1)
		end
	},
	[5] = {["activity"] = "POWER -- ON", ["wait"] = 3, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("config_apuinit") == false then
				kc_acf_elec_gpu_start()
			else
				kc_acf_elec_apu_activate()
			end
		end,
		["display"] = function()
			if get_kpcrew_config("config_apuinit") == false then
				return "GROUND POWER -- ON"
			else
				return "APU -- ON"
			end
		end
	},
	[6] = {["activity"] = "STANDBY POWER -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_stby_power(1)
		end
	},
	[7] = {["activity"] = "OVERHEAD COLUMN 1", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_yaw_damper_onoff(0)
			set("laminar/B738/toggle_switch/alt_flaps_ctrl",0)
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
			kc_acf_fuel_pumps_onoff(0,0)
			kc_acf_fuel_xfeed_mode(0)
	end
	},
	[8] = {["activity"] = "OVERHEAD COLUMN 2", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_stby_power(1)
			kc_acf_elec_cabin_power(1)
			kc_acf_elec_ife_power(1)
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/dc_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			command_once("laminar/B738/knob/ac_power_dn")
			kc_acf_wipers_mode(0,0)
			kc_acf_elec_gen_on_bus(0,1)
		end
	},
	[9] = {["activity"] = "OVERHEAD COLUMN 3", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_panel(2,0)
			set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
			set("laminar/B738/toggle_switch/eq_cool_supply",0)
			kc_acf_light_emer_mode(1)
			kc_acf_seatbelt_onoff(1)
			kc_acf_no_smoking_onoff(1)
		end
	},
	[10] = {["activity"] = "OVERHEAD COLUMN 4", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_window_heat_onoff(0,0)
			kc_acf_aice_probe_heat_onoff(0,0)
			kc_acf_aice_wing_onoff(0)
			kc_acf_aice_eng_onoff(0,0)
			kc_acf_hyd_pumps_onoff(1,1)
			kc_acf_hyd_pumps_onoff(2,1)
			kc_acf_hyd_pumps_onoff(3,0)
			kc_acf_hyd_pumps_onoff(4,0)
		end
	},
	[11] = {["activity"] = "OVERHEAD COLUMN 5", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_temp_control(0,0.5)
			set("laminar/B738/air/trim_air_pos",1)
			kc_acf_air_recirc_fans_onoff(1,1)
			kc_acf_air_packs_set(1,0)
			kc_acf_air_packs_set(2,1)
			kc_acf_air_xbleed_isol_mode(1)
			kc_acf_air_bleeds_onoff(0,0)
			kc_acf_air_apu_bleed_onoff(0)
			kc_acf_set_flight_altitude(0)
			kc_acf_set_landing_altitude(0)
			kc_acf_air_valve(0)
		end
	},
	[12] = {["activity"] = "LIGHTS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_taxi_mode(0)
			kc_acf_light_landing_mode(0,0)
			kc_acf_light_rwyto_mode(0)
			if kc_get_daylight() == 0 then
				set_array("sim/cockpit2/switches/generic_lights_switch",0,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",1,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",2,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",3,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",4,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",5,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",6,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",7,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",8,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",9,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",10,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",11,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",12,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",13,1)
				kc_acf_light_panel(0,1)
				kc_acf_light_panel(1,1)
				kc_acf_light_panel(2,1)
				kc_acf_light_panel(3,1)
				kc_acf_light_logo_mode(1)
				kc_acf_light_wing_mode(1)
				kc_acf_light_wheel_mode(1)
			else
				set_array("sim/cockpit2/switches/generic_lights_switch",0,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",1,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",2,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",3,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",4,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",5,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",6,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",7,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",8,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",9,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",10,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",11,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",12,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",13,1)
				kc_acf_light_panel(0,0)
				kc_acf_light_panel(1,0)
				kc_acf_light_panel(2,0)
				kc_acf_light_panel(3,0)
				kc_acf_light_logo_mode(0)
				kc_acf_light_wing_mode(0)
				kc_acf_light_wheel_mode(0)
			end
			kc_acf_light_nav_mode(1)
			kc_acf_light_beacon_mode(0)
			kc_acf_light_logo_mode(0)
		end
	},
	[13] = {["activity"] = "OTHER", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_controls_flaps_set(0)
			kc_acf_speed_break_set(0)
			kc_acf_parking_break_mode(1)
			kc_acf_fuel_lever_set(0,0)
			kc_acf_chocks_mode(1)
			kc_acf_eng_starter_mode(0,1)
			kc_acf_xpdr_mode(1)
			kc_acf_abrk_mode(1)
			kc_acf_mcp_fds_set(0,0)
			kc_acf_xpdr_code_set(2000)
			kc_acf_external_doors(1,1)
			kc_acf_external_doors(2,1)
			kc_acf_external_doors(3,1)
		end
	},
	[14] = {["activity"] = "IRS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_irs_mode(0,2)
		end
	},
	[15] = {["activity"] = "MCP - INITIALIZE", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_spd_set(get_kpcrew_config("default_ap_spd"))
			kc_acf_mcp_hdg_set(get_kpcrew_config("default_ap_hdg"))
			kc_acf_mcp_alt_set(get_kpcrew_config("default_ap_alt"))
			kc_acf_lower_eicas_mode(3)
			set_kpcrew_config("flight_off_block",0)
			set_kpcrew_config("flight_on_block",0)
			set_kpcrew_config("flight_time_to",0)
			set_kpcrew_config("flight_time_ldg",0)
			kc_acf_et_timer_reset(0)
		end
	},
	[16] = {["activity"] = "AIRCRAFT SET FOR TURNAROUND", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1,
		["answer"] = function () return "Aircraft is set up for turn around" end
	}
}

-- power up the aircraft from initial or cold and dark
-- function KC_PREL_PREFLIGHT_PROC() end
KC_PREL_PREFLIGHT_PROC = { ["name"] = "PRELIMINARY PREFLIGHT PROCEDURE", ["mode"]="p", ["wnd_width"] = 350, ["wnd_height"] = 31*21,
	[1] = {["activity"] = "SETTING UP THE AIRCRAFT", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
		end,
		["speak"] = function () return " " end
	},
	[2] = {["activity"] = "XPDR TO 2000", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_xpdr_code_set(2000)
			set("sim/private/controls/shadow/cockpit_near_adjust",0.09)
		end
	},
	[3] = {["activity"] = "COCKPIT LIGHTS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if kc_get_daylight() == 0 then
				set_array("sim/cockpit2/switches/generic_lights_switch",0,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",1,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",2,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",3,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",4,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",5,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",6,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",7,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",8,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",9,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",10,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",11,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",12,1)
				set_array("sim/cockpit2/switches/generic_lights_switch",13,1)
				kc_acf_light_panel(0,1)
				kc_acf_light_panel(1,1)
				kc_acf_light_panel(2,1)
				kc_acf_light_panel(3,1)
				kc_acf_light_logo_mode(1)
			else
				set_array("sim/cockpit2/switches/generic_lights_switch",0,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",1,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",2,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",3,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",4,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",5,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",6,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",7,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",8,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",9,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",10,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",11,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",12,0)
				set_array("sim/cockpit2/switches/generic_lights_switch",13,1)
				kc_acf_light_panel(0,0)
				kc_acf_light_panel(1,0)
				kc_acf_light_panel(2,0)
				kc_acf_light_panel(3,0)
				kc_acf_light_logo_mode(0)
			end
			kc_acf_light_taxi_mode(0)
			kc_acf_light_landing_mode(0,0)
			kc_acf_light_rwyto_mode(0)
			kc_acf_light_nav_mode(1)
			kc_acf_light_beacon_mode(0)
			kc_acf_light_logo_mode(0)
		end
	},
	[4] = {["activity"] = "BATTERY -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_battery_onoff(1)
		end,
		["checks"] = function () return get("laminar/B738/electric/battery_pos") == 1 end
	},
	[5] = {["activity"] = "POWER -- ON", ["wait"] = 3, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("config_apuinit") == false then
				kc_acf_elec_gpu_start()
			else
				kc_acf_elec_apu_activate()
			end
		end,
		["display"] = function()
			if get_kpcrew_config("config_apuinit") == false then
				return "GROUND POWER -- ON"
			else
				return "APU -- ON"
			end
		end
	},
	[6] = {["activity"] = "STANDBY POWER -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_stby_power(1)
		end,
		["checks"] = function () return get("laminar/B738/electric/standby_bat_pos") == 1 end
	},
	[7] = {["activity"] = "FIRE TESTS -- RUN", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_firetests()
		end
	},
	[8] = {["activity"] = "WING & WHEEL WELL LIGHTS -- AS REQUIRED", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if kc_get_daylight() == 0 then
				kc_acf_light_wing_mode(1)
				kc_acf_light_wheel_mode(1)
			else
				kc_acf_light_wing_mode(0)
				kc_acf_light_wheel_mode(0)
			end
			kc_acf_light_emer_mode(1)
		end,
		["display"] = function()
			if kc_get_daylight() == 0 then
				return "WING & WHEEL WELL LIGHTS -- ON"
			else
				return "WING & WHEEL WELL LIGHTS -- OFF"
			end
		end,
		["checks"] = function () 
			Light_Status = dataref_table("sim/flightmodel2/lights/generic_lights_brightness_ratio")
			if kc_get_daylight() == 0 then
				return Light_Status[0] == 1 and Light_Status[5] == 1 
			else
				return Light_Status[0] == 0 and Light_Status[5] == 0 
			end
		end
	},
	[9] = {["activity"] = "FUEL PUMPS -- ALL OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_pumps_onoff(0,0)
		end
	},
	[10] = {["activity"] = "FUEL PUMP -- SET FOR APU", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("config_apuinit") then
				kc_acf_fuel_pumps_onoff(1,1)
			end
		end
	},
	[11] = {["activity"] = "CROSS FEED -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_xfeed_mode(0)
		end
	},
	[12] = {["activity"] = "ELEC HYD PUMPS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_hyd_pumps_onoff(1,1)
			kc_acf_hyd_pumps_onoff(2,1)
		end
	},
	[13] = {["activity"] = "POSITION LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_nav_mode(1)
		end
	},
	[14] = {["activity"] = "IRS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CAPT", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_irs_mode(0,0)
		end
	},
	[15] = {["activity"] = "MCP - INITIALIZE", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_spd_set(get_kpcrew_config("default_ap_spd"))
			kc_acf_mcp_hdg_set(get_kpcrew_config("default_ap_hdg"))
			kc_acf_mcp_alt_set(get_kpcrew_config("default_ap_alt"))
			kc_acf_lower_eicas_mode(3)
			if get_kpcrew_config("config_qnhhpa") then
				kc_acf_efis_baro_in_mb(0,1)
			else
				kc_acf_efis_baro_in_mb(0,0)
			end
		end
	},
	[16] = {["activity"] = "PARKING BRAKE -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_parking_break_mode(1)
		end,
		["checks"] = function() return kc_get_controls_parkbrake_mode() == 1 end
	},
	[17] = {["activity"] = "FUEL CONTROLS -- CUTOFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_lever_set(0,0)
		end
	},
	[18] = {["activity"] = "IFE & GALLEY POWER -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_ife_power(1)
			kc_acf_elec_cabin_power(1)
		end
	},
	[19] = {["activity"] = "MACH OVERSPEED TEST", ["wait"] = 7, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_overspeed()
		end
	},
	[20] = {["activity"] = "STALL WARNING TEST", ["wait"] = 7, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_stall_warnings()
		end
	},
	[21] = {["activity"] = "POWER UP FINISHED", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1,
		["actions"] = function ()
			kc_acf_irs_mode(0,2)
		end,
		["answer"] = function() return "power up finished" end
	}
}

-- Flight Preparation as checklist
-- You are CPT/LHS/PF, KPCREW RHS/PNF/PM
-- CPT: Initial state set (C&D with POWER UP or TURNAROUND)
-- CPT: OFP (E.G. SIMBRIEF) - OBTAINED
-- CPT: ENTER FLIGHT DETAILS (OPEN INFO WINDOW)
-- CPT: WEIGHT & BALANCE -- set for aircraft
-- CPT: FUEL -- set as calculated (OFP, SIMBRIEF)
--  PF: SET UP FMS
-- ALL: SET INSTRUMENTS (MCP, PFD/ND, QNH, COM, NAV)
-- CPT: CALL PREFLIGHT PROCEDURE

-- function KC_FLIGHT_PREPARATIONS() end
KC_FLIGHT_PREPARATIONS = { ["name"] = "FLIGHT PREPARATIONS", ["mode"]="c", ["wnd_width1"] = 400,["wnd_width2"] = 300, ["wnd_height"] = 32*9, 
	[1] = { ["actor"] = "", ["chkl_item"] = "YOU ARE CPT|LHS|PF", ["chkl_response"] = "KPCREW F/O|RHS|PNF|PM", ["chkl_state"] = true, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "INITIAL STATE SET", ["chkl_response"] = "C&D/POWER UP/TURNAROUND", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "OPERATIONAL FLIGHT PLAN (OFP)", ["chkl_response"] = "OBTAINED (E.G. SIMBRIEF)", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "ENTER FLIGHT DETAILS", ["chkl_response"] = "DONE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function() 
			kc_set_background_proc_status("OPENINFOWINDOW",1)
		end
	},
	[5] = { ["actor"] = "CPT:", ["chkl_item"] = "SET FUEL / WEIGHT & BALANCE", ["chkl_response"] = "SET IN ZIBO EFB", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end
	},
	[6] = { ["actor"] = " PF:", ["chkl_item"] = "SET UP FMS", ["chkl_response"] = "DONE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end
	},
	[7] = { ["actor"] = "CPT:", ["chkl_item"] = "SET INSTRUMENTS", ["chkl_response"] = "MCP, PFD/ND, QNH, COM, NAV", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function() 
			kc_menus_set_DEP_data()
			if (get_kpcrew_config("config_dhda") == true) then
				kc_acf_efis_dhda_mode(0,0)
			else
				kc_acf_efis_dhda_mode(0,1)
			end
			kc_acf_efis_fpvfpa_onoff(0,0)
			if get_kpcrew_config("config_qnhhpa") then
				kc_acf_efis_baro_in_mb(0,1)
			else
				kc_acf_efis_baro_in_mb(0,0)
			end
			kc_acf_efis_baro_sync()
			kc_acf_nd_vor_capt(0,1)
			kc_acf_nd_map_mode(0,2)
			kc_acf_nd_wxr_onoff(0,0)
			kc_acf_mcp_fds_set(0,1)
			kc_acf_et_timer_reset(1)
			kc_acf_mcp_spd_set(kc_get_V2())
			kc_acf_mcp_hdg_set(kc_get_takeoff_rwy_crs())
			kc_acf_mcp_crs_set(0,kc_get_takeoff_rwy_crs())
			kc_acf_mcp_alt_set(get_kpcrew_config("dep_glare_alt"))
			set("sim/cockpit/switches/RMI_l_vor_adf_selector",0)
			set("sim/cockpit/switches/RMI_r_vor_adf_selector",0)
			if (get_kpcrew_config("config_dhda")) then
				kc_acf_efis_dhda_mode(0,0)
				kc_acf_efis_minimum(0, get_kpcrew_config("arr_dh"))
			else
				kc_acf_efis_dhda_mode(0,1)
				kc_acf_efis_minimum(0, get_kpcrew_config("arr_da"))
			end
		end
	},
	[8] = { ["actor"] = "", ["chkl_item"] = "FLIGHT PREPARATIONS COMPLETED", ["chkl_response"] = "CALL PREFLIGHT PROCEDURE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1
	}
}

-- Pre-Flight Procedure
-- function KC_PREFLIGHT_PROCEDURE() end
KC_PREFLIGHT_PROCEDURE = { ["name"] = "PREFLIGHT PROCEDURE", ["mode"]="p", ["wnd_width"] = 430, ["wnd_height"] = 31*32,
	[1] = {["activity"] = "PERFORMING PREFLIGHT ITEMS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
		end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "PARKING BRAKE -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_parking_break_mode(1)
		end,
		["checks"] = function() return kc_get_controls_parkbrake_mode() == 1 end
	},
	[3] = {["activity"] = "SET COCKPIT LIGHTING AS REQD", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if kc_get_daylight() == 0 then
				kc_acf_light_cockpit_mode(1)
			end
		end
	},
	[4] = {["activity"] = "MASTER LIGHTS TEST", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/bright_test_up")
		end
	},
	[5] = {["activity"] = "OXYGEN -- TEST AND SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/bright_test_dn")
			command_once("laminar/B738/push_button/oxy_test_cpt")
		end
	},
	[6] = {["activity"] = "DISPLAY UNITS -- SELECT", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "ALL:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			set("laminar/B738/toggle_switch/lower_du_capt",0)
			set("laminar/B738/toggle_switch/lower_du_fo",0)
			set("laminar/B738/toggle_switch/main_pnl_du_capt",0)
			set("laminar/B738/toggle_switch/main_pnl_du_fo",0)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/lower_du_capt") == 0 and get("laminar/B738/toggle_switch/lower_du_fo") == 0 and get("laminar/B738/toggle_switch/main_pnl_du_capt") and get("laminar/B738/toggle_switch/main_pnl_du_fo") == 0 end
	},
	[7] = {["activity"] = "SPD BRAKE LEVER -- DOWN DETENT", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_speed_break_set(0)
		end,
		["checks"] = function() return kc_get_controls_speedbrake_pos() == 0 end
	},
	[8] = {["activity"] = "YAW DAMPER -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_yaw_damper_onoff(1)
		end,
		["checks"] = function() return kc_get_controls_yawdamper_mode() == 1 end
	},
	[9] = {["activity"] = "APU -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_apu_activate()
		end
	},
	[10] = {["activity"] = "EMERGENCY EXIT -- LIGHTS ARMED", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_emer_mode(1)
		end,
		["checks"] = function() return kc_get_light_emerexit_mode() == 1 end
	},
	[11] = {["activity"] = "CABIN SIGNS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_seatbelt_onoff(1)
			kc_acf_no_smoking_onoff(1)
		end,
		["checks"] = function() return kc_get_light_seatbelts_mode()  == 2 and kc_get_light_nosmoking_mode() == 2 end
	},
	[12] = {["activity"] = "WINDOW HEAT -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_window_heat_onoff(0,1)
		end,
		["checks"] = function() return kc_get_aice_window_heat_mode(1) == 1 and kc_get_aice_window_heat_mode(2) == 1 and kc_get_aice_window_heat_mode(3) == 1 and kc_get_aice_window_heat_mode(4) == 1 end
	},
	[13] = {["activity"] = "HYDRAULIC PANEL -- SET", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_hyd_pumps_onoff(1,1)
			kc_acf_hyd_pumps_onoff(2,1)
			kc_acf_hyd_pumps_onoff(3,0)
			kc_acf_hyd_pumps_onoff(4,0)
		end,
		["checks"] = function() return kc_get_systems_hydpumps_mode(1) == 1 and kc_get_systems_hydpumps_mode(2) == 1 and kc_get_systems_hydpumps_mode(3) == 0 and kc_get_systems_hydpumps_mode(4) == 0 end
	},
	[14] = {["activity"] = "TRIM AIR & RECIRC FANS -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_recirc_fans_onoff(1,1)
			set("laminar/B738/air/trim_air_pos",1)
		end,
		["checks"] = function() return kc_get_air_recirc_fan_mode(1) == 1 and kc_get_air_recirc_fan_mode(2) == 1 and kc_get_air_trimair_mode() == 1 end
	},
	[15] = {["activity"] = "PACK SWITCHES -- AUTO", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_packs_set(0,1)
		end,
		["checks"] = function() return kc_get_air_pack_mode(1) == 1 and kc_get_air_pack_mode(2) == 1 end
	},
	[16] = {["activity"] = "ISOLATION VALVE -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_xbleed_isol_mode(2)
		end,
		["checks"] = function() return get("laminar/B738/air/isolation_valve_pos") == 2 end
	},
	[17] = {["activity"] = "ENGINE BLEEDS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_bleeds_onoff(0,1)
			kc_acf_air_apu_bleed_onoff(1)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/bleed_air_1_pos") == 1 and get("laminar/B738/toggle_switch/bleed_air_2_pos") == 1 and get("laminar/B738/toggle_switch/bleed_air_apu_pos") == 1 end
	},
	[18] = {["activity"] = "FLT ALT & LAND ALT -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_set_flight_altitude(get("laminar/B738/autopilot/fmc_cruise_alt"))
			kc_acf_set_landing_altitude(get("laminar/B738/autopilot/altitude"))
		end
	},
	[19] = {["activity"] = "ENGINE START IGNITION SWITCH -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/toggle_switch/eng_start_source_right")
			command_once("laminar/B738/toggle_switch/eng_start_source_right")
		end
	},
	[20] = {["activity"] = "WING & LOGO LIGHTS -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if kc_get_daylight() == 0 then
				kc_acf_light_wing_mode(1)
				kc_acf_light_logo_mode(1)
			end
		end
	},
	[21] = {["activity"] = "OXYGEN TEST AND SET -- TEST & SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/push_button/oxy_test_fo")
		end
	},
	[22] = {["activity"] = "WEATHER RADAR AND TERRAIN -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get("laminar/B738/EFIS_control/fo/terr_on") == 0 then
				command_once("laminar/B738/EFIS_control/fo/push_button/terr_press")
			end
			if get("laminar/B738/EFIS_control/capt/terr_on") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/terr_press")
			end
		end
	},
	[23] = {["activity"] = "TRANSPONDER CONTROL PANEL -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_xpdr_mode(0)
			command_once("laminar/B738/push_button/gpws_test")
		end
	},
	[24] = {["activity"] = "NAVIGATION AND DISPLAYS PANEL -- SET", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
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
		end
	},
	[25] = {["activity"] = "FUEL PUMPS -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_pumps_onoff(5,0)
			kc_acf_fuel_pumps_onoff(6,0)
			kc_acf_fuel_pumps_onoff(1,0)
			kc_acf_fuel_pumps_onoff(2,0)
			kc_acf_fuel_pumps_onoff(3,0)
			kc_acf_fuel_pumps_onoff(4,0)
			kc_acf_fuel_xfeed_mode(0)
		end,
		["checks"] = function() return get("laminar/B738/fuel/fuel_tank_pos_lft1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_lft2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr1") == 0 and get("laminar/B738/knobs/cross_feed_pos") == 0
		end
	},
	[26] = {["activity"] = "AUTO BRAKE -- RTO", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_abrk_mode(0)
		end,
		["checks"] = function() return get(kc_autobrake_position_dataref) == 1 end
	},
	[27] = {["activity"] = "FUEL FLOW -- RESET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get("laminar/B738/toggle_switch/fuel_flow_pos") == 0 then
				command_once("laminar/B738/toggle_switch/fuel_flow_up")
			end
			kc_acf_lower_eicas_mode(3)
		end
	},
	[28] = {["activity"] = "PROBE HEAT -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_probe_heat_onoff(0,0)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/capt_probes_pos") == 0 and get("laminar/B738/toggle_switch/fo_probes_pos") == 0 end
	},
	[29] = {["activity"] = "AIR CONDITIONING PANEL -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_temp_control(0,0.5)
		end,
		["checks"] = function() return get("laminar/B738/air/fwd_cab_temp/rheostat") == 0.5 end
	},
	[30] = {["activity"] = "CABIN PRESSURIZATION PANEL -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_valve(0)
		end
	},
	[31] = {["activity"] = "LIGHTING PANEL -- SET", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_landing_mode(0,0)
			kc_acf_light_nav_mode(1)
			kc_acf_light_beacon_mode(0)
			if kc_get_daylight() == 0 then
				kc_acf_light_wing_mode(1)
			end
			kc_acf_light_taxi_mode(0)
			kc_acf_light_landing_mode(0,0)
		end,
		["checks"] = function() return get("laminar/B738/switch/land_lights_left_pos") == 0 and get("laminar/B738/switch/land_lights_ret_left_pos") == 0 and get("laminar/B738/switch/land_lights_ret_right_pos") == 0 and get("laminar/B738/switch/land_lights_right_pos") == 0 end
	},
	[32] = {["activity"] = "PREFLIGHT FINISHED | CALL PREFLIGHT CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- PREFLIGHT (PM)
-- Oxygen . . . . . . . . . . . . . . . . . . . 	Tested, 100% (ALL)
-- NAVIGATION transfer and DISPLAY switches . .		NORMAL, AUTO (PF)
-- Window heat  . . . . . . . . . . . . . . . .		On (PF)
-- Pressurization mode selector . . . . . . . .		AUTO (PF)
-- Flight instruments . . . . . . . . . . . . . 	Heading___, Altimeter___ (ALL)
-- Parking brake  . . . . . . . . . . . . . . . 	Set (PF)
-- Engine start levers  . . . . . . . . . . . . 	CUTOFF (PF)
-- Gear Pins  . . . . . . . . . . . . . . . . .		REMOVED (PF)

-- function KC_PREFLIGHT_CHECKLIST() end
KC_PREFLIGHT_CHECKLIST = { ["name"] = "PREFLIGHT CHECKLIST (PM)", ["mode"]="c", ["wnd_width1"] = 400,["wnd_width2"] = 300, ["wnd_height"] = 32*9, 
	[1] = { ["actor"] = "", ["chkl_item"] = "PREFLIGHT CHECKLIST", ["chkl_response"] = "", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
	},
	[2] = { ["actor"] = "ALL:", ["chkl_item"] = "OXYGEN", ["chkl_response"] = "TESTED - 100%", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 3, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0
	},
	[3] = { ["actor"] = " PF:", ["chkl_item"] = "NAVIGATION TRANSFER & DISPLAY SWITCHES", ["chkl_response"] = "NORMAL, AUTO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["checks"] = function ()
			return get("laminar/B738/toggle_switch/vhf_nav_source") == 0 and get("laminar/B738/toggle_switch/irs_source") == 0 and get("laminar/B738/toggle_switch/fmc_source") == 0 and get("laminar/B738/toggle_switch/dspl_source") == 0 and get("laminar/B738/toggle_switch/dspl_ctrl_pnl") == 0
		end,
		["actions"] = function ()
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
				command_once("laminar/B738/toggle_switch/fmc_source_right")
			end
			set("laminar/B738/toggle_switch/dspl_source",0)
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") > 0 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
			end
			if get("laminar/B738/toggle_switch/dspl_ctrl_pnl") < 0 then
				command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
			end
		end,
		["answer"] = function () return "" end
	},
	[4] = { ["actor"] = " PF:", ["chkl_item"] = "WINDOW HEAT", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["checks"] = function ()
			return kc_get_aice_window_heat_mode(1) == 1 and kc_get_aice_window_heat_mode(2) == 1 and kc_get_aice_window_heat_mode(3) == 1 and kc_get_aice_window_heat_mode(4) == 1
		end,
		["actions"] = function ()
			-- Window heat
			kc_acf_aice_window_heat_onoff(0,1)
		end,
		["answer"] = function () return "" end
	},
	[5] = { ["actor"] = " PF:", ["chkl_item"] = "PRESSURIZATION MODE SELECTOR", ["chkl_response"] = "AUTO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["checks"] = function ()
			return get("laminar/B738/toggle_switch/air_valve_ctrl") == 0
		end,
		["actions"] = function ()
			-- Pressurization
			kc_acf_air_valve(0)
		end,
		["answer"] = function () return "" end
	},
	[6] = { ["actor"] = "ALL:", ["chkl_item"] = "FLIGHT INSTRUMENTS", ["chkl_response"] = "HEADING _, ALTIMETER _", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 5, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["display"] = function ()
			return string.format("HEADING %i, ALTIMETER %i",math.floor(get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot")),math.floor(get("laminar/B738/autopilot/altitude")))
		end,
		["answer"] = function () 
			return "HEADING "..convertNato(math.floor(get("sim/cockpit2/gauges/indicators/heading_electric_deg_mag_pilot"))).." and ALTIMETER "..convertNato(math.floor(get("laminar/B738/autopilot/altitude")))
		end
	},
	[7] = { ["actor"] = " PF:", ["chkl_item"] = "PARKING BRAKE", ["chkl_response"] = "SET", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["checks"] = function ()
			return get("laminar/B738/annunciator/parking_brake") == 1
		end,
		["actions"] = function ()
			kc_acf_parking_break_mode(1)
		end,
		["answer"] = function () return "" end
	},
	[8] = { ["actor"] = " PF:", ["chkl_item"] = "GEAR PINS", ["chkl_response"] = "REMOVED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0
	},
	[9] = { ["actor"] = "", ["chkl_item"] = "PREFLIGHT CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 3, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "pre flight checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- Briefings section
-- function KC_FLIGHT_BRIEFINGS() end
KC_FLIGHT_BRIEFINGS = { ["name"] = "FLIGHT BRIEFINGS", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*5, 
	[1] = { ["actor"] = " PF:", ["chkl_item"] = "ATC CLEARANCE", ["chkl_response"] = "OBTAINED", ["chkl_state"] = true, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function ()
			kc_set_background_proc_status("OPENINFOWINDOW",1)
		end
	},
	[3] = { ["actor"] = " PF:", ["chkl_item"] = "DEPARTURE BRIEFING", ["chkl_response"] = "CHARTS & FMS CHECKED", ["chkl_state"] = true, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function ()
			kc_set_background_proc_status("OPENINFOWINDOW",1)
		end
	},
	[2] = { ["actor"] = " PF:", ["chkl_item"] = "TAXI BRIEFING", ["chkl_response"] = "TAXI ROUTE", ["chkl_state"] = true, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function ()
			kc_set_background_proc_status("OPENINFOWINDOW",1)
		end
	},
	[4] = { ["actor"] = " PF:", ["chkl_item"] = "TAKEOFF BRIEFING", ["chkl_response"] = "OBTAINED", ["chkl_state"] = true, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function() return "" end,
		["speak"] = function() return "" end,
		["actions"] = function ()
			kc_set_background_proc_status("OPENINFOWINDOW",1)
		end
	},
	[5] = { ["actor"] = "", ["chkl_item"] = "BRIEFINGS COMPLETED", ["chkl_response"] = "NEXT BEFORE START PROCEDURE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 0, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1
	}
}

-- BEFORE START PROC
-- function KC_BEFORE_START_PROC() end
KC_BEFORE_START_PROC = { ["name"] = "BEFORE START PROCEDURE", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*11,
	[1] = {["activity"] = "PERFORMING BEFORE START ITEMS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "ELEVATOR TRIM -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elev_trim_set(get_kpcrew_config("dep_elevator_trim"))
		end
	},
	[3] = {["activity"] = "RUDDER TRIM -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_rudder_trim_set(0)
		end,
		["checks"] = function() return get("sim/cockpit2/controls/rudder_trim") == 0 end
	},
	[4] = {["activity"] = "AILERON TRIM -- SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aileron_trim_set(0)
		end,
		["checks"] = function() return get("sim/cockpit2/controls/aileron_trim") == 0 end
	},
	[5] = {["activity"] = "AUTOTHROTTLE -- ARM", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_at_onoff(1)
		end,
		["checks"] = function() return get("laminar/B738/autopilot/autothrottle_arm_pos") == 1 end
	},
	[6] = {["activity"] = "EXTERNAL DOORS -- CLOSE", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_airstair_onoff(0)
			kc_acf_external_doors(0,0)
		end,
		["checks"] = function() return get("laminar/B738/airstairs_hide") == 1 and get("737u/doors/L1") == 0 and get("737u/doors/Fwd_Cargo") == 0 and get("737u/doors/aft_Cargo") == 0 end
	},
	[7] = {["activity"] = "FUEL PANEL -- SET FOR START", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_pumps_onoff(0,1)
			if get("laminar/B738/fuel/center_tank_kgs") <  100 then
				kc_acf_fuel_pumps_onoff(5,0)
				kc_acf_fuel_pumps_onoff(6,0)
			end
		end,
		["checks"] = function() return get("laminar/B738/fuel/fuel_tank_pos_lft1") == 1 and get("laminar/B738/fuel/fuel_tank_pos_lft2") == 1 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 1 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 1 end
	},
	[8] = {["activity"] = "ANTI COLLISION LIGHT -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_beacon_mode(1)
		end,
		["checks"] = function() return kc_get_light_beacon_mode() == 1 end
	},
	[9] = {["activity"] = "HYDRAULIC PANEL -- SET FOR START", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_hyd_pumps_onoff(1,0)
			kc_acf_hyd_pumps_onoff(3,1)
			kc_acf_hyd_pumps_onoff(2,0)
			kc_acf_hyd_pumps_onoff(4,1)
		end,
		["checks"] = function() return kc_get_systems_hydpumps_mode(1) == 0 and kc_get_systems_hydpumps_mode(2) == 0 and kc_get_systems_hydpumps_mode(3) == 1 and kc_get_systems_hydpumps_mode(4) == 1 end
	},
	[10] = {["activity"] = "ISOLATION VALVE -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_xbleed_isol_mode(2)
			kc_acf_external_doors(0,0)
			kc_acf_lower_eicas_mode(0)
			kc_acf_lower_eicas_mode(1)
		end,
		["checks"] = function() return get("laminar/B738/air/isolation_valve_pos") == 2 end
	},
	[11] = {["activity"] = "BEFORE START FINISHED | NEXT BEFORE START CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- BEFORE START (FO)
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

-- function KC_BEFORE_START_CHECKLIST() end
KC_BEFORE_START_CHECKLIST = { ["name"] = "BEFORE START CHECKLIST (F/O)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*11, 
	[1] = { ["actor"] = "", ["chkl_item"] = "BEFORE START CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 4, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "before start checklist" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "FLIGHT DECK DOOR", ["chkl_response"] = "CLOSED AND LOCKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/door/flt_dk_door_ratio") == 0
		end,
		["actions"] = function () 
			kc_acf_cockpit_door(0)
			kc_acf_external_doors(0,0)
		end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "FUEL", ["chkl_response"] = "___ KGS, PUMPS ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/fuel/fuel_tank_pos_lft1") == 1 and get("laminar/B738/fuel/fuel_tank_pos_lft2") == 1 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 1 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 1 
		end,
		["display"] = function ()
			return string.format("%i KGS, PUMPS ON",kc_get_total_fuel())
		end,
		["actions"] = function ()
			kc_acf_fuel_pumps_onoff(0,1)
			if get("laminar/B738/fuel/center_tank_kgs") <  100 then
				kc_acf_fuel_pumps_onoff(5,0)
				kc_acf_fuel_pumps_onoff(6,0)
			end
		end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "PASSENGER SIGNS", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return kc_get_light_seatbelts_mode() > 0 and kc_get_light_nosmoking_mode() > 0
		end,
		["actions"] = function ()
			kc_acf_seatbelt_onoff(1)
			kc_acf_no_smoking_onoff(1)
		end
	},
	[5] = { ["actor"] = "ALL:", ["chkl_item"] = "WINDOWS", ["chkl_response"] = "LOCKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0
	},
	[6] = { ["actor"] = "CPT:", ["chkl_item"] = "MCP", ["chkl_response"] = "V2___, HEADING___, ALTITUDE_____", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["speak"] = function () return "M C P" end,
		["actions"] = function ()
			kc_acf_mcp_spd_set(get_kpcrew_config("dep_glare_spd"))
			kc_acf_mcp_hdg_set(get_kpcrew_config("dep_glare_hdg"))
			kc_acf_mcp_alt_set(get_kpcrew_config("dep_glare_alt"))
		end,
		["display"] = function ()
			return string.format("V2 %i, HEADING %i, ALTITUDE %i",kc_get_V2(),get("laminar/B738/autopilot/mcp_hdg_dial"),get("laminar/B738/autopilot/mcp_alt_dial"))
		end
	},
	[7] = { ["actor"] = "ALL:", ["chkl_item"] = "TAKEOFF SPEEDS", ["chkl_response"] = "V1___, VR___, V2___", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 7, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return string.format("V 1 %i, V Rotate %i, V 2 %i",get("laminar/B738/FMS/v1"),get("laminar/B738/FMS/vr"),get("laminar/B738/FMS/v2")) end,
		["display"] = function ()
			return string.format("V1 %i, VR %i, V2 %i",get("laminar/B738/FMS/v1"),get("laminar/B738/FMS/vr"),get("laminar/B738/FMS/v2"))
		end
	},
	[8] = { ["actor"] = "CPT:", ["chkl_item"] = "CDU PREFLIGHT", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["speak"] = function () return "C D U pre flight" end
	},
	[9] = { ["actor"] = "CPT:", ["chkl_item"] = "RUDDER AND AILERON TRIM", ["chkl_response"] = "FREE AND ZERO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("sim/cockpit2/controls/rudder_trim") == 0 and get("sim/cockpit2/controls/aileron_trim") == 0
		end,
		["actions"] = function ()
			kc_acf_rudder_trim_set(0)
			kc_acf_aileron_trim_set(0)
		end
	},
	[10] = { ["actor"] = "CPT:", ["chkl_item"] = "TAXI AND TAKEOFF BRIEFING", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[11] = { ["actor"] = "CPT:", ["chkl_item"] = "ANTI COLLISION LIGHT", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return kc_get_light_beacon_mode() == 1
		end,
		["actions"] = function ()
			kc_acf_light_beacon_mode(1)
		end
	},
	[12] = { ["actor"] = "", ["chkl_item"] = "BEFORE START CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "before start checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_STARTUP_AND_PUSH_PROC() end
KC_STARTUP_AND_PUSH_PROC = { ["name"] = "STARTUP AND PUSHBACK", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*21,
	[1] = {["activity"] = "PERFORMING BEFORE START ITEMS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_chocks_mode(0)
			kc_acf_parking_break_mode(0)
			kc_acf_light_beacon_mode(1)
			kc_acf_parking_break_mode(1)
			kc_acf_external_doors(0,0)
		end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "CALL PUSHBACK SERVICES", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function () return "" end,
		["skip"] = function () 
			return get_kpcrew_config("dep_push_direction") == 1
		end,
		["display"] = function () 
			if get_kpcrew_config("dep_push_direction") == 1 then
				return "PUSHBACK NOT REQUIRED"
			else
				return "CALL PUSHBACK SERVICES"
			end
		end
	},
	[3] = {["activity"] = "ENGAGE PUSHBACK SERVICES", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function () 
			if get_kpcrew_config("dep_push_direction") > 1 then
				return "Cockpit to ground                          we are ready to push"
			end
		end,
		["actions"] = function () 
			if get_kpcrew_config("dep_push_direction") > 1 then
				command_once("BetterPushback/start")
				set_kpcrew_config("flight_off_block",get("sim/time/zulu_time_sec"))
			end
		end,
		["skip"] = function () 
			return get_kpcrew_config("dep_push_direction") == 1
		end,
		["display"] = function () 
			if get_kpcrew_config("dep_push_direction") == 1 then
				return "CONTINUE START ITEMS"
			else
				return "PUSH TRUCK STARTING"
			end
		end
	},
	[4] = {["activity"] = "START SEQUENCE 2 THEN 1", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_lower_eicas_mode(1)
		end,
		["speak"] = function () 
			return "start sequence is 2 then 1"
		end
	},
	[5] = {["activity"] = "PACKS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_packs_set(0,0)
		end,
		["checks"] = function() return kc_get_air_pack_mode(1) == 0 and kc_get_air_pack_mode(2) == 0 end
	},
	[6] = {["activity"] = "START ENGINE 2", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	},
	[7] = {["activity"] = "STARTING ENGINE 2", ["wait"] = 10, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			command_once("laminar/B738/knob/eng2_start_left")
			kc_set_background_proc_status("N2ROTATION2",1)
		end,
		["speak"] = function () 
			return "starting engine 2"
		end	
	},
	[8] = {["activity"] = "START ENGINE 1", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
	},
	[9] = {["activity"] = "STARTING ENGINE 1", ["wait"] = 10, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			command_once("laminar/B738/knob/eng1_start_left")
			kc_set_background_proc_status("N2ROTATION2",0)
			kc_set_background_proc_status("N2ROTATION1",1)
		end,
		["speak"] = function () 
			return "starting engine 1"
		end
	},
	[10] = {["activity"] = "2 GOOD STARTS?", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_set_background_proc_status("N2ROTATION1",0)
		end	
	},
	[11] = {["activity"] = "GENERATORS -- ON", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_elec_gen_on_bus(0,1)
		end,
		["speak"] = function () 
			return "2 good starts"
		end,
		["checks"] = function() return get("laminar/B738/annunciator/gen_off_bus1") == 0 and get("laminar/B738/annunciator/gen_off_bus2") == 0 end
	},
	[12] = {["activity"] = "PROBE HEAT -- ON", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_aice_probe_heat_onoff(0,1)
		end,
		["speak"] = function () return "" end,
		["checks"] = function() return get("laminar/B738/toggle_switch/capt_probes_pos") == 0 and get("laminar/B738/toggle_switch/fo_probes_pos") == 0 end
	},
	[13] = {["activity"] = "ANTI-ICE -- AS REQUIRED", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			if get_kpcrew_config("dep_anti_ice") == 1 then
				kc_acf_aice_wing_onoff(0)
				kc_acf_aice_eng_onoff(0,0)
			end
			if get_kpcrew_config("dep_anti_ice") == 2 then
				kc_acf_aice_wing_onoff(0)
				kc_acf_aice_eng_onoff(0,1)
			end
			if get_kpcrew_config("dep_anti_ice") == 3 then
				kc_acf_aice_wing_onoff(1)
				kc_acf_aice_eng_onoff(0,1)
			end
		end,
		["speak"] = function () return "" end,
		["display"] = function () 
			if get_kpcrew_config("dep_anti_ice") == 1 then
				return "ANTI ICE -- NOT REQUIRED"
			end
			if get_kpcrew_config("dep_anti_ice") == 2 then
				return "ANTI ICE -- ENGINES ONLY"
			end
			if get_kpcrew_config("dep_anti_ice") == 3 then
				return "ANTI ICE -- ENGINES AND WINGS"
			end
		end
	},
	[14] = {["activity"] = "PACKS & ISOLATION -- AS REQUIRED", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			if get_kpcrew_config("dep_packs") == 1 then
				kc_acf_air_xbleed_isol_mode(1)
				kc_acf_air_packs_set(0,2)
			end
			if get_kpcrew_config("dep_packs") == 2 then
				kc_acf_air_xbleed_isol_mode(1)
				kc_acf_air_packs_set(0,1)
			end
			if get_kpcrew_config("dep_packs") == 3 then
				kc_acf_air_xbleed_isol_mode(1)
				kc_acf_air_packs_set(0,0)
			end
		end,
		["speak"] = function () return "" end,
		["display"] = function () 
			if get_kpcrew_config("dep_packs") == 1 then
				return "PACKS -- ON"
			end
			if get_kpcrew_config("dep_packs") == 2 then
				return "PACKS -- AUTO"
			end
			if get_kpcrew_config("dep_packs") == 3 then
				return "PACKS -- OFF"
			end
		end
	},
	[15] = {["activity"] = "BLEEDS -- ON", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_air_bleeds_onoff(0,1)
			kc_acf_air_apu_bleed_onoff(0)
		end,
		["speak"] = function () return "" end,
		["checks"] = function() return get("laminar/B738/toggle_switch/bleed_air_1_pos") == 1 and get("laminar/B738/toggle_switch/bleed_air_1_pos") == 1 end
	},
	[16] = {["activity"] = "APU -- OFF", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_elec_apu_stop()
		end,
		["speak"] = function () return "" end
	},
	[17] = {["activity"] = "ENGINE START SWITCHES -- OFF", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
--			kc_acf_eng_starter_mode(0,1)
		end,
		["speak"] = function () return "" end,
		["checks"] = function() return get("laminar/B738/engine/starter1_pos") == 1 and get("laminar/B738/engine/starter1_pos") == 1 end
	},
	[18] = {["activity"] = "HYDRAULICS -- ON", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_hyd_pumps_onoff(0,1)
		end,
		["speak"] = function () return "" end,
		["checks"] = function() return kc_get_systems_hydpumps_mode(1) == 1 and kc_get_systems_hydpumps_mode(2) == 1 and kc_get_systems_hydpumps_mode(3) and kc_get_systems_hydpumps_mode(4) == 1 end
	},
	[19] = {["activity"] = "TAKEOFF FLAPS -- SET", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(kc_get_takeoff_flaps())
		end,
		["speak"] = function () return "SET TAKEOFF FLAPS " .. kc_get_takeoff_flaps() end,
		["display"] = function () return "SET TAKEOFF FLAPS " .. kc_get_takeoff_flaps() end
	},
	[20] = {["activity"] = "FLIGHT CONTROL CHECKS ", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_lower_eicas_mode(3)
			kc_set_background_proc_status("FLIGHTCTRLELEV1",1)
			kc_set_background_proc_status("FLIGHTCTRLAIL1",1)
			kc_set_background_proc_status("FLIGHTCTRLRUD1",1)
		end
	},
	[21] = {["activity"] = "FLIGHT CONTROL CHECKS FINISHED", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function ()
			return " "
		end
	},
	[22] = {["activity"] = "STARTUP FINISHED | CALL BEFORE TAXI CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1,
		["actions"] = function ()
			kc_acf_lower_eicas_mode(0)
			kc_acf_light_cockpit_mode(0)
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

-- function KC_BEFORE_TAXI_CHECKLIST() end
KC_BEFORE_TAXI_CHECKLIST = { ["name"] = "BEFORE TAXI CHECKLIST (F/O)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*10, 
	[1] = { ["actor"] = "", ["chkl_item"] = "BEFORE TAXI CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 4, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "before taxi checklist" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "GENERATORS", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/annunciator/gen_off_bus1") == 0 and get("laminar/B738/annunciator/gen_off_bus2") == 0
		end,
		["actions"] = function () 
			kc_acf_elec_gen_on_bus(0,1)
			kc_acf_external_doors(0,0)
		end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "PROBE HEAT", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/toggle_switch/capt_probes_pos") == 1 and get("laminar/B738/toggle_switch/fo_probes_pos") == 1
		end,
		["actions"] = function () 
			kc_acf_aice_probe_heat_onoff(0,1)
		end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "ANTI ICE", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			if get_kpcrew_config("dep_anti_ice") == 1 then
				return get("laminar/B738/ice/wing_heat_pos") == 0 and get("laminar/B738/ice/eng1_heat_pos") == 0 and get("laminar/B738/ice/eng2_heat_pos") == 0
			end
			if get_kpcrew_config("dep_anti_ice") == 2 then
				return get("laminar/B738/ice/wing_heat_pos") == 0 and get("laminar/B738/ice/eng1_heat_pos") == 1 and get("laminar/B738/ice/eng2_heat_pos") == 1
			end
			if get_kpcrew_config("dep_anti_ice") == 3 then
				return get("laminar/B738/ice/wing_heat_pos") == 1 and get("laminar/B738/ice/eng1_heat_pos") == 1 and get("laminar/B738/ice/eng2_heat_pos") == 1
			end
		end,
		["actions"] = function () 
			if get_kpcrew_config("dep_anti_ice") == 1 then
				kc_acf_aice_wing_onoff(0)
				kc_acf_aice_eng_onoff(0,0)
			end
			if get_kpcrew_config("dep_anti_ice") == 2 then
				kc_acf_aice_wing_onoff(0)
				kc_acf_aice_eng_onoff(0,1)
			end
			if get_kpcrew_config("dep_anti_ice") == 3 then
				kc_acf_aice_wing_onoff(1)
				kc_acf_aice_eng_onoff(0,1)
			end
		end,
		["display"] = function () 
			if get_kpcrew_config("dep_anti_ice") == 1 then
				return "NOT REQUIRED"
			end
			if get_kpcrew_config("dep_anti_ice") == 2 then
				return "ENGINES ONLY"
			end
			if get_kpcrew_config("dep_anti_ice") == 3 then
				return "ENGINES AND WINGS"
			end
		end
	},
	[5] = { ["actor"] = "CPT:", ["chkl_item"] = "ISOLATION VALVE", ["chkl_response"] = "AUTO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/air/isolation_valve_pos") == 1
		end,
		["actions"] = function () 
			kc_acf_air_xbleed_isol_mode(1)
		end
	},
	[6] = { ["actor"] = "CPT:", ["chkl_item"] = "ENGINE START SWITCHES", ["chkl_response"] = "CONT", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/engine/starter1_pos") == 2 and get("laminar/B738/engine/starter2_pos") == 2
		end,
		["actions"] = function () 
			kc_acf_eng_starter_mode(0,2)
		end
	},
	[7] = { ["actor"] = "CPT:", ["chkl_item"] = "RECALL", ["chkl_response"] = "CHECKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[8] = { ["actor"] = "CPT:", ["chkl_item"] = "AUTOBRAKE", ["chkl_response"] = "RTO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/autobrake/autobrake_pos") == 0
		end,
		["actions"] = function () 
			kc_acf_abrk_mode(0)
		end
	},
	[9] = { ["actor"] = "CPT:", ["chkl_item"] = "ENGINE START LEVERS", ["chkl_response"] = "IDLE DETENT", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["checks"] = function ()
			return get("laminar/B738/engine/mixture_ratio2") == 1 and get("laminar/B738/engine/mixture_ratio1") == 1
		end,
		["actions"] = function () 
			kc_acf_fuel_lever_set(0,1)
		end
	},
	[10] = { ["actor"] = "CPT:", ["chkl_item"] = "FLIGHT CONTROLS", ["chkl_response"] = "CHECKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[11] = { ["actor"] = "CPT:", ["chkl_item"] = "GROUND EQUIPMENT", ["chkl_response"] = "CLEAR", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "clear" end,
		["actions"] = function () 
			kc_acf_light_cockpit_mode(0)
		end
	},
	[12] = { ["actor"] = "", ["chkl_item"] = "BEFORE TAXI CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "before taxi checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- BEFORE TAKEOFF
-- Takeoff Briefing . . . . . . . . . . . . . 		REVIEWED
-- Flaps. . . . . . . . . . . . . . . . . . .		___, Green light
-- Stabilizer trim. . . . . . . . . . . . . . 		___ Units
-- Cabin. . . . . . . . . . . . . . . . . . .		Secure

-- function KC_BEFORE_TAKEOFF_CHECKLIST() end
KC_BEFORE_TAKEOFF_CHECKLIST = { ["name"] = "BEFORE TAKEOFF CHECKLIST (F/O)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*5, 
	[1] = { ["actor"] = "", ["chkl_item"] = "BEFORE TAKEOFF CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 4, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "before take off checklist" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "TAKEOFF BRIEFING", ["chkl_response"] = "REVIEWED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "FLAPS", ["chkl_response"] = "___ ,GREEN LIGHT", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(kc_get_takeoff_flaps())
		end,
		["checks"] = function ()
			return kc_get_controls_flaps_position() == kc_get_takeoff_flaps()
		end,
		["display"] = function () 
			return kc_get_takeoff_flaps() .. ", GREEN LIGHT"
		end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "STABILIZER TRIM", ["chkl_response"] = "____ UNITS", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["actions"] = function () 
			kc_acf_elev_trim_set(kc_get_takeoff_elev_trim())
		end,
		["display"] = function ()
			return string.format("STABILIZER TRIM -- %.2f UNITS",kc_acf_elev_trim_get())
		end
	},
	[5] = { ["actor"] = "CPT:", ["chkl_item"] = "CABIN", ["chkl_response"] = "SECURE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[6] = { ["actor"] = "", ["chkl_item"] = "BEFORE TAKEOFF CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "before take off checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_ENTERING_RUNWAY_PROC() end
KC_ENTERING_RUNWAY_PROC = { ["name"] = "ENTERING RUNWAY PROCEDURE", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*7,
	[1] = {["activity"] = "SETTING AIRCRAFT UP FOR TAKEOFF", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "STROBES -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_strobe_mode(1)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/position_light_pos") == 1 end
	},
	[3] = {["activity"] = "TRANSPONDER -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_xpdr_code_set(get_kpcrew_config("flight_squawk"))
			kc_acf_xpdr_mode(5)
			kc_acf_nd_wxr_onoff(1,1)
			kc_acf_nd_terr_onoff(2,1)			
		end,
		["checks"] = function() return get("laminar/B738/knob/transponder_pos") == 5 end
	},
	[4] = {["activity"] = "FIXED LANDING LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_landing_mode(1,1)
		end,
		["checks"] = function() return get("laminar/B738/switch/land_lights_left_pos") == 1 and get("laminar/B738/switch/land_lights_right_pos") == 1 end
	},
	[5] = {["activity"] = "RWY TURNOFF LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_rwyto_mode(1)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/rwy_light_left") == 1 and get("laminar/B738/toggle_switch/rwy_light_right") == 1 end
	},
	[6] = {["activity"] = "TAXI LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_taxi_mode(0)
			set_kpcrew_config("flight_time_to",get("sim/time/zulu_time_sec"))
		end,
		["checks"] = function() return kc_get_light_taxi_mode() == 0  end
	},
	[7] = {["activity"] = "ENTER RUNWAY PROCEDURE FINISHED | TAKEOFF AND CLIMB POCEDURE", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- function KC_TAKEOFF_CLIMB_PROCEDURE() end
KC_TAKEOFF_CLIMB_PROCEDURE = { ["name"] = "TAKEOFF & CLIMB", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*8,
	[1] = {["activity"] = "TAKEOFF AND CLIMB", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if not get_kpcrew_config("dep_manual_flaps") then
				kc_set_background_proc_status("TAKEOFFRUN",1)
			end
			kc_acf_et_timer_startstop(1)
			kc_acf_mcp_fds_set(0,1)
		end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "A/T -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_at_onoff(1)
			kc_acf_mcp_hdgsel_onoff(1)
		end
	},
	[3] = {["activity"] = "SET A/P MODES", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("dep_ap_modes") == 1 then
				kc_acf_mcp_lnav_onoff(1)
				kc_acf_mcp_vnav_onoff(1)
			end
			if get_kpcrew_config("dep_ap_modes") == 2 then
				kc_acf_mcp_hdgsel_onoff(1)
			end
		end,
		["speak"] = function () return "" end
	},
	[4] = {["activity"] = "SET TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function () return "" end
	},
	[5] = {["activity"] = "SETTING TAKEOFF THRUST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("dep_ap_modes") == 2 then
				kc_acf_mcp_n1_onoff(1)
			end
			kc_acf_mcp_toga()			
		end,
		["speak"] = function () return "" end
	},
	[6] = {["activity"] = "FLAPS 10", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() < 15
		end,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 10",get("laminar/B738/pfd/flaps_15")) 
		end
	},
	[7] = {["activity"] = "SPEED CHECK FLAPS 10", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() < 15
		end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(10)
		end,
		["speak"] = function () 
			return "Speed check. Flaps ten"
		end	
	},
	[8] = {["activity"] = "FLAPS 5", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() < 10
		end,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 5",get("laminar/B738/pfd/flaps_10")) 
		end
	},
	[9] = {["activity"] = "SPEED CHECK FLAPS 5", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() < 10
		end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(5)
		end,
		["speak"] = function () 
			return "Speed check. Flaps five"
		end	
	},
	[10] = {["activity"] = "FLAPS 1", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() <= 1
		end,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 1",get("laminar/B738/pfd/flaps_5")) 
		end
	},
	[11] = {["activity"] = "SPEED CHECK FLAPS 1", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() <= 1
		end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(1)
		end,
		["speak"] = function () 
			return "Speed check. Flaps one"
		end	
	},
	[12] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() == 0
		end,
		["display"] = function () 
			return "FLAPS UP" 
		end
	},
	[13] = {["activity"] = "FLAPS UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return not get_kpcrew_config("dep_manual_flaps") or kc_get_controls_flaps_position() == 0
		end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(0)
		end,
		["speak"] = function () 
			return "Flaps up"
		end	
	},
	[14] = {["activity"] = "CMD A", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return true
		end,
		["speak"] = function () return "" end
	},
	[15] = {["activity"] = "SETTING CMD A", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["skip"] = function () 
			return true
		end,
		["actions"] = function ()
			kc_acf_mcp_ap_set(1,1)
		end,
		["speak"] = function () return "" end
	},
	[16] = {["activity"] = "TAKEOFF & CLIMB FINISHED | AFTER TAKEOFF CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- AFTER TAKEOFF
-- Engine bleeds. . . . . . . . . . . . . . . 		On
-- Packs. . . . . . . . . . . . . . . . . . . 		AUTO
-- Landing gear . . . . . . . . . . . . . . . 		UP and OFF
-- Flaps . . . . . . . . . . . . . . . . . . . 		UP, no lights
-- Altimeters . . . . . . . . . . . . . . . . 		SET

-- function KC_AFTER_TAKEOFF_CHECKLIST() end
KC_AFTER_TAKEOFF_CHECKLIST = { ["name"] = "AFTER TAKEOFF CHECKLIST (PM)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*6, 
	[1] = { ["actor"] = "", ["chkl_item"] = "AFTER TAKEOFF CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 4, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "and here is the after take off checklist" end
	},
	[2] = { ["actor"] = " PM:", ["chkl_item"] = "ENGINE BLEEDS", ["chkl_response"] = "ON", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_air_bleeds_onoff(0,1)
		end		
	},
	[3] = { ["actor"] = " PM:", ["chkl_item"] = "PACKS", ["chkl_response"] = "AUTO", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_air_packs_set(0,1)
		end		
	},
	[4] = { ["actor"] = " PM:", ["chkl_item"] = "LANDING GEAR", ["chkl_response"] = "UP AND OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_gears(2)			
			kc_acf_controls_flaps_set(0)
			kc_acf_abrk_mode(1)
		end		
	},
	[5] = { ["actor"] = " PM:", ["chkl_item"] = "FLAPS", ["chkl_response"] = "UP NO LIGHTS", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(0)
		end		
	},
	[6] = { ["actor"] = "ALL:", ["chkl_item"] = "ALTIMETERS", ["chkl_response"] = "SET", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_gears(2)			
			kc_acf_controls_flaps_set(0)
			kc_acf_abrk_mode(1)
		end		
	},
	[7] = { ["actor"] = "", ["chkl_item"] = "AFTER TAKEOFF CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "after take off checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_APPROACH_BRIEFINGS()
KC_APPROACH_BRIEFINGS = { ["name"] = "APPROACH BRIEFING", ["mode"]="b", ["wnd_width"] = 400, ["wnd_height"] = 32*4, 
	[1] = {["activity"] = "START DURING CRUISE DURING LOW WORKLOAD", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function () return "" end,
		["actions"] = function () kc_set_background_proc_status("OPENINFOWINDOW",1) end
	},
	[2] = {["activity"] = "PREPARE CHARTS, ND AND FMS", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function() return "" end
	},
	[3] = {["activity"] = "PERFORM THE BRIEFING", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function() return "" end
	},
	[4] = {["activity"] = "APPROACH BRIEFING COMPLETED", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- DESCENT
-- Pressurisation . . . . . . . . . . . . . . 		LAND ALT___
-- Recall . . . . . . . . . . . . . . . . . . 		Checked
-- Autobrake . . . . . . . . . . . . . . . . 		___
-- Landing data . . . . . . . . . . . . . . . 		VREF___, Minimums___
-- Approach briefing . . . . . . . . . . . .		Completed

-- function KC_DESCEND_CHECKLIST() end
KC_DESCEND_CHECKLIST = { ["name"] = "DESCEND CHECKLIST (PM)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*6, 
	[1] = { ["actor"] = "", ["chkl_item"] = "DESCEND CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 4, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "descend checklist" end,
		["actions"] = function ()
			kc_acf_lower_eicas_mode(1)
			kc_acf_mcp_crs_set(0,kc_get_dest_runway_crs())
			kc_set_background_proc_status("TRANSALT",0)
			kc_set_background_proc_status("TENTHOUSANDUP",0)
			kc_set_background_proc_status("TENTHOUSANDDN",1)
			kc_set_background_proc_status("TRANSLVL",1)
		end
	},
	[2] = { ["actor"] = " PM:", ["chkl_item"] = "LANDING ALTITUDE ____", ["chkl_response"] = "", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 5, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "landing altitude" end,
		["answer"] = function () return string.format("LANDING ALTITUDE %i",get("laminar/B738/pressurization/knobs/landing_alt")) end,
		["display"] = function () 
			return string.format("LANDING ALTITUDE %i",get("laminar/B738/pressurization/knobs/landing_alt"))
		end
	},
	[3] = { ["actor"] = " PM:", ["chkl_item"] = "RECALL", ["chkl_response"] = "CHECKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0
	},
	[4] = { ["actor"] = " PM:", ["chkl_item"] = "AUTOBRAKE __", ["chkl_response"] = "SET", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "auto brake" end,
		["answer"] = function () return string.format("AUTOBRAKE %s",kc_autobrake_display[get(kc_autobrake_position_dataref)]) end,
		["display"] = function () 
			return string.format("AUTOBRAKE %s",kc_autobrake_display[get(kc_autobrake_position_dataref)])
		end,
		["actions"] = function () 
			kc_acf_abrk_mode(get_kpcrew_config("arr_autobrake"))
		end,		
		["checks"] = function () 
			return get(kc_autobrake_position_dataref) > 1
		end		
	},
	[5] = { ["actor"] = " PM:", ["chkl_item"] = "LANDING DATA", ["chkl_response"] = "V REFERENCE __  MINIMUMS __ FEET", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 4, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return string.format("V REFERENCE %i  MINIMUMS %i FEET",get("laminar/B738/FMS/vref"),get("laminar/B738/pfd/dh_pilot")) end,
		["display"] = function () 
			return string.format("V REFERENCE %i  MINIMUMS %i FEET",get("laminar/B738/FMS/vref"),get("laminar/B738/pfd/dh_pilot"))
		end,
		["actions"] = function () 
			if (get_kpcrew_config("config_dhda") == true) then
				set("laminar/B738/pfd/dh_pilot",get_kpcrew_config("arr_dh"))
			else
				set("laminar/B738/pfd/dh_pilot",get_kpcrew_config("arr_da"))
			end
			set("laminar/B738/EFIS_control/cpt/minimums_show",1)
		end,		
		["checks"] = function () 
			if (get_kpcrew_config("config_dhda") == true) then
				return get("laminar/B738/FMS/vref") > 0 and get("laminar/B738/pfd/dh_pilot") == get_kpcrew_config("arr_dh")
			else
				return get("laminar/B738/FMS/vref") > 0 and get("laminar/B738/pfd/dh_pilot") == get_kpcrew_config("arr_da")
			end
		end		
	},
	[6] = { ["actor"] = " PM:", ["chkl_item"] = "APPROACH BRIEFING", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0
	},
	[7] = { ["actor"] = "", ["chkl_item"] = "DESCEND CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "descend checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- APPROACH
-- Altimeters . . . . . . . . . . . . . . . 		QNH ___
-- NAV AIDS . . . . . . . . . . . . . . . . 		SET
-- function KC_APPROACH_CHECKLIST() end
KC_APPROACH_CHECKLIST = { ["name"] = "APPROACH CHECKLIST (PM)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*3, 
	[1] = { ["actor"] = "", ["chkl_item"] = "APPROACH CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "approach checklist" end
	},
	[2] = { ["actor"] = "ALL:", ["chkl_item"] = "ALTIMETERS", ["chkl_response"] = "QNH ___", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 3, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "altimeters" end,
		["answer"] = function () return string.format("Q N H %i",get("laminar/B738/EFIS/baro_sel_in_hg_pilot")*33.86389) end,
		["display"] = function () return string.format("QNH %i",get("laminar/B738/EFIS/baro_sel_in_hg_pilot")*33.86389) end
	},
	[3] = { ["actor"] = " PM:", ["chkl_item"] = "NAVIGATION AIDS", ["chkl_response"] = "SET AND CHECKED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0
	},
	[4] = { ["actor"] = "", ["chkl_item"] = "APPROACH CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "approach checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_LANDING_PROC() end
KC_LANDING_PROC = { ["name"] = "LANDING", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*15,
	[1] = {["activity"] = "PREPARING FOR LANDING", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_light_taxi_mode(0)
			kc_acf_light_rwyto_mode(1)
			kc_acf_seatbelt_onoff(1)
			command_once("sim/lights/landing_lights_on")
			kc_acf_eng_starter_mode(0,2)
			if (get_kpcrew_config("config_dhda") == true) then
				kc_acf_efis_dhda_mode(0,0)
				kc_acf_efis_minimum(0, get_kpcrew_config("arr_dh"))
			else
				kc_acf_efis_dhda_mode(0,1)
				kc_acf_efis_minimum(0, get_kpcrew_config("arr_da"))
			end
			kc_acf_speed_break_set(1)
			kc_acf_abrk_mode(get_kpcrew_config("arr_autobrake"))
		end,
		["speak"] = function () return "" end
	},
	[2] = {["activity"] = "FLAPS 1", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 1",get("laminar/B738/pfd/flaps_1")) 
		end
	},
	[3] = {["activity"] = "SPEED CHECK FLAPS 1", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(1)
		end,
		["speak"] = function () 
			return "Speed check. Flaps one"
		end	
	},
	[4] = {["activity"] = "FLAPS 5", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 5",get("laminar/B738/pfd/flaps_5")) 
		end
	},
	[5] = {["activity"] = "SPEED CHECK FLAPS 5", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(5)
		end,
		["speak"] = function () 
			return "Speed check. Flaps five"
		end	
	},
	[6] = {["activity"] = "FLAPS 15, GEAR DOWN", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 15 & GEAR DOWN",get("laminar/B738/pfd/flaps_15")) 
		end
	},
	[7] = {["activity"] = "SPEED CHECK FLAPS 15 - GEAR DOWN", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(15)
			kc_acf_gears(1)
		end,
		["speak"] = function () 
			return "Speed check. Flaps fifteen. Gear down"
		end	
	},
	[8] = {["activity"] = "ARM SPEEDBRAKE", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0
	},
	[9] = {["activity"] = "SPEEDBRAKE ARMED", ["wait"] = 3, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_speed_break_set(1)
		end,
		["speak"] = function () 
			return "Speed brake armed"
		end	
	},
	[10] = {["activity"] = "FLAPS 30", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 30",get("laminar/B738/pfd/flaps_25")) 
		end,
		["skip"] = function () 
			return get_kpcrew_config("arr_ldg_flaps") < 2
		end
	},
	[11] = {["activity"] = "SPEED CHECK FLAPS 30", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(30)
		end,
		["speak"] = function () 
			return "Speed check. Flaps thirty"
		end,
		["skip"] = function () 
			return get_kpcrew_config("arr_ldg_flaps") < 2
		end	
	},
	[12] = {["activity"] = "FLAPS 40", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("AT %i KTS - FLAPS 40",get("laminar/B738/pfd/flaps_25")-10) 
		end,
		["skip"] = function () 
			return get_kpcrew_config("arr_ldg_flaps") < 3
		end
	},
	[13] = {["activity"] = "SPEED CHECK FLAPS 40", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_controls_flaps_set(40)
		end,
		["speak"] = function () 
			return "Speed check. Flaps fourty"
		end,
		["skip"] = function () 
			return get_kpcrew_config("arr_ldg_flaps") < 3
		end	
	},
	[14] = {["activity"] = "SET MISSED APPROACH ALTITUDE", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["display"] = function () 
			return string.format("SET MISSED APPROACH ALT %i",get_kpcrew_config("arr_ga_alt") )
		end
	},
	[15] = {["activity"] = "MISSED APPROACH ALTITUDE SET", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_acf_mcp_alt_set(get_kpcrew_config("arr_ga_alt"))
		end
	},
	[16] = {["activity"] = "CALL FOR LANDING CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- LANDING
-- Cabin . . . . . . . . . . . . . . . . . .		Secure
-- ENGINE START switches . . . . . . . . . .		CONT
-- Speedbrake  . . . . . . . . . . . . . . . 		Armed
-- Landing gear. . . . . . . . . . . . . . . 		Down
-- Flaps . . . . . . . . . . . . . . . . . .		___, green light

-- function KC_LANDING_CHECKLIST() end
KC_LANDING_CHECKLIST = { ["name"] = "LANDING CHECKLIST (PM)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*6, 
	[1] = { ["actor"] = "", ["chkl_item"] = "LANDING CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 1, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "landing checklist" end
	},
	[2] = { ["actor"] = " PF:", ["chkl_item"] = "CABIN", ["chkl_response"] = "SECURE", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end
	},
	[3] = { ["actor"] = " PF:", ["chkl_item"] = "ENGINE START SWITCHES", ["chkl_response"] = "CONT", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_eng_starter_mode(0,2) end,
		["checks"] = function () return get("laminar/B738/engine/starter1_pos") == 2 and get("laminar/B738/engine/starter2_pos") == 2 end,		
		["answer"] = function () return "" end
	},
	[4] = { ["actor"] = " PF:", ["chkl_item"] = "SPEEDBRAKE", ["chkl_response"] = "ARMED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_speed_break_set(1) end,
		["checks"] = function () return get("sim/multiplayer/controls/speed_brake_request",0) == -0.5 end,
		["answer"] = function () return "" end
	},
	[5] = { ["actor"] = " PF:", ["chkl_item"] = "LANDING GEAR", ["chkl_response"] = "DOWN", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_gears(1) end,
		["checks"] = function () return get("laminar/B738/controls/gear_handle_down") == 1 end,
		["answer"] = function () return "" end
	},
	[6] = { ["actor"] = " PF:", ["chkl_item"] = "FLAPS", ["chkl_response"] = "___ ,GREEN LIGHT", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 1, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["answer"] = function () return "" end,
		["actions"] = function () 
			kc_acf_controls_flaps_set(kc_get_landing_flaps())
		end,
		["checks"] = function ()
			return kc_get_controls_flaps_position() == kc_get_landing_flaps()
		end,
		["display"] = function () 
			return kc_get_landing_flaps() .. ", GREEN LIGHT"
		end
	},
	[7] = { ["actor"] = "", ["chkl_item"] = "LANDING CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "LANDING checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_FINAL_PROC() end
KC_FINAL_PROC = { ["name"] = "FINAL", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*7,
	[1] = {["activity"] = "ON FINAL", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0
	},
	[2] = {["activity"] = "CLEARED FOR LANDING?", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0
	},
	[3] = {["activity"] = "AUTOPILOT OFF", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0
	},
	[4] = {["activity"] = "AUTOPILOT DISCONNECTED", ["wait"] = 4, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_set_background_proc_status("APDISCONNECT1",1)
		end	
	},
	[5] = {["activity"] = "AUTOTHROTTLE OFF", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0
	},
	[6] = {["activity"] = "AUTOTHROTTLE DISCONNECTED", ["wait"] = 3, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () 
			kc_set_background_proc_status("APDISCONNECT1",1)
			kc_acf_mcp_at_onoff(0)
		end	
	},
	[7] = {["activity"] = "NEXT AFTER LANDING", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- function KC_CLEANUP_PROC() end
KC_CLEANUP_PROC = { ["name"] = "CLEANUP", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*14,
	[1] = {["activity"] = "AFTER LANDING ITEMS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () end,
		["answer"] = function () return "it is ok to clean up " end
	},
	[2] = {["activity"] = "SPEED BRAKES -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_speed_break_set(0)
		end
	},
	[3] = {["activity"] = "CHRONO and ET -- STOP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_et_timer_startstop(1)
			set_kpcrew_config("flight_time_ldg",get("sim/time/zulu_time_sec"))
		end
	},
	[4] = {["activity"] = "WX RADAR -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_nd_wxr_onoff(0,0)
		end
	},
	[5] = {["activity"] = "APU -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_apu_activate()
		end,
		["skip"] = function () return get_kpcrew_config("arr_apu") == 3 end
	},
	[6] = {["activity"] = "FLAPS -- UP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_controls_flaps_set(0)
		end
	},
	[7] = {["activity"] = "PROBE HEAT -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_probe_heat_onoff(0,0)
		end
	},
	[8] = {["activity"] = "STROBES -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_nav_mode(1)
		end
	},
	[9] = {["activity"] = "LANDING LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_landing_mode(0,0)
			kc_acf_light_rwyto_mode(0)
		end
	},
	[10] = {["activity"] = "TAXI LIGHTS -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_taxi_mode(2)
		end
	},
	[11] = {["activity"] = "ENGINE START SWITCHES -- AUTO", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_eng_starter_mode(0,1)
		end
	},
	[12] = {["activity"] = "TRAFFIC -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get("laminar/B738/EFIS/tfc_show") == 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/tfc_press")
			end
		end
	},
	[13] = {["activity"] = "AUTOBRAKE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_abrk_mode(1)
		end
	},
	[14] = {["activity"] = "TRANSPONDER -- STBY", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_xpdr_mode(1)
			kc_acf_mcp_fds_set(0,0)			
		end
	},
	[15] = {["activity"] = "AIRCRAFT CLEANED UP | NEXT SHUTDOWN AT STAND", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- function KC_SHUTDOWN_PROC() end
KC_SHUTDOWN_PROC = { ["name"] = "SHUTDOWN", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*17,
	[1] = {["activity"] = "SHUTDOWN STEPS", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () end,
		["answer"] = function () return "" end
	},
	[2] = {["activity"] = "TAXI LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_taxi_mode(0)
			set_kpcrew_config("flight_on_block",get("sim/time/zulu_time_sec"))			
		end
	},
	[3] = {["activity"] = "SHUTDOWN ENGINES!", ["wait"] = 1, ["interactive"] = 1, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["speak"] = function () return "ready for shutdown" end
	},
	[4] = {["activity"] = "SHUTTING DOWN ENGINES", ["wait"] = 10, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_lever_set(0,0)
		end
	},
	[5] = {["activity"] = "SEATBELT SIGNS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_seatbelt_onoff(0)
		end
	},
	[6] = {["activity"] = "BEACON -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_beacon_mode(0)
		end
	},
	[7] = {["activity"] = "FUEL PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_fuel_pumps_onoff(0,0)
			if get_kpcrew_config("config_apuinit") then
				kc_acf_fuel_pumps_onoff(1,1)
			end
			kc_acf_fuel_xfeed_mode(0)
		end
	},
	[8] = {["activity"] = "WING & ENGINE ANTIICE -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_wing_onoff(0)
			kc_acf_aice_eng_onoff(0,0)
		end
	},
	[9] = {["activity"] = "ELECTRICAL HYDRAULIC PUMPS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_hyd_pumps_onoff(1,1)
			kc_acf_hyd_pumps_onoff(2,1)
			kc_acf_hyd_pumps_onoff(3,0)
			kc_acf_hyd_pumps_onoff(4,0)
		end
	},
	[10] = {["activity"] = "ISOLATION VALVE -- OPEN", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_xbleed_isol_mode(2)
		end
	},
	[11] = {["activity"] = "APU BLEED -- ON", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_apu_bleed_onoff(1)
		end
	},
	[12] = {["activity"] = "FLIGHT DIRECTORS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_fds_set(0,0)
		end
	},
	[13] = {["activity"] = "RESET MCP", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_mcp_alt_set(get_kpcrew_config("default_ap_alt"))
			kc_acf_mcp_hdg_set(get_kpcrew_config("default_ap_hdg"))
			kc_acf_mcp_spd_set(get_kpcrew_config("default_ap_spd"))
		end
	},
	[14] = {["activity"] = "RESET TRANSPONDER", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_xpdr_code_set(2000)
		end
	},
	[15] = {["activity"] = "DOORS", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			if get_kpcrew_config("dep_stand") > 1 then
				kc_acf_airstair_onoff(1)
			end
			kc_acf_external_doors(3,1)
			kc_acf_external_doors(2,1)
			kc_acf_external_doors(1,1)
		end
	},
	[16] = {["activity"] = "RESET ELAPSED TIME", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_lower_eicas_mode(0)
		end
	},
	[17] = {["activity"] = "NEXT SHUTDOWN CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- SHUTDOWN
-- Hydraulic panel . . . . . . . . . . . . 			Set
-- Probe heat. . . . . . . . . . . . . . . 			Auto/Off
-- Fuel pumps. . . . . . . . . . . . . . . 			Off
-- Flaps . . . . . . . . . . . . . . . . . 			Up
-- Engine start levers . . . . . . . . . .			CUTOFF
-- Weather radar . . . . . . . . . . . . . 			Off
-- Parking brake . . . . . . . . . . . . .			___

-- function KC_SHUTDOWN_CHECKLIST() end
KC_SHUTDOWN_CHECKLIST = { ["name"] = "SHUTDOWN CHECKLIST (F/O)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*8, 
	[1] = { ["actor"] = "", ["chkl_item"] = "SHUTDOWN CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "shutdown checklist" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "HYDRAULIC PANEL", ["chkl_response"] = "SET", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_hyd_pumps_onoff(1,1)
			kc_acf_hyd_pumps_onoff(2,1)
			kc_acf_hyd_pumps_onoff(3,0)
			kc_acf_hyd_pumps_onoff(4,0)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/hydro_pumps1_pos") == 1 and get("laminar/B738/toggle_switch/hydro_pumps2_pos") == 1 and get("laminar/B738/toggle_switch/electric_hydro_pumps1_pos") == 0 and get("laminar/B738/toggle_switch/electric_hydro_pumps2_pos") == 0 end,		
		["answer"] = function () return "" end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "PROBE HEAT", ["chkl_response"] = "AUTO/OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_aice_probe_heat_onoff(0,0)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/capt_probes_pos") == 0 and get("laminar/B738/toggle_switch/fo_probes_pos") == 0 end,		
		["answer"] = function () return "" end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "FUEL PUMPS", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 3, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_fuel_pumps_onoff(0,0) 
			if get_kpcrew_config("config_apuinit") then
				kc_acf_fuel_pumps_onoff(1,1)
			end
		end,
		["checks"] = function() return ((get_kpcrew_config("config_apuinit") and get("laminar/B738/fuel/fuel_tank_pos_lft1") == 1) or get("laminar/B738/fuel/fuel_tank_pos_lft1") == 0) and  get("laminar/B738/fuel/fuel_tank_pos_lft2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt1") == 0 and get("laminar/B738/fuel/fuel_tank_pos_rgt2") == 0 and get("laminar/B738/fuel/fuel_tank_pos_ctr1") == 0
		end,		
		["answer"] = function () return "" end
	},
	[5] = { ["actor"] = "CPT:", ["chkl_item"] = "FLAPS", ["chkl_response"] = "UP", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_controls_flaps_set(0) end,
		["checks"] = function () return get(kc_flaps_position_dataref) == 0 end,
		["answer"] = function () return "" end
	},
	[6] = { ["actor"] = "CPT:", ["chkl_item"] = "ENGINE START LEVERS", ["chkl_response"] = "CUTOFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_fuel_lever_set(0,0) end,
		["checks"] = function () return get("laminar/B738/engine/mixture_ratio1") == 0 and get("laminar/B738/engine/mixture_ratio2") == 0 end,
		["answer"] = function () return "" end
	},
	[7] = { ["actor"] = "ALL:", ["chkl_item"] = "WEATHER RADAR", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_nd_wxr_onoff(0,0) end,
		["checks"] = function () return get("laminar/B738/EFIS/EFIS_wx_on") == 0 and get("laminar/B738/EFIS/fo/EFIS_wx_on") == 0 end
	},
	[8] = { ["actor"] = "CPT:", ["chkl_item"] = "PARKING BRAKE", ["chkl_response"] = "RELEASED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_parking_break_mode(0) end,
		["checks"] = function () return kc_get_controls_parkbrake_mode() end,
		["answer"] = function () return "" end
	},
	[9] = { ["actor"] = "", ["chkl_item"] = "SHUTDOWN CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "SHUTDOWN checklist completed" end,
		["answer"] = function () return "" end
	}
}

-- function KC_SECURE_AIRCRAFT_PROC() end
KC_SECURE_AIRCRAFT_PROC = { ["name"] = "SECURE AIRCRAFT", ["mode"]="p", ["wnd_width"] = 380, ["wnd_height"] = 31*10,
	[1] = {["activity"] = "SECURE AIRCRAFT", ["wait"] = 2, ["interactive"] = 0, ["actor"] = "SYS:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function () end,
		["answer"] = function () return "" end
	},
	[2] = {["activity"] = "CAB/UTIL & IFE GALLEY POWER -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_elec_ife_power(0)
			kc_acf_elec_cabin_power(0)
			kc_acf_elec_stby_power(0)
		end
	},
	[3] = {["activity"] = "TRIM AIR SWITCH -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			set("laminar/B738/air/trim_air_pos",0)
		end
	},
	[4] = {["activity"] = "IRS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_irs_mode(0,0)
		end
	},
	[5] = {["activity"] = "EMERGENCY EXIT LIGHTS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_light_emer_mode(0)
		end
	},
	[6] = {["activity"] = "WINDOW HEAT -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_aice_window_heat_onoff(0,0)
		end
	},
	[7] = {["activity"] = "PACKS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_air_packs_set(0,0)
		end
	},
	[8] = {["activity"] = "APU -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			command_once("sim/electrical/APU_off")
			command_once("sim/electrical/GPU_off")
			kc_acf_elec_battery_onoff(0)
		end
	},
	[9] = {["activity"] = "HYDRAULICS -- OFF", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "F/O:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 0,
		["actions"] = function ()
			kc_acf_hyd_pumps_onoff(0,0)
		end
	},
	[10] = {["activity"] = "NEXT SECURE AIRCRAFT CHECKLIST", ["wait"] = 1, ["interactive"] = 0, ["actor"] = "CPT:", ["validated"] = 0, ["chkl_color"] = color_white, ["end"] = 1
	}
}

-- SECURE
-- IRSs . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off
-- Emergency exit lights . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .OFF
-- Window heat . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off
-- Packs . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Off

-- function KC_SECURE_CHECKLIST() end
KC_SECURE_CHECKLIST = { ["name"] = "SECURE AIRCRAFT CHECKLIST (F/O)", ["mode"]="c", ["wnd_width1"] = 300,["wnd_width2"] = 350, ["wnd_height"] = 32*5, 
	[1] = { ["actor"] = "", ["chkl_item"] = "SECURE CHECKLIST", ["chkl_response"] = " ", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 0,
		["speak"] = function () return "" end,
		["answer"] = function () return "secure checklist" end
	},
	[2] = { ["actor"] = "CPT:", ["chkl_item"] = "IRS", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_irs_mode(0,0)
		end,
		["checks"] = function() return get("laminar/B738/toggle_switch/irs_left") == 0 and get("laminar/B738/toggle_switch/irs_right") == 0 end,		
		["answer"] = function () return "" end
	},
	[3] = { ["actor"] = "CPT:", ["chkl_item"] = "EMERGENCY EXIT LIGHTS", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_light_emer_mode(0)
		end,
		["checks"] = function() return true end,		
		["answer"] = function () return "" end
	},
	[4] = { ["actor"] = "CPT:", ["chkl_item"] = "WINDOW HEAT", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 3, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () 
			kc_acf_aice_window_heat_onoff(0,0)
		end,
		["checks"] = function() return get("laminar/B738/ice/window_heat_l_side_pos") == 0 and get("laminar/B738/ice/window_heat_l_fwd_pos") == 0 and get("laminar/B738/ice/window_heat_r_fwd_pos") and get("laminar/B738/ice/window_heat_r_side_pos") == 0 end,		
		["answer"] = function () return "" end
	},
	[5] = { ["actor"] = "CPT:", ["chkl_item"] = "PACKS", ["chkl_response"] = "OFF", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0,  ["wait"] = 2, ["interactive"] = 1, ["ask"] = 0, ["end"] = 0,
		["actions"] = function () kc_acf_air_packs_set(0,0) end,
		["checks"] = function () return kc_get_air_pack_mode(1) == 0 and kc_get_air_pack_mode(2) == 0 end,
		["answer"] = function () return "" end
	},
	[6] = { ["actor"] = "", ["chkl_item"] = "SECURE CHECKLIST", ["chkl_response"] = "COMPLETED", ["chkl_state"] = false, ["chkl_color"] = color_white, ["validated"] = 0, ["wait"] = 2, ["interactive"] = 0, ["ask"] = 0, ["end"] = 1,
		["speak"] = function () return "SECURE checklist completed" end,
		["answer"] = function () return "" end
	}
}


KC_PROCEDURES_DEFS = { KC_PREL_PREFLIGHT_PROC, KC_FLIGHT_PREPARATIONS, KC_PREFLIGHT_PROCEDURE, KC_PREFLIGHT_CHECKLIST,	KC_FLIGHT_BRIEFINGS, KC_BEFORE_START_PROC, KC_BEFORE_START_CHECKLIST, KC_STARTUP_AND_PUSH_PROC, KC_BEFORE_TAXI_CHECKLIST, KC_BEFORE_TAKEOFF_CHECKLIST, KC_ENTERING_RUNWAY_PROC, KC_TAKEOFF_CLIMB_PROCEDURE, KC_AFTER_TAKEOFF_CHECKLIST, KC_APPROACH_BRIEFINGS, KC_DESCEND_CHECKLIST, KC_APPROACH_CHECKLIST, KC_LANDING_PROC, KC_LANDING_CHECKLIST, KC_FINAL_PROC, KC_CLEANUP_PROC, KC_SHUTDOWN_PROC, KC_SHUTDOWN_CHECKLIST, KC_SECURE_AIRCRAFT_PROC, KC_SECURE_CHECKLIST, KC_TURN_AROUND_STATE, KC_COLD_AND_DARK }
KC_PROCEDURE_NAMES = { KC_PROCEDURES_DEFS[1]["name"], KC_PROCEDURES_DEFS[2]["name"], KC_PROCEDURES_DEFS[3]["name"], KC_PROCEDURES_DEFS[4]["name"], KC_PROCEDURES_DEFS[5]["name"], KC_PROCEDURES_DEFS[6]["name"], KC_PROCEDURES_DEFS[7]["name"], KC_PROCEDURES_DEFS[8]["name"], KC_PROCEDURES_DEFS[9]["name"], KC_PROCEDURES_DEFS[10]["name"], KC_PROCEDURES_DEFS[11]["name"], KC_PROCEDURES_DEFS[12]["name"], KC_PROCEDURES_DEFS[12]["name"], KC_PROCEDURES_DEFS[13]["name"], KC_PROCEDURES_DEFS[14]["name"], KC_PROCEDURES_DEFS[15]["name"], KC_PROCEDURES_DEFS[16]["name"], KC_PROCEDURES_DEFS[17]["name"], KC_PROCEDURES_DEFS[18]["name"], KC_PROCEDURES_DEFS[19]["name"], KC_PROCEDURES_DEFS[20]["name"], KC_PROCEDURES_DEFS[21]["name"], KC_PROCEDURES_DEFS[22]["name"], KC_PROCEDURES_DEFS[23]["name"], KC_PROCEDURES_DEFS[24]["name"], KC_PROCEDURES_DEFS[25]["name"] }

-- ============ Background procedures
-- function KC_BACKGROUND_PROCS()
KC_BACKGROUND_PROCS = {
	----- APU START
	["APUSTART"] = {["status"] = 0,
		["actions"] = function ()
			command_once("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			command_begin("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
			if kc_get_background_proc_status("APUSTART") > 1 then
				kc_set_background_proc_status("APUSTART",kc_get_background_proc_status("APUSTART")-1)
			end
			if kc_get_background_proc_status("APUSTART") == 1 then
				command_end("laminar/B738/spring_toggle_switch/APU_start_pos_dn")
				kc_set_background_proc_status("APUSTART",0)
			end
		end
	},
	-- Switches generators to APU when the blue APU light comes on
	["APUBUSON"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/electrical/apu_bus_enable") == 1 then
				kc_acf_elec_apu_on_bus(0,1)
				kc_acf_air_apu_bleed_onoff(1)
				kc_set_background_proc_status("APUBUSON",0)
				kc_acf_elec_gpu_stop()
			end
		end
	},
	-- Switches generators to APU when the blue APU light comes on
	["GPUBUSON"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/gpu_available") == 1 then
				command_once("laminar/B738/toggle_switch/gpu_dn")
				kc_set_background_proc_status("GPUBUSON",0)
			end
		end
	},

	----- ENGINE 1 START
	-- During startup wait for N2 to reach 25 and turn on fuel
	["N2ROTATION1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 5 then
				speakNoText(0,"N 2 rotation")
				kc_set_background_proc_status("N2ROTATION1",0)
				kc_set_background_proc_status("FUEL1IDLE",1)
			end
		end
	},
	["FUEL1IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 25.0 then
				kc_acf_fuel_lever_set(1,1)
				kc_set_background_proc_status("FUEL1IDLE",0)
				kc_set_background_proc_status("N2INCREASE1",1)
			end
		end
	},
	["N2INCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_1") > 30 then
				speakNoText(0,"N 2 increase")
				kc_set_background_proc_status("N2INCREASE1",0)
				kc_set_background_proc_status("N1ROTATION1",1)
			end
		end
	},
	["N1ROTATION1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_1") > 0.5 then
				speakNoText(0,"N 1 rotation")
				kc_set_background_proc_status("N1ROTATION1",0)
				kc_set_background_proc_status("N1INCREASE1",1)
			end
		end
	},
	["N1INCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_1") > 9 then
				speakNoText(0,"N 1 increase")
				kc_set_background_proc_status("N1INCREASE1",0)
				kc_set_background_proc_status("EGTINCREASE1",1)
			end
		end
	},
	["EGTINCREASE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng1_egt") > 300 then
				speakNoText(0,"e g t steadily increasing")
				kc_set_background_proc_status("EGTINCREASE1",0)
				kc_set_background_proc_status("OILPRESSURE1",1)
			end
		end
	},
	["OILPRESSURE1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng1_oil_press") > 3 then
				speakNoText(0,"oil pressure")
				kc_set_background_proc_status("OILPRESSURE1",0)
				kc_set_background_proc_status("STARTERCUT1",1)
			end
		end
	},
	["STARTERCUT1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/starter1_pos") == 1 then
				speakNoText(0,"Starter cutout")
				kc_set_background_proc_status("STARTERCUT1",0)
			end
		end
	},
	
	----- ENGINE 2 START
	["N2ROTATION2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 5 then
				speakNoText(0,"N 2 rotation")
				kc_set_background_proc_status("N2ROTATION2",0)
				kc_set_background_proc_status("FUEL2IDLE",1)
			end
		end
	},
	["FUEL2IDLE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 25.0 then
				kc_acf_fuel_lever_set(2,1)
				kc_set_background_proc_status("FUEL2IDLE",0)
				kc_set_background_proc_status("N2INCREASE2",1)
			end
		end
	},
	["N2INCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N2_percent_2") > 30 then
				speakNoText(0,"N 2 increase")
				kc_set_background_proc_status("N2INCREASE2",0)
				kc_set_background_proc_status("N1ROTATION2",1)
			end
		end
	},
	["N1ROTATION2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_2") > 0.5 then
				speakNoText(0,"N 1 rotation")
				kc_set_background_proc_status("N1ROTATION2",0)
				kc_set_background_proc_status("N1INCREASE2",1)
			end
		end
	},
	["N1INCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/indicators/N1_percent_2") > 9 then
				speakNoText(0,"N 1 increase")
				kc_set_background_proc_status("N1INCREASE2",0)
				kc_set_background_proc_status("EGTINCREASE2",1)
			end
		end
	},
	["EGTINCREASE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng2_egt") > 300 then
				speakNoText(0,"e g t steadily increasing")
				kc_set_background_proc_status("EGTINCREASE2",0)
				kc_set_background_proc_status("OILPRESSURE2",1)
			end
		end
	},
	["OILPRESSURE2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/eng2_oil_press") > 3 then
				speakNoText(0,"oil pressure")
				kc_set_background_proc_status("OILPRESSURE2",0)
				kc_set_background_proc_status("STARTERCUT2",1)
			end
		end
	},
	["STARTERCUT2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/engine/starter2_pos") == 1 then
				speakNoText(0,"Starter cutout")
				kc_set_background_proc_status("STARTERCUT2",0)
			end
		end
	},	

	-- TAKEOFF PROCEDURE
	["TAKEOFFRUN"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > 20.0 then
				-- activate 80 kts call
				kc_set_background_proc_status("TAKEOFFRUN",0)
				kc_set_background_proc_status("80KTS",1)
			end
		end
	},
	
	-- CALLOUTS
	["80KTS"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > 78.0 then
--				speakNoText(0,"80 knots")
				kc_set_background_proc_status("80KTS",0)
				kc_set_background_proc_status("V1",1)
				kc_set_background_proc_status("ROTATE",1)
			end
		end
	},
	-- during takeoff run call V speeds
	["V1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > kc_get_V1() then
--				speakNoText(0,"V one")
				kc_set_background_proc_status("V1",0)
			end
		end
	},
	["ROTATE"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/autopilot/airspeed") > kc_get_Vr() then
--				speakNoText(0,"rotate")
				kc_set_background_proc_status("ROTATE",0)
				kc_set_background_proc_status("APMODES",1)
				kc_set_background_proc_status("POSITIVERATE",1)
				kc_set_background_proc_status("GEARUP",1)
			end
		end
	},
	["APMODES"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 400 then
				if get_kpcrew_config("dep_ap_modes") == 1 then
					kc_acf_mcp_lnav_onoff(1)
					kc_acf_mcp_vnav_onoff(1)
				end
				if get_kpcrew_config("dep_ap_modes") == 2 then
					kc_acf_mcp_hdgsel_onoff(1)
					kc_acf_mcp_lvlchg_onoff(1)
				end
				kc_set_background_proc_status("APMODES",0)
			end
		end
	},
	["POSITIVERATE"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/tcas/targets/position/vertical_speed",0) > 150 then
				speakNoText(0,"positive rate")
				kc_set_background_proc_status("POSITIVERATE",0)
			end
		end
	},
	-- easy mode call for gear up at 200ft AGL
	["GEARUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 20 then
				kc_acf_gears(0)
				speakNoText(0,"gear up")
				kc_set_background_proc_status("GEARUP",0)
				kc_set_background_proc_status("FLAPSUPSCHED",1)
				kc_set_background_proc_status("GEAROFF",20)
			end
		end
	},
	-- Flapsup schedule
	["FLAPSUPSCHED"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/flightmodel/position/y_agl") > 50 then
				if get("laminar/B738/autopilot/airspeed") > get("laminar/B738/pfd/flaps_15") and 
					kc_get_controls_flaps_position() >= 15 then
					speakNoText(0,"SPEED CHECK   FLAPS 10")
					kc_acf_controls_flaps_set(10)
				end
				if get("laminar/B738/autopilot/airspeed") > get("laminar/B738/pfd/flaps_10") and 
					kc_get_controls_flaps_position() == 10 then
					speakNoText(0,"SPEED CHECK   FLAPS 5")
					kc_acf_controls_flaps_set(5)
				end
				if get("laminar/B738/autopilot/airspeed") > get("laminar/B738/pfd/flaps_5") and 
					kc_get_controls_flaps_position() == 5 then
					speakNoText(0,"SPEED CHECK   FLAPS 1")
					kc_acf_controls_flaps_set(1)
				end
				if get("laminar/B738/autopilot/airspeed") > get("laminar/B738/pfd/flaps_1") and 
					kc_get_controls_flaps_position() == 1 then
					speakNoText(0,"SPEED CHECK   FLAPS UP")
					kc_acf_controls_flaps_set(0)
					kc_set_background_proc_status("FLAPSUPSCHED",0)
					kc_set_background_proc_status("AFTERTAKEOFF",1)
				end
			end
		end
	},
	-- easy mode call for gear OFF
	["GEAROFF"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("GEAROFF",kc_get_background_proc_status("GEAROFF")-1)
			if kc_get_background_proc_status("GEAROFF") == 1 then
				kc_acf_gears(2)
				kc_set_background_proc_status("GEAROFF",0)
			end
		end
	},
	["AFTERTAKEOFF"] = {["status"] = 0,
		["actions"] = function ()
			kc_acf_eng_starter_mode(0,1)
			kc_acf_abrk_mode(1)
			kc_acf_air_bleeds_onoff(0,1)
			kc_acf_air_packs_set(0,1)
			kc_set_background_proc_status("AFTERTAKEOFF",0)
			kc_set_background_proc_status("TRANSALT",1)
			kc_set_background_proc_status("TENTHOUSANDUP",1)
		end
	},
	-- On reaching Transition altitude switch to STD
	["TRANSALT"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > get("laminar/B738/FMS/fmc_trans_alt") then
				speakNoText(0,"Transition altitude")
				kc_acf_efis_baro_std_set(0,1)
				kc_set_background_proc_status("TRANSALT",0)
			end
		end
	},
	-- during climb reach 10.000 ft
	["TENTHOUSANDUP"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") > 10000.0 then
				speakNoText(0,"ten thousand")
				kc_acf_light_landing_mode(1,0)
				kc_acf_light_rwyto_mode(0)
				kc_set_background_proc_status("TENTHOUSANDUP",0)
			end
		end
	},


	------ DESCEND & LANDING
	-- On reaching transition level during descend switch away from STD
	["TRANSLVL"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") < get("laminar/B738/FMS/fmc_trans_lvl") then
				speakNoText(0,"Transition level")
				kc_acf_efis_baro_std_set(0,0)
				kc_set_background_proc_status("TRANSLVL",0)
			end
		end
	},
	-- during climb reach 10.000 ft
	["TENTHOUSANDDN"] = {["status"] = 0,
		["actions"] = function ()
			if get("sim/cockpit2/gauges/indicators/altitude_ft_pilot") <= 10000.0 then
				speakNoText(0,"ten thousand")
				kc_acf_light_landing_mode(1,1)
				kc_set_background_proc_status("TENTHOUSANDDN",0)
			end
		end
	},
	
	-- TESTS
	["FIRETESTLEFTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("FIRETESTLEFTSTOP",kc_get_background_proc_status("FIRETESTLEFTSTOP")-1)
			if kc_get_background_proc_status("FIRETESTLEFTSTOP") == 1 then
				command_end("laminar/B738/toggle_switch/fire_test_lft")
				command_begin("laminar/B738/toggle_switch/fire_test_rgt")
				kc_set_background_proc_status("FIRETESTLEFTSTOP",0)
				kc_set_background_proc_status("FIRETESTRGTSTOP",4)
			end
		end
	},
	["FIRETESTRGTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("FIRETESTRGTSTOP",kc_get_background_proc_status("FIRETESTRGTSTOP")-1)
			if kc_get_background_proc_status("FIRETESTRGTSTOP") == 1 then
				command_end("laminar/B738/toggle_switch/fire_test_rgt")
				command_begin("laminar/B738/toggle_switch/exting_test_lft")
				kc_set_background_proc_status("FIRETESTRGTSTOP",0)
				kc_set_background_proc_status("EXTINGSTOP",4)
			end
		end
	},
	["EXTINGSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("EXTINGSTOP",kc_get_background_proc_status("EXTINGSTOP")-1)
			if kc_get_background_proc_status("EXTINGSTOP") == 1 then
				command_end("laminar/B738/toggle_switch/exting_test_lft")
				command_begin("laminar/B738/push_button/cargo_fire_test_push")
				kc_set_background_proc_status("EXTINGSTOP",0)
				kc_set_background_proc_status("CARGOFIRESTOP",4)
			end
		end
	},
	["CARGOFIRESTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("CARGOFIRESTOP",kc_get_background_proc_status("CARGOFIRESTOP")-1)
			if kc_get_background_proc_status("CARGOFIRESTOP") == 1 then
				command_end("laminar/B738/push_button/cargo_fire_test_push")
				kc_set_background_proc_status("CARGOFIRESTOP",0)
			end
		end
	},
	["MACH1TESTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("MACH1TESTSTOP",kc_get_background_proc_status("MACH1TESTSTOP")-1)
			if kc_get_background_proc_status("MACH1TESTSTOP") == 1 then
				command_end("laminar/B738/push_button/mach_warn1_test")
				command_begin("laminar/B738/push_button/mach_warn2_test")
				kc_set_background_proc_status("MACH1TESTSTOP",0)
				kc_set_background_proc_status("MACH2TESTSTOP",4)
			end
		end
	},
	["MACH2TESTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("MACH2TESTSTOP",kc_get_background_proc_status("MACH2TESTSTOP")-1)
			if kc_get_background_proc_status("MACH2TESTSTOP") == 1 then
				command_end("laminar/B738/push_button/mach_warn2_test")
				kc_set_background_proc_status("MACH2TESTSTOP",0)
			end
		end
	},
	["STALL1TESTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("STALL1TESTSTOP",kc_get_background_proc_status("STALL1TESTSTOP")-1)
			if kc_get_background_proc_status("STALL1TESTSTOP") == 1 then
				command_end("laminar/B738/push_button/stall_test1_press")
				command_begin("laminar/B738/push_button/stall_test2_press")
				kc_set_background_proc_status("STALL1TESTSTOP",0)
				kc_set_background_proc_status("STALL2TESTSTOP",4)
			end
		end
	},
	["STALL2TESTSTOP"] = {["status"] = 0,
		["actions"] = function ()
			kc_set_background_proc_status("STALL2TESTSTOP",kc_get_background_proc_status("STALL2TESTSTOP")-1)
			if kc_get_background_proc_status("STALL2TESTSTOP") == 1 then
				command_end("laminar/B738/push_button/stall_test2_press")
				kc_set_background_proc_status("STALL2TESTSTOP",0)
			end
		end
	},	
	
	----- Flight Control Check
	["FLIGHTCTRLELEV1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/pitch") > 0.95 then
				speakNoText(0,"Elevator Full Up")
				kc_set_background_proc_status("FLIGHTCTRLELEV1",0)
				kc_set_background_proc_status("FLIGHTCTRLELEV2",1)
			end
		end
	},	
	["FLIGHTCTRLELEV2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/pitch",0) < -0.95 then
				speakNoText(0,"Full Down")
				kc_set_background_proc_status("FLIGHTCTRLELEV2",0)
				kc_set_background_proc_status("FLIGHTCTRLELEV3",1)
			end
		end
	},	
	["FLIGHTCTRLELEV3"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/pitch") > -0.05 and get("laminar/B738/axis/pitch") < 0.05 then
				speakNoText(0,"Neutral")
				kc_set_background_proc_status("FLIGHTCTRLELEV3",0)
			end
		end
	},	
	["FLIGHTCTRLAIL1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/roll") < -0.95 then
				speakNoText(0,"Aileron Full Left")
				kc_set_background_proc_status("FLIGHTCTRLAIL1",0)
				kc_set_background_proc_status("FLIGHTCTRLAIL2",1)
			end
		end
	},	
	["FLIGHTCTRLAIL2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/roll") > 0.95 then
				speakNoText(0,"Full Right")
				kc_set_background_proc_status("FLIGHTCTRLAIL2",0)
				kc_set_background_proc_status("FLIGHTCTRLAIL3",1)
			end
		end
	},	
	["FLIGHTCTRLAIL3"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/roll") > -0.05 and get("laminar/B738/axis/roll") < 0.05 then
				speakNoText(0,"Neutral")
				kc_set_background_proc_status("FLIGHTCTRLAIL3",0)
			end
		end
	},	
	["FLIGHTCTRLRUD1"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/heading") < -0.95 then
				speakNoText(0,"Rudder Full Left")
				kc_set_background_proc_status("FLIGHTCTRLRUD1",0)
				kc_set_background_proc_status("FLIGHTCTRLRUD2",1)
			end
		end
	},	
	["FLIGHTCTRLRUD2"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/heading") > 0.95 then
				speakNoText(0,"Full Right")
				kc_set_background_proc_status("FLIGHTCTRLRUD2",0)
				kc_set_background_proc_status("FLIGHTCTRLRUD3",1)
			end
		end
	},	
	["FLIGHTCTRLRUD3"] = {["status"] = 0,
		["actions"] = function ()
			if get("laminar/B738/axis/heading") > -0.05 and get("laminar/B738/axis/heading") < 0.05 then
				speakNoText(0,"Neutral")
				kc_set_background_proc_status("FLIGHTCTRLRUD3",0)
			end
		end
	},	
	["APDISCONNECT1"] = {["status"] = 0,
		["actions"] = function ()
			kc_acf_mcp_ap_disconnect()
			kc_set_background_proc_status("APDISCONNECT1",0)
			kc_set_background_proc_status("APDISCONNECT2",1)
		end
	},	
	["APDISCONNECT2"] = {["status"] = 0,
		["actions"] = function ()
			kc_acf_mcp_ap_disconnect()
			kc_set_background_proc_status("APDISCONNECT2",0)
		end
	},	
	
	-- Open Briefing Windows & not aircraft specific functions
	["OPENINFOWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			kc_init_flightinfo_window()
			kc_set_background_proc_status("OPENINFOWINDOW",0)
		end
	},
	["OPENCHKLWINDOW"] = {["status"] = 0, 
		["actions"] = function ()
			kc_open_checklist(gActiveChecklist,true)
			kc_set_background_proc_status("OPENCHKLWINDOW",0)
		end
	},
	["OPENPROCWINDOW"] = {["status"] = 0,  
		["actions"] = function ()
			kc_open_procedure(gActiveChecklist,true)
			kc_set_background_proc_status("OPENPROCWINDOW",0)
		end
	},
	["REOPENCHKLWINDOW"] = {["status"] = 0,
		["actions"] = function ()
			kc_open_checklist(gActiveChecklist,false)
			kc_set_background_proc_status("REOPENCHKLWINDOW",0)
		end
	},
	["CLOSECHKLWINDOW"] = {["status"] = 0, 
		["actions"] = function ()
			kc_destroy_checklist_wnd()
			kc_set_background_proc_status("CLOSECHKLWINDOW",0)
		end
	}
}

-- ============= aircraft specific status functions 

-- get parking stand from aircraft or taxi briefings
function kc_get_parking_position()
	return get_kpcrew_config("flight_parkpos")
end

-- get V1 from aircraft or takeoff briefing 
function kc_get_V1()
	return get("laminar/B738/FMS/v1_set")
end

-- get rotation speed from aircraft or takeoff briefing
function kc_get_Vr()
	return get("laminar/B738/FMS/vr_set")
end

-- Get V2 from from aircraft or takeoff briefing
function kc_get_V2()
	return get("laminar/B738/FMS/v2_set")
end

-- get Vref from aircraft or approach briefing
function kc_get_Vref()
	return get("laminar/B738/FMS/approach_speed")
end

-- get Vapp from aircraft or approach briefing
function kc_get_Vapp()
	return kc_get_Vref()+5
end

-- get calculated takeoff trim from aircraft or takeoff briefing
function kc_get_takeoff_elev_trim()
	return get("laminar/B738/FMS/trim_calc")
end

-- get takeoff flap from aircraft or takeoff briefing
function kc_get_takeoff_flaps()
	return get("laminar/B738/FMS/takeoff_flaps")
end

-- get runway course from aircraft or takeoff briefing
function kc_get_takeoff_rwy_crs()
	return math.ceil(get("laminar/B738/fms/ref_runway_crs"))
end

-- get transition level from aircraft or departure briefing
function kc_get_transition_altitude()
	return get("laminar/B738/FMS/fmc_trans_alt")
end

-- get transition level from aircraft or departure briefing
function kc_get_transition_level()
	return get("laminar/B738/FMS/fmc_trans_lvl")
end

-- get approach runway ILS from aircraft or approach briefing
function kc_get_ils_rwy_name()
	return get_kpcrew_config("arr_rwy")
end

-- get destination icao from aircraft or approach briefing
function kc_get_destination_icao()
	return get("laminar/B738/fms/dest_icao")
end

-- get destination runway altitude from aircraft or approach briefing
function kc_get_dest_runway_alt()
	return get("laminar/B738/fms/dest_runway_alt")
end

-- get destination runway course from aircraft or approach briefing
function kc_get_dest_runway_crs()
	return get("laminar/B738/fms/dest_runway_crs")
end

-- get destination runway length from aircraft or approach briefing
function kc_get_dest_runway_len()
	return get("laminar/B738/fms/dest_runway_len")
end

-- get takeoff flap from aircraft or takeoff briefing
function kc_get_landing_flaps()
	return get("laminar/B738/FMS/approach_flaps")
end

-- generic getters

-- return total fuel loaded from aircraft or x-plane
function kc_get_total_fuel()
	if get_kpcrew_config("config_kglbs") then
		return get(kc_total_fuel_kgs_dataref)
	else
		return get(kc_total_fuel_lbs_dataref)
	end
end

-- return gross weight frm aircraft or x-plane
function kc_get_gross_weight()
	if get_kpcrew_config("config_kglbs") then
		return get("sim/flightmodel/weight/m_total")
	else
		return get("sim/flightmodel/weight/m_total")*2.20462262
	end	
end

-- return zero fuel weight from aircraft or x-plane
function kc_get_zfw()
	return kc_get_gross_weight()-kc_get_total_fuel()
end

-- get flaps position from aircraft or x-plane translate to readable position
function kc_get_controls_flaps_position()
	lv_flaplever = get(kc_flaps_position_dataref)
	return kc_flaps_position_aircraft[lv_flaplever]
end

-- get abrk setting from aircraft or x-plane
function kc_get_controls_autobrake_mode()
	lv_abrk = get(kc_autobrake_position_dataref)
	return kc_autobrake_setting_aircraft[lv_abrk]
end

-- get parking brake mode
function kc_get_controls_parkbrake_mode()
	return get("sim/cockpit2/controls/parking_brake_ratio")
end

-- get speed brake lever position 0=down .. 1=fully up
function kc_get_controls_speedbrake_pos()
	return get("laminar/B738/flt_ctrls/speedbrake_lever")
end

-- get yaw damper mode 
function kc_get_controls_yawdamper_mode()
	return get("laminar/B738/toggle_switch/yaw_dumper_pos")
end

-- window heat switches switch 1..4
function kc_get_aice_window_heat_mode(heater)
	if heater == 1 then return get("laminar/B738/ice/window_heat_l_side_pos") end
	if heater == 2 then return get("laminar/B738/ice/window_heat_l_fwd_pos") end
	if heater == 3 then return get("laminar/B738/ice/window_heat_r_fwd_pos") end 
	if heater == 4 then return get("laminar/B738/ice/window_heat_r_side_pos") end
	return 0
end

-- hydraukic pump switches switch 1=ENG1, 2=ENG2, 3=ELEC1, 4=ELEC2
function kc_get_systems_hydpumps_mode(pump)
	if pump == 1 then return get("laminar/B738/toggle_switch/hydro_pumps1_pos") end
	if pump == 2 then return get("laminar/B738/toggle_switch/hydro_pumps2_pos") end
	if pump == 3 then return get("laminar/B738/toggle_switch/electric_hydro_pumps1_pos") end 
	if pump == 4 then return get("laminar/B738/toggle_switch/electric_hydro_pumps2_pos") end
	return 0
end

-- get transponder setting from aircraft or x-plane
function kc_get_systems_transponder_mode()
	lv_xpdr = get(kc_transponder_position_dataref)
	return kc_transponder_setting_aircraft[lv_xpdr]
end

-- get daylight 0=dark 1=bright
function kc_get_daylight()
	if get("sim/private/stats/skyc/sun_amb_b") < 0.02 then
		return 0
	else
		return 1
	end
end

-- pack switches mode 1=left 2=right
function kc_get_air_pack_mode(pack)
	if pack == 1 then return get("laminar/B738/air/l_pack_pos") end
	if pack == 2 then return get("laminar/B738/air/r_pack_pos") end
	return 0
end

-- get recirc/cabin fans mode 1=left 2=right
function kc_get_air_recirc_fan_mode(fan)
	if fan == 1 then return get("laminar/B738/air/l_recirc_fan_pos") end
	if fan == 2 then return get("laminar/B738/air/r_recirc_fan_pos") end
	return 0
end

-- get trimair / ramair mode
function kc_get_air_trimair_mode()
	return get("laminar/B738/air/trim_air_pos")
end

-- emergency exit lights status 0=off 1=on
function kc_get_light_emerexit_mode()
	return get("laminar/B738/toggle_switch/emer_exit_lights")
end

-- seatbelt signs status
function kc_get_light_seatbelts_mode()
	return get("laminar/B738/toggle_switch/seatbelt_sign_pos")
end

-- no smoking signs status
function kc_get_light_nosmoking_mode()
	return get("laminar/B738/toggle_switch/no_smoking_pos")
end

-- get beacon light status 0=off 1=on
function kc_get_light_beacon_mode()
	return get("sim/cockpit/electrical/beacon_lights_on")
end

-- get logo light status 0=off 1=on
function kc_get_light_logo_mode()
	return get("laminar/B738/toggle_switch/logo_light")
end

-- get taxi light status 0=off 1=dim 2=bright
function kc_get_light_taxi_mode()
	return get("laminar/B738/toggle_switch/taxi_light_brightness_pos")
end
 
-- ========================= aircraft specific action functions
----------------- Electric system

-- Bring APU completely online
function kc_acf_elec_apu_activate()
	if get("sim/cockpit/engine/APU_N1") < 0.1 then
		kc_set_background_proc_status("APUSTART",8)
		kc_set_background_proc_status("APUBUSON",1)
	end
end

-- Start APU
function kc_acf_elec_apu_start()
	KC_BACKGROUND_PROCS["APUSTART"].status = 7
end

-- Stop APU
function kc_acf_elec_apu_stop()
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")	
end

-- APU on bus; bus 0=all, 1=left 2=right
function kc_acf_elec_apu_on_bus(bus, onoff)
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
function kc_acf_elec_gpu_start()
	if get("laminar/B738/gpu_available") == 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
	end
	kc_set_background_proc_status("GPUBUSON",1)
end

-- stop APU 
function kc_acf_elec_gpu_stop()
	if get("laminar/B738/gpu_available") > 0 then
		command_once("laminar/B738/tab/home")
		command_once("laminar/B738/tab/menu6")
		command_once("laminar/B738/tab/menu1")
		command_once("laminar/B738/toggle_switch/gpu_up")
	end
end

-- GENerators 0=ALL,1=GEN1,2=GEN2; 0=OFF,1=ON Bus
function kc_acf_elec_gen_on_bus(gen,mode)
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
function kc_acf_elec_battery_onoff(mode)
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

-- Cabin power 0=OFF 1=ON
function kc_acf_elec_cabin_power(mode)
	set("laminar/B738/toggle_switch/cab_util_pos",mode)
end

-- InFlight Entertainment 0=OFF 1=ON
function kc_acf_elec_ife_power(mode)
	set("laminar/B738/toggle_switch/ife_pass_seat_pos",mode)
end

-- Standby Power 0=OFF 1=ON
function kc_acf_elec_stby_power(mode)
	if mode == 0 then
		set("laminar/B738/electric/standby_bat_pos",0)
		if get("laminar/B738/button_switch/cover_position",3) == 0 then
				command_once("laminar/B738/button_switch_cover03")
		end
	else
		set("laminar/B738/electric/standby_bat_pos",1)
		if get("laminar/B738/button_switch/cover_position",3) == 1 then
				command_once("laminar/B738/button_switch_cover03")
		end
	end
end

--- Fuel system

-- Fuel pumps 0=all, 1=lft1, 2=lft2, 3=rgt1, 4=rgt2, 5=ctr1, 6=ctr2
function kc_acf_fuel_pumps_onoff(pump,mode)
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
function kc_acf_fuel_xfeed_mode(mode)
	if mode == 0 then
		command_once("laminar/B738/toggle_switch/crossfeed_valve_off")
	else
		command_once("laminar/B738/toggle_switch/crossfeed_valve_on")
	end
end

--- Hydraulic system

-- Set hydraulic pumps, pump 0=ALL, 1=ENG1, 2=ENG2, 3=ELEC1, 4=ELEC2
function kc_acf_hyd_pumps_onoff(pump,mode)
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
function kc_acf_fuel_lever_set(lever,mode)
	if lever == 0 or lever == 1 then
		set("laminar/B738/engine/mixture_ratio1",mode)
	end
	if lever == 0 or lever == 2 then
		set("laminar/B738/engine/mixture_ratio2",mode)
	end
end

-- Engine starter knobs 0=ALL,1,2 0=START GRD,1=OFF,2=CONT,3=FLT
function kc_acf_eng_starter_mode(starter,mode)
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
function kc_acf_air_packs_set(pack, mode)
	if pack == 0 or pack == 1 then
		set("laminar/B738/air/l_pack_pos",mode)
	end
	if pack == 0 or pack == 2 then
		set("laminar/B738/air/r_pack_pos",mode)
	end
end

-- Bleeds bleed 0=ALL,1=LEFT,2=RIGHT  0=OFF, 1=ON
function kc_acf_air_bleeds_onoff(bleed,mode)
	if bleed == 0 or bleed == 1 then
		set("laminar/B738/toggle_switch/bleed_air_1_pos",mode)
	end
	if bleed == 0 or bleed == 2 then
		set("laminar/B738/toggle_switch/bleed_air_2_pos",mode)
	end
end

-- cross bleed isolation 0=CLOSE,1=AUTO,2=OPEN		
function kc_acf_air_xbleed_isol_mode(mode)
	set("laminar/B738/air/isolation_valve_pos",mode)
end

-- APU Bleed air 0=OFF 1=ON
function kc_acf_air_apu_bleed_onoff(mode)
	set("laminar/B738/toggle_switch/bleed_air_apu_pos",mode)
end

-- Temperature control area 0=ALL,1=CONT,2=FWD CAB,3=AFT CAB level 0..1
function kc_acf_air_temp_control(area,level)
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
function kc_acf_air_recirc_fans_onoff(fan,mode)
	if fan == 0 or fan == 1 then
		set("laminar/B738/air/l_recirc_fan_pos",mode)
	end
	if fan == 0 or fan == 2 then
		set("laminar/B738/air/r_recirc_fan_pos",mode)
	end
end

-- Air valves 0=AUTO, 1=ALTN, 2=MAN
function kc_acf_air_valve(mode)
	set("laminar/B738/toggle_switch/air_valve_ctrl",mode)
end

-- Landing altitude in ft 
function kc_acf_set_landing_altitude(altitude)
	set("laminar/B738/pressurization/knobs/landing_alt",altitude)
end

-- set flight altitude (B737)
function kc_acf_set_flight_altitude(altitude)
	set("sim/cockpit/pressure/max_allowable_altitude",altitude)
end

--- A/ICE

-- Window heat Heater 0=All, 1-4, 0=OFF 1=ON
function kc_acf_aice_window_heat_onoff(heater,mode)
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
function kc_acf_aice_wing_onoff(mode)
	set("laminar/B738/ice/wing_heat_pos",mode)
end

-- engine anti-ice 0=OFF 1=ON
function kc_acf_aice_eng_onoff(eng,mode)
	if eng == 0 or eng == 1 then
		set("laminar/B738/ice/eng1_heat_pos",mode)
	end
	if eng == 0 or eng == 2 then
		set("laminar/B738/ice/eng2_heat_pos",mode)
	end
end

-- probe heat heater 0=ALL 1=left 2=right; mode 0=OFF, 1=ON
function kc_acf_aice_probe_heat_onoff(heater,mode)
	if heater == 0 or heater == 1 then
		set("laminar/B738/toggle_switch/capt_probes_pos",mode)
	end
	if heater == 0 or heater == 2 then
		set("laminar/B738/toggle_switch/fo_probes_pos",mode)
	end
end

--- Flight controls

-- position=0,1,2,5,10,15,25,30,40
function kc_acf_controls_flaps_set(position)
	command_once(kc_flaps_set_commands[position])
end

-- increase/decrease flaps
function kc_acf_controls_flaps_inc()
	command_once("sim/flight_controls/flaps_down")
end

function kc_acf_controls_flaps_dec()
	command_once("sim/flight_controls/flaps_up")
end

-- Speedbrake 0=UP, 1=ARMED, 2=FULL
function kc_acf_speed_break_set(position)
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

-- Parking brake 0=OFF 1=ON 2=TGL
function kc_acf_parking_break_mode(mode)
	if mode ~= 2 then
		set("sim/cockpit2/controls/parking_brake_ratio",mode)
	else
		if get("sim/cockpit2/controls/parking_brake_ratio") == 0 then
			set("sim/cockpit2/controls/parking_brake_ratio",1)
		else
			set("sim/cockpit2/controls/parking_brake_ratio",0)
		end
	end
end

-- Parking brake 0=OFF 1=ON 2=TGL
function kc_acf_chocks_mode(mode)
	if mode ~= 2 then
		set("laminar/B738/fms/chock_status",mode)
	else
		if get("laminar/B738/fms/chock_status") == 0 then
			set("laminar/B738/fms/chock_status",1)
		else
			set("laminar/B738/fms/chock_status",0)
		end
	end
end

-- Auto Brake 0=RTO, 1=OFF, 2=1, 3=2, 4=3 5=MAX
function kc_acf_abrk_mode(mode)
	command_once(kc_autobrake_set_commands[mode])
end

-- Set elevator trim to value
function kc_acf_elev_trim_set(value)
	set("sim/flightmodel2/controls/elevator_trim",(8.2 - value) * -0.119)
end
function kc_acf_elev_trim_get()
	return 8.2-(get("sim/flightmodel2/controls/elevator_trim")/-0.119)
end

function kc_acf_elev_trim_dn()
	command_once("laminar/B738/flight_controls/pitch_trim_down")
end
function kc_acf_elev_trim_up()
	command_once("laminar/B738/flight_controls/pitch_trim_up")
end

-- set aileron trim
function kc_acf_aileron_trim_set(value)
	set("sim/cockpit2/controls/aileron_trim",value)
end

-- set rudder trim
function kc_acf_rudder_trim_set(value)
	set("sim/cockpit2/controls/rudder_trim",value)
end

-- Set Yaw Damper
function kc_acf_yaw_damper_onoff(mode)
	set("laminar/B738/toggle_switch/yaw_dumper_pos",mode)
end

--- LIGHTS

-- dome lights 0=off, 1=on, 2=tgl
function kc_acf_light_cockpit_mode(mode)
	if mode == 0 and get("laminar/B738/toggle_switch/cockpit_dome_pos") ~= 0 then
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_up")
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	end
	if mode == 1 and get("laminar/B738/toggle_switch/cockpit_dome_pos") == 0 then
		command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
	end
	if mode == 2 then 
	  if get("laminar/B738/toggle_switch/cockpit_dome_pos") == 0 then
			command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
		else
			command_once("laminar/B738/toggle_switch/cockpit_dome_up")
			command_once("laminar/B738/toggle_switch/cockpit_dome_up")
			command_once("laminar/B738/toggle_switch/cockpit_dome_dn")
		end
	end
end

-- Strobe lighs 0=off 1=on with poslight 2=position light only
function kc_acf_light_strobe_mode(mode)
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
function kc_acf_light_nav_mode(mode)
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

-- Beacon lights 0=off 1=on 2=tgl
function kc_acf_light_beacon_mode(mode)
	if mode == 0 then
		command_once("sim/lights/beacon_lights_off")
	end
	if mode == 1 then
		command_once("sim/lights/beacon_lights_on")
	end
	if mode == 2 then
		if kc_get_light_beacon_mode() == 1 then
			command_once("sim/lights/beacon_lights_off")
		else
			command_once("sim/lights/beacon_lights_on")
		end
	end
end

-- Wing Light 0=OFF 1=ON
function kc_acf_light_wing_mode(mode)
	if mode == 1 then
		command_once("laminar/B738/switch/wing_light_on")
	else
		command_once("laminar/B738/switch/wing_light_off")
	end
end

-- Wheel Well Light 0=OFF 1=ON
function kc_acf_light_wheel_mode(mode)
	if mode == 1 then
		command_once("laminar/B738/switch/wheel_light_on")
	else
		command_once("laminar/B738/switch/wheel_light_off")
	end
end

-- Logo lights 0=OFF 1=ON 2=toggle
function kc_acf_light_logo_mode(mode)
	if mode == 1 then
		command_once("laminar/B738/switch/logo_light_on")
	end
	if mode == 0 then
		command_once("laminar/B738/switch/logo_light_off")
	end
	if mode == 2 then
		if kc_get_light_logo_mode() == 0 then
			command_once("laminar/B738/switch/logo_light_on")
		else
			command_once("laminar/B738/switch/logo_light_off")
		end
	end
end

-- RWY turnoff lights both 0=OFF 1=ON 2=TGL
function kc_acf_light_rwyto_mode(mode)
	if mode == 0 then 
		command_once("laminar/B738/switch/rwy_light_left_off")
		command_once("laminar/B738/switch/rwy_light_right_off")
	end
	if mode == 1 then 
		command_once("laminar/B738/switch/rwy_light_left_on")
		command_once("laminar/B738/switch/rwy_light_right_on")
	end
	if mode == 2 then 
		command_once("laminar/B738/switch/rwy_light_left_toggle")
		command_once("laminar/B738/switch/rwy_light_right_toggle")
	end
end

-- taxi lights 0=OFF 1=LOW 2=HIGH 3=toggle high
function kc_acf_light_taxi_mode(mode)
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
	if mode == 3 then
		if kc_get_light_taxi_mode() < 2 then
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_up")
		else
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
			command_once("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn")
		end
	end
	
end

-- Landing Lights 0=ALL,1=FIXED,2=RET, 3=RETLEFT, 4=RETRIGHT, 5=LEFT, 6=RIGHT
-- Mode 0=OFF, 1=ON, 2=EXTEND RETs
function kc_acf_light_landing_mode(light,mode)
	if light == 0 or light == 1 or light == 5 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_left_off")
			set("laminar/B738/switch/land_lights_left_pos",0)
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_left_on")
			set("laminar/B738/switch/land_lights_left_pos",1)
		end
	end
	if light == 0 or light == 1 or light == 6 then
		if mode == 0 then
			command_once("laminar/B738/switch/land_lights_right_off")
			set("laminar/B738/switch/land_lights_right_pos",0)
		end
		if mode == 1 then
			command_once("laminar/B738/switch/land_lights_right_on")
			set("laminar/B738/switch/land_lights_right_pos",1)
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

-- general panel brightness light=0..9, value=0..1
function kc_acf_light_panel(light,value)
	set_array("laminar/B738/electric/panel_brightness",light,value)
end

-- emergency lights 0=OFF,1=ARMED,2=ON
function kc_acf_light_emer_mode(mode)
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
		if kc_get_light_emerexit_mode() == 0 then
			command_once("laminar/B738/toggle_switch/emer_exit_lights_dn")
		end
		if kc_get_light_emerexit_mode() == 2 then
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
function kc_acf_seatbelt_onoff(mode)
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
function kc_acf_no_smoking_onoff(mode)
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

-- FD 0=BOTH, 1=LEFT, 2=RIGHT; mode 0=OFF,1=ON,2=toggle
function kc_acf_mcp_fds_set(fd, mode)
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
	end
	if mode == 1 then
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
	if mode == 2 then
		if fd == 0 or fd == 1 then
			command_once("laminar/B738/autopilot/flight_director_toggle")
		end
		if fd == 0 or fd == 2 then
			command_once("laminar/B738/autopilot/flight_director_fo_toggle")
		end
	end
end
			

-- MCP set speed
function kc_acf_mcp_spd_set(value)
	set("laminar/B738/autopilot/mcp_speed_dial_kts_mach",value)
end

-- MCP set altitude
function kc_acf_mcp_alt_set(value)
	set("laminar/B738/autopilot/mcp_alt_dial",value)
end

-- MCP set heading
function kc_acf_mcp_hdg_set(value)
	set("laminar/B738/autopilot/mcp_hdg_dial",value)
end

-- MCP course 0=all 1=CRS1, 2=CRS2, value
function kc_acf_mcp_crs_set(nav,value)
	if nav == 0 or nav == 1 then
		set("laminar/B738/autopilot/course_pilot",value)
	end
	if nav == 0 or nav == 2 then
		set("laminar/B738/autopilot/course_copilot",value)
	end
end

-- MCP vertical Speed value
function kc_acf_mcp_vs_set(value)
	set("sim/cockpit2/autopilot/vvi_dial_fpm",value)
end

-- Set CMD A or B ap 0=ALL 1=CMDA 2=CMDB, mode 0=OFF 1=ON, 2=toggle
function kc_acf_mcp_ap_set(ap, mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/autopilot/cmd_a_press")
		else
			if get("laminar/B738/autopilot/cmd_a_status") ~= mode then
				command_once("laminar/B738/autopilot/cmd_a_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/autopilot/cmd_b_press")
		else
			if get("laminar/B738/autopilot/cmd_b_status") ~= mode then
				command_once("laminar/B738/autopilot/cmd_b_press")
			end
		end
	end
end

-- Set IRS switches 0=OFF, 1=ALIGN, 2=NAV, 3=ATT
function kc_acf_irs_mode(unit,mode)
	if (unit == 0 or unit == 1) then
		set("laminar/B738/toggle_switch/irs_left",mode)
	end
	if (unit == 0 or unit == 2) then
		set("laminar/B738/toggle_switch/irs_right",mode)
	end
end

-- Transponder mode 0=TEST, 1=STBY, 2=ALT OFF, 3=ALT ON, 4=TA, 5=TARA
function kc_acf_xpdr_mode(mode)
	command_once(kc_transponder_set_commands[mode])
end

-- set transponder code
function kc_acf_xpdr_code_set(code)
	set("sim/cockpit/radios/transponder_code",code)
end

-- Reset elapsed timer 0=ALL, 1=CAPT, 2=FO
function kc_acf_et_timer_reset(timer)
	if get("sim/cockpit2/clock_timer/timer_running") == 0 then 
		command_once("sim/instruments/timer_reset")
	end
	if timer == 0 or timer == 1 then
		command_once("laminar/B738/push_button/et_reset_capt")
	end
	if timer == 0 or timer == 2 then
		command_once("laminar/B738/push_button/et_reset_fo")
	end
end

-- Start/Stop ET timer
function kc_acf_et_timer_startstop(timer)
	command_once("sim/instruments/timer_start_stop")
	if timer == 0 or timer == 1 then
		command_once("laminar/B738/push_button/chrono_capt_et_mode")
	end
	if timer == 0 or timer == 2 then
		command_once("laminar/B738/push_button/chrono_fo_et_mode")
	end
end

function kc_acf_get_elapsed_seconds()
	return get("sim/time/timer_elapsed_time_sec")
end

-- AP Disconnect button mode 0=OFF, 1=ON
function kc_acf_mcp_ap_dis_bar_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/disconnect_pos") == 1 then
		command_once("laminar/B738/autopilot/disconnect_button")
	end
	if mode == 1 and get("laminar/B738/autopilot/disconnect_pos") == 0 then
		command_once("laminar/B738/autopilot/disconnect_button")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/disconnect_button")
	end
end

-- ALT intervention 
function kc_acf_mcp_alt_intv()
	command_once("laminar/B738/autopilot/alt_interv")
end

-- speed intervention
function kc_acf_mcp_spd_intv()
	command_once("laminar/B738/autopilot/spd_interv")
end

-- LNAV 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_lnav_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/lnav_status") == 1 then
		command_once("laminar/B738/autopilot/lnav_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/lnav_status") == 0 then
		command_once("laminar/B738/autopilot/lnav_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/lnav_press")
	end
end

-- VNAV 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_vnav_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/vnav_status1") == 1 then
		command_once("laminar/B738/autopilot/vnav_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/vnav_status1") == 0 then
		command_once("laminar/B738/autopilot/vnav_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/vnav_press")
	end
end

-- VS 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_vs_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/vs_status") == 1 then
		command_once("laminar/B738/autopilot/vs_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/vs_status") == 0 then
		command_once("laminar/B738/autopilot/vs_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/vs_press")
	end
end

-- APP 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_app_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/app_status") == 1 then
		command_once("laminar/B738/autopilot/app_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/app_status") == 0 then
		command_once("laminar/B738/autopilot/app_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/app_press")
	end
end

-- ALT HLD 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_althld_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/alt_hld_status") == 1 then
		command_once("laminar/B738/autopilot/alt_hld_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/alt_hld_status") == 0 then
		command_once("laminar/B738/autopilot/alt_hld_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/alt_hld_press")
	end
end

-- VOR LOC 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_vorloc_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/vorloc_status") == 1 then
		command_once("laminar/B738/autopilot/vorloc_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/vorloc_status") == 0 then
		command_once("laminar/B738/autopilot/vorloc_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/vorloc_press")
	end
end

-- HDGSEL 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_hdgsel_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/hdg_sel_status") == 1 then
		command_once("laminar/B738/autopilot/hdg_sel_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/hdg_sel_status") == 0 then
		command_once("laminar/B738/autopilot/hdg_sel_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/hdg_sel_press")
	end
end

-- SPD 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_spd_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/speed_status1") == 1 then
		command_once("laminar/B738/autopilot/speed_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/speed_status1") == 0 then
		command_once("laminar/B738/autopilot/speed_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/speed_press")
	end
end

-- SPD 0=OFF, 1=ON, 2=TOGGLE
function kc_acf_mcp_lvlchg_onoff(mode)
	if mode == 0 and get("laminar/B738/autopilot/lvl_chg_status") == 1 then
		command_once("laminar/B738/autopilot/lvl_chg_press")
	end
	if mode == 1 and get("laminar/B738/autopilot/lvl_chg_status") == 0 then
		command_once("laminar/B738/autopilot/lvl_chg_press")
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/lvl_chg_press")
	end
end

-- Autothrottle  mode 0=OFF 1=ARMED 2=toggle
function kc_acf_mcp_at_onoff(mode)
	if mode == 0 then
		if get("laminar/B738/autopilot/autothrottle_status") == 1 then
			command_once("laminar/B738/autopilot/autothrottle_arm_toggle")
		end
	end
	if mode == 1 then
		if get("laminar/B738/autopilot/autothrottle_status") == 0 then
			command_once("laminar/B738/autopilot/autothrottle_arm_toggle")
		end
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/autothrottle_arm_toggle")
	end
end

-- N1 A/T mode 0=OFF, 1=ON, 2=toggle
function kc_acf_mcp_n1_onoff(mode)
	if mode == 0 then
		if get("laminar/B738/autopilot/n1_status") == 1 then
			command_once("laminar/B738/autopilot/n1_press")
		end
	end
	if mode == 1 then
		if get("laminar/B738/autopilot/n1_status") == 0 then
			command_once("laminar/B738/autopilot/n1_press")
		end
	end
	if mode == 2 then
		command_once("laminar/B738/autopilot/n1_press")
	end
end

-- TOGA press 
function kc_acf_mcp_toga()
	command_once("laminar/B738/autopilot/left_toga_press")
end 

function kc_acf_mcp_ap_disconnect()
	command_once("laminar/B738/autopilot/capt_disco_press")
end

--- Tests

-- trigger fire tests
function kc_acf_firetests()
	command_begin("laminar/B738/toggle_switch/fire_test_lft")
	KC_BACKGROUND_PROCS["FIRETESTLEFTSTOP"].status = 4
end

-- Stall test
function kc_acf_stall_warnings()
	command_begin("laminar/B738/push_button/stall_test1_press")
	KC_BACKGROUND_PROCS["STALL1TESTSTOP"].status = 4
end

-- Mach Overspeed tests
function kc_acf_overspeed()
	command_begin("laminar/B738/push_button/mach_warn1_test")
	KC_BACKGROUND_PROCS["MACH1TESTSTOP"].status = 4
end

--- Doors and external items 0=UP, 1=DOWN, 2=OFF
function kc_acf_gears(mode)
	if mode == 0 then
		command_once("sim/flight_controls/landing_gear_up")
	end
	if mode == 1 then
		command_once("sim/flight_controls/landing_gear_down")
	end
	if mode == 2 then
		command_once("laminar/B738/push_button/gear_off")
	end
end

-- Reverse 0=OFF 1=ON 2=toggle
function kc_acf_reverse_onoff(mode)
	set("laminar/B738/flt_ctrls/reverse_lever12",mode)
end

-- door 0=ALL, 1=main, 2=cargof, 3=cargor 
function kc_acf_external_doors(door,openclose)
	if door == 0 or door == 1 then
		if (openclose == 1) then
			if get("737u/doors/L1") == 0 then
				command_once("laminar/B738/door/fwd_L_toggle")
			end
		end
		if (openclose == 0) then
			if get("737u/doors/L1") > 0 then
				command_once("laminar/B738/door/fwd_L_toggle")
			end
		end
	end
	if door == 0 or door == 2 then
		if (openclose == 1) then
			if get("737u/doors/Fwd_Cargo") == 0 then
				command_once("laminar/B738/door/fwd_cargo_toggle")
			end			
		end
		if (openclose == 0) then
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
		end
		if (openclose == 0) then
			if get("737u/doors/aft_Cargo") == 1 then
				command_once("laminar/B738/door/aft_cargo_toggle")
			end
		end
	end

end

-- Airstair left forward
function kc_acf_airstair_onoff(onoff)
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

-- Cockpit door 0=CLOSED, 1=OPEN
function kc_acf_cockpit_door(mode)
	if mode == 0 then
		if get("laminar/B738/door/flt_dk_door_ratio") == 1 then
			command_once("laminar/B738/toggle_switch/flt_dk_door_open")
		end
	end
	if mode == 1 then
		if get("laminar/B738/door/flt_dk_door_ratio") == 0 then
			command_once("laminar/B738/toggle_switch/flt_dk_door_open")
		end
	end
end

-- Wipers 0=ALL;1=left,2=right; 0=park,1=int,2=low,3=high
function kc_acf_wipers_mode(wiper,mode)
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

--- EICAS

-- EICAS modes mode 0=OFF 1=ENG 2=ENG UP 3=SYS
function kc_acf_lower_eicas_mode(mode)
	if mode == 0 then
		while get("laminar/B738/systems/lowerDU_page") ~= 0 do
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
		end
		while get("laminar/B738/systems/lowerDU_page2") ~= 0 do
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		end
	end
	if mode == 1 then
		while get("laminar/B738/systems/lowerDU_page") ~= 1 do
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
		end
	end
	if mode == 2 then
		while get("laminar/B738/systems/lowerDU_page") ~= 2 do
			command_once("laminar/B738/LDU_control/push_button/MFD_ENG")
		end
	end
	if mode == 3 then
		while get("laminar/B738/systems/lowerDU_page2") ~= 1 do
			command_once("laminar/B738/LDU_control/push_button/MFD_SYS")
		end
	end
end

-- ND FPV nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_efis_fpvfpa_onoff(nd,mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/fpv_press")
		else
			if get("laminar/B738/PFD/capt/fpv_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/fpv_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/fpv_press")
		else
			if get("laminar/B738/PFD/fo/fpv_on") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/fpv_press")
			end
		end
	end
end

-- ND MTR nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_efis_ft_meter(nd,mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/mtrs_press")
		else
			if get("laminar/B738/PFD/capt/alt_mode_is_meters") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/mtrs_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/mtrs_press")
		else
			if get("laminar/B738/PFD/capt/alt_mode_is_meters") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/mtrs_press")
			end
		end
	end
end

-- Set STD baro side 0=ALL,1=CAPT,2=FO,3=STB mode 0=NORM, 1=STD
function kc_acf_efis_baro_std_set(side,mode)
	if side == 0 or side == 1 then
		if mode == 0 and get("laminar/B738/EFIS/baro_set_std_pilot") == 1 then
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if mode == 1 and get("laminar/B738/EFIS/baro_set_std_pilot") == 0 then
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/std_press")
		end
	end
	if side == 0 or side == 2 then
		if mode == 0 and get("laminar/B738/EFIS/baro_set_std_copilot") == 1 then
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
		if mode == 1 and get("laminar/B738/EFIS/baro_set_std_copilot") == 0 then
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/std_press")
		end
	end
	if side == 0 or side == 3 then
		if mode == 0 and get("laminar/B738/gauges/standby_alt_std_mode") == 1 then
			command_once("laminar/B738/toggle_switch/standby_alt_baro_std")
		end
		if mode == 1 and get("laminar/B738/gauges/standby_alt_std_mode") == 0 then
			command_once("laminar/B738/toggle_switch/standby_alt_baro_std")
		end
		if mode == 2 then
			command_once("laminar/B738/toggle_switch/standby_alt_baro_std")
		end
	end
end

-- baro up 1 unit 0=ALL 1=CAPT, 2=FO, 3=STBY, mode 0=dn,1=up
function kc_acf_efis_baro_up_down(side,mode)
	if side == 0 or side == 1 then
		if mode == 0 then
			command_once("laminar/B738/pilot/barometer_down")
		else
			command_once("laminar/B738/pilot/barometer_up")
		end
	end
	if side == 0 or side == 2 then
		if mode == 0 then
			command_once("laminar/B738/copilot/barometer_down")
		else
			command_once("laminar/B738/copilot/barometer_up")
		end
	end
	if side == 0 or side == 3 then
		if mode == 0 then
			command_once("laminar/B738/knob/standby_alt_baro_dn")
		else
			command_once("laminar/B738/knob/standby_alt_baro_up")
		end
	end
end

-- set baro with direct value side 0=all,1=CAPT,2=FO,3=STBY value inhg or mb depending on mode
function kc_acf_efis_baro_set(side,value)
	set("laminar/B738/EFIS/baro_sel_in_hg_pilot",value)
	set("laminar/B738/EFIS/baro_sel_in_hg_copilot",value)
	set("laminar/B738/knobs/standby_alt_baro",value)
end

-- synchronize baro with outside pressure
function kc_acf_efis_baro_sync()
	set("laminar/B738/EFIS/baro_sel_in_hg_pilot",get("sim/weather/barometer_sealevel_inhg"))
	set("laminar/B738/EFIS/baro_sel_in_hg_copilot",get("sim/weather/barometer_sealevel_inhg"))
	set("laminar/B738/knobs/standby_alt_baro",get("sim/weather/barometer_sealevel_inhg"))
end

-- switch between mb and in side 0=ALL,1=CAPT,2=FO,3=STBY mode 0=in,1=mb,2=toggle
function kc_acf_efis_baro_in_mb(side,mode)
	if side == 0 or side == 1 then
		if mode == 0 and get("laminar/B738/EFIS_control/capt/baro_in_hpa") == 1 then
			command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_dn")
		end
		if mode == 1 and get("laminar/B738/EFIS_control/capt/baro_in_hpa") == 0 then
			command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_up")
		end
		if mode == 2 then
			if get("laminar/B738/EFIS_control/capt/baro_in_hpa") == 1 then
				command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_dn")
			else
				command_once("laminar/B738/EFIS_control/capt/baro_in_hpa_up")
			end
		end
	end
	if side == 0 or side == 2 then
		if mode == 0 and get("laminar/B738/EFIS_control/fo/baro_in_hpa") == 1 then
			command_once("laminar/B738/EFIS_control/fo/baro_in_hpa_dn")
		end
		if mode == 1 and get("laminar/B738/EFIS_control/fo/baro_in_hpa") == 0 then
			command_once("laminar/B738/EFIS_control/fo/baro_in_hpa_up")
		end
		if mode == 2 then
			if get("laminar/B738/EFIS_control/fo/baro_in_hpa") == 1 then
				command_once("laminar/B738/EFIS_control/fo/baro_in_hpa_dn")
			else
				command_once("laminar/B738/EFIS_control/fo/baro_in_hpa_up")
			end
		end
	end
	if side == 0 or side == 3 then
		if mode == 0 and get("laminar/B738/gauges/standby_alt_mode") == 1 then
			command_once("laminar/B738/toggle_switch/standby_alt_hpin")
		end
		if mode == 1 and get("laminar/B738/gauges/standby_alt_mode") == 0 then
			command_once("laminar/B738/toggle_switch/standby_alt_hpin")
		end
		if mode == 2 then
			command_once("laminar/B738/toggle_switch/standby_alt_hpin")
		end
	end
end

-- EFIS: Set mode of minimums side 0=ALL,1=CAPT,2=FO mode 0=RADIO,1=BARO
function kc_acf_efis_dhda_mode(side,mode)
	if side == 0 or side == 1 then
		command_once("laminar/B738/EFIS_control/capt/push_button/rst_press")
		set("laminar/B738/EFIS_control/cpt/minimums",mode)
		set("laminar/B738/EFIS_control/cpt/minimums_pfd",mode)
		set("laminar/B738/EFIS_control/cpt/minimums_show",1)
	end
	if side == 0 or side == 2 then
		command_once("laminar/B738/EFIS_control/fo/push_button/rst_press")
		set("laminar/B738/EFIS_control/fo/minimums",mode)
		set("laminar/B738/EFIS_control/fo/minimums_pfd",mode)
		set("laminar/B738/EFIS_control/fo/minimums_show",1)
	end
end

-- set minimums side 0=ALL,1=LEFT,2=RGT altitude in feet
function kc_acf_efis_minimum(side, altitude)
	if side == 0 or side == 1 then
		if get("laminar/B738/pfd/dh_pilot") ~= altitude then
			if get("laminar/B738/pfd/dh_pilot") < altitude then
				while get("laminar/B738/pfd/dh_pilot") < altitude do 
					command_once("laminar/B738/pfd/dh_pilot_up")
				end
			else
				while get("laminar/B738/pfd/dh_pilot") > altitude do 
					command_once("laminar/B738/pfd/dh_pilot_dn")
				end
			end
		end
	end
	if side == 0 or side == 2 then
		if get("laminar/B738/pfd/dh_copilot") ~= altitude then
			if get("laminar/B738/pfd/dh_copilot") < altitude then
				while get("laminar/B738/pfd/dh_copilot") < altitude do 
					command_once("laminar/B738/pfd/dh_copilot_up")
				end
			else
				while get("laminar/B738/pfd/dh_copilot") > altitude do 
					command_once("laminar/B738/pfd/dh_copilot_dn")
				end
			end
		end
	end
end

-- EFIS MAP zoom 0=ALL 1=CAPT 2=FO  mode 0=dn 1=up
function kc_acf_efis_nd_zoom(nd,mode)
	if nd == 0 or nd == 1 then
		if mode == 0 then 
			command_once("laminar/B738/EFIS_control/capt/map_range_dn")
		else
			command_once("laminar/B738/EFIS_control/capt/map_range_up")
		end
	end
	if nd == 0 or nd == 2 then
		if mode == 0 then 
			command_once("laminar/B738/EFIS_control/fo/map_range_dn")
		else
			command_once("laminar/B738/EFIS_control/fo/map_range_up")
		end
	end	
end

-- EFIS MAP mode 0=ALL 1=CAPT 2=FO  mode 0=dn 1=up
function kc_acf_efis_nd_mode(nd,mode)
	if nd == 0 or nd == 1 then
		if mode == 0 then 
			command_once("laminar/B738/EFIS_control/capt/map_mode_dn")
		else
			command_once("laminar/B738/EFIS_control/capt/map_mode_up")
		end
	end
	if nd == 0 or nd == 2 then
		if mode == 0 then 
			command_once("laminar/B738/EFIS_control/fo/map_mode_dn")
		else
			command_once("laminar/B738/EFIS_control/fo/map_mode_dn")
		end
	end	
end

-- VOR OFF 0=both,1=LEFT,2=RIGHT mode 0=OFF, -1=ADF, 1=VOR
function kc_acf_nd_vor_capt(nav,mode)
	if nav == 0 or nav == 1 then
		while get("laminar/B738/EFIS_control/capt/vor1_off_pfd") < mode do 
			command_once("laminar/B738/EFIS_control/capt/vor1_off_up")
		end
		while get("laminar/B738/EFIS_control/capt/vor1_off_pfd") > mode do 
			command_once("laminar/B738/EFIS_control/capt/vor1_off_dn")
		end
	end
	if nav == 0 or nav == 2 then
		while get("laminar/B738/EFIS_control/capt/vor2_off_pfd") < mode do 
			command_once("laminar/B738/EFIS_control/capt/vor2_off_up")
		end
		while get("laminar/B738/EFIS_control/capt/vor2_off_pfd") > mode do 
			command_once("laminar/B738/EFIS_control/capt/vor2_off_dn")
		end
	end
end

function kc_acf_nd_vor_fo(nav,mode)
	if nav == 0 or nav == 1 then
		while get("laminar/B738/EFIS_control/fo/vor1_off_pfd") < mode do 
			command_once("laminar/B738/EFIS_control/fo/vor1_off_up")
		end
		while get("laminar/B738/EFIS_control/fo/vor1_off_pfd") > mode do 
			command_once("laminar/B738/EFIS_control/fo/vor1_off_dn")
		end
	end
	if nav == 0 or nav == 2 then
		while get("laminar/B738/EFIS_control/fo/vor2_off_pfd") < mode do 
			command_once("laminar/B738/EFIS_control/fo/vor2_off_up")
		end
		while get("laminar/B738/EFIS_control/fo/vor2_off_pfd") > mode do 
			command_once("laminar/B738/EFIS_control/fo/vor2_off_dn")
		end
	end
end

-- ND map mode nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=APP,1=VOR,2=MAP,3=PLN 
function kc_acf_nd_map_mode(nd,mode)
	if nd == 0 or nd == 1 then
		set("laminar/B738/EFIS_control/capt/map_mode_pos",mode)
	end
	if nd == 0 or nd == 2 then
		set("laminar/B738/EFIS_control/fo/map_mode_pos",mode)
	end
end

function kc_acf_nd_map_mode_up(nd)
	if nd == 0 or nd == 1 then
		command_once("laminar/B738/EFIS_control/capt/map_mode_up")
	end
	if nd == 0 or nd == 2 then
		command_once("laminar/B738/EFIS_control/fo/map_mode_up")
	end
end

function kc_acf_nd_map_mode_dn(nd)
	if nd == 0 or nd == 1 then
		command_once("laminar/B738/EFIS_control/capt/map_mode_dn")
	end
	if nd == 0 or nd == 2 then
		command_once("laminar/B738/EFIS_control/fo/map_mode_dn")
	end
end

-- ND map mode nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=5,1=10,2=20,3=40,4=80,5=160,6=320,7=640 
function kc_acf_nd_map_range(nd,mode)
	if nd == 0 or nd == 1 then
		set("laminar/B738/EFIS_control/capt/map_range",mode)
	end
	if nd == 0 or nd == 2 then
		set("laminar/B738/EFIS_control/fo/map_range",mode)
	end
end

function kc_acf_nd_map_range_up(nd)
	if nd == 0 or nd == 1 then
		command_once("laminar/B738/EFIS_control/capt/map_range_up")
	end
	if nd == 0 or nd == 2 then
		command_once("laminar/B738/EFIS_control/fo/map_range_up")
	end
end

function kc_acf_nd_map_range_dn(nd)
	if nd == 0 or nd == 1 then
		command_once("laminar/B738/EFIS_control/capt/map_range_dn")
	end
	if nd == 0 or nd == 2 then
		command_once("laminar/B738/EFIS_control/fo/map_range_dn")
	end
end

-- ND WX nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_wxr_onoff(nd,mode)
	if nd == 0 or nd == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
		else
			if get("laminar/B738/EFIS/EFIS_wx_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/wxr_press")
			end
		end
	end
	if nd == 0 or nd == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/wxr_press")
		else
			if get("laminar/B738/EFIS/fo/EFIS_wx_on") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/wxr_press")
			end
		end
	end
end

-- ND WX nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_sta_cstr_onoff(nd,mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/sta_press")
		else
			if get("laminar/B738/EFIS/EFIS_vor_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/sta_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/sta_press")
		else
			if get("laminar/B738/EFIS/fo/EFIS_vor_on") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/sta_press")
			end
		end
	end
end

-- ND WPT nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_wpt_onoff(mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/wpt_press")
		else
			if get("laminar/B738/EFIS/EFIS_fix_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/wpt_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/sta_press")
		else
			if get("laminar/B738/EFIS/fo/EFIS_fix_on") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/wpt_press")
			end
		end
	end
end

-- ND ARPT nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_arpt_onoff(mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/arpt_press")
		else
			if get("laminar/B738/EFIS/EFIS_airport_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/arpt_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/arpt_press")
		else
			if get("laminar/B738/EFIS/fo/EFIS_airport_on") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/arpt_press")
			end
		end
	end
end

-- ND DATA nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_data_onoff(mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/data_press")
		else
			if get("laminar/B738/EFIS/capt/data_status") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/data_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/data_press")
		else
			if get("laminar/B738/EFIS/fo/data_status") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/data_press")
			end
		end
	end
end

-- ND POS nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_pos_onoff(nd,mode)
	-- no dataref to chack status, always toggle
	if nd == 0 or nd == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/pos_press")
		else
			command_once("laminar/B738/EFIS_control/capt/push_button/pos_press")
		end
	end
	if nd == 0 or nd == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/pos_press")
		else
			command_once("laminar/B738/EFIS_control/fo/push_button/pos_press")
		end
	end
end

-- ND TERR nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_terr_onoff(nd,mode)
	if nd == 0 or nd == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/terr_press")
		else
			if get("laminar/B738/EFIS/EFIS_capt_wxr_terr") ~= mode % 1 then
				command_once("laminar/B738/EFIS_control/capt/push_button/terr_press")
			end
		end
	end
	if nd == 0 or nd == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/terr_press")
		else
			if get("laminar/B738/EFIS/EFIS_fo_wxr_terr") ~= mode % 1 then
				command_once("laminar/B738/EFIS_control/fo/push_button/terr_press")
			end
		end
	end
end


-- ND TRFC nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_trfc_onoff(mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/tfc_press")
		else
			if get("laminar/B738/EFIS/tcas_on") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/tfc_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/tfc_press")
		else
			if get("laminar/B738/EFIS/tcas_on_fo") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/tfc_press")
			end
		end
	end
end

-- ND CTR nd: 0=both, 1=LEFT, 2=RIGHT, mode: 0=OFF, 1=ON, 2=toggle
function kc_acf_nd_ctr_onoff(mode)
	if ap == 0 or ap == 1 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/capt/push_button/ctr_press")
		else
			if get("laminar/B738/EFIS_control/capt/exp_map") ~= mode then
				command_once("laminar/B738/EFIS_control/capt/push_button/ctr_press")
			end
		end
	end
	if ap == 0 or ap == 2 then
		if mode == 2 then
			command_once("laminar/B738/EFIS_control/fo/push_button/ctr_press")
		else
			if get("laminar/B738/EFIS_control/fo/exp_map") ~= mode then
				command_once("laminar/B738/EFIS_control/fo/push_button/ctr_press")
			end
		end
	end
end

-- Set NAV1/2 frequency
function kc_radio_nav_set(radio,freq)
	if radio == 1 then
		set("sim/cockpit2/radios/actuators/nav1_frequency_hz",freq*100)
	end
	if radio == 2 then
		set("sim/cockpit2/radios/actuators/nav2_frequency_hz",freq*100)
	end
end

-- =============== Aircraft specific Joystick functions
-- Default activate Backcourse mode on autopilot (not used these days)
-- kpcrew layer 1 
function xsp_toggle_rev_course()
	command_once("sim/autopilot/back_course")
end

-- generic up function depending on mode and layer
function xsp_bravo_knob_up()

	-- normal A/P mode
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
	
	-- MULTI mode 
	if xsp_bravo_layer == 1 then
		if xsp_bravo_mode == 1 then -- COM1 Freq
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com1_coarse_up")
			else
				command_once("sim/radios/stby_com1_fine_up_833")
			end
		end
		if xsp_bravo_mode == 2 then -- COM2 Freq
			if xsp_fine_coarse == 0 then
				command_once("sim/radios/stby_com2_coarse_up")
			else
				command_once("sim/radios/stby_com2_fine_up_833")
			end
		end
		if xsp_bravo_mode == 3 then -- ALL BARO UP/DOWN
			kc_acf_efis_baro_up_down(0,1)
		end
		if xsp_bravo_mode == 4 then -- ND ZOOM OUT
			kc_acf_efis_nd_zoom(1,1)
		end
		if xsp_bravo_mode == 5 then -- ND MODE UP
			kc_acf_efis_nd_mode(1,1)
		end
	end
end

-- generic down function depending on mode and layer
function xsp_bravo_knob_dn()

	-- normal A/P mode
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

	-- MULTI mode 
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
		if xsp_bravo_mode == 3 then -- ALL BARO UP/DOWN
			kc_acf_efis_baro_up_down(0,0)
		end
		if xsp_bravo_mode == 4 then -- ND ZOOM IN
			kc_acf_efis_nd_zoom(1,0)
		end
		if xsp_bravo_mode == 5 then -- ND MODE DN
			kc_acf_efis_nd_mode(1,0)
		end
	end
end

function xsp_bravo_button_hdg()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_hdgsel_onoff(2)
	end
end                

function xsp_bravo_button_nav()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_vorloc_onoff(2)
	end
end                

function xsp_bravo_button_apr()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_app_onoff(2)
	end
end                

function xsp_bravo_button_rev()
	if xsp_fine_coarse == 0 then
		xsp_fine_coarse = 1
	else
		xsp_fine_coarse = 0
	end
end                

function xsp_bravo_button_alt()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_althld_onoff(2)
	end
end                

function xsp_bravo_button_vsp()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_vs_onoff(2)
	end
end                

function xsp_bravo_button_ias()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_spd_onoff(2)
	end
end

function xsp_bravo_button_autopilot()
	if xsp_bravo_layer == 0 then
		kc_acf_mcp_ap_set(1,2)
	end
	if xsp_bravo_layer == 1 then
		if xsp_bravo_mode == 1 then -- switch COM1 freq
			command_once("sim/radios/com1_standy_flip")
		end
		if xsp_bravo_mode == 2 then -- Switch COM 2 freq
			command_once("sim/radios/com2_standy_flip")
		end
	end
end


-- ========== Set up Bravo throttle generic datarefs
-- xsp_parking_brake 		= create_dataref_table("kp/xsp/systems/parking_brake", "Int")
-- xsp_master_caution 		= create_dataref_table("kp/xsp/systems/master_caution", "Int")
-- xsp_master_warning 		= create_dataref_table("kp/xsp/systems/master_warning", "Int")
-- xsp_gear_light_on_n		= create_dataref_table("kp/xsp/systems/gear_light_on_n", "Int")
-- xsp_gear_light_on_l		= create_dataref_table("kp/xsp/systems/gear_light_on_l", "Int")
-- xsp_gear_light_on_r		= create_dataref_table("kp/xsp/systems/gear_light_on_r", "Int")
-- xsp_gear_light_trans_n	= create_dataref_table("kp/xsp/systems/gear_light_trans_n", "Int")
-- xsp_gear_light_trans_l	= create_dataref_table("kp/xsp/systems/gear_light_trans_l", "Int")
-- xsp_gear_light_trans_r	= create_dataref_table("kp/xsp/systems/gear_light_trans_r", "Int")
-- xsp_doors 				= create_dataref_table("kp/xsp/systems/doors", "Int")

-- xsp_engine_fire 		= create_dataref_table("kp/xsp/engines/engine_fire", "Int")
-- xsp_anc_starter 		= create_dataref_table("kp/xsp/engines/anc_starter", "Int")
-- xsp_anc_oil 			= create_dataref_table("kp/xsp/engines/anc_oil", "Int")
	
xsp_vacuum 				= create_dataref_table("kp/xsp/air/vacuum", "Int")
	
-- xsp_fuel_pumps 			= create_dataref_table("kp/xsp/fuel/fuel_pumps", "Int")
xsp_anc_fuel 			= create_dataref_table("kp/xsp/fuel/anc_fuel", "Int")
	
-- xsp_low_volts 			= create_dataref_table("kp/xsp/electric/low_volts", "Int")
-- xsp_apu_running			= create_dataref_table("kp/xsp/electric/apu_running", "Int")
	
-- xsp_anc_hyd 			= create_dataref_table("kp/xsp/hydraulic/anc_hyd", "Int")
	
xsp_anc_aice 			= create_dataref_table("kp/xsp/aice/anc_aice", "Int")
	
xsp_mcp_hdg 			= create_dataref_table("kp/xsp/autopilot/mcp_hdg", "Int")
xsp_mcp_nav 			= create_dataref_table("kp/xsp/autopilot/mcp_nav", "Int")
xsp_mcp_app 			= create_dataref_table("kp/xsp/autopilot/mcp_app", "Int")
xsp_mcp_ias 			= create_dataref_table("kp/xsp/autopilot/mcp_ias", "Int")
xsp_mcp_vsp 			= create_dataref_table("kp/xsp/autopilot/mcp_vsp", "Int")
xsp_mcp_alt 			= create_dataref_table("kp/xsp/autopilot/mcp_alt", "Int")
xsp_mcp_ap1 			= create_dataref_table("kp/xsp/autopilot/mcp_ap1", "Int")
xsp_mcp_rev 			= create_dataref_table("kp/xsp/autopilot/mcp_rev", "Int")

-- xsp_parking_brake[0] = 0
-- xsp_master_caution[0] = 0
-- xsp_master_warning[0] = 0
-- xsp_engine_fire[0] = 0
xsp_vacuum[0] = 0
-- xsp_fuel_pumps[0] = 0
-- xsp_low_volts[0] = 0

xsp_mcp_hdg[0] = 0
xsp_mcp_nav[0] = 0
xsp_mcp_app[0] = 0
xsp_mcp_ias[0] = 0
xsp_mcp_vsp[0] = 0
xsp_mcp_alt[0] = 0
xsp_mcp_ap1[0] = 0
xsp_mcp_rev[0] = 0

-- xsp_doors[0] = 0
-- xsp_anc_hyd[0] = 0
xsp_anc_fuel[0] = 0
-- xsp_anc_oil[0] = 0
xsp_anc_aice[0] = 0
-- xsp_anc_starter[0] = 0

function xsp_set_lightvars()

	-- REV button light blinks when in multi mode
	if xsp_bravo_layer == 1 then
		if xsp_mcp_rev[0] == 0 then
			xsp_mcp_rev[0] = 1
		else
			xsp_mcp_rev[0] = 0
		end
	else
		xsp_mcp_rev[0] = 0
	end

	-- HDG button light will light when in HDG SEL mode
	if xsp_bravo_layer == 1 then
		xsp_mcp_hdg[0] = 0
	else
		if xsp_bravo_mode == 3 and get("laminar/B738/autopilot/hdg_sel_status") == 1 then
			if xsp_mcp_hdg[0] == 0 then
				xsp_mcp_hdg[0] = 1
			else
				xsp_mcp_hdg[0] = 0
			end
		else
			xsp_mcp_hdg[0] = get("laminar/B738/autopilot/hdg_sel_status")
		end
	end
	
	-- NAV button light will light when in NAV modes
	if xsp_bravo_layer == 1 then
		xsp_mcp_nav[0] = 0
	else
		if xsp_bravo_mode == 4 and (get("laminar/B738/autopilot/vorloc_status") == 1 or get("laminar/B738/autopilot/lnav_status") == 1) then
			if xsp_mcp_nav[0] == 0 then
				xsp_mcp_nav[0] = 1
			else
				xsp_mcp_nav[0] = 0
			end
		else
			if get("laminar/B738/autopilot/vorloc_status") == 0 and get("laminar/B738/autopilot/lnav_status") == 0 then
				xsp_mcp_nav[0] = 0
			else
				xsp_mcp_nav[0] = 1
			end
		end
	end

	-- APR button light will light when in APR
	if xsp_bravo_layer == 1 then
		xsp_mcp_app[0] = 0
	else
		if get("laminar/B738/autopilot/app_status") == 1 then
			if xsp_mcp_app[0] == 0 then
				xsp_mcp_app[0] = 1
			else
				xsp_mcp_app[0] = 0
			end
		else
			xsp_mcp_app[0] = get("laminar/B738/autopilot/app_status")
		end
	end

	
	-- xsp_gear_light_on_l[0] = get("laminar/B738/annunciator/left_gear_safe")
	-- xsp_gear_light_on_r[0] = get("laminar/B738/annunciator/right_gear_safe")
	-- xsp_gear_light_on_n[0] = get("laminar/B738/annunciator/nose_gear_safe")
	-- xsp_gear_light_trans_l[0] = get("laminar/B738/annunciator/left_gear_transit")
	-- xsp_gear_light_trans_r[0] = get("laminar/B738/annunciator/right_gear_transit")
	-- xsp_gear_light_trans_n[0] = get("laminar/B738/annunciator/nose_gear_transit")

	-- xsp_parking_brake[0] = kc_get_controls_parkbrake_mode()

	-- xsp_apu_running[0] = get("sim/cockpit2/electrical/APU_running")

	-- Master Caution light
	-- if get("laminar/B738/annunciator/master_caution_light") > 0 then
		-- xsp_master_caution[0] = 1
	-- else
		-- xsp_master_caution[0] = 0
	-- end




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

	-- if get("737u/doors/aft1") == 0 and get("737u/doors/aft1") == 0 and get("737u/doors/aft_Cargo") == 0 and get(		"737u/doors/Fwd_Cargo")  == 0 and get("737u/doors/L1") == 0 and get("737u/doors/L2") == 0 and get(			"737u/doors/R1") == 0 and get("737u/doors/R2") then
		-- xsp_doors[0] = 0
	-- else
		-- xsp_doors[0] = 1
	-- end

	-- if get("laminar/B738/annunciator/hyd_el_press_a") == 0 and get("laminar/B738/annunciator/hyd_el_press_b") == 0 then
		-- xsp_anc_hyd[0] = 0
	-- else
		-- xsp_anc_hyd[0] = 1
	-- end
	
	if get("laminar/B738/annunciator/low_fuel_press_c1") == 0 and get("laminar/B738/annunciator/low_fuel_press_c2") == 0 and get("laminar/B738/annunciator/low_fuel_press_l1") == 0 and get("laminar/B738/annunciator/low_fuel_press_l2") == 0 and get("laminar/B738/annunciator/low_fuel_press_r1") == 0 and get("laminar/B738/annunciator/low_fuel_press_r2") == 0 then
		xsp_anc_fuel[0] = 0
	else
		xsp_anc_fuel[0] = 1
	end

	-- if get("laminar/B738/engine/eng1_oil_press") == 0 or get("laminar/B738/engine/eng2_oil_press") == 0 then
		-- xsp_anc_oil[0] = 1
	-- else
		-- xsp_anc_oil[0] = 0
	-- end

	-- if get("laminar/B738/air/engine1/starter_valve") == 0 and get("laminar/B738/air/engine2/starter_valve") == 0 then
		-- xsp_anc_starter[0] = 0
	-- else
		-- xsp_anc_starter[0] = 1
	-- end

	if get("laminar/B738/annunciator/wing_ice_on_L") == 0 and get("laminar/B738/annunciator/wing_ice_on_R") == 0 and get("laminar/B738/annunciator/cowl_ice_on_0") == 0 and get("laminar/B738/annunciator/cowl_ice_on_1") == 0  then
		xsp_anc_aice[0] = 0
	else
		xsp_anc_aice[0] = 1
	end

	-- xsp_master_warning[0] = get("laminar/B738/flt_ctrls/reverse_lever12")
	
	if get("laminar/B738/annunciator/pack_left") > 0 or get("laminar/B738/annunciator/pack_right") > 0 then
		xsp_vacuum[0] = 1
	else
		xsp_vacuum[0] = 0
	end
end

-- ============= Menu related functions
function kc_menus_set_DEP_data()
	set_kpcrew_config("dep_v1",kc_get_V1())
	set_kpcrew_config("dep_vr",kc_get_Vr())
	set_kpcrew_config("dep_v2",kc_get_V2())
	set_kpcrew_config("dep_elevator_trim",kc_get_takeoff_elev_trim())
	-- Select Flaps Setting from List
	for i = 1, #GENERAL_Acf:getDEP_Flaps() do
		if GENERAL_Acf:getDEP_Flaps()[i] == tostring(math.floor(kc_get_takeoff_flaps())) then
			set_kpcrew_config("dep_to_flaps",i)
		end
	end
	set_kpcrew_config("dep_glare_spd",kc_get_V2())
	set_kpcrew_config("dep_glare_crs1",kc_get_takeoff_rwy_crs())
	set_kpcrew_config("dep_glare_crs2",kc_get_takeoff_rwy_crs())
	set_kpcrew_config("dep_glare_hdg",kc_get_takeoff_rwy_crs())
	set_kpcrew_config("dep_glare_alt",get_kpcrew_config("flight_initial_alt"))
	set_kpcrew_config("dep_n1",get("laminar/B738/engine/eng1_N1_bug")*100)
	set_kpcrew_config("dep_transalt",kc_get_transition_altitude())
end

function kc_menus_set_APP_data()
	set_kpcrew_config("arr_vref",kc_get_Vref())
	set_kpcrew_config("arr_vapp",kc_get_Vapp())
	set_kpcrew_config("flight_destination",kc_get_destination_icao())
	set_kpcrew_config("arr_translevel",kc_get_transition_level())
	-- Select Flaps Setting from List
	for i = 1, #GENERAL_Acf:getAPP_Flaps() do
		if GENERAL_Acf:getAPP_Flaps()[i] == tostring(math.floor(kc_get_landing_flaps())) then
			set_kpcrew_config("arr_ldg_flaps",i)
		end
	end
end

-- ============ aircraft specific joystick/key commands (e.g. for Alpha Yoke)

-- ------------ A/P MCP functions
create_command("kp/xsp/autopilot/both_fd_tgl",		"All FDs Toggle",		"kc_acf_mcp_fds_set(0,2)", "", "")
create_command("kp/xsp/autopilot/bc_tgl",			"Toggle Reverse Appr",	"xsp_toggle_rev_course()", "", "")
create_command("kp/xsp/autopilot/ap_tgl",			"Toggle A/P 1",			"kc_acf_mcp_ap_set(1,2)", "", "")
create_command("kp/xsp/autopilot/alt_tgl",			"Toggle Altitude",		"kc_acf_mcp_althld_onoff(2)","","")
create_command("kp/xsp/autopilot/hdg_tgl",			"Toggle Heading",		"kc_acf_mcp_hdgsel_onoff(2)","","")
create_command("kp/xsp/autopilot/nav_tgl",			"Toggle Nav",			"kc_acf_mcp_vorloc_onoff(2)","","")
create_command("kp/xsp/autopilot/app_tgl",			"Toggle Approach",		"kc_acf_mcp_app_onoff(2)","","")
create_command("kp/xsp/autopilot/vs_tgl",			"Toggle Vertical Speed","kc_acf_mcp_vs_onoff(2)","","")
create_command("kp/xsp/autopilot/ias_tgl",			"Toggle IAS",			"kc_acf_mcp_spd_onoff(2)","","")
create_command("kp/xsp/autopilot/toga_press",		"Press Left TOGA",		"kc_acf_mcp_toga()","","")
create_command("kp/xsp/autopilot/at_tgl",			"Toggle A/T",			"kc_acf_mcp_at_onoff(2)","","")
create_command("kp/xsp/autopilot/at_arm",			"Arm A/T",				"kc_acf_mcp_at_onoff(1)","","")
create_command("kp/xsp/autopilot/at_off",			"A/T OFF",				"kc_acf_mcp_at_onoff(0)","","")

-- ------------ EFIS commands

-- Honeycomb Bravo specific commands
create_command("kp/xsp/bravo_mode_alt",				"Bravo AP Mode ALT",	"xsp_bravo_mode=1", "", "")
create_command("kp/xsp/bravo_mode_vs",				"Bravo AP Mode VS",		"xsp_bravo_mode=2", "", "")
create_command("kp/xsp/bravo_mode_hdg",				"Bravo AP Mode HDG",	"xsp_bravo_mode=3", "", "")
create_command("kp/xsp/bravo_mode_crs",				"Bravo AP Mode CRS",	"xsp_bravo_mode=4", "", "")
create_command("kp/xsp/bravo_mode_ias",				"Bravo AP Mode IAS",	"xsp_bravo_mode=5", "", "")
create_command("kp/xsp/bravo_knob_up",				"Bravo AP Knob Up",		"xsp_bravo_knob_up()", "", "")
create_command("kp/xsp/bravo_knob_dn",				"Bravo AP Knob Down",	"xsp_bravo_knob_dn()", "", "")
create_command("kp/xsp/bravo_layer_multi",			"Bravo Layer MULTI",	"xsp_bravo_layer=1", "", "")
create_command("kp/xsp/bravo_layer_ap",				"Bravo Layer A/P",		"xsp_bravo_layer=0", "", "")
create_command("kp/xsp/bravo_fine",					"Bravo Fine",			"xsp_fine_coarse = 1", "", "")
create_command("kp/xsp/bravo_coarse",				"Bravo Coarse",			"xsp_fine_coarse = 0", "", "")
create_command("kp/xsp/bravo_button_hdg",			"Bravo HDG Button",		"xsp_bravo_button_hdg()", "", "")
create_command("kp/xsp/bravo_button_nav",			"Bravo NAV Button",		"xsp_bravo_button_nav()", "", "")
create_command("kp/xsp/bravo_button_apr",			"Bravo APR Button",		"xsp_bravo_button_apr()", "", "")
create_command("kp/xsp/bravo_button_rev",			"Bravo REV Button",		"xsp_bravo_button_rev()", "", "")
create_command("kp/xsp/bravo_button_alt",			"Bravo ALT Button",		"xsp_bravo_button_alt()", "", "")
create_command("kp/xsp/bravo_button_vsp",			"Bravo VSP Button",		"xsp_bravo_button_vsp()", "", "")
create_command("kp/xsp/bravo_button_ias",			"Bravo IAS Button",		"xsp_bravo_button_ias()", "", "")
create_command("kp/xsp/bravo_button_ap",			"Bravo Autopilot Button","xsp_bravo_button_autopilot()", "", "")


-- ========== Background processing
-- Set the datarefs for the Bravo throttle lights or SAITEK display
-- do_often("xsp_set_lightvars()")
