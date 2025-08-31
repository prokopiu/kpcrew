-- B7x7 airplane 
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

logMsg("B7x7 sysControls")

sysControls.flaps_pos = {[0] =   0,  [1] = 0.166667, [2] =  0.333333, [3] =    0.5, [4] =  0.66667, [5] =  0.833333, [6] =    1, [7] =    1, [8] =    1}
sysControls.flaps_spd = {[0] = 240,  [1] =      240, [2] =       220, [3] =    210, [4] =      200, [5] =       190, [6] =  180, [7] =  180, [8] =  180}
sysControls.flaps_name= {[0] = "UP", [1] =      "1", [2] =       "5", [3] =   "15", [4] =     "20", [5] =      "25", [6] = "30", [7] = "30", [8] = "30"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",1)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","anim/rhotery/25",0)

-- YAW Damper
sysControls.yawDamper	= SwitchGroup:new("yawDampers")
sysControls.yawDamper1	= TwoStateDrefSwitch:new("yawdamper1","anim/1/button",0)
sysControls.yawDamper2	= TwoStateDrefSwitch:new("yawdamper2","anim/2/button",0)
sysControls.yawDamper:addSwitch(sysControls.yawDamper1)
sysControls.yawDamper:addSwitch(sysControls.yawDamper2)

return sysControls
