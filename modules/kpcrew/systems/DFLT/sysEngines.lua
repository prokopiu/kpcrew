-- DFLT airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
System Elements
sysEngines.engStarterGroup
	sysEngines.engStartSwitch1
	sysEngines.engStartSwitch2
	sysEngines.engStartSwitch3 	
	sysEngines.engStartSwitch4
sysEngines.engineStarterAnc - 1 if a starter is running

sysEngines.engIgnitionGroup - Ignition Switches
	sysEngines.engIgnition1	
	sysEngines.engIgnition2
	sysEngines.engIgnition3
	sysEngines.engIgnition4

sysEngines.reverserGroup  - activate reversers for engines
	sysEngines.reverser1
	sysEngines.reverser2
	sysEngines.reverser3
	sysEngines.reverser4
sysEngines.reverseAnc


sysEngines.magnetoGroup 
sysEngines.magneto1 
sysEngines.magneto2
sysEngines.magneto3
sysEngines.magneto4

sysEngines.throttlePos
sysEngines.mixtureLever
sysEngines.propLever
sysEngines.engineFireAnc
sysEngines.OilPressureAnc

sysEngines.oilqty1
sysEngines.oilqty2
sysEngines.oilqty3
sysEngines.oilqty4

Macro: kc_bck_start_engine 
Macro: kc_macro_stop_engine 
Macro: kc_macro_set_eng_mode
]]

local sysEngines = {
	magneto_off = 0,
	magneto_left = 1,
	magneto_right = 2,
	magneto_both = 3,
	magneto_start = 4,
	magneto_stopstart = 5
}

--------- Switch datarefs common
local drefReverserState		= "sim/cockpit2/annunciators/reverser_on"
local drefEngineOil 		= "sim/cockpit/warnings/annunciators/oil_pressure_low"
local drefEngineFire 		= "sim/cockpit2/annunciators/engine_fires"

--------- Annunciator datarefs common
local drefThrottlePos		= "sim/cockpit2/engine/actuators/throttle_ratio_all"
local drefMixturePos		= "sim/cockpit2/engine/actuators/mixture_ratio_all"
local drefPropPos			= "sim/cockpit2/engine/actuators/prop_rotation_speed_rad_sec_all"
local drefOilQty			= "sim/cockpit2/engine/indicators/oil_quantity_ratio"
-- local drefReverserAnn		= "sim/cockpit/warnings/annunciators/reverse"

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

logMsg("DFLT sysEngines")

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysEnginesDefinitions")

----------- Switches

-- Starter Switches for up to 4 engines
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStartSwitch1	= kc_setup_element(def.engStartSwitch1)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStartSwitch1)
if kc_num_engines > 1 then
	sysEngines.engStartSwitch2	= kc_setup_element(def.engStartSwitch2)
	sysEngines.engStarterGroup:addSwitch(sysEngines.engStartSwitch2)
end
if kc_num_engines > 2 then
	sysEngines.engStartSwitch3	= kc_setup_element(def.engStartSwitch3)
	sysEngines.engStarterGroup:addSwitch(sysEngines.engStartSwitch3)
end
if kc_num_engines > 3 then
	sysEngines.engStartSwitch4	= kc_setup_element(def.engStartSwitch4)
	sysEngines.engStarterGroup:addSwitch(sysEngines.engStartSwitch4)
end

-- ** ENGINE STARTER annunciator
sysEngines.engineStarterAnc = kc_setup_element(def.engineStarterAnc)

-- ENGINE IGNITION
if kc_has_ignition then
	sysEngines.engIgnitionGroup = SwitchGroup:new("ignition switches")
	sysEngines.engIgnition1		= kc_setup_element(def.engIgnition1)
	sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)
	if kc_num_ignition > 1 then
		sysEngines.engIgnition2	= kc_setup_element(def.engIgnition2)
		sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition2)
	end
	if kc_num_ignition > 2 then
		sysEngines.engIgnition3		= kc_setup_element(def.engIgnition3)
		sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition3)
	end
	if kc_num_ignition > 3 then
		sysEngines.engIgnition4		= kc_setup_element(def.engIgnition4)
		sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition4)
	end
else
	sysEngines.engIgnitionGroup = SwitchGroup:new("ignition switches")
	sysEngines.engIgnition1		= kc_setup_element({etype=kc_swtype_inop, name="Ignition 1"})
	sysEngines.engIgnitionGroup:addSwitch(sysEngines.engIgnition1)
end

-- REVERSERS
if kc_has_reversers then
	sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
	sysEngines.reverser1 		= kc_setup_element(def.reverser1)
	sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
	if kc_num_reversers > 1 then
		sysEngines.reverser2 	= kc_setup_element(def.reverser2)
		sysEngines.reverserGroup:addSwitch(sysEngines.reverser2)
	end
	if kc_num_reversers > 2 then
		sysEngines.reverser3 	= kc_setup_element(def.reverser3)
		sysEngines.reverserGroup:addSwitch(sysEngines.reverser3)
	end
	if kc_num_reversers > 3 then
		sysEngines.reverser4 	= kc_setup_element(def.reverser4)
		sysEngines.reverserGroup:addSwitch(sysEngines.reverser4)
	end
else
	sysEngines.reverserGroup 	= SwitchGroup:new("reversers")
	sysEngines.reverser1 		= kc_setup_element({etype=kc_swtype_inop, name="Reverser 1"})
	sysEngines.reverserGroup:addSwitch(sysEngines.reverser1)
end

-- ** Magnetos set individual positions
if kc_has_magneto_sw then
	sysEngines.magnetoGroup = SwitchGroup:new("Magnetos")
	sysEngines.magneto1		= kc_setup_element(def.magneto1)
	sysEngines.magnetoGroup:addSwitch(sysEngines.magneto1)
	if kc_num_magneto_sw > 1 then
		sysEngines.magneto2		= kc_setup_element(def.magneto2)
		sysEngines.magnetoGroup:addSwitch(sysEngines.magneto2)
	end
	if kc_num_magneto_sw > 2 then
		sysEngines.magneto3		= kc_setup_element(def.magneto3)
		sysEngines.magnetoGroup:addSwitch(sysEngines.magneto3)
	end
	if kc_num_magneto_sw > 3 then
		sysEngines.magneto4		= kc_setup_element(def.magneto4)
		sysEngines.magnetoGroup:addSwitch(sysEngines.magneto4)
	end
else
	sysEngines.magnetoGroup = SwitchGroup:new("Magnetos")
	sysEngines.magneto1		= kc_setup_element({etype=kc_swtype_inop, name="Magneto 1"})
	sysEngines.magnetoGroup:addSwitch(sysEngines.magneto1)
end

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
	if get("sim/cockpit2/annunciators/reverser_on") > 0 then
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