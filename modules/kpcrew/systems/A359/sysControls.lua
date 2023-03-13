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

	flaps_pos = {[0] = 0, [1] = 0.25, [2] = 0.5, [3] = 0.75, [4] = 1}
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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

--------- Switch datarefs common

local drefFlapPosition		= "sim/cockpit2/controls/flap_ratio"
local drefElevatorTrim		= "sim/cockpit2/controls/elevator_trim"
local drefAileronTrim 		= "sim/cockpit2/controls/aileron_trim"
local drefRudderTrim 		= "sim/cockpit2/controls/rudder_trim"
local drefYawDamper			= "sim/cockpit2/switches/yaw_damper_on"

--------- Annunciator datarefs common

local drefHydraulic1Anc		= "1-sim/hyd/systemG"
local drefHydraulic2Anc		= "1-sim/hyd/systemY"

--------- Switch commands common

local cmdFlapsDown			= "sim/flight_controls/flaps_down"
local cmdFlapsUp			= "sim/flight_controls/flaps_up"
local cmdElevTrimDown		= "sim/flight_controls/pitch_trim_down"
local cmdElevTrimUp			= "sim/flight_controls/pitch_trim_up"
local cmdAileronTrimDown	= "sim/flight_controls/aileron_trim_left"
local cmdAileronTrimUp		= "sim/flight_controls/aileron_trim_right"
local cmdAileronTrimRst		= "sim/flight_controls/aileron_trim_center"
local cmdRudderTrimDown		= "sim/flight_controls/rudder_trim_left"
local cmdRudderTrimUp		= "sim/flight_controls/rudder_trim_left"
local cmdRudderTrimRst		= "sim/flight_controls/rudder_trim_center"
local cmdYawDamperTgl		= "sim/systems/yaw_damper_toggle"

--------- Actuator definitions

-- ** Flaps 
sysControls.flapsSwitch 	= TwoStateCustomSwitch:new("flaps",drefFlapPosition,0,
	function () 
		command_once(cmdFlapsDown)
	end,
	function () 
		command_once(cmdFlapsUp)
	end,
	function () 
		return
	end
)

-- ** Pitch Trim
sysControls.pitchTrimSwitch = MultiStateCmdSwitch:new("pitchtrim",drefElevatorTrim,0,
	cmdElevTrimUp,cmdElevTrimDown,-1,1,false)

-- ** Aileron Trim
sysControls.aileronTrimSwitch = MultiStateCmdSwitch:new("ailerontrim",drefAileronTrim,0,
	cmdAileronTrimUp,cmdAileronTrimDown,-1,1,false)

sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset",drefAileronTrim,0,
	cmdAileronTrimRst)

-- ** Rudder Trim
sysControls.rudderTrimSwitch = MultiStateCmdSwitch:new("ruddertrim",drefRudderTrim,0,
	cmdRudderTrimUp,cmdRudderTrimDown,-1,1,false)

sysControls.rudderReset = TwoStateToggleSwitch:new("rudderreset",drefRudderTrim,0,
	cmdRudderTrimRst)

-- YAW Damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper",drefYawDamper,0,
	cmdYawDamperTgl)

--------- Annunciators

return sysControls