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

sysControls.rudderReset = TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,"sim/flight_controls/rudder_trim_center")

--------- Annunciators

return sysControls