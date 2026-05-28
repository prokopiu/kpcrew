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

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","sim/cockpit2/bleedair/actuators/engine_bleed_sov",-1,
	"sim/bleed_air/engine_1_toggle")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","sim/cockpit2/bleedair/actuators/engine_bleed_sov",1,
	"sim/bleed_air/engine_2_toggle")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- RECIRC fans
sysAir.recircSwitchGroup 		= TwoStateDrefSwitch:new("recirc1","XCrafts/bleedair/recirc_switch",0)

-- ISOLATION VLV Switch
sysAir.isoValveSwitch 		= TwoStateToggleSwitch:new("isolation","sim/cockpit2/bleedair/actuators/isol_valve_right",0,
	"sim/bleed_air/isolation_right_toggle")

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","sim/cockpit2/bleedair/actuators/apu_bleed",0)

return sysAir