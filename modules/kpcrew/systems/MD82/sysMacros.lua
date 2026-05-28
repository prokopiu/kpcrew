-- MD82 airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("MD82 sysMacros")

-- custom cold & dark activities
function kc_macro_custom_cold_dark()
	sysElectric.galleyPower:actuate(0)
end

-- aircraft specific custom steps not covered in default turnaround flow
function kc_macro_custom_turnaround()
	sysElectric.galleyPower:actuate(1)
end

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		command_once("sim/engines/mixture_max")
		if trigger == "engstart1" then
			command_begin("sim/starters/engage_start_run_1")
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			command_begin("sim/starters/engage_start_run_2")
			kc_speakNoText(0,"Starting Engine 2")
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

-- speedbugs set for t/o
function kc_macro_md82_set_to_speedbugs()
	set("laminar/md82/IAS/custom_bug4",0.680363)
	set("laminar/md82/IAS/custom_bug3",0.495849)
	set("laminar/md82/IAS/custom_bug2",0.376973)
	set("laminar/md82/IAS/custom_bug1",0.154392 + (activeBriefings:get("takeoff:v1")-100)*0.0038)
end

-- speedbugs set for ldg
function kc_macro_md82_set_ldg_speedbugs()
	set("laminar/md82/IAS/custom_bug4",0.57328)
	set("laminar/md82/IAS/custom_bug3",0.284922)
	set("laminar/md82/IAS/custom_bug2",0.270964)
	set("laminar/md82/IAS/custom_bug1",0.154392 + (activeBriefings:get("approach:vapp")-100)*0.0038)
end

return sysMacros