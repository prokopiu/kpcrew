-- A350 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2022 Kosta Prokopiu
local sysControls = {
	trimCenter 	= 2,
	trimLeft 	= 1,
	trimRight 	= 0,
	
	flapsUp 	= 0,
	flapsDown 	= 1,
	
	trimUp 		= 0,
	trimDown 	= 1,

	flaps_pos = {[1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1}
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

-- ** Flaps 
sysControls.flapsSwitch 	= TwoStateCustomSwitch:new("flaps","sim/cockpit2/controls/flap_ratio",0,
	function () 
		command_once("sim/flight_controls/flaps_down")
	end,
	function () 
		command_once("sim/flight_controls/flaps_up")
	end,
	function () 
		return
	end
)

MultiStateCmdSwitch:new("flaps","sim/cockpit2/controls/flap_ratio",0,
"sim/flight_controls/flaps_up","sim/flight_controls/flaps_down",0,1,true)

-- ** Pitch Trim
sysControls.pitchTrimSwitch = MultiStateCmdSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	"sim/flight_controls/pitch_trim_up","sim/flight_controls/pitch_trim_down",-1,1,false)

-- ** Aileron Trim
sysControls.aileronTrimSwitch = MultiStateCmdSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_right","sim/flight_controls/aileron_trim_left",-1,1,false)

sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_center")

-- ** Rudder Trim
sysControls.rudderTrimSwitch = MultiStateCmdSwitch:new("ruddertrim","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_right","sim/flight_controls/rudder_trim_left",-1,1,false)

sysControls.rudderReset = TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- YAW Damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"sim/systems/yaw_damper_toggle")

--------- Annunciators

return sysControls