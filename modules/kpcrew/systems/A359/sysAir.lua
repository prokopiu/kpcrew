-- A350 airplane 
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

--------- Switch datarefs common

local drefXbleedSel			= "1-sim/air/crossBeedSwitch"
local drefBleedEng1			= "1-sim/109/button"
local drefBleedEng2			= "1-sim/115/button"
local drefBleedApu			= "1-sim/111/button"
local drefPack1				= "1-sim/107/button"
local drefPack2				= "1-sim/112/button"
local drefHotAir1			= "1-sim/110/button"
local drefHotAir2			= "1-sim/114/button"
local drefAirFlow 			= "1-sim/air/airFlowSwitch"

--------- Annunciator datarefs common

local drefAirANC 			= "sim/cockpit/warnings/annunciators/bleed_air_off"

--------- Switch commands common


--------- Actuator definitions

-- TRIM/RAM air
sysAir.trimAirSwitch 		= InopSwitch:new("trimair")

-- RECIRC fans
sysAir.recircFanLeft 		= InopSwitch:new("recirc1")
sysAir.recircFanRight 		= InopSwitch:new("recirc2")

-- PACK switches
sysAir.packLeftSwitch 		= TwoStateDrefSwitch:new("pack1",drefPack1,0)
sysAir.packRightSwitch 		= TwoStateDrefSwitch:new("pack2",drefPack2,0)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- ISOLATION VLV
sysAir.isoValveSwitch 		= InopSwitch:new("isolation")

-- BLEED AIR
sysAir.bleedEng1Switch 		= InopSwitch:new("bleed1",drefBleedEng1,0)
sysAir.bleedEng2Switch 		= InopSwitch:new("bleed2",drefBleedEng2,0)
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)

-- APU Bleed
sysAir.apuBleedSwitch 		= InopSwitch:new("apubleed",drefBleedApu,0)

-- ======= Annunciators

-- ** VACUUM annunciator
sysAir.vacuumAnc 			= CustomAnnunciator:new("vacuum",
function ()
	-- if get(drefAirANC,0) == 1 or get(drefAirANC,1) == 1 then
		-- return 1
	-- else
		return 0
	-- end
end)

return sysAir