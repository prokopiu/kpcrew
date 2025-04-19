-- E55P airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("E55P sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateCustomSwitch:new("pack1","aerobask/press/knob_ecs",0,
function ()
	command_once("aerobask/press/ecs_lt")
	command_once("aerobask/press/ecs_lt")
	command_once("aerobask/press/ecs_lt")
	command_once("aerobask/press/ecs_rt")
	command_once("aerobask/press/ecs_rt")
end,
function ()
	command_once("aerobask/press/ecs_lt")
	command_once("aerobask/press/ecs_lt")
	command_once("aerobask/press/ecs_lt")
end,
function ()
end,
function ()
	if get("aerobask/press/knob_ecs") > 0 then
		return 1
	else
		return 0
	end
end)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateCmdSwitch:new("bleed1","aerobask/bleed/sw_bleed1",0,
	"aerobask/bleed/bleed1_auto", "aerobask/bleed/bleed1_off", "nocommand")
sysAir.bleedEng2Switch 		= TwoStateCmdSwitch:new("bleed2","aerobask/bleed/sw_bleed2",0,
	"aerobask/bleed/bleed2_auto", "aerobask/bleed/bleed2_off", "nocommand")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateCmdSwitch:new("isolation","aerobask/bleed/sw_xbleed",0,
	"aerobask/bleed/xbleed_auto","aerobask/bleed/xbleed_off","nocommand")

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateToggleSwitch:new("oxygen","aerobask/oxygen/sw_cut_out",0,
	"aerobask/oxygen/cut_out")
	

return sysAir