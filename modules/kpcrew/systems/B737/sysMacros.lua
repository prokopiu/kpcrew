-- B737 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("B737 sysMacros")

function kc_macro_custom_cold_dark()

	if get("laminar/B738/switches/flt_ctr_A_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/flt_ctr_A_cover")
	end
	if get("laminar/B738/switches/flt_ctr_B_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/flt_ctr_B_cover")
	end
	if get("laminar/B738/switches/spoiler_A_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/spoiler_A_cover")
	end
	if get("laminar/B738/switches/spoiler_B_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/spoiler_B_cover")
	end
	if get("laminar/B738/switches/alt_flaps_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/alt_flaps_cover")
	end

	command_once("laminar/B738/toggle_switch/irs_source_left")
	command_once("laminar/B738/toggle_switch/irs_source_left")
	command_once("laminar/B738/toggle_switch/irs_source_right")
	
	command_once("laminar/B738/toggle_switch/fmc_source_left")
	command_once("laminar/B738/toggle_switch/fmc_source_left")
	command_once("laminar/B738/toggle_switch/fmc_source_right")
	
	command_once("laminar/B738/toggle_switch/dspl_source_left")
	command_once("laminar/B738/toggle_switch/dspl_source_left")
	command_once("laminar/B738/toggle_switch/dspl_source_right")

	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
	
	command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
	command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
	command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")

	set("laminar/B738/toggle_switch/cab_util_pos",0)
	set("laminar/B738/toggle_switch/ife_pass_seat_pos",0)
	
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")

	set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
	set("laminar/B738/toggle_switch/eq_cool_supply",0)
	
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up")

	if get("laminar/B738/engine/starter1_pos") == 3 then
		command_once("laminar/B738/knob/eng1_start_left")
	end
	if get("laminar/B738/engine/starter1_pos") == 2 then
		command_once("laminar/B738/knob/eng1_start_left")
	end
	if get("laminar/B738/engine/starter1_pos") == 0 then
		command_once("laminar/B738/knob/eng1_start_right")
	end

	if get("laminar/B738/engine/starter2_pos") == 3 then
		command_once("laminar/B738/knob/eng2_start_left")
	end
	if get("laminar/B738/engine/starter2_pos") == 2 then
		command_once("laminar/B738/knob/eng2_start_left")
	end
	if get("laminar/B738/engine/starter2_pos") == 0 then
		command_once("laminar/B738/knob/eng2_start_right")
	end
	
	set("laminar/B738/toggle_switch/air_valve_ctrl",0)
	
	set("laminar/B738/toggle_switch/main_pnl_du_capt",0)
	set("laminar/B738/toggle_switch/lower_du_capt",0)
	set("laminar/B738/toggle_switch/lower_du_fo",0)
	set("laminar/B738/toggle_switch/main_pnl_du_fo",0)
	
	set("laminar/B738/air/cont_cab_temp/rheostat_700",0.5)
	set("laminar/B738/air/pass_cab_temp/rheostat_700",0.5)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	command_once("laminar/B738/push_button/capt_window_close")
	command_once("laminar/B738/push_button/fo_window_close")

	set("laminar/B738/fms/chock_status",1)
	
	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairsL1:actuate(1)
	else
		sysGeneral.stairsL1:actuate(0)
	end

end

function kc_macro_custom_turnaround()
kc_macro_at_trans_lvl()
	if get("laminar/B738/switches/flt_ctr_A_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/flt_ctr_A_cover")
	end
	if get("laminar/B738/switches/flt_ctr_B_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/flt_ctr_B_cover")
	end
	if get("laminar/B738/switches/spoiler_A_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/spoiler_A_cover")
	end
	if get("laminar/B738/switches/spoiler_B_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/spoiler_B_cover")
	end
	if get("laminar/B738/switches/alt_flaps_cover_pos") == 1 then
		command_once("laminar/B738/toggle_switch/alt_flaps_cover")
	end

	command_once("laminar/B738/toggle_switch/irs_source_left")
	command_once("laminar/B738/toggle_switch/irs_source_left")
	command_once("laminar/B738/toggle_switch/irs_source_right")
	
	command_once("laminar/B738/toggle_switch/fmc_source_left")
	command_once("laminar/B738/toggle_switch/fmc_source_left")
	command_once("laminar/B738/toggle_switch/fmc_source_right")
	
	command_once("laminar/B738/toggle_switch/dspl_source_left")
	command_once("laminar/B738/toggle_switch/dspl_source_left")
	command_once("laminar/B738/toggle_switch/dspl_source_right")

	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_left")
	command_once("laminar/B738/toggle_switch/dspl_ctrl_pnl_right")
	
	command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
	command_once("laminar/B738/toggle_switch/vhf_nav_source_lft")
	command_once("laminar/B738/toggle_switch/vhf_nav_source_rgt")

	set("laminar/B738/toggle_switch/cab_util_pos",1)
	set("laminar/B738/toggle_switch/ife_pass_seat_pos",1)
	
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")
	command_once("laminar/B738/spring_toggle_switch/APU_start_pos_up")

	set("laminar/B738/toggle_switch/eq_cool_exhaust",0)
	set("laminar/B738/toggle_switch/eq_cool_supply",0)
	
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	command_once("laminar/B738/toggle_switch/seatbelt_sign_up")
	command_once("laminar/B738/toggle_switch/seatbelt_sign_dn")

	if get("laminar/B738/engine/starter1_pos") == 3 then
		command_once("laminar/B738/knob/eng1_start_left")
	end
	if get("laminar/B738/engine/starter1_pos") == 2 then
		command_once("laminar/B738/knob/eng1_start_left")
	end
	if get("laminar/B738/engine/starter1_pos") == 0 then
		command_once("laminar/B738/knob/eng1_start_right")
	end

	if get("laminar/B738/engine/starter2_pos") == 3 then
		command_once("laminar/B738/knob/eng2_start_left")
	end
	if get("laminar/B738/engine/starter2_pos") == 2 then
		command_once("laminar/B738/knob/eng2_start_left")
	end
	if get("laminar/B738/engine/starter2_pos") == 0 then
		command_once("laminar/B738/knob/eng2_start_right")
	end
	
	set("laminar/B738/toggle_switch/air_valve_ctrl",0)
	
	set("laminar/B738/toggle_switch/main_pnl_du_capt",0)
	set("laminar/B738/toggle_switch/lower_du_capt",0)
	set("laminar/B738/toggle_switch/lower_du_fo",0)
	set("laminar/B738/toggle_switch/main_pnl_du_fo",0)
	
	set("laminar/B738/air/cont_cab_temp/rheostat_700",0.5)
	set("laminar/B738/air/pass_cab_temp/rheostat_700",0.5)
	
	kc_macro_set_autobrake(kc_AutoBrakeOff)
	
	command_once("laminar/B738/push_button/capt_window_close")
	command_once("laminar/B738/push_button/fo_window_close")

	set("laminar/B738/fms/chock_status",1)

	if activeBriefings:get("taxi:gateStand") > 1 then
		sysGeneral.stairsL1:actuate(1)
	else
		sysGeneral.stairsL1:actuate(0)
	end
end

function kc_macro_at_trans_alt()
	sysEFIS.barostdPilot:actuate(1)
	sysEFIS.barostdCopilot:actuate(1)
	sysEFIS.barostdStandby:actuate(1)
end

function kc_macro_at_trans_lvl()
	if get("laminar/B738/EFIS/baro_set_std_pilot") == 1 then 
		sysEFIS.barostdPilot:actuate(0)
		sysEFIS.barostdCopilot:actuate(0)
		sysEFIS.barostdStandby:actuate(0)
	end
	if activeBriefings:get("arrival:atisQNH") ~= "" then
		if activePrefSet:get("general:baro_mode_hpa") then
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999)
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH")) * 0.02952999) 
		else
			set("laminar/B738/EFIS/baro_sel_in_hg_pilot", tonumber(activeBriefings:get("arrival:atisQNH")))
			set("laminar/B738/EFIS/baro_sel_in_hg_copilot", tonumber(activeBriefings:get("arrival:atisQNH"))) 
		end
	end
end

return sysMacros