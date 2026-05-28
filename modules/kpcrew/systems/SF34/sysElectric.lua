-- SF34 airplane 
-- Electric system functionality

-- @classmod sysElectric
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

sysElectric = require("kpcrew.systems.DFLT.sysElectric")

logMsg("SF34 sysElectric")

-- ** BATTERY Switch
sysElectric.batteryGroup 	= SwitchGroup:new("battery switches")
sysElectric.batterySwitch 	= TwoStateCustomSwitch:new("battery1","les/sf34a/acft/elec/anm/battery_switch_L",0,
	function ()
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_up_L")
	end,
	function ()
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/battery_switch_L") == 0 then
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_up_L")
		else
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_L")
		end		
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/battery_switch_L") ~= 0 then
			return 1
		else
			return 0
		end
	end)
	
sysElectric.battery2Switch 	= TwoStateCustomSwitch:new("battery2","les/sf34a/acft/elec/anm/battery_switch_R",0,
	function ()
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_up_R")
	end,
	function ()
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/battery_switch_R") == 0 then
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_up_R")
		else
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/battery_switch_dn_R")
		end		
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/battery_switch_R") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysElectric.batteryGroup:addSwitch(batterySwitch)

-- ----- GPU
sysElectric.gpuGenBusGroup	= SwitchGroup:new("gpubussgroup")
sysElectric.gpuConnect 		= TwoStateCustomSwitch:new("GPU","LES/saab/gpu/power_available",0,
function ()
end,
function ()
end,
function ()
end,
function ()
	return get("LES/saab/gpu/power_available")
end)	
sysElectric.gpuGenBus1 		= TwoStateToggleSwitch:new("gpubus1","les/sf34a/acft/elec/anm/external_power_switch",0,
	"les/sf34a/acft/elec/mnp/external_power_switch")
sysElectric.gpuGenBusGroup:addSwitch(sysElectric.gpuGenBus1)

-- ** Avionics Buses
sysElectric.avionics1Bus		= TwoStateToggleSwitch:new("aviobus1","les/sf34a/acft/elec/anm/avionics_switch_L",0,
	"les/sf34a/acft/elec/mnp/avionics_switch_L")
sysElectric.avionics2Bus		= TwoStateToggleSwitch:new("aviobus2","les/sf34a/acft/elec/anm/avionics_switch_R",0,
	"les/sf34a/acft/elec/mnp/avionics_switch_R")
sysElectric.avionics3Bus		= TwoStateToggleSwitch:new("aviobus3","les/sf34a/acft/elec/anm/avionics_switch_ess",0,
	"les/sf34a/acft/elec/mnp/avionics_switch_ess")
sysElectric.avionicsSwitchGroup = SwitchGroup:new("altswitches")
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics1Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics2Bus)
sysElectric.avionicsSwitchGroup:addSwitch(sysElectric.avionics3Bus)

-- ---- Engine Generators
sysElectric.genSwitchGroup 	= SwitchGroup:new("generators")
sysElectric.gen1Switch 		= TwoStateCustomSwitch:new("gen1","les/sf34a/acft/elec/anm/dc_gen_switch_L",0,
	function ()
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_up_L")
	end,
	function ()
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/dc_gen_switch_L") == 0 then
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_up_L")
		else
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_L")
		end		
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/dc_gen_switch_L") ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysElectric.genSwitchGroup:addSwitch(sysElectric.gen1Switch)
	sysElectric.gen2Switch 	= TwoStateCustomSwitch:new("gen2","les/sf34a/acft/elec/anm/dc_gen_switch_R",0,
	function ()
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_up_R")
	end,
	function ()
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
		command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/dc_gen_switch_R") == 0 then
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_up_R")
		else
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
			command_once("les/sf34a/acft/elec/mnp/dc_gen_switch_dn_R")
		end		
	end,
	function ()
		if get("les/sf34a/acft/elec/anm/dc_gen_switch_R") ~= 0 then
			return 1
		else
			return 0
		end
	end)
	sysElectric.genSwitchGroup:addSwitch(sysElectric.gen2Switch)

-- ---- Inverters
sysElectric.inverter1Switch 		= TwoStateToggleSwitch:new("inverter1","les/sf34a/acft/elec/anm/main_inverter_switch",0,
	"les/sf34a/acft/elec/mnp/main_inverter_switch")
sysElectric.inverterSwitchGroup 	= SwitchGroup:new("inverters")
sysElectric.inverterSwitchGroup:addSwitch(sysElectric.inverter1Switch)

return sysElectric
