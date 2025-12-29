-- B46X airplane 
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

logMsg("B46X sysAir")

-- TRIM/RAM air
sysAir.trimAirSwitch 		= TwoStateDrefSwitch:new("trimair","thranda/pneumatic/ramAir",0)

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateDrefSwitch:new("recirc1","thranda/ACSYST/PassFan",0)
sysAir.recircFanRight 		= TwoStateDrefSwitch:new("recirc2","thranda/ACSYST/PilotFan",0)
sysAir.recircFan3			= TwoStateDrefSwitch:new("recirc3","thranda/pneumatic/cabinAir",0)
sysAir.recircSwitchGroup 	= SwitchGroup:new("Recirc")
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanLeft)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFanRight)
sysAir.recircSwitchGroup:addSwitch(sysAir.recircFan3)

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","thranda/pneumatic/pack1",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","thranda/pneumatic/pack2",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","thranda/pneumatic/engAirValve",-1)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","thranda/pneumatic/engAirValve",1)
sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3","thranda/pneumatic/engAirValve",2)
sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4","thranda/pneumatic/engAirValve",3)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","thranda/pneumatic/APUAir",0)

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateDrefSwitch:new("oxygen","thranda/anim/OxygenPaxValve",0)
	
return sysAir