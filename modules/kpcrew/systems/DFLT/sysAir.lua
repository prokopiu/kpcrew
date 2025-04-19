-- DFLT airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysAir = {
}

logMsg("DFLT sysAir")

local TwoStateDrefSwitch 	= require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch	 	= require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch 	= require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  			= require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator 	= require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator 	= require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch	= require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch 	= require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch 			= require "kpcrew.systems.InopSwitch"

local drefAirANC 			= "sim/cockpit2/annunciators/low_vacuum"

-- TRIM/RAM air
sysAir.trimAirSwitch 		= InopSwitch:new("trimair")

-- RECIRC fans
sysAir.recircFanLeft 		= InopSwitch:new("recirc1")
sysAir.recircFanRight 		= InopSwitch:new("recirc2")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","sim/cockpit2/bleedair/actuators/pack_left",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","sim/cockpit2/bleedair/actuators/pack_right",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= InopSwitch:new("isolation")

-- BLEED AIR
sysAir.bleedEng1Switch 		= InopSwitch:new("bleed1")
sysAir.bleedEng2Switch 		= InopSwitch:new("bleed2")
-- sysAir.bleedEng3Switch 		= InopSwitch:new("bleed3")
-- sysAir.bleedEng4Switch 		= InopSwitch:new("bleed4")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","sim/cockpit2/bleedair/actuators/apu_bleed",0)

-- Oxygen Supply
sysAir.oxygenMaster			= TwoStateDrefSwitch:new("oxygen","sim/cockpit2/oxygen/actuators/demand_flow_setting",0)

-- ======= Annunciators

-- ** VACUUM annunciator
sysAir.vacuumAnc 			= CustomAnnunciator:new("vacuum",
function ()
	if get(drefAirANC,0) == 1 or get(drefAirANC,1) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir