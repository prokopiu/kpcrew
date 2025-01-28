-- E1FF X-Crafts Freeware airplane 
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

logMsg("E1FF sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.16666667, [2] = 0.33333334, [3] = 0.5, [4] = 0.6666666, [5] = 0.8333333, [6] = 0.1, [7] = 0.1, [8] = 1}
sysControls.flaps_spd = {[0] = 230, [1] =   200, [2] =  180, [3] =   160, [4] = 155, [5] =   155, [6] =  150, [7] =   150, [8] = 150}
sysControls.flaps_name= {[0] = "UP", [1] =   "1", [2] =  "2", [3] =   "3", [4] = "4", [5] =   "5", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}


return sysControls