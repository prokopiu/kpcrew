-- Laminar A330 variants airplane 
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

logMsg("A33L sysControls")

sysControls.flaps_pos = {[0] =   0, [1] =  0.25, [2] =  0.5, [3] =  0.75, [4] =      1, [5] =     1, [6] =    1, [7] =     1, [8] = 1}
sysControls.flaps_spd = {[0] = 230, [1] =   215, [2] =  200, [3] =   185, [4] =    177, [5] =   177, [6] =  177, [7] =   177, [8] = 177}
sysControls.flaps_name= {[0] = "0", [1] =   "1", [2] =  "2", [3] =   "3", [4] = "FULL", [5] ="FULL", [6] =  "FULL", [7] =   "FULL", [8] = "FULL"}

-- Autobrake
sysControls.Autobrake	= CustomAnnunciator:new("autobrake",
function () 
	if get("laminar/A333/annun/auto_brake/lo_on") > 0 then 
		return 1
	elseif get("laminar/A333/annun/auto_brake/med_on") > 0 then 
		return 2
	elseif get("laminar/A333/annun/auto_brake/max_on") > 0 then
		return 3
	else
		return 0
	end
end)

return sysControls