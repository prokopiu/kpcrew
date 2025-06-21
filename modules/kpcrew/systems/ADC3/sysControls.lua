-- ADC3 airplane 
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

logMsg("ADC3 sysControls")

sysControls.flaps_pos = {[0] =   0, [1] =  0.25, [2] =     0.5, [3] = 0.75, [4] = 1,      [5] = 1, [6] = 1,       [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 109, [1] =   109, [2] =    99, [3] =   96,   [4] = 96,     [5] =   96, [6] =  96,    [7] =   96, [8] = 96}
sysControls.flaps_name= {[0] = "UP",[1] = "25%", [2] = "50%", [3] = "75%",  [4] = "FULL", [5] =   "FULL", [6] =  "FULL", [7] =   "FULL", [8] = "35"}

return sysControls