-- SF50 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("SF50 sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()
	set("sim/cockpit2/oxygen/actuators/demand_flow_setting",0)
	set_array("sim/cockpit2/switches/custom_slider_on",21,0)
	set_array("sim/cockpit2/switches/custom_slider_on",22,0)
end

-- custom turnaround items
function kc_macro_custom_turnaround()
	set("sim/cockpit2/oxygen/actuators/demand_flow_setting",0)
	set_array("sim/cockpit2/switches/custom_slider_on",21,0)
	set_array("sim/cockpit2/switches/custom_slider_on",22,0)
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
			command_begin("laminar/SF50/eng_start_stop_toggle")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("laminar/SF50/eng_start_stop_toggle")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	command_once("laminar/SF50/ignition_down")
	command_once("laminar/SF50/eng_start_stop_toggle")
end

return sysMacros