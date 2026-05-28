-- C510 airplane 
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

logMsg("C510 sysControls")

sysControls.flaps_pos = {[0] = 0, 	[1] = 0.5, 		 [2] = 1.0, 	[3] = 1.0, 		[4] = 1.0, 		[5] = 1.0, 		[6] = 1.0, 		[7] = 1.0, 		[8] = 1.0}
sysControls.flaps_spd = {[0] = 195, [1] = 185, 		 [2] = 150, 	[3] = 150,  	[4] = 150, 		[5] = 150, 		[6] = 150, 		[7] = 150, 		[8] = 150}
sysControls.flaps_name= {[0] = "UP", [1] = "TO/APR", [2] = "LAND", 	[3] = "LAND", 	[4] = "LAND",	[5] = "LAND", 	[6] = "LAND", 	[7] = "LAND",	[8] = "LAND"}

return sysControls