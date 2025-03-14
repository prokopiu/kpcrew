-- EVIC airplane 
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

logMsg("EVIC sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.5, [2] = 1, [3] = 1,   [4] = 1, [5] = 1, [6] = 1,       [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 180, [1] =   180, [2] =  130, [3] =   130,  [4] = 130,   [5] =   130, [6] =  130,    [7] =   130, [8] = 130}
sysControls.flaps_name= {[0] = "UP", [1] =  "T/O", [2] = "FULL", [3] =   "35", [4] = "35",   [5] =   "35", [6] =  "35", [7] =   "35", [8] = "35"}

return sysControls