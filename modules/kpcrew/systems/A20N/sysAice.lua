-- A20N Jardesign airplane 
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

-- Wing AICE 
sysAice.wingAiceSwitch = TwoStateDrefSwitch:new("wingAice","sim/custom/xap/icerain/wing_knob",0)

-- ENG Anti Ice
sysAice.eng1AiceSwitch = TwoStateDrefSwitch:new("eng1aice","sim/custom/xap/icerain/eng1_knob",0)
sysAice.eng2AiceSwitch = TwoStateDrefSwitch:new("eng2aice","sim/custom/xap/icerain/eng2_knob",0)
sysAice.engAiceGroup = SwitchGroup:new("engaice")
sysAice.engAiceGroup:addSwitch(sysAice.eng1AiceSwitch)
sysAice.engAiceGroup:addSwitch(sysAice.eng2AiceSwitch)

-- Probe/Window Heat
sysAice.probeSwitch = TwoStateDrefSwitch:new("probe","sim/custom/xap/icerain/window",0)

-- ANTI ICE annunciator
sysAice.antiiceAnc = CustomAnnunciator:new("antiice",
function ()
	if sysAice.wingAiceSwitch:getStatus() > 0 or sysAice.engAiceGroup:getStatus() > 0  then
		return 1
	else
		return 0
	end
end)

return sysAice