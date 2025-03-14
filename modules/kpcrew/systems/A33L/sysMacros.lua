-- Laminar A330 variants airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("A33L sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()
end

-- custom turnaround items
function kc_macro_custom_turnaround()
end

-- autobrake
function kc_macro_set_autobrake(index)
	if index ~= kc_AutoBrakeOff then
		if index == 1 and get("laminar/A333/annun/auto_brake/lo_on") == 0 then
			command_once("sim/flight_controls/brakes_1_auto")
		elseif index == 2 and get("laminar/A333/annun/auto_brake/med_on") == 0 then
			command_once("sim/flight_controls/brakes_2_auto")
		elseif index == 3 and get("laminar/A333/annun/auto_brake/max_on") == 0 then
			command_once("sim/flight_controls/brakes_rto_auto")
		end
	else
		if get("laminar/A333/annun/auto_brake/lo_on") > 0 then
			command_once("sim/flight_controls/brakes_1_auto")
		end
		if get("laminar/A333/annun/auto_brake/med_on") > 0 then
			command_once("sim/flight_controls/brakes_2_auto")
		end
		if get("laminar/A333/annun/auto_brake/max_on") > 0 then
			command_once("sim/flight_controls/brakes_rto_auto")
		end
	end
end

-- IRS off 0=OFF, 1=NAV, 2=ATT
function kc_macro_set_irs(mode)
	command_once("laminar/A333/knobs/adirs/ir1_knob_left")
	command_once("laminar/A333/knobs/adirs/ir1_knob_left")
	command_once("laminar/A333/knobs/adirs/ir2_knob_left")
	command_once("laminar/A333/knobs/adirs/ir2_knob_left")
	command_once("laminar/A333/knobs/adirs/ir3_knob_left")
	command_once("laminar/A333/knobs/adirs/ir3_knob_left")
	if mode == 0 then -- OFF
		-- do nothing see above
	elseif mode == 1 then -- ALIGN
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
	elseif mode == 2 then -- NAV 
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
		command_once("laminar/A333/knobs/adirs/ir1_knob_right")
		command_once("laminar/A333/knobs/adirs/ir2_knob_right")		
		command_once("laminar/A333/knobs/adirs/ir3_knob_right")
	end
end

function kc_macro_set_xpdrmode(mode)
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/ta_ra_left")
	command_once("laminar/A333/transponder/auto_on_off_left")
	command_once("laminar/A333/transponder/auto_on_off_left")
	command_once("laminar/A333/transponder/auto_on_off_right")
	if mode ~= sysRadios.stby then
		if mode == sysRadios.ta then
			command_once("laminar/A333/transponder/ta_ra_right")
		elseif mode == sysRadios.tara then
			command_once("laminar/A333/transponder/ta_ra_right")
			command_once("laminar/A333/transponder/ta_ra_right")
		end
	end
end

-- Airbus set EngineMode 0=off 1=ign/start 2=crank
function kc_macro_set_eng_mode(mode)
	if mode == 0 then
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_left")
	elseif mode == 1 then
		command_once("laminar/A333/switch/eng_mode_right")
		command_once("laminar/A333/switch/eng_mode_right")
	elseif mode == 2 then
		command_once("laminar/A333/switch/eng_mode_left")
		command_once("laminar/A333/switch/eng_mode_left")
	end
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,20)
		
		if trigger == "engstart1" then
			set("laminar/A333/switches/engine1_start_pos",1)
		end
		if trigger == "engstart2" then
			set("laminar/A333/switches/engine2_start_pos",1)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

return sysMacros