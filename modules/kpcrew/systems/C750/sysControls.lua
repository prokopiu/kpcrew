-- C750 airplane 
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

	flaps_pos = {[0] = 0, 	[1] = 0.25, [2] = 0.5, [3] = 0.75, [4] = 1},
	flaps_spd = {[0] = 300, [1] = 250, 	[2] = 250, [3] = 210,  [4] = 185}
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

-- ** Pitch Trim
sysControls.pitchTrimSwitch = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_once("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_once("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		return
	end
)
sysControls.pitchTrimDownRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		return
	end
)
sysControls.pitchTrimUpRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		return
	end
)

-- ** Aileron Trim
sysControls.aileronTrimSwitch = TwoStateCustomSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	function () 
		command_once("sim/flight_controls/aileron_trim_right")
	end,
	function () 
		command_once("sim/flight_controls/aileron_trim_left")
	end,
	function () 
		return
	end
)

sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset","sim/cockpit2/controls/aileron_trim",0,
	"sim/flight_controls/aileron_trim_center")

-- ** Rudder Trim
sysControls.rudderTrimSwitch = TwoStateCustomSwitch:new("ruddertrim","sim/cockpit2/controls/rudder_trim",0,
	function () 
		command_once("sim/flight_controls/rudder_trim_right")
	end,
	function () 
		command_once("sim/flight_controls/rudder_trim_left")
	end,
	function () 
		return
	end
)

sysControls.rudderReset = TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- YAW Damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"laminar/CitX/autopilot/cmd_yd_toggle")

--------- Annunciators

return sysControls