-- DFLT airplane 
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
-- sysControls.Autobrake
-- sysControls.rudderDeflection
-- sysControls.yawDamper
-- Macro: kc_macro_set_flap
-- Macro: kc_macro_arm_speedbrake

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
local KeepPressedSwitchCmd	= require "kpcrew.systems.KeepPressedSwitchCmd"

--------- Switch datarefs common
local drefFlapRatio			= "sim/cockpit2/controls/flap_ratio"
local drefPitchTrim			= "sim/cockpit2/controls/elevator_trim"
local drefAileronTrim		= "sim/cockpit2/controls/aileron_trim"
local drefRudderTrim		= "sim/cockpit2/controls/rudder_trim"
local drefSpdBrakeRatio		= "sim/cockpit2/controls/speedbrake_ratio"
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

-- ** Flaps 
sysControls.flapsSwitch 	= TwoStateCustomSwitch:new("flaps",drefFlapRatio,0,
	function () command_once(cmdFlapDown) end,
	function () command_once(cmdFlapUp) end,nil,
	function () return get(drefFlapRatio) end
)

-- ** Pitch Trim
sysControls.pitchTrimSwitch = TwoStateCustomSwitch:new("pitchtrim",drefPitchTrim,0,
	function () command_once(cmdPitchTrimDown)	end,
	function () command_once(cmdPitchTrimUp) end,nil,
	function () return get(drefPitchTrim) end
)

-- repeating for hardware when dataref is not usable
sysControls.pitchTrimDownRepeat = TwoStateCustomSwitch:new("pitchtrim",drefPitchTrim,0,
	function () command_begin(cmdPitchTrimDown) end,
	function () command_end(cmdPitchTrimDown) end,nil,
	function () return get(drefPitchTrim) end
)
sysControls.pitchTrimUpRepeat = TwoStateCustomSwitch:new("pitchtrim",drefPitchTrim,0,
	function () command_begin(cmdPitchTrimUp) end,
	function () command_end(cmdPitchTrimUp) end,nil,
	function () return get(drefPitchTrim) end
)

-- ** Aileron Trim
sysControls.aileronTrimSwitch = TwoStateCustomSwitch:new("ailerontrim",drefAileronTrim,0,
	function () command_once(cmdAileronTrimRight) end,
	function () command_once(cmdAileronTrimLeft) end,nil,
	function () return get(drefAileronTrim) end
)
-- ** Aileron Trim Reset
sysControls.aileronReset 	= TwoStateToggleSwitch:new("aileronreset",drefAileronTrim,0,
	cmdAileronTrimReset)

-- ** Rudder Trim
sysControls.rudderTrimSwitch = TwoStateCustomSwitch:new("ruddertrim",drefRudderTrim,0,
	function () command_once(cmdRudderTrimRight) end,
	function () command_once(cmdRudderTrimLeft) end,nil,
	function () return get(drefRudderTrim) end
)

-- ** Rudder Trim Reset
sysControls.rudderReset	= TwoStateToggleSwitch:new("rudderreset",drefRudderTrim,0,
	cmdRudderTrimReset)

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake",drefSpdBrakeRatio,0)

--------- Annunciators

-- rudder deflection used for flight controls check
sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection",drefRudderPos,0)

--------- Macros

-- Macro: set flaps based on index
function kc_macro_set_flap(flapindex)

	for i = 1, kc_get_nr_flapdetents() do
		command_once("sim/flight_controls/flaps_up")
	end 
	
	for i = 1, flapindex do
		command_once("sim/flight_controls/flaps_down")
	end

end

-- Macro: Arm Speedbrake
function kc_macro_arm_speedbrake()
	sysControls.Speedbrake:setValue(kc_spdbrk_arm_pos)
end

return sysControls