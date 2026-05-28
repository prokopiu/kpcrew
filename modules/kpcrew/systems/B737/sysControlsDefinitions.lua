-- B737 airplane 
-- Airctaft controls functionality

-- @classmod sysControlsDefinitions
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

--[[
Systems covered:
Flaps: 			
Pitch Trim:
Rudder Trim:
Aileron Trim:
Speedbrake:
]]

--[[
	template = {
		etype = type_...,
		name = "name",
		drefName = "name of dref",
		drefIndex = 0,
		cmd1 = "on, tgl or dn",
		cmd2 = "off or up",
		cmd3 = "tgl",
		msMin = minimum,
		msMax = maximum,
		msRead = true/false,
		msDiff = difference,
		funcOn = function...,
		funcOff = function ...,
		funcTgl = function ...,
		funcStat = function ...,
		funcStep = function...,
		funcSet = function
	}
]]

kc_has_flaps		= true		-- Aircraft has flaps
kc_Numflap_detents	= -1 		-- Number of flap detents from acf
kc_has_speedbrake	= true		-- Aircraft has an air brake to extend
kc_spdbrk_can_arm	= true		-- Aircraft's speedbrake can be armed
kc_spdbrk_arm_pos	= 0.0889
kc_spdbrk_arm_to	= false		-- Speedbrake to be armed for takeoff (e.g. Airbus)
kc_has_pitch_trim	= true		-- Aircraft has pitch or elevator trim
kc_has_aileron_trim	= true		-- Aircraft has aileron trim
kc_has_rudder_trim	= true		-- Aircraft has rudder trim
kc_rudder_index		= 0			-- Index of rudder value for readout
kc_full_rgt_rudder	= 14.9		-- Threshold where the rudder is almost fully to the right
kc_announce_flaps	= true 		-- option to announce current flaps

-- === For Briefing
kc_NumFlapsTO		= 5
kc_TakeoffFlaps 	= "UP|1|5|10|15| | "
kc_TakeoffFlapsInd 	= "0|1|3|4|5|2|2"
kc_NumFlapsLDG		= 3
kc_LandingFlaps 	= "25|30|40| | | | "
kc_LandingFlapsInd 	= "6|7|8|8|8|8|8"
kc_gear_ext_index	= 3			-- When to extend gear in flaps extend

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

sysControlsDefinitions = {
	flapsSwitch = {
		etype = kc_swtype_customCmd,
		name = "Flaps Lever/Switch",
		drefName = "sim/cockpit2/controls/flap_ratio",
		drefIndex = 0,
		funcOn = function () command_once("sim/flight_controls/flaps_down") end,
		funcOff = function () command_once("sim/flight_controls/flaps_up") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/flap_ratio") end
	},
	pitchTrimSwitch = {
		etype = kc_swtype_customCmd,
		name = "Pitch/Elevator Trim",
		drefName = "sim/cockpit2/controls/elevator_trim",
		drefIndex = 0,
		funcOn = function () command_once("sim/flight_controls/pitch_trim_down") end,
		funcOff = function () command_once("sim/flight_controls/pitch_trim_up") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/elevator_trim") end
	},
	pitchTrimDownRepeat = {
		etype = kc_swtype_customCmd,
		name = "Pitch trim down repeat",
		drefName = "sim/cockpit2/controls/elevator_trim",
		drefIndex = 0,
		funcOn = function () command_begin("sim/flight_controls/pitch_trim_down") end,
		funcOff = function () command_end("sim/flight_controls/pitch_trim_down") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/elevator_trim") end
	},
	pitchTrimUpRepeat = {
		etype = kc_swtype_customCmd,
		name = "Pitch trim up repeat",
		drefName = "sim/cockpit2/controls/elevator_trim",
		drefIndex = 0,
		funcOn = function () command_begin("sim/flight_controls/pitch_trim_up") end,
		funcOff = function () command_end("sim/flight_controls/pitch_trim_up") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/elevator_trim") end
	},
	aileronTrimSwitch = {
		etype = kc_swtype_customCmd,
		name = "Aileron trim",
		drefName = "sim/cockpit2/controls/aileron_trim",
		drefIndex = 0,
		funcOn = function () command_once("sim/flight_controls/aileron_trim_right") end,
		funcOff = function () command_once("sim/flight_controls/aileron_trim_left") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/aileron_trim") end
	},
	aileronReset = {
		etype = kc_swtype_toggleCmd,
		name = "Aileron reset",
		drefName = "sim/cockpit2/controls/aileron_trim",
		drefIndex = 0,
		cmd1 = "sim/flight_controls/aileron_trim_center"
	},
	rudderTrimSwitch = {
		etype = kc_swtype_customCmd,
		name = "Rudder trim",
		drefName = "sim/cockpit2/controls/rudder_trim",
		drefIndex = 0,
		funcOn = function () command_once("sim/flight_controls/rudder_trim_right") end,
		funcOff = function () command_once("sim/flight_controls/rudder_trim_left") end,
		funcTgl = nil,
		funcStat = function () return get("sim/cockpit2/controls/rudder_trim") end
	},
	rudderReset = {
		etype = kc_swtype_toggleCmd,
		name = "Rudder reset",
		drefName = "sim/cockpit2/controls/rudder_trim",
		drefIndex = 0,
		cmd1 = "sim/flight_controls/rudder_trim_center"
	},
	rudderDeflection = {
		etype = kc_swtype_annunciator,
		name = "Rudder deflection",
		drefName = "sim/flightmodel2/wing/rudder1_deg",
		drefIndex = kc_rudder_index
	},
	Speedbrake = {
		etype = kc_swtype_dref,
		name = "Speedbrake lever",
		drefName = "laminar/B738/flt_ctrls/speedbrake_lever",
		drefIndex = 0
	}
}

return sysControlsDefinitions