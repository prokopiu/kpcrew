-- C750 airplane macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("C750 sysMacros")

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()
	sysEngines.mixtureLever:actuate(0)
	if get("laminar/CitX/lights/recognition") ~= 0 then
		command_once("laminar/CitX/lights/cmd_recognition_toggle")
	end
	
	if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
		command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
	end
	if get("laminar/CitX/engine/gnd_idle") ~= 0 then
		command_once("laminar/CitX/engine/gnd_idle")
	end
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")

	if get("laminar/CitX/pressurization/alt_sel") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_alt_sel_toggle")
	end
	if get("laminar/CitX/pressurization/manual") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_manual_toggle")
	end
	if get("laminar/CitX/pressurization/cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_cabin_dump_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_cabin_dump_toggle")
	end
	if get("laminar/CitX/ice/wing_crossover") ~= 0 then
		command_once("laminar/CitX/ice/cmd_wing_crossover_toggle")
	end
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")

	if get("laminar/CitX/engine/eng_sync") < 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_up")
	end
	if get("laminar/CitX/engine/eng_sync") > 0 then
		command_once("laminar/CitX/engine/cmd_eng_sync_dwn")
	end	
	
	if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
	end

	command_once("laminar/CitX/APU/gen_switch_dwn") 
	command_once("laminar/CitX/APU/gen_switch_dwn") 
	sysAir.apuBleedSwitch:actuate(0)
	command_begin("laminar/CitX/APU/starter_switch_dwn") 
	sysElectric.apuMaster:actuate(0)
	command_end("laminar/CitX/APU/starter_switch_dwn")	
	
	sysGeneral.antiSkid:actuate(1)

end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	sysEngines.mixtureLever:actuate(0)
	if kc_is_daylight() == false then
		if get("laminar/CitX/lights/recognition") ~= 0 then
			command_once("laminar/CitX/lights/cmd_recognition_toggle")
		end
	else
		if get("laminar/CitX/lights/recognition") == 0 then
			command_once("laminar/CitX/lights/cmd_recognition_toggle")
		end
	end
	command_once("laminar/CitX/lights/emerg_light_switch_up")
	if get("laminar/CitX/lights/dim_lights_switch") ~= 0 then
		command_once("laminar/CitX/lights/dimming_switch_toggle")
	end
	if get("laminar/CitX/fuel/gravity_flow") ~= 0 then 
		command_once("laminar/CitX/fuel/cmd_gravity_flow_toggle")
	end
	
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_right_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/fuel/cmd_transfer_left_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_dwn")
	command_once("laminar/CitX/electrical/cmd_load_shed_up")

	if get("laminar/CitX/throttle/stow_emer_R") ~= 0 then
		command_once("laminar/CitX/throttle/stow_emer_R_toggle")
	end
	if get("laminar/CitX/throttle/stow_emer_L") ~= 0 then
		command_once("laminar/CitX/throttle/stow_emer_L_toggle")
	end
	if get("laminar/CitX/pressurization/cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_cabin_dump_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_cabin_dump") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_cabin_dump_toggle")
	end
	if get("laminar/CitX/ice/wing_crossover") ~= 0 then
		command_once("laminar/CitX/ice/cmd_wing_crossover_toggle")
	end
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	command_once("laminar/CitX/pressurization/cmd_pac_bleed_dwn")
	if get("laminar/CitX/pressurization/iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_iso_vlv_toggle")
	end
	if get("laminar/CitX/pressurization/safeguard_iso_vlv") ~= 0 then
		command_once("laminar/CitX/pressurization/cmd_safeguard_iso_vlv_toggle")
	end
	
end

-- ========================================================
-- set the takeoff details v-speeds, trim
-- function xkc_set_takeoff_details()
	-- command_once("sim/FMS/clb")
	-- command_once("sim/FMS/ls_2r")
	-- command_once("sim/FMS/ls_4r")
	-- local line = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line0") 
	-- command_once("sim/FMS/next")
	-- activeBriefings:set("takeoff:v1",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2"),1,3)) 
	-- activeBriefings:set("takeoff:vr",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4"),1,3)) 
	-- activeBriefings:set("takeoff:v2",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line6"),1,3)) 
	-- activeBriefings:set("takeoff:elevatorTrim",get("laminar/B738/FMS/trim_calc"))
-- end

-- set the landing details v-speeds, trim
-- function xkc_set_landing_details()
	-- command_once("sim/FMS/clb")
	-- command_once("sim/FMS/ls_4r")
	-- command_once("sim/FMS/next")
	-- command_once("sim/FMS/next")
	-- command_once("sim/FMS/next")
	-- local vrefline = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2")
	-- print(vrefline)
	-- if vrefline ~= "" then 
		-- activeBriefings:set("approach:vref",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line2"),1,3))
	-- end
	-- local vappline = get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4")
	-- if vappline ~= "" then 
		-- activeBriefings:set("approach:vapp",string.sub(get("sim/cockpit2/radios/indicators/fms_cdu1_text_line4"),1,3))
	-- end
-- end

-- =======================

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		set("sim/cockpit2/engine/actuators/mixture_ratio_all",1)
		if trigger == "engstart1" then
			command_begin("sim/starters/engage_start_run_1")
		end
		if trigger == "engstart2" then
			command_begin("sim/starters/engage_start_run_2")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_start_run_1")
			end
			if trigger == "engstart2" then
				command_end("sim/starters/engage_start_run_2")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("sim/cockpit2/engine/actuators/mixture_ratio_all",0)
end


-- APU start background
function kc_bck_apustart(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,30)
		sysElectric.apuMaster:actuate(1)
		command_begin("laminar/CitX/APU/starter_switch_up")
	else
		if kc_procvar_get(delayvar) <= 0 then
			command_end("laminar/CitX/APU/starter_switch_up")
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- bring apu gen & bleed online
function kc_bck_apuonline(trigger)
	if get("sim/cockpit2/electrical/APU_N1_percent") == 100 then
		sysElectric.apuGenBusGroup:actuate(1)
		sysAir.apuBleedSwitch:actuate(1)
		kc_procvar_set(trigger,false)
	end
end

-- APU start background
function kc_macro_apustop()
	command_end("laminar/CitX/APU/starter_switch_dwn")
	command_end("laminar/CitX/APU/starter_switch_dwn")
	sysElectric.apuStartSwitch:actuate(0)
	sysElectric.apuGenBusGroup:actuate(0)
	sysAir.apuBleedSwitch:actuate(0)
	sysElectric.apuMaster:actuate(0)
end

return sysMacros