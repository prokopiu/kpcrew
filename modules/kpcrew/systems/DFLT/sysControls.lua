-- DFLT airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

local sysControls = {
	autobrk_off = 1,
	
	trimCenter 	= 2,
	trimLeft 	= 1,
	trimRight 	= 0,
	
	flapsUp 	= 0,
	flapsDown 	= 1,
	
	trimUp 		= 0,
	trimDown 	= 1,

	flaps_pos = {[0] =   0, [1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1},
	flaps_spd = {[0] = 230, [1] =   200, [2] =  180, [3] =   160, [4] = 155, [5] =   155, [6] =  150, [7] =   150, [8] = 150},
	flaps_name= {[0] = "UP", [1] =   "1", [2] =  "2", [3] =   "3", [4] = "4", [5] =   "5", [6] =  "6", [7] =   "7", [8] = "FULL"}
}

logMsg("DFLT sysControls")

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
	end,nil,
	function () 
		return get("sim/cockpit2/controls/flap_ratio")
	end
)

-- ** Pitch Trim
sysControls.pitchTrimSwitch = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_once("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_once("sim/flight_controls/pitch_trim_up")
	end,nil,
	function () 
		return get("sim/cockpit2/controls/elevator_trim")
	end
)
sysControls.pitchTrimDownRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_down")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_down")
	end,nil,
	function () 
		return get("sim/cockpit2/controls/elevator_trim")
	end
)

sysControls.pitchTrimUpRepeat = TwoStateCustomSwitch:new("pitchtrim","sim/cockpit2/controls/elevator_trim",0,
	function () 
		command_begin("sim/flight_controls/pitch_trim_up")
	end,
	function () 
		command_end("sim/flight_controls/pitch_trim_up")
	end,nil,
	function () 
		return get("sim/cockpit2/controls/elevator_trim")
	end
)

-- ** Aileron Trim
sysControls.aileronTrimSwitch = TwoStateCustomSwitch:new("ailerontrim","sim/cockpit2/controls/aileron_trim",0,
	function () 
		command_once("sim/flight_controls/aileron_trim_right")
	end,
	function () 
		command_once("sim/flight_controls/aileron_trim_left")
	end,nil,
	function () 
		return get("sim/cockpit2/controls/aileron_trim")
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
	end,nil,
	function () 
		return get("sim/cockpit2/controls/rudder_trim")
	end
)

sysControls.rudderReset	= TwoStateToggleSwitch:new("rudderreset","sim/cockpit2/controls/rudder_trim",0,
	"sim/flight_controls/rudder_trim_center")

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake","sim/cockpit2/controls/speedbrake_ratio",0)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","sim/cockpit2/switches/auto_brake_level",0)

--------- Annunciators

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",0)

return sysControls