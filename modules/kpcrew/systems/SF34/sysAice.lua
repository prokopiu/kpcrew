-- SF34 airplane 
-- Anti Ice functionality

-- @classmod sysAice
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

sysAice = require("kpcrew.systems.DFLT.sysAice")

logMsg("SF34 sysAice")

-- ENG anti ice
sysAice.propAntiIce1		= TwoStateCustomSwitch:new("propaice1","les/sf34a/acft/icep/anm/prop_heat_switch_L",0,
	function ()
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_L")
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_L")
	end,
	function ()
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_L")
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_L")
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/prop_heat_switch_L") == 0 then
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_L")
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_L")
		else
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_L")
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_L")
		end
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/prop_heat_switch_L") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysAice.propAntiIce2		= TwoStateCustomSwitch:new("propaice2","les/sf34a/acft/icep/anm/prop_heat_switch_LR",0,
	function ()
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_R")
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_R")
	end,
	function ()
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_R")
		command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_R")
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/prop_heat_switch_R") == 0 then
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_R")
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_up_R")
		else
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_R")
			command_once("les/sf34a/acft/icep/mnp/prop_heat_switch_dn_R")
		end
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/prop_heat_switch_R") ~= 0 then
			return 1
		else
			return 0
		end
	end)
	
sysAice.engAntiIce1 		= TwoStateToggleSwitch:new("eng1aice","les/sf34a/acft/icep/anm/engine_antiice_switch_L",0,
	"les/sf34a/acft/icep/mnp/engine_antiice_switch_L")
sysAice.engAntiIce2 		= TwoStateToggleSwitch:new("eng2aice","les/sf34a/acft/icep/anm/engine_antiice_switch_R",0,
	"les/sf34a/acft/icep/mnp/engine_antiice_switch_R")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.propAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.propAntiIce2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateCustomSwitch:new("wingaice","les/sf34a/acft/icep/anm/boot_autocycling_switch",0,
	function ()
		command_once("les/sf34a/acft/icep/mnp/boot_autocycling_switch_up")
		command_once("les/sf34a/acft/icep/mnp/boot_autocycling_switch_up")
	end,
	function ()
		command_once("les/sf34a/acft/icep/mnp/boot_autocycling_switch_up")
		command_once("les/sf34a/acft/icep/mnp/boot_autocycling_switch_up")
		command_once("les/sf34a/acft/icep/mnp/boot_autocycling_switch_dn")
	end,
	function ()
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/boot_autocycling_switch") ~= 1 then
			return 1
		else
			return 0
		end
	end)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- Window Heat
sysAice.windowHeat1 		= TwoStateToggleSwitch:new("winheat1","les/sf34a/acft/icep/anm/front_window_heat_switch_L",0,
	"les/sf34a/acft/icep/mnp/front_window_heat_switch_L")
sysAice.windowHeat2 		= TwoStateToggleSwitch:new("winheat2","les/sf34a/acft/icep/anm/front_window_heat_switch_R",0,
	"les/sf34a/acft/icep/mnp/front_window_heat_switch_R")
sysAice.windowHeat3 		= TwoStateCustomSwitch:new("winheat3","les/sf34a/acft/icep/anm/side_window_heat_switch_L",0,
	function ()
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_L")
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_L")
	end,
	function ()
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_L")
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_L")
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/side_window_heat_switch_L") == 0 then
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_L")
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_L")
		else
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_L")
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_L")
		end
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/side_window_heat_switch_L") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysAice.windowHeat4 		= TwoStateCustomSwitch:new("winheat4","les/sf34a/acft/icep/anm/side_window_heat_switch_R",0,
	function ()
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_R")
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_R")
	end,
	function ()
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_R")
		command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_R")
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/side_window_heat_switch_R") == 0 then
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_R")
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_up_R")
		else
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_R")
			command_once("les/sf34a/acft/icep/mnp/side_window_heat_switch_dn_R")
		end
	end,
	function ()
		if get("les/sf34a/acft/icep/anm/side_window_heat_switch_R") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

return sysAice