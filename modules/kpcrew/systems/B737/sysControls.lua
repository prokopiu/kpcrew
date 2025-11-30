-- B737 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

-- System Elements
-- sysControls.flapsSwitch
-- sysControls.pitchTrimSwitch
-- sysControls.pitchTrimDownRepeat
-- sysControls.pitchTrimUpRepeat
-- sysControls.aileronTrimSwitch
-- sysControls.aileronReset
-- sysControls.rudderTrimSwitch
-- sysControls.rudderReset
-- sysControls.Speedbrake
-- sysControls.rudderDeflection
-- sysControls.yawDamper
-- Macro: kc_macro_set_flap
-- Macro: kc_macro_arm_speedbrake

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

sysControls = require("kpcrew.systems.DFLT.sysControls")

logMsg("B737 sysControls")

sysControls.flaps_pos = {[0] = 0, 	[1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1.0}
sysControls.flaps_spd = {[0] = 230, [1] = 230,   [2] =  230, [3] =   230, [4] = 210, [5] =   190, [6] =  170, [7] =   150, [8] = 150}
sysControls.flaps_name= {[0] = "UP",[1] =   "1", [2] =  "2", [3] =   "5", [4] ="10", [5] =  "15", [6] = "25", [7] =  "30", [8] = "40"}

--------- Switch datarefs common
local drefFlapRatio			= "sim/cockpit2/controls/flap_ratio"
local drefPitchTrim			= "sim/cockpit2/controls/elevator_trim"
local drefAileronTrim		= "sim/cockpit2/controls/aileron_trim"
local drefRudderTrim		= "sim/cockpit2/controls/rudder_trim"
local drefSpdBrakeRatio		= "laminar/B738/flt_ctrls/speedbrake_lever"
local drefAutoBrakePos		= "sim/cockpit2/switches/auto_brake_level"

--------- Annunciator datarefs common
local drefRudderPos			= "sim/flightmodel2/wing/rudder1_deg"

--------- Switch commands common
local cmdFlapDown			= "sim/flight_controls/flaps_down"
local cmdFlapUp				= "sim/flight_controls/flaps_up"
local cmdPitchTrimDown		= "sim/flight_controls/pitch_trim_down"
local cmdPitchTrimUp		= "sim/flight_controls/pitch_trim_up"
local cmdAileronTrimRight	= "sim/flight_controls/aileron_trim_right"
local cmdAileronTrimLeft	= "sim/flight_controls/aileron_trim_left"
local cmdAileronTrimReset	= "sim/flight_controls/aileron_trim_center"
local cmdRudderTrimRight	= "sim/flight_controls/rudder_trim_right"
local cmdRudderTrimLeft		= "sim/flight_controls/rudder_trim_left"
local cmdRudderTrimReset	= "sim/flight_controls/rudder_trim_center"

--------- Switches

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake",drefSpdBrakeRatio,0)
	
return sysControls