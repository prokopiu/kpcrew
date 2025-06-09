-- E1XX airplane 
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

logMsg("E1XX sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.166, [2] = 0.333, [3] = 0.5,   [4] = 0.666, [5] = 0.833, [6] = 1,       [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 230, [1] =   215, [2] =  200, [3] =   190,  [4] = 180,   [5] =   165, [6] =  165,    [7] =   165, [8] = 165}
sysControls.flaps_name= {[0] = "UP", [1] =   "1", [2] =  "2", [3] =   "3", [4] = "4",   [5] =   "5", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}

return sysControls