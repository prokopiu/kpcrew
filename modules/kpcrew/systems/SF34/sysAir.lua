-- SF34 airplane 
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

logMsg("SF34 sysAir")

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateToggleSwitch:new("recirc1","les/sf34a/acft/acon/anm/recirc_fan_switch_L",0,
	"les/sf34a/acft/acon/mnp/recirc_fan_switch_L")
sysAir.recircFanRight 		= TwoStateToggleSwitch:new("recirc2","les/sf34a/acft/acon/anm/recirc_fan_switch_R",0,
	"les/sf34a/acft/acon/mnp/recirc_fan_switch_R")
sysAir.recircSwitchGroup 		= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateCmdSwitch:new("bleed1","les/sf34a/acft/pneu/anm/bleed_valve_switch_L",0,
	"les/sf34a/acft/pneu/mnp/bleed_valve_switch_up_L","les/sf34a/acft/pneu/mnp/bleed_valve_switch_dn_L","nocommand")
sysAir.bleedEng2Switch 		= TwoStateCmdSwitch:new("bleed2","les/sf34a/acft/pneu/anm/bleed_valve_switch_R",0,
	"les/sf34a/acft/pneu/mnp/bleed_valve_switch_up_R","les/sf34a/acft/pneu/mnp/bleed_valve_switch_dn_R","nocommand")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateCmdSwitch:new("pack1","les/sf34a/acft/pneu/anm/hp_bleed_vlv_switch_L",0,
	"les/sf34a/acft/pneu/mnp/hp_bleed_vlv_switch_up_L","les/sf34a/acft/pneu/mnp/hp_bleed_vlv_switch_dn_L")
sysAir.packRightSwitch 		= TwoStateCmdSwitch:new("pack2","les/sf34a/acft/pneu/anm/hp_bleed_vlv_switch_R",0,
	"les/sf34a/acft/pneu/mnp/hp_bleed_vlv_switch_up_R","les/sf34a/acft/pneu/mnp/hp_bleed_vlv_switch_dn_R")
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateToggleSwitch:new("isolation","les/sf34a/acft/pneu/anm/bleed_xvalve_switch",0,
	"les/sf34a/acft/pneu/mnp/bleed_xvalve_switch")

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateDrefSwitch:new("oxygen","les/sf34a/acft/emrg/mnp/oxygen_on_off_handle",0)

return sysAir