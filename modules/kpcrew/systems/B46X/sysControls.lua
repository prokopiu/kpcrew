-- B46X airplane 
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

logMsg("B46X sysControls")

sysControls.flaps_pos = {[0] =   0,  [1] = 0.25, [2] =  0.50, [3] =  0.75, [4] =  1.00, [5] =  1.00, [6] =    1, [7] =    1, [8] =    1}
sysControls.flaps_spd = {[0] = 220,  [1] =  200, [2] =   170, [3] =   160, [4] =   140, [5] =   140, [6] =  140, [7] =  140, [8] =  140}
sysControls.flaps_name= {[0] = "UP", [1] = "18", [2] =  "24", [3] =  "30", [4] =  "33", [5] =  "33", [6] = "33", [7] = "33", [8] = "33"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",-1)

-- Speedbrake lever
sysControls.Speedbrake	= TwoStateDrefSwitch:new("speedbrake","thranda/actuators/SpeedBrakeHandle",0)
	
return sysControls