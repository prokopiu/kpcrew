-- B738 airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
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

local drefPackLeftANC 		= "laminar/B738/annunciator/pack_left"
local drefPackRightANC 		= "laminar/B738/annunciator/pack_right"

-- ======= Switches

-- PRESS MODE
sysAir.pressModeSelector 	= MultiStateCmdSwitch:new("pressMode","laminar/B738/toggle_switch/air_valve_ctrl",0,
	"laminar/B738/toggle_switch/air_valve_ctrl_left","laminar/B738/toggle_switch/air_valve_ctrl_right",0,2,false)

-- AIR temperature
sysAir.contCabTemp 			= TwoStateDrefSwitch:new("airtemp1","laminar/B738/air/cont_cab_temp/rheostat",0)
sysAir.fwdCabTemp 			= TwoStateDrefSwitch:new("airtemp2","laminar/B738/air/fwd_cab_temp/rheostat",0)
sysAir.aftCabTemp 			= TwoStateDrefSwitch:new("airtemp3","laminar/B738/air/aft_cab_temp/rheostat",0)

-- TRIM air
sysAir.trimAirSwitch 		= TwoStateToggleSwitch:new("trimair","laminar/B738/air/trim_air_pos",0,
	"laminar/B738/toggle_switch/trim_air")

-- RECIRC fans
sysAir.recircFanLeft 		= TwoStateToggleSwitch:new("recirc1","laminar/B738/air/l_recirc_fan_pos",0,
	"laminar/B738/toggle_switch/l_recirc_fan")
sysAir.recircFanRight 		= TwoStateToggleSwitch:new("recirc2","laminar/B738/air/r_recirc_fan_pos",0,
	"laminar/B738/toggle_switch/r_recirc_fan")

-- PACK switches
sysAir.packLeftSwitch 		= MultiStateCmdSwitch:new("pack1","laminar/B738/air/l_pack_pos",0,
	"laminar/B738/toggle_switch/l_pack_dn","laminar/B738/toggle_switch/l_pack_up",0,2,false)
sysAir.packRightSwitch 		= MultiStateCmdSwitch:new("pack2","laminar/B738/air/r_pack_pos",0,
	"laminar/B738/toggle_switch/r_pack_dn","laminar/B738/toggle_switch/r_pack_up",0,2,false)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= MultiStateCmdSwitch:new("isolation","laminar/B738/air/isolation_valve_pos",0,
	"laminar/B738/toggle_switch/iso_valve_dn","laminar/B738/toggle_switch/iso_valve_up",0,2,false)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","laminar/B738/toggle_switch/bleed_air_1_pos",0,
	"laminar/B738/toggle_switch/bleed_air_1")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","laminar/B738/toggle_switch/bleed_air_2_pos",0,
	"laminar/B738/toggle_switch/bleed_air_2")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateToggleSwitch:new("apubleed","laminar/B738/toggle_switch/bleed_air_apu_pos",0,
	"laminar/B738/toggle_switch/bleed_air_apu")

-- PRESSURIZATION Cruise level
sysAir.maxCruiseAltitude 	= MultiStateCmdSwitch:new("maxcrzlv","sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft",0,
	"laminar/B738/knob/flt_alt_press_dn","laminar/B738/knob/flt_alt_press_up",-1000,42000,false)

-- PRESS Landing ALtitude
sysAir.landingAltitude 		= MultiStateCmdSwitch:new("landalt","laminar/B738/pressurization/knobs/landing_alt",0,
	"laminar/B738/knob/land_alt_press_up","laminar/B738/knob/land_alt_press_dn",-1000,13600,false)

-- ======= Annunciators

-- VACUUM annunciator
sysAir.vacuumAnc 			= CustomAnnunciator:new("vacuum",
function ()
	if get(drefPackLeftANC,0) == 1 or get(drefPackRightANC,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir