-- SF50 airplane 
-- aircraft general systems

-- @classmod sysGeneral
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

sysGeneral = require("kpcrew.systems.DFLT.sysGeneral")

logMsg("SF50 sysGeneral")

sysGeneral.clock			= TwoStateCustomSwitch:new("clock","sim/cockpit2/clock_timer/chrono_running",-1,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_running",0,1)
	end,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_running",0,0)
	end,
	function ()
		set_array("sim/cockpit2/clock_timer/chrono_time",0,0)
	end,
	function ()
		if get("sim/cockpit2/clock_timer/chrono_running",0) == 1 then
			return 1
		else
			return 0
		end
	end)

return sysGeneral