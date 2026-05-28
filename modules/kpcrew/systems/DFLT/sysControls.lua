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
-- sysControls.rudderDeflection
-- sysControls.Speedbrake


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

local def = require("kpcrew.systems." .. kc_acf_icao ..".sysControlsDefinitions")

-- ** Flaps 
if kc_has_flaps then
	sysControls.flapsSwitch 	= kc_setup_element(def.flapsSwitch)
else
	sysControls.flapsSwitch		= kc_setup_element({etype=kc_swtype_inop, name="Flaps Lever/Switch"})
end

-- ** Pitch Trim
-- **Trim repeating commands for hardware when dataref is not usable
if kc_has_pitch_trim then
	sysControls.pitchTrimSwitch 	= kc_setup_element(def.pitchTrimSwitch)
	sysControls.pitchTrimDownRepeat = kc_setup_element(def.pitchTrimDownRepeat)
	sysControls.pitchTrimUpRepeat 	= kc_setup_element(def.pitchTrimUpRepeat)
else
	sysControls.pitchTrimSwitch		= kc_setup_element({etype=kc_swtype_inop, name="Pitch/Elevator Trim"})
	sysControls.pitchTrimDownRepeat	= kc_setup_element({etype=kc_swtype_inop, name="Pitch trim down repeat"})
	sysControls.pitchTrimUpRepeat	= kc_setup_element({etype=kc_swtype_inop, name="Pitch trim up repeat"})
end

-- ** Aileron Trim
-- ** Aileron Trim Reset
if kc_has_aileron_trim then
	sysControls.aileronTrimSwitch 	= kc_setup_element(def.aileronTrimSwitch)
	sysControls.aileronReset 		= kc_setup_element(def.aileronReset)
else
	sysControls.aileronTrimSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Aileron trim"})
	sysControls.aileronReset 		= kc_setup_element({etype=kc_swtype_inop, name="Aileron reset"})
end

-- ** Rudder Trim
-- ** Rudder Trim Reset
-- ** Rudder deflection used for flight controls check
if kc_has_rudder_trim then
	sysControls.rudderTrimSwitch 	= kc_setup_element(def.rudderTrimSwitch)
	sysControls.rudderReset			= kc_setup_element(def.rudderReset)
	sysControls.rudderDeflection	= kc_setup_element(def.rudderDeflection)
else
	sysControls.rudderTrimSwitch 	= kc_setup_element({etype=kc_swtype_inop, name="Rudder trim"})
	sysControls.rudderReset			= kc_setup_element({etype=kc_swtype_inop, name="Rudder reset"})
	sysControls.rudderDeflection	= kc_setup_element({etype=kc_swtype_inop, name="Rudder deflection"})
end

-- Speedbrake lever
if kc_has_speedbrake then
	sysControls.Speedbrake			= kc_setup_element(def.Speedbrake)
else
	sysControls.Speedbrake		 	= kc_setup_element({etype=kc_swtype_inop, name="Speedbrake"})
end

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