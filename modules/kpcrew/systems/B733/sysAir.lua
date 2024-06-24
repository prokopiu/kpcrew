-- B733 IXEG B737 PRO 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
local sysAir = {
	packModeOff 	= 0,
	packModeAuto 	= 1,
	packModeOn 		= 2,
	
	isoVlvClosed 	= 0,
	isoVlvAuto 		= 1,
	isoVlvOpen 		= 2,
	airVlvAuto 		= 0,
	airVlvAltn 		= 1,
	airVlvMan 		= 2
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

-- ======= Switches

-- PRESS MODE
sysAir.pressModeSelector 	= TwoStateDrefSwitch:new("pressMode","ixeg/733/pressurization/cabin_flt_grd_act",0)

-- AIR temperature
sysAir.contCabTemp 			= TwoStateDrefSwitch:new("airtemp1","laminar/B738/air/cont_cab_temp/rheostat",0)
sysAir.fwdCabTemp 			= TwoStateDrefSwitch:new("airtemp2","laminar/B738/air/fwd_cab_temp/rheostat",0)
sysAir.aftCabTemp 			= TwoStateDrefSwitch:new("airtemp3","laminar/B738/air/aft_cab_temp/rheostat",0)

-- TRIM air
sysAir.trimAirSwitch 		= TwoStateToggleSwitch:new("trimair","laminar/B738/air/trim_air_pos",0,
	"laminar/B738/toggle_switch/trim_air")

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateDrefSwitch:new("recirc1","ixeg/733/bleedair/bleedair_recirc_fan_act",0,
	"laminar/B738/toggle_switch/l_recirc_fan")
sysAir.recircFanRight 		= InopSwitch:new("recirc2")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1","ixeg/733/bleedair/bleedair_lpack_act",0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2","ixeg/733/bleedair/bleedair_rpack_act",0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= TwoStateDrefSwitch:new("isolation","ixeg/733/bleedair/bleedair_isovalve_act",0)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateDrefSwitch:new("bleed1","ixeg/733/bleedair/bleedair_eng1_act",0)
sysAir.bleedEng2Switch 		= TwoStateDrefSwitch:new("bleed2","ixeg/733/bleedair/bleedair_eng2_act",0)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateDrefSwitch:new("apubleed","ixeg/733/bleedair/bleedair_apu_act",0)

-- PRESSURIZATION Cruise level
sysAir.maxCruiseAltitude 	= TwoStateDrefSwitch:new("maxcrzlv","ixeg/733/pressurization/cabin_auto_flt_alt_kft_act",0)

-- PRESS Landing ALtitude
sysAir.landingAltitude 		= TwoStateDrefSwitch:new("landalt","ixeg/733/pressurization/cabin_auto_land_alt_kft_act",0)

-- ======= Annunciators

-- VACUUM annunciator
sysAir.vacuumAnc 			= CustomAnnunciator:new("vacuum",
function ()
	-- if get(drefPackLeftANC,0) == 1 or get(drefPackRightANC,0) == 1 then
		-- return 1
	-- else
		return 0
	-- end
end)

return sysAir