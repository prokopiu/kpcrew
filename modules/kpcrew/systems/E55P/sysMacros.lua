-- E55P airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("E55P sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()
	if get("aerobask/hide_static") == 1 then
		command_once("aerobask/options/toggle_static_elements")
	end
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_rt")
	command_once("aerobask/iceprot/insp_light_off")
	set("aerobask/airco/knob_ckpt_temp",0)
	set("aerobask/airco/knob_cabin_temp",0)
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/mode_dn")
	command_once("aerobask/airco/mode_dn")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_lt")
	command_once("aerobask/test/test_lt")	
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_1_lt")
	command_once("aerobask/engines/knob_2_lt")
	command_once("aerobask/engines/knob_2_lt")	
	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_1_dn")
	command_once("aerobask/engines/ignition_2_dn")
	command_once("aerobask/engines/ignition_2_dn")	
end

-- custom turnaround items
function kc_macro_custom_turnaround()
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_lt")
	command_once("aerobask/oxygen/supply_rt")	
		command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_rt")
	command_once("aerobask/test/test_lt")
	command_once("aerobask/test/test_lt")
	set("aerobask/airco/knob_ckpt_temp",0)
	set("aerobask/airco/knob_cabin_temp",0)
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/cabin_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/ckpt_fan_dn")
	command_once("aerobask/airco/mode_dn")
	command_once("aerobask/airco/mode_dn")
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_dn")
			command_once("aerobask/engines/ignition_1_up")
			command_once("aerobask/engines/knob_1_rt")
			command_begin("aerobask/engines/knob_1_rt")
		end
		if trigger == "engstart2" then
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_dn")
			command_once("aerobask/engines/ignition_2_up")
			command_once("aerobask/engines/knob_2_rt")
			command_begin("aerobask/engines/knob_2_rt")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("aerobask/engines/knob_1_rt")
			end
			if trigger == "engstart2" then
				command_end("aerobask/engines/knob_2_rt")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- set the flaps
function kc_macro_set_flap(flapindex)

	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")
	command_once("sim/flight_controls/flaps_up")

	if flapindex == 1 then
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 2 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 3 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

	if flapindex == 4 then
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
		command_once("sim/flight_controls/flaps_down")
	end

end

return sysMacros