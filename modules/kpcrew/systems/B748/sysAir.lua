-- B748 airplane 
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

logMsg("B748 sysAir")

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","ssg/BLD/bd_eng1_sw",0)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","ssg/BLD/bd_eng2_sw",0)
sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3","ssg/BLD/bd_eng3_sw",0)
sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4","ssg/BLD/bd_eng4_sw",0)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- TRIM/RAM air
sysAir.trimAirSwitch 		= SwitchGroup:new("TrimAir")
sysAir.trimAirSwitch1		= TwoStateDrefSwitch:new("trimair1","ssg/B748/trim_air_l_sw",0)
sysAir.trimAirSwitch2		= TwoStateDrefSwitch:new("trimair2","ssg/B748/trim_air_r_sw",0)
sysAir.trimAirSwitch:addSwitch(sysAir.trimAirSwitch1)
sysAir.trimAirSwitch:addSwitch(sysAir.trimAirSwitch2)

-- RECIRC fans
sysAir.recircFanLeft 		= InopSwitch:new("recirc1")
sysAir.recircFanRight 		= InopSwitch:new("recirc2")
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","ssg/BLD/pack1_sw",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","ssg/BLD/pack2_sw",0)
sysAir.pack3Switch 			= TwoStateDrefSwitch:new("pack3","ssg/BLD/pack3_sw",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.pack3Switch)

-- Isolation valves
sysAir.isoValveSwitch1 		= TwoStateDrefSwitch:new("isolvlv1","ssg/BLD/islnL_sw",0)
sysAir.isoValveSwitch2 		= TwoStateDrefSwitch:new("isolvlv2","ssg/BLD/islnR_sw",0)
sysAir.isoValveSwitch 		= SwitchGroup:new("Isolation valves")
sysAir.isoValveSwitch:addSwitch(sysAir.isoValveSwitch1)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValveSwitch2)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","ssg/BLD/bd_APU_sw",0)

return sysAir