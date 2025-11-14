-- DFLT airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysEngines.engStart1Switch - Starter Switches
-- sysEngines.engStart2Switch
-- sysEngines.engStart3Switch	
-- sysEngines.engStart4Switch
-- sysEngines.engStarterGroup
-- sysEngines.engineStarterAnc - 1 if a starter is running
-- sysEngines.engIgnition1	- Ignition Switches
-- sysEngines.engIgnition2
-- sysEngines.engIgnition3
-- sysEngines.engIgnition4
-- sysEngines.engIgnitionGroup
-- sysEngines.reverser1 - activate reversers for engines
-- sysEngines.reverser2
-- sysEngines.reverser3
-- sysEngines.reverser4
-- sysEngines.reverserGroup
-- sysEngines.magnetoOff - Magneto positions
-- sysEngines.magnetoL
-- sysEngines.magnetoR
-- sysEngines.magnetoBoth
-- sysEngines.magnetoStartOn
-- sysEngines.magnetoStartStop
-- sysEngines.throttlePos
-- sysEngines.mixtureLever
-- sysEngines.propLever
-- sysEngines.engineFireAnc
-- sysEngines.OilPressureAnc
-- sysEngines.oilqty1
-- sysEngines.oilqty2
-- sysEngines.oilqty3
-- sysEngines.oilqty4
-- sysEngines.reverseAnc
-- Macro: kc_bck_start_engine 
-- Macro: kc_macro_stop_engine 
-- Macro: kc_macro_set_eng_mode

local sysEngines = {
	magneto_off = 0,
	magneto_left = 1,
	magneto_right = 2,
	magneto_both = 3,
	magneto_start = 4,
	magneto_stopstart = 5
}

logMsg("DFLT sysEngines")

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

--------- Switch datarefs common
local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefEngineStarter 	= "sim/flightmodel2/engines/starter_is_running"
local drefIgnition			= "sim/cockpit2/engine/actuators/auto_ignite_on"
local drefEngineOil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngineFire 		= "sim/cockpit2/annunciators/engine_fires"

--------- Annunciator datarefs common
local drefThrottlePos		= "sim/cockpit2/engine/actuators/throttle_ratio_all"
local drefMixturePos		= "sim/cockpit2/engine/actuators/mixture_ratio_all"
local drefPropPos			= "sim/cockpit2/engine/actuators/prop_rotation_speed_rad_sec_all"
local drefOilQty			= "sim/cockpit2/engine/indicators/oil_quantity_ratio"
local drefReverserAnn		= "sim/cockpit/warnings/annunciators/reverse"

--------- Switch commands common
local cmdReverser1			= "sim/engines/thrust_reverse_hold_1"
local cmdReverser2			= "sim/engines/thrust_reverse_hold_2"
local cmdReverser3			= "sim/engines/thrust_reverse_hold_3"
local cmdReverser4			= "sim/engines/thrust_reverse_hold_4"
local cmdMagneto1Off		= "sim/magnetos/magnetos_off_1"
local cmdMagneto1Left		= "sim/magnetos/magnetos_left_1"
local cmdMagneto1Right		= "sim/magnetos/magnetos_right_1"
local cmdMagneto1Both		= "sim/magnetos/magnetos_both_1"
local cmdMagneto1Start		= "sim/starters/engage_start_run_1"
local cmdMagneto1Stop		= "sim/starters/engage_start_run_1"
local cmdEgine1Starter		= "sim/starters/engage_start_run_1"
local cmdEgine2Starter		= "sim/starters/engage_start_run_2"
local cmdEgine3Starter		= "sim/starters/engage_start_run_3"
local cmdEgine4Starter		= "sim/starters/engage_start_run_4"

----------- Switches

-- Starter Switches for up to 4 engines
sysEngines.engStart1Switch	= TwoStateCustomSwitch:new("starter1","",0,
function () kc_procvar_set("engstart1",true) end,
function () kc_procvar_set("engstart1",false) end,
function () end,
function () return get(drefEngineStarter,0) end)

sysEngines.engStart2Switch	= TwoStateCustomSwitch:new("starter2","",0,
function () kc_procvar_set("engstart2",true) end,
function () kc_procvar_set("engstart2",false) end,
function () end,
function () return get(drefEngineStarter,1) end)

sysEngines.engStart3Switch	= TwoStateCustomSwitch:new("starter3","",0,
function () kc_procvar_set("engstart3",true) end,
function () kc_procvar_set("engstart3",false) end,
function () end,
function () return get(drefEngineStarter,2) end)

sysEngines.engStart4Switch	= TwoStateCustomSwitch:new("starter4","",0,
function () kc_procvar_set("engstart4",true) end,
function () kc_procvar_set("engstart4",false) end,
function () end,
function () return get(drefEngineStarter,3) end)

sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = CustomAnnunciator:new("enginestarter",
function ()
	if get(drefEngineStarter,0) > 0 or get(drefEngineStarter,1) > 0 or get(drefEngineStarter,2) > 0 or get(drefEngineStarter,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- ENGINE IGNITION
sysEngines.engIgnition1	= TwoStateDrefSwitch:new("ignition1",drefIgnition,-1)
sysEngines.engIgnition2	= TwoStateDrefSwitch:new("ignition2",drefIgnition,1)
sysEngines.engIgnition3	= TwoStateDrefSwitch:new("ignition3",drefIgnition,2)
sysEngines.engIgnition4	= TwoStateDrefSwitch:new("ignition4",drefIgnition,3)
sysEngines.engIgnitionGroup 	= SwitchGroup:new("ignitions")
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition2)
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition3)
sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition4)

-- REVERSERS
sysEngines.reverser1 		= TwoStateCustomSwitch:new("reverse1",drefReverserState,-1,
	function () command_begin(cmdReverser1) end,
	function () command_end(cmdReverser1) end,
	function () end	
)
sysEngines.reverser2 		= TwoStateCustomSwitch:new("reverse2",drefReverserState,1,
	function () command_begin(cmdReverser2) end,
	function () command_end(cmdReverser2) end,
	function () end	
)
sysEngines.reverser3 		= TwoStateCustomSwitch:new("reverse3",drefReverserState,2,
	function () command_begin(cmdReverser3)	end,
	function () command_end(cmdReverser3) end,
	function () end	
)
sysEngines.reverser4 		= TwoStateCustomSwitch:new("reverse4",drefReverserState,3,
	function () command_begin(cmdReverser4) end,
	function () command_end(cmdReverser4) end,
	function () end	
)
sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser2)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser3)
sysEngines.reverserGroup:addSwitch(sysEngines.reverser4)

-- ** Magnetos set individual positions
sysEngines.magnetoOff		= TwoStateCustomSwitch:new("magnetoOff","",0,
	function () command_once(cmdMagneto1Off) end,
	function () end,
	function () end	
)
sysEngines.magnetoL		= TwoStateCustomSwitch:new("magnetoL","",0,
	function () command_once(cmdMagneto1Left) end,
	function () end,
	function () end	
)
sysEngines.magnetoR		= TwoStateCustomSwitch:new("magnetoR","",0,
	function () command_once(cmdMagneto1Right) end,
	function () end,
	function () end	
)
sysEngines.magnetoBoth		= TwoStateCustomSwitch:new("magnetoBoth","",0,
	function () command_once(cmdMagneto1Both) end,
	function () end,
	function () end	
)
sysEngines.magnetoStartOn		= TwoStateCustomSwitch:new("magnetoStart","",0,
	function () command_begin(cmdMagneto1Start) end,
	function () end,
	function () end	
)
sysEngines.magnetoStartStop		= TwoStateCustomSwitch:new("magnetoStop","",0,
	function () command_end(cmdMagneto1Stop) end,
	function () end,
	function () end	
)

-- Throttle position 0-1
sysEngines.throttlePos			= TwoStateDrefSwitch:new("throttlepos",drefThrottlePos,0)

-- Mixture Lever position
sysEngines.mixtureLever			= TwoStateDrefSwitch:new("mixturelever",drefMixturePos,0)

-- Prop Lever position
sysEngines.propLever			= TwoStateDrefSwitch:new("proplever",drefPropPos,0)

----------- Annunciators

-- ** ENGINE FIRE annunciator
sysEngines.engineFireAnc 	= CustomAnnunciator:new("enginefire",
function ()
	if get(drefEngineFire,0) > 0 or get(drefEngineFire,1) > 0 or 
		get(drefEngineFire,2) > 0 or get(drefEngineFire,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- ** OIL PRESSURE annunciator
sysEngines.OilPressureAnc 	= CustomAnnunciator:new("oilpressure",
function ()
	if get(drefEngineOil,0) > 0 or get(drefEngineOil,1) > 0 or 
		get(drefEngineOil,2) > 0 or get(drefEngineOil,3) > 0 then
		return 1
	else
		return 0
	end
end)

-- OIL QUANTITY readout
sysEngines.oilqty1 = SimpleAnnunciator:new("oilqty1",drefOilQty,-1)
sysEngines.oilqty2 = SimpleAnnunciator:new("oilqty2",drefOilQty,1)
sysEngines.oilqty3 = SimpleAnnunciator:new("oilqty3",drefOilQty,2)
sysEngines.oilqty4 = SimpleAnnunciator:new("oilqty4",drefOilQty,3)


-- ** Reverse Thrust
sysEngines.reverseAnc 		= CustomAnnunciator:new("enginestarter",
function ()
	if get(drefReverserAnn) > 0 then
		return 1
	else
		return 0
	end
end)

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
			command_begin(cmdEgine1Starter)
			kc_speakNoText(0,"Starting Engine 1")
		end
		if trigger == "engstart2" then
			command_begin(cmdEgine2Starter)
			kc_speakNoText(0,"Starting Engine 2")
		end
		if trigger == "engstart3" then
			command_begin(cmdEgine3Starter)
			kc_speakNoText(0,"Starting Engine 3")
		end
		if trigger == "engstart4" then
			command_begin(cmdEgine4Starter)
			kc_speakNoText(0,"Starting Engine 4")
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				command_end(cmdEgine1Starter)
			end
			if trigger == "engstart2" then
				command_end(cmdEgine2Starter)
			end
			if trigger == "engstart3" then
				command_end(cmdEgine3Starter)
			end
			if trigger == "engstart4" then
				command_end(cmdEgine4Starter)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Macro: Stop engines 
function kc_macro_stop_engine()
	set(drefMixturePos,0)
	set(drefMixturePos,1)
	set(drefMixturePos,2)
	set(drefMixturePos,3)
end

-- Macro: Airbus set EngineMode 0=off 1=ign/start 2=crank
function kc_macro_set_eng_mode(mode)
end	

-- Macro: Set Prop Magneto
function kc_macro_set_magneto_mode(magneto, mode)
-- only supports one magneto for the moment
	if mode == sysEngines.magneto_off then
		command_once(cmdMagneto1Off)
	elseif mode == sysEngines.magneto_left then
		command_once(cmdMagneto1Left)
	elseif mode == sysEngines.magneto_right then
		command_once(cmdMagneto1Right)
	elseif mode == sysEngines.magneto_both then
		command_once(cmdMagneto1Both)
	elseif mode == sysEngines.magneto_start then
		command_once(cmdMagneto1Start)
	elseif mode == sysEngines.magneto_stopstart then
		command_once(cmdMagneto1Stop)
	end
end

return sysEngines