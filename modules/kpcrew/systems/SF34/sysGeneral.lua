-- Sf34 airplane 
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("SF34 sysGeneral")

-- Parking Brake
sysGeneral.parkBrakeSwitch 	= TwoStateDrefSwitch:new("parkbrake","les/sf34a/acft/gear/mnp/parking_brake_handle",0)
	
-- Wiper Switches
sysGeneral.wiperLeft = TwoStateCustomSwitch:new("wiperleft","les/sf34a/acft/rain/anm/wiper_knob_L",0,
	function()
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_up_L")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_up_L")
	end,
	function()
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_L")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_L")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_L")
	end,
	function ()
	end,
	function()
		if get("les/sf34a/acft/rain/anm/wiper_knob_L") > 1 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.wiperRight = TwoStateCustomSwitch:new("wiperright","les/sf34a/acft/rain/anm/wiper_knob_R",0,
	function()
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_up_R")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_up_R")
	end,
	function()
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_R")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_R")
		command_once("les/sf34a/acft/rain/mnp/wiper_knob_dn_R")
	end,
	function ()
	end,
	function()
		if get("les/sf34a/acft/rain/anm/wiper_knob_R") > 1 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.wiperGroup = SwitchGroup:new("wipers")
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperLeft)
sysGeneral.wiperGroup:addSwitch(sysGeneral.wiperRight)

sysGeneral.noSmokingSwitch	= TwoStateToggleSwitch:new("nosmoke","les/sf34a/acft/comm/anm/no_smoking_sign_switch",0,
	"les/sf34a/acft/comm/mnp/no_smoking_sign_switch")

sysGeneral.passSignsSwitch	= TwoStateToggleSwitch:new("seatbelts","les/sf34a/acft/comm/anm/seat_belt_sign_switch",0,
	"les/sf34a/acft/comm/mnp/seat_belt_sign_switch")

-- Doors
sysGeneral.doorL1			= TwoStateCustomSwitch:new("doorl1","les/sf34a/acft/emrg/anm/main_door",0,
	function () 
		kc_procvar_set("door1open",true)
	end,
	function () 
		kc_procvar_set("door1close",true)
	end,
	function () 
	end,
	function () 
		if get("les/sf34a/acft/emrg/anm/main_door",0) ~= 0 then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorACargo 		= TwoStateCustomSwitch:new("dooracargo","les/sf34a/acft/emrg/anm/cargo_door",0,
	function () 
		kc_procvar_set("cargoopen",true)
	end,
	function () 
		kc_procvar_set("cargoclose",true)
	end,
	function () 
	end,
	function () 
		if get("les/sf34a/acft/emrg/anm/cargo_door",0) then
			return 1
		else
			return 0
		end
	end)
sysGeneral.stairsL1 		= TwoStateCustomSwitch:new("stairs1","les/sf34a/acft/emrg/anm/cabin_stair_fold",0,
	function () 
		kc_procvar_set("stairsout",true)
	end,
	function () 
		kc_procvar_set("stairsin",true)
	end,
	function () 
	end,
	function () 
		if get("les/sf34a/acft/emrg/anm/cabin_stair_fold",0) then
			return 1
		else
			return 0
		end
	end)
sysGeneral.doorGroup = SwitchGroup:new("doors")
sysGeneral.doorGroup:addSwitch(sysGeneral.doorL1)
sysGeneral.doorGroup:addSwitch(sysGeneral.doorACargo)
-- sysGeneral.doorGroup:addSwitch(sysGeneral.cockpitDoor)
sysGeneral.doorGroup:addSwitch(sysGeneral.stairsL1)

return sysGeneral