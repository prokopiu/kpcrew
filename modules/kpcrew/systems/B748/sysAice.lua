-- B748 airplane 
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

logMsg("B748 sysAice")

-- Window Heat
sysAice.windowHeat1 		= TwoStateCmdSwitch:new("winheat1","ssg/ICE/sheldL_sw",0)
sysAice.windowHeat2 		= TwoStateCmdSwitch:new("winheat2","ssg/ICE/sheldR_sw",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","ssg/ICE/ice_wing_sw",0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","ssg/ICE/ice_eng1_sw",0)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","ssg/ICE/ice_eng2_sw",0)
sysAice.engAntiIce3 		= TwoStateDrefSwitch:new("eng3aice","ssg/ICE/ice_eng3_sw",0)
sysAice.engAntiIce4 		= TwoStateDrefSwitch:new("eng4aice","ssg/ICE/ice_eng4_sw",0)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce3)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce4)

return sysAice