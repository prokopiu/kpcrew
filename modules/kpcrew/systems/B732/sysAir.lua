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

local drefPackLeftANC = "FJS/732/Pneumatic/LPackSwitch"
local drefPackRightANC = "FJS/732/Pneumatic/RPackSwitch"

-- ======= Switches

-- PRESS MODE
sysAir.pressModeSelector = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/PressModeSelector",0)

-- AIR temperature
sysAir.contCabTemp = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/ContCabinTempSelector",0)
sysAir.fwdCabTemp = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/PassCabinTempSelector",0)
sysAir.aftCabTemp = InopSwitch:new("")

-- TRIM air
sysAir.trimAirSwitch = InopSwitch:new("trimair")

-- RECIRC fans
sysAir.recircFanLeft = TwoStateToggleSwitch:new("","FJS/732/Pneumatic/GasperFanSwitch",0)
sysAir.recircFanRight = InopSwitch:new("")

sysAir.recircFans = SwitchGroup:new("recirc")
sysAir.recircFans:addSwitch(sysAir.recircFanLeft)

-- PACK switches
sysAir.packLeftSwitch = TwoStateDrefSwitch:new("",drefPackLeftANC,0)
sysAir.packRightSwitch = TwoStateDrefSwitch:new("",drefPackRightANC,0)
sysAir.packSwitchGroup = SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/IsoValveSwitch",0)

-- BLEED AIR
sysAir.bleedEng1Switch = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/EngBleed1Switch",0)
sysAir.bleedEng2Switch = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/EngBleed2Switch",0)
sysAir.engBleedGroup = SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
sysAir.apuBleedSwitch = TwoStateDrefSwitch:new("","FJS/732/Pneumatic/APUBleedSwitch",0)

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