-- B738 airplane 
-- Air and Pneumatics functionality

local sysAir = {
}

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

local drefPackLeftANC = "laminar/B738/annunciator/pack_left"
local drefPackRightANC = "laminar/B738/annunciator/pack_right"

-- ======= Switches

-- PRESS MODE
sysAir.pressModeSelector = MultiStateCmdSwitch:new("","laminar/B738/toggle_switch/air_valve_ctrl",0,"laminar/B738/toggle_switch/air_valve_ctrl_left","laminar/B738/toggle_switch/air_valve_ctrl_right")

-- AIR temperature
sysAir.contCabTemp = TwoStateDrefSwitch:new("","laminar/B738/air/cont_cab_temp/rheostat",0)
sysAir.fwdCabTemp = TwoStateDrefSwitch:new("","laminar/B738/air/fwd_cab_temp/rheostat",0)
sysAir.aftCabTemp = TwoStateDrefSwitch:new("","laminar/B738/air/aft_cab_temp/rheostat",0)

-- TRIM air
sysAir.trimAirSwitch = TwoStateToggleSwitch:new("","laminar/B738/air/trim_air_pos",0,"laminar/B738/toggle_switch/trim_air")

-- RECIRC fans
sysAir.recircFanLeft = TwoStateToggleSwitch:new("","laminar/B738/air/l_recirc_fan_pos",0,"laminar/B738/toggle_switch/l_recirc_fan")
sysAir.recircFanRight = TwoStateToggleSwitch:new("","laminar/B738/air/r_recirc_fan_pos",0,"laminar/B738/toggle_switch/r_recirc_fan")

-- PACK switches
sysAir.packLeftSwitch = MultiStateCmdSwitch:new("","laminar/B738/air/l_pack_pos",0,"laminar/B738/toggle_switch/l_pack_dn","laminar/B738/toggle_switch/l_pack_up")
sysAir.packRightSwitch = MultiStateCmdSwitch:new("","laminar/B738/air/r_pack_pos",0,"laminar/B738/toggle_switch/r_pack_dn","laminar/B738/toggle_switch/r_pack_up")

-- ISOLATION VLV
sysAir.isoValveSwitch = TwoStateCmdSwitch:new("","laminar/B738/air/isolation_valve_pos",0,"laminar/B738/toggle_switch/iso_valve_dn","laminar/B738/toggle_switch/iso_valve_up")

-- BLEED AIR
sysAir.bleedEng1Switch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/bleed_air_1_pos",0,"laminar/B738/toggle_switch/bleed_air_1")
sysAir.bleedEng2Switch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/bleed_air_2_pos",0,"laminar/B738/toggle_switch/bleed_air_2")

-- APU Bleed
sysAir.apuBleedSwitch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/bleed_air_apu_pos",0,"laminar/B738/toggle_switch/bleed_air_apu")

-- ======= Annunciators

-- VACUUM annunciator
sysAir.vacuumAnc = CustomAnnunciator:new("vacuum",
function ()
	if get(drefPackLeftANC,0) == 1 or get(drefPackRightANC,0) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir