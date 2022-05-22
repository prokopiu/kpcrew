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

local TwoStateDrefSwitch = require "kpcrew.systems.TwoStateDrefSwitch"
local TwoStateCmdSwitch = require "kpcrew.systems.TwoStateCmdSwitch"
local TwoStateCustomSwitch = require "kpcrew.systems.TwoStateCustomSwitch"
local SwitchGroup  = require "kpcrew.systems.SwitchGroup"
local SimpleAnnunciator = require "kpcrew.systems.SimpleAnnunciator"
local CustomAnnunciator = require "kpcrew.systems.CustomAnnunciator"
local TwoStateToggleSwitch = require "kpcrew.systems.TwoStateToggleSwitch"
local MultiStateCmdSwitch = require "kpcrew.systems.MultiStateCmdSwitch"
local InopSwitch = require "kpcrew.systems.InopSwitch"

--------- Switches

-- Flaps 
sysControls.flapsSwitch = MultiStateCmdSwitch:new("flaps","sim/cockpit2/controls/flap_ratio",0,"sim/flight_controls/flaps_down","sim/flight_controls/flaps_up")

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
sysControls.yawDamper = TwoStateDrefSwitch:new("yawdamper","FJS/732/FltControls/YawDamperSwitch",0)

-- flaps ctrl
sysControls.altFlapsCtrl = TwoStateDrefSwitch:new("altflapsctrl","FJS/732/FltControls/AlternatFlapsMasterSwitch",0)
sysControls.altFlapsCover = TwoStateDrefSwitch:new("altflapscover","FJS/732/num/FlipPo_06",0)

-- flight controls
sysControls.fltCtrlASwitch = TwoStateDrefSwitch:new("","FJS/732/FltControls/FltControlASwitch",0)
sysControls.fltCtrlBSwitch = TwoStateDrefSwitch:new("","FJS/732/FltControls/FltControlBSwitch",0)
sysControls.fltCtrlSwitches = SwitchGroup:new("fltCtrlSwitches")
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlASwitch) 
sysControls.fltCtrlSwitches:addSwitch(sysControls.fltCtrlBSwitch) 

sysControls.fltCtrlACover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_02",0)
sysControls.fltCtrlBCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipPo_03",0)
sysControls.fltCtrlCovers = SwitchGroup:new("fltCtrlCovers")
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlACover) 
sysControls.fltCtrlCovers:addSwitch(sysControls.fltCtrlBCover) 

-- Spoilers
sysControls.spoilerASwitch = TwoStateDrefSwitch:new("","FJS/732/FltControls/SpoilerASwitch",0)
sysControls.spoilerBSwitch = TwoStateDrefSwitch:new("","FJS/732/FltControls/SpoilerBSwitch",0)
sysControls.spoilerSwitches = SwitchGroup:new("spoilerSwitches")
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerASwitch) 
sysControls.spoilerSwitches:addSwitch(sysControls.spoilerBSwitch) 

sysControls.spoilerACover = TwoStateDrefSwitch:new("","FJS/732/num/FlipMo_04",0)
sysControls.spoilerBCover = TwoStateDrefSwitch:new("","FJS/732/num/FlipMo_05",0)
sysControls.spoilerCovers = SwitchGroup:new("spoilerCovers")
sysControls.spoilerCovers:addSwitch(sysControls.spoilerACover) 
sysControls.spoilerCovers:addSwitch(sysControls.spoilerBCover) 

--------- Annunciators
sysControls.spoilerLever = SimpleAnnunciator:new("","FJS/732/FltControls/SpeedBreakHandleMo",0)

-- Flaps extend
sysControls.slatsExtended = SimpleAnnunciator:new("","sim/cockpit2/controls/flap_ratio",0)

return sysControls