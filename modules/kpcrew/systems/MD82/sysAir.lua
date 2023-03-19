-- B738 airplane 
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

-- APU Bleed
sysAir.apuBleedSwitch 		= TwoStateCmdSwitch:new("apubleed","laminar/md82/bleedair/APU_on",0,
	"laminar/md82cmd/bleedair/APU_dwn","laminar/md82cmd/bleedair/APU_up","nocommand")

-- PACK switches
sysAir.packLeftSwitch 		= MultiStateCmdSwitch:new("pack1","laminar/md82/bleedair/bleedair_HVAC_L",0,
	"laminar/md82cmd/bleedair/bleedair_HVAC_L_dwn","laminar/md82cmd/bleedair/bleedair_HVAC_L_up",0,2,true)
sysAir.packRightSwitch 		= MultiStateCmdSwitch:new("pack2","laminar/md82/bleedair/bleedair_HVAC_R",0,
	"laminar/md82cmd/bleedair/bleedair_HVAC_R_dwn","laminar/md82cmd/bleedair/bleedair_HVAC_R_up",0,2,true)
sysAir.packSwitchGroup 		= SwitchGroup:new("PackBleeds")
sysAir.packSwitchGroup:addSwitch(sysAir.packLeftSwitch)
sysAir.packSwitchGroup:addSwitch(sysAir.packRightSwitch)

-- BLEED AIR
sysAir.bleedEng1Switch 		= TwoStateToggleSwitch:new("bleed1","laminar/md82/bleedair/engineL_xfeed_lever",0,
	"laminar/md82cmd/bleedair/L_xfeed_lever_toggle")
sysAir.bleedEng2Switch 		= TwoStateToggleSwitch:new("bleed2","laminar/md82/bleedair/engineR_xfeed_lever",0,
	"laminar/md82cmd/bleedair/R_xfeed_lever_toggle")
sysAir.engBleedGroup 		= SwitchGroup:new("EngBleeds")
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng1Switch)
sysAir.engBleedGroup:addSwitch(sysAir.bleedEng2Switch)
	
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