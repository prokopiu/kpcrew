-- ToLiss Airbusses
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- Overwrite system elements
-- sysEngines.engStart1Switch - Starter Switches
-- sysEngines.engStart2Switch
-- sysEngines.engStart3Switch	
-- sysEngines.engStart4Switch
-- sysEngines.engStarterGroup
-- sysEngines.engIgnitionGroup
-- Macro: kc_bck_start_engine 
-- Macro: kc_macro_set_eng_mode 

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
local drefEngine1Starter 	= "AirbusFBW/ENG1MasterSwitch"
local drefEngine2Starter 	= "AirbusFBW/ENG2MasterSwitch"
local drefEngine3Starter 	= "AirbusFBW/ENG3MasterSwitch"
local drefEngine4Starter 	= "AirbusFBW/ENG4MasterSwitch"
local drefIgnition			= "AirbusFBW/anim/ENGModeSwitch"

--------- Switch commands common
local cmdIgnitionOn			= "toliss_airbus/engcommands/EngineModeSwitchToStart"
local cmdIgnitionOff		= "toliss_airbus/engcommands/EngineModeSwitchToNorm"
local cmdEgine1Starter		= "toliss_airbus/engcommands/Master1On"
local cmdEgine2Starter		= "toliss_airbus/engcommands/Master2On"
local cmdEgine3Starter		= "toliss_airbus/engcommands/Master3On"
local cmdEgine4Starter		= "toliss_airbus/engcommands/Master4On"
local cmdEngModeSelNorm		= "toliss_airbus/engcommands/EngineModeSwitchToNorm"
local cmdEngModeSelStart	= "toliss_airbus/engcommands/EngineModeSwitchToStart"
local cmdEngModeSelCrank	= "toliss_airbus/engcommands/EngineModeSwitchToCrank"

logMsg("A3TL sysEngines")

sysEngines = require("kpcrew.systems.DFLT.sysEngines")

----------- Switches

-- Starter Switches for up to 4 engines
sysEngines.engStart1Switch	= TwoStateDrefSwitch:new("starter1",drefEngine1Starter,0)
sysEngines.engStart2Switch	= TwoStateDrefSwitch:new("starter2",drefEngine2Starter,0)
sysEngines.engStart3Switch	= TwoStateDrefSwitch:new("starter3",drefEngine3Starter,0)
sysEngines.engStart4Switch	= TwoStateDrefSwitch:new("starter4",drefEngine4Starter,0)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)

-- ENGINE IGNITION replaced for Engine Mode
sysEngines.engIgnitionGroup	= TwoStateCmdSwitch:new("Ignition",drefIgnition,0,
	cmdIgnitionOn,cmdIgnitionOff,"nocommand")

--------- Macros

-- Macro: Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = trigger .. "delay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,20)
		if trigger == "engstart1" then
			kc_speakNoText(0,"Starting engine 1")
			command_once(cmdEgine1Starter)
		end
		if trigger == "engstart2" then
			kc_speakNoText(0,"Starting engine 2")
			command_once(cmdEgine2Starter)
		end
		if trigger == "engstart3" then
			kc_speakNoText(0,"Starting engine 3")
			command_once(cmdEgine3Starter)
		end
		if trigger == "engstart4" then
			kc_speakNoText(0,"Starting engine 4")
			command_once(cmdEgine4Starter)
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

-- Macro: Airbus set EngineMode 0=off 1=ign/start 2=crank
function kc_macro_set_eng_mode(mode)
	if mode == 0 then
		command_once(cmdEngModeSelNorm)
	elseif mode == 1 then
		command_once(cmdEngModeSelStart)
	elseif mode == 2 then
		command_once(cmdEngModeSelCrank)
	end
end	

return sysEngines
