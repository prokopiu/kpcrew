-- TMPL airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("TMPL sysMacros")

-- ====================================== States related macros

-- aircraft specific custom steps not covered in default cold and dark flow
function kc_macro_custom_cold_dark()

end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()

end

function kc_macro_set_xpdrmode(mode)
	command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
	command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
	command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_dn")
	if mode == sysRadios.stby then
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
	end
	if mode == sysRadios.ta then
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
	end
	if mode == sysRadios.tara then
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
		command_once("les/sf34a/acft/avio/mnp/pl2_atc_func_knob_up")
	end
end

function kc_bck_door1_open(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,1)
		if get("les/sf34a/acft/emrg/anm/main_door_handle") == 1 then
			command_once("les/sf34a/acft/emrg/mnp/main_door_handle")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/main_door") == 1 then
				command_once("les/sf34a/acft/emrg/mnp/main_door")
			end	
			if get("les/sf34a/acft/gnrl/anm/cabin_attendant_seat") == 0 then
				command_once("les/sf34a/acft/gnrl/mnp/cabin_attendant_seat")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			kc_procvar_set("stairsout",true)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_bck_door1_close(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,2)
		if get("les/sf34a/acft/emrg/anm/main_door") == 0 then
			command_once("les/sf34a/acft/emrg/mnp/main_door")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/main_door_handle") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/main_door_handle")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_bck_cargo_open(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,1)
		if get("les/sf34a/acft/emrg/anm/cargo_door_handle") == 1 then
			command_once("les/sf34a/acft/emrg/mnp/cargo_door_handle")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/cargo_door") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/cargo_door")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_bck_cargo_close(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,2)
		if get("les/sf34a/acft/emrg/anm/cargo_door") == 1 then
			command_once("les/sf34a/acft/emrg/mnp/cargo_door")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/cargo_door_handle") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/cargo_door_handle")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_bck_stairs_out(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,1)
		if get("les/sf34a/acft/emrg/anm/cabin_stair_slide") == 0 then
			command_once("les/sf34a/acft/emrg/mnp/cabin_stair_slide_button")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/cabin_stair_fold") == 0 then
				command_once("les/sf34a/acft/emrg/mnp/cabin_stair_fold_button")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_bck_stairs_in(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,2)
		if get("les/sf34a/acft/emrg/anm/cabin_stair_fold") == 1 then
			command_once("les/sf34a/acft/emrg/mnp/cabin_stair_fold_button")
		end	
	else
		if kc_procvar_get(delayvar) <= 0 then
			if get("les/sf34a/acft/emrg/anm/cabin_stair_slide") == 1 then
				command_once("les/sf34a/acft/emrg/mnp/cabin_stair_slide_button")
			end	
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_macro_additional_bck_procs()
	if kc_procvar_get("door1open") == true then 
		kc_bck_door1_open("door1open")
	end
	if kc_procvar_get("door1close") == true then 
		kc_bck_door1_close("door1close")
	end
	if kc_procvar_get("cargoopen") == true then 
		kc_bck_cargo_open("cargoopen")
	end
	if kc_procvar_get("cargoclose") == true then 
		kc_bck_cargo_close("cargoclose")
	end
	if kc_procvar_get("stairsout") == true then 
		kc_bck_stairs_out("stairsout")
	end
	if kc_procvar_get("stairsin") == true then 
		kc_bck_stairs_in("stairsin")
	end
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,5)
		if trigger == "engstart1" then
			set("les/sf34a/acft/engn/mnp/condition_lever_L",19)
			command_begin("les/sf34a/acft/engn/mnp/start_switch_L")
		end
		if trigger == "engstart2" then
			set("les/sf34a/acft/engn/mnp/condition_lever_R",19)
			command_begin("les/sf34a/acft/engn/mnp/start_switch_R")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("les/sf34a/acft/engn/mnp/start_switch_L")
			end
			if trigger == "engstart2" then
				command_end("les/sf34a/acft/engn/mnp/start_switch_R")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("les/sf34a/acft/engn/mnp/condition_lever_L",0)
	set("les/sf34a/acft/engn/mnp/condition_lever_R",0)
end

-- set flaps based on index
function kc_macro_set_flap(flapindex)
	set("les/sf34a/acft/fltc/mnp/flap_handle",sysControls.flaps_pos[flapindex])
end

return sysMacros