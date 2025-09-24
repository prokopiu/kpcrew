-- A306 airplane 
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

logMsg("A306 sysControls")

sysControls.flaps_pos = {[0] =   0,  [1] =   0.16, [2] =    0.33, [3] =     0.5, [4] =    0.66, [5] =    0.83, [6] =       1, [7] =       1, [8] =    1}
sysControls.flaps_spd = {[0] = 275,  [1] =    275, [2] =     250, [3] =     238, [4] =     231, [5] =     205, [6] =     180, [7] =     180, [8] =  180}
sysControls.flaps_name= {[0] = "0",  [1] = "15/0", [2] = "15/15", [3] = "15/20", [4] = "30/40", [5] = "30/40", [6] = "30/40", [7] = "30/40", [8] = "30/40"}

-- YAW Damper
sysControls.yawDamper	= SwitchGroup:new("yawdampers")
sysControls.yawDamper1	= TwoStateDrefSwitch:new("yawdamper1","A300/fctl/yaw_damper1",0)
sysControls.yawDamper2  = TwoStateDrefSwitch:new("yawdamper2","A300/fctl/yaw_damper2",0)
sysControls.yawDamper:addSwitch(sysControls.yawDamper1)
sysControls.yawDamper:addSwitch(sysControls.yawDamper2)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","A300/brakes/autobrake_pos",0)

return sysControls