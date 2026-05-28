-- B744 MSPARKS airplane 
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

logMsg("B744 sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.167, [2] = 0.333, [3] =    0.5, [4] = 0.677, [5] = 0.833, [6] =    1, [7] =    1, [8] =    1}
sysControls.flaps_spd = {[0] = 280, [1] =   280, [2] =   260, [3] =    240, [4] =   230, [5] =   205, [6] =  180, [7] =  180, [8] =  180}
sysControls.flaps_name= {[0] = "UP", [1] =  "1", [2] =   "5", [3] =   "10", [4] =  "20", [5] =  "25", [6] = "30", [7] = "30", [8] = "30"}

sysControls.rudderDeflection	= SimpleAnnunciator:new("rudderdeflection","sim/flightmodel2/wing/rudder1_deg",11)

-- Autobrake
sysControls.Autobrake	= TwoStateDrefSwitch:new("autobrake","sim/cockpit2/switches/auto_brake_level",0)

-- laminar/B747/gear/autobrakes/sel_dial_dn
return sysControls


