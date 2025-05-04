-- B744 MSPARKS airplane 
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

logMsg("B744 sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","laminar/B747/air/pack_ctrl/sel_dial_pos",-1)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","laminar/B747/air/pack_ctrl/sel_dial_pos",1)
sysAir.pack3Switch 			= TwoStateDrefSwitch:new("pack3","laminar/B747/air/pack_ctrl/sel_dial_pos",2)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.pack3Switch)

-- ISOLATION VLV
sysAir.isoValve1Switch = TwoStateToggleSwitch:new("","laminar/B747/air/isolation_valve_L_pos",0,
	"laminar/B747/button_switch/bleed_air_isln_vlv_L")
sysAir.isoValve2Switch = TwoStateToggleSwitch:new("","laminar/B747/air/isolation_valve_R_pos",0,
	"laminar/B747/button_switch/bleed_air_isln_vlv_R")
sysAir.isoValveSwitch = SwitchGroup:new("isovlvs")
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve1Switch)
sysAir.isoValveSwitch:addSwitch(sysAir.isoValve2Switch)

-- APU Bleed
sysAir.apuBleedSwitch = TwoStateToggleSwitch:new("","laminar/B747/air/apu/bleed_valve_pos",0,
	"laminar/B747/button_switch/bleed_air_vlv_apu")
	
-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","laminar/B747/button_switch/position",77,
	"laminar/B747/button_switch/bleed_air_vlv_engine_1")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","laminar/B747/button_switch/position",78,
	"laminar/B747/button_switch/bleed_air_vlv_engine_2")
sysAir.bleedEng3Switch 		= TwoStateToggleSwitch:new("bleed3","laminar/B747/button_switch/position",79,
	"laminar/B747/button_switch/bleed_air_vlv_engine_3")
sysAir.bleedEng4Switch 		= TwoStateToggleSwitch:new("bleed4","laminar/B747/button_switch/position",80,
	"laminar/B747/button_switch/bleed_air_vlv_engine_4")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- B747DR_bleedAir_engine1_start_valve_pos     = find_dataref("laminar/B747/air/engine1/bleed_start_valve_pos")
-- laminar/B747/button_switch/bleed_air_vlv_engine_1
-- laminar/B747/button_switch/position
-- B747DR_bleedAir_engine2_start_valve_pos     = find_dataref("laminar/B747/air/engine2/bleed_start_valve_pos")
-- B747DR_bleedAir_engine3_start_valve_pos     = find_dataref("laminar/B747/air/engine3/bleed_start_valve_pos")
-- B747DR_bleedAir_engine4_start_valve_pos     = find_dataref("laminar/B747/air/engine4/bleed_start_valve_pos")
	
return sysAir
