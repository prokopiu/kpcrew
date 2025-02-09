-- E55P airplane 
-- Flight Controls functionality

-- @classmod sysControls
-- @author Kosta Prokopiu
-- @copyright 2024 Kosta Prokopiu

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

logMsg("E55P sysControls")

sysControls.flaps_pos = {[0] =   0, [1] = 0.25, [2] = 0.5, [3] = 0.75,     [4] = 1,          [5] = 1, [6] = 1,       [7] = 1, [8] = 1}
sysControls.flaps_spd = {[0] = 205, [1] =   180, [2] =  170, [3] =   170,  [4] = 160,        [5] =   165, [6] =  165,    [7] =   165, [8] = 165}
sysControls.flaps_name= {[0] = "0", [1] =   "1", [2] =  "2", [3] =   "3",  [4] = "FULL",     [5] =   "FULL", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}


-- ** Flaps 
sysControls.flapsSwitch 	= TwoStateCustomSwitch:new("flaps","aerobask/anim/sw_flap",0,
	function () 
		command_once("sim/flight_controls/flaps_down")
	end,
	function () 
		command_once("sim/flight_controls/flaps_up")
	end,
	function () 
		return get("aerobask/anim/sw_flap")
	end
)


return sysControls