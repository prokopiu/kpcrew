-- B7x7 FF B757 B767 airplane 
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

logMsg("B7x7 sysAice")

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","anim/41/button",0)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","anim/42/button",0)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","anim/40/button",0)
sysAice.wingAiceGroup 		= SwitchGroup:new("wingaice")
sysAice.wingAiceGroup:addSwitch(sysAice.wingAntiIce)

-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("winheat1","anim/47/button",0)
sysAice.windowHeat2 		= TwoStateDrefSwitch:new("winheat2","anim/48/button",0)
sysAice.windowHeat3 		= TwoStateDrefSwitch:new("winheat3","anim/49/button",0)
sysAice.windowHeat4 		= TwoStateDrefSwitch:new("winheat4","anim/50/button",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat3)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat4)

return sysAice