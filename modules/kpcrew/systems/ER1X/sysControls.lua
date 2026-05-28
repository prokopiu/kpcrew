-- ER1X airplane 
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

logMsg("ER1X sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.25, [2] = 0.5, [3] = 0.75,   [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 250, [1] =   250, [2] =  200, [3] =   200,  [4] = 145,   [5] =   145, [6] =  145,    [7] =   145, [8] = 145}
sysControls.flaps_name= {[0] = "0", [1] =   "9", [2] =  "18", [3] =   "22", [4] = "45",   [5] =   "5", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}

return sysControls