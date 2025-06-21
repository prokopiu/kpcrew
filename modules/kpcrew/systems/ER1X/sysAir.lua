-- E1XX airplane 
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

logMsg("E1XX sysAir")

-- RECIRC fans
sysAir.recircSwitchGroup 	= TwoStateDrefSwitch:new("Recirc","sim/cockpit2/switches/generic_lights_switch",13)

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","sim/cockpit2/switches/generic_lights_switch",14)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","sim/cockpit2/switches/generic_lights_switch",15)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateCmdSwitch:new("bleed1","sim/cockpit2/pressurization/actuators/bleed_air_mode",0,
	"sim/bleed_air/bleed_air_left_on","sim/bleed_air/bleed_air_left_off","nocommand")
sysAir.bleedEng2Switch 		= TwoStateCmdSwitch:new("bleed2","sim/cockpit2/pressurization/actuators/bleed_air_mode",0,
	"sim/bleed_air/bleed_air_right_on","sim/bleed_air/bleed_air_right_off","nocommand")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateDrefSwitch:new("isolation","sim/cockpit2/switches/generic_lights_switch",33)

return sysAir