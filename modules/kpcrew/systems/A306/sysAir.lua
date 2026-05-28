-- A306 airplane 
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

logMsg("A306 sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","A300/pack1_state",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","A300/pack2_state",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateToggleSwitch:new("isolation","A300/COND/isolation_valve_right",0,
	"A300/COND/isol_valve_right")

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","A300/animations/buttons/ENG1_WING_BLEED_VALVE",0,
	"A300/BLEED/eng1_toggle")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","A300/animations/buttons/ENG2_WING_BLEED_VALVE",0,
	"A300/BLEED/eng1_toggle")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","A300/APU/bleed_status",0)

-- Oxygen Supply
sysAir.oxygenMaster			= SwitchGroup:new("Oxygen Master")
sysAir.oxygenMaster1		= TwoStateDrefSwitch:new("oxygen1","A300/OXYGEN/low_pressure_supply",0)
sysAir.oxygenMaster2		= TwoStateDrefSwitch:new("oxygen2","A300/OXYGEN/courier_low_pressure_supply",0)

return sysAir