-- A350 airplane 
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysAice = {
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

local drefAiceWing 			= "1-sim/117/button"
local drefAiceEng1 			= "1-sim/119/button"
local drefAiceEng2			= "1-sim/120/button"
local drefProbeHeat			= "1-sim/121/button"
local drefAiceMode			= "1-sim/118/button"

--------- Annunciator datarefs common


--------- Switch commands common


--------- Actuator definitions


-- Window Heat
sysAice.windowHeat1 		= TwoStateDrefSwitch:new("wh1",drefAiceMode,0)
-- sysAice.windowHeat2 		= InopSwitch:new("wh2")
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat1)
-- sysAice.windowHeatGroup:addSwitch(sysAice.windowHeat2)

-- Probe heat
sysAice.probeHeat1 	= TwoStateDrefSwitch:new("probeheat1",drefProbeHeat,0)
-- sysAice.probeHeat2 	= InopSwitch:new("probeheat2")
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeat1)
-- sysAice.probeHeatGroup:addSwitch(sysAice.probeHeat2)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice",drefAiceWing,0)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice",drefAiceEng1,0)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice",drefAiceEng2,0)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- ==== Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWing) > 0 or get(drefAiceEng1) > 0 or get(drefAiceEng2) > 0 then
		return 1
	else
		return 0
	end
end)

return sysAice