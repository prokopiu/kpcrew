-- B742 airplane 
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

logMsg("B742 sysControls")

sysControls.flaps_pos = {[0] =   0,  [1] = 0.16, [2] =  0.33, [3] =    0.5, [4] =  0.66, [5] =  0.83, [6] =    1, [7] =    1, [8] =    1}
sysControls.flaps_spd = {[0] = 275,  [1] =  275, [2] =   250, [3] =    238, [4] =   231, [5] =   205, [6] =  180, [7] =  180, [8] =  180}
sysControls.flaps_name= {[0] = "UP", [1] =  "1", [2] =   "5", [3] =   "10", [4] =  "20", [5] =  "25", [6] = "30", [7] = "30", [8] = "30"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",11)

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake","B742/controls/spd_brake_lever",0)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","B742/OVHD/auto_brake_sel",0)

return sysControls