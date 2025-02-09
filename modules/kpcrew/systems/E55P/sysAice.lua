-- Aerobask E55P airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysAice = {
}

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

logMsg("E55P sysAice")

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateCmdSwitch:new("eng1aice","aerobask/iceprot/sw_eng1",0,
	"aerobask/iceprot/eng1_on", "aerobask/iceprot/eng1_off", "nocommand")
sysAice.engAntiIce2 		= TwoStateCmdSwitch:new("eng2aice","aerobask/iceprot/sw_eng2",0,
	"aerobask/iceprot/eng2_on", "aerobask/iceprot/eng2_off", "nocommand")
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- Window Heat
sysAice.windowHeat1 		= TwoStateCmdSwitch:new("winheat1","aerobask/iceprot/sw_wshld1",0,
	"aerobask/iceprot/wshld1_on","aerobask/iceprot/wshld1_off","nocommand")
sysAice.windowHeat2 		= TwoStateCmdSwitch:new("winheat2","aerobask/iceprot/sw_wshld2",0,
	"aerobask/iceprot/wshld2_on","aerobask/iceprot/wshld2_off","nocommand")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateCustomSwitch:new("wingaice","aerobask/iceprot/sw_wingstab",0,
function ()
	command_once("aerobask/iceprot/wingstab_up")
	command_once("aerobask/iceprot/wingstab_up")
end,
function ()
	command_once("aerobask/iceprot/wingstab_dn")
	command_once("aerobask/iceprot/wingstab_dn")
end,
function ()
end,
function ()
	if get("aerobask/iceprot/sw_wingstab") == 2 then
		return 1
	else
		return 0
	end
end)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)


return sysAice