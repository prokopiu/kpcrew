-- B737 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

sysAir = require("kpcrew.systems.DFLT.sysAir")

logMsg("B737 sysAir")
kc_is_zibo			= PLANE_ICAO == "B738" and PLANE_TAILNUMBER == "ZB738"

-- PACK switches
if kc_is_zibo then
	sysAir.packLeftSwitch 		= MultiStateCmdSwitch:new("pack1","laminar/B738/air/l_pack_pos",0,
		"laminar/B738/toggle_switch/l_pack_dn","laminar/B738/toggle_switch/l_pack_up",0,2,false)
	sysAir.packRightSwitch 		= MultiStateCmdSwitch:new("pack2","laminar/B738/air/r_pack_pos",0,
		"laminar/B738/toggle_switch/r_pack_dn","laminar/B738/toggle_switch/r_pack_up",0,2,false)
else
	sysAir.packLeftSwitch 		= TwoStateCustomSwitch:new("pack1","laminar/B738/pressurization/l_pack_pos",0,
		function ()
			command_once("laminar/B738/switch/Lpack_up")
			command_once("laminar/B738/switch/Lpack_up")
			command_once("laminar/B738/switch/Lpack_dn")
		end,
		function ()
			command_once("laminar/B738/switch/Lpack_up")
			command_once("laminar/B738/switch/Lpack_up")
		end,
		function ()
		end,
		function ()
			if get("laminar/B738/pressurization/l_pack_pos") > -1 then
				return 1
			else
				return 0
			end
		end)
	sysAir.packRightSwitch 		= TwoStateCustomSwitch:new("pack2","laminar/B738/pressurization/r_pack_pos",0,
		function ()
			command_once("laminar/B738/switch/Rpack_up")
			command_once("laminar/B738/switch/Rpack_up")
			command_once("laminar/B738/switch/Rpack_dn")
		end,
		function ()
			command_once("laminar/B738/switch/Rpack_up")
			command_once("laminar/B738/switch/Rpack_up")
		end,
		function ()
		end,
		function ()
			if get("laminar/B738/pressurization/r_pack_pos") > -1 then
				return 1
			else
				return 0
			end
		end)
end
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
if kc_is_zibo then
	sysAir.isoValveSwitch 		= MultiStateCmdSwitch:new("isolation","laminar/B738/air/isolation_valve_pos",0,
		"laminar/B738/toggle_switch/iso_valve_dn","laminar/B738/toggle_switch/iso_valve_up",0,2,false)
else
	sysAir.isoValveSwitch 		= TwoStateCustomSwitch:new("isolation","laminar/B738/pressurization/iso_valve_pos",0,
		function ()
			command_once("laminar/B738/switch/iso_valve_up")
			command_once("laminar/B738/switch/iso_valve_up")
			command_once("laminar/B738/switch/iso_valve_dn")
		end,
		function ()
			command_once("laminar/B738/switch/iso_valve_up")
			command_once("laminar/B738/switch/iso_valve_up")
		end,
		function ()
		end,
		function ()
			if get("laminar/B738/pressurization/iso_valve_pos") > -1 then
				return 1
			else
				return 0
			end
		end)
end

-- BLEED AIR
if kc_is_zibo then
	sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","laminar/B738/toggle_switch/bleed_air_1_pos",0,
		"laminar/B738/toggle_switch/bleed_air_1")
	sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","laminar/B738/toggle_switch/bleed_air_2_pos",0,
		"laminar/B738/toggle_switch/bleed_air_2")
else
	sysAir.bleedEng1Switch 		= TwoStateCmdSwitch:new("bleed1","sim/cockpit2/bleedair/actuators/engine_bleed_sov",-1,
		"sim/bleed_air/engine_1_on","sim/bleed_air/engine_1_off","sim/bleed_air/engine_1_toggle")
	sysAir.bleedEng2Switch 		= TwoStateCmdSwitch:new("bleed2","sim/cockpit2/bleedair/actuators/engine_bleed_sov",1,
		"sim/bleed_air/engine_2_on","sim/bleed_air/engine_2_off","sim/bleed_air/engine_2_toggle")
end
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
if kc_is_zibo then
	sysAir.apuBleedSwitch 		= TwoStateToggleSwitch:new("apubleed","laminar/B738/toggle_switch/bleed_air_apu_pos",0,
		"laminar/B738/toggle_switch/bleed_air_apu")
else
	sysAir.apuBleedSwitch 		= TwoStateCmdSwitch:new("apubleed","sim/cockpit2/bleedair/actuators/apu_bleed",0,
		"sim/bleed_air/apu_on","sim/bleed_air/apu_off","sim/bleed_air/apu_toggle")
end

-- AIR temperature
sysAir.contCabTemp 			= TwoStateDrefSwitch:new("airtemp1","laminar/B738/air/cont_cab_temp/rheostat",0)
sysAir.fwdCabTemp 			= TwoStateDrefSwitch:new("airtemp2","laminar/B738/air/fwd_cab_temp/rheostat",0)
sysAir.aftCabTemp 			= TwoStateDrefSwitch:new("airtemp3","laminar/B738/air/aft_cab_temp/rheostat",0)

return sysAir