-- A20N JarDesign  airplane 
-- Air and Pneumatics functionality

-- @classmod sysAir
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysAir = {
	xbleedSHUT = 0,
	xbleedAUTO = 1,
	xbleedOPEN = 2
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

local drefAirANC = "sim/cockpit/warnings/annunciators/bleed_air_off"

-- CAB PRESS
sysAir.cabPressSwitch = TwoStateDrefSwitch:new("capPress","sim/custom/xap/press/alt_rot",0)

-- APU BLEED
sysAir.apuBleed = TwoStateDrefSwitch:new("apubleed","sim/custom/xap/bleed/apu_blvlv",0)

-- X-BLEED
sysAir.crossBleed = TwoStateDrefSwitch:new("xbleed","sim/custom/xap/bleed/mode_sw",0)

-- HI FLOW
sysAir.highFlow = TwoStateDrefSwitch:new("packflow","sim/custom/xap/cond/econ_flow",0)

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