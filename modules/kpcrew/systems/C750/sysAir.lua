-- C750 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysAir = {
}

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
sysAir.packLeftSwitch 		= TwoStateCmdSwitch:new("pack1","laminar/CitX/bleedair/air_cond_cockpit",0,
	"laminar/CitX/bleedair/cmd_air_cond_cockpit_up","laminar/CitX/bleedair/cmd_air_cond_cockpit_dwn","nocommand")
sysAir.packRightSwitch 		= TwoStateCmdSwitch:new("pack2","laminar/CitX/bleedair/air_cond_cabin",0,
	"laminar/CitX/bleedair/cmd_air_cond_cabin_up","laminar/CitX/bleedair/cmd_air_cond_cabin_dwn","nocommand")
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateCmdSwitch:new("isolation","laminar/CitX/bleedair/iso_valve",0,
	"laminar/CitX/bleedair/cmd_iso_valve_up","laminar/CitX/bleedair/cmd_iso_valve_dwn","nocommand")

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateCmdSwitch:new("bleed1","laminar/CitX/bleedair/engine_left",0,
	"laminar/CitX/bleedair/cmd_engine_left_up","laminar/CitX/bleedair/cmd_engine_left_down","nocommand")
sysAir.bleedEng2Switch 		= TwoStateCmdSwitch:new("bleed2","laminar/CitX/bleedair/engine_right",0,
	"laminar/CitX/bleedair/cmd_engine_right_up","laminar/CitX/bleedair/cmd_engine_right_down","nocommand")
-- sysAir.bleedEng3Switch 		= InopSwitch:new("bleed3")
-- sysAir.bleedEng4Switch 		= InopSwitch:new("bleed4")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng3Switch)
-- sysAir.engBleedGroup:addSwitch(sysAir.bleedEng4Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateCmdSwitch:new("apubleed","laminar/CitX/APU/bleed_air_switch",0,
	"laminar/CitX/APU/bleed_switch_up","laminar/CitX/APU/bleed_switch_dwn","nocommand")

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