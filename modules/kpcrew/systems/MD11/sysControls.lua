-- MD11 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu
local sysControls = {
	trimCenter 	= 2,
	trimLeft 	= 1,
	trimRight 	= 0,
	flapsUp 	= 0,
	flapsDown 	= 1,
	trimUp 		= 0,
	trimDown 	= 1
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

--------- Switches

-- Flaps 
sysControls.flapsSwitch 	= MultiStateCmdSwitch:new("flaps","Rotate/aircraft/controls/flap_handle",0,
	"Rotate/aircraft/controls_c/flap_handle_dn","Rotate/aircraft/controls_c/flap_handle_up")

-- Pitch Trim
sysControls.pitchTrimSwitch	= MultiStateCmdSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	"sim/flight_controls/pitch_trim_up","sim/flight_controls/pitch_trim_down")

-- Aileron Trim
sysControls.aileronTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_right","sim/flight_controls/aileron_trim_left")
sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_center")

-- Rudder Trim
sysControls.rudderTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_right","sim/flight_controls/rudder_trim_left")
sysControls.rudderReset 	= TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- Yaw Damper
sysControls.yawDamper 		= TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"sim/systems/yaw_damper_toggle")

sysControls.speedBrake 		= TwoStateDrefSwitch:new("spoiler","Rotate/aircraft/controls/speed_brake",0)

--------- Annunciators

return sysControls