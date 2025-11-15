-- B742 airplane 
-- Engine related functionality

-- @classmod sysEngines
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements overwrite
-- sysEngines.engStart1Switch
-- sysEngines.engStart2Switch
-- sysEngines.engStart3Switch	
-- sysEngines.engStart4Switch
-- sysEngines.engStarterGroup
-- Macro: kc_bck_start_engine 
-- Macro: kc_macro_stop_engine 

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

logMsg("B742 sysEngines")

--------- Switch datarefs common
local drefEngineStarter1 	= "B742/OVHD/engine_ignition_sys_1"
local drefEngineStarter2 	= "B742/OVHD/engine_ignition_sys_2"

-- ignition
sysEngines.engStart1Switch	= TwoStateDrefSwitch:new("ignition1",drefEngineStarter1,-1)
sysEngines.engStart2Switch	= TwoStateDrefSwitch:new("ignition2",drefEngineStarter1,1)
sysEngines.engStart3Switch	= TwoStateDrefSwitch:new("ignition3",drefEngineStarter1,2)
sysEngines.engStart4Switch	= TwoStateDrefSwitch:new("ignition4",drefEngineStarter1,3)
sysEngines.engStart5Switch	= TwoStateDrefSwitch:new("ignition1",drefEngineStarter2,-1)
sysEngines.engStart6Switch	= TwoStateDrefSwitch:new("ignition2",drefEngineStarter2,1)
sysEngines.engStart7Switch	= TwoStateDrefSwitch:new("ignition3",drefEngineStarter2,2)
sysEngines.engStart8Switch	= TwoStateDrefSwitch:new("ignition4",drefEngineStarter2,3)
sysEngines.engStarterGroup 	= SwitchGroup:new("engstarters")
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart1Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart2Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart3Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart4Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart5Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart6Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart7Switch)
sysEngines.engStarterGroup:addSwitch(sysEngines.engStart8Switch)

--------- Macros

-- Start engines 
function kc_bck_start_engine(trigger)
	local delayvar = "engstartdelay"
	if kc_procvar_exists(delayvar) == false then
		kc_procvar_initialize_count(delayvar,-1)
	end
	if kc_procvar_get(delayvar) == -1 then
		kc_procvar_set(delayvar,15)
		if trigger == "engstart1" then
			set("B742/controls/fuel_cut_off_pos_1",1)
			sysEngines.engStart1Switch:actuate(1)
		end
		if trigger == "engstart2" then
			set("B742/controls/fuel_cut_off_pos_2",1)
			sysEngines.engStart2Switch:actuate(1)
		end
		if trigger == "engstart3" then
			set("B742/controls/fuel_cut_off_pos_3",1)
			sysEngines.engStart3Switch:actuate(1)
		end
		if trigger == "engstart4" then
			set("B742/controls/fuel_cut_off_pos_4",1)	
			sysEngines.engStart4Switch:actuate(1)
		end
	else
		if kc_procvar_get(delayvar) <= 0 then
			kc_procvar_set(trigger,false)
			kc_procvar_set(delayvar,-1)
			if trigger == "engstart1" then
				sysEngines.engStart1Switch:actuate(0)
			end
			if trigger == "engstart2" then
				sysEngines.engStart2Switch:actuate(0)
			end
			if trigger == "engstart3" then
				sysEngines.engStart3Switch:actuate(0)
			end
			if trigger == "engstart4" then
				sysEngines.engStart4Switch:actuate(0)
			end
		else
			kc_procvar_set(delayvar,kc_procvar_get(delayvar)-1)
		end
	end
end

-- Stop engines 
function kc_macro_stop_engine()
	set("B742/controls/fuel_cut_off_pos_1",0)
	set("B742/controls/fuel_cut_off_pos_2",0)
	set("B742/controls/fuel_cut_off_pos_3",0)
	set("B742/controls/fuel_cut_off_pos_4",0)	
end

return sysEngines
