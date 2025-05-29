-- SF34 airplane 
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

logMsg("SF34 sysControls")

sysControls.flaps_pos = {[0] =   0, [1] =   0.2, [2] = 0.428571, [3] = 0.571429, [4] = 1,    [5] = 1,    [6] = 1,    [7] = 1,    [8] = 1}
sysControls.flaps_spd = {[0] = 175, [1] =   175, [2] =      175, [3] =      165, [4] = 140,  [5] = 140,  [6] = 140,  [7] = 140,  [8] = 140}
sysControls.flaps_name= {[0] = "0", [1] =   "7", [2] =     "15", [3] =     "20", [4] = "35", [5] = "35", [6] = "35", [7] = "35", [8] = "35"}

sysControls.flapsSwitch 	= TwoStateDrefSwitch:new("flaps","les/sf34a/acft/fltc/mnp/flap_handle",0)
	-- function () 
		-- command_once("sim/flight_controls/flaps_down")
	-- end,
	-- function () 
		-- command_once("sim/flight_controls/flaps_up")
	-- end,
	-- function ()
	-- end,
	-- function () 
		-- return get("les/sf34a/acft/fltc/mnp/flap_handle")
	-- end
-- )

return sysControls