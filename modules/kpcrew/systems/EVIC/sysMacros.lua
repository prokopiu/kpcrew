-- EVIC airplane 
-- Macros

-- @classmod sysMacros
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysMacros = {
}

sysMacros = require("kpcrew.systems.DFLT.sysMacros")

logMsg("EVIC sysMacros")

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			command_begin("sim/starters/engage_start_run_1")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end("sim/starters/engage_start_run_1")
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

function kc_macro_lights_for_takeoff()
	-- set the lights when entering the runway
	kc_macro_lights_before_taxi()
	sysLights.taxiSwitch:actuate(0)
	sysLights.landLightGroup:actuate(1)
	sysLights.strobesSwitch:actuate(1)
	if kc_is_daylight() then
		sysLights.domeLightSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0)
		sysLights.instrLightGroup:actuate(1)
	else
		sysLights.domeLightSwitch:actuate(0)
		sysLights.panelLightGroup:actuate(0.5)
		sysLights.instrLightGroup:actuate(0.6)
	end
end

return sysMacros