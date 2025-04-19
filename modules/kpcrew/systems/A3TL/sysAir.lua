-- ToLiss Airbusses
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

logMsg("A3TL sysAir")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","AirbusFBW/Pack1Switch",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","AirbusFBW/Pack2Switch",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","AirbusFBW/ENG1BleedSwitch",0)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","AirbusFBW/ENG2BleedSwitch",0)
if PLANE_ICAO == "A346" then
	sysAir.bleedEng3Switch 		= TwoStateDrefSwitch:new("bleed3","AirbusFBW/ENG3BleedSwitch",0)
	sysAir.bleedEng4Switch 		= TwoStateDrefSwitch:new("bleed4","AirbusFBW/ENG4BleedSwitch",0)
else
	sysAir.bleedEng3Switch 		= InopSwitch:new("bleed3","AirbusFBW/ENG3BleedSwitch",0)
	sysAir.bleedEng4Switch 		= InopSwitch:new("bleed4","AirbusFBW/ENG4BleedSwitch",0)
end
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","AirbusFBW/APUBleedSwitch",0)

return sysAir