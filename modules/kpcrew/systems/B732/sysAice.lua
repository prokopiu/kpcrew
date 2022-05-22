-- B738 airplane 
-- Anti Ice functionality

local sysAice = {
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

-- ===== Switches

sysAice.windowHeatLeftSide = TwoStateDrefSwitch:new("wheatleftside","FJS/732/AntiIce/WindowHeatL1Switch",0)
sysAice.windowHeatLeftFwd = TwoStateDrefSwitch:new("wheatleftfwd","FJS/732/AntiIce/WindowHeatL2Switch",0)
sysAice.windowHeatRightSide = TwoStateDrefSwitch:new("wheatrightside","FJS/732/AntiIce/WindowHeatR1Switch",0)
sysAice.windowHeatRightFwd = TwoStateDrefSwitch:new("wheatrightfwd","FJS/732/AntiIce/WindowHeatR2Switch",0)

sysAice.windowHeatGroup = SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftFwd)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightFwd) 

-- probe heat
sysAice.probeHeatASwitch = TwoStateDrefSwitch:new("","FJS/732/AntiIce/PitotStaticSwitchA",0)
sysAice.probeHeatBSwitch = TwoStateDrefSwitch:new("","FJS/732/AntiIce/PitotStaticSwitchA",0)

sysAice.probeHeatGroup = SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce = TwoStateDrefSwitch:new("","FJS/732/AntiIce/WingAntiIceSwitch",0)

-- ENG anti ice
sysAice.engAntiIce1 = TwoStateDrefSwitch:new("","FJS/732/AntiIce/EngAntiIce1Switch",0)
sysAice.engAntiIce2 = TwoStateDrefSwitch:new("","FJS/732/AntiIce/EngAntiIce2Switch",0)

sysAice.engAntiIceGroup = SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)


-- ===== Annunciators

-- ANTI ICE annunciator
sysAice.antiiceAnc = CustomAnnunciator:new("antiice",
function ()
	if sysAice.wingAntiIce:getStatus() > 0 or sysAice.engAntiIceGroup:getStatus() > 0 then
		return 1
	else
		return 0
	end
end)

return sysAice