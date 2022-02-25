-- B738 airplane 
-- Flight Controls functionality

local sysControls = {
	trimCenter = 2,
	trimLeft = 1,
	trimRight = 0,
	flapsUp = 1,
	flapsDown = 0,
	trimUp = 0,
	trimDown = 1
}

TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
SwitchGroup  = require "kpcrew.systems.SwitchGroup"
SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
InopSwitch = require "kpcrew.systems.InopSwitch"

--------- Switches

-- Flaps 
sysControls.flapsSwitch = MultiStateCmdSwitch:new("flaps","sim/flightmodel2/controls/flap_ratio",0,"sim/flight_controls/flaps_down","sim/flight_controls/flaps_up")

-- Pitch Trim
sysControls.pitchTrimSwitch = MultiStateCmdSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,"laminar/B738/flight_controls/pitch_trim_up","laminar/B738/flight_controls/pitch_trim_down")

-- Aileron Trim
sysControls.aileronTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,"sim/flight_controls/aileron_trim_right","sim/flight_controls/aileron_trim_left")

sysControls.aileronReset = TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,"sim/flight_controls/aileron_trim_center")

-- Rudder Trim
sysControls.rudderTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/rudder_trim",0,"sim/flight_controls/rudder_trim_right","sim/flight_controls/rudder_trim_left")

-- ruder reset
sysControls.rudderReset = TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,"sim/flight_controls/rudder_trim_center")

-- Yaw damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper","laminar/B738/toggle_switch/yaw_dumper_pos",0,"laminar/B738/toggle_switch/yaw_dumper")

-- flaps ctrl
sysControls.altFlapsCtrl = MultiStateCmdSwitch:new("altflapsctrl","laminar/B738/toggle_switch/alt_flaps_ctrl",0,"laminar/B738/toggle_switch/alt_flaps_ctrl_dn","laminar/B738/toggle_switch/alt_flaps_ctrl_up")
sysControls.altFlapsCover = TwoStateToggleSwitch:new("altflapscover","laminar/B738/switches/alt_flaps_cover_pos",0,"laminar/B738/toggle_switch/alt_flaps_cover")

-- flight controls
sysControls.fltCtrlASwitch = MultiStateCmdSwitch:new("","laminar/B738/switches/flt_ctr_A_pos",0,"laminar/B738/toggle_switch/flt_ctr_A_dn","laminar/B738/toggle_switch/flt_ctr_A_up")
sysControls.fltCtrlBSwitch = MultiStateCmdSwitch:new("","laminar/B738/switches/flt_ctr_B_pos",0,"laminar/B738/toggle_switch/flt_ctr_B_dn","laminar/B738/toggle_switch/flt_ctr_B_up")
sysControls.fltCtrlACover = TwoStateToggleSwitch:new("","laminar/B738/switches/flt_ctr_A_cover_pos",0,"laminar/B738/toggle_switch/flt_ctr_A_cover")
sysControls.fltCtrlBCover = TwoStateToggleSwitch:new("","laminar/B738/switches/flt_ctr_B_cover_pos",0,"laminar/B738/toggle_switch/flt_ctr_B_cover")

-- Spoilers
sysControls.spoilerASwitch = TwoStateToggleSwitch:new("","laminar/B738/switches/spoiler_A_pos",0,"laminar/B738/toggle_switch/spoiler_A")
sysControls.spoilerBSwitch = TwoStateToggleSwitch:new("","laminar/B738/switches/spoiler_B_pos",0,"laminar/B738/toggle_switch/spoiler_B")
sysControls.spoilerACover = TwoStateToggleSwitch:new("","laminar/B738/switches/spoiler_A_cover_pos",0,"laminar/B738/toggle_switch/spoiler_A_cover")
sysControls.spoilerBCover = TwoStateToggleSwitch:new("","laminar/B738/switches/spoiler_B_cover_pos",0,"laminar/B738/toggle_switch/spoiler_B_cover")

--------- Annunciators

return sysControls