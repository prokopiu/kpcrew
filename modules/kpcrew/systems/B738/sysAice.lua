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

local drefAiceWingLeft = "laminar/B738/annunciator/wing_ice_on_L"
local drefAiceWingRight = "laminar/B738/annunciator/wing_ice_on_R"
local drefAiceEng1 = "laminar/B738/annunciator/cowl_ice_on_0"
local drefAiceEng2 = "laminar/B738/annunciator/cowl_ice_on_1"

-- ===== Switches

sysAice.windowHeatLeftSide = TwoStateToggleSwitch:new("wheatleftside","laminar/B738/ice/window_heat_l_side_pos",0,"laminar/B738/toggle_switch/window_heat_l_side")
sysAice.windowHeatLeftFwd = TwoStateToggleSwitch:new("wheatleftfwd","laminar/B738/ice/window_heat_l_fwd_pos",0,"laminar/B738/toggle_switch/window_heat_l_fwd")
sysAice.windowHeatRightSide = TwoStateToggleSwitch:new("wheatrightside","laminar/B738/ice/window_heat_r_side_pos",0,"laminar/B738/toggle_switch/window_heat_r_side")
sysAice.windowHeatRightFwd = TwoStateToggleSwitch:new("wheatrightfwd","laminar/B738/ice/window_heat_r_fwd_pos",0,"laminar/B738/toggle_switch/window_heat_r_fwd")

sysAice.windowHeatGroup = SwitchGroup:new("windowheat")
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatLeftFwd)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightSide)
sysAice.windowHeatGroup:addSwitch(sysAice.windowHeatRightFwd) 

-- probe heat
sysAice.probeHeatASwitch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/capt_probes_pos",0,"laminar/B738/toggle_switch/capt_probes_pos")
sysAice.probeHeatBSwitch = TwoStateToggleSwitch:new("","laminar/B738/toggle_switch/fo_probes_pos",0,"laminar/B738/toggle_switch/fo_probes_pos")

sysAice.probeHeatGroup = SwitchGroup:new("probeHeat")
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatASwitch)
sysAice.probeHeatGroup:addSwitch(sysAice.probeHeatBSwitch)

-- Wing anti ice
sysAice.wingAntiIce = TwoStateToggleSwitch:new("","laminar/B738/ice/wing_heat_pos",0,"laminar/B738/toggle_switch/wing_heat")

-- ENG anti ice
sysAice.engAntiIce1 = TwoStateToggleSwitch:new("","laminar/B738/ice/eng1_heat_pos",0,"laminar/B738/toggle_switch/eng1_heat")
sysAice.engAntiIce2 = TwoStateToggleSwitch:new("","laminar/B738/ice/eng2_heat_pos",0,"laminar/B738/toggle_switch/eng2_heat")

sysAice.engAntiIceGroup = SwitchGroup:new("engantiice")
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce1)
sysAice.engAntiIceGroup:addSwitch(sysAice.engAntiIce2)


-- ===== Annunciators

-- ANTI ICE annunciator
sysAice.antiiceAnc = CustomAnnunciator:new("antiice",
function ()
	if get(drefAiceWingLeft) > 0 or get(drefAiceWingRight) > 0 or get(drefAiceEng1) > 0 or get(drefAiceEng2) > 0 then
		return 1
	else
		return 0
	end
end)

sysAice.windowHeatAnns = CustomAnnunciator:new("windoheat",
function () return get("laminar/B738/annunciator/window_heat_l_fwd") + get("laminar/B738/annunciator/window_heat_l_side") +
	get("laminar/B738/annunciator/window_heat_r_fwd") + get("laminar/B738/annunciator/window_heat_r_side")
end)

return sysAice