-- C750 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

sysControls = require("kpcrew.systems.DFLT.sysControls")

sysControls.flaps_pos = {[0] = 0, 	[1] = 0.25, [2] = 0.5, [3] = 0.75, [4] = 1}
sysControls.flaps_spd = {[0] = 300, [1] = 250, 	[2] = 250, [3] = 210,  [4] = 185}

-- YAW Damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"laminar/CitX/autopilot/cmd_yd_toggle")

--------- Annunciators

return sysControls