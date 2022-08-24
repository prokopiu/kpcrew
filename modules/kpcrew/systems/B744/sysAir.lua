-- DFLT airplane 
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
local drefAirANC = "sim/cockpit/warnings/annunciators/bleed_air_off"

sysAir.pack1Switch = MultiStateCmdSwitch:new("","laminar/B747/air/pack_ctrl/sel_dial_pos",0,"laminar/B747/air/pack_ctrl_01/sel_dial_dn","laminar/B747/air/pack_ctrl_01/sel_dial_up")
sysAir.pack2Switch = MultiStateCmdSwitch:new("","laminar/B747/air/pack_ctrl/sel_dial_pos",1,"laminar/B747/air/pack_ctrl_02/sel_dial_dn","laminar/B747/air/pack_ctrl_02/sel_dial_up")
sysAir.pack3Switch = MultiStateCmdSwitch:new("","laminar/B747/air/pack_ctrl/sel_dial_pos",2,"laminar/B747/air/pack_ctrl_03/sel_dial_dn","laminar/B747/air/pack_ctrl_03/sel_dial_up")
sysAir.packSwitchGroup = SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.pack1Switch)
sysAir.packSwitchGroup:addSwitch(sysAir.pack2Switch)
sysAir.packSwitchGroup:addSwitch(sysAir.pack3Switch)

-- ISOLATION VLV
sysAir.isoValve1Switch = TwoStateToggleSwitch:new("","laminar/B747/air/isolation_valve_L_pos",0,"laminar/B747/button_switch/bleed_air_isln_vlv_L")
sysAir.isoValve2Switch = TwoStateToggleSwitch:new("","laminar/B747/air/isolation_valve_R_pos",0,"laminar/B747/button_switch/bleed_air_isln_vlv_R")
sysAir.isoValveGroup = SwitchGroup:new("isovlvs")
sysAir.isoValveGroup:addSwitch(sysAir.isoValve1Switch)
sysAir.isoValveGroup:addSwitch(sysAir.isoValve2Switch)

-- APU Bleed
sysAir.apuBleedSwitch = TwoStateToggleSwitch:new("","laminar/B747/air/apu/bleed_valve_pos",0,"laminar/B747/button_switch/bleed_air_vlv_apu")


-- VACUUM annunciator
sysAir.vacuumAnc = CustomAnnunciator:new("vacuum",
function ()
	if get(drefAirANC,0) == 1 or get(drefAirANC,1) == 1 then
		return 1
	else
		return 0
	end
end)

return sysAir