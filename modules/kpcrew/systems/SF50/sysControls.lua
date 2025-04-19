-- SF50 airplane 
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

logMsg("SF50 sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.5, [2] = 1, [3] = 1,   [4] = 1, [5] = 1, [6] = 1,       [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 190, [1] =   190, [2] =  150, [3] =   150,  [4] = 150,   [5] =   150, [6] =  150,    [7] =   150, [8] = 150}
sysControls.flaps_name= {[0] = "UP", [1] =  "50%", [2] = "100%", [3] =   "35", [4] = "35",   [5] =   "35", [6] =  "35", [7] =   "35", [8] = "35"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/cockpit2/controls/total_heading_ratio",0)

return sysControls