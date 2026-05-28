-- MD88 airplane 
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

logMsg("MD88 sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.125, [2] = 0.25, [3] = 0.375, [4] = 0.5, [5] = 0.625, [6] = 0.75, [7] = 0.875, [8] = 1}
sysControls.flaps_spd = {[0] = 999, [1] =   999, [2] =  999, [3] =   999, [4] = 999, [5] =   999, [6] =  999, [7] =   999, [8] = 999}
sysControls.flaps_name= {[0] = "UP", [1] =  "50%", [2] = "100%", [3] =   "35", [4] = "35",   [5] =   "35", [6] =  "35", [7] =   "35", [8] = "35"}

return sysControls