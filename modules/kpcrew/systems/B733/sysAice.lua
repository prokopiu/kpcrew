-- B733 Airplane IXEG B733 PRO
-- Anti Ice functionality

-- @classmod sysAice
-- @author Kosta Prokopiu
-- @copyright 2023 Kosta Prokopiu
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


-- ===== Switches

-- Window Heat
sysAice.windowHeatLeftSide 	= TwoStateDrefSwitch:new("wheatleftside","ixeg/733/antiice/ai_winheat_l_side_act",0)
sysAice.windowHeatLeftFwd 	= TwoStateDrefSwitch:new("wheatleftfwd","ixeg/733/antiice/ai_winheat_l_fwd_act",0)
sysAice.windowHeatRightSide = TwoStateDrefSwitch:new("wheatrightside","ixeg/733/antiice/ai_winheat_r_fwd_act",0)
sysAice.windowHeatRightFwd 	= TwoStateDrefSwitch:new("wheatrightfwd","ixeg/733/antiice/ai_winheat_r_side_act",0)
sysAice.windowHeatGroup 	= SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftFwd)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightFwd) 

-- Probe heat
sysAice.probeHeatASwitch 	= TwoStateDrefSwitch:new("probeheat1","ixeg/733/antiice/ai_pitot_a_act",0)
sysAice.probeHeatBSwitch 	= TwoStateDrefSwitch:new("probeheat2","ixeg/733/antiice/ai_pitot_b_act",0)
sysAice.probeHeatGroup 		= SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce 		= TwoStateDrefSwitch:new("wingaice","ixeg/733/antiice/ai_wing_anti_ice_act",0)

-- ENG anti ice
sysAice.engAntiIce1 		= TwoStateDrefSwitch:new("eng1aice","ixeg/733/antiice/ai_eng1_act",0)
sysAice.engAntiIce2 		= TwoStateDrefSwitch:new("eng2aice","ixeg/733/antiice/ai_eng2_act",0)
sysAice.engAntiIceGroup 	= SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)

-- ===== Annunciators

-- ** ANTI ICE annunciator
sysAice.antiiceAnc 			= CustomAnnunciator:new("antiice",
function ()
	if get("ixeg/733/antiice/ai_wingv1_open_ann",0) > 0 or get("ixeg/733/antiice/ai_wingv2_open_ann",0) > 0 or get("ixeg/733/antiice/ai_cowlv1_open_ann",0) > 0 or get("ixeg/733/antiice/ai_cowlv2_open_ann",0) > 0 then
		return 1
	else
		return 0
	end
end)

-- WINDOW HEAT annunciator
sysAice.windowHeatAnns 		= CustomAnnunciator:new("windoheat",
function () return get("laminar/B738/annunciator/window_heat_l_fwd") + get("laminar/B738/annunciator/window_heat_l_side") +
	get("laminar/B738/annunciator/window_heat_r_fwd") + get("laminar/B738/annunciator/window_heat_r_side")
end)

return sysAice