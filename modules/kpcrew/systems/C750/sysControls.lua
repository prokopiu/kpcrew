-- C750 airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2025 Kosta Prokopiu

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

sysControls.flaps_pos = {[0] = 0, 	[1] = 0.25, [2] = 0.5, [3] = 0.75, [4] = 1.0, [5] = 1.0, [6] = 1.0, [7] = 1.0, [8] = 1.0}
sysControls.flaps_spd = {[0] = 250, [1] = 240, 	[2] = 240, [3] = 200,  [4] = 170, [5] = 170, [6] = 170, [7] = 170, [8] = 170}
sysControls.flaps_name= {[0] = "UP", [1] = "SLAT", [2] = "5", [3] = "15",  [4] = "FULL",     [5] =   "FULL", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}

logMsg("C750 sysControls")

-- YAW Damper
sysControls.yawDamper = TwoStateToggleSwitch:new("yawdamper","sim/cockpit2/switches/yaw_damper_on",0,
	"laminar/CitX/autopilot/cmd_yd_toggle")

return sysControls