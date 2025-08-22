-- B742 airplane 
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

logMsg("B742 sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","B742/AIR_COND/pack_valves_rotary",-1)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","B742/AIR_COND/pack_valves_rotary",1)
sysAir.packCenterSwitch 		= TwoStateDrefSwitch:new("pack3","B742/AIR_COND/pack_valves_rotary",2)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packCenterSwitch)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateDrefSwitch:new("recirc1","B742/AIR_COND/recilc_fan_zones_sw",-1)
sysAir.recircFanRight 		= TwoStateDrefSwitch:new("recirc2","B742/AIR_COND/recilc_fan_zones_sw",1)
sysAir.recircFan3 			= TwoStateDrefSwitch:new("recirc3","B742/AIR_COND/recilc_fan_zones_sw",2)
sysAir.recircFan4 			= TwoStateDrefSwitch:new("recirc4","B742/AIR_COND/recilc_fan_zones_sw",3)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFan3)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFan4)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= SwitchGroup:new("IsoValves")
sysAir.isoValve1 			= TwoStateDrefSwitch:new("pack1","B742/AIR_COND/pack_isolation_valves",-1)
sysAir.isoValve2 			= TwoStateDrefSwitch:new("pack2","B742/AIR_COND/pack_isolation_valves",1)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve1)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve2)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","B742/AIR_COND/bleed_air_valves",-1)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","B742/AIR_COND/bleed_air_valves",1)
sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3","B742/AIR_COND/bleed_air_valves",2)
sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4","B742/AIR_COND/bleed_air_valves",3)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","B742/APU/APU_bleed_air_sw",0)

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateDrefSwitch:new("trimair","B742/AIR_COND/trim_air_sw",0)

return sysAir