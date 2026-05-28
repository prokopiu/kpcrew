-- C510 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

logMsg("C510 sysEngines")

--------- Macros

-- Macro: Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		command_once("sim/engines/mixture_max")
		if trigger == "engstart1" then
			if get("vsl/510x/throttle_anim_L") == 0 then
				command_once("vskylabs/510x/throttles/throttle_L_cutoff_toggle")
			end
			command_begin("vskylabs/510x/starters/left_starter_push")
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			if get("vsl/510x/throttle_anim_R") == 0 then
				command_once("vskylabs/510x/throttles/throttle_R_cutoff_toggle")
			end
			command_begin("vskylabs/510x/starters/right_starter_push")
			kc_speakNoText(0,"Starting Engine 2")

		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			-- if trigger == "engstart1" then
				-- command_end(cmdEgine1Starter)
			-- end
			-- if trigger == "engstart2" then
				-- command_end(cmdEgine2Starter)
			-- end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Macro: Stop engines 
function kc_macro_stop_engine()
	if get("vsl/510x/throttle_anim_L") > 0 then
		command_once("vskylabs/510x/throttles/throttle_L_cutoff_toggle")
	end
	if get("vsl/510x/throttle_anim_R") > 0 then
		command_once("vskylabs/510x/throttles/throttle_R_cutoff_toggle")
	end
end

return sysEngines
