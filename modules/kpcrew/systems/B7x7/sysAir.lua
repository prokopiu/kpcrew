-- B7x7 FF B767 B757 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
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

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("B7x7 sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","1-sim/cond/leftPackSelector",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","1-sim/cond/rightPackSelector",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateDrefSwitch:new("isolation","anim/59/button",0)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","anim/60/button",0)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","anim/62/button",0)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateDrefSwitch:new("recirc1","anim/55/button",0)
sysAir.recircFanRight 		= TwoStateDrefSwitch:new("recirc2","anim/56/button",0)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateDrefSwitch:new("trimair","anim/54/button",0)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","anim/61/button",0)

return sysAir