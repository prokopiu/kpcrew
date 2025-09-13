-- B748 airplane 
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

logMsg("B748 sysControls")

sysControls.flaps_pos = {[0] =   0,  [1] = 0.16, [2] =  0.33, [3] =    0.5, [4] =  0.66, [5] =  0.83, [6] =    1, [7] =    1, [8] =    1}
sysControls.flaps_spd = {[0] = 285,  [1] =  285, [2] =   265, [3] =    245, [4] =   235, [5] =   210, [6] =  185, [7] =  185, [8] =  185}
sysControls.flaps_name= {[0] = "UP", [1] =  "1", [2] =   "5", [3] =   "10", [4] =  "20", [5] =  "25", [6] = "30", [7] = "30", [8] = "30"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",0)

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake","SSG/B748/speed_brk_hand",0)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","ssg/GEAR/autobrake_sel",0)

return sysControls